module Components.UserSearch
  ( UserSearchProps
  , mkUserSearch
  ) where

import Prelude

import Beta.DOM as R
import Data.Either (Either(..))
import Data.Foldable (traverse_)
import Data.Monoid (guard)
import Effect (Effect)
import Effect.Aff (Aff, Error, attempt, launchAff_)
import Effect.Class (liftEffect)
import Foreign.Shadcn.Input (input)
import LucideReact (makeIcon, search)
import React.Basic (ReactComponent)
import React.Basic.DOM.Events (preventDefault, targetValue)
import React.Basic.Events (handler)
import React.Basic.Hooks ((/\), reactComponent, useState')
import React.Basic.Hooks as React
import Service.ApiClient (ApiClient)
import Service.Routing.Router (useRouter)
import Service.Routing.Routes as Routes
import Types (Email(..))

type UserSearchProps =
  { apiClient :: ApiClient
  , onError :: String -> Error -> Effect Unit
  }

mkUserSearch :: Effect (ReactComponent UserSearchProps)
mkUserSearch = reactComponent "UserSearch" \{ apiClient, onError } -> React.do
  router <- useRouter
  emailInput /\ setEmailInput <- useState' ""

  let
    onSubmit :: Email -> Aff Unit
    onSubmit email = do
      maybeUser <- attempt $ apiClient.findUser email
      liftEffect case maybeUser of
        Right userId -> router.redirect (Routes.User userId)
        Left error -> onError "User not found" error

  pure $ R.div
    { className: "flex w-full items-center gap-4 md:ml-auto md:gap-2 lg:gap-4" }
    [ R.form
        { className: "ml-auto flex-1 sm:flex-initial"
        , onSubmit: handler preventDefault $ \_ -> guard (emailInput /= "") $ launchAff_ $ onSubmit (Email emailInput)
        }
        [ R.div
            { className: "relative" }
            [ makeIcon search
                { className: "absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" }
            , input
                { className: "pl-8 sm:w-[300px] md:w-[200px] lg:w-[300px] text-foreground"
                , type: "search"
                , value: emailInput
                , placeholder: "Search user by email"
                , onChange: handler targetValue $ traverse_ setEmailInput
                }
            ]
        ]
    ]
