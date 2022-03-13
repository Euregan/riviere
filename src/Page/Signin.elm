module Page.Signin exposing (Message(..), Model, init, update, view)

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
    = EmailUpdated String
    | PasswordUpdated String
    | Signin
    | SignedIn (Result Http.Error String)


init : Model
init =
    { name = ""
    , email = ""
    , password = ""
    }


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        EmailUpdated email ->
            ( { model | email = email }, Cmd.none )

        PasswordUpdated password ->
            ( { model | password = password }, Cmd.none )

        Signin ->
            ( model
            , Http.post
                { url = "/api/signin"
                , body =
                    Encode.object
                        [ ( "email", Encode.string model.email )
                        , ( "password", Encode.string model.password )
                        ]
                        |> Http.jsonBody
                , expect =
                    Http.expectJson SignedIn <|
                        Decode.field "jwt" Decode.string
                }
            )

        SignedIn _ ->
            ( model, Cmd.none )


view : Model -> List (Html Message)
view model =
    Layout.view
        [ h2 [] [ text "Riviere" ]
        , div []
            [ label []
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
            , button [ onClick Signin ] [ text "Signin" ]
            ]
        ]
