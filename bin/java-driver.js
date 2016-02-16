#!/usr/bin/env node
'use strict';

// This module resolves the maven dependencies, adds them to the
// java classpath, and (asynchronously) returns the java object,
// with the methods instantiated per this project's conventions.
//
// Usage:
//   var jd = require('./java-driver.js');
//   jd.java(function(err, java) {
//     if (err) { ... }
//     module.java = java;
//     ...
//   });
//
// If you run this from the command line, it will download any
// missing Maven artifacts into vender, and then exit.
//
// Note that this is called from the package's prepublish hook, which means
// it's called when the user does `npm install` with no arguments. Thus, the
// Maven dependencies are installed at the same time as the other Node deps.

var java = require('java');
var mvn = require('node-java-maven');
var path = require('path');
var VError = require('verror');

java.asyncOptions = {
  asyncSuffix: undefined,
  syncSuffix: "",             // Sync methods use the base name
  promiseSuffix: undefined,   // No promises
};

var pkgPath = path.join(__dirname, '../package.json');
var pkg = require(pkgPath);

if (!module.parent) {
  _java(function(err, java) {
    if (err) {
      console.error("Error attempting to resolve Maven dependencies: ", err);
      process.exit(1);
    }
  });
}

function _java(cb) {
  mvn({
      packageJsonPath: pkgPath,
      localRepository: path.join(__dirname, '..', pkg.java.localRepository),
    },
    function(err, mvnResults) {
      if (err) {
        cb(new VError(err, 'Could not resolve maven dependencies'));
        return;
      }
      //console.log('mvnResults: ', mvnResults);
      mvnResults.classpath.forEach(c => java.classpath.push(c));
      cb(null, java);
    }
  );
}

exports.java = _java;
