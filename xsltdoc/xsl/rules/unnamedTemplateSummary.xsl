<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="2.0" 
                xmlns:xd="http://www.pnp-software.com/XSLTdoc">
  <xd:doc type="stylesheet">
    <xd:short>This stylesheet lists the unnamed templates.</xd:short>
    <xd:author>ibirrer</xd:author>
    <xd:copyright>2004, P&amp;P Software GmbH</xd:copyright>
  </xd:doc>
  
  <xd:doc>
    Outputs title and surrounding html table elements for the list of the templates.
  </xd:doc>
  <xsl:template match="xsl:stylesheet" mode="unnamedTemplateSummary">
    <xsl:if test="xsl:template[@match]">
      <p>&#160;</p>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="reticuleColor">
            <table width="100%" border="0" cellspacing="1" cellpadding="3">
              <tr>
                <th>
                  <h2>Unnamed Template Summary</h2>
                </th>
              </tr>
              <xsl:apply-templates select="xsl:template[@match]" mode="unnamedTemplateSummary">
                <xsl:sort select="concat(@mode, @match)"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>
  
  <xd:doc> 
    Outputs the rows of the table, the match attribute value and the short description.
  </xd:doc>
  <xsl:template match="xsl:template[@match]" mode="unnamedTemplateSummary">
    <xsl:variable name="doc" select="preceding-sibling::*[1][self::xd:doc and not(@type)]"/>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="3">
          <tr>
            <td width="15%" nowrap="">
              <a href="#{generate-id(.)}">
                <xsl:value-of select="@match"/>
              </a>
              <xsl:call-template name="printTemplateDeclaration">
                <xsl:with-param name="doc" select="$doc"/>
                <xsl:with-param name="template" select="."/>
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
  </xsl:template>
</xsl:stylesheet>
