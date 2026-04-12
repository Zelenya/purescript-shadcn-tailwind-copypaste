module Components.Dashboard
  ( mkDashboard
  ) where

import Prelude

import Beta.DOM as R
import Components.Analytics (mkAnalytics)
import Components.UserPage (mkUserPage)
import Components.UserSearch (mkUserSearch)
import Components.UsersTable (mkUsersTable)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Effect (Effect)
import Effect.Aff (Error)
import Effect.Aff as Exception
import Effect.Class.Console (log)
import Foreign.Shadcn.Button (button)
import Foreign.Shadcn.Card (card, cardContent, cardDescription, cardHeader, cardTitle)
import Foreign.Shadcn.Toast (useToast)
import LucideReact (circleUser, makeIcon, activity, sun)
import Mode (toggleMode)
import React.Basic.Events (handler_)
import React.Basic.Hooks (JSX, ReactComponent, element, reactComponent)
import React.Basic.Hooks as React
import Service.ApiClient (ApiClient)
import Service.Routing.Router (useRouter)
import Service.Routing.Routes (printRoute)
import Service.Routing.Routes as Routes

type BaseProps r = (apiClient :: ApiClient | r)

-- This is the core of the app (called dashboard for the lack of a better name).
-- It has tabs: Home, Users, and Analytics, which are also connected to the routes
mkDashboard :: Effect (ReactComponent { | BaseProps () })
mkDashboard = do
  userSearch <- mkUserSearch
  userPage <- mkUserPage
  usersTable <- mkUsersTable
  analytics <- mkAnalytics

  reactComponent "Dashboard" \{ apiClient } -> React.do
    toast <- useToast
    router <- useRouter

    let
      -- Unified error handling for all subcomponents
      -- Note: errors are expected in this demo since there's no real backend
      onError :: String -> Error -> Effect Unit
      onError reason err = do
        let description = reason <> " (This is expected - no backend in this demo)"
        log $ reason <> ": " <> Exception.message err
        toast { variant: "destructive", title: "API Error Demo", description }

    pure $ R.div
      { className: "flex min-h-screen w-full flex-col" }
      [ R.header
          { className: "sticky top-0 flex h-16 items-center gap-4 border-b bg-background px-4 md:px-6" }
          [ navigation { activeTab: pageToTab router.route }
          , element userSearch
              { apiClient
              , onError
              }
          , button
              { className: "rounded-full"
              , variant: "ghost"
              , size: "icon"
              , onClick: handler_ toggleMode
              }
              [ makeIcon sun { className: "h-5 w-5" }
              , R.span { className: "sr-only" } [ R.text "Toggle dark/light mode" ]
              ]
          ]
      , case router.route of
          Routes.Home -> homePage
          Routes.User userId -> element userPage { apiClient, userId, onError }
          Routes.Users -> element usersTable {}
          Routes.Analytics -> element analytics {}
      ]
  where
  homePage =
    R.main { className: "p-6 space-y-6" }
      [ R.div { className: "grid gap-4 md:grid-cols-3" }
          [ card {}
              [ cardHeader { className: "flex flex-row items-center justify-between space-y-0 pb-2" }
                  [ cardTitle { className: "font-medium" } [ R.text "This is a PureScript + shadcn/ui demo app" ]
                  , makeIcon activity { className: "h-4 w-4 text-muted-foreground" }
                  ]
              , cardContent {}
                  [ R.div { className: "" }
                      [ R.text "These cards are just placesholders to showcase the shadcn/ui components integration."
                      ]
                  , R.p { className: "text-xs text-muted-foreground" }
                      [ R.text "Checkout the source code for comments and basic documentation" ]
                  ]
              ]
          , card {}
              [ cardHeader {}
                  [ cardTitle { className: "font-medium" } [ R.text "Quick Stats" ]
                  ]
              , cardContent {}
                  [ R.div { className: "text-2xl font-bold" } [ R.text "6" ]
                  , R.p { className: "text-xs text-muted-foreground" }
                      [ R.text "Team members in the system" ]
                  ]
              ]
          , card {}
              [ cardHeader {}
                  [ cardTitle { className: "font-medium" } [ R.text "System Status" ]
                  ]
              , cardContent {}
                  [ R.div { className: "flex items-center gap-2" }
                      [ R.span { className: "h-2 w-2 rounded-full bg-green-500" } []
                      , R.span { className: "text-sm" } [ R.text "All systems operational" ]
                      ]
                  , R.div { className: "flex items-center gap-2" }
                      [ R.span { className: "h-2 w-2 rounded-full bg-destructive" } []
                      , R.span { className: "text-sm" } [ R.text "There is no BE (as expected)" ]
                      ]
                  ]
              ]
          ]
      , card {}
          [ cardHeader {}
              [ cardTitle {} [ R.text "Getting Started" ]
              , cardDescription {} [ R.text "Explore the demo features" ]
              ]
          , cardContent {}
              [ R.ul { className: "list-disc list-inside space-y-2 text-sm text-muted-foreground" }
                  [ R.li {} [ R.text "Check out the Users tab to see a table of team members" ]
                  , R.li {} [ R.text "Visit Analytics for charts and statistics" ]
                  , R.li {} [ R.text "Use the search bar to find specific users" ]
                  ]
              ]
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
  , renderTab Analytics

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
  = Home
  | Users
  | Analytics

tabToPage :: Tab -> Routes.Route
tabToPage = case _ of
  Home -> Routes.Home
  Users -> Routes.Users
  Analytics -> Routes.Analytics

pageToTab :: Routes.Route -> Tab
pageToTab = case _ of
  Routes.Home -> Home
  Routes.Users -> Users
  Routes.User _ -> Users
  Routes.Analytics -> Analytics

derive instance Eq Tab
derive instance Generic Tab _
instance Show Tab where
  show x = genericShow x
