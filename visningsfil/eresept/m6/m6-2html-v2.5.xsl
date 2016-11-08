<?xml version="1.0" encoding="UTF-8"?>
<!-- Edited with Atova XLMSpy (x64) ver. 2013 rel.2  sp.2 (http://www.altova.com) by Jan Sigurd Dragsjø - avd. Standardisering, Helsedirektoratet-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" xmlns:m6="http://www.kith.no/xmlstds/eresept/m6/2013-10-08" xmlns:ul="http://www.kith.no/xmlstds/eresept/utlevering/2013-10-08" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="mh fk1 m6 ul xhtml">

<!-- Visningsfil for M6 Utleveringsrapport forskriver -->
<!-- Endringslogg
	- 04.11.13 - Endret namespace for m6 og ul -->

	<xsl:import href="../utlevering/utlevering-2html-v2.5.xsl"/>
	<xsl:import href="../../Felleskomponenter/meldingshode2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/funksjoner.xsl"/>
	
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	
	<!-- Variabel for hvilken stil visningen har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'One-line-doc'"/>
	
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Utlevering</title>
				<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
				<style type="text/css"><xsl:value-of select="document('../../Felleskomponenter/KITH-visning.css')" disable-output-escaping="yes" /></style>
			</head>
			<body>
				<xsl:apply-templates select="mh:MsgHead"/>
			</body>
		</html>
	</xsl:template>
	
	<!-- Visning av meldingshodet. Tilpasset vinduskonvolutt ved utskrift -->
	<xsl:template match="mh:MsgHead">
		<xsl:call-template name="Topp"/>
		<xsl:call-template name="Innhold"/>
		<xsl:choose>
			<!-- Inngang for å komponere egen bunn i EgetBunnTillegg nedenfor. Foreløpig hoppes den over -->
			<xsl:when test="not(1)">
				<xsl:call-template name="BunnTillegg">
					<xsl:with-param name="stil" select="$stil"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="Bunn">
					<xsl:with-param name="stil" select="$stil"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Template som kalles fra BunnTillegg i meldingshodet. Kan brukes til visning av egenkomponert bunn -->
	<xsl:template name="EgetBunnTillegg">
	</xsl:template>
	
	<xsl:template name="Innhold" match="m6:UtleveringsrapportRekvirent">
		<div class="{$stil}">
			<xsl:for-each select="//m6:UtleveringsrapportRekvirent">
				<xsl:apply-templates select="ul:Utlevering"/>
			</xsl:for-each>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
