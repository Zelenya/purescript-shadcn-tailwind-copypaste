module Components.Dashboard
  ( mkDashboard
  ) where

import Prelude

import Beta.DOM as R
import Components.UserPage (mkUserPage)
import Components.UserSearch (mkUserSearch)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Effect (Effect)
import Effect.Aff (Error)
import Effect.Aff as Exception
import Effect.Class.Console (log)
import Foreign.Shadcn.AlertDemo (alert, alertDescription, alertTitle)
import Foreign.Shadcn.Button (button)
import Foreign.Shadcn.Toast (useToast)
import LucideReact (circleUser, makeIcon, construction)
import React.Basic.Hooks (JSX, ReactComponent, element, reactComponent)
import React.Basic.Hooks as React
import Service.ApiClient (ApiClient)
import Service.Routing.Router (useRouter)
import Service.Routing.Routes (printRoute)
import Service.Routing.Routes as Routes

type BaseProps r = (apiClient :: ApiClient | r)

-- This is the core of the app (called dashboard for the lack of a better name).
-- It has two tabs: Home and User, which are also connected to the routes
mkDashboard :: Effect (ReactComponent { | BaseProps () })
mkDashboard = do
  userSearch <- mkUserSearch
  userPage <- mkUserPage

  reactComponent "Dashboard" \{ apiClient } -> React.do
    toast <- useToast
    router <- useRouter

    let
      -- Unified error handling for all subcomponents
      onError :: String -> Error -> Effect Unit
      onError reason err = do
        let description = reason <> ": " <> Exception.message err
        log description
        toast { variant: "destructive", title: "Something went wrong", description }

    pure $ R.div
      { className: "flex min-h-screen w-full flex-col" }
      [ R.header
          { className: "sticky top-0 flex h-16 items-center gap-4 border-b bg-background px-4 md:px-6" }
          [ navigation { activeTab: pageToTab router.route }
          , element userSearch
              { apiClient
              , onError
              }
          ]
      , case router.route of
          Routes.Home -> preview
          Routes.User userId -> element userPage { apiClient, userId, onError }
          Routes.Users -> preview
      ]
  where
  preview =
    R.main { className: "p-6" }
      [ alert { variant: "destructive" }
          [ makeIcon construction { className: "h-4 w-4" }
          , alertTitle {} [ R.text "Caution!" ]
          , alertDescription {} [ R.text "Under active development." ]
          ]
      ]

type NavigationProps =
  { activeTab :: Tab
  }

navigation ∷ NavigationProps -> JSX
navigation { activeTab } = R.nav
  { className: "hidden flex-col gap-6 text-lg font-medium md:flex md:flex-row md:items-center md:gap-5 md:text-sm lg:gap-6" }
  [ button
      { className: "rounded-full"
      , variant: "secondary"
      , size: "icon"
      }
      [ makeIcon circleUser { className: "h-5 w-5" }
      , R.span { className: "sr-only" } [ R.text "Toggle admin menu" ]
      ]
  , renderTab Home
  , renderTab Users
  ]
  where
  renderTab :: Tab -> JSX
  renderTab tab = R.a
    { href: printRoute (tabToPage tab)
    , className: "transition-colors hover:text-foreground " <> color tab
    }
    [ R.text $ show tab ]

  color tab = if activeTab == tab then "text-foreground" else "text-muted-foreground"

data Tab
  = Users
  | Home

tabToPage :: Tab -> Routes.Route
tabToPage = case _ of
  Users -> Routes.Users
  Home -> Routes.Home

pageToTab :: Routes.Route -> Tab
pageToTab = case _ of
  Routes.Users -> Users
  Routes.User _ -> Users
  Routes.Home -> Home

derive instance Eq Tab
derive instance Generic Tab _
instance Show Tab where
  show x = genericShow x
