module Main where

import Prelude

import App (mkApp)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import Env (RawEnv)
import React.Basic.DOM.Client (createRoot, renderRoot)
import Service.Routing.Router (mkRouterProvider)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

-- | Find the element with `app` id, that we declared in `index.html`.
-- | Create and render a component tree into this element,
-- | Or crash in case we messed up during the setup.
-- | When you develop locally, you can either point to prod or staging APIs
-- | See index.js
main :: EffectFn1 RawEnv Unit
main = mkEffectFn1 $ \_rawEnv -> mkMain
  where
  mkMain :: Effect Unit
  mkMain = do
    doc <- document =<< window
    container <- getElementById "app" $ toNonElementParentNode doc
    case container of
      Nothing -> throw "Could not find container element"
      Just c -> do
        routerProvider <- mkRouterProvider
        app <- mkApp
        reactRoot <- createRoot c
        renderRoot reactRoot $ routerProvider [ app {} ]
