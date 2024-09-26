module Foreign.Shadcn.Label
  ( LabelProps
  , label
  ) where

import Prelude

import Beta.DOM (FFIComponent)
import Beta.DOM.Attributes (BaseAttributesR)
import React.Basic (ReactComponent)
import React.Basic as React
import Record as Record
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

type LabelProps = BaseAttributesR
  ( htmlFor :: String
  )

foreign import labelImpl :: forall a. ReactComponent { | a }

label :: FFIComponent LabelProps
label props kids = React.element labelImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | LabelProps })
