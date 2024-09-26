module Config
  ( Config
  , devConfig
  ) where

-- All the configurations go here (they can be environment dependent).
-- Currently, everything is mocked and hardcoded, so this is just a demo
type Config =
  { apiUrl :: String -- This would point to our api server
  }

devConfig :: Config
devConfig =
  { apiUrl: "localhost:8081"
  }

-- productionConfig :: Config

-- stagingConfig :: Config

