module View.Desktop exposing (renderWrapperWithNav, renderTopNavigation, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import GameData exposing (GameData, NotificationCount)
import Heroicons.Outline exposing (chatAlt, documentText, hashtag, mail)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)
import Json.Decode as Json
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Svg.Attributes


view : GameData -> Route -> NotificationCount -> Html Msg
view gameData pageRoute notifications =
    case String.left 1 gameData.teamName of
        "?" ->
            renderLoginPage gameData

        {-
           When the team name consists of a ? or is prefixed with a ?, we should show the login box.

           A ? prefix on teamname value is used so that we can change the model's data value in the
           <select> 'onChange' event without instantly navigating away from this page (which is a weird user experience)
           - instead, they click on the login <button> which removes the '?' prefix from the teamName
        -}
        _ ->
            div []
                [ renderTopNavigation gameData.teamName
                , renderWrapperWithNav gameData
                    pageRoute
                    notifications
                    [ div [ class "welcome" ]
                        [ h1 [] [ text (t DesktopWelcome) ]
                        , p [ class "desktopParagraph1" ] [ text (t DesktopParagraph1) ]
                        , p [ class "desktopParagraph2" ] [ text (t DesktopParagraph2) ]
                        , p [ class "desktopParagraph3" ] [ text (t DesktopParagraph3) ]
                        , p [ class "desktopParagraph4" ] [ text (t DesktopParagraph4) ]
                        ]
                    ]
                ]


renderTopNavigation : String -> Html Msg
renderTopNavigation teamName = 
    nav [ class "navbar navbar-light bg-light"] [
        a [ class "navbar-brand", href "#" ] [ text (t Navbar) ]
        {- 
        , button [ class "navbar-toggler", attribute "type" "button" , attribute "data-toggle" "collapse" , attribute "data-target" "#navbar" , attribute "aria-controls" "navbar" , attribute "aria-expanded" "false", attribute "aria-label" "Toggle navigation" ] [ 
            span [ class "navbar-toggler-icon" ] [ ] 
        ] -}
        , div [ id "navbar" ] [
            ul [ class "navbar-nav ml-auto" ] [
                li [ class "nav-item active" ] [ 
                    a [ class "nav-link", href "#" ] [ text ("Team " ++ teamName) ]
                ]
                , audio
                    [ src "/audio/vector_loop_1_web.ogg"
                    , id "audio-player"
                    , controls True
                    , autoplay True
                    , loop True
                    ] []
            ]
        ]
    
    ]

renderWrapperWithNav : GameData -> Route -> NotificationCount -> List (Html Msg) -> Html Msg
renderWrapperWithNav gameData pageRoute notifications elements =
    div [ class "container-fluid " ]
        [ div [ class "row desktop", id "desktop" ]
            [ div [ class "col-md-3 d-none d-md-block" ]
                [ div [ class "sticky-top" ]
                    [ renderTeamInformation gameData.teamName
                    , renderNavLinks pageRoute notifications

                    -- DEBUG ONLY!
                    -- , div [ class "debug-score" ]
                    --     [ div [ class "economic" ] [ text ("£" ++ String.fromInt gameData.scoreEconomic) ]
                    --     , div [ class "harm" ] [ text (String.fromInt gameData.scoreHarm) ]
                    --     , div [ class "success" ] [ text (String.fromInt gameData.scoreSuccess ++ "%") ]
                    --     , div [ class "choices" ] [ text (String.join " " (List.reverse gameData.choices)) ]
                    --     ]
                    ]
                ]
            , div [ class "order-last d-md-none" ]
                [ renderMobileNavLinks pageRoute notifications
                ]
            , div [ class "col-md-8 content" ] elements
            ]
        ]


loginOption : String -> Html Msg
loginOption login =
    option [ value ("?" ++ String.trim login) ] [ text login ]


