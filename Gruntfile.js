module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jshint: {
      options: {
        esversion: 6,
        funcscope: true,
      },
      all: ['Gruntfile.js', 'main.js', 'bin/*.js'],
    },
    mochaTest: {
      test: {
        options: {
          reporter: 'nyan',
        },
        src: ['test/**/*.js']
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.registerTask('makeDocs', 'Generate this project\'s docs.',
    function() {
      var done = this.async();
      var xsltdoc = require('./main.js');
      xsltdoc.xsltdoc(null, function(err, docDir) {
        if (!err) grunt.log.writeln(`Docs written to ${docDir}`);
        done(err);
      });
    });
  grunt.registerTask('default', ['jshint', 'mochaTest', 'makeDocs']);
};
