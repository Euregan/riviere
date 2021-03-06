module Slide.Repository.File exposing (DisplayFile, File(..), decoder, encode, swap, tick, view)

import Diff exposing (Change(..))
import Extension exposing (Extension(..))
import Html exposing (Html, code, div, pre, text)
import Html.Attributes exposing (class, style)
import Icon
import Json.Decode as Decode
import Json.Encode as Encode
import SyntaxHighlight exposing (oneDark, toBlockHtml, useTheme)


transitionDuration =
    200


type File
    = None
    | SelectedFile FileRecord


type alias FileRecord =
    { name : String
    , extension : Extension
    , content : String
    }


type DisplayFile
    = DisplayFile Transition


type Transition
    = Open Float FileRecord
    | Close Float FileRecord
    | Swap Float FileRecord FileRecord
    | Edit
        Float
        { name : String
        , extension : Extension
        , content : List (Change String)
        }
    | Visible FileRecord
    | Hidden


encode : File -> Encode.Value
encode file =
    case file of
        None ->
            Encode.null

        SelectedFile { name, extension, content } ->
            Encode.object
                [ ( "name", Encode.string name )
                , ( "extension", Extension.encode extension )
                , ( "content", Encode.string content )
                ]


decoder : Decode.Decoder File
decoder =
    Decode.oneOf
        [ Decode.map3 (\name extension content -> SelectedFile { name = name, extension = extension, content = content })
            (Decode.field "name" Decode.string)
            (Decode.field "extension" Extension.decoder)
            (Decode.field "content" Decode.string)
        , Decode.null None
        ]


swap : File -> File -> DisplayFile
swap from to =
    let
        diff : String -> String -> List (Change String)
        diff fromContent toContent =
            Diff.diffLines fromContent toContent

        hasDiff : Change String -> Bool
        hasDiff changes =
            True

        displayFile : Transition
        displayFile =
            case ( from, to ) of
                ( None, None ) ->
                    Hidden

                ( None, SelectedFile file ) ->
                    Open 0 file

                ( SelectedFile file, None ) ->
                    Close 0 file

                ( SelectedFile fromFile, SelectedFile toFile ) ->
                    if fromFile.name == toFile.name && fromFile.extension == toFile.extension then
                        Edit 0
                            { name = toFile.name
                            , extension = toFile.extension
                            , content = Diff.diffLines fromFile.content toFile.content
                            }

                    else
                        Swap 0 fromFile toFile
    in
    DisplayFile displayFile


view : DisplayFile -> Html msg
view (DisplayFile transition) =
    let
        iconSize =
            1

        titleSize =
            1.25

        ( name, extension, content ) =
            case transition of
                Hidden ->
                    ( text ""
                    , text ""
                    , ""
                    )

                Visible file ->
                    ( rollingTransition titleSize (text file.name)
                    , rollingTransition iconSize (Extension.view file.extension)
                    , file.content
                    )

                Open percent file ->
                    ( rollingTransition (titleSize * percent) (text file.name)
                    , rollingTransition (iconSize * percent) (Extension.view file.extension)
                    , typingTransition percent file.content
                    )

                Close percent file ->
                    ( rollingTransition (titleSize * (1 - percent)) (text file.name)
                    , rollingTransition (iconSize * (1 - percent)) (Extension.view file.extension)
                    , typingTransition (1 - percent) file.content
                    )

                Swap percent fromFile toFile ->
                    ( div
                        [ style "display" "flex"
                        , style "flex-direction" "column"
                        ]
                        [ text fromFile.name
                        , rollingTransition (titleSize * percent) (text toFile.name)
                        ]
                    , div
                        [ style "display" "flex"
                        , style "flex-direction" "column"
                        ]
                        [ Extension.view fromFile.extension
                        , rollingTransition (iconSize * percent) (Extension.view toFile.extension)
                        ]
                    , typingTransition percent toFile.content
                    )

                Edit percent file ->
                    let
                        finalizedContent =
                            List.foldl
                                (\curr acc ->
                                    case curr of
                                        Added line ->
                                            acc ++ "\n" ++ typingTransition percent line

                                        Removed line ->
                                            acc ++ "\n" ++ typingTransition (1 - percent) line

                                        NoChange line ->
                                            acc ++ "\n" ++ line
                                )
                                ""
                                file.content
                    in
                    ( rollingTransition titleSize (text file.name)
                    , rollingTransition iconSize (Extension.view file.extension)
                    , finalizedContent
                    )

        rollingTransition : Float -> Html msg -> Html msg
        rollingTransition size element =
            div
                [ style "height" (String.fromFloat size ++ "rem")
                , style "overflow" "hidden"
                ]
                [ element ]

        typingTransition : Float -> String -> String
        typingTransition percent text =
            String.left (round (percent * toFloat (String.length text))) text

        syntax trans =
            let
                ext =
                    case trans of
                        Open _ file ->
                            file.extension

                        Close _ file ->
                            file.extension

                        Swap _ fromFile toFile ->
                            toFile.extension

                        Edit _ file ->
                            file.extension

                        Visible file ->
                            file.extension

                        Hidden ->
                            JSON
            in
            case ext of
                JSON ->
                    SyntaxHighlight.json

                HTML ->
                    SyntaxHighlight.xml

                JSX ->
                    SyntaxHighlight.javascript

                TSX ->
                    SyntaxHighlight.javascript

                JavaScript ->
                    SyntaxHighlight.javascript

                TypeScript ->
                    SyntaxHighlight.javascript

                Elm ->
                    SyntaxHighlight.elm
    in
    div
        [ style "background" "#21252b"
        , style "flex-grow" "2"
        , style "padding" "2rem"
        , style "display" "flex"
        , style "flex-direction" "column"
        , style "gap" "3rem"
        , style "border-radius" "0.6rem"
        , style "box-shadow" "rgba(149, 157, 165, 0.2) 0px 8px 24px"
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
            [ extension, name ]
        , pre
            [ style "margin" "0"
            , style "padding" "0"
            , style "background" "transparent"
            ]
            [ content
                |> syntax transition
                |> Result.map (toBlockHtml (Just 1))
                |> Result.withDefault
                    (pre [] [ code [] [ text content ] ])
            ]
        ]


tick : Float -> DisplayFile -> DisplayFile
tick delta (DisplayFile transition) =
    let
        updatedTransition =
            case transition of
                Open percent file ->
                    if percent + (delta / transitionDuration) > 1 then
                        Visible file

                    else
                        Open (percent + (delta / transitionDuration)) file

                Close percent file ->
                    if percent + (delta / transitionDuration) > 1 then
                        Hidden

                    else
                        Close (percent + (delta / transitionDuration)) file

                Swap percent fromFile toFile ->
                    if percent + (delta / transitionDuration) > 1 then
                        Visible toFile

                    else
                        Swap (percent + (delta / transitionDuration)) fromFile toFile

                Edit percent file ->
                    if percent + (delta / transitionDuration) > 1 then
                        let
                            finalizedContent =
                                List.foldl
                                    (\curr acc ->
                                        case curr of
                                            Added line ->
                                                acc ++ "\n" ++ line

                                            Removed _ ->
                                                acc

                                            NoChange line ->
                                                acc ++ "\n" ++ line
                                    )
                                    ""
                                    file.content
                        in
                        Visible { name = file.name, extension = file.extension, content = finalizedContent }

                    else
                        Edit (percent + (delta / transitionDuration)) file

                Visible file ->
                    Visible file

                Hidden ->
                    Hidden
    in
    DisplayFile updatedTransition
