<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:util="http://www.pnp-software.com/util"
                version="2.0"
                exclude-result-prefixes="xd xsl util">
  <xsl:import href="stylesheetMultiple.xsl"/>
  <xd:doc type="stylesheet">
    <xd:short>
      Stylesheet that provides the possibility to create documentation
      for several stylesheets in one run.
    </xd:short>
    <xd:detail>
      The input for this is an XML config file that lists the
      stylesheets to be included in the documentation. Stylesheets which are
      imported or included by these are automatically included in the
      documentation as well, as well as included or imported stylesheets by the
      included and so on. The Config file does also provide the possibility to
      write some general documenation of the stylesheets to be documented. This
      general information will be shown in the 'Main Page' ine the documenation.
      Any html tags can be used to write this documentation. 
    </xd:detail>
  </xd:doc>
  
  <!-- Output definition for generated html files -->
  <xsl:output name="htmlOutput"
              omit-xml-declaration="no"
              method="xml"
              doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
              indent="yes" 
              encoding="iso-8859-1"
              exclude-result-prefixes="xd util xsl"/>
  
  <!-- Redefine some variables from the imported stylesheet. These variables depend on the setting in the config file. -->
  <xsl:variable name="targetDirNorm" select="resolve-uri(util:normalizeFolder(util:pathToUri(/XSLTdocConfig/TargetDirectory/@path)), base-uri(/) )"/>
  <xsl:variable name="rootSourceFolder" select="resolve-uri(util:normalizeFolder(util:pathToUri(/XSLTdocConfig/SourceDirectory/@path)), base-uri(/))"/>
  
  <xd:doc> 
    Root template. Reads the configuration file and builds a list of all
    files to be processed. Also creates the index html page and then calls the
    multipleStylesheet.xsl for each stylesheet.
  </xd:doc>
  <xsl:template match="/">
    <!-- Read the files to be processed from the config file and save them in a filelist -->
    <xsl:variable name="filelist">
      <xsl:for-each select="/XSLTdocConfig/RootStylesheets/File">
        <xsl:call-template name="buildFilelist">
          <xsl:with-param name="uri" select="resolve-uri(@href, $rootSourceFolder)"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:variable>
    <!-- Build distinct filelist eliminating file elements with the same @uri attribute -->
    <xsl:variable name="distinctFilelist">
      <xsl:for-each-group select="$filelist/file" group-by="@uri">
        <xsl:copy-of select="."/>
      </xsl:for-each-group>
    </xsl:variable>
    
    <!-- Create the index file (Main Page) -->
    <xsl:result-document format="htmlOutput" href="{$indexTarget}">
      <html>
        <head>
          <title>XSLTdoc - Main Page</title>
          <link href="XSLTdoc.css" rel="stylesheet" type="text/css"/>
        </head>
        <body>
          <div class="qindex">
            <a class="qindexHL"
              href="{util:getRelativeUriFiles($indexTarget, $targetDirNorm, true())}">Main Page</a>
            <xsl:text> | </xsl:text>
            <a class="qindex" href="{util:getRelativeUriFiles($stylesheetListTarget, $targetDirNorm, true())}">Stylesheets</a>
            <xsl:text> | </xsl:text>
            <a class="qindex" href="{util:getRelativeUriFiles($templateListTarget, $targetDirNorm, true())}">Templates/Functions</a>
          </div>
          <h1>
            <xsl:value-of select="/XSLTdocConfig/Title"/>
          </h1>
          <xsl:copy-of select="/XSLTdocConfig/Introduction/*"/>
          <hr size="1"/>
          <xsl:text>Powered by </xsl:text>
          <a target="_blank" href="http://www.pnp-software.com/XSLTdoc/index.html">XSLTdoc</a>
        </body>
      </html>
    </xsl:result-document>
    
    <!-- Call template from multipleStylesheet.xsl and provide filelist as a parameter -->
    <xsl:call-template name="processFiles">
      <xsl:with-param name="filelist" select="$distinctFilelist"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
