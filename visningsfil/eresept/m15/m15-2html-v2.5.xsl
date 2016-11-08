<?xml version="1.0" encoding="UTF-8"?>
<!-- Edited with Atova XLMSpy (x64) ver. 2013 rel.2  sp.2 (http://www.altova.com) by Jan Sigurd Dragsjø - avd. Standardisering, Helsedirektoratet-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" xmlns:m15="http://www.kith.no/xmlstds/eresept/m15/2006-10-06" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="mh m15">

<!-- Visningsfil for eReseptmeldingen: M15 Søknadssvar fra SLV
Inngår i Hdirs visningsfiler versjon 1

26-08-2013: versjon for eResept v2.5
-->

	<xsl:import href="../../Felleskomponenter/meldingshode2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../../Felleskomponenter/kodeverk.xsl"/>
	
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
		
	<!-- Variabel for hvilken stil visningen har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'One-line-doc'"/>
	
	
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>SvarSLV</title>
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
	
	<xsl:template name="Innhold" match="m15:SvarSLV">
		<div class="{$stil}">
			<xsl:for-each select="//m15:SvarSLV">
				<h1>Søknadssvar&#160;fra&#160;SLV</h1>
				<table>
					<tbody>
						<xsl:if test="m15:Innvilget or m15:BegrunnelseAvslag or m15:Saksbehandler">
							<tr>
								<xsl:if test="m15:Innvilget">
									<th width="25%">Innvilget</th>
								</xsl:if>
								<xsl:if test="m15:BegrunnelseAvslag">
									<th width="25%">Begrunnelse</th>
								</xsl:if>
								<xsl:if test="m15:Saksbehandler">
									<th width="25%">Saksbehandler</th>
								</xsl:if>
							</tr>
							<tr>
								<xsl:if test="m15:Innvilget">
									<td width="25%">
										<xsl:choose>
											<xsl:when test="m15:Innvilget/@V='1'">Ja</xsl:when>
											<xsl:otherwise>Nei</xsl:otherwise>
										</xsl:choose>
									</td>
								</xsl:if>
								<xsl:if test="m15:BegrunnelseAvslag">
									<td width="25%">
										<xsl:value-of select="m15:BegrunnelseAvslag"/>
									</td>
								</xsl:if>
								<xsl:if test="m15:Saksbehandler">
									<td width="25%">
										<xsl:value-of select="m15:Saksbehandler"/>
									</td>
								</xsl:if>
							</tr>
						</xsl:if>
					</tbody>
				</table>
			</xsl:for-each>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
