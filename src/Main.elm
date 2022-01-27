module Main exposing (..)

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onClick)
import Browser.Navigation
import FileTree exposing (Extension(..), File(..))
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Json.Decode as Decoder
import Slides exposing (Slides)
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
    , slides : Slides
    }


type alias Flags =
    ()


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { navigationKey = key
      , slides =
            Slides.init
                { name = "unbreakable"
                , files = []
                }
                [ { name = "unbreakable"
                  , files =
                        [ File "package.json" JSON
                        , File "package-lock.json" JSON
                        ]
                  }
                , { name = "unbreakable"
                  , files =
                        [ File "package.json" JSON
                        , File "package-lock.json" JSON
                        , File "webpack.config.js" JavaScript
                        , File "index.html" HTML
                        ]
                  }
                , { name = "unbreakable"
                  , files =
                        [ File "package.json" JSON
                        , File "package-lock.json" JSON
                        , File "webpack.config.js" JavaScript
                        , File "index.html" HTML
                        , Directory "src"
                            [ File "App.jsx" JSX
                            ]
                        ]
                  }
                , { name = "unbreakable"
                  , files =
                        [ File "package.json" JSON
                        , File "package-lock.json" JSON
                        , File "webpack.config.js" JavaScript
                        , File "index.html" HTML
                        , Directory "src"
                            [ File "App.jsx" JSX
                            , File "Login.jsx" JSX
                            ]
                        ]
                  }
                ]
      }
    , Cmd.none
    )


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Clicked
    | Tick Float


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onClick <| Decoder.succeed Clicked
        , onAnimationFrameDelta Tick
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
            ( { model | slides = Slides.next model.slides }, Cmd.none )

        Tick delta ->
            ( { model
                | slides = Slides.tick delta model.slides
              }
            , Cmd.none
            )



-- stepUrl : Url.Url -> Model -> ( Model, Cmd Msg )
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


view : Model -> Browser.Document Msg
view model =
    { title = "Making an unbreakable website"
    , body =
        [ Html.main_
            [ style "padding" "10vh"
            , style "height" "100vh"
            , style "box-sizing" "border-box"
            ]
            [ FileTree.view <| Slides.current model.slides ]
        ]
    }
