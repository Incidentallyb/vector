const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');


module.exports = {
  entry: {
    app: [
      './src/index.js'
    ]
  },

  mode: 'production',

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js',
  },

  plugins: [
    new CopyWebpackPlugin({
        patterns: [
            { from: './src/assets', to: './'},
        ]
    }),
  ],

  module: {
    rules: [
      {
        test: /\.css$/,
        loader: 'file-loader?name=[name].[ext]',
      },
      {
        test: /\.html$/,
        exclude: /node_modules/,
        loader: 'file-loader?name=[name].[ext]',
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: 'elm-webpack-loader',
            options: {
              debug: false,
              optimize: true,
              verbose: false,
            }
          },
        ],
      },
      {
          test: /\.(png|jpg|gif|svg|ico|ttf|eot)$/,
          loader: 'file-loader',
          options: {
              name: '[name].[ext]?[hash]'
          }
      },
    ],

    noParse: /\.elm$/,
  },

};
