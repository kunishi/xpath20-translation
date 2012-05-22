<?xml version="1.0" encoding="UTF-8"?>
<!-- ********************************************************
     This stylesheet is intended for use when publishing standard
     specifications in the W3C Internationalization Activity.
	 It is derived from stylesheets created by Richard Ishida and
	 François Yergeau.
	 
     The behaviour depends on the presence or absence of a
     role='editors-copy' atribute on the spec element.  If this
     attribute is absent, the stylesheet produces a version for
     publication.  If it is present, then the following occurs

      - The $Id stuff appears at the very top (now contained in
        the 1st para in <revisiondesc>)
      - The W3C logo disappears.
      - A notice appears in the Status section, saying this is an
        editors copy with no standing.
      - The base.css stylesheet is used instead of W3C-xx. To
        facilitate offline editing, base.css is assumed to be in
        the same directory as the document.
      - The <ins> and <del> markup is preserved, styling is added
        for it in the CSS stylesheet embedded in the doc.
      - The Javascript to turn redlining on and off is included.
      - Editor's notes (<ednote>) appear.
     ********************************************************
     
	HOUSEKEEPING RULES:
     
	Use Python-like indentation, eg. 
		<element1>
			<element2/>
			</element1>
	not
		<element1>
			<element2/>
		</element1>
	and use tabs to indent, not spaces.
	
	Always note in the initial comment how this differs from the previous
	definition that it overwrites (or say that this is specific to this
	style sheet).
	
	Always order templates alphabetically, except where mode is used, when 
	it may be better to order alphabetically by mode.
	
	Always summarise changes made just below here. 
     
     -->
<!-- Version: $Id: xmlspec-i18n.xsl,v 1.12 2005/07/29 11:03:43 rishida Exp $ -->
<!-- Author: Richard Ishida (ishida@w3.org) -->
<!-- Date Created: 2005.07.13 -->
<!-- This stylesheet is copyright (c) 2000 by its authors.  Free
     distribution and modification is permitted, including adding to
     the list of authors and copyright holders, as long as this
     copyright notice is maintained. --><!-- ChangeLog:

14 july 2005 (ishida@w3.org)

    - compared all templates to latest xmlspec and brought in line where needed
    - annotated all templates to explain differences from xmlspec.


-->
<xsl:transform version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:saxon="http://icl.com/saxon"
 exclude-result-prefixes="saxon fn xs xdt">



<!-- First, import the main stylesheet -->
<xsl:import href="xmlspec.xsl"></xsl:import>

<!-- *** CHECK AGAIN -->
<!--xsl:key name="bibls" match="doc('refs.xml')/spec/body/div1/blist/bibl" use="@id"/-->
<!--xsl:variable name="biblItems" select="doc('refs.xml')/blist"/-->
<xsl:variable name="biblItems" select="//blist"/>



