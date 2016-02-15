#!/usr/bin/env node
// This runs with the prepublish hook, which means it runs every time
// the user enters `npm install` without any arguments.
// It downloads the Maven dependencies into the jars subdirectory.
'use strict';

var mvn = require('node-java-maven');
mvn({
    packageJsonPath: path.join(__dirname, '../package.json'),
    localRepository: path.join(__dirname, '..', pkg.java.localRepository),
  },
  function(err, mvnResults) {
    if (err) {
      return console.error('Could not resolve maven dependencies', err);
    }
  }
);
