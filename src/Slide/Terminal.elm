module Slide.Terminal exposing (Color(..), DisplayTerminal, Line(..), Terminal, swap, tick, view)

import Color
import Html exposing (Html, div, li, span, text, ul)
import Html.Attributes exposing (style)
import Message exposing (Message)


type Color
    = Default
    | White
    | Red
    | Orange
    | Yellow
    | Green
    | Blue
    | Purple
    | Brown


type alias Block =
    ( Color, String )


type Line
    = Command (List Block)
    | Result (List Block)


type alias Terminal =
    ( String, List Line )


type DisplayTerminal
    = DisplayTerminal Terminal


view : DisplayTerminal -> Html Message
view (DisplayTerminal ( user, lines )) =
    let
        color : Color -> String -> Html Message
        color col cont =
            let
                externalColor =
                    case col of
                        Default ->
                            Color.white

                        White ->
                            Color.white

                        Red ->
                            Color.red

                        Orange ->
                            Color.orange

                        Yellow ->
                            Color.yellow

                        Green ->
                            Color.green

                        Blue ->
                            Color.blue

                        Purple ->
                            Color.purple

                        Brown ->
                            Color.brown
            in
            span [ style "color" (Color.toCssString externalColor) ] [ text cont ]

        terminalFrame : Html Message -> Html Message
        terminalFrame content =
            div
                [ style "border-radius" "0.6rem"
                , style "overflow" "hidden"
                , style "box-shadow" "rgba(149, 157, 165, 0.2) 0px 8px 24px"
                , style "height" "100%"
                , style "background" "black"
                , style "color" "white"
                ]
                [ div
                    [ style "padding" "1.1rem 1.4rem"
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
                    ]
                , div [ style "padding" "2rem 4rem" ]
                    [ content ]
                ]
    in
    terminalFrame
        (ul [] <|
            List.map
                (\line ->
                    li [] <|
                        case line of
                            Command command ->
                                List.append
                                    [ color Green user
                                    , color Default ":"
                                    , color Blue "~"
                                    , color Default "$ "
                                    ]
                                    (List.map (\( c, s ) -> color c s) command)

                            Result result ->
                                List.map (\( c, s ) -> color c s) result
                )
                lines
        )


swap : Terminal -> Terminal -> DisplayTerminal
swap from to =
    DisplayTerminal to


tick : Float -> DisplayTerminal -> DisplayTerminal
tick delta terminal =
    terminal
