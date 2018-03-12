<?xml version="1.0" encoding="UTF-8"?>
<!-- Edited with Atova XLMSpy (x64) ver. 2011 rel. 2 (http://www.altova.com) by Jan Sigurd Dragsjø -->
<xsl:stylesheet version="1.0" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" 
	xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" 
	xmlns:m8="http://www.kith.no/xmlstds/eresept/m8/2010-06-07" 
	xmlns:ul="http://www.kith.no/xmlstds/eresept/utlevering/2010-05-01" 
	xmlns:xhtml="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="mh fk1 m8 ul xhtml">

<!-- Visningsfil for eReseptmeldingen: M8 Utleveringsrapport fastlege
Inngår i KITHs visningsfiler versjon 10

25-10-2016: La til variabel for visningsversjonnr
26-02-2011: Første versjon

MERK:
- Importerer visningsfil for hodemeldingen og felleskomponenten utlevering. -->

	<xsl:import href="../utlevering/utlevering-2html-v2.4.xsl"/>
	<xsl:import href="../../Hodemelding/v1.2/Hodemelding2html.xsl"/>
	
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" 
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

	<!-- Variabel for hvilken versjon av visningsfilen -->
	<xsl:variable name="versjon" select="'eresept-m8-2.4 v3.1.0'"/>

	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Utlevering</title>
				<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
				<style type="text/css"><xsl:value-of select="document('../../Felleskomponenter/KITH-visning.css')" disable-output-escaping="yes" /></style>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="m8:UtleveringsrapportFastlege">
		<xsl:apply-templates select="ul:Utlevering"/>
	</xsl:template>
	
</xsl:stylesheet>
