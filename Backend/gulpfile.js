var browserify = require('browserify'),
    gulp = require('gulp'),
    plumber = require('gulp-plumber'),
    gutil = require('gulp-util'),
    source = require('vinyl-source-stream'),
    sass = require('gulp-sass'),
    hbsfy = require("hbsfy"),
    apidoc = require('gulp-apidoc'),
    destCSS = 'public/css/',
    mocha = require('gulp-mocha'),
    fs = require('fs-extra'),
    exit = require('gulp-exit');

var sourceFile = './src/client/js/main.js',
    destFolder = './public/js/',
    destFile = 'bundle.js',
    sourceCSS = 'src/client/css/';
    
// build for dist
gulp.task('browserify-build', function() {

    var bundler = browserify({
        // Required watchify args
        cache: {}, 
        packageCache: {}, 
        fullPaths: true,
        // Browserify Options
        entries: sourceFile,
        debug: true
    });

    hbsfy.configure({
        extensions: ['hbs']
    });
    
    var bundle = function() {
        return bundler
        .transform(hbsfy)
        .bundle()
        .on('error', function(err){
            console.log(err.message);
            this.emit('end');
        })
        .pipe(source(destFile))
        .pipe(gulp.dest(destFolder));
    };

    return bundle();
  
});

gulp.task('copy', function() {

    gulp.src('node_modules/bootstrap-sass/assets/fonts/**/*').pipe( gulp.dest('public/fonts') );
    gulp.src('node_modules/font-awesome/fonts/**/*').pipe( gulp.dest('public/fonts') );
    gulp.src('src/client/index.html').pipe( gulp.dest('public') );
    gulp.src('src/server/assets/**/*').pipe( gulp.dest('public/assets') );

});

gulp.task('build-css', function() {

  return gulp.src(sourceCSS + '*.scss')
        .pipe(plumber())
        .pipe(sass())
        .pipe(gulp.dest(destCSS));
});

gulp.task('build-apidoc', function(done){
    
    apidoc({
        src: "src/",
        dest: "public/doc/API",
        debug: false
    },done);

});

gulp.task('build-dist',['build-apidoc','copy','browserify-build','build-css'],function(){
    
});

gulp.task('server-test',[], function (done) {
    return gulp.src('src/server/test/**/*.js', { read: false })
    .pipe(mocha({ reporter: 'spec' }))
    .pipe(exit());
});

gulp.task('default',['build-dist'],function(){
    
    
});

