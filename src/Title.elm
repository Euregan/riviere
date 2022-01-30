module Title exposing (DisplayTitle, Title, swap, tick, view)

import Html exposing (Html, div, h1, h2, text)
import Html.Attributes exposing (class, style)


type alias Title =
    { title : String
    , subtitle : Maybe String
    }


type DisplayTitle
    = DisplayTitle Title


view : DisplayTitle -> Html msg
view (DisplayTitle { title, subtitle }) =
    div []
        [ h1 [] [ text title ]
        , h2 [] [ subtitle |> Maybe.withDefault "" |> text ]
        ]


swap : Title -> Title -> DisplayTitle
swap from to =
    DisplayTitle to


tick : Float -> DisplayTitle -> DisplayTitle
tick delta title =
    title
