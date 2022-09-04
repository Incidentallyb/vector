module Message exposing (Msg(..))

import Browser
import Url
import View.PathChecker


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | WatchVideoClicked
    | ChoiceButtonClicked String
    | CheckboxClicked String
    | CheckboxesSubmitted String
    | TeamChosen String
    | SocialInputAdded String
    | PostSocial String String
    | PathCheckerMsg View.PathChecker.Msg
    | CookieAccepted
    | NoOp
