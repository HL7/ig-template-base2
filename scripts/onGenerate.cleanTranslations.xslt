<?xml version="1.0" encoding="UTF-8"?>
<!--
  - Rebuilds a translations file (stringsBase.xml or stringsArtifacts.xml) keeping only translation elements and their
  - plain attributes and text.  The files live outside scripts/, so a child template can replace them; ant pastes the
  - output of this stylesheet into the IG, and this stops anything other than translations being pasted in.
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>
  <xsl:template match="/">
    <translations xmlns="http://hl7.org/fhir">
      <xsl:for-each select="//*[local-name(.)='translation']">
        <translation xmlns="http://hl7.org/fhir">
          <xsl:copy-of select="@*[namespace-uri(.)='']"/>
          <xsl:value-of select="."/>
        </translation>
      </xsl:for-each>
    </translations>
  </xsl:template>
</xsl:stylesheet>
