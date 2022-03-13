module Component.Layout exposing (view)

import Html exposing (..)
import Router exposing (Route(..))


view : List (Html msg) -> List (Html msg)
view content =
    [ nav []
        [ a [ Router.href Home ] [ text "Riviere" ]
        , a [ Router.href Signup ] [ text "Signup" ]
        , a [ Router.href Signin ] [ text "Signin" ]
        ]
    , main_ [] content
    ]
