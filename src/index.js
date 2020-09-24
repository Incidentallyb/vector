'use strict';
require('./index.html');
require('./styles/style.scss');

const { Elm } = require('./Main.elm');

const messages = require('../data/messages.json');
const documents = require('../data/documents.json');
const emails = require('../data/emails.json');

const app = Elm.Main.init({flags : {messages, documents, emails}});
