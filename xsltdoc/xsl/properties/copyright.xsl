<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">
  <xd:doc type="stylesheet">
    Stylesheet for xd:copyright property.
  </xd:doc>
               
  <xd:doc>Prints the xd:copyright property.</xd:doc>
  <xsl:template match="xd:copyright" mode="printProperty"> 
    <div class="property">
      <div class="propertyCaption">Copyright:</div>
      <div class="propertyContent"><xsl:value-of select="."/></div>
    </div>
  </xsl:template>
</xsl:stylesheet>