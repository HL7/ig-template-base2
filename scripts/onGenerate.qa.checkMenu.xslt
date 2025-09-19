<?xml version="1.0" encoding="UTF-8"?>
<!--
  - Checks content on the change log page
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://www.w3.org/1999/xhtml" exclude-result-prefixes="h">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:include href="handleIssues.xslt"/>
  <xsl:template match="/">
    <xsl:if test="//h:a[@data-toggle='dropdown' and @href='#']">
      <xsl:call-template name="raiseIssue">
        <xsl:with-param name="severity">error</xsl:with-param>
        <xsl:with-param name="code">business-rule</xsl:with-param>
        <xsl:with-param name="details">In your menu.xml file, it's no longer allowed to have href='#' on dropdown items.  Change them to be href='menu.html' instead.  (It won't link, but it needs to be something valid.)</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
