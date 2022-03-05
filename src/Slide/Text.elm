module Slide.Text exposing (DisplayText, Text(..), swap, tick, view)

import Html exposing (Html, div, h1, h2, text)
import Html.Attributes exposing (class, style)
import Message exposing (Message)


type Text
    = Title
        { title : String
        , subtitle : Maybe String
        }
    | Text
        { title : String
        , content : List String
        }


type DisplayText
    = DisplayTitle
        { title : String
        , subtitle : Maybe String
        }
    | DisplayText
        { title : String
        , content : List String
        }


view : DisplayText -> Html Message
view displayText =
    case displayText of
        DisplayTitle { title, subtitle } ->
            div
                [ style "display" "flex"
                , style "height" "100%"
                , style "flex-direction" "column"
                , style "align-items" "center"
                , if subtitle == Nothing then
                    style "justify-content" "center"

                  else
                    style "" ""
                ]
                [ h1 [] [ text title ]
                , h2 [] [ subtitle |> Maybe.withDefault "" |> text ]
                ]

        DisplayText { title, content } ->
            div [] <| h1 [] [ text title ] :: List.map (\c -> div [ style "font-size" "1.5rem" ] [ text c ]) content


swap : Text -> Text -> DisplayText
swap from to =
    case to of
        Title content ->
            DisplayTitle content

        Text content ->
            DisplayText content


tick : Float -> DisplayText -> DisplayText
tick delta title =
    title
