export const paths = {
  "dirs": {
    "dist": "app",
    "lib": "build/es5"
  },
  "files": {
    "client": {
      "all": "src/client/**/*.js?(x)",
      "bundle": "app/bundle.js?(.map)",
      "entry": "src/client/app.jsx"
    },
    "config": {
      "gulp": "Gulpfile.babel.js",
      "webpack": "etc/gulp/webpack.config.babel.js"
    },
    "server": {
      "all": "src/server/**/*.js?(x)"
    },
    "shared": {
      "all": "src/shared/**/*.js?(x)"
    },
    "tests": {
      "all": "build/es5/test/**/*.js"
    }
  }
};

export const allConfigJS = [
  paths.files.config.gulp,
  paths.files.config.webpack
];

export const allSrcJS = 'src/**/*.js?(x)';

export const allJS = [allSrcJS].concat(allConfigJS);

export const buildDeps = ['lint', 'clean'];

export const toClean = [paths.files.client.bundle, paths.dirs.lib];
