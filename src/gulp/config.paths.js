export const paths = {
  dirs: {
    dist: 'app',
    es5: {
      client: 'var/build/es5/client',
      common: 'var/build/es5/common',
      render: 'var/build/es5/render',
      server: 'var/build/es5/server',
    },
    lib: 'var/build/es5',
  },
  files: {
    client: {
      js: {
        all: 'src/client/**/*.js?(x)',
        entry: 'src/client/index.js',
      },
      pug: {
        in: 'src/client/index.pug',
        out: 'index.min.html',
      },
    },
    common: {
      js: {
        all: 'src/common/**/*.js?(x)',
      },
    },
    config: {
      gulp: 'Gulpfile.babel.js',
      paths: 'src/gulp/config.paths.js',
      webpack: 'src/gulp/webpack.config.babel.js',
    },
    render: {
      js: {
        all: 'src/render/**/*.js?(x)',
      },
    },
    server: {
      js: {
        all: 'src/server/**/*.js?(x)',
      },
    },
  },
};

export const toLint = [
  paths.files.client.js.all,
  paths.files.common.js.all,
  paths.files.config.gulp,
  paths.files.config.paths,
  paths.files.config.webpack,
  paths.files.render.js.all,
  paths.files.server.js.all,
];

export const toClean = [
  `app/${paths.files.client.pug.out}`,
  'app/bundle.min.js?(.map)',
  paths.dirs.es5.client,
  paths.dirs.es5.common,
  paths.dirs.es5.render,
  paths.dirs.es5.server,
];
