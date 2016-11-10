<?xml version="1.0" encoding="UTF-8"?>
<!-- Edited with Atova XLMSpy (x64) ver. 2013 rel.2  sp.2 (http://www.altova.com) by Jan Sigurd Dragsjø - avd. Standardisering, Helsedirektoratet-->
<xsl:stylesheet version="1.0" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" 
	xmlns:m28="http://www.kith.no/xmlstds/eresept/m28/2012-06-11" 
	xmlns:m274="http://www.kith.no/xmlstds/eresept/m274/2012-06-11" 
	exclude-result-prefixes="mh m28 m274">

<!-- Visningsfil for eReseptmeldingen: M28 Endring av multidoseansvarlig lege
Inngår i Hdirs visningsfiler versjon 1

25-10-2016: La til visningsversjonnr
02-09-2013: versjon for eResept v2.5
-->

	<xsl:import href="../../Felleskomponenter/meldingshode2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../../Felleskomponenter/kodeverk.xsl"/>
	<xsl:import href="../m27/m274-2html-v2.5.xsl"/>
	
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" 
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
		
	<!-- Variabel for hvilken stil visningen har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'One-line-doc'"/>
	
	<!-- Variabel for hvilken versjon av visningsfilen -->
	<xsl:variable name="versjon" select="'eresept-m28-2.5 v3.1.0 '"/>
	
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>M28</title>
				<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
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
					<xsl:with-param name="versjon" select="$versjon"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="Bunn">
					<xsl:with-param name="stil" select="$stil"/>
					<xsl:with-param name="versjon" select="$versjon"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Template som kalles fra BunnTillegg i meldingshodet. Kan brukes til visning av egenkomponert bunn -->
	<xsl:template name="EgetBunnTillegg">
	</xsl:template>
	
	<xsl:template name="Innhold" match="m28:M28">
		<div class="{$stil}">
			<xsl:for-each select="//m28:M28">
				<h1>Endring&#160;av&#160;multidoseansvarlig&#160;lege</h1>
				<table>
					<tbody>
						<xsl:if test="m28:AktivFra">
							<tr>
								<xsl:if test="m28:AktivFra">
									<th width="20%">Aktiv&#160;fra</th>
								</xsl:if>
							</tr>
							<tr>
								<xsl:if test="m28:AktivFra">
									<td width="20%">
										<xsl:call-template name="skrivUtDate">
											<xsl:with-param name="oppgittTid" select="m28:AktivFra"/>
										</xsl:call-template>
									</td>
								</xsl:if>
							</tr>
						</xsl:if>
					</tbody>
				</table>
				<xsl:if test="m274:Multidoselege">
					<h2>Multidoselege</h2>
					<table>
						<tbody>
							<tr>
								<xsl:apply-templates select="m274:Multidoselege" mode="overskrift"/>
							</tr>
							<tr>
								<xsl:apply-templates select="m274:Multidoselege" mode="innhold"/>
							</tr>
						</tbody>
					</table>
				</xsl:if>
			</xsl:for-each>
		</div>
	</xsl:template>
</xsl:stylesheet>
