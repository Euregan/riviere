module Main exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onClick, onKeyDown)
import Browser.Navigation
import Component.Layout as Layout
import Deck exposing (Deck)
import Html exposing (Html)
import Json.Decode as Decoder
import Key exposing (Key(..))
import Message exposing (Message(..), PageMessage(..))
import Page.Home
import Page.Presentation
import Page.Signin
import Page.Signup
import Router exposing (Route(..))
import Slides exposing (slides)
import Url
import User exposing (User(..))


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        , subscriptions = subscriptions
        }


type Page
    = Home Page.Home.Model
    | Presentation Page.Presentation.Model
    | Signup Page.Signup.Model
    | Signin Page.Signin.Model
    | NotFound


type alias Model =
    { navigationKey : Browser.Navigation.Key
    , decks : List Deck
    , user : User
    , page : Page
    }


type alias Flags =
    ()


routeToPage : List Deck -> Route -> Page
routeToPage decks route =
    case route of
        Router.Home ->
            Home <| Page.Home.init decks

        Router.Presentation id ->
            case List.head (List.filter (\d -> Deck.id d == id) decks) of
                Just deck ->
                    Presentation <| Page.Presentation.init deck

                Nothing ->
                    NotFound

        Router.Signup ->
            Signup Page.Signup.init

        Router.Signin ->
            Signin Page.Signin.init


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Message )
init flags url key =
    ( { navigationKey = key
      , decks = [ slides ]
      , user = Visitor
      , page =
            Maybe.withDefault NotFound <|
                Maybe.map (routeToPage [ slides ]) <|
                    Router.fromUrl url
      }
    , Cmd.none
    )


keyDecoder : Decoder.Decoder Key
keyDecoder =
    Decoder.map toKey (Decoder.field "key" Decoder.string)


toKey : String -> Key
toKey string =
    case string of
        "ArrowLeft" ->
            ArrowLeft

        "ArrowRight" ->
            ArrowRight

        " " ->
            Space

        _ ->
            Other


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.batch
        [ onClick <| Decoder.succeed Clicked
        , onAnimationFrameDelta Tick
        , onKeyDown <| Decoder.map KeyPressed keyDecoder
        ]


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.navigationKey (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Browser.Navigation.load href
                    )

        UrlChanged url ->
            ( { model
                | page =
                    Maybe.withDefault NotFound <|
                        Maybe.map (routeToPage model.decks) <|
                            Router.fromUrl url
              }
            , Cmd.none
            )

        Clicked ->
            case model.page of
                Presentation mdl ->
                    ( { model
                        | page =
                            Presentation <|
                                Page.Presentation.update Page.Presentation.Clicked mdl
                      }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        KeyPressed key ->
            case model.page of
                Presentation mdl ->
                    ( { model
                        | page =
                            Presentation <|
                                Page.Presentation.update (Page.Presentation.KeyPressed key) mdl
                      }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        Tick delta ->
            case model.page of
                Presentation mdl ->
                    ( { model
                        | page =
                            Presentation <|
                                Page.Presentation.update (Page.Presentation.Tick delta) mdl
                      }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        PageMessage pageMessage ->
            case ( model.page, pageMessage ) of
                ( Home mdl, HomeMessage msg ) ->
                    ( { model | page = Home <| Page.Home.update msg mdl }, Cmd.none )

                ( Presentation mdl, PresentationMessage msg ) ->
                    ( { model | page = Presentation <| Page.Presentation.update msg mdl }, Cmd.none )

                ( Signup mdl, SignupMessage msg ) ->
                    let
                        ( page, command ) =
                            Page.Signup.update msg mdl
                    in
                    case msg of
                        Page.Signup.SignedUp (Ok jwt) ->
                            let
                                maybeUser =
                                    User.login jwt
                            in
                            ( { model | user = Result.withDefault Visitor maybeUser }
                            , Browser.Navigation.pushUrl model.navigationKey "/"
                            )

                        _ ->
                            ( { model | page = Signup page }
                            , Cmd.map (\m -> PageMessage <| SignupMessage m) command
                            )

                ( Signin mdl, SigninMessage msg ) ->
                    let
                        ( page, command ) =
                            Page.Signin.update msg mdl
                    in
                    case msg of
                        Page.Signin.SignedIn (Ok jwt) ->
                            let
                                maybeUser =
                                    User.login jwt
                            in
                            ( { model | user = Result.withDefault Visitor maybeUser }
                            , Browser.Navigation.pushUrl model.navigationKey "/"
                            )

                        _ ->
                            ( { model | page = Signin page }
                            , Cmd.map (\m -> PageMessage <| SigninMessage m) command
                            )

                ( NotFound, _ ) ->
                    ( model, Cmd.none )

                ( Home mdl, _ ) ->
                    ( model, Cmd.none )

                ( Presentation mdl, _ ) ->
                    ( model, Cmd.none )

                ( Signup mdl, _ ) ->
                    ( model, Cmd.none )

                ( Signin mdl, _ ) ->
                    ( model, Cmd.none )


view : Model -> Browser.Document Message
view { page } =
    { title = "Riviere - A tool to make project presentations"
    , body =
        case page of
            Home model ->
                Page.Home.view model

            Presentation model ->
                Page.Presentation.view model

            Signup model ->
                Page.Signup.view model
                    |> List.map (Html.map (\msg -> PageMessage <| SignupMessage msg))

            Signin model ->
                Page.Signin.view model
                    |> List.map (Html.map (\msg -> PageMessage <| SigninMessage msg))

            NotFound ->
                Layout.view [ Html.text "404 - Not Found" ]
    }
