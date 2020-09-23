module View.Emails exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaHidden)
import Message exposing (Msg(..))
import String
import View.Desktop exposing (..)


view : Html Msg
view =
    ul [ class "email-list" ]
        [ renderEmail "Kris" "Important News" "/emails/1" "red"
        , renderEmail "Katja" "Interesting Stuff" "/emails/2" "blue"
        , renderEmail "Nick" "Fish" "/emails/3" "green"
        ]


renderEmail : String -> String -> String -> String -> Html msg
renderEmail from subject link colour =
    li
        [ class "email" ]
        [ a [ class "text-body", href link ]
            [ div [ class "email-icon", class colour, ariaHidden True ]
                [ text (String.left 1 from)
                ]
            , div [ class "email-info" ]
                [ h2 [] [ text subject ]
                , p [] [ text from ]
                ]
            ]
        ]
