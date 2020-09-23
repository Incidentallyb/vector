module View.Emails exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaHidden)
import Message exposing (Msg(..))
import Route exposing (Route(..))
import String


view : Html Msg
view =
    ul [ class "email-list" ]
        [ renderEmail "Kris" "Important News" 1 "red"
        , renderEmail "Katja" "Interesting Stuff" 2 "blue"
        , renderEmail "Nick" "Fish" 3 "green"
        ]


renderEmail : String -> String -> Int -> String -> Html msg
renderEmail from subject routeId colour =
    li
        [ class "email-list-item" ]
        [ a [ class "text-body", href (Route.toString (Email routeId)) ]
            [ div [ class ("email-icon " ++ colour), ariaHidden True ]
                [ text (String.left 1 from)
                ]
            , div [ class "email-info ml-3" ]
                [ h2 [ class "m-0" ] [ text subject ]
                , p [ class "m-0" ] [ text from ]
                ]
            ]
        ]
