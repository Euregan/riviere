module Title exposing (DisplayTitle, Title, swap, tick, view)

import Html exposing (Html, h1, text)
import Html.Attributes exposing (class, style)


type alias Title =
    { title : String }


type DisplayTitle
    = DisplayTitle Title


view : DisplayTitle -> Html msg
view (DisplayTitle { title }) =
    h1 [] [ text title ]


swap : Title -> Title -> DisplayTitle
swap from to =
    DisplayTitle to


tick : Float -> DisplayTitle -> DisplayTitle
tick delta title =
    title
