module Service.Routing.Router (useRouter, mkRouterProvider, UseRouter(..), Router) where

import Prelude hiding ((/))

import Service.Routing.Routes (Route(..), parseRoute, printRoute)
import Data.Newtype (class Newtype)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Ref as Ref
import Effect.Unsafe (unsafePerformEffect)
import React.Basic.Hooks (JSX, UseContext, Hook)
import React.Basic.Hooks as React
import Web.Router as Router
import Web.Router.PushState as PushState

type Router =
  { route :: Route
  , navigate :: Route -> Effect Unit
  , redirect :: Route -> Effect Unit
  }

newtype UseRouter :: Type -> Type
newtype UseRouter hooks = UseRouter (UseContext Router hooks)

derive instance Newtype (UseRouter hooks) _

routerContext :: React.ReactContext Router
-- This is a top-level component, it's safe to call unsafe :)
routerContext = unsafePerformEffect (React.createContext { route: Home, navigate: mempty, redirect: mempty })

useRouter :: Hook UseRouter Router
useRouter =
  React.coerceHook do
    React.useContext routerContext

mkRouterProvider :: Effect (Array JSX -> JSX)
mkRouterProvider = do
  subscriberRef <- Ref.new mempty
  let
    onNavigation _ _ = Router.continue
    onEvent = case _ of
      Router.Routing _ _ -> pure unit
      Router.Resolved _ route -> do
        setRoute <- Ref.read subscriberRef
        setRoute route
  driver <- PushState.mkInterface parseRoute printRoute
  router <- Router.mkInterface onNavigation onEvent driver
  React.component "Router" \children -> React.do
    currentRoute /\ setCurrentRoute <- React.useState' Home
    React.useEffectOnce do
      Ref.write setCurrentRoute subscriberRef
      router.initialize
    pure $ React.provider routerContext
      { route: currentRoute
      , navigate: router.navigate
      , redirect: router.redirect
      }
      children
