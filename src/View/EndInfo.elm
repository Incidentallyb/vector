module View.EndInfo exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import Message exposing (Msg(..))
import Route exposing (Route(..))


view : Html Msg
view =
    div [ class "end container-fluid" ]
        [ div [ class "container" ]
            [ div [ class "row my-4" ]
                [ div [ class "col-12" ]
                    [ h1 [ class "d-block mx-auto text-center" ]
                        [ text (t EndInfoHeader)
                        ]
                    ]
                , Markdown.toHtml [ class "col-12 mt-4" ]
                    -- join each string with newlines so Markdown.toHtml can insert paragraphs
                    -- could be joined into one string in Text.elm instead
                    (t EndInfoParagraph1
                        ++ "\n\n"
                        ++ t EndInfoParagraph2
                        ++ "\n\n"
                        ++ t EndInfoParagraph3
                        ++ "\n\n"
                        ++ t EndInfoParagraph4
                    )
                ]
            ]
        , footer [ class "row d-flex justify-content-center" ]
            [ img [ src "images/wellcome-logo.png", alt "Wellcome Trust" ] []
            , img [ src "images/AnNex_Logo_600.png", alt "Annex - Animal Research Nexus" ] []
            , img [ src "images/lab-collective.png", alt "Lab Collective" ] []
            ]
        ]
