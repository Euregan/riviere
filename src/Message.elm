module Message exposing (Message(..), PageMessage(..))

import Browser
import Key exposing (Key(..))
import Page.Home as Home
import Page.Presentation as Presentation
import Page.Signin as Signin
import Page.Signup as Signup
import Url


type PageMessage
    = HomeMessage Home.Message
    | PresentationMessage Presentation.Message
    | SignupMessage Signup.Message
    | SigninMessage Signin.Message


type Message
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Clicked
    | Tick Float
    | KeyPressed Key
    | PageMessage PageMessage
