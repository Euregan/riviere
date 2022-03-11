module Deck exposing (Deck, Slide(..), id, init, name, next, previous, tick, view)

import Array
import Html exposing (Html, div, li, ul)
import Html.Attributes exposing (style)
import Slide.Application as Application exposing (Application, DisplayApplication)
import Slide.Repository as Repository exposing (DisplayRepository, Repository)
import Slide.Repository.File as File exposing (DisplayFile, File)
import Slide.Repository.FileTree as FileTree exposing (DisplayFileTree, FileTree)
import Slide.Terminal as Terminal exposing (DisplayTerminal, Terminal)
import Slide.Text as Text exposing (DisplayText, Text)


transitionDuration =
    200


type Slide
    = Text Text
    | Terminal Terminal
    | Repository Repository
    | Application Application


type DisplaySlide
    = IdleApplication DisplayApplication
    | ApplicationToRepository Float DisplayApplication DisplayRepository
    | ApplicationToTerminal Float DisplayApplication DisplayTerminal
    | ApplicationToText Float DisplayApplication DisplayText
    | IdleRepository DisplayRepository
    | RepositoryToApplication Float DisplayRepository DisplayApplication
    | RepositoryToTerminal Float DisplayRepository DisplayTerminal
    | RepositoryToText Float DisplayRepository DisplayText
    | IdleTerminal DisplayTerminal
    | TerminalToApplication Float DisplayTerminal DisplayApplication
    | TerminalToRepository Float DisplayTerminal DisplayRepository
    | TerminalToText Float DisplayTerminal DisplayText
    | IdleText DisplayText
    | TextToApplication Float DisplayText DisplayApplication
    | TextToRepository Float DisplayText DisplayRepository
    | TextToTerminal Float DisplayText DisplayTerminal


type Deck
    = Deck
        { deck : List Slide
        , name : String
        , id : String
        , current : Int
        , currentSlide : Slide
        , currentDisplayedSlide : DisplaySlide
        }


id : Deck -> String
id (Deck deck) =
    deck.id


name : Deck -> String
name (Deck deck) =
    deck.name


init : String -> String -> Slide -> List Slide -> Deck
init deckId deckName initialSlide slides =
    Deck
        { deck = initialSlide :: slides
        , name = deckName
        , id = deckId
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

        ( Application application, Text text ) ->
            ApplicationToText 0
                (Application.swap application application)
                (Text.swap text text)

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

        ( Repository repository, Text text ) ->
            RepositoryToText 0
                (Repository.swap repository repository)
                (Text.swap text text)

        ( Terminal fromTerminal, Terminal toTerminal ) ->
            IdleTerminal <| Terminal.swap fromTerminal toTerminal

        ( Terminal terminal, Repository repository ) ->
            TerminalToRepository 0
                (Terminal.swap terminal terminal)
                (Repository.swap repository repository)

        ( Terminal terminal, Text text ) ->
            TerminalToText 0
                (Terminal.swap terminal terminal)
                (Text.swap text text)

        ( Terminal terminal, Application application ) ->
            TerminalToApplication 0
                (Terminal.swap terminal terminal)
                (Application.swap application application)

        ( Text fromText, Text toText ) ->
            IdleText <| Text.swap fromText toText

        ( Text text, Application application ) ->
            TextToApplication 0
                (Text.swap text text)
                (Application.swap application application)

        ( Text text, Repository repository ) ->
            TextToRepository 0
                (Text.swap text text)
                (Repository.swap repository repository)

        ( Text text, Terminal terminal ) ->
            TextToTerminal 0
                (Text.swap text text)
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

                ApplicationToText percent application text ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleText (Text.tick delta text)

                    else
                        ApplicationToText (percent + (delta / transitionDuration))
                            (Application.tick delta application)
                            text

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

                RepositoryToText percent repository text ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleText (Text.tick delta text)

                    else
                        RepositoryToText (percent + (delta / transitionDuration))
                            (Repository.tick delta repository)
                            text

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

                TerminalToText percent terminal text ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleText (Text.tick delta text)

                    else
                        TerminalToText (percent + (delta / transitionDuration))
                            (Terminal.tick delta terminal)
                            text

                IdleText text ->
                    IdleText (Text.tick delta text)

                TextToApplication percent text application ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleApplication (Application.tick delta application)

                    else
                        TextToApplication (percent + (delta / transitionDuration))
                            (Text.tick delta text)
                            application

                TextToRepository percent text repository ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleRepository (Repository.tick delta repository)

                    else
                        TextToRepository (percent + (delta / transitionDuration))
                            (Text.tick delta text)
                            repository

                TextToTerminal percent text terminal ->
                    if percent + (delta / transitionDuration) > 1 then
                        IdleTerminal (Terminal.tick delta terminal)

                    else
                        TextToTerminal (percent + (delta / transitionDuration))
                            (Text.tick delta text)
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

                ApplicationToText percent application text ->
                    transition percent
                        (Application.view application)
                        (Text.view text)

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

                RepositoryToText percent repository text ->
                    transition percent
                        (Repository.view repository)
                        (Text.view text)

                IdleTerminal text ->
                    Terminal.view text

                TerminalToApplication percent terminal application ->
                    transition percent
                        (Terminal.view terminal)
                        (Application.view application)

                TerminalToRepository percent terminal repository ->
                    transition percent
                        (Terminal.view terminal)
                        (Repository.view repository)

                TerminalToText percent terminal text ->
                    transition percent
                        (Terminal.view terminal)
                        (Text.view text)

                IdleText text ->
                    Text.view text

                TextToApplication percent text application ->
                    transition percent
                        (Text.view text)
                        (Application.view application)

                TextToRepository percent text repository ->
                    transition percent
                        (Text.view text)
                        (Repository.view repository)

                TextToTerminal percent text terminal ->
                    transition percent
                        (Text.view text)
                        (Terminal.view terminal)
    in
    Html.main_
        [ style "padding" "10vh"
        , style "height" "100vh"
        , style "box-sizing" "border-box"
        ]
        [ viewSlide slides.currentDisplayedSlide ]
