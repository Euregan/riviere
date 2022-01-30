module Deck exposing (Deck, init, next, tick, view)

import Array
import File exposing (DisplayFile, File)
import FileTree exposing (DisplayFileTree, FileTree)
import Html exposing (Html, div)
import Html.Attributes exposing (style)


type Deck
    = Deck
        { deck : List ( FileTree, File )
        , current : Int
        , currentSlide : ( FileTree, File )
        , currentDisplayedSlide : ( DisplayFileTree, DisplayFile )
        }


init : ( FileTree, File ) -> List ( FileTree, File ) -> Deck
init ( initialFileTree, initialFile ) slides =
    Deck
        { deck = ( initialFileTree, initialFile ) :: slides
        , current = 0
        , currentSlide = ( initialFileTree, initialFile )
        , currentDisplayedSlide =
            ( FileTree.swap initialFileTree initialFileTree
            , File.swap initialFile initialFile
            )
        }


tick : Float -> Deck -> Deck
tick delta (Deck slides) =
    Deck
        { slides
            | currentDisplayedSlide =
                ( FileTree.tick delta (Tuple.first slides.currentDisplayedSlide)
                , File.tick delta (Tuple.second slides.currentDisplayedSlide)
                )
        }


next : Deck -> Deck
next (Deck slides) =
    if slides.current < List.length slides.deck - 1 then
        let
            ( nextFileTreeSlide, nextFileSlide ) =
                Array.fromList slides.deck |> Array.get (slides.current + 1) |> Maybe.withDefault slides.currentSlide
        in
        Deck
            { slides
                | current = slides.current + 1
                , currentSlide = ( nextFileTreeSlide, nextFileSlide )
                , currentDisplayedSlide =
                    ( FileTree.swap (Tuple.first slides.currentSlide) nextFileTreeSlide
                    , File.swap (Tuple.second slides.currentSlide) nextFileSlide
                    )
            }

    else
        Deck slides


view : Deck -> Html msg
view (Deck slides) =
    Html.main_
        [ style "padding" "10vh"
        , style "height" "100vh"
        , style "box-sizing" "border-box"
        , style "display" "flex"
        , style "gap" "1rem"
        ]
        [ slides.currentDisplayedSlide |> Tuple.first |> FileTree.view
        , slides.currentDisplayedSlide |> Tuple.second |> File.view
        ]
