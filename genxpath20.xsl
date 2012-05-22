<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

  <xsl:template match="langname" priority="1.5">
    <xsl:text>XPath</xsl:text>
  </xsl:template>

  <xsl:template match="title/phrase | version/phrase | w3c-designation/phrase" priority="1.5">
    <xsl:if test="@role='xpath'">
      <xsl:apply-templates select="text()"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="node()[@role and @role='xquery']"/>

  <xsl:template match="prod" priority="1.5">
    <xsl:if test="contains(@id, 'doc-xpath') or contains(@id, 'prod-xpath')">
      <xsl:copy>
	<xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  <xsl:template match="nt" priority="1.5">
    <xsl:if test="contains(@def, 'doc-xpath') or contains(@def, 'prod-xpath')">
      <xsl:copy>
	<xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*|node()[not(@role)]|node()[not(@role='xquery')]">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
    
</xsl:stylesheet>
