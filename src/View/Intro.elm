module View.Intro exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Message exposing (Msg(..))
import Route exposing (Route(..))
import Video exposing (Video(..), videoToData)
import View.Video


view : Video -> Html Msg
view activeVideo =
    div [ class "intro container-fluid" ]
        [ div [ class "row my-4" ]
            [ h1 [ class "d-block mx-auto px-4 text-center" ] [ text (t SiteTitle) ]
            ]
        , div [ class "intro-video" ]
            [ View.Video.view (videoToData activeVideo) ]
        , div [ class "row my-4 video-button-row" ]
            [ if activeVideo == Intro1 then
                button
                    [ class "btn btn-primary btn-lg mx-auto"
                    , type_ "button"
                    , onClick (WatchIntroVideoClicked Intro3)
                    ]
                    [ text (t WatchIntro3Button) ]

              else
                text ""
            , a
                [ class "btn btn-primary btn-lg mx-auto"
                , href (Route.toString Route.Desktop)
                ]
                [ text
                    (if activeVideo == Intro3 then
                        t StartNewGameLink

                     else
                        t SkipIntro3VideoLink
                    )
                ]
            ]
        ]
