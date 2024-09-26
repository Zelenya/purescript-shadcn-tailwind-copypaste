module Service.AuthClient
  ( Credentials
  , TokenPair
  , login
  , refresh
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Aff (Aff, error, throwError)
import Fetch (Method(..), fetch)
import Fetch.Yoga.Json (fromJSON)
import Types (JwtAccessToken(..), JwtRefreshToken(..))
import Yoga.JSON (writeJSON)

type Config =
  { apiUrl ∷ String
  }

type Credentials =
  { email ∷ String
  , password ∷ String
  }

type TokenPair =
  { accessToken :: JwtAccessToken
  , refreshToken :: JwtRefreshToken
  }

-- TODO: Implement a call to the login endpoint 
-- This is a mock:
login :: Config -> Credentials -> Aff (Maybe TokenPair)
login _ _ = pure $ Just $
  { accessToken: JwtAccessToken "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjozNDU2Nzg5MDEyMSwidXNlciI6eyJyb2xlIjoic3VwZXIifX0.aQmhzAjAZMrDUVdUCSdPFc30KKv9mwkfPfRdqpZWGyY"
  , refreshToken: JwtRefreshToken "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjozNDU2Nzg5MDEyMSwidXNlciI6eyJyb2xlIjoic3VwZXIifX0.aQmhzAjAZMrDUVdUCSdPFc30KKv9mwkfPfRdqpZWGyY"
  }

-- TODO: Implement a call to the refresh endpoint
-- This is an example (which errors because nothing handles the request):
refresh :: Config -> JwtRefreshToken -> Aff TokenPair
refresh { apiUrl } credentials = do
  { status, json } <- fetch (apiUrl <> "/demo/refresh") requestBody
  if status == 200 then fromJSON json
  else throwError $ error $ "Unexpected response status: " <> show status
  where
  requestBody =
    { method: POST
    , body: writeJSON credentials
    , headers: { "Content-Type": "application/json" }
    }
