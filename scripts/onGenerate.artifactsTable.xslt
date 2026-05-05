<?xml version="1.0" encoding="UTF-8"?>
<!--
  - Produces _data/artifactsTable.json: a flat array of artifact rows with all
  - per-row translations baked in. Consumed by includes/artifacts2.xml.
  - Each row: { groupingPos, groupingId, groupingName, type, url, ref,
  -            name: { src, <lang>... }, description: { src, <lang>... } }
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="http://hl7.org/fhir" exclude-result-prefixes="f">
  <xsl:output method="text" encoding="UTF-8"/>
  <xsl:key name="groupingById" match="f:definition/f:grouping" use="@id"/>

  <xsl:template match="/f:ImplementationGuide">
    <xsl:text>[</xsl:text>
    <xsl:for-each select="f:definition/f:resource[
        f:extension[@url='http://hl7.org/fhir/StructureDefinition/implementationguide-page']
      ][
        key('groupingById', (f:groupingId/@value | f:package/@value)[1])
      ][
        not(f:extension[@url='http://hl7.org/fhir/StructureDefinition/tools-alternateVersion'])
      ]">
      <xsl:if test="position()!=1">,</xsl:if>
      <xsl:variable name="gid" select="(f:groupingId/@value | f:package/@value)[1]"/>
      <xsl:variable name="grouping" select="key('groupingById', $gid)"/>
      <xsl:text>{"groupingPos":</xsl:text>
      <xsl:value-of select="count($grouping/preceding-sibling::f:grouping) + 1"/>
      <xsl:text>,"groupingId":"</xsl:text>
      <xsl:call-template name="js-escape"><xsl:with-param name="s" select="$gid"/></xsl:call-template>
      <xsl:text>","groupingName":"</xsl:text>
      <xsl:call-template name="js-escape"><xsl:with-param name="s" select="$grouping/@name"/></xsl:call-template>
      <xsl:text>","groupingDescription":{"src":"</xsl:text>
      <xsl:call-template name="js-escape"><xsl:with-param name="s" select="$grouping/f:description/@value"/></xsl:call-template>
      <xsl:text>"</xsl:text>
      <xsl:for-each select="$grouping/f:description/f:extension[@url='http://hl7.org/fhir/StructureDefinition/translation']">
        <xsl:text>,"</xsl:text>
        <xsl:value-of select="f:extension[@url='lang']/f:valueCode/@value"/>
        <xsl:text>":"</xsl:text>
        <xsl:call-template name="js-escape"><xsl:with-param name="s" select="f:extension[@url='content']/f:valueString/@value"/></xsl:call-template>
        <xsl:text>"</xsl:text>
      </xsl:for-each>
      <xsl:text>},"type":"</xsl:text>
      <xsl:value-of select="substring-before(f:reference/f:reference/@value, '/')"/>
      <xsl:text>","url":"</xsl:text>
      <xsl:call-template name="js-escape"><xsl:with-param name="s" select="f:extension[@url='http://hl7.org/fhir/StructureDefinition/implementationguide-page']/f:valueUri/@value"/></xsl:call-template>
      <xsl:text>","ref":"</xsl:text>
      <xsl:call-template name="js-escape"><xsl:with-param name="s" select="f:reference/f:reference/@value"/></xsl:call-template>
      <xsl:text>","name":{"src":"</xsl:text>
      <xsl:call-template name="js-escape"><xsl:with-param name="s" select="f:name/@value"/></xsl:call-template>
      <xsl:text>"</xsl:text>
      <xsl:for-each select="f:name/f:extension[@url='http://hl7.org/fhir/StructureDefinition/translation']">
        <xsl:text>,"</xsl:text>
        <xsl:value-of select="f:extension[@url='lang']/f:valueCode/@value"/>
        <xsl:text>":"</xsl:text>
        <xsl:call-template name="js-escape"><xsl:with-param name="s" select="f:extension[@url='content']/f:valueString/@value"/></xsl:call-template>
        <xsl:text>"</xsl:text>
      </xsl:for-each>
      <xsl:text>},"description":{"src":"</xsl:text>
      <xsl:call-template name="js-escape"><xsl:with-param name="s" select="f:description/@value"/></xsl:call-template>
      <xsl:text>"</xsl:text>
      <xsl:for-each select="f:description/f:extension[@url='http://hl7.org/fhir/StructureDefinition/translation']">
        <xsl:text>,"</xsl:text>
        <xsl:value-of select="f:extension[@url='lang']/f:valueCode/@value"/>
        <xsl:text>":"</xsl:text>
        <xsl:call-template name="js-escape"><xsl:with-param name="s" select="f:extension[@url='content']/f:valueString/@value"/></xsl:call-template>
        <xsl:text>"</xsl:text>
      </xsl:for-each>
      <xsl:text>}}</xsl:text>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template name="js-escape">
    <xsl:param name="s"/>
    <xsl:variable name="s1"><xsl:call-template name="replace-all"><xsl:with-param name="text" select="$s"/><xsl:with-param name="from" select="'\'"/><xsl:with-param name="to" select="'\\'"/></xsl:call-template></xsl:variable>
    <xsl:variable name="s2"><xsl:call-template name="replace-all"><xsl:with-param name="text" select="$s1"/><xsl:with-param name="from" select="'&quot;'"/><xsl:with-param name="to" select="'\&quot;'"/></xsl:call-template></xsl:variable>
    <xsl:variable name="s3"><xsl:call-template name="replace-all"><xsl:with-param name="text" select="$s2"/><xsl:with-param name="from" select="'&#xD;&#xA;'"/><xsl:with-param name="to" select="'\n'"/></xsl:call-template></xsl:variable>
    <xsl:variable name="s4"><xsl:call-template name="replace-all"><xsl:with-param name="text" select="$s3"/><xsl:with-param name="from" select="'&#xA;'"/><xsl:with-param name="to" select="'\n'"/></xsl:call-template></xsl:variable>
    <xsl:variable name="s5"><xsl:call-template name="replace-all"><xsl:with-param name="text" select="$s4"/><xsl:with-param name="from" select="'&#xD;'"/><xsl:with-param name="to" select="'\r'"/></xsl:call-template></xsl:variable>
    <xsl:variable name="s6"><xsl:call-template name="replace-all"><xsl:with-param name="text" select="$s5"/><xsl:with-param name="from" select="'&#x9;'"/><xsl:with-param name="to" select="'\t'"/></xsl:call-template></xsl:variable>
    <xsl:value-of select="$s6"/>
  </xsl:template>

  <xsl:template name="replace-all">
    <xsl:param name="text"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>
    <xsl:choose>
      <xsl:when test="contains($text, $from)">
        <xsl:value-of select="substring-before($text, $from)"/>
        <xsl:value-of select="$to"/>
        <xsl:call-template name="replace-all">
          <xsl:with-param name="text" select="substring-after($text, $from)"/>
          <xsl:with-param name="from" select="$from"/>
          <xsl:with-param name="to" select="$to"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
