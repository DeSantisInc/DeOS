module.exports = {

  entry: "./src/dev/entry.js",

  output: {

    path: "./src/dev/",

    filename: "bundle.js"

  },

  module: {

    loaders: [

      { test: /\.css$/, loader: "style!css" }

    ]

  }

};
