module NoDesign.Radio exposing (radio)

import Html
    exposing
        ( Html
        , div
        , fieldset
        , input
        , label
        , legend
        , span
        , text
        )
import Html.Attributes as Attr


option : { fieldName : String, option : { id : String, textLabel : String } } -> Html msg
option args =
    div
        [ Attr.class "field-radioButton" ]
        [ label
            [ Attr.for args.fieldName
            ]
            [ input
                [ Attr.type_ "radio"
                , Attr.name args.fieldName
                , Attr.value args.option.textLabel
                , Attr.id args.option.id
                ]
                []
            , text args.option.textLabel
            ]
        ]


radio :
    { descriptiveLabel : String
    , fieldName : String
    , options : List { id : String, textLabel : String }
    , msgTagger : String -> msg
    }
    -> Html msg
radio args =
    let
        renderOption option_ =
            option
                { fieldName = args.fieldName
                , option = option_
                }
    in
    fieldset
        [ Attr.class "field" ]
        [ legend []
            [ span
                [ Attr.class "field-legend"
                ]
                [ text args.descriptiveLabel ]
            ]
        , div
            [ Attr.class "field-options"
            , Attr.style "display" "flex"
            , Attr.style "flex-direction" "column"
            , Attr.style "align-items" "flex-start"
            ]
            (List.map renderOption args.options)
        ]
