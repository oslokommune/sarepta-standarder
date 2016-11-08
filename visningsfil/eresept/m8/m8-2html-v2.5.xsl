<?xml version="1.0" encoding="UTF-8"?>
<!-- Edited with Atova XLMSpy (x64) ver. 2013 rel.2  sp.2 (http://www.altova.com) by Jan Sigurd Dragsjø - avd. Standardisering, Helsedirektoratet-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" xmlns:m8="http://www.kith.no/xmlstds/eresept/m8/2013-10-08" xmlns:m1v2.4="http://www.kith.no/xmlstds/eresept/m1/2010-05-01" xmlns:m1v2.5="http://www.kith.no/xmlstds/eresept/m1/2013-10-08" xmlns:ul="http://www.kith.no/xmlstds/eresept/utlevering/2013-10-08" xmlns:bas="http://www.kith.no/xmlstds/base64container" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="mh fk1 m8 m1v2.4 m1v2.5 ul bas xhtml">

<!-- Visningsfil for M8 Utleveringsrapport fastlege -->
<!-- Endringslogg
	- 04.11.13 - Endret namespace for m1-v2.5, m8 og ul -->
<!-- Bruk
	- Visningen håndterer visning av vedlagte resepter v2.4 og v2.5 (vanlig xml)
	- Visningen håndterer foreløpig ikke dekoding og visning av vedlagte resepter som er base64-kodet -->

	<xsl:import href="../utlevering/utlevering-2html-v2.5.xsl"/>
	<xsl:import href="../m1/m1-2html-v2.4.xsl"/>
	<xsl:import href="../m1/m1-2html-v2.5.xsl"/>
	<xsl:import href="../../Felleskomponenter/meldingshode2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../../Felleskomponenter/base64decoder.xsl"/>
	
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
			<!-- Inngang for å komponere egen bunn i EgetBunnTillegg nedenfor. -->
			<xsl:when test="//m8:Papirresept">
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
		<tr>
			<th>Papirresept</th>
			<td>
				<xsl:choose>
					<xsl:when test="//m8:Papirresept='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	
	
	<xsl:template name="Innhold" match="m8:UtleveringsrapportFastlege">
		<div class="{$stil}">
			<xsl:for-each select="//m8:UtleveringsrapportFastlege">
				<xsl:apply-templates select="ul:Utlevering"/>
				<xsl:apply-templates select="ul:RekvirentPapir"/>
			</xsl:for-each>
		</div>
		<xsl:if test="//bas:Base64Container or //m1v2.5:Resept or //m1v2.4:Resept">
			<xsl:if test="//bas:Base64Container">
				<div class="{$stil}">
					<h2>Vedlagt resept</h2>
					<table>
						<tbody>
							<tr>
								<th colspan="3">Ingen visning av vedlagt resept grunnet base-64-kode</th>
							</tr>
						</tbody>
					</table>
				</div>
			</xsl:if>
			<xsl:for-each select="//m1v2.5:Resept">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
			<xsl:for-each select="//m1v2.4:Resept">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
