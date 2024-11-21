module App (mkApp) where

import Prelude

import Beta.DOM as R
import Components.Dashboard (mkDashboard)
import Components.LoginForm (mkLoginForm)
import Config as Config
import Data.Maybe (Maybe(..))
import Debug (spy)
import Effect.Class (liftEffect)
import Foreign.Shadcn.Toast (toaster)
import React.Basic.Hooks (Component, component, element, useState', (/\))
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)
import Service.Auth as Auth
import Service.ApiClient as ApiClient
import Types (JwtAccessToken)

mkApp :: Component {}
mkApp = do
  let { apiUrl } = Config.devConfig
  dashboard <- mkDashboard
  loginForm <- mkLoginForm
  component "App" \_ -> React.do
    token /\ setToken <- useState' NoToken

    useAff token do
      case token of
        NoToken -> Auth.getAccessToken { apiUrl } >>= case _ of
          Just accessToken -> liftEffect $ setToken (Loaded accessToken)
          Nothing -> liftEffect $ setToken NeedToLogin
        _ -> pure unit
      pure unit

    let
      -- You can debug stuff with the spy function:
      _ = spy "Config.apiUrl" apiUrl

      doLogin = Auth.loginAndGetAccessToken { apiUrl }
      onLoginSuccess = liftEffect <<< setToken <<< Loaded
      refreshAndGetAccessToken = Auth.refreshAndGetAccessToken { apiUrl }

    pure $ R.div {}
      [ case token of
          NoToken -> R.text "Loading..."
          NeedToLogin -> element loginForm { doLogin, onLoginSuccess }
          Loaded accessToken ->
            element dashboard
              { apiClient: ApiClient.makeClient { apiUrl, accessToken, refreshAndGetAccessToken }
              }
      , toaster {}
      ]

data TokenState = NoToken | NeedToLogin | Loaded JwtAccessToken

derive instance Eq TokenState
