module View.Landing exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))


view : Html Msg
view =
    div [ class "landing container-fluid" ]
        [ div [ class "container" ]
            [ div [ class "row my-5" ]
                [ div [ class "col-12" ]
                    [ h1 [ class "d-block mx-auto text-center" ]
                        [ text (t LandingHeader)
                        ]
                    ]
                , Markdown.toHtml [ class "col-12 mt-4" ]
                    -- join each string with newlines so Markdown.toHtml can insert paragraphs
                    -- could be joined into one string in Text.elm instead
                    (t LandingParagraph1
                        ++ "\n\n"
                        ++ t LandingParagraph2
                    )
                ]
            , div [ class "row my-4" ]
                [ iframe
                    [ class "d-block mx-auto"
                    , width 560
                    , height 315
                    , src (t LandingVideo)
                    , attribute "frameborder" "0"
                    , attribute "allowfullscreen" "true"
                    , attribute "gyroscope" "true"
                    , attribute "allow" "autoplay"
                    , attribute "title" (t LandingVideo)
                    ]
                    []
                ]
            , div [ class "row my-5 text-center" ]
                [ div [ class "col-12 text-center" ]
                    [ a [ class "btn btn-primary btn-lg mx-auto", href (Route.toString Route.Intro) ] [ text (t LandingLinkText) ]
                    ]
                ]
            ]
        , footer [ class "row d-flex justify-content-center" ]
            [ img [ src "images/wellcome-logo.png", alt "Wellcome Trust" ] []
            , img [ src "images/AnNex_Logo_600.png", alt "Annex - Animal Research Nexus" ] []
            ]
        ]
