<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xd="http://www.pnp-software.com/XSLTdoc" 
  xmlns:util="http://www.pnp-software.com/util" version="2.0">
  <xd:doc type="stylesheet"> 
  This stylesheet prints the details of a named stylesheet
    <xd:author>ibirrer</xd:author>
    <xd:copyright>2004, P&amp;P Software GmbH</xd:copyright>
  </xd:doc>
  <xsl:template match="xsl:stylesheet" mode="stylesheetDetail">
    <xsl:variable name="doc" select="xd:doc[@type='stylesheet']"/>
    <!-- ************* Title ********************** -->
    <h1 align="center">
      <xsl:value-of select="util:getFile(base-uri(.))"/></h1>
    <!-- ************* Includes ******************* -->
    <xsl:if test="xsl:include">
      <h3>Include</h3>
      <ul>
        <xsl:for-each select="xsl:include">
          <li>
            <a href="{@href}.xd.html" class="filelink">
              <xsl:value-of select="@href"/>
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
    <!-- ************* Imorts ********************* -->
    <xsl:if test="xsl:import">
      <h3>Import</h3>
      <ul>
        <xsl:for-each select="xsl:import">
          <li>
            <a href="{@href}.xd.html" class="filelink">
              <xsl:value-of select="@href"/>
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
    <xsl:call-template name="printShortDescription">
      <xsl:with-param name="doc" select="$doc"/>
    </xsl:call-template>
    <p/>
    <xsl:call-template name="printDetailDescription">
      <xsl:with-param name="doc" select="$doc"/>
    </xsl:call-template>
    <br/><br/>
    <!-- *************** Author & Copyright ****************** -->
    <xsl:if test="$doc/xd:author or $doc/xd:copyright or $doc/xd:cvsId">
      <table border="0" cellpadding="3" cellspacing="0">
        <xsl:if test="$doc/xd:author">
          <tr>
            <td class="form">Author:</td>
            <td>&#160;</td>
            <td>
              <xsl:value-of select="$doc/xd:author/text()"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="$doc/xd:copyright">
          <tr>
            <td class="form"> Copyright: </td>
            <td>&#160;</td>
            <td>
              <xsl:value-of select="$doc/xd:copyright/text()"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="$doc/xd:cvsId">
          <tr>
            <td class="form"> CVS: </td>
            <td>&#160;</td>
            <td>
              <xsl:value-of select="substring($doc/xd:cvsId/text(), 5, string-length($doc/xd:cvsId/text()) - 5 )"/>
            </td>
          </tr>
        </xsl:if>
      </table>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
