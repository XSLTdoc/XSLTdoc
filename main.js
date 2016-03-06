#!/usr/bin/env node
'use strict';
var _ = require('lodash');
var fs = require('fs-extra');
var jd = require('./bin/java-driver.js');
var path = require('path');
var prg = require('commander');
var temp = require('temp');
var url = require('url');
var VError = require('verror');

var pkg = require(path.join(__dirname, 'package.json'));
var defaults = {
  debug: false,
  config: 'xsltdoc-config.xml'
};

// If this is being called as a script (rather than `required`) then get
// options from the command line, and invoke the tool.
if (!module.parent) {
  prg.version(pkg.version)
    .option('--debug', 'Enable debugging output messages.',
      defaults.debug)
    .option('-c, --config [file]',
      'XSLTdoc config file; default is xsltdoc-config.xml.',
      defaults.config)
    .option('--init',
      'Create a copy of the default xsltdoc-config.xml file in this ' +
      'directory, if one doesn\'t exist already.', false)
    .parse(process.argv);

  // The `init` option is only for the command-line tool
  if (prg.init) {
    try {
      fs.statSync('./xsltdoc-config.xml'); // will throw if doesn't exist
      console.error('You already seem to have xsltdoc-config.xml here.');
      process.exit(1);
    }
    catch(err) {}

    fs.copy(path.join(__dirname, 'templates/xsltdoc-config.xml'),
      './xsltdoc-config.xml',
      { clobber: false },
      function(err) {
        if (err) {
          console.error('Failed to create xsltdoc-config.xml file', err);
          process.exit(1);
        }
        console.log('New configuration file created: xsltdoc-config.xml');
        return;
      }
    );
    return;
  }

  xsltdoc({
    debug: !!prg.debug,
    config: prg.config,
  }, function(err, targetDir) {
    if (err) {
      console.error('\nERROR!');
      console.error('Error while generating documentation.');
      console.error('Detailed error information:', err);
      process.exit(1);
    }
    console.log('Done. Documentation written to ' + targetDir);
  });
}

// Entry point for scripts that `require` this module.
// Options:
// - config - pathname of the config file, either absolute, or relative
//   to theh current working directory
// - debug - enable verbose messages
function xsltdoc(_opts, cb) {
  var opts = _.merge({}, defaults, _opts);
  opts.configPath = path.resolve(process.cwd(), opts.config);

  jd.java(function(err, java) {
    if (err) {
      cb(err);
      return;
    }
    module.java = java;
    doTransform(opts, (err, targetDir) => {
      if (err) {
        cb(err);
        return;
      }
      try {
        copyCss(targetDir);
      }
      catch(err) {
        cb(new VError(err, 'Problem while copying the css files'));
        return;
      }
      cb(null, targetDir);
    });
  });
}

// Run the XSLT to generate the documentation. This requires the node-java's
// classpath to be already set up.
function doTransform(opts, cb) {
  var Transform = module.java.import('net.sf.saxon.Transform');
  var config = opts.configPath;
  var debug = opts.debug;

  // Some checks
  try {
    fs.accessSync(config);
  }
  catch(err) {
    cb(new VError(err, 'Can\'t find the config file ' + config));
    return;
  }

  // Make an array of Strings to hold the command line arguments
  // Saxon command-line arguments are described here:
  // http://www.saxonica.com/documentation9.5/using-xsl/commandline.html
  var xslt = path.join(__dirname, 'xsl/xsltdoc.xsl');
  var tempOut = temp.path({
    prefix: 'xsltdoc-', suffix: '.xml'
  });
  var args = ['-quit:off', '-xi', `-s:${config}`, `-xsl:${xslt}`, `-o:${tempOut}`];

  if (debug) console.log('Running `transform ' + args.join(' ') + '`');
  try {
    Transform.main(args);
  }
  catch (err) {
    cb(new VError(err,
      'There was a problem when we tried to run the ' +
      'transformation with these arguments:\n  ' + args.join('\n  ')));
    return;
  }

  try {
    // The transformer wrote the output directory into the tempOut file.
    var targetDir = url.parse(fs.readFileSync(tempOut, 'utf8')).pathname;
  }
  catch (err) {
    cb(new VError(err, 'Problem while reading target directory from the ' +
      'tranformer output.'));
    return;
  }

  cb(null, targetDir);
}

// Copy the XSLTdoc CSS files to the target directory.
function copyCss(targetDir) {
  fs.copySync(path.join(__dirname, 'css'), targetDir);
}

exports.xsltdoc = xsltdoc;
exports.doTransform = doTransform;
exports.copyCss = copyCss;
