module Message exposing (Msg(..))

import Browser
import Url
import View.PathChecker


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | ChoiceButtonClicked String
    | CheckboxClicked String
    | CheckboxesSubmitted String
    | TeamChosen String
    | PathCheckerMsg View.PathChecker.Msg
    | NoFeedbackButton
    | NoOp
