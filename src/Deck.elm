module Deck exposing (Deck, Slide(..), init, next, previous, tick, view)

import Application exposing (Application, DisplayApplication)
import Array
import File exposing (DisplayFile, File)
import FileTree exposing (DisplayFileTree, FileTree)
import Html exposing (Html, div, li, ul)
import Html.Attributes exposing (style)
import Message exposing (Message)
import Repository exposing (DisplayRepository, Repository)
import Terminal exposing (DisplayTerminal, Terminal)
import Title exposing (DisplayTitle, Title)


transitionDuration =
    200


type Slide
    = Title Title
    | Terminal Terminal
    | Repository Repository
    | Application Application


type DisplaySlide
    = IdleApplication DisplayApplication
    | ApplicationToRepository Float DisplayApplication DisplayRepository
    | ApplicationToTerminal Float DisplayApplication DisplayTerminal
    | ApplicationToTitle Float DisplayApplication DisplayTitle
    | IdleRepository DisplayRepository
    | RepositoryToApplication Float DisplayRepository DisplayApplication
    | RepositoryToTerminal Float DisplayRepository DisplayTerminal
    | RepositoryToTitle Float DisplayRepository DisplayTitle
    | IdleTerminal DisplayTerminal
    | TerminalToApplication Float DisplayTerminal DisplayApplication
    | TerminalToRepository Float DisplayTerminal DisplayRepository
    | TerminalToTitle Float DisplayTerminal DisplayTitle
    | IdleTitle DisplayTitle
    | TitleToApplication Float DisplayTitle DisplayApplication
    | TitleToRepository Float DisplayTitle DisplayRepository
    | TitleToTerminal Float DisplayTitle DisplayTerminal


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
        ( Application fromApplication, Application toApplication ) ->
            IdleApplication <| Application.swap fromApplication toApplication

        ( Application application, Repository repository ) ->
            ApplicationToRepository 0
                (Application.swap application application)
                (Repository.swap repository repository)

        ( Application application, Terminal terminal ) ->
            ApplicationToTerminal 0
                (Application.swap application application)
                (Terminal.swap terminal terminal)

        ( Application application, Title title ) ->
            ApplicationToTitle 0
                (Application.swap application application)
                (Title.swap title title)

        ( Repository fromRepository, Repository toRepository ) ->
            IdleRepository <| Repository.swap fromRepository toRepository

        ( Repository repository, Application application ) ->
            RepositoryToApplication 0
                (Repository.swap repository repository)
                (Application.swap application application)

        ( Repository repository, Terminal terminal ) ->
            RepositoryToTerminal 0
                (Repository.swap repository repository)
                (Terminal.swap terminal terminal)

        ( Repository repository, Title title ) ->
            RepositoryToTitle 0
                (Repository.swap repository repository)
                (Title.swap title title)

        ( Terminal fromTerminal, Terminal toTerminal ) ->
            IdleTerminal <| Terminal.swap fromTerminal toTerminal

        ( Terminal terminal, Repository repository ) ->
            TerminalToRepository 0
                (Terminal.swap terminal terminal)
                (Repository.swap repository repository)

        ( Terminal terminal, Title title ) ->
            TerminalToTitle 0
                (Terminal.swap terminal terminal)
                (Title.swap title title)

        ( Terminal terminal, Application application ) ->
            TerminalToApplication 0
                (Terminal.swap terminal terminal)
                (Application.swap application application)

        ( Title fromTitle, Title toTitle ) ->
            IdleTitle <| Title.swap fromTitle toTitle

        ( Title title, Application application ) ->
            TitleToApplication 0
                (Title.swap title title)
                (Application.swap application application)

        ( Title title, Repository repository ) ->
            TitleToRepository 0
                (Title.swap title title)
                (Repository.swap repository repository)

        ( Title title, Terminal terminal ) ->
            TitleToTerminal 0
                (Title.swap title title)
                (Terminal.swap terminal terminal)


