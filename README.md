XSLTdoc is a Javadoc-like tool for XSLT 2.0. [Home 
page](http://www.pnp-software.com/XSLTdoc/).

This project has been migrated from SourceForge
[here](https://sourceforge.net/projects/xsltdoc/) to GitHub at
[XSLTdoc/XSLTdoc](https://github.com/XSLTdoc/XSLTdoc), preserving original
Subversion commit history. 
We are still trying to contact the original authors for permission to make this 
the "official" project repo.


## Using

Download from [the Sourceforge
site](https://sourceforge.net/projects/xsltdoc/files/xsltdoc/). The latest
version is 1.2.2.

See the [home page](http://www.pnp-software.com/XSLTdoc/) for more
detailed instructions on running from the command line.

Since those were written, we've added a very primitive bash script. This is not
yet included in any release version, so to use it, you'll have to get the code 
from the GitHub repository, either by cloneing or using the "Download Zip" 
button. Then,
put the "bin" subdirectory into your PATH, and run the tool with:

```
xsltdoc <config-file>
```


## Building

You don't need to build this project in order to run it. The build script
creates the home page site (using this tool itself) and provides tasks for
testing and creating a distribution tarball.

To run any of the build tasks, install and run `ant`. The default task builds 
the pages for the home page, and writes them to the doc directory.

The tool uses SaxonHE 9 to run the XSLT transformations. It is downloaded
automatically, the first time you run the build.

Use `ant -p` to see the list of tasks.


## See also 

* [Release notes](release-notes.md)


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
