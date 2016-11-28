/* eslint-disable import/no-extraneous-dependencies */

import gulp from 'gulp';
import pug from 'gulp-pug';
import rename from 'gulp-rename';

import { paths } from './src/gulp/config.paths';

gulp.task('pug', () => gulp.src(paths.files.client.pug.in)
                           .pipe(pug({}))
                           .pipe(rename(paths.files.client.pug.out))
                           .pipe(gulp.dest(paths.dirs.dist)));

gulp.task('build', ['pug']);

gulp.task('main', ['build']);

gulp.task('default', ['main']);
