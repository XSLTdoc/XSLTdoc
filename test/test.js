// Mocha tests

var assert = require('assert');
var fs = require('fs');
var path = require('path');
var temp = require('temp');

// Automatically track and cleanup files at exit
temp.track();


describe('Main module', function() {
  var xsltdoc;

  before(function() {
    xsltdoc = require('../main.js');
  });

  it('should be able to be required', function() {
    assert(xsltdoc);
    console.log('xsltdoc: ', xsltdoc);
  });

  it('copyCss() should work', function(done) {
    temp.mkdir('css', function(err, dirPath) {
      console.log('css temp dir: ', dirPath);
      xsltdoc.copyCss(dirPath);
      ['xmlverbatim.css', 'XSLTdoc.css', 'XSLTdoc_green.css'].forEach(
        function(cssFile) {
          assert(
            fs.statSync(
              path.join(dirPath, cssFile)
            ).isFile());
        }
      );
      done();
    });
  });




  describe('#indexOf()', function () {
    it('should return -1 when the value is not present', function () {
      assert.equal(-1, [1,2,3].indexOf(5));
      assert.equal(-1, [1,2,3].indexOf(0));
    });
  });
});