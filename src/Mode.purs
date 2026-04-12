module Mode
  ( Mode(..)
  , initializeMode
  , toggleMode
  ) where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe)
import Effect (Effect)
import Web.DOM.Element (setClassName)
import Web.HTML (window)
import Web.HTML.HTMLDocument (body)
import Web.HTML.Window (document, localStorage)
import Web.Storage.Storage (getItem, setItem)
import Web.HTML.HTMLElement (toElement)

data Mode = Light | Dark

derive instance eqMode :: Eq Mode

modeToString :: Mode -> String
modeToString = case _ of
  Light -> "light"
  Dark -> "dark"

stringToMode :: String -> Maybe Mode
stringToMode = case _ of
  "light" -> Just Light
  "dark" -> Just Dark
  _ -> Nothing

storageKey :: String
storageKey = "mode"

getStoredMode :: Effect (Maybe Mode)
getStoredMode = do
  storage <- window >>= localStorage
  modeStr <- getItem storageKey storage
  pure $ modeStr >>= stringToMode

initializeMode :: Effect Mode
initializeMode = do
  stored <- getStoredMode
  let initialMode = fromMaybe Dark stored
  setMode initialMode
  pure initialMode

toggleMode :: Effect Unit
toggleMode = do
  current <- getStoredMode
  let newMode = if current == Just Light then Dark else Light
  setMode newMode

setMode :: Mode -> Effect Unit
setMode mode = do
  storage <- window >>= localStorage
  setItem storageKey (modeToString mode) storage
  bodyElement <- window >>= document >>= body
  case bodyElement of
    Just el -> setClassName (modeToString mode) $ toElement el
    Nothing -> pure unit
