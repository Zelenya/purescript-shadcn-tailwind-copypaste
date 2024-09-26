module Service.Routing.Routes
  ( Route(..)
  , parseRoute
  , printRoute
  ) where

import Prelude hiding ((/))

import Data.Either (Either)
import Data.Generic.Rep (class Generic)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Show.Generic (genericShow)
import Routing.Duplex (RouteDuplex', end, parse, print, root, segment)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))
import Routing.Duplex.Parser (RouteError)
import Types (UserId)

data Route
  = Home
  | Users
  | User UserId

derive instance Generic Route _
derive instance Eq Route
instance Show Route where
  show x = genericShow x

userId :: RouteDuplex' UserId
userId = _Newtype segment

routes :: RouteDuplex' Route
routes =
  root $ end $ sum
    { "Home": noArgs
    , "Users": "users" / noArgs
    , "User": "users" / userId
    }

parseRoute :: String -> Either RouteError Route
parseRoute = parse routes

printRoute :: Route -> String
printRoute = print routes
