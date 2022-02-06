module Main exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onClick, onKeyDown)
import Browser.Navigation
import Deck exposing (Deck)
import Html exposing (Html)
import Json.Decode as Decoder
import Message exposing (Key(..), Message(..))
import Slides exposing (slides)
import Url


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        , subscriptions = subscriptions
        }


type alias Model =
    { navigationKey : Browser.Navigation.Key
    , slides : Deck
    }


type alias Flags =
    ()


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Message )
init flags url key =
    ( { navigationKey = key
      , slides = slides
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
            -- stepUrl url model
            ( model, Cmd.none )

        Clicked ->
            ( { model | slides = Deck.next model.slides }, Cmd.none )

        KeyPressed key ->
            ( { model
                | slides =
                    case key of
                        ArrowLeft ->
                            Deck.previous model.slides

                        ArrowRight ->
                            Deck.next model.slides

                        Space ->
                            Deck.next model.slides

                        Other ->
                            model.slides
              }
            , Cmd.none
            )

        Tick delta ->
            ( { model
                | slides = Deck.tick delta model.slides
              }
            , Cmd.none
            )



-- stepUrl : Url.Url -> Model -> ( Model, Cmd Message )
-- stepUrl url model =
--     let
--         session =
--             exit model
--
--         parser =
--             oneOf
--                 [ route top
--                     (stepSearch model (Search.init session))
--                 , route (s "packages" </> author_ </> project_)
--                     (\author project ->
--                         stepDiff model (Diff.init session author project)
--                     )
--                 , route (s "packages" </> author_ </> project_ </> version_ </> focus_)
--                     (\author project version focus ->
--                         stepDocs model (Docs.init session author project version focus)
--                     )
--                 , route (s "help" </> s "design-guidelines")
--                     (stepHelp model (Help.init session "Design Guidelines" "/assets/help/design-guidelines.md"))
--                 , route (s "help" </> s "documentation-format")
--                     (stepHelp model (Help.init session "Documentation Format" "/assets/help/documentation-format.md"))
--                 ]
--     in
--     case Parser.parse parser url of
--         Just answer ->
--             answer
--
--         Nothing ->
--             ( { model | page = NotFound session }
--             , Cmd.none
--             )


view : Model -> Browser.Document Message
view model =
    { title = "Making an unbreakable website"
    , body = [ Deck.view model.slides ]
    }
