<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:util="http://www.pnp-software.com/util"
                version="2.0">
	<xsl:output method="text"/>
  <xsl:include href='../xsl/lib/util.xsl'/>
  <xsl:param name='quiet' select='false()'/>
  <xsl:param name='halt-on-error' select='true()'/>

  <xsl:template match="/">
    <xsl:value-of select='util:log(concat("Running tests on ", current-dateTime()), false())'/>
    <xsl:copy-of select="util:testGetSharedPath()"/>
    <xsl:copy-of select="util:testGetRelativeUri()"/>
    <xsl:copy-of select="util:testNormalizeUri()"/>
  </xsl:template>

  <xd:doc type="stylesheet">
    This function logs a message both to the console, using &lt;xsl:message>,
    and to the result document. If the `quiet` parameter is set to true, this
    won't log non-terminal messages to the console.
    <xd:param name='message'>The message to log.</xd:param>
    <xd:param name='terminate' type='boolean'>If true, causes the process to exit.</xd:param>
  </xd:doc>
  <xsl:function name='util:log'>
    <xsl:param name='message'/>
    <xsl:param name='terminate'/>
    <!-- write it to the result document, with a newline -->
    <xsl:value-of select='concat($message, "&#xA;")'/>
    <!-- 
      And to the console, without the newline. Unfortunately, the
      `terminate` attribute can't be parameterized, so we have to use a
      `choose` here. 
    -->
    <xsl:choose>
      <xsl:when test="$terminate">
        <xsl:message terminate='yes'>
          <xsl:value-of select="$message"/>
        </xsl:message>
      </xsl:when>
      <xsl:when test='not($quiet)'>
        <xsl:message terminate='no'>
          <xsl:value-of select="$message"/>
        </xsl:message>
      </xsl:when>
    </xsl:choose>
  </xsl:function>
  
  <xd:doc type='stylesheet'>
    Assert that two things are equal.
  </xd:doc>
  <xsl:function name='util:assert-equal'>
    <xsl:param name='test-name'/>
    <xsl:param name='subtest-num'/>
    <xsl:param name='expected'/>
    <xsl:param name='received'/>
    
    <xsl:variable name='passed' select='$expected = $received'/>
    <xsl:variable name="message" select='concat(
      "[", if ($passed) then "PASSED" else "FAILED", "] ",
      $test-name, " [", $subtest-num, "]",
      if ($passed) then "" else concat(
        "expected: ", $expected, "; ",
        "received: ", $received
      )
    )'/>
    <xsl:value-of select="util:log($message, not($passed))"/>
  </xsl:function>
  
  <xsl:function name='util:log-test-name'>
    <xsl:param name='name'/>
    <xsl:value-of select='util:log(concat("Running test ", $name), false())'/>
  </xsl:function>

  <xd:doc>
    Test the util:getSharedPath() function.
  </xd:doc>
  <xsl:function name="util:testGetSharedPath">
    <xsl:variable name='test-name' select='"util:testGetSharedPath"'/>
    <xsl:value-of select='util:log-test-name($test-name)'/>

    <xsl:value-of select='util:assert-equal($test-name, 1, "D:/", 
      util:getSharedPath("D:/test", "D:/testCenter"))'/>
    <xsl:value-of select='util:assert-equal($test-name, 2, "D:/", 
      util:getSharedPath("D:/testCenter", "D:/test"))'/>
    <xsl:value-of select='util:assert-equal($test-name, 3, "D:/test/", 
      util:getSharedPath("D:/test/dir2", "D:/test/dir1/dir2"))'/>
    <xsl:value-of select='util:assert-equal($test-name, 4, "D:/test/dir2/", 
      util:getSharedPath("D:/test/dir2", "D:/test/dir2"))'/>
  </xsl:function>
  
  <xd:doc>
    Test the util:getRelativeUri() function.
  </xd:doc>
  <xsl:function name="util:testGetRelativeUri">
    <xsl:variable name='test-name' select='"util:testGetRelativeUri"'/>
    <xsl:value-of select='util:log-test-name($test-name)'/>

    <xsl:value-of select='util:assert-equal($test-name, 1, "./", 
      util:getRelativeUri("file://D:/test", "file://D:/test"))'/>
    <xsl:value-of select='util:assert-equal($test-name, 2, "./", 
      util:getRelativeUri("file:///a/b/", "file:///a/b/./"))'/>
    <xsl:value-of select='util:assert-equal($test-name, 3, "./", 
      util:getRelativeUri("file:///a/b/./", "file:///a/b/"))'/>
  </xsl:function>

  <xd:doc>
    Test that util:normalizeUri() works as advertised.
  </xd:doc>
  <xsl:function name='util:testNormalizeUri'>
    <xsl:variable name='test-name' select='"util:testNormalizeUri"'/>
    <xsl:value-of select='util:log-test-name($test-name)'/>

    <xsl:value-of select='util:assert-equal($test-name, 1, "file:/a/b/c", 
      util:normalizeUri("file:///a/b/./c"))'/>    
    <xsl:value-of select='util:assert-equal($test-name, 1, "file:/a/b/d", 
      util:normalizeUri("file:///a/b/././././d"))'/>   
  </xsl:function>
</xsl:stylesheet>
