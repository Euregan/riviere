module Slides exposing (slides)

import Application exposing (Application(..))
import Deck exposing (Deck, Slide(..))
import Extension exposing (Extension(..))
import File exposing (File(..))
import FileTree exposing (File(..))
import Html
import Terminal exposing (Color(..), Line(..))


slides : Deck
slides =
    Deck.init
        (Title
            { title = "Making an unbreakable website"
            , subtitle = Just "Or how to avoid clientside errors"
            }
        )
        [ Repository
            ( { name = "unbreakable"
              , files = []
              }
            , None
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    ]
              }
            , None
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , File "webpack.config.js" JavaScript
                    , File "index.html" HTML
                    ]
              }
            , None
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , File "webpack.config.js" JavaScript
                    , File "index.html" HTML
                    ]
              }
            , SelectedFile
                { name = "webpack.config.js"
                , extension = JavaScript
                , content = """const path = require('path');

module.exports = {
  entry: './src/index.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
  },
};"""
                }
            )
        , Repository
            ( { name = "unbreakable"
              , files =
                    [ File "package.json" JSON
                    , File "package-lock.json" JSON
                    , File "webpack.config.js" JavaScript
                    , File "index.html" HTML
                    ]
              }
            , SelectedFile
                { name = "index.html"
                , extension = HTML
                , content = """<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    ...
  </head>
  <body>
    ...
    <script src="dist/bundle.js"></script>
  </body>
</html>"""
                }
            )
        , Repository
            ( { name = "unbreakable"
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
            , None
            )
        , Repository
            ( { name = "unbreakable"
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
            , None
            )
        , Terminal ( "valentin", [ Command [ ( Default, "yarn build" ) ] ] )
        , Application <| FakeBrowser "https://unbreakable.com" <| Html.div [] [ Html.text "This is the content" ]
        , Application <| FakeBrowserWithConsole "https://unbreakable.com" (Html.div [] [ Html.text "This is the content, but there is an error" ]) [ "oh no :( TypeError" ]
        ]
