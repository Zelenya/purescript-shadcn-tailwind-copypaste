module Foreign.Shadcn.Toast
  ( ToastFn
  , ToastProps
  , UseToast(..)
  , toaster
  , useToast
  ) where

import Prelude

import Beta.DOM (FFIComponent_)
import Beta.DOM.Attributes (BaseAttributes)
import Data.Undefined.NoProblem (Opt)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import React.Basic (ReactComponent)
import React.Basic as React
import React.Basic.Hooks (Hook, unsafeHook)
import Unsafe.Coerce (unsafeCoerce)
import ForgetMeNot (Id)

foreign import toasterImpl :: forall a. ReactComponent { | a }

toaster :: FFIComponent_ BaseAttributes
toaster props = React.element toasterImpl $
  (unsafeCoerce props :: { | BaseAttributes })

type ToastProps f =
  ( variant :: f String
  , title :: f String
  , description :: String
  -- , action :: Opt ??? -- TODO: Add ToastAction
  )

type ToastFn = { | ToastProps Id } -> Effect Unit

type UseToastResult = { toast :: EffectFn1 { | ToastProps Opt } Unit }

foreign import useToastImpl :: Effect UseToastResult

foreign import data UseToast :: Type -> Type

useToast :: Hook UseToast ToastFn
useToast = unsafeHook do
  { toast } <- useToastImpl
  let curried props = runEffectFn1 toast $ unsafeCoerce props
  pure curried

