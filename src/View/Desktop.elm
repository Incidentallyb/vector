module View.Desktop exposing (renderWrapperWithNav, view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Heroicons.Outline exposing (chatAlt, documentText, hashtag, mail, userCircle)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)
import Json.Decode as Json
import Message exposing (Msg(..))
import Route exposing (Route(..))
import GameData exposing (GameData)


view : GameData -> Route -> Html Msg
view gameData pageRoute =
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
                [ renderWrapperWithNav gameData pageRoute [ text "my desktop" ]
                ]


renderWrapperWithNav : GameData -> Route -> List (Html Msg) -> Html Msg
renderWrapperWithNav gameData pageRoute elements =
    div [ class "container-fluid desktop" ]
        [ div [ class "row" ]
            [ div [ class "col-sm-auto" ]
                [ renderTeamInformation gameData.teamName
                , renderNavLinks pageRoute
                ]
            , div [ class "col" ] elements
            ]
        ]


loginOption login =
    option [ value ("?" ++ login) ] [ text login ]


renderLoginPage : GameData -> Html Msg
renderLoginPage gameData =
    div [ class "container desktop" ]
        [ div [ class "v-centred" ]
            [ div [ class "sign-in" ]
                [ userCircle []
                , h1 [] [ text "Please login" ]
                ,  let
                        teamNamesList = 
                            String.split "," (t TeamNames)
                    in 
                    select
                    [ on "change" (Json.map TeamChosen targetValue)
                    , class "form-control"
                    , value gameData.teamName
                    ]
                    (List.map loginOption teamNamesList)
                , button
                    [ class "btn btn-primary btn-block"
                    , onClick (TeamChosen (String.dropLeft 1 gameData.teamName))
                    ]
                    [ text "Login" ]
                ]
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
            [ documentText []
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
            [ mail []
            , text (t NavEmails)
            ]
        , a
            [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Messages )
                ]
            , href (Route.toString Route.Messages)
            ]
            [ chatAlt []
            , text (t NavMessages)
            ]
        , a
            [ classList
                [ ( "nav-link", True )
                , ( "active", pageRoute == Route.Social )
                ]
            , href (Route.toString Route.Social)
            ]
            [ hashtag []
            , text (t NavSocial)
            ]
        ]


renderTeamInformation : String -> Html Msg
renderTeamInformation teamName =
    div []
        [ div [ class "card" ]
            [ div [ class "card-body" ]
                [ h5 [ class "card-title" ] [ text ("Team " ++ teamName) ]
                , p [ class "card-text" ] [ text "team picture here" ]
                ]
            ]
        ]
