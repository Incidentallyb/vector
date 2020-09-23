const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const SWPrecacheWebpackPlugin = require('sw-precache-webpack-plugin');
const WebpackPwaManifest = require('webpack-pwa-manifest');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

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
    new SWPrecacheWebpackPlugin({
      cacheId: 'vector-app',
      dontCacheBustUrlsMatching: /\.\w{8}\./,
      filename: 'service-worker.js',
      minify: false,
      navigateFallback: 'index.html',
      staticFileGlobsIgnorePatterns: [/\.map$/, /manifest\.json$/]
    }),
    new WebpackPwaManifest({
      name: '[cCc] Vector app',
      short_name: '[cCc] Vector app',
      description: '[cCc] Vector app description',
      background_color: '#ffffff',
      theme_color: '#000000',
      start_url: '/',
      icons: [{
        src: path.resolve('src/assets/icon.png'),
        sizes: [192],
        destination: path.join('static', 'img')
      }]
    }),
    new MiniCssExtractPlugin({
      filename: '[name].css',
      chunkFilename: '[id].css',
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
            },
          },
        ],
      },
      {
        test: /\.scss$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
          },
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
          name: '[name].[hash:8].[ext]',
        },
      },
    ],

    noParse: /\.elm$/,
  },

};
