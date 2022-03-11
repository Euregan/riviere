module Extension exposing (Extension(..), decoder, encode, view)

import Icon
import Json.Decode as Decode
import Json.Encode as Encode
import Svg exposing (Svg)


type Extension
    = JSON
    | JSX
    | TSX
    | JavaScript
    | TypeScript
    | HTML
    | Elm


encode : Extension -> Encode.Value
encode extension =
    case extension of
        JSON ->
            Encode.string "json"

        JSX ->
            Encode.string "jsx"

        TSX ->
            Encode.string "tsx"

        JavaScript ->
            Encode.string "javascript"

        TypeScript ->
            Encode.string "typescript"

        HTML ->
            Encode.string "html"

        Elm ->
            Encode.string "elm"


decoder : Decode.Decoder Extension
decoder =
    Decode.string
        |> Decode.andThen
            (\extension ->
                case extension of
                    "json" ->
                        Decode.succeed JSON

                    "jsx" ->
                        Decode.succeed JSX

                    "tsx" ->
                        Decode.succeed TSX

                    "javascript" ->
                        Decode.succeed JavaScript

                    "typescript" ->
                        Decode.succeed TypeScript

                    "html" ->
                        Decode.succeed HTML

                    "elm" ->
                        Decode.succeed Elm

                    _ ->
                        Decode.fail <| "Extension " ++ extension ++ " is not yet supported"
            )


view : Extension -> Svg msg
view icon =
    case icon of
        JSON ->
            Icon.json

        JSX ->
            Icon.jsx

        TSX ->
            Icon.tsx

        JavaScript ->
            Icon.javascript

        HTML ->
            Icon.html

        TypeScript ->
            Icon.typescript

        Elm ->
            Icon.elm
