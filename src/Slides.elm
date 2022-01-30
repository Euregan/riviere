module Slides exposing (slides)

import Deck exposing (Deck)
import Extension exposing (Extension(..))
import File exposing (File(..))
import FileTree exposing (File(..))


slides : Deck
slides =
    Deck.init
        ( { name = "unbreakable"
          , files = []
          }
        , None
        )
        [ ( { name = "unbreakable"
            , files =
                [ File "package.json" JSON
                , File "package-lock.json" JSON
                ]
            }
          , None
          )
        , ( { name = "unbreakable"
            , files =
                [ File "package.json" JSON
                , File "package-lock.json" JSON
                , File "webpack.config.js" JavaScript
                , File "index.html" HTML
                ]
            }
          , None
          )
        , ( { name = "unbreakable"
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
        , ( { name = "unbreakable"
            , files =
                [ File "package.json" JSON
                , File "package-lock.json" JSON
                , File "webpack.config.js" JavaScript
                , File "index.html" HTML
                ]
            }
          , SelectedFile
                { name = "index.html"
                , extension = JavaScript
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
        , ( { name = "unbreakable"
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
        , ( { name = "unbreakable"
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
        ]
