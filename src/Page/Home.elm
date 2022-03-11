module Page.Home exposing (Message, Model, init, update, view)

import Component.Layout as Layout
import Deck exposing (Deck)
import Html exposing (..)
import Router exposing (Route(..))


type alias Model =
    { decks : List Deck
    }


type Message
    = NoOp


init : List Deck -> Model
init decks =
    { decks = decks
    }


update : Message -> Model -> Model
update msg model =
    model


view : Model -> List (Html msg)
view model =
    Layout.view
        [ h1 [] [ text "Riviere" ]
        , ul [] <|
            List.map
                (\deck ->
                    li []
                        [ a
                            [ Router.href <| Presentation <| Deck.id deck ]
                            [ text <| Deck.name deck ]
                        ]
                )
                model.decks
        ]
