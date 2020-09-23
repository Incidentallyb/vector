'use strict';
require('./index.html');
require('./styles/style.scss');

const { Elm } = require('./Main.elm');

const app = Elm.Main.init({});
