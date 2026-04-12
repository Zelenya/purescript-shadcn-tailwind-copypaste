module Components.UsersTable
  ( mkUsersTable
  ) where

import Prelude

import Beta.DOM as R
import Data.Newtype (wrap)
import Foreign.Shadcn.Card (card, cardContent, cardDescription, cardHeader, cardTitle)
import Foreign.Shadcn.Table (table, tableBody, tableCell, tableHead, tableHeader, tableRow)
import LucideReact (mail, makeIcon)
import React.Basic.Hooks (JSX, ReactComponent, reactComponent)
import Effect (Effect)
import Service.Routing.Routes (printRoute)
import Service.Routing.Routes as Routes

type User =
  { id :: Int
  , name :: String
  , email :: String
  , role :: String
  }

sampleUsers :: Array User
sampleUsers =
  [ { id: 1, name: "Alice Johnson", email: "alice@example.com", role: "Admin" }
  , { id: 2, name: "Bob Smith", email: "bob@example.com", role: "Editor" }
  , { id: 3, name: "Carol Williams", email: "carol@example.com", role: "Viewer" }
  , { id: 4, name: "David Brown", email: "david@example.com", role: "Editor" }
  , { id: 5, name: "Eva Martinez", email: "eva@example.com", role: "Admin" }
  , { id: 6, name: "Frank Lee", email: "frank@example.com", role: "Viewer" }
  ]

mkUsersTable :: Effect (ReactComponent {})
mkUsersTable = reactComponent "UsersTable" \_ -> React.do
  pure $ R.main { className: "p-6" }
    [ card {}
        [ cardHeader {}
            [ cardTitle {} [ R.text "Users" ]
            , cardDescription {} [ R.text "Manage your team members and their roles." ]
            ]
        , cardContent {}
            [ table {}
                [ tableHeader {}
                    [ tableRow {}
                        [ tableHead {} [ R.text "Name" ]
                        , tableHead {} [ R.text "Email" ]
                        , tableHead {} [ R.text "Role" ]
                        ]
                    ]
                , tableBody {} $ map renderUser sampleUsers
                ]
            ]
        ]
    ]

renderUser :: User -> JSX
renderUser user =
  tableRow { key: show user.id }
    [ tableCell { className: "font-medium" } [ R.text user.name ]
    , tableCell {}
        [ R.a
            { href: printRoute (Routes.User (wrap $ show user.id))
            , className: "flex items-center gap-2 text-primary hover:underline"
            }
            [ makeIcon mail { className: "h-4 w-4" }
            , R.text user.email
            ]
        ]
    , tableCell {}
        [ R.span { className: roleClass user.role }
            [ R.text user.role ]
        ]
    ]
  where
  roleClass :: String -> String
  roleClass = case _ of
    "Admin" -> "inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold bg-primary text-primary-foreground"
    "Editor" -> "inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold bg-secondary text-secondary-foreground"
    _ -> "inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold"
