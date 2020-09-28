module View.Desktop exposing (renderWrapperWithNav, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Heroicons.Outline exposing (chatAlt, documentText, hashtag, mail)
import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Svg.Attributes


view : Route -> Html Msg
view pageRoute =
    div []
        [ renderWrapperWithNav pageRoute [ text "my desktop" ]
        ]


renderWrapperWithNav : Route -> List (Html Msg) -> Html Msg
renderWrapperWithNav pageRoute elements =
    div [ class "container-fluid " ]
        [ div [ class "row desktop" ]
            [ div [ class "col-sm-auto d-none d-md-block" ]
                [ div [ class "sticky-top" ]
                    [ renderTeamInformation
                    , renderNavLinks pageRoute
                    ]
                ]
            , div [ class "order-last d-md-none" ]
                [ renderMobileNavLinks pageRoute
                ]
            , div [ class "col-md-8 content" ] elements
            ]
        ]


renderNavLinks : Route -> Html Msg
renderNavLinks pageRoute =
    nav [ class "nav flex-column nav-pills" ]
        [ a
            [ classList
                [ ( "nav-link", True )
                , ( "active", Route.isDocumentRoute pageRoute )
                ]
            , href (Route.toString Route.Documents)
            ]
            [ documentText [ Svg.Attributes.class "nav-icon" ]
            , text (t NavDocuments)
            , text " "

            --            , span [ class "badge badge-secondary" ] [ text "4" ]
            ]
        , a
            [ classList
                [ ( "nav-link", True )
                , ( "active", Route.isEmailRoute pageRoute )
                ]
            , href (Route.toString Route.Emails)
            ]
            [ mail [ Svg.Attributes.class "nav-icon" ]
            , text (t NavEmails)
            ]
        , a
            [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Messages )
                ]
            , href (Route.toString Route.Messages)
            ]
            [ chatAlt [ Svg.Attributes.class "nav-icon" ]
            , text (t NavMessages)
            ]
        , a
            [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Social )
                ]
            , href (Route.toString Route.Social)
            ]
            [ hashtag [ Svg.Attributes.class "nav-icon" ]
            , text (t NavSocial)
            ]
        ]


renderMobileNavLinks : Route -> Html Msg
renderMobileNavLinks pageRoute =
    nav [ class "nav nav-pills mobile-nav fixed-bottom" ]
        [ a
            [ classList
                [ ( "nav-link", True )
                , ( "active", Route.isDocumentRoute pageRoute )
                ]
            , class "mobile-nav-item"
            , href (Route.toString Route.Documents)
            ]
            [ documentText [ Svg.Attributes.class "mobile-nav-icon" ]
            , div [] [ text (t NavDocuments) ]
            , text " "

            --            , span [ class "badge badge-secondary" ] [ text "4" ]
            ]
        , a
            [ classList
                [ ( "nav-link", True )
                , ( "active", Route.isEmailRoute pageRoute )
                ]
            , class "mobile-nav-item"
            , href (Route.toString Route.Emails)
            ]
            [ mail [ Svg.Attributes.class "mobile-nav-icon" ]
            , div [] [ text (t NavEmails) ]
            ]
        , a
            [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Messages )
                ]
            , class "mobile-nav-item"
            , href (Route.toString Route.Messages)
            ]
            [ chatAlt [ Svg.Attributes.class "mobile-nav-icon" ]
            , div [] [ text (t NavMessages) ]
            ]
        , a
            [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Social )
                ]
            , class "mobile-nav-item"
            , href (Route.toString Route.Social)
            ]
            [ hashtag [ Svg.Attributes.class "mobile-nav-icon" ]
            , div [] [ text (t NavSocial) ]
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
