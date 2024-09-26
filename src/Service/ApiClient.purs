module Service.ApiClient
  ( ApiClient
  , Product
  , Props
  , User
  , makeClient
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Newtype (un)
import Effect.Aff (Aff, error, throwError)
import Fetch (Method(..), Response, fetch)
import Fetch.Yoga.Json (fromJSON)
import Types (Email(..), JwtAccessToken(..), UserId(..))
import Yoga.JSON (class ReadForeign)

-- The Service.ApiClient is an example of a client module.
-- Using this client, we can find a user by email and get all products for the given user.
-- It allows showcases some boilerplate for dealing with access tokens and basic response status handling.

type ApiClient =
  { findUser :: Email -> Aff UserId
  , getUser :: UserId -> Aff User
  , getProducts :: UserId -> Aff Product
  }

type Props =
  { apiUrl ∷ String
  , accessToken :: JwtAccessToken
  , refreshAndGetAccessToken :: Aff (Maybe JwtAccessToken)
  }

-- One way to bundle/module code.
-- This is something like the handle or the service patterns
-- TODO: Use and implement the ones that you need:
makeClient :: Props -> ApiClient
makeClient config =
  { findUser: findUser config
  , getUser: getUser config
  , getProducts: getProducts config
  }

-- So, for example, you can mock/test without using an actual client:
-- makeMockClient :: forall a. a -> ApiClient
-- makeMockClient _ =
--   { findUser: \_ -> pure mockUser
--   , getProducts: \_ -> pure mockSubscriptionForced
--   }

-- TODO: Implement a call to some find-user endpoint 
-- This is a mock:
findUser :: Props -> Email -> Aff UserId
findUser _ _ = pure (UserId "1bb8c528-e908-4302-a02f-5e739866a68d")

type User =
  { id ∷ UserId
  , email ∷ Email
  , name ∷ String
  }

-- TODO: Implement a call to some get-user endpoint 
-- This is a mock:
getUser :: Props -> UserId -> Aff User
getUser _ userId = pure mockUser
  where
  mockUser ∷ User
  mockUser =
    { id: userId
    , email: Email "real.user@jmail.com"
    , name: "Real User"
    }

type Product =
  { id :: String
  , name :: String
  , autorenew :: Boolean
  }

-- TODO: Implement the rest of the client
-- This is an example (which errors because nothing handles the request):
getProducts :: Props -> UserId -> Aff Product
getProducts { apiUrl, accessToken, refreshAndGetAccessToken } (UserId userId) = do
  fetchWithAuth { accessToken, refreshAndGetAccessToken, request }
  where
  request token = fetch (apiUrl <> "/example/products/" <> userId)
    { method: GET
    , headers:
        { "Authorization": "Bearer " <> un JwtAccessToken token
        , "Content-Type": "application/json"
        }
    }

type Fetch =
  { accessToken :: JwtAccessToken
  , refreshAndGetAccessToken :: Aff (Maybe JwtAccessToken)
  , request :: JwtAccessToken -> Aff Response
  }

fetchWithAuth :: forall a. ReadForeign a => Fetch -> Aff a
fetchWithAuth { accessToken, refreshAndGetAccessToken, request } = do
  { status, json } <- request accessToken
  case status of
    -- if the respone was successful, return the parsed body 
    200 -> fromJSON json
    -- if api returns 401, refresh a token and try again
    401 -> refreshAndGetAccessToken >>= case _ of
      Just newToken -> do
        retried <- request newToken
        -- if the respone was successful, return the parsed body
        if retried.status == 200 then fromJSON retried.json
        -- if the response wasn't successful, throw an error
        else throwUnexpected retried.status
      -- if refreshing token failed, throw an error
      Nothing -> throwError $ error $ "Couldn't get access token"
    -- if the response wasn't successful, throw an error
    other -> throwUnexpected other
  where
  throwUnexpected status = throwError $ error $ "Unexpected response status: " <> show status
