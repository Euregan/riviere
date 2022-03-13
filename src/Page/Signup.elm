module Page.Signup exposing (Message(..), Model, init, update, view)

import Component.Layout as Layout
import Deck exposing (Deck)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Router exposing (Route(..))


type alias Model =
    { name : String
    , email : String
    , password : String
    }


type Message
    = NameUpdated String
    | EmailUpdated String
    | PasswordUpdated String
    | Signup
    | SignedUp (Result Http.Error String)


init : Model
init =
    { name = ""
    , email = ""
    , password = ""
    }


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        NameUpdated name ->
            ( { model | name = name }, Cmd.none )

        EmailUpdated email ->
            ( { model | email = email }, Cmd.none )

        PasswordUpdated password ->
            ( { model | password = password }, Cmd.none )

        Signup ->
            ( model
            , Http.post
                { url = "/api/signup"
                , body =
                    Encode.object
                        [ ( "name", Encode.string model.name )
                        , ( "email", Encode.string model.email )
                        , ( "password", Encode.string model.password )
                        ]
                        |> Http.jsonBody
                , expect =
                    Http.expectJson SignedUp <|
                        Decode.field "jwt" Decode.string
                }
            )

        SignedUp _ ->
            ( model, Cmd.none )


view : Model -> List (Html Message)
view model =
    Layout.view
        [ h2 [] [ text "Riviere" ]
        , div []
            [ label []
                [ text "Name"
                , input
                    [ onInput NameUpdated
                    , value model.name
                    ]
                    []
                ]
            , label []
                [ text "Email"
                , input
                    [ onInput EmailUpdated
                    , value model.email
                    , type_ "email"
                    ]
                    []
                ]
            , label []
                [ text "Password"
                , input
                    [ onInput PasswordUpdated
                    , value model.password
                    , type_ "password"
                    ]
                    []
                ]
            , button [ onClick Signup ] [ text "Signup" ]
            ]
        ]
