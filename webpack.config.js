const path = require('path');
const WebpackDashboard = require('webpack-dashboard/plugin')

module.exports = {
  entry: {
    app: ['./src/index.js']
  },

  output: {
    path: path.resolve(path.join(__dirname, 'dist')),
    filename: '[name].js',
  },

  module: {
    loaders: [
      {test: /\.(css|scss)$/, loaders: ['style', 'css']},
      {test: /\.html$/, exclude: /node_modules/, loader: 'file?name=[name].[ext]'},
      {test: /\.elm$/, exclude: [/elm-stuff/, /node_modules/], loader: 'elm-webpack'},
      {test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: 'url?limit=10000&mimetype=application/font-woff'},
      {test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: 'file'},
    ],
    noParse: /.elm$/,
  },

  plugins: [
    new WebpackDashboard(),
  ],

  devServer: {
    inline: true,
    stats: { colors: true },
  }
}
