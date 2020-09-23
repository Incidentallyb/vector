module View.Email exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaHidden)
import Message exposing (Msg(..))
import View.Desktop exposing (..)


type alias EmailInfo =
    { from : String
    , subject : String
    , content : String
    , colour : String
    }


view : Int -> Html Msg
view emailId =
    let
        info =
            emailInfoFromId emailId
    in
    article [ classList [ ( "email", True ), ( "p-3", True ) ] ]
        [ h2 [] [ text info.subject ]
        , div [ classList [ ( "d-flex", True ), ( "align-items-center", True ) ] ]
            [ div [ classList [ ( "email-icon", True ), ( info.colour, True ) ], ariaHidden True ]
                [ text (String.left 1 info.from)
                ]
            , div [ classList [ ( "ml-3", True ) ] ] [ text info.from ]
            ]
        , div [ classList [ ( "mt-3", True ) ] ] [ text info.content ]
        ]



-- This hardcoding will be removed later


emailInfoFromId : Int -> EmailInfo
emailInfoFromId id =
    case id of
        1 ->
            { from = "Kris"
            , subject = "Important News"
            , content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            , colour = "red"
            }

        2 ->
            { from = "Katja"
            , subject = "Interesting Stuff"
            , content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            , colour = "blue"
            }

        3 ->
            { from = "Nick"
            , subject = "Fish"
            , content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            , colour = "green"
            }

        _ ->
            { from = "Unknown"
            , subject = "Not found"
            , content = "Not found"
            , colour = "red"
            }
