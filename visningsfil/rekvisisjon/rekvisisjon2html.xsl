<?xml version="1.0" encoding="utf-8"?>
<!-- Endringslogg
	- 13.01.16: v4.0.1 - Fix av CSS vedr. lang tekst i siste kolonne.
	- 09.11.16: v4.0.0 - Opprettet felles visning for alle versjonene av rekvisisjon. (v1.4, v1.5, v1.6)
	- 25.10.16: v3.1.0 - La til visningsversjonnr
	- 09.05.14: La til import av kodeverk-fil
	- 27.04.11: La til visning av flere enn en underavdeling ved pasientopphold, la til visning av Comment/TextResultValue, samt erstattet mange <br/> med <div>.
	- 01.12.10: Import av felles CSS-fil
	- 10.07.09: Felles komplett visningsfil for rekvisisjon
	- 04.02.09: Oppdatert adresse for namespace for v1.5
	- 06.05.08: Andre versjon etter forslag sendt inn 28.04
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
	- Fravær av DN-attributt (ev. OT-attributt) kan gi {Ukjent kode} i visningen
-->
<!-- Om
	- Inngår i Hdirs visningsfiler versjon 2.0
	- Laget i XMLSpy v2014 rel.2 sp1 (http://www.altova.com) av Jan Sigurd Dragsjø (nhn.no)
-->
<xsl:stylesheet version="1.0" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:base="http://www.kith.no/xmlstds/base64container" 
	xmlns:xhtml="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="xhtml base">
	
	<xsl:import href="../felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../felleskomponenter/kodeverk.xsl"/>

	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" 
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

	<!-- Variabel-deklarasjon -->
	<!-- Variabel for hvilken stil visning har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'No-line-doc'"/>
	<!-- Variabler for antall kolonner og bredde -->
	<xsl:variable name="std-col" select="10"/>
	<xsl:variable name="std-td" select="200"/>
	<!-- Variabel for hvilken versjon av visningsfilen -->
	<xsl:variable name="versjon" select="'rekvisisjon versjonuavhengig - v4.0.1 '"/>

	<!-- Meldingsstart -->
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Rekvisisjon</title>
				<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
				<style type="text/css">
					<xsl:value-of select="document('../Felleskomponenter/KITH-visning.css')" disable-output-escaping="yes"/>
				</style>
				<style type="text/css">
					.eh-field {
						display: block;
						width: 12.5%;
						min-width: 60px;
						line-height: 16px; 
						white-space: normal;
						vertical-align: text-top;
					    padding-left: 2px;
					    padding-right: 2px;
					    word-wrap: break-word;
				        float: left;
				        padding-bottom: 502px;
				        margin-bottom: -500px;
					}
					.eh-label {
						font-weight: bold; 
					}
					.eh-strong {
						font-weight: bold; 
					}
					.eh-field:last-child  { /* :last-child not supported in IE7/8 */
						width: auto;
						overflow: hidden;
						float: none;
					}
					.eh-field.eh-last-child { /* IE7/8 */
						width: auto;
						overflow: hidden;
						float: none;
					}
					.eh-row {
						white-space: nowrap;
						overflow: hidden; /* clear the float */
						position: relative;
					}
					.One-line-doc .eh-row {
						line-height: 24px;
						border-top: 1px solid lightgrey;
					}
					.Document .eh-field.eh-label {
						background-color: #CAE8EA;
					}
					.Document .eh-label.h3 {
						background-color: gray;
						color: white;
					}
					.Document .eh-field {
				        background-color: white;
				        margin-top: 2px;
				        margin-left: 2px;
					}
					.Document .eh-field.DocRow {
						border-top: 2px solid #eeeeee;
						margin-top: 0;
					}
					.Document .eh-field:last-child { /* :last-child not supported in IE7/8 */
						margin-right: 5px;
						position: relative;
						left: 2px;
					}
					.Document .eh-field.eh-last-child { /* IE7/8 */
						margin-right: 5px;
						position: relative;
						left: 2px;
					}
					.Document .eh-row:last-child {
				        margin-bottom: 4px;
					}
					.Document .eh-section {
						border: 1px solid black;
						background-color: #eeeeee;
					}
					.Document .eh-row .eh-bottom {
						position: absolute;
						bottom: 0;
						height: 2px;
						background-color: white;
					}
					@media print {
						.eh-field {
							padding-bottom: 2px;
							margin-bottom: 0;
						}
					}
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
		<xsl:for-each select="child::*[local-name()='ServReq']">
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
						<xsl:for-each select="child::*[local-name()='Requester']">
							<xsl:call-template name="RequesterHode"/>
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
					<xsl:otherwise>
						<div class="No-line-headerContent">
							<div class="NoScreen">&#160;</div>
						</div>
					</xsl:otherwise>
				</xsl:choose>
				<div class="No-line-headerContent">
					<div class="No-line-caption">Mottaker&#160;</div>
					<div class="No-line-content">
						<xsl:for-each select="child::*[local-name()='ServProvider']">
							<xsl:call-template name="ServProviderHode"/>
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

	<xsl:template name="RequesterHode">
		<xsl:for-each select="child::*[local-name()='HCP']">
			<xsl:call-template name="HCPHode"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="ServProviderHode">
		<xsl:for-each select="child::*[local-name()='HCP']">
			<xsl:call-template name="HCPHode"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="PatientHode">
		<div>
			<xsl:value-of select="child::*[local-name()='Name']"/>&#160;
			<span class="eh-label">
				<xsl:for-each select="child::*[local-name()='TypeOffId']">
					<xsl:call-template name="k-8116"/>
				</xsl:for-each>:&#160;
			</span>
			<xsl:value-of select="child::*[local-name()='OffId']"/>&#160;
		</div>
		<xsl:if test="child::*[local-name()='DateOfDeath']">
			<div>
				<span class="eh-label">Dødsdato:&#160;</span>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfDeath']/@V"/>
				</xsl:call-template>
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='Address']">
			<xsl:call-template name="AddressHode"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="AnimalHode"> <!-- ikke i bruk ?? -->
		<div>
			<xsl:if test="child::*[local-name()='Name']">
				<span class="eh-label">Navn</span>:&#160;<xsl:value-of select="child::*[local-name()='Name']"/>&#160;</xsl:if>
			<xsl:if test="child::*[local-name()='Species']">
				<span class="eh-label">Art</span>:&#160;<xsl:value-of select="child::*[local-name()='Species']"/>&#160;</xsl:if>
			<xsl:if test="child::*[local-name()='NameOwner']">
				<span class="eh-label">Eier</span>:&#160;<xsl:value-of select="child::*[local-name()='NameOwner']"/>&#160;</xsl:if>
		</div>
	</xsl:template>

	<xsl:template name="MaterialHode" > <!-- ikke i bruk ?? -->
		<div>
			<xsl:if test="child::*[local-name()='InvMaterial']">
				<span class="eh-label">Beskrivelse</span>:&#160;<xsl:value-of select="child::*[local-name()='InvMaterial']"/>&#160;</xsl:if>
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
			<xsl:value-of select="child::*[local-name()='Name']"/>
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
			</xsl:for-each>&#160;<xsl:value-of select="child::*[local-name()='Name']"/>
		</div>
	</xsl:template>

	<xsl:template name="CopyDestHode">
		<xsl:for-each select="child::*[local-name()='HCP']">
			<xsl:call-template name="HCPHode"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="AddressHode" >
		<xsl:if test="child::*[local-name()='Type'] and (child::*[local-name()='StreetAdr'] or child::*[local-name()='PostalCode'] or child::*[local-name()='City'] or child::*[local-name()='CityDistr'])">
			<div class="NoPrint">&#160;
				<span class="eh-label">
					<xsl:for-each select="child::*[local-name()='Type']">
						<xsl:call-template name="k-3401"/>
					</xsl:for-each>:&#160;
				</span>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='StreetAdr']">
			<div>
				<xsl:value-of select="child::*[local-name()='StreetAdr']"/>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='PostalCode'] or child::*[local-name()='City']">
			<xsl:if test="child::*[local-name()='StreetAdr']">
				<div class="NoPrint">,</div>
			</xsl:if>
			<div>
				<xsl:value-of select="child::*[local-name()='PostalCode']"/>&#160;<xsl:value-of select="child::*[local-name()='City']"/>
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='CityDistr']">
			<div class="NoPrint">,</div>
			<div>
				<xsl:call-template name="k-3403"/>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='County']">
			<div class="NoPrint">,</div>
			<div>
				<xsl:call-template name="k-3402"/>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Country']">
			<div class="NoPrint">,</div>
			<div>
				<xsl:call-template name="k-9043"/>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='TeleAddress']">
			<div class="NoPrint">&#160;</div>
			<xsl:call-template name="TeleAddressHode"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="TeleAddressHode">
		<div>
			<span class="eh-label">
				<xsl:choose>
					<xsl:when test="starts-with(@V, 'tel:') or starts-with(@V, 'callto:')">Telefon</xsl:when>
					<xsl:when test="starts-with(@V, 'fax:')">Faks</xsl:when>
					<xsl:when test="starts-with(@V, 'mailto:')">e-post</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(@V, ':')"/>
					</xsl:otherwise>
				</xsl:choose>
			</span>
			&#160;<xsl:value-of select="substring-after(@V, ':')"/>&#160;
		</div>
	</xsl:template>

	<!-- Hoveddokument -->
	<xsl:template name="ResultBody"> <!-- /Message/ServReq -->
		<div class="{$stil}">
			<xsl:variable name="position" select="position()"/>
			<!-- Tabell for rekvisisjon -->
			<h1>Rekvisisjon
				<xsl:for-each select="child::*[local-name()='MsgDescr']">
					<xsl:call-template name="k-8202"/>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='ServType']">&#160;-
					<xsl:call-template name="k-7309"/>
				</xsl:for-each>
			</h1>
			<div>
				<xsl:call-template name="FellesMeny">
					<xsl:with-param name="position" select="position()"/>
				</xsl:call-template>
			</div>
			<xsl:variable name="id1">
				<xsl:value-of select="concat('ServReq',$position)"/>
			</xsl:variable>

			<h2 id="{$id1}">Meldingsinformasjon</h2>
			<div class="eh-section">
				<xsl:call-template name="ServReq"/>
			</div>

			<!-- Tabell for rekvirert undersøkelse -->
			<xsl:for-each select=".//child::*[local-name()='ReqInvestigation']">
				<xsl:variable name="id2">
					<xsl:value-of select="concat('ReqInvestigation',$position,position())"/>
				</xsl:variable>
				<h2 id="{$id2}">
					<xsl:choose>
						<xsl:when test="last()!=1">
							<xsl:value-of select="concat('Rekvirert undersøkelse',position())"/>
						</xsl:when>
						<xsl:otherwise>Rekvirert undersøkelse</xsl:otherwise>
					</xsl:choose>
					<xsl:for-each select="child::*[local-name()='ServType']">&#160;-
						<xsl:call-template name="k-7309"/>
					</xsl:for-each>
				</h2>
				<div class="eh-section">
					<xsl:call-template name="ReqInvestigation"/>
				</div>
			</xsl:for-each>

			<!-- Tabell for øvrig pasientinformasjon -->
			<xsl:for-each select="child::*[local-name()='Patient']">
				<xsl:if test="child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='Sex'] or child::*[local-name()='DateOfBirth'] or child::*[local-name()='DateOfDeath'] or child::*[local-name()='AdmLocation'] or child::*[local-name()='AdditionalId'] or child::*[local-name()='InfItem'] or child::*[local-name()='Patient']">
					<xsl:variable name="id5">
						<xsl:value-of select="concat('Patient',$position)"/>
					</xsl:variable>
					<h2 id="{$id5}">Pasient</h2>

					<div class="eh-section">
						<xsl:call-template name="Patient">
							<xsl:with-param name="col" select="$std-col"/>
						</xsl:call-template>
					</div>
				</xsl:if>
			</xsl:for-each>

			<!-- Tabell for øvrig informasjon om undersøkelsesobjekt: dyr -->
			<xsl:for-each select="child::*[local-name()='Animal']">
				<xsl:if test="child::*[local-name()='Sex'] or child::*[local-name()='Animal']">
					<xsl:variable name="id6">
						<xsl:value-of select="concat('Animal',$position)"/>
					</xsl:variable>
					<h2 id="{$id6}">Undersøkelsesdyr</h2>
					<div class="eh-section">
						<xsl:call-template name="Animal">
							<xsl:with-param name="col" select="$std-col"/>
						</xsl:call-template>
					</div>
				</xsl:if>
			</xsl:for-each>

			<!-- Tabell for alle tilknyttede helsetjenesteenheter -->
			<xsl:variable name="id7">
				<xsl:value-of select="concat('HCP',$position)"/>
			</xsl:variable>
			<h2 id="{$id7}">Helsetjenesteenheter</h2>
			<div class="eh-section">
				<xsl:for-each select="child::*[local-name()='ServProvider']">
					<xsl:call-template name="ServProvider" >
						<xsl:with-param name="col" select="$std-col"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='Requester']">
					<xsl:call-template name="Requester" >
						<xsl:with-param name="col" select="$std-col"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='PaymentResponsible']">
					<xsl:call-template name="PaymentResponsible" >
						<xsl:with-param name="col" select="$std-col"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='CopyDest']">
					<xsl:call-template name="CopyDest" >
						<xsl:with-param name="col" select="$std-col"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='ResponsibleHcp']">
					<xsl:call-template name="ResponsibleHcp" >
						<xsl:with-param name="col" select="$std-col"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='Patient']">
					<xsl:call-template name="Patient" >
						<xsl:with-param name="col" select="$std-col"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='AdmLocation']">
					<xsl:call-template name="AdmLocation" >
						<xsl:with-param name="col" select="$std-col"/>
					</xsl:call-template>
				</xsl:for-each>
			</div>

			<!-- Tabell for vedlegg -->
			<xsl:if test="child::*[local-name()='RefDoc']">
				<xsl:variable name="id8">
					<xsl:value-of select="concat('RefDoc',$position)"/>
				</xsl:variable>
				<h2 id="{$id8}">Vedlegg</h2>
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

	<!-- Meldingshodet - dokumentopplysninger -->
	<xsl:template name="Footer">
		<div class="{$stil}">
			<h2 style="margin-top:0px;">Dokumentinformasjon</h2>
			<table>
				<tbody>
					<tr>
						<th>Melding&#160;sendt</th>
						<td width="{$std-td}px">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../child::*[local-name()='GenDate']/@V"/>
							</xsl:call-template>
						</td>
						<th>Meldingsid</th>
						<td>
							<xsl:value-of select="../child::*[local-name()='MsgId']"/>
						</td>
					</tr>
					<tr>
						<th>Visningsversjon</th>
						<td colspan="3">
							<xsl:value-of select="$versjon"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<!-- Klikkbar horisontal meny som leder lenger ned i dokumentet -->
	<xsl:template name="FellesMeny">
		<xsl:param name="position"/>
		<div id="FellesMeny" class="FellesMeny">
			<div class="NoPrint">
				<ul>
					<li>
						<xsl:variable name="temp1" select="concat('ServReq',$position)"/>
						<a href="#{$temp1}">Meldingsinformasjon</a>
					</li>
					<xsl:for-each select=".//child::*[local-name()='ReqInvestigation']">
						<li>
							<xsl:variable name="temp2" select="concat('ReqInvestigation',$position,position())"/>
							<xsl:choose>
								<xsl:when test="last()!=1">
									<a href="#{$temp2}">
										<xsl:value-of select="concat('Rekvirert undersøkelse',position())"/>
									</a>
								</xsl:when>
								<xsl:otherwise>
									<a href="#{$temp2}">Rekvirert undersøkelse</a>
								</xsl:otherwise>
							</xsl:choose>
						</li>
					</xsl:for-each>
					<xsl:if test=".//child::*[local-name()='Patient']/child::*[local-name()='BasisForHealthServices'] or .//child::*[local-name()='Patient']/child::*[local-name()='Sex'] or .//child::*[local-name()='Patient']/child::*[local-name()='DateOfBirth'] or .//child::*[local-name()='Patient']/child::*[local-name()='DateOfDeath'] or .//child::*[local-name()='Patient']/child::*[local-name()='AdmLocation'] or .//child::*[local-name()='Patient']/child::*[local-name()='AdditionalId'] or .//child::*[local-name()='Patient']/child::*[local-name()='InfItem'] or .//child::*[local-name()='Patient']/child::*[local-name()='Patient']">
						<li>
							<xsl:variable name="temp3" select="concat('Patient',$position)"/>
							<a href="#{$temp3}">Pasient</a>
						</li>
					</xsl:if>
					<xsl:if test=".//child::*[local-name()='Animal']/child::*[local-name()='Sex'] or .//child::*[local-name()='Animal']/child::*[local-name()='Animal']">
						<li>
							<xsl:variable name="temp4" select="concat('Animal',$position)"/>
							<a href="#{$temp4}">Undersøkelsesdyr</a>
						</li>
					</xsl:if>
					<xsl:if test=".//child::*[local-name()='ServProvider'] | .//child::*[local-name()='Requester'] | .//child::*[local-name()='PaymentResponsible'] | .//child::*[local-name()='CopyDest'] | .//child::*[local-name()='ResponsibleHcp'] | .//child::*[local-name()='Patient']/child::*[local-name()='AdmLocation']">
						<li>
							<xsl:variable name="temp5" select="concat('HCP',$position)"/>
							<a href="#{$temp5}">Helsetjenesteenheter</a>
						</li>
					</xsl:if>
					<xsl:if test=".//child::*[local-name()='RefDoc']">
						<li>
							<xsl:variable name="temp6" select="concat('RefDoc',$position)"/>
							<a href="#{$temp6}">Vedlegg</a>
						</li>
					</xsl:if>
				</ul>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="ServReq"> <!-- /Message/ServReq -->
		<xsl:if test="child::*[local-name()='IssueDate'] or child::*[local-name()='RequestedDateReport'] or child::*[local-name()='RequestedPrioReport'] or child::*[local-name()='PaymentCat'] or child::*[local-name()='Reservation']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='IssueDate']">
					<span class="eh-field eh-label">Utstedt-dato</span>
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='IssueDate']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='RequestedDateReport']">
					<span class="eh-field eh-label">Ønsket svartid</span>
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='RequestedDateReport']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='RequestedPrioReport']">
					<span class="eh-field eh-label">Ønsket prioritet</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='RequestedPrioReport']">
							<xsl:choose>
								<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/rekvisisjon/2012-02-15'">
									<xsl:call-template name="k-8115"/> <!-- v1.6 -->
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="k-7303"/> <!-- v1.5 and below -->
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='PaymentCat']">
					<span class="eh-field eh-label">Betalings&#173;kategori</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='PaymentCat']">
							<xsl:call-template name="k-4101"/>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Reservation']">
					<span class="eh-field eh-label">Pasientens reservasjoner</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Reservation']">
							<div>
								<xsl:call-template name="k-3108"/>
							</div>
						</xsl:for-each>
					</span>
				</xsl:if>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='NoReport'] or child::*[local-name()='LevelOfDetail'] or child::*[local-name()='EscortRequired'] or child::*[local-name()='Permission']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='NoReport']">
					<span class="eh-field eh-label">Ønsker svar</span>
					<span class="eh-field">
						<xsl:choose>
							<xsl:when test="child::*[local-name()='NoReport']/@V=&quot;false&quot;">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='LevelOfDetail']">
					<span class="eh-field eh-label">Ønsket detaljnivå</span>
					<span class="eh-field">
						<xsl:apply-templates select="child::*[local-name()='LevelOfDetail']"/>  <!-- string -->
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='EscortRequired']">
					<span class="eh-field eh-label">Ledsagelsesbehov</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='EscortRequired']">
							<xsl:call-template name="k-8247"/>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Permission']">
					<span class="eh-field eh-label">Tillatelser</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Permission']">
							<xsl:call-template name="k-dummy"/>
							<xsl:if test="position()!=last()">.&#160;&#160;</xsl:if>
						</xsl:for-each>
					</span>
				</xsl:if>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='ReqComment']">
			<div class="eh-row">
				<span class="eh-field eh-label">Rekvirentens kommentar</span>
				<span class="eh-field eh-last-child">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='ReqComment']"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='ReasonAsText']">
			<div class="eh-row">
				<span class="eh-field eh-label h3 eh-last-child">Begrunnelser</span>
			</div>
			<xsl:for-each select="child::*[local-name()='ReasonAsText']">
				<xsl:call-template name="ReasonAsText"/>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Comment']">
			<div class="eh-row">
				<span class="eh-field eh-label h3 eh-last-child">Kommentarer</span>
			</div>
			<xsl:for-each select="child::*[local-name()='Comment']">
				<xsl:call-template name="Comment"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template name="ReqInvestigation">
		<xsl:if test="child::*[local-name()='Purpose'] or child::*[local-name()='ReqDate'] or child::*[local-name()='Priority']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='Purpose']">
					<span class="eh-field eh-label">Formål</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Purpose']">
							<xsl:call-template name="k-8248"/>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='ReqDate']">
					<span class="eh-field eh-label">Ønsket tidspunkt</span>
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='ReqDate']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Priority']">
					<span class="eh-field eh-label">Hastegrad</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Priority']">
							<xsl:call-template name="k-8304"/>
						</xsl:for-each>
					</span>
				</xsl:if>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Comment']">
			<div class="eh-row">
				<span class="eh-field eh-label">Kommentar</span>
				<span class="eh-field  eh-last-child">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Investigation']">
			<div class="eh-row">
				<span class="eh-field eh-label h3 eh-last-child">Undersøkelse</span>
			</div>
			<xsl:for-each select="child::*[local-name()='Investigation']">
				<xsl:if test="child::*[local-name()='Id'] or child::*[local-name()='Spec'] or child::*[local-name()='Comment'] or child::*[local-name()='Priority']">
					<div class="eh-row">
						<xsl:if test="child::*[local-name()='Id']">
							<span class="eh-field eh-label">Type</span>
							<span class="eh-field">
								<xsl:for-each select="child::*[local-name()='Id']">
									<xsl:choose>
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
							</span>
						</xsl:if>
						<xsl:if test="child::*[local-name()='Spec']">
							<span class="eh-field eh-label">Spesifisert</span>
							<span class="eh-field">
								<xsl:for-each select="child::*[local-name()='Spec']">
									<xsl:call-template name="k-dummy"/>
									<xsl:if test="position()!=last()">,&#160;</xsl:if>
								</xsl:for-each>
							</span>
						</xsl:if>
						<xsl:if test="child::*[local-name()='Comment']">
							<span class="eh-field eh-label">Kommentar</span>
							<span class="eh-field">
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
								</xsl:call-template>
							</span>
						</xsl:if>
						<xsl:if test="child::*[local-name()='Priority']">
							<span class="eh-field eh-label">Hastegrad</span>
							<span class="eh-field">
								<xsl:for-each select="child::*[local-name()='Priority']">
									<xsl:call-template name="k-8304"/>
								</xsl:for-each>
							</span>
						</xsl:if>
					</div>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="child::*[local-name()='StandingInv']">
			<div class="eh-row">
				<th class="h3 eh-last-child">Gjentagende undersøkelse</th>
			</div>
			<xsl:for-each select="child::*[local-name()='StandingInv']">
				<xsl:if test="child::*[local-name()='NumberOfTimes'] or child::*[local-name()='ScheduledStart'] or child::*[local-name()='ScheduledEnd'] or child::*[local-name()='CycleTime'] or child::*[local-name()='EndCondition']">
					<div class="eh-row">
						<xsl:if test="child::*[local-name()='NumberOfTimes']">
							<span class="eh-field eh-label">Antall repetisjoner</span>
							<span class="eh-field">
								<xsl:value-of select="child::*[local-name()='NumberOfTimes']"/>
							</span>
						</xsl:if>
						<xsl:if test="child::*[local-name()='ScheduledStart']">
							<span class="eh-field eh-label">Planlagt start</span>
							<span class="eh-field">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()='ScheduledStart']/@V"/>
								</xsl:call-template>
							</span>
						</xsl:if>
						<xsl:if test="child::*[local-name()='ScheduledEnd']">
							<span class="eh-field eh-label">Planlagt slutt</span>
							<span class="eh-field">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()='ScheduledEnd']/@V"/>
								</xsl:call-template>
							</span>
						</xsl:if>
						<xsl:if test="child::*[local-name()='CycleTime']">
							<span class="eh-field eh-label">Intervall</span>
							<span class="eh-field">
								<xsl:value-of select="child::*[local-name()='CycleTime']"/>
							</span>
						</xsl:if>
						<xsl:if test="child::*[local-name()='EndCondition']">
							<span class="eh-field eh-label">Sluttbetingelser</span>
							<span class="eh-field">
								<xsl:value-of select="child::*[local-name()='EndCondition']"/>
							</span>
						</xsl:if>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Instructions']">
					<div class="eh-row">
						<span class="eh-field eh-label">Instruksjon</span>
						<span class="eh-field eh-label eh-last-child">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()='Instructions']"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="child::*[local-name()='AnalysedSubject']">
			<div class="eh-row">
				<span class="eh-field eh-label h3 eh-last-child">Prøve</span>
			</div>
			<xsl:for-each select="child::*[local-name()='AnalysedSubject']">
				<xsl:call-template name="AnalysedSubject">
					<xsl:with-param name="col" select="$std-col"/>
					<xsl:with-param name="pos" select="position()"/>
					<xsl:with-param name="last" select="last()"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template name="Comment">
		<xsl:if test="child::*[local-name()='Heading'] or child::*[local-name()='TextResultValue'] or child::*[local-name()='TextCode']">
			<div class="eh-row">
				<span class="eh-field eh-label">
					<xsl:choose>
						<xsl:when test="child::*[local-name()='Heading']">
							<xsl:for-each select="child::*[local-name()='Heading']">
								<xsl:call-template name="k-8234"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="contains(child::*[local-name()='TextCode']/@S,'8274')">Anbefaling om supplerende undersøkelse</xsl:when>
						<xsl:otherwise>Generell</xsl:otherwise>
					</xsl:choose>
				</span>
				<span class="eh-field eh-last-child">
					<xsl:if test="child::*[local-name()='TextResultValue']">
						<div>
							<xsl:value-of select="child::*[local-name()='TextResultValue']"/>
						</div>
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
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="ReasonAsText">
		<xsl:if test="child::*[local-name()='Heading'] or child::*[local-name()='TextResultValue']">
			<div class="eh-row">
				<span class="eh-field eh-label">
					<xsl:for-each select="child::*[local-name()='Heading']">
						<xsl:call-template name="k-8231"/>
					</xsl:for-each>
				</span>
				<span class="eh-field eh-last-child">
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
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="Patient">
		<xsl:param name="col"/>
		<div class="eh-row">
			<span class="eh-field eh-label">Navn&#160;<xsl:if test="child::*[local-name()='Relation'] and local-name(..)=&quot;Patient&quot;">-&#160;relasjon:&#160;<xsl:for-each select="child::*[local-name()='Relation']">
						<xsl:call-template name="k-8238"/>
					</xsl:for-each>
				</xsl:if>
			</span>
			<span class="eh-field">
				<xsl:value-of select="child::*[local-name()='Name']"/>
			</span>
			<span class="eh-field eh-label">
				<xsl:for-each select="child::*[local-name()='TypeOffId']">
					<xsl:call-template name="k-8116"/>
				</xsl:for-each>
			</span>
			<span class="eh-field">
				<xsl:value-of select="child::*[local-name()='OffId']"/>
			</span>
			<xsl:if test="child::*[local-name()='Sex']">
				<span class="eh-field eh-label">Kjønn</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='Sex']">
						<xsl:call-template name="k-3101"/>
					</xsl:for-each>
				</span>
			</xsl:if>
			<xsl:if test="child::*[local-name()='DateOfBirth']">
				<span class="eh-field eh-label">Fødselsdato</span>
				<span class="eh-field">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfBirth']/@V"/>
					</xsl:call-template>
				</span>
			</xsl:if>
			<xsl:if test="child::*[local-name()='DateOfDeath']">
				<span class="eh-field eh-label">Dødsdato</span>
				<span class="eh-field">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfDeath']/@V"/>
					</xsl:call-template>
				</span>
			</xsl:if>
		</div>
		<xsl:for-each select="child::*[local-name()='Address']">
			<xsl:variable name="antall-tel" select="count(child::*[local-name()='TeleAddress'])"/>
			<div class="eh-row">
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
			</div>
		</xsl:for-each>
		<xsl:if test="child::*[local-name()='AdditionalId'] or child::*[local-name()='BasisForHealthServices']">
			<xsl:variable name="antall-id" select="count(child::*[local-name()='AdditionalId'])"/>
			<div class="eh-row">
				<xsl:choose>
					<xsl:when test="child::*[local-name()='AdditionalId'] and child::*[local-name()='BasisForHealthServices']">
						<span class="eh-field eh-label" style="width: 25%;">Andre pasient-identifikatorer</span>
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
						<span class="eh-field eh-label">Refusjonsgrunnlag</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='BasisForHealthServices']">
								<xsl:call-template name="k-8246"/>
							</xsl:for-each>
						</span>
					</xsl:when>
					<xsl:when test="child::*[local-name()='AdditionalId'] and not(child::*[local-name()='BasisForHealthServices'])">
						<span class="eh-field eh-label" style="width: 25%; ">Andre pasient-identifikatorer</span>
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
						<span class="eh-field eh-label">Refusjonsgrunnlag</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='BasisForHealthServices']">
								<xsl:call-template name="k-8246"/>
							</xsl:for-each>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='AdmLocation']">
			<div class="eh-row">
				<span class="eh-field eh-label h3 eh-last-child">
					Opphold
				</span>
			</div>
			<div class="eh-row">
				<span class="eh-field eh-label">Institusjon</span>
				<span class="eh-field">
					<!-- Gir her boksen en default kolonnebredde på 3 mot normalt 1 -->
					<xsl:value-of select="child::*[local-name()='Location']/child::*[local-name()='Inst']/child::*[local-name()='Name']"/>
					<xsl:if test="child::*[local-name()='Location']/child::*[local-name()='Inst']/child::*[local-name()='Dept']/child::*[local-name()='Name']">
						<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='Inst']/child::*[local-name()='Dept']">, <xsl:value-of select="child::*[local-name()='Name']"/>
						</xsl:for-each>
					</xsl:if>
					<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='SubLocation']">, <xsl:for-each select="child::*[local-name()='Type']">
							<xsl:call-template name="k-8242"/>
						</xsl:for-each>: <xsl:value-of select="child::*[local-name()='Place']"/>
					</xsl:for-each>
				</span>
				<xsl:if test="child::*[local-name()='AdmCat']">
					<span class="eh-field eh-label">Type tjeneste</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='AdmCat']">
							<xsl:call-template name="k-8240"/>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='StartDateTime']">
					<span class="eh-field eh-label">Innlagt dato</span>
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='EndDateTime']">
					<span class="eh-field eh-label">Utskrevet dato</span>
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Patient']"> <!-- Feil ?? Er allerede på Patient -->
			<xsl:call-template name="Patient">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='InfItem']">
			<xsl:call-template name="InfItem">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="Animal">
		<xsl:param name="col"/>
		<div class="eh-row">
			<xsl:if test="child::*[local-name()='NameOwner']">
				<span class="eh-field eh-label">Eier&#160;</span>
				<span class="eh-field">
					<xsl:value-of select="child::*[local-name()='NameOwner']"/>
				</span>
			</xsl:if>
			<xsl:if test="child::*[local-name()='Name']">
				<span class="eh-field eh-label">Navn&#160;
					<xsl:if test="local-name(..)=&quot;Animal&quot;">
						-&#160;relasjon:&#160;<xsl:for-each select="child::*[local-name()='Relation']">
							<xsl:call-template name="k-8238"/>
						</xsl:for-each>
					</xsl:if>
				</span>
				<span class="eh-field">
					<xsl:value-of select="child::*[local-name()='Name']"/>
				</span>
			</xsl:if>
			<xsl:if test="child::*[local-name()='Sex']">
				<span class="eh-field eh-label">Kjønn</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='Sex']">
						<xsl:call-template name="k-3101"/>
					</xsl:for-each>
				</span>
			</xsl:if>
			<xsl:if test="child::*[local-name()='Species']">
				<span class="eh-field eh-label">Art</span>
				<span class="eh-field">
					<xsl:value-of select="child::*[local-name()='Species']"/>
				</span>
			</xsl:if>
		</div>
		<xsl:for-each select="child::*[local-name()='Animal']"> <!-- Feil ?? Er allerede på Animal -->
			<xsl:call-template name="Animal">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="AnalysedSubject">
		<xsl:param name="col"/>
		<xsl:param name="pos"/>
		<xsl:param name="last"/>
		<xsl:if test="child::*[local-name()='Type'] or child::*[local-name()='TypeCoded'] or child::*[local-name()='IdByRequester'] or child::*[local-name()='RequestedSubject'] or child::*[local-name()='CollectedSample'] or child::*[local-name()='CollectedStudyProduct']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='Type'] or child::*[local-name()='TypeCoded']">
					<span class="eh-field eh-label">
						Type materiale
						<xsl:if test="$last!=1">
							&#160;<xsl:value-of select="$pos"/>
						</xsl:if>
					</span>
					<span class="eh-field">
						<!--Kommentar til en tilsynelatende for lang kolonnebredde: RequestedSubject, CollectedSample og CollectedStudyProduct er innenfor en choice -->
						<xsl:choose>
							<xsl:when test="child::*[local-name()='Type']">
								<xsl:value-of select="child::*[local-name()='Type']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="child::*[local-name()='TypeCoded']">
									<xsl:choose>
										<xsl:when test="contains(@S, '8216')">
											<xsl:call-template name="k-8216"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="k-dummy"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='IdByRequester']">
					<span class="eh-field eh-label">Rekvirents id</span>
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='IdByRequester']"/>
					</span>
				</xsl:if>
				<xsl:for-each select="child::*[local-name()='RequestedSubject']">
					<xsl:if test="child::*[local-name()='Priority']">
						<span class="eh-field eh-label">Prøvetakingsprioritet</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='Priority']">
								<xsl:call-template name="k-8304"/>
							</xsl:for-each>
						</span>
					</xsl:if>
					<xsl:if test="child::*[local-name()='ReqDate']">
						<span class="eh-field eh-label">Ønsket tidspunkt</span>
						<span class="eh-field">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='ReqDate']/@V"/>
							</xsl:call-template>
						</span>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='CollectedSample']">
					<xsl:if test="child::*[local-name()='CollectedDate']">
						<span class="eh-field eh-label">Prøve tatt - dato</span>
						<span class="eh-field">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='CollectedDate']/@V"/>
							</xsl:call-template>
						</span>
					</xsl:if>
					<xsl:if test="child::*[local-name()='Logistics']">
						<span class="eh-field eh-label">Forsendelsesmåte</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='Logistics']"/>
						</span>
					</xsl:if>
					<xsl:if test="child::*[local-name()='CollectorComment'] or child::*[local-name()='CollectorCommentCoded']">
						<span class="eh-field eh-label">Prøvetakers kommentar</span>
						<span class="eh-field">
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
						</span>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='CollectedStudyProduct']">
					<xsl:if test="child::*[local-name()='Type']">
						<span class="eh-field eh-label">Type analyseprodukt</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='Type']"/>
						</span>
					</xsl:if>
					<xsl:if test="child::*[local-name()='ProducedDate']">
						<span class="eh-field eh-label">Avledet prøve tatt - dato</span>
						<span class="eh-field">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='ProducedDate']/@V"/>
							</xsl:call-template>
						</span>
					</xsl:if>
					<xsl:if test="child::*[local-name()='RefRelatedProd']">
						<span class="eh-field eh-label">Referanse til relatert produkt</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='RefRelatedProd']"/>
						</span>
					</xsl:if>
				</xsl:for-each>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Number'] or child::*[local-name()='IdByServProv'] or child::*[local-name()='SampleCollInd'] or child::*[local-name()='SampleCollProc']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='Number']">
					<span class="eh-field eh-label">Antall</span>
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='Number']"/>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='IdByServProv']">
					<span class="eh-field eh-label">Tjeneste&#173;yters id</span>
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='IdByServProv']"/>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='SampleCollInd']">
					<span class="eh-field eh-label">Prøve tatt</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='SampleCollInd']">
							<xsl:call-template name="k-1101"/>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='SampleCollProc']">
					<span class="eh-field eh-label">Prøvetakingsprosedyre</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='SampleCollInd']">
							<xsl:call-template name="k-dummy"/>
						</xsl:for-each>
					</span>
				</xsl:if>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='AnatomicalOrigin'] or child::*[local-name()='PreservMaterial'] or child::*[local-name()='Pretreatment'] or child::*[local-name()='SubjectMeasures']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='AnatomicalOrigin']">
					<span class="eh-field eh-label">Anatomisk lokasjon</span>
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='AnatomicalOrigin']"/>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='PreservMaterial']">
					<span class="eh-field eh-label">Konserverings-middel</span>
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='PreservMaterial']"/>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Pretreatment']">
					<span class="eh-field eh-label">Forberedende behandling</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Pretreatment']/child::*[local-name()='Heading']">
							<xsl:call-template name="k-8232"/>
						</xsl:for-each>
						<xsl:if test="child::*[local-name()='Pretreatment']/child::*[local-name()='TextResultValue']">
							<div>
								<span class="eh-strong">Beskrivelse: </span>
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="child::*[local-name()='Pretreatment']/child::*[local-name()='TextResultValue']"/>
								</xsl:call-template>
							</div>
						</xsl:if>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='SubjectMeasures']">
					<span class="eh-field eh-label">Størrelse</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='SubjectMeasures']">
							<div>
								<span class="eh-label">
									<xsl:value-of select="child::*[local-name()='TypeQuantity']"/>:&#160;
								</span>
								<xsl:value-of select="child::*[local-name()='Quantity']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='Quantity']/@U"/>&#160;
							</div>
						</xsl:for-each>
					</span>
				</xsl:if>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='SampleHandling']">
			<div class="eh-row">
				<span class="eh-field eh-label">Håndteringsbeskrivelse</span>
				<span class="eh-field eh-last-child">
					<xsl:for-each select="child::*[local-name()='SampleHandling']">
						<div>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="."/>
							</xsl:call-template>
						</div>
					</xsl:for-each>
				</span>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Comment']">
			<div class="eh-row">
				<span class="eh-field eh-label">Kommentar</span>
				<span class="eh-field eh-last-child">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='AnalysedSubject']"> <!-- Feil ?? Er allerede på AnalysedSubject -->
			<xsl:call-template name="AnalysedSubject">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="InfItem">
		<xsl:param name="col"/>
		<xsl:variable name="type" select="child::*[local-name()='Type']/@V"/>
		<xsl:if test="not(preceding-sibling::*[local-name()='InfItem'][child::*[local-name()='Type']/@V=$type])">
			<div class="eh-row">
				<span class="eh-field eh-label h3  eh-last-child">
					<xsl:for-each select="child::*[local-name()='Type']">
						<xsl:call-template name="k-8233"/>
					</xsl:for-each>
				</span>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Observation']/child::*[local-name()='Description'] or child::*[local-name()='Observation']/child::*[local-name()='CodedDescr'] or child::*[local-name()='StartDateTime'] or child::*[local-name()='EndDateTime'] or child::*[local-name()='OrgDate']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='Observation']/child::*[local-name()='Description'] or child::*[local-name()='Observation']/child::*[local-name()='CodedDescr']">
					<span class="eh-field eh-label">Beskrivelse</span>
					<span class="eh-field">
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
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='StartDateTime']">
					<span class="eh-field eh-label">Start-dato</span>
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='EndDateTime']">
					<span class="eh-field eh-label">Slutt-dato</span>
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='OrgDate']">
					<span class="eh-field eh-label">Opprinnelses-dato</span>
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='OrgDate']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Observation']/child::*[local-name()='Comment']">
			<div class="eh-row">
				<span class="eh-field eh-label">Kommentar</span>
				<span class="eh-field  eh-last-child">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='Observation']/child::*[local-name()='Comment']"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="ServProvider">
		<xsl:param name="col"/>
		<div class="eh-row">
			<span class="eh-field eh-label h3 eh-last-child">Tjenesteyter
				<xsl:if test="child::*[local-name()='HCP']/child::*[local-name()='MedSpeciality']"> - Spesialitet:&#160;<xsl:for-each select="child::*[local-name()='HCP']/child::*[local-name()='MedSpeciality']">
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
			</span>
		</div>
		<xsl:for-each select="child::*[local-name()='HCP']">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="Requester">
		<xsl:param name="col"/>
		<div class="eh-row">
			<span class="eh-field eh-label h3 eh-last-child">Henvisende instans
				<xsl:if test="child::*[local-name()='HCP']/child::*[local-name()='MedSpeciality']"> - Spesialitet:&#160;<xsl:for-each select="child::*[local-name()='HCP']/child::*[local-name()='MedSpeciality']">
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
			</span>
		</div>
		<xsl:for-each select="child::*[local-name()='HCP']">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="PaymentResponsible">
		<xsl:param name="col"/>
		<div class="eh-row">
			<span class="eh-field eh-label h3 eh-last-child">Betalingsansvarlig
				<xsl:if test="child::*[local-name()='TypeGuarantor']"> - <xsl:value-of select="child::*[local-name()='TypeGuarantor']"/>
				</xsl:if>
			</span>
		</div>
		<xsl:for-each select="child::*[local-name()='HCP']">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="CopyDest">
		<xsl:param name="col"/>
		<div class="eh-row">
			<span class="eh-field eh-label h3 eh-last-child">Kopimottaker
				<xsl:if test="child::*[local-name()='CopyDestRole']/child::*[local-name()='MsgType']"> - kopi&#160;av:&#160;<xsl:for-each select="child::*[local-name()='CopyDestRole']/child::*[local-name()='MsgType']">
						<xsl:call-template name="k-8236"/>
					</xsl:for-each>
				</xsl:if>
			</span>
		</div>
		<xsl:for-each select="child::*[local-name()='HCP']">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="ResponsibleHcp">
		<xsl:param name="col"/>
		<div class="eh-row">
			<span class="eh-field eh-label h3 eh-last-child">
				<xsl:choose>
					<xsl:when test="child::*[local-name()='Relation']">
						<xsl:for-each select="child::*[local-name()='Relation']">
							<xsl:choose>
								<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/rekvisisjon/2012-02-15'">
									<xsl:call-template name="k-8254"/> <!-- v1.6 -->
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="k-7319"/> <!-- v1.5 and below -->
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Ansvarlig&#160;helsetjenesteenhet</xsl:otherwise>
				</xsl:choose>
			</span>
		</div>
		<xsl:for-each select="child::*[local-name()='HCP']">
			<xsl:call-template name="HCP">
				<xsl:with-param name="col" select="$col"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="AdmLocation">
		<xsl:param name="col"/>
		<div class="eh-row">
			<span class="eh-field eh-label h3 eh-last-child">Oppholdssted for pasient
				<xsl:if test="child::*[local-name()='AdmCat']"> - Type&#160;tjeneste:&#160;<xsl:for-each select="child::*[local-name()='AdmCat']">
						<xsl:call-template name="k-8240"/>
					</xsl:for-each>
				</xsl:if>
			</span>
		</div>
		<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='Inst']">
			<div class="eh-row">
				<xsl:call-template name="Inst">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='Inst']/child::*[local-name()='Dept']">
			<div class="eh-row">
				<xsl:call-template name="Dept">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='Inst']/child::*[local-name()='HCPerson']">
			<div class="eh-row">
				<xsl:call-template name="HCPerson">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Location']/child::*[local-name()='Address']">
			<xsl:variable name="antall-tel" select="count(child::*[local-name()='TeleAddress'])"/>
			<div class="eh-row">
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
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="HCP">
		<xsl:param name="col"/>
		<xsl:for-each select="child::*[local-name()='Inst']">
			<div class="eh-row">
				<xsl:call-template name="Inst">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Inst']/child::*[local-name()='Dept']">
			<div class="eh-row">
				<xsl:call-template name="Dept">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Inst']/child::*[local-name()='HCPerson']">
			<div class="eh-row">
				<xsl:call-template name="HCPerson">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='HCProf']">
			<div class="eh-row">
				<xsl:call-template name="HCProf">
					<xsl:with-param name="col" select="$col"/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Address']">
			<xsl:variable name="antall-tel" select="count(child::*[local-name()='TeleAddress'])"/>
			<div class="eh-row">
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
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="HCProf">
		<xsl:param name="col"/>
		<span class="eh-field eh-label">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='Type']">
					<xsl:for-each select="child::*[local-name()='Type']">
						<xsl:call-template name="k-9060"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>Helse&#173;personell</xsl:otherwise>
			</xsl:choose>
		</span>
		<span class="eh-field">
			<xsl:value-of select="child::*[local-name()='Name']"/>
		</span>
		<span class="eh-field eh-label">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='TypeId']">
					<xsl:for-each select="child::*[local-name()='TypeId']">
						<xsl:choose>
							<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/rekvisisjon/2012-02-15'">
								<xsl:call-template name="k-8116"/> <!-- v1.6 -->
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="k-8268"/> <!-- v1.5 and below -->
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>Id</xsl:otherwise>
			</xsl:choose>
		</span>
		<xsl:choose>
			<xsl:when test="child::*[local-name()='AdditionalId']">
				<span class="eh-field">
					<xsl:value-of select="child::*[local-name()='Id']"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="eh-field">
					<xsl:value-of select="child::*[local-name()='Id']"/>
				</span>
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
	</xsl:template>

	<xsl:template name="Inst">
		<xsl:param name="col"/>
		<span class="eh-field eh-label">Navn</span>
		<span class="eh-field">
			<xsl:value-of select="child::*[local-name()='Name']"/>
		</span>
		<span class="eh-field eh-label">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='TypeId']">
					<xsl:for-each select="child::*[local-name()='TypeId']">
						<xsl:choose>
							<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/rekvisisjon/2012-02-15'">
								<xsl:call-template name="k-9051"/> <!-- v1.6 -->
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="k-8268"/> <!-- v1.5 and below -->
							</xsl:otherwise>
						</xsl:choose>						
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>Id</xsl:otherwise>
			</xsl:choose>
		</span>
		<xsl:choose>
			<xsl:when test="child::*[local-name()='AdditionalId']">
				<span class="eh-field">
					<xsl:value-of select="child::*[local-name()='Id']"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="eh-field">
					<xsl:value-of select="child::*[local-name()='Id']"/>
				</span>
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
	</xsl:template>

	<xsl:template name="Dept">
		<xsl:param name="col"/>
		<span class="eh-field eh-label">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='Type']">
					<xsl:for-each select="child::*[local-name()='Type']">
						<xsl:call-template name="k-8624"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>Avdeling</xsl:otherwise>
			</xsl:choose>
		</span>
		<span class="eh-field">
			<xsl:value-of select="child::*[local-name()='Name']"/>
		</span>
		<span class="eh-field eh-label">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='TypeId']">
					<xsl:for-each select="child::*[local-name()='TypeId']">
						<xsl:choose>
							<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/rekvisisjon/2012-02-15'">
								<xsl:call-template name="k-9051"/> <!-- v1.6 -->
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="k-8268"/> <!-- v1.5 and below -->
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>Id</xsl:otherwise>
			</xsl:choose>
		</span>
		<xsl:choose>
			<xsl:when test="child::*[local-name()='AdditionalId']">
				<span class="eh-field">
					<xsl:value-of select="child::*[local-name()='Id']"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="eh-field">
					<xsl:value-of select="child::*[local-name()='Id']"/>
				</span>
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
	</xsl:template>

	<xsl:template name="HCPerson">
		<xsl:param name="col"/>
		<span class="eh-field eh-label">Helse&#173;personell</span>
		<span class="eh-field">
			<xsl:value-of select="child::*[local-name()='Name']"/>
		</span>
		<span class="eh-field eh-label">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='TypeId']">
					<xsl:for-each select="child::*[local-name()='TypeId']">
					<xsl:choose>
						<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/rekvisisjon/2012-02-15'">
							<xsl:call-template name="k-8116"/> <!-- v1.6 -->
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="k-8268"/> <!-- v1.5 and below -->
						</xsl:otherwise>
					</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>Id</xsl:otherwise>
			</xsl:choose>
		</span>
		<xsl:choose>
			<xsl:when test="child::*[local-name()='AdditionalId']">
				<span class="eh-field">
					<xsl:value-of select="child::*[local-name()='Id']"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="eh-field">
					<xsl:value-of select="child::*[local-name()='Id']"/>
				</span>
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
	</xsl:template>

	<xsl:template name="AdditionalId">
		<xsl:param name="col"/>
		<span class="eh-field eh-label">
			<xsl:for-each select="child::*[local-name()='Type']">

				<xsl:choose>
					<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/rekvisisjon/2012-02-15'">
						<xsl:choose> <!-- v1.6 -->
							<xsl:when test="local-name(../..)=&quot;Patient&quot; or local-name(../..)=&quot;HCProf&quot; or local-name(../..)=&quot;HCPerson&quot;">
								<xsl:call-template name="k-8116"/>
							</xsl:when>
							<xsl:when test="local-name(..)=&quot;Inst&quot; or local-name(..)=&quot;Dept&quot;">
								<xsl:call-template name="k-9051"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="k-dummy"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="k-8268"/> <!-- v1.5 and below -->
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</span>
		<span class="eh-field">
			<xsl:value-of select="child::*[local-name()='Id']"/>
		</span>
	</xsl:template>

	<xsl:template name="Address">
		<xsl:param name="col"/>
		<span class="eh-field eh-label">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='Type']">
					<xsl:for-each select="child::*[local-name()='Type']">
						<xsl:call-template name="k-3401"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>Adresse</xsl:otherwise>
			</xsl:choose>
		</span>
		<span class="eh-field">
			<xsl:if test="child::*[local-name()='StreetAdr']">
				<xsl:value-of select="child::*[local-name()='StreetAdr']"/>,&#160;</xsl:if>
			<xsl:if test="child::*[local-name()='PostalCode']">
				<xsl:value-of select="child::*[local-name()='PostalCode']"/>
			</xsl:if>
			<xsl:if test="child::*[local-name()='City']">&#160;<xsl:value-of select="child::*[local-name()='City']"/>
			</xsl:if>
			<xsl:if test="child::*[local-name()='CityDistr']">,&#160;<xsl:for-each select="child::*[local-name()='CityDistr']">
					<xsl:call-template name="k-3403"/>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="child::*[local-name()='County']">,&#160;<xsl:for-each select="child::*[local-name()='County']">
					<xsl:call-template name="k-3402"/>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="child::*[local-name()='Country']">,&#160;<xsl:for-each select="child::*[local-name()='Country']">
					<xsl:call-template name="k-9043"/>
				</xsl:for-each>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template name="TeleAddress">
		<xsl:param name="col"/>
		<span class="eh-field eh-label">
			<xsl:choose>
				<xsl:when test="starts-with(@V, &quot;tel:&quot;) or starts-with(@V, &quot;callto:&quot;)">Telefon</xsl:when>
				<xsl:when test="starts-with(@V, &quot;fax:&quot;)">Faks</xsl:when>
				<xsl:when test="starts-with(@V, &quot;mailto:&quot;)">e-post</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before(@V, &quot;:&quot;)"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
		<span class="eh-field">
			<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>
		</span>
	</xsl:template>

	<xsl:template name="RefDoc">
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()='MsgType'] or child::*[local-name()='Id'] or child::*[local-name()='IssueDate'] or child::*[local-name()='MimeType'] or child::*[local-name()='Compression']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='MsgType']">
					<span class="eh-field eh-label">Type</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='MsgType']">
							<xsl:choose>
								<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/rekvisisjon/2012-02-15'">
									<xsl:call-template name="k-8114"/> <!-- v1.6 -->
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="k-8278"/> <!-- v1.5 and below -->
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Id']">
					<span class="eh-field eh-label">Id</span>
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='Id']"/>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='IssueDate']">
					<span class="eh-field eh-label">Utstedt-dato</span>
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='IssueDate']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='MimeType']">
					<span class="eh-field eh-label">Mimetype</span>
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='MimeType']"/>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Compression']">
					<span class="eh-field eh-label">Komprimering</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Compression']">
							<xsl:call-template name="k-1204"/>
						</xsl:for-each>
					</span>
				</xsl:if>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Description']">
			<div class="eh-row">
				<span class="eh-field eh-label">Beskrivelse</span>
				<span class="eh-field eh-last-child">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='Description']"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Content'] or child::*[local-name()='FileReference']">
			<xsl:choose>
				<xsl:when test="contains(child::*[local-name()='MimeType'],'image')">
					<div class="eh-row">
						<span class="eh-field eh-label">Bilde</span>
						<xsl:choose>
							<xsl:when test="child::*[local-name()='FileReference']">
								<span class="eh-field eh-last-child">
									<img>
										<xsl:attribute name="src"><xsl:value-of select="child::*[local-name()='FileReference']"/></xsl:attribute>
										<xsl:attribute name="alt">Bilde fra ekstern URL</xsl:attribute>
									</img>
								</span>
							</xsl:when>
							<xsl:when test="child::*[local-name()='Content']">
								<span class="eh-field eh-last-child">
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
								</span>
							</xsl:when>
						</xsl:choose>
					</div>
				</xsl:when>
				<xsl:when test="contains(child::*[local-name()='MimeType'],'pdf')">
					<div class="eh-row">
						<span class="eh-field eh-label">pdf</span>
						<xsl:choose>
							<xsl:when test="child::*[local-name()='FileReference']">
								<span class="eh-field eh-last-child">
									<object>
										<xsl:attribute name="data"><xsl:value-of select="concat(child::*[local-name()='FileReference'],'&#35;view&#61;FitH&#38;toolbar&#61;1')"/></xsl:attribute>
										<xsl:attribute name="type">application/pdf</xsl:attribute>
										<xsl:attribute name="width">100%</xsl:attribute>
										<xsl:attribute name="height">500px</xsl:attribute>
									</object>
								</span>
							</xsl:when>
							<xsl:when test="child::*[local-name()='Content']">
								<span class="eh-field eh-last-child">
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
								</span>
							</xsl:when>
						</xsl:choose>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="child::*[local-name()='Content']">
							<xsl:value-of select="child::*[local-name()='Content']"/>
						</xsl:when>
						<xsl:when test="child::*[local-name()='FileReference']">
							<xsl:value-of select="child::*[local-name()='FileReference']"/>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
