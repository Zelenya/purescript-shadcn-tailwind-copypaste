module Foreign.Shadcn.AlertDemo where

import Prelude

import Beta.DOM (FFIComponent)
import Beta.DOM.Attributes (BaseAttributes, BaseAttributesR)
import Data.Undefined.NoProblem (Opt)
import ForgetMeNot (Id)
import React.Basic (ReactComponent)
import React.Basic as React
import Record as Record
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

type AlertProps f = BaseAttributesR
  ( variant :: f String
  )

foreign import alertImpl :: forall a. ReactComponent { | a }

alert :: FFIComponent (AlertProps Id)
alert props kids = React.element alertImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | AlertProps Opt })

foreign import alertDescriptionImpl :: forall a. ReactComponent { | a }

alertDescription :: FFIComponent BaseAttributes
alertDescription props kids = React.element alertDescriptionImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import alertTitleImpl :: forall a. ReactComponent { | a }

alertTitle :: FFIComponent BaseAttributes
alertTitle props kids = React.element alertTitleImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })
