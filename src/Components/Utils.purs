module Components.Utils
  ( descriptionItem
  , humanizeBoolean
  ) where

import Beta.DOM as R
import React.Basic (JSX)

descriptionItem ∷ String → String → JSX
descriptionItem title value =
  R.div
    { className: "flex items-center justify-between" }
    [ R.dt { className: "text-muted-foreground" } [ R.text title ]
    , R.dd {} [ R.text value ]
    ]

humanizeBoolean :: Boolean -> String
humanizeBoolean = case _ of
  true -> "Yes"
  false -> "No"
