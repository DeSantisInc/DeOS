/* eslint-disable import/no-extraneous-dependencies */

import gulp from 'gulp';
import babel from 'gulp-babel';
import pug from 'gulp-pug';
import rename from 'gulp-rename';
import del from 'del';

import { paths, toClean } from './src/gulp/config.paths';

gulp.task('pug', () => gulp.src(paths.files.client.pug.in)
                           .pipe(pug({}))
                           .pipe(rename(paths.files.client.pug.out))
                           .pipe(gulp.dest(paths.dirs.dist)));

gulp.task('clean', () => del(toClean));

gulp.task('build', ['pug'], () => {
  gulp.src(paths.files.client.js.all)
      .pipe(babel())
      .pipe(gulp.dest(paths.dirs.es5.client));
  gulp.src(paths.files.common.js.all)
      .pipe(babel())
      .pipe(gulp.dest(paths.dirs.es5.common));
  gulp.src(paths.files.render.js.all)
      .pipe(babel())
      .pipe(gulp.dest(paths.dirs.es5.render));
  gulp.src(paths.files.server.js.all)
      .pipe(babel())
      .pipe(gulp.dest(paths.dirs.es5.server));
});

gulp.task('main', ['clean', 'build']);

gulp.task('default', ['main']);
