module Deck exposing (Deck, Slide(..), init, next, tick, view)

import Array
import File exposing (DisplayFile, File)
import FileTree exposing (DisplayFileTree, FileTree)
import Html exposing (Html, div, li, ul)
import Html.Attributes exposing (style)
import Title exposing (DisplayTitle, Title)


transitionDuration =
    200


type Slide
    = Title Title
    | Repository ( FileTree, File )


type DisplaySlide
    = IdleTitle DisplayTitle
    | IdleRepository ( DisplayFileTree, DisplayFile )
    | TitleToRepository Float DisplayTitle ( DisplayFileTree, DisplayFile )
    | RepositoryToTitle Float ( DisplayFileTree, DisplayFile ) DisplayTitle


type Deck
    = Deck
        { deck : List Slide
        , current : Int
        , currentSlide : Slide
        , currentDisplayedSlide : DisplaySlide
        }


init : Slide -> List Slide -> Deck
init initialSlide slides =
    Deck
        { deck = initialSlide :: slides
        , current = 0
        , currentSlide = initialSlide
        , currentDisplayedSlide =
            transitionSlide initialSlide initialSlide
        }


transitionSlide : Slide -> Slide -> DisplaySlide
transitionSlide from to =
    case ( from, to ) of
        ( Repository ( fromFileTree, fromFile ), Repository ( toFileTree, toFile ) ) ->
            IdleRepository
                ( FileTree.swap fromFileTree toFileTree
                , File.swap fromFile toFile
                )

        ( Title fromTitle, Title toTitle ) ->
            IdleTitle <| Title.swap fromTitle toTitle

        ( Title title, Repository ( fileTree, file ) ) ->
            TitleToRepository 0
                (Title.swap title title)
                ( FileTree.swap fileTree fileTree
                , File.swap file file
                )

        ( Repository ( fileTree, file ), Title title ) ->
            RepositoryToTitle 0
                ( FileTree.swap fileTree fileTree
                , File.swap file file
                )
                (Title.swap title title)


tick : Float -> Deck -> Deck
tick delta (Deck slides) =
    let
        tickSlide : DisplaySlide -> DisplaySlide
        tickSlide slide =
            case slide of
                IdleRepository ( fileTree, file ) ->
                    IdleRepository
                        ( FileTree.tick delta fileTree
                        , File.tick delta file
                        )

                IdleTitle title ->
                    IdleTitle (Title.tick delta title)

                TitleToRepository percent title ( fileTree, file ) ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleRepository
                            ( FileTree.tick delta fileTree
                            , File.tick delta file
                            )

                    else
                        TitleToRepository (percent + (delta / transitionDuration)) (Title.tick delta title) ( fileTree, file )

                RepositoryToTitle percent ( fileTree, file ) title ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleTitle (Title.tick delta title)

                    else
                        RepositoryToTitle (percent + (delta / transitionDuration))
                            ( FileTree.tick delta fileTree
                            , File.tick delta file
                            )
                            title
    in
    Deck
        { slides
            | currentDisplayedSlide = tickSlide slides.currentDisplayedSlide
        }


next : Deck -> Deck
next (Deck slides) =
    if slides.current < List.length slides.deck - 1 then
        let
            futureSlide =
                Array.fromList slides.deck |> Array.get (slides.current + 1) |> Maybe.withDefault slides.currentSlide
        in
        Deck
            { slides
                | current = slides.current + 1
                , currentSlide = futureSlide
                , currentDisplayedSlide = transitionSlide slides.currentSlide futureSlide
            }

    else
        Deck slides


view : Deck -> Html msg
view (Deck slides) =
    let
        transition : Float -> List (Html msg) -> List (Html msg) -> List (Html msg)
        transition percent from to =
            [ ul
                [ style "width" "calc(100vw - 20vh)"
                , style "height" "80vh"
                , style "position" "relative"
                ]
                [ li
                    [ style "height" "100%"
                    , style "width" "100%"
                    , style "position" "absolute"
                    , style "left" <| String.fromFloat (percent * -100) ++ "%"
                    ]
                    from
                , li
                    [ style "height" "100%"
                    , style "width" "100%"
                    , style "position" "absolute"
                    , style "left" <| String.fromFloat ((1 - percent) * 100) ++ "%"
                    ]
                    to
                ]
            ]

        viewSlide : DisplaySlide -> List (Html msg)
        viewSlide slide =
            case slide of
                IdleRepository ( fileTree, file ) ->
                    [ div
                        [ style "height" "100%"
                        , style "display" "flex"
                        , style "gap" "1rem"
                        ]
                        [ FileTree.view fileTree
                        , File.view file
                        ]
                    ]

                IdleTitle title ->
                    [ Title.view title ]

                TitleToRepository percent title ( fileTree, file ) ->
                    transition percent
                        [ Title.view title
                        ]
                        [ div
                            [ style "height" "100%"
                            , style "display" "flex"
                            , style "gap" "1rem"
                            ]
                            [ FileTree.view fileTree
                            , File.view file
                            ]
                        ]

                RepositoryToTitle percent ( fileTree, file ) title ->
                    transition percent
                        [ div
                            [ style "height" "100%"
                            , style "display" "flex"
                            , style "gap" "1rem"
                            ]
                            [ FileTree.view fileTree
                            , File.view file
                            ]
                        ]
                        [ Title.view title
                        ]
    in
    Html.main_
        [ style "padding" "10vh"
        , style "height" "100vh"
        , style "box-sizing" "border-box"
        ]
        (viewSlide slides.currentDisplayedSlide)
