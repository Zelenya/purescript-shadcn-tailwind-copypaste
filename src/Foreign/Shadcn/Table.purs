module Foreign.Shadcn.Table
  ( table
  , tableHeader
  , tableBody
  , tableFooter
  , tableHead
  , tableRow
  , tableCell
  , tableCaption
  ) where

import Prelude

import Beta.DOM (FFIComponent)
import Beta.DOM.Attributes (BaseAttributes)
import React.Basic (ReactComponent)
import React.Basic as React
import Record as Record
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

foreign import tableImpl :: forall a. ReactComponent { | a }

table :: FFIComponent BaseAttributes
table props kids = React.element tableImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import tableHeaderImpl :: forall a. ReactComponent { | a }

tableHeader :: FFIComponent BaseAttributes
tableHeader props kids = React.element tableHeaderImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import tableBodyImpl :: forall a. ReactComponent { | a }

tableBody :: FFIComponent BaseAttributes
tableBody props kids = React.element tableBodyImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import tableFooterImpl :: forall a. ReactComponent { | a }

tableFooter :: FFIComponent BaseAttributes
tableFooter props kids = React.element tableFooterImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import tableHeadImpl :: forall a. ReactComponent { | a }

tableHead :: FFIComponent BaseAttributes
tableHead props kids = React.element tableHeadImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import tableRowImpl :: forall a. ReactComponent { | a }

tableRow :: FFIComponent BaseAttributes
tableRow props kids = React.element tableRowImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import tableCellImpl :: forall a. ReactComponent { | a }

tableCell :: FFIComponent BaseAttributes
tableCell props kids = React.element tableCellImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })

foreign import tableCaptionImpl :: forall a. ReactComponent { | a }

tableCaption :: FFIComponent BaseAttributes
tableCaption props kids = React.element tableCaptionImpl $
  Record.insert (Proxy :: _ "children") kids
    (unsafeCoerce props :: { | BaseAttributes })
