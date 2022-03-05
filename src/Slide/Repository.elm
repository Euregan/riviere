module Slide.Repository exposing (DisplayRepository, Repository, swap, tick, view)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Message exposing (Message)
import Slide.Repository.File as File exposing (DisplayFile, File(..))
import Slide.Repository.FileTree as FileTree exposing (DisplayFileTree, FileTree)


type alias Repository =
    ( FileTree, File )


type DisplayRepository
    = DisplayRepository ( DisplayFileTree, DisplayFile )


view : DisplayRepository -> Html Message
view (DisplayRepository ( fileTree, file )) =
    div
        [ style "height" "100%"
        , style "display" "flex"
        , style "gap" "1rem"
        ]
        [ FileTree.view fileTree
        , File.view file
        ]


swap : Repository -> Repository -> DisplayRepository
swap ( fromFileTree, fromFile ) ( toFileTree, toFile ) =
    DisplayRepository
        ( FileTree.swap fromFileTree toFileTree
        , File.swap fromFile toFile
        )


tick : Float -> DisplayRepository -> DisplayRepository
tick delta (DisplayRepository ( fileTree, file )) =
    DisplayRepository
        ( FileTree.tick delta fileTree
        , File.tick delta file
        )
