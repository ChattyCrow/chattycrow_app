/** Init gulp files */
var gulp    = require('gulp');
var coffee  = require('gulp-coffee');
var plumber = require('gulp-plumber');
var gutil   = require('gulp-util');
var jshint  = require('gulp-jshint');
var jade    = require('gulp-jade');
var bf      = require('main-bower-files');
var inject  = require('gulp-inject');
var less    = require('gulp-less');

/* Compile Coffee APP files into www directory */
gulp.task('coffee', function() {
  return gulp.src('src/**/*.coffee')
      .pipe(plumber())
      .pipe(coffee({ bare: true }))
      .on('error', gutil.log)
      .pipe(gulp.dest('./www/app/'));
});

/* Compile less stylesheets */
gulp.task('less', function() {
  return gulp.src('src/stylesheets/*.less')
      .pipe(plumber())
      .pipe(less())
      .on('error', gutil.log)
      .pipe(gulp.dest('./www/css/'));
});

/* Compile & inject jade file */
gulp.task('inject', function() {
  return gulp.src('src/index.jade')
      .pipe(plumber())
      .pipe(jade())
      .on('error', gutil.log)
      .pipe(inject(gulp.src(['css/*.js', 'css/*.css'], { read: false, cwd: 'www/' }), { name: 'ui', relative: true }))
      .pipe(inject(gulp.src(['app/**/*.js', 'assets/**/*.css', '!app/app.js'], { read: false, cwd: 'www/' }), { name: 'app', relative: true }))
      .pipe(inject(gulp.src(['app/app.js'], { read: false, cwd: 'www/' }), { name: 'main', relative: true }))
      .pipe(inject(gulp.src(bf(), { read: false, cwd: 'www/' }), { name: 'bower', relative: true }))
      .pipe(gulp.dest('./www/'));
});

/* Check JS files for stylish errors */
gulp.task('jshint', function() {
  return gulp.src(['www/app/**/*.js'])
             .pipe(jshint())
             .pipe(jshint.reporter('jshint-stylish'));
});

/* Copy libs */
gulp.task('libs', function() {
  return gulp.src('./src/lib/**/*.js')
     .pipe(gulp.dest('./www/app/lib/'));
});

/* Copy images */
gulp.task('images', function() {
  return gulp.src('./res/images/**/*.*')
     .pipe(gulp.dest('./www/images/'));
});

/** Run watchers */
gulp.task('watch-coffee', function() {
  return gulp.watch('src/**/*.coffee', ['coffee', 'jshint']);
});

gulp.task('watch-jade', function() {
  return gulp.watch('src/**/*.jade', ['inject']);
});

gulp.task('watch-less', function() {
  return gulp.watch('src/stylesheets/*.less', ['less']);
});

gulp.task('watch-image', function() {
  return gulp.watch('res/images/**/*.png', ['images']);
});

/** Gulp start task */
gulp.task('default', [ 'coffee', 'jshint', 'less', 'images', 'libs', 'inject', 'watch-coffee', 'watch-jade', 'watch-less', 'watch-image' ]);
