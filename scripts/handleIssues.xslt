<?xml version="1.0" encoding="UTF-8"?>
<!--
  - A helper-transform that supports reporting issues.
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="http://hl7.org/fhir" xmlns="http://hl7.org/fhir" exclude-result-prefixes="f">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:template name="raiseError">
    <xsl:param name="code"/>
    <xsl:param name="details"/>
    <xsl:param name="location"/>
    <xsl:call-template name="raiseIssue">
      <xsl:with-param name="severity">error</xsl:with-param>
      <xsl:with-param name="code" select="$code"/>
      <xsl:with-param name="details" select="$details"/>
      <xsl:with-param name="location" select="$location"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="raiseWarning">
    <xsl:param name="code"/>
    <xsl:param name="details"/>
    <xsl:param name="location"/>
    <xsl:call-template name="raiseIssue">
      <xsl:with-param name="severity">warning</xsl:with-param>
      <xsl:with-param name="code" select="$code"/>
      <xsl:with-param name="details" select="$details"/>
      <xsl:with-param name="location" select="$location"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="raiseIssue">
    <xsl:param name="severity"/>
    <xsl:param name="code"/>
    <xsl:param name="details"/>
    <xsl:param name="location"/>
    <xsl:variable name="escapedDetails1">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="$details"/>
        <xsl:with-param name="search" select="'\'"/>
        <xsl:with-param name="new" select="'\\'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="escapedDetails2">
      <xsl:call-template name="replace">
        <xsl:with-param name="string" select="$escapedDetails1"/>
        <xsl:with-param name="search" select="'&quot;'"/>
        <xsl:with-param name="new" select="'\&quot;'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>&#xa;{"severity":"</xsl:text>
    <xsl:value-of select="$severity"/>
    <xsl:text>","code":"</xsl:text>
    <xsl:value-of select="$code"/>
    <xsl:text>","details":{"text":"</xsl:text>
    <xsl:value-of select="$escapedDetails2"/>
    <xsl:text>"},"location":["</xsl:text>
    <xsl:value-of select="$location"/>
    <xsl:text>"]}&#xa;,</xsl:text>
  </xsl:template>
  <xsl:template name="replace">
    <xsl:param name="string"/>
    <xsl:param name="search"/>
    <xsl:param name="new"/>
    <xsl:choose>
      <xsl:when test="contains($string, $search)">
        <xsl:variable name="remainder">
          <xsl:call-template name="replace">
            <xsl:with-param name="string" select="substring-after($string, $search)"/>
            <xsl:with-param name="search" select="$search"/>
            <xsl:with-param name="new" select="$new"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat(substring-before($string, $search), $new, $remainder)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>  