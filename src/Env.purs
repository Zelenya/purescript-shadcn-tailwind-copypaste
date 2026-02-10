module Env
  ( Env(..)
  , Environment(..)
  , RawEnv
  , extractEnv
  , isDev
  , parseEnv
  ) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Partial.Unsafe (unsafeCrashWith)

type RawEnv = { type :: String, value :: String }

parseEnv :: RawEnv -> Environment
parseEnv raw = case raw.type of
  "Dev" -> Dev case raw.value of
    "Production" -> Production
    "Staging" -> Staging
    err -> unsafeCrashWith $ "Invalid value for Dev environment: " <> err
  "Live" -> Live
  err -> unsafeCrashWith $ "Invalid type for environment: " <> err

data Environment = Dev Env | Live

derive instance Eq Environment
derive instance Generic Environment _
instance Show Environment where
  show x = genericShow x

data Env = Production | Staging

derive instance Eq Env
derive instance Generic Env _
instance Show Env where
  show x = genericShow x

extractEnv :: Environment -> Env
extractEnv = case _ of
  Live -> Production
  Dev e -> e

isDev :: Environment -> Boolean
isDev = case _ of
  Live -> false
  Dev _ -> true
