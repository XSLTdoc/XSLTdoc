#!/usr/bin/env node
'use strict';

var fs = require('fs-extra');
var java = require('java');
var mvn = require('node-java-maven');
var path = require('path');
var prg = require('commander');
var temp = require('temp');
var url = require('url');

var pkg = require(path.join(__dirname, 'package.json'));

java.asyncOptions = {
  asyncSuffix: undefined,     // Don't generate async methods
  syncSuffix: "",             // Sync methods use the base name(!!)
  promiseSuffix: undefined,   // Don't generate methods returning promises
};

prg.version(pkg.version)
  .option('--debug', 'Enable debugging output messages.')
  .option('-c, --config [file]',
    'XSLTdoc config file; default is xsltdoc-config.xml.',
    'xsltdoc-config.xml')
  .parse(process.argv);

var debug = !!prg.debug;
var config = path.resolve(process.cwd(), prg.config);


mvn({
    packageJsonPath: path.join(__dirname, 'package.json'),
    localRepository: pkg.java.localRepository
  },
  function(err, mvnResults) {
    if (err) {
      console.error('Could not resolve maven dependencies', err);
      process.exit(1);
    }
    // initialize the classpath
    mvnResults.classpath.forEach(c => java.classpath.push(c));

    try {
      main();
    }
    catch(err) {
      console.error('\nERROR!\n');
      if (err.xsltdocMessage) console.error(err.xsltdocMessage);
      console.error('\nDetailed error info:\n', err);
    }
  }
);

function main() {
  var Transform = java.import('net.sf.saxon.Transform');

  // Some checks
  try {
    fs.accessSync(config);
  }
  catch(err) {
    err.xsltdocMessage = 'Can\'t find the configuration file ' + config;
    throw err;
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
    err.xsltdocMessage = 'There was a problem when we tried to run the ' +
      'transformation with these arguments:\n  ' + args.join('\n  ');
    throw err;
  }

  // The transformer wrote the output directory into the tempOut file.
  var targetDir = url.parse(fs.readFileSync(tempOut, 'utf8')).pathname;

  // Copy css
  fs.copySync(path.join(__dirname, 'css'), targetDir);
  console.log('Done. Documentation written to ' + targetDir);
}
