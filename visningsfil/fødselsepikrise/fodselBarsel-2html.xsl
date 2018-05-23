<?xml version="1.0" encoding="UTF-8"?>
	<!-- Endringslogg
	- 25.10.16: La til visningsversjonnr
	- 17.06.16 - Første versjon. Viser Fødselspikrise v1.3 eller lavere samt vedlagt Utskrivningsrapport versjon 1.6 eller lavere.
	-->
	<!-- Om
	- Inngår i Hdirs visningsfiler versjon 3.0
	- Laget i XMLSpy Ent.Ed. ver. 2016 rel. 2  (http://www.altova.com) av Jan Sigurd Dragsjø (nhn.no)
	-->
<xsl:stylesheet version="1.0" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" 
	exclude-result-prefixes="mh">

	<xsl:import href="../Felleskomponenter/meldingshode2html.xsl"/>
	<xsl:import href="../Felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../Felleskomponenter/kodeverk.xsl"/>
	<xsl:import href="../plo/v1.6 eller lavere/plo2html.xsl"/>
	
	<xsl:output method="html" version="4.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" 
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	
	<!-- Variabel for hvilken stil visningen har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'One-line-doc'"/>

	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="8"/>
	<xsl:variable name="std-td" select="100"/>

	<!-- Variabel for hvilken versjon av visningsfilen -->
	<xsl:variable name="versjon" select="'fødselsepikrise v3.1.0 '"/>

	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Fødselsepikrise</title>
				<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
				<style type="text/css"><xsl:value-of select="document('../Felleskomponenter/KITH-visning.css')" disable-output-escaping="yes" /></style>
			</head>
			<body>
				<xsl:apply-templates select="mh:MsgHead"/>
			</body>
		</html>
	</xsl:template>
	
	<!-- Visning av meldingshodet. Tilpasset vinduskonvolutt ved utskrift -->
	<xsl:template match="mh:MsgHead">
		<xsl:call-template name="Topp"/>
		<xsl:call-template name="FBInnhold"/>
		<xsl:call-template name="Innhold"/>
		<xsl:choose>
			<!-- Inngang for å komponere egen bunn i EgetBunnTillegg nedenfor. Foreløpig hoppes den over -->
			<xsl:when test="not(1)">
				<xsl:call-template name="BunnTillegg">
					<xsl:with-param name="stil" select="$stil"/>
					<xsl:with-param name="versjon" select="$versjon"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="Bunn">
					<xsl:with-param name="stil" select="$stil"/>
					<xsl:with-param name="versjon" select="$versjon"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Template som kalles fra BunnTillegg i meldingshodet. Kan brukes til visning av egenkomponert bunn -->
	<xsl:template name="EgetBunnTillegg">
	</xsl:template>
	
	<!-- Visning av innhold i fødselsepikrise -->
	<xsl:template name="FBInnhold">
		<div class="{$stil}">
			<!-- Overskrift for meldingen -->
			<h1 id="Fodselsepikrise">Fødselsepikrise</h1>
			<xsl:call-template name="FBFellesMeny"/>
			<xsl:call-template name="FBDokument"/>
		</div>
	</xsl:template>
	
	<!-- Visning av klikkbar overskriftsliste for fødselsepikrise. Ikke synlig ved utskrift -->
	<xsl:template name="FBFellesMeny">
		<div class="NoPrint">
			<div id="FellesMeny" class="FellesMeny">
				<ul>
					<xsl:if test="//child::*[local-name()=&quot;Barneundersokelse&quot;]">
						<li>
							<a href="#Barneundersokelse">Barneundersøkelse</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;OpplysningerOmFodselen&quot;]">
						<li>
							<a href="#OpplysningerOmFodselen">Opplysninger&#160;om&#160;fødselen</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;BarselforlopBarn&quot;]">
						<li>
							<a href="#BarselforlopBarn">Barselforløp&#160;barn</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;BarselforlopMor&quot;]">
						<li>
							<a href="#BarselforlopMor">Barselforløp&#160;mor</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;TidligereSvangerskap&quot;]">
						<li>
							<a href="#TidligereSvangerskap">Tidligere&#160;svangerskap</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;TverrfagligEpikrise&quot;]">
						<li>
							<a href="#Utskrivningsrapport">Utskrivningsrapport</a>
						</li>
					</xsl:if>
				</ul>
			</div>
		</div>
	</xsl:template>
	
	<!-- Visning av vedlagte fødselsepikrise -->
	<xsl:template name="FBDokument">
		<!-- Tabell og overskrift for Barneundersøkelse -->
		<xsl:if test="//child::*[local-name()=&quot;Barneundersokelse&quot;]">
			<h2 id="Barneundersokelse">Barneundersøkelse</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;Barneundersokelse&quot;]">
						<xsl:call-template name="Barneundersokelse"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Opplysninger om fødselen -->
		<xsl:if test="//child::*[local-name()=&quot;OpplysningerOmFodselen&quot;]">
			<h2 id="OpplysningerOmFodselen">Opplysninger&#160;om&#160;fødselen</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;OpplysningerOmFodselen&quot;]">
						<xsl:call-template name="OpplysningerOmFodselen"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Barselforløp barn -->
		<xsl:if test="//child::*[local-name()=&quot;BarselforlopBarn&quot;]">
			<h2 id="BarselforlopBarn">Barselforløp&#160;barn</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;BarselforlopBarn&quot;]">
						<xsl:call-template name="BarselforlopBarn"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Barselforløp mor -->
		<xsl:if test="//child::*[local-name()=&quot;BarselforlopMor&quot;]">
			<h2 id="BarselforlopMor">Barselforløp&#160;mor</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;BarselforlopMor&quot;]">
						<xsl:call-template name="BarselforlopMor"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Tidligere svangerskap -->
		<xsl:if test="//child::*[local-name()=&quot;TidligereSvangerskap&quot;]">
			<h2 id="TidligereSvangerskap">Tidligere&#160;svangerskap</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;TidligereSvangerskap&quot;]">
						<xsl:call-template name="TidligereSvangerskap"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	
	<!-- Visning av innhold i Barneundersøkelse -->
	<xsl:template name="Barneundersokelse">
		<xsl:if test="child::*[local-name()=&quot;Fodselstidspunkt&quot;] or child::*[local-name()=&quot;Levestatus&quot;] or child::*[local-name()=&quot;Kjonn&quot;] or child::*[local-name()=&quot;ApgarScore&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Fodselstidspunkt&quot;]">
					<th>Fødselstidspunkt</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Levestatus&quot;] | child::*[local-name()=&quot;Kjonn&quot;] | child::*[local-name()=&quot;ApgarScore&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Levestatus&quot;] | child::*[local-name()=&quot;Kjonn&quot;] | child::*[local-name()=&quot;ApgarScore&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Fodselstidspunkt&quot;]">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="@V"/>
							</xsl:call-template>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Levestatus&quot;]">
					<th>Barnet&#160;var</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Fodselstidspunkt&quot;])*2)*number(not(child::*[local-name()=&quot;Kjonn&quot;] | child::*[local-name()=&quot;ApgarScore&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Fodselstidspunkt&quot;])*2)*number(not(child::*[local-name()=&quot;Kjonn&quot;] | child::*[local-name()=&quot;ApgarScore&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Levestatus&quot;]">
							<xsl:call-template name="k-8522"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Kjonn&quot;]">
					<th>Kjønn</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Fodselstidspunkt&quot;] | child::*[local-name()=&quot;Levestatus&quot;])*2)*number(not(child::*[local-name()=&quot;ApgarScore&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Fodselstidspunkt&quot;] | child::*[local-name()=&quot;Levestatus&quot;])*2)*number(not(child::*[local-name()=&quot;ApgarScore&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Kjonn&quot;]">
							<xsl:call-template name="k-3101"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;ApgarScore&quot;]">
					<th>Apgar&#160;score</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;Fodselstidspunkt&quot;] | child::*[local-name()=&quot;Levestatus&quot;] | child::*[local-name()=&quot;Kjonn&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;ApgarScore&quot;]">
							<xsl:value-of select="."/>
							<xsl:if test="not(position()=last())">-</xsl:if>
						</xsl:for-each>&#160;
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;FodselsVekt&quot;] or child::*[local-name()=&quot;FodselsLengde&quot;] or child::*[local-name()=&quot;FodselsHodeomkrets&quot;] or child::*[local-name()=&quot;Merknader&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;FodselsVekt&quot;]">
					<th>Vekt</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;FodselsLengde&quot;] | child::*[local-name()=&quot;FodselsHodeomkrets&quot;] | child::*[local-name()=&quot;Merknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;FodselsLengde&quot;] | child::*[local-name()=&quot;FodselsHodeomkrets&quot;] | child::*[local-name()=&quot;Merknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;FodselsVekt&quot;]">
							<xsl:value-of select="."/>g&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;FodselsLengde&quot;]">
					<th>Lengde</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;FodselsVekt&quot;])*2)*number(not(child::*[local-name()=&quot;FodselsHodeomkrets&quot;] | child::*[local-name()=&quot;Merknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;FodselsVekt&quot;])*2)*number(not(child::*[local-name()=&quot;FodselsHodeomkrets&quot;] | child::*[local-name()=&quot;Merknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;FodselsLengde&quot;]">
							<xsl:value-of select="."/>cm&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;FodselsHodeomkrets&quot;]">
					<th>Hodeomkrets</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;FodselsVekt&quot;] | child::*[local-name()=&quot;FodselsLengde&quot;])*2)*number(not(child::*[local-name()=&quot;Merknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;FodselsVekt&quot;] | child::*[local-name()=&quot;FodselsLengde&quot;])*2)*number(not(child::*[local-name()=&quot;Merknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;FodselsHodeomkrets&quot;]">
							<xsl:value-of select="."/>cm&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Merknader&quot;]">
					<th>Merknader</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;FodselsVekt&quot;] | child::*[local-name()=&quot;FodselsLengde&quot;] | child::*[local-name()=&quot;FodselsHodeomkrets&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;Merknader&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Horselsscreening&quot;] or child::*[local-name()=&quot;HorselsscreeningNormaleFunn&quot;] or child::*[local-name()=&quot;NyfodtscreeningMedfodtStoffskiftesykdommer&quot;] or child::*[local-name()=&quot;MerknaderScreening&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Horselsscreening&quot;]">
					<th>Hørselsscreening&#160;utført?</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;HorselsscreeningNormaleFunn&quot;] | child::*[local-name()=&quot;NyfodtscreeningMedfodtStoffskiftesykdommer&quot;] | child::*[local-name()=&quot;MerknaderScreening&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;HorselsscreeningNormaleFunn&quot;] | child::*[local-name()=&quot;NyfodtscreeningMedfodtStoffskiftesykdommer&quot;] | child::*[local-name()=&quot;MerknaderScreening&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Horselsscreening&quot;]">
							<xsl:call-template name="k-1101"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;HorselsscreeningNormaleFunn&quot;]">
					<th>Normale&#160;funn&#160;ved hørselsscreening?</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Horselsscreening&quot;])*2)*number(not(child::*[local-name()=&quot;NyfodtscreeningMedfodtStoffskiftesykdommer&quot;] | child::*[local-name()=&quot;MerknaderScreening&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Horselsscreening&quot;])*2)*number(not(child::*[local-name()=&quot;NyfodtscreeningMedfodtStoffskiftesykdommer&quot;] | child::*[local-name()=&quot;MerknaderScreening&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;HorselsscreeningNormaleFunn&quot;]">
							<xsl:call-template name="k-1101"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;NyfodtscreeningMedfodtStoffskiftesykdommer&quot;]">
					<th>Screening&#160;for&#160;medfødte stoffskiftesykdommer&#160;utført?</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Horselsscreening&quot;] | child::*[local-name()=&quot;HorselsscreeningNormaleFunn&quot;])*2)*number(not(child::*[local-name()=&quot;MerknaderScreening&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Horselsscreening&quot;] | child::*[local-name()=&quot;HorselsscreeningNormaleFunn&quot;])*2)*number(not(child::*[local-name()=&quot;MerknaderScreening&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;NyfodtscreeningMedfodtStoffskiftesykdommer&quot;]">
							<xsl:call-template name="k-1101"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;MerknaderScreening&quot;]">
					<th>Merknader&#160;screening</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;Horselsscreening&quot;] | child::*[local-name()=&quot;HorselsscreeningNormaleFunn&quot;] | child::*[local-name()=&quot;NyfodtscreeningMedfodtStoffskiftesykdommer&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;MerknaderScreening&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Modenhetsbedommelse&quot;] or child::*[local-name()=&quot;UkomplisertForlopEtterFodselen&quot;] or child::*[local-name()=&quot;OrganundersokelseNormaleFunn&quot;] or child::*[local-name()=&quot;MerknaderOrganundersokelser&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Modenhetsbedommelse&quot;]">
					<th>Modenhetsbedømmelse</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;UkomplisertForlopEtterFodselen&quot;] | child::*[local-name()=&quot;OrganundersokelseNormaleFunn&quot;] | child::*[local-name()=&quot;MerknaderOrganundersokelser&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;UkomplisertForlopEtterFodselen&quot;] | child::*[local-name()=&quot;OrganundersokelseNormaleFunn&quot;] | child::*[local-name()=&quot;MerknaderOrganundersokelser&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Modenhetsbedommelse&quot;]">
							<xsl:value-of select="."/>&#160;uker&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;UkomplisertForlopEtterFodselen&quot;]">
					<th>Ukomplisert&#160;forløp etter&#160;fødselen?</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Modenhetsbedommelse&quot;])*2)*number(not(child::*[local-name()=&quot;OrganundersokelseNormaleFunn&quot;] | child::*[local-name()=&quot;MerknaderOrganundersokelser&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Modenhetsbedommelse&quot;])*2)*number(not(child::*[local-name()=&quot;OrganundersokelseNormaleFunn&quot;] | child::*[local-name()=&quot;MerknaderOrganundersokelser&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;UkomplisertForlopEtterFodselen&quot;]">
							<xsl:call-template name="k-1101"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;OrganundersokelseNormaleFunn&quot;]">
					<th>Normale&#160;funn&#160;ved organundersøkelse?</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Modenhetsbedommelse&quot;] | child::*[local-name()=&quot;UkomplisertForlopEtterFodselen&quot;])*2)*number(not(child::*[local-name()=&quot;MerknaderOrganundersokelser&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Modenhetsbedommelse&quot;] | child::*[local-name()=&quot;UkomplisertForlopEtterFodselen&quot;])*2)*number(not(child::*[local-name()=&quot;MerknaderOrganundersokelser&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;OrganundersokelseNormaleFunn&quot;]">
							<xsl:call-template name="k-1101"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;MerknaderOrganundersokelser&quot;]">
					<th>Merknader&#160;organundersøkelse</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;Modenhetsbedommelse&quot;] | child::*[local-name()=&quot;UkomplisertForlopEtterFodselen&quot;] | child::*[local-name()=&quot;OrganundersokelseNormaleFunn&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;MerknaderOrganundersokelser&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<!-- Visning av innhold i Opplysninger om fødselen -->
	<xsl:template name="OpplysningerOmFodselen">
		<xsl:if test="../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Episiotomi&quot;] or ../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Rifter&quot;] or ../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Leie&quot;] or ../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Merknader&quot;]">
			<tr>
				<xsl:if test="../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Episiotomi&quot;]">
					<th>Episiotomi&#160;utført?</th>
					<td width="{((($std-col)-2)*number(not(../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Rifter&quot;] | ../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Leie&quot;] | ../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Merknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Rifter&quot;] | ../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Leie&quot;] | ../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Merknader&quot;]))+1}">
						<xsl:for-each select="../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Episiotomi&quot;]">
							<xsl:call-template name="k-1101"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Rifter&quot;]">
					<th>Rifter</th>
					<td width="{((($std-col)-2-count(../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Episiotomi&quot;])*2)*number(not(../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Leie&quot;] | ../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Merknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Episiotomi&quot;])*2)*number(not(../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Leie&quot;] | ../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Merknader&quot;]))+1}">
						<xsl:for-each select="../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Rifter&quot;]">
							<xsl:call-template name="k-8529"/>
							<xsl:if test="not(position()=last())">,&#160;</xsl:if>
						</xsl:for-each>&#160;
					</td>
				</xsl:if>
				<xsl:if test="../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Leie&quot;]">
					<th>Barnets&#160;leie</th>
					<td width="{((($std-col)-2-count(../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Episiotomi&quot;] | ../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Rifter&quot;])*2)*number(not(../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Merknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Episiotomi&quot;] | ../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Rifter&quot;])*2)*number(not(../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Merknader&quot;]))+1}">
						<xsl:for-each select="../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Leie&quot;]">
							<xsl:call-template name="k-8531"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Merknader&quot;]">
					<th>Merknader&#160;til&#160;leiet</th>
					<td colspan="{($std-col)-1-count(../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Episiotomi&quot;] | ../child::*[local-name()=&quot;EpisiotomiRifter&quot;]/child::*[local-name()=&quot;Rifter&quot;] | ../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Leie&quot;])*2}">
						<xsl:for-each select="../child::*[local-name()=&quot;BarnetsLeieVedFodselstidspunktet&quot;]/child::*[local-name()=&quot;Merknader&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Fodselsstart&quot;] or child::*[local-name()=&quot;ForlosendeInngrep&quot;] or child::*[local-name()=&quot;Pluralitet&quot;] or child::*[local-name()=&quot;AntallBarn&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Fodselsstart&quot;]">
					<th>Fødselsstart</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;ForlosendeInngrep&quot;] | child::*[local-name()=&quot;Pluralitet&quot;] | child::*[local-name()=&quot;AntallBarn&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;ForlosendeInngrep&quot;] | child::*[local-name()=&quot;Pluralitet&quot;] | child::*[local-name()=&quot;AntallBarn&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Fodselsstart&quot;]">
							<xsl:call-template name="k-8526"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;ForlosendeInngrep&quot;]">
					<th>Forløsende&#160;inngrep</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Fodselsstart&quot;])*2)*number(not(child::*[local-name()=&quot;Pluralitet&quot;] | child::*[local-name()=&quot;AntallBarn&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Fodselsstart&quot;])*2)*number(not(child::*[local-name()=&quot;Pluralitet&quot;] | child::*[local-name()=&quot;AntallBarn&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;ForlosendeInngrep&quot;]">
							<xsl:call-template name="k-8527"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Pluralitet&quot;]">
					<th>Pluralitet</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Fodselsstart&quot;] | child::*[local-name()=&quot;ForlosendeInngrep&quot;])*2)*number(not(child::*[local-name()=&quot;AntallBarn&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Fodselsstart&quot;] | child::*[local-name()=&quot;ForlosendeInngrep&quot;])*2)*number(not(child::*[local-name()=&quot;AntallBarn&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Pluralitet&quot;]">
							<xsl:call-template name="k-8528"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;AntallBarn&quot;]">
					<th>Antall&#160;barn</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;Fodselsstart&quot;] | child::*[local-name()=&quot;ForlosendeInngrep&quot;] | child::*[local-name()=&quot;Pluralitet&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;AntallBarn&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Svangerskapslengde&quot;] or child::*[local-name()=&quot;Blodning&quot;] or child::*[local-name()=&quot;Merknader&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Svangerskapslengde&quot;]">
					<th>Svangerskapslengde</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Blodning&quot;] | child::*[local-name()=&quot;Merknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Blodning&quot;] | child::*[local-name()=&quot;Merknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Svangerskapslengde&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Blodning&quot;]">
					<th>Blødning</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Svangerskapslengde&quot;])*2)*number(not(child::*[local-name()=&quot;Merknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Svangerskapslengde&quot;])*2)*number(not(child::*[local-name()=&quot;Merknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Blodning&quot;]">
							<xsl:value-of select="."/>ml&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Merknader&quot;]">
					<th>Merknader</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;Svangerskapslengde&quot;] | child::*[local-name()=&quot;Blodning&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;Merknader&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<!-- Visning av innhold i Barselforløp barn -->
	<xsl:template name="BarselforlopBarn">
		<xsl:if test="child::*[local-name()=&quot;Ernaering&quot;] or child::*[local-name()=&quot;Dieproblem&quot;] or child::*[local-name()=&quot;TiltakDato&quot;] or child::*[local-name()=&quot;AvtalteTiltak&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Ernaering&quot;]">
					<th>Ernæring</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Dieproblem&quot;] | child::*[local-name()=&quot;TiltakDato&quot;] | child::*[local-name()=&quot;AvtalteTiltak&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Dieproblem&quot;] | child::*[local-name()=&quot;TiltakDato&quot;] | child::*[local-name()=&quot;AvtalteTiltak&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Ernaering&quot;]">
							<xsl:call-template name="k-8523"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Dieproblem&quot;]">
					<th>Dieproblem?</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Ernaering&quot;])*2)*number(not(child::*[local-name()=&quot;TiltakDato&quot;] | child::*[local-name()=&quot;AvtalteTiltak&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Ernaering&quot;])*2)*number(not(child::*[local-name()=&quot;TiltakDato&quot;] | child::*[local-name()=&quot;AvtalteTiltak&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Dieproblem&quot;]">
							<xsl:call-template name="k-1101"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;TiltakDato&quot;]">
					<th>Dato&#160;for&#160;tiltak</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Ernaering&quot;] | child::*[local-name()=&quot;Dieproblem&quot;])*2)*number(not(child::*[local-name()=&quot;AvtalteTiltak&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Ernaering&quot;] | child::*[local-name()=&quot;Dieproblem&quot;])*2)*number(not(child::*[local-name()=&quot;AvtalteTiltak&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;TiltakDato&quot;]">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="@V"/>
							</xsl:call-template>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;AvtalteTiltak&quot;]">
					<th>Avtalte&#160;tiltak</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;Ernaering&quot;] | child::*[local-name()=&quot;Dieproblem&quot;] | child::*[local-name()=&quot;TiltakDato&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;AvtalteTiltak&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;LavesteVektUnderOpphold&quot;] or child::*[local-name()=&quot;LavesteVektDato&quot;] or child::*[local-name()=&quot;VektVedUtreise&quot;] or child::*[local-name()=&quot;ErnaeringMerknader&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;LavesteVektUnderOpphold&quot;]">
					<th>Laveste&#160;vekt</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;LavesteVektDato&quot;] | child::*[local-name()=&quot;VektVedUtreise&quot;] | child::*[local-name()=&quot;ErnaeringMerknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;LavesteVektDato&quot;] | child::*[local-name()=&quot;VektVedUtreise&quot;] | child::*[local-name()=&quot;ErnaeringMerknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;LavesteVektUnderOpphold&quot;]">
							<xsl:value-of select="."/>g&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;LavesteVektDato&quot;]">
					<th>Dato&#160;for&#160;laveste&#160;vekt</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;LavesteVektUnderOpphold&quot;])*2)*number(not(child::*[local-name()=&quot;VektVedUtreise&quot;] | child::*[local-name()=&quot;ErnaeringMerknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;LavesteVektUnderOpphold&quot;])*2)*number(not(child::*[local-name()=&quot;VektVedUtreise&quot;] | child::*[local-name()=&quot;ErnaeringMerknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;LavesteVektDato&quot;]">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="@V"/>
							</xsl:call-template>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;VektVedUtreise&quot;]">
					<th>Vekt&#160;ved&#160;utreise</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;LavesteVektUnderOpphold&quot;] | child::*[local-name()=&quot;LavesteVektDato&quot;])*2)*number(not(child::*[local-name()=&quot;ErnaeringMerknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;LavesteVektUnderOpphold&quot;] | child::*[local-name()=&quot;LavesteVektDato&quot;])*2)*number(not(child::*[local-name()=&quot;ErnaeringMerknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;VektVedUtreise&quot;]">
							<xsl:value-of select="."/>g&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;ErnaeringMerknader&quot;]">
					<th>Merknader&#160;til&#160;ernæring</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;LavesteVektUnderOpphold&quot;] | child::*[local-name()=&quot;LavesteVektDato&quot;] | child::*[local-name()=&quot;VektVedUtreise&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;ErnaeringMerknader&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;HodeomkretsUnderOpphold&quot;] or child::*[local-name()=&quot;HodeomkretsDato&quot;] or child::*[local-name()=&quot;LengdemaalUnderOpphold&quot;] or child::*[local-name()=&quot;LengdemaalDato&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;HodeomkretsUnderOpphold&quot;]">
					<th>Hodeomkrets&#160;under&#160;opphold</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;HodeomkretsDato&quot;] | child::*[local-name()=&quot;LengdemaalUnderOpphold&quot;] | child::*[local-name()=&quot;LengdemaalDato&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;HodeomkretsDato&quot;] | child::*[local-name()=&quot;LengdemaalUnderOpphold&quot;] | child::*[local-name()=&quot;LengdemaalDato&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;HodeomkretsUnderOpphold&quot;]">
							<xsl:value-of select="."/>cm&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;HodeomkretsDato&quot;]">
					<th>Dato&#160;for&#160;målt&#160;hodeomkrets</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;HodeomkretsUnderOpphold&quot;])*2)*number(not(child::*[local-name()=&quot;LengdemaalUnderOpphold&quot;] | child::*[local-name()=&quot;LengdemaalDato&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;HodeomkretsUnderOpphold&quot;])*2)*number(not(child::*[local-name()=&quot;LengdemaalUnderOpphold&quot;] | child::*[local-name()=&quot;LengdemaalDato&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;HodeomkretsDato&quot;]">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="@V"/>
							</xsl:call-template>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;LengdemaalUnderOpphold&quot;]">
					<th>Lengdemål&#160;under&#160;opphold</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;HodeomkretsUnderOpphold&quot;] | child::*[local-name()=&quot;HodeomkretsDato&quot;])*2)*number(not(child::*[local-name()=&quot;LengdemaalDato&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;HodeomkretsUnderOpphold&quot;] | child::*[local-name()=&quot;HodeomkretsDato&quot;])*2)*number(not(child::*[local-name()=&quot;LengdemaalDato&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;LengdemaalUnderOpphold&quot;]">
							<xsl:value-of select="."/>cm&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;LengdemaalDato&quot;]">
					<th>Dato&#160;for&#160;målt&#160;lengdemål</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;HodeomkretsUnderOpphold&quot;] | child::*[local-name()=&quot;HodeomkretsDato&quot;] | child::*[local-name()=&quot;LengdemaalUnderOpphold&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;LengdemaalDato&quot;]">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="@V"/>
							</xsl:call-template>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()=&quot;Utreise&quot;]">
			<xsl:call-template name="Utreise"/>
		</xsl:for-each>
	</xsl:template>
	
	<!-- Visning av innhold i Barselforløp mor -->
	<xsl:template name="BarselforlopMor">
		<xsl:if test="child::*[local-name()=&quot;Amming&quot;] or child::*[local-name()=&quot;Ammehjelpemidler&quot;] or child::*[local-name()=&quot;AmmingMerknader&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Amming&quot;]">
					<th>Amming</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Ammehjelpemidler&quot;] | child::*[local-name()=&quot;AmmingMerknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Ammehjelpemidler&quot;] | child::*[local-name()=&quot;AmmingMerknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Amming&quot;]">
							<xsl:call-template name="k-8524"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Ammehjelpemidler&quot;]">
					<th>Ammehjelpemidler</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Amming&quot;])*2)*number(not(child::*[local-name()=&quot;AmmingMerknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Amming&quot;])*2)*number(not(child::*[local-name()=&quot;AmmingMerknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Ammehjelpemidler&quot;]">
							<xsl:call-template name="k-8525"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;AmmingMerknader&quot;]">
					<th>Merknader&#160;til&#160;amming</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;Amming&quot;] | child::*[local-name()=&quot;Ammehjelpemidler&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;AmmingMerknader&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;UkomplisertBarselforlop&quot;] or child::*[local-name()=&quot;KomplikasjonerBarselforlop&quot;] or child::*[local-name()=&quot;BarselforlopMerknader&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;UkomplisertBarselforlop&quot;]">
					<th>Ukomplisert&#160;barselforløp?</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;KomplikasjonerBarselforlop&quot;] | child::*[local-name()=&quot;BarselforlopMerknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;KomplikasjonerBarselforlop&quot;] | child::*[local-name()=&quot;BarselforlopMerknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;UkomplisertBarselforlop&quot;]">
							<xsl:call-template name="k-1101"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;KomplikasjonerBarselforlop&quot;]">
					<th>Komplikasjoner&#160;barselforløp</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;UkomplisertBarselforlop&quot;])*2)*number(not(child::*[local-name()=&quot;BarselforlopMerknader&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;UkomplisertBarselforlop&quot;])*2)*number(not(child::*[local-name()=&quot;BarselforlopMerknader&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;KomplikasjonerBarselforlop&quot;]">
							<div><xsl:call-template name="k-8530"/>&#160;</div>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;BarselforlopMerknader&quot;]">
					<th>Merknader&#160;til&#160;barselforløp</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;UkomplisertBarselforlop&quot;] | child::*[local-name()=&quot;KomplikasjonerBarselforlop&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;BarselforlopMerknader&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()=&quot;Utreise&quot;]">
			<xsl:call-template name="Utreise"/>
		</xsl:for-each>
	</xsl:template>
	
	<!-- Visning av innhold i Tidligere svangerskap -->
	<xsl:template name="TidligereSvangerskap">
		<xsl:if test="child::*[local-name()=&quot;LevendeFodteBarn&quot;] or child::*[local-name()=&quot;Dodfodte&quot;] or child::*[local-name()=&quot;DodEtterFodsel&quot;] or child::*[local-name()=&quot;TidligereSvangerskapMerknad&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;LevendeFodteBarn&quot;]">
					<th>Levendefødte</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Dodfodte&quot;] | child::*[local-name()=&quot;DodEtterFodsel&quot;] | child::*[local-name()=&quot;TidligereSvangerskapMerknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Dodfodte&quot;] | child::*[local-name()=&quot;DodEtterFodsel&quot;] | child::*[local-name()=&quot;TidligereSvangerskapMerknad&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;LevendeFodteBarn&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Dodfodte&quot;]">
					<th>Dodfødte</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;LevendeFodteBarn&quot;])*2)*number(not(child::*[local-name()=&quot;DodEtterFodsel&quot;] | child::*[local-name()=&quot;TidligereSvangerskapMerknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;LevendeFodteBarn&quot;])*2)*number(not(child::*[local-name()=&quot;DodEtterFodsel&quot;] | child::*[local-name()=&quot;TidligereSvangerskapMerknad&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Dodfodte&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;DodEtterFodsel&quot;]">
					<th>Død&#160;etter&#160;fødsel</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;LevendeFodteBarn&quot;] | child::*[local-name()=&quot;Dodfodte&quot;])*2)*number(not(child::*[local-name()=&quot;TidligereSvangerskapMerknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;LevendeFodteBarn&quot;] | child::*[local-name()=&quot;Dodfodte&quot;])*2)*number(not(child::*[local-name()=&quot;TidligereSvangerskapMerknad&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;DodEtterFodsel&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;TidligereSvangerskapMerknad&quot;]">
					<th>Merknader&#160;til tidligere&#160;svangerskap</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;LevendeFodteBarn&quot;] | child::*[local-name()=&quot;Dodfodte&quot;] | child::*[local-name()=&quot;DodEtterFodsel&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;TidligereSvangerskapMerknad&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<!-- Visning av innhold i Utreise -->
	<xsl:template name="Utreise">
		<xsl:if test="child::*[local-name()=&quot;Utreisedato&quot;] or child::*[local-name()=&quot;MorOgBarnSkrevetUtSammen&quot;] or child::*[local-name()=&quot;UtskrevetTil&quot;] or child::*[local-name()=&quot;OverflyttetTilAnnenEnhet&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;Utreisedato&quot;]">
					<th>Utreisedato</th>
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;MorOgBarnSkrevetUtSammen&quot;] | child::*[local-name()=&quot;UtskrevetTil&quot;] | child::*[local-name()=&quot;OverflyttetTilAnnenEnhet&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;MorOgBarnSkrevetUtSammen&quot;] | child::*[local-name()=&quot;UtskrevetTil&quot;] | child::*[local-name()=&quot;OverflyttetTilAnnenEnhet&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Utreisedato&quot;]">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="@V"/>
							</xsl:call-template>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;MorOgBarnSkrevetUtSammen&quot;]">
					<th>Mor&#160;og&#160;barn skrevet&#160;ut&#160;sammen?</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Utreisedato&quot;])*2)*number(not(child::*[local-name()=&quot;UtskrevetTil&quot;] | child::*[local-name()=&quot;OverflyttetTilAnnenEnhet&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Utreisedato&quot;])*2)*number(not(child::*[local-name()=&quot;UtskrevetTil&quot;] | child::*[local-name()=&quot;OverflyttetTilAnnenEnhet&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;MorOgBarnSkrevetUtSammen&quot;]">
							<xsl:call-template name="k-1101"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;UtskrevetTil&quot;]">
					<th>Utskrevet&#160;til</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Utreisedato&quot;] | child::*[local-name()=&quot;MorOgBarnSkrevetUtSammen&quot;])*2)*number(not(child::*[local-name()=&quot;OverflyttetTilAnnenEnhet&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Utreisedato&quot;] | child::*[local-name()=&quot;MorOgBarnSkrevetUtSammen&quot;])*2)*number(not(child::*[local-name()=&quot;OverflyttetTilAnnenEnhet&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;UtskrevetTil&quot;]">
							<xsl:call-template name="k-8408"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;OverflyttetTilAnnenEnhet&quot;]">
					<th>Overflyttet&#160;til&#160;annen&#160;enhet</th>
					<td colspan="{($std-col)-1-count(child::*[local-name()=&quot;Utreisedato&quot;] | child::*[local-name()=&quot;MorOgBarnSkrevetUtSammen&quot;] | child::*[local-name()=&quot;UtskrevetTil&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;OverflyttetTilAnnenEnhet&quot;]">
							<xsl:value-of select="."/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<!-- Visning av innhold i utskrivningsrapport. Benytter templates i plo2html -->
	<xsl:template name="Innhold">
		<div class="{$stil}">
			<!-- Overskrift for meldingen -->
			<h1 id="Utskrivningsrapport">Utskrivningsrapport</h1>
			<xsl:call-template name="FellesMeny"/>
			<xsl:call-template name="Dokument"/>
		</div>
	</xsl:template>
	
	<!-- Template som overskriver tilsvarende template i plo2html. Peker tilbake på Fødselsepikrise -->
	<xsl:template name="RefDoc">
		<div id="FellesMeny" class="FellesMeny">
			<ul>
				<li><a href="#Fodselsepikrise">Se fødselsepikrise</a></li>
			</ul>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
