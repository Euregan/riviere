module Deck exposing (Deck, Slide(..), init, next, tick, view)

import Array
import File exposing (DisplayFile, File)
import FileTree exposing (DisplayFileTree, FileTree)
import Html exposing (Html, div, li, ul)
import Html.Attributes exposing (style)
import Repository exposing (DisplayRepository, Repository)
import Title exposing (DisplayTitle, Title)


transitionDuration =
    200


type Slide
    = Title Title
    | Repository ( FileTree, File )


type DisplaySlide
    = IdleTitle DisplayTitle
    | IdleRepository DisplayRepository
    | TitleToRepository Float DisplayTitle DisplayRepository
    | RepositoryToTitle Float DisplayRepository DisplayTitle


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
        ( Repository fromRepository, Repository toRepository ) ->
            IdleRepository <| Repository.swap fromRepository toRepository

        ( Title fromTitle, Title toTitle ) ->
            IdleTitle <| Title.swap fromTitle toTitle

        ( Title title, Repository repository ) ->
            TitleToRepository 0
                (Title.swap title title)
                (Repository.swap repository repository)

        ( Repository repository, Title title ) ->
            RepositoryToTitle 0
                (Repository.swap repository repository)
                (Title.swap title title)


tick : Float -> Deck -> Deck
tick delta (Deck slides) =
    let
        tickSlide : DisplaySlide -> DisplaySlide
        tickSlide slide =
            case slide of
                IdleRepository repository ->
                    IdleRepository (Repository.tick delta repository)

                IdleTitle title ->
                    IdleTitle (Title.tick delta title)

                TitleToRepository percent title repository ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleRepository (Repository.tick delta repository)

                    else
                        TitleToRepository (percent + (delta / transitionDuration)) (Title.tick delta title) repository

                RepositoryToTitle percent repository title ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleTitle (Title.tick delta title)

                    else
                        RepositoryToTitle (percent + (delta / transitionDuration))
                            (Repository.tick delta repository)
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
        transition : Float -> Html msg -> Html msg -> Html msg
        transition percent from to =
            ul
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
                    [ from ]
                , li
                    [ style "height" "100%"
                    , style "width" "100%"
                    , style "position" "absolute"
                    , style "left" <| String.fromFloat ((1 - percent) * 100) ++ "%"
                    ]
                    [ to ]
                ]

        viewSlide : DisplaySlide -> Html msg
        viewSlide slide =
            case slide of
                IdleRepository repository ->
                    Repository.view repository

                IdleTitle title ->
                    Title.view title

                TitleToRepository percent title repository ->
                    transition percent
                        (Title.view title)
                        (Repository.view repository)

                RepositoryToTitle percent repository title ->
                    transition percent
                        (Repository.view repository)
                        (Title.view title)
    in
    Html.main_
        [ style "padding" "10vh"
        , style "height" "100vh"
        , style "box-sizing" "border-box"
        ]
        [ viewSlide slides.currentDisplayedSlide ]
