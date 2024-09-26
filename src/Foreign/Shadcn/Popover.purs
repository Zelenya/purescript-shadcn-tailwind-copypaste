module Foreign.Shadcn.Popover
  ( PopoverProps
  , popover
  , popoverContent
  , popoverTrigger
  ) where

import Prelude

import Beta.DOM (FFIComponent)
import Beta.DOM.Attributes (BaseAttributes, BaseAttributesR)
import Effect (Effect)
import React.Basic (ReactComponent)
import React.Basic as React
import Record as Record
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

type PopoverProps = BaseAttributesR
  ( open :: Boolean
  , onOpenChange :: Boolean -> Effect Unit
  )

foreign import popoverImpl :: forall a. ReactComponent { | a }

popover :: FFIComponent PopoverProps
popover props kids = React.element popoverImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | PopoverProps })

type PopoverTriggerProps = BaseAttributesR
  ( asChild :: Boolean
  )

foreign import popoverTriggerImpl :: forall a. ReactComponent { | a }

popoverTrigger :: FFIComponent PopoverTriggerProps

popoverTrigger props kids = React.element popoverTriggerImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | PopoverTriggerProps })

foreign import popoverContentImpl :: forall a. ReactComponent { | a }

popoverContent :: FFIComponent BaseAttributes
popoverContent props kids = React.element popoverContentImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })
