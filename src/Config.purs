module Config
  ( Config
  , devConfig
  , getConfig
  , productionConfig
  , stagingConfig
  ) where

import Env (Env(..))

-- All the configurations go here (they can be environment dependent).
-- Currently, everything is mocked and hardcoded, so this is just a demo
type Config =
  { apiUrl :: String -- This would point to our api server
  }

-- For local development (mocked)
devConfig :: Config
devConfig =
  { apiUrl: "localhost:8081"
  }

productionConfig :: Config
productionConfig =
  { apiUrl: "https://api.example.com"
  }

stagingConfig :: Config
stagingConfig =
  { apiUrl: "https://staging-api.example.com"
  }

getConfig :: Env -> Config
getConfig = case _ of
  Production -> productionConfig
  Staging -> stagingConfig
