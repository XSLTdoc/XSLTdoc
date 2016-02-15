#!/usr/bin/env node
'use strict';
var fs = require('fs-extra');
var java = require('java');
var mvn = require('node-java-maven');
var path = require('path');
var prg = require('commander');
var temp = require('temp');
var url = require('url');
var VError = require('verror');

java.asyncOptions = {
  asyncSuffix: undefined,
  syncSuffix: "",             // Sync methods use the base name
  promiseSuffix: undefined,   // No promises
};

/**
 * @module xsltdoc
 */

var pkg = require(path.join(__dirname, 'package.json'));

// If this is being called as a script (rather than `required`) then get
// options from the command line, and invoke the tool.
if (!module.parent) {
  prg.version(pkg.version)
    .option('--debug', 'Enable debugging output messages.')
    .option('-c, --config [file]',
      'XSLTdoc config file; default is xsltdoc-config.xml.',
      'xsltdoc-config.xml')
    .parse(process.argv);

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


/**
 * Entry point for scripts that `require` this module.
 * @alias module:xsltdoc.xsltdoc
 * @param {object} opts - options
 * @param {mainCallback} cb - Called when finished.
 */
function xsltdoc(opts, cb) {
  opts.configPath = path.resolve(process.cwd(), opts.config);

  mvn({
      packageJsonPath: path.join(__dirname, 'package.json'),
      localRepository: path.join(__dirname, pkg.java.localRepository),
    },
    function(err, mvnResults) {
      if (err) {
        cb(new VError(err, 'Could not resolve maven dependencies'));
      }
      else {
        mvnResults.classpath.forEach(c => java.classpath.push(c));
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
      }
    }
  );
}


/**
 * Run the XSLT to generate the documentation.
 * @alias module:xsltdoc.doTransform
 * @param {object} opts - options; same as for the xsltdoc function
 * @param {mainCallback} cb
 */
function doTransform(opts, cb) {
  var Transform = java.import('net.sf.saxon.Transform');
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
  var xslt = path.join(__dirname, 'xsl/xsltdoc.xsl');
  var tempOut = temp.path({
    prefix: 'xsltdoc-', suffix: '.xml'
  });
  var args = ['-quit:off', `-s:${config}`, `-xsl:${xslt}`, `-o:${tempOut}`];

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

/**
 * Copy the XSLTdoc CSS files to the target directory.
 * @alias module:xsltdoc.copyCss
 * @param {string} targetDir - path to the destination directory, either
 *   absolute or relative to the current working directory.
 * @throws an exception if there are any problems
 */
function copyCss(targetDir) {
  fs.copySync(path.join(__dirname, 'css'), targetDir);
}

exports.xsltdoc = xsltdoc;
exports.doTransform = doTransform;
exports.copyCss = copyCss;

/**
 * @callback mainCallback
 * @param err - an Error object
 * @param {string} targetDir - path to the destination directory, either
 *   absolute or relative to the current working directory.
 */

