module FeedbackForm exposing (count, render)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import GameData exposing (GameData, NotificationCount)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)
import Message exposing (Msg(..))
import Route exposing (Route(..))


render : Int -> Html Msg
render formId =
    if formSource formId == "" then
        text ""

    else
        div [ class "modal", attribute "style" "display:block", id "finalScoreFeedback" ]
            [ div [ class "modal-dialog modal-dialog-centered" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-body" ]
                        [ iframe
                            [ src (formSource formId)
                            , style "height" "780px"
                            , style "width" "100%"
                            ]
                            []
                        ]
                    , div [ class "modal-footer" ]
                        [ button [ attribute "type" "button", class "btn btn-secondary", onClick (ChoiceButtonClicked "score") ] [ text (t FeedbackFormClose) ]
                        ]
                    ]
                ]
            ]


count : List String -> Int
count choiceList =
    List.filter (\choice -> choice == "feedback") choiceList
        |> List.length


formSource : Int -> String
formSource formId =
    case formId of
        1 ->
            t FeedbackForm1Source

        2 ->
            t FeedbackForm2Source

        3 ->
            t FeedbackForm3Source

        _ ->
            ""
