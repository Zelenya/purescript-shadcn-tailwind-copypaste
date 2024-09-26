module Components.LoginForm (mkLoginForm, Props) where

import Prelude

import Beta.DOM as R
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Effect (Effect)
import Effect.Aff (Aff, attempt, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Foreign.Shadcn.Button (button)
import Foreign.Shadcn.Card (card, cardContent, cardDescription, cardFooter, cardHeader, cardTitle)
import Foreign.Shadcn.Input (input)
import Foreign.Shadcn.Label (label)
import LucideReact (loader2, makeIcon)
import React.Basic.DOM.Events (targetValue)
import React.Basic.Events (handler, handler_)
import React.Basic.Hooks (ReactComponent, reactComponent, useState, useState', (/\))
import React.Basic.Hooks as React
import Service.AuthClient (Credentials)
import Types (JwtAccessToken)

type Props =
  { doLogin :: Credentials -> Aff (Maybe JwtAccessToken)
  , onLoginSuccess :: JwtAccessToken -> Effect Unit
  }

mkLoginForm :: Effect (ReactComponent Props)
mkLoginForm = reactComponent "LoginForm" \{ doLogin, onLoginSuccess } -> React.do
  credentials /\ updateCredentials <- useState { email: "", password: "" }
  loading /\ setLoading <- useState' false
  error /\ setError <- useState' Nothing

  let clearError = setError Nothing

  pure $ R.div
    { className: "flex flex-row min-h-screen justify-center items-center gap-4" }
    [ card
        { className: "w-full max-w-sm" <> maybe "" (const " dark:border-destructive") error }
        [ cardHeader {}
            [ cardTitle { className: "text-2xl" } [ R.text "Login" ]
            , cardDescription {} [ R.text "Enter *anything* below to login (demo mode)" ] -- DEMO
            ]
        , cardContent { className: "grid gap-4" }
            [ R.div { className: "grid gap-2" }
                [ label { htmlFor: "email" } [ R.text "Email" ]
                , input
                    { id: "email"
                    , type: "email"
                    , placeholder: "im@pure.io"
                    , required: true
                    , value: credentials.email
                    , onChange: handler targetValue $ \value ->
                        clearError *> updateCredentials _ { email = fromMaybe "" value }
                    }
                ]
            , R.div { className: "grid gap-2" }
                [ label { htmlFor: "password" } [ R.text "Password" ]
                , input
                    { id: "password"
                    , type: "password"
                    , placeholder: "P4$$W0RD"
                    , required: true
                    , value: credentials.password
                    , onChange: handler targetValue $ \value ->
                        clearError *> updateCredentials _ { password = fromMaybe "" value }
                    }
                ]
            ]
        , cardFooter { className: "flex flex-col gap-4" }
            [ button
                { className: "w-full"
                , onClick:
                    handler_ $ launchAff_ do
                      liftEffect $ setLoading true
                      result <- attempt $ doLogin credentials
                      liftEffect case result of
                        Right (Just token) ->
                          onLoginSuccess token
                        Right Nothing ->
                          setError $ Just "Incorrect credentials"
                        Left err -> do
                          setError $ Just "Couldn't login. Something went wrong"
                          log $ show err
                      liftEffect $ setLoading false
                }
                [ if loading then
                    makeIcon loader2 { className: "mr-2 h-4 w-4 animate-spin" }
                  else
                    R.text "Sign in"
                ]
            , case error of
                Just msg -> R.div { className: "text-sm text-destructive" }
                  [ R.text msg ]
                Nothing -> mempty
            ]
        ]
    ]

