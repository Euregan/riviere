module Terminal exposing (DisplayTerminal, Terminal, swap, tick, view)

import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (style)
import Message exposing (Message)


type alias Terminal =
    List String


type DisplayTerminal
    = DisplayTerminal Terminal


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
            , style "gap" "1.5rem"
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
                , style "border-radius" "0.3rem"
                , style "flex-grow" "1"
                ]
                [ text url ]
            ]
        , div [ style "padding" "4rem" ]
            [ content ]
        ]


view : DisplayTerminal -> Html Message
view (DisplayTerminal lines) =
    ul [] <|
        List.map (\line -> li [] [ text line ]) lines


swap : Terminal -> Terminal -> DisplayTerminal
swap from to =
    DisplayTerminal to


tick : Float -> DisplayTerminal -> DisplayTerminal
tick delta terminal =
    terminal
