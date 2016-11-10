<?xml version="1.0" encoding="utf-8"?>
	<!-- Endringslogg
	- 01.09.16: Opprettet felles visning for alle versjonene av svarrapport
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
	<!-- Svakheter
	- Kolonnevariablene er foreløpig ikke dynamiske (forminsker man variablene dannes ikke flere rader)
	- Fravær av obligatoriske element kan gi tomme bokser/rader
	-->
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:base="http://www.kith.no/xmlstds/base64container" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="base xhtml">
	<xsl:import href="../Felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../Felleskomponenter/kodeverk.xsl"/>
	<xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	<!-- Variabel-deklarasjon -->
	<!-- Variabel for hvilken stil visning har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'No-line-doc'"/>
	<!-- Variabel for hvilken versjon av visningsfilen -->
	<xsl:variable name="versjon" select="'svar versjonuavhengig v4.0.0 '"/>
	<!-- Variabler for kolonnebredde -->
	<xsl:variable name="structured-col-width" select="'40%'"/>
	<xsl:variable name="structured-head-width" select="'20%'"/>
	<!-- Variabler for antall kolonner og bredde -->
	<xsl:variable name="result-col" select="10"/>
	<xsl:variable name="result-td" select="150"/>
	<xsl:variable name="id-td" select="25"/>
	<xsl:variable name="std-col" select="10"/>
	<xsl:variable name="std-td" select="200"/>
	<!-- Variabler for bruk til referanser i undersøkelsestabellen -->
	<xsl:variable name="und-komm" select="'k'"/>
	<xsl:variable name="und-spes" select="'s'"/>
	<xsl:variable name="res-komm" select="'r'"/>
	<xsl:variable name="dia-komm" select="'d'"/>
	<!-- (hårete) Variabler for beregning av antall kolonner i undersøkelsestabellen -->
	<xsl:variable name="investigation-col" select="(($result-col)-1)*number(not(//child::*[local-name()=&quot;TextResult&quot;] | //child::*[local-name()=&quot;Interval&quot;] | //child::*[local-name()=&quot;DateResult&quot;] | //child::*[local-name()=&quot;NumResult&quot;] | //child::*[local-name()=&quot;IdResultItem&quot;] | //child::*[local-name()=&quot;RefIdResultItem&quot;] | //child::*[local-name()=&quot;RefInterval&quot;]  | //child::*[local-name()=&quot;InvDate&quot;] | //child::*[local-name()=&quot;StatusChangeDate&quot;] | //child::*[local-name()=&quot;DescrDate&quot;] | //child::*[local-name()=&quot;CounterSignDate&quot;] | //child::*[local-name()=&quot;MedicalValidationDate&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;RelServProv&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Accredited&quot;] | //child::*[local-name()=&quot;StructuredInfo&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DiagComment&quot;] | //child::*[local-name()=&quot;RefAnalysedSubject&quot;] | //child::*[local-name()=&quot;StatusInvestigation&quot;]))+1"/>
	<xsl:variable name="res-col" select="(($result-col)-1-number(boolean(//child::*[local-name()=&quot;Investigation&quot;])))*number(not(//child::*[local-name()=&quot;IdResultItem&quot;] | //child::*[local-name()=&quot;RefIdResultItem&quot;] | //child::*[local-name()=&quot;RefInterval&quot;]  | //child::*[local-name()=&quot;InvDate&quot;] | //child::*[local-name()=&quot;StatusChangeDate&quot;] | //child::*[local-name()=&quot;DescrDate&quot;] | //child::*[local-name()=&quot;CounterSignDate&quot;] | //child::*[local-name()=&quot;MedicalValidationDate&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;RelServProv&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Accredited&quot;] | //child::*[local-name()=&quot;StructuredInfo&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DiagComment&quot;] | //child::*[local-name()=&quot;RefAnalysedSubject&quot;] | //child::*[local-name()=&quot;StatusInvestigation&quot;]))+1"/>
	<xsl:variable name="id-col" select="(($result-col)-1-number(boolean(//child::*[local-name()=&quot;Investigation&quot;]))-number(boolean(//child::*[local-name()=&quot;TextResult&quot;] or //child::*[local-name()=&quot;Interval&quot;] or //child::*[local-name()=&quot;DateResult&quot;] or //child::*[local-name()=&quot;NumResult&quot;])))*number(not(//child::*[local-name()=&quot;RefIdResultItem&quot;] | //child::*[local-name()=&quot;RefInterval&quot;]  | //child::*[local-name()=&quot;InvDate&quot;] | //child::*[local-name()=&quot;StatusChangeDate&quot;] | //child::*[local-name()=&quot;DescrDate&quot;] | //child::*[local-name()=&quot;CounterSignDate&quot;] | //child::*[local-name()=&quot;MedicalValidationDate&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;RelServProv&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Accredited&quot;] | //child::*[local-name()=&quot;StructuredInfo&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DiagComment&quot;] | //child::*[local-name()=&quot;RefAnalysedSubject&quot;] | //child::*[local-name()=&quot;StatusInvestigation&quot;]))+1"/>
	<xsl:variable name="refid-col" select="(($result-col)-1-number(boolean(//child::*[local-name()=&quot;Investigation&quot;]))-number(boolean(//child::*[local-name()=&quot;TextResult&quot;] or //child::*[local-name()=&quot;Interval&quot;] or //child::*[local-name()=&quot;DateResult&quot;] or //child::*[local-name()=&quot;NumResult&quot;]))-number(boolean(//child::*[local-name()=&quot;IdResultItem&quot;])))*number(not(//child::*[local-name()=&quot;RefInterval&quot;]  | //child::*[local-name()=&quot;InvDate&quot;] | //child::*[local-name()=&quot;StatusChangeDate&quot;] | //child::*[local-name()=&quot;DescrDate&quot;] | //child::*[local-name()=&quot;CounterSignDate&quot;] | //child::*[local-name()=&quot;MedicalValidationDate&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;RelServProv&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Accredited&quot;] | //child::*[local-name()=&quot;StructuredInfo&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DiagComment&quot;] | //child::*[local-name()=&quot;RefAnalysedSubject&quot;] | //child::*[local-name()=&quot;StatusInvestigation&quot;]))+1"/>
	<xsl:variable name="refinterval-col" select="(($result-col)-1-number(boolean(//child::*[local-name()=&quot;Investigation&quot;]))-number(boolean(//child::*[local-name()=&quot;TextResult&quot;] or //child::*[local-name()=&quot;Interval&quot;] or //child::*[local-name()=&quot;DateResult&quot;] or //child::*[local-name()=&quot;NumResult&quot;]))-number(boolean(//child::*[local-name()=&quot;IdResultItem&quot;]))-number(boolean(//child::*[local-name()=&quot;RefIdResultItem&quot;])))*number(not(//child::*[local-name()=&quot;InvDate&quot;] | //child::*[local-name()=&quot;StatusChangeDate&quot;] | //child::*[local-name()=&quot;DescrDate&quot;] | //child::*[local-name()=&quot;CounterSignDate&quot;] | //child::*[local-name()=&quot;MedicalValidationDate&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;RelServProv&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Accredited&quot;] | //child::*[local-name()=&quot;StructuredInfo&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DiagComment&quot;] | //child::*[local-name()=&quot;RefAnalysedSubject&quot;] | //child::*[local-name()=&quot;StatusInvestigation&quot;]))+1"/>
	<xsl:variable name="date-col" select="(($result-col)-1-number(boolean(//child::*[local-name()=&quot;Investigation&quot;]))-number(boolean(//child::*[local-name()=&quot;TextResult&quot;] or //child::*[local-name()=&quot;Interval&quot;] or //child::*[local-name()=&quot;DateResult&quot;] or //child::*[local-name()=&quot;NumResult&quot;]))-number(boolean(//child::*[local-name()=&quot;IdResultItem&quot;]))-number(boolean(//child::*[local-name()=&quot;RefIdResultItem&quot;]))-number(boolean(//child::*[local-name()=&quot;RefInterval&quot;])))*number(not(//child::*[local-name()=&quot;DescrDate&quot;] | //child::*[local-name()=&quot;CounterSignDate&quot;] | //child::*[local-name()=&quot;MedicalValidationDate&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;RelServProv&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Accredited&quot;] | //child::*[local-name()=&quot;StructuredInfo&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DiagComment&quot;] | //child::*[local-name()=&quot;RefAnalysedSubject&quot;] | //child::*[local-name()=&quot;StatusInvestigation&quot;]))+1"/>
	<xsl:variable name="relserv-col" select="(($result-col)-1-number(boolean(//child::*[local-name()=&quot;Investigation&quot;]))-number(boolean(//child::*[local-name()=&quot;TextResult&quot;] or //child::*[local-name()=&quot;Interval&quot;] or //child::*[local-name()=&quot;DateResult&quot;] or //child::*[local-name()=&quot;NumResult&quot;]))-number(boolean(//child::*[local-name()=&quot;IdResultItem&quot;]))-number(boolean(//child::*[local-name()=&quot;RefIdResultItem&quot;]))-number(boolean(//child::*[local-name()=&quot;RefInterval&quot;]))-number(boolean(//child::*[local-name()=&quot;InvDate&quot;] or //child::*[local-name()=&quot;StatusChangeDate&quot;] or //child::*[local-name()=&quot;DescrDate&quot;] or //child::*[local-name()=&quot;CounterSignDate&quot;] or //child::*[local-name()=&quot;MedicalValidationDate&quot;])))*number(not(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Accredited&quot;] | //child::*[local-name()=&quot;StructuredInfo&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;] | //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;DiagComment&quot;] | //child::*[local-name()=&quot;RefAnalysedSubject&quot;] | //child::*[local-name()=&quot;StatusInvestigation&quot;]))+1"/>
	<xsl:variable name="tillegg-col" select="($result-col)-number(boolean(//child::*[local-name()=&quot;Investigation&quot;]))-number(boolean(//child::*[local-name()=&quot;TextResult&quot;] or //child::*[local-name()=&quot;Interval&quot;] or //child::*[local-name()=&quot;DateResult&quot;] or //child::*[local-name()=&quot;NumResult&quot;]))-number(boolean(//child::*[local-name()=&quot;IdResultItem&quot;]))-number(boolean(//child::*[local-name()=&quot;RefIdResultItem&quot;]))-number(boolean(//child::*[local-name()=&quot;RefInterval&quot;]))-number(boolean(//child::*[local-name()=&quot;InvDate&quot;] or //child::*[local-name()=&quot;StatusChangeDate&quot;] or //child::*[local-name()=&quot;DescrDate&quot;] or //child::*[local-name()=&quot;CounterSignDate&quot;] or //child::*[local-name()=&quot;MedicalValidationDate&quot;]))-number(boolean(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;RelServProv&quot;]))"/>
	<!-- Meldingsstart -->
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Svarrapport</title>
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
		<xsl:for-each select="child::*[local-name()=&quot;ServReport&quot;]">
			<!-- utelater meldingsid og kommunikasjonsinformasjon -->
			<xsl:call-template name="Header"/>
			<xsl:call-template name="ResultBody"/>
			<xsl:call-template name="Footer"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Header - avsender og mottaker-informasjon -->
	<xsl:template name="Header">
		<div class="No-line-top">
			<div class="No-line-header">
				<div class="No-line-headerContent">
					<div class="No-line-caption">Avsender &#160;</div>
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
					<xsl:when test="child::*[local-name()=&quot;Animal&quot;]">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Undersøkelsesdyr&#160;</div>
							<div class="No-line-content">
								<xsl:for-each select="child::*[local-name()=&quot;Animal&quot;]">
									<xsl:call-template name="AnimalHode"/>
								</xsl:for-each>
							</div>
						</div>
					</xsl:when>
					<xsl:when test="child::*[local-name()=&quot;Material&quot;]">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Materiale&#160;</div>
							<div class="No-line-content">
								<xsl:for-each select="child::*[local-name()=&quot;Material&quot;]">
									<xsl:call-template name="MaterialHode"/>
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
					<div class="No-line-caption">Mottaker&#160;</div>
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
	<xsl:template name="ServProviderHode">
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCPHode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="RequesterHode">
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCPHode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="PatientHode">
		<div>
			<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>&#160;
			<b>
				<xsl:for-each select="child::*[local-name()=&quot;TypeOffId&quot;]">
					<xsl:call-template name="k-8116"/>
				</xsl:for-each>:&#160;</b>
			<xsl:value-of select="child::*[local-name()=&quot;OffId&quot;]"/>&#160;
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
	<xsl:template name="AnimalHode">
		<div>
			<xsl:if test="child::*[local-name()=&quot;Name&quot;]"><b>Navn</b>:&#160;<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>&#160;</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Species&quot;]"><b>Art</b>:&#160;<xsl:value-of select="child::*[local-name()=&quot;Species&quot;]"/>&#160;</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;NameOwner&quot;]"><b>Eier</b>:&#160;<xsl:value-of select="child::*[local-name()=&quot;NameOwner&quot;]"/>&#160;</xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="MaterialHode">
		<div>
			<xsl:if test="child::*[local-name()=&quot;Name&quot;]"><b>Beskrivelse</b>:&#160;<xsl:value-of select="child::*[local-name()=&quot;InvMaterial&quot;]"/>&#160;</xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="HCPersonHode">
		<div>
			<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
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
			<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
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
			</xsl:for-each>&#160;<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
		</div>
	</xsl:template>
	<xsl:template name="CopyDestHode">
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCPHode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="AddressHode">
		<xsl:if test="child::*[local-name()=&quot;Type&quot;] and (child::*[local-name()=&quot;StreetAdr&quot;] or child::*[local-name()=&quot;PostalCode&quot;] or child::*[local-name()=&quot;City&quot;] or child::*[local-name()=&quot;CityDistr&quot;])">
			<div class="NoPrint">&#160;<b>
				<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]">
					<xsl:call-template name="k-3401"/>
				</xsl:for-each>:&#160;</b>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;StreetAdr&quot;]">
			<div>
				<xsl:value-of select="child::*[local-name()=&quot;StreetAdr&quot;]"/>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;PostalCode&quot;] or child::*[local-name()=&quot;City&quot;]">
			<xsl:if test="child::*[local-name()=&quot;StreetAdr&quot;]">
				<div class="NoPrint">,</div>
			</xsl:if>
			<div>
				<xsl:value-of select="child::*[local-name()=&quot;PostalCode&quot;]"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;City&quot;]"/>
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()=&quot;CityDistr&quot;]">
			<div class="NoPrint">,</div>
			<div>
				<xsl:call-template name="k-3403"/>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;County&quot;]">
			<div class="NoPrint">,</div>
			<div>
				<xsl:call-template name="k-3402"/>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Country&quot;]">
			<div class="NoPrint">,</div>
			<div>
				<xsl:call-template name="k-9043"/>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;TeleAddress&quot;]">
			<div class="NoPrint">&#160;</div>
			<xsl:call-template name="TeleAddressHode"/>
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
	<!-- Hoveddokument -->
	<xsl:template name="ResultBody">
		<div class="{$stil}">
			<xsl:variable name="position" select="position()"/>
			<xsl:variable name="color">
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;ServType&quot;][@V='M' or @V='C' or @V='O']">red</xsl:when>
					<xsl:otherwise>black</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- Tabell for svarrapport -->
			<h1>Svarrapport
				<xsl:for-each select="child::*[local-name()=&quot;MsgDescr&quot;]">
					<xsl:call-template name="k-8202"/>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()=&quot;ServType&quot;]">&#160;-
					<font color="{$color}"><xsl:call-template name="k-7309"/></font>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()=&quot;Status&quot;]">&#160;-
					<xsl:call-template name="k-7306"/>
				</xsl:for-each>
			</h1>
			<xsl:call-template name="FellesMeny">
				<xsl:with-param name="position" select="position()"/>
			</xsl:call-template>
			<br/>
			<xsl:variable name="id1">
				<xsl:value-of select="concat('ServReport',$position)"/>
			</xsl:variable>
			<h2 id="{$id1}">Meldingsinformasjon</h2>
			<table>
				<tbody>
					<xsl:call-template name="ServReport">
						<xsl:with-param name="col" select="$std-col"/>
					</xsl:call-template>
				</tbody>
			</table>
			<!-- Tabell for analysert objekt -->
			<xsl:if test="//child::*[local-name()=&quot;AnalysedSubject&quot;]">
				<xsl:variable name="id2">
					<xsl:value-of select="concat('AnalysedSubject',$position)"/>
				</xsl:variable>
				<h2 id="{$id2}">Analysert materiale</h2>
				<table>
					<tbody>
						<xsl:for-each select="child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;AnalysedSubject&quot;] | child::*[local-name()=&quot;Animal&quot;]/child::*[local-name()=&quot;AnalysedSubject&quot;] | child::*[local-name()=&quot;Material&quot;]/child::*[local-name()=&quot;AnalysedSubject&quot;]">
							<xsl:call-template name="AnalysedSubject">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="pos" select="position()"/>
								<xsl:with-param name="last" select="last()"/>
							</xsl:call-template>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Tabell for Undersøkelsesresultat -->
			<xsl:if test="//child::*[local-name()=&quot;ResultItem&quot;]">
				<xsl:variable name="id3">
					<xsl:value-of select="concat('ResultItem',$position)"/>
				</xsl:variable>
				<h2 id="{$id3}">Undersøkelsesresultat</h2> <!-- Denne tabellen kan bli tom om alle resultatene er merket med historikk. Antar det aldri skjer. -->
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;ResultItem&quot;][(child::*[local-name()=&quot;ServType&quot;]/@V != 'H' or not(child::*[local-name()=&quot;ServType&quot;]/@V)) and child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;ServType&quot;]/@V != 'H' or not(child::*[local-name()=&quot;ServType&quot;]/@V)]] | //child::*[local-name()=&quot;ResultItem&quot;][(child::*[local-name()=&quot;ServType&quot;]/@V != 'H' or not(child::*[local-name()=&quot;ServType&quot;]/@V)) and not(../child::*[local-name()=&quot;ServType&quot;]/@V = 'H') and not(child::*[local-name()=&quot;ResultItem&quot;])]"> <!-- Alle hovedsvar som ikke er merket med historikk som har minst et delsvar som ikke er merket historikk samt alle hovedsvar/delsvar som ikke er merket med historikk hvor forelder ikke er merket med historikk og som ikke selv har delsvar-->
							<xsl:variable name="slaaSammen"><!--  Variabel som er 'true' om hovedsvaret og dets første delsvar ikke har felles tabellelementer og dermed kan slås sammen - 'false' ellers.-->
								<xsl:variable name="overlapp">
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Investigation&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V='GR'">
										<xsl:if test="child::*[local-name()=&quot;Investigation&quot;] or child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V='GR'">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;TextResult&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Interval&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;DateResult&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;NumResult&quot;]">
										<xsl:if test="child::*[local-name()=&quot;TextResult&quot;] or child::*[local-name()=&quot;Interval&quot;] or child::*[local-name()=&quot;DateResult&quot;] or child::*[local-name()=&quot;NumResult&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;IdResultItem&quot;]">
										<xsl:if test="child::*[local-name()=&quot;IdResultItem&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;RefIdResultItem&quot;]">RelServProv
										<xsl:if test="child::*[local-name()=&quot;RefIdResultItem&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;RefInterval&quot;]">
										<xsl:if test="child::*[local-name()=&quot;RefInterval&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;InvDate&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;StatusChangeDate&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;DescrDate&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;CounterSignDate&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;MedicalValidationDate&quot;]">
										<xsl:if test="child::*[local-name()=&quot;InvDate&quot;] or child::*[local-name()=&quot;StatusChangeDate&quot;] or child::*[local-name()=&quot;DescrDate&quot;] or child::*[local-name()=&quot;CounterSignDate&quot;] or child::*[local-name()=&quot;MedicalValidationDate&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;RelServProv&quot;]">
										<xsl:if test="child::*[local-name()=&quot;RelServProv&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Accredited&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;StructuredInfo&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;DiagComment&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;RefAnalysedSubject&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;StatusInvestigation&quot;]">
										<xsl:if test="child::*[local-name()=&quot;Accredited&quot;] or child::*[local-name()=&quot;StructuredInfo&quot;] or child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;DiagComment&quot;] or child::*[local-name()=&quot;RefAnalysedSubject&quot;] or child::*[local-name()=&quot;StatusInvestigation&quot;]">Ja</xsl:if>
									</xsl:if>
								</xsl:variable>
								<xsl:choose>
									  <xsl:when test="child::*[local-name()=&quot;ResultItem&quot;] and not(contains($overlapp,'Ja'))">true</xsl:when> 
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="forsteDelsvarSlaattSammen"><!-- Variabel som er 'true' om nåværende node er første delsvar som er slått sammen med sitt hovedsvar - 'false' ellers -->
								<xsl:variable name="overlappForelder">
									<xsl:if test="../child::*[local-name()=&quot;Investigation&quot;] or ../child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V='GR'">
										<xsl:if test="child::*[local-name()=&quot;Investigation&quot;] or child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V='GR'">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;TextResult&quot;] or ../child::*[local-name()=&quot;Interval&quot;] or ../child::*[local-name()=&quot;DateResult&quot;] or ../child::*[local-name()=&quot;NumResult&quot;]">
										<xsl:if test="child::*[local-name()=&quot;TextResult&quot;] or child::*[local-name()=&quot;Interval&quot;] or child::*[local-name()=&quot;DateResult&quot;] or child::*[local-name()=&quot;NumResult&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;IdResultItem&quot;]">
										<xsl:if test="child::*[local-name()=&quot;IdResultItem&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;RefIdResultItem&quot;]">RelServProv
										<xsl:if test="child::*[local-name()=&quot;RefIdResultItem&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;RefInterval&quot;]">
										<xsl:if test="child::*[local-name()=&quot;RefInterval&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;InvDate&quot;] or ../child::*[local-name()=&quot;StatusChangeDate&quot;] or ../child::*[local-name()=&quot;DescrDate&quot;] or ../child::*[local-name()=&quot;CounterSignDate&quot;] or ../child::*[local-name()=&quot;MedicalValidationDate&quot;]">
										<xsl:if test="child::*[local-name()=&quot;InvDate&quot;] or child::*[local-name()=&quot;StatusChangeDate&quot;] or child::*[local-name()=&quot;DescrDate&quot;] or child::*[local-name()=&quot;CounterSignDate&quot;] or child::*[local-name()=&quot;MedicalValidationDate&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;RelServProv&quot;]">
										<xsl:if test="child::*[local-name()=&quot;RelServProv&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;Accredited&quot;] or ../child::*[local-name()=&quot;StructuredInfo&quot;] or ../child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or ../child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or ../child::*[local-name()=&quot;Comment&quot;] or ../child::*[local-name()=&quot;DiagComment&quot;] or ../child::*[local-name()=&quot;RefAnalysedSubject&quot;] or ../child::*[local-name()=&quot;StatusInvestigation&quot;]">
										<xsl:if test="child::*[local-name()=&quot;Accredited&quot;] or child::*[local-name()=&quot;StructuredInfo&quot;] or child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;DiagComment&quot;] or child::*[local-name()=&quot;RefAnalysedSubject&quot;] or child::*[local-name()=&quot;StatusInvestigation&quot;]">Ja</xsl:if>
									</xsl:if>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="local-name(..)=&quot;ResultItem&quot; and not(preceding-sibling::*[1][self::*[local-name()=&quot;ResultItem&quot;]]) and not(contains($overlappForelder,'Ja'))">true</xsl:when> 
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="position()=1">
								<xsl:call-template name="skrivUtUndersokelseOverskrift"/>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="$forsteDelsvarSlaattSammen='true'"></xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="ResultItem">
										<xsl:with-param name="slaaSammen" select="$slaaSammen"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Tabell for Historiske Undersøkelsesresultat -->
			<xsl:if test="//child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;ServType&quot;]/@V = 'H']">
				<xsl:variable name="id3">
					<xsl:value-of select="concat('ResultItem',$position)"/>
				</xsl:variable>
				<h2 id="{$id3}">Undersøkelsesresultat&#160;(<font color="red">historikk</font>)</h2>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;ServType&quot;]/@V = 'H'] | //child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;ServType&quot;]/@V = 'H']/child::*[local-name()=&quot;ResultItem&quot;] | //child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;ServType&quot;]/@V = 'H']]"> <!-- Alle hovedsvar/delsvar merket med historikk, alle delsvar av hovedsvar merket med historikk, samt alle hovedsvar som har delsvar merket med historikk -->
							<xsl:variable name="slaaSammen"><!--  Variabel som er 'true' om hovedsvaret og dets første delsvar ikke har felles tabellelementer og dermed kan slås sammen - 'false' ellers.-->
								<xsl:variable name="overlapp">
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Investigation&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V='GR'">
										<xsl:if test="child::*[local-name()=&quot;Investigation&quot;] or child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V='GR'">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;TextResult&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Interval&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;DateResult&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;NumResult&quot;]">
										<xsl:if test="child::*[local-name()=&quot;TextResult&quot;] or child::*[local-name()=&quot;Interval&quot;] or child::*[local-name()=&quot;DateResult&quot;] or child::*[local-name()=&quot;NumResult&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;IdResultItem&quot;]">
										<xsl:if test="child::*[local-name()=&quot;IdResultItem&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;RefIdResultItem&quot;]">RelServProv
										<xsl:if test="child::*[local-name()=&quot;RefIdResultItem&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;RefInterval&quot;]">
										<xsl:if test="child::*[local-name()=&quot;RefInterval&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;InvDate&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;StatusChangeDate&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;DescrDate&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;CounterSignDate&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;MedicalValidationDate&quot;]">
										<xsl:if test="child::*[local-name()=&quot;InvDate&quot;] or child::*[local-name()=&quot;StatusChangeDate&quot;] or child::*[local-name()=&quot;DescrDate&quot;] or child::*[local-name()=&quot;CounterSignDate&quot;] or child::*[local-name()=&quot;MedicalValidationDate&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;RelServProv&quot;]">
										<xsl:if test="child::*[local-name()=&quot;RelServProv&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Accredited&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;StructuredInfo&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;DiagComment&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;RefAnalysedSubject&quot;] or child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;StatusInvestigation&quot;]">
										<xsl:if test="child::*[local-name()=&quot;Accredited&quot;] or child::*[local-name()=&quot;StructuredInfo&quot;] or child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;DiagComment&quot;] or child::*[local-name()=&quot;RefAnalysedSubject&quot;] or child::*[local-name()=&quot;StatusInvestigation&quot;]">Ja</xsl:if>
									</xsl:if>
								</xsl:variable>
								<xsl:choose>
									  <xsl:when test="child::*[local-name()=&quot;ResultItem&quot;] and not(contains($overlapp,'Ja'))">true</xsl:when> 
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="forsteDelsvarSlaattSammen"><!-- Variabel som er 'true' om nåværende node er første delsvar som er slått sammen med sitt hovedsvar - 'false' ellers -->
								<xsl:variable name="overlappForelder">
									<xsl:if test="../child::*[local-name()=&quot;Investigation&quot;] or ../child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V='GR'">
										<xsl:if test="child::*[local-name()=&quot;Investigation&quot;] or child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V='GR'">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;TextResult&quot;] or ../child::*[local-name()=&quot;Interval&quot;] or ../child::*[local-name()=&quot;DateResult&quot;] or ../child::*[local-name()=&quot;NumResult&quot;]">
										<xsl:if test="child::*[local-name()=&quot;TextResult&quot;] or child::*[local-name()=&quot;Interval&quot;] or child::*[local-name()=&quot;DateResult&quot;] or child::*[local-name()=&quot;NumResult&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;IdResultItem&quot;]">
										<xsl:if test="child::*[local-name()=&quot;IdResultItem&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;RefIdResultItem&quot;]">RelServProv
										<xsl:if test="child::*[local-name()=&quot;RefIdResultItem&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;RefInterval&quot;]">
										<xsl:if test="child::*[local-name()=&quot;RefInterval&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;InvDate&quot;] or ../child::*[local-name()=&quot;StatusChangeDate&quot;] or ../child::*[local-name()=&quot;DescrDate&quot;] or ../child::*[local-name()=&quot;CounterSignDate&quot;] or ../child::*[local-name()=&quot;MedicalValidationDate&quot;]">
										<xsl:if test="child::*[local-name()=&quot;InvDate&quot;] or child::*[local-name()=&quot;StatusChangeDate&quot;] or child::*[local-name()=&quot;DescrDate&quot;] or child::*[local-name()=&quot;CounterSignDate&quot;] or child::*[local-name()=&quot;MedicalValidationDate&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;RelServProv&quot;]">
										<xsl:if test="child::*[local-name()=&quot;RelServProv&quot;]">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()=&quot;Accredited&quot;] or ../child::*[local-name()=&quot;StructuredInfo&quot;] or ../child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or ../child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or ../child::*[local-name()=&quot;Comment&quot;] or ../child::*[local-name()=&quot;DiagComment&quot;] or ../child::*[local-name()=&quot;RefAnalysedSubject&quot;] or ../child::*[local-name()=&quot;StatusInvestigation&quot;]">
										<xsl:if test="child::*[local-name()=&quot;Accredited&quot;] or child::*[local-name()=&quot;StructuredInfo&quot;] or child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;DiagComment&quot;] or child::*[local-name()=&quot;RefAnalysedSubject&quot;] or child::*[local-name()=&quot;StatusInvestigation&quot;]">Ja</xsl:if>
									</xsl:if>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="local-name(..)='ResultItem' and not(preceding-sibling::*[1][self::*[local-name()=&quot;ResultItem&quot;]]) and not(contains($overlappForelder,'Ja'))">true</xsl:when> 
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="position()=1">
								<xsl:call-template name="skrivUtUndersokelseOverskrift"/>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="$forsteDelsvarSlaattSammen='true'"></xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="ResultItem">
										<xsl:with-param name="slaaSammen" select="$slaaSammen"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Tabell for Strukturert resultat -->
			<xsl:if test="//child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]]">
				<xsl:variable name="id03">
					<xsl:value-of select="concat('StructuredInfo',$position)"/>
				</xsl:variable>
				<xsl:for-each select="//child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]]">
					<h2 id="{$id03}">Strukturert resultat
						<xsl:if test="last()!=1">
							<xsl:value-of select="count(//child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]])-count(following-sibling::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]])-count(parent::*[local-name()=&quot;ResultItem&quot;]/following-sibling::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]])-count(child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]])"/>
						</xsl:if>
					</h2>
					<xsl:call-template name="ResultItemStructuredInfo"/>
				</xsl:for-each>
			</xsl:if>
			<!-- Tabell for oprinnelig rekvisisjon -->
			<xsl:for-each select="child::*[local-name()=&quot;ServReq&quot;]">
				<xsl:variable name="id4">
					<xsl:value-of select="concat('ServReq',$position)"/>
				</xsl:variable>
				<h2 id="{$id4}">Opprinnelig rekvisisjon
					<xsl:for-each select="child::*[local-name()=&quot;MsgDescr&quot;]">
						<xsl:call-template name="k-8202"/>
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()=&quot;ServType&quot;]">&#160;-
						<xsl:call-template name="k-7309"/>
					</xsl:for-each>
				</h2>
				<table>
					<tbody>
						<xsl:call-template name="ServReq">
							<xsl:with-param name="col" select="$std-col"/>
						</xsl:call-template>
					</tbody>
				</table>
			</xsl:for-each>
			<!-- Tabell for øvrig pasientinformasjon -->
			<xsl:for-each select="child::*[local-name()=&quot;Patient&quot;]">
				<xsl:if test="child::*[local-name()=&quot;BasisForHealthServices&quot;] or child::*[local-name()=&quot;Sex&quot;] or child::*[local-name()=&quot;DateOfBirth&quot;] or child::*[local-name()=&quot;DateOfDeath&quot;] or child::*[local-name()=&quot;AdmLocation&quot;] or child::*[local-name()=&quot;AdditionalId&quot;] or child::*[local-name()=&quot;InfItem&quot;] or child::*[local-name()=&quot;Patient&quot;]">
					<xsl:variable name="id5">
						<xsl:value-of select="concat('Patient',$position)"/>
					</xsl:variable>
					<h2 id="{$id5}">Pasient</h2>
					<table>
						<tbody>
							<xsl:call-template name="Patient">
								<xsl:with-param name="col" select="$std-col"/>
							</xsl:call-template>
						</tbody>
					</table>
				</xsl:if>
			</xsl:for-each>
			<!-- Tabell for øvrig informasjon om undersøkelsesobjekt: dyr -->
			<xsl:for-each select="child::*[local-name()=&quot;Animal&quot;]">
				<xsl:if test="child::*[local-name()=&quot;Sex&quot;] or child::*[local-name()=&quot;Animal&quot;]">
					<xsl:variable name="id6">
						<xsl:value-of select="concat('Animal',$position)"/>
					</xsl:variable>
					<h2 id="{$id6}">Undersøkelsesdyr</h2>
					<table>
						<tbody>
							<xsl:call-template name="Animal">
								<xsl:with-param name="col" select="$std-col"/>
							</xsl:call-template>
						</tbody>
					</table>
				</xsl:if>
			</xsl:for-each>
			<!-- Tabell for alle tilknyttede helsetjenesteenheter -->
			<xsl:variable name="id7">
				<xsl:value-of select="concat('HCP',$position)"/>
			</xsl:variable>
			<h2 id="{$id7}">Helsetjenesteenheter</h2>
			<table>
				<tbody>
					<xsl:for-each select="child::*[local-name()=&quot;ServProvider&quot;] | child::*[local-name()=&quot;Requester&quot;] | child::*[local-name()=&quot;PaymentResponsible&quot;] | child::*[local-name()=&quot;CopyDest&quot;] | child::*[local-name()=&quot;RelServProv&quot;] | .//child::*[local-name()=&quot;RelServProv&quot;][descendant::*[local-name()=&quot;Id&quot;]] | .//child::*[local-name()=&quot;ResponsibleHcp&quot;] | child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;AdmLocation&quot;]">
						<xsl:variable name="historikk">
							<xsl:choose>
								<xsl:when test="ancestor::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;ServType&quot;]/@V='H']">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="local-name()=&quot;ServProvider&quot;">
							<xsl:call-template name="ServProvider">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()=&quot;Requester&quot;">
							<xsl:call-template name="Requester">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()=&quot;PaymentResponsible&quot;">
							<xsl:call-template name="PaymentResponsible">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()=&quot;CopyDest&quot;">
							<xsl:call-template name="CopyDest">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()=&quot;RelServProv&quot;">
							<xsl:call-template name="RelServProv">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()=&quot;ResponsibleHcp&quot;">
							<xsl:call-template name="ResponsibleHcp">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()=&quot;AdmLocation&quot;">
							<xsl:call-template name="AdmLocation">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
				</tbody>
			</table>
			<!-- Tabell for referert dokument -->
			<xsl:if test="child::*[local-name()=&quot;RefDoc&quot;]">
				<xsl:variable name="id8">
					<xsl:value-of select="concat('RefDoc',$position)"/>
				</xsl:variable>
				<h2 id="{$id8}">Referert dokument</h2>
				<table>
					<tbody>
						<xsl:for-each select="child::*[local-name()=&quot;RefDoc&quot;]">
							<xsl:call-template name="RefDoc">
								<xsl:with-param name="col" select="$std-col"/>
							</xsl:call-template>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
		</div>
	</xsl:template>
	<!-- Meldingshodet - Dokumentopplysninger -->
	<xsl:template name="Footer">
		<div class="{$stil}">
			<h2 style="margin-top:0px;">Dokumentinformasjon</h2>
			<table>
				<tbody>
					<tr>
						<th>Melding sendt</th>
						<td width="{$std-td}px">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;GenDate&quot;]/@V"/>
							</xsl:call-template>
						</td>
						<th>Tjenesteyters id</th>
						<td width="{$std-td}px">
							<xsl:value-of select="child::*[local-name()=&quot;ServProvId&quot;]"/>
						</td>
						<th>Meldingsid</th>
						<td>
							<xsl:value-of select="../child::*[local-name()=&quot;MsgId&quot;]"/>
						</td>
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
		<div id="FellesMeny" class="FellesMeny">
			<ul>
				<li>
					<xsl:variable name="temp1" select="concat('ServReport',$position)"/>
					<a href="#{$temp1}">Meldingsinformasjon</a>
				</li>
				<xsl:if test=".//child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;AnalysedSubject&quot;] or .//child::*[local-name()=&quot;Animal&quot;]/child::*[local-name()=&quot;AnalysedSubject&quot;] or .//child::*[local-name()=&quot;Material&quot;]/child::*[local-name()=&quot;AnalysedSubject&quot;]">
					<li>
						<xsl:variable name="temp2" select="concat('AnalysedSubject',$position)"/>
						<a href="#{$temp2}">Analysert materiale</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()=&quot;ResultItem&quot;]">
					<li>
						<xsl:variable name="temp3" select="concat('ResultItem',$position)"/>
						<a href="#{$temp3}">Undersøkelsesresultat</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]]">
					<li>
						<xsl:variable name="temp03" select="concat('StructuredInfo',$position)"/>
						<a href="#{$temp03}">Strukturert resultat</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()=&quot;ServReq&quot;]">
					<li>
						<xsl:variable name="temp4" select="concat('ServReq',$position)"/>
						<a href="#{$temp4}">Opprinnelig rekvisisjon</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;BasisForHealthServices&quot;] or .//child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;Sex&quot;] or .//child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;DateOfBirth&quot;] or .//child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;DateOfDeath&quot;] or .//child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;AdmLocation&quot;] or .//child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;AdditionalId&quot;] or .//child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;InfItem&quot;] or .//child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;Patient&quot;]">
					<li>
						<xsl:variable name="temp5" select="concat('Patient',$position)"/>
						<a href="#{$temp5}">Pasient</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()=&quot;Animal&quot;]/child::*[local-name()=&quot;Sex&quot;] or .//child::*[local-name()=&quot;Animal&quot;]/child::*[local-name()=&quot;Animal&quot;]">
					<li>
						<xsl:variable name="temp6" select="concat('Animal',$position)"/>
						<a href="#{$temp6}">Undersøkelsesdyr</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()=&quot;ServProvider&quot;] | .//child::*[local-name()=&quot;Requester&quot;] | .//child::*[local-name()=&quot;PaymentResponsible&quot;] | .//child::*[local-name()=&quot;CopyDest&quot;] | child::*[local-name()=&quot;RelServProv&quot;] | .//child::*[local-name()=&quot;RelServProv&quot;][descendant::*[local-name()=&quot;Id&quot;]] | .//child::*[local-name()=&quot;ResponsibleHcp&quot;] | .//child::*[local-name()=&quot;Patient&quot;]/child::*[local-name()=&quot;AdmLocation&quot;]">
					<li>
						<xsl:variable name="temp7" select="concat('HCP',$position)"/>
						<a href="#{$temp7}">Helsetjenesteenheter</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()=&quot;RefDoc&quot;]">
					<li>
						<xsl:variable name="temp8" select="concat('RefDoc',$position)"/>
						<a href="#{$temp8}">Vedlegg</a>
					</li>
				</xsl:if>
			</ul>
		</div>
	</xsl:template>
	<!-- Visning av Svarrapport -->
	<xsl:template name="ServReport">
		<xsl:param name="col"/>
		<tr>
			<th>Utstedt-dato</th>
			<td width="{((($col)-2)*number(not(child::*[local-name()=&quot;ApprDate&quot;] | child::*[local-name()=&quot;CancellationCode&quot;]))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()=&quot;ApprDate&quot;] | child::*[local-name()=&quot;CancellationCode&quot;]))+1}">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;IssueDate&quot;]/@V"/>
				</xsl:call-template>
			</td>
			<xsl:if test="child::*[local-name()=&quot;ApprDate&quot;]">
				<th>Godkjent-dato</th>
				<td width="{((($col)-2-count(child::*[local-name()=&quot;IssueDate&quot;])*2)*number(not(child::*[local-name()=&quot;CancellationCode&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;IssueDate&quot;])*2)*number(not(child::*[local-name()=&quot;CancellationCode&quot;]))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;ApprDate&quot;]/@V"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;CancellationCode&quot;]">
				<th>Årsak til kansellering</th>
				<td colspan="{($col)-1-count(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;ApprDate&quot;])*2}">
					<xsl:for-each select="child::*[local-name()=&quot;CancellationCode&quot;]">
						<xsl:call-template name="k-dummy"/>
					</xsl:for-each>
				</td>
			</xsl:if>
		</tr>
		<xsl:if test="child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;CodedComment&quot;]">
			<tr>
				<th>Kommentar til svarrapporten</th>
				<td colspan="{($col)-1}">
					<xsl:for-each select="child::*[local-name()=&quot;Comment&quot;]">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="."/>
						</xsl:call-template>&#160;
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()=&quot;CodedComment&quot;][contains(@S,'8272')]">
						<xsl:if test="position()=1">
							<b>Anbefaler ny undersøkelse:&#160;</b>
						</xsl:if>
						<xsl:call-template name="k-8272"/>
						<xsl:choose>
							<xsl:when test="position()!=last()">,&#160;</xsl:when>
							<xsl:otherwise>&#160;</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()=&quot;CodedComment&quot;][contains(@S,'8273')]">
						<xsl:if test="position()=1">
							<b>Hastegrad:&#160;</b>
						</xsl:if>
						<xsl:call-template name="k-8273"/>&#160;
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()=&quot;CodedComment&quot;][not(contains(@S,'8272')) and not(contains(@S,'8273'))]">
						<xsl:choose>
							<xsl:when test="contains(@S,'8269')">
								<xsl:call-template name="k-8269"/>&#160;
							</xsl:when>
							<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Opprinnelig rekvisisjon -->
	<xsl:template name="ServReq">
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()=&quot;IssueDate&quot;] or child::*[local-name()=&quot;ReceiptDate&quot;] or child::*[local-name()=&quot;RequestedPrioReport&quot;] or child::*[local-name()=&quot;PaymentCat&quot;] or child::*[local-name()=&quot;Reservation&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;IssueDate&quot;]">
					<th>Utstedt-dato</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()=&quot;ReceiptDate&quot;] | child::*[local-name()=&quot;RequestedPrioReport&quot;] | child::*[local-name()=&quot;PaymentCat&quot;] | child::*[local-name()=&quot;Reservation&quot;]))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()=&quot;ReceiptDate&quot;] | child::*[local-name()=&quot;RequestedPrioReport&quot;] | child::*[local-name()=&quot;PaymentCat&quot;] | child::*[local-name()=&quot;Reservation&quot;]))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;IssueDate&quot;]/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;ReceiptDate&quot;]">
					<th>Mottatt-dato</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;IssueDate&quot;])*2)*number(not(child::*[local-name()=&quot;RequestedPrioReport&quot;] | child::*[local-name()=&quot;PaymentCat&quot;] | child::*[local-name()=&quot;Reservation&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;IssueDate&quot;])*2)*number(not(child::*[local-name()=&quot;RequestedPrioReport&quot;] | child::*[local-name()=&quot;PaymentCat&quot;] | child::*[local-name()=&quot;Reservation&quot;]))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;ReceiptDate&quot;]/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;RequestedPrioReport&quot;]">
					<th>Ønsket prioritet</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;ReceiptDate&quot;])*2)*number(not(child::*[local-name()=&quot;PaymentCat&quot;] | child::*[local-name()=&quot;Reservation&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;ReceiptDate&quot;])*2)*number(not(child::*[local-name()=&quot;PaymentCat&quot;] | child::*[local-name()=&quot;Reservation&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;RequestedPrioReport&quot;]">
							<xsl:call-template name="k-7303"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;PaymentCat&quot;]">
					<th>Betalingskategori</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;ReceiptDate&quot;] | child::*[local-name()=&quot;RequestedPrioReport&quot;])*2)*number(not(child::*[local-name()=&quot;Reservation&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;ReceiptDate&quot;] | child::*[local-name()=&quot;RequestedPrioReport&quot;])*2)*number(not(child::*[local-name()=&quot;Reservation&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;PaymentCat&quot;]">
							<xsl:call-template name="k-4101"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Reservation&quot;]">
					<th>Pasientens reservasjoner</th>
					<td colspan="{($col)-1-count(child::*[local-name()=&quot;IssueDate&quot;] | child::*[local-name()=&quot;ReceiptDate&quot;] | child::*[local-name()=&quot;RequestedPrioReport&quot;] | child::*[local-name()=&quot;PaymentCat&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;Reservation&quot;]">
							<div>
								<xsl:call-template name="k-3108"/>
							</div>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;ReqComment&quot;]">
			<tr>
				<th>Rekvirentens kommentar</th>
				<td colspan="{($col)-1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;ReqComment&quot;]"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;ReasonAsText&quot;]">
			<tr>
				<th colspan="{$col}" class="h3">Begrunnelser</th>
			</tr>
			<xsl:for-each select="child::*[local-name()=&quot;ReasonAsText&quot;]">
				<xsl:call-template name="ReasonAsText">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Comment&quot;]">
			<tr>
				<th colspan="{$col}" class="h3">Kommentarer</th>
			</tr>
			<xsl:for-each select="child::*[local-name()=&quot;Comment&quot;]">
				<xsl:call-template name="Comment">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Kommentar til rekvisisjon -->
	<xsl:template name="Comment">
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()=&quot;Heading&quot;] or child::*[local-name()=&quot;TextResultValue&quot;] or child::*[local-name()=&quot;TextCode&quot;]">
			<tr>
				<th>
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;Heading&quot;]">
							<xsl:for-each select="child::*[local-name()=&quot;Heading&quot;]">
								<xsl:call-template name="k-8234"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="contains(child::*[local-name()=&quot;TextCode&quot;]/@S,'8274')">Anbefaling om supplerende undersøkelse</xsl:when>
						<xsl:otherwise>Generell</xsl:otherwise>
					</xsl:choose>
				</th>
				<td colspan="{($col)-1}">
					<xsl:if test="child::*[local-name()=&quot;TextResultValue&quot;]">
						<div><xsl:value-of select="child::*[local-name()=&quot;TextResultValue&quot;]"/></div>
					</xsl:if>
					<xsl:for-each select="child::*[local-name()=&quot;TextCode&quot;]">
						<xsl:choose>
							<xsl:when test="contains(@S,'8274')">
								<xsl:call-template name="k-8274"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="k-dummy"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Begrunnelse for rekvisisjon -->
	<xsl:template name="ReasonAsText">
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()=&quot;Heading&quot;] or child::*[local-name()=&quot;TextResultValue&quot;]">
			<tr>
				<th>
					<xsl:for-each select="child::*[local-name()=&quot;Heading&quot;]">
						<xsl:call-template name="k-8231"/>
					</xsl:for-each>
				</th>
				<td colspan="{($col)-1}">
					<xsl:for-each select="child::*[local-name()=&quot;TextResultValue&quot;]">
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
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Øvrig pasientinformasjon -->
	<xsl:template name="Patient">
		<xsl:param name="col"/>
		<tr>
			<th>Navn&#160;<xsl:if test="child::*[local-name()=&quot;Relation&quot;] and local-name(..)='Patient'">-&#160;relasjon:&#160;<xsl:for-each select="child::*[local-name()=&quot;Relation&quot;]"><xsl:call-template name="k-8238"/></xsl:for-each></xsl:if></th>
			<td width="{$std-td}px">
				<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
			</td>
			<th>
				<xsl:for-each select="child::*[local-name()=&quot;TypeOffId&quot;]">
					<xsl:call-template name="k-8116"/>
				</xsl:for-each>
			</th>
			<td width="{((($col)-2-count(child::*[local-name()=&quot;Name&quot;])*2)*number(not(child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;Name&quot;])*2)*number(not(child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;]))+1}">
				<xsl:value-of select="child::*[local-name()=&quot;OffId&quot;]"/>
			</td>
			<xsl:if test="child::*[local-name()=&quot;Sex&quot;]">
				<th>Kjønn</th>
				<td width="{((($col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;])*2)*number(not(child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;])*2)*number(not(child::*[local-name()=&quot;DateOfBirth&quot;] | child::*[local-name()=&quot;DateOfDeath&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;Sex&quot;]">
						<xsl:call-template name="k-3101"/>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;DateOfBirth&quot;]">
				<th>Fødselsdato</th>
				<td width="{((($col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;])*2)*number(not(child::*[local-name()=&quot;DateOfDeath&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;])*2)*number(not(child::*[local-name()=&quot;DateOfDeath&quot;]))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;DateOfBirth&quot;]/@V"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;DateOfDeath&quot;]">
				<th>Dødsdato</th>
				<td colspan="{(($col)-1-count(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;OffId&quot;] | child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;DateOfBirth&quot;])*2)}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;DateOfDeath&quot;]/@V"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;Address&quot;]">
			<xsl:variable name="antall-tel" select="count(child::*[local-name()=&quot;TeleAddress&quot;])"/>
			<tr>
				<xsl:call-template name="TeleAddress">
					<xsl:with-param name="col" select="(($col)-1)*number(not(child::*[local-name()=&quot;Type&quot;] and (child::*[local-name()=&quot;PostalCode&quot;] or child::*[local-name()=&quot;City&quot;])))+1"/>
				</xsl:call-template>
				<xsl:if test="child::*[local-name()=&quot;Type&quot;] and (child::*[local-name()=&quot;PostalCode&quot;] or child::*[local-name()=&quot;City&quot;])">
					<xsl:call-template name="TeleAddress">
						<xsl:with-param name="col" select="($col)-1-($antall-tel)*2"/>
					</xsl:call-template>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:if test="child::*[local-name()=&quot;AdditionalId&quot;] or child::*[local-name()=&quot;BasisForHealthServices&quot;]">
			<xsl:variable name="antall-id" select="count(child::*[local-name()=&quot;AdditionalId&quot;])"/>
			<tr>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;AdditionalId&quot;] and child::*[local-name()=&quot;BasisForHealthServices&quot;]">
						<th colspan="2">Andre pasient-identifikatorer</th>
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
						<th>Refusjonsgrunnlag</th>
						<td>
							<xsl:for-each select="child::*[local-name()=&quot;BasisForHealthServices&quot;]">
								<xsl:call-template name="k-8246"/>
							</xsl:for-each>
						</td>
					</xsl:when>
					<xsl:when test="child::*[local-name()=&quot;AdditionalId&quot;] and not(child::*[local-name()=&quot;BasisForHealthServices&quot;])">
						<th colspan="2">Andre pasient-identifikatorer</th>
						<xsl:for-each select="child::*[local-name()=&quot;AdditionalId&quot;]">
							<xsl:call-template name="AdditionalId">
								<xsl:with-param name="col">
									<xsl:choose>
										<xsl:when test="position() = $antall-id">
											<xsl:value-of select="($col)-1-($antall-id)*2"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<th>Refusjonsgrunnlag</th>
						<td colspan="{($col)-1}">
							<xsl:for-each select="child::*[local-name()=&quot;BasisForHealthServices&quot;]">
								<xsl:call-template name="k-8246"/>
							</xsl:for-each>
						</td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()=&quot;AdmLocation&quot;]">
			<tr>
				<th colspan="{$col}" class="h3">
					Opphold
				</th>
			</tr>
			<tr>
				<th>Institusjon</th>
				<td width="{((($col)-2)*number(not(child::*[local-name()=&quot;AdmCat&quot;] | child::*[local-name()=&quot;StartDateTime&quot;] | child::*[local-name()=&quot;EndDateTime&quot;]))+1)*$std-td}px" colspan="{(($col)-4)*number(not(child::*[local-name()=&quot;AdmCat&quot;] | child::*[local-name()=&quot;StartDateTime&quot;] | child::*[local-name()=&quot;EndDateTime&quot;]))+3}">
					<!-- Gir her boksen en default kolonnebredde på 3 mot normalt 1 -->
					<xsl:value-of select="child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;Name&quot;]"/>
					<xsl:if test="child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;Dept&quot;]/child::*[local-name()=&quot;Name&quot;]">
						<xsl:for-each select="child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;Dept&quot;]">,&#160;<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
						</xsl:for-each>
					</xsl:if>
					<xsl:for-each select="child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;SubLocation&quot;]">,&#160;<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]"><xsl:call-template name="k-8242"/></xsl:for-each>:&#160;<xsl:value-of select="child::*[local-name()=&quot;Place&quot;]"/>
					</xsl:for-each>
				</td>
				<xsl:if test="child::*[local-name()=&quot;AdmCat&quot;]">
					<th>Type&#160;tjeneste&#160;</th>
					<td width="{((($col)-6)*number(not(child::*[local-name()=&quot;StartDateTime&quot;] | child::*[local-name()=&quot;EndDateTime&quot;]))+1)*$std-td}px" colspan="{(($col)-6)*number(not(child::*[local-name()=&quot;StartDateTime&quot;] | child::*[local-name()=&quot;EndDateTime&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;AdmCat&quot;]">
							<xsl:call-template name="k-8240"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;StartDateTime&quot;]">
					<th>Innlagt&#160;dato&#160;</th>
					<td width="{((($col)-6-count(child::*[local-name()=&quot;AdmCat&quot;])*2)*number(not(child::*[local-name()=&quot;EndDateTime&quot;]))+1)*$std-td}px" colspan="{(($col)-6-count(child::*[local-name()=&quot;AdmCat&quot;])*2)*number(not(child::*[local-name()=&quot;EndDateTime&quot;]))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;StartDateTime&quot;]/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;EndDateTime&quot;]">
					<th>Utskrevet&#160;dato&#160;</th>
					<td colspan="{(($col)-5-count(child::*[local-name()=&quot;AdmCat&quot;] | child::*[local-name()=&quot;StartDateTime&quot;])*2)}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;EndDateTime&quot;]/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Patient&quot;] | child::*[local-name()=&quot;InfItem&quot;]">
			<xsl:if test="local-name()=&quot;Patient&quot;">
				<xsl:call-template name="Patient">
				<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="local-name()=&quot;InfItem&quot;">
				<xsl:call-template name="InfItem">
				<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Øvrig informasjon om dyret -->
	<xsl:template name="Animal">
		<xsl:param name="col"/>
		<tr>
			<xsl:if test="child::*[local-name()=&quot;NameOwner&quot;]">
				<th>Eier&#160;</th>
				<td width="{((($col)-2)*number(not(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;Species&quot;]))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;Species&quot;]))+1}">
					<xsl:value-of select="child::*[local-name()=&quot;NameOwner&quot;]"/>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Name&quot;]">
				<th>Navn&#160;
					<xsl:if test="local-name(..)='Animal'">
						-&#160;relasjon:&#160;<xsl:for-each select="child::*[local-name()=&quot;Relation&quot;]"><xsl:call-template name="k-8238"/></xsl:for-each>
					</xsl:if>
				</th>
				<td width="{((($col)-2-count(child::*[local-name()=&quot;NameOwner&quot;])*2)*number(not(child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;Species&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;NameOwner&quot;])*2)*number(not(child::*[local-name()=&quot;Sex&quot;] | child::*[local-name()=&quot;Species&quot;]))+1}">
					<xsl:value-of select="child::*[local-name()=&quot;Name&quot;]"/>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Sex&quot;]">
				<th>Kjønn</th>
				<td width="{((($col)-2-count(child::*[local-name()=&quot;NameOwner&quot;] | child::*[local-name()=&quot;Name&quot;])*2)*number(not(child::*[local-name()=&quot;Species&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;NameOwner&quot;] | child::*[local-name()=&quot;Name&quot;])*2)*number(not(child::*[local-name()=&quot;Species&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;Sex&quot;]">
						<xsl:call-template name="k-3101"/>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Species&quot;]">
				<th>Art</th>
				<td colspan="{($col)-1-count(child::*[local-name()=&quot;NameOwner&quot;] | child::*[local-name()=&quot;Name&quot;] | child::*[local-name()=&quot;Sex&quot;])*2}">
					<xsl:value-of select="child::*[local-name()=&quot;Species&quot;]"/>
				</td>
			</xsl:if>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;Animal&quot;]">
			<xsl:call-template name="Animal">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Analysert objekt -->
	<xsl:template name="AnalysedSubject">
		<xsl:param name="col"/>
		<xsl:param name="pos"/>
		<xsl:param name="last"/>
		<xsl:if test="child::*[local-name()=&quot;Type&quot;] or child::*[local-name()=&quot;TypeCoded&quot;] or child::*[local-name()=&quot;IdByServProvider&quot;] or child::*[local-name()=&quot;CollectedSample&quot;] or child::*[local-name()=&quot;CollectedStudyProduct&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Type&quot;] or child::*[local-name()=&quot;TypeCoded&quot;]"><!-- Enten Type eller TypeCoded må oppgis - jfr. standard HIS 80822:2014 -->
					<th>Type&#160;materiale<xsl:if test="$last!=1">&#160;<xsl:value-of select="$pos"/></xsl:if>
						<xsl:for-each select="child::*[local-name()=&quot;ServType&quot;]">
							-&#160;<xsl:call-template name="k-7309"/>
						</xsl:for-each>
					</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()=&quot;IdByServProvider&quot;] | child::*[local-name()=&quot;CollectedSample&quot;] | child::*[local-name()=&quot;CollectedStudyProduct&quot;]))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()=&quot;IdByServProvider&quot;] | child::*[local-name()=&quot;CollectedSample&quot;] | child::*[local-name()=&quot;CollectedStudyProduct&quot;]))+1}">
					<!--Kommentar til en tilsynelatende for lang kolonnebredde: CollectedSample og CollectedStudyProduct er innenfor en choice -->
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;Type&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;Type&quot;]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="child::*[local-name()=&quot;TypeCoded&quot;]">
									<xsl:choose>
										<xsl:when test="contains(@S, '8212')">
											<xsl:call-template name="k-dummy-OT"/>
										</xsl:when>
										<xsl:when test="contains(@S, '8216')">
											<xsl:call-template name="k-8216"/>
										</xsl:when>
										<xsl:when test="contains(@S, '8351')">
											<xsl:call-template name="k-dummy-OT"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="k-dummy"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;IdByServProvider&quot;]">
					<th>Tjenesteyters&#160;id</th>
					<td width="{((($col)-2-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2)*number(not(child::*[local-name()=&quot;CollectedSample&quot;] | child::*[local-name()=&quot;CollectedStudyProduct&quot;]))+1)*$std-td}px" colspan="{(($col)-2-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2)*number(not(child::*[local-name()=&quot;CollectedSample&quot;] | child::*[local-name()=&quot;CollectedStudyProduct&quot;]))+1}">
						<xsl:value-of select="child::*[local-name()=&quot;IdByServProvider&quot;]"/>
					</td>
				</xsl:if>
				<xsl:for-each select="child::*[local-name()=&quot;CollectedSample&quot;]">
					<xsl:if test="child::*[local-name()=&quot;CollectedDate&quot;]">
						<th>Dato&#160;prøvetakning</th>
						<td width="{((($col)-2-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2-count(../child::*[local-name()=&quot;IdByServProvider&quot;])*2)*number(not(child::*[local-name()=&quot;CollectorComment&quot;] | child::*[local-name()=&quot;CollectorCommentCoded&quot;] | child::*[local-name()=&quot;Logistics&quot;]))+1)*$std-td}px" colspan="{(($col)-2-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2-count(../child::*[local-name()=&quot;IdByServProvider&quot;])*2)*number(not(child::*[local-name()=&quot;CollectorComment&quot;] | child::*[local-name()=&quot;CollectorCommentCoded&quot;] | child::*[local-name()=&quot;Logistics&quot;]))+1}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;CollectedDate&quot;]/@V"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;Logistics&quot;]">
						<th>Forsendelsesmåte</th>
						<td width="{((($col)-2-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2-count(../child::*[local-name()=&quot;IdByServProvider&quot;] | child::*[local-name()=&quot;CollectedDate&quot;])*2)*number(not(child::*[local-name()=&quot;CollectorComment&quot;] | child::*[local-name()=&quot;CollectorCommentCoded&quot;]))+1)*$std-td}px" colspan="{(($col)-2-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2-count(../child::*[local-name()=&quot;IdByServProvider&quot;] | child::*[local-name()=&quot;CollectedDate&quot;])*2)*number(not(child::*[local-name()=&quot;CollectorComment&quot;] | child::*[local-name()=&quot;CollectorCommentCoded&quot;]))+1}">
							<xsl:value-of select="child::*[local-name()=&quot;Logistics&quot;]"/>
						</td>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;CollectorComment&quot;] or child::*[local-name()=&quot;CollectorCommentCoded&quot;]">
						<th>Prøvetakers&#160;kommentar</th>
						<td colspan="{($col)-1-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2-count(../child::*[local-name()=&quot;IdByServProvider&quot;] | child::*[local-name()=&quot;CollectedDate&quot;] | child::*[local-name()=&quot;Logistics&quot;])*2}">
							<xsl:if test="child::*[local-name()=&quot;CollectorComment&quot;]">
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="child::*[local-name()=&quot;CollectorComment&quot;]"/>
								</xsl:call-template>&#160;
							</xsl:if>
							<xsl:for-each select="child::*[local-name()=&quot;CollectorCommentCoded&quot;]">
								<xsl:choose>
									<xsl:when test="contains(@S, '8275')">
										<xsl:call-template name="k-8275"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="k-dummy"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</td>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()=&quot;CollectedStudyProduct&quot;]">
					<xsl:if test="child::*[local-name()=&quot;Type&quot;]">
						<th>Type&#160;analyseprodukt</th>
						<td width="{((($col)-2-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2-count(../child::*[local-name()=&quot;IdByServProvider&quot;])*2)*number(not(child::*[local-name()=&quot;ProducedDate&quot;] | child::*[local-name()=&quot;RefRelatedProd&quot;]))+1)*$std-td}px" colspan="{(($col)-2-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2-count(../child::*[local-name()=&quot;IdByServProvider&quot;])*2)*number(not(child::*[local-name()=&quot;ProducedDate&quot;] | child::*[local-name()=&quot;RefRelatedProd&quot;]))+1}">
							<xsl:value-of select="child::*[local-name()=&quot;Type&quot;]"/>
						</td>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;ProducedDate&quot;]">
						<th>Dato&#160;prøvetakning</th>
						<td width="{((($col)-2-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2-count(../child::*[local-name()=&quot;IdByServProvider&quot;] | child::*[local-name()=&quot;Type&quot;])*2)*number(not(child::*[local-name()=&quot;RefRelatedProd&quot;]))+1)*$std-td}px" colspan="{(($col)-2-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2-count(../child::*[local-name()=&quot;IdByServProvider&quot;] | child::*[local-name()=&quot;Type&quot;])*2)*number(not(child::*[local-name()=&quot;RefRelatedProd&quot;]))+1}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;ProducedDate&quot;]/@V"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;RefRelatedProd&quot;]">
						<th>Referanse</th>
						<td colspan="{($col)-1-number(boolean(../child::*[local-name()=&quot;Type&quot;] or ../child::*[local-name()=&quot;TypeCoded&quot;]))*2-count(../child::*[local-name()=&quot;IdByServProvider&quot;] | child::*[local-name()=&quot;Type&quot;] | child::*[local-name()=&quot;ProducedDate&quot;])*2}">
							<xsl:value-of select="child::*[local-name()=&quot;RefRelatedProd&quot;]"/>
						</td>
					</xsl:if>
				</xsl:for-each>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Number&quot;] or child::*[local-name()=&quot;IdByRequester&quot;] or child::*[local-name()=&quot;SampleCollInd&quot;] or child::*[local-name()=&quot;SampleCollProc&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Number&quot;]">
					<th>Antall</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()=&quot;IdByRequester&quot;] | child::*[local-name()=&quot;SampleCollInd&quot;] | child::*[local-name()=&quot;SampleCollProc&quot;]))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()=&quot;IdByRequester&quot;] | child::*[local-name()=&quot;SampleCollInd&quot;] | child::*[local-name()=&quot;SampleCollProc&quot;]))+1}">
						<xsl:value-of select="child::*[local-name()=&quot;Number&quot;]"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;IdByRequester&quot;]">
					<th>Rekvirents&#160;id</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;Number&quot;])*2)*number(not(child::*[local-name()=&quot;SampleCollInd&quot;] | child::*[local-name()=&quot;SampleCollProc&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;Number&quot;])*2)*number(not(child::*[local-name()=&quot;SampleCollInd&quot;] | child::*[local-name()=&quot;SampleCollProc&quot;]))+1}">
						<xsl:value-of select="child::*[local-name()=&quot;IdByRequester&quot;]"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;SampleCollInd&quot;]">
					<th>Prøve&#160;tatt</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;Number&quot;] | child::*[local-name()=&quot;IdByRequester&quot;])*2)*number(not(child::*[local-name()=&quot;SampleCollProc&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;Number&quot;] | child::*[local-name()=&quot;IdByRequester&quot;])*2)*number(not(child::*[local-name()=&quot;SampleCollProc&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;SampleCollInd&quot;]">
							<xsl:call-template name="k-1101"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;SampleCollProc&quot;]">
					<th>Prøvetakingsprosedyre</th>
					<td colspan="{($col)-1-count(child::*[local-name()=&quot;Number&quot;] | child::*[local-name()=&quot;IdByRequester&quot;] | child::*[local-name()=&quot;SampleCollInd&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;SampleCollInd&quot;]">
							<xsl:call-template name="k-dummy"/>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;AnatomicalOrigin&quot;] or child::*[local-name()=&quot;PreservMaterial&quot;] or child::*[local-name()=&quot;Pretreatment&quot;] or child::*[local-name()=&quot;Accredited&quot;] or child::*[local-name()=&quot;RelServProv&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;AnatomicalOrigin&quot;]">
					<th>Anatomisk&#160;lokasjon</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()=&quot;PreservMaterial&quot;] | child::*[local-name()=&quot;Pretreatment&quot;] | child::*[local-name()=&quot;Accredited&quot;] | child::*[local-name()=&quot;RelServProv&quot;]))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()=&quot;PreservMaterial&quot;] | child::*[local-name()=&quot;Pretreatment&quot;] | child::*[local-name()=&quot;Accredited&quot;] | child::*[local-name()=&quot;RelServProv&quot;]))+1}">
						<xsl:value-of select="child::*[local-name()=&quot;AnatomicalOrigin&quot;]"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;PreservMaterial&quot;]">
					<th>Konserveringsmiddel</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;AnatomicalOrigin&quot;])*2)*number(not(child::*[local-name()=&quot;Pretreatment&quot;] | child::*[local-name()=&quot;Accredited&quot;] | child::*[local-name()=&quot;RelServProv&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;AnatomicalOrigin&quot;])*2)*number(not(child::*[local-name()=&quot;Pretreatment&quot;] | child::*[local-name()=&quot;Accredited&quot;] | child::*[local-name()=&quot;RelServProv&quot;]))+1}">
						<xsl:value-of select="child::*[local-name()=&quot;PreservMaterial&quot;]"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Pretreatment&quot;]">
					<th>Forberedende&#160;behandling</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;AnatomicalOrigin&quot;] | child::*[local-name()=&quot;PreservMaterial&quot;])*2)*number(not(child::*[local-name()=&quot;Accredited&quot;] | child::*[local-name()=&quot;RelServProv&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;AnatomicalOrigin&quot;] | child::*[local-name()=&quot;PreservMaterial&quot;])*2)*number(not(child::*[local-name()=&quot;Accredited&quot;] | child::*[local-name()=&quot;RelServProv&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Pretreatment&quot;]/child::*[local-name()=&quot;Heading&quot;]">
							<xsl:call-template name="k-8232"/>
						</xsl:for-each>
						<xsl:if test="child::*[local-name()=&quot;Pretreatment&quot;]/child::*[local-name()=&quot;TextResultValue&quot;]">
							<div>
								<b>Beskrivelse:&#160;</b>
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="child::*[local-name()=&quot;Pretreatment&quot;]/child::*[local-name()=&quot;TextResultValue&quot;]"/>
								</xsl:call-template>
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Accredited&quot;]">
					<th>Akkreditert</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;AnatomicalOrigin&quot;] | child::*[local-name()=&quot;PreservMaterial&quot;] | child::*[local-name()=&quot;Pretreatment&quot;])*2)*number(not(child::*[local-name()=&quot;RelServProv&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;AnatomicalOrigin&quot;] | child::*[local-name()=&quot;PreservMaterial&quot;] | child::*[local-name()=&quot;Pretreatment&quot;])*2)*number(not(child::*[local-name()=&quot;RelServProv&quot;]))+1}">
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;Accredited&quot;]/@V='true'">Resultatet er akkreditert</xsl:when>
							<xsl:otherwise>Resultatet er ikke akkreditert</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;RelServProv&quot;]">
					<th>
						<xsl:for-each select="child::*[local-name()=&quot;RelServProv&quot;]/child::*[local-name()=&quot;Relation&quot;]">
							<xsl:call-template name="k-8254"/>
						</xsl:for-each>
					</th>
					<td colspan="{($col)-1-count(child::*[local-name()=&quot;AnatomicalOrigin&quot;] | child::*[local-name()=&quot;PreservMaterial&quot;] | child::*[local-name()=&quot;Pretreatment&quot;] | child::*[local-name()=&quot;Accredited&quot;])*2}">
						<xsl:value-of select="child::*[local-name()=&quot;RelServProv&quot;]//child::*[local-name()=&quot;Name&quot;]"/>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;SampleHandling&quot;]">
			<tr>
				<th>Håndteringsbeskrivelse</th>
				<td colspan="{($col)-1}">
					<xsl:for-each select="child::*[local-name()=&quot;SampleHandling&quot;]">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Comment&quot;]">
			<tr>
				<th>Kommentar</th>
				<td colspan="{($col)-1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Comment&quot;]"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()=&quot;AnalysedSubject&quot;]">
			<xsl:call-template name="AnalysedSubject">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Undersøkelsesresultat -->
	<xsl:template name="ResultItem">
		<xsl:param name="slaaSammen"/>
		<xsl:variable name="textWidth"> <!-- variabel som gjør resultat-kolonnebredden større jo mer tekst som skal vises -->
			<xsl:choose>
				<xsl:when test="child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;TextResultValue&quot;]">
					<xsl:value-of select="ceiling(string-length(child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;TextResultValue&quot;]) div 50)"/>
				</xsl:when>
				<xsl:when test="$slaaSammen='true' and child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;TextResultValue&quot;]">
					<xsl:value-of select="ceiling(string-length(child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;TextResultValue&quot;]) div 50)"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="commentWidth"> <!-- variabel som gjør kommentar-kolonnebredden større jo mer tekst som skal vises -->
			<xsl:choose>
				<xsl:when test="child::*[local-name()=&quot;Comment&quot;]">
					<xsl:value-of select="ceiling(string-length(child::*[local-name()=&quot;Comment&quot;]) div 50)"/>
				</xsl:when>
				<xsl:when test="$slaaSammen='true' and child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Comment&quot;]">
					<xsl:value-of select="ceiling(string-length(child::*[local-name()=&quot;ResultItem&quot;][1]/child::*[local-name()=&quot;Comment&quot;]) div 50)"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<!-- Undersøkelse -->
			<xsl:if test="//child::*[local-name()=&quot;Investigation&quot;] or //child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V='GR']">
				<td width="{$investigation-col*$result-td}px" colspan="{$investigation-col}">
					<xsl:if test="child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V='GR'">
						<b>Gruppe:&#160;</b>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;Investigation&quot;]">
							<div>
								<xsl:call-template name="skrivUtUndersokelse"/>
							</div>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()=&quot;ResultItem&quot;][1]">
								<div>
									<xsl:call-template name="skrivUtUndersokelse"/>
								</div>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>				
			</xsl:if>
			<!-- Resultat -->
			<xsl:if test="//child::*[local-name()=&quot;TextResult&quot;] or //child::*[local-name()=&quot;Interval&quot;] or //child::*[local-name()=&quot;DateResult&quot;] or //child::*[local-name()=&quot;NumResult&quot;]">
				<td width="{($textWidth)*$result-td}px" colspan="{$res-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;TextResult&quot;] or child::*[local-name()=&quot;Interval&quot;] or child::*[local-name()=&quot;DateResult&quot;] or child::*[local-name()=&quot;NumResult&quot;]">
							<xsl:call-template name="skrivUtResultat"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()=&quot;ResultItem&quot;][1]">
								<xsl:call-template name="skrivUtResultat"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Id -->
			<xsl:if test="//child::*[local-name()=&quot;IdResultItem&quot;]">
				<td width="{$id-col*$id-td}px" colspan="{$id-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;IdResultItem&quot;]">
							<xsl:value-of select="child::*[local-name()=&quot;IdResultItem&quot;]"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()=&quot;ResultItem&quot;][1]">
								<xsl:value-of select="child::*[local-name()=&quot;IdResultItem&quot;]"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Ref.id -->
			<xsl:if test="//child::*[local-name()=&quot;RefIdResultItem&quot;]">
				<td width="{$refid-col*$id-td}px" colspan="{$refid-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;RefIdResultItem&quot;]">
							<xsl:value-of select="child::*[local-name()=&quot;RefIdResultItem&quot;]"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()=&quot;ResultItem&quot;][1]">
								<xsl:value-of select="child::*[local-name()=&quot;RefIdResultItem&quot;]"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Ref.interval -->
			<xsl:if test="//child::*[local-name()=&quot;RefInterval&quot;]">
				<td width="{$refinterval-col*$result-td}px" colspan="{$refinterval-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;RefInterval&quot;]">
							<xsl:call-template name="skrivUtRefInterval"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()=&quot;ResultItem&quot;][1]">
								<xsl:call-template name="skrivUtRefInterval"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Tidspunkt for -->
			<xsl:if test="//child::*[local-name()=&quot;InvDate&quot;] or //child::*[local-name()=&quot;StatusChangeDate&quot;] or //child::*[local-name()=&quot;DescrDate&quot;] or //child::*[local-name()=&quot;CounterSignDate&quot;] or //child::*[local-name()=&quot;MedicalValidationDate&quot;]">
				<td width="{$date-col*$result-td}px" colspan="{$date-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;InvDate&quot;] or child::*[local-name()=&quot;StatusChangeDate&quot;] or child::*[local-name()=&quot;DescrDate&quot;] or child::*[local-name()=&quot;CounterSignDate&quot;] or child::*[local-name()=&quot;MedicalValidationDate&quot;]">
							<xsl:call-template name="skrivUtTidspunktFor"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()=&quot;ResultItem&quot;][1]">
								<xsl:call-template name="skrivUtTidspunktFor"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Tilknyttet tjenesteyter -->
			<xsl:if test="//child::*[local-name()=&quot;RelServProv&quot;]">
				<td width="{$relserv-col*$result-td}px" colspan="{$relserv-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;RelServProv&quot;]">
							<xsl:call-template name="skrivUtTjenesteyter"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()=&quot;ResultItem&quot;][1]">
								<xsl:call-template name="skrivUtTjenesteyter"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Tilleggsopplysninger -->
			<xsl:if test="//child::*[local-name()=&quot;Accredited&quot;] or //child::*[local-name()=&quot;StructuredInfo&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or //child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;DiagComment&quot;] or //child::*[local-name()=&quot;RefAnalysedSubject&quot;] or //child::*[local-name()=&quot;StatusInvestigation&quot;]">
				<td width="{$commentWidth*$std-td}px" colspan="{$tillegg-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;Accredited&quot;] or child::*[local-name()=&quot;StructuredInfo&quot;] or child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or child::*[local-name()=&quot;Comment&quot;] or child::*[local-name()=&quot;DiagComment&quot;] or child::*[local-name()=&quot;RefAnalysedSubject&quot;] or child::*[local-name()=&quot;StatusInvestigation&quot;]">
							<xsl:call-template name="skrivUtTillegg"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()=&quot;ResultItem&quot;][1]">
								<xsl:call-template name="skrivUtTillegg"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<xsl:template name="ResultItemStructuredInfo">
		<table>
			<tbody>
				<tr>
					<th>Type</th>
					<td><b>Resultat</b></td>
				</tr>
				<xsl:for-each select="child::*[local-name()=&quot;StructuredInfo&quot;]">
					<tr>
						<td>
							<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]">
								<xsl:call-template name="k-dummy"/>
							</xsl:for-each>
						</td>
						<td>
							<xsl:for-each select="child::*[local-name()=&quot;TextInfo&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;Text&quot;]"/>&#160;
							</xsl:for-each>
							<xsl:for-each select="child::*[local-name()=&quot;IntegerInfo&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;Integer&quot;]"/>&#160;
							</xsl:for-each>
							<xsl:for-each select="child::*[local-name()=&quot;PhysicalInfo&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;Quantity&quot;]/@V"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;Quantity&quot;]/@U"/>&#160;
							</xsl:for-each>
							<xsl:for-each select="child::*[local-name()=&quot;CodedInfo&quot;]/child::*[local-name()=&quot;Code&quot;]">
								<xsl:call-template name="k-dummy"/>&#160;
							</xsl:for-each>
							<xsl:for-each select="child::*[local-name()=&quot;BooleanInfo&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;Flag&quot;]/@V"/>&#160;
							</xsl:for-each>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	<!-- Visning av Klinisk opplysning -->
	<xsl:template name="InfItem">
		<xsl:param name="col"/>
		<xsl:variable name="type" select="child::*[local-name()=&quot;Type&quot;]/@V"/>
		<xsl:if test="not(preceding-sibling::*[local-name()=&quot;InfItem&quot;][child::*[local-name()=&quot;Type&quot;]/@V=$type])">
			<tr>
				<th colspan="{$col}" class="h3">
					<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]">
						<xsl:call-template name="k-8233"/>
					</xsl:for-each>
				</th>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;Description&quot;] or child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;CodedDescr&quot;] or child::*[local-name()=&quot;StartDateTime&quot;] or child::*[local-name()=&quot;EndDateTime&quot;] or child::*[local-name()=&quot;OrgDate&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;Description&quot;] or child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;CodedDescr&quot;]">
					<th>Beskrivelse</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()=&quot;StartDateTime&quot;] | child::*[local-name()=&quot;EndDateTime&quot;] | child::*[local-name()=&quot;OrgDate&quot;]))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()=&quot;StartDateTime&quot;] | child::*[local-name()=&quot;EndDateTime&quot;] | child::*[local-name()=&quot;OrgDate&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;Description&quot;]">
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
						<xsl:if test="child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;CodedDescr&quot;]">
							<div>
								<xsl:for-each select="child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;CodedDescr&quot;]">
									<xsl:choose>
										<xsl:when test="contains(@S, '8209')">
											<xsl:call-template name="k-8209"/>
										</xsl:when>
										<xsl:when test="contains(@S, '8210')">
											<xsl:call-template name="k-8210"/>
										</xsl:when>
										<xsl:when test="contains(@S, '8217')">
											<xsl:call-template name="k-8217"/>
										</xsl:when>
										<xsl:when test="contains(@S, '8218')">
											<xsl:call-template name="k-8218"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="k-dummy"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;StartDateTime&quot;]">
					<th>Start-dato</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;Description&quot;])*2)*number(not(child::*[local-name()=&quot;EndDateTime&quot;] | child::*[local-name()=&quot;OrgDate&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;Description&quot;])*2)*number(not(child::*[local-name()=&quot;EndDateTime&quot;] | child::*[local-name()=&quot;OrgDate&quot;]))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;StartDateTime&quot;]/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;EndDateTime&quot;]">
					<th>Slutt-dato</th>
					<td width="{((($col)-2-count(child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;Description&quot;] | child::*[local-name()=&quot;StartDateTime&quot;])*2)*number(not(child::*[local-name()=&quot;OrgDate&quot;]))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;Description&quot;] | child::*[local-name()=&quot;StartDateTime&quot;])*2)*number(not(child::*[local-name()=&quot;OrgDate&quot;]))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;EndDateTime&quot;]/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;OrgDate&quot;]">
					<th>Opprinnelses-dato</th>
					<td colspan="{($col)-1-count(child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;Description&quot;] | child::*[local-name()=&quot;StartDateTime&quot;] | child::*[local-name()=&quot;EndDateTime&quot;])*2}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;OrgDate&quot;]/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;Comment&quot;]">
			<tr>
				<th>Kommentar</th>
				<td colspan="{($col)-1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Observation&quot;]/child::*[local-name()=&quot;Comment&quot;]"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Tjenesteyter -->
	<xsl:template name="ServProvider">
		<xsl:param name="col"/>
		<xsl:param name="historikk"/>
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
				<xsl:if test="$historikk='true'">&#160;(<font color="red">fra historikk</font>)</xsl:if>
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
		<xsl:param name="historikk"/>
		<tr>
			<th colspan="{$col}" class="h3">Henvisende&#160;instans<xsl:if test="child::*[local-name()=&quot;HCP&quot;]/child::*[local-name()=&quot;MedSpeciality&quot;]"> - Spesialitet:&#160;<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]/child::*[local-name()=&quot;MedSpeciality&quot;]">
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
				<xsl:if test="$historikk='true'">&#160;(<font color="red">fra historikk</font>)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Betalingsansvarlig -->
	<xsl:template name="PaymentResponsible">
		<xsl:param name="col"/>
		<xsl:param name="historikk"/>
		<tr>
			<th colspan="{$col}" class="h3">Betalingsansvarlig<xsl:if test="child::*[local-name()=&quot;TypeGuarantor&quot;]"> - <xsl:value-of select="child::*[local-name()=&quot;TypeGuarantor&quot;]"/></xsl:if>
				<xsl:if test="$historikk='true'">&#160;(<font color="red">fra historikk</font>)</xsl:if>
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
		<xsl:param name="historikk"/>
		<tr>
			<th colspan="{$col}" class="h3">Kopimottaker<xsl:if test="child::*[local-name()=&quot;CopyDestRole&quot;]/child::*[local-name()=&quot;MsgType&quot;]"> - kopi&#160;av:&#160;<xsl:for-each select="child::*[local-name()=&quot;CopyDestRole&quot;]/child::*[local-name()=&quot;MsgType&quot;]">
						<xsl:call-template name="k-8236"/>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="$historikk='true'">&#160;(<font color="red">fra historikk</font>)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Tilknyttet tjeneteyter -->
	<xsl:template name="RelServProv">
		<xsl:param name="col"/>
		<xsl:param name="historikk"/>
		<tr>
			<th colspan="{$col}" class="h3">
				<xsl:for-each select="child::*[local-name()=&quot;Relation&quot;]">
					<xsl:call-template name="k-8254"/>
				</xsl:for-each>
				<xsl:if test="$historikk='true'">&#160;(<font color="red">fra historikk</font>)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Ansvarlig Helsetjenesteenhet -->
	<xsl:template name="ResponsibleHcp">
		<xsl:param name="col"/>
		<xsl:param name="historikk"/>
		<tr>
			<th colspan="{$col}" class="h3">
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;Relation&quot;]/@DN">
						<xsl:for-each select="child::*[local-name()=&quot;Relation&quot;]">
							<xsl:call-template name="k-7319"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Ansvarlig&#160;helsetjenesteenhet</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$historikk='true'">&#160;(<font color="red">fra historikk</font>)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;HCP&quot;]">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Oppholdsted -->
	<xsl:template name="AdmLocation">
		<xsl:param name="col"/>
		<xsl:param name="historikk"/>
		<tr>
			<th colspan="{$col}" class="h3">Oppholdssted for pasient<xsl:if test="child::*[local-name()=&quot;AdmCat&quot;]"> - Type&#160;tjeneste:&#160;<xsl:for-each select="child::*[local-name()=&quot;AdmCat&quot;]">
						<xsl:call-template name="k-8240"/>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="$historikk='true'">&#160;(<font color="red">fra historikk</font>)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]">
			<tr>
				<xsl:call-template name="Inst">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;Dept&quot;]">
			<tr>
				<xsl:call-template name="Dept">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Inst&quot;]/child::*[local-name()=&quot;HCPerson&quot;]">
			<tr>
				<xsl:call-template name="HCPerson">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Location&quot;]/child::*[local-name()=&quot;Address&quot;]">
			<xsl:variable name="antall-tel" select="count(child::*[local-name()=&quot;TeleAddress&quot;])"/>
			<tr>
				<xsl:for-each select="child::*[local-name()=&quot;TeleAddress&quot;]">
					<xsl:call-template name="TeleAddress">
						<xsl:with-param name="col" select="(($col)-1)*number(not(child::*[local-name()=&quot;Type&quot;] and (child::*[local-name()=&quot;PostalCode&quot;] or child::*[local-name()=&quot;City&quot;])))+1"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:if test="child::*[local-name()=&quot;Type&quot;] and (child::*[local-name()=&quot;PostalCode&quot;] or child::*[local-name()=&quot;City&quot;])">
					<xsl:call-template name="Address">
						<xsl:with-param name="col" select="($col)-1-($antall-tel)*2"/>
					</xsl:call-template>
				</xsl:if>
			</tr>
		</xsl:for-each>
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
						<xsl:with-param name="col" select="(($col)-1)*number(not(child::*[local-name()=&quot;Type&quot;] and (child::*[local-name()=&quot;PostalCode&quot;] or child::*[local-name()=&quot;City&quot;])))+1"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:if test="child::*[local-name()=&quot;Type&quot;] and (child::*[local-name()=&quot;PostalCode&quot;] or child::*[local-name()=&quot;City&quot;])">
					<xsl:call-template name="Address">
						<xsl:with-param name="col" select="($col)-1-($antall-tel)*2"/>
					</xsl:call-template>
				</xsl:if>
			</tr>
		</xsl:for-each>
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
			<td width="{$std-td}px">
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
			<td width="{$std-td}px">
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
			<td width="{$std-td}px">
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
			<td width="{$std-td}px">
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
					<tr>
						<th>Fil</th>
						<td colspan="{($col)-1}">
							<xsl:choose>
								<xsl:when test="child::*[local-name()=&quot;Content&quot;]">
									<xsl:value-of select="child::*[local-name()=&quot;Content&quot;]"/>
								</xsl:when>
								<xsl:when test="child::*[local-name()=&quot;FileReference&quot;]">
									<xsl:value-of select="child::*[local-name()=&quot;FileReference&quot;]"/>
								</xsl:when>
							</xsl:choose>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!-- funksjoner som kalles ved visning av resultattabellen-->
	<xsl:template name="skrivUtUndersokelseOverskrift">
		<tr>
			<!-- Overskrift for Undersøkelse -->
			<xsl:if test="//child::*[local-name()=&quot;Investigation&quot;] or //child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V='GR']">
				<th colspan="{$investigation-col}">Undersøkelse</th>
			</xsl:if>
			<!-- Overskrift for Resultat -->
			<xsl:if test="//child::*[local-name()=&quot;TextResult&quot;] or //child::*[local-name()=&quot;Interval&quot;] or //child::*[local-name()=&quot;DateResult&quot;] or //child::*[local-name()=&quot;NumResult&quot;]">
				<td colspan="{$res-col}">
					<b>
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;] and child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]/@V!='GR'">
								<xsl:for-each select="child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;]">
									<xsl:call-template name="k-8243"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>Resultat</xsl:otherwise>
						</xsl:choose>
					</b>
				</td>
			</xsl:if>
			<!-- Overskrift for Id -->
			<xsl:if test="//child::*[local-name()=&quot;IdResultItem&quot;]">
				<th colspan="{$id-col}">Id</th>
			</xsl:if>
			<!-- Overskrift for Ref.id -->
			<xsl:if test="//child::*[local-name()=&quot;RefIdResultItem&quot;]">
				<th colspan="{$refid-col}">Ref.id</th>
			</xsl:if>
			<!-- Overskrift for Ref.interval -->
			<xsl:if test="//child::*[local-name()=&quot;RefInterval&quot;]">
				<th colspan="{$refinterval-col}">Ref.interval</th>
			</xsl:if>
			<!-- Overskrift for Tidspunkt -->
			<xsl:if test="//child::*[local-name()=&quot;InvDate&quot;] or //child::*[local-name()=&quot;StatusChangeDate&quot;] or //child::*[local-name()=&quot;DescrDate&quot;] or //child::*[local-name()=&quot;CounterSignDate&quot;] or //child::*[local-name()=&quot;MedicalValidationDate&quot;]">
				<th colspan="{$date-col}">
					<xsl:choose>
						<xsl:when test="//child::*[local-name()=&quot;InvDate&quot;] and not(//child::*[local-name()=&quot;StatusChangeDate&quot;]) and not(//child::*[local-name()=&quot;DescrDate&quot;]) and not(//child::*[local-name()=&quot;CounterSignDate&quot;]) and not(//child::*[local-name()=&quot;MedicalValidationDate&quot;])">Tidspunkt for undersøkelsen</xsl:when>
						<xsl:when test="not(//child::*[local-name()=&quot;InvDate&quot;]) and //child::*[local-name()=&quot;StatusChangeDate&quot;] and not(//child::*[local-name()=&quot;DescrDate&quot;]) and not(//child::*[local-name()=&quot;CounterSignDate&quot;]) and not(//child::*[local-name()=&quot;MedicalValidationDate&quot;])">Tidspunkt for beskrivelse</xsl:when>
						<xsl:when test="not(//child::*[local-name()=&quot;InvDate&quot;]) and not(//child::*[local-name()=&quot;StatusChangeDate&quot;]) and //child::*[local-name()=&quot;DescrDate&quot;] and not(//child::*[local-name()=&quot;CounterSignDate&quot;]) and not(//child::*[local-name()=&quot;MedicalValidationDate&quot;])">Tidspunkt for beskrivelse</xsl:when>
						<xsl:when test="not(//child::*[local-name()=&quot;InvDate&quot;]) and not(//child::*[local-name()=&quot;StatusChangeDate&quot;]) and not(//child::*[local-name()=&quot;DescrDate&quot;]) and //child::*[local-name()=&quot;CounterSignDate&quot;] and not(//child::*[local-name()=&quot;MedicalValidationDate&quot;])">Tidspunkt for kontrasignering</xsl:when>
						<xsl:when test="not(//child::*[local-name()=&quot;InvDate&quot;]) and not(//child::*[local-name()=&quot;StatusChangeDate&quot;]) and not(//child::*[local-name()=&quot;DescrDate&quot;]) and not(//child::*[local-name()=&quot;CounterSignDate&quot;]) and //child::*[local-name()=&quot;MedicalValidationDate&quot;]">Tidspunkt for medisinsk validering</xsl:when>
						<xsl:otherwise>Tidspunkt for</xsl:otherwise>
					</xsl:choose>
				</th>
			</xsl:if>
			<!-- Overskrift for Tilknyttet tjenesteyter -->
			<xsl:if test="//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;RelServProv&quot;]">
				<th colspan="{$relserv-col}">
					<xsl:choose>
						<xsl:when test="//child::*[local-name()=&quot;RelServProv&quot;]/child::*[local-name()=&quot;Relation&quot;]">
							<xsl:for-each select="//child::*[local-name()=&quot;RelServProv&quot;]/child::*[local-name()=&quot;Relation&quot;]">
								<xsl:if test="position()=1">
									<xsl:variable name="relationOne">
										<xsl:value-of select="@V"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="count(//child::*[local-name()=&quot;RelServProv&quot;]/child::*[local-name()=&quot;Relation&quot;])=count(//child::*[local-name()=&quot;RelServProv&quot;]/child::*[local-name()=&quot;Relation&quot;][@V=$relationOne])"><!-- Samme kode i alle relation-elementene -->
											<xsl:call-template name="k-8254"/>
										</xsl:when>
										<xsl:otherwise>Tilknyttet tjenesteyter</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>Tilknyttet tjenesteyter</xsl:otherwise>
					</xsl:choose>
				</th>
			</xsl:if>
			<!-- Overskrift for Tilleggsopplysninger -->
			<xsl:if test="//child::*[local-name()=&quot;Accredited&quot;] or //child::*[local-name()=&quot;StructuredInfo&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;DiagComment&quot;] or //child::*[local-name()=&quot;RefAnalysedSubject&quot;] or //child::*[local-name()=&quot;StatusInvestigation&quot;]">
				<td colspan="{$tillegg-col}">
					<xsl:choose>
						<xsl:when test="//child::*[local-name()=&quot;Accredited&quot;] and not(//child::*[local-name()=&quot;StructuredInfo&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;]) and not(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;DiagComment&quot;]) and not(//child::*[local-name()=&quot;RefAnalysedSubject&quot;]) and not(//child::*[local-name()=&quot;StatusInvestigation&quot;])"><b>Akkreditert</b></xsl:when>
						<xsl:when test="not(//child::*[local-name()=&quot;Accredited&quot;]) and //child::*[local-name()=&quot;StructuredInfo&quot;] and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;]) and not(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;DiagComment&quot;]) and not(//child::*[local-name()=&quot;RefAnalysedSubject&quot;]) and not(//child::*[local-name()=&quot;StatusInvestigation&quot;])"><b>Strukturert info</b></xsl:when>
						<xsl:when test="not(//child::*[local-name()=&quot;Accredited&quot;]) and not(//child::*[local-name()=&quot;StructuredInfo&quot;]) and //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;]) and not(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;DiagComment&quot;]) and not(//child::*[local-name()=&quot;RefAnalysedSubject&quot;]) and not(//child::*[local-name()=&quot;StatusInvestigation&quot;])"><b>Kommentar</b></xsl:when>
						<xsl:when test="not(//child::*[local-name()=&quot;Accredited&quot;]) and not(//child::*[local-name()=&quot;StructuredInfo&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;]) and //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] and not(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;DiagComment&quot;]) and not(//child::*[local-name()=&quot;RefAnalysedSubject&quot;]) and not(//child::*[local-name()=&quot;StatusInvestigation&quot;])"><b>Spesifisering</b></xsl:when>
						<xsl:when test="not(//child::*[local-name()=&quot;Accredited&quot;]) and not(//child::*[local-name()=&quot;StructuredInfo&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;]) and //child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;] and not(//child::*[local-name()=&quot;DiagComment&quot;]) and not(//child::*[local-name()=&quot;RefAnalysedSubject&quot;]) and not(//child::*[local-name()=&quot;StatusInvestigation&quot;])"><b>Kommentar til undersøkelsen</b></xsl:when>
						<xsl:when test="not(//child::*[local-name()=&quot;Accredited&quot;]) and not(//child::*[local-name()=&quot;StructuredInfo&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;]) and not(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;]) and //child::*[local-name()=&quot;DiagComment&quot;] and not(//child::*[local-name()=&quot;RefAnalysedSubject&quot;]) and not(//child::*[local-name()=&quot;StatusInvestigation&quot;])"><b>Kommentar som diagnose</b></xsl:when>
						<xsl:when test="not(//child::*[local-name()=&quot;Accredited&quot;]) and not(//child::*[local-name()=&quot;StructuredInfo&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;]) and not(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;DiagComment&quot;]) and //child::*[local-name()=&quot;RefAnalysedSubject&quot;] and not(//child::*[local-name()=&quot;StatusInvestigation&quot;])"><b>Referanse til prøve</b></xsl:when>
						<xsl:when test="not(//child::*[local-name()=&quot;Accredited&quot;]) and not(//child::*[local-name()=&quot;StructuredInfo&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;]) and not(//child::*[local-name()=&quot;ResultItem&quot;]/child::*[local-name()=&quot;Comment&quot;]) and not(//child::*[local-name()=&quot;DiagComment&quot;]) and not(//child::*[local-name()=&quot;RefAnalysedSubject&quot;]) and //child::*[local-name()=&quot;StatusInvestigation&quot;]"><b>Undersøkelsesstatus</b></xsl:when>
						<xsl:otherwise><b>Tilleggsopplysninger</b></xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<xsl:template name="skrivUtUndersokelse">
		<xsl:for-each select="child::*[local-name()=&quot;ServType&quot;]">
			<xsl:if test="@V!='N' and @V!='H'"><b><font color="red"><xsl:call-template name="k-7309"/></font></b>&#160;-&#160;</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Id&quot;]">
			<xsl:choose>
				<xsl:when test="contains(@S, '8212')">
					<xsl:call-template name="k-dummy-OT"/>
				</xsl:when>
				<xsl:when test="contains(@S, '8219')">
					<xsl:call-template name="k-8219"/>
				</xsl:when>
				<xsl:when test="contains(@S, '8220')">
					<xsl:call-template name="k-8220"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="k-dummy"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="position()!=last()">,&#160;</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="skrivUtResultat">
		<xsl:choose>
			<xsl:when test="child::*[local-name()=&quot;TextResult&quot;]">
				<xsl:for-each select="child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Heading&quot;][@V='AN' or @V='VU' or @V='UP' or @V='SY']">
					<b><xsl:call-template name="k-8243"/></b>:&#160;
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;TextResultValue&quot;]">
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
				<xsl:for-each select="child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;TextCode&quot;]">
					<xsl:choose>
						<xsl:when test="contains(@S, '7010')">
							<div><b>SNOMED:</b>&#160;<xsl:call-template name="k-dummy-V"/></div>
						</xsl:when>
						<xsl:when test="contains(@S, '8212')">
							<div><xsl:call-template name="k-dummy-OT"/></div>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="k-dummy"/>
							<xsl:if test="position()!=last()"><br/></xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:if test="child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Unit&quot;]">
					<b>Benevning:</b>&#160;<xsl:value-of select="child::*[local-name()=&quot;TextResult&quot;]/child::*[local-name()=&quot;Unit&quot;]"/>&#160;
				</xsl:if>
			</xsl:when>
			<xsl:when test="child::*[local-name()=&quot;Interval&quot;]">
				<xsl:value-of select="child::*[local-name()=&quot;Interval&quot;]/child::*[local-name()=&quot;Low&quot;]/@V"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;Interval&quot;]/child::*[local-name()=&quot;Low&quot;]/@U"/>&#160;-&#160;<xsl:value-of select="child::*[local-name()=&quot;Interval&quot;]/child::*[local-name()=&quot;High&quot;]/@V"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;Interval&quot;]/child::*[local-name()=&quot;High&quot;]/@U"/>
			</xsl:when>
			<xsl:when test="DateResult">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;DateResult&quot;]/@V"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="child::*[local-name()=&quot;NumResult&quot;]">
				<xsl:for-each select="child::*[local-name()=&quot;NumResult&quot;]/child::*[local-name()=&quot;ArithmeticComp&quot;]">
					<xsl:call-template name="k-8239"/>
				</xsl:for-each>
				<xsl:value-of select="child::*[local-name()=&quot;NumResult&quot;]/child::*[local-name()=&quot;NumResultValue&quot;]/@V"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;NumResult&quot;]/child::*[local-name()=&quot;NumResultValue&quot;]/@U"/>&#160;
				<xsl:for-each select="child::*[local-name()=&quot;DevResultInd&quot;]">
					<b><xsl:call-template name="k-8244"/></b>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="skrivUtRefInterval">
		<xsl:for-each select="child::*[local-name()=&quot;RefInterval&quot;]">
			<xsl:value-of select="child::*[local-name()=&quot;Descr&quot;]"/>&#160;
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="skrivUtTidspunktFor">
		<xsl:if test="child::*[local-name()=&quot;InvDate&quot;]">
			<xsl:if test="//child::*[local-name()=&quot;DescrDate&quot;] or //child::*[local-name()=&quot;StatusChangeDate&quot;] or //child::*[local-name()=&quot;CounterSignDate&quot;] or //child::*[local-name()=&quot;MedicalValidationDate&quot;]"><b>Undersøkelse</b>:&#160;</xsl:if>
			<div>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;InvDate&quot;]/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;DescrDate&quot;]">
			<xsl:if test="//child::*[local-name()=&quot;InvDate&quot;] or //child::*[local-name()=&quot;StatusChangeDate&quot;] or //child::*[local-name()=&quot;CounterSignDate&quot;] or //child::*[local-name()=&quot;MedicalValidationDate&quot;]"><b>Beskrivelse</b>:&#160;</xsl:if>
			<div>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;DescrDate&quot;]/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;StatusChangeDate&quot;]">
			<xsl:if test="//child::*[local-name()=&quot;InvDate&quot;] or //child::*[local-name()=&quot;DescrDate&quot;] or //child::*[local-name()=&quot;CounterSignDate&quot;] or //child::*[local-name()=&quot;MedicalValidationDate&quot;]"><b>Statusendring</b>:&#160;</xsl:if>
			<div>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;StatusChangeDate&quot;]/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;CounterSignDate&quot;]">
			<xsl:if test="//child::*[local-name()=&quot;InvDate&quot;] or //child::*[local-name()=&quot;DescrDate&quot;] or //child::*[local-name()=&quot;StatusChangeDate&quot;] or //child::*[local-name()=&quot;MedicalValidationDate&quot;]"><b>Kontrasignering</b>:&#160;</xsl:if>
			<div>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;CounterSignDate&quot;]/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;MedicalValidationDate&quot;]">
			<xsl:if test="//child::*[local-name()=&quot;InvDate&quot;] or //child::*[local-name()=&quot;DescrDate&quot;] or //child::*[local-name()=&quot;StatusChangeDate&quot;] or //child::*[local-name()=&quot;CounterSignDate&quot;]"><b>Medisinsk&#160;validering</b>:&#160;</xsl:if>
			<div>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;MedicalValidationDate&quot;]/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="skrivUtTjenesteyter">
		<xsl:variable name="relationOne">
			<xsl:value-of select="child::*[local-name()=&quot;RelServProv&quot;]/child::*[local-name()=&quot;Relation&quot;]/@V"/>
		</xsl:variable>
		<xsl:for-each select="child::*[local-name()=&quot;RelServProv&quot;]">
			<xsl:if test="count(//child::*[local-name()=&quot;RelServProv&quot;]/child::*[local-name()=&quot;Relation&quot;])!=count(//child::*[local-name()=&quot;RelServProv&quot;]/child::*[local-name()=&quot;Relation&quot;][@V=$relationOne])">
				<xsl:for-each select="child::*[local-name()=&quot;Relation&quot;]">
					<b><xsl:call-template name="k-8254"/></b>:&#160;
				</xsl:for-each>
			</xsl:if>
			<xsl:value-of select="descendant::*[local-name()=&quot;Name&quot;]"/>
			<xsl:if test="position()!=last()"><br/></xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="skrivUtTillegg">
		<xsl:if test="child::*[local-name()=&quot;Accredited&quot;]">
			<xsl:choose>
				<xsl:when test="child::*[local-name()=&quot;Accredited&quot;]/@V='true'">Resultatet er akkreditert.&#160;</xsl:when>
				<xsl:otherwise>Resultatet er ikke akkreditert.&#160;</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;StructuredInfo&quot;]">
			Se Strukturert resultat
			<xsl:if test="count(//child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]])!=1">
				<xsl:value-of select="count(//child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]])-count(following-sibling::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]])-count(parent::*[local-name()=&quot;ResultItem&quot;]/following-sibling::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]])-count(child::*[local-name()=&quot;ResultItem&quot;][child::*[local-name()=&quot;StructuredInfo&quot;]])"/>
			</xsl:if>
			under.&#160;
		</xsl:if>
		<xsl:for-each select="child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;]">
			<xsl:call-template name="line-breaks">
				<xsl:with-param name="text" select="."/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;]">
			<xsl:if test="//child::*[local-name()=&quot;Accredited&quot;] or //child::*[local-name()=&quot;StructuredInfo&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;DiagComment&quot;] or //child::*[local-name()=&quot;RefAnalysedSubject&quot;] or //child::*[local-name()=&quot;StatusInvestigation&quot;]">
				<xsl:if test="position()=1"><b>Spesifisering</b>:&#160;</xsl:if>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="contains(@S, '8212')">
					<xsl:call-template name="k-dummy-OT"/>&#160;
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="k-dummy"/>&#160;
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Comment&quot;]">
			<xsl:if test="//child::*[local-name()=&quot;Accredited&quot;] or //child::*[local-name()=&quot;StructuredInfo&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or //child::*[local-name()=&quot;DiagComment&quot;] or //child::*[local-name()=&quot;RefAnalysedSubject&quot;] or //child::*[local-name()=&quot;StatusInvestigation&quot;]">
				<xsl:if test="position()=1"><b>Kommentar til undersøkelsen</b>:&#160;</xsl:if>
			</xsl:if>
			<xsl:call-template name="line-breaks">
				<xsl:with-param name="text" select="."/>
			</xsl:call-template>&#160;
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;DiagComment&quot;]">
			<xsl:if test="//child::*[local-name()=&quot;Accredited&quot;] or //child::*[local-name()=&quot;StructuredInfo&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or //child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;RefAnalysedSubject&quot;] or //child::*[local-name()=&quot;StatusInvestigation&quot;]">
				<xsl:if test="position()=1"><b>Kommentar som diagnose</b>:&#160;</xsl:if>
			</xsl:if>
			<xsl:for-each select="child::*[local-name()=&quot;Concept&quot;]">
				<xsl:call-template name="k-dummy"/>&#160;
			</xsl:for-each>
			<xsl:for-each select="child::*[local-name()=&quot;Modifier&quot;]">
				<xsl:for-each select="child::*[local-name()=&quot;Name&quot;]">
					<b><xsl:call-template name="k-7305"/></b>:&#160;
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()=&quot;Value&quot;]">
					<xsl:call-template name="k-dummy"/>
				</xsl:for-each>
			</xsl:for-each>&#160;
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;RefAnalysedSubject&quot;]">
			<xsl:if test="//child::*[local-name()=&quot;Accredited&quot;] or //child::*[local-name()=&quot;StructuredInfo&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or //child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;DiagComment&quot;] or //child::*[local-name()=&quot;StatusInvestigation&quot;]">
				<xsl:if test="position()=1"><b>Referanse til prøve</b>:&#160;</xsl:if>
			</xsl:if>
			<xsl:call-template name="line-breaks">
				<xsl:with-param name="text" select="."/>
			</xsl:call-template>&#160;
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;StatusInvestigation&quot;]">
			<xsl:if test="//child::*[local-name()=&quot;Accredited&quot;] or //child::*[local-name()=&quot;StructuredInfo&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;Investigation&quot;]/child::*[local-name()=&quot;Spec&quot;] or //child::*[local-name()=&quot;Comment&quot;] or //child::*[local-name()=&quot;DiagComment&quot;] or //child::*[local-name()=&quot;RefAnalysedSubject&quot;]">
				<xsl:if test="position()=1"><b>Undersøkelsesstatus</b>:&#160;</xsl:if>
			</xsl:if>
			<xsl:call-template name="k-8245"/>&#160;
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
