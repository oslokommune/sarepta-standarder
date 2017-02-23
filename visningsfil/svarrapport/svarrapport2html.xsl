<?xml version="1.0" encoding="utf-8"?>
	<!-- Endringslogg
	- 06.01.17: (v4.1.2) Rettet syntaks-feil vedr. Xerces
	- 03.01.17: (v4.1.1) Lagt til konvertering av linjeskift for felt ResultItem/StructuredInfo/TextInfo/Text. Byttet &quot; med '
	- 15.11.16: Forbedringer av visning. Endringene går på lesbarhet, innføring av sammendrag, og enkelte omrokkeringer av element.
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
	<xsl:variable name="versjon" select="'svar versjonuavhengig - v4.1.2 '"/>
	
	<!-- Variabler for kolonnebredde -->
	<xsl:variable name="structured-col-width" select="'40%'"/>
	<xsl:variable name="structured-head-width" select="'20%'"/>
	
	<!-- Variabler for antall kolonner og bredde -->
	<xsl:variable name="result-col" select="15"/>
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
	<xsl:variable name="investigation-col" select="(($result-col)-1)*number(not(//child::*[local-name()='DevResultInd'] | //child::*[local-name()='TextResult'] | //child::*[local-name()='Interval'] | //child::*[local-name()='DateResult'] | //child::*[local-name()='NumResult'] | //child::*[local-name()='RefInterval'] | //child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U | //child::*[local-name()='TextResult']/child::*[local-name()='Unit'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] | //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] | //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] | //child::*[local-name()='StructuredInfo'] | //child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv'] | //child::*[local-name()='InvDate'] | //child::*[local-name()='StatusChangeDate'] | //child::*[local-name()='DescrDate'] | //child::*[local-name()='CounterSignDate'] | //child::*[local-name()='MedicalValidationDate'] | //child::*[local-name()='StatusInvestigation'] | //child::*[local-name()='IdResultItem'] | //child::*[local-name()='RefIdResultItem'] | //child::*[local-name()='RefAnalysedSubject'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="devind-col" select="(($result-col)-1-number(boolean(//child::*[local-name()='Investigation'])))*number(not(//child::*[local-name()='TextResult'] | //child::*[local-name()='Interval'] | //child::*[local-name()='DateResult'] | //child::*[local-name()='NumResult'] | //child::*[local-name()='RefInterval'] | //child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U | //child::*[local-name()='TextResult']/child::*[local-name()='Unit'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] | //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] | //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] | //child::*[local-name()='StructuredInfo'] | //child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv'] | //child::*[local-name()='InvDate'] | //child::*[local-name()='StatusChangeDate'] | //child::*[local-name()='DescrDate'] | //child::*[local-name()='CounterSignDate'] | //child::*[local-name()='MedicalValidationDate'] | //child::*[local-name()='StatusInvestigation'] | //child::*[local-name()='IdResultItem'] | //child::*[local-name()='RefIdResultItem'] | //child::*[local-name()='RefAnalysedSubject'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="res-col" select="(($result-col)-1-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='DevResultInd'])))*number(not(//child::*[local-name()='RefInterval'] | //child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U | //child::*[local-name()='TextResult']/child::*[local-name()='Unit'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] | //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] | //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] | //child::*[local-name()='StructuredInfo'] | //child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv'] | //child::*[local-name()='InvDate'] | //child::*[local-name()='StatusChangeDate'] | //child::*[local-name()='DescrDate'] | //child::*[local-name()='CounterSignDate'] | //child::*[local-name()='MedicalValidationDate'] | //child::*[local-name()='StatusInvestigation'] | //child::*[local-name()='IdResultItem'] | //child::*[local-name()='RefIdResultItem'] | //child::*[local-name()='RefAnalysedSubject'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="refinterval-col" select="(($result-col)-1-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='DevResultInd']))-number(boolean(//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult'])))*number(not(//child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U | //child::*[local-name()='TextResult']/child::*[local-name()='Unit'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] | //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] | //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] | //child::*[local-name()='StructuredInfo'] | //child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv'] | //child::*[local-name()='InvDate'] | //child::*[local-name()='StatusChangeDate'] | //child::*[local-name()='DescrDate'] | //child::*[local-name()='CounterSignDate'] | //child::*[local-name()='MedicalValidationDate'] | //child::*[local-name()='StatusInvestigation'] | //child::*[local-name()='IdResultItem'] | //child::*[local-name()='RefIdResultItem'] | //child::*[local-name()='RefAnalysedSubject'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="unit-col" select="(($result-col)-1-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='DevResultInd']))-number(boolean(//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']))-number(boolean(//child::*[local-name()='RefInterval'])))*number(not(//child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] | //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] | //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] | //child::*[local-name()='StructuredInfo'] | //child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv'] | //child::*[local-name()='InvDate'] | //child::*[local-name()='StatusChangeDate'] | //child::*[local-name()='DescrDate'] | //child::*[local-name()='CounterSignDate'] | //child::*[local-name()='MedicalValidationDate'] | //child::*[local-name()='StatusInvestigation'] | //child::*[local-name()='IdResultItem'] | //child::*[local-name()='RefIdResultItem'] | //child::*[local-name()='RefAnalysedSubject'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="comment-col" select="(($result-col)-1-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='DevResultInd']))-number(boolean(//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']))-number(boolean(//child::*[local-name()='RefInterval']))-number(boolean(//child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or //child::*[local-name()='TextResult']/child::*[local-name()='Unit'])))*number(not(//child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv'] | //child::*[local-name()='InvDate'] | //child::*[local-name()='StatusChangeDate'] | //child::*[local-name()='DescrDate'] | //child::*[local-name()='CounterSignDate'] | //child::*[local-name()='MedicalValidationDate'] | //child::*[local-name()='StatusInvestigation'] | //child::*[local-name()='IdResultItem'] | //child::*[local-name()='RefIdResultItem'] | //child::*[local-name()='RefAnalysedSubject'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="relserv-col" select="(($result-col)-1-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='DevResultInd']))-number(boolean(//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']))-number(boolean(//child::*[local-name()='RefInterval']))-number(boolean(//child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or //child::*[local-name()='TextResult']/child::*[local-name()='Unit']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] or //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] or //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or //child::*[local-name()='StructuredInfo'])))*number(not(//child::*[local-name()='InvDate'] | //child::*[local-name()='StatusChangeDate'] | //child::*[local-name()='DescrDate'] | //child::*[local-name()='CounterSignDate'] | //child::*[local-name()='MedicalValidationDate'] | //child::*[local-name()='StatusInvestigation'] | //child::*[local-name()='IdResultItem'] | //child::*[local-name()='RefIdResultItem'] | //child::*[local-name()='RefAnalysedSubject'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="date-col" select="(($result-col)-1-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='DevResultInd']))-number(boolean(//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']))-number(boolean(//child::*[local-name()='RefInterval']))-number(boolean(//child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or //child::*[local-name()='TextResult']/child::*[local-name()='Unit']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] or //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] or //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or //child::*[local-name()='StructuredInfo']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv'])))*number(not(//child::*[local-name()='StatusInvestigation'] | //child::*[local-name()='IdResultItem'] | //child::*[local-name()='RefIdResultItem'] | //child::*[local-name()='RefAnalysedSubject'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="status-col" select="(($result-col)-1-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='DevResultInd']))-number(boolean(//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']))-number(boolean(//child::*[local-name()='RefInterval']))-number(boolean(//child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or //child::*[local-name()='TextResult']/child::*[local-name()='Unit']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] or //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] or //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or //child::*[local-name()='StructuredInfo']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv']))-number(boolean(//child::*[local-name()='InvDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='DescrDate'] or //child::*[local-name()='CounterSignDate'] or //child::*[local-name()='MedicalValidationDate'])))*number(not(//child::*[local-name()='IdResultItem'] | //child::*[local-name()='RefIdResultItem'] | //child::*[local-name()='RefAnalysedSubject'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="id-col" select="(($result-col)-1-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='DevResultInd']))-number(boolean(//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']))-number(boolean(//child::*[local-name()='RefInterval']))-number(boolean(//child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or //child::*[local-name()='TextResult']/child::*[local-name()='Unit']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] or //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] or //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or //child::*[local-name()='StructuredInfo']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv']))-number(boolean(//child::*[local-name()='InvDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='DescrDate'] or //child::*[local-name()='CounterSignDate'] or //child::*[local-name()='MedicalValidationDate']))-number(boolean(//child::*[local-name()='StatusInvestigation'])))*number(not(//child::*[local-name()='RefIdResultItem'] | //child::*[local-name()='RefAnalysedSubject'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="refid-col" select="(($result-col)-1-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='DevResultInd']))-number(boolean(//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']))-number(boolean(//child::*[local-name()='RefInterval']))-number(boolean(//child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or //child::*[local-name()='TextResult']/child::*[local-name()='Unit']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] or //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] or //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or //child::*[local-name()='StructuredInfo']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv']))-number(boolean(//child::*[local-name()='InvDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='DescrDate'] or //child::*[local-name()='CounterSignDate'] or //child::*[local-name()='MedicalValidationDate']))-number(boolean(//child::*[local-name()='StatusInvestigation']))-number(boolean(//child::*[local-name()='IdResultItem'])))*number(not(//child::*[local-name()='RefAnalysedSubject'] | //child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="refsubject-col" select="(($result-col)-1-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='DevResultInd']))-number(boolean(//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']))-number(boolean(//child::*[local-name()='RefInterval']))-number(boolean(//child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or //child::*[local-name()='TextResult']/child::*[local-name()='Unit']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] or //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] or //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or //child::*[local-name()='StructuredInfo']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv']))-number(boolean(//child::*[local-name()='InvDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='DescrDate'] or //child::*[local-name()='CounterSignDate'] or //child::*[local-name()='MedicalValidationDate']))-number(boolean(//child::*[local-name()='StatusInvestigation']))-number(boolean(//child::*[local-name()='IdResultItem']))-number(boolean(//child::*[local-name()='RefIdResultItem'])))*number(not(//child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']))+1"/>
	<xsl:variable name="acc-col" select="($result-col)-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='DevResultInd']))-number(boolean(//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']))-number(boolean(//child::*[local-name()='RefInterval']))-number(boolean(//child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or //child::*[local-name()='TextResult']/child::*[local-name()='Unit']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] or //child::*[local-name()='ResultItem']/child::*[local-name()='DiagComment'] or //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or //child::*[local-name()='StructuredInfo']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv']))-number(boolean(//child::*[local-name()='InvDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='DescrDate'] or //child::*[local-name()='CounterSignDate'] or //child::*[local-name()='MedicalValidationDate']))-number(boolean(//child::*[local-name()='StatusInvestigation']))-number(boolean(//child::*[local-name()='IdResultItem']))-number(boolean(//child::*[local-name()='RefIdResultItem']))-number(boolean(//child::*[local-name()='RefAnalysedSubject']))"/>
	
	
	
	<xsl:variable name="tillegg-col" select="($result-col)-number(boolean(//child::*[local-name()='Investigation']))-number(boolean(//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']))-number(boolean(//child::*[local-name()='IdResultItem']))-number(boolean(//child::*[local-name()='RefIdResultItem']))-number(boolean(//child::*[local-name()='RefInterval']))-number(boolean(//child::*[local-name()='InvDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='DescrDate'] or //child::*[local-name()='CounterSignDate'] or //child::*[local-name()='MedicalValidationDate']))-number(boolean(//child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv']))"/>
	
		
	<!-- Boolske variabler for visning av 'Vis/Skjul' knapp ved hver overskrift. Settes til 'true()' om knappen skal vises -->
	<xsl:variable name="VisSammendragVisSkjul" select="false()"/>
	<xsl:variable name="VisAnalysertMaterialeVisSkjul" select="false()"/>
	<xsl:variable name="VisUndersokelsesresultatVisSkjul" select="false()"/>
	<xsl:variable name="VisUndersokelsesresultatHistorikkVisSkjul" select="true()"/>
	<xsl:variable name="VisUndersokelsesresultatStrukturertVisSkjul" select="false()"/>
	<xsl:variable name="VisOpprinneligRekvisisjonVisSkjul" select="false()"/>
	<xsl:variable name="VisPasientVisSkjul" select="false()"/>
	<xsl:variable name="VisUndersokelsesdyrVisSkjul" select="false()"/>
	<xsl:variable name="VisHelsetjenesteenheterVisSkjul" select="false()"/>
	<xsl:variable name="VisReferertDokumentVisSkjul" select="false()"/>
	<xsl:variable name="VisDokInfoVisSkjul" select="false()"/>
	
	<!-- Boolsk variabel om menylinjen skal vises. Settes til true() om den skal vises. -->
	<xsl:variable name="VisMenylinje" select="false()"/>
	
	<!-- Boolsk variabel for å anonymisere pasienten i visningen -->
	<xsl:variable name="Anonymisert" select="false()"/>
	
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
				<xsl:for-each select="child::*[local-name()='Message']">
					<xsl:call-template name="Message"/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="Message">
		<xsl:for-each select="child::*[local-name()='ServReport']">
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
						<xsl:for-each select="child::*[local-name()='ServProvider']">
							<xsl:call-template name="ServProviderHode"/>
						</xsl:for-each>
					</div>
				</div>
				<xsl:choose>
					<xsl:when test="child::*[local-name()='Patient']">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Pasient&#160;</div>
							<div class="No-line-content">
								<xsl:for-each select="child::*[local-name()='Patient']">
									<xsl:call-template name="PatientHode"/>
								</xsl:for-each>
							</div>
						</div>
					</xsl:when>
					<xsl:when test="child::*[local-name()='Animal']">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Undersøkelsesdyr&#160;</div>
							<div class="No-line-content">
								<xsl:for-each select="child::*[local-name()='Animal']">
									<xsl:call-template name="AnimalHode"/>
								</xsl:for-each>
							</div>
						</div>
					</xsl:when>
					<xsl:when test="child::*[local-name()='Material']">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Materiale&#160;</div>
							<div class="No-line-content">
								<xsl:for-each select="child::*[local-name()='Material']">
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
						<xsl:for-each select="child::*[local-name()='Requester']">
							<xsl:call-template name="RequesterHode"/>
						</xsl:for-each>
					</div>
				</div>
				<xsl:choose>
					<xsl:when test="child::*[local-name()='CopyDest']">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Kopimottaker&#160;</div>
							<div class="No-line-content">
								<xsl:for-each select="child::*[local-name()='CopyDest']">
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
		<xsl:for-each select="child::*[local-name()='HCP']">
			<xsl:call-template name="HCPHode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="RequesterHode">
		<xsl:for-each select="child::*[local-name()='HCP']">
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
		<xsl:if test="child::*[local-name()='DateOfDeath']">
			<div>
				<b>Dødsdato:&#160;</b>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfDeath']/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='Address']">
			<xsl:call-template name="AddressHode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="AnimalHode">
		<div>
			<xsl:if test="child::*[local-name()='Name']"><b>Navn</b>:&#160;<xsl:value-of select="child::*[local-name()='Name']"/>&#160;</xsl:if>
			<xsl:if test="child::*[local-name()='Species']"><b>Art</b>:&#160;<xsl:value-of select="child::*[local-name()='Species']"/>&#160;</xsl:if>
			<xsl:if test="child::*[local-name()='NameOwner']"><b>Eier</b>:&#160;<xsl:value-of select="child::*[local-name()='NameOwner']"/>&#160;</xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="MaterialHode">
		<div>
			<xsl:if test="child::*[local-name()='Name']"><b>Beskrivelse</b>:&#160;<xsl:value-of select="child::*[local-name()='InvMaterial']"/>&#160;</xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="HCPersonHode">
		<div>
			<xsl:value-of select="child::*[local-name()='Name']"/>
			<div class="NoPrint">,</div>&#160;</div>
	</xsl:template>
	<xsl:template name="HCPHode">
		<xsl:for-each select="child::*[local-name()='Inst']">
			<xsl:call-template name="InstHode"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='HCProf']">
			<xsl:call-template name="HCProfHode"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Address']">
			<xsl:call-template name="AddressHode"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="InstHode">
		<xsl:for-each select="child::*[local-name()='HCPerson']">
			<xsl:call-template name="HCPersonHode"/>
		</xsl:for-each>
		<div>
			<xsl:choose>
				<xsl:when test="ancestor::*[local-name()='ServProvider']"><font size="3em"><b><xsl:value-of select="child::*[local-name()='Name']"/></b></font></xsl:when>
				<xsl:otherwise><xsl:value-of select="child::*[local-name()='Name']"/></xsl:otherwise>
			</xsl:choose>
			<!-- <xsl:value-of select="child::*[local-name()='Name']"/> -->
		</div>
		<xsl:for-each select="child::*[local-name()='Dept']">
			<div>
				<div class="NoPrint">-&#160;</div>
				<xsl:value-of select="child::*[local-name()='Name']"/>&#160;</div>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="HCProfHode">
		<div>
			<xsl:for-each select="child::*[local-name()='Type']">
				<xsl:call-template name="k-9060"/>
			</xsl:for-each>&#160;<xsl:choose>
				<xsl:when test="ancestor::*[local-name()='ServProvider']"><font size="3em"><b><xsl:value-of select="child::*[local-name()='Name']"/></b></font></xsl:when>
				<xsl:otherwise><xsl:value-of select="child::*[local-name()='Name']"/></xsl:otherwise>
			</xsl:choose>
			<!--<xsl:value-of select="child::*[local-name()='Name']"/>-->
		</div>
	</xsl:template>
	<xsl:template name="CopyDestHode">
		<xsl:for-each select="child::*[local-name()='HCP']">
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
	<!-- Hoveddokument -->
	<xsl:template name="ResultBody">
		<div class="{$stil}">
			<xsl:if test="$VisMenylinje">
				<xsl:call-template name="FellesMeny">
					<xsl:with-param name="position" select="position()"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:variable name="position" select="position()"/> <!-- I svarrapport v1.3 og lavere er det mulig å legge ved flere ServReport -->
			<xsl:variable name="color">
				<xsl:choose>
					<xsl:when test="child::*[local-name()='ServType'][@V='M' or @V='C' or @V='O']">red</xsl:when>
					<xsl:otherwise>black</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- Overskrift for svarrapport -->
			<h1>Svarrapport
				<xsl:for-each select="child::*[local-name()='MsgDescr']">
					<xsl:call-template name="k-8202"/>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='ServType']">&#160;-
					<font color="{$color}"><xsl:call-template name="k-7309"/></font>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='Status']">&#160;-
					<xsl:call-template name="k-7306"/>
				</xsl:for-each>
			</h1>
			<br/>
			<!-- Tabell for sammendrag -->
			<xsl:variable name="id0">
				<xsl:value-of select="concat('ServReport',$position, '0')"/>
			</xsl:variable>
			<xsl:variable name="DisplayBlock0">
				<xsl:choose>
					<xsl:when test="$VisSammendragVisSkjul">inline-block</xsl:when>
					<xsl:otherwise>block</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<h2 style="background-color:#e3e3e3; padding-top:1em; margin-top:0em; padding-left:1em; margin-left:0em; display:{$DisplayBlock0}" id="{$id0}">Sammendrag</h2>
			<xsl:if test="$VisSammendragVisSkjul">
				<label for="vis{$id0}" class="VisSkjul">Vis/Skjul</label>
				<input type="checkbox" id="vis{$id0}" style="display: none; margin-bottom:0em;"/>
			</xsl:if>
			<table style="background-color:#e3e3e3; padding-left:1em; margin-left:0em;">
				<tbody>
					<xsl:if test="child::*[local-name()='Patient'][descendant::*[local-name()='CollectedDate']] or child::*[local-name()='Patient'][descendant::*[local-name()='AnatomicalOrigin']]">
						<tr>
							<xsl:if test="child::*[local-name()='Patient'][descendant::*[local-name()='CollectedDate']]">
								<th>Dato&#160;prøvetakning</th>
								<td colspan="{(($std-col)-2)*number(not(child::*[local-name()='Patient'][descendant::*[local-name()='AnatomicalOrigin']]))+1}">
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="descendant::*[local-name()='CollectedDate']/@V"/>
									</xsl:call-template>
								</td>
							</xsl:if>
							<xsl:if test="child::*[local-name()='Patient'][descendant::*[local-name()='AnatomicalOrigin']]">
								<th>Anatomisk&#160;lokasjon</th>
								<td colspan="{($std-col)-1-count(child::*[local-name()='Patient'][descendant::*[local-name()='CollectedDate']])*2}">
									<xsl:for-each select="descendant::*[local-name()='AnatomicalOrigin']">
										<xsl:value-of select="."/>
										<xsl:if test="position() != last()">,&#160;</xsl:if>
									</xsl:for-each>
								</td>
							</xsl:if>
						</tr>
					</xsl:if>
					<xsl:if test="descendant::*[local-name()='ResultItem'][descendant::*[local-name()='RelServProv'][child::*[local-name()='Relation'][@V='ALE']]] or child::*[local-name()='Requester'][descendant::*[local-name()='Name']] or child::*[local-name()='ServProvider'][descendant::*[local-name()='Name']]">
						<tr>
							<xsl:if test="descendant::*[local-name()='ResultItem'][descendant::*[local-name()='RelServProv'][child::*[local-name()='Relation'][@V='ALE']]]">
								<th>Ansvarlig&#160;lege</th>
								<td colspan="{(($std-col)-2)*number(not(child::*[local-name()='Requester'][descendant::*[local-name()='Name']] or child::*[local-name()='ServProvider'][descendant::*[local-name()='Name']]))+1}">
									<xsl:for-each select="descendant::*[local-name()='ResultItem'][child::*[local-name()='RelServProv'][child::*[local-name()='Relation'][@V='ALE']] and not(descendant::*[local-name()='RelServProv']/descendant::*[local-name()='Name'] = preceding-sibling::*[descendant::*[local-name()='RelServProv']]/descendant::*[local-name()='Name']) and not(descendant::*[local-name()='RelServProv']/descendant::*[local-name()='Name'] = ../preceding-sibling::*[descendant::*[local-name()='RelServProv']]/descendant::*[local-name()='Name'])]">
										<xsl:if test="child::*[local-name()='ServType']/@V != 'H' or not(child::*[local-name()='ServType']/@V)">
											<xsl:value-of select="descendant::*[local-name()='RelServProv']/descendant::*[local-name()='Name']"/><!-- Navn på ansvalig lege for resultatet ikke merket med historikk og som ikke er lik ansvarlig lege for neste resultat -->
										</xsl:if>
										<xsl:if test="position() != last()">,&#160;</xsl:if>
									</xsl:for-each>
								</td>
							</xsl:if>
							<xsl:if test="child::*[local-name()='Requester'][descendant::*[local-name()='Name']]">
								<th>Henvisende&#160;instans</th>
								<td colspan="{(($std-col)-2-number(boolean(descendant::*[local-name()='ResultItem'][descendant::*[local-name()='RelServProv'][child::*[local-name()='Relation'][@V='ALE']]]))*2)*number(not(//child::*[local-name()='ServProvider'][descendant::*[local-name()='Name']]))+1}">
									<xsl:for-each select="child::*[local-name()='Requester']/descendant::*[local-name()='Name']">
										<xsl:value-of select="."/>
										<xsl:if test="position() != last()">,&#160;</xsl:if>
									</xsl:for-each>
								</td>
							</xsl:if>
							<xsl:if test="child::*[local-name()='ServProvider'][descendant::*[local-name()='Name']]">
								<th>Tjenesteyter</th>
								<td colspan="{($std-col)-1-number(boolean(descendant::*[local-name()='ResultItem'][descendant::*[local-name()='RelServProv'][child::*[local-name()='Relation'][@V='ALE']]]))*2-number(boolean(child::*[local-name()='Requester'][descendant::*[local-name()='Name']]))*2}">
									<xsl:for-each select="child::*[local-name()='ServProvider']/descendant::*[local-name()='Name']">
										<xsl:value-of select="."/>
										<xsl:if test="position() != last()">,&#160;</xsl:if>
									</xsl:for-each>
								</td>
							</xsl:if>
						</tr>
					</xsl:if>
					<xsl:if test="child::*[local-name()='MsgDescr']/@V!='CLIN'"> <!-- Resultat tas ikke med i sammendraget hvis svar innen Medisinsk biokjemi -->
						<!-- Tom rad før resultat -->
						<xsl:if test="child::*[local-name()='Patient'][descendant::*[local-name()='CollectedDate']] or child::*[local-name()='Patient'][descendant::*[local-name()='AnatomicalOrigin']] or descendant::*[local-name()='ResultItem'][descendant::*[local-name()='RelServProv'][child::*[local-name()='Relation'][@V='ALE']]] or child::*[local-name()='Requester'][descendant::*[local-name()='Name']]">
							<tr>
								<td colspan="{($std-col)}">&#160;</td>
							</tr>
						</xsl:if>
						<xsl:for-each select="descendant::*[local-name()='ResultItem'][(child::*[local-name()='TextResult'] or child::*[local-name()='Interval'] or child::*[local-name()='DateResult'] or child::*[local-name()='NumResult'] or child::*[local-name()='Comment']) and (child::*[local-name()='ServType']/@V != 'H' or not(child::*[local-name()='ServType']/@V)) and (../child::*[local-name()='ServType']/@V != 'H' or not(../child::*[local-name()='ServType']/@V))]">
							<xsl:choose>
								<xsl:when test="child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR' and not(descendant::*[local-name()='ServType']/@V != 'H' or not(descendant::*[local-name()='ServType']/@V))">
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td width="{($std-td)}">
											<xsl:if test="child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR'">
												<b>Gruppe:&#160;</b>
											</xsl:if>
											<xsl:choose>
												<xsl:when test="child::*[local-name()='Investigation']">
													<xsl:call-template name="skrivUtUndersokelse"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:for-each select="..">
														<xsl:call-template name="skrivUtUndersokelse"/>
													</xsl:for-each>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<td colspan="{(($std-col)-1)*number(not(child::*[local-name()='Comment']))+1}">
											<xsl:call-template name="skrivUtResultat">
												<xsl:with-param name="sammendrag" select="true()"/>
											</xsl:call-template>
										</td>
										<xsl:if test="child::*[local-name()='Comment']">
											<td colspan="{($std-col)-2}">
												<xsl:call-template name="line-breaks">
													<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
												</xsl:call-template>
											</td>
										</xsl:if>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="child::*[local-name()='Comment'] or child::*[local-name()='CodedComment']">
						<tr>
							<td colspan="{($std-col)}">&#160;</td>
						</tr>
						<tr>
							<th>Kommentar til svarrapporten</th>
							<td colspan="{($std-col)-1}">
								<xsl:for-each select="child::*[local-name()='Comment']">
									<xsl:call-template name="line-breaks">
										<xsl:with-param name="text" select="."/>
									</xsl:call-template>&#160;
								</xsl:for-each>
								<xsl:for-each select="child::*[local-name()='CodedComment'][contains(@S,'8272')]">
									<xsl:if test="position()=1">
										<b>Anbefaler ny undersøkelse:&#160;</b>
									</xsl:if>
									<xsl:call-template name="k-8272"/>
									<xsl:choose>
										<xsl:when test="position()!=last()">,&#160;</xsl:when>
										<xsl:otherwise>&#160;</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
								<xsl:for-each select="child::*[local-name()='CodedComment'][contains(@S,'8273')]">
									<xsl:if test="position()=1">
										<b>Hastegrad:&#160;</b>
									</xsl:if>
									<xsl:call-template name="k-8273"/>&#160;
								</xsl:for-each>
								<xsl:for-each select="child::*[local-name()='CodedComment'][not(contains(@S,'8272')) and not(contains(@S,'8273'))]">
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
				</tbody>
			</table>
			<!-- Tabell for Undersøkelsesresultat -->
			<xsl:if test="//child::*[local-name()='ResultItem']">
				<xsl:variable name="id3">
					<xsl:value-of select="concat('ResultItem',$position, '0')"/>
				</xsl:variable>
				<xsl:variable name="DisplayBlock">
					<xsl:choose>
						<xsl:when test="$VisUndersokelsesresultatVisSkjul">inline-block</xsl:when>
						<xsl:otherwise>block</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<h2 style="display:{$DisplayBlock}" id="{$id3}">Undersøkelsesresultat</h2> 
				<xsl:if test="$VisUndersokelsesresultatVisSkjul">
					<label for="vis{$id3}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id3}" style="display: none; margin-bottom:0em;"/>
				</xsl:if>
				<table> <!-- Denne tabellen kan bli tom om alle resultatene er merket med historikk. Antar det aldri skjer. -->
					<tbody>
						<xsl:for-each select="//child::*[local-name()='ResultItem'][(child::*[local-name()='ServType']/@V != 'H' or not(child::*[local-name()='ServType']/@V)) and child::*[local-name()='ResultItem'][child::*[local-name()='ServType']/@V != 'H' or not(child::*[local-name()='ServType']/@V)]] | //child::*[local-name()='ResultItem'][(child::*[local-name()='ServType']/@V != 'H' or not(child::*[local-name()='ServType']/@V)) and not(../child::*[local-name()='ServType']/@V = 'H') and not(child::*[local-name()='ResultItem'])]"> <!-- Alle hovedsvar som ikke er merket med historikk som har minst et delsvar som ikke er merket historikk samt alle hovedsvar/delsvar som ikke er merket med historikk hvor forelder ikke er merket med historikk og som ikke selv har delsvar-->
							<xsl:variable name="slaaSammen"><!--  Variabel som er 'true' om hovedsvaret og dets første delsvar ikke har felles tabellelementer og dermed kan slås sammen - 'false' ellers.-->
								<xsl:variable name="overlapp">
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='Investigation'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR'">
										<xsl:if test="child::*[local-name()='Investigation'] or child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR'">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='DevResultInd']">
										<xsl:if test="child::*[local-name()='DevResultInd']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='TextResult'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='Interval'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='DateResult'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='NumResult']">
										<xsl:if test="child::*[local-name()='TextResult'] or child::*[local-name()='Interval'] or child::*[local-name()='DateResult'] or child::*[local-name()='NumResult']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='RefInterval']">
										<xsl:if test="child::*[local-name()='RefInterval']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or child::*[local-name()='ResultItem'][1]/child::*[local-name()='TextResult']/child::*[local-name()='Unit']">
										<xsl:if test="child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or child::*[local-name()='TextResult']/child::*[local-name()='Unit']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='Comment'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='DiagComment'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='StructuredInfo']">
										<xsl:if test="child::*[local-name()='Comment'] or child::*[local-name()='DiagComment'] or child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or child::*[local-name()='StructuredInfo']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='RelServProv']">
										<xsl:if test="child::*[local-name()='RelServProv']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='InvDate'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='StatusChangeDate'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='DescrDate'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='CounterSignDate'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='MedicalValidationDate']">
										<xsl:if test="child::*[local-name()='InvDate'] or child::*[local-name()='StatusChangeDate'] or child::*[local-name()='DescrDate'] or child::*[local-name()='CounterSignDate'] or child::*[local-name()='MedicalValidationDate']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='StatusInvestigation']">
										<xsl:if test="child::*[local-name()='StatusInvestigation']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='IdResultItem']">
										<xsl:if test="child::*[local-name()='IdResultItem']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='RefIdResultItem']">RelServProv
										<xsl:if test="child::*[local-name()='RefIdResultItem']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='Accredited']">
										<xsl:if test="child::*[local-name()='Accredited']">Ja</xsl:if>
									</xsl:if>
								</xsl:variable>
								<xsl:choose>
									  <xsl:when test="child::*[local-name()='ResultItem'] and not(contains($overlapp,'Ja'))">true</xsl:when> 
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="forsteDelsvarSlaattSammen"><!-- Variabel som er 'true' om nåværende node er første delsvar som er slått sammen med sitt hovedsvar - 'false' ellers -->
								<xsl:variable name="overlappForelder">
									<xsl:if test="../child::*[local-name()='Investigation'] or ../child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR'">
										<xsl:if test="child::*[local-name()='Investigation'] or child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR'">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='DevResultInd']">
										<xsl:if test="child::*[local-name()='DevResultInd']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='TextResult'] or ../child::*[local-name()='Interval'] or ../child::*[local-name()='DateResult'] or ../child::*[local-name()='NumResult']">
										<xsl:if test="child::*[local-name()='TextResult'] or child::*[local-name()='Interval'] or child::*[local-name()='DateResult'] or child::*[local-name()='NumResult']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='RefInterval']">
										<xsl:if test="child::*[local-name()='RefInterval']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or ../child::*[local-name()='TextResult']/child::*[local-name()='Unit']">
										<xsl:if test="child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or child::*[local-name()='TextResult']/child::*[local-name()='Unit']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='Comment'] or ../child::*[local-name()='DiagComment'] or ../child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or ../child::*[local-name()='StructuredInfo']">
										<xsl:if test="child::*[local-name()='Comment'] or child::*[local-name()='DiagComment'] or child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or child::*[local-name()='StructuredInfo']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='RelServProv']">
										<xsl:if test="child::*[local-name()='RelServProv']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='InvDate'] or ../child::*[local-name()='StatusChangeDate'] or ../child::*[local-name()='DescrDate'] or ../child::*[local-name()='CounterSignDate'] or ../child::*[local-name()='MedicalValidationDate']">
										<xsl:if test="child::*[local-name()='InvDate'] or child::*[local-name()='StatusChangeDate'] or child::*[local-name()='DescrDate'] or child::*[local-name()='CounterSignDate'] or child::*[local-name()='MedicalValidationDate']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='StatusInvestigation']">
										<xsl:if test="child::*[local-name()='StatusInvestigation']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='IdResultItem']">
										<xsl:if test="child::*[local-name()='IdResultItem']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='RefIdResultItem']">RelServProv
										<xsl:if test="child::*[local-name()='RefIdResultItem']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='Accredited']">
										<xsl:if test="child::*[local-name()='Accredited']">Ja</xsl:if>
									</xsl:if>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="local-name(..)='ResultItem' and not(preceding-sibling::*[1][self::*[local-name()='ResultItem']]) and not(contains($overlappForelder,'Ja'))">true</xsl:when> 
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="rowColor">
								<xsl:choose>
									<xsl:when test="boolean(position() mod 2)">#f8f8f8</xsl:when>
									<xsl:otherwise>white</xsl:otherwise>
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
										<xsl:with-param name="rowColor" select="$rowColor"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Tabell for Historiske Undersøkelsesresultat -->
			<xsl:if test="//child::*[local-name()='ResultItem'][child::*[local-name()='ServType']/@V = 'H']">
				<xsl:variable name="id30">
					<xsl:value-of select="concat('ResultItem',$position)"/>
				</xsl:variable>
				<xsl:variable name="DisplayBlock">
					<xsl:choose>
						<xsl:when test="$VisUndersokelsesresultatHistorikkVisSkjul">inline-block</xsl:when>
						<xsl:otherwise>block</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<h2 style="display:{$DisplayBlock}" id="{$id30}">Tidligere&#160;sendt&#160;undersøkelsesresultat&#160;</h2>
				<xsl:if test="$VisUndersokelsesresultatHistorikkVisSkjul">
					<label for="vis{$id30}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id30}" style="display: none; margin-bottom:0em;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()='ResultItem'][child::*[local-name()='ServType']/@V = 'H'] | //child::*[local-name()='ResultItem'][child::*[local-name()='ServType']/@V = 'H']/child::*[local-name()='ResultItem'] | //child::*[local-name()='ResultItem'][child::*[local-name()='ResultItem'][child::*[local-name()='ServType']/@V = 'H']]"> <!-- Alle hovedsvar/delsvar merket med historikk, alle delsvar av hovedsvar merket med historikk, samt alle hovedsvar som har delsvar merket med historikk -->
							<xsl:variable name="slaaSammen"><!--  Variabel som er 'true' om hovedsvaret og dets første delsvar ikke har felles tabellelementer og dermed kan slås sammen - 'false' ellers.-->
								<xsl:variable name="overlapp">
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='Investigation'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR'">
										<xsl:if test="child::*[local-name()='Investigation'] or child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR'">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='DevResultInd']">
										<xsl:if test="child::*[local-name()='DevResultInd']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='TextResult'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='Interval'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='DateResult'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='NumResult']">
										<xsl:if test="child::*[local-name()='TextResult'] or child::*[local-name()='Interval'] or child::*[local-name()='DateResult'] or child::*[local-name()='NumResult']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='RefInterval']">
										<xsl:if test="child::*[local-name()='RefInterval']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or child::*[local-name()='ResultItem'][1]/child::*[local-name()='TextResult']/child::*[local-name()='Unit']">
										<xsl:if test="child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or child::*[local-name()='TextResult']/child::*[local-name()='Unit']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='Comment'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='DiagComment'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='StructuredInfo']">
										<xsl:if test="child::*[local-name()='Comment'] or child::*[local-name()='DiagComment'] or child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or child::*[local-name()='StructuredInfo']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='RelServProv']">
										<xsl:if test="child::*[local-name()='RelServProv']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='InvDate'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='StatusChangeDate'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='DescrDate'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='CounterSignDate'] or child::*[local-name()='ResultItem'][1]/child::*[local-name()='MedicalValidationDate']">
										<xsl:if test="child::*[local-name()='InvDate'] or child::*[local-name()='StatusChangeDate'] or child::*[local-name()='DescrDate'] or child::*[local-name()='CounterSignDate'] or child::*[local-name()='MedicalValidationDate']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='StatusInvestigation']">
										<xsl:if test="child::*[local-name()='StatusInvestigation']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='IdResultItem']">
										<xsl:if test="child::*[local-name()='IdResultItem']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='RefIdResultItem']">RelServProv
										<xsl:if test="child::*[local-name()='RefIdResultItem']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="child::*[local-name()='ResultItem'][1]/child::*[local-name()='Accredited']">
										<xsl:if test="child::*[local-name()='Accredited']">Ja</xsl:if>
									</xsl:if>
								</xsl:variable>
								<xsl:choose>
									  <xsl:when test="child::*[local-name()='ResultItem'] and not(contains($overlapp,'Ja'))">true</xsl:when> 
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="forsteDelsvarSlaattSammen"><!-- Variabel som er 'true' om nåværende node er første delsvar som er slått sammen med sitt hovedsvar - 'false' ellers -->
								<xsl:variable name="overlappForelder">
									<xsl:if test="../child::*[local-name()='Investigation'] or ../child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR'">
										<xsl:if test="child::*[local-name()='Investigation'] or child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR'">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='DevResultInd']">
										<xsl:if test="child::*[local-name()='DevResultInd']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='TextResult'] or ../child::*[local-name()='Interval'] or ../child::*[local-name()='DateResult'] or ../child::*[local-name()='NumResult']">
										<xsl:if test="child::*[local-name()='TextResult'] or child::*[local-name()='Interval'] or child::*[local-name()='DateResult'] or child::*[local-name()='NumResult']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='RefInterval']">
										<xsl:if test="child::*[local-name()='RefInterval']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or ../child::*[local-name()='TextResult']/child::*[local-name()='Unit']">
										<xsl:if test="child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or child::*[local-name()='TextResult']/child::*[local-name()='Unit']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='Comment'] or ../child::*[local-name()='DiagComment'] or ../child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or ../child::*[local-name()='StructuredInfo']">
										<xsl:if test="child::*[local-name()='Comment'] or child::*[local-name()='DiagComment'] or child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or child::*[local-name()='StructuredInfo']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='RelServProv']">
										<xsl:if test="child::*[local-name()='RelServProv']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='InvDate'] or ../child::*[local-name()='StatusChangeDate'] or ../child::*[local-name()='DescrDate'] or ../child::*[local-name()='CounterSignDate'] or ../child::*[local-name()='MedicalValidationDate']">
										<xsl:if test="child::*[local-name()='InvDate'] or child::*[local-name()='StatusChangeDate'] or child::*[local-name()='DescrDate'] or child::*[local-name()='CounterSignDate'] or child::*[local-name()='MedicalValidationDate']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='StatusInvestigation']">
										<xsl:if test="child::*[local-name()='StatusInvestigation']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='IdResultItem']">
										<xsl:if test="child::*[local-name()='IdResultItem']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='RefIdResultItem']">RelServProv
										<xsl:if test="child::*[local-name()='RefIdResultItem']">Ja</xsl:if>
									</xsl:if>
									<xsl:if test="../child::*[local-name()='Accredited']">
										<xsl:if test="child::*[local-name()='Accredited']">Ja</xsl:if>
									</xsl:if>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="local-name(..)='ResultItem' and not(preceding-sibling::*[1][self::*[local-name()='ResultItem']]) and not(contains($overlappForelder,'Ja'))">true</xsl:when> 
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="rowColor">
								<xsl:choose>
									<xsl:when test="boolean(position() mod 2)">#f8f8f8</xsl:when>
									<xsl:otherwise>white</xsl:otherwise>
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
										<xsl:with-param name="rowColor" select="$rowColor"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Tabell for Strukturert resultat -->
			<xsl:if test="//child::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']]">
				<xsl:for-each select="//child::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']]">
					<xsl:variable name="id03">
						<xsl:value-of select="concat('StructuredInfo',$position,position())"/>
					</xsl:variable>
					<xsl:variable name="DisplayBlock">
						<xsl:choose>
							<xsl:when test="$VisUndersokelsesresultatStrukturertVisSkjul">inline-block</xsl:when>
							<xsl:otherwise>block</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<h2 style="display:{$DisplayBlock}" id="{$id03}">Strukturert resultat
						<xsl:if test="last()!=1">
							<xsl:value-of select="count(//child::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']])-count(following-sibling::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']])-count(parent::*[local-name()='ResultItem']/following-sibling::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']])-count(child::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']])"/>
						</xsl:if>
					</h2>
					<xsl:if test="$VisUndersokelsesresultatStrukturertVisSkjul">
						<label for="vis{$id03}" class="VisSkjul">Vis/Skjul</label>
						<input type="checkbox" id="vis{$id03}" style="display: none; margin-bottom:0em;"/>
					</xsl:if>
					<xsl:call-template name="ResultItemStructuredInfo"/>
				</xsl:for-each>
			</xsl:if>
			<!-- Tabell for analysert objekt -->
			<xsl:if test="//child::*[local-name()='AnalysedSubject']">
				<xsl:variable name="id2">
					<xsl:value-of select="concat('AnalysedSubject',$position)"/>
				</xsl:variable>
				<xsl:variable name="DisplayBlock">
					<xsl:choose>
						<xsl:when test="$VisAnalysertMaterialeVisSkjul">inline-block</xsl:when>
						<xsl:otherwise>block</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<h2 style="display:{$DisplayBlock}" id="{$id2}">Analysert materiale</h2>
				<xsl:if test="$VisAnalysertMaterialeVisSkjul">
					<label for="vis{$id2}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id2}" style="display: none; margin-bottom:0em;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="child::*[local-name()='Patient']/child::*[local-name()='AnalysedSubject'] | child::*[local-name()='Animal']/child::*[local-name()='AnalysedSubject'] | child::*[local-name()='Material']/child::*[local-name()='AnalysedSubject']">
							<xsl:call-template name="AnalysedSubject">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="pos" select="position()"/>
								<xsl:with-param name="last" select="last()"/>
							</xsl:call-template>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<!-- Tabell for oprinnelig rekvisisjon -->
			<xsl:for-each select="child::*[local-name()='ServReq']">
				<xsl:variable name="id4">
					<xsl:value-of select="concat('ServReq',$position)"/>
				</xsl:variable>
				<xsl:variable name="DisplayBlock">
					<xsl:choose>
						<xsl:when test="$VisOpprinneligRekvisisjonVisSkjul">inline-block</xsl:when>
						<xsl:otherwise>block</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<h2 style="display:{$DisplayBlock}" id="{$id4}">Opprinnelig rekvisisjon
					<xsl:for-each select="child::*[local-name()='MsgDescr']">
						<xsl:call-template name="k-8202"/>
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()='ServType']">&#160;-
						<xsl:call-template name="k-7309"/>
					</xsl:for-each>
				</h2>
				<xsl:if test="$VisOpprinneligRekvisisjonVisSkjul">
					<label for="vis{$id4}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id4}" style="display: none; margin-bottom:0em;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:call-template name="ServReq">
							<xsl:with-param name="col" select="$std-col"/>
						</xsl:call-template>
					</tbody>
				</table>
			</xsl:for-each>
			<!-- Tabell for øvrig pasientinformasjon -->
			<xsl:for-each select="child::*[local-name()='Patient']">
				<xsl:if test="child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='Sex'] or child::*[local-name()='DateOfBirth'] or child::*[local-name()='DateOfDeath'] or child::*[local-name()='AdmLocation'] or child::*[local-name()='AdditionalId'] or child::*[local-name()='InfItem'] or child::*[local-name()='Patient']">
					<xsl:variable name="id5">
						<xsl:value-of select="concat('Patient',$position)"/>
					</xsl:variable>
					<xsl:variable name="DisplayBlock">
						<xsl:choose>
							<xsl:when test="$VisPasientVisSkjul">inline-block</xsl:when>
							<xsl:otherwise>block</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<h2 style="display:{$DisplayBlock}" id="{$id5}">Pasient</h2>
					<xsl:if test="$VisPasientVisSkjul">
						<label for="vis{$id5}" class="VisSkjul">Vis/Skjul</label>
						<input type="checkbox" id="vis{$id5}" style="display: none; margin-bottom:0em;"/>
					</xsl:if>
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
			<xsl:for-each select="child::*[local-name()='Animal']">
				<xsl:if test="child::*[local-name()='Sex'] or child::*[local-name()='Animal']">
					<xsl:variable name="id6">
						<xsl:value-of select="concat('Animal',$position)"/>
					</xsl:variable>
					<xsl:variable name="DisplayBlock">
						<xsl:choose>
							<xsl:when test="$VisUndersokelsesdyrVisSkjul">inline-block</xsl:when>
							<xsl:otherwise>block</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<h2 style="display:{$DisplayBlock}" id="{$id6}">Undersøkelsesdyr</h2>
					<xsl:if test="$VisUndersokelsesdyrVisSkjul">
						<label for="vis{$id6}" class="VisSkjul">Vis/Skjul</label>
						<input type="checkbox" id="vis{$id6}" style="display: none; margin-bottom:0em;"/>
					</xsl:if>
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
			<xsl:variable name="DisplayBlock7">
				<xsl:choose>
					<xsl:when test="$VisHelsetjenesteenheterVisSkjul">inline-block</xsl:when>
					<xsl:otherwise>block</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<h2 style="display:{$DisplayBlock7}" id="{$id7}">Helsetjenesteenheter</h2>
			<xsl:if test="$VisHelsetjenesteenheterVisSkjul">
				<label for="vis{$id7}" class="VisSkjul">Vis/Skjul</label>
				<input type="checkbox" id="vis{$id7}" style="display: none; margin-bottom:0em;"/>
			</xsl:if>
			<table>
				<tbody>
					<xsl:for-each select="child::*[local-name()='ServProvider'] | child::*[local-name()='Requester'] | child::*[local-name()='PaymentResponsible'] | child::*[local-name()='CopyDest'] | child::*[local-name()='RelServProv'] | .//child::*[local-name()='RelServProv'][descendant::*[local-name()='Id']] | .//child::*[local-name()='ResponsibleHcp'] | child::*[local-name()='Patient']/child::*[local-name()='AdmLocation']">
						<xsl:variable name="historikk">
							<xsl:choose>
								<xsl:when test="ancestor::*[local-name()='ResultItem'][child::*[local-name()='ServType']/@V='H']">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="local-name()='ServProvider'">
							<xsl:call-template name="ServProvider">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()='Requester'">
							<xsl:call-template name="Requester">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()='PaymentResponsible'">
							<xsl:call-template name="PaymentResponsible">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()='CopyDest'">
							<xsl:call-template name="CopyDest">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()='RelServProv'">
							<xsl:call-template name="RelServProv">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()='ResponsibleHcp'">
							<xsl:call-template name="ResponsibleHcp">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="local-name()='AdmLocation'">
							<xsl:call-template name="AdmLocation">
								<xsl:with-param name="col" select="$std-col"/>
								<xsl:with-param name="historikk" select="$historikk"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
				</tbody>
			</table>
			<!-- Tabell for referert dokument -->
			<xsl:if test="child::*[local-name()='RefDoc']">
				<xsl:variable name="id8">
					<xsl:value-of select="concat('RefDoc',$position)"/>
				</xsl:variable>
				<xsl:variable name="DisplayBlock">
					<xsl:choose>
						<xsl:when test="$VisReferertDokumentVisSkjul">inline-block</xsl:when>
						<xsl:otherwise>block</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<h2 style="display:{$DisplayBlock}" id="{$id8}">Referert dokument</h2>
				<xsl:if test="$VisReferertDokumentVisSkjul">
					<label for="vis{$id8}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id8}" style="display: none; margin-bottom:0em;"/>
				</xsl:if>
				<table>
					<tbody>
						<xsl:for-each select="child::*[local-name()='RefDoc']">
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
			<xsl:variable name="id22">
				<xsl:value-of select="concat('Dokumentinformasjon',position())"/>
			</xsl:variable>
			<xsl:variable name="DisplayBlock">
				<xsl:choose>
					<xsl:when test="$VisDokInfoVisSkjul">inline-block</xsl:when>
					<xsl:otherwise>block</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<h2 style="display:{$DisplayBlock}" id="{$id22}">Dokumentinformasjon</h2>
			<xsl:if test="$VisDokInfoVisSkjul">
				<label for="vis{$id22}" class="VisSkjul">Vis/Skjul</label>
				<input type="checkbox" id="vis{$id22}" style="display: none; margin-bottom:0em;"/>
			</xsl:if>
			<table>
				<tbody>
					<tr>
						<th>Melding sendt</th>
						<td width="{((($std-col)-2)*number(not(child::*[local-name()='ServProvId'] | ../child::*[local-name()='MsgId']))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()='ServProvId'] | ../child::*[local-name()='MsgId']))+1}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../child::*[local-name()='GenDate']/@V"/>
							</xsl:call-template>
						</td>
						<th>Tjenesteyters id</th>
						<td width="{((($std-col)-2-count(../child::*[local-name()='GenDate'])*2)*number(not(../child::*[local-name()='MsgId']))+1)*$std-td}px" colspan="{(($std-col)-2-count(../child::*[local-name()='GenDate'])*2)*number(not(../child::*[local-name()='MsgId']))+1}">
							<xsl:value-of select="child::*[local-name()='ServProvId']"/>
						</td>
						<th>Meldingsid</th>
						<td colspan="{($std-col)-1-count(child::*[local-name()='ServProvId'] | child::*[local-name()='MsgId'])*2}">
							<xsl:value-of select="../child::*[local-name()='MsgId']"/>
						</td>
					</tr>
					<tr>
						<th>Utstedt-dato</th>
						<td width="{((($std-col)-2)*number(not(child::*[local-name()='ApprDate'] | child::*[local-name()='CancellationCode']))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()='ApprDate'] | child::*[local-name()='CancellationCode']))+1}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='IssueDate']/@V"/>
							</xsl:call-template>
						</td>
						<xsl:if test="child::*[local-name()='ApprDate']">
							<th>Godkjent-dato</th>
							<td width="{((($std-col)-2-count(child::*[local-name()='IssueDate'])*2)*number(not(child::*[local-name()='CancellationCode']))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()='IssueDate'])*2)*number(not(child::*[local-name()='CancellationCode']))+1}">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()='ApprDate']/@V"/>
								</xsl:call-template>
							</td>
						</xsl:if>
						<xsl:if test="child::*[local-name()='CancellationCode']">
							<th>Årsak til kansellering</th>
							<td colspan="{($std-col)-1-count(child::*[local-name()='IssueDate'] | child::*[local-name()='ApprDate'])*2}">
								<xsl:for-each select="child::*[local-name()='CancellationCode']">
									<xsl:call-template name="k-dummy"/>
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
		<div id="FellesMeny" class="FellesMeny">
			<ul>
				<!-- Denne er fjernet
				<li>
					<xsl:variable name="temp1" select="concat('ServReport',$position)"/>
					<a href="#{$temp1}">Meldingsinformasjon</a>
				</li> -->
				<xsl:if test=".//child::*[local-name()='ResultItem']">
					<li>
						<xsl:variable name="temp3" select="concat('ResultItem',$position)"/>
						<a href="#{$temp3}">Undersøkelsesresultat</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']]">
					<li>
						<xsl:variable name="temp03" select="concat('StructuredInfo',$position)"/>
						<a href="#{$temp03}">Strukturert resultat</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()='Patient']/child::*[local-name()='AnalysedSubject'] or .//child::*[local-name()='Animal']/child::*[local-name()='AnalysedSubject'] or .//child::*[local-name()='Material']/child::*[local-name()='AnalysedSubject']">
					<li>
						<xsl:variable name="temp2" select="concat('AnalysedSubject',$position)"/>
						<a href="#{$temp2}">Analysert materiale</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()='ServReq']">
					<li>
						<xsl:variable name="temp4" select="concat('ServReq',$position)"/>
						<a href="#{$temp4}">Opprinnelig rekvisisjon</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()='Patient']/child::*[local-name()='BasisForHealthServices'] or .//child::*[local-name()='Patient']/child::*[local-name()='Sex'] or .//child::*[local-name()='Patient']/child::*[local-name()='DateOfBirth'] or .//child::*[local-name()='Patient']/child::*[local-name()='DateOfDeath'] or .//child::*[local-name()='Patient']/child::*[local-name()='AdmLocation'] or .//child::*[local-name()='Patient']/child::*[local-name()='AdditionalId'] or .//child::*[local-name()='Patient']/child::*[local-name()='InfItem'] or .//child::*[local-name()='Patient']/child::*[local-name()='Patient']">
					<li>
						<xsl:variable name="temp5" select="concat('Patient',$position)"/>
						<a href="#{$temp5}">Pasient</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()='Animal']/child::*[local-name()='Sex'] or .//child::*[local-name()='Animal']/child::*[local-name()='Animal']">
					<li>
						<xsl:variable name="temp6" select="concat('Animal',$position)"/>
						<a href="#{$temp6}">Undersøkelsesdyr</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()='ServProvider'] | .//child::*[local-name()='Requester'] | .//child::*[local-name()='PaymentResponsible'] | .//child::*[local-name()='CopyDest'] | child::*[local-name()='RelServProv'] | .//child::*[local-name()='RelServProv'][descendant::*[local-name()='Id']] | .//child::*[local-name()='ResponsibleHcp'] | .//child::*[local-name()='Patient']/child::*[local-name()='AdmLocation']">
					<li>
						<xsl:variable name="temp7" select="concat('HCP',$position)"/>
						<a href="#{$temp7}">Helsetjenesteenheter</a>
					</li>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()='RefDoc']">
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
		<xsl:if test="child::*[local-name()='Comment'] or child::*[local-name()='CodedComment']">
			<tr>
				<th>Kommentar til svarrapporten</th>
				<td colspan="{($col)-1}">
					<xsl:for-each select="child::*[local-name()='Comment']">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="."/>
						</xsl:call-template>&#160;
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()='CodedComment'][contains(@S,'8272')]">
						<xsl:if test="position()=1">
							<b>Anbefaler ny undersøkelse:&#160;</b>
						</xsl:if>
						<xsl:call-template name="k-8272"/>
						<xsl:choose>
							<xsl:when test="position()!=last()">,&#160;</xsl:when>
							<xsl:otherwise>&#160;</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()='CodedComment'][contains(@S,'8273')]">
						<xsl:if test="position()=1">
							<b>Hastegrad:&#160;</b>
						</xsl:if>
						<xsl:call-template name="k-8273"/>&#160;
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()='CodedComment'][not(contains(@S,'8272')) and not(contains(@S,'8273'))]">
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
		<xsl:if test="child::*[local-name()='IssueDate'] or child::*[local-name()='ReceiptDate'] or child::*[local-name()='RequestedPrioReport'] or child::*[local-name()='PaymentCat'] or child::*[local-name()='Reservation']">
			<tr>
				<xsl:if test="child::*[local-name()='IssueDate']">
					<th>Utstedt-dato</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()='ReceiptDate'] | child::*[local-name()='RequestedPrioReport'] | child::*[local-name()='PaymentCat'] | child::*[local-name()='Reservation']))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()='ReceiptDate'] | child::*[local-name()='RequestedPrioReport'] | child::*[local-name()='PaymentCat'] | child::*[local-name()='Reservation']))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='IssueDate']/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='ReceiptDate']">
					<th>Mottatt-dato</th>
					<td width="{((($col)-2-count(child::*[local-name()='IssueDate'])*2)*number(not(child::*[local-name()='RequestedPrioReport'] | child::*[local-name()='PaymentCat'] | child::*[local-name()='Reservation']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='IssueDate'])*2)*number(not(child::*[local-name()='RequestedPrioReport'] | child::*[local-name()='PaymentCat'] | child::*[local-name()='Reservation']))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='ReceiptDate']/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='RequestedPrioReport']">
					<th>Ønsket prioritet</th>
					<td width="{((($col)-2-count(child::*[local-name()='IssueDate'] | child::*[local-name()='ReceiptDate'])*2)*number(not(child::*[local-name()='PaymentCat'] | child::*[local-name()='Reservation']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='IssueDate'] | child::*[local-name()='ReceiptDate'])*2)*number(not(child::*[local-name()='PaymentCat'] | child::*[local-name()='Reservation']))+1}">
						<xsl:for-each select="child::*[local-name()='RequestedPrioReport']">
							<xsl:call-template name="k-7303"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='PaymentCat']">
					<th>Betalingskategori</th>
					<td width="{((($col)-2-count(child::*[local-name()='IssueDate'] | child::*[local-name()='ReceiptDate'] | child::*[local-name()='RequestedPrioReport'])*2)*number(not(child::*[local-name()='Reservation']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='IssueDate'] | child::*[local-name()='ReceiptDate'] | child::*[local-name()='RequestedPrioReport'])*2)*number(not(child::*[local-name()='Reservation']))+1}">
						<xsl:for-each select="child::*[local-name()='PaymentCat']">
							<xsl:call-template name="k-4101"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Reservation']">
					<th>Pasientens reservasjoner</th>
					<td colspan="{($col)-1-count(child::*[local-name()='IssueDate'] | child::*[local-name()='ReceiptDate'] | child::*[local-name()='RequestedPrioReport'] | child::*[local-name()='PaymentCat'])*2}">
						<xsl:for-each select="child::*[local-name()='Reservation']">
							<div>
								<xsl:call-template name="k-3108"/>
							</div>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()='ReqComment']">
			<tr>
				<th>Rekvirentens kommentar</th>
				<td colspan="{($col)-1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='ReqComment']"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()='ReasonAsText']">
			<tr>
				<th colspan="{$col}" class="h3">Begrunnelser</th>
			</tr>
			<xsl:for-each select="child::*[local-name()='ReasonAsText']">
				<xsl:call-template name="ReasonAsText">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Comment']">
			<tr>
				<th colspan="{$col}" class="h3">Kommentarer</th>
			</tr>
			<xsl:for-each select="child::*[local-name()='Comment']">
				<xsl:call-template name="Comment">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<!-- Visning av Kommentar til rekvisisjon -->
	<xsl:template name="Comment">
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()='Heading'] or child::*[local-name()='TextResultValue'] or child::*[local-name()='TextCode']">
			<tr>
				<th>
					<xsl:choose>
						<xsl:when test="child::*[local-name()='Heading']">
							<xsl:for-each select="child::*[local-name()='Heading']">
								<xsl:call-template name="k-8234"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="contains(child::*[local-name()='TextCode']/@S,'8274')">Anbefaling om supplerende undersøkelse</xsl:when>
						<xsl:otherwise>Generell</xsl:otherwise>
					</xsl:choose>
				</th>
				<td colspan="{($col)-1}">
					<xsl:if test="child::*[local-name()='TextResultValue']">
						<div><xsl:value-of select="child::*[local-name()='TextResultValue']"/></div>
					</xsl:if>
					<xsl:for-each select="child::*[local-name()='TextCode']">
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
		<xsl:if test="child::*[local-name()='Heading'] or child::*[local-name()='TextResultValue']">
			<tr>
				<th>
					<xsl:for-each select="child::*[local-name()='Heading']">
						<xsl:call-template name="k-8231"/>
					</xsl:for-each>
				</th>
				<td colspan="{($col)-1}">
					<xsl:for-each select="child::*[local-name()='TextResultValue']">
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
			<th>Navn&#160;<xsl:if test="child::*[local-name()='Relation'] and local-name(..)='Patient'">-&#160;relasjon:&#160;<xsl:for-each select="child::*[local-name()='Relation']"><xsl:call-template name="k-8238"/></xsl:for-each></xsl:if></th>
			<td width="{$std-td}px">
				<xsl:choose>
					<xsl:when test="not($Anonymisert)">
						<xsl:value-of select="child::*[local-name()='Name']"/>
					</xsl:when>
					<xsl:otherwise>Gundersen,&#160;Roland</xsl:otherwise>
				</xsl:choose>
			</td>
			<th>
				<xsl:choose>
					<xsl:when test="not($Anonymisert)">
						<xsl:for-each select="child::*[local-name()='TypeOffId']">
							<xsl:call-template name="k-8116"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Fødselsnummer</xsl:otherwise>
				</xsl:choose>
			</th>
			<td width="{((($col)-2-count(child::*[local-name()='Name'])*2)*number(not(child::*[local-name()='Sex'] | child::*[local-name()='DateOfBirth'] | child::*[local-name()='DateOfDeath']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='Name'])*2)*number(not(child::*[local-name()='Sex'] | child::*[local-name()='DateOfBirth'] | child::*[local-name()='DateOfDeath']))+1}">
				<xsl:choose>
					<xsl:when test="not($Anonymisert)">
						<xsl:value-of select="child::*[local-name()='OffId']"/>
					</xsl:when>
					<xsl:otherwise>15076500565</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="child::*[local-name()='Sex']">
				<th>Kjønn</th>
				<td width="{((($col)-2-count(child::*[local-name()='Name'] | child::*[local-name()='OffId'])*2)*number(not(child::*[local-name()='DateOfBirth'] | child::*[local-name()='DateOfDeath']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='Name'] | child::*[local-name()='OffId'])*2)*number(not(child::*[local-name()='DateOfBirth'] | child::*[local-name()='DateOfDeath']))+1}">
					<xsl:choose>
						<xsl:when test="not($Anonymisert)">
							<xsl:for-each select="child::*[local-name()='Sex']">
								<xsl:call-template name="k-3101"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>Mann</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()='DateOfBirth']">
				<th>Fødselsdato</th>
				<td width="{((($col)-2-count(child::*[local-name()='Name'] | child::*[local-name()='OffId'] | child::*[local-name()='Sex'])*2)*number(not(child::*[local-name()='DateOfDeath']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='Name'] | child::*[local-name()='OffId'] | child::*[local-name()='Sex'])*2)*number(not(child::*[local-name()='DateOfDeath']))+1}">
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
			<xsl:if test="child::*[local-name()='DateOfDeath']">
				<th>Dødsdato</th>
				<td colspan="{(($col)-1-count(child::*[local-name()='Name'] | child::*[local-name()='OffId'] | child::*[local-name()='Sex'] | child::*[local-name()='DateOfBirth'])*2)}">
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
		</tr>
		<xsl:for-each select="child::*[local-name()='Address']">
			<xsl:variable name="antall-tel" select="count(child::*[local-name()='TeleAddress'])"/>
			<tr>
				<xsl:if test="not($Anonymisert)">
					<xsl:call-template name="TeleAddress">
						<xsl:with-param name="col" select="(($col)-1)*number(not(child::*[local-name()='Type'] and (child::*[local-name()='PostalCode'] or child::*[local-name()='City'])))+1"/>
					</xsl:call-template>
					<xsl:if test="child::*[local-name()='Type'] and (child::*[local-name()='PostalCode'] or child::*[local-name()='City'])">
						<xsl:call-template name="TeleAddress">
							<xsl:with-param name="col" select="($col)-1-($antall-tel)*2"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:if test="child::*[local-name()='AdditionalId'] or child::*[local-name()='BasisForHealthServices']">
			<xsl:variable name="antall-id" select="count(child::*[local-name()='AdditionalId'])"/>
			<tr>
				<xsl:if test="not($Anonymisert)">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='AdditionalId'] and child::*[local-name()='BasisForHealthServices']">
							<th colspan="2">Andre pasient-identifikatorer</th>
							<xsl:for-each select="child::*[local-name()='AdditionalId']">
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
								<xsl:for-each select="child::*[local-name()='BasisForHealthServices']">
									<xsl:call-template name="k-8246"/>
								</xsl:for-each>
							</td>
						</xsl:when>
						<xsl:when test="child::*[local-name()='AdditionalId'] and not(child::*[local-name()='BasisForHealthServices'])">
							<th colspan="2">Andre pasient-identifikatorer</th>
							<xsl:for-each select="child::*[local-name()='AdditionalId']">
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
								<xsl:for-each select="child::*[local-name()='BasisForHealthServices']">
									<xsl:call-template name="k-8246"/>
								</xsl:for-each>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='AdmLocation']">
			<tr>
				<th colspan="{$col}" class="h3">
					Opphold
				</th>
			</tr>
			<tr>
				<th>Institusjon</th>
				<td width="{((($col)-2)*number(not(child::*[local-name()='AdmCat'] | child::*[local-name()='StartDateTime'] | child::*[local-name()='EndDateTime']))+1)*$std-td}px" colspan="{(($col)-4)*number(not(child::*[local-name()='AdmCat'] | child::*[local-name()='StartDateTime'] | child::*[local-name()='EndDateTime']))+3}">
					<!-- Gir her boksen en default kolonnebredde på 3 mot normalt 1 -->
					<xsl:value-of select="child::*[local-name()='Location']/child::*[local-name()='Inst']/child::*[local-name()='Name']"/>
					<xsl:if test="child::*[local-name()='Location']/child::*[local-name()='Inst']/child::*[local-name()='Dept']/child::*[local-name()='Name']">
						<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='Inst']/child::*[local-name()='Dept']">,&#160;<xsl:value-of select="child::*[local-name()='Name']"/>
						</xsl:for-each>
					</xsl:if>
					<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='SubLocation']">,&#160;<xsl:for-each select="child::*[local-name()='Type']"><xsl:call-template name="k-8242"/></xsl:for-each>:&#160;<xsl:value-of select="child::*[local-name()='Place']"/>
					</xsl:for-each>
				</td>
				<xsl:if test="child::*[local-name()='AdmCat']">
					<th>Type&#160;tjeneste&#160;</th>
					<td width="{((($col)-6)*number(not(child::*[local-name()='StartDateTime'] | child::*[local-name()='EndDateTime']))+1)*$std-td}px" colspan="{(($col)-6)*number(not(child::*[local-name()='StartDateTime'] | child::*[local-name()='EndDateTime']))+1}">
						<xsl:for-each select="child::*[local-name()='AdmCat']">
							<xsl:call-template name="k-8240"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='StartDateTime']">
					<th>Innlagt&#160;dato&#160;</th>
					<td width="{((($col)-6-count(child::*[local-name()='AdmCat'])*2)*number(not(child::*[local-name()='EndDateTime']))+1)*$std-td}px" colspan="{(($col)-6-count(child::*[local-name()='AdmCat'])*2)*number(not(child::*[local-name()='EndDateTime']))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='EndDateTime']">
					<th>Utskrevet&#160;dato&#160;</th>
					<td colspan="{(($col)-5-count(child::*[local-name()='AdmCat'] | child::*[local-name()='StartDateTime'])*2)}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Patient'] | child::*[local-name()='InfItem']">
			<xsl:if test="local-name()='Patient'">
				<xsl:call-template name="Patient">
				<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="local-name()='InfItem'">
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
			<xsl:if test="child::*[local-name()='NameOwner']">
				<th>Eier&#160;</th>
				<td width="{((($col)-2)*number(not(child::*[local-name()='Name'] | child::*[local-name()='Sex'] | child::*[local-name()='Species']))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()='Name'] | child::*[local-name()='Sex'] | child::*[local-name()='Species']))+1}">
					<xsl:value-of select="child::*[local-name()='NameOwner']"/>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()='Name']">
				<th>Navn&#160;
					<xsl:if test="local-name(..)='Animal'">
						-&#160;relasjon:&#160;<xsl:for-each select="child::*[local-name()='Relation']"><xsl:call-template name="k-8238"/></xsl:for-each>
					</xsl:if>
				</th>
				<td width="{((($col)-2-count(child::*[local-name()='NameOwner'])*2)*number(not(child::*[local-name()='Sex'] | child::*[local-name()='Species']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='NameOwner'])*2)*number(not(child::*[local-name()='Sex'] | child::*[local-name()='Species']))+1}">
					<xsl:value-of select="child::*[local-name()='Name']"/>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()='Sex']">
				<th>Kjønn</th>
				<td width="{((($col)-2-count(child::*[local-name()='NameOwner'] | child::*[local-name()='Name'])*2)*number(not(child::*[local-name()='Species']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='NameOwner'] | child::*[local-name()='Name'])*2)*number(not(child::*[local-name()='Species']))+1}">
					<xsl:for-each select="child::*[local-name()='Sex']">
						<xsl:call-template name="k-3101"/>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()='Species']">
				<th>Art</th>
				<td colspan="{($col)-1-count(child::*[local-name()='NameOwner'] | child::*[local-name()='Name'] | child::*[local-name()='Sex'])*2}">
					<xsl:value-of select="child::*[local-name()='Species']"/>
				</td>
			</xsl:if>
		</tr>
		<xsl:for-each select="child::*[local-name()='Animal']">
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
		<xsl:if test="child::*[local-name()='Type'] or child::*[local-name()='TypeCoded'] or child::*[local-name()='IdByServProvider'] or child::*[local-name()='CollectedSample'] or child::*[local-name()='CollectedStudyProduct']">
			<tr>
				<xsl:if test="child::*[local-name()='Type'] or child::*[local-name()='TypeCoded']"><!-- Enten Type eller TypeCoded må oppgis - jfr. standard HIS 80822:2014 -->
					<th>Type&#160;materiale<xsl:if test="$last!=1">&#160;<xsl:value-of select="$pos"/></xsl:if>
						<xsl:for-each select="child::*[local-name()='ServType']">
							-&#160;<xsl:call-template name="k-7309"/>
						</xsl:for-each>
					</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()='IdByServProvider'] | child::*[local-name()='CollectedSample'] | child::*[local-name()='CollectedStudyProduct']))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()='IdByServProvider'] | child::*[local-name()='CollectedSample'] | child::*[local-name()='CollectedStudyProduct']))+1}">
					<!--Kommentar til en tilsynelatende for lang kolonnebredde: CollectedSample og CollectedStudyProduct er innenfor en choice -->
						<xsl:choose>
							<xsl:when test="child::*[local-name()='Type']">
								<xsl:value-of select="child::*[local-name()='Type']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="child::*[local-name()='TypeCoded']">
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
				<xsl:if test="child::*[local-name()='IdByServProvider']">
					<th>Tjenesteyters&#160;id</th>
					<td width="{((($col)-2-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2)*number(not(child::*[local-name()='CollectedSample'] | child::*[local-name()='CollectedStudyProduct']))+1)*$std-td}px" colspan="{(($col)-2-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2)*number(not(child::*[local-name()='CollectedSample'] | child::*[local-name()='CollectedStudyProduct']))+1}">
						<xsl:value-of select="child::*[local-name()='IdByServProvider']"/>
					</td>
				</xsl:if>
				<xsl:for-each select="child::*[local-name()='CollectedSample']">
					<xsl:if test="child::*[local-name()='CollectedDate']">
						<th>Dato&#160;prøvetakning</th>
						<td width="{((($col)-2-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2-count(../child::*[local-name()='IdByServProvider'])*2)*number(not(child::*[local-name()='CollectorComment'] | child::*[local-name()='CollectorCommentCoded'] | child::*[local-name()='Logistics']))+1)*$std-td}px" colspan="{(($col)-2-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2-count(../child::*[local-name()='IdByServProvider'])*2)*number(not(child::*[local-name()='CollectorComment'] | child::*[local-name()='CollectorCommentCoded'] | child::*[local-name()='Logistics']))+1}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='CollectedDate']/@V"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<xsl:if test="child::*[local-name()='Logistics']">
						<th>Forsendelsesmåte</th>
						<td width="{((($col)-2-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2-count(../child::*[local-name()='IdByServProvider'] | child::*[local-name()='CollectedDate'])*2)*number(not(child::*[local-name()='CollectorComment'] | child::*[local-name()='CollectorCommentCoded']))+1)*$std-td}px" colspan="{(($col)-2-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2-count(../child::*[local-name()='IdByServProvider'] | child::*[local-name()='CollectedDate'])*2)*number(not(child::*[local-name()='CollectorComment'] | child::*[local-name()='CollectorCommentCoded']))+1}">
							<xsl:value-of select="child::*[local-name()='Logistics']"/>
						</td>
					</xsl:if>
					<xsl:if test="child::*[local-name()='CollectorComment'] or child::*[local-name()='CollectorCommentCoded']">
						<th>Prøvetakers&#160;kommentar</th>
						<td colspan="{($col)-1-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2-count(../child::*[local-name()='IdByServProvider'] | child::*[local-name()='CollectedDate'] | child::*[local-name()='Logistics'])*2}">
							<xsl:if test="child::*[local-name()='CollectorComment']">
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="child::*[local-name()='CollectorComment']"/>
								</xsl:call-template>&#160;
							</xsl:if>
							<xsl:for-each select="child::*[local-name()='CollectorCommentCoded']">
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
				<xsl:for-each select="child::*[local-name()='CollectedStudyProduct']">
					<xsl:if test="child::*[local-name()='Type']">
						<th>Type&#160;analyseprodukt</th>
						<td width="{((($col)-2-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2-count(../child::*[local-name()='IdByServProvider'])*2)*number(not(child::*[local-name()='ProducedDate'] | child::*[local-name()='RefRelatedProd']))+1)*$std-td}px" colspan="{(($col)-2-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2-count(../child::*[local-name()='IdByServProvider'])*2)*number(not(child::*[local-name()='ProducedDate'] | child::*[local-name()='RefRelatedProd']))+1}">
							<xsl:value-of select="child::*[local-name()='Type']"/>
						</td>
					</xsl:if>
					<xsl:if test="child::*[local-name()='ProducedDate']">
						<th>Dato&#160;prøvetakning</th>
						<td width="{((($col)-2-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2-count(../child::*[local-name()='IdByServProvider'] | child::*[local-name()='Type'])*2)*number(not(child::*[local-name()='RefRelatedProd']))+1)*$std-td}px" colspan="{(($col)-2-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2-count(../child::*[local-name()='IdByServProvider'] | child::*[local-name()='Type'])*2)*number(not(child::*[local-name()='RefRelatedProd']))+1}">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='ProducedDate']/@V"/>
							</xsl:call-template>
						</td>
					</xsl:if>
					<xsl:if test="child::*[local-name()='RefRelatedProd']">
						<th>Referanse</th>
						<td colspan="{($col)-1-number(boolean(../child::*[local-name()='Type'] or ../child::*[local-name()='TypeCoded']))*2-count(../child::*[local-name()='IdByServProvider'] | child::*[local-name()='Type'] | child::*[local-name()='ProducedDate'])*2}">
							<xsl:value-of select="child::*[local-name()='RefRelatedProd']"/>
						</td>
					</xsl:if>
				</xsl:for-each>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Number'] or child::*[local-name()='IdByRequester'] or child::*[local-name()='SampleCollInd'] or child::*[local-name()='SampleCollProc']">
			<tr>
				<xsl:if test="child::*[local-name()='Number']">
					<th>Antall</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()='IdByRequester'] | child::*[local-name()='SampleCollInd'] | child::*[local-name()='SampleCollProc']))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()='IdByRequester'] | child::*[local-name()='SampleCollInd'] | child::*[local-name()='SampleCollProc']))+1}">
						<xsl:value-of select="child::*[local-name()='Number']"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='IdByRequester']">
					<th>Rekvirents&#160;id</th>
					<td width="{((($col)-2-count(child::*[local-name()='Number'])*2)*number(not(child::*[local-name()='SampleCollInd'] | child::*[local-name()='SampleCollProc']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='Number'])*2)*number(not(child::*[local-name()='SampleCollInd'] | child::*[local-name()='SampleCollProc']))+1}">
						<xsl:value-of select="child::*[local-name()='IdByRequester']"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='SampleCollInd']">
					<th>Prøve&#160;tatt</th>
					<td width="{((($col)-2-count(child::*[local-name()='Number'] | child::*[local-name()='IdByRequester'])*2)*number(not(child::*[local-name()='SampleCollProc']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='Number'] | child::*[local-name()='IdByRequester'])*2)*number(not(child::*[local-name()='SampleCollProc']))+1}">
						<xsl:for-each select="child::*[local-name()='SampleCollInd']">
							<xsl:call-template name="k-1101"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='SampleCollProc']">
					<th>Prøvetakingsprosedyre</th>
					<td colspan="{($col)-1-count(child::*[local-name()='Number'] | child::*[local-name()='IdByRequester'] | child::*[local-name()='SampleCollInd'])*2}">
						<xsl:for-each select="child::*[local-name()='SampleCollInd']">
							<xsl:call-template name="k-dummy"/>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()='AnatomicalOrigin'] or child::*[local-name()='PreservMaterial'] or child::*[local-name()='Pretreatment'] or child::*[local-name()='Accredited'] or child::*[local-name()='RelServProv']">
			<tr>
				<xsl:if test="child::*[local-name()='AnatomicalOrigin']">
					<th>Anatomisk&#160;lokasjon</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()='PreservMaterial'] | child::*[local-name()='Pretreatment'] | child::*[local-name()='Accredited'] | child::*[local-name()='RelServProv']))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()='PreservMaterial'] | child::*[local-name()='Pretreatment'] | child::*[local-name()='Accredited'] | child::*[local-name()='RelServProv']))+1}">
						<xsl:value-of select="child::*[local-name()='AnatomicalOrigin']"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='PreservMaterial']">
					<th>Konserveringsmiddel</th>
					<td width="{((($col)-2-count(child::*[local-name()='AnatomicalOrigin'])*2)*number(not(child::*[local-name()='Pretreatment'] | child::*[local-name()='Accredited'] | child::*[local-name()='RelServProv']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='AnatomicalOrigin'])*2)*number(not(child::*[local-name()='Pretreatment'] | child::*[local-name()='Accredited'] | child::*[local-name()='RelServProv']))+1}">
						<xsl:value-of select="child::*[local-name()='PreservMaterial']"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Pretreatment']">
					<th>Forberedende&#160;behandling</th>
					<td width="{((($col)-2-count(child::*[local-name()='AnatomicalOrigin'] | child::*[local-name()='PreservMaterial'])*2)*number(not(child::*[local-name()='Accredited'] | child::*[local-name()='RelServProv']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='AnatomicalOrigin'] | child::*[local-name()='PreservMaterial'])*2)*number(not(child::*[local-name()='Accredited'] | child::*[local-name()='RelServProv']))+1}">
						<xsl:for-each select="child::*[local-name()='Pretreatment']/child::*[local-name()='Heading']">
							<xsl:call-template name="k-8232"/>
						</xsl:for-each>
						<xsl:if test="child::*[local-name()='Pretreatment']/child::*[local-name()='TextResultValue']">
							<div>
								<b>Beskrivelse:&#160;</b>
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="child::*[local-name()='Pretreatment']/child::*[local-name()='TextResultValue']"/>
								</xsl:call-template>
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Accredited']">
					<th>Akkreditert</th>
					<td width="{((($col)-2-count(child::*[local-name()='AnatomicalOrigin'] | child::*[local-name()='PreservMaterial'] | child::*[local-name()='Pretreatment'])*2)*number(not(child::*[local-name()='RelServProv']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='AnatomicalOrigin'] | child::*[local-name()='PreservMaterial'] | child::*[local-name()='Pretreatment'])*2)*number(not(child::*[local-name()='RelServProv']))+1}">
						<xsl:choose>
							<xsl:when test="child::*[local-name()='Accredited']/@V='true'">Prosedyren er akkreditert</xsl:when>
							<xsl:otherwise>Prosedyren er ikke akkreditert</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='RelServProv']">
					<th>
						<xsl:for-each select="child::*[local-name()='RelServProv']/child::*[local-name()='Relation']">
							<xsl:call-template name="k-8254"/>
						</xsl:for-each>
					</th>
					<td colspan="{($col)-1-count(child::*[local-name()='AnatomicalOrigin'] | child::*[local-name()='PreservMaterial'] | child::*[local-name()='Pretreatment'] | child::*[local-name()='Accredited'])*2}">
						<xsl:value-of select="child::*[local-name()='RelServProv']//child::*[local-name()='Name']"/>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()='SampleHandling']">
			<tr>
				<th>Håndteringsbeskrivelse</th>
				<td colspan="{($col)-1}">
					<xsl:for-each select="child::*[local-name()='SampleHandling']">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Comment']">
			<tr>
				<th>Kommentar</th>
				<td colspan="{($col)-1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='AnalysedSubject']">
			<xsl:call-template name="AnalysedSubject">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av Undersøkelsesresultat -->
	<xsl:template name="ResultItem">
		<xsl:param name="slaaSammen"/>
		<xsl:param name="rowColor"/>
		<xsl:variable name="textWidth"> <!-- variabel som gjør resultat-kolonnebredden større jo mer tekst som skal vises -->
			<xsl:choose>
				<xsl:when test="child::*[local-name()='TextResult']/child::*[local-name()='TextResultValue']">
					<xsl:value-of select="ceiling(string-length(child::*[local-name()='TextResult']/child::*[local-name()='TextResultValue']) div 50)"/>
				</xsl:when>
				<xsl:when test="$slaaSammen='true' and child::*[local-name()='ResultItem'][1]/child::*[local-name()='TextResult']/child::*[local-name()='TextResultValue']">
					<xsl:value-of select="ceiling(string-length(child::*[local-name()='ResultItem'][1]/child::*[local-name()='TextResult']/child::*[local-name()='TextResultValue']) div 50)"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="commentWidth"> <!-- variabel som gjør kommentar-kolonnebredden større jo mer tekst som skal vises -->
			<xsl:choose>
				<xsl:when test="child::*[local-name()='Comment']">
					<xsl:value-of select="ceiling(string-length(child::*[local-name()='Comment']) div 50)"/>
				</xsl:when>
				<xsl:when test="$slaaSammen='true' and child::*[local-name()='ResultItem'][1]/child::*[local-name()='Comment']">
					<xsl:value-of select="ceiling(string-length(child::*[local-name()='ResultItem'][1]/child::*[local-name()='Comment']) div 50)"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="farge">
			<xsl:choose>
				<xsl:when test="$slaaSammen='true'">white</xsl:when>
				<xsl:otherwise><xsl:value-of select="$rowColor"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr bgcolor="{$farge}">
			<!-- Undersøkelse -->
			<xsl:if test="//child::*[local-name()='Investigation'] or //child::*[local-name()='ResultItem'][child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR']">
				<td width="{$investigation-col*$std-td}px" colspan="{$investigation-col}">
					<xsl:if test="child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR'">
						<b>Gruppe:&#160;</b>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="child::*[local-name()='Investigation']">
							<div>
								<xsl:call-template name="skrivUtUndersokelse"/>
							</div>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]">
								<div>
									<xsl:call-template name="skrivUtUndersokelse"/>
								</div>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>				
			</xsl:if>
			<!-- Avviksmarkør -->
			<xsl:if test="//child::*[local-name()='DevResultInd']">
				<td width="{$devind-col*$id-td}px" colspan="{$devind-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='DevResultInd']">
							<xsl:for-each select="child::*[local-name()='DevResultInd']">
								<xsl:call-template name="k-8244"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]/child::*[local-name()='DevResultInd']">
								<xsl:call-template name="k-8244"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Resultat -->
			<xsl:if test="//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']">
				<td width="{($textWidth)*$result-td}px" colspan="{$res-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='TextResult'] or child::*[local-name()='Interval'] or child::*[local-name()='DateResult'] or child::*[local-name()='NumResult']">
							<xsl:call-template name="skrivUtResultat">
								<xsl:with-param name="sammendrag" select="false()"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]">
								<xsl:call-template name="skrivUtResultat">
									<xsl:with-param name="sammendrag" select="false()"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Ref.interval -->
			<xsl:if test="//child::*[local-name()='RefInterval']">
				<td width="{$refinterval-col*$id-td}px" colspan="{$refinterval-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='RefInterval']">
							<xsl:call-template name="skrivUtRefInterval"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]">
								<xsl:call-template name="skrivUtRefInterval"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Benevning -->
			<xsl:if test="//child::*[local-name()='NumResultValue']/@U | //child::*[local-name()='Unit']">
				<td width="{$unit-col*$id-td}px" colspan="{$unit-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U or child::*[local-name()='TextResult']/child::*[local-name()='Unit']">
							<xsl:call-template name="skrivUtBenevning"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]">
								<xsl:call-template name="skrivUtBenevning"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Kommentar -->
			<xsl:if test="//child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] or //child::*[local-name()='DiagComment'] or //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or //child::*[local-name()='StructuredInfo']">
				<td width="{$commentWidth*$std-td}px" colspan="{$comment-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='Comment'] or child::*[local-name()='DiagComment'] or child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or child::*[local-name()='StructuredInfo']">
							<xsl:call-template name="skrivUtKommentar"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]">
								<xsl:call-template name="skrivUtKommentar"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Tilknyttet tjenesteyter -->
			<xsl:if test="//child::*[local-name()='RelServProv']">
				<td width="{$relserv-col*$result-td}px" colspan="{$relserv-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='RelServProv']">
							<xsl:call-template name="skrivUtTjenesteyter"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]">
								<xsl:call-template name="skrivUtTjenesteyter"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Tidspunkt for -->
			<xsl:if test="//child::*[local-name()='InvDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='DescrDate'] or //child::*[local-name()='CounterSignDate'] or //child::*[local-name()='MedicalValidationDate']">
				<td width="{$date-col*$result-td}px" colspan="{$date-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='InvDate'] or child::*[local-name()='StatusChangeDate'] or child::*[local-name()='DescrDate'] or child::*[local-name()='CounterSignDate'] or child::*[local-name()='MedicalValidationDate']">
							<xsl:call-template name="skrivUtTidspunktFor"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]">
								<xsl:call-template name="skrivUtTidspunktFor"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Undersøkelsesstatus -->
			<xsl:if test="//child::*[local-name()='StatusInvestigation']">
				<td width="{$status-col*$id-td}px" colspan="{$status-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='StatusInvestigation']">
							<xsl:for-each select="child::*[local-name()='StatusInvestigation']">
								<xsl:call-template name="k-8245"/>&#160;
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]/child::*[local-name()='StatusInvestigation']">
								<xsl:call-template name="k-8245"/>&#160;
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Id -->
			<xsl:if test="//child::*[local-name()='IdResultItem']">
				<td width="{$id-col*$id-td}px" colspan="{$id-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='IdResultItem']">
							<xsl:value-of select="child::*[local-name()='IdResultItem']"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]">
								<xsl:value-of select="child::*[local-name()='IdResultItem']"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Ref.id -->
			<xsl:if test="//child::*[local-name()='RefIdResultItem']">
				<td width="{$refid-col*$id-td}px" colspan="{$refid-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='RefIdResultItem']">
							<xsl:value-of select="child::*[local-name()='RefIdResultItem']"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]">
								<xsl:value-of select="child::*[local-name()='RefIdResultItem']"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Ref.prøve -->
			<xsl:if test="//child::*[local-name()='RefAnalysedSubject']">
				<td width="{$refsubject-col*$id-td}px" colspan="{$refsubject-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='RefAnalysedSubject']">
							<xsl:value-of select="child::*[local-name()='RefAnalysedSubject']"/>&#160;
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]">
								<xsl:value-of select="child::*[local-name()='RefAnalysedSubject']"/>&#160;
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<!-- Akkreditert -->
			<xsl:if test="//child::*[local-name()='Accredited']">
				<td width="{$acc-col*$id-td}px" colspan="{$acc-col}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='Accredited']">
							<xsl:call-template name="skrivUtAkkrediert"/>
						</xsl:when>
						<xsl:when test="$slaaSammen='true'">
							<xsl:for-each select="child::*[local-name()='ResultItem'][1]">
								<xsl:call-template name="skrivUtAkkrediert"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av Strukturert undersøkelsesresultat -->
	<xsl:template name="ResultItemStructuredInfo">
		<table>
			<tbody>
				<tr>
					<th>Type</th>
					<td><b>Resultat</b></td>
				</tr>
				<xsl:for-each select="child::*[local-name()='StructuredInfo']">
					<tr>
						<td>
							<xsl:for-each select="child::*[local-name()='Type']">
								<xsl:call-template name="k-dummy"/>
							</xsl:for-each>
						</td>
						<td>
							<xsl:for-each select="child::*[local-name()='TextInfo']">
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="child::*[local-name()='Text']"/>
								</xsl:call-template>&#160;
							</xsl:for-each>
							<xsl:for-each select="child::*[local-name()='IntegerInfo']">
								<xsl:value-of select="child::*[local-name()='Integer']"/>&#160;
							</xsl:for-each>
							<xsl:for-each select="child::*[local-name()='PhysicalInfo']">
								<xsl:value-of select="child::*[local-name()='Quantity']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='Quantity']/@U"/>&#160;
							</xsl:for-each>
							<xsl:for-each select="child::*[local-name()='CodedInfo']/child::*[local-name()='Code']">
								<xsl:call-template name="k-dummy"/>&#160;
							</xsl:for-each>
							<xsl:for-each select="child::*[local-name()='BooleanInfo']">
								<xsl:value-of select="child::*[local-name()='Flag']/@V"/>&#160;
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
		<xsl:variable name="type" select="child::*[local-name()='Type']/@V"/>
		<xsl:if test="not(preceding-sibling::*[local-name()='InfItem'][child::*[local-name()='Type']/@V=$type])">
			<tr>
				<th colspan="{$col}" class="h3">
					<xsl:for-each select="child::*[local-name()='Type']">
						<xsl:call-template name="k-8233"/>
					</xsl:for-each>
				</th>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Observation']/child::*[local-name()='Description'] or child::*[local-name()='Observation']/child::*[local-name()='CodedDescr'] or child::*[local-name()='StartDateTime'] or child::*[local-name()='EndDateTime'] or child::*[local-name()='OrgDate']">
			<tr>
				<xsl:if test="child::*[local-name()='Observation']/child::*[local-name()='Description'] or child::*[local-name()='Observation']/child::*[local-name()='CodedDescr']">
					<th>Beskrivelse</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()='StartDateTime'] | child::*[local-name()='EndDateTime'] | child::*[local-name()='OrgDate']))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()='StartDateTime'] | child::*[local-name()='EndDateTime'] | child::*[local-name()='OrgDate']))+1}">
						<xsl:for-each select="child::*[local-name()='Observation']/child::*[local-name()='Description']">
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
						<xsl:if test="child::*[local-name()='Observation']/child::*[local-name()='CodedDescr']">
							<div>
								<xsl:for-each select="child::*[local-name()='Observation']/child::*[local-name()='CodedDescr']">
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
				<xsl:if test="child::*[local-name()='StartDateTime']">
					<th>Start-dato</th>
					<td width="{((($col)-2-count(child::*[local-name()='Observation']/child::*[local-name()='Description'])*2)*number(not(child::*[local-name()='EndDateTime'] | child::*[local-name()='OrgDate']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='Observation']/child::*[local-name()='Description'])*2)*number(not(child::*[local-name()='EndDateTime'] | child::*[local-name()='OrgDate']))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='EndDateTime']">
					<th>Slutt-dato</th>
					<td width="{((($col)-2-count(child::*[local-name()='Observation']/child::*[local-name()='Description'] | child::*[local-name()='StartDateTime'])*2)*number(not(child::*[local-name()='OrgDate']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='Observation']/child::*[local-name()='Description'] | child::*[local-name()='StartDateTime'])*2)*number(not(child::*[local-name()='OrgDate']))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='OrgDate']">
					<th>Opprinnelses-dato</th>
					<td colspan="{($col)-1-count(child::*[local-name()='Observation']/child::*[local-name()='Description'] | child::*[local-name()='StartDateTime'] | child::*[local-name()='EndDateTime'])*2}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='OrgDate']/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Observation']/child::*[local-name()='Comment']">
			<tr>
				<th>Kommentar</th>
				<td colspan="{($col)-1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='Observation']/child::*[local-name()='Comment']"/>
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
			<th colspan="{$col}" class="h3">Tjenesteyter<xsl:if test="child::*[local-name()='HCP']/child::*[local-name()='MedSpeciality']"> - Spesialitet:&#160;<xsl:for-each select="child::*[local-name()='HCP']/child::*[local-name()='MedSpeciality']">
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
				<xsl:if test="$historikk='true'">&#160;(tidligere&#160;sendt)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()='HCP']">
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
			<th colspan="{$col}" class="h3">Henvisende&#160;instans<xsl:if test="child::*[local-name()='HCP']/child::*[local-name()='MedSpeciality']"> - Spesialitet:&#160;<xsl:for-each select="child::*[local-name()='HCP']/child::*[local-name()='MedSpeciality']">
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
				<xsl:if test="$historikk='true'">&#160;(tidligere&#160;sendt)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()='HCP']">
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
			<th colspan="{$col}" class="h3">Betalingsansvarlig<xsl:if test="child::*[local-name()='TypeGuarantor']"> - <xsl:value-of select="child::*[local-name()='TypeGuarantor']"/></xsl:if>
				<xsl:if test="$historikk='true'">&#160;(tidligere&#160;sendt)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()='HCP']">
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
			<th colspan="{$col}" class="h3">Kopimottaker<xsl:if test="child::*[local-name()='CopyDestRole']/child::*[local-name()='MsgType']"> - kopi&#160;av:&#160;<xsl:for-each select="child::*[local-name()='CopyDestRole']/child::*[local-name()='MsgType']">
						<xsl:call-template name="k-8236"/>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="$historikk='true'">&#160;(tidligere&#160;sendt)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()='HCP']">
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
				<xsl:for-each select="child::*[local-name()='Relation']">
					<xsl:call-template name="k-8254"/>
				</xsl:for-each>
				<xsl:if test="$historikk='true'">&#160;(tidligere&#160;sendt)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()='HCP']">
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
					<xsl:when test="child::*[local-name()='Relation']/@DN">
						<xsl:for-each select="child::*[local-name()='Relation']">
							<xsl:call-template name="k-7319"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Ansvarlig&#160;helsetjenesteenhet</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$historikk='true'">&#160;(tidligere&#160;sendt)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()='HCP']">
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
			<th colspan="{$col}" class="h3">Oppholdssted for pasient<xsl:if test="child::*[local-name()='AdmCat']"> - Type&#160;tjeneste:&#160;<xsl:for-each select="child::*[local-name()='AdmCat']">
						<xsl:call-template name="k-8240"/>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="$historikk='true'">&#160;(tidligere&#160;sendt)</xsl:if>
			</th>
		</tr>
		<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='Inst']">
			<tr>
				<xsl:call-template name="Inst">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='Inst']/child::*[local-name()='Dept']">
			<tr>
				<xsl:call-template name="Dept">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='Inst']/child::*[local-name()='HCPerson']">
			<tr>
				<xsl:call-template name="HCPerson">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='Address']">
			<xsl:variable name="antall-tel" select="count(child::*[local-name()='TeleAddress'])"/>
			<tr>
				<xsl:for-each select="child::*[local-name()='TeleAddress']">
					<xsl:call-template name="TeleAddress">
						<xsl:with-param name="col" select="(($col)-1)*number(not(child::*[local-name()='Type'] and (child::*[local-name()='PostalCode'] or child::*[local-name()='City'])))+1"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:if test="child::*[local-name()='Type'] and (child::*[local-name()='PostalCode'] or child::*[local-name()='City'])">
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
		<xsl:for-each select="child::*[local-name()='Inst']">
			<tr>
				<xsl:call-template name="Inst">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Inst']/child::*[local-name()='Dept']">
			<tr>
				<xsl:call-template name="Dept">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Inst']/child::*[local-name()='HCPerson']">
			<tr>
				<xsl:call-template name="HCPerson">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='HCProf']">
			<tr>
				<xsl:call-template name="HCProf">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Address']">
			<xsl:variable name="antall-tel" select="count(child::*[local-name()='TeleAddress'])"/>
			<tr>
				<xsl:for-each select="child::*[local-name()='TeleAddress']">
					<xsl:call-template name="TeleAddress">
						<xsl:with-param name="col" select="(($col)-1)*number(not(child::*[local-name()='Type'] and (child::*[local-name()='PostalCode'] or child::*[local-name()='City'])))+1"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:if test="child::*[local-name()='Type'] and (child::*[local-name()='PostalCode'] or child::*[local-name()='City'])">
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
		<xsl:if test="child::*[local-name()='Type'] or child::*[local-name()='Name']">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()='Type']">
						<xsl:for-each select="child::*[local-name()='Type']">
							<xsl:call-template name="k-9060"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Helsepersonell</xsl:otherwise>
				</xsl:choose>
			</th>
			<td width="{$std-td}px">
				<xsl:value-of select="child::*[local-name()='Name']"/>
			</td>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Id'] or child::*[local-name()='AdditionalId']">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()='TypeId']">
						<xsl:for-each select="child::*[local-name()='TypeId']">
							<xsl:call-template name="k-8116"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Id</xsl:otherwise>
				</xsl:choose>
			</th>
			<xsl:choose>
				<xsl:when test="child::*[local-name()='AdditionalId']">
					<td width="{$std-td}px">
						<xsl:value-of select="child::*[local-name()='Id']"/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="{($col)-3}">
						<xsl:value-of select="child::*[local-name()='Id']"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="child::*[local-name()='AdditionalId']">
				<xsl:variable name="antall-id" select="count(child::*[local-name()='AdditionalId'])"/>
				<xsl:for-each select="child::*[local-name()='AdditionalId']">
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
		<xsl:if test="child::*[local-name()='Name']">
			<th>Navn</th>
			<td width="{$std-td}px">
				<xsl:value-of select="child::*[local-name()='Name']"/>
			</td>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Id'] or child::*[local-name()='AdditionalId']">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()='TypeId']">
						<xsl:for-each select="child::*[local-name()='TypeId']">
							<xsl:call-template name="k-9051"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Id</xsl:otherwise>
				</xsl:choose>
			</th>
			<xsl:choose>
				<xsl:when test="child::*[local-name()='AdditionalId']">
					<td width="{$std-td}px">
						<xsl:value-of select="child::*[local-name()='Id']"/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="{($col)-3}">
						<xsl:value-of select="child::*[local-name()='Id']"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="child::*[local-name()='AdditionalId']">
				<xsl:variable name="antall-id" select="count(child::*[local-name()='AdditionalId'])"/>
				<xsl:for-each select="child::*[local-name()='AdditionalId']">
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
		<xsl:if test="child::*[local-name()='Type'] or child::*[local-name()='Name']">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()='Type']">
						<xsl:for-each select="child::*[local-name()='Type']">
							<xsl:call-template name="k-8624"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Avdeling</xsl:otherwise>
				</xsl:choose>
			</th>
			<td width="{$std-td}px">
				<xsl:value-of select="child::*[local-name()='Name']"/>
			</td>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Id'] or child::*[local-name()='AdditionalId']">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()='TypeId']">
						<xsl:for-each select="child::*[local-name()='TypeId']">
							<xsl:call-template name="k-9051"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Id</xsl:otherwise>
				</xsl:choose>
			</th>
			<xsl:choose>
				<xsl:when test="child::*[local-name()='AdditionalId']">
					<td width="{$std-td}px">
						<xsl:value-of select="child::*[local-name()='Id']"/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="{($col)-3}">
						<xsl:value-of select="child::*[local-name()='Id']"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="child::*[local-name()='AdditionalId']">
				<xsl:variable name="antall-id" select="count(child::*[local-name()='AdditionalId'])"/>
				<xsl:for-each select="child::*[local-name()='AdditionalId']">
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
		<xsl:if test="child::*[local-name()='Name']">
			<th>Helsepersonell</th>
			<td width="{$std-td}px">
				<xsl:value-of select="child::*[local-name()='Name']"/>
			</td>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Id'] or child::*[local-name()='AdditionalId']">
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()='TypeId']">
						<xsl:for-each select="child::*[local-name()='TypeId']">
							<xsl:call-template name="k-8116"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Id</xsl:otherwise>
				</xsl:choose>
			</th>
			<xsl:choose>
				<xsl:when test="child::*[local-name()='AdditionalId']">
					<td width="{$std-td}px">
						<xsl:value-of select="child::*[local-name()='Id']"/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="{($col)-3}">
						<xsl:value-of select="child::*[local-name()='Id']"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="child::*[local-name()='AdditionalId']">
				<xsl:variable name="antall-id" select="count(child::*[local-name()='AdditionalId'])"/>
				<xsl:for-each select="child::*[local-name()='AdditionalId']">
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
			<xsl:for-each select="child::*[local-name()='Type']">
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
			<xsl:value-of select="child::*[local-name()='Id']"/>
		</td>
	</xsl:template>
	<!-- Visning av Adresse -->
	<xsl:template name="Address">
		<xsl:param name="col"/>
		<th>
			<xsl:choose>
				<xsl:when test="child::*[local-name()='Type']">
					<xsl:for-each select="child::*[local-name()='Type']">
						<xsl:call-template name="k-3401"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>Adresse</xsl:otherwise>
			</xsl:choose>
		</th>
		<td colspan="{$col}">
			<xsl:if test="child::*[local-name()='StreetAdr']">
				<xsl:value-of select="child::*[local-name()='StreetAdr']"/>,&#160;</xsl:if>
			<xsl:if test="child::*[local-name()='PostalCode']">
				<xsl:value-of select="child::*[local-name()='PostalCode']"/>
			</xsl:if>
			<xsl:if test="child::*[local-name()='City']">&#160;<xsl:value-of select="child::*[local-name()='City']"/>
			</xsl:if>
			<xsl:if test="child::*[local-name()='CityDistr']">,&#160;<xsl:for-each select="child::*[local-name()='CityDistr']"><xsl:call-template name="k-3403"/></xsl:for-each>
			</xsl:if>
			<xsl:if test="child::*[local-name()='County']">,&#160;<xsl:for-each select="child::*[local-name()='County']"><xsl:call-template name="k-3402"/></xsl:for-each>
			</xsl:if>
			<xsl:if test="child::*[local-name()='Country']">,&#160;<xsl:for-each select="child::*[local-name()='Country']"><xsl:call-template name="k-9043"/></xsl:for-each>
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
		<xsl:if test="child::*[local-name()='MsgType'] or child::*[local-name()='Id'] or child::*[local-name()='IssueDate'] or child::*[local-name()='MimeType'] or child::*[local-name()='Compression']">
			<tr>
				<xsl:if test="child::*[local-name()='MsgType']">
					<th>Type</th>
					<td width="{((($col)-2)*number(not(child::*[local-name()='Id'] | child::*[local-name()='IssueDate'] | child::*[local-name()='MimeType'] | child::*[local-name()='Compression']))+1)*$std-td}px" colspan="{(($col)-2)*number(not(child::*[local-name()='Id'] | child::*[local-name()='IssueDate'] | child::*[local-name()='MimeType'] | child::*[local-name()='Compression']))+1}">
						<xsl:for-each select="child::*[local-name()='MsgType']">
							<xsl:call-template name="k-8114"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Id']">
					<th>Id</th>
					<td width="{((($col)-2-count(child::*[local-name()='MsgType'])*2)*number(not(child::*[local-name()='IssueDate'] | child::*[local-name()='MimeType'] | child::*[local-name()='Compression']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='MsgType'])*2)*number(not(child::*[local-name()='IssueDate'] | child::*[local-name()='MimeType'] | child::*[local-name()='Compression']))+1}">
						<xsl:value-of select="child::*[local-name()='Id']"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='IssueDate']">
					<th>Utstedt-dato</th>
					<td width="{((($col)-2-count(child::*[local-name()='MsgType'] | child::*[local-name()='Id'])*2)*number(not(child::*[local-name()='MimeType'] | child::*[local-name()='Compression']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='MsgType'] | child::*[local-name()='Id'])*2)*number(not(child::*[local-name()='MimeType'] | child::*[local-name()='Compression']))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='IssueDate']/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='MimeType']">
					<th>Mimetype</th>
					<td width="{((($col)-2-count(child::*[local-name()='MsgType'] | child::*[local-name()='Id'] | child::*[local-name()='IssueDate'])*2)*number(not(child::*[local-name()='Compression']))+1)*$std-td}px" colspan="{(($col)-2-count(child::*[local-name()='MsgType'] | child::*[local-name()='Id'] | child::*[local-name()='IssueDate'])*2)*number(not(child::*[local-name()='Compression']))+1}">
						<xsl:value-of select="child::*[local-name()='MimeType']"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Compression']">
					<th>Komprimering</th>
					<td colspan="{($col)-1-count(child::*[local-name()='MsgType'] | child::*[local-name()='Id'] | child::*[local-name()='IssueDate'] | child::*[local-name()='MimeType'])*2}">
						<xsl:for-each select="child::*[local-name()='Compression']">
							<xsl:call-template name="k-1204"/>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Description']">
			<tr>
				<th>Beskrivelse</th>
				<td colspan="{($col)-1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='Description']"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Content'] or child::*[local-name()='FileReference']">
			<xsl:choose>
				<xsl:when test="contains(child::*[local-name()='MimeType'],'image')">
					<tr>
						<th>Bilde</th>
						<xsl:choose>
							<xsl:when test="child::*[local-name()='FileReference']">
								<td colspan="{($col)-1}">
									<img>
										<xsl:attribute name="src"><xsl:value-of select="child::*[local-name()='FileReference']"/></xsl:attribute>
										<xsl:attribute name="alt">Bilde fra ekstern URL</xsl:attribute>
									</img>
								</td>
							</xsl:when>
							<xsl:when test="child::*[local-name()='Content']">
								<td colspan="{($col)-1}">
									<xsl:choose>
										<xsl:when test="child::*[local-name()='Content']/base:Base64Container">
											<img>
												<xsl:attribute name="src"><xsl:value-of select="concat('data:',child::*[local-name()='MimeType'],';base64,',child::*[local-name()='Content']/base:Base64Container)"/></xsl:attribute>
												<xsl:attribute name="alt">Bilde vedlagt som base64-kode</xsl:attribute>
											</img>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="child::*[local-name()='Content']"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</xsl:when>
						</xsl:choose>
					</tr>
				</xsl:when>
				<xsl:when test="contains(child::*[local-name()='MimeType'],'pdf')">
					<tr>
						<th>pdf</th>
						<xsl:choose>
							<xsl:when test="child::*[local-name()='FileReference']">
								<td colspan="{($col)-1}">
									<object>
										<xsl:attribute name="data"><xsl:value-of select="concat(child::*[local-name()='FileReference'],'&#35;view&#61;FitH&#38;toolbar&#61;1')"/></xsl:attribute>
										<xsl:attribute name="type">application/pdf</xsl:attribute>
										<xsl:attribute name="width">100%</xsl:attribute>
										<xsl:attribute name="height">500px</xsl:attribute>
									</object>
								</td>
							</xsl:when>
							<xsl:when test="child::*[local-name()='Content']">
								<td colspan="{($col)-1}">
									<xsl:choose>
										<xsl:when test="child::*[local-name()='Content']/base:Base64Container">
											<object>
												<xsl:attribute name="data"><xsl:value-of select="concat('data:application/pdf;base64,',child::*[local-name()='Content']/base:Base64Container)"/></xsl:attribute>
												<xsl:attribute name="type">application/pdf</xsl:attribute>
												<xsl:attribute name="width">100%</xsl:attribute>
												<xsl:attribute name="height">500px</xsl:attribute>
											</object>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="child::*[local-name()='Content']"/>
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
								<xsl:when test="child::*[local-name()='Content']">
									<xsl:value-of select="child::*[local-name()='Content']"/>
								</xsl:when>
								<xsl:when test="child::*[local-name()='FileReference']">
									<xsl:value-of select="child::*[local-name()='FileReference']"/>
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
			<xsl:if test="//child::*[local-name()='Investigation'] or //child::*[local-name()='ResultItem'][child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V='GR']">
				<th colspan="{$investigation-col}">Undersøkelse</th>
			</xsl:if>
			<!-- Overskrift for Avviksmarkør -->
			<xsl:if test="//child::*[local-name()='DevResultInd']">
				<th colspan="{$devind-col}">Avvik</th>
			</xsl:if>
			<!-- Overskrift for Resultat -->
			<xsl:if test="//child::*[local-name()='TextResult'] or //child::*[local-name()='Interval'] or //child::*[local-name()='DateResult'] or //child::*[local-name()='NumResult']">
				<td colspan="{$res-col}">
					<b>
						<xsl:choose>
							<xsl:when test="child::*[local-name()='TextResult']/child::*[local-name()='Heading'] and child::*[local-name()='TextResult']/child::*[local-name()='Heading']/@V!='GR'">
								<xsl:for-each select="child::*[local-name()='TextResult']/child::*[local-name()='Heading']">
									<xsl:call-template name="k-8243"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>Resultat</xsl:otherwise>
						</xsl:choose>
					</b>
				</td>
			</xsl:if>
			<!-- Overskrift for Ref.interval -->
			<xsl:if test="//child::*[local-name()='RefInterval']">
				<th colspan="{$refinterval-col}">Ref.int.</th>
			</xsl:if>
			<!-- Overskrift for Benevning -->
			<xsl:if test="//child::*[local-name()='NumResultValue']/@U | //child::*[local-name()='Unit']">
				<th colspan="{$unit-col}">Benevning</th>
			</xsl:if>
			<!-- Overskrift for Kommentar -->
			<xsl:if test="//child::*[local-name()='ResultItem']/child::*[local-name()='Comment'] or //child::*[local-name()='DiagComment'] or //child::*[local-name()='Investigation']/child::*[local-name()='Comment'] or //child::*[local-name()='StructuredInfo']">
				<th colspan="{$comment-col}">Kommentar</th>
			</xsl:if>
			<!-- Overskrift for Tilknyttet tjenesteyter -->
			<xsl:if test="//child::*[local-name()='ResultItem']/child::*[local-name()='RelServProv']">
				<th colspan="{$relserv-col}">
					<xsl:choose>
						<xsl:when test="//child::*[local-name()='RelServProv']/child::*[local-name()='Relation']">
							<xsl:for-each select="//child::*[local-name()='RelServProv']/child::*[local-name()='Relation']">
								<xsl:if test="position()=1">
									<xsl:variable name="relationOne">
										<xsl:value-of select="@V"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="count(//child::*[local-name()='RelServProv']/child::*[local-name()='Relation'])=count(//child::*[local-name()='RelServProv']/child::*[local-name()='Relation'][@V=$relationOne])"><!-- Samme kode i alle relation-elementene -->
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
			<!-- Overskrift for Tidspunkt -->
			<xsl:if test="//child::*[local-name()='InvDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='DescrDate'] or //child::*[local-name()='CounterSignDate'] or //child::*[local-name()='MedicalValidationDate']">
				<th colspan="{$date-col}">
					<xsl:choose>
						<xsl:when test="//child::*[local-name()='InvDate'] and not(//child::*[local-name()='StatusChangeDate']) and not(//child::*[local-name()='DescrDate']) and not(//child::*[local-name()='CounterSignDate']) and not(//child::*[local-name()='MedicalValidationDate'])">Tidspunkt for undersøkelsen</xsl:when>
						<xsl:when test="not(//child::*[local-name()='InvDate']) and //child::*[local-name()='StatusChangeDate'] and not(//child::*[local-name()='DescrDate']) and not(//child::*[local-name()='CounterSignDate']) and not(//child::*[local-name()='MedicalValidationDate'])">Tidspunkt for beskrivelse</xsl:when>
						<xsl:when test="not(//child::*[local-name()='InvDate']) and not(//child::*[local-name()='StatusChangeDate']) and //child::*[local-name()='DescrDate'] and not(//child::*[local-name()='CounterSignDate']) and not(//child::*[local-name()='MedicalValidationDate'])">Tidspunkt for beskrivelse</xsl:when>
						<xsl:when test="not(//child::*[local-name()='InvDate']) and not(//child::*[local-name()='StatusChangeDate']) and not(//child::*[local-name()='DescrDate']) and //child::*[local-name()='CounterSignDate'] and not(//child::*[local-name()='MedicalValidationDate'])">Tidspunkt for kontrasignering</xsl:when>
						<xsl:when test="not(//child::*[local-name()='InvDate']) and not(//child::*[local-name()='StatusChangeDate']) and not(//child::*[local-name()='DescrDate']) and not(//child::*[local-name()='CounterSignDate']) and //child::*[local-name()='MedicalValidationDate']">Tidspunkt for medisinsk validering</xsl:when>
						<xsl:otherwise>Tidspunkt for</xsl:otherwise>
					</xsl:choose>
				</th>
			</xsl:if>
			<!-- Overskrift for Undersøkelsesstatus -->
			<xsl:if test="//child::*[local-name()='StatusInvestigation']">
				<th colspan="{$status-col}">Status</th>
			</xsl:if>
			<!-- Overskrift for Id -->
			<xsl:if test="//child::*[local-name()='IdResultItem']">
				<th colspan="{$id-col}">Id</th>
			</xsl:if>
			<!-- Overskrift for Ref.id -->
			<xsl:if test="//child::*[local-name()='RefIdResultItem']">
				<th colspan="{$refid-col}">Ref.id</th>
			</xsl:if>
			<!-- Overskrift for Referanse til prøve -->
			<xsl:if test="//child::*[local-name()='RefAnalysedSubject']">
				<th colspan="{$refsubject-col}">Ref.prøve</th>
			</xsl:if>
			<!-- Overskrift for Akkreditering -->
			<xsl:if test="//child::*[local-name()='ResultItem']/child::*[local-name()='Accredited']">
				<th colspan="{$acc-col}">Akkr.</th>
			</xsl:if>
		</tr>
	</xsl:template>
	<xsl:template name="skrivUtUndersokelse">
		<xsl:for-each select="child::*[local-name()='ServType']">
			<xsl:if test="@V!='N' and @V!='H'"><b><font color="red"><xsl:call-template name="k-7309"/></font></b>&#160;-&#160;</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Investigation']/child::*[local-name()='Id']">
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
		<xsl:if test="child::*[local-name()='Investigation']/child::*[local-name()='Spec']">
			<div>
				<xsl:for-each select="child::*[local-name()='Investigation']/child::*[local-name()='Spec']">
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
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="skrivUtResultat">
		<xsl:param name="sammendrag"/>
		<xsl:choose>
			<xsl:when test="child::*[local-name()='TextResult']">
				<xsl:for-each select="child::*[local-name()='TextResult']/child::*[local-name()='Heading'][@V='AN' or @V='VU' or @V='UP' or @V='SY']">
					<b><xsl:call-template name="k-8243"/></b>:&#160;
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='TextResult']/child::*[local-name()='TextResultValue']">
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
				<xsl:for-each select="child::*[local-name()='TextResult']/child::*[local-name()='TextCode']">
					<xsl:if test="not(contains(@S, '7010') and $sammendrag)">
						<xsl:choose>
							<xsl:when test="contains(@S, '7010')">
								<div>SNOMED:&#160;<xsl:call-template name="k-dummy-V"/></div>
							</xsl:when>
							<xsl:when test="contains(@S, '8212')">
								<div><xsl:call-template name="k-dummy-OT"/></div>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="k-dummy"/>
								<xsl:if test="position()!=last()"><br/></xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="child::*[local-name()='Interval']">
				<xsl:value-of select="child::*[local-name()='Interval']/child::*[local-name()='Low']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='Interval']/child::*[local-name()='Low']/@U"/>&#160;-&#160;<xsl:value-of select="child::*[local-name()='Interval']/child::*[local-name()='High']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='Interval']/child::*[local-name()='High']/@U"/>
			</xsl:when>
			<xsl:when test="DateResult">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateResult']/@V"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="child::*[local-name()='NumResult']">
				<xsl:for-each select="child::*[local-name()='NumResult']/child::*[local-name()='ArithmeticComp']">
					<xsl:call-template name="k-8239"/>
				</xsl:for-each>
				<xsl:value-of select="child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@V"/>&#160;
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="skrivUtRefInterval">
		<xsl:for-each select="child::*[local-name()='RefInterval']">
			<xsl:value-of select="child::*[local-name()='Descr']"/>&#160;
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="skrivUtTidspunktFor">
		<xsl:if test="child::*[local-name()='InvDate']">
			<div>
				<xsl:if test="//child::*[local-name()='DescrDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='CounterSignDate'] or //child::*[local-name()='MedicalValidationDate']"><b>Undersøkelse</b>:&#160;</xsl:if>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='InvDate']/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='DescrDate']">
			<div>
				<xsl:if test="//child::*[local-name()='InvDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='CounterSignDate'] or //child::*[local-name()='MedicalValidationDate']"><b>Beskrivelse</b>:&#160;</xsl:if>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='DescrDate']/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='StatusChangeDate']">
			<div>
				<xsl:if test="//child::*[local-name()='InvDate'] or //child::*[local-name()='DescrDate'] or //child::*[local-name()='CounterSignDate'] or //child::*[local-name()='MedicalValidationDate']"><b>Statusendring</b>:&#160;</xsl:if>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='StatusChangeDate']/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='CounterSignDate']">
			<div>
				<xsl:if test="//child::*[local-name()='InvDate'] or //child::*[local-name()='DescrDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='MedicalValidationDate']"><b>Kontrasignering</b>:&#160;</xsl:if>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='CounterSignDate']/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='MedicalValidationDate']">
			<div>
				<xsl:if test="//child::*[local-name()='InvDate'] or //child::*[local-name()='DescrDate'] or //child::*[local-name()='StatusChangeDate'] or //child::*[local-name()='CounterSignDate']"><b>Medisinsk&#160;validering</b>:&#160;</xsl:if>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='MedicalValidationDate']/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="skrivUtTjenesteyter">
		<xsl:variable name="relationOne">
			<xsl:value-of select="child::*[local-name()='RelServProv']/child::*[local-name()='Relation']/@V"/>
		</xsl:variable>
		<xsl:for-each select="child::*[local-name()='RelServProv']">
			<xsl:if test="count(//child::*[local-name()='RelServProv']/child::*[local-name()='Relation'])!=count(//child::*[local-name()='RelServProv']/child::*[local-name()='Relation'][@V=$relationOne])">
				<xsl:for-each select="child::*[local-name()='Relation']">
					<b><xsl:call-template name="k-8254"/></b>:&#160;
				</xsl:for-each>
			</xsl:if>
			<xsl:value-of select="descendant::*[local-name()='Name']"/>
			<xsl:if test="position()!=last()"><br/></xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="skrivUtBenevning">
		<xsl:if test="child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U">
			<xsl:value-of select="child::*[local-name()='NumResult']/child::*[local-name()='NumResultValue']/@U"/>&#160;
		</xsl:if>
		<xsl:if test="child::*[local-name()='TextResult']/child::*[local-name()='Unit']">
			<xsl:value-of select="child::*[local-name()='TextResult']/child::*[local-name()='Unit']"/>&#160;
		</xsl:if>
	</xsl:template>
	<xsl:template name="skrivUtKommentar">
		<xsl:if test="child::*[local-name()='StructuredInfo']">
			Se Strukturert resultat
			<xsl:if test="count(//child::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']])!=1">
				<xsl:value-of select="count(//child::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']])-count(following-sibling::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']])-count(parent::*[local-name()='ResultItem']/following-sibling::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']])-count(child::*[local-name()='ResultItem'][child::*[local-name()='StructuredInfo']])"/>
			</xsl:if>
			under.&#160;
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='Investigation']/child::*[local-name()='Comment'] | child::*[local-name()='Comment']">
			<div>
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="."/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='DiagComment']">
			<div>
				<xsl:for-each select="child::*[local-name()='Concept']">
					<xsl:call-template name="k-dummy"/>&#160;
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='Modifier']">
					<xsl:for-each select="child::*[local-name()='Name']">
						<b><xsl:call-template name="k-7305"/></b>:&#160;
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()='Value']">
						<xsl:call-template name="k-dummy"/>
					</xsl:for-each>
				</xsl:for-each>&#160;
			</div>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="skrivUtAkkrediert">
		<xsl:if test="child::*[local-name()='Accredited']">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='Accredited']/@V='true'"><input type="checkbox" checked="checked" disabled="disabled"/></xsl:when>
				<xsl:otherwise><input type="checkbox" disabled="disabled"/></xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
