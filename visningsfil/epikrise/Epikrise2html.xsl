<?xml version="1.0" encoding="utf-8"?>
	<!-- Endringslogg
	- 10.11.16: Ny versjonsuavhengig visning
	- 01.11.16: Justeringer av layout etter innspill fra brukere. Bl.a.: Vurdering og Videre oppfølging plassert langt oppe og med grå bakgrunn.
	- 12.05.16: Komplettering av Helsetjenesteenheter-tabellen
	- 05.11.15: Innføring av felles kodeverksfil
	- 01.04.12: Første versjon
	-->
	<!-- Design
	- Ingen tomme felt så langt det lar seg gjøre
	- Radene strekkes alltid til full kolonnebredde (bortsett fra enkelte overskrifter) vha formelen:	<td colspan="{(($col)-1-count(<elementer foran>)*2)*number(not(<elementer bak>))+1}">
		- Om det gjenstår elementer bak i raden ( number(not(<elementer bak>))=0 ) gir formelen:	<td colspan="1"> (multipliserer med 0 slik at bare "1" gjenstår)
		- Om det ikke er elementer bak beregner formelen - utfra antall elementer foran i raden - antall kolonner som gjenstår til kolonnebredden ($col) er nådd.
		- Ett-tallene oppveier hverandre
	- Klikkbar menylinje
	- Headervisning avhengig av utskriftsmedium
	- Kommentarer for ofte tildelt fulle rader
	-->
	<!-- Om
	- Laget i XMLSpy v2016 (http://www.altova.com) av Jan Sigurd Dragsjø (nhn.no)
	-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:base="http://www.kith.no/xmlstds/base64container" exclude-result-prefixes="xhtml base">

	<!-- Import. Stien tilrettelegger for katalogstruktur med en meldings-katalog med versjons-kataloger inni. Sti må endres om slik struktur ikke benyttes -->
	<xsl:import href="../Felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../Felleskomponenter/kodeverk.xsl"/>
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="no" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	
	<!-- Variabel for hvilken stil visning har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'No-line-doc'"/>
	
	<!-- Variabel for hvilken versjon av visningsfilen -->
	<xsl:variable name="versjon" select="'v4.0.0 versjonsuavhengig'"/>
	
	<!-- Variabeler for standard antall kolonner i tabellene, og for standard cellebredde i tabellene -->
	<xsl:variable name="std-col" select="8"/>
	<xsl:variable name="std-td" select="200"/>
	
	<!-- Variabler for beregning av colspan i legemiddel-tabellen -->
	<xsl:variable name="med-stat-col" select="(($std-col)-2)*number(not(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;UnitDose&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;QuantitySupplied&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;CounterSDosageTextignDate&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;IntendedDuration&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]))+1"/>
	<xsl:variable name="med-unit-col" select="(($std-col)-3)*number(not(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;DosageText&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;IntendedDuration&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]))+1"/>
	<xsl:variable name="med-text-col" select="(($std-col)-3-number(boolean(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;UnitDose&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;QuantitySupplied&quot;])))*number(not(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]))+1"/>
	<xsl:variable name="med-com-col" select="(($std-col)-3-number(boolean(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;UnitDose&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;QuantitySupplied&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;DosageText&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;IntendedDuration&quot;])))*number(not(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]))+1"/>
	<xsl:variable name="med-sdate-col" select="(($std-col)-3-number(boolean(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;UnitDose&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;QuantitySupplied&quot;]))-number(boolean(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;DosageText&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;IntendedDuration&quot;]))-number(boolean(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;Comment&quot;])))*number(not(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]))+1"/>
	<xsl:variable name="med-edate-col" select="(($std-col)-3-number(boolean(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;UnitDose&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;QuantitySupplied&quot;]))-number(boolean(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;DosageText&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;IntendedDuration&quot;]))-number(boolean(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;Comment&quot;]))-number(boolean(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;])))*number(not(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]))+1"/>
	<xsl:variable name="med-odate-col" select="(($std-col)-2-number(boolean(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;UnitDose&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;QuantitySupplied&quot;]))-number(boolean(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;DosageText&quot;] | //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;IntendedDuration&quot;]))-number(boolean(//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;Comment&quot;]))-number(boolean(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;]))-number(boolean(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;])))"/>
	
	<!-- Variabler for beregning av colspan i resultat-tabellen -->
	<xsl:variable name="res-res-col" select="(($std-col)-2)*number(not(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DevResultInd&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;InvDate&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]))+1"/>
	<xsl:variable name="res-dev-col" select="(($std-col)-3)*number(not(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;InvDate&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]))+1"/>
	<xsl:variable name="res-idate-col" select="(($std-col)-3-number(boolean(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DevResultInd&quot;])))*number(not(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]))+1"/>
	<xsl:variable name="res-sdate-col" select="(($std-col)-3-number(boolean(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DevResultInd&quot;]))-number(boolean(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;InvDate&quot;])))*number(not(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]))+1"/>
	<xsl:variable name="res-edate-col" select="(($std-col)-3-number(boolean(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DevResultInd&quot;]))-number(boolean(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;InvDate&quot;]))-number(boolean(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;])))*number(not(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]))+1"/>
	<xsl:variable name="res-odate-col" select="(($std-col)-2-number(boolean(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DevResultInd&quot;]))-number(boolean(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;InvDate&quot;]))-number(boolean(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;]))-number(boolean(//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;])))"/>
	
	<!-- Variabler for beregning av colspan i hendelser-tabellen -->
	<xsl:variable name="event-type-col" select="(($std-col)-1)*number(not(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;EventLocation&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;ReportedEvent&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;ExpDuration&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;AdmOutcome&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;Priority&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;AssRequest&quot;]))+1"/>
	<xsl:variable name="event-place-col" select="(($std-col)-2)*number(not(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;ReportedEvent&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;ExpDuration&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;AdmOutcome&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;Priority&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;AssRequest&quot;]))+1"/>
	<xsl:variable name="event-time-col" select="(($std-col)-2-number(boolean(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;EventLocation&quot;])))*number(not(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;AdmOutcome&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;Priority&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;AssRequest&quot;]))+1"/>
	<xsl:variable name="event-out-col" select="(($std-col)-2-number(boolean(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;EventLocation&quot;]))-number(boolean(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;ReportedEvent&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;ExpDuration&quot;])))*number(not(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;Priority&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;AssRequest&quot;]))+1"/>
	<xsl:variable name="event-pri-col" select="(($std-col)-2-number(boolean(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;EventLocation&quot;]))-number(boolean(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;ReportedEvent&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;ExpDuration&quot;]))-number(boolean(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;AdmOutcome&quot;])))*number(not(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;AssRequest&quot;]))+1"/>
	<xsl:variable name="event-ass-col" select="(($std-col)-1-number(boolean(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;EventLocation&quot;]))-number(boolean(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;ReportedEvent&quot;] | //child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;ExpDuration&quot;]))-number(boolean(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;AdmOutcome&quot;]))-number(boolean(//child::*[local-name()=&quot;Event&quot;]/child::*[local-name()=&quot;Priority&quot;])))"/>
	
	<!-- Boolske variabler for visning av 'Vis/Skjul' knapp ved hver overskrift. Settes til 'true()' om knappen skal vises -->
	<xsl:variable name="VisDiagnoserVisSkjul" select="false()"/>
	<xsl:variable name="VisVurderingVisSkjul" select="false()"/>
	<xsl:variable name="VisVidereOppfolgingVisSkjul" select="false()"/>
	<xsl:variable name="VisCAVEVisSkjul" select="false()"/>
	<xsl:variable name="VisAarsakInnleggelseVisSkjul" select="false()"/>
	<xsl:variable name="VisAarsakHenvisningVisSkjul" select="false()"/>
	<xsl:variable name="VisKliniskeOpplysningerVisSkjul" select="false()"/>
	<xsl:variable name="VisSykehistorieVisSkjul" select="false()"/>
	<xsl:variable name="VisResultatVisSkjul" select="false()"/>
	<xsl:variable name="VisForlopBehandlingVisSkjul" select="false()"/>
	<xsl:variable name="VisMedisineringVisSkjul" select="false()"/>
	<xsl:variable name="VisFunksjonVisSkjul" select="false()"/>
	<xsl:variable name="VisSykmeldingVisSkjul" select="false()"/>
	<xsl:variable name="VisProsedyrerVisSkjul" select="false()"/>
	<xsl:variable name="VisAndreKliniskeVisSkjul" select="false()"/>
	<xsl:variable name="VisFamilieVisSkjul" select="false()"/>
	<xsl:variable name="VisInfoPasientVisSkjul" select="false()"/>
	<xsl:variable name="VisUbesvarteVisSkjul" select="false()"/>
	<xsl:variable name="VisTilbakemeldingVisSkjul" select="false()"/>
	<xsl:variable name="VisOvrigPasientInfoVisSkjul" select="false()"/>
	<xsl:variable name="VisOvrigHelsetjenesteInfoVisSkjul" select="false()"/>
	<xsl:variable name="VisHendelseVisSkjul" select="false()"/>
	<xsl:variable name="VisRefDokVisSkjul" select="false()"/>
	<xsl:variable name="VisOpprinneligHenvisningVisSkjul" select="false()"/>
	<xsl:variable name="VisDokInfoVisSkjul" select="false()"/>
	
	<!-- Boolsk variabel om menylinjen skal vises. Settes til true() om den skal vises. -->
	<xsl:variable name="VisMenylinje" select="false()"/>
	
	<!-- Boolsk variabel for å anonymisere pasienten i visningen -->
	<xsl:variable name="Anonymisert" select="false()"/>
	
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Epikrise</title>
				<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
				<style type="text/css">
					<xsl:value-of select="document('../Felleskomponenter/KITH-visning.css')" disable-output-escaping="yes"/>
				</style>
			</head>
			<body>
				<xsl:for-each select="child::*[local-name()=&quot;Message&quot;]">
					<xsl:call-template name="Message"/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="Message">
		<xsl:for-each select="child::*[local-name()=&quot;ServRprt&quot;]">
			<!-- utelater meldingsid og kommunikasjonsinformasjon -->
			<xsl:call-template name="Header"/>
			<xsl:call-template name="ResultBody"/>
			<xsl:call-template name="Footer"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Meldingshodet - avsender og mottaker-informasjon -->
	<xsl:template name="Header">
		<div class="No-line-top">
			<div class="No-line-header">
				<div class="No-line-headerContent">
					<div class="No-line-caption">Avsender&#160;</div>
					<div class="No-line-content">
						<xsl:for-each select="child::*[local-name()=&quot;ServProvider&quot;]">
							<xsl:call-template name="ServProviderHode"/>
						</xsl:for-each>
					</div>
				</div>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;Patient&quot;]">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Pasient&#160;</div>
							<div class="No-line-content">
								<xsl:for-each select="child::*[local-name()=&quot;Patient&quot;]">
									<xsl:call-template name="PatientHode"/>
								</xsl:for-each>
							</div>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<div class="No-line-headerContent">
							<div class="NoScreen">&#160;</div>
						</div>
					</xsl:otherwise>
				</xsl:choose>
				<div class="No-line-headerContent">
					<div class="No-line-caption">Hovedmottaker&#160;</div>
					<div class="No-line-content">
						<xsl:for-each select="child::*[local-name()=&quot;Requester&quot;]">
							<xsl:call-template name="RequesterHode"/>
						</xsl:for-each>
					</div>
				</div>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;CopyDest&quot;]">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Kopimottaker&#160;</div>
							<div class="No-line-content">
								<xsl:for-each select="child::*[local-name()=&quot;CopyDest&quot;]">
									<xsl:call-template name="CopyDestHode"/>
								</xsl:for-each>
							</div>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<div class="No-line-headerContent">
							<div class="NoScreen">&#160;</div>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="RequesterHode">
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCPHode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ServProviderHode">
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCPHode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="PatientHode">
		<div>
			<xsl:choose>
				<xsl:when test="not($Anonymisert)">
					<xsl:value-of select="child::*[local-name()='Name']"/>&#160;</xsl:when>
				<xsl:otherwise>Gundersen,&#160;Roland&#160;</xsl:otherwise>
			</xsl:choose>
			<b>
				<xsl:choose>
					<xsl:when test="not($Anonymisert)">
						<xsl:for-each select="child::*[local-name()='TypeOffId']">
							<xsl:call-template name="k-8116"/>
						</xsl:for-each>:&#160;</xsl:when>
					<xsl:otherwise>Fødselsnummer:&#160;</xsl:otherwise>
				</xsl:choose></b>
			<xsl:choose>
				<xsl:when test="not($Anonymisert)">
					<xsl:value-of select="child::*[local-name()='OffId']"/>&#160;</xsl:when>
				<xsl:otherwise>15076500565</xsl:otherwise>
			</xsl:choose>
		</div>
		<xsl:if test="child::*[local-name()=&quot;DateOfDeath&quot;]">
			<div>
				<b>Dødsdato:&#160;</b>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;DateOfDeath&quot;]/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()=&quot;Address&quot;]">
			<xsl:call-template name="AddressHode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="HCPersonHode">
		<div>
			<xsl:choose>
				<xsl:when test="ancestor::*[local-name()=&quot;ServProvider&quot;]"><font size="3em"><b><xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/></b></font></xsl:when>
				<xsl:otherwise><xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/></xsl:otherwise>
			</xsl:choose>
			<!--<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>-->
			<div class="NoPrint">,</div>&#160;</div>
	</xsl:template>
	<xsl:template name="HCPHode">
		<xsl:for-each select="child::*[local-name()=&quot;Inst&quot;]">
			<xsl:call-template name="InstHode"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;HCProf&quot;]">
			<xsl:call-template name="HCProfHode"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Address&quot;]">
			<xsl:call-template name="AddressHode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="InstHode">
		<xsl:for-each select="child::*[local-name()=&quot;HCPerson&quot;]">
			<xsl:call-template name="HCPersonHode"/>
		</xsl:for-each>
		<div>
			<xsl:choose>
				<xsl:when test="ancestor::*[local-name()=&quot;ServProvider&quot;]"><font size="3em"><b><xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/></b></font></xsl:when>
				<xsl:otherwise><xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/></xsl:otherwise>
			</xsl:choose>
			<!--<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>-->
		</div>
		<xsl:for-each select="child::*[local-name()=&quot;Dept&quot;]">
			<div>
				<div class="NoPrint">-&#160;</div>
				<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>&#160;</div>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="HCProfHode">
		<div>
			<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]">
				<xsl:call-template name="k-9060"/>
			</xsl:for-each>&#160;<xsl:choose>
				<xsl:when test="ancestor::*[local-name()=&quot;ServProvider&quot;]"><font size="3em"><b><xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/></b></font></xsl:when>
				<xsl:otherwise><xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/></xsl:otherwise>
			</xsl:choose>
			<!--<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>-->
		</div>
	</xsl:template>
	<xsl:template name="CopyDestHode">
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCPHode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="AddressHode">
		<xsl:if test="child::*[local-name()='Type'] and (child::*[local-name()='StreetAdr'] or child::*[local-name()='PostalCode'] or child::*[local-name()='City'] or child::*[local-name()='CityDistr'])">
			<div class="NoPrint">&#160;<b>
				<xsl:for-each select="child::*[local-name()='Type']">
					<xsl:choose>
						<xsl:when test="$Anonymisert and local-name(..)='Patient'">Bostedsadresse</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="k-3401"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>:&#160;</b>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='StreetAdr']">
			<div>
				<xsl:choose>
					<xsl:when test="$Anonymisert and local-name(..)='Patient'">Flåklypa&#160;31</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="child::*[local-name()='StreetAdr']"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='PostalCode'] or child::*[local-name()='City']">
			<xsl:if test="child::*[local-name()='StreetAdr']">
				<div class="NoPrint">,</div>
			</xsl:if>
			<div>
				<xsl:choose>
					<xsl:when test="$Anonymisert and local-name(..)='Patient'">2560&#160;Alvdal</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="child::*[local-name()='PostalCode']"/>&#160;<xsl:value-of select="child::*[local-name()='City']"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='CityDistr']">
			<div class="NoPrint">,</div>
			<div>
				<xsl:choose>
					<xsl:when test="$Anonymisert and local-name(..)='Patient'">&#160;</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="k-3403"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='County']">
			<div class="NoPrint">,</div>
			<div>
				<xsl:choose>
					<xsl:when test="$Anonymisert and local-name(..)='Patient'">&#160;</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="k-3402"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Country']">
			<div class="NoPrint">,</div>
			<div>
				<xsl:choose>
					<xsl:when test="$Anonymisert and local-name(..)='Patient'">Norge&#160;</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="k-9043"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='TeleAddress']">
			<div class="NoPrint">&#160;</div>
			<xsl:choose>
				<xsl:when test="$Anonymisert and local-name(..)='Patient'"></xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="TeleAddressHode"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="TeleAddressHode">
		<div>
			<b>
				<xsl:choose>
					<xsl:when test="starts-with(@V, 'tel:') or starts-with(@V, 'callto:')">Telefon</xsl:when>
					<xsl:when test="starts-with(@V, 'fax:')">Faks</xsl:when>
					<xsl:when test="starts-with(@V, 'mailto:')">e-post</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(@V, ':')"/>
					</xsl:otherwise>
				</xsl:choose>
			</b>&#160;<xsl:value-of select="substring-after(@V, ':')"/>&#160;
		</div>
	</xsl:template>
	<!-- Hoveddokumentet -->
	<xsl:template name="ResultBody">
		<xsl:variable name="position" select="position()"/>
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="child::*[local-name()=&quot;ServType&quot;][@V='M' or @V='C' or @V='O']">red</xsl:when>
				<xsl:otherwise>black</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="{$stil}">
			<xsl:if test="$VisMenylinje">
				<xsl:call-template name="FellesMeny">
					<xsl:with-param name="position" select="position()"/>
				</xsl:call-template>
			</xsl:if>
			<!-- Overskrift og tabell for epikrisen -->
			<h1>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;MsgDescr&quot;] and string-length(child::*[local-name()=&quot;MsgDescr&quot;]) &gt; 0">
						<xsl:value-of select="child::*[local-name()=&quot;MsgDescr&quot;]"/>
					</xsl:when>
					<xsl:otherwise>Epikrise</xsl:otherwise>
				</xsl:choose>
				<xsl:for-each select="child::*[local-name()=&quot;ServType&quot;][@V!='N']">&#160;-
					<font color="{$color}"><xsl:call-template name="k-7309"/></font>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()=&quot;Status&quot;]">&#160;-&#160;<xsl:call-template name="k-7306"/>
				</xsl:for-each>
			</h1>
			<table>
				<tbody>
					<xsl:call-template name="ServRprt"/>
				</tbody>
			</table>
			<!-- Overskrift og tabell for Diagnoser -->
			<xsl:if test="//child::*[local-name()=&quot;Diagnosis&quot;] or //child::*[local-name()=&quot;DiagComment&quot;] or //child::*[local-name()=&quot;ReasonAsText&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='DIAG'] or //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='H' or child::*[local-name()=&quot;Type&quot;]/@V='B']">
				<xsl:variable name="id1">
					<xsl:value-of select="concat('Diagnosis',$position)"/>
				</xsl:variable>
				<xsl:variable name="DisplayBlock">
					<xsl:choose>
						<xsl:when test="$VisDiagnoserVisSkjul">inline-block</xsl:when>
						<xsl:otherwise>block</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<h2 style="background-color:#e3e3e3; padding-top:1em; margin-top:0em; padding-left:1em; margin-left:0em; display:{$DisplayBlock}" id="{$id1}">Diagnoser</h2>
				<xsl:if test="$VisDiagnoserVisSkjul">
					<label for="vis{$id1}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id1}" style="display: none; margin-bottom:0em;"/>
				</xsl:if>
				<table style="background-color:#e3e3e3; padding-left:1em; margin-left:0em;">
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='H']/child::*[local-name()=&quot;Observation&quot;]">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='B']/child::*[local-name()=&quot;Observation&quot;]">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;Diagnosis&quot;] | //child::*[local-name()=&quot;DiagComment&quot;]">
							<xsl:call-template name="Diagnosis-DiagComment-CodedDescr-CodedComment"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;ReasonAsText&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='DIAG']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Vurdering -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='VU']">
				<xsl:variable name="id6">
					<xsl:value-of select="concat('VU',$position)"/>
				</xsl:variable>
				<xsl:variable name="DisplayBlock">
					<xsl:choose>
						<xsl:when test="$VisVurderingVisSkjul">inline-block</xsl:when>
						<xsl:otherwise>block</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<h2 id="{$id6}" style="background-color:#e3e3e3; padding-top:1em; margin-top:0em; padding-left:1em; margin-left:0em; display:{$DisplayBlock}">Vurdering</h2>
				<xsl:if test="$VisVurderingVisSkjul">
					<label for="vis{$id6}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id6}" style="display: none;"/>
				</xsl:if>
				<table style="background-color:#e3e3e3; padding-left:1em; margin-left:0em;">
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='VU']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Videre oppfølging -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='OP']">
				<xsl:variable name="id11">
					<xsl:value-of select="concat('OP',$position)"/>
				</xsl:variable>
				<xsl:variable name="DisplayBlock">
					<xsl:choose>
						<xsl:when test="$VisVidereOppfolgingVisSkjul">inline-block</xsl:when>
						<xsl:otherwise>block</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<h2 id="{$id11}" style="background-color:#e3e3e3; padding-top:1em; margin-top:0em; padding-left:1em; margin-left:0em; display:{$DisplayBlock}">Videre&#160;oppfølging</h2>
				<xsl:if test="$VisVidereOppfolgingVisSkjul">
					<label for="vis{$id11}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id11}" style="display: none;"/>
				</xsl:if>
				<table style="background-color:#e3e3e3; padding-left:1em; margin-left:0em;">
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='OP']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for CAVE og NB-opplysninger -->
			<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='CAVE' or child::*[local-name()=&quot;Type&quot;]/@V='NB']">
				<xsl:variable name="id2">
					<xsl:value-of select="concat('CAVE',$position)"/>
				</xsl:variable>
				<h2 id="{$id2}" style="display:inline-block">
					<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='CAVE']">CAVE</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='CAVE'] and //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='NB']">&#160;og&#160;</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='NB']">NB-opplysninger</xsl:if>
				</h2>
				<xsl:if test="VisCAVEVisSkjul">
					<label for="vis{$id2}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id2}" style="display: none; margin-bottom:0em;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='CAVE']/child::*[local-name()=&quot;Observation&quot;]">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='NB']/child::*[local-name()=&quot;Observation&quot;]">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Årsak til innleggelse -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='AI'] or //child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='ÅI']">
				<xsl:variable name="id3">
					<xsl:value-of select="concat('AI',$position)"/>
				</xsl:variable>
				<h2 id="{$id3}" style="display:inline-block">Årsak&#160;til&#160;innleggelse</h2>
				<xsl:if test="VisAarsakInnleggelseVisSkjul">
					<label for="vis{$id3}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id3}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='AI']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='ÅI']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Årsak til henvisning -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='AH']">
				<xsl:variable name="id4">
					<xsl:value-of select="concat('AH',$position)"/>
				</xsl:variable>
				<h2 id="{$id4}" style="display:inline-block">Årsak&#160;til&#160;henvisning</h2>
				<xsl:if test="$VisAarsakHenvisningVisSkjul">
					<label for="vis{$id4}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id4}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='AH']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Kliniske opplysninger -->
			<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='OPPL']">
				<xsl:variable name="id50">
					<xsl:value-of select="concat('OPPL',$position)"/>
				</xsl:variable>
				<h2 id="{$id50}" style="display:inline-block">Kliniske&#160;opplysninger</h2>
				<xsl:if test="VisKliniskeOpplysningerVisSkjul">
					<label for="vis{$id50}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id50}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='OPPL']/child::*[local-name()=&quot;Observation&quot;]">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Sykehistorie -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='TS'] or //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='ANAM']">
				<xsl:variable name="id5">
					<xsl:value-of select="concat('TS',$position)"/>
				</xsl:variable>
				<h2 id="{$id5}" style="display:inline-block">Sykehistorie</h2>
				<xsl:if test="$VisSykehistorieVisSkjul">
					<label for="vis{$id5}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id5}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='TS']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='ANAM']/child::*[local-name()=&quot;Observation&quot;]">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Funn/undersøkelsesresultat -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='FU' or child::*[local-name()=&quot;Heading&quot;]/@V='LR'] or //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='FUNN']">
				<xsl:variable name="id7">
					<xsl:value-of select="concat('FU',$position)"/>
				</xsl:variable>
				<h2 id="{$id7}" style="display:inline-block">Funn/undersøkelsesresultat</h2>
				<xsl:if test="$VisResultatVisSkjul">
					<label for="vis{$id7}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id7}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='FU']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='LR']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='FUNN']/child::*[local-name()=&quot;Observation&quot;]">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;ResultItem&quot;]">
							<xsl:if test="position()=1">
								<tr>
									<th>Undersøkelse</th>
									<th colspan="{$res-res-col}">Funn/resultat</th>
									<xsl:if test="//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DevResultInd&quot;]">
										<th colspan="{$res-dev-col}">Avviksmarkør</th>
									</xsl:if>
									<xsl:if test="//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;InvDate&quot;]">
										<th colspan="{$res-idate-col}">Tidspunkt&#160;for&#160;undersøkelsen</th>
									</xsl:if>
									<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;]">
										<th colspan="{$res-sdate-col}">Starttidspunkt</th>
									</xsl:if>
									<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;]">
										<th colspan="{$res-edate-col}">Sluttidspunkt</th>
									</xsl:if>
									<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]">
										<th colspan="{$res-odate-col}">Tidspunkt&#160;for&#160;opprinnelse</th>
									</xsl:if>
								</tr>
							</xsl:if>
							<tr>
								<xsl:call-template name="ResultItem"/>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Forløp og behandling -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='FO']">
				<xsl:variable name="id8">
					<xsl:value-of select="concat('FO',$position)"/>
				</xsl:variable>
				<h2 id="{$id8}" style="display:inline-block">Forløp&#160;og&#160;behandling</h2>
				<xsl:if test="$VisForlopBehandlingVisSkjul">
					<label for="vis{$id8}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id8}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='FO']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Medisinering -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='ME'] or //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='MEDB']">
				<xsl:variable name="id9">
					<xsl:value-of select="concat('ME',$position)"/>
				</xsl:variable>
				<h2 id="{$id9}" style="display:inline-block">Medisinering</h2>
				<xsl:if test="$VisForlopBehandlingVisSkjul">
					<label for="vis{$id9}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id9}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='ME']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='MEDB']/child::*[local-name()=&quot;Observation&quot;]">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='MEDB']/child::*[local-name()=&quot;ResultItem&quot;]">
							<xsl:call-template name="ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;Medication&quot;]">
							<xsl:variable name="rowColor">
								<xsl:choose>
									<xsl:when test="boolean(position() mod 2)">#f8f8f8</xsl:when>
									<xsl:otherwise>white</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="position()=1">
								<tr>
									<th>Legemiddel</th>
									<th colspan="{$med-stat-col}">Status</th>
									<xsl:if test="//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;UnitDose&quot;] or //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;QuantitySupplied&quot;]">
										<th colspan="{$med-unit-col}">Mengde</th>
									</xsl:if>
									<xsl:if test="//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;DosageText&quot;] or //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;IntendedDuration&quot;]">
										<th colspan="{$med-text-col}">
											<xsl:if test="//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;DosageText&quot;]">Dosering</xsl:if>
											<xsl:if test="//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;DosageText&quot;] and //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;IntendedDuration&quot;]">/</xsl:if>
											<xsl:if test="//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;IntendedDuration&quot;]">Varighet</xsl:if>
										</th>
									</xsl:if>
									<xsl:if test="//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;Comment&quot;]">
										<th colspan="{$med-com-col}">Kommentar</th>
									</xsl:if>
									<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;]">
										<th colspan="{$med-sdate-col}">Starttidspunkt</th>
									</xsl:if>
									<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;]">
										<th colspan="{$med-edate-col}">Sluttidspunkt</th>
									</xsl:if>
									<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]">
										<th colspan="{$med-odate-col}">Tidspunkt&#160;for&#160;opprinnelse</th>
									</xsl:if>
								</tr>
							</xsl:if>
							<tr bgcolor="{$rowColor}">
								<xsl:call-template name="Medication"/>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Funksjonsnivå/hjelpetiltak -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='HJ']">
				<xsl:variable name="id10">
					<xsl:value-of select="concat('HJ',$position)"/>
				</xsl:variable>
				<h2 id="{$id10}" style="display:inline-block">Funksjonsnivå/hjelpetiltak</h2>
				<xsl:if test="$VisFunksjonVisSkjul">
					<label for="vis{$id10}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id10}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='HJ']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Sykmelding -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='SY'] or //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='SYKM']">
				<xsl:variable name="id12">
					<xsl:value-of select="concat('SY',$position)"/>
				</xsl:variable>
				<h2 id="{$id12}" style="display:inline-block">Sykmelding</h2>
				<xsl:if test="$VisSykmeldingVisSkjul">
					<label for="vis{$id12}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id12}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='SY']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='SYKM']/child::*[local-name()=&quot;Observation&quot;]">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Prosedyrer mv. -->
			<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='OPIN' or child::*[local-name()=&quot;Type&quot;]/@V='MPRS' or child::*[local-name()=&quot;Type&quot;]/@V='PRS']">
				<xsl:variable name="id60">
					<xsl:value-of select="concat('PRS',$position)"/>
				</xsl:variable>
				<h2 id="{$id60}" style="display:inline-block">Prosedyrer&#160;mv.</h2>
				<xsl:if test="$VisProsedyrerVisSkjul">
					<label for="vis{$id60}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id60}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='OPIN' or child::*[local-name()=&quot;Type&quot;]/@V='MPRS' or child::*[local-name()=&quot;Type&quot;]/@V='PRS']/child::*[local-name()=&quot;Observation&quot;]">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Andre kliniske opplysninger -->
			<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='PROG' or child::*[local-name()=&quot;Type&quot;]/@V='GBEH' or child::*[local-name()=&quot;Type&quot;]/@V='GOPL' or child::*[local-name()=&quot;Type&quot;]/@V='SYMP' or child::*[local-name()=&quot;Type&quot;]/@V='TB' or child::*[local-name()=&quot;Type&quot;]/@V='US' or child::*[local-name()=&quot;Type&quot;]/@V='SM']">
				<xsl:variable name="id70">
					<xsl:value-of select="concat('PROG',$position)"/>
				</xsl:variable>
				<h2 id="{$id70}" style="display:inline-block">Andre&#160;kliniske&#160;opplysninger</h2>
				<xsl:if test="$VisAndreKliniskeVisSkjul">
					<label for="vis{$id70}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id70}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='PROG' or child::*[local-name()=&quot;Type&quot;]/@V='GBEH' or child::*[local-name()=&quot;Type&quot;]/@V='GOPL' or child::*[local-name()=&quot;Type&quot;]/@V='SYMP' or child::*[local-name()=&quot;Type&quot;]/@V='TB' or child::*[local-name()=&quot;Type&quot;]/@V='US' or child::*[local-name()=&quot;Type&quot;]/@V='SM']/child::*[local-name()=&quot;Observation&quot;]">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Familie/sosialt -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='FA']">
				<xsl:variable name="id13">
					<xsl:value-of select="concat('FA',$position)"/>
				</xsl:variable>
				<h2 id="{$id13}" style="display:inline-block">Familie/sosialt</h2>
				<xsl:if test="$VisFamilieVisSkjul">
					<label for="vis{$id13}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id13}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='FA']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Informasjon til pasient/pårørende -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='IP']">
				<xsl:variable name="id14">
					<xsl:value-of select="concat('IP',$position)"/>
				</xsl:variable>
				<h2 id="{$id14}" style="display:inline-block">Informasjon&#160;til&#160;pasient/pårørende</h2>
				<xsl:if test="$VisInfoPasientVisSkjul">
					<label for="vis{$id14}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id14}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='IP']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Ubesvarte prøver -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='UP']">
				<xsl:variable name="id15">
					<xsl:value-of select="concat('UP',$position)"/>
				</xsl:variable>
				<h2 id="{$id15}" style="display:inline-block">Ubesvarte&#160;prøver</h2>
				<xsl:if test="$VisUbesvarteVisSkjul">
					<label for="vis{$id15}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id15}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='UP']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Tilbakemelding (uspes.) -->
			<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='TB'] or //child::*[local-name()=&quot;Comment&quot;][not(child::*[local-name()=&quot;Heading&quot;])]">
				<xsl:variable name="id16">
					<xsl:value-of select="concat('TB',$position)"/>
				</xsl:variable>
				<h2 id="{$id16}" style="display:inline-block">Tilbakemelding&#160;(uspes.)</h2>
				<xsl:if test="$VisTilbakemeldingVisSkjul">
					<label for="vis{$id16}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id16}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='TB']">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
						<xsl:for-each select="//child::*[local-name()=&quot;Comment&quot;][not(child::*[local-name()=&quot;Heading&quot;])]">
							<xsl:call-template name="ReasonAsText-Comment"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for øvrig pasientinformasjon -->
			<xsl:for-each select="child::*[local-name()=&quot;Patient&quot;]">
				<xsl:if test="child::*[local-name()=&quot;BasisForHealthServices&quot;] or child::*[local-name()=&quot;Sex&quot;] or child::*[local-name()=&quot;DateOfBirth&quot;] or child::*[local-name()=&quot;PatientPrecaution&quot;] or child::*[local-name()=&quot;NeedTranslator&quot;] or child::*[local-name()=&quot;CareSituation&quot;] or child::*[local-name()=&quot;PatRelperson&quot;] or child::*[local-name()=&quot;PatRelInst&quot;] or child::*[local-name()=&quot;Consent&quot;] or child::*[local-name()=&quot;AdditionalId&quot;]">
					<xsl:variable name="id30">
						<xsl:value-of select="concat('Patient',$position)"/>
					</xsl:variable>
					<h2 id="{$id30}" style="display:inline-block">Pasient</h2>
					<xsl:if test="$VisOvrigPasientInfoVisSkjul">
						<label for="vis{$id30}" class="VisSkjul">Vis/Skjul</label>
						<input type="checkbox" id="vis{$id30}" style="display: none;"/>
					</xsl:if>
					<table>
						<tbody>
							<xsl:call-template name="Patient"/>
						</tbody>
					</table>
				</xsl:if>
			</xsl:for-each>
			<!-- Overskrift og tabell for øvrig informasjon helsetjenesteenheter -->
			<xsl:if test="child::*[local-name()=&quot;ServProvider&quot;] | child::*[local-name()=&quot;Requester&quot;] | child::*[local-name()=&quot;CopyDest&quot;] | .//child::*[local-name()=&quot;RelServProvider&quot;] | .//child::*[local-name()=&quot;Origin&quot;] | .//child::*[local-name()=&quot;RelHCProvider&quot;] | .//child::*[local-name()=&quot;PatRelHCP&quot;]">
				<xsl:variable name="id31">
					<xsl:value-of select="concat('HCP',$position)"/>
				</xsl:variable>
				<h2 id="{$id31}" style="display:inline-block">Helsetjenesteenheter</h2>
				<xsl:if test="$VisOvrigHelsetjenesteInfoVisSkjul">
					<label for="vis{$id31}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id31}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="child::*[local-name()=&quot;ServProvider&quot;]">
							<xsl:call-template name="ServProvider">
								<xsl:with-param name="col" select="$std-col"/>
							</xsl:call-template>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()=&quot;Requester&quot;]">
							<xsl:call-template name="Requester">
								<xsl:with-param name="col" select="$std-col"/>
							</xsl:call-template>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()=&quot;CopyDest&quot;]">
							<xsl:call-template name="CopyDest">
								<xsl:with-param name="col" select="$std-col"/>
							</xsl:call-template>
						</xsl:for-each>
						<xsl:for-each select=".//child::*[local-name()=&quot;RelServProvider&quot;]">
							<xsl:call-template name="RelServProvider">
								<xsl:with-param name="col" select="$std-col"/>
							</xsl:call-template>
						</xsl:for-each>
						<xsl:for-each select=".//child::*[local-name()=&quot;Origin&quot;]">
							<xsl:call-template name="Origin">
								<xsl:with-param name="col" select="$std-col"/>
							</xsl:call-template>
						</xsl:for-each>
						<xsl:for-each select=".//child::*[local-name()=&quot;RelHCProvider&quot;]">
							<xsl:call-template name="RelHCProvider">
								<xsl:with-param name="col" select="$std-col"/>
							</xsl:call-template>
						</xsl:for-each>
						<xsl:for-each select=".//child::*[local-name()=&quot;PatRelHCP&quot;]">
							<xsl:call-template name="PatRelHCP">
								<xsl:with-param name="col" select="$std-col"/>
							</xsl:call-template>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for hendelse -->
			<xsl:if test="child::*[local-name()=&quot;Event&quot;]">
				<xsl:variable name="id32">
					<xsl:value-of select="concat('Event',$position)"/>
				</xsl:variable>
				<h2 id="{$id32}" style="display:inline-block">Hendelser</h2>
				<xsl:if test="$VisHendelseVisSkjul">
					<label for="vis{$id32}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id32}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;Event&quot;]">
							<xsl:if test="position()=1">
								<tr>
									<th colspan="{$event-type-col}">Type</th>
									<xsl:if test="..//child::*[local-name()=&quot;EventLocation&quot;]">
										<th colspan="{$event-place-col}">Sted</th>
									</xsl:if>
									<xsl:if test="..//child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;StartDateTime&quot;] or ..//child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;EndDateTime&quot;] or ..//child::*[local-name()=&quot;ExpDuration&quot;]">
										<th colspan="{$event-time-col}">Tidspunkt</th>
									</xsl:if>
									<xsl:if test="..//child::*[local-name()=&quot;AdmOutcome&quot;]">
										<th colspan="{$event-out-col}">Ut&#160;til</th>
									</xsl:if>
									<xsl:if test="..//child::*[local-name()=&quot;Priority&quot;]">
										<th colspan="{$event-pri-col}">Prioritet</th>
									</xsl:if>
									<xsl:if test="..//child::*[local-name()=&quot;AssRequest&quot;]">
										<th colspan="{$event-ass-col}">Tilknyttet&#160;melding/dokument</th>
									</xsl:if>
								</tr>
							</xsl:if>
							<xsl:if test="position() &gt; 1 and not(local-name(..)=&quot;Event&quot;)">
								<tr><td colspan="{$std-col}"><hr/></td></tr>
							</xsl:if>
							<xsl:call-template name="Event"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for referert dokument -->
			<xsl:if test="child::*[local-name()=&quot;RefDoc&quot;]">
				<xsl:variable name="id40">
					<xsl:value-of select="concat('RefDoc',$position)"/>
				</xsl:variable>
				<h2 id="{$id40}" style="display:inline-block">Vedlegg</h2>
				<xsl:if test="$VisRefDokVisSkjul">
					<label for="vis{$id40}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id40}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="child::*[local-name()=&quot;RefDoc&quot;]">
							<xsl:call-template name="RefDoc"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Overskrift og tabell for Opprinnelig henvisning -->
			<xsl:if test="child::*[local-name()=&quot;ServReq&quot;]">
				<xsl:variable name="id41">
					<xsl:value-of select="concat('ServReq',$position)"/>
				</xsl:variable>
				<h2 id="{$id41}" style="display:inline-block">Opprinnelig&#160;henvisning</h2>
				<xsl:if test="$VisOpprinneligHenvisningVisSkjul">
					<label for="vis{$id41}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id41}" style="display: none;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="child::*[local-name()=&quot;ServReq&quot;]">
							<xsl:call-template name="ServReq"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
		</div>
	</xsl:template>
	<!-- Meldingshodet - Dokumentopplysninger -->
	<xsl:template name="Footer">
		<div class="{$stil}">
			<h2 style="display:inline-block">Dokumentinformasjon</h2>
			<xsl:if test="$VisDokInfoVisSkjul">
				<label for="visFooter" class="VisSkjul">Vis/Skjul</label>
				<input type="checkbox" id="visFooter" style="display: none;"/>
			</xsl:if>
			<table>
				<tbody>
					<tr>
						<th>Melding&#160;opprettet</th>
						<td width="{$std-td}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;GenDate&quot;]/@V"/>
							</xsl:call-template>
						</td>
						<th>Meldingsid</th>
						<td><xsl:value-of select="../child::*[local-name()=&quot;MsgId&quot;]"/></td>
					</tr>
					<tr>
						<xsl:if test="child::*[local-name()=&quot;IssueDate&quot;]">
							<th>Utstedt</th>
							<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Priority&quot;] | child::*[local-name()=&quot;ApprDate&quot;] | child::*[local-name()=&quot;Ack&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Priority&quot;] | child::*[local-name()=&quot;ApprDate&quot;] | child::*[local-name()=&quot;Ack&quot;]))+1}">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;IssueDate&quot;]/@V"/>
								</xsl:call-template>
							</td>
						</xsl:if>
						<xsl:if test="child::*[local-name()=&quot;Priority&quot;]">
							<th>Hastegrad</th>
							<td width="{((($std-col)-2-count(child::*[local-name()=&quot;IssueDate&quot;])*2)*number(not(child::*[local-name()=&quot;ApprDate&quot;] | child::*[local-name()=&quot;Ack&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;IssueDate&quot;])*2)*number(not(child::*[local-name()=&quot;ApprDate&quot;] | child::*[local-name()=&quot;Ack&quot;]))+1}">
								<xsl:for-each select="child::*[local-name()=&quot;Priority&quot;]">
									<xsl:call-template name="k-7303"/>
								</xsl:for-each>
							</td>
						</xsl:if>
						<xsl:if test="child::*[local-name()=&quot;ApprDate&quot;]">
							<th>Godkjent</th>
							<td width="{((($std-col)-2-count(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;Priority&quot;])*2)*number(not(child::*[local-name()=&quot;Ack&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;Priority&quot;])*2)*number(not(child::*[local-name()=&quot;Ack&quot;]))+1}">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;ApprDate&quot;]/@V"/>
								</xsl:call-template>
							</td>
						</xsl:if>
						<xsl:if test="child::*[local-name()=&quot;Ack&quot;]">
							<th>Meldingsbekreftelse</th>
							<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;Priority&quot;] | child::*[local-name()=&quot;ApprDate&quot;])*2}">
								<xsl:for-each select="child::*[local-name()=&quot;Ack&quot;]">
									<xsl:call-template name="k-7304"/>
								</xsl:for-each>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<th>Visningsversjon</th>
						<td><xsl:value-of select="$versjon"/></td>
					</tr>
				</tbody>
			</table>
		</div>
	</xsl:template>
	<!-- Klikkbar horisontal meny som leder lenger ned i dokumentet -->
	<xsl:template name="FellesMeny">
		<xsl:param name="position"/>
		<div class="NoPrint">
			<div id="FellesMeny" class="FellesMeny">
				<ul>
					<xsl:if test="//child::*[local-name()=&quot;Diagnosis&quot;] or //child::*[local-name()=&quot;DiagComment&quot;] or //child::*[local-name()=&quot;ReasonAsText&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='DIAG'] or //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='H' or child::*[local-name()=&quot;Type&quot;]/@V='B']">
						<li>
							<xsl:variable name="temp1" select="concat('Diagnosis',$position)"/>
							<a href="#{$temp1}">Diagnoser</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='CAVE' or child::*[local-name()=&quot;Type&quot;]/@V='NB']">
						<li>
							<xsl:variable name="temp2" select="concat('CAVE',$position)"/>
							<a href="#{$temp2}">
								<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='CAVE']">CAVE</xsl:if>
								<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='CAVE'] and //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='NB']">&#160;og&#160;</xsl:if>
								<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='NB']">NB-opplysninger</xsl:if>
							</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='VU']">
						<li>
							<xsl:variable name="temp6" select="concat('VU',$position)"/>
							<a href="#{$temp6}">Vurdering</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='OP']">
						<li>
							<xsl:variable name="temp11" select="concat('OP',$position)"/>
							<a href="#{$temp11}">Videre&#160;oppfølging</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='AI'] or //child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='ÅI']">
						<li>
							<xsl:variable name="temp3" select="concat('AI',$position)"/>
							<a href="#{$temp3}">Årsak&#160;til&#160;innleggelse</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='AH']">
						<li>
							<xsl:variable name="temp4" select="concat('AH',$position)"/>
							<a href="#{$temp4}">Årsak&#160;til&#160;henvisning</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='OPPL']">
						<li>
							<xsl:variable name="temp50" select="concat('OPPL',$position)"/>
							<a href="#{$temp50}">Kliniske&#160;opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='TS'] or //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='ANAM']">
						<li>
							<xsl:variable name="temp5" select="concat('TS',$position)"/>
							<a href="#{$temp5}">Sykehistorie</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='FU' or child::*[local-name()=&quot;Heading&quot;]/@V='LR'] or //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='FUNN']">
						<li>
							<xsl:variable name="temp7" select="concat('FU',$position)"/>
							<a href="#{$temp7}">Funn&#160;og&#160;undersøkelsesresultater</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='FO']">
						<li>
							<xsl:variable name="temp8" select="concat('FO',$position)"/>
							<a href="#{$temp8}">Forløp&#160;og&#160;behandling</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='ME'] or //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='MEDB']">
						<li>
							<xsl:variable name="temp9" select="concat('ME',$position)"/>
							<a href="#{$temp9}">Medisinering</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='HJ']">
						<li>
							<xsl:variable name="temp10" select="concat('HJ',$position)"/>
							<a href="#{$temp10}">Funksjonsnivå/hjelpetiltak</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='SY'] or //child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='SYKM']">
						<li>
							<xsl:variable name="temp12" select="concat('SY',$position)"/>
							<a href="#{$temp12}">Sykmelding</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='OPIN' or child::*[local-name()=&quot;Type&quot;]/@V='MPRS' or child::*[local-name()=&quot;Type&quot;]/@V='PRS']">
						<li>
							<xsl:variable name="temp60" select="concat('PRS',$position)"/>
							<a href="#{$temp60}">Prosedyrer&#160;mv.</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V='PROG' or child::*[local-name()=&quot;Type&quot;]/@V='GBEH' or child::*[local-name()=&quot;Type&quot;]/@V='GOPL' or child::*[local-name()=&quot;Type&quot;]/@V='SYMP' or child::*[local-name()=&quot;Type&quot;]/@V='TB' or child::*[local-name()=&quot;Type&quot;]/@V='US' or child::*[local-name()=&quot;Type&quot;]/@V='SM']">
						<li>
							<xsl:variable name="temp70" select="concat('PROG',$position)"/>
							<a href="#{$temp70}">Andre&#160;kliniske&#160;opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='FA']">
						<li>
							<xsl:variable name="temp13" select="concat('FA',$position)"/>
							<a href="#{$temp13}">Familie/sosialt</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='IP']">
						<li>
							<xsl:variable name="temp14" select="concat('IP',$position)"/>
							<a href="#{$temp14}">Informasjon&#160;til&#160;pasient/pårørende</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='UP']">
						<li>
							<xsl:variable name="temp15" select="concat('UP',$position)"/>
							<a href="#{$temp15}">Ubesvarte&#160;prøver</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Comment&quot;][child::*[local-name()=&quot;Heading&quot;]/@V='TB']">
						<li>
							<xsl:variable name="temp16" select="concat('TB',$position)"/>
							<a href="#{$temp16}">Tilbakemelding&#160;(uspes.)</a>
						</li>
					</xsl:if>
					<xsl:for-each select="//child::*[local-name()=&quot;Patient&quot;]">
						<xsl:if test="child::*[local-name()=&quot;Sex&quot;] or child::*[local-name()=&quot;DateOfBirth&quot;] or child::*[local-name()=&quot;PatientPrecaution&quot;] or child::*[local-name()=&quot;PatientRelParty&quot;] or child::*[local-name()=&quot;AdditionalId&quot;]">
							<li>
								<xsl:variable name="temp30" select="concat('Patient',$position)"/>
								<a href="#{$temp30}">Pasient</a>
							</li>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="child::*[local-name()=&quot;ServProvider&quot;] or child::*[local-name()=&quot;Requester&quot;] or child::*[local-name()=&quot;CopyDest&quot;] or .//child::*[local-name()=&quot;RelServProvider&quot;] or .//child::*[local-name()=&quot;Origin&quot;] or .//child::*[local-name()=&quot;RelHCProvider&quot;] or .//child::*[local-name()=&quot;PatRelHCP&quot;]">
						<li>
							<xsl:variable name="temp31" select="concat('HCP',$position)"/>
							<a href="#{$temp31}">Helsetjenesteenheter</a>
						</li>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;Event&quot;]">
						<li>
							<xsl:variable name="temp32" select="concat('Event',$position)"/>
							<a href="#{$temp32}">Hendelser</a>
						</li>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;RefDoc&quot;]">
						<li>
							<xsl:variable name="temp40" select="concat('RefDoc',$position)"/>
							<a href="#{$temp40}">Vedlegg</a>
						</li>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;ServReq&quot;]">
						<li>
							<xsl:variable name="temp41" select="concat('ServReq',$position)"/>
							<a href="#{$temp41}">Opprinnelig&#160;henvisning</a>
						</li>
					</xsl:if>
				</ul>
			</div>
		</div>
	</xsl:template>
	<!-- Visning av Tilbakemelding -->
	<xsl:template name="ServRprt">
		<xsl:if test="//child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;StartDateTime&quot;] or //child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;EndDateTime&quot;] or //child::*[local-name()=&quot;RelServProvider&quot;]">
			<tr>
				<xsl:for-each select="//child::*[local-name()=&quot;ReportedEvent&quot;]">
					<xsl:if test="child::*[local-name()=&quot;StartDateTime&quot;] and position()=1">
						<th>Innlagt</th>
						<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;RelServProvider&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;RelServProvider&quot;]))+1}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;StartDateTime&quot;]/@V"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;EndDateTime&quot;] and position()=last()">
						<th>Utskrevet</th>
						<td width="{((($std-col)-2-count(child::*[local-name()=&quot;StartDateTime&quot;])*2)*number(not(//child::*[local-name()=&quot;RelServProvider&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;StartDateTime&quot;])*2)*number(not(//child::*[local-name()=&quot;RelServProvider&quot;]))+1}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;EndDateTime&quot;]/@V"/>
							</xsl:call-template>
						</td>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="//child::*[local-name()=&quot;RelServProvider&quot;]//child::*[local-name()=&quot;HCProf&quot;]">
					<xsl:if test="position()=1">
						<th>Ansvarlig</th>
						<td colspan="{($std-col)-1-count(//child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;EndDateTime&quot;] | //child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;StartDateTime&quot;])*2}">
							<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]">
								<xsl:call-template name="k-9060"/>&#160;
							</xsl:for-each>
							<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
						</td>
					</xsl:if>
				</xsl:for-each>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Henvisning -->
	<xsl:template name="ServReq">
		<xsl:variable name="color2">
			<xsl:choose>
				<xsl:when test="child::*[local-name()=&quot;ServType&quot;][@V='M' or @V='C' or @V='O']">red</xsl:when>
				<xsl:otherwise>black</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<xsl:if test="child::*[local-name()=&quot;MsgDescr&quot;]">
				<th>Type</th>
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;ReceiptDate&quot;] | child::*[local-name()=&quot;ReqComment&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;ReceiptDate&quot;] | child::*[local-name()=&quot;ReqComment&quot;]))+1}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;MsgDescr&quot;]/@V">
							<xsl:for-each select="child::*[local-name()=&quot;MsgDescr&quot;]"> <!-- For versjon av epikrise hvor MsgDescr er kith:CS -->
								<xsl:call-template name="k-8455"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="child::*[local-name()=&quot;MsgDescr&quot;]"/> <!-- For versjon av epikrise hvor MsgDescr er kith:ST -->
						</xsl:otherwise>
					</xsl:choose>
					<xsl:for-each select="child::*[local-name()=&quot;ServType&quot;][@V!='N']">
						&#160;<font color="{$color2}"><xsl:call-template name="k-7309"/></font>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;IssueDate&quot;]">
				<th>Utstedt</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;MsgDescr&quot;])*2)*number(not(child::*[local-name()=&quot;ReceiptDate&quot;] | child::*[local-name()=&quot;ReqComment&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;MsgDescr&quot;])*2)*number(not(child::*[local-name()=&quot;ReceiptDate&quot;] | child::*[local-name()=&quot;ReqComment&quot;]))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;IssueDate&quot;]/@V"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;ReceiptDate&quot;]">
				<th>Mottatt</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;MsgDescr&quot;] | child::*[local-name()=&quot;IssueDate&quot;])*2)*number(not(child::*[local-name()=&quot;ReqComment&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;MsgDescr&quot;] | child::*[local-name()=&quot;IssueDate&quot;])*2)*number(not(child::*[local-name()=&quot;ReqComment&quot;]))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;ReceiptDate&quot;]/@V"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;ReqComment&quot;]">
				<th>Kommentar</th>
				<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;MsgDescr&quot;] | child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;ReceiptDate&quot;])*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;ReqComment&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;ReasonAsText&quot;]">
			<xsl:call-template name="ReasonAsText-Comment"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Diagnose -->
	<xsl:template name="Diagnosis-DiagComment-CodedDescr-CodedComment">
		<xsl:variable name="HovedDiagnose">
			<xsl:choose>
				<xsl:when test="../../child::*[local-name()=&quot;Type&quot;]/@V='H'">bold</xsl:when>
				<xsl:otherwise>normal</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<td width="{$std-td}px" style="font-weight:{$HovedDiagnose}">
				<xsl:if test="child::*[local-name()=&quot;Concept&quot;]/@DN or child::*[local-name()=&quot;Concept&quot;]/@OT">
					<xsl:for-each select="child::*[local-name()=&quot;Concept&quot;]">
						<xsl:call-template name="k-dummy"/>
					</xsl:for-each>
				</xsl:if>
				<xsl:for-each select="child::*[local-name()=&quot;Modifier&quot;]">,&#160;<xsl:value-of select="child::*[local-name()=&quot;Value&quot;]/@DN"/></xsl:for-each>
			</td>
			<td colspan="{($std-col)-1}" style="font-weight:{$HovedDiagnose}">
				<xsl:value-of select="child::*[local-name()=&quot;Concept&quot;]/@V"/>&#160;
				<xsl:if test="contains(child::*[local-name()=&quot;Concept&quot;]/@S, '7170')">(ICPC)</xsl:if>
				<xsl:if test="contains(child::*[local-name()=&quot;Concept&quot;]/@S, '7110')">(ICD-10)</xsl:if>
				<xsl:for-each select="child::*[local-name()=&quot;Modifier&quot;]">,&#160;<xsl:value-of select="child::*[local-name()=&quot;Value&quot;]/@V"/></xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	<!-- Visning av Begrunnelse for / kommentar til henvisningen -->
	<xsl:template name="ReasonAsText-Comment">
		<tr>
			<xsl:if test="local-name(.)=&quot;ReasonAsText&quot;">
				<th>
					<xsl:for-each select="child::*[local-name()=&quot;Heading&quot;]">
						<xsl:call-template name="k-8231"/>
					</xsl:for-each>
					<xsl:if test="not(child::*[local-name()=&quot;Heading&quot;])">Begrunnelse&#160;(uspes.)</xsl:if>
				</th>
			</xsl:if>
			<td colspan="{($std-col)-1}">
				<xsl:for-each select="child::*[local-name()=&quot;TextResultValue&quot;]">
					<div>
						<xsl:choose>
							<xsl:when test="count(child::*)=0">
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="."/>
								</xsl:call-template>&#160;
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()=&quot;TextCode&quot;]">
					<div>
						<xsl:choose>
							<xsl:when test="@DN"><xsl:value-of select="@DN"/>&#160;</xsl:when>
							<xsl:when test="@OT"><xsl:value-of select="@OT"/>&#160;</xsl:when>
							<xsl:when test="@V"><xsl:value-of select="@V"/>&#160;<xsl:choose>
									<xsl:when test="contains(@S,'7010')">(SNOMED)</xsl:when>
									<xsl:when test="contains(@S,'7230')">(NKKKL)</xsl:when>
									<xsl:when test="contains(@S,'7240')">(NORAKO)</xsl:when>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>
					</div>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	<!-- Visning av Annen klinisk opplysning -->
	<xsl:template name="Observation">
		<xsl:if test="child::*[local-name()=&quot;Description&quot;] or child::*[local-name()=&quot;Comment&quot;] or ../child::*[local-name()=&quot;StartDateTime&quot;] or ../child::*[local-name()=&quot;EndDateTime&quot;] or ../child::*[local-name()=&quot;OrgDate&quot;]">
			<tr>
				<td width="{((($std-col)-1)*number(not(../child::*[local-name()=&quot;StartDateTime&quot;] | ../child::*[local-name()=&quot;EndDateTime&quot;] | ../child::*[local-name()=&quot;OrgDate&quot;]))+1)*$std-td}px" colspan="{(($std-col)-1)*number(not(../child::*[local-name()=&quot;StartDateTime&quot;] | ../child::*[local-name()=&quot;EndDateTime&quot;] | ../child::*[local-name()=&quot;OrgDate&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;Description&quot;]">
						<xsl:choose>
							<xsl:when test="count(child::*)=0">
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="."/>
								</xsl:call-template>&#160;
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:if test="child::*[local-name()=&quot;Comment&quot;]">
						<div>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()=&quot;Comment&quot;]"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</td>
				<xsl:if test="../child::*[local-name()=&quot;StartDateTime&quot;] or ../child::*[local-name()=&quot;EndDateTime&quot;] or ../child::*[local-name()=&quot;OrgDate&quot;]">
					<td colspan="{($std-col)-1}">
						<xsl:if test="../child::*[local-name()=&quot;StartDateTime&quot;]">
							<div>Start:&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;StartDateTime&quot;]/@V"/>
								</xsl:call-template>
							</div>
						</xsl:if>
						<xsl:if test="../child::*[local-name()=&quot;EndDateTime&quot;]">
							<div>Slutt:&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;EndDateTime&quot;]/@V"/>
								</xsl:call-template>
							</div>
						</xsl:if>
						<xsl:if test="../child::*[local-name()=&quot;OrgDate&quot;]">
							<div>Opprinnelse:&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;OrgDate&quot;]/@V"/>
								</xsl:call-template>
							</div>
						</xsl:if>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()=&quot;CodedDescr&quot;]">
			<xsl:call-template name="Diagnosis-DiagComment-CodedDescr-CodedComment"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Undersøkelsesresultat -->
	<xsl:template name="ResultItem">
		<td>
			<xsl:for-each select="child::*[local-name()=&quot;ClinInv&quot;]">
				<div>
					<xsl:for-each select="child::*[local-name()=&quot;Id&quot;]">
						<xsl:call-template name="k-dummy"/>
					</xsl:for-each>
				</div>
				<xsl:for-each select="child::*[local-name()=&quot;Spec&quot;]">
					<div>
						<b>Spesifisert:</b>&#160;
						<xsl:call-template name="k-dummy"/>
					</div>
				</xsl:for-each>
			</xsl:for-each>
		</td>
		<td width="{$res-res-col*$std-td}px" colspan="{$res-res-col}">
			<xsl:for-each select="child::*[local-name()=&quot;Interval&quot;]">
				<xsl:if test="child::*[local-name()=&quot;Low&quot;]"><b>Nedre:</b>&#160;<xsl:value-of select="child::*[local-name()=&quot;Low&quot;]/@V"/><xsl:value-of select="child::*[local-name()=&quot;Low&quot;]/@U"/>&#160;</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;High&quot;]"><b>Øvre:</b>&#160;<xsl:value-of select="child::*[local-name()=&quot;High&quot;]/@V"/><xsl:value-of select="child::*[local-name()=&quot;High&quot;]/@U"/>&#160;</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="child::*[local-name()=&quot;DateResult&quot;]">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;DateResultValue&quot;]/@V"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="child::*[local-name()=&quot;NumResult&quot;]">
				<xsl:for-each select="child::*[local-name()=&quot;ArithmeticComp&quot;]">
					<xsl:call-template name="k-8239"/>
				</xsl:for-each>
				<xsl:value-of select="child::*[local-name()=&quot;NumResultValue&quot;]/@V"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;NumResultValue&quot;]/@U"/>&#160;
				<xsl:for-each select="../child::*[local-name()=&quot;DevResultInd&quot;]">
					<b><xsl:call-template name="k-8244"/></b>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Result&quot;]">
				<xsl:if test="child::*[local-name()=&quot;TextResultValue&quot;]">
					<div><xsl:call-template name="line-breaks"><xsl:with-param name="text" select="child::*[local-name()=&quot;TextResultValue&quot;]"/></xsl:call-template></div>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;TextCode&quot;]">
					<div>
						<xsl:call-template name="k-dummy"/>
					</div>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="child::*[local-name()=&quot;Comment&quot;]">
				<div>
					<b>Kommentar:</b>&#160;<xsl:call-template name="line-breaks"><xsl:with-param name="text" select="child::*[local-name()=&quot;Comment&quot;]"/></xsl:call-template>
				</div>
			</xsl:if>
		</td>
		<xsl:if test="//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;InvDate&quot;]">
			<td width="{$res-idate-col*$std-td}px" colspan="{$res-idate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;InvDate&quot;]/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;]">
			<td width="{$res-sdate-col*$std-td}px" colspan="{$res-sdate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;StartDateTime&quot;]/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;]">
			<td width="{$res-edate-col*$std-td}px" colspan="{$res-edate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;EndDateTime&quot;]/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;ResultItem&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]">
			<td colspan="{$res-odate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;OrgDate&quot;]/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Medikamentell behandling -->
	<xsl:template name="Medication">
		<td>
			<xsl:for-each select="child::*[local-name()=&quot;DrugId&quot;]">
				<xsl:call-template name="k-dummy"/>
			</xsl:for-each>
		</td>
		<td width="{$med-stat-col*$std-td}px" colspan="{$med-stat-col}">
			<xsl:for-each select="child::*[local-name()=&quot;Status&quot;]">
				<xsl:call-template name="k-7307"/>&#160;
			</xsl:for-each>
		</td>
		<xsl:if test="//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;UnitDose&quot;] or //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;QuantitySupplied&quot;]">
			<td width="{$med-unit-col*$std-td}px" colspan="{$med-unit-col}">
				<xsl:if test="child::*[local-name()=&quot;UnitDose&quot;]">
					<xsl:value-of select="child::*[local-name()=&quot;UnitDose&quot;]/@V"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;UnitDose&quot;]/@U"/>
					<xsl:if test="child::*[local-name()=&quot;QuantitySupplied&quot;]">&#160;x&#160;</xsl:if>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;QuantitySupplied&quot;]">
					<xsl:value-of select="child::*[local-name()=&quot;QuantitySupplied&quot;]/@V"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;QuantitySupplied&quot;]/@U"/>
				</xsl:if>&#160;
			</td>
		</xsl:if>
		<xsl:if test="//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;DosageText&quot;] or //child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;IntendedDuration&quot;]">
			<td width="{$med-text-col*$std-td}px" colspan="{$med-text-col}">
				<xsl:if test="child::*[local-name()=&quot;DosageText&quot;]">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;DosageText&quot;]"/>
					</xsl:call-template>
				</xsl:if>&#160;
				<xsl:if test="child::*[local-name()=&quot;IntendedDuration&quot;]">&#160;/&#160;<xsl:value-of select="child::*[local-name()=&quot;IntendedDuration&quot;]/@V"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;IntendedDuration&quot;]/@U"/></xsl:if>
				<xsl:if test="not(child::*[local-name()=&quot;DosageText&quot;]) and not(child::*[local-name()=&quot;IntendedDuration&quot;])">&#160;</xsl:if>
			</td>
		</xsl:if>
		<xsl:if test="//child::*[local-name()=&quot;Medication&quot;]/child::*[local-name()=&quot;Comment&quot;]">
			<td width="{$med-com-col*$std-td}px" colspan="{$med-com-col}">
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="child::*[local-name()=&quot;Comment&quot;]"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;StartDateTime&quot;]">
			<td width="{$med-sdate-col*$std-td}px" colspan="{$med-sdate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;StartDateTime&quot;]/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;EndDateTime&quot;]">
			<td width="{$med-edate-col*$std-td}px" colspan="{$med-edate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;EndDateTime&quot;]/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//child::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Medication&quot;]]/child::*[local-name()=&quot;OrgDate&quot;]">
			<td colspan="{$med-odate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;OrgDate&quot;]/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Pasient -->
	<xsl:template name="Patient">
		<xsl:if test="child::*[local-name()=&quot;Sex&quot;] or child::*[local-name()=&quot;DateOfBirth&quot;] or child::*[local-name()=&quot;AdditionalId&quot;]">
			<tr>
				<th rowspan="2">Pasientinfo</th>
				<xsl:if test="child::*[local-name()=&quot;Name&quot;]">
					<th colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;] ))+1}">Navn</th>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;OffId&quot;]">
					<th colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Name&quot;]))*number(not(child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;]))+1}">
						<xsl:choose>
							<xsl:when test="not($Anonymisert)">
								<xsl:for-each select="child::*[local-name()='TypeOffId']">
									<xsl:call-template name="k-8116"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>Fødselsnummer</xsl:otherwise>
						</xsl:choose>
					</th>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Sex&quot;]">
					<th colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;]))*number(not(child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;]))+1}">Kjønn</th>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;DateOfBirth&quot;]">
					<th colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;]))*number(not(child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;]))+1}">Fødselsdag</th>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;DateOfDeath&quot;]">
					<th colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;]))*number(not(child::*[local-name()=&quot;AdditionalId&quot;]))+1}">Dødsdag</th>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;AdditionalId&quot;]">
					<th colspan="{(($std-col)-1-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;]))}">Tilleggs-Id</th>
				</xsl:if>
			</tr>
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Name&quot;]">
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;] ))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;] ))+1}">
						<xsl:choose>
							<xsl:when test="not($Anonymisert)">
								<xsl:value-of select="child::*[local-name()='Name']"/>
							</xsl:when>
							<xsl:otherwise>Gundersen,&#160;Roland</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;OffId&quot;]">
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Name&quot;]))*number(not(child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Name&quot;]))*number(not(child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;]))+1}">
						<xsl:choose>
							<xsl:when test="not($Anonymisert)">
								<xsl:value-of select="child::*[local-name()='OffId']"/>
							</xsl:when>
							<xsl:otherwise>15076500565</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Sex&quot;]">
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;]))*number(not(child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;]))*number(not(child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;]))+1}">
						<xsl:choose>
							<xsl:when test="not($Anonymisert)">
								<xsl:for-each select="child::*[local-name()='Sex']">
									<xsl:call-template name="k-3101"/>&#160;
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>Mann</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;DateOfBirth&quot;]">
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;]))*number(not(child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;]))*number(not(child::*[local-name()=&quot;DateOfDeath&quot;] | child::*[local-name()=&quot;AdditionalId&quot;]))+1}">
						<xsl:choose>
							<xsl:when test="not($Anonymisert)">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfBirth']/@V"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>15.07.65</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;DateOfDeath&quot;]">
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;]))*number(not(child::*[local-name()=&quot;AdditionalId&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;]))*number(not(child::*[local-name()=&quot;AdditionalId&quot;]))+1}">
						<xsl:choose>
							<xsl:when test="not($Anonymisert)">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfDeath']/@V"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>&#160;</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;AdditionalId&quot;]">
					<td colspan="{(($std-col)-1-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;]))}">
						<xsl:choose>
							<xsl:when test="not($Anonymisert)">
								<xsl:for-each select="child::*[local-name()=&quot;AdditionalId&quot;]">
									<div>
										<xsl:if test="child::*[local-name()=&quot;Type&quot;]"><b><xsl:value-of select="child::*[local-name()=&quot;Type&quot;]/@V"/>:</b>&#160;</xsl:if>
										<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
									</div>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>&#160;</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()=&quot;PatientPrecaution&quot;]">
			<xsl:if test="not($Anonymisert)">
				<xsl:if test="position()=1">
					<xsl:if test="../child::*[local-name()=&quot;Sex&quot;] or ../child::*[local-name()=&quot;DateOfBirth&quot;] or ../child::*[local-name()=&quot;AdditionalId&quot;]">
						<tr><td colspan="{$std-col}"><hr/></td></tr>
					</xsl:if>
					<tr>
						<th rowspan="{last()+1}">Advarsel til tjenesteyter</th>
						<xsl:if test="..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;Precaution&quot;]">
							<th colspan="{(($std-col)-2)*number(not(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;StartDateTime&quot;] | ..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]))+1}">Advarsel</th>
						</xsl:if>
						<xsl:if test="..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;StartDateTime&quot;]">
							<th colspan="{(($std-col)-2-number(boolean(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;Precaution&quot;])))*number(not(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]))+1}">Starttidspunkt</th>
						</xsl:if>
						<xsl:if test="..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]">
							<th colspan="{(($std-col)-1-number(boolean(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;Precaution&quot;]))-number(boolean(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;StartDateTime&quot;])))}">Sluttidspunkt</th>
						</xsl:if>
					</tr>
				</xsl:if>
				<tr>
					<xsl:if test="..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;Precaution&quot;]">
						<td width="{((($std-col)-2)*number(not(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;StartDateTime&quot;] | ..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;StartDateTime&quot;] | ..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]))+1}">
							<xsl:value-of select="child::*[local-name()=&quot;Precaution&quot;]"/>&#160;
						</td>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;StartDateTime&quot;]">
						<td width="{((($std-col)-2-number(boolean(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;Precaution&quot;])))*number(not(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-number(boolean(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;Precaution&quot;])))*number(not(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]))+1}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;StartDateTime&quot;]/@V"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]">
						<td colspan="{(($std-col)-1-number(boolean(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;Precaution&quot;]))-number(boolean(..//child::*[local-name()=&quot;PatientPrecaution&quot;]/child::*[local-name()=&quot;StartDateTime&quot;])))}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;EndDateTime&quot;]/@V"/>
							</xsl:call-template>
						</td>
					</xsl:if>
				</tr>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;PatientRelParty&quot;]">
			<xsl:if test="not($Anonymisert)">
				<xsl:if test="position()=1">
					<xsl:if test="../child::*[local-name()=&quot;Sex&quot;] or ../child::*[local-name()=&quot;DateOfBirth&quot;] or ../child::*[local-name()=&quot;AdditionalId&quot;] or ../child::*[local-name()=&quot;PatientPrecaution&quot;]">
						<tr><td colspan="{$std-col}"><hr/></td></tr>
					</xsl:if>
					<tr>
						<th rowspan="{last()+1}">Pasientrelatert part</th>
						<xsl:if test="..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Relation&quot;]">
							<th colspan="{(($std-col)-2)*number(not(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Name&quot;] | ..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;RelPartyOffId&quot;] | ..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Address&quot;]))+1}">Relasjon</th>
						</xsl:if>
						<xsl:if test="..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Name&quot;]">
							<th colspan="{(($std-col)-2-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Relation&quot;])))*number(not(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;RelPartyOffId&quot;] | ..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Address&quot;]))+1}">Navn</th>
						</xsl:if>
						<xsl:if test="..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;RelPartyOffId&quot;]">
							<th colspan="{(($std-col)-2-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Relation&quot;]))-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Name&quot;])))*number(not(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Address&quot;]))+1}">Fødselsnummer</th>
						</xsl:if>
						<xsl:if test="..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Address&quot;]">
							<th colspan="{(($std-col)-1-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Relation&quot;]))-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Name&quot;]))-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;RelPartyOffId&quot;])))}">Adresse</th>
						</xsl:if>
					</tr>
				</xsl:if>
				<tr>
					<xsl:if test="..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Relation&quot;]">
						<td width="{((($std-col)-2)*number(not(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Name&quot;] | ..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;RelPartyOffId&quot;] | ..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Address&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Name&quot;] | ..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;RelPartyOffId&quot;] | ..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Address&quot;]))+1}">
							<xsl:for-each select="child::*[local-name()=&quot;Relation&quot;]">
								<xsl:call-template name="k-7317"/>&#160;
							</xsl:for-each>
						</td>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Name&quot;]">
						<td width="{((($std-col)-2-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Relation&quot;])))*number(not(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;RelPartyOffId&quot;] | ..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Address&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Relation&quot;])))*number(not(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;RelPartyOffId&quot;] | ..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Address&quot;]))+1}">
							<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
						</td>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;RelPartyOffId&quot;]">
						<td width="{((($std-col)-2-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Relation&quot;]))-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Name&quot;])))*number(not(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Address&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Relation&quot;]))-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Name&quot;])))*number(not(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Address&quot;]))+1}">
							<xsl:value-of select="child::*[local-name()=&quot;RelPartyOffId&quot;]"/>
						</td>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Address&quot;]">
						<td colspan="{(($std-col)-1-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Relation&quot;]))-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;Name&quot;]))-number(boolean(..//child::*[local-name()=&quot;PatientRelParty&quot;]/child::*[local-name()=&quot;RelPartyOffId&quot;])))}">
							<xsl:for-each select="child::*[local-name()=&quot;Address&quot;]">
								<xsl:call-template name="Address"/>
							</xsl:for-each>
						</td>
					</xsl:if>
				</tr>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Hendelse -->
	<xsl:template name="Event">
		<tr>
			<td width="{$event-type-col*$std-td}px" colspan="{$event-type-col}">
				<b>
					<xsl:if test="local-name(..)=&quot;Event&quot;">Del-hendelse:&#160;</xsl:if>
					<xsl:for-each select="child::*[local-name()=&quot;Service&quot;]/child::*[local-name()=&quot;AdmCat&quot;]">
						<xsl:call-template name="k-8240"/>&#160;
					</xsl:for-each>
				</b>
				<xsl:if test="child::*[local-name()=&quot;ServType&quot;]/@V != &quot;N&quot;">
					<div><b>Tjenstetype:&#160;</b>
						<xsl:for-each select="child::*[local-name()=&quot;ServType&quot;]">
							<xsl:call-template name="k-7309"/>&#160;
						</xsl:for-each>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Recipient&quot;]/@V != &quot;1&quot;">
					<div>
						(<xsl:for-each select="child::*[local-name()=&quot;Recipient&quot;]">
							<xsl:call-template name="k-8250"/>&#160;
						</xsl:for-each>)
					</div>
				</xsl:if>
			</td>
			<xsl:if test="..//child::*[local-name()=&quot;EventLocation&quot;]">
				<td width="{$event-place-col*$std-td}px" colspan="{$event-place-col}">
					<xsl:if test="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]">
						<div>
							<xsl:if test="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;Name&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;Name&quot;]"/>&#160;
							</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;Name&quot;] and child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;Dept&quot;]/child::*[local-name()=&quot;Name&quot;]">-&#160;</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;Dept&quot;]/child::*[local-name()=&quot;Name&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;Dept&quot;]/child::*[local-name()=&quot;Name&quot;]"/>&#160;
							</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;SubLocation&quot;]/child::*[local-name()=&quot;Place&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;SubLocation&quot;]/child::*[local-name()=&quot;Place&quot;]"/>&#160;
							</xsl:if>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Role&quot;]">
						<div><b>Rolle:&#160;</b>
							<xsl:for-each select="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Role&quot;]">
								<xsl:call-template name="k-8251"/>&#160;
							</xsl:for-each>
							<xsl:for-each select="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;SubLocation&quot;]/child::*[local-name()=&quot;Type&quot;]">
								<xsl:call-template name="k-8242"/>&#160;
							</xsl:for-each>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Address&quot;]">
						<div>
							<xsl:for-each select="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Address&quot;]">
								<xsl:call-template name="Address"/>
							</xsl:for-each>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;StartDateTime&quot;] or ..//child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;EndDateTime&quot;] or ..//child::*[local-name()=&quot;ExpDuration&quot;]">
				<td width="{$event-time-col*$std-td}px" colspan="{$event-time-col}">
					<xsl:if test="child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;StartDateTime&quot;]">
						<b>Start:&#160;</b>
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;StartDateTime&quot;]/@V"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]">
						<b>Slutt:&#160;</b>
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;ReportedEvent&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]/@V"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;StartDateTime&quot;] or child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]">
						<div>
							<xsl:if test="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;StartDateTime&quot;]">
								<b>Lokasjonstart:&#160;</b>
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;StartDateTime&quot;]/@V"/>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]">
								<b>Lokasjonslutt:&#160;</b>
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;EventLocation&quot;]/child::*[local-name()=&quot;EndDateTime&quot;]/@V"/>
								</xsl:call-template>
							</xsl:if>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;ExpDuration&quot;]">
						<div><b>Forventet&#160;varighet:&#160;</b>
						<xsl:value-of select="child::*[local-name()=&quot;ExpDuration&quot;]/@V"/><xsl:value-of select="child::*[local-name()=&quot;ExpDuration&quot;]/@U"/>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()=&quot;AdmOutcome&quot;]">
				<td width="{$event-out-col*$std-td}px" colspan="{$event-out-col}">
					<xsl:for-each select="child::*[local-name()=&quot;AdmOutcome&quot;]">
						<xsl:call-template name="k-7300"/>&#160;
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()=&quot;Priority&quot;]">
				<td width="{$event-pri-col*$std-td}px" colspan="{$event-pri-col}">
					<xsl:for-each select="child::*[local-name()=&quot;Priority&quot;]">
						<xsl:call-template name="k-8304"/>&#160;
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()=&quot;AssRequest&quot;]">
				<td colspan="{$event-ass-col}">
					<xsl:for-each select="child::*[local-name()=&quot;AssRequest&quot;]/child::*[local-name()=&quot;MsgType&quot;]">
						<xsl:call-template name="k-7315"/>&#160;
					</xsl:for-each>
					<xsl:if test="child::*[local-name()=&quot;AssRequest&quot;]/child::*[local-name()=&quot;IssueDate&quot;]">
						<div><b>Utsted:&#160;</b>
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;AssRequest&quot;]/child::*[local-name()=&quot;IssueDate&quot;]/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
		</tr>
		<!-- Id (Id) er valgt utelatt -->
	</xsl:template>
	<!-- Visning av Tjenesteyter -->
	<xsl:template name="ServProvider">
		<xsl:param name="col"/>
		<tr>
			<th colspan="{$col}" class="h3">Tjenesteyter<xsl:if test="child::*[local-name()=&quot;HCP&quot;]/child::*[local-name()=&quot;MedSpeciality&quot;]"> - Spesialitet:&#160;<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]/child::*[local-name()=&quot;MedSpeciality&quot;]">
						<xsl:choose>
							<xsl:when test="contains(@S, '7426')">
								<xsl:call-template name="k-7426"/>
							</xsl:when>
							<xsl:when test="contains(@S, '8451')">
								<xsl:call-template name="k-8451"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="k-dummy"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Henvisende instans -->
	<xsl:template name="Requester">
		<xsl:param name="col"/>
		<tr>
			<th colspan="{$col}" class="h3">Rekvirent<xsl:if test="child::*[local-name()=&quot;HCP&quot;]/child::*[local-name()=&quot;MedSpeciality&quot;]"> - Spesialitet:&#160;<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]/child::*[local-name()=&quot;MedSpeciality&quot;]">
						<xsl:choose>
							<xsl:when test="contains(@S, '7426')">
								<xsl:call-template name="k-7426"/>
							</xsl:when>
							<xsl:when test="contains(@S, '8451')">
								<xsl:call-template name="k-8451"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="k-dummy"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Kopimottaker -->
	<xsl:template name="CopyDest">
		<xsl:param name="col"/>
		<tr>
			<th colspan="{$col}" class="h3">Kopimottaker<xsl:if test="child::*[local-name()=&quot;CopyDestRole&quot;]/child::*[local-name()=&quot;MsgType&quot;]"> - kopi&#160;av:&#160;<xsl:for-each select="child::*[local-name()=&quot;CopyDestRole&quot;]/child::*[local-name()=&quot;MsgType&quot;]">
						<xsl:call-template name="k-8279"/>
					</xsl:for-each>
				</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Tilknyttet tjeneteyter -->
	<xsl:template name="RelServProvider">
		<xsl:param name="col"/>
		<tr>
			<th colspan="{$col}" class="h3">
				<xsl:for-each select="child::*[local-name()=&quot;Relation&quot;]">
					<xsl:call-template name="k-8254"/>
				</xsl:for-each>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Opprinnelse til klinisk opplysning -->
	<xsl:template name="Origin">
		<xsl:param name="col"/>
		<tr>
			<th colspan="{$col}" class="h3">Opprinnelse&#160;til&#160;klinisk&#160;opplysning<xsl:if test="child::*[local-name()=&quot;HCP&quot;]/child::*[local-name()=&quot;MedSpeciality&quot;]"> - Spesialitet:&#160;<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]/child::*[local-name()=&quot;MedSpeciality&quot;]">
						<xsl:choose>
							<xsl:when test="contains(@S, '7426')">
								<xsl:call-template name="k-7426"/>
							</xsl:when>
							<xsl:when test="contains(@S, '8451')">
								<xsl:call-template name="k-8451"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="k-dummy"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Tilknyttet klinisk tjenesteyter -->
	<xsl:template name="RelHCProvider">
		<xsl:param name="col"/>
		<tr>
			<th colspan="{$col}" class="h3">
				<xsl:for-each select="child::*[local-name()=&quot;Relation&quot;]">
					<xsl:call-template name="k-7318"/>
				</xsl:for-each>
			</th>
		</tr>
		<!-- Rolle (Role) er valgt utelatt -->
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Tilknyttet klinisk tjenesteyter -->
	<xsl:template name="PatRelHCP">
		<xsl:param name="col"/>
		<tr>
			<th colspan="{$col}" class="h3">
				<xsl:for-each select="child::*[local-name()=&quot;Relation&quot;]">
					<xsl:call-template name="k-8254"/>
				</xsl:for-each>
				<xsl:if test="child::*[local-name()=&quot;StartDateTime&quot;] or child::*[local-name()=&quot;EndDateTime&quot;]">&#160;Tidsrom:&#160;<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;StartDateTime&quot;]/@V"/>
					</xsl:call-template>&#160;-:&#160;<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;EndDateTime&quot;]/@V"/>
					</xsl:call-template>&#160;
				</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
		<!-- Rolle (Role) er valgt utelatt -->
	</xsl:template>
	<!-- Visning av Helsetjenesteenhet -->
	<xsl:template name="HCP">
		<xsl:param name="col"/>
		<xsl:for-each select="child::*[local-name()=&quot;Inst&quot;]">
			<tr>
				<xsl:call-template name="Inst">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;Dept&quot;]">
			<tr>
				<xsl:call-template name="Dept">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;HCPerson&quot;]">
			<tr>
				<xsl:call-template name="HCPerson">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;HCProf&quot;]">
			<tr>
				<xsl:call-template name="HCProf">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Address&quot;]">
			<xsl:variable name="antall-tel" select="count(child::*[local-name()=&quot;TeleAddress&quot;])"/>
			<tr>
				<xsl:for-each select="child::*[local-name()=&quot;TeleAddress&quot;]">
					<xsl:call-template name="TeleAddress">
						<xsl:with-param name="col" select="(($col)-1)*number(not(../child::*[local-name()=&quot;Type&quot;] and (../child::*[local-name()=&quot;PostalCode&quot;] or ../child::*[local-name()=&quot;City&quot;])))+1"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:if test="child::*[local-name()=&quot;Type&quot;] and (child::*[local-name()=&quot;PostalCode&quot;] or child::*[local-name()=&quot;City&quot;])">
					<xsl:call-template name="Address">
						<xsl:with-param name="col" select="($col)-1-($antall-tel)*2"/>
					</xsl:call-template>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<!-- Henvisende instans sin helsetjenesteenhetsid (PartyIdByRequester) og Tjenesteyters id av helsetjenesteenhet (PartyIdByServProv) er valgt utelatt -->
	</xsl:template>
	<!-- Visning av Person i helsevesenet -->
	<xsl:template name="HCProf">
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()=&quot;Type&quot;] or child::*[local-name()=&quot;Name&quot;]">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;Type&quot;]">
						<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]">
							<xsl:call-template name="k-9060"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Helsepersonell</xsl:otherwise>
				</xsl:choose>
			</th>
			<td width="{$std-td*2}px">
				<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
			</td>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Id&quot;] or child::*[local-name()=&quot;AdditionalId&quot;]">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;TypeId&quot;]">
						<xsl:for-each select="child::*[local-name()=&quot;TypeId&quot;]">
							<xsl:call-template name="k-8116"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Id</xsl:otherwise>
				</xsl:choose>
			</th>
			<xsl:choose>
				<xsl:when test="child::*[local-name()=&quot;AdditionalId&quot;]">
					<td width="{$std-td}px">
						<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="{($col)-3}">
						<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="child::*[local-name()=&quot;AdditionalId&quot;]">
				<xsl:variable name="antall-id" select="count(child::*[local-name()=&quot;AdditionalId&quot;])"/>
				<xsl:for-each select="child::*[local-name()=&quot;AdditionalId&quot;]">
					<xsl:call-template name="AdditionalId">
						<xsl:with-param name="col">
							<xsl:choose>
								<xsl:when test="position() = $antall-id">
									<xsl:value-of select="($col)-3-($antall-id)*2"/>
								</xsl:when>
								<xsl:otherwise>1</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Institusjon -->
	<xsl:template name="Inst">
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()=&quot;Name&quot;]">
			<th>Navn</th>
			<td width="{$std-td*2}px">
				<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
			</td>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Id&quot;] or child::*[local-name()=&quot;AdditionalId&quot;]">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;TypeId&quot;]">
						<xsl:for-each select="child::*[local-name()=&quot;TypeId&quot;]">
							<xsl:call-template name="k-9051"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Id</xsl:otherwise>
				</xsl:choose>
			</th>
			<xsl:choose>
				<xsl:when test="child::*[local-name()=&quot;AdditionalId&quot;]">
					<td width="{$std-td}px">
						<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="{($col)-3}">
						<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="child::*[local-name()=&quot;AdditionalId&quot;]">
				<xsl:variable name="antall-id" select="count(child::*[local-name()=&quot;AdditionalId&quot;])"/>
				<xsl:for-each select="child::*[local-name()=&quot;AdditionalId&quot;]">
					<xsl:call-template name="AdditionalId">
						<xsl:with-param name="col">
							<xsl:choose>
								<xsl:when test="position() = $antall-id">
									<xsl:value-of select="($col)-3-($antall-id)*2"/>
								</xsl:when>
								<xsl:otherwise>1</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
		<!-- Type (Type) er valgt utelatt -->
	</xsl:template>
	<!-- Visning av Avdeling -->
	<xsl:template name="Dept">
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()=&quot;Type&quot;] or child::*[local-name()=&quot;Name&quot;]">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;Type&quot;]">
						<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]">
							<xsl:call-template name="k-8624"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Avdeling</xsl:otherwise>
				</xsl:choose>
			</th>
			<td width="{$std-td*2}px">
				<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
			</td>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Id&quot;] or child::*[local-name()=&quot;AdditionalId&quot;]">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;TypeId&quot;]">
						<xsl:for-each select="child::*[local-name()=&quot;TypeId&quot;]">
							<xsl:call-template name="k-9051"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Id</xsl:otherwise>
				</xsl:choose>
			</th>
			<xsl:choose>
				<xsl:when test="child::*[local-name()=&quot;AdditionalId&quot;]">
					<td width="{$std-td}px">
						<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="{($col)-3}">
						<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="child::*[local-name()=&quot;AdditionalId&quot;]">
				<xsl:variable name="antall-id" select="count(child::*[local-name()=&quot;AdditionalId&quot;])"/>
				<xsl:for-each select="child::*[local-name()=&quot;AdditionalId&quot;]">
					<xsl:call-template name="AdditionalId">
						<xsl:with-param name="col">
							<xsl:choose>
								<xsl:when test="position() = $antall-id">
									<xsl:value-of select="($col)-3-($antall-id)*2"/>
								</xsl:when>
								<xsl:otherwise>1</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Person i organisasjon -->
	<xsl:template name="HCPerson">
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()=&quot;Name&quot;]">
			<th>Helsepersonell</th>
			<td width="{$std-td*2}px">
				<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
			</td>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Id&quot;] or child::*[local-name()=&quot;AdditionalId&quot;]">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;TypeId&quot;]">
						<xsl:for-each select="child::*[local-name()=&quot;TypeId&quot;]">
							<xsl:call-template name="k-8116"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Id</xsl:otherwise>
				</xsl:choose>
			</th>
			<xsl:choose>
				<xsl:when test="child::*[local-name()=&quot;AdditionalId&quot;]">
					<td width="{$std-td}px">
						<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="{($col)-3}">
						<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="child::*[local-name()=&quot;AdditionalId&quot;]">
				<xsl:variable name="antall-id" select="count(child::*[local-name()=&quot;AdditionalId&quot;])"/>
				<xsl:for-each select="child::*[local-name()=&quot;AdditionalId&quot;]">
					<xsl:call-template name="AdditionalId">
						<xsl:with-param name="col">
							<xsl:choose>
								<xsl:when test="position() = $antall-id">
									<xsl:value-of select="($col)-3-($antall-id)*2"/>
								</xsl:when>
								<xsl:otherwise>1</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Alternativ id -->
	<xsl:template name="AdditionalId">
		<xsl:param name="col"/>
		<th>
			<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]">
				<xsl:choose>
					<xsl:when test="local-name(../..)='Patient' or local-name(../..)='HCProf' or local-name(../..)='HCPerson'">
						<xsl:call-template name="k-8116"/>
					</xsl:when>
					<xsl:when test="local-name(..)='Inst' or local-name(..)='Dept'">
						<xsl:call-template name="k-9051"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="k-dummy"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</th>
		<td colspan="{$col}">
			<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
		</td>
	</xsl:template>
	<!-- Visning av Adresse -->
	<xsl:template name="Address">
		<xsl:param name="col"/>
		<th>
			<xsl:choose>
				<xsl:when test="child::*[local-name()=&quot;Type&quot;]">
					<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]">
						<xsl:call-template name="k-3401"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>Adresse</xsl:otherwise>
			</xsl:choose>
		</th>
		<td colspan="{$col}">
			<xsl:if test="child::*[local-name()=&quot;StreetAdr&quot;]">
				<xsl:value-of select="child::*[local-name()=&quot;StreetAdr&quot;]"/>,&#160;</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;PostalCode&quot;]">
				<xsl:value-of select="child::*[local-name()=&quot;PostalCode&quot;]"/>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;City&quot;]">&#160;<xsl:value-of select="child::*[local-name()=&quot;City&quot;]"/>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;CityDistr&quot;]">,&#160;<xsl:for-each select="child::*[local-name()=&quot;CityDistr&quot;]"><xsl:call-template name="k-3403"/></xsl:for-each>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;County&quot;]">,&#160;<xsl:for-each select="child::*[local-name()=&quot;County&quot;]"><xsl:call-template name="k-3402"/></xsl:for-each>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Country&quot;]">,&#160;<xsl:for-each select="child::*[local-name()=&quot;Country&quot;]"><xsl:call-template name="k-9043"/></xsl:for-each>
			</xsl:if>
		</td>
	</xsl:template>
	<!-- Visning av Telekommunikasjon -->
	<xsl:template name="TeleAddress">
		<xsl:param name="col"/>
		<th>
			<xsl:choose>
				<xsl:when test="starts-with(@V, 'tel:') or starts-with(@V, 'callto:')">Telefon</xsl:when>
				<xsl:when test="starts-with(@V, 'fax:')">Faks</xsl:when>
				<xsl:when test="starts-with(@V, 'mailto:')">e-post</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before(@V, ':')"/>
				</xsl:otherwise>
			</xsl:choose>
		</th>
		<td colspan="{$col}">
			<xsl:value-of select="substring-after(@V, ':')"/>
		</td>
	</xsl:template>
	<!-- Visning av vedllegg -->
	<xsl:template name="RefDoc">
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()=&quot;MsgType&quot;] or child::*[local-name()=&quot;Id&quot;] or child::*[local-name()=&quot;IssueDate&quot;] or child::*[local-name()=&quot;MimeType&quot;] or child::*[local-name()=&quot;Compression&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;MsgType&quot;]">
					<th>Type</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()=&quot;Id&quot;] | child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;MimeType&quot;] | child::*[local-name()=&quot;Compression&quot;]))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()=&quot;Id&quot;] | child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;MimeType&quot;] | child::*[local-name()=&quot;Compression&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;MsgType&quot;]">
							<xsl:call-template name="k-8114"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Id&quot;]">
					<th>Id</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;MsgType&quot;])*2)*number(not(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;MimeType&quot;] | child::*[local-name()=&quot;Compression&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;MsgType&quot;])*2)*number(not(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;MimeType&quot;] | child::*[local-name()=&quot;Compression&quot;]))+1}">
						<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;IssueDate&quot;]">
					<th>Utstedt-dato</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;MsgType&quot;] | child::*[local-name()=&quot;Id&quot;])*2)*number(not(child::*[local-name()=&quot;MimeType&quot;] | child::*[local-name()=&quot;Compression&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;MsgType&quot;] | child::*[local-name()=&quot;Id&quot;])*2)*number(not(child::*[local-name()=&quot;MimeType&quot;] | child::*[local-name()=&quot;Compression&quot;]))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;IssueDate&quot;]/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;MimeType&quot;]">
					<th>Mimetype</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;MsgType&quot;] | child::*[local-name()=&quot;Id&quot;] | child::*[local-name()=&quot;IssueDate&quot;])*2)*number(not(child::*[local-name()=&quot;Compression&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;MsgType&quot;] | child::*[local-name()=&quot;Id&quot;] | child::*[local-name()=&quot;IssueDate&quot;])*2)*number(not(child::*[local-name()=&quot;Compression&quot;]))+1}">
						<xsl:value-of select="child::*[local-name()=&quot;MimeType&quot;]"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Compression&quot;]">
					<th>Komprimering</th>
					<td colspan="{($col)-1-count(child::*[local-name()=&quot;MsgType&quot;] | child::*[local-name()=&quot;Id&quot;] | child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;MimeType&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;Compression&quot;]">
							<xsl:call-template name="k-1204"/>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Description&quot;]">
			<tr>
				<th>Beskrivelse</th>
				<td colspan="{($col)-1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Description&quot;]"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Content&quot;] or child::*[local-name()=&quot;FileReference&quot;]">
			<xsl:choose>
				<xsl:when test="contains(child::*[local-name()=&quot;MimeType&quot;],'image')">
					<tr>
						<th>Bilde</th>
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;FileReference&quot;]">
								<td colspan="{($col)-1}">
									<img>
										<xsl:attribute name="src"><xsl:value-of select="child::*[local-name()=&quot;FileReference&quot;]"/></xsl:attribute>
										<xsl:attribute name="alt">Bilde fra ekstern URL</xsl:attribute>
									</img>
								</td>
							</xsl:when>
							<xsl:when test="child::*[local-name()=&quot;Content&quot;]">
								<td colspan="{($col)-1}">
									<xsl:choose>
										<xsl:when test="child::*[local-name()=&quot;Content&quot;]/base:Base64Container">
											<img>
												<xsl:attribute name="src"><xsl:value-of select="concat('data:',child::*[local-name()=&quot;MimeType&quot;],';base64,',child::*[local-name()=&quot;Content&quot;]/base:Base64Container)"/></xsl:attribute>
												<xsl:attribute name="alt">Bilde vedlagt som base64-kode</xsl:attribute>
											</img>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="child::*[local-name()=&quot;Content&quot;]"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</xsl:when>
						</xsl:choose>
					</tr>
				</xsl:when>
				<xsl:when test="contains(child::*[local-name()=&quot;MimeType&quot;],'pdf')">
					<tr>
						<th>pdf</th>
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;FileReference&quot;]">
								<td colspan="{($col)-1}">
									<object>
										<xsl:attribute name="data"><xsl:value-of select="concat(child::*[local-name()=&quot;FileReference&quot;],'&#35;view&#61;FitH&#38;toolbar&#61;1')"/></xsl:attribute>
										<xsl:attribute name="type">application/pdf</xsl:attribute>
										<xsl:attribute name="width">100%</xsl:attribute>
										<xsl:attribute name="height">500px</xsl:attribute>
									</object>
								</td>
							</xsl:when>
							<xsl:when test="child::*[local-name()=&quot;Content&quot;]">
								<td colspan="{($col)-1}">
									<xsl:choose>
										<xsl:when test="child::*[local-name()=&quot;Content&quot;]/base:Base64Container">
											<object>
												<xsl:attribute name="data"><xsl:value-of select="concat('data:application/pdf;base64,',child::*[local-name()=&quot;Content&quot;]/base:Base64Container)"/></xsl:attribute>
												<xsl:attribute name="type">application/pdf</xsl:attribute>
												<xsl:attribute name="width">100%</xsl:attribute>
												<xsl:attribute name="height">500px</xsl:attribute>
											</object>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="child::*[local-name()=&quot;Content&quot;]"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</xsl:when>
						</xsl:choose>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;Content&quot;]">
							<xsl:value-of select="child::*[local-name()=&quot;Content&quot;]"/>
						</xsl:when>
						<xsl:when test="child::*[local-name()=&quot;FileReference&quot;]">
							<xsl:value-of select="child::*[local-name()=&quot;FileReference&quot;]"/>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
