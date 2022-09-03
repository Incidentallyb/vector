module Message exposing (Msg(..))

import Browser
import Url
import Video
import View.PathChecker


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | WatchDocumentVideoClicked
    | WatchIntroVideoClicked Video.Video
    | ChoiceButtonClicked String
    | CheckboxClicked String
    | CheckboxesSubmitted String
    | TeamChosen String
    | SocialInputAdded String
    | PostSocial String String
    | PathCheckerMsg View.PathChecker.Msg
    | NoOp
