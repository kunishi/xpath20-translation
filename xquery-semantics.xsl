<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml">
  <xsl:import href="xpath20.xsl"/>

  <xsl:template match="smnotation">
    <p><b>Notation</b></p>

    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="display">
    <div align="center"><xsl:apply-templates/></div>
  </xsl:template>

  <xsl:template match="environment">
    <xsl:apply-templates/><b><xsl:text disable-output-escaping="yes">&amp;#160;|-&amp;#160;</xsl:text></b>
  </xsl:template>

  <xsl:template match="update">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="expression">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="infergr">
    <div align="center">
      <table cellpadding="0" cellspacing="0" summary="">
	<xsl:for-each select="infer">
	  <tr valign="middle" align="center">
	    <td>
	      <xsl:apply-templates select="."/>
	    </td>
	  </tr>
	</xsl:for-each>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="infer">
    <table cellpadding="0" cellspacing="0" summary="">
      <tr valign="middle" align="center">
	<td><xsl:apply-templates select="prejudge"/></td>
      </tr>
      <tr>
	<td><hr noshade="noshade" size="1" style="color:black" /></td>
      </tr>
      <tr valign="middle" align="center">
	<td><xsl:apply-templates select="postjudge"/></td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="prejudge|postjudge">
    <table cellpadding="0" cellspacing="0" summary="">
      <xsl:for-each select="clause|multiclause">
	<tr valign="middle" align="center">
	  <td><xsl:apply-templates select="."/></td>
	</tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="clause">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="multiclause">
    <xsl:for-each select="clause">
      <xsl:apply-templates select="."/>
      <xsl:if test="not(position()=last())">
	<xsl:text disable-output-escaping="yes">&amp;#160;&amp;#160;&amp;#160;&amp;#160;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="subscript">
    <sub><font size="2"><xsl:apply-templates/></font></sub>
  </xsl:template>

  <!-- sm group -->
  <xsl:template match="smnote">
    <p><b>Note</b></p>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="smexamples">
    <p><b>Examples</b></p>
    <xsl:apply-templates/>
  </xsl:template>
 
  <xsl:template match="smexample">
    <p><b>Example</b></p>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="smintro">
    <p><b>Introduction</b></p>
    <xsl:apply-templates/>
  </xsl:template>
 
  <xsl:template match="smrules">
    <p><b>Semantics</b></p>
    <xsl:apply-templates/>
  </xsl:template>
 
  <xsl:template match="smcore">
    <p><b>Core Grammar</b></p>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="smnorm">
    <p><b><a class="processing" href="#processing_normalization">正規化</a></b></p>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="smtype">
    <p><b><a class="processing" href="#processing_static">静的型解析</a></b></p>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="smeval">
    <p><b><a class="procesing" href="#processing_dynamic">動的評価</a></b></p>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="smcontext">
    <p><b><a class="processing" href="#processing_context">静的文脈の処理</a></b></p>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="smdyncontext">
    <p><b><a class="processing" href="#dyn_processing_context">動的文脈の処理</a></b></p>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="smschema">
    <p><b>スキーマ構成要素</b></p>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="smschemanorm">
    <p><b>Schema mapping</b></p>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="mapping">
    <div align="center">
      <table cellpadding="0" cellspacing="0" summary="">
	<tr>
	  <td><xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text></td>
	</tr>
	<tr>
	  <td style="margin-right:1cm;" align="center"><xsl:apply-templates select="xquery"/></td>
	</tr>
	<tr>
	  <td align="center"><b>==</b></td>
	</tr>
	<tr>
	  <td style="margin-right:1cm;" align="center"><xsl:apply-templates select="core"/></td>
	</tr>
      </table>
    </div>
  </xsl:template>
  <xsl:template match="xquery|core">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="map">
    <font size="6">[</font><xsl:apply-templates/><font size="6">]</font>
  </xsl:template>

  <!-- override -->
  <xsl:template match="loc">
    <xsl:if test="starts-with(@href, '#')">
      <xsl:if test="not(key('ids', substring-after(@href, '#')))">
        <xsl:message>
          <xsl:text>Internal loc href to </xsl:text>
          <xsl:value-of select="@href"/>
          <xsl:text>, but that ID does not exist in this document.</xsl:text>
        </xsl:message>
      </xsl:if>
    </xsl:if>

    <a xmlns="http://www.w3.org/1999/xhtml" href="{@href}">
      <xsl:choose>
        <xsl:when test="count(child::node())=0">
          <xsl:value-of select="@href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsl:template match="b">
    <b><xsl:apply-templates/></b>
  </xsl:template>

  <xsl:template match="small">
    <small><xsl:apply-templates/></small>
  </xsl:template>

  <xsl:template match="xtermref">
    <xsl:variable name="context" select="."/>

    <a xmlns="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="href">
	<xsl:choose>
	  <xsl:when test="@spec='DM'">
	    <xsl:value-of select="concat('http://www.w3.org/TR/xpath-datamodel/#', @ref)" />
	  </xsl:when>
	  <xsl:when test="@spec='FO'">
	    <xsl:value-of select="concat('http://www.w3.org/TR/xpath-functions/#', @ref)" />
	  </xsl:when>
	  <xsl:when test="@spec='FS'">
	    <xsl:value-of select="concat('http://www.w3.org/TR/xquery-semantics/#', @ref)" />
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
	<xsl:when test="@spec='DM'">
	  <xsl:value-of select="document('data-model.xml')//*[@id=$context/@ref]/term"/>
	</xsl:when>
	<xsl:when test="@spec='FO'">
	  <xsl:value-of select="document('xpath-functions.xml')//*[@id=$context/@ref]/term"/>
	</xsl:when>
	<xsl:when test="@spec='FS'">
	  <xsl:value-of select="document('xquery-semantics.xml')//*[@id=$context/@ref]/term"/>
	</xsl:when>
	<xsl:when test="@spec='XP'">
	  <xsl:value-of select="document('xpath20.xml')//*[@id=$context/@ref]/term"/>
	</xsl:when>
	<xsl:when test="@spec='XQ'">
	  <xsl:value-of select="document('xquery.xml')//*[@id=$context/@ref]/term"/>
	</xsl:when>
      </xsl:choose>
    </a>
    <sup><small><xsl:value-of select="@spec"/></small></sup>
  </xsl:template>

  <xsl:template match="rhs-group">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="schemaRepresentationEg">
    <div class="exampleInner">
      <xsl:apply-templates select="schemaRepresentation"/>
    </div>
  </xsl:template>

  <xsl:template match="schemaRepresentation">
    <table summary="">
      <tbody>
	<tr>
	  <td><xsl:text disable-output-escaping="yes">&amp;#160;&amp;#160;&amp;lt;</xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes">&amp;gt;</xsl:text></td>
	</tr>
	<xsl:apply-templates select="schemaAttribute | content"/>
	<tr>
	  <td><xsl:text disable-output-escaping="yes">&amp;#160;&amp;#160;&amp;lt;/</xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes">&amp;gt;</xsl:text></td>
	</tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="schemaRepresentationNoContent">
    <table summary="">
      <tbody>
	<tr>
	  <td><xsl:text disable-output-escaping="yes">&amp;#160;&amp;#160;&amp;lt;</xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes">&amp;gt;</xsl:text></td>
	</tr>
	<xsl:apply-templates select="schemaAttribute"/>
	<tr>
	  <td><xsl:text disable-output-escaping="yes">&amp;#160;&amp;#160;&amp;lt;/</xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes">&amp;gt;</xsl:text></td>
	</tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="schemaRepresentationNoAttribute">
    <table summary="">
      <tbody>
	<tr>
	  <td><xsl:text disable-output-escaping="yes">&amp;#160;&amp;#160;&amp;lt;</xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes">&amp;gt;</xsl:text></td>
	</tr>
	<xsl:apply-templates select="content"/>
	<tr>
	  <td><xsl:text disable-output-escaping="yes">&amp;#160;&amp;#160;&amp;lt;/</xsl:text><xsl:value-of select="name"/><xsl:text disable-output-escaping="yes">&amp;gt;</xsl:text></td>
	</tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="schemaAttribute">
    <tr>
      <td>
	<xsl:text disable-output-escaping="yes">&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;</xsl:text>
	<xsl:if test="@role">
	  <b>[ <xsl:value-of select="@role"/> ]	<xsl:text disable-output-escaping="yes">&amp;#160;&amp;#160;</xsl:text></b>
	</xsl:if>
	<xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="content">
    <tr>
      <td>
	<xsl:text disable-output-escaping="yes">&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;&amp;#160;</xsl:text>
	<xsl:value-of select="."/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="a//a">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="emph//emph">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
