module View.EndInfo exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))
import Route exposing (Route(..))


view : Html Msg
view =
    div [ class "intro container-fluid" ]
        [ div [ class "row my-4" ]
            [ h1 [ class "d-block mx-auto" ]
                [ text "Thank you for playing!"
                ]
            ]
        , div [ class "row my-4" ]
            [ p [] [ text "Vector and Biocore are fictional but based on research, conversations, observations and strategic decisions. Vector was produced by The Lab Collective and Bentley Crudgington as part of the Animal Research Nexus Public Engagement Programme." ]
            ]
        ]
