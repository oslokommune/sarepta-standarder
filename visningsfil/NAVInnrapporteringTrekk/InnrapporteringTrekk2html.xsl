<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" xmlns:ivt="http://www.kith.no/xmlstds/nav/innrapporteringtrekk/2010-02-04" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="fk1 ivt mh xhtml">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="no" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	<!--	Visningsfil for Innrapportering av vederlagstrekk til NAV
		30.10.2010: Første versjon
	-->
	<xsl:include href="../../Hodemelding/v1.2/Hodemelding2html.xsl"/>
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Innrapportering av vederlagstrekk</title>
				<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
				<style type="text/css"><xsl:value-of select="document('../../Felleskomponenter/KITH-visning.css')" disable-output-escaping="yes" /></style>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="ivt:InnrapporteringTrekk">
		<h1><xsl:if test="//mh:MsgInfo/mh:Type/@V='INNRAPPORTERING_TREKK_RETUR'">Retur&#160;-&#160;</xsl:if>Innrapportering av vederlagstrekk<xsl:apply-templates select="ivt:Aksjonskode"/></h1>
		<xsl:apply-templates select="ivt:Identifisering"/>
		<xsl:apply-templates select="ivt:Trekk"/>
		<xsl:apply-templates select="ivt:Periode"/>
		<xsl:apply-templates select="ivt:Kreditor"/>
	</xsl:template>
	<xsl:template match="ivt:Identifisering">
		<h3>Identifisering</h3>
		<div class="Box">
			<div class="Block">
				<div class="MainCaption">Kreditors trekk-ID</div>
				<div class="MainContent"><xsl:value-of select="ivt:KreditorTrekkId"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">NAVs trekk-ID</div>
				<div class="MainContent"><xsl:value-of select="ivt:NavTrekkId"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">Debitors ID (<xsl:value-of select="ivt:DebitorId/fk1:TypeId/@V"/>)</div>
				<div class="MainContent"><xsl:value-of select="ivt:DebitorId/fk1:Id"/></div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="ivt:Trekk">
		<h3>Trekk</h3>
		<div class="Box">
			<div class="Block">
				<div class="MainCaption">Kode trekktype</div>
				<div class="MainContent"><xsl:apply-templates select="ivt:KodeTrekktype"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">Kode trekk alternativ</div>
				<div class="MainContent"><xsl:apply-templates select="ivt:KodeTrekkAlternativ"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">Sats (<xsl:value-of select="ivt:Sats/@U"/>)</div>
				<div class="MainContent"><xsl:value-of select="ivt:Sats/@V"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">Saldo (<xsl:value-of select="ivt:Saldo/@U"/>)</div>
				<div class="MainContent"><xsl:value-of select="ivt:Saldo/@V"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">Gyldig t.o.m. dato</div>
				<div class="MainContent"><xsl:value-of select="ivt:GyldigTomDato"/></div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="ivt:Periode">
		<h3>Periode</h3>
		<div class="Box">
			<div class="Block">
				<div class="MainCaption">Periode f.o.m. dato</div>
				<div class="MainContent"><xsl:value-of select="ivt:PeriodeFomDato"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">Periode t.o.m. dato</div>
				<div class="MainContent"><xsl:value-of select="ivt:PeriodeTomDato"/></div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="ivt:Kreditor">
		<h3>Kreditor</h3>
		<div class="Box">
			<div class="Block">
				<div class="MainCaption">ID TSS</div>
				<div class="MainContent"><xsl:value-of select="ivt:TSSId"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">Organisasjonsnr. (<xsl:value-of select="ivt:OrgNr/fk1:TypeId/@V"/>)</div>
				<div class="MainContent"><xsl:value-of select="ivt:OrgNr/fk1:Id"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">Navn</div>
				<div class="MainContent"><xsl:value-of select="ivt:Navn"/></div>
			</div>
			<div class="Block" style="clear:left">
				<div class="MainCaption">Adresse</div>
				<div class="MainContent"><xsl:value-of select="ivt:Adresse/fk1:StreetAdr"/><xsl:if test="ivt:Adresse/fk1:StreetAdr">,&#160;</xsl:if><xsl:value-of select="ivt:Adresse/fk1:PostalCode"/>&#160;<xsl:value-of select="ivt:Adresse/fk1:City"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">Referanse</div>
				<div class="MainContent"><xsl:value-of select="ivt:Ref"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">Kontonr.</div>
				<div class="MainContent"><xsl:value-of select="ivt:Kontonr"/></div>
			</div>
			<div class="Block">
				<div class="MainCaption">KID</div>
				<div class="MainContent"><xsl:value-of select="ivt:KID"/></div>
			</div>
		</div>
	</xsl:template>
	<!-- Kodeverk -->
	<xsl:template match="ivt:Aksjonskode">&#160;-&#160;
		<xsl:choose>
			<xsl:when test="@V='NY'">Nytt trekk</xsl:when>
			<xsl:when test="@V='ENDR'">Endring</xsl:when>
			<xsl:when test="@V='KANS'">Kreditor trekk</xsl:when>
			<xsl:when test="@V='OPPH'">Opphør</xsl:when>
		</xsl:choose> 
	</xsl:template>
	<xsl:template match="ivt:KodeTrekktype">
		<xsl:choose>
			<xsl:when test="@V='VEDE'">Vederlagstrekk</xsl:when>
			<xsl:when test="@V='FAGF'">Fagforeningstrekk</xsl:when>
			<xsl:when test="@V='KRED'">Kansellering av perioder</xsl:when>
			<xsl:when test="@V='PSKT'">Påleggstrekk skatt</xsl:when>
			<xsl:when test="@V='RSOS'">Refusjonskrav fra sosialkontor</xsl:when>
			<xsl:when test="@V='BSKT'">Kreditor disponerer</xsl:when>
		</xsl:choose> 
	</xsl:template>
	<xsl:template match="ivt:KodeTrekkAlternativ">
		<xsl:choose>
			<xsl:when test="@V='SALP'">Saldotrekk som trekker oppgitt prosent av ytelsen</xsl:when>
			<xsl:when test="@V='SALD'">Saldotrekk dagsats, beregnes ihht ytelses perioden</xsl:when>
			<xsl:when test="@V='SALM'">Saldotrekk månedsats</xsl:when>
			<xsl:when test="@V='LOPP'">Løpende trekk som trekker oppgitt prosent av ytelsen</xsl:when>
			<xsl:when test="@V='LOPD'">Løpende dagsats, beregnes ihht ytelses perioden</xsl:when>
			<xsl:when test="@V='LOPM'">Løpende månedsats</xsl:when>
		</xsl:choose> 
	</xsl:template>

</xsl:stylesheet>
