module View.ChoiceButtons exposing (choiceStringsToButtons, renderButtons, renderCheckboxes)

import GameData
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Message exposing (Msg(..))
import Set exposing (Set)


type alias ButtonInfo =
    { label : String
    , action : String
    }


type alias ButtonWithHeading =
    { heading : String
    , description : String
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


buttonWithHeadingFromButtonInfo : String -> ButtonInfo -> ButtonWithHeading
buttonWithHeadingFromButtonInfo splitter info =
    let
        labelParts =
            String.split splitter info.label
    in
    -- The part before the splitter
    { heading = Maybe.withDefault "" (List.head labelParts)

    -- The part after the splitter
    , description = Maybe.withDefault "" (List.head (List.reverse labelParts))
    , action = info.action
    }


allowedSubmitValues =
    Set.fromList [ "two-extras", "one-extra", "nothing" ]


renderCheckbox : ButtonWithHeading -> Html Msg
renderCheckbox info =
    -- if this is is one of the submit values then don't make a button.
    if Set.member info.action allowedSubmitValues then
        text ""

    else
        -- Check markup for a11y
        button
            [ class "btn checkbox-button"
            , if True then
                onClick (CheckboxClicked info.action)

              else
                Html.Attributes.class ""
            ]
            [ span [] [ text info.heading ], span [] [ text info.description ] ]


renderCheckboxes : List ButtonInfo -> GameData.CheckboxData -> String -> Html Msg
renderCheckboxes buttonList checkboxes chosenValue =
    let
        submitValue =
            "two-extras"

        -- Transform the button text to contain headings
        splitButtonText =
            List.map (\choiceText -> buttonWithHeadingFromButtonInfo " - " choiceText) buttonList
    in
    div []
        [ div []
            -- The multiple choices
            (List.map (\checkboxInfo -> renderCheckbox checkboxInfo) splitButtonText)
        , -- The chooser submit value
          button
            [ classList
                [ ( "btn choice-button", True )
                , ( "btn-primary", chosenValue == "" )
                ]
            , onClick (CheckboxesSubmitted submitValue)
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
