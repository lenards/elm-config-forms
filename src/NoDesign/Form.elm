module NoDesign.Form exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, span, text)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra exposing (when)
import Json.Decode.Pipeline exposing (required)
import NoDesign.Radio as Radio


type Inputs
    = Radio Label FieldName Options
    | InterleavedElement ElementId


type Label
    = Label_ String


type FieldName
    = FieldName_ String


type Options
    = Options_ (List RadioOption)


type alias RadioOption =
    { id : String, textLabel : String }


type ElementId
    = ElementId_ String


type FormInputs
    = Inputs_ (List Inputs)


getKey : Inputs -> String
getKey inputDef =
    case inputDef of
        Radio _ (FieldName_ fieldName) _ ->
            fieldName

        InterleavedElement (ElementId_ elementId) ->
            elementId


view : Result Decode.Error FormInputs -> (String -> msg) -> List (Html msg)
view result tagMsg =
    case result of
        Ok inputs ->
            viewInputs inputs tagMsg

        Err _ ->
            [ span [] [] ]


viewInputs : FormInputs -> (String -> msg) -> List (Html msg)
viewInputs (Inputs_ inputs) tagMsg =
    inputs
        |> List.map (render tagMsg)


render : (String -> msg) -> Inputs -> Html msg
render tagMsg input =
    case input of
        Radio (Label_ label) (FieldName_ fieldName) (Options_ options) ->
            Radio.radio
                { descriptiveLabel = label
                , fieldName = fieldName
                , options = options
                , msgTagger = tagMsg
                }

        InterleavedElement _ ->
            span [] [ text "" ]


optionDecoder : Decoder RadioOption
optionDecoder =
    Decode.succeed RadioOption
        |> required "id" Decode.string
        |> required "textLabel" Decode.string


optionsDecoder : Decoder (List RadioOption)
optionsDecoder =
    Decode.list optionDecoder


radioDecoder : Decoder Inputs
radioDecoder =
    Decode.succeed Radio
        |> required "label" (Decode.map Label_ Decode.string)
        |> required "fieldName" (Decode.map FieldName_ Decode.string)
        |> required "options" (Decode.map Options_ optionsDecoder)


interleavedDecoder : Decoder Inputs
interleavedDecoder =
    Decode.succeed InterleavedElement
        |> required "elementId" (Decode.map ElementId_ Decode.string)


inputsType : Decoder String
inputsType =
    Decode.field "type_" Decode.string


inputsDecoder : Decoder Inputs
inputsDecoder =
    let
        is : value -> value -> Bool
        is lhs rhs =
            lhs == rhs
    in
    Decode.oneOf
        [ when inputsType (is "radio") radioDecoder
        , when inputsType (is "interleaved") interleavedDecoder
        ]


formDecoder : Decoder FormInputs
formDecoder =
    Decode.succeed Inputs_
        |> required "inputs" (Decode.list inputsDecoder)
