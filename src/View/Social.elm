module View.Social exposing (view)

import Content
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Dict exposing (Dict)
import GameData exposing (GameData, filterSocials)
import Heroicons.Outline exposing (chat, heart, refresh, upload)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes.Aria exposing (ariaHidden)
import Html.Events exposing (onClick, onInput)
import Markdown
import Message exposing (Msg(..))


view : String -> GameData -> Dict String Content.SocialData -> Html Msg
view currentSocialInput gamedata socialDict =
    div []
        [ div [ class "clearfix form-group send-tweet" ]
            [ label [ for "tweet-textbox" ] [ text (t SocialInputLabel) ]
            , textarea
                [ class "form-control"
                , id "tweet-textbox"
                , onInput SocialInputAdded
                , value currentSocialInput
                ]
                []
            , button
                [ class "btn btn-primary float-right"
                , onClick (PostSocial "key" currentSocialInput)
                ]
                [ text (t SocialInputPost) ]
            ]
        , ul [ class "tweet-list p-0" ]
            (List.reverse
                (List.map
                    renderTweet
                    (Dict.values (filterSocials socialDict gamedata.choices gamedata.socialsPosted))
                )
            )
        ]


renderImage : Content.SocialData -> Html Msg
renderImage social =
    case social.image of
        Nothing ->
            text ""

        Just image ->
            img [ src (t UploadPath ++ image.src), alt image.alt ] []


renderTweet : Content.SocialData -> Html Msg
renderTweet social =
    li
        [ class "tweet py-2" ]
        [ div [ class "d-flex" ]
            -- TODO replace with photos
            [ div [ class "author-icon red mx-2 flex-shrink-0", ariaHidden True ]
                [ text (String.left 1 social.author)
                ]
            , div [ class "flex-grow-1" ]
                [ div [ class "m-0" ]
                    [ span [ class "author" ] [ text social.author ], span [ class "handle" ] [ text social.handle ] ]
                , Markdown.toHtml [ class "m-0 mr-2 socialText" ] social.content
                , renderImage social
                , div [ class "icons d-flex justify-content-between my-2 mr-4" ]
                    [ div [] [ chat [], text (String.fromInt social.numComments), span [ class "sr-only" ] [ text " comments." ] ]
                    , div [] [ refresh [], text (String.fromInt social.numRetweets), span [ class "sr-only" ] [ text " retweeeets." ] ]
                    , div [] [ heart [], text (String.fromInt social.numLoves), span [ class "sr-only" ] [ text " likes." ] ]
                    , div [] [ upload [], span [ class "sr-only" ] [ text "share." ] ]
                    ]
                ]
            ]
        ]
