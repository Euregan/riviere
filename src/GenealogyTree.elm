module GenealogyTree exposing (..)

import Html exposing (Html)
import Html.Attributes
import Message exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)


box : ( Int, Int ) -> Maybe String -> Svg Message
box ( centerX, centerY ) name =
    let
        boxWidth =
            300

        boxHeight =
            100

        margin =
            20

        picture =
            case name of
                Just n ->
                    image
                        [ xlinkHref <| "/public/" ++ n ++ ".jpg"
                        , x <| String.fromFloat <| toFloat centerX - toFloat boxWidth / 2
                        , y <| String.fromFloat <| toFloat centerY - toFloat boxHeight / 2
                        , height <| String.fromInt boxHeight
                        , width <| String.fromInt boxHeight
                        ]
                        []

                Nothing ->
                    image
                        [ xlinkHref <| "/public/plus.svg"
                        , x <| String.fromFloat <| toFloat centerX - toFloat boxWidth / 2
                        , y <| String.fromFloat <| toFloat centerY - toFloat boxHeight / 2
                        , height <| String.fromInt boxHeight
                        , width <| String.fromInt boxHeight
                        ]
                        []

        txt =
            case name of
                Just n ->
                    text_
                        [ x <| String.fromFloat <| toFloat centerX - toFloat boxWidth / 2 + toFloat boxHeight + toFloat margin
                        , y <| String.fromInt centerY
                        ]
                        [ text n ]

                Nothing ->
                    text ""
    in
    g []
        [ rect
            [ x <| String.fromFloat <| toFloat centerX - toFloat boxWidth / 2
            , y <| String.fromFloat <| toFloat centerY - toFloat boxHeight / 2
            , width <| String.fromInt boxWidth
            , height <| String.fromInt boxHeight
            , rx "7"
            , fill "white"
            , strokeWidth "1"
            , stroke "#dbdfe2"
            ]
            []
        , picture
        , txt
        ]


link : ( Int, Int ) -> ( Int, Int ) -> Svg Message
link ( fromX, fromY ) ( toX, toY ) =
    Svg.path
        [ d <| "M " ++ String.fromInt fromX ++ " " ++ String.fromInt fromY ++ " L " ++ String.fromInt toX ++ " " ++ String.fromInt toY
        , stroke "black"
        , strokeWidth "2"
        ]
        []


display : Html Message
display =
    svg
        [ viewBox "0 0 2000 1000"
        , Html.Attributes.style "width" "100%"
        , Html.Attributes.style "height" "100%"
        ]
        [ link ( 1000, 650 ) ( 750, 400 )
        , link ( 1000, 650 ) ( 1250, 400 )
        , link ( 1250, 400 ) ( 1650, 150 )
        , link ( 1250, 400 ) ( 1250, 150 )
        , box ( 1000, 650 ) (Just "Frédéric Allard")
        , box ( 750, 400 ) (Just "Sébastien Lambert")
        , box ( 1250, 400 ) (Just "Alice Allard")
        , box ( 1650, 150 ) Nothing
        , box ( 1250, 150 ) Nothing
        ]
