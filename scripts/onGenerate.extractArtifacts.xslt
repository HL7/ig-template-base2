<?xml version="1.0" encoding="UTF-8"?>
<!--
  - Produce the stringsArtifacts JSON file, merging the default stringsArtifacts with any additional or overridden values from the ImplementationGuide
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:f="http://hl7.org/fhir" exclude-result-prefixes="f html">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
  <xsl:variable name="defaultLang">
    <xsl:call-template name="getParameter">
      <xsl:with-param name="name" select="'i18n-default-lang'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:template match="/">
    <xsl:text>{</xsl:text>
    <xsl:call-template name="showLang">
      <xsl:with-param name="lang" select="$defaultLang"/>
    </xsl:call-template>
    <xsl:for-each select="/f:ImplementationGuide/f:definition/f:parameter[f:code/@value='i18n-lang']/f:value/@value">
      <xsl:text>,</xsl:text>
      <xsl:call-template name="showLang">
        <xsl:with-param name="lang" select="."/>
      </xsl:call-template>
    </xsl:for-each>
    
<!--    <xsl:for-each select="/f:ImplementationGuide/f:definition/f:extension[@url='http://hl7.org/fhir/tools/StructureDefinition/ig-parameter'][f:extension[@url='code']/f:valueString/@value='i18n-lang']/f:extension[@url='value']/f:valueString/@value">
      <xsl:text>,</xsl:text>
      <xsl:call-template name="showLang">
        <xsl:with-param name="lang" select="."/>
      </xsl:call-template>
    </xsl:for-each>-->
    <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template name="showLang">
    <xsl:param name="lang"/>
    <xsl:text>"</xsl:text><xsl:value-of select="$lang"/><xsl:text>":{</xsl:text>
    <xsl:for-each select="/f:ImplementationGuide/f:definition/f:artifactTranslations/f:translations/f:grouping">
      <xsl:if test="position()!=1">,</xsl:if>
      <xsl:text>"</xsl:text><xsl:value-of select="@name"/><xsl:text>Name":"</xsl:text>
      <xsl:call-template name="getNameValue">
        <xsl:with-param name="lang" select="$lang"/>
        <xsl:with-param name="name" select="'Name'"/>
      </xsl:call-template>
      <xsl:text>",</xsl:text>
      <xsl:text>"</xsl:text><xsl:value-of select="@name"/><xsl:text>Desc":"</xsl:text>
      <xsl:call-template name="getNameValue">
        <xsl:with-param name="lang" select="$lang"/>
        <xsl:with-param name="name" select="'Desc'"/>
      </xsl:call-template>
      <xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template name="getNameValue">
    <xsl:param name="lang"/>
    <xsl:param name="name"/>
    <xsl:variable name="value">
      <xsl:choose>
        <xsl:when test="f:override/f:*[local-name(.)=$name]/@*[local-name(.)=$lang]">
          <xsl:value-of select="f:override/f:*[local-name(.)=$name]/@*[local-name(.)=$lang]"/>
        </xsl:when>
        <xsl:when test="f:*[local-name(.)=$name]/@*[local-name(.)=$lang]">
          <xsl:value-of select="f:*[local-name(.)=$name]/@*[local-name(.)=$lang]"/>
        </xsl:when>
        <xsl:when test="f:override/f:*[local-name(.)=$name]/@*[local-name(.)=$defaultLang]">
          <xsl:value-of select="f:override/f:*[local-name(.)=$name]/@*[local-name(.)=$defaultLang]"/>
        </xsl:when>
        <xsl:when test="f:*[local-name(.)=$name]/@*[local-name(.)=$defaultLang]">
          <xsl:value-of select="f:*[local-name(.)=$name]/@*[local-name(.)=$defaultLang]"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="escapeJsonString">
      <xsl:with-param name="string" select="$value"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="escapeJsonString">
    <xsl:param name="string"/>
    <xsl:choose>
      <xsl:when test="contains($string, '&quot;')">
        <xsl:value-of select="substring-before($string, '&quot;')"/>
        <xsl:text>\"</xsl:text>
        <xsl:call-template name="escapeJsonString">
          <xsl:with-param name="string" select="substring-after($string, '&quot;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="getParameter">
    <xsl:param name="name"/>
    <xsl:choose>
      <xsl:when test="/f:ImplementationGuide/f:definition/f:parameter[f:code/@value=$name]">
        <xsl:value-of select="/f:ImplementationGuide/f:definition/f:parameter[f:code/@value=$name]/f:value/@value"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/f:ImplementationGuide/f:definition/f:extension[@url='http://hl7.org/fhir/tools/StructureDefinition/ig-parameter'][f:extension[@url='code']/f:valueString/@value=$name]/f:extension[@url='value']/f:valueString/@value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>