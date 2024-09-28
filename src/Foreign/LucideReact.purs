module LucideReact where

import Beta.DOM (FFIComponent_)
import Beta.DOM.Attributes (BaseAttributesR)
import Data.Undefined.NoProblem (Opt)
import ForgetMeNot (Id)
import React.Basic (ReactComponent)
import React.Basic as React
import Unsafe.Coerce (unsafeCoerce)

type IconProps f = BaseAttributesR
  ( size :: f String
  )

-- Example usage: makeIcon activity { className: "h-4 w-4 text-muted-foreground" }
makeIcon ∷ ReactComponent { | IconProps Opt } -> FFIComponent_ (IconProps Id)
makeIcon icon iconProps =
  React.element icon (unsafeCoerce iconProps :: { | IconProps Opt })

foreign import activity :: forall r. ReactComponent { | r }
foreign import arrowDown :: forall r. ReactComponent { | r }
foreign import bomb :: forall r. ReactComponent { | r }
foreign import chevronDown :: forall r. ReactComponent { | r }
foreign import circleUser :: forall r. ReactComponent { | r }
foreign import clipboardCheck :: forall r. ReactComponent { | r }
foreign import clipboardCopy :: forall r. ReactComponent { | r }
foreign import construction :: forall r. ReactComponent { | r }
foreign import dollarSign :: forall r. ReactComponent { | r }
foreign import link :: forall r. ReactComponent { | r }
foreign import loader2 :: forall r. ReactComponent { | r }
foreign import mail :: forall r. ReactComponent { | r }
foreign import refresh :: forall r. ReactComponent { | r }
foreign import search :: forall r. ReactComponent { | r }
foreign import users :: forall r. ReactComponent { | r }
foreign import video :: forall r. ReactComponent { | r }
foreign import wallet :: forall r. ReactComponent { | r }
