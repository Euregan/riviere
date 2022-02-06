module Message exposing (Key(..), Message(..))

import Browser
import Url


type Key
    = ArrowLeft
    | ArrowRight
    | Space
    | Other


type Message
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Clicked
    | Tick Float
    | KeyPressed Key
