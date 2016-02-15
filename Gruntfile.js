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
    jsdoc : {
      dist : {
        src: ['main.js', 'bin/*.js', 'test/*.js'],
        options: {
          destination: 'jsdoc',
          'readme': 'README.md',
        }
      }
    },
  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-jsdoc');

  // Default task(s).
  grunt.registerTask('default', ['jshint', 'jsdoc']);
};
