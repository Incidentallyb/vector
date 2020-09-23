module View.Desktop exposing (renderWrapperWithNav, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))
import Heroicons.Outline exposing (mail, documentText, chatAlt, hashtag)

iconSize : Int 
iconSize = 24

view : Html Msg
view =
    div []
        [ h1 [] [ text "Desktop" ]
        , renderWrapperWithNav [ text "my desktop"]
        ]


renderWrapperWithNav : List (Html Msg) -> Html Msg
renderWrapperWithNav elements  =
    div [ class "container" ] [
        div [ class "row" ] [
            div [ class "col-sm-auto" ] [
                renderTeamInformation
                , renderNavLinks
            ],
            div [ class "col" ] elements
        ]
    ]

renderNavLinks : Html Msg
renderNavLinks =
    nav [ class "nav flex-column nav-pills" ]
        [ a [ class "nav-link", href "/documents" ] [ documentText [ width iconSize, height iconSize], text " documents ", 
            span [ class "badge badge-secondary" ] [ text "4" ]
        ]
        , a [ class "nav-link active", href "/emails" ] [ mail [ width iconSize, height iconSize], text " emails" ]
        , a [ class "nav-link", href "/messages" ] [ chatAlt [ width iconSize, height iconSize], text " messages" ]
        , a [ class "nav-link", href "/tweets" ] [ hashtag [ width iconSize, height iconSize], text " tweets" ]
        ]

renderTeamInformation : Html Msg
renderTeamInformation = 
    div [] [
        div [ class "card" ] [
            
            div [ class "card-body" ] [
                h5 [class "card-title"] [ text "Team Elm" ],
                p [ class "card-text"] [ text "more text here"]
            ]
        ]
    ]