module File exposing (DisplayFile, File(..), swap, tick, view)

import Diff exposing (Change(..))
import Extension exposing (Extension(..))
import Html exposing (Html, code, div, pre, text)
import Html.Attributes exposing (class, style)
import Icon
import Message exposing (Message)
import SyntaxHighlight exposing (oneDark, toBlockHtml, useTheme)


transitionDuration =
    200


type File
    = None
    | SelectedFile
        { name : String
        , extension : Extension
        , content : String
        }


type DisplayFile
    = DisplayFile
        { name : Transition String
        , extension : Transition Extension
        , content : List (Transition String)
        }


type Transition a
    = Replace Float a a
    | Remove Float a
    | Add Float a
    | Visible a
    | Hidden


swap : File -> File -> DisplayFile
swap from to =
    let
        diff fromContent toContent =
            Diff.diffLines fromContent toContent
                |> List.map
                    (\change ->
                        case change of
                            Added line ->
                                Add 0 line

                            Removed line ->
                                Remove 0 line

                            NoChange line ->
                                Visible line
                    )

        ( n, e, c ) =
            case ( from, to ) of
                ( None, None ) ->
                    ( Hidden
                    , Hidden
                    , []
                    )

                ( None, SelectedFile { name, extension, content } ) ->
                    ( Add 0 name
                    , Add 0 extension
                    , diff "" content
                    )

                ( SelectedFile { name, extension, content }, None ) ->
                    ( Remove 0 name
                    , Remove 0 extension
                    , diff content ""
                    )

                ( SelectedFile fromFile, SelectedFile toFile ) ->
                    ( Replace 0 fromFile.name toFile.name
                    , Replace 0 fromFile.extension toFile.extension
                    , diff fromFile.content toFile.content
                    )
    in
    DisplayFile
        { name = n
        , extension = e
        , content = c
        }


view : DisplayFile -> Html Message
view (DisplayFile file) =
    let
        rollingTransition : Transition a -> Float -> (a -> Html Message) -> Html Message
        rollingTransition transition size viewTransition =
            case transition of
                Hidden ->
                    div [] []

                Visible element ->
                    div [ style "height" (String.fromFloat size ++ "rem") ] [ viewTransition element ]

                Replace percent oldElement newElement ->
                    div
                        [ style "display" "flex"
                        , style "flex-direction" "column"
                        ]
                        [ div
                            [ style "height" (String.fromFloat ((1 - percent) * size) ++ "rem")
                            , style "overflow" "hidden"
                            ]
                            [ viewTransition oldElement ]
                        , div
                            [ style "height" (String.fromFloat (percent * size) ++ "rem")
                            , style "overflow" "hidden"
                            ]
                            [ viewTransition newElement ]
                        ]

                Remove percent element ->
                    div [ style "height" (String.fromFloat ((1 - percent) * size) ++ "rem") ] [ viewTransition element ]

                Add percent element ->
                    div [ style "height" (String.fromFloat (percent * size) ++ "rem") ] [ viewTransition element ]

        typingTransition : List (Transition String) -> String
        typingTransition lines =
            List.map typingTransitionLine lines
                |> List.foldr
                    (\maybeLine content ->
                        case maybeLine of
                            Just line ->
                                line :: content

                            Nothing ->
                                content
                    )
                    []
                |> String.join "\n"

        typingTransitionLine : Transition String -> Maybe String
        typingTransitionLine transition =
            case transition of
                Hidden ->
                    Nothing

                Visible line ->
                    Just line

                Replace percent oldLine newLine ->
                    Just newLine

                Remove percent line ->
                    Just <| String.left ((1 - percent) * (String.length line |> toFloat) |> floor) line

                Add percent line ->
                    Just <| String.left (percent * (String.length line |> toFloat) |> floor) line

        currentExtension : Transition Extension -> Extension
        currentExtension transition =
            case transition of
                Hidden ->
                    JSON

                Visible extension ->
                    extension

                Replace _ _ extension ->
                    extension

                Remove _ extension ->
                    extension

                Add _ extension ->
                    extension

        syntax extension =
            case currentExtension extension of
                JSON ->
                    SyntaxHighlight.json

                HTML ->
                    SyntaxHighlight.xml

                JSX ->
                    SyntaxHighlight.javascript

                JavaScript ->
                    SyntaxHighlight.javascript
    in
    div
        [ style "background" "#21252b"
        , style "flex-grow" "2"
        , style "padding" "2rem"
        , style "display" "flex"
        , style "flex-direction" "column"
        , style "gap" "3rem"
        ]
        [ div
            [ style "display" "flex"
            , style "gap" "0.5rem"
            , style "align-items" "center"
            , style "justify-content" "baseline"
            , style "overflow" "hidden"
            , style "color" "#9da5b4"
            , style "fill" "#9da5b4"
            , style "height" "1.25rem"
            ]
            [ rollingTransition file.extension 1 Extension.view, rollingTransition file.name 1.25 text ]
        , pre
            [ style "margin" "0"
            , style "padding" "0"
            , style "background" "transparent"
            ]
            [ typingTransition file.content
                |> syntax file.extension
                |> Result.map (toBlockHtml (Just 1))
                |> Result.withDefault
                    (pre [] [ code [] [ typingTransition file.content |> text ] ])
            ]
        ]


tick : Float -> DisplayFile -> DisplayFile
tick delta (DisplayFile file) =
    let
        tickTransition : Transition a -> Transition a
        tickTransition transition =
            case transition of
                Hidden ->
                    Hidden

                Visible element ->
                    Visible element

                Replace percent from to ->
                    if percent + (delta / transitionDuration) > 1 then
                        Visible to

                    else
                        Replace (percent + (delta / transitionDuration)) from to

                Remove percent element ->
                    if percent + (delta / transitionDuration) > 1 then
                        Hidden

                    else
                        Remove (percent + (delta / transitionDuration)) element

                Add percent element ->
                    if percent + (delta / transitionDuration) > 1 then
                        Visible element

                    else
                        Add (percent + (delta / transitionDuration)) element
    in
    DisplayFile
        { file
            | name = tickTransition file.name
            , extension = tickTransition file.extension
            , content = List.map tickTransition file.content
        }
