module Page.Presentation exposing (Message(..), Model, init, update, view)

import Component.Layout as Layout
import Deck exposing (Deck)
import Html exposing (..)
import Key exposing (Key(..))


type Model
    = Model Deck


type Message
    = Clicked
    | Tick Float
    | KeyPressed Key


init : Deck -> Model
init deck =
    Model deck


update : Message -> Model -> Model
update msg (Model deck) =
    case msg of
        Clicked ->
            Model <| Deck.next deck

        KeyPressed key ->
            Model <|
                case key of
                    ArrowLeft ->
                        Deck.previous deck

                    ArrowRight ->
                        Deck.next deck

                    Space ->
                        Deck.next deck

                    Other ->
                        deck

        Tick delta ->
            Model <| Deck.tick delta deck


view : Model -> List (Html msg)
view (Model deck) =
    [ Deck.view deck ]
