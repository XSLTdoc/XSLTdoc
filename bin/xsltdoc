#!/bin/bash

if [ $# -eq 0 ]
then
  echo "No configuration file was given."
  echo "Usage: xsltdoc <config-file>"
  exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Generating HTML"
java -jar $DIR/../lib/saxon9he.jar $1 $DIR/../xsl/xsltdoc.xsl > /dev/null

# This hack gets the output directory from the config file, so we can copy
# the CSS files
echo "Copying CSS"
export TARGET_DIR=`echo '//TargetDirectory' | \
  java -cp $DIR/../lib/saxon9he.jar net.sf.saxon.Query -q:- \
    -s:xsltdoc-config.xml | \
  sed -E 's/^.*path=\"(.*)\".*$/\1/'`
cp $DIR/../css/*.css $TARGET_DIR/
