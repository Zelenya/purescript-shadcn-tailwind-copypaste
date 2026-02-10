module Components.Analytics
  ( mkAnalytics
  ) where

import Prelude

import Beta.DOM as R
import Data.Array (mapWithIndex)
import Foreign.Shadcn.Card (card, cardContent, cardDescription, cardHeader, cardTitle)
import LucideReact (dollarSign, makeIcon, trendingDown, trendingUp, users, activity)
import React.Basic.Hooks (JSX, ReactComponent, reactComponent)
import Effect (Effect)

type StatCard =
  { title :: String
  , value :: String
  , change :: String
  , trend :: String
  }

type ChartData =
  { label :: String
  , value :: Int
  , color :: String
  }

statsCards :: Array StatCard
statsCards =
  [ { title: "Total Revenue", value: "$45,231", change: "+20.1%", trend: "up" }
  , { title: "Active Users", value: "2,350", change: "+15.2%", trend: "up" }
  , { title: "New Signups", value: "1,234", change: "-5.4%", trend: "down" }
  , { title: "Conversion Rate", value: "3.2%", change: "+2.1%", trend: "up" }
  ]

monthlyData :: Array ChartData
monthlyData =
  [ { label: "Jan", value: 65, color: "bg-chart-1 hover:opacity-80" }
  , { label: "Feb", value: 45, color: "bg-chart-2 hover:opacity-80" }
  , { label: "Mar", value: 78, color: "bg-chart-3 hover:opacity-80" }
  , { label: "Apr", value: 52, color: "bg-chart-4 hover:opacity-80" }
  , { label: "May", value: 88, color: "bg-chart-5 hover:opacity-80" }
  , { label: "Jun", value: 74, color: "bg-chart-1 hover:opacity-80" }
  , { label: "Jul", value: 95, color: "bg-chart-2 hover:opacity-80" }
  , { label: "Aug", value: 68, color: "bg-chart-3 hover:opacity-80" }
  ]

mkAnalytics :: Effect (ReactComponent {})
mkAnalytics = reactComponent "Analytics" \_ -> React.do
  pure $ R.main { className: "p-6 space-y-6" }
    [ R.div { className: "grid gap-4 md:grid-cols-2 lg:grid-cols-4" }
        (mapWithIndex renderStatCard statsCards)
    , R.div { className: "grid gap-4 md:grid-cols-2" }
        [ card {}
            [ cardHeader {}
                [ cardTitle {} [ R.text "Monthly Revenue" ]
                , cardDescription {} [ R.text "Revenue trends over the past 8 months" ]
                ]
            , cardContent {}
                [ renderBarChart monthlyData ]
            ]
        , card {}
            [ cardHeader {}
                [ cardTitle {} [ R.text "Recent Activity" ]
                , cardDescription {} [ R.text "Latest actions in your account" ]
                ]
            , cardContent {}
                [ R.div { className: "space-y-4" }
                    [ activityItem "New user registered" "2 minutes ago"
                    , activityItem "Payment received" "15 minutes ago"
                    , activityItem "Server maintenance completed" "1 hour ago"
                    , activityItem "New feature deployed" "3 hours ago"
                    , activityItem "Weekly report generated" "5 hours ago"
                    ]
                ]
            ]
        ]
    ]
  where
  renderBarChart :: Array ChartData -> JSX
  renderBarChart chartData =
    R.div { className: "flex items-end gap-3 h-48" }
      (map renderBar chartData)

  renderBar :: ChartData -> JSX
  renderBar d =
    R.div { key: d.label, className: "flex flex-col items-center flex-1 h-full group" }
      [ R.div { className: "flex-1 w-full flex items-end" }
          [ R.div
              { className: "w-full rounded-t transition-all duration-200 cursor-pointer hover:scale-105 " <> d.color
              , style: R.css { height: show d.value <> "%" }
              , title: d.label <> ": $" <> show (d.value * 500)
              }
              []
          ]
      , R.span { className: "text-xs text-muted-foreground mt-2 group-hover:text-foreground transition-colors" }
          [ R.text d.label ]
      ]

  activityItem :: String -> String -> JSX
  activityItem title time =
    R.div { className: "flex items-center gap-4" }
      [ R.div { className: "h-2 w-2 rounded-full bg-primary" } []
      , R.div { className: "flex-1" }
          [ R.p { className: "text-sm font-medium" } [ R.text title ]
          , R.p { className: "text-xs text-muted-foreground" } [ R.text time ]
          ]
      ]

renderStatCard :: Int -> StatCard -> JSX
renderStatCard idx stat =
  card { key: show idx }
    [ cardHeader { className: "flex flex-row items-center justify-between space-y-0 pb-2" }
        [ cardTitle { className: "text-sm font-medium" }
            [ R.text stat.title ]
        , statIcon stat.title
        ]
    , cardContent {}
        [ R.div { className: "text-2xl font-bold" } [ R.text stat.value ]
        , R.p { className: "text-xs " <> trendColor stat.trend }
            [ trendIcon stat.trend
            , R.text $ " " <> stat.change <> " from last month"
            ]
        ]
    ]
  where
  statIcon :: String -> JSX
  statIcon = case _ of
    "Total Revenue" -> makeIcon dollarSign { className: "h-4 w-4 text-muted-foreground" }
    "Active Users" -> makeIcon users { className: "h-4 w-4 text-muted-foreground" }
    _ -> makeIcon activity { className: "h-4 w-4 text-muted-foreground" }

  trendColor :: String -> String
  trendColor = case _ of
    "up" -> "text-green-500"
    "down" -> "text-red-500"
    _ -> "text-muted-foreground"

  trendIcon :: String -> JSX
  trendIcon = case _ of
    "up" -> makeIcon trendingUp { className: "h-3 w-3 inline" }
    "down" -> makeIcon trendingDown { className: "h-3 w-3 inline" }
    _ -> R.text ""
