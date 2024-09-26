module Main where

import Prelude

import App (mkApp)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM.Client (createRoot, renderRoot)
import Service.Routing.Router (mkRouterProvider)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

-- | Find the element with `app` id, that we declared in `index.html`.
-- | Create and render a component tree into this element,
-- | Or crash in case we messed up during the setup.
main :: Effect Unit
main = do
  doc <- document =<< window
  container <- getElementById "app" $ toNonElementParentNode doc
  case container of
    Nothing -> throw "Could not find container element"
    Just c -> do
      routerProvider <- mkRouterProvider
      app <- mkApp
      reactRoot <- createRoot c
      renderRoot reactRoot $ routerProvider [ app {} ]
