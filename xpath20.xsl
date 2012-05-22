<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="xmlspec.xsl"/>

  <xsl:template match="br">
    <br xmlns="http://www.w3.org/1999/xhtml" />
  </xsl:template>

  <xsl:template match="errorref">
    <xsl:variable name="spec" select="//error[@code=current()/@code]/@spec"/>
    <xsl:text>[</xsl:text>
    <a xmlns="http://www.w3.org/1999/xhtml"
       title="{concat('err:', $spec, @class, @code)}"
       href="{concat('#ERR', $spec, @class, @code)}">
      <xsl:value-of select="concat('err:', $spec, @class, @code)"/>
    </a>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="error-list">
    <dl xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </dl>
  </xsl:template>

  <xsl:template match="error">
    <dt xmlns="http://www.w3.org/1999/xhtml">
      <a xmlns="http://www.w3.org/1999/xhtml"
	 name="{concat('ERR', @spec, @class, @code)}"
	 id="{concat('ERR', @spec, @class, @code)}"/>
      <xsl:value-of select="concat('err:', @spec, @class, @code)"/>
    </dt>
    <dd xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <xsl:template match="xspecref">
    <xsl:variable name="context" select="."/>

    <a xmlns="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="href">
	<xsl:choose>
	  <xsl:when test="@spec='FS'">
	    <xsl:value-of select="concat('http://www.w3.org/TR/xquery-semantics/#', @ref)" />
	  </xsl:when>
	  <xsl:when test="@spec='DM'">
	    <xsl:value-of select="concat('http://www.w3.org/TR/xpath-datamodel/#', @ref)" />
	  </xsl:when>
	  <xsl:when test="@spec='FO'">
	    <xsl:value-of select="concat('http://www.w3.org/TR/xpath-functions/#', @ref)" />
	  </xsl:when>
	  <xsl:when test="@spec='XP'">
	    <xsl:value-of select="concat('http://www.w3.org/TR/xpath20/#', @ref)" />
	  </xsl:when>
	  <xsl:when test="@spec='XQ'">
	    <xsl:value-of select="concat('http://www.w3.org/TR/xquery/#', @ref)" />
	  </xsl:when>
	</xsl:choose>
      </xsl:attribute>
      <xsl:choose>
	<xsl:when test="@spec='FS'">
	  <xsl:apply-templates select="document('xquery-semantics.xml')//*[@id=$context/@ref]" mode="divnum" />
	  <xsl:apply-templates select="document('xquery-semantics.xml')//*[@id=$context/@ref]/head" mode="text" />
	</xsl:when>
	<xsl:when test="@spec='DM'">
	  <xsl:apply-templates select="document('data-model.xml')//*[@id=$context/@ref]" mode="divnum" />
	  <xsl:apply-templates select="document('data-model.xml')//*[@id=$context/@ref]/head" mode="text" />
	</xsl:when>
	<xsl:when test="@spec='FO'">
	  <xsl:apply-templates select="document('xpath-functions.xml')//*[@id=$context/@ref]" mode="divnum" />
	  <xsl:apply-templates select="document('xpath-functions.xml')//*[@id=$context/@ref]/head" mode="text" />
	</xsl:when>
	<xsl:when test="@spec='XP'">
	  <xsl:apply-templates select="document('xpath20.xml')//*[@id=$context/@ref]" mode="divnum" />
	  <xsl:apply-templates select="document('xpath20.xml')//*[@id=$context/@ref]/head" mode="text" />
	</xsl:when>
	<xsl:when test="@spec='XQ'">
	  <xsl:apply-templates select="document('xquery.xml')//*[@id=$context/@ref]" mode="divnum" />
	  <xsl:apply-templates select="document('xquery.xml')//*[@id=$context/@ref]/head" mode="text" />
	</xsl:when>
      </xsl:choose>
    </a>
    <sup><small><xsl:value-of select="@spec"/></small></sup>
  </xsl:template>

  <!-- notices for translations -->
  <xsl:template match="processing-instruction('translation-notice')">
    <p xmlns="http://www.w3.org/1999/xhtml">
      <xsl:text>訳注: この文書は</xsl:text>
      <xsl:element name="a" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:attribute name="href">
	  <xsl:value-of select="/spec/header/publoc/loc"/>
	</xsl:attribute>
	<xsl:value-of select="/spec/header/publoc/loc"/>
      </xsl:element>
      <xsl:text>を国島丈生(</xsl:text><a xmlns="http://www.w3.org/1999/xhtml" href="mailto:kunishi@acm.org">kunishi@acm.org</a><xsl:text>)が訳したものです。この日本語訳はあくまで参考であり、また翻訳には誤りが含まれる可能性があります。ご利用は自己責任でお願いします。一部に翻訳未完成の部分が含まれている場合があります。</xsl:text>
    </p>
  </xsl:template>

  <!-- glossary -->
  <xsl:template match="processing-instruction('glossary')">
    <dl xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="//termdef" mode="glossary">
	<xsl:sort select="@term" order="ascending"/>
      </xsl:apply-templates>
    </dl>
  </xsl:template>

  <xsl:template match="termdef" mode="glossary">
    <dt xmlns="http://www.w3.org/1999/xhtml">
      <a xmlns="http://www.w3.org/1999/xhtml">
	<xsl:attribute name="name">
	  <xsl:value-of select="concat('GL', @id)"/>
	</xsl:attribute>
	<xsl:attribute name="id">
	  <xsl:value-of select="concat('GL', @id)"/>
	</xsl:attribute>
      </a>
      <xsl:value-of select="@term"/>
    </dt>
    <dd xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

</xsl:stylesheet>
