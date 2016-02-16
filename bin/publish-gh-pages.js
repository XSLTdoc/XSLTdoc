#!/usr/bin/env node
// This generates the documentation for this project, then publishes it to
// gh-pages, all in one go.
//
// You can call this either from the command-line, or as a module. If as a
// module, use it like this:
//   require('./publish-gh-pages.js')(console.log,
//     function(err, messages) {
//       ...
//     });

var ghpages = require('gh-pages');
var path = require('path');
var xsltdoc = require('../main.js');
var VError = require('verror');

function publish(logger, cb) {
  xsltdoc.xsltdoc(null,
    function(err, targetDir) {
      if (err) {
        cb(new VError(err, "Failed to generate documentation"));
        return;
      }
      ghpages.publish(path.join(__dirname, '../doc'),
        { repo: 'git@github.com:XSLTdoc/xsltdoc.github.io.git',
          branch: 'master',
          message: 'Auto-generated pages from the XSLTdoc repo',
          logger: logger,
        },
        function(err) {
          if (err) {
            cb(new VError(err,
              'Documentation is okay, but failed to publish gh-pages'));
            return;
          }
          cb();
        }
      );
    }
  );
}

// If we've been invoked as a script, execute the function
if (!module.parent) {
  publish(console.log, function(err) {
    if (err) {
      console.error(err.message);
      return;
    }
  });
}

module.exports = publish;
