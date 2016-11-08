<?xml version="1.0" encoding="UTF-8"?>
<!-- Edited with Atova XLMSpy (x64) ver. 2013 rel.2  sp.2 (http://www.altova.com) by Jan Sigurd Dragsjø - avd. Standardisering, Helsedirektoratet-->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" xmlns:m7="http://www.kith.no/xmlstds/eresept/m7/2008-05-01" xmlns:m5v2.5="http://www.kith.no/xmlstds/eresept/m5/2013-04-16" xmlns:bas="http://www.kith.no/xmlstds/base64container" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="mh m7 m5v2.5 bas xhtml">

<!-- Visningsfil for eReseptmeldingen: M7 Slettet resept i RF
Inngår i Hdirs visningsfiler versjon 1

17-08-2013: versjon for eResept v2.5
28-02-2011: versjon for eResept v2.4 
-->
	<xsl:import href="../m5/m5-2html-v2.5.xsl"/>
	<xsl:import href="../../Felleskomponenter/meldingshode2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../../Felleskomponenter/base64decoder.xsl"/>
	
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	
	<!-- Variabel for hvilken stil visningen har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'One-line-doc'"/>
	
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Slettet resept i RF</title>
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
	
	<xsl:template name="Innhold" match="m7:SlettetReseptRF">
		<div class="{$stil}">
			<xsl:for-each select="//m7:SlettetReseptRF">
				<h1>Slettet resept i RF</h1>
				<table>
					<tbody>
						<xsl:if test="m7:Tidspunkt">
							<tr>
								<th>Tidspunkt</th>
							</tr>
							<tr>
								<td><xsl:call-template name="skrivUtDateTime"><xsl:with-param name="oppgittTid" select="m7:Tidspunkt"></xsl:with-param></xsl:call-template></td>
							</tr>
						</xsl:if>
					</tbody>
				</table>
			</xsl:for-each>
		</div>
		<xsl:if test="//bas:Base64Container or //m5v2.5:Tilbakekalling">
			<xsl:if test="//bas:Base64Container">
				<div class="{$stil}">
					<h1>Tilbakekalling&#160;av&#160;resept</h1>
					<table>
						<tbody>
							<xsl:for-each select="//bas:Base64Container">
								<xsl:variable name="konvertertBase64">
									<xsl:call-template name="convertBase64ToAscii">
										<xsl:with-param name="base64String" select="."/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="tilbakekalling">
									<xsl:value-of select="substring-after(substring-before($konvertertBase64, '&lt;/Tilbakekalling&gt;'),'&lt;Tilbakekalling')"/>
								</xsl:variable>
								<tr>
									<xsl:if test="contains($tilbakekalling, 'Arsak')">
										<th width="25%">Årsak</th>
									</xsl:if>
									<xsl:if test="contains($tilbakekalling, 'Merknad')">
										<th width="25%">Begrunnelse</th>
									</xsl:if>
								</tr>
								<tr>
									<xsl:if test="contains($tilbakekalling, 'Arsak')">
										<xsl:variable name="Arsak">
											<xsl:value-of select="substring-before(substring-after($konvertertBase64, '&lt;Arsak'),'/')"/>
										</xsl:variable>
										<td width="25%">
											<xsl:choose>
												<xsl:when test="contains($Arsak, 'OT')">
													<xsl:value-of select="substring-before(substring-after($konvertertBase64, 'OT=&quot;'),'&quot;')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="substring-before(substring-after($konvertertBase64, 'DN=&quot;'),'&quot;')"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</xsl:if>
									<xsl:if test="contains($tilbakekalling, 'Merknad')">
										<td width="25%">
											<xsl:value-of select="substring-after(substring-before($konvertertBase64, '&lt;/Merknad&gt;'),'&lt;Merknad&gt;')"/>
										</td>
									</xsl:if>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</xsl:if>
		
			<xsl:for-each select="//m5v2.5:Tilbakekalling">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</xsl:if>

	</xsl:template>
	
</xsl:stylesheet>
