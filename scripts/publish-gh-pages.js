#!/usr/bin/env node

var ghpages = require('gh-pages');
var path = require('path');

var xsltdoc = require('../main.js');
xsltdoc({config: path.join(__dirname, '../xsl/XSLTdocConfig.xml')},
  function(targetDir) {
    ghpages.publish(path.join(__dirname, '../doc'),
      { repo: 'git@github.com:XSLTdoc/xsltdoc.github.io.git',
        branch: 'master', },
      function(err) {
        console.log("done");
      }
    );
  }
);



