module Foreign.Shadcn.Button where

import Prelude

import Beta.DOM (FFIComponent)
import Beta.DOM.Attributes (BaseAttributesR)
import Data.Undefined.NoProblem (Opt)
import ForgetMeNot (Id)
import React.Basic (ReactComponent)
import React.Basic as React
import Record as Record
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

type ButtonProps f = BaseAttributesR
  ( variant :: f String
  , size :: f String
  , asChild :: Boolean
  , type :: String
  , disabled :: Boolean
  )

foreign import buttonImpl :: forall a. ReactComponent { | a }

button :: FFIComponent (ButtonProps Id)
button props kids = React.element buttonImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | ButtonProps Opt })
