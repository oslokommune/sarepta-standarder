<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:ref="http://www.kith.no/xmlstds/henvisning/2012-02-15" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:po="http://www.kith.no/xmlstds/po/poKomponent/2009-06-30" xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" exclude-result-prefixes="ref xhtml po fk1">
	<xsl:import href="../../Felleskomponenter/funksjoner.xsl"/>
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	<!--
Inngår i Hdirs visningsfiler versjon 1.0

FORMÅL
XSLT for generering av html fra Henvisning v1.1

ENDRINGER:
01.04.2012: Første versjon

Laget i XMLSpy v2012 rel2 (http://www.altova.com) av Jan Sigurd Dragsjø (helsedirektoratet.no)
-->
	<!-- Variabel for hvilken stil visning har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'No-line-doc'"/>
	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="8"/>
	<!-- Variabler for beregning av antall kolonner i legemiddel-tabellen -->
	<xsl:variable name="med-stat-col" select="(($std-col)-2)*number(not(//ref:Medication/ref:UnitDose | //ref:Medication/ref:QuantitySupplied | //ref:Medication/ref:DosageText | //ref:Medication/ref:IntendedDuration | //ref:Medication/ref:Comment | //ref:InfItem[ref:Medication]/ref:StartDateTime | //ref:InfItem[ref:Medication]/ref:EndDateTime | //ref:InfItem[ref:Medication]/ref:OrgDate))+1"/>
	<xsl:variable name="med-unit-col" select="(($std-col)-3)*number(not(//ref:Medication/ref:DosageText | //ref:Medication/ref:IntendedDuration | //ref:Medication/ref:Comment | //ref:InfItem[ref:Medication]/ref:StartDateTime | //ref:InfItem[ref:Medication]/ref:EndDateTime | //ref:InfItem[ref:Medication]/ref:OrgDate))+1"/>
	<xsl:variable name="med-text-col" select="(($std-col)-3-number(boolean(//ref:Medication/ref:UnitDose | //ref:Medication/ref:QuantitySupplied)))*number(not(//ref:Medication/ref:Comment | //ref:InfItem[ref:Medication]/ref:StartDateTime | //ref:InfItem[ref:Medication]/ref:EndDateTime | //ref:InfItem[ref:Medication]/ref:OrgDate))+1"/>
	<xsl:variable name="med-com-col" select="(($std-col)-3-number(boolean(//ref:Medication/ref:UnitDose | //ref:Medication/ref:QuantitySupplied | //ref:Medication/ref:DosageText | //ref:Medication/ref:IntendedDuration)))*number(not(//ref:InfItem[ref:Medication]/ref:StartDateTime | //ref:InfItem[ref:Medication]/ref:EndDateTime | //ref:InfItem[ref:Medication]/ref:OrgDate))+1"/>
	<xsl:variable name="med-sdate-col" select="(($std-col)-3-number(boolean(//ref:Medication/ref:UnitDose | //ref:Medication/ref:QuantitySupplied))-number(boolean(//ref:Medication/ref:DosageText | //ref:Medication/ref:IntendedDuration))-number(boolean(//ref:Medication/ref:Comment)))*number(not(//ref:InfItem[ref:Medication]/ref:EndDateTime | //ref:InfItem[ref:Medication]/ref:OrgDate))+1"/>
	<xsl:variable name="med-edate-col" select="(($std-col)-3-number(boolean(//ref:Medication/ref:UnitDose | //ref:Medication/ref:QuantitySupplied))-number(boolean(//ref:Medication/ref:DosageText | //ref:Medication/ref:IntendedDuration))-number(boolean(//ref:Medication/ref:Comment))-number(boolean(//ref:InfItem[ref:Medication]/ref:StartDateTime)))*number(not(//ref:InfItem[ref:Medication]/ref:OrgDate))+1"/>
	<xsl:variable name="med-odate-col" select="(($std-col)-2-number(boolean(//ref:Medication/ref:UnitDose | //ref:Medication/ref:QuantitySupplied))-number(boolean(//ref:Medication/ref:DosageText | //ref:Medication/ref:IntendedDuration))-number(boolean(//ref:Medication/ref:Comment))-number(boolean(//ref:InfItem[ref:Medication]/ref:StartDateTime))-number(boolean(//ref:InfItem[ref:Medication]/ref:EndDateTime)))"/>
	<!-- Variabler for beregning av antall kolonner i resultat-tabellen -->
	<xsl:variable name="res-res-col" select="(($std-col)-2)*number(not(//ref:ResultItem/ref:DevResultInd | //ref:ResultItem/ref:InvDate | //ref:InfItem[ref:ResultItem]/ref:StartDateTime | //ref:InfItem[ref:ResultItem]/ref:EndDateTime | //ref:InfItem[ref:ResultItem]/ref:OrgDate))+1"/>
	<xsl:variable name="res-dev-col" select="(($std-col)-3)*number(not(//ref:ResultItem/ref:InvDate | //ref:InfItem[ref:ResultItem]/ref:StartDateTime | //ref:InfItem[ref:ResultItem]/ref:EndDateTime | //ref:InfItem[ref:ResultItem]/ref:OrgDate))+1"/>
	<xsl:variable name="res-idate-col" select="(($std-col)-3-number(boolean(//ref:ResultItem/ref:DevResultInd)))*number(not(//ref:InfItem[ref:ResultItem]/ref:StartDateTime | //ref:InfItem[ref:ResultItem]/ref:EndDateTime | //ref:InfItem[ref:ResultItem]/ref:OrgDate))+1"/>
	<xsl:variable name="res-sdate-col" select="(($std-col)-3-number(boolean(//ref:ResultItem/ref:DevResultInd))-number(boolean(//ref:ResultItem/ref:InvDate)))*number(not(//ref:InfItem[ref:ResultItem]/ref:EndDateTime | //ref:InfItem[ref:ResultItem]/ref:OrgDate))+1"/>
	<xsl:variable name="res-edate-col" select="(($std-col)-3-number(boolean(//ref:ResultItem/ref:DevResultInd))-number(boolean(//ref:ResultItem/ref:InvDate))-number(boolean(//ref:InfItem[ref:ResultItem]/ref:StartDateTime)))*number(not(//ref:InfItem[ref:ResultItem]/ref:OrgDate))+1"/>
	<xsl:variable name="res-odate-col" select="(($std-col)-2-number(boolean(//ref:ResultItem/ref:DevResultInd))-number(boolean(//ref:ResultItem/ref:InvDate))-number(boolean(//ref:InfItem[ref:ResultItem]/ref:StartDateTime))-number(boolean(//ref:InfItem[ref:ResultItem]/ref:EndDateTime)))"/>
	
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Henvisning</title>
				<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
				<style type="text/css">
					<xsl:value-of select="document('../../Felleskomponenter/KITH-visning.css')" disable-output-escaping="yes"/>
				</style>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<!-- Meldingshodet - avsender og mottaker-informasjon -->
	<xsl:template name="Header">
		<div class="No-line-top">
			<div class="No-line-header">
				<div class="No-line-headerContent">
					<div class="No-line-caption">Avsender &#160;</div>
					<div class="No-line-content">
						<xsl:apply-templates select="ref:Requester"/>
					</div>
				</div>
				<xsl:choose>
					<xsl:when test="ref:Patient">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Pasient &#160;</div>
							<div class="No-line-content">
								<xsl:apply-templates select="ref:Patient"/>
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
					<div class="No-line-caption">Mottaker &#160;</div>
					<div class="No-line-content">
						<xsl:apply-templates select="ref:ServProvider"/>
					</div>
				</div>
				<xsl:choose>
					<xsl:when test="ref:CopyDest">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Kopimottaker(e) &#160;</div>
							<div class="No-line-content">
								<xsl:apply-templates select="ref:CopyDest"/>
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
	<xsl:template match="ref:Requester">
		<xsl:apply-templates select="ref:HCP"/>
	</xsl:template>
	<xsl:template match="ref:ServProvider">
		<xsl:apply-templates select="ref:HCP"/>
	</xsl:template>
	<xsl:template match="ref:Patient">
		<div>
			<xsl:value-of select="ref:Name"/>&#160;
			<b><xsl:value-of select="ref:TypeOffId/@V"/>:&#160;</b>
			<xsl:value-of select="substring(ref:OffId, 1,6)"/>&#160;<xsl:value-of select="substring(ref:OffId, 7)"/>&#160;
		</div>
		<xsl:if test="ref:DateOfDeath">
			<div>
				<b>Dødsdato:&#160;</b>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="ref:DateOfDeath/@V"/>
				</xsl:call-template>
			&#160;</div>
		</xsl:if>
		<xsl:apply-templates select="ref:Address"/>
	</xsl:template>
	<xsl:template match="ref:HCPerson">
		<div><xsl:value-of select="ref:Name"/>&#160;</div>
		<xsl:apply-templates select="ref:Address"/>
	</xsl:template>
	<xsl:template match="ref:HCP">
		<xsl:apply-templates select="ref:Inst"/>
		<xsl:apply-templates select="ref:HCProf"/>
		<xsl:apply-templates select="ref:Address"/>
	</xsl:template>
	<xsl:template match="ref:Inst">
		<xsl:apply-templates select="ref:HCPerson"/>
		<div>
			<div class="NoPrint">
				<b>Institusjon:&#160;</b>
			</div>
			<xsl:value-of select="ref:Name"/>
		</div>
		<xsl:for-each select="ref:Dept">
			<div>
				<div class="NoPrint">-&#160;</div>
				<xsl:value-of select="ref:Name"/>&#160;</div>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="ref:HCProf">
		<div>
			<xsl:if test="ref:Type">
				<xsl:value-of select="ref:Type/@DN"/>&#160;</xsl:if>
			<xsl:value-of select="ref:Name"/>
		</div>
	</xsl:template>
	<xsl:template match="ref:CopyDest">
		<xsl:apply-templates select="ref:HCP"/>
	</xsl:template>
	<xsl:template match="ref:Address">
		<xsl:if test="ref:Type and (ref:StreetAdr or ref:PostalCode or ref:City or ref:CityDistr)">
			<div class="NoPrint">&#160;<b>
					<xsl:choose>
						<xsl:when test="ref:Type/@DN">
							<xsl:value-of select="ref:Type/@DN"/>:&#160;</xsl:when>
						<xsl:otherwise>Adresse:&#160;</xsl:otherwise>
					</xsl:choose>
				</b>
			</div>
		</xsl:if>
		<xsl:if test="ref:StreetAdr">
			<div>
				<xsl:value-of select="ref:StreetAdr"/>
			</div>
		</xsl:if>
		<xsl:if test="ref:PostalCode or ref:City">
			<xsl:if test="ref:StreetAdr">
				<div class="NoPrint">,</div>
			</xsl:if>
			<div>
				<xsl:value-of select="ref:PostalCode"/>&#160;<xsl:value-of select="ref:City"/>
			</div>
		</xsl:if>
		<xsl:if test="ref:CityDistr">
			<div class="NoPrint">,</div>
			<div>
				<xsl:value-of select="ref:CityDistr/@DN"/>
			</div>
		</xsl:if>
		<xsl:if test="ref:County">
			<div class="NoPrint">,</div>
			<div>
				<xsl:value-of select="ref:County/@DN"/>
			</div>
		</xsl:if>
		<xsl:if test="ref:Country">
			<div class="NoPrint">,</div>
			<div>
				<xsl:value-of select="ref:Country/@DN"/>
			</div>
		</xsl:if>
		<xsl:for-each select="ref:TeleAddress">
			<div class="NoPrint">&#160;</div>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="ref:TeleAddress" name="ref:TeleAddress">
		<xsl:if test="starts-with(@V, &quot;tel:&quot;) or starts-with(@V, &quot;callto:&quot;)">
			<div><b>Telefon:</b>&#160;<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>&#160;</div>
		</xsl:if>
		<xsl:if test="starts-with(@V, &quot;fax:&quot;)">
			<div><b>Faks:</b>&#160;<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>&#160;</div>
		</xsl:if>
		<xsl:if test="starts-with(@V, &quot;mailto:&quot;)">
			<div><b>e-post:</b>&#160;<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>&#160;</div>
		</xsl:if>
	</xsl:template>
	<!-- Meldingshodet - Dokumentopplysninger -->
	<xsl:template name="Footer">
		<div class="{$stil}">
			<h2>Dokumentinformasjon</h2>
			<div class="No-line-Box">
				<div class="No-line-Block">
					<div class="No-line-MainCaption">Melding sendt</div>
					<div class="No-line-MainContent">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="../ref:GenDate/@V"/>
						</xsl:call-template>
					</div>
				</div>
				<div class="No-line-Block">
					<div class="No-line-MainCaption">Meldingsid</div>
					<div class="No-line-MainContent">
						<xsl:value-of select="../ref:MsgId"/>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<!-- Hoveddokumentet -->
	<xsl:template name="FellesMeny">
		<xsl:param name="position"/>
		<div class="NoPrint">
			<div id="FellesMeny" class="FellesMeny">
				<ul>
					<xsl:if test="//ref:Diagnosis or //ref:ReasonAsText[ref:Heading/@V='DIAG'] or //ref:InfItem[ref:Type/@V='H' or ref:Type/@V='B']">
						<li>
							<xsl:variable name="temp10" select="concat('Diagnosis',$position)"/>
							<a href="#{$temp10}">Diagnoser</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:InfItem[ref:Type/@V='CAVE' or ref:Type/@V='NB']">
						<li>
							<xsl:variable name="temp20" select="concat('CAVE',$position)"/>
							<a href="#{$temp20}">
								<xsl:if test="//ref:InfItem[ref:Type/@V='CAVE']">CAVE</xsl:if>
								<xsl:if test="//ref:InfItem[ref:Type/@V='CAVE'] and //ref:InfItem[ref:Type/@V='NB']">&#160;og&#160;</xsl:if>
								<xsl:if test="//ref:InfItem[ref:Type/@V='NB']">NB-opplysninger</xsl:if>
							</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:ReasonAsText[ref:Heading/@V='PROB' or //ref:InfItem[ref:Type/@V='SYMP' or ref:Type/@V='PROG' or ref:Type/@V='SM']]">
						<li>
							<xsl:variable name="temp30" select="concat('PROB',$position)"/>
							<a href="#{$temp30}">Problemstilling</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:ReasonAsText[ref:Heading/@V='UTRED']">
						<li>
							<xsl:variable name="temp40" select="concat('UTRED',$position)"/>
							<a href="#{$temp40}">Forventet utredning/behandling</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:InfItem[ref:Type/@V='OPPL']">
						<li>
							<xsl:variable name="temp50" select="concat('OPPL',$position)"/>
							<a href="#{$temp50}">Kliniske opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:InfItem[ref:Type/@V='GOPL' or ref:Type/@V='GBEH']">
						<li>
							<xsl:variable name="temp60" select="concat('GOPL',$position)"/>
							<a href="#{$temp60}">Gynekologiske opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:ReasonAsText[ref:Heading/@V='SVU']">
						<li>
							<xsl:variable name="temp70" select="concat('SVU',$position)"/>
							<a href="#{$temp70}">Spesialistvurdering</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:ReasonAsText[ref:Heading/@V='VU']">
						<li>
							<xsl:variable name="temp80" select="concat('VU',$position)"/>
							<a href="#{$temp80}">Vurdering</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:ReasonAsText[ref:Heading/@V='BG' or ref:Heading/@V='BUP-BM' or ref:Heading/@V='BUP-HG' or ref:Heading/@V='KF' or ref:Heading/@V='MAAL' or ref:Heading/@V='MU' or ref:Heading/@V='RU' or ref:Heading/@V='UP' or not(ref:Heading)]">
						<li>
							<xsl:variable name="temp90" select="concat('Annen',$position)"/>
							<a href="#{$temp90}">Annen begrunnelse</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:InfItem[ref:Type/@V='ANAM' or ref:Type/@V='TB' or ref:Type/@V='US']">
						<li>
							<xsl:variable name="temp100" select="concat('ANAM',$position)"/>
							<a href="#{$temp100}">Sykehistorie</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:InfItem[ref:Type/@V='FUNN'] or //ref:ReasonAsText[ref:Heading/@V='FU']">
						<li>
							<xsl:variable name="temp110" select="concat('ResultItem',$position)"/>
							<a href="#{$temp110}">Funn/undersøkelsesresultat</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:InfItem[ref:Type/@V='OPIN' or ref:Type/@V='MPRS' or ref:Type/@V='PRS']">
						<li>
							<xsl:variable name="temp120" select="concat('OPIN',$position)"/>
							<a href="#{$temp120}">Prosedyrer</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:ReasonAsText[ref:Heading/@V='FO']">
						<li>
							<xsl:variable name="temp130" select="concat('FO',$position)"/>
							<a href="#{$temp130}">Forløp og behandling</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:ReasonAsText[ref:Heading/@V='HJ']">
						<li>
							<xsl:variable name="temp140" select="concat('HJ',$position)"/>
							<a href="#{$temp140}">Funksjonsnivå/hjelpetiltak</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:InfItem[ref:Type/@V='MEDB']">
						<li>
							<xsl:variable name="temp150" select="concat('Medication',$position)"/>
							<a href="#{$temp150}">Medisinering</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:ReasonAsText[ref:Heading/@V='FA']">
						<li>
							<xsl:variable name="temp160" select="concat('FA',$position)"/>
							<a href="#{$temp160}">Familie/sosialt</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:ReasonAsText[ref:Heading/@V='IP']">
						<li>
							<xsl:variable name="temp170" select="concat('IP',$position)"/>
							<a href="#{$temp170}">Informasjon til pasient/pårørende</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:InfItem[ref:Type/@V='SYKM']">
						<li>
							<xsl:variable name="temp180" select="concat('SYKM',$position)"/>
							<a href="#{$temp180}">Sykemelding</a>
						</li>
					</xsl:if>
					<xsl:if test="//ref:ServReq/ref:Comment">
						<li>
							<xsl:variable name="temp190" select="concat('Comment',$position)"/>
							<a href="#{$temp190}">Kommentarer</a>
						</li>
					</xsl:if>
					<xsl:for-each select="//ref:Patient">
						<xsl:if test="ref:BasisForHealthServices or ref:Sex or ref:DateOfBirth or ref:PatientPrecaution or po:AssistertKommunikasjon or po:ParorendeForesatt or ref:ContactPerson or ref:PatRelInst or ref:Consent or ref:AdditionalId">
							<li>
								<xsl:variable name="temp200" select="concat('Patient',$position)"/>
								<a href="#{$temp200}">Pasient</a>
							</li>
						</xsl:if>
						<xsl:if test="ref:PatRelHCP">
							<li>
								<xsl:variable name="temp210" select="concat('PatRelHCP',$position)"/>
								<a href="#{$temp210}">Helsetjenesteenheter</a>
							</li>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="ref:RefDoc">
						<li>
							<xsl:variable name="temp220" select="concat('RefDoc',$position)"/>
							<a href="#{$temp220}">Vedlegg</a>
						</li>
					</xsl:if>
				</ul>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="ref:Message">
		<xsl:for-each select="ref:ServReq">
			<xsl:variable name="position" select="position()"/>
			<xsl:call-template name="Header"/>
			<div class="{$stil}">
				<xsl:call-template name="FellesMeny"><xsl:with-param name="position" select="position()"/></xsl:call-template>
				<!-- Overskrift og tabell for henvisningen -->
				<h1>Henvisning&#160;-&#160;
					<xsl:choose>
						<xsl:when test="ref:MsgDescr/@DN"><xsl:value-of select="ref:MsgDescr/@DN"/></xsl:when>
						<xsl:otherwise><xsl:for-each select="ref:MsgDescr"><xsl:call-template name="k-8455"/></xsl:for-each></xsl:otherwise>
					</xsl:choose>
					<xsl:if test="ref:ServType/@V != 'N'">
						&#160;<b>
						<xsl:choose>
							<xsl:when test="ref:ServType/@DN"><xsl:value-of select="ref:ServType/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="ref:ServType"><xsl:call-template name="k-7309"/></xsl:for-each></xsl:otherwise>
						</xsl:choose></b>
					</xsl:if>
					<xsl:if test="ref:ReqServ/ref:ServType/@V != 'N'">
						&#160;Status&#160;rekvirert&#160;tjeneste:&#160;
						<xsl:choose>
							<xsl:when test="ref:ReqServ/ref:ServType/@DN"><xsl:value-of select="ref:ReqServ/ref:ServType/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="ref:ReqServ/ref:ServType"><xsl:call-template name="k-7309"/></xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</h1>
				<table>
					<tbody>
						<xsl:apply-templates select="."/>
					</tbody>
				</table>
				<!-- Overskrift og tabell for Diagnoser -->
				<xsl:if test="ref:Diagnosis or ref:ReasonAsText[ref:Heading/@V='DIAG'] or //ref:InfItem[ref:Type/@V='H' or ref:Type/@V='B']">
					<xsl:variable name="id10"><xsl:value-of select="concat('Diagnosis',$position)"/></xsl:variable>
					<h2 id="{$id10}">Diagnoser</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="ref:Diagnosis"/>
							<xsl:apply-templates select="ref:ReasonAsText[ref:Heading/@V='DIAG']"/>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='H']">
								<xsl:apply-templates/>
							</xsl:for-each>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='B']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for CAVE og NB-opplysninger -->
				<xsl:if test="//ref:InfItem[ref:Type/@V='CAVE' or ref:Type/@V='NB']">
					<xsl:variable name="id20"><xsl:value-of select="concat('CAVE',$position)"/></xsl:variable>
					<h2 id="{$id20}">
						<xsl:if test="//ref:InfItem[ref:Type/@V='CAVE']">CAVE</xsl:if>
						<xsl:if test="//ref:InfItem[ref:Type/@V='CAVE'] and //ref:InfItem[ref:Type/@V='NB']">&#160;og&#160;</xsl:if>
						<xsl:if test="//ref:InfItem[ref:Type/@V='NB']">NB-opplysninger</xsl:if>
					</h2>
					<table>
						<tbody>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='CAVE']">
								<xsl:apply-templates/>
							</xsl:for-each>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='NB']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Problemstilling -->
				<xsl:if test="//ref:ReasonAsText[ref:Heading/@V='PROB'] or //ref:InfItem[ref:Type/@V='SYMP' or ref:Type/@V='PROG' or ref:Type/@V='SM']">
					<xsl:variable name="id30"><xsl:value-of select="concat('PROB',$position)"/></xsl:variable>
					<h2 id="{$id30}">Problemstilling</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="ref:ReasonAsText[ref:Heading/@V='PROB']"/>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='SYMP'] | //ref:InfItem[ref:Type/@V='PROG'] | //ref:InfItem[ref:Type/@V='SM']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Forventet utredning/behandling -->
				<xsl:if test="ref:ReasonAsText[ref:Heading/@V='UTRED']">
					<xsl:variable name="id40"><xsl:value-of select="concat('UTRED',$position)"/></xsl:variable>
					<h2 id="{$id40}">Forventet utredning/behandling</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="ref:ReasonAsText[ref:Heading/@V='UTRED']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Kliniske opplysninger -->
				<xsl:if test="//ref:InfItem[ref:Type/@V='OPPL']">
					<xsl:variable name="id50"><xsl:value-of select="concat('OPPL',$position)"/></xsl:variable>
					<h2 id="{$id50}">Kliniske opplysninger</h2>
					<table>
						<tbody>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='OPPL']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Gynekologiske opplysninger -->
				<xsl:if test="//ref:InfItem[ref:Type/@V='GOPL' or ref:Type/@V='GBEH']">
					<xsl:variable name="id60"><xsl:value-of select="concat('GOPL',$position)"/></xsl:variable>
					<h2 id="{$id60}">Gynekologiske opplysninger</h2>
					<table>
						<tbody>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='GOPL' or ref:Type/@V='GBEH']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Spesialistvurdering -->
				<xsl:if test="ref:ReasonAsText[ref:Heading/@V='SVU']">
					<xsl:variable name="id70"><xsl:value-of select="concat('SVU',$position)"/></xsl:variable>
					<h2 id="{$id70}">Spesialistvurdering</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="ref:ReasonAsText[ref:Heading/@V='SVU']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Vurdering -->
				<xsl:if test="ref:ReasonAsText[ref:Heading/@V='VU']">
					<xsl:variable name="id80"><xsl:value-of select="concat('VU',$position)"/></xsl:variable>
					<h2 id="{$id80}">Vurdering</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="ref:ReasonAsText[ref:Heading/@V='VU']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Annen begrunnelse for henvisningen -->
				<xsl:if test="ref:ReasonAsText[ref:Heading/@V='BG' or ref:Heading/@V='BUP-BM' or ref:Heading/@V='BUP-HG' or ref:Heading/@V='KF' or ref:Heading/@V='MAAL' or ref:Heading/@V='MU' or ref:Heading/@V='RU' or ref:Heading/@V='UP' or not(ref:Heading)]">
					<xsl:variable name="id90"><xsl:value-of select="concat('Annen',$position)"/></xsl:variable>
					<h2 id="{$id90}">Annen begrunnelse for henvisningen</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="ref:ReasonAsText[ref:Heading/@V='BG' or ref:Heading/@V='BUP-BM' or ref:Heading/@V='BUP-HG' or ref:Heading/@V='KF' or ref:Heading/@V='MAAL' or ref:Heading/@V='MU' or ref:Heading/@V='RU' or ref:Heading/@V='UP' or not(ref:Heading)]"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Sykehistorie -->
				<xsl:if test="//ref:InfItem[ref:Type/@V='ANAM' or ref:Type/@V='TB' or ref:Type/@V='US']">
					<xsl:variable name="id100"><xsl:value-of select="concat('ANAM',$position)"/></xsl:variable>
					<h2 id="{$id100}">Sykehistorie</h2>
					<table>
						<tbody>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='ANAM' or ref:Type/@V='TB' or ref:Type/@V='US']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Funn/undersøkelsesresultat -->
				<xsl:if test="//ref:InfItem[ref:Type/@V='FUNN'] or ref:ReasonAsText[ref:Heading/@V='FU']">
					<xsl:variable name="id110"><xsl:value-of select="concat('ResultItem',$position)"/></xsl:variable>
					<h2 id="{$id110}">Funn/undersøkelsesresultat</h2>
					<table>
						<tbody>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='FUNN']/ref:Observation">
								<xsl:apply-templates select="."/>
							</xsl:for-each>
							<xsl:for-each select="//ref:ResultItem">
								<xsl:if test="position()=1">
									<tr>
										<th>Undersøkelse</th>
										<th colspan="{$res-res-col}">Funn/resultat</th>
										<xsl:if test="//ref:ResultItem/ref:DevResultInd">
											<th colspan="{$res-dev-col}">Avviksmarkør</th>
										</xsl:if>
										<xsl:if test="//ref:ResultItem/ref:InvDate">
											<th colspan="{$res-idate-col}">Tidspunkt&#160;for&#160;undersøkelsen</th>
										</xsl:if>
										<xsl:if test="//ref:InfItem[ref:ResultItem]/ref:StartDateTime">
											<th colspan="{$res-sdate-col}">Starttidspunkt</th>
										</xsl:if>
										<xsl:if test="//ref:InfItem[ref:ResultItem]/ref:EndDateTime">
											<th colspan="{$res-edate-col}">Sluttidspunkt</th>
										</xsl:if>
										<xsl:if test="//ref:InfItem[ref:ResultItem]/ref:OrgDate">
											<th colspan="{$res-odate-col}">Tidspunkt&#160;for&#160;opprinnelse</th>
										</xsl:if>
									</tr>
								</xsl:if>
								<tr>
									<xsl:apply-templates select="."/>
								</tr>
							</xsl:for-each>
							<xsl:apply-templates select="ref:ReasonAsText[ref:Heading/@V='FU']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Prosedyrer -->
				<xsl:if test="//ref:InfItem[ref:Type/@V='OPIN'] or //ref:InfItem[ref:Type/@V='MPRS'] or //ref:InfItem[ref:Type/@V='PRS']">
					<xsl:variable name="id120"><xsl:value-of select="concat('OPIN',$position)"/></xsl:variable>
					<h2 id="{$id120}">Prosedyrer</h2>
					<table>
						<tbody>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='OPIN'] | //ref:InfItem[ref:Type/@V='MPRS'] | //ref:InfItem[ref:Type/@V='PRS']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Forløp og behandling -->
				<xsl:if test="ref:ReasonAsText[ref:Heading/@V='FO']">
					<xsl:variable name="id130"><xsl:value-of select="concat('FO',$position)"/></xsl:variable>
					<h2 id="{$id130}">Forløp og behandling</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="ref:ReasonAsText[ref:Heading/@V='FO']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Funksjonsnivå/hjelpetiltak -->
				<xsl:if test="ref:ReasonAsText[ref:Heading/@V='HJ']">
					<xsl:variable name="id140"><xsl:value-of select="concat('HJ',$position)"/></xsl:variable>
					<h2 id="{$id140}">Funksjonsnivå/hjelpetiltak</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="ref:ReasonAsText[ref:Heading/@V='HJ']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Medisinering -->
				<xsl:if test="//ref:InfItem[ref:Type/@V='MEDB']">
					<xsl:variable name="id150"><xsl:value-of select="concat('Medication',$position)"/></xsl:variable>
					<h2 id="{$id150}">Medisinering</h2>
					<table>
						<tbody>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='MEDB']/ref:Observation | //ref:InfItem[ref:Type/@V='MEDB']/ref:ResultItem">
								<xsl:apply-templates select="."/>
							</xsl:for-each>
							<xsl:for-each select="//ref:Medication">
								<xsl:if test="position()=1">
									<tr>
										<th>Legemiddel</th>
										<th colspan="{$med-stat-col}">Status</th>
										<xsl:if test="//ref:Medication/ref:UnitDose or //ref:Medication/ref:QuantitySupplied">
											<th colspan="{$med-unit-col}">Mengde</th>
										</xsl:if>
										<xsl:if test="//ref:Medication/ref:DosageText or //ref:Medication/ref:IntendedDuration">
											<th colspan="{$med-text-col}">
												<xsl:if test="//ref:Medication/ref:DosageText">Dosering</xsl:if>
												<xsl:if test="//ref:Medication/ref:DosageText and //ref:Medication/ref:IntendedDuration">/</xsl:if>
												<xsl:if test="//ref:Medication/ref:IntendedDuration">Varighet</xsl:if>
											</th>
										</xsl:if>
										<xsl:if test="//ref:Medication/ref:Comment">
											<th colspan="{$med-com-col}">Kommentar</th>
										</xsl:if>
										<xsl:if test="//ref:InfItem[ref:Medication]/ref:StartDateTime">
											<th colspan="{$med-sdate-col}">Starttidspunkt</th>
										</xsl:if>
										<xsl:if test="//ref:InfItem[ref:Medication]/ref:EndDateTime">
											<th colspan="{$med-edate-col}">Sluttidspunkt</th>
										</xsl:if>
										<xsl:if test="//ref:InfItem[ref:Medication]/ref:OrgDate">
											<th colspan="{$med-odate-col}">Tidspunkt&#160;for&#160;opprinnelse</th>
										</xsl:if>
									</tr>
								</xsl:if>
								<tr>
									<xsl:apply-templates select="."/>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Familie/sosialt -->
				<xsl:if test="ref:ReasonAsText[ref:Heading/@V='FA']">
					<xsl:variable name="id160"><xsl:value-of select="concat('FA',$position)"/></xsl:variable>
					<h2 id="{$id160}">Familie/sosialt</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="ref:ReasonAsText[ref:Heading/@V='FA']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Informasjon til pasient/pårørende -->
				<xsl:if test="ref:ReasonAsText[ref:Heading/@V='IP']">
					<xsl:variable name="id170"><xsl:value-of select="concat('IP',$position)"/></xsl:variable>
					<h2 id="{$id170}">Informasjon til pasient/pårørende</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="ref:ReasonAsText[ref:Heading/@V='IP']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Sykemelding -->
				<xsl:if test="//ref:InfItem[ref:Type/@V='SYKM']">
					<xsl:variable name="id180"><xsl:value-of select="concat('SYKM',$position)"/></xsl:variable>
					<h2 id="{$id180}">Sykemelding</h2>
					<table>
						<tbody>
							<xsl:for-each select="//ref:InfItem[ref:Type/@V='SYKM']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Kommentarer -->
				<xsl:if test="ref:Comment">
					<xsl:variable name="id190"><xsl:value-of select="concat('Comment',$position)"/></xsl:variable>
					<h2 id="{$id190}">Kommentarer</h2>
					<table>
						<tbody>
							<xsl:for-each select="ref:Comment">
								<tr>
									<th>
										<xsl:choose>
											<xsl:when test="ref:Heading"><xsl:for-each select="ref:Heading"><xsl:call-template name="k-8234"/></xsl:for-each></xsl:when>
											<xsl:otherwise>Kommentar</xsl:otherwise>
										</xsl:choose>
									</th>
									<td colspan="{($std-col)-1}">
										<xsl:if test="ref:TextResultValue"><div><xsl:value-of select="ref:TextResultValue"/></div></xsl:if>
										<xsl:for-each select="ref:CodedComment">
											<div><b>Kodet:</b>&#160;
												<xsl:choose>
													<xsl:when test="@DN"><xsl:value-of select="@DN"/>&#160;</xsl:when>
													<xsl:otherwise><xsl:value-of select="@V"/>&#160;</xsl:otherwise>
												</xsl:choose>
												<xsl:if test="@OT"><xsl:value-of select="@OT"/></xsl:if>
											</div>
										</xsl:for-each>
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Pasient -->
				<xsl:for-each select="ref:Patient">
					<xsl:if test="ref:BasisForHealthServices or ref:Sex or ref:DateOfBirth or ref:PatientPrecaution or po:AssistertKommunikasjon or po:ParorendeForesatt or ref:ContactPerson or ref:PatRelInst or ref:Consent or ref:AdditionalId">
						<xsl:variable name="id200"><xsl:value-of select="concat('Patient',$position)"/></xsl:variable>
						<h2 id="{$id200}">Pasient</h2>
						<table>
							<tbody>
								<xsl:apply-templates select="." mode="full"/>
							</tbody>
						</table>
					</xsl:if>
				</xsl:for-each>
				<!-- Overskrift og tabell for Helsetjenesteenheter -->
				<xsl:if test="ref:Patient/ref:PatRelHCP">
					<xsl:variable name="id210"><xsl:value-of select="concat('PatRelHCP',$position)"/></xsl:variable>
					<h2 id="{$id210}">Helsetjenesteenheter</h2>
					<table>
						<tbody>
							<tr>
								<xsl:if test="//ref:PatRelHCP/ref:Relation">
									<th>Pasientrelasjon</th>
								</xsl:if>
								<xsl:if test="//ref:PatRelHCP//ref:HCProf | //ref:PatRelHCP//ref:HCPerson | //ref:PatRelHCP//ref:Dept">
									<th colspan="{(($std-col)-2)*number(not(//ref:PatRelHCP//ref:HCProf/ref:Id | //ref:PatRelHCP//ref:HCProf/ref:AdditionalId | //ref:PatRelHCP//ref:HCPerson/ref:Id | //ref:PatRelHCP//ref:HCPerson/ref:AdditionalId | //ref:PatRelHCP//ref:Dept/ref:Id | //ref:PatRelHCP//ref:Dept/ref:AdditionalId | //ref:PatRelHCP//ref:Inst/ref:Name | //ref:PatRelHCP//ref:MedSpeciality | //ref:PatRelHCP//ref:Inst/ref:Id | //ref:PatRelHCP/ref:StartDateTime | //ref:PatRelHCP/ref:EndDateTime | //ref:PatRelHCP//ref:Address))+1}">
										<xsl:choose>
											<xsl:when test="//ref:PatRelHCP//ref:Dept and (//ref:PatRelHCP//ref:HCProf or //ref:PatRelHCP//ref:HCPerson)">Person/avd.</xsl:when>
											<xsl:when test="not(//ref:PatRelHCP//ref:Dept)">Person</xsl:when>
											<xsl:otherwise>Avdeling</xsl:otherwise>
										</xsl:choose>
									</th>
								</xsl:if>
								<xsl:if test="//ref:PatRelHCP//ref:HCProf/ref:Id | //ref:PatRelHCP//ref:HCProf/ref:AdditionalId | //ref:PatRelHCP//ref:HCPerson/ref:Id | //ref:PatRelHCP//ref:HCPerson/ref:AdditionalId | //ref:PatRelHCP//ref:Dept/ref:Id | //ref:PatRelHCP//ref:Dept/ref:AdditionalId">
									<th colspan="{(($std-col)-3)*number(not(//ref:PatRelHCP//ref:Inst/ref:Name | //ref:PatRelHCP//ref:MedSpeciality | //ref:PatRelHCP//ref:Inst/ref:Id | //ref:PatRelHCP/ref:StartDateTime | //ref:PatRelHCP/ref:EndDateTime | //ref:PatRelHCP//ref:Address))+1}">Id</th>
								</xsl:if>
								<xsl:if test="//ref:PatRelHCP//ref:Inst/ref:Name">
									<th colspan="{(($std-col)-2-number(boolean(//ref:PatRelHCP//ref:HCProf | //ref:PatRelHCP//ref:HCPerson | //ref:PatRelHCP//ref:Dept))-1)*number(not(//ref:PatRelHCP//ref:MedSpeciality | //ref:PatRelHCP//ref:Inst/ref:Id | //ref:PatRelHCP/ref:StartDateTime | //ref:PatRelHCP/ref:EndDateTime | //ref:PatRelHCP//ref:Address))+1}">Institusjon</th>
								</xsl:if>
								<xsl:if test="//ref:PatRelHCP//ref:MedSpeciality">
									<th colspan="{(($std-col)-2-number(boolean(//ref:PatRelHCP//ref:HCProf | //ref:PatRelHCP//ref:HCPerson | //ref:PatRelHCP//ref:Dept))-1-number(boolean(//ref:PatRelHCP//ref:Inst/ref:Name)))*number(not(//ref:PatRelHCP//ref:Inst/ref:Id | //ref:PatRelHCP/ref:StartDateTime | //ref:PatRelHCP/ref:EndDateTime | //ref:PatRelHCP//ref:Address))+1}">Medisinsk&#160;spesialitet</th>
								</xsl:if>
								<xsl:if test="//ref:PatRelHCP//ref:Inst/ref:Id">
									<th colspan="{(($std-col)-2-number(boolean(//ref:PatRelHCP//ref:HCProf | //ref:PatRelHCP//ref:HCPerson | //ref:PatRelHCP//ref:Dept))-1-number(boolean(//ref:PatRelHCP//ref:Inst/ref:Name))-number(boolean(//ref:PatRelHCP//ref:MedSpeciality)))*number(not(//ref:PatRelHCP/ref:StartDateTime | //ref:PatRelHCP/ref:EndDateTime | //ref:PatRelHCP//ref:Address))+1}">Institusjon-id</th>
								</xsl:if>
								<xsl:if test="//ref:PatRelHCP/ref:StartDateTime | //ref:PatRelHCP/ref:EndDateTime">
									<th colspan="{(($std-col)-2-number(boolean(//ref:PatRelHCP//ref:HCProf | //ref:PatRelHCP//ref:HCPerson | //ref:PatRelHCP//ref:Dept))-1-number(boolean(//ref:PatRelHCP//ref:Inst/ref:Name))-number(boolean(//ref:PatRelHCP//ref:MedSpeciality))-number(boolean(//ref:PatRelHCP//ref:Inst/ref:Id)))*number(not(//ref:PatRelHCP//ref:Address))+1}">Tidsrom</th>
								</xsl:if>
								<xsl:if test="//ref:PatRelHCP//ref:Address">
									<th colspan="{(($std-col)-1-number(boolean(//ref:PatRelHCP//ref:HCProf | //ref:PatRelHCP//ref:HCPerson | //ref:PatRelHCP//ref:Dept))-1-number(boolean(//ref:PatRelHCP//ref:Inst/ref:Name))-number(boolean(//ref:PatRelHCP//ref:MedSpeciality))-number(boolean(//ref:PatRelHCP//ref:Inst/ref:Id))-number(boolean(//ref:PatRelHCP/ref:StartDateTime | //ref:PatRelHCP/ref:EndDateTime)))}">Adresse</th>
								</xsl:if>
							</tr>
							<xsl:apply-templates select="ref:Patient/ref:PatRelHCP"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for vedlegg -->
				<xsl:if test="ref:RefDoc">
					<xsl:variable name="id220"><xsl:value-of select="concat('RefDoc',$position)"/></xsl:variable>
					<h2 id="{$id220}">Vedlegg</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="ref:RefDoc"/>
						</tbody>
					</table>
				</xsl:if>
			</div>
			<xsl:call-template name="Footer"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="ref:ServReq">
		<tr>
			<xsl:if test="ref:IssueDate">
				<th>Utstedt</th>
				<td colspan="{(($std-col)-2)*number(not(ref:PaymentCat | ref:Ack))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="ref:IssueDate/@V"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="ref:PaymentCat">
				<th>Betalingskategori</th>
				<td colspan="{(($std-col)-2-count(ref:IssueDate)*2)*number(not(ref:Ack))+1}">
					<xsl:choose>
						<xsl:when test="ref:PaymentCat/@DN"><xsl:value-of select="ref:PaymentCat/@DN"/></xsl:when>
						<xsl:otherwise><xsl:for-each select="ref:PaymentCat"><xsl:call-template name="k-8246"/>&#160;</xsl:for-each></xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="ref:Ack">
				<th>Meldingsbekreftelse</th>
				<td colspan="{($std-col)-2-count(ref:IssueDate | ref:PaymentCat)*2}">
					<xsl:choose>
						<xsl:when test="ref:Ack/@DN"><xsl:value-of select="ref:Ack/@DN"/></xsl:when>
						<xsl:otherwise><xsl:for-each select="ref:Ack"><xsl:call-template name="k-7304"/>&#160;</xsl:for-each></xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
		</tr>
		<xsl:if test="ref:ReqComment">
			<tr>
				<td colspan="{$std-col}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="ref:ReqComment"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:for-each select="ref:ReqServ">
			<xsl:if test="ref:Priority or ref:Purpose or ref:ReqDate">
				<tr>
					<xsl:if test="ref:Priority">
						<th>Hastegrad</th>
						<td colspan="{(($std-col)-2)*number(not(ref:Purpose | ref:ReqDate))+1}">
							<xsl:choose>
								<xsl:when test="ref:Priority/@DN"><xsl:value-of select="ref:Priority/@DN"/></xsl:when>
								<xsl:otherwise><xsl:for-each select="ref:Priority"><xsl:call-template name="k-8304"/>&#160;</xsl:for-each></xsl:otherwise>
							</xsl:choose>
						</td>
					</xsl:if>
					<xsl:if test="ref:Purpose">
						<th>Formål</th>
						<td colspan="{(($std-col)-2-count(ref:Priority)*2)*number(not(ref:ReqDate))+1}">
							<xsl:choose>
								<xsl:when test="ref:Purpose/@DN"><xsl:value-of select="ref:Purpose/@DN"/></xsl:when>
								<xsl:otherwise><xsl:for-each select="ref:Purpose"><xsl:call-template name="k-8248"/>&#160;</xsl:for-each></xsl:otherwise>
							</xsl:choose>
						</td>
					</xsl:if>
					<xsl:if test="ref:ReqDate">
						<th>Utstedt</th>
						<td colspan="{($std-col)-1-count(ref:Priority | ref:Purpose)*2}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="ref:ReqDate/@V"/>
							</xsl:call-template>
						</td>
					</xsl:if>
				</tr>
			</xsl:if>
			<xsl:if test="ref:Comment">
				<tr>
					<td colspan="{$std-col}">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="ref:Comment"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:for-each select="ref:Service">
				<tr>
					<th>Spesifisert tjeneste</th>
				</tr>
				<xsl:if test="ref:ServId or ref:MedSpeciality or ref:AdmCat">
					<tr>
						<xsl:if test="ref:ServId">
							<th>Tjeneste</th>
							<td colspan="{(($std-col)-2)*number(not(ref:MedSpeciality | ref:AdmCat))+1}">
								<xsl:choose>
									<xsl:when test="ref:ServId/@DN">
										<xsl:value-of select="ref:ServId/@DN"/>
									</xsl:when>
									<xsl:otherwise>
										<b>Kodet:</b>&#160;<xsl:value-of select="ref:ServId/@V"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="ref:ServId/@OT">
									<div><b>Fritekst:</b>&#160;<xsl:value-of select="ref:ServId/@OT"/></div>
								</xsl:if>
							</td>
						</xsl:if>
						<xsl:if test="ref:MedSpeciality">
							<th>Medisinsk spesialitet</th>
							<td colspan="{(($std-col)-2-count(ref:ServId)*2)*number(not(ref:AdmCat))+1}">
								<xsl:choose>
									<xsl:when test="ref:MedSpeciality/@DN">
										<xsl:value-of select="ref:MedSpeciality/@DN"/>
									</xsl:when>
									<xsl:otherwise>
										<b>Kodet:</b>&#160;<xsl:value-of select="ref:MedSpeciality/@V"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="ref:MedSpeciality/@OT">
									<div><b>Fritekst:</b>&#160;<xsl:value-of select="ref:MedSpeciality/@OT"/></div>
								</xsl:if>
							</td>
						</xsl:if>
						<xsl:if test="ref:AdmCat">
							<th>Type tjeneste</th>
							<td colspan="{($std-col)-2-count(ref:ServId | ref:MedSpeciality)*2}">
								<xsl:choose>
									<xsl:when test="ref:AdmCat/@DN"><xsl:value-of select="ref:AdmCat/@DN"/></xsl:when>
									<xsl:otherwise><xsl:for-each select="ref:AdmCat"><xsl:call-template name="k-8240"/>&#160;</xsl:for-each></xsl:otherwise>
								</xsl:choose>
							</td>
						</xsl:if>
					</tr>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="ref:Diagnosis">
		<tr>
			<th>
				<xsl:value-of select="ref:Concept/@V"/>&#160;
				<xsl:if test="contains(ref:Concept/@S, '7170')">(ICPC)</xsl:if>
				<xsl:if test="contains(ref:Concept/@S, '7110')">(ICD-10)</xsl:if>
			</th>
			<td colspan="{(($std-col)-2)*number(not(ref:Modifier))+1}">
				<xsl:if test="ref:Concept/@DN"><xsl:value-of select="ref:Concept/@DN"/>&#160;</xsl:if>
				<xsl:if test="ref:Concept/@OT">Fritekst:&#160;<xsl:value-of select="ref:Concept/@OT"/>&#160;</xsl:if>
				<xsl:if test="../../ref:Type/@V='H'">(Hoveddiagnose)</xsl:if>
			</td>
			<xsl:if test="ref:Modifier">
				<td colspan="{($std-col)-2}">
					<xsl:for-each select="ref:Modifier">
						<div><b>Moderator&#160;-&#160;
							<xsl:choose>
								<xsl:when test="ref:Name/@V='S'">ICD10 stjernekode:&#160;</xsl:when>
								<xsl:when test="ref:Name/@V='A'">ATC-kode:&#160;</xsl:when>
								<xsl:otherwise>Ukjent:&#160;</xsl:otherwise>
							</xsl:choose></b>
							<xsl:value-of select="ref:Value/@V"/>&#160;-&#160;<xsl:value-of select="ref:Value/@DN"/>
						</div>
					</xsl:for-each>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<xsl:template match="ref:ReasonAsText">
		<tr>
			<xsl:if test="ref:Heading/@V='BG' or ref:Heading/@V='BUP-BM' or ref:Heading/@V='BUP-HG' or ref:Heading/@V='KF' or ref:Heading/@V='MAAL' or ref:Heading/@V='MU' or ref:Heading/@V='RU' or ref:Heading/@V='UP'">
				<th>
					<xsl:for-each select="ref:Heading">
						<xsl:call-template name="k-8231"/>
					</xsl:for-each>
					<xsl:if test="not(ref:Heading)">Begrunnelse&#160;(uspes.)</xsl:if>
				</th>
			</xsl:if>
			<td colspan="{($std-col)-1}">
				<xsl:if test="ref:TextResultValue">
					<div>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="ref:TextResultValue"/>
						</xsl:call-template>
					</div>
				</xsl:if>
				<xsl:for-each select="ref:TextCode">
					<div>
						<xsl:if test="@DN"><xsl:value-of select="@DN"/>&#160;-&#160;</xsl:if>
						<xsl:if test="@V"><b>Kodet:</b>&#160;<xsl:value-of select="@V"/></xsl:if>
						<xsl:if test="@OT"><b>Fritekst:</b>&#160;<xsl:value-of select="@OT"/></xsl:if>
					</div>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="ref:Observation">
		<tr>
			<td colspan="{(($std-col)-1)*number(not(../ref:StartDateTime | ../ref:EndDateTime | ../ref:OrgDate))+1}">
				<xsl:if test="ref:Description">
					<div><xsl:call-template name="line-breaks"><xsl:with-param name="text" select="ref:Description"/></xsl:call-template></div>
				</xsl:if>
				<xsl:if test="ref:Comment">
					<div><xsl:call-template name="line-breaks"><xsl:with-param name="text" select="ref:Comment"/></xsl:call-template></div>
				</xsl:if>
			</td>
			<xsl:if test="../ref:StartDateTime or ../ref:EndDateTime or ../ref:OrgDate">
				<td colspan="{($std-col)-1}">
					<xsl:if test="../ref:StartDateTime">
						<div>Start:&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../ref:StartDateTime/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="../ref:EndDateTime">
						<div>Slutt:&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../ref:EndDateTime/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="../ref:OrgDate">
						<div>Opprinnelse:&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../ref:OrgDate/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<xsl:template match="ref:ResultItem">
		<td>
			<xsl:for-each select="ref:ClinInv">
				<div>
					<xsl:choose>
						<xsl:when test="ref:Id/@DN"><xsl:value-of select="ref:Id/@DN"/>&#160;</xsl:when>
						<xsl:when test="ref:Id/@V"><b>Kodet:</b>&#160;<xsl:value-of select="ref:Id/@V"/>&#160;</xsl:when>
					</xsl:choose>
					<xsl:if test="ref:Id/@OT"><xsl:value-of select="ref:Id/@OT"/></xsl:if>
				</div>
				<xsl:for-each select="ref:Spec">
					<div><b>Spesifisert:</b>&#160;
						<xsl:choose>
							<xsl:when test="@DN"><xsl:value-of select="@DN"/>&#160;</xsl:when>
							<xsl:when test="@V"><b>Kodet:</b>&#160;<xsl:value-of select="@V"/>&#160;</xsl:when>
						</xsl:choose>
						<xsl:if test="@OT"><xsl:value-of select="@OT"/></xsl:if>
					</div>
				</xsl:for-each>
			</xsl:for-each>
		</td>
		<td colspan="{$res-res-col}">
			<xsl:for-each select="ref:Interval">
				<xsl:if test="ref:Low"><b>Nedre:</b>&#160;<xsl:value-of select="ref:Low/@V"/><xsl:value-of select="ref:Low/@U"/>&#160;</xsl:if>
				<xsl:if test="ref:High"><b>Øvre:</b>&#160;<xsl:value-of select="ref:High/@V"/><xsl:value-of select="ref:High/@U"/>&#160;</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="ref:DateResult">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="ref:DateResultValue/@V"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="ref:NumResult">
				<xsl:choose>
					<xsl:when test="../ref:DevResultInd">
						<em>
							<xsl:for-each select="ref:ArithmeticComp">
								<xsl:call-template name="k-8239"/>
							</xsl:for-each>
							<xsl:value-of select="ref:NumResultValue/@V"/><xsl:value-of select="ref:NumResultValue/@U"/>
						</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="ref:ArithmeticComp">
							<xsl:call-template name="k-8239"/>
						</xsl:for-each>
						<xsl:value-of select="ref:NumResultValue/@V"/><xsl:value-of select="ref:NumResultValue/@U"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:for-each select="ref:TextResult/ref:Result">
				<xsl:if test="ref:TextResultValue">
					<div><xsl:call-template name="line-breaks"><xsl:with-param name="text" select="ref:TextResultValue"/></xsl:call-template></div>
				</xsl:if>
				<xsl:if test="ref:TextCode">
					<div>
						<xsl:choose>
							<xsl:when test="ref:TextCode/@DN"><xsl:value-of select="ref:TextCode/@DN"/>&#160;</xsl:when>
							<xsl:when test="ref:TextCode/@V"><b>Kodet:</b>&#160;<xsl:value-of select="ref:TextCode/@V"/>&#160;</xsl:when>
						</xsl:choose>
						<xsl:if test="ref:TextCode/@OT"><xsl:value-of select="ref:TextCode/@OT"/></xsl:if>
					</div>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="ref:Comment">
				<div>
					<b>Kommentar:</b>&#160;<xsl:call-template name="line-breaks"><xsl:with-param name="text" select="ref:Comment"/></xsl:call-template>
				</div>
			</xsl:if>
		</td>
		<xsl:if test="//ref:ResultItem/ref:DevResultInd">
			<td colspan="{$res-dev-col}">
				<xsl:for-each select="ref:DevResultInd">
					<xsl:choose>
						<xsl:when test="@DN"><xsl:value-of select="@DN"/></xsl:when>
						<xsl:otherwise><xsl:call-template name="k-8239"/>&#160;</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</td>
		</xsl:if>
		<xsl:if test="//ref:ResultItem/ref:InvDate">
			<td colspan="{$res-idate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="ref:InvDate/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//ref:InfItem[ref:ResultItem]/ref:StartDateTime">
			<td colspan="{$res-sdate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../ref:StartDateTime/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//ref:InfItem[ref:ResultItem]/ref:EndDateTime">
			<td colspan="{$res-edate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../ref:EndDateTime/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//ref:InfItem[ref:ResultItem]/ref:OrgDate">
			<td colspan="{$res-odate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../ref:OrgDate/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ref:Medication">
		<td>
			<xsl:choose>
				<xsl:when test="ref:DrugId/@DN"><xsl:value-of select="ref:DrugId/@DN"/></xsl:when>
				<xsl:when test="ref:DrugId/@OT"><xsl:value-of select="ref:DrugId/@OT"/></xsl:when>
				<xsl:otherwise><b>Kodet:</b>&#160;<xsl:value-of select="ref:DrugId/@V"/></xsl:otherwise>
			</xsl:choose>
		</td>
		<td colspan="{$med-stat-col}">
			<xsl:choose>
				<xsl:when test="ref:Status/@DN"><xsl:value-of select="ref:Status/@DN"/></xsl:when>
				<xsl:otherwise><xsl:for-each select="ref:Status"><xsl:call-template name="k-7307"/>&#160;</xsl:for-each></xsl:otherwise>
			</xsl:choose>
		</td>
		<xsl:if test="//ref:Medication/ref:UnitDose or //ref:Medication/ref:QuantitySupplied">
			<td colspan="{$med-unit-col}">
				<xsl:if test="ref:UnitDose">
					<xsl:value-of select="ref:UnitDose/@V"/>&#160;<xsl:value-of select="ref:UnitDose/@U"/>
					<xsl:if test="ref:QuantitySupplied">&#160;x&#160;</xsl:if>
				</xsl:if>
				<xsl:if test="ref:QuantitySupplied">
					<xsl:value-of select="ref:QuantitySupplied/@V"/>&#160;<xsl:value-of select="ref:QuantitySupplied/@U"/>
				</xsl:if>&#160;
			</td>
		</xsl:if>
		<xsl:if test="//ref:Medication/ref:DosageText or //ref:Medication/ref:IntendedDuration">
			<td colspan="{$med-text-col}">
				<xsl:if test="ref:DosageText">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="ref:DosageText"/>
						</xsl:call-template>
				</xsl:if>&#160;
				<xsl:if test="ref:IntendedDuration">&#160;/&#160;<xsl:value-of select="ref:IntendedDuration/@V"/>&#160;<xsl:value-of select="ref:IntendedDuration/@U"/></xsl:if>
				<xsl:if test="not(ref:DosageText) and not(ref:IntendedDuration)">&#160;</xsl:if>
			</td>
		</xsl:if>
		<xsl:if test="//ref:Medication/ref:Comment">
			<td colspan="{$med-com-col}">
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="ref:Comment"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//ref:InfItem[ref:Medication]/ref:StartDateTime">
			<td colspan="{$med-sdate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../ref:StartDateTime/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//ref:InfItem[ref:Medication]/ref:EndDateTime">
			<td colspan="{$med-edate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../ref:EndDateTime/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//ref:InfItem[ref:Medication]/ref:OrgDate">
			<td colspan="{$med-odate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../ref:OrgDate/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ref:Patient" mode="full">
		<xsl:if test="ref:BasisForHealthServices or ref:Sex or ref:DateOfBirth or ref:AdditionalId">
			<tr>
				<th rowspan="2">Pasientinfo</th>
				<xsl:if test="ref:Name">
					<th colspan="{(($std-col)-2)*number(not(ref:OffId | ref:Sex | ref:DateOfBirth | ref:DateOfDeath | ref:BasisForHealthServices | ref:AdditionalId ))+1}">Navn</th>
				</xsl:if>
				<xsl:if test="ref:OffId">
					<th colspan="{(($std-col)-2-count(ref:Name))*number(not(ref:Sex | ref:DateOfBirth | ref:DateOfDeath | ref:BasisForHealthServices | ref:AdditionalId))+1}">
						<xsl:choose>
							<xsl:when test="ref:TypeOffId/@DN"><xsl:value-of select="ref:TypeOffId/@DN"/></xsl:when>
							<xsl:when test="ref:TypeOffId/@V"><xsl:for-each select="ref:TypeOffId"><xsl:call-template name="k-8116"/>&#160;</xsl:for-each></xsl:when>
						</xsl:choose>
					</th>
				</xsl:if>
				<xsl:if test="ref:Sex">
					<th colspan="{(($std-col)-2-count(ref:Name | ref:OffId))*number(not(ref:DateOfBirth | ref:DateOfDeath | ref:BasisForHealthServices | ref:AdditionalId))+1}">Kjønn</th>
				</xsl:if>
				<xsl:if test="ref:DateOfBirth">
					<th colspan="{(($std-col)-2-count(ref:Name | ref:OffId | ref:Sex))*number(not(ref:DateOfDeath | ref:BasisForHealthServices | ref:AdditionalId))+1}">Fødselsdag</th>
				</xsl:if>
				<xsl:if test="ref:DateOfDeath">
					<th colspan="{(($std-col)-2-count(ref:Name | ref:OffId | ref:Sex | ref:DateOfBirth))*number(not(ref:BasisForHealthServices | ref:AdditionalId))+1}">Dødsdag</th>
				</xsl:if>
				<xsl:if test="ref:BasisForHealthServices">
					<th colspan="{(($std-col)-2-count(ref:Name | ref:OffId | ref:Sex | ref:DateOfBirth | ref:DateOfDeath))*number(not(ref:AdditionalId))+1}">Refusjonsgrunnlag</th>
				</xsl:if>
				<xsl:if test="ref:AdditionalId">
					<th colspan="{(($std-col)-1-count(ref:Name | ref:OffId | ref:Sex | ref:DateOfBirth | ref:DateOfDeath | ref:BasisForHealthServices))}">Tilleggs-Id</th>
				</xsl:if>
			</tr>
			<tr>
				<xsl:if test="ref:Name">
					<td colspan="{(($std-col)-2)*number(not(ref:OffId | ref:Sex | ref:DateOfBirth | ref:DateOfDeath | ref:BasisForHealthServices | ref:AdditionalId ))+1}">
						<xsl:value-of select="ref:Name"/>
					</td>
				</xsl:if>
				<xsl:if test="ref:OffId">
					<td colspan="{(($std-col)-2-count(ref:Name))*number(not(ref:Sex | ref:DateOfBirth | ref:DateOfDeath | ref:BasisForHealthServices | ref:AdditionalId))+1}">
						<xsl:value-of select="ref:OffId"/>
					</td>
				</xsl:if>
				<xsl:if test="ref:Sex">
					<td colspan="{(($std-col)-2-count(ref:Name | ref:OffId))*number(not(ref:DateOfBirth | ref:DateOfDeath | ref:BasisForHealthServices | ref:AdditionalId))+1}">
						<xsl:choose>
							<xsl:when test="ref:Sex/@DN"><xsl:value-of select="ref:Sex/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="ref:Sex"><xsl:call-template name="k-3101"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="ref:DateOfBirth">
					<td colspan="{(($std-col)-2-count(ref:Name | ref:OffId | ref:Sex))*number(not(ref:DateOfDeath | ref:BasisForHealthServices | ref:AdditionalId))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="ref:DateOfBirth/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="ref:DateOfDeath">
					<td colspan="{(($std-col)-2-count(ref:Name | ref:OffId | ref:Sex | ref:DateOfBirth))*number(not(ref:BasisForHealthServices | ref:AdditionalId))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="ref:DateOfDeath/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="ref:BasisForHealthServices">
					<td colspan="{(($std-col)-2-count(ref:Name | ref:OffId | ref:Sex | ref:DateOfBirth | ref:DateOfDeath))*number(not(ref:AdditionalId))+1}">
						<xsl:choose>
							<xsl:when test="ref:BasisForHealthServices/@DN"><xsl:value-of select="ref:BasisForHealthServices/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="ref:BasisForHealthServices"><xsl:call-template name="k-8246"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="ref:AdditionalId">
					<td colspan="{(($std-col)-1-count(ref:Name | ref:OffId | ref:Sex | ref:DateOfBirth | ref:DateOfDeath | ref:BasisForHealthServices))}">
						<xsl:for-each select="ref:AdditionalId">
							<div>
								<xsl:if test="ref:Type"><b><xsl:value-of select="ref:Type/@V"/>:</b>&#160;</xsl:if>
								<xsl:value-of select="ref:Id"/>
							</div>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:for-each select="ref:PatientPrecaution">
			<xsl:if test="position()=1">
				<tr><td colspan="{$std-col}"><hr/></td></tr>
				<tr>
					<th rowspan="{last()+1}">Advarsel til tjenesteyter</th>
					<xsl:if test="..//ref:PatientPrecaution/ref:Precaution">
						<th colspan="{(($std-col)-2)*number(not(..//ref:PatientPrecaution/ref:StartDateTime | ..//ref:PatientPrecaution/ref:EndDateTime))+1}">Advarsel</th>
					</xsl:if>
					<xsl:if test="..//ref:PatientPrecaution/ref:StartDateTime">
						<th colspan="{(($std-col)-2-number(boolean(..//ref:PatientPrecaution/ref:Precaution)))*number(not(..//ref:PatientPrecaution/ref:EndDateTime))+1}">Starttidspunkt</th>
					</xsl:if>
					<xsl:if test="..//ref:PatientPrecaution/ref:EndDateTime">
						<th colspan="{(($std-col)-1-number(boolean(..//ref:PatientPrecaution/ref:Precaution))-number(boolean(..//ref:PatientPrecaution/ref:StartDateTime)))}">Sluttidspunkt</th>
					</xsl:if>
				</tr>
			</xsl:if>
			<tr>
				<xsl:if test="..//ref:PatientPrecaution/ref:Precaution">
					<td colspan="{(($std-col)-2)*number(not(..//ref:PatientPrecaution/ref:StartDateTime | ..//ref:PatientPrecaution/ref:EndDateTime))+1}">
						<xsl:value-of select="ref:Precaution"/>&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//ref:PatientPrecaution/ref:StartDateTime">
					<td colspan="{(($std-col)-2-number(boolean(..//ref:PatientPrecaution/ref:Precaution)))*number(not(..//ref:PatientPrecaution/ref:EndDateTime))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="ref:StartDateTime/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="..//ref:PatientPrecaution/ref:EndDateTime">
					<td colspan="{(($std-col)-1-number(boolean(..//ref:PatientPrecaution/ref:Precaution))-number(boolean(..//ref:PatientPrecaution/ref:StartDateTime)))}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="ref:EndDateTime/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="ref:Consent">
			<tr><td colspan="{$std-col}"><hr/></td></tr>
			<tr>
				<th rowspan="2">Samtykke</th>
				<xsl:if test="ref:ConsentStatus">
					<th colspan="{(($std-col)-2)*number(not(ref:ConsentDate | ref:Merknad | ref:GivenBy))+1}">Samtykke&#160;gitt</th>
				</xsl:if>
				<xsl:if test="ref:ConsentDate">
					<th colspan="{(($std-col)-2-count(ref:ConsentStatus))*number(not(ref:Merknad | ref:GivenBy))+1}">Samtykkedato</th>
				</xsl:if>
				<xsl:if test="ref:Merknad">
					<th colspan="{(($std-col)-2-count(ref:ConsentStatus | ref:ConsentDate))*number(not(ref:GivenBy))+1}">Merknad</th>
				</xsl:if>
				<xsl:if test="ref:GivenBy">
					<th colspan="{(($std-col)-1-count(ref:ConsentStatus | ref:ConsentDate | ref:Merknad))}">Gitt&#160;av</th>
				</xsl:if>
			</tr>
			<tr>
				<xsl:if test="ref:ConsentStatus">
					<td colspan="{(($std-col)-2)*number(not(ref:ConsentDate | ref:Merknad | ref:GivenBy))+1}">
						<xsl:choose>
							<xsl:when test="ref:ConsentStatus/@DN"><xsl:value-of select="ref:ConsentStatus/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="ref:ConsentStatus"><xsl:call-template name="k-3109"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="ref:ConsentDate">
					<td colspan="{(($std-col)-2-count(ref:ConsentStatus))*number(not(ref:Merknad | ref:GivenBy))+1}">
						<xsl:call-template name="skrivUtDate">
							<xsl:with-param name="oppgittTid" select="ref:ConsentDate"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="ref:Merknad">
					<td colspan="{(($std-col)-2-count(ref:ConsentStatus | ref:ConsentDate))*number(not(ref:GivenBy))+1}">
						<xsl:call-template name="line-breaks"><xsl:with-param name="text" select="ref:Merknad"/></xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="ref:GivenBy">
					<td colspan="{(($std-col)-1-count(ref:ConsentStatus | ref:ConsentDate | ref:Merknad))}">
						<xsl:value-of select="ref:GivenBy"/>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="po:AssistertKommunikasjon">
			<xsl:if test="position()=1">
				<tr><td colspan="{$std-col}"><hr/></td></tr>
				<tr>
					<th rowspan="{(last()+1)}">Behov&#160;for&#160;tolk</th>
					<xsl:if test="..//po:AssistertKommunikasjon/po:PersonTolkebehov">
						<th colspan="{(($std-col)-2)*number(not(..//po:AssistertKommunikasjon/po:Horselsvikt | ..//po:AssistertKommunikasjon/po:Synsvikt | ..//po:AssistertKommunikasjon/po:BehovTolkSprak | ..//po:AssistertKommunikasjon/po:PreferertTolk | ..//po:AssistertKommunikasjon/po:BehovOpphortDato | ..//po:AssistertKommunikasjon/po:Merknad))+1}">Personen&#160;behovet&#160;gjelder</th>
					</xsl:if>
					<xsl:if test="..//po:AssistertKommunikasjon[po:Horselsvikt='true'] or ..//po:AssistertKommunikasjon[po:Synsvikt='true']">
						<th colspan="{(($std-col)-2-number(boolean(..//po:AssistertKommunikasjon/po:PersonTolkebehov)))*number(not(..//po:AssistertKommunikasjon/po:BehovTolkSprak | ..//po:AssistertKommunikasjon/po:PreferertTolk | ..//po:AssistertKommunikasjon/po:BehovOpphortDato | ..//po:AssistertKommunikasjon/po:Merknad))+1}">Handikap</th>
					</xsl:if>
					<xsl:if test="..//po:AssistertKommunikasjon/po:BehovTolkSprak">
						<th colspan="{(($std-col)-2-number(boolean(..//po:AssistertKommunikasjon/po:PersonTolkebehov))-number(boolean(..//po:AssistertKommunikasjon/po:Horselsvikt | ..//po:AssistertKommunikasjon/po:Synsvikt)))*number(not(..//po:AssistertKommunikasjon/po:PreferertTolk | ..//po:AssistertKommunikasjon/po:BehovOpphortDato | ..//po:AssistertKommunikasjon/po:Merknad))+1}">Språk</th>
					</xsl:if>
					<xsl:if test="..//po:AssistertKommunikasjon/po:PreferertTolk">
						<th colspan="{(($std-col)-2-number(boolean(..//po:AssistertKommunikasjon/po:PersonTolkebehov))-number(boolean(..//po:AssistertKommunikasjon/po:Horselsvikt | ..//po:AssistertKommunikasjon/po:Synsvikt))-number(boolean(..//po:AssistertKommunikasjon/po:BehovTolkSprak)))*number(not(..//po:AssistertKommunikasjon/po:BehovOpphortDato | ..//po:AssistertKommunikasjon/po:Merknad))+1}">Foretrukket&#160;tolk</th>
					</xsl:if>
					<xsl:if test="..//po:AssistertKommunikasjon/po:BehovOpphortDato">
						<th colspan="{(($std-col)-2-number(boolean(..//po:AssistertKommunikasjon/po:PersonTolkebehov))-number(boolean(..//po:AssistertKommunikasjon/po:Horselsvikt | ..//po:AssistertKommunikasjon/po:Synsvikt))-number(boolean(..//po:AssistertKommunikasjon/po:BehovTolkSprak))-number(boolean(..//po:AssistertKommunikasjon/po:PreferertTolk)))*number(not(..//po:AssistertKommunikasjon/po:Merknad))+1}">Behov&#160;opphørt&#160;dato</th>
					</xsl:if>
					<xsl:if test="..//po:AssistertKommunikasjon/po:Merknad">
						<th colspan="{(($std-col)-1-number(boolean(..//po:AssistertKommunikasjon/po:PersonTolkebehov))-number(boolean(..//po:AssistertKommunikasjon/po:Horselsvikt | ..//po:AssistertKommunikasjon/po:Synsvikt))-number(boolean(..//po:AssistertKommunikasjon/po:BehovTolkSprak))-number(boolean(..//po:AssistertKommunikasjon/po:PreferertTolk))-number(boolean(..//po:AssistertKommunikasjon/po:BehovOpphortDato)))}">Merknad</th>
					</xsl:if>
				</tr>
			</xsl:if>
			<tr>
				<xsl:if test="..//po:AssistertKommunikasjon/po:PersonTolkebehov">
					<td colspan="{(($std-col)-2)*number(not(..//po:AssistertKommunikasjon/po:Horselsvikt | ..//po:AssistertKommunikasjon/po:Synsvikt | ..//po:AssistertKommunikasjon/po:BehovTolkSprak | ..//po:AssistertKommunikasjon/po:PreferertTolk | ..//po:AssistertKommunikasjon/po:BehovOpphortDato | ..//po:AssistertKommunikasjon/po:Merknad))+1}">
						<xsl:for-each select="po:PersonTolkebehov">
							<div><xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/></div>
							<xsl:for-each select=".//fk1:TeleAddress"><xsl:call-template name="ref:TeleAddress"/></xsl:for-each>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="..//po:AssistertKommunikasjon[po:Horselsvikt='true'] or ..//po:AssistertKommunikasjon[po:Synsvikt='true']">
					<td colspan="{(($std-col)-2-number(boolean(..//po:AssistertKommunikasjon/po:PersonTolkebehov)))*number(not(..//po:AssistertKommunikasjon/po:BehovTolkSprak | ..//po:AssistertKommunikasjon/po:PreferertTolk | ..//po:AssistertKommunikasjon/po:BehovOpphortDato | ..//po:AssistertKommunikasjon/po:Merknad))+1}">
						<xsl:if test="po:Horselsvikt='true'">Døv</xsl:if>
						<xsl:if test="po:Horselsvikt='true' and po:Synsvikt='true'">&#160;og&#160;</xsl:if>
						<xsl:if test="po:Synsvikt='true'">Blind</xsl:if>&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//po:AssistertKommunikasjon/po:BehovTolkSprak">
					<td colspan="{(($std-col)-2-number(boolean(..//po:AssistertKommunikasjon/po:PersonTolkebehov))-number(boolean(..//po:AssistertKommunikasjon/po:Horselsvikt | ..//po:AssistertKommunikasjon/po:Synsvikt)))*number(not(..//po:AssistertKommunikasjon/po:PreferertTolk | ..//po:AssistertKommunikasjon/po:BehovOpphortDato | ..//po:AssistertKommunikasjon/po:Merknad))+1}">
						<xsl:choose>
							<xsl:when test="po:BehovTolkSprak/@DN"><xsl:value-of select="po:BehovTolkSprak/@DN"/></xsl:when>
							<xsl:when test="po:BehovTolkSprak/@V"><b>Kodet:</b>&#160;<xsl:value-of select="po:BehovTolkSprak/@V"/></xsl:when>
						</xsl:choose>&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//po:AssistertKommunikasjon/po:PreferertTolk">
					<td colspan="{(($std-col)-2-number(boolean(..//po:AssistertKommunikasjon/po:PersonTolkebehov))-number(boolean(..//po:AssistertKommunikasjon/po:Horselsvikt | ..//po:AssistertKommunikasjon/po:Synsvikt))-number(boolean(..//po:AssistertKommunikasjon/po:BehovTolkSprak)))*number(not(..//po:AssistertKommunikasjon/po:BehovOpphortDato | ..//po:AssistertKommunikasjon/po:Merknad))+1}">
						<xsl:for-each select="po:PreferertTolk">
							<div><xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/></div>
							<xsl:for-each select=".//fk1:TeleAddress"><xsl:call-template name="ref:TeleAddress"/></xsl:for-each>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="..//po:AssistertKommunikasjon/po:BehovOpphortDato">
					<td colspan="{(($std-col)-2-number(boolean(..//po:AssistertKommunikasjon/po:PersonTolkebehov))-number(boolean(..//po:AssistertKommunikasjon/po:Horselsvikt | ..//po:AssistertKommunikasjon/po:Synsvikt))-number(boolean(..//po:AssistertKommunikasjon/po:BehovTolkSprak))-number(boolean(..//po:AssistertKommunikasjon/po:PreferertTolk)))*number(not(..//po:AssistertKommunikasjon/po:Merknad))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="po:BehovOpphortDato/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="..//po:AssistertKommunikasjon/po:Merknad">
					<td colspan="{(($std-col)-1-number(boolean(..//po:AssistertKommunikasjon/po:PersonTolkebehov))-number(boolean(..//po:AssistertKommunikasjon/po:Horselsvikt | ..//po:AssistertKommunikasjon/po:Synsvikt))-number(boolean(..//po:AssistertKommunikasjon/po:BehovTolkSprak))-number(boolean(..//po:AssistertKommunikasjon/po:PreferertTolk))-number(boolean(..//po:AssistertKommunikasjon/po:BehovOpphortDato)))}">
						<xsl:call-template name="line-breaks"><xsl:with-param name="text" select="po:Merknad"/></xsl:call-template>&#160;
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="po:ParorendeForesatt">
			<xsl:if test="position()=1">
				<tr><td colspan="{$std-col}"><hr/></td></tr>
				<tr>
					<th rowspan="{last()+1}">Pårørende/foresatt</th>
					<xsl:if test="..//po:ParorendeForesatt/po:Referanseperson">
						<th colspan="{(($std-col)-2)*number(not(..//po:ParorendeForesatt/po:Slektskap | ..//po:ParorendeForesatt/po:Omsorgsfunksjon | ..//po:ParorendeForesatt/po:Merknad))+1}">Person</th>
					</xsl:if>
					<xsl:if test="..//po:ParorendeForesatt/po:Slektskap">
						<th colspan="{(($std-col)-2-number(boolean(..//po:ParorendeForesatt/po:Referanseperson)))*number(not(..//po:ParorendeForesatt/po:Omsorgsfunksjon | ..//po:ParorendeForesatt/po:Merknad))+1}">Slektskap</th>
					</xsl:if>
					<xsl:if test="..//po:ParorendeForesatt/po:Omsorgsfunksjon">
						<th colspan="{(($std-col)-2-number(boolean(..//po:ParorendeForesatt/po:Referanseperson))-number(boolean(..//po:ParorendeForesatt/po:Slektskap)))*number(not(..//po:ParorendeForesatt/po:Merknad))+1}">Omsorgsfunksjon</th>
					</xsl:if>
					<xsl:if test="..//po:ParorendeForesatt/po:Merknad">
						<th colspan="{(($std-col)-1-number(boolean(..//po:ParorendeForesatt/po:Referanseperson))-number(boolean(..//po:ParorendeForesatt/po:Slektskap))-number(boolean(..//po:ParorendeForesatt/po:Omsorgsfunksjon)))}">Merknad</th>
					</xsl:if>
				</tr>
			</xsl:if>
			<tr>
				<xsl:if test="..//po:ParorendeForesatt/po:Referanseperson">
					<td colspan="{(($std-col)-2)*number(not(..//po:ParorendeForesatt/po:Slektskap | ..//po:ParorendeForesatt/po:Omsorgsfunksjon | ..//po:ParorendeForesatt/po:Merknad))+1}">
						<xsl:for-each select="po:Referanseperson">
							<div><xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/></div>
							<xsl:for-each select=".//fk1:TeleAddress"><xsl:call-template name="ref:TeleAddress"/></xsl:for-each>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="..//po:ParorendeForesatt/po:Slektskap">
					<td colspan="{(($std-col)-2-number(boolean(..//po:ParorendeForesatt/po:Referanseperson)))*number(not(..//po:ParorendeForesatt/po:Omsorgsfunksjon | ..//po:ParorendeForesatt/po:Merknad))+1}">
						<xsl:choose>
							<xsl:when test="po:Slektskap/@DN"><xsl:value-of select="po:Slektskap/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="po:Slektskap"><xsl:call-template name="k-9033"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="..//po:ParorendeForesatt/po:Omsorgsfunksjon">
					<td colspan="{(($std-col)-2-number(boolean(..//po:ParorendeForesatt/po:Referanseperson))-number(boolean(..//po:ParorendeForesatt/po:Slektskap)))*number(not(..//po:ParorendeForesatt/po:Merknad))+1}">
						<xsl:choose>
							<xsl:when test="po:Omsorgsfunksjon/@DN"><xsl:value-of select="po:Omsorgsfunksjon/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="po:Omsorgsfunksjon"><xsl:call-template name="k-9050"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="..//po:ParorendeForesatt/po:Merknad">
					<td colspan="{(($std-col)-1-number(boolean(..//po:ParorendeForesatt/po:Referanseperson))-number(boolean(..//po:ParorendeForesatt/po:Slektskap))-number(boolean(..//po:ParorendeForesatt/po:Omsorgsfunksjon)))}">
						<xsl:value-of select="po:Merknad"/>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="ref:ContactPerson">
			<xsl:if test="position()=1">
				<tr><td colspan="{$std-col}"><hr/></td></tr>
				<tr>
					<th rowspan="{last()+1}">Kontaktperson</th>
					<xsl:if test="..//ref:ContactPerson/ref:Referanseperson">
						<th colspan="{(($std-col)-2)*number(not(..//ref:ContactPerson/ref:OccupationRole | ..//ref:ContactPerson/ref:WorkingPlace | ..//ref:ContactPerson/ref:Merknad))+1}">Person</th>
					</xsl:if>
					<xsl:if test="..//ref:ContactPerson/ref:OccupationRole">
						<th colspan="{(($std-col)-2-number(boolean(..//ref:ContactPerson/ref:Referanseperson)))*number(not(..//ref:ContactPerson/ref:WorkingPlace | ..//ref:ContactPerson/ref:Merknad))+1}">Stilling/rolle</th>
					</xsl:if>
					<xsl:if test="..//ref:ContactPerson/ref:WorkingPlace">
						<th colspan="{(($std-col)-2-number(boolean(..//ref:ContactPerson/ref:Referanseperson))-number(boolean(..//ref:ContactPerson/ref:OccupationRole)))*number(not(..//ref:ContactPerson/ref:Merknad))+1}">Arbeidssted</th>
					</xsl:if>
					<xsl:if test="..//ref:ContactPerson/ref:Merknad">
						<th colspan="{(($std-col)-1-number(boolean(..//ref:ContactPerson/ref:Referanseperson))-number(boolean(..//ref:ContactPerson/ref:OccupationRole))-number(boolean(..//ref:ContactPerson/ref:WorkingPlace)))}">Merknad</th>
					</xsl:if>
				</tr>
			</xsl:if>
			<tr>
				<xsl:if test="..//ref:ContactPerson/ref:Referanseperson">
					<td colspan="{(($std-col)-2)*number(not(..//ref:ContactPerson/ref:OccupationRole | ..//ref:ContactPerson/ref:WorkingPlace | ..//ref:ContactPerson/ref:Merknad))+1}">
						<xsl:for-each select="ref:Referanseperson">
							<div><xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/></div>
							<xsl:for-each select=".//fk1:TeleAddress"><xsl:call-template name="ref:TeleAddress"/></xsl:for-each>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="..//ref:ContactPerson/ref:OccupationRole">
					<td colspan="{(($std-col)-2-number(boolean(..//ref:ContactPerson/ref:Referanseperson)))*number(not(..//ref:ContactPerson/ref:WorkingPlace | ..//ref:ContactPerson/ref:Merknad))+1}">
						<xsl:value-of select="ref:OccupationRole"/>
					</td>
				</xsl:if>
				<xsl:if test="..//ref:ContactPerson/ref:WorkingPlace">
					<td colspan="{(($std-col)-2-number(boolean(..//ref:ContactPerson/ref:Referanseperson))-number(boolean(..//ref:ContactPerson/ref:OccupationRole)))*number(not(..//ref:ContactPerson/ref:Merknad))+1}">
						<xsl:value-of select="ref:WorkingPlace"/>
					</td>
				</xsl:if>
				<xsl:if test="..//ref:ContactPerson/ref:Merknad">
					<td colspan="{(($std-col)-1-number(boolean(..//ref:ContactPerson/ref:Referanseperson))-number(boolean(..//ref:ContactPerson/ref:OccupationRole))-number(boolean(..//ref:ContactPerson/ref:WorkingPlace)))}">
						<xsl:value-of select="ref:Merknad"/>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="ref:PatRelInst">
			<xsl:if test="position()=1">
				<tr><td colspan="{$std-col}"><hr/></td></tr>
				<tr>
					<th rowspan="{last()+1}">Referert virksomhet</th>
					<xsl:if test="..//ref:PatRelInst/ref:NameInst">
						<th colspan="{(($std-col)-2)*number(not(..//ref:PatRelInst/ref:RoleInst | ..//ref:PatRelInst/ref:ContactPerson | ..//ref:PatRelInst/ref:Merknad))+1}">Navn</th>
					</xsl:if>
					<xsl:if test="..//ref:PatRelInst/ref:RoleInst">
						<th colspan="{(($std-col)-2-number(boolean(..//ref:PatRelInst/ref:NameInst)))*number(not(..//ref:PatRelInst/ref:ContactPerson | ..//ref:PatRelInst/ref:Merknad))+1}">Rolle</th>
					</xsl:if>
					<xsl:if test="..//ref:PatRelInst/ref:ContactPerson">
						<th colspan="{(($std-col)-2-number(boolean(..//ref:PatRelInst/ref:NameInst))-number(boolean(..//ref:PatRelInst/ref:RoleInst)))*number(not(..//ref:PatRelInst/ref:Merknad))+1}">Kontaktperson</th>
					</xsl:if>
					<xsl:if test="..//ref:PatRelInst/ref:Merknad">
						<th colspan="{(($std-col)-1-number(boolean(..//ref:PatRelInst/ref:NameInst))-number(boolean(..//ref:PatRelInst/ref:RoleInst))-number(boolean(..//ref:PatRelInst/ref:ContactPerson)))}">Merknad</th>
					</xsl:if>
				</tr>
			</xsl:if>
			<tr>
				<xsl:if test="..//ref:PatRelInst/ref:NameInst">
					<td colspan="{(($std-col)-2)*number(not(..//ref:PatRelInst/ref:RoleInst | ..//ref:PatRelInst/ref:ContactPerson | ..//ref:PatRelInst/ref:Merknad))+1}">
						<xsl:value-of select="ref:NameInst"/>
						&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//ref:PatRelInst/ref:RoleInst">
					<td colspan="{(($std-col)-2-number(boolean(..//ref:PatRelInst/ref:NameInst)))*number(not(..//ref:PatRelInst/ref:ContactPerson | ..//ref:PatRelInst/ref:Merknad))+1}">
						<xsl:value-of select="ref:RoleInst"/>
						&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//ref:PatRelInst/ref:ContactPerson">
					<td colspan="{(($std-col)-2-number(boolean(..//ref:PatRelInst/ref:NameInst))-number(boolean(..//ref:PatRelInst/ref:RoleInst)))*number(not(..//ref:PatRelInst/ref:Merknad))+1}">
						<xsl:value-of select="ref:ContactPerson"/>
						&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//ref:PatRelInst/ref:Merknad">
					<td colspan="{(($std-col)-1-number(boolean(..//ref:PatRelInst/ref:NameInst))-number(boolean(..//ref:PatRelInst/ref:RoleInst))-number(boolean(..//ref:PatRelInst/ref:ContactPerson)))}">
						<xsl:value-of select="ref:Merknad"/>
						&#160;
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="ref:PatRelHCP">
		<xsl:variable name="raw-rows" select="count(.//ref:HCProf | .//ref:HCPerson | .//ref:Dept)"/>
		<xsl:variable name="rows">
			<xsl:choose>
				<xsl:when test="$raw-rows&gt;0"><xsl:value-of select="$raw-rows"/></xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<xsl:if test="..//ref:PatRelHCP/ref:Relation">
				<th rowspan="{$rows}">
					<xsl:choose>
						<xsl:when test="ref:Relation/@DN"><xsl:value-of select="ref:Relation/@DN"/></xsl:when>
						<xsl:otherwise><xsl:for-each select="ref:Relation"><xsl:call-template name="k-7319"/>&#160;</xsl:for-each></xsl:otherwise>
					</xsl:choose>&#160;
				</th>
			</xsl:if>
			<xsl:if test="..//ref:PatRelHCP//ref:HCProf | ..//ref:PatRelHCP//ref:HCPerson | ..//ref:PatRelHCP//ref:Dept">
				<xsl:choose>
					<xsl:when test=".//ref:HCProf | .//ref:HCPerson | .//ref:Dept">
						<xsl:for-each select=".//ref:HCProf | .//ref:HCPerson | .//ref:Dept">
							<xsl:if test="position()=1"><xsl:apply-templates select="."/></xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise><td>&#160;</td><td>&#160;</td></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="..//ref:PatRelHCP//ref:Inst/ref:Name">
				<td rowspan="{$rows}" colspan="{(($std-col)-2-number(boolean(..//ref:PatRelHCP//ref:HCProf | ..//ref:PatRelHCP//ref:HCPerson | ..//ref:PatRelHCP//ref:Dept))-1)*number(not(..//ref:PatRelHCP//ref:MedSpeciality | ..//ref:PatRelHCP//ref:Inst/ref:Id | ..//ref:PatRelHCP/ref:StartDateTime | ..//ref:PatRelHCP/ref:EndDateTime | ..//ref:PatRelHCP//ref:Address))+1}">
					<xsl:value-of select=".//ref:Inst/ref:Name"/>&#160;
				</td>
			</xsl:if>
			<xsl:if test="..//ref:PatRelHCP//ref:MedSpeciality">
				<td rowspan="{$rows}" colspan="{(($std-col)-2-number(boolean(..//ref:PatRelHCP//ref:HCProf | ..//ref:PatRelHCP//ref:HCPerson | ..//ref:PatRelHCP//ref:Dept))-1-number(boolean(..//ref:PatRelHCP//ref:Inst/ref:Name)))*number(not(..//ref:PatRelHCP//ref:Inst/ref:Id | ..//ref:PatRelHCP/ref:StartDateTime | ..//ref:PatRelHCP/ref:EndDateTime | ..//ref:PatRelHCP//ref:Address))+1}">
					<xsl:for-each select=".//ref:MedSpeciality">
						<xsl:choose>
							<xsl:when test="@DN"><xsl:value-of select="@DN"/></xsl:when>
							<xsl:when test="@OT"><xsl:value-of select="@OT"/></xsl:when>
							<xsl:otherwise><b>Kodet:</b>&#160;<xsl:value-of select="@V"/></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>&#160;
				</td>
			</xsl:if>
			<xsl:if test="..//ref:PatRelHCP//ref:Inst/ref:Id">
				<td rowspan="{$rows}" colspan="{(($std-col)-2-number(boolean(..//ref:PatRelHCP//ref:HCProf | ..//ref:PatRelHCP//ref:HCPerson | ..//ref:PatRelHCP//ref:Dept))-1-number(boolean(..//ref:PatRelHCP//ref:Inst/ref:Name))-number(boolean(..//ref:PatRelHCP//ref:MedSpeciality)))*number(not(..//ref:PatRelHCP/ref:StartDateTime | ..//ref:PatRelHCP/ref:EndDateTime | ..//ref:PatRelHCP//ref:Address))+1}">
					<xsl:if test=".//ref:Inst/ref:TypeId/@V">
						<b><xsl:value-of select=".//ref:Inst/ref:TypeId/@V"/>:</b>
					</xsl:if>&#160;
					<xsl:value-of select=".//ref:Inst/ref:Id"/>
				</td>
			</xsl:if>
			<xsl:if test="..//ref:PatRelHCP//ref:StartDateTime | ..//ref:PatRelHCP//ref:EndDateTime">
				<td rowspan="{$rows}" colspan="{(($std-col)-2-number(boolean(..//ref:PatRelHCP//ref:HCProf | ..//ref:PatRelHCP//ref:HCPerson | ..//ref:PatRelHCP//ref:Dept))-1-number(boolean(..//ref:PatRelHCP//ref:Inst/ref:Name))-number(boolean(..//ref:PatRelHCP//ref:MedSpeciality))-number(boolean(..//ref:PatRelHCP//ref:Inst/ref:Id)))*number(not(..//ref:PatRelHCP//ref:Address))+1}">
					<xsl:if test="ref:StartDateTime">
						<b>Start:</b>&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="ref:StartDateTime/@V"/>
						</xsl:call-template>
					</xsl:if>&#160;
					<xsl:if test="ref:EndDateTime">
						<div><b>Slutt:</b>&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="ref:EndDateTime/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="..//ref:PatRelHCP//ref:Address">
				<td rowspan="{$rows}" colspan="{(($std-col)-1-number(boolean(..//ref:PatRelHCP//ref:HCProf | ..//ref:PatRelHCP//ref:HCPerson | ..//ref:PatRelHCP//ref:Dept))-1-number(boolean(..//ref:PatRelHCP//ref:Inst/ref:Name))-number(boolean(..//ref:PatRelHCP//ref:MedSpeciality))-number(boolean(..//ref:PatRelHCP//ref:Inst/ref:Id))-number(boolean(..//ref:PatRelHCP/ref:StartDateTime | ..//ref:PatRelHCP/ref:EndDateTime)))}">
					<xsl:apply-templates select=".//ref:Address" mode="full"/>
				</td>
			</xsl:if>
		</tr>
		<xsl:for-each select=".//ref:HCProf | .//ref:HCPerson | .//ref:Dept">
			<xsl:if test="position()!=1"><tr><xsl:apply-templates select="."/></tr></xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="ref:HCProf | ref:HCPerson | ref:Dept">
		<td colspan="{(($std-col)-2)*number(not(//ref:PatRelHCP//ref:HCProf/ref:Id | //ref:PatRelHCP//ref:HCProf/ref:AdditionalId | //ref:PatRelHCP//ref:HCPerson/ref:Id | //ref:PatRelHCP//ref:HCPerson/ref:AdditionalId | //ref:PatRelHCP//ref:Dept/ref:Id | //ref:PatRelHCP//ref:Dept/ref:AdditionalId | //ref:PatRelHCP//ref:Inst/ref:Name | //ref:PatRelHCP//ref:MedSpeciality | //ref:PatRelHCP//ref:Inst/ref:Id | //ref:PatRelHCP/ref:StartDateTime | //ref:PatRelHCP/ref:EndDateTime | //ref:PatRelHCP//ref:Address))+1}">
			<xsl:if test="ref:Type/@DN">
				<b><xsl:value-of select="ref:Type/@DN"/></b>&#160;
			</xsl:if>
			<xsl:value-of select="ref:Name"/>&#160;
		</td>
		<td colspan="{(($std-col)-3)*number(not(//ref:PatRelHCP//ref:Inst/ref:Name | //ref:PatRelHCP//ref:MedSpeciality | //ref:PatRelHCP//ref:Inst/ref:Id | //ref:PatRelHCP/ref:StartDateTime | //ref:PatRelHCP/ref:EndDateTime | //ref:PatRelHCP//ref:Address))+1}">
			<xsl:if test="ref:TypeId/@V">
				<b><xsl:value-of select="ref:TypeId/@V"/>:</b>&#160;
			</xsl:if>
			<xsl:value-of select="ref:Id"/>&#160;
		</td>
	</xsl:template>
	<xsl:template match="ref:Address" mode="full">
		<xsl:if test="ref:Type">
			<b>
				<xsl:choose>
					<xsl:when test="ref:Type/@DN"><xsl:value-of select="ref:Type/@DN"/>:&#160;</xsl:when>
					<xsl:otherwise><xsl:for-each select="ref:Type"><xsl:call-template name="k-3401"/>:&#160;</xsl:for-each></xsl:otherwise>
				</xsl:choose>
			</b>
		</xsl:if>
		<xsl:if test="ref:StreetAdr"><xsl:value-of select="ref:StreetAdr"/></xsl:if>
		<xsl:if test="ref:PostalCode or ref:City">
			<xsl:if test="ref:StreetAdr">,&#160;</xsl:if>
			<xsl:value-of select="ref:PostalCode"/>&#160;<xsl:value-of select="ref:City"/>
		</xsl:if>
		<xsl:if test="ref:CityDistr">&#160;,<xsl:value-of select="ref:CityDistr/@DN"/></xsl:if>
		<xsl:if test="ref:County">&#160;,<xsl:value-of select="ref:County/@DN"/></xsl:if>
		<xsl:if test="ref:Country">&#160;,<xsl:value-of select="ref:Country/@DN"/></xsl:if>
		&#160;
		<xsl:for-each select="ref:TeleAddress"><xsl:apply-templates select="."/></xsl:for-each>
	</xsl:template>
	<xsl:template match="ref:RefDoc">
		<tr>
			<xsl:if test="ref:MsgType">
				<th><xsl:if test="count(//ref:RefDoc) &gt; 1">Vedlegg<xsl:value-of select="position()"/>:&#160;</xsl:if>Type</th>
				<td colspan="{(($std-col)-2)*number(not(ref:IssueDate | ref:Id | ref:MimeType | ref:Description | ref:Compression | ref:FileReference | ref:Content))+1}">
					<xsl:choose>
						<xsl:when test="ref:MsgType/@DN"><xsl:value-of select="ref:MsgType/@DN"/></xsl:when>
						<xsl:otherwise><xsl:for-each select="ref:MsgType"><xsl:call-template name="k-8263"/>&#160;</xsl:for-each></xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="ref:IssueDate">
				<th>Utstedt</th>
				<td colspan="{(($std-col)-2-count(ref:MsgType)*2)*number(not(ref:Id | ref:MimeType | ref:Description | ref:Compression | ref:FileReference | ref:Content))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="ref:IssueDate/@V"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="ref:Id or ref:MimeType or ref:Description or ref:Compression">
				<th>Egenskaper</th>
				<td colspan="{(($std-col)-2-count(ref:MsgType | ref:IssueDate)*2)*number(not(ref:FileReference | ref:Content))+1}">
					<xsl:if test="ref:Description"><div><b>Beskrivelse:&#160;</b><xsl:value-of select="ref:Description"/></div></xsl:if>
					<xsl:if test="ref:MimeType"><div><b>Mime type:&#160;</b><xsl:value-of select="ref:MimeType"/></div></xsl:if>
					<xsl:if test="ref:Compression"><div><b>Komprimering:&#160;</b>
						<xsl:choose>
							<xsl:when test="ref:Compression/@DN"><xsl:value-of select="ref:Compression/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="ref:Compression"><xsl:call-template name="k-1204"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose></div>
					</xsl:if>
					<xsl:if test="ref:Id"><div><b>Id:&#160;</b><xsl:value-of select="ref:Id"/></div></xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="ref:FileReference or ref:Content">
				<th>
					<xsl:if test="ref:FileReference">Filreferanse</xsl:if>
					<xsl:if test="ref:Content">Innhold</xsl:if>
				</th>
				<td colspan="{($std-col)-1-count(ref:MsgType | ref:IssueDate)*2-number(not(not(ref:Id | ref:MimeType | ref:Description | ref:Compression)))*2}">
					<xsl:if test="ref:FileReference"><xsl:value-of select="ref:FileReference"/></xsl:if>
					<xsl:if test="ref:Content"><xsl:value-of select="ref:Content"/></xsl:if>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
		
	<!-- Kodeverk -->
	<xsl:template name="k-1204">
		<xsl:choose>
			<xsl:when test="@V='DF'">Deflate</xsl:when>
			<xsl:when test="@V='GZ'">Gzip</xsl:when>
			<xsl:when test="@V='Z'">Compress</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3101">
		<xsl:choose>
			<xsl:when test="@V='0'">Ikke kjent</xsl:when>
			<xsl:when test="@V='1'">Mann</xsl:when>
			<xsl:when test="@V='2'">Kvinne</xsl:when>
			<xsl:when test="@V='9'">Ikke spesifisert</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3105">
		<xsl:choose>
			<xsl:when test="@V='1'">Bor hos begge foreldre</xsl:when>
			<xsl:when test="@V='2'">Pendler mellom foreldre</xsl:when>
			<xsl:when test="@V='3'">Bor hos en av foreldrene</xsl:when>
			<xsl:when test="@V='4'">Bor hos en av foreldrene og en eller flere andre voksne</xsl:when>
			<xsl:when test="@V='5'">Bor hos besteforeldre eller andre</xsl:when>
			<xsl:when test="@V='6'">Fosterhjem</xsl:when>
			<xsl:when test="@V='7'">Institusjon</xsl:when>
			<xsl:when test="@V='8'">Bor alene</xsl:when>
			<xsl:when test="@V='9'">Annet</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3109">
		<xsl:choose>
			<xsl:when test="@V='1'">Ja</xsl:when>
			<xsl:when test="@V='2'">Nei</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-3401">
		<xsl:choose>
			<xsl:when test="@V='H'">Bostedsadresse</xsl:when>
			<xsl:when test="@V='HP'">Folkeregisteradresse</xsl:when>
			<xsl:when test="@V='HV'">Ferieadresse</xsl:when>
			<xsl:when test="@V='INV'">Faktureringsadresse</xsl:when>
			<xsl:when test="@V='PST'">Postadresse</xsl:when>
			<xsl:when test="@V='RES'">Besøksadresse</xsl:when>
			<xsl:when test="@V='TMP'">Midlertidig adresse</xsl:when>
			<xsl:when test="@V='WP'">Arbeidsadresse</xsl:when>
			<xsl:when test="@V='BAD'">Ubrukelig&#160;adresse</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7304">
		<xsl:choose>
			<xsl:when test="@V='J'">Ja</xsl:when>
			<xsl:when test="@V='N'">Nei</xsl:when>
			<xsl:when test="@V='F'">Kun ved feil</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7307">
		<xsl:choose>
			<xsl:when test="@V='1'">Inntatt</xsl:when>
			<xsl:when test="@V='2'">Forskrevet</xsl:when>
			<xsl:when test="@V='3'">Anbefalt&#160;å&#160;innta</xsl:when>
			<xsl:when test="@V='4'">Anbefalt&#160;å&#160;slutte&#160;å&#160;innta</xsl:when>
			<xsl:when test="@V='5'">Benyttes&#160;sporadisk</xsl:when>
			<xsl:when test="@V='6'">Benyttes&#160;regelmessig</xsl:when>
			<xsl:when test="@V='10'">Allergisk&#160;ovenfor</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7309">
		<xsl:choose>
			<xsl:when test="@V='N'">Ny</xsl:when>
			<xsl:when test="@V='M'">Endring</xsl:when>
			<xsl:when test="@V='A'">Tillegg</xsl:when>
			<xsl:when test="@V='H'">Historikk</xsl:when>
			<xsl:when test="@V='C'">Kansellering</xsl:when>
			<xsl:when test="@V='X'">Annet</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-7319">
		<xsl:choose>
			<xsl:when test="@V='FLE'">Fastlege</xsl:when>
			<xsl:when test="@V='RHI'">Ansvarlig institusjon</xsl:when>
			<xsl:when test="@V='RHP'">Ansvarlig lege</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8116">
		<xsl:choose>
			<xsl:when test="@V='FNR'">Fødselsnummer</xsl:when>
			<xsl:when test="@V='DNR'">D-nummer</xsl:when>
			<xsl:when test="@V='HNR'">H-nummer</xsl:when>
			<xsl:when test="@V='HPR'">HPR-id</xsl:when>
			<xsl:when test="@V='HER'">HER-id</xsl:when>
			<xsl:when test="@V='PNR'">Passnummer</xsl:when>
			<xsl:when test="@V='SEF'">Svensk 'personnummer'</xsl:when>
			<xsl:when test="@V='DKF'">Dansk 'personnummer'</xsl:when>
			<xsl:when test="@V='SSN'">Sosial security number</xsl:when>
			<xsl:when test="@V='FPN'">Forsikringspolise nummer</xsl:when>
			<xsl:when test="@V='UID'">Utenlandsk identifikasjon</xsl:when>
			<xsl:when test="@V='DUF'">DUF-nummer</xsl:when>
			<xsl:when test="@V='FHN'">Felles hjelpenummer</xsl:when>
			<xsl:when test="@V='XXX'">Annet</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8231">
		<xsl:choose>
			<xsl:when test="@V='BG'">Begrunnelse</xsl:when>
			<xsl:when test="@V='BUP-BM'">Henvisningsgrunn barnets&#160;miljø</xsl:when>
			<xsl:when test="@V='BUP-HG'">Henvisningsgrunn barnet</xsl:when>
			<xsl:when test="@V='DIAG'">Diagnose</xsl:when>
			<xsl:when test="@V='FA'">Familie/sosialt</xsl:when>
			<xsl:when test="@V='FO'">Forløp og behandling</xsl:when>
			<xsl:when test="@V='FU'">Funn og undersøkelsesresultater</xsl:when>
			<xsl:when test="@V='HJ'">Funksjonsnivå/hjelpetiltak</xsl:when>
			<xsl:when test="@V='IP'">Informasjon til pasient/pårørende</xsl:when>
			<xsl:when test="@V='KF'">Kontroll pga. tidligere funn</xsl:when>
			<xsl:when test="@V='MAAL'">Mål for oppholdet</xsl:when>
			<xsl:when test="@V='MU'">Innkalt til masseundersøkelse</xsl:when>
			<xsl:when test="@V='PROB'">Problemstilling</xsl:when>
			<xsl:when test="@V='RU'">Rutineundersøkelse utenom masseundersøkelse</xsl:when>
			<xsl:when test="@V='SVU'">Spesialistvurdering</xsl:when>
			<xsl:when test="@V='UP'">Ubesvarte prøver</xsl:when>
			<xsl:when test="@V='UTRED'">Forventet utredning/behandling</xsl:when>
			<xsl:when test="@V='VU'">Vurdering</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8233">
		<xsl:choose>
			<xsl:when test="@V='H'">Hoveddiagnose</xsl:when>
			<xsl:when test="@V='B'">Bidiagnose</xsl:when>
			<xsl:when test="@V='MEDB'">Legemiddelopplysning</xsl:when>
			<xsl:when test="@V='OPIN'">Operasjon/inngrep</xsl:when>
			<xsl:when test="@V='MPRS'">Medisinsk prosedyre</xsl:when>
			<xsl:when test="@V='PRS'">Andre prosedyrer</xsl:when>
			<xsl:when test="@V='PROG'">Prognose</xsl:when>
			<xsl:when test="@V='ANAM'">Sykehistorie</xsl:when>
			<xsl:when test="@V='CAVE'">Cave-opplysninger</xsl:when>
			<xsl:when test="@V='NB'">NB-opplysninger</xsl:when>
			<xsl:when test="@V='GBEH'">Tidligere gynekologisk behandling</xsl:when>
			<xsl:when test="@V='GOPL'">Gynekologiske opplysninger</xsl:when>
			<xsl:when test="@V='OPPL'">Klinisk opplysning</xsl:when>
			<xsl:when test="@V='SYKM'">Opplysninger om sykemelding</xsl:when>
			<xsl:when test="@V='SYMP'">Symptom</xsl:when>
			<xsl:when test="@V='TB'">Tidligere behandling</xsl:when>
			<xsl:when test="@V='US'">Tidligere undersøkelse</xsl:when>
			<xsl:when test="@V='SM'">Smitte</xsl:when>
			<xsl:when test="@V='FUNN'">Funn/undersøkelsesresultat</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8234">
		<xsl:choose>
			<xsl:when test="@V='ADM'">Økonomisk/administrativ kommentar</xsl:when>
			<xsl:when test="@V='BUP-S'">Saksbehandler for denne saken</xsl:when>
			<xsl:when test="@V='EHK'">Europeisk helsetrygdkortnummer</xsl:when>
			<xsl:when test="@V='SH'">Spesielle hensyn</xsl:when>
			<xsl:when test="@V='TEL'">Telefonnummer</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8239">
		<xsl:choose>
			<xsl:when test="@V='GE'">H</xsl:when>
			<xsl:when test="@V='GT'">H</xsl:when>
			<xsl:when test="@V='LE'">L</xsl:when>
			<xsl:when test="@V='LT'">L</xsl:when>
			<xsl:when test="@V='MG'">H</xsl:when>
			<xsl:when test="@V='ML'">L</xsl:when>
			<xsl:when test="@V='NE'">!=</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8240">
		<xsl:choose>
			<xsl:when test="@V='Følger av en innleggelse'">H</xsl:when>
			<xsl:when test="@V='2'">Behandling av pasient enten poliklinisk eller ved dagopphold. Behandlingen er mer omfattende enn vanlig poliklinisk kontakt og forutsetter tilgang til seng, men ikke overnatting.</xsl:when>
			<xsl:when test="@V='3'">Omsorg hvor de medisinske tiltak er kortvarige og hvor pasienten ikke innlegges.</xsl:when>
			<xsl:when test="@V='4'">Undersøkelse, overvåkning, behandling eller administrasjon av pasienter når ekspertise eller pasientinformasjon overføres til/fra et annet geografisk sted ved bruk av informasjonsteknologi.</xsl:when>
			<xsl:when test="@V='5'">Henvendelse, forespørsel ved personlig fremmøte på legens oppholdssted, vanligvis på legens faste arbeidssted/kontor. En konsultasjon forutsetter en direkte kontakt mellom lege og pasient og at legen foretar en utredning.</xsl:when>
			<xsl:when test="@V='6'">Kontakt med pasient eller annet helsefaglig personell via telefon i forbindelse med behandling/pleie av en pasient.</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8243">
		<xsl:choose>
			<xsl:when test="@V='AN'">Analyse</xsl:when>
			<xsl:when test="@V='FU'">Funn og undersøkelsesresultater</xsl:when>
			<xsl:when test="@V='GR'">Gruppe</xsl:when>
			<xsl:when test="@V='LR'">Laboratorieresultat</xsl:when>
			<xsl:when test="@V='RSB'">Resistensbestemmelse</xsl:when>
			<xsl:when test="@V='SY'">Sykmelding</xsl:when>
			<xsl:when test="@V='UP'">Ubesvarte prøver</xsl:when>
			<xsl:when test="@V='VU'">Vurdering</xsl:when>
			<xsl:when test="@V='XX'">Uspesifisert</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8246">
		<xsl:choose>
			<xsl:when test="@V='1'">Folketrygdmedlem</xsl:when>
			<xsl:when test="@V='2'">EU-borger</xsl:when>
			<xsl:when test="@V='3'">Bilateral avtale</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8248">
		<xsl:choose>
			<xsl:when test="@V='1'">Utredning</xsl:when>
			<xsl:when test="@V='2'">Behandling</xsl:when>
			<xsl:when test="@V='3'">Kontroll</xsl:when>
			<xsl:when test="@V='4'">Second opinion</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8263">
		<xsl:choose>
			<xsl:when test="@V='B'">Booking</xsl:when>
			<xsl:when test="@V='H'">Henvisning</xsl:when>
			<xsl:when test="@V='H_REHAB'">Henvisning til rehabiliteringsinstitusjon</xsl:when>
			<xsl:when test="@V='T'">Tilbakemelding på henvisning</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8264">
		<xsl:choose>
			<xsl:when test="@V='000'">Svangerskapskontroll uke 18</xsl:when>
			<xsl:when test="@V='001'">Svangerskap vurdering leie</xsl:when>
			<xsl:when test="@V='002'">Svangerskap overtidskontroll</xsl:when>
			<xsl:when test="@V='003'">CIN utredning</xsl:when>
			<xsl:when test="@V='004'">Gastroskopi</xsl:when>
			<xsl:when test="@V='005'">Utredning lyskebrokk</xsl:when>
			<xsl:when test="@V='006'">Utredning gallestein</xsl:when>
			<xsl:when test="@V='007'">Sterilisering kvinner</xsl:when>
			<xsl:when test="@V='008'">Gynekologisk spesialistvurdering</xsl:when>
			<xsl:when test="@V='009'">Vurdering eksem</xsl:when>
			<xsl:when test="@V='010'">Vurdering psoriasis</xsl:when>
			<xsl:when test="@V='011'">Utredning/behandling hudtumor</xsl:when>
			<xsl:when test="@V='012'">Coloskopi</xsl:when>
			<xsl:when test="@V='013'">Arbeids-EKG</xsl:when>
			<xsl:when test="@V='014'">Ekkokardiografi</xsl:when>
			<xsl:when test="@V='015'">Operasjon fimose</xsl:when>
			<xsl:when test="@V='016'">Operasjon hallux valgus</xsl:when>
			<xsl:when test="@V='017'">Artroskopi meniskruptur</xsl:when>
			<xsl:when test="@V='018'">Operasjon canalis carpi</xsl:when>
			<xsl:when test="@V='019'">Operasjon varicer</xsl:when>
			<xsl:when test="@V='020'">Tilpasning høreapparat</xsl:when>
			<xsl:when test="@V='021'">Vurdering sekretorisk otitt barn</xsl:when>
			<xsl:when test="@V='022'">Vurdering av nattlig enurese hos barn</xsl:when>
			<xsl:when test="@V='023'">Vurdering av bilyd på hjertet hos barn</xsl:when>
			<xsl:when test="@V='024'">Vurdering av atopisk eksem hos barn</xsl:when>
			<xsl:when test="@V='025'">Røntgen thorax</xsl:when>
			<xsl:when test="@V='026'">Røntgen over- og underekstremiteter</xsl:when>
			<xsl:when test="@V='027'">Psykiatrisk vurdering barn og ungdom</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8304">
		<xsl:choose>
			<xsl:when test="@V='0'">Umiddelbart</xsl:when>
			<xsl:when test="@V='1H'">Innen en time</xsl:when>
			<xsl:when test="@V='2H'">Innen to timer</xsl:when>
			<xsl:when test="@V='4H'">Innen fire timer</xsl:when>
			<xsl:when test="@V='8H'">Innen åtte timer</xsl:when>
			<xsl:when test="@V='1'">Innen tjuefire timer</xsl:when>
			<xsl:when test="@V='2'">Innen to døgn</xsl:when>
			<xsl:when test="@V='7'">Innen en uke</xsl:when>
			<xsl:when test="@V='14'">Innen to uker</xsl:when>
			<xsl:when test="@V='21'">Innen tre uker</xsl:when>
			<xsl:when test="@V='30'">Innen en måned</xsl:when>
			<xsl:when test="@V='90'">Innen tre måneder</xsl:when>
			<xsl:when test="@V='180'">Innen seks måneder</xsl:when>
			<xsl:when test="@V='360'">Innen tolv måneder</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8417">
		<xsl:choose>
			<xsl:when test="@V='1'">Norsk</xsl:when>
			<xsl:when test="@V='2'">Annet hjemmespråk</xsl:when>
			<xsl:when test="@V='3'">To-språklig</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8422">
		<xsl:choose>
			<xsl:when test="@V='1'">Biologisk mor</xsl:when>
			<xsl:when test="@V='2'">Biologisk far</xsl:when>
			<xsl:when test="@V='3'">Adoptivmor</xsl:when>
			<xsl:when test="@V='4'">Adoptivfar</xsl:when>
			<xsl:when test="@V='5'">Stemor</xsl:when>
			<xsl:when test="@V='6'">Stefar</xsl:when>
			<xsl:when test="@V='7'">Fostermor</xsl:when>
			<xsl:when test="@V='8'">Fosterfar</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8423">
		<xsl:choose>
			<xsl:when test="@V='1'">Norsk</xsl:when>
			<xsl:when test="@V='2'">Samisk</xsl:when>
			<xsl:when test="@V='3'">Nordisk</xsl:when>
			<xsl:when test="@V='4'">Europeisk</xsl:when>
			<xsl:when test="@V='5'">Asiatisk</xsl:when>
			<xsl:when test="@V='6'">Afrikansk</xsl:when>
			<xsl:when test="@V='7'">Latin-Amerikansk</xsl:when>
			<xsl:when test="@V='8'">Nord-Amerikansk</xsl:when>
			<xsl:when test="@V='9'">Australsk</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8426">
		<xsl:choose>
			<xsl:when test="@V='1'">Ordinær pasient. Opphold finansiert gjennom ISF, HELFO, og ordinær finansiering innen psykisk helse og TSB</xsl:when>
			<xsl:when test="@V='11'">Konvensjonspasient behandlet ved ø-hjelp</xsl:when>
			<xsl:when test="@V='12'">Pasient fra land uten konvensjonsavtale (selvbetalende)</xsl:when>
			<xsl:when test="@V='20'">Sykepengeprosjekt, Raskere tilbake</xsl:when>
			<xsl:when test="@V='22'">Forskningsprogram</xsl:when>
			<xsl:when test="@V='30'">Selvbetalende norsk pasient og selvbetalende konvensjonspasient</xsl:when>
			<xsl:when test="@V='40'">Anbudspasient finansiert via ISF</xsl:when>
			<xsl:when test="@V='41'">Anbudspasient på avtalen for Helse Øst RHF</xsl:when>
			<xsl:when test="@V='42'">Anbudspasient på avtalen for Helse Sør RHF</xsl:when>
			<xsl:when test="@V='43'">Anbudspasient på avtalen for Helse Vest RHF</xsl:when>
			<xsl:when test="@V='44'">Anbudspasient på avtalen for Helse Midt-Norge RHF</xsl:when>
			<xsl:when test="@V='45'">Anbudspasient på avtalen for Helse Nord RHF</xsl:when>
			<xsl:when test="@V='47'">Anbudspasient på avtalen for Helse Sør-Øst RHF</xsl:when>
			<xsl:when test="@V='50'">Opphold hos avtalespesialist finansiert via ISF</xsl:when>
			<xsl:when test="@V='60'">Forsikringsfinansiert opphold</xsl:when>
			<xsl:when test="@V='70'">HELFO formidlet opphold ved fristbrudd</xsl:when>
			<xsl:when test="@V='80'">Opphold på avtale med HF/RHF</xsl:when>
			<xsl:when test="@V='99'">Annet</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8455">
		<xsl:choose>
			<xsl:when test="@V='1'">Utredning</xsl:when>
			<xsl:when test="@V='2'">Behandling (eventuelt også inkludert videre utredning)</xsl:when>
			<xsl:when test="@V='3'">Kontroll</xsl:when>
			<xsl:when test="@V='4'">Generert for Ø-hjelpspasient</xsl:when>
			<xsl:when test="@V='5'">Friskt nyfødt barn</xsl:when>
			<xsl:when test="@V='6'">Graviditet</xsl:when>
			<xsl:when test="@V='7'">Omsorg, botilbud eller annet</xsl:when>
			<xsl:when test="@V='8'">Rehabilitering</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9033">
		<xsl:choose>
			<xsl:when test="@V='MO'">Mor</xsl:when>
			<xsl:when test="@V='FA'">Far</xsl:when>
			<xsl:when test="@V='SM'">Stemor</xsl:when>
			<xsl:when test="@V='SF'">Stefar</xsl:when>
			<xsl:when test="@V='FM'">Fostermor</xsl:when>
			<xsl:when test="@V='FF'">Fosterfar</xsl:when>
			<xsl:when test="@V='MM'">Medmor</xsl:when>
			<xsl:when test="@V='EF'">Ektefelle</xsl:when>
			<xsl:when test="@V='SA'">Samboer</xsl:when>
			<xsl:when test="@V='SI'">Søster</xsl:when>
			<xsl:when test="@V='BR'">Bror</xsl:when>
			<xsl:when test="@V='SS'">Stesøster</xsl:when>
			<xsl:when test="@V='SB'">Stebror</xsl:when>
			<xsl:when test="@V='DA'">Datter</xsl:when>
			<xsl:when test="@V='SO'">Sønn</xsl:when>
			<xsl:when test="@V='SD'">Stedatter</xsl:when>
			<xsl:when test="@V='SN'">Stesønn</xsl:when>
			<xsl:when test="@V='GM'">Bestemor</xsl:when>
			<xsl:when test="@V='GF'">Bestefar</xsl:when>
			<xsl:when test="@V='BB'">Barnebarn</xsl:when>
			<xsl:when test="@V='TO'">Foreldres søsken</xsl:when>
			<xsl:when test="@V='AS'">Annen slektning</xsl:when>
			<xsl:when test="@V='AN'">Annen foresatt</xsl:when>
			<xsl:when test="@V='AP'">Annen personlig relasjon</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9050">
		<xsl:choose>
			<xsl:when test="@V='1'">Forelder/foresatt</xsl:when>
			<xsl:when test="@V='2'">Verge</xsl:when>
			<xsl:when test="@V='3'">Hjelpeverge</xsl:when>
			<xsl:when test="@V='4'">Tilsynsfører</xsl:when>
			<xsl:when test="@V='5'">Støttekontakt</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9513">
		<xsl:choose>
			<xsl:when test="@V='D'">Delt</xsl:when>
			<xsl:when test="@V='M'">Mor</xsl:when>
			<xsl:when test="@V='F'">Far</xsl:when>
			<xsl:when test="@V='A'">Andre</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- Hack for å få til linjeskift - for bruk ved datatypen ST eller string -->
	<!--	<xsl:call-template name="line-breaks"><xsl:with-param name="text" select="dia:TekstNotatInnhold"></xsl:with-param>  </xsl:call-template> -->
	<xsl:template name="line-breaks">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text,'&#10;')">
				<div>
					<xsl:value-of select="substring-before($text,'&#10;')"/>
				</div>
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="substring-after($text,'&#10;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
