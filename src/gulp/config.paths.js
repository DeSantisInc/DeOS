export const paths = {
  'dirs': {
    'dist': 'app'
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
  `app/${paths.files.client.pug.out}`
]
