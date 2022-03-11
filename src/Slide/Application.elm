module Slide.Application exposing (Application(..), DisplayApplication, swap, tick, view)

import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (style)
import Html.Parser
import Html.Parser.Util
import Json.Decode as Decode
import Json.Encode as Encode


type Application
    = FakeBrowser String (List Html.Parser.Node)
    | FakeBrowserWithConsole String (List Html.Parser.Node) (List String)


type DisplayApplication
    = DisplayApplication Application


encode : Application -> Encode.Value
encode application =
    case application of
        FakeBrowser url content ->
            Encode.object
                [ ( "type", Encode.string "fakeBrowser" )
                , ( "url", Encode.string url )
                , ( "content", Encode.string <| String.join "" <| List.map Html.Parser.nodeToString content )
                ]

        FakeBrowserWithConsole url content errors ->
            Encode.object
                [ ( "type", Encode.string "fakeBrowserWithConsole" )
                , ( "url", Encode.string url )
                , ( "content", Encode.string <| String.join "" <| List.map Html.Parser.nodeToString content )
                , ( "errors", Encode.list Encode.string errors )
                ]


decoder : Decode.Decoder Application
decoder =
    let
        contentDecoder =
            Decode.string
                |> Decode.andThen
                    (\content ->
                        case Html.Parser.run content of
                            Ok nodes ->
                                Decode.succeed nodes

                            Err deadEnds ->
                                Decode.fail "The HTML doesn't seem to be valid"
                    )
    in
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\type_ ->
                case type_ of
                    "fakeBrowser" ->
                        Decode.map2 FakeBrowser
                            (Decode.field "url" Decode.string)
                            (Decode.field "content" contentDecoder)

                    "fakeBrowserWithConsole" ->
                        Decode.map3 FakeBrowserWithConsole
                            (Decode.field "title" Decode.string)
                            (Decode.field "content" contentDecoder)
                            (Decode.field "errors" <| Decode.list Decode.string)

                    _ ->
                        Decode.fail <| "Type " ++ type_ ++ " is not a valid type for an Application slide"
            )


browserFrame : String -> List (Html msg) -> Html msg
browserFrame url content =
    div
        [ style "border-radius" "0.6rem"
        , style "overflow" "hidden"
        , style "box-shadow" "rgba(149, 157, 165, 0.2) 0px 8px 24px"
        , style "height" "100%"
        , style "display" "flex"
        , style "flex-direction" "column"
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
        , div
            [ style "padding" "4rem"
            , style "flex-grow" "1"
            ]
            content
        ]


browserFrameWithConsole : String -> List (Html msg) -> List String -> Html msg
browserFrameWithConsole url content errors =
    browserFrame url <|
        [ div
            [ style "display" "flex"
            , style "margin" "-4rem"
            , style "height" "calc(100% + 8rem)"
            ]
            [ div
                [ style "padding" "4rem"
                , style "flex-grow" "1"
                ]
                content
            , ul
                [ style "border-left" "1px lightgray solid"
                , style "width" "30%"
                ]
              <|
                List.map
                    (\error ->
                        li
                            [ style "color" "red"
                            , style "background" "bisque"
                            , style "padding" "1rem"
                            , style "width" "100%"
                            ]
                            [ text error ]
                    )
                    errors
            ]
        ]


view : DisplayApplication -> Html msg
view (DisplayApplication application) =
    case application of
        FakeBrowser url content ->
            browserFrame url (Html.Parser.Util.toVirtualDom content)

        FakeBrowserWithConsole url content errors ->
            browserFrameWithConsole url (Html.Parser.Util.toVirtualDom content) errors


swap : Application -> Application -> DisplayApplication
swap from to =
    DisplayApplication to


tick : Float -> DisplayApplication -> DisplayApplication
tick delta title =
    title
