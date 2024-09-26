module Components.ClipboardButton where

import Prelude

import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, launchAff_)
import Effect.Class (liftEffect)
import LucideReact (clipboardCheck, clipboardCopy, makeIcon)
import React.Basic.Events (handler_)
import React.Basic.Hooks (ReactComponent, reactComponent, useState', (/\))
import React.Basic.Hooks as React
import Foreign.Shadcn.Button (button)
import Web.Clipboard (clipboard, writeText)
import Web.HTML (window)
import Web.HTML.Window (navigator)

type ClipboardButtonProps =
  { text :: String
  }

-- Copy the text to clipboard; show a checkmark and then hide it
mkClipboardButton :: Effect (ReactComponent ClipboardButtonProps)
mkClipboardButton =
  reactComponent "ClipboardButton" \{ text } -> React.do
    copied /\ setCopied <- useState' false
    pure $ button
      { variant: "outline"
      , size: "icon"
      , onClick: handler_ do
          void $ window >>= navigator >>= clipboard >>= writeText text
          setCopied true
          launchAff_ $ delay (Milliseconds 500.0) *> liftEffect (setCopied false)
      }
      [ if copied then makeIcon clipboardCheck { className: "h-4 w-4 text-emerald-500" }
        else makeIcon clipboardCopy { className: "h-4 w-4" }
      ]
