<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:util="http://www.pnp-software.com/util"
                version="2.0"
                exclude-result-prefixes="xd xsl util">
  
  <xd:doc type="stylesheet">
    <xd:short>Creates a HTML page for a single stylesheet.</xd:short>
    <xd:detail>
      This stylesheet defines the main html structure of the output. It calls sub-templates to 
      build documentation parts for different parts of a stylesheet (templates, functions etc.).
      These sub-templates are located in the 'rules' directory.
    </xd:detail>
    <xd:author>ibirrer</xd:author>
    <xd:copyright>2004, P&amp;P Software GmbH</xd:copyright>
  </xd:doc>
  
  <!-- ************* Includes *********************** -->
  <xsl:include href="rules/stylesheetDetail.xsl"/>
  <xsl:include href="rules/parameterSummary.xsl"/>
  <xsl:include href="rules/parameterDetail.xsl"/>
  <xsl:include href="rules/namedTemplateSummary.xsl"/>
  <xsl:include href="rules/unnamedTemplateSummary.xsl"/>
  <xsl:include href="rules/templateDetail.xsl"/>
  <xsl:include href="rules/functionSummary.xsl"/>
  
  <!-- ************* Unnamed Templates ************** -->
  <xd:doc>
    <xd:name>Root Template</xd:name>
    <xd:short>Calls sub-templates for each part of the stylesheet documentation.</xd:short>
    <xd:param name="filename">The filename of the stylesheet to document.</xd:param>
    <xd:param name="htmlBanner">HTML fragment to be added at the very beginning of the body of the html page.</xd:param>
    <xd:param name="stylesheetPath">Path to a css stylesheet.</xd:param>
    <xd:param name="htmlFooter">HTML fragment to be added at the very end of the body of the html page.</xd:param>
  </xd:doc>
  <xsl:template match="/xsl:stylesheet">
    <xsl:param name="filename"/>
    <xsl:param name="htmlBanner"/>
    <xsl:param name="stylesheetPath" select="'XSLTdoc.css'"/>
    <xsl:param name="htmlFooter">
      <xsl:text>Powered by </xsl:text>
      <a target="_blank" href="http://www.pnp-software.com/XSLTdoc/index.html">XSLTdoc</a>
    </xsl:param>
    <html>
      <head>
        <title>XSLTdoc</title>
        <link href="{$stylesheetPath}" rel="stylesheet" type="text/css"/>
      </head>
      <body>
        <xsl:copy-of select="$htmlBanner"/>
        <xsl:apply-templates select="." mode="stylesheetDetail"/>
        <xsl:apply-templates select="." mode="parameterSummary"/>
        <xsl:apply-templates select="." mode="unnamedTemplateSummary"/>
        <xsl:apply-templates select="." mode="namedTemplateSummary"/>
        <xsl:apply-templates select="." mode="functionSummary"/>
        <xsl:apply-templates select="." mode="parameterDetail">
          <xsl:with-param name="filename" select="$filename"></xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="unnamedTemplateDetail">
          <xsl:with-param name="filename" select="$filename"></xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="namedTemplateDetail">
          <xsl:with-param name="filename" select="$filename"></xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="functionDetail">
          <xsl:with-param name="filename" select="$filename"></xsl:with-param>
        </xsl:apply-templates>
        <xsl:copy-of select="$htmlFooter"/>
        <br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
      </body>
    </html>
  </xsl:template>

  <xd:doc>
    Extracts the short description from a string. Everything before the
    first period is considered as short description. If the string doesn't
    contain a period, the whole string is returned. 
    <xd:param name="doc" type="string">xd:doc element</xd:param>
  </xd:doc>
  <xsl:template name="extractShortDescription">
    <xsl:param name="doc"/>
    <!-- <xsl:message><xsl:copy-of select="$doc/text()[contains(.,'.')][1] | $doc/text()[contains(.,'.')][1]/preceding-sibling::node()"/></xsl:message> -->
    <xsl:variable name="shortDesc" select="substring-before(string($doc/text()),'.')"/>
    <xsl:choose>
      <xsl:when test="string-length($shortDesc) &lt;= 0">
        <xsl:value-of select="$doc/text()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$shortDesc"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc> 
    Extracts the detail description from string. Everything after the
    first period is considered as detail description. If no detail description
    can be extracted, the empty string is returned.
    <xd:param name="doc" type="string">
      xd:doc element
    </xd:param>
  </xd:doc>
  <xsl:template name="extractDetailDescription">
    <xsl:param name="doc"/>
    <xsl:variable name="detailDesc" select="substring-after(string($doc/text()),'.')"/>
    <xsl:choose>
      <xsl:when test="string-length($detailDesc) &lt;= 0">
        <xsl:text></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$detailDesc"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc>
    <xd:short>Prints the detail description of a xd:doc element.</xd:short>
    <xd:detail> 
      If no detail description is found, the string &quot;No
      detail description available&quot; is printed
    </xd:detail>
    <xd:param name="doc" type="node-set">The whole xd:doc node-set</xd:param>
  </xd:doc>
  <xsl:template name="printDetailDescription">
    <xsl:param name="doc"/>
    <xsl:choose>
      <xsl:when test="count($doc/*) &gt;= 0">
        <!-- xd documentation exists, find detail description -->
        <xsl:choose>
          <xsl:when test="$doc/xd:detail">
            <xsl:apply-templates select="$doc/xd:detail" mode="XdocTags"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="extractDetailDescription">
              <xsl:with-param name="doc" select="$doc"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc>
    <xd:short>Prints the short description of a xd:doc element.</xd:short>
    <xd:detail> 
      If no short description is found, the string &quot;No
      short description available&quot; is printed.
    </xd:detail>
    <xd:param name="doc" type="node-set">The whole xd:doc node-set</xd:param>
  </xd:doc>
  <xsl:template name="printShortDescription">
    <xsl:param name="doc"/>
    <xsl:choose>
      <xsl:when test="count($doc) &gt; 0">
        <!-- xd documentation exists, find short description -->
        <xsl:choose>
          <xsl:when test="$doc/xd:short">
            <xsl:apply-templates select="$doc/xd:short" mode="XdocTags"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="extractShortDescription">
              <xsl:with-param name="doc" select="$doc"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>No short description available</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc> 
    Prints the decalaration of a function. This includes the parameters. 
    <xd:param name="doc" type="node-set">The xd:doc node-set</xd:param>
    <xd:param name="function" type="node-set">
      The xsl:function node-set for which the <b>declaration</b> should be printed
    </xd:param>
  </xd:doc>
  <xsl:template name="printFunctionDeclaration">
    <xsl:param name="doc"/>
    <xsl:param name="function"/>
    <xsl:text> (</xsl:text>
    <xsl:if test="$function/xsl:param">
      <span class="form">param: </span>
      <xsl:for-each select="$function/xsl:param">
          <span class="parameterType"><xsl:value-of select="@as"/>&#160;</span>
        <span class="parameterName">
          <xsl:value-of select="@name"/>
        <xsl:if test="position() != last()">,&#160;</xsl:if>
        </span>
      </xsl:for-each>
    </xsl:if>
    <xsl:text>)</xsl:text>
  </xsl:template>
  
  <xd:doc> 
    Prints the short form of the decalaration of a template. This
    includes the parameters and the mode. 
    <xd:param name="doc" type="node-set">The xd:doc node-set</xd:param>
    <xd:param name="template" type="node-set">
      The xsl:template node-set for which the <b>declaration</b> should be printed
    </xd:param>
  </xd:doc>
  <xsl:template name="printTemplateDeclaration">
    <xsl:param name="doc"/>
    <xsl:param name="template"/>
    <xsl:if test="$template/xsl:param or $template/@mode">
      <xsl:text> (</xsl:text>
      <xsl:if test="$template/xsl:param">
        <span class="form">param: </span>
        <xsl:for-each select="$template/xsl:param">
          <xsl:if test="$doc/xd:param[@name=current()/@name]">
            <span class="parameterType">
              <xsl:value-of select="$doc/xd:param[@name=current()/@name]/@type"/>&#160;</span>
          </xsl:if>
          <span class="parameterName">
            <xsl:value-of select="@name"/>
          <xsl:if test="position() != last()">,&#160;</xsl:if>
          </span>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test="@mode">
        <span class="form">mode: </span>
        <span class="parameterValue"><xsl:value-of select="$template/@mode"/></span>
      </xsl:if>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>
  
  
  <xd:doc>
    Default template in XdocTags mode. This ensures that elements that
    need no conversion(html tags) are copied to the result tree.
  </xd:doc>
  <xsl:template match="*" mode="XdocTags">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="*" mode="XdocTags"/>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    Default template in XdocTags mode for elements in xd namespace.
  </xd:doc>
  <xsl:template match="xd:*" mode="XdocTags">
    <xsl:apply-templates mode="XdocTags"/>
  </xsl:template>
  
  <xd:doc> Converts a xd:link element to a html link. Not implemented yet!</xd:doc>
  <xsl:template match="xd:link" mode="XdocTags">
    <a href="#">
      <xsl:value-of select="."/>
    </a>
  </xsl:template>
</xsl:stylesheet>
