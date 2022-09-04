"use strict";
require("./index.html");
require("./styles/style.scss");

const { Elm } = require("./Main.elm");

const messages = require("../data/messages.json");
const documents = require("../data/documents.json");
const emails = require("../data/emails.json");
const social = require("../data/social.json");

const app = Elm.Main.init({ flags: { messages, documents, emails, social } });

app.ports.enableAnalytics.subscribe(function (hasConsented) {
  const gtag = document.createElement("script");
  gtag.type = "text/javascript";
  gtag.async = true;
  gtag.src = "https://www.googletagmanager.com/gtag/js?id=G-[cCc]xyz123";

  const config = document.createElement("script");
  config.type = "text/javascript";
  config.text =
    "window.dataLayer = window.dataLayer || []; function gtag() {dataLayer.push(arguments)};gtag('js', new Date()); gtag('config', 'G-[cCc]xyz123');";

  document.getElementsByTagName("head")[0].appendChild(gtag);
  document.getElementsByTagName("head")[0].appendChild(config);
});
