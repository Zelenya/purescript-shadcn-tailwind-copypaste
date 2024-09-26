module Foreign.Shadcn.Command
  ( command
  , commandDialog
  , commandEmpty
  , commandGroup
  , commandImpl
  , commandInput
  , commandItem
  , commandList
  , commandSeparator
  , commandShortcut
  ) where

import Prelude

import Beta.DOM (FFIComponent, FFIComponent_)
import Beta.DOM.Attributes (BaseAttributes, BaseAttributesR)
import Data.Undefined.NoProblem (Opt)
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1)
import React.Basic (ReactComponent)
import React.Basic as React
import Record as Record
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

foreign import commandImpl :: forall a. ReactComponent { | a }

command :: FFIComponent BaseAttributes
command props kids = React.element commandImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

type CommandDialogProps = BaseAttributesR
  ( open :: Boolean
  , onOpenChange :: Boolean -> Effect Unit
  )

foreign import commandDialogImpl :: forall a. ReactComponent { | a }

commandDialog :: FFIComponent CommandDialogProps
commandDialog props kids = React.element commandDialogImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | CommandDialogProps })

foreign import commandEmptyImpl :: forall a. ReactComponent { | a }

commandEmpty :: FFIComponent BaseAttributes
commandEmpty props kids = React.element commandEmptyImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

type CommandGroupProps = BaseAttributesR
  ( heading :: String
  )

foreign import commandGroupImpl :: forall a. ReactComponent { | a }

commandGroup :: FFIComponent CommandGroupProps
commandGroup props kids = React.element commandGroupImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | CommandGroupProps })

type CommandInputProps = BaseAttributesR
  ( placeholder :: String
  )

foreign import commandInputImpl :: forall a. ReactComponent { | a }

commandInput :: FFIComponent_ CommandInputProps
commandInput props = React.element commandInputImpl (unsafeCoerce props :: { | CommandInputProps })

type CommandItemProps = BaseAttributesR
  ( onSelect :: String -> Effect Unit
  )

foreign import commandItemImpl :: forall a. ReactComponent { | a }

commandItem :: FFIComponent CommandItemProps
commandItem props kids = React.element commandItemImpl
  $ Record.insert (Proxy :: _ "children") kids
      (unsafeCoerce props :: { | CommandItemProps })

foreign import commandListImpl :: forall a. ReactComponent { | a }

commandList :: FFIComponent BaseAttributes
commandList props kids = React.element commandListImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import commandSeparatorImpl :: forall a. ReactComponent { | a }

commandSeparator :: FFIComponent_ BaseAttributes
commandSeparator props = React.element commandSeparatorImpl (unsafeCoerce props :: { | BaseAttributes })

foreign import commandShortcutImpl :: forall a. ReactComponent { | a }

commandShortcut :: FFIComponent BaseAttributes
commandShortcut props kids = React.element commandShortcutImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })
