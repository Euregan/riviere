module Slide.Terminal exposing (Color(..), DisplayTerminal, Line(..), Terminal, swap, tick, view)

import Color
import Html exposing (Html, div, li, span, text, ul)
import Html.Attributes exposing (style)
import Json.Decode as Decode
import Json.Encode as Encode
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


encode : Terminal -> Encode.Value
encode ( user, lines ) =
    let
        encodeColor : Color -> Encode.Value
        encodeColor color =
            case color of
                Default ->
                    Encode.string "default"

                White ->
                    Encode.string "white"

                Red ->
                    Encode.string "red"

                Orange ->
                    Encode.string "orange"

                Yellow ->
                    Encode.string "yellow"

                Green ->
                    Encode.string "green"

                Blue ->
                    Encode.string "blue"

                Purple ->
                    Encode.string "purple"

                Brown ->
                    Encode.string "brown"

        encodeBlock : Block -> Encode.Value
        encodeBlock ( color, text ) =
            Encode.object
                [ ( "color", encodeColor color )
                , ( "text", Encode.string text )
                ]

        encodeLine : Line -> Encode.Value
        encodeLine line =
            case line of
                Command blocks ->
                    Encode.object
                        [ ( "type", Encode.string "command" )
                        , ( "blocks", Encode.list encodeBlock blocks )
                        ]

                Result blocks ->
                    Encode.object
                        [ ( "type", Encode.string "result" )
                        , ( "blocks", Encode.list encodeBlock blocks )
                        ]
    in
    Encode.object
        [ ( "type", Encode.string "terminal" )
        , ( "user", Encode.string user )
        , ( "lines", Encode.list encodeLine lines )
        ]


decoder : Decode.Decoder Terminal
decoder =
    let
        colorDecoder : Decode.Decoder Color
        colorDecoder =
            Decode.string
                |> Decode.andThen
                    (\color ->
                        case color of
                            "default" ->
                                Decode.succeed Default

                            "white" ->
                                Decode.succeed White

                            "red" ->
                                Decode.succeed Red

                            "orange" ->
                                Decode.succeed Orange

                            "yellow" ->
                                Decode.succeed Yellow

                            "green" ->
                                Decode.succeed Green

                            "blue" ->
                                Decode.succeed Blue

                            "purple" ->
                                Decode.succeed Purple

                            "brown" ->
                                Decode.succeed Brown

                            _ ->
                                Decode.fail <| "Color " ++ color ++ " is not supported"
                    )

        blockDecoder : Decode.Decoder Block
        blockDecoder =
            Decode.map2 (\color text -> ( color, text ))
                (Decode.field "color" colorDecoder)
                (Decode.field "text" Decode.string)

        lineDecoder : Decode.Decoder Line
        lineDecoder =
            Decode.field "type" Decode.string
                |> Decode.andThen
                    (\type_ ->
                        case type_ of
                            "command" ->
                                Decode.map Command
                                    (Decode.field "blocks" <| Decode.list blockDecoder)

                            "result" ->
                                Decode.map Result
                                    (Decode.field "blocks" <| Decode.list blockDecoder)

                            _ ->
                                Decode.fail <| "Type " ++ type_ ++ " is not a valid type for a Terminal's line"
                    )
    in
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\type_ ->
                case type_ of
                    "terminal" ->
                        Decode.map2 (\user lines -> ( user, lines ))
                            (Decode.field "user" Decode.string)
                            (Decode.field "lines" (Decode.list lineDecoder))

                    _ ->
                        Decode.fail <| "Type " ++ type_ ++ " is not a valid type for a Terminal slide"
            )


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
