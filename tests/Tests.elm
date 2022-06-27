module Tests exposing (..)

import Dict
import Expect
import Json.Decode as Decode exposing (..)
import NoDesign.Form as Form
import Test exposing (..)


decoderSuite : Test
decoderSuite =
    describe "Decoding the Form Definition from Json to Types"
        [ describe "decoder for Radio"
            [ test "with basic `type_: radio` definition" <|
                \() ->
                    """
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
                    }
                    """
                        |> Decode.decodeString Form.inputsDecoder
                        |> Expect.equal
                            (Ok
                                (Form.Radio
                                    (Form.Label_ "Destination")
                                    (Form.FieldName_ "destination")
                                    (Form.Options_
                                        [ Form.RadioOption "destination1" "Afghanistan"
                                        , Form.RadioOption "destination2" "Åland Islands"
                                        , Form.RadioOption "destination3" "Albania"
                                        , Form.RadioOption "destination4" "Algeria"
                                        ]
                                    )
                                )
                            )
            ]
        , describe "decoder for InterleavedElement"
            [ test "with basic `type_: interleaved` definition" <|
                \() ->
                    """
                    {
                        "type_": "interleaved",
                        "elementId": "explain__i98123289798"
                    }
                    """
                        |> Decode.decodeString Form.inputsDecoder
                        |> Expect.equal
                            (Ok
                                (Form.InterleavedElement
                                    (Form.ElementId_ "explain__i98123289798")
                                )
                            )
            ]
        , describe "decoder for Form Definition"
            [ test "with basic form" <|
                \() ->
                    formDefinitionJson
                        |> Decode.decodeString Form.formDecoder
                        |> Expect.equal
                            (Ok
                                (Form.Inputs_
                                    [ Form.Radio
                                        (Form.Label_ "Destination")
                                        (Form.FieldName_ "destination")
                                        (Form.Options_
                                            [ Form.RadioOption "destination1" "Afghanistan"
                                            , Form.RadioOption "destination2" "Åland Islands"
                                            , Form.RadioOption "destination3" "Albania"
                                            , Form.RadioOption "destination4" "Algeria"
                                            ]
                                        )
                                    ]
                                )
                            )
            ]
        ]


formDefinitionJson =
    """
    {
        "inputs": [
            {
                "type_": "radio",
                "fieldName": "destination",
                "label": "Destination",
                "options":
                    [
                        { "id": "destination1", "textLabel": "Afghanistan" },
                        { "id": "destination2", "textLabel": "Åland Islands" },
                        { "id": "destination3", "textLabel": "Albania" },
                        { "id": "destination4", "textLabel": "Algeria" }
                ]
            }
        ]
    }
    """
