module Components.UserPage
  ( mkUserPage
  ) where

import Prelude

import Beta.DOM as R
import Components.ClipboardButton (mkClipboardButton)
import Components.Utils (descriptionItem, humanizeBoolean)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), maybe)
import Data.Newtype (un)
import Effect (Effect)
import Effect.Aff (Error, attempt)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Foreign.Shadcn.Button (button)
import Foreign.Shadcn.Card (card, cardContent, cardHeader, cardTitle)
import Foreign.Shadcn.Command (command, commandEmpty, commandGroup, commandInput, commandItem, commandList, commandSeparator)
import Foreign.Shadcn.Dialog (dialog, dialogContent, dialogDescription, dialogFooter, dialogHeader, dialogTitle, dialogTrigger)
import Foreign.Shadcn.Input (input)
import Foreign.Shadcn.Label (label)
import Foreign.Shadcn.Popover (popover, popoverContent, popoverTrigger)
import Foreign.Shadcn.Skeleton (skeleton)
import LucideReact (activity, chevronDown, link, mail, makeIcon, refresh, users, wallet)
import React.Basic.DOM.Events (preventDefault)
import React.Basic.Events (handler, handler_)
import React.Basic.Hooks (JSX, ReactComponent, element, reactComponent, useState', (/\))
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)
import Service.ApiClient (Product, ApiClient, User)
import Types (Email(..), UserId(..))

type BaseProps r = (apiClient :: ApiClient | r)

type UserPageProps =
  { userId :: UserId
  , onError :: String -> Error -> Effect Unit
  | BaseProps ()
  }

mkUserPage :: Effect (ReactComponent UserPageProps)
mkUserPage = do
  actions <- mkActionsCard
  clipboards <- mkClipboardsCard

  reactComponent "UserPage" \{ apiClient, userId, onError } -> React.do
    user /\ setUser <- useState' Nothing
    product /\ setProduct <- useState' Nothing

    -- IMPROVEMENT: Use something like Tanstack Query to fetch data
    useAff userId do
      maybeUser <- attempt $ apiClient.getUser userId
      liftEffect case maybeUser of
        Left error -> onError "Couldn't fetch the user" error
        Right u -> setUser $ Just u
      pure unit

    useAff userId do
      maybeSubscription <- attempt $ apiClient.getProducts userId
      liftEffect case maybeSubscription of
        Left error -> onError "Couldn't fetch the products" error
        Right sub -> setProduct $ Just sub
      pure unit

    pure $ R.main
      { className: "flex flex-1 flex-col gap-4 p-4 md:gap-8 md:p-8" }
      [ R.div
          { className: "grid gap-4 md:grid-cols-2 md:gap-8 lg:grid-cols-3" }
          [ maybe skelly userInfo user -- This card shows a simple user card
          , maybe skelly productInfo product -- This card won't show, because the product endpoint always fails
          , skelly -- I didn't even try here, always a skeleton
          ]
      , R.div
          { className: "grid gap-4 md:gap-8 lg:grid-cols-2 xl:grid-cols-3" }
          [ element clipboards { apiClient, userId } -- This card demos clipboard component
          , element actions { apiClient, userId } -- This card demos dialog and commands
          ]
      ]
  where
  skelly =
    card {}
      [ cardHeader {} [ skeleton { className: "h-8" } ]
      , cardContent {}
          [ R.div { className: "flex flex-col space-y-3" }
              [ skeleton { className: "h-[80px] rounded-xl" }
              ]
          ]
      ]

  userInfo :: User -> JSX
  userInfo user = card {}
    [ cardHeader
        { className: "flex flex-row items-center justify-between space-y-0 pb-2" }
        [ cardTitle
            { className: "text-sm font-medium" }
            [ R.text $ un Email user.email ]
        , makeIcon users
            { className: "h-4 w-4 text-muted-foreground" }
        ]
    , cardContent
        {}
        [ R.dl { className: "text-xs grid gap-2" }
            [ descriptionItem "Name" user.name
            , descriptionItem "User id" (un UserId user.id)
            , descriptionItem "Something else" "Unknown"
            ]
        ]
    ]

  productInfo :: Product -> JSX
  productInfo product =
    card {}
      [ cardHeader
          { className: "flex flex-row items-center justify-between space-y-0 pb-2" }
          [ cardTitle
              { className: "text-sm font-medium" }
              [ R.text "Subscriptions" ]
          , makeIcon activity
              { className: "h-4 w-4 text-muted-foreground" }
          ]
      , cardContent { className: "grid gap-2" }
          [ R.p
              { className: "text-xl font-bold" }
              [ R.text product.name ]
          , R.dl
              { className: "text-xs grid gap-2" }
              [ descriptionItem "Subscription id" product.id
              , descriptionItem "Autorenew" (humanizeBoolean product.autorenew)
              , descriptionItem "On free trial" "N/A"
              ]
          ]
      ]

type ClipboardProps =
  { userId :: UserId
  | BaseProps ()
  }

mkClipboardsCard :: Effect (ReactComponent ClipboardProps)
mkClipboardsCard = do
  clipboardButton <- mkClipboardButton
  reactComponent "ClipboardInfo" \props -> React.do
    pure $ card {}
      [ cardHeader
          { className: "flex flex-row items-center justify-between space-y-0 pb-2" }
          [ cardTitle
              { className: "text-sm font-medium" }
              [ R.text "Finding the right thing to copy is a skill"
              ]
          ]
      , cardContent { className: "flex flex-col gap-2 text-muted-foreground" }
          [ R.div { className: "flex flex-row justify-between items-center" }
              [ R.text "Click the button to copy the user id"
              , R.div
                  { className: "flex items-center gap-2" }
                  [ element clipboardButton { text: un UserId props.userId } ]
              ]
          , R.div { className: "flex flex-row justify-between items-center" }
              [ R.text "Click to copy the word nothing"
              , R.div
                  { className: "flex items-center gap-2" }
                  [ element clipboardButton { text: "nothing" } ]
              ]
          ]
      ]

