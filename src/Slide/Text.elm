module Slide.Text exposing (DisplayText, Text(..), swap, tick, view)

import Html exposing (Html, div, h1, h2, text)
import Html.Attributes exposing (class, style)
import Json.Decode as Decode
import Json.Encode as Encode


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


encode : Text -> Encode.Value
encode text =
    case text of
        Title { title, subtitle } ->
            Encode.object
                [ ( "type", Encode.string "title" )
                , ( "title", Encode.string title )
                , ( "subtitle", Maybe.withDefault Encode.null <| Maybe.map Encode.string subtitle )
                ]

        Text { title, content } ->
            Encode.object
                [ ( "type", Encode.string "text" )
                , ( "title", Encode.string title )
                , ( "content", Encode.list Encode.string content )
                ]


decoder : Decode.Decoder Text
decoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\type_ ->
                case type_ of
                    "title" ->
                        Decode.map2 (\title subtitle -> Title { title = title, subtitle = subtitle })
                            (Decode.field "title" Decode.string)
                            (Decode.field "subtitle" (Decode.nullable Decode.string))

                    "text" ->
                        Decode.map2 (\title content -> Text { title = title, content = content })
                            (Decode.field "title" Decode.string)
                            (Decode.field "content" (Decode.list Decode.string))

                    _ ->
                        Decode.fail <| "Type " ++ type_ ++ " is not a valid type for a Text slide"
            )


view : DisplayText -> Html msg
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
