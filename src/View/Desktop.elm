module View.Desktop exposing (renderWrapperWithNav, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Heroicons.Outline exposing (chatAlt, documentText, hashtag, mail)
import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))
import Route exposing (Route(..))


iconSize : Int
iconSize =
    24


view : Route -> Html Msg
view pageRoute =
    div []
        [ renderWrapperWithNav pageRoute [ text "my desktop" ]
        ]


renderWrapperWithNav : Route -> List (Html Msg) -> Html Msg
renderWrapperWithNav pageRoute elements =
    div [ class "container-fluid" ]
        [ div [ class "row" ]
            [ div [ class "col-sm-auto" ]
                [ renderTeamInformation
                , renderNavLinks pageRoute
                ]
            , div [ class "col" ] elements
            ]
        ]



-- @todo implement "nav-link active" class using pageRoute


renderNavLinks : Route -> Html Msg
renderNavLinks pageRoute =
    nav [ class "nav flex-column nav-pills" ]
        [ a
            [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Documents )
                ]
            , href (Route.toString Route.Documents)
            ]
            [ documentText [ width iconSize, height iconSize ]
            , text " "
            , text (t NavDocuments)
            , text " "
            , span [ class "badge badge-secondary" ] [ text "4" ]
            ]
        , a [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Emails )
                ]
            , href (Route.toString Route.Emails)
            ]
            [ mail [ width iconSize, height iconSize ]
            , text " "
            , text (t NavEmails)
            ]
        , a [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Messages )
                ]
            , href (Route.toString Route.Messages) ]
            [ chatAlt [ width iconSize, height iconSize ]
            , text " "
            , text (t NavMessages)
            ]
        , a [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Social )
                ]
            , href (Route.toString Route.Social) ]
            [ hashtag [ width iconSize, height iconSize ]
            , text " "
            , text (t NavSocial)
            ]
        ]

renderTeamInformation : Html Msg
renderTeamInformation =
    div []
        [ div [ class "card" ]
            [ div [ class "card-body" ]
                [ h5 [ class "card-title" ] [ text "Team Elm" ]
                , p [ class "card-text" ] [ text "tree picture here" ]
                ]
            ]
        ]
