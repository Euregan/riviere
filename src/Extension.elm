module Extension exposing (Extension(..), view)

import Icon
import Message exposing (Message)
import Svg exposing (Svg)


type Extension
    = JSON
    | JSX
    | TSX
    | JavaScript
    | HTML


view : Extension -> Svg Message
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
