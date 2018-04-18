<?xml version="1.0" encoding="UTF-8"?>
<!-- Edited with Atova XLMSpy (x64) ver. 2011 rel. 2 (http://www.altova.com) by Jan Sigurd Dragsjø -->
<xsl:stylesheet version="1.0" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" 
	xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" 
	xmlns:m241="http://www.kith.no/xmlstds/eresept/m241/2009-02-20" 
	xmlns:m242="http://www.kith.no/xmlstds/eresept/m242/2008-10-03" 
	xmlns:xhtml="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="mh fk1 m241 m242 xhtml">

<!-- Visningsfil for eReseptmeldingen: M24.2 Svar på samtykke
Inngår i KITHs visningsfiler versjon 10

25-10-2016: La til variabel for visningsversjonnr
09-03-2011: Første versjon

MERK:
- Importerer visningsfil for hodemeldingen
- Man kan legge ved Samtykke (m24.1) som input-parameter -->

	<xsl:import href="../../Hodemelding/v1.2/Hodemelding2html.xsl"/>
	
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" 
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	
	<xsl:param name="vedlegg"/>

	<!-- Variabel for hvilken versjon av visningsfilen -->
	<xsl:variable name="versjon" select="'eresept-m24 v3.1.0 '"/>

	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Svar på samtykke</title>
				<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
				<style type="text/css"><xsl:value-of select="document('../../Felleskomponenter/KITH-visning.css')" disable-output-escaping="yes" /></style>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="m242:SvarSamtykke">
		<h1>Svar på samtykke</h1>
		<table>
			<tbody>
				<tr>
					<th width="25%">Svar</th>
					<xsl:if test="m242:Begrunnelse/@DN"><th width="25%">Begrunnelse</th></xsl:if>
				</tr>
				<tr>
					<td width="25%"><xsl:value-of select="m242:Svar/@DN"/></td>
					<xsl:if test="m242:Begrunnelse/@DN"><td width="25%"><xsl:value-of select="m242:Begrunnelse/@DN"/></td></xsl:if>
				</tr>
			</tbody>
		</table>
		<p/>
		<xsl:if test="string-length($vedlegg) != 0 and count($vedlegg//m241:Samtykke) != 0">
			<h1>
				<xsl:choose>
					<xsl:when test="$vedlegg//m241:Samtykke/m241:Samtykkeverdi/@V = 2">Sletting av samtykke</xsl:when>
					<xsl:otherwise>Samtykke</xsl:otherwise>
				</xsl:choose>
			</h1>
			<table>
				<tbody>
					<tr>
						<th width="25%">Samtykke gitt av</th>
						<th width="25%">Gyldig til</th>
						<th width="25%">Type</th>
					</tr>
					<tr>
						<td width="25%"><xsl:value-of select="$vedlegg//m241:Samtykke/m241:SamtykkeGittAv/@DN"/></td>
						<td width="25%"><xsl:value-of select="$vedlegg//m241:Samtykke/m241:SamtykkeTil"/></td>
						<td width="25%"><xsl:value-of select="$vedlegg//m241:Samtykke/m241:TypeSamtykke/@DN"/></td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
