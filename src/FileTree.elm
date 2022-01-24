module FileTree exposing (Extension(..), File(..), FileTree, Visibility(..), init, tick, view)

import Html exposing (Html, div, h2, img, li, text, ul)
import Html.Attributes exposing (src, style)
import Icon
import Svg exposing (Svg)


newColor =
    "#9da5b4"


transitionDuration =
    200


type Extension
    = JSON


type Transition
    = Idle Visibility
    | Appearing Float
    | Disappearing Float


type Visibility
    = Visible
    | Hidden


type File
    = File String Extension (List Visibility)
    | Directory String (List File) (List Visibility)


type FileTree
    = FileTree
        { name : String
        , files : List InternalFile
        }


type InternalFile
    = InternalFile
        { name : String
        , extension : Extension
        , visibilities : List Visibility
        , transition : Transition
        }
    | InternalDirectory
        { name : String
        , children : List InternalFile
        , visibilities : List Visibility
        , transition : Transition
        }


init : String -> List File -> FileTree
init rootDirectoryName files =
    let
        initialTransition : List Visibility -> Transition
        initialTransition visibilities =
            List.head visibilities |> Maybe.withDefault Hidden |> Idle

        fileToInternal : File -> InternalFile
        fileToInternal file =
            case file of
                File name extension visibilities ->
                    InternalFile
                        { name = name
                        , extension = extension
                        , visibilities = visibilities
                        , transition = initialTransition visibilities
                        }

                Directory name children visibilities ->
                    InternalDirectory
                        { name = name
                        , children = List.map fileToInternal children
                        , visibilities = visibilities
                        , transition = initialTransition visibilities
                        }
    in
    FileTree
        { name = rootDirectoryName
        , files = List.map fileToInternal files
        }


tick : Float -> FileTree -> FileTree
tick delta (FileTree tree) =
    FileTree { tree | files = List.map (tickFile delta) tree.files }


tickFile : Float -> InternalFile -> InternalFile
tickFile delta file =
    case file of
        InternalFile f ->
            case f.transition of
                Idle _ ->
                    InternalFile f

                Appearing percent ->
                    if percent + (delta / transitionDuration) > 1 then
                        InternalFile { f | transition = Idle Visible }

                    else
                        InternalFile { f | transition = Appearing (percent + (delta / transitionDuration)) }

                Disappearing percent ->
                    if percent + (delta / transitionDuration) > 1 then
                        InternalFile { f | transition = Idle Hidden }

                    else
                        InternalFile { f | transition = Disappearing (percent + (delta / transitionDuration)) }

        InternalDirectory d ->
            InternalDirectory d


view : FileTree -> Html msg
view (FileTree tree) =
    ul
        [ style "background" "#21252b"
        , style "color" newColor
        , style "fill" newColor
        , style "height" "100%"
        , style "padding" "2rem"
        , style "box-sizing" "border-box"
        ]
        [ li []
            [ viewFileRaw (Idle Visible) Icon.git (text tree.name)
            , ul [] <| List.map viewFile tree.files
            ]
        ]


viewFile : InternalFile -> Html msg
viewFile file =
    li [] <|
        case file of
            InternalFile { name, extension, transition } ->
                [ viewFileRaw transition (iconFromExtension extension) (text name)
                ]

            InternalDirectory { name, children, transition } ->
                [ viewFileRaw transition Icon.folder (text name)
                , ul [] <| List.map viewFile children
                ]


iconFromExtension : Extension -> Svg html
iconFromExtension icon =
    case icon of
        JSON ->
            Icon.json


viewFileRaw : Transition -> Html msg -> Html msg -> Html msg
viewFileRaw transition icon text =
    let
        percentFromTransition : Float
        percentFromTransition =
            case transition of
                Idle Visible ->
                    1

                Idle Hidden ->
                    0

                Appearing percent ->
                    percent

                Disappearing percent ->
                    1 - percent
    in
    div
        [ style "display" "flex"
        , style "gap" "0.5rem"
        , style "align-items" "center"
        , style "overflow" "hidden"
        , style "height" (String.fromFloat (percentFromTransition * 1.25) ++ "rem")
        , style "transform" ("scaleY(" ++ String.fromFloat percentFromTransition ++ ")")
        ]
        [ icon, text ]