<!--xsl:param name="additional.title">(Editors' copy)</xsl:param-->
<xsl:param name="show.ednotes">1</xsl:param>

<xsl:variable name="output.mode" select="'xhtml'" />

<xsl:output method="xml" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="no" 
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />


<!-- abbr
Specific to xmlspec-i18n -->
<xsl:template match="abbr">
	<abbr>
		<xsl:call-template name="copy-common-atts"/>
		<xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute>
		<xsl:apply-templates/>
		</abbr>
	</xsl:template>


<!-- anchor
Changed so that it produces <a ...></a> rather than <a .../> -->
<xsl:template name="anchor">
	<xsl:param name="node" select="."/>
	<xsl:param name="conditional" select="1"/>
	<xsl:param name="default.id" select="''"/>

	<xsl:variable name="id">
		<xsl:call-template name="object.id">
			<xsl:with-param name="node" select="$node"/>
			<xsl:with-param name="default.id" select="$default.id"/>
			</xsl:call-template>
		</xsl:variable>
	<xsl:if test="$conditional = 0 or $node/@id">
		<xsl:text disable-output-escaping="yes">&lt;a name="</xsl:text><xsl:value-of 
		select="$id"/><xsl:text>" id="</xsl:text><xsl:value-of 
		select="$id"/><xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>
		<!--a name="{$id}" id="{$id}"></a-->
		</xsl:if>
	</xsl:template>



<!-- bibref
Makes a link to the bibl.
If the bibl has a key, put it in square brackets; otherwise use the bibl's ID.
Added title attribute to <a>. -->
<xsl:template match="bibref">
	<a>
		<xsl:attribute name="title">
			<xsl:value-of select="key('ids', @ref)/titleref" />
			</xsl:attribute>
		<xsl:attribute name="href">
			<xsl:call-template name="href.target">
				<xsl:with-param name="target" select="key('ids', @ref)"/>
				</xsl:call-template>
			</xsl:attribute>
		<xsl:text>[</xsl:text>
		<xsl:choose>
		<xsl:when test="key('ids', @ref)/@key">
			<xsl:value-of select="key('ids', @ref)/@key"/>
			</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@ref"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>]</xsl:text>
		</a>
	</xsl:template>


<!-- body: the meat of the spec 
Changed first <p class="toc"> to <div class="toc"> 
Removed 2nd <p class="toc"> -->
<xsl:template match="body">
	<xsl:if test="$toc.level &gt; 0">
		<div class="toc">
			<xsl:text>
</xsl:text>
			<h2>
				<xsl:call-template name="anchor">
					<xsl:with-param name="conditional" select="0"/>
					<xsl:with-param name="default.id" select="'contents'"/>
					</xsl:call-template>
				<xsl:text>Table of Contents</xsl:text>
				</h2>
			<div class="toc">
				<xsl:apply-templates select="div1" mode="toc"/>
				</div>
			<xsl:if test="../back">
				<xsl:text>
</xsl:text>
				<h3>
					<xsl:call-template name="anchor">
						<xsl:with-param name="conditional" select="0"/>
						<xsl:with-param name="default.id" select="'appendices'"/>
						</xsl:call-template>
					<xsl:text>Appendi</xsl:text>
					<xsl:choose>
					<xsl:when test="count(../back/div1 | ../back/inform-div1) &gt; 1">
						<xsl:text>ces</xsl:text>
						</xsl:when>
					<xsl:otherwise>
						<xsl:text>x</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					</h3>
				<xsl:apply-templates mode="toc" select="../back/div1 | ../back/inform-div1"/>
				<xsl:call-template name="autogenerated-appendices-toc"/>
				</xsl:if>
			<xsl:if test="//footnote[not(ancestor::table)]">
				<p class="toc">
					<a href="#endnotes">
						<xsl:text>End Notes</xsl:text>
						</a>
					</p>
				</xsl:if>
			</div>
		<hr />
		</xsl:if>
	<div class="body">
		<xsl:apply-templates/>
		</div>
	</xsl:template>



<!-- caption: 
Calls the parseString template to deal with the part that says: Figure X:
That is a reusable string that has been externalized to aid translatability.
Specific to xmlspec-i18n. -->
<xsl:template match="caption">
	<div class="caption">
			<xsl:call-template name="copy-common-atts"/>
			<xsl:call-template name="parseString">
				<xsl:with-param name="stringID" select="'figure'" /> 
				<xsl:with-param name="var1ID" select="'var1'" /> 
				<xsl:with-param name="var1Value">
  					<xsl:number count="figure" level="any" /> 
					</xsl:with-param>
		 		</xsl:call-template>
  		<xsl:value-of select="." /> 
  		</div>
	</xsl:template>



<!-- checklist-item -->
<xsl:template match="checklist-item">
	<div class="rule">
		<xsl:call-template name="copy-common-atts"/>
		<xsl:apply-templates />
		</div>
	</xsl:template>
	

<!-- copy-common-atts: copies across xml:lang and dir attributes.  The preferred way of doing 
this is the commented out template immediately following this one, but I can't copy the id 
across because of the way xmlspec handles anchors. 
I don't add role here, because it overwrites classes set elsewhere.  *** this can probably be fixed by concatenation.
I don't add id, because ids are used in a elements, and there's another routine for that.
I don't add any of the localization attributes, because there's nothing to map them to, and they
aren't needed in the HTML.
Added code to disallow bidi overrides - these are handled in the phrase template. -->
<xsl:template name="copy-common-atts">
	<xsl:for-each select="@*">
		<xsl:if test="name()='dir' and . != 'lro' and . != 'rlo'">
			<xsl:copy/>
			</xsl:if>
		<xsl:if test="name()='xml:lang'">
			<xsl:copy/>
			<xsl:attribute name="lang"><xsl:value-of select="."/></xsl:attribute>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

<!-- copy-common-atts: does what it says (see comments for previous template). 
<xsl:template name="preferred-copy-common-atts">
	<xsl:for-each select="@*">
		<xsl:copy/>
		</xsl:for-each>
	</xsl:template>-->



<!-- css 
Removed all in-document styling
Added <link rel="stylesheet" href="local.css" type="text/css" />
Removed absolute path if editor's copy -->
<xsl:template name="css">
	<style type="text/css">
		<xsl:text>
</xsl:text>
		<xsl:if test="$tabular.examples = 0">
			<xsl:text>
</xsl:text>
			</xsl:if>
		<xsl:value-of select="$additional.css"/>
		</style>
	<link rel="stylesheet" href="local.css" type="text/css" />
	<link rel="stylesheet" type="text/css">
		<xsl:attribute name="href">
			<xsl:if test="not(/spec/@role='editors-copy')">
				<xsl:text>http://www.w3.org/StyleSheets/TR/</xsl:text>
				</xsl:if>
			<xsl:choose>
			<xsl:when test="/spec/@role='editors-copy'">base</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
				<!-- Editor's review drafts are a special case. -->
				<xsl:when test="/spec/@w3c-doctype='review'or contains(/spec/header/w3c-doctype, 'Editor')">base</xsl:when>
				<xsl:when test="/spec/@w3c-doctype='wd'">W3C-WD</xsl:when>
				<xsl:when test="/spec/@w3c-doctype='rec'">W3C-REC</xsl:when>
				<xsl:when test="/spec/@w3c-doctype='pr'">W3C-PR</xsl:when>
				<xsl:when test="/spec/@w3c-doctype='per'">W3C-PER</xsl:when>
				<xsl:when test="/spec/@w3c-doctype='cr'">W3C-CR</xsl:when>
				<xsl:when test="/spec/@w3c-doctype='note'">W3C-NOTE</xsl:when>
				<xsl:when test="/spec/@w3c-doctype='wgnote'">W3C-WG-NOTE</xsl:when>
				<xsl:when test="/spec/@w3c-doctype='memsub'">W3C-Member-SUBM</xsl:when>
				<xsl:when test="/spec/@w3c-doctype='teamsub'">W3C-Team-SUBM</xsl:when>
				<xsl:otherwise>base</xsl:otherwise>
				</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>.css</xsl:text>
			</xsl:attribute>
		</link>
	</xsl:template>



<!--  del
Not rendered at all for publication, marked as HTML del in editors' copy.
Specific to xmlspec-i18n. -->
<xsl:template match="del">
	<xsl:if test="/spec/@role='editors-copy'">
		<del>
			<xsl:apply-templates/>
			</del>
    	</xsl:if>
  	</xsl:template>


<!-- TECHNIQUE SPECIFIC -->
<!--  description: encloses a description of a technique -->
<xsl:template match="description">
	<div class="description">
		<xsl:call-template name="copy-common-atts"/>
		<xsl:apply-templates />
		</div>
	</xsl:template>




<!-- div1
Added call to copy-common-atts -->
<xsl:template match="div1">
	<div class="div1">
		<xsl:call-template name="copy-common-atts"/>
		<xsl:apply-templates/>
		</div>
 	</xsl:template>



<!-- div1/div2[@role='unfiltered'] 
Specific to xmlspec-i18n.
Used to filter out from a long list of references just those that are relevant to this document.
Cannot be used where a distinction is made between normative and non-normative documents. -->
<xsl:template match="div1[@role='unfiltered']|div2[@role='unfiltered']">
	<div class="div1">
		<xsl:call-template name="copy-common-atts"/>
      	<xsl:apply-templates select="head"/>
		<dl>
			<!-- make a list of all the references in the document -->
			<xsl:variable name="unsortedResourceList" select="//geo-technique/resources"/>
			<!-- sort the list of all the references in the document -->
			<xsl:variable name="resourceList">
				<xsl:for-each select="$unsortedResourceList/resource">
					<xsl:sort select="bibref/@ref" />
					<xsl:copy-of select="." />
					</xsl:for-each>
				</xsl:variable>
			
			<!-- list out references without duplication-->
			<xsl:for-each select="$resourceList/resource">
				<xsl:if test="(not(bibref/@ref = preceding-sibling::resource/bibref/@ref)) and (not(bibref/@ref = 'url'))">
					<xsl:apply-templates select="doc('refs.xml')//bibl[@id = current()/bibref/@ref]" />
					</xsl:if>
				</xsl:for-each>
    		</dl>
		</div>
  	</xsl:template>



<!-- div2
Added call to copy-common-atts -->
<xsl:template match="div2">
    <div class="div2">
		<xsl:call-template name="copy-common-atts"/>
    	<xsl:apply-templates/>
    	</div>
	</xsl:template>





<!-- div3
Added call to copy-common-atts -->
<xsl:template match="div3">
    <div class="div3">
		<xsl:call-template name="copy-common-atts"/>
    	<xsl:apply-templates/>
    	</div>
	</xsl:template>





<!-- divnum mode templates: returns the number of a section for use in a link.  
They are reproduced here because they are without the trailing space used in 
the divnum templates in xmlspec. This makes it easier to create references to,
say, sections where the number is followed by a colon. -->
<xsl:template mode="divnum" match="div1">
	<xsl:number format="1"/>
	</xsl:template>

<xsl:template mode="divnum" match="back/div1 | inform-div1">
	<xsl:number count="div1 | inform-div1" format="A"/>
	</xsl:template>

<xsl:template mode="divnum" match="front/div1 | front//div2 | front//div3 | front//div4 | front//div5"/>

<xsl:template mode="divnum" match="div2">
	<xsl:number level="multiple" count="div1 | div2" format="1.1"/>
	</xsl:template>

<xsl:template mode="divnum" match="back//div2">
	<xsl:number level="multiple" count="div1 | div2 | inform-div1" format="A.1"/>
	</xsl:template>

<xsl:template mode="divnum" match="div3">
	<xsl:number level="multiple" count="div1 | div2 | div3" format="1.1.1"/>
	</xsl:template>

<xsl:template mode="divnum" match="back//div3">
	<xsl:number level="multiple" count="div1 | div2 | div3 | inform-div1" format="A.1.1"/>
	</xsl:template>

<xsl:template mode="divnum" match="div4">
	<xsl:number level="multiple" count="div1 | div2 | div3 | div4" format="1.1.1.1"/>
	</xsl:template>

<xsl:template mode="divnum" match="back//div4">
	<xsl:number level="multiple" count="div1 | div2 | div3 | div4 | inform-div1" format="A.1.1.1"/>
	</xsl:template>

<xsl:template mode="divnum" match="div5">
	<xsl:number level="multiple" count="div1 | div2 | div3 | div4 | div5" format="1.1.1.1.1"/>
	</xsl:template>

<xsl:template mode="divnum" match="back//div5">
	<xsl:number level="multiple" count="div1 | div2 | div3 | div4 | div5 | inform-div1" format="A.1.1.1.1"/>
	</xsl:template>
	

<!-- ednote: editors' note 
Show only if $show.ednotes parameter is not 0 or if editors' copy.
Overridden for use as a phrase level element. No tables. -->
<xsl:template match="ednote">
	<xsl:if test="$show.ednotes!='0' or /spec/@role='editors-copy'">
		<span class="editor-note">
			<xsl:text>[</xsl:text>
			<xsl:call-template name="parseString">
				<xsl:with-param name="stringID" select="'ednote'" /> 
				</xsl:call-template>
			<xsl:apply-templates/>
			<xsl:text>]</xsl:text>
			</span>
		</xsl:if>
	</xsl:template>
	
	
<!-- emph(role=strong): 
Provides a more visible highlighting of text than ordinary emph.
Specific to xmlspec-i18n. -->
<xsl:template match="emph[@role='strong']">
	<strong>
		<xsl:call-template name="copy-common-atts"/>
		<xsl:apply-templates/>
		</strong>
  	</xsl:template>


<!-- example
Added call to copy-common-atts.
Added switch to ensure that there is always a caption. -->
<xsl:template match="example">
	<xsl:variable name="class">
		<xsl:choose>
		<xsl:when test="$tabular.examples = 0">exampleOuter</xsl:when>
		<xsl:otherwise>example</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
	<div class="{$class}">
		<xsl:call-template name="copy-common-atts"/>
		<xsl:choose>
		<xsl:when test="head">
			<xsl:apply-templates/>
			</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="example-head"/>
			<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		</div>
	</xsl:template>
	

<!-- example-head
Specific to xmlspec-i18n.
Used to add a caption (head) if there wasn't one already. -->
<xsl:template name="example-head">
	<xsl:choose>
	<xsl:when test="$tabular.examples = 0">
		<div class="exampleHeader">
			<xsl:call-template name="copy-common-atts"/>
			<xsl:call-template name="anchor">
				<xsl:with-param name="node" select="."/>
				<xsl:with-param name="conditional" select="0"/>
				</xsl:call-template>
			<xsl:call-template name="parseString">
				<xsl:with-param name="stringID" select="'example'" /> 
				<xsl:with-param name="var1ID" select="'var1'" /> 
				<xsl:with-param name="var1Value">
  					<xsl:number count="example" level="any" /> 
  					</xsl:with-param>
		 		</xsl:call-template>
			</div>
		</xsl:when>
	<xsl:otherwise>
		<h5>
			<xsl:call-template name="anchor">
				<xsl:with-param name="node" select="."/>
				<xsl:with-param name="conditional" select="0"/>
				</xsl:call-template>
			<xsl:call-template name="parseString">
				<xsl:with-param name="stringID" select="'example'" /> 
				<xsl:with-param name="var1ID" select="'var1'" /> 
				<xsl:with-param name="var1Value">
  					<xsl:number count="example" level="any" /> 
  					</xsl:with-param>
		 		</xsl:call-template>
			</h5>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- figure
This is new to xmlspec-i18n -->
<xsl:template match="figure">
	<div class="figure">
		<xsl:call-template name="copy-common-atts"/>
		<a name="{@id}" id="{@id}"></a>
		<xsl:if test="image">
			<xsl:apply-templates select="image"/>
			</xsl:if>
		<xsl:if test="table">
			<xsl:apply-templates select="table"/>
			</xsl:if>
		<xsl:apply-templates select="caption"/>
		</div>
	</xsl:template>



<!--  geo-technique
Specific to xmlspec-i18n
*** Should it be in a separate stylesheet? -->
<xsl:template match="geo-technique">
	<xsl:apply-templates select="short-name"/>
	<xsl:apply-templates select="checklist-item"/>
	<xsl:apply-templates select="ua-applicability"/>
	<xsl:apply-templates select="description"/>
	<xsl:apply-templates select="ua-issues"/>
	<xsl:apply-templates select="resources"/>
	</xsl:template>




<!-- head in div1
Added code for graphic link back to table of contents.
*** We should decide whether to keep that code, or whether it should be 
technique-specific
Added call to copy-common-attrs.
Added <xsl:text> </xsl:text> because spaces removed from divnum templates. -->
<xsl:template match="div1/head">
    <xsl:text>
</xsl:text>
    <h2>
		<xsl:call-template name="copy-common-atts"/>
		<a href="#contents">
			<img src="images/topOfPage.gif" align="right" height="26" width="26" >
				<xsl:attribute name="title">
					<xsl:call-template name="parseString">
						<xsl:with-param name="stringID" select="'ESgototoc'" /> 
			 			</xsl:call-template>
					</xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:call-template name="parseString">
						<xsl:with-param name="stringID" select="'ESgototoc'" /> 
			 			</xsl:call-template>
					</xsl:attribute>
				</img>
			</a>
		<xsl:call-template name="anchor">
			<xsl:with-param name="conditional" select="0"/>
			<xsl:with-param name="node" select=".."/>
			</xsl:call-template>
		<xsl:apply-templates select=".." mode="divnum"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
		</h2>
	</xsl:template>



<!-- head in div2 
Added code for graphic link back to table of contents
*** We should decide whether to keep that code, or whether it should be 
technique-specific
Added call to copy-common-attrs.
Added <xsl:text> </xsl:text> because spaces removed from divnum templates. -->
<xsl:template match="div2/head">
	<xsl:text>
</xsl:text>
 	<h3>
		<xsl:call-template name="copy-common-atts"/>
		<a href="#contents">
			<img src="images/topOfPage.gif" align="right" height="26" width="26" >
				<xsl:attribute name="title">
					<xsl:call-template name="parseString">
						<xsl:with-param name="stringID" select="'ESgototoc'" /> 
			 			</xsl:call-template>
					</xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:call-template name="parseString">
						<xsl:with-param name="stringID" select="'ESgototoc'" /> 
			 			</xsl:call-template>
					</xsl:attribute>
				</img>
			</a>
      	<xsl:call-template name="anchor">
        	<xsl:with-param name="conditional" select="0"/>
       		<xsl:with-param name="node" select=".."/>
      		</xsl:call-template>
      	<xsl:apply-templates select=".." mode="divnum"/>
      	<xsl:text> </xsl:text>
      	<xsl:apply-templates/>
    	</h3>
  	</xsl:template>


<!-- head in div3 
Added code for graphic link back to table of contents
*** We should decide whether to keep that code, or whether it should be 
technique-specific
Added call to copy-common-attrs.
Added <xsl:text> </xsl:text> because spaces removed from divnum templates. -->
<xsl:template match="div3/head">
	<xsl:text>
</xsl:text>
 	<h4>
		<xsl:call-template name="copy-common-atts"/>
		<a href="#contents">
			<img src="images/topOfPage.gif" align="right" height="26" width="26" >
				<xsl:attribute name="title">
					<xsl:call-template name="parseString">
						<xsl:with-param name="stringID" select="'ESgototoc'" /> 
			 			</xsl:call-template>
					</xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:call-template name="parseString">
						<xsl:with-param name="stringID" select="'ESgototoc'" /> 
			 			</xsl:call-template>
					</xsl:attribute>
				</img>
			</a>
      	<xsl:call-template name="anchor">
        	<xsl:with-param name="conditional" select="0"/>
        	<xsl:with-param name="node" select=".."/>
      		</xsl:call-template>
      	<xsl:apply-templates select=".." mode="divnum"/>
      	<xsl:text> </xsl:text>
      	<xsl:apply-templates/>
    	</h4>
  	</xsl:template>


<!-- head in inform-div1 
Added code for graphic link back to table of contents
*** We should decide whether to keep that code, or whether it should be 
technique-specific
Added call to copy-common-attrs.
Added <xsl:text> </xsl:text> because spaces removed from divnum templates. -->
<xsl:template match="inform-div1/head">
	<xsl:text>
</xsl:text>
	<h2>
		<xsl:call-template name="copy-common-atts"/>
		<a href="#contents">
			<img src="images/topOfPage.gif" align="right" height="26" width="26" >
				<xsl:attribute name="title">
					<xsl:call-template name="parseString">
						<xsl:with-param name="stringID" select="'ESgototoc'" /> 
			 			</xsl:call-template>
					</xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:call-template name="parseString">
						<xsl:with-param name="stringID" select="'ESgototoc'" /> 
			 			</xsl:call-template>
					</xsl:attribute>
				</img>
			</a>
		<xsl:call-template name="anchor">
			<xsl:with-param name="conditional" select="0"/>
			<xsl:with-param name="node" select=".."/>
			</xsl:call-template>
		<xsl:apply-templates select=".." mode="divnum"/>
      	<xsl:text> </xsl:text>
		<xsl:apply-templates/>
		<xsl:text> (Non-Normative)</xsl:text>
		</h2>
	</xsl:template>



<!-- head in example
Added call to copy-common-atts.
Added calls to parseString instead of 'Example X: '. -->
<xsl:template match="example/head">
	<xsl:choose>
	<xsl:when test="$tabular.examples = 0">
		<div class="exampleHeader">
			<xsl:call-template name="copy-common-atts"/>
			<xsl:call-template name="anchor">
				<xsl:with-param name="node" select=".."/>
				<xsl:with-param name="conditional" select="0"/>
				</xsl:call-template>
			<xsl:call-template name="parseString">
				<xsl:with-param name="stringID" select="'example'" /> 
				<xsl:with-param name="var1ID" select="'var1'" /> 
				<xsl:with-param name="var1Value">
  					<xsl:number count="example" level="any" /> 
  					</xsl:with-param>
		 		</xsl:call-template>
			<xsl:apply-templates/>
			</div>
		</xsl:when>
	<xsl:otherwise>
		<h5>
			<xsl:call-template name="anchor">
				<xsl:with-param name="node" select=".."/>
				<xsl:with-param name="conditional" select="0"/>
				</xsl:call-template>
			<xsl:call-template name="parseString">
				<xsl:with-param name="stringID" select="'example'" /> 
				<xsl:with-param name="var1ID" select="'var1'" /> 
				<xsl:with-param name="var1Value">
  					<xsl:number count="example" level="any" /> 
  					</xsl:with-param>
		 		</xsl:call-template>
			<xsl:apply-templates/>
			</h5>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



<!-- image
Specific to xmlspec-i18n.
Replaces the graphic element of xmlspec. -->
<xsl:template match="image">
	<img align="middle">
		<xsl:call-template name="copy-common-atts"/>
      		<xsl:attribute name="src">
        			<xsl:value-of select="img/@source"/>
      			</xsl:attribute>
      		<xsl:attribute name="alt">
        			<xsl:value-of select="alt"/>
      			</xsl:attribute>
      		<xsl:if test="img/@height">
        			<xsl:attribute name="height">
          				<xsl:value-of select="img/@height"/>
        				</xsl:attribute>
      			</xsl:if>
      		<xsl:if test="img/@width">
        			<xsl:attribute name="width">
          				<xsl:value-of select="img/@width"/>
        				</xsl:attribute>
      			</xsl:if>
    		</img>
  	</xsl:template>




<!--  ins: content goes straight through for publication, marked as HTML 
ins in editors' copy only.
Specific to xmlspec-i18n. -->
<xsl:template match="ins">
	<xsl:choose>
	<xsl:when test="/spec/@role='editors-copy'">
		<ins ><xsl:apply-templates/></ins>
		</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>


<!-- item
Added call to copy-common-atts.
Added anchor if id present.
Added special class handling for items that are part of a req element.
*** Note that this has Charmod specific code. -->
<xsl:template match="item">
	<li>
		<xsl:call-template name="copy-common-atts"/>
		<xsl:if test="@id"><a name="{@id}" id="{@id}"></a></xsl:if>
		<xsl:if test="ancestor-or-self::*/req">
			<xsl:attribute name="class"><xsl:text>req</xsl:text></xsl:attribute>
			</xsl:if>
		<xsl:apply-templates/>
		</li>
	</xsl:template>



<!-- kw: keyword 
Made it <code class="keyword"> instead of bold. -->
<xsl:template match="kw">
	<code class="keyword"><xsl:apply-templates/></code>
  	</xsl:template>


<!-- list.numeration
Adapted to return the depth as a number, rather than assuming style.
*** Not sure why you need to do this, since CSS can handle ol ol { } -->
<xsl:template name="list.numeration">
    <xsl:variable name="depth" select="count(ancestor::olist)"/>
    <xsl:choose>
      <xsl:when test="$depth mod 5 = 0">1</xsl:when>
      <xsl:when test="$depth mod 5 = 1">2</xsl:when>
      <xsl:when test="$depth mod 5 = 2">3</xsl:when>
      <xsl:when test="$depth mod 5 = 3">4</xsl:when>
      <xsl:when test="$depth mod 5 = 4">5</xsl:when>
    </xsl:choose>
  </xsl:template>


<!-- note
See also p in note. Together these have the following effect: 
if the first element in an example is a p, make the NOTE: heading appear inline 
otherwise pop it into a p block before all other elements.
Added call to copy-common-atts.
Added test for first child and link to note/p. -->
<xsl:template match="note">
	<div class="note">
		<xsl:call-template name="copy-common-atts"/>
		<xsl:if test="@id"><a name="{@id}" id="{@id}"></a></xsl:if>
		<xsl:if test="name(*[1]) != 'p'">
			<p class="prefix">
				<xsl:call-template name="parseString">
					<xsl:with-param name="stringID" select="'note'" /> 
		 			</xsl:call-template>
				</p>
			</xsl:if>
		<xsl:apply-templates/>
		</div>
	</xsl:template>
	

<!-- olist
Class names changed to be more memorable.
Adapted to ensure that olist doesn't appear inside p in HTML.
Added call to copy-common-atts. -->
<xsl:template match="olist">
	<xsl:variable name="numeration">
		<xsl:call-template name="list.numeration"/>
		</xsl:variable>
	<xsl:if test="$validity.hacks and (local-name(..) = 'p')">
		<xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
		</xsl:if>
	<ol class="depth{$numeration}">
		<xsl:call-template name="copy-common-atts"/>
		<xsl:apply-templates/>
		</ol>
	<xsl:if test="$validity.hacks and (local-name(..) = 'p')">
		<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
		</xsl:if>
	</xsl:template>


<!-- p: a standard paragraph
Added call to copy-common-atts and removed id code -->
<xsl:template match="p">
	<p>
		<xsl:call-template name="copy-common-atts"/>
		<xsl:if test="@role">
			<xsl:attribute name="class">
				<xsl:value-of select="@role"/>
				</xsl:attribute>
			</xsl:if>
		<xsl:apply-templates/>
		</p>
	</xsl:template>
	

<!-- p in note
Works with note template to determine whether the text "Note:" is inline
or in a separate paragraph.
Specific to xmlspec-i18n. -->
<xsl:template match="note/p">
	<p>
		<xsl:call-template name="copy-common-atts"/>
		<xsl:if test="@id">
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
		<xsl:if test="@role">
			<xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
			</xsl:if>
		<xsl:if test="position() = 1">
			<span class="note-head">
				<xsl:call-template name="parseString">
					<xsl:with-param name="stringID" select="'note'" /> 
					</xsl:call-template>
				</span>
			</xsl:if>
		<xsl:apply-templates/>
		</p>
	</xsl:template>



<!-- *** CHECK AGAIN - we don't allow multiple p's in checklist items any more -->
<!-- p in checklist-item -->	
<xsl:template match="checklist-item/p">
	<xsl:apply-templates />
	</xsl:template>



<!-- parseString
Specific to xmlspec-i18n -->
<xsl:template name="parseString">
  	<xsl:param name="stringID" /> 
  	<xsl:param name="var1ID" /> 
  	<xsl:param name="var1Value" /> 
  	<xsl:param name="var2ID" /> 
  	<xsl:param name="var2Value" /> 
	<xsl:for-each select="doc('strings.xml')/id($stringID)/string/node()">
		<xsl:choose>
		<xsl:when test="name() = 'variable' and @name = $var1ID">
  			<xsl:value-of select="$var1Value" /> 
  			</xsl:when>
		<xsl:when test="name() = 'variable' and @name = $var2ID">
  			<xsl:value-of select="$var2Value" /> 
  			</xsl:when>
		<xsl:otherwise>
  			<xsl:value-of select="." /> 
  			</xsl:otherwise>
  		</xsl:choose>
  		</xsl:for-each>
  	</xsl:template>



<!-- phrase: semantically meaningless markup hanger 
Role attributes may be used to request different formatting,
which isn't currently handled.
Added call to copy-common-atts. 
Added code to handle bidi overrides. -->
<xsl:template match="phrase">
	<span>
		<xsl:call-template name="copy-common-atts"/>
		<xsl:if test="@role">
			<xsl:attribute name="class">
				<xsl:value-of select="@role"/>
				</xsl:attribute>
			</xsl:if>
		<xsl:choose>
		<xsl:when test="(@dir = 'rlo') or (@dir = 'lro')">
			<bdo>
				<xsl:attribute name="dir">
					<xsl:choose>
					<xsl:when test="@dir = 'rlo'">rtl</xsl:when>
					<xsl:otherwise>ltr</xsl:otherwise>
					</xsl:choose>
					</xsl:attribute>
				<xsl:apply-templates/>
				</bdo>
			</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>




<!-- *** CHECK AGAIN: We only use a single reference these days -->
<!-- prevlocs: previous locations for this spec 
called in a <dl> context from header 
Overridden to generate multiple <dd>s (one per loc) -->
  <xsl:template match="prevlocs">
    <dt >
      <xsl:text>Previous version</xsl:text>
      <xsl:if test="count(loc) &gt; 1">s</xsl:if>
      <xsl:text>:</xsl:text>
    </dt>
    <xsl:for-each select="loc">
      <dd >
        <xsl:apply-templates select="."/>
      </dd>
    </xsl:for-each>
  </xsl:template>


<!-- qchar
Specific to xmlspec-i18n. -->
<xsl:template match="qchar">
	<xsl:text>'</xsl:text>
	<span class="qchar">
		<xsl:call-template name="copy-common-atts"/>
		<xsl:apply-templates/>
		</span>
	<xsl:text>'</xsl:text>
  	</xsl:template>


<!-- qterm
Specific to xmlspec-i18n. -->
<xsl:template match="qterm">
	<xsl:text>'</xsl:text>
	<span class="qterm">
		<xsl:call-template name="copy-common-atts"/>
		<xsl:apply-templates/>
		</span>
	<xsl:text>'</xsl:text>
	</xsl:template>



<!-- quote
It would be nice to use HTML <q> elements, but browser support
is abysmal.
Added call to copy-common-atts.
Added span class="quote" to enable styling and xml:lang, etc. -->
<xsl:template match="quote">
	<xsl:text>"</xsl:text>
	<span class="quote">
		<xsl:call-template name="copy-common-atts"/>
		<xsl:apply-templates/>
		</span>
	<xsl:text>"</xsl:text>
  	</xsl:template>




<!-- req, req-list, req-type and reqtext: markup normative requirements of the spec 
Just pass some markup through for CSS to decorate -->
<xsl:template match="req">
	<span class="req" ><xsl:apply-templates></xsl:apply-templates></span>
	</xsl:template>

<xsl:template match="req-list">
	<p >
		<span class="req"><xsl:apply-templates select="req-type"></xsl:apply-templates></span>
		<span class="req"><xsl:apply-templates select="req-text"></xsl:apply-templates></span>
		</p>
	<div class="req" ><xsl:apply-templates select="./*[last()]"></xsl:apply-templates></div>
	</xsl:template>

<xsl:template match="req-type">
    <span class="requirement-type" ><xsl:text>[</xsl:text><xsl:value-of select="."></xsl:value-of><xsl:text>]</xsl:text></span><xsl:text> </xsl:text>
  </xsl:template>

<xsl:template match="req-text">
    <xsl:apply-templates></xsl:apply-templates>
  </xsl:template>



<!-- resource: an item in a resource list for a technique -->
<xsl:template match="resource">
	<div class="resource-item">
		<xsl:call-template name="copy-common-atts"/>
		<table><tr><td rowspan="2" class="resource-label"><xsl:value-of select="@resource-type"/></td>
			<td><xsl:apply-templates select="bibref" /><xsl:text> </xsl:text> <xsl:apply-templates select="loc" /></td></tr>
			<tr><td><xsl:value-of select="resource-descn" /></td></tr>
			</table>
		</div>
	</xsl:template>



<!-- resources: groups resource information for a technique -->
<xsl:template match="resources">
	<xsl:if test="resource">
	<div class="resources">
		<xsl:call-template name="copy-common-atts"/>
		<div class="small-head">Resources:</div>

		<xsl:if test="resource[@resource-type='background']">
			<h4 class="resource-first"><a>
				<xsl:attribute name="id">BI<xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:attribute name="name">BI<xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:text>Background information</xsl:text>
				</a></h4>
			<ul>
				<xsl:for-each select="resource[@resource-type='background']">
					<li><xsl:value-of select="resource-descn" /><br />
						<xsl:apply-templates select="bibref" /><xsl:text> </xsl:text> <xsl:apply-templates select="loc" />
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
			
		<xsl:if test="resource[@resource-type='implementation']">
			<h4><a>
				<xsl:attribute name="id">IG<xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:attribute name="name">IG<xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:text>How to's</xsl:text>
				</a></h4>
			<ul>
				<xsl:for-each select="resource[@resource-type='implementation']">
					<li><xsl:value-of select="resource-descn" /><br />
						<xsl:apply-templates select="bibref" /><xsl:text> </xsl:text> <xsl:apply-templates select="loc" />
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>

		<xsl:if test="resource[@resource-type='other']">
			<h4><a>
				<xsl:attribute name="id">RL<xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:attribute name="name">RL<xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:text>Reference links</xsl:text>
				</a></h4>
			<ul>
				<xsl:for-each select="resource[@resource-type='other']">
					<li><xsl:value-of select="resource-descn" /><br />
						<xsl:apply-templates select="bibref" /><xsl:text> </xsl:text> <xsl:apply-templates select="loc" />
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>

		<xsl:if test="resource[@resource-type='source']">
			<h4><a>
				<xsl:attribute name="id">S<xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:attribute name="name">S<xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:text>Sources</xsl:text>
				</a></h4>
			<ul>
				<xsl:for-each select="resource[@resource-type='source']">
					<li><xsl:value-of select="resource-descn" /><br />
						<xsl:apply-templates select="bibref" /><xsl:text> </xsl:text><xsl:apply-templates select="loc" />
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>

		<xsl:if test="resource[@resource-type='test']">
			<h4><a>
				<xsl:attribute name="id">T<xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:attribute name="name">T<xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:text>Test data</xsl:text>
				</a></h4>
			<ul>
				<xsl:for-each select="resource[@resource-type='test']">
					<li><xsl:value-of select="resource-descn" /><br />
						<xsl:apply-templates select="bibref" /><xsl:text> </xsl:text><xsl:apply-templates select="loc" />
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>

		<!--xsl:apply-templates /-->
		</div>
	</xsl:if>
	</xsl:template>



<!-- rfc2119: the terms MUST, SHOULD, etc. used in requirements
Replaced strong with span class="rfc2119" to allow more flexibility in presentation. -->
<xsl:template match="rfc2119">
	<span class="rfc2119">
		<xsl:apply-templates/>
		</span>
	</xsl:template>


	
<!-- see-also: an item in a resource list for a technique -->
<xsl:template match="see-also">
	<div class="resource-item">
		<xsl:call-template name="copy-common-atts"/>
		<table><tr><td><span class="resource-label">See also: </span></td>
			<td><xsl:apply-templates /></td></tr>
			</table>
		</div>
	</xsl:template>


<!-- short-name -->
<xsl:template match="short-name">
	<div class="short-name">
		<xsl:call-template name="copy-common-atts"/>
		<a href="#contents">
			<img src="images/topOfPage.gif" align="right" height="26" width="26" >
				<xsl:attribute name="title">
					<xsl:call-template name="parseString">
						<xsl:with-param name="stringID" select="'ESgototoc'" /> 
			 			</xsl:call-template>
					</xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:call-template name="parseString">
						<xsl:with-param name="stringID" select="'ESgototoc'" /> 
			 			</xsl:call-template>
					</xsl:attribute>
				</img>
			</a>
		<a>
			<xsl:attribute name="id"><xsl:value-of select="../@id"/></xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="../@id"/></xsl:attribute>
			<xsl:attribute name="href">#<xsl:value-of select="../@id"/></xsl:attribute>
			<xsl:call-template name="parseString">
				<xsl:with-param name="stringID" select="'technique'" /> 
				<xsl:with-param name="var1ID" select="'var1'" /> 
				<xsl:with-param name="var1Value">
  					<xsl:number count="geo-technique" level="any" /> 
  					</xsl:with-param>
	 			</xsl:call-template>
			<xsl:apply-templates />	
			</a>
		</div>
	</xsl:template>


<!-- short-name with mode toc -->
<xsl:template mode="toc" match="short-name">
	<li class="toc-technique" >
		<a>
			<xsl:attribute name="href">
				<xsl:text>#</xsl:text><xsl:value-of select="../@id"/>
				</xsl:attribute>
			<xsl:apply-templates/>
			</a>
		</li>
	</xsl:template>



<!-- spec: the specification itself 
Replaced langusage/language with call to copy-common-atts
Added encoding declaration
Added content associated with editors-copy
Added link to table of contents at top of page -->
<xsl:template match="spec">
	<html xmlns="http://www.w3.org/1999/xhtml">
		<xsl:call-template name="copy-common-atts"/>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<title>
				<xsl:apply-templates select="header/title"/>
				<xsl:if test="header/version">
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="header/version"/>
					</xsl:if>
				<xsl:if test="$additional.title != ''">
					<xsl:text> -- </xsl:text>
					<xsl:value-of select="$additional.title"/>
					</xsl:if>
				<xsl:if test="/spec/@role='editors-copy'">
					<xsl:text> -- (Editors' copy)</xsl:text>
					</xsl:if>
				</title>
			<xsl:call-template name="css"/>
			<xsl:call-template name="additional-head"/>
			<xsl:if test="/spec/@role='editors-copy'">
				<xsl:text disable-output-escaping="yes">&lt;script language="JavaScript" 
				src="redlining.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text>
        		</xsl:if>
			</head>
		<body>
			<xsl:if test="/spec/@role='editors-copy'">
				<xsl:attribute name="ondblclick">toggleRows();</xsl:attribute>
				<div><p>This document is an editor's copy.  It supports markup to identify 
					changes from a previous version. Two kinds of changes are highlighted: 
					<ins>new, added text</ins>, and <del>deleted text</del>.</p>
					</div>
				<div> 
					<div id="revisions"></div>
					<xsl:value-of select="//revisiondesc/p[1]"/>
					<script type="text/javascript">showButton()</script>
					</div>
				<hr /> 
				</xsl:if>
			<div style="text-align:center;">
				<p>[ <a href="#contents">contents</a> ]</p>
				</div>
			<xsl:apply-templates/>
			<xsl:if test="//footnote[not(ancestor::table)]">
				<hr />
				<div class="endnotes">
					<xsl:text>
</xsl:text>
					<h3>
						<xsl:call-template name="anchor">
							<xsl:with-param name="conditional" select="0"/>
							<xsl:with-param name="default.id" select="'endnotes'"/>
							</xsl:call-template>
						<xsl:text>End Notes</xsl:text>
						</h3>
					<dl>
						<xsl:apply-templates select="//footnote[not(ancestor::table)]" mode="notes"/>
						</dl>
					</div>
				</xsl:if>
			</body>
		</html>
	</xsl:template>



<!-- specref: reference to another part of teh current specification -->
<xsl:template match="specref">
	<xsl:param name="target" select="key('ids', @ref)[1]"/>
	
	<xsl:choose>
	<xsl:when test="not($target)">
		<xsl:message>
			<xsl:text>specref to non-existent ID: </xsl:text>
			<xsl:value-of select="@ref"/>
			</xsl:message>
		</xsl:when>
	<xsl:when test="local-name($target)='issue'
		or starts-with(local-name($target), 'div')
		or starts-with(local-name($target), 'inform-div')
		or local-name($target) = 'vcnote'
		or local-name($target) = 'prod'
		or local-name($target) = 'example'
		or local-name($target) = 'figure'
		or local-name($target) = 'geo-technique'
		or local-name($target) = 'label'
		or $target/self::item[parent::olist]">
		<xsl:apply-templates select="$target" mode="specref"/>
		</xsl:when>
	<xsl:otherwise>
		<xsl:message>
			<xsl:text>Unsupported specref to </xsl:text>
			<xsl:value-of select="local-name($target)"/>
			<xsl:text> [</xsl:text>
			<xsl:value-of select="@ref"/>
			<xsl:text>] </xsl:text>
			<xsl:text> (Contact stylesheet maintainer).</xsl:text>
			</xsl:message>
		<b>
			<a>
				<xsl:attribute name="href">
					<xsl:call-template name="href.target">
						<xsl:with-param name="target" select="key('ids', @ref)"/>
						</xsl:call-template>
					</xsl:attribute>
				<xsl:text>???</xsl:text>
				</a>
			</b>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- specref mode: div*
Replaced <b> with a class="section-ref" to allow alternative styling.
Added call to parseString to allow for additional text. -->
<xsl:template match="div1|div2|div3|div4|div5" mode="specref">
	<a class="section-ref">
		<xsl:attribute name="href">
			<xsl:call-template name="href.target"/>
			</xsl:attribute>
		<xsl:call-template name="parseString">
			<xsl:with-param name="stringID" select="'ESsection-ref'" /> 
			<xsl:with-param name="var1ID" select="'var1'" /> 
			<xsl:with-param name="var1Value">
				<xsl:apply-templates select="." mode="divnum"/>
				</xsl:with-param>
 			</xsl:call-template>
		<xsl:apply-templates select="head" mode="text"/>
		</a>
	</xsl:template>

<!-- specref mode: example
Rewritten because you cannot assume that examples have captions (head).
Added class="example-ref" to <a> to allow for alternative styling.
Replaced <xsl:text>Example</xsl:text> with call to parseString. -->
<xsl:template match="example" mode="specref">
	<xsl:variable name="id">
		<xsl:call-template name="object.id">
			<xsl:with-param name="node" select="."/>
			</xsl:call-template>
		</xsl:variable>

	<a class="example-ref" href="#{$id}">
		<xsl:value-of select="count(id(@id)/preceding::example) + 1"/>
		</a>
	</xsl:template>


<!-- specref mode: figure
Specific to xmlspec-i18n. -->
<xsl:template match="figure" mode="specref">
	<a class="figure-ref">
		<xsl:attribute name="href">
			<xsl:call-template name="href.target"/>
			</xsl:attribute>
		<xsl:value-of select="count(id(@id)/preceding::figure) + 1"/>
		</a>
	</xsl:template>


<!-- specref mode: geo-technique
Specific to xmlspec-i18n. -->
<xsl:template match="geo-technique" mode="specref">
	<a class="technique-ref">
		<xsl:attribute name="href">
			<xsl:call-template name="href.target"/>
			</xsl:attribute>
		<xsl:call-template name="parseString">
			<xsl:with-param name="stringID" select="'technique'" /> 
			<xsl:with-param name="var1ID" select="'var1'" /> 
			<xsl:with-param name="var1Value">
				<xsl:value-of select="count(id(@id)/preceding::geo-technique) + 1"/>
				</xsl:with-param>
 			</xsl:call-template>
		<xsl:value-of select="short-name"/>
		</a>
	</xsl:template>


 

<!-- *** CHECK AGAIN -->
<!-- strlist -->
<xsl:template match="strlist">
	</xsl:template>



<!-- tech-source: an item in a resource list for a technique -->
<xsl:template match="tech-source">
	<div class="resource-item">
		<xsl:call-template name="copy-common-atts"/>
		<table><tr><td><span class="resource-label">Source: </span></td>
			<td><xsl:apply-templates /></td></tr>
			</table>
		</div>
	</xsl:template>


<!-- term: the actual mention of a term within a termdef
Replaced <b> with span class="term" to allow for alternative styling.
Added call to copy-common-atts. -->
<xsl:template match="term">
	<span class="new-term">
		<xsl:call-template name="copy-common-atts"/>
		<xsl:apply-templates/>
		</span>
	</xsl:template>


  
<!-- toc mode: div1
Added <div class="toc1"> and removed <br />.
Added code to print geo-techniques, if any.
Added space after section number, because removed from divnum templates. -->
<xsl:template mode="toc" match="div1">
	<div class="toc1">
		<xsl:apply-templates select="." mode="divnum"/>
		<xsl:text> </xsl:text>
		<a>
			<xsl:attribute name="href">
				<xsl:call-template name="href.target">
					<xsl:with-param name="target" select="."/>
					</xsl:call-template>
				</xsl:attribute>
			<xsl:apply-templates select="head" mode="text"/>
			</a>
		<xsl:if test="geo-technique">
			<ul style="margin-top:0;margin-bottom:0;"><xsl:apply-templates 
				select="geo-technique/short-name" mode="toc"/></ul>
			</xsl:if>
		<xsl:if test="$toc.level &gt; 1">
			<xsl:apply-templates select="div2" mode="toc"/>
			</xsl:if>
		</div>
		<xsl:text>
</xsl:text>
	</xsl:template>




<!-- toc mode: div2
Replaced nbsps and <br/> with <div class="toc2"> so styling can be used for left margin
Added code to print geo-techniques, if any.
Added space after section number, because removed from divnum templates. -->
<xsl:template mode="toc" match="div2">
	<div class="toc2">
		<xsl:apply-templates select="." mode="divnum"/>
		<xsl:text> </xsl:text>
		<a>
			<xsl:attribute name="href">
				<xsl:call-template name="href.target">
					<xsl:with-param name="target" select="."/>
					</xsl:call-template>
				</xsl:attribute>
			<xsl:apply-templates select="head" mode="text"/>
			</a>
		<xsl:if test="geo-technique">
			<ul style="margin-top:0;margin-bottom:0;"><xsl:apply-templates 
				select="geo-technique/short-name" mode="toc"/></ul>
			</xsl:if>
		<xsl:if test="$toc.level &gt; 2">
			<xsl:apply-templates select="div3" mode="toc"/>
			</xsl:if>
		</div>
		<xsl:text>
</xsl:text>
	</xsl:template>





<!-- toc mode: div3
Replaced nbsps with <div class="toc3"> so styling can be used for left margin
Added code to print geo-techniques, if any.
Added space after section number, because removed from divnum templates. -->
<xsl:template mode="toc" match="div3">
	<div class="toc3">
		<xsl:apply-templates select="." mode="divnum"/>
		<xsl:text> </xsl:text>
		<a>
			<xsl:attribute name="href">
				<xsl:call-template name="href.target">
					<xsl:with-param name="target" select="."/>
					</xsl:call-template>
				</xsl:attribute>
			<xsl:apply-templates select="head" mode="text"/>
			</a>
		<xsl:if test="geo-technique">
			<ul style="margin-top:0;margin-bottom:0;"><xsl:apply-templates 
				select="geo-technique/short-name" mode="toc"/></ul>
			</xsl:if>
		<xsl:if test="$toc.level &gt; 3">
			<xsl:apply-templates select="div4" mode="toc"/>
			</xsl:if>
		</div>
	<xsl:text>
</xsl:text>
	</xsl:template>



<!-- toc mode: inform-div1
Replaced nbsps with <div class="toc1"> so styling can be used for left margin
Added space after section number, because removed from divnum templates. -->
<xsl:template mode="toc" match="inform-div1">
	<div class="toc1">
		<xsl:apply-templates select="." mode="divnum"/>
		<xsl:text> </xsl:text>
		<a>
			<xsl:attribute name="href">
				<xsl:call-template name="href.target">
					<xsl:with-param name="target" select="."/>
					</xsl:call-template>
				</xsl:attribute>
			<xsl:apply-templates select="head" mode="text"/>
			</a>
		<xsl:text> (Non-Normative)</xsl:text>
		<xsl:if test="$toc.level &gt; 2">
			<xsl:apply-templates select="div2" mode="toc"/>
			</xsl:if>
		</div>
	<xsl:text>
</xsl:text>
	</xsl:template>


<!-- ua-applicability: applicability of a technique to user agents -->
<xsl:template match="ua-applicability">
	<div class="applicability">
		<span class="applic-title">UA applicability issues: &#xa0; </span>
		<xsl:apply-templates/>
		</div>
	</xsl:template>
	
<xsl:template match="ua">
	<xsl:choose>
		<xsl:when test="@ua-name = 'ie'">IE(Win)&#xa0; </xsl:when>
		<xsl:when test="@ua-name = 'ff'">Firefox&#xa0; </xsl:when>
		<xsl:when test="@ua-name = 'moz'">Mozilla&#xa0; </xsl:when>
		<xsl:when test="@ua-name = 'op'">Opera&#xa0; </xsl:when>
		<xsl:when test="@ua-name = 'nn'">NNav&#xa0; </xsl:when>
		<xsl:when test="@ua-name = 'safari'">Safari&#xa0; </xsl:when>
		<xsl:when test="@ua-name = 'iem'">IE(Mac)&#xa0; </xsl:when>
		</xsl:choose>
	<xsl:choose>
		<xsl:when test="@version = 'nn'"><img src="images/nono.gif" alt="No issues"/>&#xa0; </xsl:when>
		<xsl:when test="@version = 'yn'"><img src="images/yesno.gif" alt="Issues with base version, but not latest"/>&#xa0; </xsl:when>
		<xsl:when test="@version = 'ny'"><img src="images/noyes.gif" alt="Issues with latest version, but not base"/>&#xa0; </xsl:when>
		<xsl:when test="@version = 'yy'"><img src="images/yesyes.gif" alt="Issues still to date"/>&#xa0; </xsl:when>
		<xsl:when test="@version = '?'">&#xa0; ? &#xa0; </xsl:when>
		<xsl:otherwise>Mozilla<span class="ver"><xsl:value-of select="moz/@version"/></span><xsl:text>&#xa0; </xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- ua-issues -->
<xsl:template match="ua-issues">
	<div class="ua-issues">
		<xsl:call-template name="copy-common-atts"/>
		<div class="small-head">User Agent Notes: </div>
			<xsl:apply-templates />
		</div>
	</xsl:template>


<!-- ua-issue -->
<xsl:template match="ua-issue">
	<div class="ua-issue">
		<xsl:call-template name="copy-common-atts"/>
		<table><tr><td class="ua-type"><xsl:value-of select="@name"/><xsl:value-of select="@version"/></td>
			<td><xsl:apply-templates /></td></tr>
			</table>
		</div>
	</xsl:template>



<!-- ulist
Rewritten to ensure that lists do not appear inside p elements in HTML. -->
<xsl:template match="ulist">
	<xsl:if test="$validity.hacks and (local-name(..) = 'p')">
		<xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
		</xsl:if>
	<ul >
		<xsl:apply-templates></xsl:apply-templates>
		</ul>
	<xsl:if test="$validity.hacks and (local-name(..) = 'p')">
		<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
		</xsl:if>
	</xsl:template>




<!-- uname
Specific to xmlspec-i18n. -->
<xsl:template match="uname">
    <span class="uname"><xsl:apply-templates/></span>
	</xsl:template>


<!-- xref-list -->
<xsl:template match="xref-list">
</xsl:template>


</xsl:transform>
