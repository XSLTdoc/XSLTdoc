<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:util="http://www.pnp-software.com/util"
                version="2.0"
                exclude-result-prefixes="xd xsl util">
  <xd:doc type="stylesheet"> 
    This stylesheet prints the details of a stylesheet parameter
    <xd:author>ibirrer</xd:author>
    <xd:copyright>2004, P&amp;P Software GmbH</xd:copyright>
  </xd:doc>
  <xd:doc>Outputs title for parameter details and applies templates for each
    named parameter</xd:doc>
  <xsl:template match="xsl:stylesheet" mode="parameterDetail">
    <xsl:param name="filename"/>
    <xsl:if test="xsl:param">
      <p>&#160;</p>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="reticuleColor">
            <table width="100%" border="0" cellspacing="1" cellpadding="3">
              <tr>
                <th>
                  <h2>Parameter Detail</h2>
                </th>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <xsl:apply-templates select="xsl:param" mode="parameterDetail">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  
  <xd:doc> Outputs the details of a stylesheet parameter.</xd:doc>
  <xsl:template match="xsl:param" mode="parameterDetail">
    <xsl:param name="filename"/>
    <xsl:variable name="doc" select="preceding-sibling::*[1][self::xd:doc and not(@type)]"/>
    <!-- HTML anchor -->
    
    <p class="detailDeclaration">
      <xsl:if test="$doc/xd:param">
        <span class="parameterType">
          <xsl:value-of select="$doc/xd:param/@type"/>&#160;</span>
      </xsl:if>
      <a name="{generate-id(.)}"><xsl:value-of select="@name"/></a>
      <xsl:if test="@select">
        <xsl:text>(</xsl:text>
        <span class="form">default:</span>
        <span class="detailAttribute">
          <xsl:value-of select="@select"/>
        </span>
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$doc">
          <xsl:text>&#160;(</xsl:text>
          <a class="filelink" href="{concat($filename, '.src.html')}#{generate-id($doc)}">source</a>
          <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#160;(</xsl:text>
          <a class="filelink" href="{concat($filename, '.src.html')}#{generate-id(.)}">source</a>
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
    </div>
    <br/>
    <hr size="1"/>
  </xsl:template>
</xsl:stylesheet>
