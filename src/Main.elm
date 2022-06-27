module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src, style)
import Json.Decode as Decode
import NoDesign.Form as Form



---- MODEL ----


type alias Model =
    { formInputs : Result Decode.Error Form.FormInputs }


formDefinition : String
formDefinition =
    """
    {
        "inputs": [
            {
                "type_": "radio",
                "fieldName": "destination",
                "label": "Destination",
                "options": [
                    { "id": "destination1", "textLabel": "Afghanistan" },
                    { "id": "destination2", "textLabel": "Åland Islands" },
                    { "id": "destination3", "textLabel": "Albania" },
                    { "id": "destination4", "textLabel": "Algeria" }
                ]
            },
            {
                "type_": "radio",
                "fieldName": "return",
                "label": "Return",
                "options": [
                    { "id": "return1", "textLabel": "Afghanistan" },
                    { "id": "return2", "textLabel": "Åland Islands" },
                    { "id": "return3", "textLabel": "Albania" },
                    { "id": "return4", "textLabel": "Algeria" }
                ]
            },
            {
                "type_": "radio",
                "fieldName": "roundTrip",
                "label": "Round Trip?",
                "options": [
                    { "id": "roundTrip1", "textLabel": "Yes" },
                    { "id": "roundTrip2", "textLabel": "No" }
                ]
            }
        ]
    }
    """


init : ( Model, Cmd Msg )
init =
    ( { formInputs = Decode.decodeString Form.formDecoder formDefinition
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | RadioMsg String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , div
            [ style "display" "flex"
            , style "flex-direction" "column"
            , style "width" "35%"
            , style "margin" "auto"
            ]
            (Form.view model.formInputs RadioMsg)
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
