module Slides exposing (Slides, current, init, next, tick)

import Array
import FileTree exposing (DisplayFileTree, FileTree)


type Slides
    = Slides
        { deck : List FileTree
        , current : Int
        , currentSlide : FileTree
        , currentDisplayedSlide : DisplayFileTree
        }


init : FileTree -> List FileTree -> Slides
init initialFileTree fileTrees =
    Slides
        { deck = initialFileTree :: fileTrees
        , current = 0
        , currentSlide = initialFileTree
        , currentDisplayedSlide = FileTree.swap initialFileTree initialFileTree
        }


tick : Float -> Slides -> Slides
tick delta (Slides slides) =
    Slides
        { slides
            | currentDisplayedSlide = FileTree.tick delta slides.currentDisplayedSlide
        }


next : Slides -> Slides
next (Slides slides) =
    if slides.current < List.length slides.deck - 1 then
        let
            nextSlide =
                Array.fromList slides.deck |> Array.get (slides.current + 1) |> Maybe.withDefault slides.currentSlide
        in
        Slides
            { slides
                | current = slides.current + 1
                , currentSlide = nextSlide
                , currentDisplayedSlide = FileTree.swap slides.currentSlide nextSlide
            }

    else
        Slides slides


current : Slides -> DisplayFileTree
current (Slides slides) =
    slides.currentDisplayedSlide
