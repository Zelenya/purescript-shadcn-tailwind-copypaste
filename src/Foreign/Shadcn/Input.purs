module Foreign.Shadcn.Input where

import Beta.DOM (FFIComponent_)
import Beta.DOM.Attributes (BaseAttributesR)
import Data.Undefined.NoProblem (Opt)
import ForgetMeNot (Id)
import React.Basic (ReactComponent)
import React.Basic as React
import React.Basic.Events (EventHandler)
import Unsafe.Coerce (unsafeCoerce)

type InputProps f = BaseAttributesR
  ( asChild :: f Boolean
  , onChange :: EventHandler
  , onKeyUp :: EventHandler
  , placeholder :: String
  , required :: f Boolean
  , size :: f String
  , type :: f String
  , value :: String
  , variant :: f String
  )

foreign import inputImpl :: forall a. ReactComponent { | a }

input :: FFIComponent_ (InputProps Id)
input props = React.element inputImpl (unsafeCoerce props :: { | InputProps Opt })
