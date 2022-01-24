module FileTree exposing (File(..), FileTree, init, view)

import Html exposing (Html, div, h2, img, li, text, ul)
import Html.Attributes exposing (src, style)
import Icon
import Svg exposing (Svg)


newColor =
    "#9da5b4"


type Extension
    = JSON


type File
    = File String Extension
    | Directory String (List File)


type alias FileTree =
    { name : String
    , files : List File
    }


init : String -> FileTree
init rootDirectoryName =
    { name = rootDirectoryName
    , files = []
    }


view : FileTree -> Html msg
view tree =
    ul
        [ style "background" "#21252b"
        , style "color" newColor
        , style "fill" newColor
        , style "height" "100%"
        , style "padding" "2rem"
        , style "box-sizing" "border-box"
        ]
        [ viewFileRaw Icon.git (text tree.name) ]


viewFile : File -> Html msg
viewFile file =
    li [] <|
        case file of
            File name extension ->
                [ viewFileRaw (iconFromExtension extension) (text name)
                ]

            Directory name children ->
                [ viewFileRaw Icon.folder (text name)
                , ul [] <| List.map viewFile children
                ]


iconFromExtension : Extension -> Svg html
iconFromExtension icon =
    case icon of
        JSON ->
            Icon.json


viewFileRaw : Html msg -> Html msg -> Html msg
viewFileRaw icon text =
    div
        [ style "display" "flex"
        , style "gap" "0.5rem"
        , style "align-items" "center"
        ]
        [ icon, text ]
