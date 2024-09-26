module Foreign.Shadcn.Dialog
  ( DialogTriggerProps
  , dialog
  , dialogClose
  , dialogContent
  , dialogDescription
  , dialogFooter
  , dialogHeader
  , dialogImpl
  , dialogTitle
  , dialogTrigger
  ) where

import Prelude

import Beta.DOM (FFIComponent)
import Beta.DOM.Attributes (BaseAttributes, BaseAttributesR)
import React.Basic (ReactComponent)
import React.Basic as React
import Record as Record
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

foreign import dialogImpl :: forall a. ReactComponent { | a }

dialog :: FFIComponent BaseAttributes
dialog props kids = React.element dialogImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

type DialogTriggerProps = BaseAttributesR
  ( asChild :: Boolean
  )

foreign import dialogTriggerImpl :: forall a. ReactComponent { | a }

dialogTrigger :: FFIComponent DialogTriggerProps
dialogTrigger props kids = React.element dialogTriggerImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | DialogTriggerProps })

foreign import dialogContentImpl :: forall a. ReactComponent { | a }

dialogContent :: FFIComponent BaseAttributes
dialogContent props kids = React.element dialogContentImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import dialogHeaderImpl :: forall a. ReactComponent { | a }

dialogHeader :: FFIComponent BaseAttributes
dialogHeader props kids = React.element dialogHeaderImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import dialogTitleImpl :: forall a. ReactComponent { | a }

dialogTitle :: FFIComponent BaseAttributes
dialogTitle props kids = React.element dialogTitleImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import dialogDescriptionImpl :: forall a. ReactComponent { | a }

dialogDescription :: FFIComponent BaseAttributes
dialogDescription props kids = React.element dialogDescriptionImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import dialogFooterImpl :: forall a. ReactComponent { | a }

dialogFooter :: FFIComponent BaseAttributes
dialogFooter props kids = React.element dialogFooterImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import dialogCloseImpl :: forall a. ReactComponent { | a }

dialogClose :: FFIComponent BaseAttributes
dialogClose props kids = React.element dialogCloseImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })
