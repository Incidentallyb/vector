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
        , div [ class "intro-video" ] [ View.Video.view (videoToData activeVideo) ]
        , renderVideoButtons
        , div [ class "row my-4" ]
            [ a
                [ class "btn btn-primary btn-lg mx-auto"
                , href (Route.toString Route.Desktop)
                ]
                [ text (t StartNewGame) ]
            ]
        ]


renderVideoButtons : Html Msg
renderVideoButtons =
    ol [ class "row my-4 list-unstyled justify-content-md-center" ]
        (List.map
            (\( buttonTextKey, videoKey ) ->
                li [ class "col text-center" ]
                    [ button
                        [ class "btn btn-primary btn-md mx-2"
                        , onClick (WatchIntroVideoClicked videoKey)
                        ]
                        [ text (t buttonTextKey) ]
                    ]
            )
            [ ( WatchIntro1, Intro1 )
            , ( WatchIntro2, Intro2 )
            , ( WatchIntro3, Intro3 )
            ]
        )
