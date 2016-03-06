#!/usr/bin/env node
// Simple script to convert the README.md into XHTML, for inclusion into the
// home page documentation.

var fs = require('fs');
var MarkdownIt = require('markdown-it');
var path = require('path');

var mdFile = path.join(__dirname, '../README.md');
var htmlFile = path.join(__dirname, '../readme.xhtml');

var main = module.exports = function(cb) {
  // Instantiate a Markdown processor with specific options
  var md = new MarkdownIt('default', {
    xhtmlOut: true,
    typographer: true,
    highlight: function (str, lang) {
      return '<pre><code class="' + lang + '">' + str +
        '</code></pre>';
    }
  });

  // Asynchronously read the input file, process it, then write the output
  fs.readFile(mdFile, 'utf-8', function(err, contentMd) {
    if (err) {
      cb(err);
      return;
    }
    var contentHtml = md.render(contentMd);
    var xhtml = `<div>${contentHtml}</div>\n`;
    fs.writeFile(htmlFile, xhtml, 'utf-8', function(err) {
      if (err) {
        cb(err);
        return;
      }
      cb(null, htmlFile);
    });
  });
};

// If running as a script
if (!module.parent) {
  main(function(err, outfile) {
    if (err) {
      console.log('got an error');
      console.error(err);
      process.exit(1);
    }
    console.log('Done; output is ' + path.resolve(outfile));
  });
}
