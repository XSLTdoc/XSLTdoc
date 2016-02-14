# Release notes

## 1.2.2 - 2009-01-20

Thanks to the patch of Greg Beauchesne, XSLTdoc got some new features and bug 
fixes:

* Added xsl:transform as a valid document root (XSL templates can
  have either xsl:stylesheet or xsl:transform as their root
  element)
* Added support for documenting match template modes
  (use <xd:doc mode="modename">)
* If a template parameter is documented in a mode but not in a
  template, the documentation is copied from the mode documentation
* The templates using a particular mode are organized into a list
  for easy access
* Added xd:return (Returns) for a "Returns" section. Like xd:param,
  this will also copy documentation from a template mode if applicable.
* Added support for the xd:access attribute to all template elements.
  By adding the attribute xd:access="private", it is possible to hide
  definitions from view. To display these, one can either add
  "<Access>private</Access>" to the XSLTdocConfig file, or pass
  in a template parameter of "access" and set it to "private".
* Added support for xsl:param/@required and xsl:param/@tunnel
* Added support for xsl:function/@override
* Added support for @version and @xsl:version (XSLT version) on
  all elements
* Added support for xsl:template/@priority
* Added support for documenting xsl:output, xsl:character-map,
  xsl:decimal-format, xsl:namespace-alias, xsl:preserve-space, and
  xsl:strip-space
* In xd:link:
* Modified to avoid the use of the "disable-output-escaping"
  attribute
* Added support for xsl:key, xsl:attribute-set, and xsl:output,
  xsl:character-map, xsl:decimal-format, xsl:preserve-space, and
  xsl:strip-space
* Added support for xsl:namespace-alias (use @stylesheet-prefix and
  @result-prefix to make the link)
* Added @name to allow linking to documentation without also
  requiring the object name be the title of the link
* Added automatic link title generation if the xd:link element has
  no content.
* Added xsl:import-schema to the stylesheet details
* Fixed the display of element declaration properties (param, mode,
  etc.) so that there is at least a comma between them
* Added @xpath-default-namespace as a declaration property and
  stylesheet property
* Namespace redefinitions are indicated in the detailed description for
  each element
* Added linking for xsl:attribute-set/@use-attribute-sets
* Added a number of additional documentation properties as
  counterparts to Doxygen tags:
* xd:version (Version, as opposed to XSLT Version)
* xd:see or xd:sa (See Also; best used with xd:link)
* xd:since (Since)
* xd:deprecated (Deprecated)
* xd:remarks (Remarks)
* xd:note (Notes)


## 1.2.1 - 2009-01-16

A bugfix release 1.2.1 is available for download.

Changelog:

* Changed output format from XML to XHTML
* Changed output encoding to UTF-8
* Fixed a bug where xd:detail was not printed
* xml:xd inline tag supports an href attribute which allows to include external XML markup
* Enabled the Forum on sourceforge


## 1.2 - 2007-12-14

Release 1.2 is available for download.

Thanks to Johannes Katelaan and Sascha Mantscheff for their contributions.

New Features:

* added section for documentation on xsl:variable
* added section for documentation on xsl:attribute-set
* implemented xd:link for referencing templates
* supports xsl:key elements

## 1.1 - 2005-01-05


## 1.0.1 - 2004-12-20


Features:

* Documentation is embedded in the XSL program
* Documenting of XSLT 2.0 functions
* Syntax highlighted source code browsing
* Generates documentation a whole set of stylesheets
* Generates documentation for included and imported stylesheets
* Layout is customizeable with CSS stylesheets
* Site layout is based on a customizeable/interchangeable html template
* Easely extensible with new tags
* Open source under GPL license
* Written in XSLT