tick : Float -> Deck -> Deck
tick delta (Deck slides) =
    let
        tickSlide : DisplaySlide -> DisplaySlide
        tickSlide slide =
            case slide of
                IdleApplication application ->
                    IdleApplication (Application.tick delta application)

                ApplicationToRepository percent application repository ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleRepository (Repository.tick delta repository)

                    else
                        ApplicationToRepository (percent + (delta / transitionDuration))
                            (Application.tick delta application)
                            repository

                ApplicationToTerminal percent application terminal ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleTerminal (Terminal.tick delta terminal)

                    else
                        ApplicationToTerminal (percent + (delta / transitionDuration))
                            (Application.tick delta application)
                            terminal

                ApplicationToTitle percent application title ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleTitle (Title.tick delta title)

                    else
                        ApplicationToTitle (percent + (delta / transitionDuration))
                            (Application.tick delta application)
                            title

                IdleRepository repository ->
                    IdleRepository (Repository.tick delta repository)

                RepositoryToApplication percent repository application ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleApplication (Application.tick delta application)

                    else
                        RepositoryToApplication (percent + (delta / transitionDuration))
                            (Repository.tick delta repository)
                            application

                RepositoryToTerminal percent repository terminal ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleTerminal (Terminal.tick delta terminal)

                    else
                        RepositoryToTerminal (percent + (delta / transitionDuration))
                            (Repository.tick delta repository)
                            terminal

                RepositoryToTitle percent repository title ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleTitle (Title.tick delta title)

                    else
                        RepositoryToTitle (percent + (delta / transitionDuration))
                            (Repository.tick delta repository)
                            title

                IdleTerminal terminal ->
                    IdleTerminal (Terminal.tick delta terminal)

                TerminalToApplication percent terminal application ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleApplication (Application.tick delta application)

                    else
                        TerminalToApplication (percent + (delta / transitionDuration))
                            (Terminal.tick delta terminal)
                            application

                TerminalToRepository percent terminal repository ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleRepository (Repository.tick delta repository)

                    else
                        TerminalToRepository (percent + (delta / transitionDuration))
                            (Terminal.tick delta terminal)
                            repository

                TerminalToTitle percent terminal title ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleTitle (Title.tick delta title)

                    else
                        TerminalToTitle (percent + (delta / transitionDuration))
                            (Terminal.tick delta terminal)
                            title

                IdleTitle title ->
                    IdleTitle (Title.tick delta title)

                TitleToApplication percent title application ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleApplication (Application.tick delta application)

                    else
                        TitleToApplication (percent + (delta / transitionDuration))
                            (Title.tick delta title)
                            application

                TitleToRepository percent title repository ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleRepository (Repository.tick delta repository)

                    else
                        TitleToRepository (percent + (delta / transitionDuration))
                            (Title.tick delta title)
                            repository

                TitleToTerminal percent title terminal ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleTerminal (Terminal.tick delta terminal)

                    else
                        TitleToTerminal (percent + (delta / transitionDuration))
                            (Title.tick delta title)
                            terminal
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


previous : Deck -> Deck
previous (Deck slides) =
    if slides.current > 0 then
        let
            futureSlide =
                Array.fromList slides.deck |> Array.get (slides.current - 1) |> Maybe.withDefault slides.currentSlide
        in
        Deck
            { slides
                | current = slides.current - 1
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
                IdleApplication application ->
                    Application.view application

                ApplicationToRepository percent application repository ->
                    transition percent
                        (Application.view application)
                        (Repository.view repository)

                ApplicationToTerminal percent application terminal ->
                    transition percent
                        (Application.view application)
                        (Terminal.view terminal)

                ApplicationToTitle percent application title ->
                    transition percent
                        (Application.view application)
                        (Title.view title)

                IdleRepository repository ->
                    Repository.view repository

                RepositoryToApplication percent repository application ->
                    transition percent
                        (Repository.view repository)
                        (Application.view application)

                RepositoryToTerminal percent repository terminal ->
                    transition percent
                        (Repository.view repository)
                        (Terminal.view terminal)

                RepositoryToTitle percent repository title ->
                    transition percent
                        (Repository.view repository)
                        (Title.view title)

                IdleTerminal title ->
                    Terminal.view title

                TerminalToApplication percent terminal application ->
                    transition percent
                        (Terminal.view terminal)
                        (Application.view application)

                TerminalToRepository percent terminal repository ->
                    transition percent
                        (Terminal.view terminal)
                        (Repository.view repository)

                TerminalToTitle percent terminal title ->
                    transition percent
                        (Terminal.view terminal)
                        (Title.view title)

                IdleTitle title ->
                    Title.view title

                TitleToApplication percent title application ->
                    transition percent
                        (Title.view title)
                        (Application.view application)

                TitleToRepository percent title repository ->
                    transition percent
                        (Title.view title)
                        (Repository.view repository)

                TitleToTerminal percent title terminal ->
                    transition percent
                        (Title.view title)
                        (Terminal.view terminal)
    in
    Html.main_
        [ style "padding" "10vh"
        , style "height" "100vh"
        , style "box-sizing" "border-box"
        ]
        [ viewSlide slides.currentDisplayedSlide ]
