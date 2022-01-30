module Application exposing (Application(..), DisplayApplication, swap, tick, view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Message exposing (Message)


type Application
    = FakeBrowser String (Html Message)


type DisplayApplication
    = DisplayApplication Application


browserFrame : String -> Html Message -> Html Message
browserFrame url content =
    div
        [ style "border-radius" "0.6rem"
        , style "overflow" "hidden"
        , style "box-shadow" "rgba(149, 157, 165, 0.2) 0px 8px 24px"
        , style "height" "100%"
        ]
        [ div
            [ style "background" "#d3d3d1"
            , style "padding" "1.1rem 1.4rem"
            , style "display" "flex"
            , style "gap" "1rem"
            , style "align-items" "center"
            ]
            [ div
                [ style "display" "flex"
                , style "gap" "0.5rem"
                , style "align-items" "center"
                ]
                [ div
                    [ style "background" "#e26d65"
                    , style "border-radius" "50%"
                    , style "width" "1rem"
                    , style "height" "1rem"
                    ]
                    []
                , div
                    [ style "background" "#e0ac3a"
                    , style "border-radius" "50%"
                    , style "width" "1rem"
                    , style "height" "1rem"
                    ]
                    []
                , div
                    [ style "background" "#86c046"
                    , style "border-radius" "50%"
                    , style "width" "1rem"
                    , style "height" "1rem"
                    ]
                    []
                ]
            , div
                [ style "background" "white"
                , style "padding" "0.3rem 0.5rem"
                , style "flex-grow" "1"
                ]
                [ text url ]
            ]
        , div [ style "padding" "4rem" ]
            [ content ]
        ]


view : DisplayApplication -> Html Message
view (DisplayApplication application) =
    case application of
        FakeBrowser url content ->
            browserFrame url content


swap : Application -> Application -> DisplayApplication
swap from to =
    DisplayApplication to


tick : Float -> DisplayApplication -> DisplayApplication
tick delta title =
    title