type ActionsProps =
  { userId :: UserId
  | BaseProps ()
  }

mkActionsCard :: Effect (ReactComponent ActionsProps)
mkActionsCard = do
  commands <- mkCommandsDemo
  reactComponent "Actions" \props -> React.do
    pure $ card { className: "xl:col-span-2" }
      [ cardHeader
          { className: "flex flex-row items-center" }
          [ element commands props
          ]
      , cardContent
          { className: "grid grid-cols-2 gap-2" }
          [ dialogExample
          , button
              { className: ""
              , variant: "outline"
              }
              [ R.text "Useless button"
              ]
          , button
              { className: ""
              , variant: "destructive"
              }
              [ R.text "Red useless user"
              ]
          , button
              { className: ""
              , variant: "outline"
              }
              [ R.text "Another useless button"
              ]
          ]
      ]
  where
  dialogExample = dialog {}
    [ dialogTrigger { asChild: true }
        [ button
            { variant: "secondary"
            }
            [ R.text "Open a dialog demo"
            ]
        ]
    , dialogContent { className: "dark bg-background text-foreground sm:max-w-[425px]" }
        [ dialogHeader {}
            [ dialogTitle { className: "text-foreground" }
                [ R.text "This is an example of a dialog"
                ]
            , dialogDescription {}
                [ R.text "And this is a description. It's not very useful"
                ]
            ]
        , R.div { className: "grid gap-4 py-4" }
            [ R.div { className: "grid grid-cols-4 items-center gap-4" }
                [ label { htmlFor: "name", className: "text-right text-foreground" }
                    [ R.text "Name"
                    ]
                , input { id: "name", className: "col-span-3", placeholder: "Name" }
                ]
            , R.div { className: "grid grid-cols-4 items-center gap-4" }
                [ label { htmlFor: "something", className: "text-right text-foreground" }
                    [ R.text "Something"
                    ]
                , input { id: "something", className: "col-span-3", placeholder: "Something else" }
                ]
            ]
        , dialogFooter {}
            [ button
                { type: "submit"
                , onClick: handler_ do log "You clicked the button!"
                }
                [ R.text "Log simple message"
                ]
            ]
        ]
    ]

mkCommandsDemo :: Effect (ReactComponent ActionsProps)
mkCommandsDemo = do
  reactComponent "OtherActions" \_ -> React.do
    open /\ setOpen <- useState' false

    pure $ popover { open, onOpenChange: setOpen }
      [ popoverTrigger { asChild: true }
          [ button
              { className: "ml-auto gap-1"
              , variant: "secondary"
              , size: "sm"
              , onClick: handler preventDefault $ \_ -> setOpen (not open)
              }
              [ R.div { className: "flex items-center gap-1" }
                  [ makeIcon chevronDown { className: "h-4 w-4" }
                  , R.text "Other actions"
                  ]
              ]
          ]
      , popoverContent {}
          [ command { className: "rounded-lg shadow-md" }
              [ commandInput { placeholder: "Type a command or search..." }
              , commandList {}
                  [ commandEmpty {} [ R.text "No results found." ]
                  , commandGroup { heading: "Email operations" }
                      [ commandItem
                          { onSelect: handler_ $ log "Reset password" *> setOpen false
                          }
                          [ makeIcon mail { className: "mr-2 h-4 w-4" }
                          , R.text "Reset password"
                          ]
                      , commandItem
                          { onSelect: handler_ $ log "Send another email" *> setOpen false
                          }
                          [ makeIcon mail { className: "mr-2 h-4 w-4" }
                          , R.text "Send another email"
                          ]
                      ]
                  , commandSeparator {}
                  , commandGroup { heading: "Money operations" }
                      [ commandItem
                          { onSelect: handler_ $ log "Upgrade something" *> setOpen false }
                          [ makeIcon wallet { className: "mr-2 h-4 w-4" }
                          , R.text "Upgrade something"
                          ]
                      , commandItem
                          { onSelect: handler_ $ log "Add a dollar" *> setOpen false }
                          [ makeIcon wallet { className: "mr-2 h-4 w-4" }
                          , R.text "Add a dollar"
                          ]
                      , commandItem
                          { onSelect: handler_ $ log "Take a dollar" *> setOpen false }
                          [ makeIcon wallet { className: "mr-2 h-4 w-4" }
                          , R.text "Take a dollar"
                          ]
                      , commandItem
                          { onSelect: handler_ $ log "Resync all channel data" *> setOpen false }
                          [ makeIcon refresh { className: "mr-2 h-4 w-4" }
                          , R.text "Resync products"
                          ]
                      ]
                  , commandSeparator {}
                  , commandGroup { heading: "" }
                      [ commandItem
                          { onSelect: handler_ $ log "Link a product" *> setOpen false }
                          [ makeIcon link { className: "mr-2 h-4 w-4" }
                          , R.text "Link a product"
                          ]
                      , commandItem
                          { onSelect: handler_ $ log "Link another id" *> setOpen false }
                          [ makeIcon link { className: "mr-2 h-4 w-4" }
                          , R.text "Link another id"
                          ]
                      ]
                  ]
              ]
          ]
      ]
