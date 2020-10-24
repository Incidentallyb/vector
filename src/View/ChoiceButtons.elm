module View.ChoiceButtons exposing (ButtonInfo, choiceStringsToButtons, renderButtons, renderCheckboxes)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Message exposing (Msg(..))


type alias ButtonInfo =
    { label : String
    , action : String
    }


choiceStringsToButtons : String -> ButtonInfo
choiceStringsToButtons buttonString =
    let
        ( parsedString, action ) =
            ( case List.head (String.indexes "|" buttonString) of
                Nothing ->
                    buttonString

                Just val ->
                    String.dropLeft (val + 1) buttonString
            , case List.head (String.indexes "|" buttonString) of
                Nothing ->
                    buttonString

                Just val ->
                    String.left val buttonString
            )
    in
    { label = parsedString, action = action }


renderCheckboxes : List ButtonInfo -> String -> Html Msg
renderCheckboxes buttonList chosenValue =
    let
        submitValue =
            "two-extras"

        -- Transform the button text
        splitButtonText =
            List.map
                (\choiceText ->
                    Tuple.pair
                        (Maybe.withDefault "" (List.head (String.split " - " choiceText.label)))
                        (Maybe.withDefault "" (List.head (List.reverse (String.split " - " choiceText.label))))
                )
                buttonList
    in
    div []
        [ div []
            (List.map
                (\( heading, description ) ->
                    button
                        [ class "btn"
                        , if chosenValue == "" then
                            onClick (ChoiceButtonClicked submitValue)

                          else
                            Html.Attributes.class ""
                        ]
                        [ span [] [ text heading ], span [] [ text description ] ]
                )
                splitButtonText
            )
        , button
            [ classList
                [ ( "btn choice-button", True )
                , ( "btn-primary", chosenValue == "" )
                ]
            , onClick (ChoiceButtonClicked submitValue)
            ]
            [ text "Submit choices" ]
        ]


renderButtons : List ButtonInfo -> String -> List (Html Msg)
renderButtons buttonList chosenValue =
    List.map
        (\buttonItem ->
            button
                [ classList
                    [ ( "btn choice-button", True )
                    , ( "btn-primary", chosenValue == "" )
                    , ( "active", chosenValue == buttonItem.action )
                    , ( "disabled", chosenValue /= buttonItem.action && chosenValue /= "" )
                    ]
                , if chosenValue == "" then
                    onClick (ChoiceButtonClicked buttonItem.action)

                  else
                    Html.Attributes.class ""
                ]
                [ text buttonItem.label ]
        )
        buttonList
