module Message exposing (Message(..))

import Browser
import Url


type Message
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Clicked
    | Tick Float
