module FileTree exposing (DisplayFileTree, File(..), FileTree, swap, tick, view)

import Extension exposing (Extension)
import Html exposing (Html, div, h2, img, li, text, ul)
import Html.Attributes exposing (src, style)
import Icon
import Message exposing (Message)


newColor =
    "#9da5b4"


transitionDuration =
    200


type Transition
    = Idle Visibility
    | Appearing Float
    | Disappearing Float


type Visibility
    = Visible
    | Hidden


type File
    = File String Extension
    | Directory String (List File)


type alias FileTree =
    { name : String
    , files : List File
    }


type DisplayFile
    = DisplayFile
        { name : String
        , extension : Extension
        , transition : Transition
        }
    | DisplayDirectory
        { name : String
        , children : List DisplayFile
        , transition : Transition
        }


type alias DisplayFileTree =
    { name : String
    , files : List DisplayFile
    }


type Comparison a
    = NotFound
    | Keep a
    | Drop


viewFileRaw : Transition -> Html Message -> Html Message -> Html Message
viewFileRaw transition icon text =
    let
        percentFromTransition : Float
        percentFromTransition =
            case transition of
                Idle Visible ->
                    1

                Idle Hidden ->
                    0

                Appearing percent ->
                    percent

                Disappearing percent ->
                    1 - percent
    in
    div
        [ style "display" "flex"
        , style "gap" "0.5rem"
        , style "align-items" "center"
        , style "overflow" "hidden"
        , style "height" (String.fromFloat (percentFromTransition * 1.25) ++ "rem")
        ]
        [ icon, text ]


tick : Float -> DisplayFileTree -> DisplayFileTree
tick delta tree =
    let
        tickFile : DisplayFile -> DisplayFile
        tickFile file =
            case file of
                DisplayFile f ->
                    case f.transition of
                        Idle _ ->
                            DisplayFile f

                        Appearing percent ->
                            if percent + (delta / transitionDuration) > 1 then
                                DisplayFile { f | transition = Idle Visible }

                            else
                                DisplayFile { f | transition = Appearing (percent + (delta / transitionDuration)) }

                        Disappearing percent ->
                            if percent + (delta / transitionDuration) > 1 then
                                DisplayFile { f | transition = Idle Hidden }

                            else
                                DisplayFile { f | transition = Disappearing (percent + (delta / transitionDuration)) }

                DisplayDirectory d ->
                    case d.transition of
                        Idle _ ->
                            DisplayDirectory { d | children = List.map tickFile d.children }

                        Appearing percent ->
                            if percent + (delta / transitionDuration) > 1 then
                                DisplayDirectory
                                    { d
                                        | transition = Idle Visible
                                        , children = List.map tickFile d.children
                                    }

                            else
                                DisplayDirectory
                                    { d
                                        | transition = Appearing (percent + (delta / transitionDuration))
                                        , children = List.map tickFile d.children
                                    }

                        Disappearing percent ->
                            if percent + (delta / transitionDuration) > 1 then
                                DisplayDirectory
                                    { d
                                        | transition = Idle Hidden
                                        , children = List.map tickFile d.children
                                    }

                            else
                                DisplayDirectory
                                    { d
                                        | transition = Disappearing (percent + (delta / transitionDuration))
                                        , children = List.map tickFile d.children
                                    }
    in
    { tree | files = List.map tickFile tree.files }


view : DisplayFileTree -> Html Message
view tree =
    let
        viewFile : DisplayFile -> Html Message
        viewFile file =
            li [] <|
                case file of
                    DisplayFile { name, extension, transition } ->
                        [ viewFileRaw transition (Extension.view extension) (text name)
                        ]

                    DisplayDirectory { name, children, transition } ->
                        [ viewFileRaw transition Icon.folder (text name)
                        , ul [] <| List.map viewFile children
                        ]
    in
    ul
        [ style "background" "#21252b"
        , style "color" newColor
        , style "fill" newColor
        , style "height" "100%"
        , style "padding" "2rem"
        , style "box-sizing" "border-box"
        , style "min-width" "25rem"
        , style "border-radius" "0.6rem"
        , style "box-shadow" "rgba(149, 157, 165, 0.2) 0px 8px 24px"
        ]
        [ li []
            [ viewFileRaw (Idle Visible) Icon.git (text tree.name)
            , ul [] <| List.map viewFile tree.files
            ]
        ]


notFoundDefault : a -> Comparison a -> Comparison a
notFoundDefault default comparison =
    case comparison of
        NotFound ->
            Keep default

        _ ->
            comparison


swap : FileTree -> FileTree -> DisplayFileTree
swap from to =
    let
        transitionDirectory : List File -> List File -> List DisplayFile
        transitionDirectory fromFiles toFiles =
            List.append
                (List.map
                    (\fromFile ->
                        List.foldl
                            (\toFile found ->
                                case ( found, fromFile, toFile ) of
                                    ( NotFound, File fromName fromExtension, File toName toExtension ) ->
                                        if fromName == toName && fromExtension == toExtension then
                                            Keep (DisplayFile { name = toName, extension = toExtension, transition = Idle Visible })

                                        else
                                            found

                                    ( NotFound, Directory fromName fromChildren, Directory toName toChildren ) ->
                                        if fromName == toName then
                                            Keep (DisplayDirectory { name = toName, children = transitionDirectory fromChildren toChildren, transition = Idle Visible })

                                        else
                                            found

                                    _ ->
                                        found
                            )
                            NotFound
                            toFiles
                            |> notFoundDefault
                                (case fromFile of
                                    File fromName fromExtension ->
                                        DisplayFile { name = fromName, extension = fromExtension, transition = Disappearing 0 }

                                    Directory fromName children ->
                                        DisplayDirectory { name = fromName, children = transitionDirectory children [], transition = Disappearing 0 }
                                )
                    )
                    fromFiles
                )
                (List.map
                    (\toFile ->
                        List.foldl
                            (\fromFile found ->
                                case ( found, fromFile, toFile ) of
                                    ( NotFound, File fromName fromExtension, File toName toExtension ) ->
                                        if fromName == toName && fromExtension == toExtension then
                                            Drop

                                        else
                                            found

                                    ( NotFound, Directory fromName _, Directory toName _ ) ->
                                        if fromName == toName then
                                            Drop

                                        else
                                            found

                                    _ ->
                                        found
                            )
                            NotFound
                            fromFiles
                            |> notFoundDefault
                                (case toFile of
                                    File toName toExtension ->
                                        DisplayFile { name = toName, extension = toExtension, transition = Appearing 0 }

                                    Directory toName children ->
                                        DisplayDirectory { name = toName, children = transitionDirectory [] children, transition = Appearing 0 }
                                )
                    )
                    toFiles
                )
                |> List.foldl
                    (\comparison kept ->
                        case comparison of
                            Keep element ->
                                element :: kept

                            _ ->
                                kept
                    )
                    []
    in
    { name = to.name
    , files = transitionDirectory from.files to.files
    }
