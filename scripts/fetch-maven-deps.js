#!/usr/bin/env node
// This runs with the prepublish hook, which means it runs every time
// the user enters `npm install` without any arguments.
// It downloads the Maven dependencies into the vendor subdirectory.
// By default, this module downloads them into the user's ~/.m2 directory,
// but that's not good.
'use strict';

var path = require('path');

try {
var pkgPath = path.join(__dirname, '..', 'package.json');
var pkg = require(pkgPath);

var mvn = require('node-java-maven');
mvn({
    packageJsonPath: pkgPath,
    localRepository: path.join(__dirname, '..', pkg.java.localRepository),
  },
  function(err, mvnResults) {
    console.log('Done: ', mvnResults);
    if (err) {
      return console.error('Could not resolve maven dependencies', err);
    }
  }
);
}
catch(err) {
  console.error(err);
}