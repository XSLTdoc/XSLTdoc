module.exports = function(grunt) {
  require('load-grunt-tasks')(grunt);

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    clean: ['doc', 'readme.xhtml', 'test/temp', 'test/testResult.txt'],
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
    },
    replace: {
      dist: {
        options: {
          patterns: [
            {
              match: /XSLTdoc \d+\.\d+\.\d+/,
              replacement: 'XSLTdoc <%= pkg.version %>'
            }
          ]
        },
        files: [
          {expand: true, flatten: true, src: ['templates/standard.tpl.html'],
          dest: 'templates/'}
        ]
      }
    },
    release: {
      options: {
        filesToStage: ['templates/standard.tpl.html'],
        afterBump: ['replace'],
        afterRelease: ['ghPages'],
        github: {
          repo: 'XSLTdoc/XSLTdoc',
          accessTokenVar: 'GITHUB_GRUNT_RELEASE_ACCESS_TOKEN',
        },
      },
    },
  });

  grunt.registerTask('test', ['mochaTest']);

  grunt.registerTask('doc', 'Generate this project\'s docs in the "doc" ' +
    'subdirectory',
    function() {
      var done = this.async();
      // Convert the readme markdown into xhtml
      require('./bin/readme-to-xhtml.js')(function(err) {
        if (err) {
          done(err);
          return;
        }
        // Now generate this project's docs
        var xsltdoc = require('./main.js');
        xsltdoc.xsltdoc(null, function(err, docDir) {
          if (err) {
            done(err);
            return;
          }
          grunt.log.writeln(`Docs written to ${docDir}`);
          done();
        });
      });
    });

  grunt.registerTask('ghPages',
    'Publish to GitHub pages (requires that you have commit access to the ' +
    'repo)',
    function() {
      var done = this.async();
      require('./bin/publish-gh-pages.js')(
        grunt.log.writeln,
        function(err) {
          done(err);
        }
      );
    });

  grunt.registerTask('default', ['clean', 'jshint', 'test', 'doc']);

};
