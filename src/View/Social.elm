module View.Social exposing (view)

import Heroicons.Outline exposing (chat, heart, refresh, upload)
import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))


type alias ButtonInfo =
    { label : String
    , action : String
    }


view : Html Msg
view =
    ul [ class "tweet-list p-0" ]
        [ renderTweet "Nick" "@nick" "Tweet content"
        , renderTweet "Katja" "@katjam" "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        , renderTweet "Kris" "@kris" "Tweet content"
        ]


renderTweet : String -> String -> String -> Html Msg
renderTweet author handle content =
    li
        [ class "tweet py-2" ]
        [ div [ class "d-flex" ]
            -- TODO replace with photos
            [ div [ class "author-icon red mx-2 flex-shrink-0" ]
                [ text (String.left 1 author)
                ]
            , div [ class "flex-grow-1" ]
                [ div [ class "m-0" ]
                    [ span [ class "author" ] [ text author ], span [ class "handle" ] [ text handle ] ]
                , p [ class "card-text m-0" ]
                    [ text content ]
                , div [ class "icons d-flex justify-content-between my-2 mr-4" ]
                    [ div [] [ chat [], text "3" ]
                    , div [] [ refresh [], text "5" ]
                    , div [] [ heart [], text "7" ]
                    , div [] [ upload [] ]
                    ]
                ]
            ]
        ]
