export const paths = {
  'dirs': {
    'dist': 'app',
    'es5': {
      'client': 'var/build/es5/client',
      'common': 'var/build/es5/common',
      'renderer': 'var/build/es5/renderer',
      'server': 'var/build/es5/server'
    },
    'lib': 'var/build/es5'
  },
  'files': {
    'client': {
      'pug': {
        'in': 'src/client/index.pug',
        'out': 'index.min.html'
      }
    }
  }
}

export const toClean = [
  `app/${paths.files.client.pug.out}`,
  paths.dirs.es5.client,
  paths.dirs.es5.common,
  paths.dirs.es5.renderer,
  paths.dirs.es5.server
]
