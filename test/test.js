// Mocha tests

var assert = require('assert');
var fs = require('fs-extra');
var jd = require('../bin/java-driver.js');
var path = require('path');
var VError = require('verror');

// Test the XSLT
describe('XSLT tests', function() {
  var java;

  // In the before hook, initialize the java instance.
  before(function(done) {
    jd.java(function(err, _java) {
      if (err) {
        done(err);
        return;
      }
      java = _java;
      done();
    });
  });

  it('has working utility xslt templates', function(done) {
    this.timeout(10000);
    var src = path.join(__dirname, 'dummy.xml');
    var xsl = path.join(__dirname, 'utilTest.xsl');
    var out = path.join(__dirname, 'testResult.txt');
    var args = ['-quit:off', `-s:${src}`, `-xsl:${xsl}`, `-o:${out}`,
      'quiet=true'];
    try {
      var Transform = java.import('net.sf.saxon.Transform');
      Transform.main(args);
    }
    catch (err) {
      done(new VError(err,
        'There was a problem when we tried to run the ' +
        'transformation with these arguments:\n  ' + args.join('\n  ')));
      return;
    }
    done();
  });
});


// Test the main javascript driver
// These tests use test/temp as a working directory.
describe('Main module', function() {
  var tempDir = path.join(__dirname, 'temp');
  var xsltdoc;

  before(function() {
    xsltdoc = require('../main.js');

    // Start with a clean temp directory
    fs.removeSync(tempDir);
    fs.mkdirpSync(tempDir);
    process.chdir(tempDir);

    // Copy the sample/template config file
    var src, dest;
    src = path.join(__dirname, '../templates/xsltdoc-config.xml');
    dest = path.join(tempDir, 'xsltdoc-config.xml');
    //console.log(`copying ${src} to ${dest}`);
    fs.copySync(src, dest);

    // Copy the sample XSLT
    src = path.join(__dirname, 'test.xsl');
    dest = path.join(tempDir, 'test.xsl');
    //console.log(`copying ${src} to ${dest}`);
    fs.copySync(src, dest);
  });

  it('should be able to be required', function() {
    assert(xsltdoc);
  });

  // Copy the CSS files to a temp directory, and make sure they arrive
  it('should copy css files', function(done) {
    //console.log('Copying css files to ' + tempDir);
    xsltdoc.copyCss(tempDir);
    ['xmlverbatim.css', 'XSLTdoc.css', 'XSLTdoc_green.css'].forEach(
      function(cssFile) {
        assert(
          fs.statSync(
            path.join(tempDir, cssFile)
          ).isFile());
      }
    );
    done();
  });

  // Copies the template config file into the test directory, and uses it and
  // test.xsl to generate documentation in the test/doc subdirectory
  it('can generate documentation for an XSLT', function(done) {
    this.timeout(10000);
    xsltdoc.xsltdoc(null, function(err, targetPath) {
      //console.log('Generating documentation in ' + targetPath);
      if (err) {
        done(err);
        return;
      }
      // Check the results
      assert(fs.statSync(path.join(tempDir, 'doc/index.html')).isFile());
      done();
    });
  });
});