renderLoginPage : GameData -> Html Msg
renderLoginPage gameData =
    div [ class "container desktop" ]
        [ div [ class "v-centred" ]
            [ div [ class "sign-in" ]
                [ img [ src (t UploadPath ++ "biocore-logo.png"), alt "BioCore", class "login-logo" ] []
                , h1 [] [ text "Please login" ]
                , let
                    teamNamesList =
                        String.split "|" (t TeamNames)
                  in
                  select
                    [ on "change" (Json.map TeamChosen targetValue)
                    , class "form-control"
                    , value gameData.teamName
                    ]
                    (List.map loginOption teamNamesList)
                , button
                    [ class "btn btn-primary btn-block"
                    , let
                        teamName =
                            if gameData.teamName == "?" then
                                gameData.teamName

                            else
                                String.dropLeft 1 gameData.teamName
                      in
                      onClick (TeamChosen teamName)
                    ]
                    [ text "Login" ]
                ]
            ]
        ]


renderNavLinks : Route -> NotificationCount -> Html Msg
renderNavLinks pageRoute notifications =
    nav [ class "nav flex-column nav-pills" ]
        [ a
            [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Messages )
                ]
            , href (Route.toString Route.Messages)
            ]
            [ chatAlt [ Svg.Attributes.class "nav-icon" ]
            , text (t NavMessages)
            , if notifications.messages > 0 then
                span [ class "badge badge-warning" ] [ text (String.fromInt notifications.messages) ]

              else
                text ""
            , if notifications.messages == 0 && notifications.messagesNeedAttention == True then
                span [ class "badge badge-warning need-attention", title (t NavMessagesNeedAttention) ] [ text "!" ]

              else
                text ""
            ]
        , a
            [ classList
                [ ( "nav-link", True )
                , ( "active", Route.isDocumentRoute pageRoute )
                ]
            , href (Route.toString Route.Documents)
            ]
            [ documentText [ Svg.Attributes.class "nav-icon" ]
            , text (t NavDocuments)
            , text " "
            , if notifications.documents > 0 then
                span [ class "badge badge-warning" ] [ text (String.fromInt notifications.documents) ]

              else
                text ""
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
            , if notifications.emails > 0 then
                span [ class "badge badge-warning" ] [ text (String.fromInt notifications.emails) ]

              else
                text ""
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
            , if notifications.social > 0 then
                span [ class "badge badge-warning" ] [ text (String.fromInt notifications.social) ]

              else
                text ""
            ]
        ]


renderMobileNavLinks : Route -> NotificationCount -> Html Msg
renderMobileNavLinks pageRoute notifications =
    nav [ class "nav nav-pills mobile-nav fixed-bottom" ]
        [ a
            [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Messages )
                ]
            , class "mobile-nav-item"
            , href (Route.toString Route.Messages)
            ]
            [ chatAlt [ Svg.Attributes.class "mobile-nav-icon" ]
            , div [] [ text (t NavMessages) ]
            , if notifications.messages > 0 then
                span [ class "badge badge-warning badge-mobile" ] [ text (String.fromInt notifications.messages) ]

              else
                text ""
            , if notifications.messages == 0 && notifications.messagesNeedAttention == True then
                span [ class "badge badge-warning badge-mobile need-attention", title (t NavMessagesNeedAttention) ] [ text "!" ]

              else
                text ""
            ]
        , a
            [ classList
                [ ( "nav-link", True )
                , ( "active", Route.isDocumentRoute pageRoute )
                ]
            , class "mobile-nav-item"
            , href (Route.toString Route.Documents)
            ]
            [ documentText [ Svg.Attributes.class "mobile-nav-icon" ]
            , div [] [ text (t NavDocuments) ]
            , if notifications.documents > 0 then
                span [ class "badge badge-warning badge-mobile" ] [ text (String.fromInt notifications.documents) ]

              else
                text ""
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
            , if notifications.emails > 0 then
                span [ class "badge badge-warning badge-mobile" ] [ text (String.fromInt notifications.emails) ]

              else
                text ""
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
            , if notifications.social > 0 then
                span [ class "badge badge-warning badge-mobile" ] [ text (String.fromInt notifications.social) ]

              else
                text ""
            ]
        ]


renderTeamInformation : String -> Html Msg
renderTeamInformation teamName =
    div []
        [ div [ class "card" ]
            [ div [ class "card-body" ]
                [ h2 [ class "card-title" ] [ text ("Team " ++ teamName) ]
                , img [ src "leaf.png", alt "Team logo.", class "team-logo mb-2" ] []
                ]
            ]
        ]
