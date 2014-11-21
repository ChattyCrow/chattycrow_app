var gulp    = require('gulp');
var coffee  = require('gulp-coffee');
var plumber = require('gulp-plumber');
var gutil   = require('gulp-util');

gulp.task('coffee-app', function() {
  return gulp.src('src/**/*.coffee')
      .pipe(plumber())
      .pipe(coffee({ bare: true }))
      .on('error', gutil.log)
      .pipe(gulp.dest('./www/'));
});

gulp.task('coffee-controllers', function() {
  return gulp.src('src/controllers/**/*.coffee')
      .pipe(plumber())
      .pipe(coffee({ bare: true }))
      .on('error', gutil.log)
      .pipe(gulp.dest('./www/controllers/'));
});

gulp.task('coffee-services', function() {
  return gulp.src('src/services/**/*.coffee')
      .pipe(plumber())
      .pipe(coffee({ bare: true }))
      .on('error', gutil.log)
      .pipe(gulp.dest('./www/services/'));
});

gulp.task('watch', function() {
  return gulp.watch('src/**/*.coffee', ['coffee-app', 'coffee-controllers', 'coffee-services']);
});

gulp.task('default', [ 'coffee-app', 'coffee-controllers', 'coffee-services', 'watch' ]);
