<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xd="http://www.pnp-software.com/XSLTdoc"
  xmlns:util="http://www.pnp-software.com/util" version="2.0">
  
  <xd:doc type="stylesheet">
    <xd:short>
      Documents multiple stylesheets by following the inlcude/import
      statements in a stylesheet.
    </xd:short>
    <xd:detail>As its input, it takes a stylesheet and follows the
      include/import statements in this stylesheet and processes the referenced
      stylesheets as well and again follows the include/import statements of
      these stylesheets. It creates a html page for each stylesheet (by using
      stylsheet.xsl) and creates a list of all stylesheets and all named
      templates and functions. It also creates a html page for each stylesheet
      that shows the sourcecode using the verbatim-formatter stylesheet.</xd:detail>
      <xd:author>ibirrer</xd:author>
    <xd:copyright>2004, P&amp;P Software GmbH</xd:copyright>
  </xd:doc>
  
  <xsl:include href="lib/util.xsl"/>
  <xsl:include href="stylesheetSingle.xsl"/>
  <xsl:include href="verbatim/xmlverbatimwrapper.xsl"/>
  
  <xd:doc> 
    <xd:short>The target directory for the documentation files.</xd:short>
    <xd:detail>
      <p>All html files will be created within this folder. If the target directory is given as a
      relative path, the path is always relative to the stylesheet that was first
      loaded by the xslt processor. Normally this will be this file
      (multipleStylesheets.xsl)</p>
      <p>This parameter should not be used witing the stylesheet directly. 
      Use the variable $targetDirNorm instead.</p>
    </xd:detail>
    <xd:param type="string"/>
  </xd:doc>
  <xsl:param name="targetDir"/>
  <xsl:variable name="targetDirNorm" select="resolve-uri(util:normalizeFolder(util:pathToUri($targetDir)), static-base-uri() )"/>
  <xsl:variable name="rootSourceFolder" select="util:normalizeFolder(util:getFolder(base-uri()))"/>
  <xsl:variable name="stylesheetListTarget" select="concat($targetDirNorm, 'stylesheetList.html')"/>
  <xsl:variable name="templateListTarget" select="concat($targetDirNorm, 'templateList.html')"/>
  <xsl:variable name="indexTarget" select="concat($targetDirNorm, 'index.html')"/>
  
  <xd:doc> 
    Root template. Creates the filelist to be documented and passes it to
    the processFiles template.
  </xd:doc>
  <xsl:template match="/">
    <xsl:message>Output: <xsl:value-of select="$targetDirNorm"/>
    </xsl:message>
    <xsl:call-template name="processFiles">
      <xsl:with-param name="filelist">
        <xsl:call-template name="buildFilelist"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xd:doc> 
    This template calls sub-templates to build several html documentation
    files. This includes the stylesheet pages, the sourcecode pages, the
    stylesheet list page and the template/function list page. 
    <xd:param type="node-set">
      A node-set that contains all the files which should be documented.
    </xd:param>
  </xd:doc>
  <xsl:template name="processFiles">
    <xsl:param name="filelist"/>
    <xsl:message>Files to process: <xsl:value-of select="count($filelist/file)"/>
    </xsl:message>
    <xsl:message>TargetDir: <xsl:value-of select="$targetDirNorm"/>
    </xsl:message>
    <xsl:message>SourceDir: <xsl:value-of select="$rootSourceFolder"/>
    </xsl:message>
    <!-- Build html output for each stylesheet -->
    <xsl:call-template name="buildStylesheetPages">
      <xsl:with-param name="filelist" select="$filelist"/>
    </xsl:call-template>
    <!-- Build verbatim source code documents for each file -->
    <xsl:call-template name="buildSourcecodePages">
      <xsl:with-param name="filelist" select="$filelist"/>
    </xsl:call-template>
    <!-- Build one html page of a list of all stylesheets -->
    <xsl:result-document href="{$stylesheetListTarget}"
      omit-xml-declaration="yes" method="html">
      <xsl:call-template name="buildStylesheetList">
        <xsl:with-param name="filelist" select="$filelist"/>
      </xsl:call-template>
    </xsl:result-document>
    <!-- Build html list of all named templates and funtcions -->
    <xsl:result-document href="{$templateListTarget}" omit-xml-declaration="yes" method="html">
      <xsl:call-template name="buildTemplateList">
        <xsl:with-param name="filelist" select="$filelist"/>
      </xsl:call-template>
    </xsl:result-document>
  </xsl:template>
  
  <xd:doc>
    Builds the html documentation pages for each stylesheet. 
    <xd:param name="filelist">List of the files to process. </xd:param>
  </xd:doc>
  <xsl:template name="buildStylesheetPages">
    <xsl:param name="filelist"/>
    <xsl:for-each select="$filelist/file">
      <xsl:variable name="destinationPath" select="concat($targetDirNorm, @relativeUri, '.xd.html')"/>
      <!-- Output a new document for each inlude/import -->
      <xsl:result-document href="{$destinationPath}" omit-xml-declaration="yes" method="html">
        <!-- Build the html output of the actual stylesheet. This uses the templates defined in stylesheet.xsl -->
        <xsl:apply-templates select="document(@uri)/xsl:stylesheet">
          <xsl:with-param name="htmlBanner">
            <div class="qindex">
              <a class="qindex"
                href="{util:getRelativeUriFiles($indexTarget, $destinationPath, true())}">Main Page</a>
              <xsl:text> | </xsl:text>
              <a class="qindex" href="{util:getRelativeUriFiles($stylesheetListTarget, $destinationPath, true())}">Stylesheets</a>
              <xsl:text> | </xsl:text>
              <a class="qindex" href="{util:getRelativeUriFiles($templateListTarget, $destinationPath, true())}">Templates/Functions</a>
            </div>
          </xsl:with-param>
          <xsl:with-param name="filename" select="@filename"/>
          <xsl:with-param name="stylesheetPath">
            <xsl:value-of select="concat(util:getRelativeUri(util:getFolder(@uri), $rootSourceFolder),'XSLTdoc.css')"/>
          </xsl:with-param>
          <xsl:with-param name="htmlFooter">
            <xsl:text>Powered by </xsl:text>
            <a target="_blank" href="http://www.pnp-software.com/XSLTdoc/index.html">XSLTdoc</a>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>
  
  <xd:doc> 
    Builds highlighted html pages for XSLT source code.
    <xd:param name="filelist">List of the files to process. </xd:param>
  </xd:doc>
  <xsl:template name="buildSourcecodePages">
    <xsl:param name="filelist"/>
    <xsl:for-each select="$filelist/file">
      <xsl:variable name="destinationPath" select="concat($targetDirNorm, @relativeUri, '.src.html')"/>
      <!-- Output a new document for each inlude/import -->
      <xsl:result-document href="{$destinationPath}" omit-xml-declaration="yes" method="html">
        <!-- Build the html output for the actual stylesheet. -->
        <xsl:apply-templates select="document(@uri)" mode="xmlverbwrapper">
          <xsl:with-param name="css-stylesheet">
            <xsl:value-of select="concat(util:getRelativeUri(util:getFolder(@uri), $rootSourceFolder),'xmlverbatim.css')"/>
          </xsl:with-param>
        </xsl:apply-templates>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>
  
  <xd:doc>
    Builds html page that lists all stylesheets.
  <xd:param name="filelist">List of the files to process.</xd:param>
  </xd:doc>
  <xsl:template name="buildStylesheetList">
    <xsl:param name="filelist"/>
    <html>
      <head>
        <title>XSLTdoc - Stylesheets</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
        <link href="XSLTdoc.css" rel="stylesheet" type="text/css"/>
      </head>
      <body>
        <div class="qindex">
          <a class="qindex" href="{util:getFile($indexTarget)}">Main Page</a>
          <xsl:text> | </xsl:text>
          <a class="qindexHL" href="{util:getFile($stylesheetListTarget)}">Stylesheets</a>
          <xsl:text> | </xsl:text>
          <a class="qindex" href="{util:getFile($templateListTarget)}">Templates/Functions</a>
        </div>
        <p>&#160;</p>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="reticuleColor">
              <table width="100%" border="0" cellspacing="1" cellpadding="3">
                <tr>
                  <th>
                    <h2>Stylesheets</h2>
                  </th>
                </tr>
                <xsl:for-each select="$filelist/file">
                  <xsl:sort select="@folder"/>
                  <xsl:sort select="@filename"/>
                  <tr>
                    <td>
                      <table width="100%" border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td width="15%" nowrap="">
                            <a href="{concat(@relativeUri, '.xd.html')}">
                              <xsl:value-of select="@relativeUri"/>
                            </a>
                          </td>
                          <td>&#160;</td>
                        </tr>
                        <tr>
                          <td colspan="2">
                            <p class="shortDescription">
                              <xsl:call-template name="printShortDescription">
                                <xsl:with-param name="doc" select="document(@uri)/xsl:stylesheet/xd:doc[@type='stylesheet']"/>
                              </xsl:call-template>
                            </p>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </td>
          </tr>
        </table>
        <hr size="1"/>
        <xsl:text>Powered by </xsl:text>
        <a target="_blank" href="http://www.pnp-software.com/XSLTdoc/index.html">XSLTdoc</a>
      </body>
    </html>
  </xsl:template>
  
  <xd:doc>
    Builds html page that lists all templates and functions.
    <xd:param name="filelist">List of the files to process.</xd:param>
  </xd:doc>
  <xsl:template name="buildTemplateList">
    <xsl:param name="filelist"/>
    <html>
      <head>
        <title>XSLTdoc - Templates / Functions</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
        <link href="XSLTdoc.css" rel="stylesheet" type="text/css"/>
      </head>
      <body>
        <div class="qindex">
          <a class="qindex" href="{util:getFile($indexTarget)}">Main Page</a>
          <xsl:text> | </xsl:text>
          <a class="qindex" href="{util:getFile($stylesheetListTarget)}">Stylesheets</a>
          <xsl:text> | </xsl:text>
          <a class="qindexHL" href="{util:getFile($templateListTarget)}">Templates/Functions</a>
        </div>
        <p>&#160;</p>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="reticuleColor">
              <table width="100%" border="0" cellspacing="1" cellpadding="3">
                <tr>
                  <th>
                    <h2>Templates</h2>
                  </th>
                </tr>
                <xsl:for-each select="$filelist/file/template">
                  <xsl:sort select="@name"/>
                  <xsl:variable name="template" select="document(parent::file/@uri)/xsl:stylesheet/xsl:template[@name=current()/@name]"/>
                  <xsl:variable name="doc" select="$template/preceding-sibling::*[1][self::xd:doc]"/>
                  <tr>
                    <td>
                      <table width="100%" border="0" cellspacing="0" cellpadding="3">
                        <tr>
                          <td width="15%" nowrap="">
                            <a href="{concat(parent::file/@relativeUri, '.xd.html')}#{generate-id($template)}">
                              <xsl:value-of select="@name"/>
                            </a>
                            <xsl:call-template name="printTemplateDeclaration">
                              <xsl:with-param name="doc" select="$doc"/>
                              <xsl:with-param name="template" select="$template"/>
                            </xsl:call-template>
                          </td>
                          <td>&#160;</td>
                        </tr>
                        <tr>
                          <td colspan="2">
                            <p class="shortDescription">
                              <xsl:call-template name="printShortDescription">
                                <xsl:with-param name="doc" select="$doc"/>
                              </xsl:call-template>
                            </p>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </td>
          </tr>
        </table>
        <p>&#160;</p>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="reticuleColor">
              <table width="100%" border="0" cellspacing="1" cellpadding="3">
                <tr>
                  <th>
                    <h2>Functions</h2>
                  </th>
                </tr>
                <xsl:for-each select="$filelist/file/function">
                  <xsl:sort select="@name"/>
                  <xsl:variable name="functions" select="document(parent::file/@uri)/xsl:stylesheet/xsl:function[@name=current()/@name]"/>
                  <xsl:variable name="relativeUri" select="parent::file/@relativeUri"/>
                  <xsl:for-each select="$functions">
                    <xsl:variable name="function" select="."/>
                    <xsl:variable name="doc" select="$function/preceding-sibling::*[1][self::xd:doc]"/>
                    <tr>
                      <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                          <tr>
                            <td width="15%" nowrap="">
                              <a href="{concat($relativeUri, '.xd.html')}#{generate-id($function)}">
                                <xsl:value-of select="@name"/>
                              </a>
                              <xsl:call-template name="printTemplateDeclaration">
                                <xsl:with-param name="doc" select="$doc"/>
                                <xsl:with-param name="template" select="$function"/>
                              </xsl:call-template>
                            </td>
                            <td>&#160;</td>
                          </tr>
                          <tr>
                            <td colspan="2">
                              <p class="shortDescription">
                                <xsl:call-template name="printShortDescription">
                                  <xsl:with-param name="doc" select="$doc"/>
                                </xsl:call-template>
                              </p>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
              </table>
            </td>
          </tr>
        </table>
        <hr size="1"/>
        <xsl:text>Powered by </xsl:text>
        <a target="_blank" href="http://www.pnp-software.com/XSLTdoc/index.html">XSLTdoc</a>
      </body>
    </html>
  </xsl:template>
  
  <xd:doc> 
    Builds a list of all stylesheet files by following the include and
    import links in each stylesheet. 
  </xd:doc>
  <xsl:template name="buildFilelist">
    <xsl:param name="uri" select="base-uri(.)"/>
    <xsl:variable name="normalizedUri" select="util:normalizeUri($uri)"/>
    <xsl:variable name="folder" select="util:getFolder($normalizedUri)"/>
    <xsl:variable name="filename" select="util:getFile($normalizedUri)"/>
    <xsl:variable name="relativeUri" select="util:getRelativeUri($rootSourceFolder, util:getFolder($normalizedUri))"/>
    <file uri="{$normalizedUri}" folder="{$folder}" filename="{$filename}" relativeUri="{concat($relativeUri,$filename)}">
      <xsl:for-each select="document($normalizedUri)/xsl:stylesheet/xsl:template[@name]">
        <template name="{@name}"/>
      </xsl:for-each>
      <xsl:for-each select="document($normalizedUri)/xsl:stylesheet/xsl:function">
        <function name="{@name}"/>
      </xsl:for-each>
    </file>
    <xsl:for-each select="document($normalizedUri)/xsl:stylesheet/xsl:include | document($normalizedUri)/xsl:stylesheet/xsl:import">
      <xsl:call-template name="buildFilelist">
        <xsl:with-param name="uri" select="resolve-uri(@href, base-uri(.))"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
