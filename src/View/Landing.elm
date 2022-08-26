module View.Landing exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Video exposing (Video(..), videoToData)
import View.Video


view : Html Msg
view =
    div [ class "landing container-fluid" ]
        [ div [ class "container" ]
            [ View.Video.view (videoToData Video.Landing)
            , div [ class "row my-5 text-center" ]
                [ div [ class "col-12 text-center" ]
                    [ a [ class "btn btn-primary btn-lg mx-auto", href (Route.toString Route.Intro) ] [ text (t LandingLinkText) ]
                    ]
                ]
            , div [ class "row my-5" ]
                [ Markdown.toHtml []
                    (t LandingParagraph)
                ]
            ]
        , footer [ class "row d-flex justify-content-center" ]
            [ img [ src "images/wellcome-logo.png", alt "Wellcome Trust" ] []
            , img [ src "images/AnNex_Logo_600.png", alt "Annex - Animal Research Nexus" ] []
            , img [ src "images/lab-collective.png", alt "Lab Collective" ] []
            ]
        ]
