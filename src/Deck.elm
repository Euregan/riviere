module Deck exposing (Deck, Slide(..), init, next, tick, view)

import Application exposing (Application, DisplayApplication)
import Array
import File exposing (DisplayFile, File)
import FileTree exposing (DisplayFileTree, FileTree)
import Html exposing (Html, div, li, ul)
import Html.Attributes exposing (style)
import Message exposing (Message)
import Repository exposing (DisplayRepository, Repository)
import Title exposing (DisplayTitle, Title)


transitionDuration =
    200


type Slide
    = Title Title
    | Repository Repository
    | Application Application


type DisplaySlide
    = IdleTitle DisplayTitle
    | IdleRepository DisplayRepository
    | IdleApplication DisplayApplication
    | TitleToRepository Float DisplayTitle DisplayRepository
    | RepositoryToTitle Float DisplayRepository DisplayTitle
    | ApplicationToTitle Float DisplayApplication DisplayTitle
    | ApplicationToRepository Float DisplayApplication DisplayRepository
    | RepositoryToApplication Float DisplayRepository DisplayApplication
    | TitleToApplication Float DisplayTitle DisplayApplication


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

        ( Application fromApplication, Application toApplication ) ->
            IdleApplication <| Application.swap fromApplication toApplication

        ( Title title, Repository repository ) ->
            TitleToRepository 0
                (Title.swap title title)
                (Repository.swap repository repository)

        ( Repository repository, Title title ) ->
            RepositoryToTitle 0
                (Repository.swap repository repository)
                (Title.swap title title)

        ( Application application, Title title ) ->
            ApplicationToTitle 0
                (Application.swap application application)
                (Title.swap title title)

        ( Application application, Repository repository ) ->
            ApplicationToRepository 0
                (Application.swap application application)
                (Repository.swap repository repository)

        ( Title title, Application application ) ->
            TitleToApplication 0
                (Title.swap title title)
                (Application.swap application application)

        ( Repository repository, Application application ) ->
            RepositoryToApplication 0
                (Repository.swap repository repository)
                (Application.swap application application)


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

                IdleApplication application ->
                    IdleApplication (Application.tick delta application)

                TitleToRepository percent title repository ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleRepository (Repository.tick delta repository)

                    else
                        TitleToRepository (percent + (delta / transitionDuration))
                            (Title.tick delta title)
                            repository

                RepositoryToTitle percent repository title ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleTitle (Title.tick delta title)

                    else
                        RepositoryToTitle (percent + (delta / transitionDuration))
                            (Repository.tick delta repository)
                            title

                ApplicationToTitle percent application title ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleTitle (Title.tick delta title)

                    else
                        ApplicationToTitle (percent + (delta / transitionDuration))
                            (Application.tick delta application)
                            title

                ApplicationToRepository percent application repository ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleRepository (Repository.tick delta repository)

                    else
                        ApplicationToRepository (percent + (delta / transitionDuration))
                            (Application.tick delta application)
                            repository

                RepositoryToApplication percent repository application ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleApplication (Application.tick delta application)

                    else
                        RepositoryToApplication (percent + (delta / transitionDuration))
                            (Repository.tick delta repository)
                            application

                TitleToApplication percent title application ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleApplication (Application.tick delta application)

                    else
                        TitleToApplication (percent + (delta / transitionDuration))
                            (Title.tick delta title)
                            application
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


view : Deck -> Html Message
view (Deck slides) =
    let
        transition : Float -> Html Message -> Html Message -> Html Message
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

        viewSlide : DisplaySlide -> Html Message
        viewSlide slide =
            case slide of
                IdleRepository repository ->
                    Repository.view repository

                IdleTitle title ->
                    Title.view title

                IdleApplication application ->
                    Application.view application

                TitleToRepository percent title repository ->
                    transition percent
                        (Title.view title)
                        (Repository.view repository)

                RepositoryToTitle percent repository title ->
                    transition percent
                        (Repository.view repository)
                        (Title.view title)

                ApplicationToTitle percent application title ->
                    transition percent
                        (Application.view application)
                        (Title.view title)

                ApplicationToRepository percent application repository ->
                    transition percent
                        (Application.view application)
                        (Repository.view repository)

                RepositoryToApplication percent repository application ->
                    transition percent
                        (Repository.view repository)
                        (Application.view application)

                TitleToApplication percent title application ->
                    transition percent
                        (Title.view title)
                        (Application.view application)
    in
    Html.main_
        [ style "padding" "10vh"
        , style "height" "100vh"
        , style "box-sizing" "border-box"
        ]
        [ viewSlide slides.currentDisplayedSlide ]
