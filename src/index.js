'use strict';
require('./index.html');
require('./styles/style.scss');

const { Elm } = require('./Main.elm');

const messages = require('../data/test.json');

const app = Elm.Main.init({flags : {messages: messages}});
