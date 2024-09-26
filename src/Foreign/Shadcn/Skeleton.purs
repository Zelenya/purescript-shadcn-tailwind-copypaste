module Foreign.Shadcn.Skeleton where

import Prelude

import Beta.DOM (FFIComponent_)
import Beta.DOM.Attributes (BaseAttributesR)
import React.Basic (ReactComponent)
import React.Basic as React
import Unsafe.Coerce (unsafeCoerce)

foreign import skeletonImpl :: forall a. ReactComponent { | a }

skeleton :: FFIComponent_ (BaseAttributesR ())
skeleton props = React.element skeletonImpl $
  (unsafeCoerce props :: { | BaseAttributesR () })
