module View.Desktop exposing (renderNavLinks, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Msg(..))


view : Html Msg
view =
    div []
        [ h1 [] [ text "Desktop" ]
        , renderNavLinks
        ]


renderNavLinks : Html Msg
renderNavLinks =
    ul []
        [ li [] [ a [ href "/documents" ] [ text "documents" ] ]
        , li [] [ a [ href "/emails" ] [ text "emails" ] ]
        , li [] [ a [ href "/messages" ] [ text "messages" ] ]
        , li [] [ a [ href "/tweets" ] [ text "tweets" ] ]
        ]
