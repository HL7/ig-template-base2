<?xml version="1.0" encoding="UTF-8"?>
<!--
  - Integrate the 'default' groupings with any custom groupings, sorting ones that start with '-' to intermix with other 'standard' groupings
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:f="http://hl7.org/fhir" exclude-result-prefixes="f html">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="f:definition">
    <xsl:copy>
      <xsl:apply-templates select="@*|f:extension|f:modifierExtension"/>
      <xsl:call-template name="doGroupings"/>
      <xsl:apply-templates select="node()[not(self::f:extension or self::f:modifierExtension or self::f:grouping or self::f:groups)]"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="doGroupings">
    <xsl:apply-templates select="f:grouping[not(starts-with(@id, '-'))]"/>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-req'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-dyn'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-ka'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-str'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-term'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-map'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-test'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-clin'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-ex'"/>
    </xsl:call-template>
    <xsl:call-template name="doGrouping">
      <xsl:with-param name="prefix" select="'-other'"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="doGrouping">
    <xsl:param name="prefix"/>
    <xsl:for-each select="f:groups/f:grouping[starts-with(@id, $prefix)]">
      <xsl:copy>
        <xsl:choose>
          <xsl:when test="parent::f:groups/parent::*/f:grouping[@id=current()/@id]">
            <xsl:for-each select="parent::f:groups/parent::*/f:grouping[@id=current()/@id]">
              <xsl:apply-templates select="@*|node()"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="@*|node()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:for-each>
    <xsl:for-each select="f:grouping[starts-with(@id, $prefix)]">
      <xsl:if test="not(parent::*/f:groups/f:grouping[@id=current()/@id])">
        <xsl:copy>
          <xsl:apply-templates select="@*"/>
          <xsl:attribute name="name">
            <xsl:value-of select="translate(f:name/@value, ' ', '')"/>
          </xsl:attribute>
          <xsl:apply-templates select="node()"/>
        </xsl:copy>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:variable name="defaultLang">
    <xsl:call-template name="getParameter">
      <xsl:with-param name="name" select="'i18n-default-lang'"/>
    </xsl:call-template>
  </xsl:variable>
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
  <xsl:template match="f:artifactTranslations">
    <xsl:copy>
      <xsl:message>
        <xsl:value-of select="$defaultLang"/>
      </xsl:message>
      <translations xmlns="http://hl7.org/fhir">
        <xsl:for-each select="/f:ImplementationGuide/f:definition/f:groups/f:grouping">
          <xsl:variable name="id" select="@id"/>
          <xsl:variable name="name" select="@name"/>
          <grouping xmlns="http://hl7.org/fhir" id="{$id}">
            <xsl:for-each select="/f:ImplementationGuide/f:definition/f:artifactTranslations/f:translations/f:translation[@name=concat($name, 'Name') or @name=concat($name, 'Desc')]">
              <xsl:if test="position()=1">
                <xsl:attribute name="name">
                  <xsl:value-of select="substring(@name, 1, string-length(@name)-4)"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:element name="{substring(@name, string-length(@name)-3,4)}">
                <xsl:copy-of select="@*[not(local-name(.)='name')]"/>
              </xsl:element>
            </xsl:for-each>
            <xsl:apply-templates mode="alternate" select="/f:ImplementationGuide/f:definition/f:grouping[@id=$id]"/>
          </grouping>
        </xsl:for-each>
        <xsl:for-each select="/f:ImplementationGuide/f:definition/f:grouping[not(@id=/f:ImplementationGuide/f:definition/f:groups/f:grouping/@id)]">
          <grouping xmlns="http://hl7.org/fhir" id="{@id}">
            <xsl:attribute name="name">
              <xsl:value-of select="translate(f:name/@value, ' ', '')"/>
            </xsl:attribute>
            <xsl:apply-templates mode="alternate" select="."/>
          </grouping>
        </xsl:for-each>
      </translations>
    </xsl:copy>
	</xsl:template>
  <xsl:template mode="alternate" match="f:grouping">
    <override xmlns="http://hl7.org/fhir">
      <xsl:for-each select="f:name">
        <Name xmlns="http://hl7.org/fhir">
          <xsl:attribute name="{$defaultLang}">
            <xsl:value-of select="@value"/>
          </xsl:attribute>
          <xsl:for-each select="f:extension[@url='http://hl7.org/fhir/StructureDefinition/translation']">
            <xsl:attribute name="{f:extension[@url='lang']/f:valueCode/@value}">
              <xsl:value-of select="f:extension[@url='content']/f:valueString/@value"/>
            </xsl:attribute>
          </xsl:for-each>
        </Name>
      </xsl:for-each>
      <xsl:for-each select="f:description">
        <Desc xmlns="http://hl7.org/fhir">
          <xsl:attribute name="{$defaultLang}">
            <xsl:value-of select="@value"/>
          </xsl:attribute>
          <xsl:for-each select="f:extension[@url='http://hl7.org/fhir/StructureDefinition/translation']">
            <xsl:attribute name="{f:extension[@url='lang']/f:valueCode/@value}">
              <xsl:value-of select="f:extension[@url='content']/f:valueString/@value"/>
            </xsl:attribute>
          </xsl:for-each>
        </Desc>
      </xsl:for-each>
    </override>
  </xsl:template>
</xsl:stylesheet>