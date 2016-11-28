export const paths = {
  'dirs': {
    'dist': 'app',
    'es5': {
      'client': 'var/build/es5/client',
      'common': 'var/build/es5/common',
      'render': 'var/build/es5/render',
      'server': 'var/build/es5/server'
    },
    'lib': 'var/build/es5'
  },
  'files': {
    'client': {
      'js': {
        'all': 'src/client/**/*.js?(x)'
      },
      'pug': {
        'in': 'src/client/index.pug',
        'out': 'index.min.html'
      }
    },
    'common': {
      'js': {
        'all': 'src/common/**/*.js?(x)'
      }
    },
    'render': {
      'js': {
        'all': 'src/render/**/*.js?(x)'
      }
    },
    'server': {
      'js': {
        'all': 'src/server/**/*.js?(x)'
      }
    }
  }
}

export const toClean = [
  `app/${paths.files.client.pug.out}`,
  paths.dirs.es5.client,
  paths.dirs.es5.common,
  paths.dirs.es5.render,
  paths.dirs.es5.server
]
