<?xml version="1.0" encoding="UTF-8"?>
<!-- Edited with Atova XLMSpy (x64) ver. 2013 rel.2  sp.2 (http://www.altova.com) by Jan Sigurd Dragsjø - avd. Standardisering, Helsedirektoratet-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" xmlns:m273="http://www.kith.no/xmlstds/eresept/m273/2012-06-11" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="mh m273">

<!-- Visningsfil for eReseptmeldingen: M27.3 Registrering av multidoseansvarlig gruppe
Inngår i Hdirs visningsfiler versjon 1

01-09-2013: versjon for eResept v2.5
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
				<title>M273</title>
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
	
	<xsl:template name="Innhold" match="m273:M273">
		<div class="{$stil}">
			<xsl:for-each select="//m273:M273">
				<h1>Registrering&#160;av&#160;multidoseansvarlig&#160;gruppe</h1>
				<table>
					<tbody>
						<xsl:if test="m273:Status or m273:GjelderFra or m273:GruppeId">
							<tr>
								<xsl:if test="m273:Status">
									<th width="20%">Status</th>
								</xsl:if>
								<xsl:if test="m273:GjelderFra">
									<th width="20%">Gjelder&#160;fra</th>
								</xsl:if>
								<xsl:if test="m273:GruppeId">
									<th width="20%">Gruppe-id</th>
								</xsl:if>
							</tr>
							<tr>
								<xsl:if test="m273:Status">
									<td width="20%">
										<xsl:for-each select="m273:Status">
											<xsl:choose>
												<xsl:when test="@DN"><xsl:value-of select="@DN"/></xsl:when>
												<xsl:otherwise><xsl:call-template name="k-7496"/></xsl:otherwise>											
											</xsl:choose>
										</xsl:for-each>
									</td>
								</xsl:if>
								<xsl:if test="m273:GjelderFra">
									<td width="20%">
										<xsl:call-template name="skrivUtDate">
											<xsl:with-param name="oppgittTid" select="m273:GjelderFra"/>
										</xsl:call-template>
									</td>
								</xsl:if>
								<xsl:if test="m273:GruppeId">
									<td width="20%">
										<xsl:value-of select="m273:GruppeId"/>
									</td>
								</xsl:if>
							</tr>
						</xsl:if>
					</tbody>
				</table>
				<xsl:if test="m273:Pasient">
					<h2>Pasienter</h2>
					<table>
						<tbody>
							<tr>
								<xsl:if test="m273:Pasient/m273:Fnr">
									<th width="20%">Fødselsnummer</th>
								</xsl:if>
							</tr>
							<xsl:for-each select="m273:Pasient">
								<tr>
									<xsl:if test="m273:Fnr">
										<td width="20%"><xsl:value-of select="m273:Fnr"/></td>
									</xsl:if>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
			</xsl:for-each>
		</div>
	</xsl:template>
	<!-- Kodeverk -->
	<xsl:template name="k-7496">
		<xsl:choose>
			<xsl:when test="@V='R'">Registrering</xsl:when>
			<xsl:when test="@V='A'">Avregistrering</xsl:when>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
