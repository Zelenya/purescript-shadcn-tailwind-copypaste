module Foreign.Shadcn.Card
  ( card
  , cardContent
  , cardDescription
  , cardFooter
  , cardHeader
  , cardTitle
  ) where

import Prelude

import Beta.DOM (FFIComponent)
import Beta.DOM.Attributes (BaseAttributes)
import React.Basic (ReactComponent)
import React.Basic as React
import Record as Record
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

foreign import cardImpl :: forall a. ReactComponent { | a }

card :: FFIComponent BaseAttributes
card props kids = React.element cardImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import cardContentImpl :: forall a. ReactComponent { | a }

cardContent :: FFIComponent BaseAttributes
cardContent props kids = React.element cardContentImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import cardDescriptionImpl :: forall a. ReactComponent { | a }

cardDescription :: FFIComponent BaseAttributes
cardDescription props kids = React.element cardDescriptionImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import cardHeaderImpl :: forall a. ReactComponent { | a }

cardHeader :: FFIComponent BaseAttributes
cardHeader props kids = React.element cardHeaderImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import cardTitleImpl :: forall a. ReactComponent { | a }

cardTitle :: FFIComponent BaseAttributes
cardTitle props kids = React.element cardTitleImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import cardFooterImpl :: forall a. ReactComponent { | a }

cardFooter :: FFIComponent BaseAttributes
cardFooter props kids = React.element cardFooterImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })
