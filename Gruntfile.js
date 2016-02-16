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
  /*
    Experimented with jsdoc (and some others -- see the README)
    but I'm not happy with it.
    jsdoc : {
      dist : {
        src: ['main.js', 'bin/*.js', 'test/*.js'],
        options: {
          destination: 'jsdoc',
          'readme': 'README.md',
        }
      }
    },
  */
  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  //grunt.loadNpmTasks('grunt-jsdoc');
  grunt.loadNpmTasks('grunt-mocha-test');


  // Default task(s).
  grunt.registerTask('default', ['jshint', 'mochaTest']);
};
