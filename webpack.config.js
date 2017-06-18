var path = require('path');
var webpack = require('webpack');
var merge = require('webpack-merge');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var autoprefixer = require('autoprefixer');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');

var entryPath = path.join(__dirname, 'src/index.js');
var outputPath = path.join(__dirname, 'dist');

console.log('WEBPACK GO!');

// determine build env
var TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? 'production' : 'development';
var outputFilename = TARGET_ENV === 'production' ? '[name]-[hash].js' : '[name].js'

// common webpack config
var commonConfig = {

  output: {
    path: outputPath,
    filename: outputFilename,
    // publicPath: '/'
  },

  resolve: {
    extensions: ['.js', '.elm']
  },

  module: {
    rules: [
      {
        test: /\.(css|scss)$/,
        use: [
          'style-loader',
          'css-loader',
          {
            loader: 'postcss-loader',
            options: {
              plugins: () => [autoprefixer({ browsers: ['last 2 versions'] })]
            }
          }
        ]
      },
      {
        test: /\.html$/,
        exclude: /node_modules/,
        loader: 'file-loader?name=[name].[ext]',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
    ],

    noParse: /\.elm$/,
  },

  plugins: [],

}

// additional webpack settings for local env (when invoked by 'npm start')
if (TARGET_ENV === 'development') {
  console.log('Serving locally...');

  module.exports = merge(commonConfig, {

    entry:{
      app:  [
        'webpack-dev-server/client?http://localhost:8080',
        entryPath
      ]
    },

    devServer: {
      // serve index.html in place of 404 responses
      historyApiFallback: true,
      contentBase: './src',
      inline: true,
      stats: { colors: true },
    },

    module: {
      rules: [{
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-hot-loader!elm-webpack-loader?verbose=true&warn=true&debug=true'
      }]
    }

  });
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if (TARGET_ENV === 'production') {
  console.log('Building for prod...');

  module.exports = merge(commonConfig, {

    entry: { app: entryPath},

    module: {
      rules: [{
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack'
      }]
    },

    plugins: [
      // new CopyWebpackPlugin([{
      //     from: 'src/public/img/',
      //     to: 'public/img/'
      //   },
      //   {
      //     from: 'src/favicon.ico'
      //   },
      // ]),

      new webpack.optimize.OccurenceOrderPlugin(),

      // minify & mangle JS/CSS
      new webpack.optimize.UglifyJsPlugin({
        minimize: true,
        compressor: { warnings: false }
        // mangle:  true
      })
    ]

  });
}
