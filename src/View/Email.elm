module View.Email exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))
import View.Desktop exposing (..)


type alias EmailInfo =
    { from : String
    , subject : String
    , content : String
    }


view : Int -> Html Msg
view emailId =
    let
        info =
            emailInfoFromId emailId
    in
    div []
        [ h2 [] [ text info.subject ]
        , div [] [ text info.from ]
        , div [] [ text info.content ]
        ]



-- This hardcoding will be removed later


emailInfoFromId : Int -> EmailInfo
emailInfoFromId id =
    case id of
        1 ->
            { from = "Kris"
            , subject = "Important News"
            , content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            }

        2 ->
            { from = "Katja"
            , subject = "Interesting Stuff"
            , content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            }

        3 ->
            { from = "Nick"
            , subject = "Fish"
            , content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            }

        _ ->
            { from = "Unknown"
            , subject = "Not found"
            , content = "Not found"
            }
