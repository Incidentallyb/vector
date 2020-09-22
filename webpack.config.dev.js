const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: {
    app: [
        './src/index.js',
        './src/styles/style.scss'
    ]
  },

  mode: 'development',

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js',
    publicPath: '/',
  },

  plugins: [
    new CopyWebpackPlugin({
      patterns: [
          {from: './src/assets', to: './'},
      ]
    }),
  ],

  module: {
    rules: [
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
              debug: true,
              optimize: false,
              verbose: true,
            },
          },
        ],
      },
      {
        test: /\.scss$/,
        use: [
          'style-loader',
          {
            loader: 'css-loader',
          },
          {
            loader: 'postcss-loader',
          },
          {
            loader: 'sass-loader',
          },
        ],
      },
      {
        test: /\.(png|jpg|gif|svg|ico|ttf|eot)$/,
        loader: 'file-loader',
        options: {
          name: '[name].[ext]?[hash]',
        },
      },
    ],

    noParse: /\.elm$/,
  },

  devServer: {
    // Redirect 404s to index.html
    historyApiFallback: true,
    inline: true,
    stats: { colors: true },
  },


};
