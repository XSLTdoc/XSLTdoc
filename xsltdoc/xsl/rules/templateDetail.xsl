<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:util="http://www.pnp-software.com/util"
                version="2.0"
                exclude-result-prefixes="xd xsl util">
  <xd:doc type="stylesheet"> 
  This stylesheet prints the details of a named or unnamed template and a function
    <xd:author>ibirrer</xd:author>
    <xd:copyright>2004, P&amp;P Software GmbH</xd:copyright>
  </xd:doc>
  <xd:doc>Outputs title for named details and applies templates for each named template</xd:doc>
  <xsl:template match="xsl:stylesheet" mode="namedTemplateDetail">
    <xsl:param name="filename"/>
    <xsl:if test="xsl:template[@name]">
      <p>&#160;</p>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="reticuleColor">
            <table width="100%" border="0" cellspacing="1" cellpadding="3">
              <tr>
                <th>
                  <h2>Named Template Detail</h2>
                </th>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <xsl:apply-templates select="xsl:template[@name]" mode="templateDetail">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  <xd:doc>Outputs title for function and applies templates for each function</xd:doc>
  <xsl:template match="xsl:stylesheet" mode="functionDetail">
    <xsl:param name="filename"/>
    <xsl:if test="xsl:function">
      <p>&#160;</p>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="reticuleColor">
            <table width="100%" border="0" cellspacing="1" cellpadding="3">
              <tr>
                <th>
                  <h2>Function Detail</h2>
                </th>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <xsl:apply-templates select="xsl:function" mode="templateDetail">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>Outputs title for unnamed details and applies templates for each
    unnamed template</xd:doc>
  <xsl:template match="xsl:stylesheet" mode="unnamedTemplateDetail">
    <xsl:param name="filename"/>
    <xsl:if test="xsl:template[@match]">
      <p>&#160;</p>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="reticuleColor">
            <table width="100%" border="0" cellspacing="1" cellpadding="3">
              <tr>
                <th>
                  <h2>Unnamed Template Detail</h2>
                </th>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <xsl:apply-templates select="xsl:template[@match]" mode="templateDetail">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:sort select="concat(@mode, @match)"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  <xd:doc> Outputs the rows of the table, the name attribute value and the
    short description. </xd:doc>
  <xsl:template match="xsl:template | xsl:function" mode="templateDetail">
    <xsl:param name="filename"/>
    <xsl:variable name="doc" select="preceding-sibling::*[1][self::xd:doc and not(@type)]"/>
    <!-- HTML anchor -->
    <a name="{generate-id(.)}"/>
    <p class="detailDeclaration">
      <xsl:value-of select="@name"/>
      <xsl:value-of select="@match"/>
      <xsl:choose>
        <xsl:when test="self::xsl:template">
          <xsl:call-template name="printTemplateDeclaration">
            <xsl:with-param name="doc" select="$doc"/>
            <xsl:with-param name="template" select="."/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="printFunctionDeclaration">
            <xsl:with-param name="doc" select="$doc"/>
            <xsl:with-param name="function" select="."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:variable name="filenameWithoutPath" select="util:getFile($filename)"/>
      <xsl:choose>
        <xsl:when test="$doc">
          <xsl:text>&#160;(</xsl:text>
          <a class="filelink" href="{concat($filenameWithoutPath, '.src.html')}#{generate-id($doc)}">source</a>
          <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#160;(</xsl:text>
          <a class="filelink" href="{concat($filenameWithoutPath, '.src.html')}#{generate-id(.)}">source</a>
          <xsl:text>)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </p>
    <div class="detailBlock">
      <xsl:variable name="shortDescription">
        <xsl:call-template name="printShortDescription">
          <xsl:with-param name="doc" select="$doc"/>
        </xsl:call-template>
      </xsl:variable>
      <!-- *********** description ************** -->
      <xsl:copy-of select="$shortDescription"/>
      <xsl:if test="not(contains($shortDescription,'.'))">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:call-template name="printDetailDescription">
        <xsl:with-param name="doc" select="$doc"/>
      </xsl:call-template>
      <!-- ************** priority ******************** -->
      <xsl:if test="@priority">
        <p>
          <span class="form">priority:</span>
          <xsl:text/>
          <span class="detailAttribute">
            <xsl:value-of select="@priority"/>
          </span>
        </p>
      </xsl:if>
      <!-- ************** parameters ****************** -->
      <xsl:if test="xsl:param">
        <p>
          <span class="form">parameters:</span>
        </p>
      </xsl:if>
      <xsl:for-each select="xsl:param">
        <p class="parameter">
          <xsl:if test="parent::xsl:function">
            <span class="parameterType">
              <xsl:value-of select="concat(@as, ' ')"/>
            </span>
          </xsl:if>
          <xsl:if test="$doc/xd:param[@name=current()/@name]/@type">
            <span class="parameterType">
              <xsl:value-of select="concat($doc/xd:param[@name=current()/@name]/@type, ' ')"/>
            </span>
          </xsl:if>
          <span class="parameterName">
            <xsl:value-of select="concat(@name,' ')"/>
          </span>
          <xsl:if test="@select">
            <xsl:text>(</xsl:text>
            <span class="form">default:</span>
            <span class="detailAttribute">
              <xsl:value-of select="@select"/>
            </span>
            <xsl:text>)</xsl:text>
          </xsl:if>
          <xsl:if test="$doc/xd:param[@name=current()/@name]">
            <xsl:text> - </xsl:text>
            <xsl:apply-templates select="$doc/xd:param[@name=current()/@name]" mode="XdocTags"/>
          </xsl:if>
        </p>
      </xsl:for-each>
    </div>
    <br/>
    <hr size="1"/>
  </xsl:template>
</xsl:stylesheet>
