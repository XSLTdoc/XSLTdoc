<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xd="http://www.pnp-software.com/XSLTdoc" version="2.0">
  <xd:doc type="stylesheet"> This stylesheet lists the parameter
    <xd:author>ibirrer</xd:author>
    <xd:copyright>2004, P&amp;P Software GmbH</xd:copyright>
  </xd:doc>
  <xd:doc> Outputs title and surrounding html table elements for the list of
    the stylesheet parameters. </xd:doc>
  <xsl:template match="xsl:stylesheet" mode="parameterSummary">
    <xsl:if test="xsl:param">
      <p>&#160;</p>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td class="reticuleColor">
            <table width="100%" border="0" cellspacing="1" cellpadding="3">
              <tr>
                <th>
                  <h2>Parameter Summary</h2>
                </th>
              </tr>
              <xsl:apply-templates select="xsl:param" mode="parameterSummary">
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </table>
          </td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>
  <xd:doc> Outputs the rows or the table, the name attribute value and the
    short description. </xd:doc>
  <xsl:template match="xsl:param" mode="parameterSummary">
    <xsl:variable name="doc" select="preceding-sibling::*[1][self::xd:doc and not(@type)]"/>
    <tr>
      <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="3">
          <tr>
            <td width="15%" nowrap="">
              <xsl:if test="$doc/xd:param">
                <span class="parameterType">
                  <xsl:value-of select="$doc/xd:param/@type"/>&#160;</span>
              </xsl:if>
              <a href="#{generate-id(.)}">
                <xsl:value-of select="@name"/>
              </a>
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
