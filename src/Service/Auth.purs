module Service.Auth
  ( cleanTokens
  , getAccessToken
  , loginAndGetAccessToken
  , refreshAndGetAccessToken
  ) where

import Prelude

import Data.Array as Array
import Data.DateTime.Instant as Instant
import Data.Either (Either(..), hush)
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.String (Pattern(..))
import Data.String as String
import Data.String.Base64 as Base64
import Data.Time.Duration (Minutes(..), Seconds, fromDuration)
import Effect (Effect)
import Effect.Aff (Aff, attempt)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Now (now)
import Service.AuthClient (Credentials, TokenPair)
import Service.AuthClient as AuthClient
import Types (JwtAccessToken(..), JwtRefreshToken(..))
import Web.HTML (window)
import Web.HTML.Window (localStorage)
import Web.Storage.Storage (getItem, removeItem, setItem)
import Yoga.JSON (readJSON_)

type Props =
  { apiUrl ∷ String
  }

-- | Get the access token from local storage if it's valid, otherwise refresh and return a new one.
getAccessToken ∷ Props -> Aff (Maybe JwtAccessToken)
getAccessToken config = do
  accessToken <- liftEffect $ window >>= localStorage >>= getItem "jwt.access"
  case JwtAccessToken <$> accessToken of
    Just token -> ifM (liftEffect $ isGoodToken token)
      (pure $ Just token)
      (refreshAndGetAccessToken config)
    Nothing -> pure Nothing

-- | Refresh the access token using the refresh token from local storage.
refreshAndGetAccessToken ∷ Props -> Aff (Maybe JwtAccessToken)
refreshAndGetAccessToken config = do
  refreshToken <- liftEffect $ window >>= localStorage >>= getItem "jwt.refresh"
  case refreshToken of
    Nothing -> pure Nothing
    Just token -> do
      result <- attempt $ AuthClient.refresh config (JwtRefreshToken token)
      liftEffect $ case result of
        Right tokens -> do
          persistTokens tokens
          pure $ Just tokens.accessToken
        Left err -> do
          log $ show err
          pure Nothing

-- | Login and get the token, save to local storage (if valid), and return an access token
loginAndGetAccessToken ∷ Props -> Credentials -> Aff (Maybe JwtAccessToken)
loginAndGetAccessToken config credentials = do
  loginResponse <- AuthClient.login config credentials
  isValid <- liftEffect $ maybe (pure false) (isGoodToken <<< _.accessToken) loginResponse
  case loginResponse of
    Just tokens | isValid -> do
      liftEffect (persistTokens tokens)
      pure (Just tokens.accessToken)
    _ -> pure Nothing

persistTokens :: TokenPair -> Effect Unit
persistTokens
  { accessToken: JwtAccessToken access
  , refreshToken: JwtRefreshToken refresh
  } = do
  s <- window >>= localStorage
  setItem "jwt.access" access s
  setItem "jwt.refresh" refresh s

cleanTokens :: Effect Unit
cleanTokens = do
  s <- window >>= localStorage
  removeItem "jwt.access" s
  removeItem "jwt.refresh" s

type Payload =
  { exp :: Seconds
  , user :: { role :: String }
  }

-- | Check if the token isn't about expired (~1 minute) and has one of the expected roles
isGoodToken :: JwtAccessToken -> Effect Boolean
isGoodToken (JwtAccessToken token) =
  -- TODO: this doesn't verify the signature, nor checks the header, it only takes the payload data
  case payload token >>= decodeBase64 >>= readJSON_ of
    Just ({ exp, user: { role } } :: Payload) -> do
      rightNow <- now
      let
        expiresAt = fromMaybe rightNow $ Instant.instant $ fromDuration exp
        tillExpiry = Instant.diff expiresAt rightNow
      pure $ tillExpiry > Minutes 1.0 && role == "super"
    Nothing -> log "Malformed access token" *> pure false
  where
  payload = (flip Array.index 1) <<< String.split (Pattern ".")
  decodeBase64 = hush <<< Base64.decode
