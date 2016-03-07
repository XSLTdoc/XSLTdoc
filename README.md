# XSLTdoc - code documentation tool for XSLT

***XSLTdoc is a Javadoc-like tool for XSLT all versions of XSLT (1.0, 1.1, 
2.0).***

See also the [home page](http://xsltdoc.github.io/). This project has recently
been moved, with kind permission from the original authors Iwan Birrer and
Alessandro Pasetti, from
[SourceForge](https://sourceforge.net/projects/xsltdoc/) to a [new home on
GitHub](https://github.com/XSLTdoc/XSLTdoc/).

The XSLTdoc tool defines conventions for documenting XSLT "code elements" 
directly in the source code. These "documentation elements" are then extracted 
by the XSLTdoc tool to build a documentation consisting of several linked 
HTML pages which facilitate easy access. The
XSLT source code is also rendered with syntax highlighting.



**Features**

* Syntax highlighted source code
* Generates documentation whole sets of stylesheets, following includes and imports
* Style customizeable with CSS stylesheets
* Site layout is based on a customizeable/interchangeable html template
* Easily extensible with new tags
* Open source under GPL license
* Written in XSLT
* Uses Node.js, npm, and node-java for ease of packaging, installation, and running


## Installing

The easiest (but not the only) way to install and use this tool is with Node.js.
If you don't have that installed, and don't want to install it, then
see the section below, "Running manually".

To install the XSLTdoc tool:

```bash
npm install -g xsltdoc
```

## Running

In the project where your XSLT resides, create a copy of the default
configuration file, named `xsltdoc-config.xml`, with:

```bash
xsltdoc --init
```

Open this config file in an editor, and change the settings to suit your 
needs. There are copious comments describing the meaning of each setting, and
more detailed descriptions below.
You can rename this config file if you want, but then you will have to specify
the name with a command line option, whenever you run `xsltdoc`.

To run the tool, and generate the documenation:

```bash
xsltdoc
```

Use the `--help` switch to get some more usage information.

You can run it programmatically from another Node.js script with

```javascript
var xsltdoc = require('xsltdoc');

// The conversion runs asynchronously and then invokes a callback
xsltdoc(opts, function(targetDir) {
  console.log('Done. Documentation written to ' + targetDir);
});
```


## Running manually

Download the latest release from 
[GitHub](https://github.com/XSLTdoc/XSLTdoc/releases/latest), and unzip it
to the location of your choice. 

XSLTdoc is written in XSLT 2.0. You need an XSLT 2.0 processor to run it.
Download the latest version of Saxon-HE
from the [Sourceforge download 
page](https://sourceforge.net/projects/saxon/files/Saxon-HE/) (for example,
`SAXONHE9-7-0-3J.zip`) and extract that into the `lib` subdirectory of
the XSLTdoc directory.

The examples here assume you're on a Unix-flavored box with a bash shell. If
you are on Windows, adjust accordingly. The following commands will accomplish
all of the above instructions, and set an environment variable, `XSLTDOC`, to
point to the base directory of the tool. Substitute whatever the current
latest release version number is.


```bash
https://github.com/XSLTdoc/XSLTdoc/archive/latest.zip
wget https://github.com/XSLTdoc/XSLTdoc/archive/1.3.1.zip
unzip 1.3.1.zip
export XSLTDOC=`pwd`/XSLTdoc-1.3.1/
wget https://sourceforge.net/projects/saxon/files/Saxon-HE/9.7/SaxonHE9-7-0-3J.zip
unzip SaxonHE9-7-0-3J.zip -d $XSLTDOC/lib saxon9he.jar
# clean up
rm 1.3.1.zip
rm SaxonHE9-7-0-3J.zip
```


To set up your project's configuration file, copy the template from the tool
directory:

```bash
cp $XSLTDOC/templates/xsltdoc-config.xml .
```

Then open it in an editor and change the settings as needed.

Next, to generate the documentation:

```bash
java -jar $XSLTDOC/lib/saxon9he.jar xsltdoc-config.xml $XSLTDOC/xsl/xsltdoc.xsl
```

Fonts, colors and layout of the HTML documentation are defined in a few CSS 
files which can be found in the `css` directory of the installation. Copy these 
files to the folder where the documentation was generated. For example:

```bash
cp $XSLTDOC/css/* doc
```

***Note:*** If you need an older version of XSLTdoc, you can find them listed
[here](https://github.com/XSLTdoc/XSLTdoc/releases).



## Documenting your XSLT code

Documentation elements are written in XML. Because XSLT is expressed in XML 
too, it is necessary to define a new namespace for XSLTdoc to enable a XSLT 
processor to distinguish between documentation and source code. The URI for 
this namespace is http://www.pnp-software.com/XSLTdoc. This namespace must 
be declared in any stylesheet which uses XSLTdoc for documenting. 
Example:

```xml
&lt;xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc" version="2.0">
  ...
&lt;/xsl:stylesheet>
```

### General documenting rules

The documentation is normally added before the source element that should be 
documented. Generally this looks like this:

```xml
&lt;xd:doc>
  ...
&lt;/xd:doc>
&lt;xsl:...>
```

Any XSLTdoc documentation is enclosed in an `xd:doc` element. If you just 
want to write a plain text comment the `xd:doc` element can contain simple 
text. Text before the first period is considered as short description, the 
remaining as detailed description:

```xml
&lt;xd:doc>
  This is the short description. And here comes a more detailed 
  description that appears in the detailed view of the documentation only.
&lt;/xd:doc>
&lt;xsl:...>
```

If you use this technique, then no HTML elements are allowed in the text. If 
you want to use HTML tags within short and detailed description the text for 
the short and detailed description needs to enclosed in special XSLTdoc tags:

```xml
&lt;xd:doc>
  &lt;xd:short>This is the short description with 
    &lt;code>HTML tags&lt;/code>.&lt;/xd:short>
  &lt;xd:detail>
    And here comes a &lt;b>more detailed&lt;/b> 
    description showed only in the detailed view of the documentation.
  &lt;/xd:detail>
&lt;/xd:doc>
&lt;xsl:...>
```

### Stylesheet documentation

The documentaion of a stylesheet is the only exception where the documentation 
is written as a subelement of the target element (xsl:stylesheet). To mark a 
documentation element as a stylesheet documentation the type attribute of 
the `xd:doc` element must be set to `stylesheet`. A stylesheet documentation 
can have the following subelements (properties): 
`xd:author`, `xd:copyright`, `xd:cvsId`, `xd:svnId`. For example:

```xml
&lt;xsl:stylesheet ...>
  &lt;xd:doc type="stylesheet">
    ...
    &lt;xd:author>ibirrer&lt;/xd:author>
    &lt;xd:copyright>P&amp;P Software, 2007&lt;/xd:copyright>
    &lt;xd:cvsId>$Id: XSLTdocConfig.xml 42 2009-01-16 15:02:32Z ibirrer $&lt;/xd:cvsId>
  &lt;xd:doc/>
  ...
&lt;/xsl:stylesheet>
```

Properties can be added by writing a property extension. See the properties 
directory of the XSLTdoc installation for examples.

### Stylesheet Parameter

To document a stylesheet parameter you can use the type attribute of the 
`xd:doc` element to define its type:

```xml
&lt;xsl:stylesheet ...>
...
  &lt;xd:doc type="string">
    A Stylesheet parameter of type string.
  &lt;/xd:doc>
  &lt;xsl:param name="outputDir"/>
  ...
&lt;/xsl:stylesheet>
```

### Function/Template Documentation

The parameter of a template or a function can be described with a 
`xd:param` element. The name attribute is obligatory for templates and 
functions while the type attribute is optional for template definitions.

```xml
&lt;xd:doc>
  A template with a parameter of the type string.
  &lt;xd:param type="string">The string to be processed.&lt;/xd:param>
&lt;/xd:doc>
```

Look at the source code of the XSLTdoc tool for more examples. The source 
code is accessible through this website. Just go to a detailed description 
of a template or function and click on the source link.

### Inline tags

You can use so-called inline tags to tag special parts inside a 
`xs:short` or `xd:detail` element. The `xd:xml` inline tag can be used to 
print XML to the output. The whole xml inside the tag is transformed to html 
by XSLTdoc.

```xml
&lt;xd:doc>
  &lt;xd:detail>
    The following XML inside the xd:xml tag is printed exactly as it shows 
    here:
    &lt;xd:xml>
&lt;html>
  &lt;head>&lt;/head>
  &lt;body>
    Bla
  &lt;/body>
&lt;/html>
    &lt;/xd:xml>
  &lt;xd:detail>
&lt;/xd:doc>
&lt;xsl:...>
```


## Building, developing, contributing

You don't need to build this project in order to use it. If you want to build
it anyway, for whatever reason, this section gives some instructions.

You'll need to have Node.js and Java installed.

Then, after cloning the repository, install all the dependencies that the
main script uses, and install the grunt build tool (you should only need to
do these once):

```bash
npm install
npm install -g grunt-cli
```

Then:

```bash
grunt
```

To get help with grunt, including a list of tasks defined for this project:

```bash
grunt --help
```

### Publishing docs to GitHub pages

You'll need to have commit access to the [GitHub pages
repo](https://github.com/XSLTdoc/xsltdoc.github.io). To publish,
first run a build, and then bring up the "doc" pages
in a static server to make sure they look okay. Then run

```bash
grunt gh-pages
```

### Releasing and publishing

Here's a checklist for doing a release. Don't bump the version number -- 
that will be done automatically.

* Update release-notes.md
* Wipe out any development side-effects:

    ```bash
    npm uninstall -g xsltdoc
    git clean -ndxff    # dry-run "super clean", make sure it's okay, then
    git clean -dxff
    git checkout -f
    ```

* Do `npm install` and `grunt`; make sure tests pass.

* Check the docs. Start `http-server` and then
  go to http://localhost:8080/doc.

* Try out the instructions for using the tool with a new project. Currently:

    ```bash
    npm install -g .    #=> in the XSLTdoc directory
    export XSLTDOC=`pwd`
    mkdir -p ~/temp/try-xsltdoc
    cd ~/temp/try-xsltdoc
    xsltdoc --init
    cp $XSLTDOC/test/test.xsl .
    xsltdoc
    http-server  # Go to http://localhost:8080/doc, and verify
    ```

* Make sure everything is committed and pushed.

* Tag, publish, and re-generate the gh-pages:

    ```bash
    git commit ...
    git tag -a 1.3.1
    git push
    git push --tags
    npm publish
    grunt ghPages
    ```

## See also

* [Release notes](https://github.com/XSLTdoc/XSLTdoc/blob/master/release-notes.md)

## Notes on Node.js implementation

I (Chris Maloney) ported this to Node.js as a proof-of-concept, to see if it 
would be practical to use Node.js and npm infrastructure, along with node-java,
to manage XML/XSLT projects. I think it was a success: as long as the basic
prerequisites are met, that the user has Node.js and Java installed, then
installing and running this app are very easy and simple -- much easier than
trying to download, configure and install an XSLT application by hand.

## To do

* This README needs a TOC that will work both on GitHub and when it's passed
  through markdown-it -> xsltdoc. Right now, I don't know how to get consistent
  heading anchors in.
* The npm `xmltools` library is currently in the works, which provides a better
  version of the `java-driver.js` script. This repo should be updated whenever
  that gets done.
* Recently added highlight.js for syntax highlighting of the home page. That
  should probably subsume/replace the "verbatim" syntax highlighting that is
  currently used for XSLT source (which needs work, anyway).
* The node-java-maven dependency right now points to a specific commit on
  GitHub, because of a very minor
  fix to remove a `console.log` message. This should be updated whenever
  it's released again.
* It would be nice to auto-generate documentation for the JavaScript here.
  I did some experimenting with jsdoc (see [this tag]()), docco, and
  grok, but didn't find anything perfect:
    * jsdoc - a bit onerous in terms of getting your structured comments
      just right; especially for CommonJS modules -- it's a bad fit.
    * docco and grok - too *unstructured*. They produce very pretty pages,
      but nothing like API documentation.
* What would be really cool is if we could integrate that JS documentation
  framework with this XSLTdoc output -- a generalized doc framework.


## Copyright And Licence

*This license information was copied from the [XSLTdoc home
page](http://www.pnp-software.com/XSLTdoc/#CopyrightAndLicence) on
2016-02-14.*

The software and documenation downloadable from this site is made up of the
following items:

* Software and documentation for the XSLTdoc documentation tool. The copyright
  for these items belongs to P&P Software. These items can be downloaded and
  used under the terms of the GNU General Public Licence.
* The The Saxon XSLT and XQuery Processor from Saxonica Limited. This software
  is used and distributed in accordance with the terms of the Mozilla Public
  License Version 1.0.
* The XML to HTML Verbatim Formatter with Syntax Highlighting. This software
  was downloaded from http://www.informatik.hu-berlin.de/~obecker/XSLT/. There
  was no license information available on this site at the time of downloading
  (October 2004).

THE XSLTdoc DELIVERABLES ARE PROVIDED "AS IS'' AND ANY EXPRESSED OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
EVENT SHALL THE PROVIDER OF THE SOFTWARE BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
