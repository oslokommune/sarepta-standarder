<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dis="http://www.kith.no/xmlstds/henvisning/2005-07-08" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="dis xhtml">
	<xsl:import href="../../Felleskomponenter/funksjoner.xsl"/>
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	<!--
Inngår i Hdirs visningsfiler versjon 1.0

FORMÅL
XSLT for generering av html fra Henvisning v.1.0

ENDRINGER:
01.04.2012: Ny grafisk layout
18.05.2011:
	-	Layoutmessige endringer
	-	Dynamisk tabellbredde hvor celler får full tabellbredde og hvor tomme felt unngås (i høyest mulig grad)
28.04.2011: 
	-	Rettet/la til visning av kjønn (Sex),
	-	Flyttet Status (ServType) og Type (MsgDescr) opp til hoved-overskriften
01.12.2010: Import av felles CSS-fil
07.01.2008: Første versjon

Laget i XMLSpy v2012 rel2 (http://www.altova.com) av Jan Sigurd Dragsjø (helsedirektoratet.no)
-->
	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="8"/>
	<!-- Variabler for beregning av antall kolonner i legemiddel-tabellen -->
	<xsl:variable name="med-stat-col" select="(($std-col)-2)*number(not(//dis:Medication/dis:UnitDose | //dis:Medication/dis:QuantitySupplied | //dis:Medication/dis:DosageText | //dis:Medication/dis:IntendedDuration | //dis:Medication/dis:Comment | //dis:InfItem[dis:Medication]/dis:StartDateTime | //dis:InfItem[dis:Medication]/dis:EndDateTime | //dis:InfItem[dis:Medication]/dis:OrgDate))+1"/>
	<xsl:variable name="med-unit-col" select="(($std-col)-3)*number(not(//dis:Medication/dis:DosageText | //dis:Medication/dis:IntendedDuration | //dis:Medication/dis:Comment | //dis:InfItem[dis:Medication]/dis:StartDateTime | //dis:InfItem[dis:Medication]/dis:EndDateTime | //dis:InfItem[dis:Medication]/dis:OrgDate))+1"/>
	<xsl:variable name="med-text-col" select="(($std-col)-3-number(boolean(//dis:Medication/dis:UnitDose | //dis:Medication/dis:QuantitySupplied)))*number(not(//dis:Medication/dis:Comment | //dis:InfItem[dis:Medication]/dis:StartDateTime | //dis:InfItem[dis:Medication]/dis:EndDateTime | //dis:InfItem[dis:Medication]/dis:OrgDate))+1"/>
	<xsl:variable name="med-com-col" select="(($std-col)-3-number(boolean(//dis:Medication/dis:UnitDose | //dis:Medication/dis:QuantitySupplied | //dis:Medication/dis:DosageText | //dis:Medication/dis:IntendedDuration)))*number(not(//dis:InfItem[dis:Medication]/dis:StartDateTime | //dis:InfItem[dis:Medication]/dis:EndDateTime | //dis:InfItem[dis:Medication]/dis:OrgDate))+1"/>
	<xsl:variable name="med-sdate-col" select="(($std-col)-3-number(boolean(//dis:Medication/dis:UnitDose | //dis:Medication/dis:QuantitySupplied))-number(boolean(//dis:Medication/dis:DosageText | //dis:Medication/dis:IntendedDuration))-number(boolean(//dis:Medication/dis:Comment)))*number(not(//dis:InfItem[dis:Medication]/dis:EndDateTime | //dis:InfItem[dis:Medication]/dis:OrgDate))+1"/>
	<xsl:variable name="med-edate-col" select="(($std-col)-3-number(boolean(//dis:Medication/dis:UnitDose | //dis:Medication/dis:QuantitySupplied))-number(boolean(//dis:Medication/dis:DosageText | //dis:Medication/dis:IntendedDuration))-number(boolean(//dis:Medication/dis:Comment))-number(boolean(//dis:InfItem[dis:Medication]/dis:StartDateTime)))*number(not(//dis:InfItem[dis:Medication]/dis:OrgDate))+1"/>
	<xsl:variable name="med-odate-col" select="(($std-col)-2-number(boolean(//dis:Medication/dis:UnitDose | //dis:Medication/dis:QuantitySupplied))-number(boolean(//dis:Medication/dis:DosageText | //dis:Medication/dis:IntendedDuration))-number(boolean(//dis:Medication/dis:Comment))-number(boolean(//dis:InfItem[dis:Medication]/dis:StartDateTime))-number(boolean(//dis:InfItem[dis:Medication]/dis:EndDateTime)))"/>
	<!-- Variabler for beregning av antall kolonner i resultat-tabellen -->
	<xsl:variable name="res-res-col" select="(($std-col)-2)*number(not(//dis:ResultItem/dis:DevResultInd | //dis:ResultItem/dis:InvDate | //dis:InfItem[dis:ResultItem]/dis:StartDateTime | //dis:InfItem[dis:ResultItem]/dis:EndDateTime | //dis:InfItem[dis:ResultItem]/dis:OrgDate))+1"/>
	<xsl:variable name="res-dev-col" select="(($std-col)-3)*number(not(//dis:ResultItem/dis:InvDate | //dis:InfItem[dis:ResultItem]/dis:StartDateTime | //dis:InfItem[dis:ResultItem]/dis:EndDateTime | //dis:InfItem[dis:ResultItem]/dis:OrgDate))+1"/>
	<xsl:variable name="res-idate-col" select="(($std-col)-3-number(boolean(//dis:ResultItem/dis:DevResultInd)))*number(not(//dis:InfItem[dis:ResultItem]/dis:StartDateTime | //dis:InfItem[dis:ResultItem]/dis:EndDateTime | //dis:InfItem[dis:ResultItem]/dis:OrgDate))+1"/>
	<xsl:variable name="res-sdate-col" select="(($std-col)-3-number(boolean(//dis:ResultItem/dis:DevResultInd))-number(boolean(//dis:ResultItem/dis:InvDate)))*number(not(//dis:InfItem[dis:ResultItem]/dis:EndDateTime | //dis:InfItem[dis:ResultItem]/dis:OrgDate))+1"/>
	<xsl:variable name="res-edate-col" select="(($std-col)-3-number(boolean(//dis:ResultItem/dis:DevResultInd))-number(boolean(//dis:ResultItem/dis:InvDate))-number(boolean(//dis:InfItem[dis:ResultItem]/dis:StartDateTime)))*number(not(//dis:InfItem[dis:ResultItem]/dis:OrgDate))+1"/>
	<xsl:variable name="res-odate-col" select="(($std-col)-2-number(boolean(//dis:ResultItem/dis:DevResultInd))-number(boolean(//dis:ResultItem/dis:InvDate))-number(boolean(//dis:InfItem[dis:ResultItem]/dis:StartDateTime))-number(boolean(//dis:InfItem[dis:ResultItem]/dis:EndDateTime)))"/>
	
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
						<xsl:apply-templates select="dis:Requester"/>
					</div>
				</div>
				<xsl:choose>
					<xsl:when test="dis:Patient">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Pasient &#160;</div>
							<div class="No-line-content">
								<xsl:apply-templates select="dis:Patient"/>
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
						<xsl:apply-templates select="dis:ServProvider"/>
					</div>
				</div>
				<xsl:choose>
					<xsl:when test="dis:CopyDest">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Kopimottaker(e) &#160;</div>
							<div class="No-line-content">
								<xsl:apply-templates select="dis:CopyDest"/>
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
	<!-- Meldingshodet - Dokumentopplysninger -->
	<xsl:template name="Footer">
		<div class="No-line-doc">
			<h2>Dokumentinformasjon</h2>
			<div class="No-line-Box">
				<div class="No-line-Block">
					<div class="No-line-MainCaption">Melding sendt</div>
					<div class="No-line-MainContent">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="../dis:GenDate/@V"/>
						</xsl:call-template>
					</div>
				</div>
				<div class="No-line-Block">
					<div class="No-line-MainCaption">Meldingsid</div>
					<div class="No-line-MainContent">
						<xsl:value-of select="../dis:MsgId"/>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="dis:Requester">
		<xsl:apply-templates select="dis:HCP"/>
	</xsl:template>
	<xsl:template match="dis:ServProvider">
		<xsl:apply-templates select="dis:HCP"/>
	</xsl:template>
	<xsl:template match="dis:Patient">
		<div>
			<xsl:value-of select="dis:Name"/>&#160;
			<b><xsl:value-of select="dis:TypeOffId/@V"/>:&#160;</b>
			<xsl:value-of select="substring(dis:OffId, 1,6)"/>&#160;<xsl:value-of select="substring(dis:OffId, 7)"/>&#160;
		</div>
		<xsl:if test="dis:DateOfDeath">
			<div>
				<b>Dødsdato:&#160;</b>
				<xsl:value-of select="dis:DateOfDeath/@V"/>&#160;</div>
		</xsl:if>
		<xsl:apply-templates select="dis:Address"/>
	</xsl:template>
	<xsl:template match="dis:HCPerson">
		<div><xsl:value-of select="dis:Name"/>&#160;</div>
		<xsl:apply-templates select="dis:Address"/>
	</xsl:template>
	<xsl:template match="dis:HCP">
		<xsl:apply-templates select="dis:Inst"/>
		<xsl:apply-templates select="dis:HCProf"/>
		<xsl:apply-templates select="dis:Address"/>
	</xsl:template>
	<xsl:template match="dis:Inst">
		<xsl:apply-templates select="dis:HCPerson"/>
		<div>
			<div class="NoPrint">
				<b>Institusjon:&#160;</b>
			</div>
			<xsl:value-of select="dis:Name"/>
		</div>
		<xsl:for-each select="dis:Dept">
			<div>
				<div class="NoPrint">-&#160;</div>
				<xsl:value-of select="dis:Name"/>&#160;</div>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="dis:HCProf">
		<div>
			<xsl:if test="dis:Type">
				<xsl:value-of select="dis:Type/@DN"/>&#160;</xsl:if>
			<xsl:value-of select="dis:Name"/>
		</div>
	</xsl:template>
	<xsl:template match="dis:CopyDest">
		<xsl:apply-templates select="dis:HCP"/>
	</xsl:template>
	<xsl:template match="dis:Address">
		<xsl:if test="dis:Type and (dis:StreetAdr or dis:PostalCode or dis:City or dis:CityDistr)">
			<div class="NoPrint">&#160;<b>
					<xsl:choose>
						<xsl:when test="dis:Type/@DN">
							<xsl:value-of select="dis:Type/@DN"/>:&#160;</xsl:when>
						<xsl:otherwise>Adresse:&#160;</xsl:otherwise>
					</xsl:choose>
				</b>
			</div>
		</xsl:if>
		<xsl:if test="dis:StreetAdr">
			<div>
				<xsl:value-of select="dis:StreetAdr"/>
			</div>
		</xsl:if>
		<xsl:if test="dis:PostalCode or dis:City">
			<xsl:if test="dis:StreetAdr">
				<div class="NoPrint">,</div>
			</xsl:if>
			<div>
				<xsl:value-of select="dis:PostalCode"/>&#160;<xsl:value-of select="dis:City"/>
			</div>
		</xsl:if>
		<xsl:if test="dis:CityDistr">
			<div class="NoPrint">,</div>
			<div>
				<xsl:value-of select="dis:CityDistr/@DN"/>
			</div>
		</xsl:if>
		<xsl:if test="dis:County">
			<div class="NoPrint">,</div>
			<div>
				<xsl:value-of select="dis:County/@DN"/>
			</div>
		</xsl:if>
		<xsl:if test="dis:Country">
			<div class="NoPrint">,</div>
			<div>
				<xsl:value-of select="dis:Country/@DN"/>
			</div>
		</xsl:if>
		<xsl:for-each select="dis:TeleAddress">
			<div class="NoPrint">&#160;</div>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="dis:TeleAddress">
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
	<!-- Hoveddokumentet -->
	<xsl:template name="FellesMeny">
		<xsl:param name="position"/>
		<div class="NoPrint">
			<div id="FellesMeny" class="FellesMeny">
				<ul>
					<xsl:if test="//dis:Diagnosis or //dis:ReasonAsText[dis:Heading/@V='DIAG'] or //dis:InfItem[dis:Type/@V='H' or dis:Type/@V='B']">
						<li>
							<xsl:variable name="temp10" select="concat('Diagnosis',$position)"/>
							<a href="#{$temp10}">Diagnoser</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:InfItem[dis:Type/@V='CAVE' or dis:Type/@V='NB']">
						<li>
							<xsl:variable name="temp20" select="concat('CAVE',$position)"/>
							<a href="#{$temp20}">
								<xsl:if test="//dis:InfItem[dis:Type/@V='CAVE']">CAVE</xsl:if>
								<xsl:if test="//dis:InfItem[dis:Type/@V='CAVE'] and //dis:InfItem[dis:Type/@V='NB']">&#160;og&#160;</xsl:if>
								<xsl:if test="//dis:InfItem[dis:Type/@V='NB']">NB-opplysninger</xsl:if>
							</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:ReasonAsText[dis:Heading/@V='PROB'] or //dis:InfItem[dis:Type/@V='SYMP' or dis:Type/@V='PROG' or dis:Type/@V='SM']">
						<li>
							<xsl:variable name="temp30" select="concat('PROB',$position)"/>
							<a href="#{$temp30}">Problemstilling</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:ReasonAsText[dis:Heading/@V='UTRED']">
						<li>
							<xsl:variable name="temp40" select="concat('UTRED',$position)"/>
							<a href="#{$temp40}">Forventet utredning/behandling</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:InfItem[dis:Type/@V='OPPL']">
						<li>
							<xsl:variable name="temp50" select="concat('OPPL',$position)"/>
							<a href="#{$temp50}">Kliniske opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:InfItem[dis:Type/@V='GOPL' or dis:Type/@V='GBEH']">
						<li>
							<xsl:variable name="temp60" select="concat('GOPL',$position)"/>
							<a href="#{$temp60}">Gynekologiske opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:ReasonAsText[dis:Heading/@V='SVU']">
						<li>
							<xsl:variable name="temp70" select="concat('SVU',$position)"/>
							<a href="#{$temp70}">Spesialistvurdering</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:ReasonAsText[dis:Heading/@V='VU']">
						<li>
							<xsl:variable name="temp80" select="concat('VU',$position)"/>
							<a href="#{$temp80}">Vurdering</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:ReasonAsText[dis:Heading/@V='BG' or dis:Heading/@V='BUP-BM' or dis:Heading/@V='BUP-HG' or dis:Heading/@V='KF' or dis:Heading/@V='MAAL' or dis:Heading/@V='MU' or dis:Heading/@V='RU' or dis:Heading/@V='UP' or not(dis:Heading)]">
						<li>
							<xsl:variable name="temp90" select="concat('Annen',$position)"/>
							<a href="#{$temp90}">Annen begrunnelse</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:InfItem[dis:Type/@V='ANAM' or dis:Type/@V='TB' or dis:Type/@V='US']">
						<li>
							<xsl:variable name="temp100" select="concat('ANAM',$position)"/>
							<a href="#{$temp100}">Sykehistorie</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:InfItem[dis:Type/@V='FUNN'] or //dis:ReasonAsText[dis:Heading/@V='FU']">
						<li>
							<xsl:variable name="temp110" select="concat('ResultItem',$position)"/>
							<a href="#{$temp110}">Funn/undersøkelsesresultat</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:InfItem[dis:Type/@V='OPIN' or dis:Type/@V='MPRS' or dis:Type/@V='PRS']">
						<li>
							<xsl:variable name="temp120" select="concat('OPIN',$position)"/>
							<a href="#{$temp120}">Prosedyrer</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:ReasonAsText[dis:Heading/@V='FO']">
						<li>
							<xsl:variable name="temp130" select="concat('FO',$position)"/>
							<a href="#{$temp130}">Forløp og behandling</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:ReasonAsText[dis:Heading/@V='HJ']">
						<li>
							<xsl:variable name="temp140" select="concat('HJ',$position)"/>
							<a href="#{$temp140}">Funksjonsnivå/hjelpetiltak</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:InfItem[dis:Type/@V='MEDB']">
						<li>
							<xsl:variable name="temp150" select="concat('Medication',$position)"/>
							<a href="#{$temp150}">Medisinering</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:ReasonAsText[dis:Heading/@V='FA']">
						<li>
							<xsl:variable name="temp160" select="concat('FA',$position)"/>
							<a href="#{$temp160}">Familie/sosialt</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:ReasonAsText[dis:Heading/@V='IP']">
						<li>
							<xsl:variable name="temp170" select="concat('IP',$position)"/>
							<a href="#{$temp170}">Informasjon til pasient/pårørende</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:InfItem[dis:Type/@V='SYKM']">
						<li>
							<xsl:variable name="temp180" select="concat('SYKM',$position)"/>
							<a href="#{$temp180}">Sykemelding</a>
						</li>
					</xsl:if>
					<xsl:if test="//dis:ServReq/dis:Comment">
						<li>
							<xsl:variable name="temp190" select="concat('Comment',$position)"/>
							<a href="#{$temp190}">Kommentarer</a>
						</li>
					</xsl:if>
					<xsl:for-each select="//dis:Patient">
						<xsl:if test="dis:BasisForHealthServices or dis:Sex or dis:DateOfBirth or dis:PatientPrecaution or dis:NeedTranslator or dis:CareSituation or dis:PatRelperson or dis:PatRelInst or dis:Consent or dis:AdditionalId">
							<li>
								<xsl:variable name="temp200" select="concat('Patient',$position)"/>
								<a href="#{$temp200}">Pasient</a>
							</li>
						</xsl:if>
						<xsl:if test="dis:PatRelHCP">
							<li>
								<xsl:variable name="temp210" select="concat('PatRelHCP',$position)"/>
								<a href="#{$temp210}">Helsetjenesteenheter</a>
							</li>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="dis:RefDoc">
						<li>
							<xsl:variable name="temp220" select="concat('RefDoc',$position)"/>
							<a href="#{$temp220}">Vedlegg</a>
						</li>
					</xsl:if>
				</ul>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="dis:Message">
		<xsl:for-each select="dis:ServReq">
			<xsl:variable name="position" select="position()"/>
			<xsl:call-template name="Header"/>
			<div class="No-line-doc">
				<xsl:call-template name="FellesMeny"><xsl:with-param name="position" select="position()"/></xsl:call-template>
				<!-- Overskrift og tabell for henvisningen -->
				<h1>Henvisning&#160;-&#160;
					<xsl:choose>
						<xsl:when test="dis:MsgDescr/@DN"><xsl:value-of select="dis:MsgDescr/@DN"/></xsl:when>
						<xsl:otherwise><xsl:for-each select="dis:MsgDescr"><xsl:call-template name="k-8455"/></xsl:for-each></xsl:otherwise>
					</xsl:choose>
					<xsl:if test="dis:ServType/@V != 'N'">
						&#160;<b>
						<xsl:choose>
							<xsl:when test="dis:ServType/@DN"><xsl:value-of select="dis:ServType/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="dis:ServType"><xsl:call-template name="k-7309"/></xsl:for-each></xsl:otherwise>
						</xsl:choose></b>
					</xsl:if>
					<xsl:if test="dis:ReqServ/dis:ServType/@V != 'N'">
						&#160;Status&#160;rekvirert&#160;tjeneste:&#160;
						<xsl:choose>
							<xsl:when test="dis:ReqServ/dis:ServType/@DN"><xsl:value-of select="dis:ReqServ/dis:ServType/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="dis:ReqServ/dis:ServType"><xsl:call-template name="k-7309"/></xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</h1>
				<table>
					<tbody>
						<xsl:apply-templates select="."/>
					</tbody>
				</table>
				<!-- Overskrift og tabell for Diagnoser -->
				<xsl:if test="dis:Diagnosis or dis:ReasonAsText[dis:Heading/@V='DIAG'] or //dis:InfItem[dis:Type/@V='H' or dis:Type/@V='B']">
					<xsl:variable name="id10"><xsl:value-of select="concat('Diagnosis',$position)"/></xsl:variable>
					<h2 id="{$id10}">Diagnoser</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="dis:Diagnosis"/>
							<xsl:apply-templates select="dis:ReasonAsText[dis:Heading/@V='DIAG']"/>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='H']">
								<xsl:apply-templates/>
							</xsl:for-each>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='B']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for CAVE og NB-opplysninger -->
				<xsl:if test="//dis:InfItem[dis:Type/@V='CAVE' or dis:Type/@V='NB']">
					<xsl:variable name="id20"><xsl:value-of select="concat('CAVE',$position)"/></xsl:variable>
					<h2 id="{$id20}">
						<xsl:if test="//dis:InfItem[dis:Type/@V='CAVE']">CAVE</xsl:if>
						<xsl:if test="//dis:InfItem[dis:Type/@V='CAVE'] and //dis:InfItem[dis:Type/@V='NB']">&#160;og&#160;</xsl:if>
						<xsl:if test="//dis:InfItem[dis:Type/@V='NB']">NB-opplysninger</xsl:if>
					</h2>
					<table>
						<tbody>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='CAVE']">
								<xsl:apply-templates/>
							</xsl:for-each>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='NB']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Problemstilling -->
				<xsl:if test="//dis:ReasonAsText[dis:Heading/@V='PROB'] or //dis:InfItem[dis:Type/@V='SYMP' or dis:Type/@V='PROG' or dis:Type/@V='SM']">
					<xsl:variable name="id30"><xsl:value-of select="concat('PROB',$position)"/></xsl:variable>
					<h2 id="{$id30}">Problemstilling</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="dis:ReasonAsText[dis:Heading/@V='PROB']"/>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='SYMP'] | //dis:InfItem[dis:Type/@V='PROG'] | //dis:InfItem[dis:Type/@V='SM']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Forventet utredning/behandling -->
				<xsl:if test="dis:ReasonAsText[dis:Heading/@V='UTRED']">
					<xsl:variable name="id40"><xsl:value-of select="concat('UTRED',$position)"/></xsl:variable>
					<h2 id="{$id40}">Forventet utredning/behandling</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="dis:ReasonAsText[dis:Heading/@V='UTRED']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Kliniske opplysninger -->
				<xsl:if test="//dis:InfItem[dis:Type/@V='OPPL']">
					<xsl:variable name="id50"><xsl:value-of select="concat('OPPL',$position)"/></xsl:variable>
					<h2 id="{$id50}">Kliniske opplysninger</h2>
					<table>
						<tbody>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='OPPL']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Gynekologiske opplysninger -->
				<xsl:if test="//dis:InfItem[dis:Type/@V='GOPL' or dis:Type/@V='GBEH']">
					<xsl:variable name="id60"><xsl:value-of select="concat('GOPL',$position)"/></xsl:variable>
					<h2 id="{$id60}">Gynekologiske opplysninger</h2>
					<table>
						<tbody>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='GOPL' or dis:Type/@V='GBEH']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Spesialistvurdering -->
				<xsl:if test="dis:ReasonAsText[dis:Heading/@V='SVU']">
					<xsl:variable name="id70"><xsl:value-of select="concat('SVU',$position)"/></xsl:variable>
					<h2 id="{$id70}">Spesialistvurdering</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="dis:ReasonAsText[dis:Heading/@V='SVU']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Vurdering -->
				<xsl:if test="dis:ReasonAsText[dis:Heading/@V='VU']">
					<xsl:variable name="id80"><xsl:value-of select="concat('VU',$position)"/></xsl:variable>
					<h2 id="{$id80}">Vurdering</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="dis:ReasonAsText[dis:Heading/@V='VU']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Annen begrunnelse for henvisningen -->
				<xsl:if test="dis:ReasonAsText[dis:Heading/@V='BG' or dis:Heading/@V='BUP-BM' or dis:Heading/@V='BUP-HG' or dis:Heading/@V='KF' or dis:Heading/@V='MAAL' or dis:Heading/@V='MU' or dis:Heading/@V='RU' or dis:Heading/@V='UP' or not(dis:Heading)]">
					<xsl:variable name="id90"><xsl:value-of select="concat('Annen',$position)"/></xsl:variable>
					<h2 id="{$id90}">Annen begrunnelse for henvisningen</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="dis:ReasonAsText[dis:Heading/@V='BG' or dis:Heading/@V='BUP-BM' or dis:Heading/@V='BUP-HG' or dis:Heading/@V='KF' or dis:Heading/@V='MAAL' or dis:Heading/@V='MU' or dis:Heading/@V='RU' or dis:Heading/@V='UP' or not(dis:Heading)]"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Sykehistorie -->
				<xsl:if test="//dis:InfItem[dis:Type/@V='ANAM' or dis:Type/@V='TB' or dis:Type/@V='US']">
					<xsl:variable name="id100"><xsl:value-of select="concat('ANAM',$position)"/></xsl:variable>
					<h2 id="{$id100}">Sykehistorie</h2>
					<table>
						<tbody>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='ANAM' or dis:Type/@V='TB' or dis:Type/@V='US']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Funn/undersøkelsesresultat -->
				<xsl:if test="//dis:InfItem[dis:Type/@V='FUNN'] or dis:ReasonAsText[dis:Heading/@V='FU']">
					<xsl:variable name="id110"><xsl:value-of select="concat('ResultItem',$position)"/></xsl:variable>
					<h2 id="{$id110}">Funn/undersøkelsesresultat</h2>
					<table>
						<tbody>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='FUNN']/dis:Observation">
								<xsl:apply-templates select="."/>
							</xsl:for-each>
							<xsl:for-each select="//dis:ResultItem">
								<xsl:if test="position()=1">
									<tr>
										<th>Undersøkelse</th>
										<th colspan="{$res-res-col}">Funn/resultat</th>
										<xsl:if test="//dis:ResultItem/dis:DevResultInd">
											<th colspan="{$res-dev-col}">Avviksmarkør</th>
										</xsl:if>
										<xsl:if test="//dis:ResultItem/dis:InvDate">
											<th colspan="{$res-idate-col}">Tidspunkt&#160;for&#160;undersøkelsen</th>
										</xsl:if>
										<xsl:if test="//dis:InfItem[dis:ResultItem]/dis:StartDateTime">
											<th colspan="{$res-sdate-col}">Starttidspunkt</th>
										</xsl:if>
										<xsl:if test="//dis:InfItem[dis:ResultItem]/dis:EndDateTime">
											<th colspan="{$res-edate-col}">Sluttidspunkt</th>
										</xsl:if>
										<xsl:if test="//dis:InfItem[dis:ResultItem]/dis:OrgDate">
											<th colspan="{$res-odate-col}">Tidspunkt&#160;for&#160;opprinnelse</th>
										</xsl:if>
									</tr>
								</xsl:if>
								<tr>
									<xsl:apply-templates select="."/>
								</tr>
							</xsl:for-each>
							<xsl:apply-templates select="dis:ReasonAsText[dis:Heading/@V='FU']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Prosedyrer -->
				<xsl:if test="//dis:InfItem[dis:Type/@V='OPIN' or dis:Type/@V='MPRS' or dis:Type/@V='PRS']">
					<xsl:variable name="id120"><xsl:value-of select="concat('OPIN',$position)"/></xsl:variable>
					<h2 id="{$id120}">Prosedyrer</h2>
					<table>
						<tbody>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='OPIN' or dis:Type/@V='MPRS' or dis:Type/@V='PRS']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Forløp og behandling -->
				<xsl:if test="dis:ReasonAsText[dis:Heading/@V='FO']">
					<xsl:variable name="id130"><xsl:value-of select="concat('FO',$position)"/></xsl:variable>
					<h2 id="{$id130}">Forløp og behandling</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="dis:ReasonAsText[dis:Heading/@V='FO']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Funksjonsnivå/hjelpetiltak -->
				<xsl:if test="dis:ReasonAsText[dis:Heading/@V='HJ']">
					<xsl:variable name="id140"><xsl:value-of select="concat('HJ',$position)"/></xsl:variable>
					<h2 id="{$id140}">Funksjonsnivå/hjelpetiltak</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="dis:ReasonAsText[dis:Heading/@V='HJ']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Medisinering -->
				<xsl:if test="//dis:InfItem[dis:Type/@V='MEDB']">
					<xsl:variable name="id150"><xsl:value-of select="concat('Medication',$position)"/></xsl:variable>
					<h2 id="{$id150}">Medisinering</h2>
					<table>
						<tbody>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='MEDB']/dis:Observation | //dis:InfItem[dis:Type/@V='MEDB']/dis:ResultItem">
								<xsl:apply-templates select="."/>
							</xsl:for-each>
							<xsl:for-each select="//dis:Medication">
								<xsl:if test="position()=1">
									<tr>
										<th>Legemiddel</th>
										<th colspan="{$med-stat-col}">Status</th>
										<xsl:if test="//dis:Medication/dis:UnitDose or //dis:Medication/dis:QuantitySupplied">
											<th colspan="{$med-unit-col}">Mengde</th>
										</xsl:if>
										<xsl:if test="//dis:Medication/dis:DosageText or //dis:Medication/dis:IntendedDuration">
											<th colspan="{$med-text-col}">
												<xsl:if test="//dis:Medication/dis:DosageText">Dosering</xsl:if>
												<xsl:if test="//dis:Medication/dis:DosageText and //dis:Medication/dis:IntendedDuration">/</xsl:if>
												<xsl:if test="//dis:Medication/dis:IntendedDuration">Varighet</xsl:if>
											</th>
										</xsl:if>
										<xsl:if test="//dis:Medication/dis:Comment">
											<th colspan="{$med-com-col}">Kommentar</th>
										</xsl:if>
										<xsl:if test="//dis:InfItem[dis:Medication]/dis:StartDateTime">
											<th colspan="{$med-sdate-col}">Starttidspunkt</th>
										</xsl:if>
										<xsl:if test="//dis:InfItem[dis:Medication]/dis:EndDateTime">
											<th colspan="{$med-edate-col}">Sluttidspunkt</th>
										</xsl:if>
										<xsl:if test="//dis:InfItem[dis:Medication]/dis:OrgDate">
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
				<xsl:if test="dis:ReasonAsText[dis:Heading/@V='FA']">
					<xsl:variable name="id160"><xsl:value-of select="concat('FA',$position)"/></xsl:variable>
					<h2 id="{$id160}">Familie/sosialt</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="dis:ReasonAsText[dis:Heading/@V='FA']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Informasjon til pasient/pårørende -->
				<xsl:if test="dis:ReasonAsText[dis:Heading/@V='IP']">
					<xsl:variable name="id170"><xsl:value-of select="concat('IP',$position)"/></xsl:variable>
					<h2 id="{$id170}">Informasjon til pasient/pårørende</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="dis:ReasonAsText[dis:Heading/@V='IP']"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Sykemelding -->
				<xsl:if test="//dis:InfItem[dis:Type/@V='SYKM']">
					<xsl:variable name="id180"><xsl:value-of select="concat('SYKM',$position)"/></xsl:variable>
					<h2 id="{$id180}">Sykemelding</h2>
					<table>
						<tbody>
							<xsl:for-each select="//dis:InfItem[dis:Type/@V='SYKM']">
								<xsl:apply-templates/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Kommentarer -->
				<xsl:if test="dis:Comment">
					<xsl:variable name="id190"><xsl:value-of select="concat('Comment',$position)"/></xsl:variable>
					<h2 id="{$id190}">Kommentarer</h2>
					<table>
						<tbody>
							<xsl:for-each select="dis:Comment">
								<tr>
									<th>
										<xsl:choose>
											<xsl:when test="dis:Heading"><xsl:for-each select="dis:Heading"><xsl:call-template name="k-8234"/></xsl:for-each></xsl:when>
											<xsl:otherwise>Kommentar</xsl:otherwise>
										</xsl:choose>
									</th>
									<td colspan="{($std-col)-1}">
										<xsl:if test="dis:TextResultValue"><div><xsl:value-of select="dis:TextResultValue"/></div></xsl:if>
										<xsl:for-each select="dis:CodedComment">
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
				<xsl:for-each select="dis:Patient">
					<xsl:if test="dis:BasisForHealthServices or dis:Sex or dis:DateOfBirth or dis:PatientPrecaution or dis:NeedTranslator or dis:CareSituation or dis:PatRelperson or dis:PatRelInst or dis:Consent or dis:AdditionalId">
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
				<xsl:if test="dis:Patient/dis:PatRelHCP">
					<xsl:variable name="id210"><xsl:value-of select="concat('PatRelHCP',$position)"/></xsl:variable>
					<h2 id="{$id210}">Helsetjenesteenheter</h2>
					<table>
						<tbody>
							<tr>
								<xsl:if test="//dis:PatRelHCP/dis:Relation">
									<th>Pasientrelasjon</th>
								</xsl:if>
								<xsl:if test="//dis:PatRelHCP//dis:HCProf | //dis:PatRelHCP//dis:HCPerson | //dis:PatRelHCP//dis:Dept">
									<th colspan="{(($std-col)-2)*number(not(//dis:PatRelHCP//dis:HCProf/dis:Id | //dis:PatRelHCP//dis:HCProf/dis:AdditionalId | //dis:PatRelHCP//dis:HCPerson/dis:Id | //dis:PatRelHCP//dis:HCPerson/dis:AdditionalId | //dis:PatRelHCP//dis:Dept/dis:Id | //dis:PatRelHCP//dis:Dept/dis:AdditionalId | //dis:PatRelHCP//dis:Inst/dis:Name | //dis:PatRelHCP//dis:MedSpeciality | //dis:PatRelHCP//dis:Inst/dis:Id | //dis:PatRelHCP/dis:StartDateTime | //dis:PatRelHCP/dis:EndDateTime | //dis:PatRelHCP//dis:Address))+1}">
										<xsl:choose>
											<xsl:when test="//dis:PatRelHCP//dis:Dept and (//dis:PatRelHCP//dis:HCProf or //dis:PatRelHCP//dis:HCPerson)">Person/avd.</xsl:when>
											<xsl:when test="not(//dis:PatRelHCP//dis:Dept)">Person</xsl:when>
											<xsl:otherwise>Avdeling</xsl:otherwise>
										</xsl:choose>
									</th>
								</xsl:if>
								<xsl:if test="//dis:PatRelHCP//dis:HCProf/dis:Id | //dis:PatRelHCP//dis:HCProf/dis:AdditionalId | //dis:PatRelHCP//dis:HCPerson/dis:Id | //dis:PatRelHCP//dis:HCPerson/dis:AdditionalId | //dis:PatRelHCP//dis:Dept/dis:Id | //dis:PatRelHCP//dis:Dept/dis:AdditionalId">
									<th colspan="{(($std-col)-3)*number(not(//dis:PatRelHCP//dis:Inst/dis:Name | //dis:PatRelHCP//dis:MedSpeciality | //dis:PatRelHCP//dis:Inst/dis:Id | //dis:PatRelHCP/dis:StartDateTime | //dis:PatRelHCP/dis:EndDateTime | //dis:PatRelHCP//dis:Address))+1}">Id</th>
								</xsl:if>
								<xsl:if test="//dis:PatRelHCP//dis:Inst/dis:Name">
									<th colspan="{(($std-col)-2-number(boolean(//dis:PatRelHCP//dis:HCProf | //dis:PatRelHCP//dis:HCPerson | //dis:PatRelHCP//dis:Dept))-1)*number(not(//dis:PatRelHCP//dis:MedSpeciality | //dis:PatRelHCP//dis:Inst/dis:Id | //dis:PatRelHCP/dis:StartDateTime | //dis:PatRelHCP/dis:EndDateTime | //dis:PatRelHCP//dis:Address))+1}">Institusjon</th>
								</xsl:if>
								<xsl:if test="//dis:PatRelHCP//dis:MedSpeciality">
									<th colspan="{(($std-col)-2-number(boolean(//dis:PatRelHCP//dis:HCProf | //dis:PatRelHCP//dis:HCPerson | //dis:PatRelHCP//dis:Dept))-1-number(boolean(//dis:PatRelHCP//dis:Inst/dis:Name)))*number(not(//dis:PatRelHCP//dis:Inst/dis:Id | //dis:PatRelHCP/dis:StartDateTime | //dis:PatRelHCP/dis:EndDateTime | //dis:PatRelHCP//dis:Address))+1}">Medisinsk&#160;spesialitet</th>
								</xsl:if>
								<xsl:if test="//dis:PatRelHCP//dis:Inst/dis:Id">
									<th colspan="{(($std-col)-2-number(boolean(//dis:PatRelHCP//dis:HCProf | //dis:PatRelHCP//dis:HCPerson | //dis:PatRelHCP//dis:Dept))-1-number(boolean(//dis:PatRelHCP//dis:Inst/dis:Name))-number(boolean(//dis:PatRelHCP//dis:MedSpeciality)))*number(not(//dis:PatRelHCP/dis:StartDateTime | //dis:PatRelHCP/dis:EndDateTime | //dis:PatRelHCP//dis:Address))+1}">Institusjon-id</th>
								</xsl:if>
								<xsl:if test="//dis:PatRelHCP/dis:StartDateTime | //dis:PatRelHCP/dis:EndDateTime">
									<th colspan="{(($std-col)-2-number(boolean(//dis:PatRelHCP//dis:HCProf | //dis:PatRelHCP//dis:HCPerson | //dis:PatRelHCP//dis:Dept))-1-number(boolean(//dis:PatRelHCP//dis:Inst/dis:Name))-number(boolean(//dis:PatRelHCP//dis:MedSpeciality))-number(boolean(//dis:PatRelHCP//dis:Inst/dis:Id)))*number(not(//dis:PatRelHCP//dis:Address))+1}">Tidsrom</th>
								</xsl:if>
								<xsl:if test="//dis:PatRelHCP//dis:Address">
									<th colspan="{(($std-col)-1-number(boolean(//dis:PatRelHCP//dis:HCProf | //dis:PatRelHCP//dis:HCPerson | //dis:PatRelHCP//dis:Dept))-1-number(boolean(//dis:PatRelHCP//dis:Inst/dis:Name))-number(boolean(//dis:PatRelHCP//dis:MedSpeciality))-number(boolean(//dis:PatRelHCP//dis:Inst/dis:Id))-number(boolean(//dis:PatRelHCP/dis:StartDateTime | //dis:PatRelHCP/dis:EndDateTime)))}">Adresse</th>
								</xsl:if>
							</tr>
							<xsl:apply-templates select="dis:Patient/dis:PatRelHCP"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for vedlegg -->
				<xsl:if test="dis:RefDoc">
					<xsl:variable name="id220"><xsl:value-of select="concat('RefDoc',$position)"/></xsl:variable>
					<h2 id="{$id220}">Vedlegg</h2>
					<table>
						<tbody>
							<xsl:apply-templates select="dis:RefDoc"/>
						</tbody>
					</table>
				</xsl:if>
			</div>
			<xsl:call-template name="Footer"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="dis:ServReq">
		<tr>
			<xsl:if test="dis:IssueDate">
				<th>Utstedt</th>
				<td colspan="{(($std-col)-2)*number(not(dis:PaymentCat | dis:Ack))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="dis:IssueDate/@V"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="dis:PaymentCat">
				<th>Betalingskategori</th>
				<td colspan="{(($std-col)-2-count(dis:IssueDate)*2)*number(not(dis:Ack))+1}">
					<xsl:choose>
						<xsl:when test="dis:PaymentCat/@DN"><xsl:value-of select="dis:PaymentCat/@DN"/></xsl:when>
						<xsl:otherwise><xsl:for-each select="dis:PaymentCat"><xsl:call-template name="k-8246"/>&#160;</xsl:for-each></xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="dis:Ack">
				<th>Meldingsbekreftelse</th>
				<td colspan="{($std-col)-2-count(dis:IssueDate | dis:PaymentCat)*2}">
					<xsl:choose>
						<xsl:when test="dis:Ack/@DN"><xsl:value-of select="dis:Ack/@DN"/></xsl:when>
						<xsl:otherwise><xsl:for-each select="dis:Ack"><xsl:call-template name="k-7304"/>&#160;</xsl:for-each></xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
		</tr>
		<xsl:if test="dis:ReqComment">
			<tr>
				<td colspan="{$std-col}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="dis:ReqComment"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:for-each select="dis:ReqServ">
			<xsl:if test="dis:Priority or dis:Purpose or dis:ReqDate">
				<tr>
					<xsl:if test="dis:Priority">
						<th>Hastegrad</th>
						<td colspan="{(($std-col)-2)*number(not(dis:Purpose | dis:ReqDate))+1}">
							<xsl:choose>
								<xsl:when test="dis:Priority/@DN"><xsl:value-of select="dis:Priority/@DN"/></xsl:when>
								<xsl:otherwise><xsl:for-each select="dis:Priority"><xsl:call-template name="k-8304"/>&#160;</xsl:for-each></xsl:otherwise>
							</xsl:choose>
						</td>
					</xsl:if>
					<xsl:if test="dis:Purpose">
						<th>Formål</th>
						<td colspan="{(($std-col)-2-count(dis:Priority)*2)*number(not(dis:ReqDate))+1}">
							<xsl:choose>
								<xsl:when test="dis:Purpose/@DN"><xsl:value-of select="dis:Purpose/@DN"/></xsl:when>
								<xsl:otherwise><xsl:for-each select="dis:Purpose"><xsl:call-template name="k-8248"/>&#160;</xsl:for-each></xsl:otherwise>
							</xsl:choose>
						</td>
					</xsl:if>
					<xsl:if test="dis:ReqDate">
						<th>Utstedt</th>
						<td colspan="{($std-col)-1-count(dis:Priority | dis:Purpose)*2}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="dis:ReqDate/@V"/>
							</xsl:call-template>
						</td>
					</xsl:if>
				</tr>
			</xsl:if>
			<xsl:if test="dis:Comment">
				<tr>
					<td colspan="{$std-col}">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="dis:Comment"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:for-each select="dis:Service">
				<tr>
					<th>Spesifisert tjeneste</th>
				</tr>
				<xsl:if test="dis:ServId or dis:MedSpeciality or dis:AdmCat">
					<tr>
						<xsl:if test="dis:ServId">
							<th>Tjeneste</th>
							<td colspan="{(($std-col)-2)*number(not(dis:MedSpeciality | dis:AdmCat))+1}">
								<xsl:choose>
									<xsl:when test="dis:ServId/@DN">
										<xsl:value-of select="dis:ServId/@DN"/>
									</xsl:when>
									<xsl:otherwise>
										<b>Kodet:</b>&#160;<xsl:value-of select="dis:ServId/@V"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="dis:ServId/@OT">
									<div><b>Fritekst:</b>&#160;<xsl:value-of select="dis:ServId/@OT"/></div>
								</xsl:if>
							</td>
						</xsl:if>
						<xsl:if test="dis:MedSpeciality">
							<th>Medisinsk spesialitet</th>
							<td colspan="{(($std-col)-2-count(dis:ServId)*2)*number(not(dis:AdmCat))+1}">
								<xsl:choose>
									<xsl:when test="dis:MedSpeciality/@DN">
										<xsl:value-of select="dis:MedSpeciality/@DN"/>
									</xsl:when>
									<xsl:otherwise>
										<b>Kodet:</b>&#160;<xsl:value-of select="dis:MedSpeciality/@V"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="dis:MedSpeciality/@OT">
									<div><b>Fritekst:</b>&#160;<xsl:value-of select="dis:MedSpeciality/@OT"/></div>
								</xsl:if>
							</td>
						</xsl:if>
						<xsl:if test="dis:AdmCat">
							<th>Type tjeneste</th>
							<td colspan="{($std-col)-2-count(dis:ServId | dis:MedSpeciality)*2}">
								<xsl:choose>
									<xsl:when test="dis:AdmCat/@DN"><xsl:value-of select="dis:AdmCat/@DN"/></xsl:when>
									<xsl:otherwise><xsl:for-each select="dis:AdmCat"><xsl:call-template name="k-8240"/>&#160;</xsl:for-each></xsl:otherwise>
								</xsl:choose>
							</td>
						</xsl:if>
					</tr>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="dis:Diagnosis">
		<tr>
			<th>
				<xsl:choose>
					<xsl:when test="position()=1">
						<b>
							<xsl:value-of select="dis:Concept/@V"/>&#160;
							<xsl:if test="contains(dis:Concept/@S, '7170')">(ICPC)</xsl:if>
							<xsl:if test="contains(dis:Concept/@S, '7110')">(ICD-10)</xsl:if>
						</b>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="dis:Concept/@V"/>&#160;
						<xsl:if test="contains(dis:Concept/@S, '7170')">(ICPC)</xsl:if>
						<xsl:if test="contains(dis:Concept/@S, '7110')">(ICD-10)</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</th>
			<td>
				<xsl:choose>
					<xsl:when test="position()=1">
						<b>
							<xsl:if test="dis:Concept/@DN"><xsl:value-of select="dis:Concept/@DN"/>&#160;</xsl:if>
							<xsl:if test="dis:Concept/@OT">Fritekst:&#160;<xsl:value-of select="dis:Concept/@OT"/>&#160;</xsl:if>
						</b>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="dis:Concept/@DN"><xsl:value-of select="dis:Concept/@DN"/>&#160;</xsl:if>
						<xsl:if test="dis:Concept/@OT">Fritekst:&#160;<xsl:value-of select="dis:Concept/@OT"/>&#160;</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="dis:Modifier">
				<td>
					<xsl:for-each select="dis:Modifier">
						<div><b>Moderator&#160;-&#160;
							<xsl:choose>
								<xsl:when test="dis:Name/@V='S'">ICD10 stjernekode:&#160;</xsl:when>
								<xsl:when test="dis:Name/@V='A'">ATC-kode:&#160;</xsl:when>
								<xsl:otherwise>Ukjent:&#160;</xsl:otherwise>
							</xsl:choose></b>
							<xsl:value-of select="dis:Value/@V"/>&#160;-&#160;<xsl:value-of select="dis:Value/@DN"/>
						</div>
					</xsl:for-each>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<xsl:template match="dis:ReasonAsText">
		<tr>
			<xsl:if test="dis:Heading/@V='BG' or dis:Heading/@V='BUP-BM' or dis:Heading/@V='BUP-HG' or dis:Heading/@V='KF' or dis:Heading/@V='MAAL' or dis:Heading/@V='MU' or dis:Heading/@V='RU' or dis:Heading/@V='UP'">
				<th>
					<xsl:for-each select="dis:Heading">
						<xsl:call-template name="k-8231"/>
					</xsl:for-each>
					<xsl:if test="not(dis:Heading)">Begrunnelse&#160;(uspes.)</xsl:if>
				</th>
			</xsl:if>
			<td colspan="{($std-col)-1}">
				<xsl:if test="dis:TextResultValue">
					<div>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="dis:TextResultValue"/>
						</xsl:call-template>
					</div>
				</xsl:if>
				<xsl:for-each select="dis:TextCode">
					<div>
						<xsl:if test="@DN"><xsl:value-of select="@DN"/>&#160;-&#160;</xsl:if>
						<xsl:if test="@V"><b>Kodet:</b>&#160;<xsl:value-of select="@V"/></xsl:if>
						<xsl:if test="@OT"><b>Fritekst:</b>&#160;<xsl:value-of select="@OT"/></xsl:if>
					</div>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="dis:Observation">
		<tr>
			<td colspan="{($std-col)-3}">
				<xsl:if test="dis:Description">
					<div><xsl:call-template name="line-breaks"><xsl:with-param name="text" select="dis:Description"/></xsl:call-template></div>
				</xsl:if>
				<xsl:if test="dis:Comment">
					<div><xsl:call-template name="line-breaks"><xsl:with-param name="text" select="dis:Comment"/></xsl:call-template></div>
				</xsl:if>
			</td>
			<xsl:if test="../dis:StartDateTime or ../dis:EndDateTime or ../dis:OrgDate">
				<td>
					<xsl:if test="../dis:StartDateTime">
						<div>Start:&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../dis:StartDateTime/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="../dis:EndDateTime">
						<div>Slutt:&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../dis:EndDateTime/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="../dis:OrgDate">
						<div>Opprinnelse:&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../dis:OrgDate/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<xsl:template match="dis:ResultItem">
		<td>
			<xsl:for-each select="dis:ClinInv">
				<div>
					<xsl:choose>
						<xsl:when test="dis:Id/@DN"><xsl:value-of select="dis:Id/@DN"/>&#160;</xsl:when>
						<xsl:when test="dis:Id/@V"><b>Kodet:</b>&#160;<xsl:value-of select="dis:Id/@V"/>&#160;</xsl:when>
					</xsl:choose>
					<xsl:if test="dis:Id/@OT"><xsl:value-of select="dis:Id/@OT"/></xsl:if>
				</div>
				<xsl:for-each select="dis:Spec">
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
			<xsl:for-each select="dis:Interval">
				<xsl:if test="dis:Low"><b>Nedre:</b>&#160;<xsl:value-of select="dis:Low/@V"/><xsl:value-of select="dis:Low/@U"/>&#160;</xsl:if>
				<xsl:if test="dis:High"><b>Øvre:</b>&#160;<xsl:value-of select="dis:High/@V"/><xsl:value-of select="dis:High/@U"/>&#160;</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="dis:DateResult">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="dis:DateResultValue/@V"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="dis:NumResult">
				<xsl:choose>
					<xsl:when test="../dis:DevResultInd">
						<em>
							<xsl:for-each select="dis:ArithmeticComp">
								<xsl:call-template name="k-8239"/>
							</xsl:for-each>
							<xsl:value-of select="dis:NumResultValue/@V"/><xsl:value-of select="dis:NumResultValue/@U"/>
						</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="dis:ArithmeticComp">
							<xsl:call-template name="k-8239"/>
						</xsl:for-each>
						<xsl:value-of select="dis:NumResultValue/@V"/><xsl:value-of select="dis:NumResultValue/@U"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:for-each select="dis:TextResult/dis:Result">
				<xsl:if test="dis:TextResultValue">
					<div><xsl:call-template name="line-breaks"><xsl:with-param name="text" select="dis:TextResultValue"/></xsl:call-template></div>
				</xsl:if>
				<xsl:if test="dis:TextCode">
					<div>
						<xsl:choose>
							<xsl:when test="dis:TextCode/@DN"><xsl:value-of select="dis:TextCode/@DN"/>&#160;</xsl:when>
							<xsl:when test="dis:TextCode/@V"><b>Kodet:</b>&#160;<xsl:value-of select="dis:TextCode/@V"/>&#160;</xsl:when>
						</xsl:choose>
						<xsl:if test="dis:TextCode/@OT"><xsl:value-of select="dis:TextCode/@OT"/></xsl:if>
					</div>
				</xsl:if>
			</xsl:for-each>
			<xsl:if test="dis:Comment">
				<div>
					<b>Kommentar:</b>&#160;<xsl:call-template name="line-breaks"><xsl:with-param name="text" select="dis:Comment"/></xsl:call-template>
				</div>
			</xsl:if>
		</td>
		<xsl:if test="//dis:ResultItem/dis:DevResultInd">
			<td colspan="{$res-dev-col}">
				<xsl:for-each select="dis:DevResultInd">
					<xsl:choose>
						<xsl:when test="@DN"><xsl:value-of select="@DN"/></xsl:when>
						<xsl:otherwise><xsl:call-template name="k-8239"/>&#160;</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</td>
		</xsl:if>
		<xsl:if test="//dis:ResultItem/dis:InvDate">
			<td colspan="{$res-idate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="dis:InvDate/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//dis:InfItem[dis:ResultItem]/dis:StartDateTime">
			<td colspan="{$res-sdate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../dis:StartDateTime/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//dis:InfItem[dis:ResultItem]/dis:EndDateTime">
			<td colspan="{$res-edate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../dis:EndDateTime/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//dis:InfItem[dis:ResultItem]/dis:OrgDate">
			<td colspan="{$res-odate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../dis:OrgDate/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
	</xsl:template>
	<xsl:template match="dis:Medication">
		<td>
			<xsl:choose>
				<xsl:when test="dis:DrugId/@DN"><xsl:value-of select="dis:DrugId/@DN"/></xsl:when>
				<xsl:when test="dis:DrugId/@OT"><xsl:value-of select="dis:DrugId/@OT"/></xsl:when>
				<xsl:otherwise><b>Kodet:</b>&#160;<xsl:value-of select="dis:DrugId/@V"/></xsl:otherwise>
			</xsl:choose>
		</td>
		<td colspan="{$med-stat-col}">
			<xsl:choose>
				<xsl:when test="dis:Status/@DN"><xsl:value-of select="dis:Status/@DN"/></xsl:when>
				<xsl:otherwise><xsl:for-each select="dis:Status"><xsl:call-template name="k-7307"/>&#160;</xsl:for-each></xsl:otherwise>
			</xsl:choose>
		</td>
		<xsl:if test="//dis:Medication/dis:UnitDose or //dis:Medication/dis:QuantitySupplied">
			<td colspan="{$med-unit-col}">
				<xsl:if test="dis:UnitDose">
					<xsl:value-of select="dis:UnitDose/@V"/>&#160;<xsl:value-of select="dis:UnitDose/@U"/>
					<xsl:if test="dis:QuantitySupplied">&#160;x&#160;</xsl:if>
				</xsl:if>
				<xsl:if test="dis:QuantitySupplied">
					<xsl:value-of select="dis:QuantitySupplied/@V"/>&#160;<xsl:value-of select="dis:QuantitySupplied/@U"/>
				</xsl:if>&#160;
			</td>
		</xsl:if>
		<xsl:if test="//dis:Medication/dis:DosageText or //dis:Medication/dis:IntendedDuration">
			<td colspan="{$med-text-col}">
				<xsl:if test="dis:DosageText">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="dis:DosageText"/>
						</xsl:call-template>
				</xsl:if>&#160;
				<xsl:if test="dis:IntendedDuration">&#160;/&#160;<xsl:value-of select="dis:IntendedDuration/@V"/>&#160;<xsl:value-of select="dis:IntendedDuration/@U"/></xsl:if>
				<xsl:if test="not(dis:DosageText) and not(dis:IntendedDuration)">&#160;</xsl:if>
			</td>
		</xsl:if>
		<xsl:if test="//dis:Medication/dis:Comment">
			<td colspan="{$med-com-col}">
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="dis:Comment"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//dis:InfItem[dis:Medication]/dis:StartDateTime">
			<td colspan="{$med-sdate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../dis:StartDateTime/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//dis:InfItem[dis:Medication]/dis:EndDateTime">
			<td colspan="{$med-edate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../dis:EndDateTime/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
		<xsl:if test="//dis:InfItem[dis:Medication]/dis:OrgDate">
			<td colspan="{$med-odate-col}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../dis:OrgDate/@V"/>
				</xsl:call-template>
			</td>
		</xsl:if>
	</xsl:template>
	<xsl:template match="dis:Patient" mode="full">
		<xsl:if test="dis:BasisForHealthServices or dis:Sex or dis:DateOfBirth or dis:AdditionalId">
			<tr>
				<th rowspan="2">Pasientinfo</th>
				<xsl:if test="dis:Name">
					<th colspan="{(($std-col)-2)*number(not(dis:OffId | dis:Sex | dis:DateOfBirth | dis:DateOfDeath | dis:BasisForHealthServices | dis:AdditionalId ))+1}">Navn</th>
				</xsl:if>
				<xsl:if test="dis:OffId">
					<th colspan="{(($std-col)-2-count(dis:Name))*number(not(dis:Sex | dis:DateOfBirth | dis:DateOfDeath | dis:BasisForHealthServices | dis:AdditionalId))+1}">
						<xsl:choose>
							<xsl:when test="dis:TypeOffId/@DN"><xsl:value-of select="dis:TypeOffId/@DN"/></xsl:when>
							<xsl:when test="dis:TypeOffId/@V"><xsl:for-each select="dis:TypeOffId"><xsl:call-template name="k-8116"/>&#160;</xsl:for-each></xsl:when>
						</xsl:choose>
					</th>
				</xsl:if>
				<xsl:if test="dis:Sex">
					<th colspan="{(($std-col)-2-count(dis:Name | dis:OffId))*number(not(dis:DateOfBirth | dis:DateOfDeath | dis:BasisForHealthServices | dis:AdditionalId))+1}">Kjønn</th>
				</xsl:if>
				<xsl:if test="dis:DateOfBirth">
					<th colspan="{(($std-col)-2-count(dis:Name | dis:OffId | dis:Sex))*number(not(dis:DateOfDeath | dis:BasisForHealthServices | dis:AdditionalId))+1}">Fødselsdag</th>
				</xsl:if>
				<xsl:if test="dis:DateOfDeath">
					<th colspan="{(($std-col)-2-count(dis:Name | dis:OffId | dis:Sex | dis:DateOfBirth))*number(not(dis:BasisForHealthServices | dis:AdditionalId))+1}">Dødsdag</th>
				</xsl:if>
				<xsl:if test="dis:BasisForHealthServices">
					<th colspan="{(($std-col)-2-count(dis:Name | dis:OffId | dis:Sex | dis:DateOfBirth | dis:DateOfDeath))*number(not(dis:AdditionalId))+1}">Refusjonsgrunnlag</th>
				</xsl:if>
				<xsl:if test="dis:AdditionalId">
					<th colspan="{(($std-col)-1-count(dis:Name | dis:OffId | dis:Sex | dis:DateOfBirth | dis:DateOfDeath | dis:BasisForHealthServices))}">Tilleggs-Id</th>
				</xsl:if>
			</tr>
			<tr>
				<xsl:if test="dis:Name">
					<td colspan="{(($std-col)-2)*number(not(dis:OffId | dis:Sex | dis:DateOfBirth | dis:DateOfDeath | dis:BasisForHealthServices | dis:AdditionalId ))+1}">
						<xsl:value-of select="dis:Name"/>
					</td>
				</xsl:if>
				<xsl:if test="dis:OffId">
					<td colspan="{(($std-col)-2-count(dis:Name))*number(not(dis:Sex | dis:DateOfBirth | dis:DateOfDeath | dis:BasisForHealthServices | dis:AdditionalId))+1}">
						<xsl:value-of select="dis:OffId"/>
					</td>
				</xsl:if>
				<xsl:if test="dis:Sex">
					<td colspan="{(($std-col)-2-count(dis:Name | dis:OffId))*number(not(dis:DateOfBirth | dis:DateOfDeath | dis:BasisForHealthServices | dis:AdditionalId))+1}">
						<xsl:choose>
							<xsl:when test="dis:Sex/@DN"><xsl:value-of select="dis:Sex/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="dis:Sex"><xsl:call-template name="k-3101"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="dis:DateOfBirth">
					<td colspan="{(($std-col)-2-count(dis:Name | dis:OffId | dis:Sex))*number(not(dis:DateOfDeath | dis:BasisForHealthServices | dis:AdditionalId))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="dis:DateOfBirth/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="dis:DateOfDeath">
					<td colspan="{(($std-col)-2-count(dis:Name | dis:OffId | dis:Sex | dis:DateOfBirth))*number(not(dis:BasisForHealthServices | dis:AdditionalId))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="dis:DateOfDeath/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="dis:BasisForHealthServices">
					<td colspan="{(($std-col)-2-count(dis:Name | dis:OffId | dis:Sex | dis:DateOfBirth | dis:DateOfDeath))*number(not(dis:AdditionalId))+1}">
						<xsl:choose>
							<xsl:when test="dis:BasisForHealthServices/@DN"><xsl:value-of select="dis:BasisForHealthServices/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="dis:BasisForHealthServices"><xsl:call-template name="k-8246"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="dis:AdditionalId">
					<td colspan="{(($std-col)-1-count(dis:Name | dis:OffId | dis:Sex | dis:DateOfBirth | dis:DateOfDeath | dis:BasisForHealthServices))}">
						<xsl:for-each select="dis:AdditionalId">
							<div>
								<xsl:if test="dis:Type"><b><xsl:value-of select="dis:Type/@V"/>:</b>&#160;</xsl:if>
								<xsl:value-of select="dis:Id"/>
							</div>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:for-each select="dis:PatientPrecaution">
			<xsl:if test="position()=1">
				<tr>
					<th rowspan="{last()+1}">Advarsel til tjenesteyter</th>
					<xsl:if test="..//dis:PatientPrecaution/dis:Precaution">
						<th colspan="{(($std-col)-2)*number(not(..//dis:PatientPrecaution/dis:StartDateTime | ..//dis:PatientPrecaution/dis:EndDateTime))+1}">Advarsel</th>
					</xsl:if>
					<xsl:if test="..//dis:PatientPrecaution/dis:StartDateTime">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:PatientPrecaution/dis:Precaution)))*number(not(..//dis:PatientPrecaution/dis:EndDateTime))+1}">Starttidspunkt</th>
					</xsl:if>
					<xsl:if test="..//dis:PatientPrecaution/dis:EndDateTime">
						<th colspan="{(($std-col)-1-number(boolean(..//dis:PatientPrecaution/dis:Precaution))-number(boolean(..//dis:PatientPrecaution/dis:StartDateTime)))}">Sluttidspunkt</th>
					</xsl:if>
				</tr>
			</xsl:if>
			<tr>
				<xsl:if test="..//dis:PatientPrecaution/dis:Precaution">
					<td colspan="{(($std-col)-2)*number(not(..//dis:PatientPrecaution/dis:StartDateTime | ..//dis:PatientPrecaution/dis:EndDateTime))+1}">
						<xsl:value-of select="dis:Precaution"/>&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:PatientPrecaution/dis:StartDateTime">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:PatientPrecaution/dis:Precaution)))*number(not(..//dis:PatientPrecaution/dis:EndDateTime))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="dis:StartDateTime/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="..//dis:PatientPrecaution/dis:EndDateTime">
					<td colspan="{(($std-col)-1-number(boolean(..//dis:PatientPrecaution/dis:Precaution))-number(boolean(..//dis:PatientPrecaution/dis:StartDateTime)))}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="dis:EndDateTime/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="dis:Consent">
			<tr>
				<th rowspan="2">Samtykke</th>
				<xsl:if test="dis:ConsentStatus">
					<th colspan="{(($std-col)-2)*number(not(dis:ConsentDate | dis:Merknad))+1}">Samtykke&#160;gitt</th>
				</xsl:if>
				<xsl:if test="dis:ConsentDate">
					<th colspan="{(($std-col)-2-count(dis:ConsentStatus))*number(not(dis:Merknad))+1}">Samtykkedato</th>
				</xsl:if>
				<xsl:if test="dis:Merknad">
					<th colspan="{(($std-col)-1-count(dis:ConsentStatus | dis:ConsentDate))}">Merknad</th>
				</xsl:if>
			</tr>
			<tr>
				<xsl:if test="dis:ConsentStatus">
					<td colspan="{(($std-col)-2)*number(not(dis:ConsentDate | dis:Merknad))+1}">
						<xsl:choose>
							<xsl:when test="dis:ConsentStatus/@DN"><xsl:value-of select="dis:ConsentStatus/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="dis:ConsentStatus"><xsl:call-template name="k-3109"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="dis:ConsentDate">
					<td colspan="{(($std-col)-2-count(dis:ConsentStatus))*number(not(dis:Merknad))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="dis:ConsentDate/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="dis:Merknad">
					<td colspan="{(($std-col)-1-count(dis:ConsentStatus | dis:ConsentDate))}">
						<xsl:call-template name="line-breaks"><xsl:with-param name="text" select="dis:Merknad"/></xsl:call-template>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="dis:NeedTranslator">
			<xsl:if test="position()=1">
				<tr>
					<th rowspan="{(last()+1)}">Behov&#160;for&#160;tolk<div style="color:red">NB: Benyttes ikke</div></th>
					<xsl:if test="..//dis:NeedTranslator/dis:Person">
						<th colspan="{(($std-col)-2)*number(not(..//dis:NeedTranslator/dis:IsDeaf | ..//dis:NeedTranslator/dis:IsBlind | ..//dis:NeedTranslator/dis:Language | ..//dis:NeedTranslator/dis:PreferredTranslator | ..//dis:NeedTranslator/dis:TranslatorEndDate | ..//dis:NeedTranslator/dis:Note))+1}">Person-referanse</th>
					</xsl:if>
					<xsl:if test="..//dis:NeedTranslator[dis:IsDeaf/@V='true'] or ..//dis:NeedTranslator[dis:IsBlind/@V='true']">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:NeedTranslator/dis:Person)))*number(not(..//dis:NeedTranslator/dis:Language | ..//dis:NeedTranslator/dis:PreferredTranslator | ..//dis:NeedTranslator/dis:TranslatorEndDate | ..//dis:NeedTranslator/dis:Note))+1}">Handikap</th>
					</xsl:if>
					<xsl:if test="..//dis:NeedTranslator/dis:Language">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:NeedTranslator/dis:Person))-number(boolean(..//dis:NeedTranslator/dis:IsDeaf | ..//dis:NeedTranslator/dis:IsBlind)))*number(not(..//dis:NeedTranslator/dis:PreferredTranslator | ..//dis:NeedTranslator/dis:TranslatorEndDate | ..//dis:NeedTranslator/dis:Note))+1}">Språk</th>
					</xsl:if>
					<xsl:if test="..//dis:NeedTranslator/dis:PreferredTranslator">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:NeedTranslator/dis:Person))-number(boolean(..//dis:NeedTranslator/dis:IsDeaf | ..//dis:NeedTranslator/dis:IsBlind))-number(boolean(..//dis:NeedTranslator/dis:Language)))*number(not(..//dis:NeedTranslator/dis:TranslatorEndDate | ..//dis:NeedTranslator/dis:Note))+1}">Referanse til foretrukket tolk</th>
					</xsl:if>
					<xsl:if test="..//dis:NeedTranslator/dis:TranslatorEndDate">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:NeedTranslator/dis:Person))-number(boolean(..//dis:NeedTranslator/dis:IsDeaf | ..//dis:NeedTranslator/dis:IsBlind))-number(boolean(..//dis:NeedTranslator/dis:Language))-number(boolean(..//dis:NeedTranslator/dis:PreferredTranslator)))*number(not(..//dis:NeedTranslator/dis:Note))+1}">Behov opphørt dato</th>
					</xsl:if>
					<xsl:if test="..//dis:NeedTranslator/dis:Note">
						<th colspan="{(($std-col)-1-number(boolean(..//dis:NeedTranslator/dis:Person))-number(boolean(..//dis:NeedTranslator/dis:IsDeaf | ..//dis:NeedTranslator/dis:IsBlind))-number(boolean(..//dis:NeedTranslator/dis:Language))-number(boolean(..//dis:NeedTranslator/dis:PreferredTranslator))-number(boolean(..//dis:NeedTranslator/dis:TranslatorEndDate)))}">Merknad</th>
					</xsl:if>
				</tr>
			</xsl:if>
			<tr>
				<xsl:if test="..//dis:NeedTranslator/dis:Person">
					<td colspan="{(($std-col)-2)*number(not(..//dis:NeedTranslator/dis:IsDeaf | ..//dis:NeedTranslator/dis:IsBlind | ..//dis:NeedTranslator/dis:Language | ..//dis:NeedTranslator/dis:PreferredTranslator | ..//dis:NeedTranslator/dis:TranslatorEndDate | ..//dis:NeedTranslator/dis:Note))+1}">
						<xsl:value-of select="dis:Person"/>&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:NeedTranslator[dis:IsDeaf/@V='true'] or ..//dis:NeedTranslator[dis:IsBlind/@V='true']">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:NeedTranslator/dis:Person)))*number(not(..//dis:NeedTranslator/dis:Language | ..//dis:NeedTranslator/dis:PreferredTranslator | ..//dis:NeedTranslator/dis:TranslatorEndDate | ..//dis:NeedTranslator/dis:Note))+1}">
						<xsl:if test="dis:IsDeaf/@V='true'">Døv</xsl:if>
						<xsl:if test="dis:IsDeaf/@V='true' and dis:IsBlind/@V='true'">&#160;og&#160;</xsl:if>
						<xsl:if test="dis:IsBlind/@V='true'">Blind</xsl:if>&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:NeedTranslator/dis:Language">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:NeedTranslator/dis:Person))-number(boolean(..//dis:NeedTranslator/dis:IsDeaf | ..//dis:NeedTranslator/dis:IsBlind)))*number(not(..//dis:NeedTranslator/dis:PreferredTranslator | ..//dis:NeedTranslator/dis:TranslatorEndDate | ..//dis:NeedTranslator/dis:Note))+1}">
						<xsl:choose>
							<xsl:when test="dis:Language/@DN"><xsl:value-of select="dis:Language/@DN"/></xsl:when>
							<xsl:when test="dis:Language/@V"><b>Kodet:</b>&#160;<xsl:value-of select="dis:Language/@V"/></xsl:when>
						</xsl:choose>&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:NeedTranslator/dis:PreferredTranslator">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:NeedTranslator/dis:Person))-number(boolean(..//dis:NeedTranslator/dis:IsDeaf | ..//dis:NeedTranslator/dis:IsBlind))-number(boolean(..//dis:NeedTranslator/dis:Language)))*number(not(..//dis:NeedTranslator/dis:TranslatorEndDate | ..//dis:NeedTranslator/dis:Note))+1}">
						<xsl:value-of select="dis:PreferredTranslator"/>&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:NeedTranslator/dis:TranslatorEndDate">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:NeedTranslator/dis:Person))-number(boolean(..//dis:NeedTranslator/dis:IsDeaf | ..//dis:NeedTranslator/dis:IsBlind))-number(boolean(..//dis:NeedTranslator/dis:Language))-number(boolean(..//dis:NeedTranslator/dis:PreferredTranslator)))*number(not(..//dis:NeedTranslator/dis:Note))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="dis:TranslatorEndDate/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="..//dis:NeedTranslator/dis:Note">
					<td colspan="{(($std-col)-1-number(boolean(..//dis:NeedTranslator/dis:Person))-number(boolean(..//dis:NeedTranslator/dis:IsDeaf | ..//dis:NeedTranslator/dis:IsBlind))-number(boolean(..//dis:NeedTranslator/dis:Language))-number(boolean(..//dis:NeedTranslator/dis:PreferredTranslator))-number(boolean(..//dis:NeedTranslator/dis:TranslatorEndDate)))}">
						<xsl:call-template name="line-breaks"><xsl:with-param name="text" select="dis:Note"/></xsl:call-template>&#160;
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="dis:CareSituation">
			<tr>
				<th rowspan="2">Omsorgssituasjon</th>
				<xsl:if test="dis:CustodyType">
					<th colspan="{(($std-col)-2)*number(not(dis:CareSituationType | dis:NativeLanguage | dis:Description))+1}">Foreldreansvar</th>
				</xsl:if>
				<xsl:if test="dis:CareSituationType">
					<th colspan="{(($std-col)-2-count(dis:CustodyType))*number(not(dis:NativeLanguage | dis:Description))+1}">Type&#160;omsorgssituasjon</th>
				</xsl:if>
				<xsl:if test="dis:NativeLanguage">
					<th colspan="{(($std-col)-2-count(dis:CustodyType | dis:CareSituationType))*number(not(dis:Description))+1}">Hjemmespråk</th>
				</xsl:if>
				<xsl:if test="dis:Description">
					<th colspan="{(($std-col)-1-count(dis:CustodyType | dis:CareSituationType | dis:NativeLanguage))}">Beskrivelse</th>
				</xsl:if>
			</tr>
			<tr>
				<xsl:if test="dis:CustodyType">
					<td colspan="{(($std-col)-2)*number(not(dis:CareSituationType | dis:NativeLanguage | dis:Description))+1}">
						<xsl:choose>
							<xsl:when test="dis:CustodyType/@DN"><xsl:value-of select="dis:CustodyType/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="dis:CustodyType"><xsl:call-template name="k-9513"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose>&#160;
						<xsl:if test="dis:CustodyOwner"><xsl:value-of select="dis:CustodyOwner"/></xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="dis:CareSituationType">
					<td colspan="{(($std-col)-2-count(dis:CustodyType))*number(not(dis:NativeLanguage | dis:Description))+1}">
						<xsl:choose>
							<xsl:when test="dis:CareSituationType/@DN"><xsl:value-of select="dis:CareSituationType/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="dis:CareSituationType"><xsl:call-template name="k-3105"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="dis:NativeLanguage">
					<td colspan="{(($std-col)-2-count(dis:CustodyType | dis:CareSituationType))*number(not(dis:Description))+1}">
						<xsl:choose>
							<xsl:when test="dis:NativeLanguage/@DN"><xsl:value-of select="dis:NativeLanguage/@DN"/></xsl:when>
							<xsl:otherwise><xsl:for-each select="dis:NativeLanguage"><xsl:call-template name="k-8417"/>&#160;</xsl:for-each></xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="dis:Description">
					<td colspan="{(($std-col)-1-count(dis:CustodyType | dis:CareSituationType | dis:NativeLanguage))}">
						<xsl:call-template name="line-breaks"><xsl:with-param name="text" select="dis:Description"/></xsl:call-template>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="dis:PatRelperson">
			<xsl:if test="position()=1">
				<tr>
					<th rowspan="{(last()+1)}">Referert person</th>
					<xsl:if test="..//dis:PatRelperson/dis:Relation or ..//dis:PatRelperson/dis:Description">
						<th colspan="{(($std-col)-2)*number(not(..//dis:PatRelperson/dis:Name | ..//dis:PatRelperson/dis:OffId | ..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth | ..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role | ..//dis:PatRelperson/dis:Consent | ..//dis:PatRelperson/dis:Address))+1}">Relasjon/beskrivelse</th>
					</xsl:if>
					<xsl:if test="..//dis:PatRelperson/dis:Name">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description)))*number(not(..//dis:PatRelperson/dis:OffId | ..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth | ..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role | ..//dis:PatRelperson/dis:Consent | ..//dis:PatRelperson/dis:Address))+1}">Navn</th>
					</xsl:if>
					<xsl:if test="..//dis:PatRelperson/dis:OffId">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description))-number(boolean(..//dis:PatRelperson/dis:Name)))*number(not(..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth | ..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role | ..//dis:PatRelperson/dis:Consent | ..//dis:PatRelperson/dis:Address))+1}">Offentlig&#160;id</th>
					</xsl:if>
					<xsl:if test="..//dis:PatRelperson/dis:Sex or ..//dis:PatRelperson/dis:EthnicBelonging or ..//dis:PatRelperson/dis:DateOfBirth">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description))-number(boolean(..//dis:PatRelperson/dis:Name))-number(boolean(..//dis:PatRelperson/dis:OffId)))*number(not(..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role | ..//dis:PatRelperson/dis:Consent | ..//dis:PatRelperson/dis:Address))+1}">Personlige opplysninger</th>
					</xsl:if>
					<xsl:if test="..//dis:PatRelperson/dis:Occupation or ..//dis:PatRelperson/dis:Role">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description))-number(boolean(..//dis:PatRelperson/dis:Name))-number(boolean(..//dis:PatRelperson/dis:OffId))-number(boolean(..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth)))*number(not(..//dis:PatRelperson/dis:Consent | ..//dis:PatRelperson/dis:Address))+1}">Stilling/annen&#160;rolle</th>
					</xsl:if>
					<xsl:if test="..//dis:PatRelperson/dis:Consent">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description))-number(boolean(..//dis:PatRelperson/dis:Name))-number(boolean(..//dis:PatRelperson/dis:OffId))-number(boolean(..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth))-number(boolean(..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role)))*number(not(..//dis:PatRelperson/dis:Address))+1}">Samtykke</th>
					</xsl:if>
					<xsl:if test="..//dis:PatRelperson/dis:Address">
						<th colspan="{(($std-col)-1-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description))-number(boolean(..//dis:PatRelperson/dis:Name))-number(boolean(..//dis:PatRelperson/dis:OffId))-number(boolean(..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth))-number(boolean(..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role))-number(boolean(..//dis:PatRelperson/dis:Consent)))}">Adresse</th>
					</xsl:if>
				</tr>
			</xsl:if>
			<tr>
				<xsl:if test="..//dis:PatRelperson/dis:Relation or ..//dis:PatRelperson/dis:Description">
					<td colspan="{(($std-col)-2)*number(not(..//dis:PatRelperson/dis:Name | ..//dis:PatRelperson/dis:OffId | ..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth | ..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role | ..//dis:PatRelperson/dis:Consent | ..//dis:PatRelperson/dis:Address))+1}">
						<xsl:if test="dis:Relation/dis:Guardien/@V='true'"><b>Foresatt</b>&#160;</xsl:if>
						<xsl:choose>
							<xsl:when test="dis:Relation/dis:RelationCode/@DN"><xsl:value-of select="dis:Relation/dis:RelationCode/@DN"/></xsl:when>
							<xsl:when test="dis:Relation/dis:RelationCode/@V='9' and dis:Relation/dis:Description"><xsl:value-of select="dis:Relation/dis:Description"/></xsl:when>
							<xsl:when test="dis:Relation/dis:RelationCode/@V"><xsl:for-each select="dis:Relation/dis:RelationCode"><xsl:call-template name="k-8422"/>&#160;</xsl:for-each></xsl:when>
							<xsl:when test="dis:Relation/dis:Description"><xsl:value-of select="dis:Relation/dis:Description"/></xsl:when>
							<xsl:when test="dis:Description"><xsl:value-of select="dis:Description"/></xsl:when>
							<xsl:otherwise>Pasientrelatert person</xsl:otherwise>
						</xsl:choose>&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:PatRelperson/dis:Name">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description)))*number(not(..//dis:PatRelperson/dis:OffId | ..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth | ..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role | ..//dis:PatRelperson/dis:Consent | ..//dis:PatRelperson/dis:Address))+1}">
						<xsl:value-of select="dis:Name"/>&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:PatRelperson/dis:OffId">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description))-number(boolean(..//dis:PatRelperson/dis:Name)))*number(not(..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth | ..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role | ..//dis:PatRelperson/dis:Consent | ..//dis:PatRelperson/dis:Address))+1}">
						<b>
							<xsl:choose>
								<xsl:when test="dis:TypeOffId/@DN"><xsl:value-of select="dis:TypeOffId/@DN"/></xsl:when>
								<xsl:otherwise><xsl:for-each select="dis:TypeOffId"><xsl:call-template name="k-8116"/>&#160;</xsl:for-each></xsl:otherwise>
							</xsl:choose>
						</b>&#160;
						<xsl:value-of select="dis:OffId"/>
					</td>
				</xsl:if>
				<xsl:if test="..//dis:PatRelperson/dis:Sex or ..//dis:PatRelperson/dis:EthnicBelonging or ..//dis:PatRelperson/dis:DateOfBirth">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description))-number(boolean(..//dis:PatRelperson/dis:Name))-number(boolean(..//dis:PatRelperson/dis:OffId)))*number(not(..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role | ..//dis:PatRelperson/dis:Consent | ..//dis:PatRelperson/dis:Address))+1}">
						<xsl:if test="dis:Sex">
							<xsl:if test="dis:Sex/@V='0' or dis:Sex/@V='9'"><b>Kjønn:</b>&#160;</xsl:if>
							<xsl:choose>
								<xsl:when test="dis:Sex/@DN"><xsl:value-of select="dis:Sex/@DN"/></xsl:when>
								<xsl:otherwise><xsl:for-each select="dis:Sex"><xsl:call-template name="k-3101"/>&#160;</xsl:for-each></xsl:otherwise>
							</xsl:choose>
							<xsl:if test="dis:EthnicBelonging or dis:DateOfBirth">,&#160;</xsl:if>
						</xsl:if>
						<xsl:if test="dis:EthnicBelonging">
							<xsl:choose>
								<xsl:when test="dis:EthnicBelonging/@DN"><xsl:value-of select="dis:EthnicBelonging/@DN"/></xsl:when>
								<xsl:otherwise><xsl:for-each select="dis:EthnicBelonging"><xsl:call-template name="k-8423"/>&#160;</xsl:for-each></xsl:otherwise>
							</xsl:choose>
							<xsl:if test="dis:DateOfBirth">,&#160;</xsl:if>
						</xsl:if>
						<xsl:if test="dis:DateOfBirth">
							<b>født:&#160;</b>
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="dis:DateOfBirth/@V"/>
							</xsl:call-template>
						</xsl:if>
						&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:PatRelperson/dis:Occupation or ..//dis:PatRelperson/dis:Role">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description))-number(boolean(..//dis:PatRelperson/dis:Name))-number(boolean(..//dis:PatRelperson/dis:OffId))-number(boolean(..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth)))*number(not(..//dis:PatRelperson/dis:Consent | ..//dis:PatRelperson/dis:Address))+1}">
						<xsl:choose>
							<xsl:when test="dis:Occupation/@DN"><xsl:value-of select="dis:Occupation/@DN"/></xsl:when>
							<xsl:otherwise><b>Stillingskode:</b>&#160;<xsl:value-of select="dis:Occupation/@V"/></xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="dis:Role"/>
						&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:PatRelperson/dis:Consent">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description))-number(boolean(..//dis:PatRelperson/dis:Name))-number(boolean(..//dis:PatRelperson/dis:OffId))-number(boolean(..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth))-number(boolean(..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role)))*number(not(..//dis:PatRelperson/dis:Address))+1}">
						<xsl:for-each select="dis:Consent">
							<xsl:if test="dis:ConsentStatus">
								<b>Samtykke&#160;gitt:</b>&#160;
								<xsl:choose>
									<xsl:when test="dis:ConsentStatus/@DN"><xsl:value-of select="dis:ConsentStatus/@DN"/></xsl:when>
									<xsl:otherwise><xsl:for-each select="dis:ConsentStatus"><xsl:call-template name="k-3109"/>&#160;</xsl:for-each></xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="dis:ConsentDate">
								<b>Dato:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="dis:ConsentDate/@V"/>
								</xsl:call-template>
							</xsl:if>&#160;
							<xsl:if test="dis:Merknad">
								<div><b>Merknad:</b>&#160;<xsl:call-template name="line-breaks"><xsl:with-param name="text" select="dis:Merknad"/></xsl:call-template></div>
							</xsl:if>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="..//dis:PatRelperson/dis:Address">
					<td colspan="{(($std-col)-1-number(boolean(..//dis:PatRelperson/dis:Relation | ..//dis:PatRelperson/dis:Description))-number(boolean(..//dis:PatRelperson/dis:Name))-number(boolean(..//dis:PatRelperson/dis:OffId))-number(boolean(..//dis:PatRelperson/dis:Sex | ..//dis:PatRelperson/dis:EthnicBelonging | ..//dis:PatRelperson/dis:DateOfBirth))-number(boolean(..//dis:PatRelperson/dis:Occupation | ..//dis:PatRelperson/dis:Role))-number(boolean(..//dis:PatRelperson/dis:Consent)))}">
						<xsl:apply-templates select="dis:Address" mode="full"/>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="dis:PatRelInst">
			<xsl:if test="position()=1">
				<tr>
					<th rowspan="{last()+1}">Referert virksomhet</th>
					<xsl:if test="..//dis:PatRelInst/dis:NameInst">
						<th colspan="{(($std-col)-2)*number(not(..//dis:PatRelInst/dis:WorkingTime | ..//dis:PatRelInst/dis:ContactPerson | ..//dis:PatRelInst/dis:Address))+1}">Navn</th>
					</xsl:if>
					<xsl:if test="..//dis:PatRelInst/dis:WorkingTime">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:PatRelInst/dis:NameInst)))*number(not(..//dis:PatRelInst/dis:ContactPerson | ..//dis:PatRelInst/dis:Address))+1}">Arbeidstid</th>
					</xsl:if>
					<xsl:if test="..//dis:PatRelInst/dis:ContactPerson">
						<th colspan="{(($std-col)-2-number(boolean(..//dis:PatRelInst/dis:NameInst))-number(boolean(..//dis:PatRelInst/dis:WorkingTime)))*number(not(..//dis:PatRelInst/dis:Address))+1}">Kontaktperson</th>
					</xsl:if>
					<xsl:if test="..//dis:PatRelInst/dis:Address">
						<th colspan="{(($std-col)-1-number(boolean(..//dis:PatRelInst/dis:NameInst))-number(boolean(..//dis:PatRelInst/dis:WorkingTime))-number(boolean(..//dis:PatRelInst/dis:ContactPerson)))}">Adresse</th>
					</xsl:if>
				</tr>
			</xsl:if>
			<tr>
				<xsl:if test="..//dis:PatRelInst/dis:NameInst">
					<td colspan="{(($std-col)-2)*number(not(..//dis:PatRelInst/dis:WorkingTime | ..//dis:PatRelInst/dis:ContactPerson | ..//dis:PatRelInst/dis:Address))+1}">
						<xsl:value-of select="dis:NameInst"/>
						&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:PatRelInst/dis:WorkingTime">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:PatRelInst/dis:NameInst)))*number(not(..//dis:PatRelInst/dis:ContactPerson | ..//dis:PatRelInst/dis:Address))+1}">
						<xsl:value-of select="dis:WorkingTime"/>
						&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:PatRelInst/dis:ContactPerson">
					<td colspan="{(($std-col)-2-number(boolean(..//dis:PatRelInst/dis:NameInst))-number(boolean(..//dis:PatRelInst/dis:WorkingTime)))*number(not(..//dis:PatRelInst/dis:Address))+1}">
						<xsl:value-of select="dis:ContactPerson"/>
						&#160;
					</td>
				</xsl:if>
				<xsl:if test="..//dis:PatRelInst/dis:Address">
					<td colspan="{(($std-col)-1-number(boolean(..//dis:PatRelInst/dis:NameInst))-number(boolean(..//dis:PatRelInst/dis:WorkingTime))-number(boolean(..//dis:PatRelInst/dis:ContactPerson)))}">
						<xsl:apply-templates select="dis:Address" mode="full"/>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="dis:PatRelHCP">
		<xsl:variable name="raw-rows" select="count(.//dis:HCProf | .//dis:HCPerson | .//dis:Dept)"/>
		<xsl:variable name="rows">
			<xsl:choose>
				<xsl:when test="$raw-rows&gt;0"><xsl:value-of select="$raw-rows"/></xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<xsl:if test="..//dis:PatRelHCP/dis:Relation">
				<th rowspan="{$rows}">
					<xsl:choose>
						<xsl:when test="dis:Relation/@DN"><xsl:value-of select="dis:Relation/@DN"/></xsl:when>
						<xsl:otherwise><xsl:for-each select="dis:Relation"><xsl:call-template name="k-7319"/>&#160;</xsl:for-each></xsl:otherwise>
					</xsl:choose>&#160;
				</th>
			</xsl:if>
			<xsl:if test="..//dis:PatRelHCP//dis:HCProf | ..//dis:PatRelHCP//dis:HCPerson | ..//dis:PatRelHCP//dis:Dept">
				<xsl:choose>
					<xsl:when test=".//dis:HCProf | .//dis:HCPerson | .//dis:Dept">
						<xsl:for-each select=".//dis:HCProf | .//dis:HCPerson | .//dis:Dept">
							<xsl:if test="position()=1"><xsl:apply-templates select="."/></xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise><td>&#160;</td><td>&#160;</td></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="..//dis:PatRelHCP//dis:Inst/dis:Name">
				<td rowspan="{$rows}" colspan="{(($std-col)-2-number(boolean(..//dis:PatRelHCP//dis:HCProf | ..//dis:PatRelHCP//dis:HCPerson | ..//dis:PatRelHCP//dis:Dept))-1)*number(not(..//dis:PatRelHCP//dis:MedSpeciality | ..//dis:PatRelHCP//dis:Inst/dis:Id | ..//dis:PatRelHCP/dis:StartDateTime | ..//dis:PatRelHCP/dis:EndDateTime | ..//dis:PatRelHCP//dis:Address))+1}">
					<xsl:value-of select=".//dis:Inst/dis:Name"/>&#160;
				</td>
			</xsl:if>
			<xsl:if test="..//dis:PatRelHCP//dis:MedSpeciality">
				<td rowspan="{$rows}" colspan="{(($std-col)-2-number(boolean(..//dis:PatRelHCP//dis:HCProf | ..//dis:PatRelHCP//dis:HCPerson | ..//dis:PatRelHCP//dis:Dept))-1-number(boolean(..//dis:PatRelHCP//dis:Inst/dis:Name)))*number(not(..//dis:PatRelHCP//dis:Inst/dis:Id | ..//dis:PatRelHCP/dis:StartDateTime | ..//dis:PatRelHCP/dis:EndDateTime | ..//dis:PatRelHCP//dis:Address))+1}">
					<xsl:for-each select=".//dis:MedSpeciality">
						<xsl:choose>
							<xsl:when test="@DN"><xsl:value-of select="@DN"/></xsl:when>
							<xsl:when test="@OT"><xsl:value-of select="@OT"/></xsl:when>
							<xsl:otherwise><b>Kodet:</b>&#160;<xsl:value-of select="@V"/></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>&#160;
				</td>
			</xsl:if>
			<xsl:if test="..//dis:PatRelHCP//dis:Inst/dis:Id">
				<td rowspan="{$rows}" colspan="{(($std-col)-2-number(boolean(..//dis:PatRelHCP//dis:HCProf | ..//dis:PatRelHCP//dis:HCPerson | ..//dis:PatRelHCP//dis:Dept))-1-number(boolean(..//dis:PatRelHCP//dis:Inst/dis:Name))-number(boolean(..//dis:PatRelHCP//dis:MedSpeciality)))*number(not(..//dis:PatRelHCP/dis:StartDateTime | ..//dis:PatRelHCP/dis:EndDateTime | ..//dis:PatRelHCP//dis:Address))+1}">
					<xsl:if test=".//dis:Inst/dis:TypeId/@V">
						<b><xsl:value-of select=".//dis:Inst/dis:TypeId/@V"/>:</b>
					</xsl:if>&#160;
					<xsl:value-of select=".//dis:Inst/dis:Id"/>
				</td>
			</xsl:if>
			<xsl:if test="..//dis:PatRelHCP//dis:StartDateTime | ..//dis:PatRelHCP//dis:EndDateTime">
				<td rowspan="{$rows}" colspan="{(($std-col)-2-number(boolean(..//dis:PatRelHCP//dis:HCProf | ..//dis:PatRelHCP//dis:HCPerson | ..//dis:PatRelHCP//dis:Dept))-1-number(boolean(..//dis:PatRelHCP//dis:Inst/dis:Name))-number(boolean(..//dis:PatRelHCP//dis:MedSpeciality))-number(boolean(..//dis:PatRelHCP//dis:Inst/dis:Id)))*number(not(..//dis:PatRelHCP//dis:Address))+1}">
					<xsl:if test="dis:StartDateTime">
						<b>Start:</b>&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="dis:StartDateTime/@V"/>
						</xsl:call-template>
					</xsl:if>&#160;
					<xsl:if test="dis:EndDateTime">
						<div><b>Slutt:</b>&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="dis:EndDateTime/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="..//dis:PatRelHCP//dis:Address">
				<td rowspan="{$rows}" colspan="{(($std-col)-1-number(boolean(..//dis:PatRelHCP//dis:HCProf | ..//dis:PatRelHCP//dis:HCPerson | ..//dis:PatRelHCP//dis:Dept))-1-number(boolean(..//dis:PatRelHCP//dis:Inst/dis:Name))-number(boolean(..//dis:PatRelHCP//dis:MedSpeciality))-number(boolean(..//dis:PatRelHCP//dis:Inst/dis:Id))-number(boolean(..//dis:PatRelHCP/dis:StartDateTime | ..//dis:PatRelHCP/dis:EndDateTime)))}">
					<xsl:apply-templates select=".//dis:Address" mode="full"/>
				</td>
			</xsl:if>
		</tr>
		<xsl:for-each select=".//dis:HCProf | .//dis:HCPerson | .//dis:Dept">
			<xsl:if test="position()!=1"><tr><xsl:apply-templates select="."/></tr></xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="dis:HCProf | dis:HCPerson | dis:Dept">
		<td colspan="{(($std-col)-2)*number(not(//dis:PatRelHCP//dis:HCProf/dis:Id | //dis:PatRelHCP//dis:HCProf/dis:AdditionalId | //dis:PatRelHCP//dis:HCPerson/dis:Id | //dis:PatRelHCP//dis:HCPerson/dis:AdditionalId | //dis:PatRelHCP//dis:Dept/dis:Id | //dis:PatRelHCP//dis:Dept/dis:AdditionalId | //dis:PatRelHCP//dis:Inst/dis:Name | //dis:PatRelHCP//dis:MedSpeciality | //dis:PatRelHCP//dis:Inst/dis:Id | //dis:PatRelHCP/dis:StartDateTime | //dis:PatRelHCP/dis:EndDateTime | //dis:PatRelHCP//dis:Address))+1}">
			<xsl:if test="dis:Type/@DN">
				<b><xsl:value-of select="dis:Type/@DN"/></b>&#160;
			</xsl:if>
			<xsl:value-of select="dis:Name"/>&#160;
		</td>
		<td colspan="{(($std-col)-3)*number(not(//dis:PatRelHCP//dis:Inst/dis:Name | //dis:PatRelHCP//dis:MedSpeciality | //dis:PatRelHCP//dis:Inst/dis:Id | //dis:PatRelHCP/dis:StartDateTime | //dis:PatRelHCP/dis:EndDateTime | //dis:PatRelHCP//dis:Address))+1}">
			<xsl:if test="dis:TypeId/@V">
				<b><xsl:value-of select="dis:TypeId/@V"/>:</b>&#160;
			</xsl:if>
			<xsl:value-of select="dis:Id"/>&#160;
		</td>
	</xsl:template>
	<xsl:template match="dis:Address" mode="full">
		<xsl:if test="dis:Type">
			<b>
				<xsl:choose>
					<xsl:when test="dis:Type/@DN"><xsl:value-of select="dis:Type/@DN"/>:&#160;</xsl:when>
					<xsl:otherwise><xsl:for-each select="dis:Type"><xsl:call-template name="k-3401"/>:&#160;</xsl:for-each></xsl:otherwise>
				</xsl:choose>
			</b>
		</xsl:if>
		<xsl:if test="dis:StreetAdr"><xsl:value-of select="dis:StreetAdr"/></xsl:if>
		<xsl:if test="dis:PostalCode or dis:City">
			<xsl:if test="dis:StreetAdr">,&#160;</xsl:if>
			<xsl:value-of select="dis:PostalCode"/>&#160;<xsl:value-of select="dis:City"/>
		</xsl:if>
		<xsl:if test="dis:CityDistr">&#160;,<xsl:value-of select="dis:CityDistr/@DN"/></xsl:if>
		<xsl:if test="dis:County">&#160;,<xsl:value-of select="dis:County/@DN"/></xsl:if>
		<xsl:if test="dis:Country">&#160;,<xsl:value-of select="dis:Country/@DN"/></xsl:if>
		&#160;
		<xsl:for-each select="dis:TeleAddress"><xsl:apply-templates select="."/></xsl:for-each>
	</xsl:template>
	<xsl:template match="dis:RefDoc">
		<tr>
			<xsl:if test="dis:MsgType">
				<th>Type</th>
				<td colspan="{(($std-col)-2)*number(not(dis:Id | dis:IssueDate | dis:Booking))+1}">
					<xsl:choose>
						<xsl:when test="dis:MsgType/@DN"><xsl:value-of select="dis:MsgType/@DN"/></xsl:when>
						<xsl:otherwise><xsl:for-each select="dis:MsgType"><xsl:call-template name="k-8263"/>&#160;</xsl:for-each></xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="dis:IssueDate or dis:Id">
				<th>
					<xsl:if test="dis:IssueDate">Utstedt</xsl:if>
					<xsl:if test="dis:IssueDate and dis:Id">&#160;/&#160;</xsl:if>
					<xsl:if test="dis:Id">Id</xsl:if>
				</th>
				<td colspan="{(($std-col)-2-count(dis:MsgType)*2)*number(not(dis:Booking))+1}">
					<xsl:if test="dis:IssueDate">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="dis:IssueDate/@V"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="dis:IssueDate and dis:Id">&#160;/&#160;</xsl:if>
					<xsl:if test="dis:Id"><xsl:value-of select="dis:Id"/></xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="dis:Booking">
				<th>Booking</th>
				<td>
					<xsl:for-each select="dis:Booking">
						<xsl:value-of select="dis:Name"/>&#160;
						<b><xsl:choose>
							<xsl:when test="dis:TypeId/@V"><xsl:value-of select="dis:TypeId/@V"/>:</xsl:when>
							<xsl:otherwise>Id:</xsl:otherwise>
						</xsl:choose></b>&#160;
						<xsl:value-of select="dis:Id"/>
						<xsl:apply-templates select=".//dis:SubOrg"/>
					</xsl:for-each>
				</td>
				<th>Avtale</th>
				<td colspan="{($std-col)-3-number(boolean(dis:MsgType | dis:Id))*2-count(dis:IssueDate)*2}">
					<xsl:for-each select="dis:Booking/dis:Appointment">
						<div>
							<b>Tidspunkt:</b>&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="dis:StartDateTime/@V"/>
							</xsl:call-template>
							&#160;<b>til</b>&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="dis:EndDateTime/@V"/>
							</xsl:call-template>
						</div>
						<div>
							<b>Ressurs:</b>&#160;
							<xsl:value-of select="dis:ResourceId"/>&#160;
							<b>Index:</b>&#160;
							<xsl:value-of select="dis:Index"/>
						</div>
						<div>
							<b>Service:</b>&#160;
							<xsl:choose>
								<xsl:when test="dis:Service/@DN"><xsl:value-of select="dis:Service/@DN"/></xsl:when>
								<xsl:otherwise><xsl:for-each select="dis:Service"><xsl:call-template name="k-8264"/>&#160;</xsl:for-each></xsl:otherwise>
							</xsl:choose>
						</div>
					</xsl:for-each>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<xsl:template match="dis:SubOrg">
		<div>
			<xsl:value-of select="dis:Name"/>&#160;
			<b><xsl:choose>
				<xsl:when test="dis:TypeId"><xsl:value-of select="dis:TypeId"/>:</xsl:when>
				<xsl:otherwise>Id:</xsl:otherwise>
			</xsl:choose></b>&#160;
			<xsl:value-of select="dis:Id"/>
		</div>
	</xsl:template>
	
	<!-- Kodeverk -->
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
