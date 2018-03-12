<?xml version="1.0" encoding="UTF-8"?>

<!-- Endringslogg
- 07.02.17: v4.1.2 - Endret kodeverk fra 7319 til 8254 for v1.1 vedr. relasjonstype for helseperson.
- 13.01.16: v4.1.1 - Fix av CSS vedr. lang tekst i siste kolonne.
- 15.11.16: v4.1.0 - Inkluderer v2.0. Noe css-tilpasning for IE7/8.
- 26.10.16: v4.0.0 - Opprettet felles visning for alle versjonene av henvisning. (v1.0, v1.1)
-->

<xsl:stylesheet version="1.0" 
	xmlns:xhtml="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" 
	xmlns:base="http://www.kith.no/xmlstds/base64container"
	xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" 
	exclude-result-prefixes="xhtml fk1 base mh" >

	<xsl:import href="../felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../felleskomponenter/kodeverk.xsl"/>
	<xsl:import href="../felleskomponenter/meldingshode2html.xsl"/>

	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" 
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

	<!-- Variabel for hvilken stil visning har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'No-line-doc'"/>
	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="8"/>
	<xsl:variable name="std-td" select="100"/>
	<!-- Variabel for hvilken versjon av visningsfilen -->
	<xsl:variable name="versjon" select="'henvisning versjonuavhengig - v4.1.2 '"/>

	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Henvisning</title>
				<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
				<style type="text/css">
					<xsl:value-of select="document('../felleskomponenter/KITH-visning.css')" disable-output-escaping="yes"/>
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
					.Document .eh-field {
				        background-color: white;
				        margin-top: 2px;
				        margin-left: 2px;
					}
					.Document .eh-field.DocRow {
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
				<xsl:for-each select="child::*[local-name()='Message']">  <!-- v1.0, v1.1 -->
					<xsl:call-template name="Message"/>
				</xsl:for-each>
				<xsl:apply-templates select="mh:MsgHead"/> <!-- v2.0 -->
			</body>
		</html>
	</xsl:template>

	<!-- Visning av meldingshodet. Tilpasset vinduskonvolutt ved utskrift -->
	<xsl:template match="mh:MsgHead">  <!-- v2.0 -->
		<xsl:call-template name="Topp"/>
		<xsl:call-template name="Innhold"/>
		<xsl:call-template name="EgetBunnTillegg"/>
	</xsl:template>

	<xsl:template name="Message">  <!-- v1.0, v1.1 -->
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
							<div class="No-line-caption">Kopimottaker(e)&#160;</div>
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
				&#160;
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='Address']">
			<xsl:call-template name="AddressHode"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="HCPersonHode">
		<div>
			<xsl:value-of select="child::*[local-name()='Name']"/>&#160;
		</div>
		<xsl:call-template name="AddressHode"/>
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
			<div class="NoPrint">
				<span class="eh-label">Institusjon:&#160;</span>
			</div>
			<xsl:value-of select="child::*[local-name()='Name']"/>
		</div>
		<xsl:for-each select="child::*[local-name()='Dept']">
			<div>
				<div class="NoPrint">-&#160;</div>
				<xsl:value-of select="child::*[local-name()='Name']"/>&#160;
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="HCProfHode">
		<div>
			<xsl:for-each select="child::*[local-name()='Type']">
				<xsl:call-template name="k-9060"/>&#160;
			</xsl:for-each>
			<xsl:value-of select="child::*[local-name()='Name']"/>
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
						<xsl:call-template name="k-3401"/>&#160;
					</xsl:for-each>
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

	<xsl:template name="Innhold">
		<xsl:for-each select="//child::*[local-name()='Henvisning']">
			<xsl:call-template name="ResultBody"/>
		</xsl:for-each>
	</xsl:template>

	<!-- Hoveddokumentet -->
	<xsl:template name="ResultBody"> <!-- /Message/ServReq (v1.0, v1.1) eller  /MsgHead/Document/Content/Henvisning (v2.0)  -->
		<xsl:variable name="position" select="position()"/>
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='ServType'][@V='M' or @V='C' or @V='O']">red</xsl:when>
				<xsl:otherwise>black</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="color2">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='ReqServ']/child::*[local-name()='ServType'][@V='M' or @V='C' or @V='O']">red</xsl:when>
				<xsl:otherwise>black</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="{$stil}">
			<xsl:call-template name="FellesMeny">
				<xsl:with-param name="position" select="position()"/>
			</xsl:call-template>

			<!-- Overskrift og tabell for henvisningen -->
			<h1>
				<xsl:choose>
					<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/henvisning/2014-04-30'">
						<xsl:for-each select="child::*[local-name()='TypeInnholdIMelding']/child::*[local-name()='TypeInnhold']">
							<xsl:choose>
								<xsl:when test="contains(@S,'9146')"><xsl:call-template name="k-9146"/></xsl:when>
								<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>					
					</xsl:when>
					<xsl:otherwise>
						Henvisning&#160;-&#160;<xsl:for-each select="child::*[local-name()='MsgDescr']">
							<xsl:call-template name="k-8455"/>
							</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:for-each select="child::*[local-name()='ServType'][@V!='N']">&#160;-
					<span style="color: {$color};">
						<xsl:call-template name="k-7309"/>
					</span>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='ReqServ']/child::*[local-name()='ServType'][@V!='N']">
					&#160;Status&#160;rekvirert&#160;tjeneste:&#160;-
					<span style="color: {$color2};">
						<xsl:call-template name="k-7309"/>
					</span>
				</xsl:for-each>
			</h1>
	
			<div class="eh-section">
				<xsl:call-template name="ServReq_Henvisning"/> <!-- v1.0, v1.1, v2.0 -->
	
				<xsl:if test="//child::*[local-name()='ServReq']/child::*[local-name()='ReqComment']">
					<div  class="eh-row">
						<span class="eh-field eh-last-child">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="//child::*[local-name()='ServReq']/child::*[local-name()='ReqComment']"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
			</div>

			<!-- Overskrift og tabell for Diagnoser -->
			<xsl:if test="child::*[local-name()='Diagnosis'] or child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='DIAG'] or //child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='H' or child::*[local-name()='Type']/@V='B']">
				<xsl:variable name="id10">
					<xsl:value-of select="concat('Diagnosis',$position)"/>
				</xsl:variable>
				<h2 id="{$id10}">Diagnoser</h2>

				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='Diagnosis']">
						<xsl:call-template name="Diagnosis"/>
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='DIAG']">
						<xsl:call-template name="ReasonAsText"/>
					</xsl:for-each>

					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='H' or child::*[local-name()='Type']/@V='B']">
						<xsl:for-each select="child::*[local-name()='ResultItem']">
							<xsl:call-template name="ResultItem" />
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="Medication" />
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="Observation" />
						</xsl:for-each>
						<!-- Men ResultItem og Medication er kankje ikke aktuell herfra siden rad-element mangler ?? -->
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for CAVE og NB-opplysninger -->
			<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='CAVE' or child::*[local-name()='Type']/@V='NB']">

				<xsl:variable name="id20">
					<xsl:value-of select="concat('CAVE',$position)"/>
				</xsl:variable>

				<h2 id="{$id20}">
					<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='CAVE']">CAVE</xsl:if>
					<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='CAVE'] and //child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='NB'] ">&#160;og&#160;</xsl:if>
					<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='NB']">NB-opplysninger</xsl:if>
				</h2>

				<div class="eh-section">
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='CAVE' or child::*[local-name()='Type']/@V='NB']">
						<xsl:for-each select="child::*[local-name()='ResultItem']">
							<xsl:call-template name="ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<!-- Men ResultItem og Medication er kankje ikke aktuell herfra siden rad-element mangler ?? -->
					</xsl:for-each> 
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Problemstilling -->
			<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='PROB'] or //child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='SYMP' or child::*[local-name()='Type']/@V='PROG' or child::*[local-name()='Type']/@V='SM']">
				<xsl:variable name="id30">
					<xsl:value-of select="concat('PROB',$position)"/>
				</xsl:variable>
				<h2 id="{$id30}">Problemstilling</h2>

				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='PROB']">
						<xsl:call-template name="ReasonAsText"/>
					</xsl:for-each>
	
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='SYMP' or child::*[local-name()='Type']/@V='PROG' or child::*[local-name()='Type']/@V='SM']">
	
						<xsl:for-each select="child::*[local-name()='ResultItem']">
							<xsl:call-template name="ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<!-- Men ResultItem og Medication er kankje ikke aktuell herfra siden rad-element mangler ?? -->
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Forventet utredning/behandling -->
			<xsl:if test="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='UTRED']">
				<xsl:variable name="id40">
					<xsl:value-of select="concat('UTRED',$position)"/>
				</xsl:variable>
				<h2 id="{$id40}">Forventet utredning/behandling</h2>

				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='UTRED']">
						<xsl:call-template name="ReasonAsText"/>
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Kliniske opplysninger -->
			<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='OPPL']">
				<xsl:variable name="id50">
					<xsl:value-of select="concat('OPPL',$position)"/>
				</xsl:variable>
				<h2 id="{$id50}">Kliniske opplysninger</h2>

				<div class="eh-section">
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='OPPL']">
						<xsl:for-each select="child::*[local-name()='ResultItem']">
							<xsl:call-template name="ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<!-- Men ResultItem og Medication er kankje ikke aktuell herfra siden rad-element mangler ?? -->
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Gynekologiske opplysninger -->
			<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='GOPL' or child::*[local-name()='Type']/@V='GBEH']">
				<xsl:variable name="id60">
					<xsl:value-of select="concat('GOPL',$position)"/>
				</xsl:variable>
				<h2 id="{$id60}">Gynekologiske opplysninger</h2>

				<div class="eh-section">
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='GOPL' or child::*[local-name()='Type']/@V='GBEH']">
	
						<xsl:for-each select="child::*[local-name()='ResultItem']">
							<xsl:call-template name="ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<!-- Men ResultItem og Medication er kankje ikke aktuell herfra siden rad-element mangler ?? -->
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Spesialistvurdering -->
			<xsl:if test="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='SVU']">
				<xsl:variable name="id70">
					<xsl:value-of select="concat('SVU',$position)"/>
				</xsl:variable>
				<h2 id="{$id70}">Spesialistvurdering</h2>
				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='SVU']">
						<xsl:call-template name="ReasonAsText"/>
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Vurdering -->
			<xsl:if test="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='VU']">
				<xsl:variable name="id80">
					<xsl:value-of select="concat('VU',$position)"/>
				</xsl:variable>
				<h2 id="{$id80}">Vurdering</h2>
				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='VU']">
						<xsl:call-template name="ReasonAsText"/>
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Annen begrunnelse for henvisningen -->
			<xsl:if test="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='BG' or child::*[local-name()='Heading']/@V='BUP-BM' or child::*[local-name()='Heading']/@V='BUP-HG' or child::*[local-name()='Heading']/@V='KF' or child::*[local-name()='Heading']/@V='MAAL' or child::*[local-name()='Heading']/@V='MU' or child::*[local-name()='Heading']/@V='RU' or child::*[local-name()='Heading']/@V='UP' or not(child::*[local-name()='Heading'])]">
				<xsl:variable name="id90">
					<xsl:value-of select="concat('Annen',$position)"/>
				</xsl:variable>
				<h2 id="{$id90}">Annen begrunnelse for henvisningen</h2>
				
				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='BG' or child::*[local-name()='Heading']/@V='BUP-BM' or child::*[local-name()='Heading']/@V='BUP-HG' or child::*[local-name()='Heading']/@V='KF' or child::*[local-name()='Heading']/@V='MAAL' or child::*[local-name()='Heading']/@V='MU' or child::*[local-name()='Heading']/@V='RU' or child::*[local-name()='Heading']/@V='UP' or not(child::*[local-name()='Heading'])]">
						<xsl:call-template name="ReasonAsText"/>
					</xsl:for-each>
				</div>

			</xsl:if>

			<!-- Overskrift og tabell for Sykehistorie -->
			<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='ANAM' or child::*[local-name()='Type']/@V='TB' or child::*[local-name()='Type']/@V='US']">
				<xsl:variable name="id100">
					<xsl:value-of select="concat('ANAM',$position)"/>
				</xsl:variable>
				<h2 id="{$id100}">Sykehistorie</h2>
				<div class="eh-section">
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='ANAM' or child::*[local-name()='Type']/@V='TB' or child::*[local-name()='Type']/@V='US']">
						<xsl:for-each select="child::*[local-name()='ResultItem']">
							<xsl:call-template name="ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<!-- Men ResultItem og Medication er kankje ikke aktuell herfra siden rad-element mangler ?? -->
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Funn/undersøkelsesresultat -->
			<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='FUNN'] or child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='FU']">
				<xsl:variable name="id110">
					<xsl:value-of select="concat('ResultItem',$position)"/>
				</xsl:variable>
				<h2 id="{$id110}">Funn/undersøkelsesresultat</h2>
				<div class="eh-section">
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='FUNN']/child::*[local-name()='Observation']">
						<xsl:call-template name="Observation"/>
					</xsl:for-each>
					<xsl:for-each select="//child::*[local-name()='ResultItem']">
						<xsl:if test="position()=1">
							<div class="eh-row">
								<span class="eh-field eh-label">Undersøkelse</span>
								<span class="eh-field eh-label">Funn/resultat</span>
								<xsl:if test="//child::*[local-name()='ResultItem']/child::*[local-name()='InvDate']">
									<span class="eh-field eh-label">Tidspunkt for under&#173;søkelsen</span>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='StartDateTime']">
									<span class="eh-field eh-label">Starttidspunkt</span>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='EndDateTime']">
									<span class="eh-field eh-label">Sluttidspunkt</span>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='OrgDate']">
									<span class="eh-field eh-label">Tidspunkt&#160;for&#160;opprinnelse</span>
								</xsl:if>
							</div>
						</xsl:if>
						<div class="eh-row">
							<xsl:call-template name="ResultItem"/>
						</div>
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='FU']">
						<xsl:call-template name="ReasonAsText"/>
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Prosedyrer -->
			<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='OPIN' or child::*[local-name()='Type']/@V='MPRS' or child::*[local-name()='Type']/@V='PRS']">
				<xsl:variable name="id120">
					<xsl:value-of select="concat('OPIN',$position)"/>
				</xsl:variable>
				<h2 id="{$id120}">Prosedyrer</h2>

				<div class="eh-section">
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='OPIN' or child::*[local-name()='Type']/@V='MPRS' or child::*[local-name()='Type']/@V='PRS']">
						<xsl:for-each select="child::*[local-name()='ResultItem']">
							<xsl:call-template name="ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<!-- Men ResultItem og Medication er kankje ikke aktuell herfra siden rad-element mangler ?? -->
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Forløp og behandling -->
			<xsl:if test="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='FO']">
				<xsl:variable name="id130">
					<xsl:value-of select="concat('FO',$position)"/>
				</xsl:variable>
				<h2 id="{$id130}">Forløp og behandling</h2>
				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='FO']">
						<xsl:call-template name="ReasonAsText"/>
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Funksjonsnivå/hjelpetiltak -->
			<xsl:if test="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='HJ']">
				<xsl:variable name="id140">
					<xsl:value-of select="concat('HJ',$position)"/>
				</xsl:variable>
				<h2 id="{$id140}">Funksjonsnivå/hjelpetiltak</h2>
				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='HJ']">
						<xsl:call-template name="ReasonAsText"/>
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Medisinering -->
			<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='MEDB']">
				<xsl:variable name="id150">
					<xsl:value-of select="concat('Medication',$position)"/>
				</xsl:variable>

				<h2 id="{$id150}">Medisinering</h2>

				<div class="eh-section">
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='MEDB']/child::*[local-name()='Observation']">
						<xsl:call-template name="Observation"/>
					</xsl:for-each>
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='MEDB']/child::*[local-name()='ResultItem']">
						<xsl:call-template name="ResultItem"/> <!-- Bug?? Mangler rad-element for ResultItem -->
					</xsl:for-each>
	
					<xsl:for-each select="//child::*[local-name()='Medication']">
						<xsl:variable name="countChildren">
							<xsl:value-of select="count(*)"/>
						</xsl:variable>
						<xsl:if test="position()=1">
							<div class="eh-row">
								<span class="eh-field eh-label">Lege&#173;middel</span>
								<span class="eh-field eh-label">Status</span>
								<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='UnitDose'] or //child::*[local-name()='Medication']/child::*[local-name()='QuantitySupplied']">
									<span class="eh-field eh-label">Mengde</span>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='DosageText'] or //child::*[local-name()='Medication']/child::*[local-name()='IntendedDuration']">
									<span class="eh-field eh-label">
										<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='DosageText']">Dosering</xsl:if>
										<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='DosageText'] and //child::*[local-name()='Medication']/child::*[local-name()='IntendedDuration']">/</xsl:if>
										<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='IntendedDuration']">Varighet</xsl:if>
									</span>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='Comment']">
									<span class="eh-field eh-label">Kommentar</span>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='StartDateTime']">
									<span class="eh-field eh-label">Start&#173;tidspunkt</span>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='EndDateTime']">
									<span class="eh-field eh-label">Slut&#173;tidspunkt</span>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='OrgDate']">
									<span class="eh-field eh-label">Tidspunkt for opprinnelse</span>
								</xsl:if>
							</div>
						</xsl:if>
						<div class="eh-row">
							<xsl:call-template name="Medication"/>
						</div>
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Familie/sosialt -->
			<xsl:if test="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='FA']">
				<xsl:variable name="id160">
					<xsl:value-of select="concat('FA',$position)"/>
				</xsl:variable>
				<h2 id="{$id160}">Familie/sosialt</h2>
				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='FA']">
						<xsl:call-template name="ReasonAsText"/>
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Informasjon til pasient/pårørende -->
			<xsl:if test="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='IP']">
				<xsl:variable name="id170">
					<xsl:value-of select="concat('IP',$position)"/>
				</xsl:variable>
				<h2 id="{$id170}">Informasjon til pasient/pårørende</h2>
				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='IP']">
						<xsl:call-template name="ReasonAsText"/>
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Sykemelding -->
			<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='SYKM']">
				<xsl:variable name="id180">
					<xsl:value-of select="concat('SYKM',$position)"/>
				</xsl:variable>
				<h2 id="{$id180}">Sykemelding</h2>

				<div class="eh-section">
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='SYKM']">
						<xsl:for-each select="child::*[local-name()='ResultItem']">
							<xsl:call-template name="ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="Observation"/>
						</xsl:for-each>
						<!-- Men ResultItem og Medication er kankje ikke aktuell herfra siden rad-element mangler ?? -->
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Kommentarer -->
			<xsl:if test="child::*[local-name()='Comment']">
				<xsl:variable name="id190">
					<xsl:value-of select="concat('Comment',$position)"/>
				</xsl:variable>
				<h2 id="{$id190}">Kommentarer</h2>

				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='Comment']">
						<div class="eh-row">
							<span class="eh-field eh-label">
								<xsl:choose>
									<xsl:when test="child::*[local-name()='Heading']">
										<xsl:for-each select="child::*[local-name()='Heading']">
											<xsl:call-template name="k-8234"/>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>Kommentar</xsl:otherwise>
								</xsl:choose>
							</span>
							<span class="eh-field eh-last-child">
								<xsl:if test="child::*[local-name()='TextResultValue']">
									<div>
										<xsl:value-of select="child::*[local-name()='TextResultValue']"/>
									</div>
								</xsl:if>
								<xsl:for-each select="child::*[local-name()='CodedComment']">
									<div>
										<xsl:choose>
											<xsl:when test="contains(@S,'8403')">
												<xsl:call-template name="k-8403"/>
											</xsl:when>
											<xsl:when test="contains(@S,'8419')">
												<xsl:call-template name="k-8419"/>
											</xsl:when>
											<xsl:when test="contains(@S,'9513')">
												<xsl:call-template name="k-9513"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="k-dummy"/>
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</xsl:for-each>
							</span>
						</div>
					</xsl:for-each>
				</div>
			</xsl:if>


			<xsl:choose>
				<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/henvisning/2014-04-30'">
					<!--  v2.0 -->

					<!-- Overskrift og tabell for pasientopplysninger  -->
					<xsl:if test="child::*[local-name()='PatientPrecaution'] or child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='TilleggsopplysningPasient'] or ancestor::*[local-name()='Document']/child::*[local-name()='Consent'] or child::*[local-name()='ParorendeForesatt'] or child::*[local-name()='InfoAssistertKommunikasjon'] or child::*[local-name()='PasientrelatertKontaktperson']">
						<xsl:variable name="id200"><xsl:value-of select="concat('Comment',$position)"/></xsl:variable>
						<h2 id="{$id200}">Pasientopplysninger</h2>
						<div class="eh-section">
							<xsl:call-template name="PatientInformation"/>
						</div>
					</xsl:if>

					<!-- Overskrift og tabell for helsetjenesteenheter -->
					<xsl:if test="child::*[local-name()='TilknyttetEnhet'] or child::*[local-name()='KontaktpersonHelsepersonell'] or child::*[local-name()='AnsvarForRapport']">
						<xsl:variable name="id210"><xsl:value-of select="concat('Comment',$position)"/></xsl:variable>
						<h2 id="{$id210}">Helsetjenesteenheter</h2>
						<div class="eh-section">
							<xsl:call-template name="HealthCareProfessional_v2"/>
						</div>
					</xsl:if>

				</xsl:when>

				<xsl:otherwise>
					<!--  v1.0, v1.1 -->

					<!-- Overskrift og tabell for Pasient -->
					<xsl:for-each select="child::*[local-name()='Patient']">
						<xsl:if test="child::*[local-name()='PatientPrecaution'] or child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='Sex'] or child::*[local-name()='DateOfBirth'] or child::*[local-name()='PatientPrecaution'] or child::*[local-name()='AssistertKommunikasjon'] or child::*[local-name()='ParorendeForesatt'] or child::*[local-name()='ContactPerson'] or child::*[local-name()='PatRelInst'] or child::*[local-name()='Consent'] or child::*[local-name()='AdditionalId'] or child::*[local-name()='NeedTranslator'] or child::*[local-name()='CareSituation']">
							<xsl:variable name="id200">
								<xsl:value-of select="concat('Patient',$position)"/>
							</xsl:variable>
							<h2 id="{$id200}">Pasient</h2>
							<div class="eh-section">
								<xsl:call-template name="Patient"/>
							</div>
						</xsl:if>
					</xsl:for-each>

					<!-- Overskrift og tabell for Helsetjenesteenheter -->
					<xsl:if test="child::*[local-name()='Patient']/child::*[local-name()='PatRelHCP']">
						<xsl:variable name="id210">
							<xsl:value-of select="concat('PatRelHCP',$position)"/>
						</xsl:variable>
						<h2 id="{$id210}">Helsetjenesteenheter</h2>
						<div class="eh-section">
							<xsl:call-template name="HealthCareProfessional_v1"/>
						</div>
					</xsl:if>

				</xsl:otherwise>
			</xsl:choose>

			<!-- Overskrift og tabell for henvisning mellom helseforetak -->
			<xsl:if test="child::*[local-name()='VurderingAvHenvisning']">
				<xsl:variable name="id215"><xsl:value-of select="concat('Comment',$position)"/></xsl:variable>
				<h2 id="{$id215}">Henvisning mellom helseforetak</h2>
				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='VurderingAvHenvisning']">
						<xsl:call-template name="VurderingAvHenvisning"/>
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for vedlegg -->
			<xsl:if test="child::*[local-name()='RefDoc'] or count(//mh:RefDoc) &gt; 1">
				<xsl:variable name="id220">
					<xsl:value-of select="concat('RefDoc',$position)"/>
				</xsl:variable>
				<h2 id="{$id220}">Vedlegg</h2>
				<div class="eh-section">

					<xsl:for-each select="child::*[local-name()='RefDoc']"> <!-- v1.0, v1.1 -->
						<xsl:call-template name="RefDoc"/> 
					</xsl:for-each>

					<xsl:for-each select="//mh:RefDoc"> <!-- v2.0 -->
						<xsl:if test="position() != 1"> 
							<table>
								<tbody>
									<xsl:apply-templates select="."> 
										<xsl:with-param name="std-col" select="$std-col"/>
										<xsl:with-param name="std-td" select="$std-td"/>
									</xsl:apply-templates>
								</tbody>
							</table>
						</xsl:if>
					</xsl:for-each>

				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- Meldingshodet - Dokumentopplysninger -->
	<xsl:template name="Footer"> <!-- v1.0, v1.1 -->
		<div class="{$stil}">
			<h2>Dokumentinformasjon</h2>
			<table>
				<tbody>
					<tr>
						<th>Melding&#160;opprettet</th>
						<td width="{$std-td}">
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

	<!-- Template som kalles fra BunnTillegg i meldingshodet. Kan brukes til visning av egenkomponert bunn -->
	<xsl:template name="EgetBunnTillegg"> <!-- v2.0 -->
		<div class="{$stil}">	
		<h2>Dokumentinformasjon</h2>
			<table>
				<tbody>
					<tr>
						<th>Melding&#160;opprettet</th>
						<td width="{$std-td}">
							<xsl:call-template name="skrivUtDateTime">
								<xsl:with-param name="oppgittTid" select="//mh:GenDate"/>
							</xsl:call-template>
						</td>
						<th>Meldingsid</th>
						<td><xsl:value-of select="//mh:MsgId"/></td>
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
		<div class="NoPrint">
			<div id="FellesMeny" class="FellesMeny">
				<ul>
					<xsl:if test="//child::*[local-name()='Diagnosis'] or //child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='DIAG'] or //child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='H' or child::*[local-name()='Type']/@V='B']">
						<li>
							<xsl:variable name="temp10" select="concat('Diagnosis',$position)"/>
							<a href="#{$temp10}">Diagnoser</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='CAVE' or child::*[local-name()='Type']/@V='NB']">
						<li>
							<xsl:variable name="temp20" select="concat('CAVE',$position)"/>
							<a href="#{$temp20}">
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='CAVE']">CAVE</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='CAVE' and child::*[local-name()='Type']/@V='NB']">&#160;og&#160;</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='NB']">NB-opplysninger</xsl:if>
							</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='PROB'] or //child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='SYMP' or child::*[local-name()='Type']/@V='PROG' or child::*[local-name()='Type']/@V='SM']">
						<li>
							<xsl:variable name="temp30" select="concat('PROB',$position)"/>
							<a href="#{$temp30}">Problemstilling</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='UTRED']">
						<li>
							<xsl:variable name="temp40" select="concat('UTRED',$position)"/>
							<a href="#{$temp40}">Forventet utredning/behandling</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='OPPL']">
						<li>
							<xsl:variable name="temp50" select="concat('OPPL',$position)"/>
							<a href="#{$temp50}">Kliniske opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='GOPL' or child::*[local-name()='Type']/@V='GBEH']">
						<li>
							<xsl:variable name="temp60" select="concat('GOPL',$position)"/>
							<a href="#{$temp60}">Gynekologiske opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='SVU']">
						<li>
							<xsl:variable name="temp70" select="concat('SVU',$position)"/>
							<a href="#{$temp70}">Spesialistvurdering</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='VU']">
						<li>
							<xsl:variable name="temp80" select="concat('VU',$position)"/>
							<a href="#{$temp80}">Vurdering</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='BG' or child::*[local-name()='Heading']/@V='BUP-BM' or child::*[local-name()='Heading']/@V='BUP-HG' or child::*[local-name()='Heading']/@V='KF' or child::*[local-name()='Heading']/@V='MAAL' or child::*[local-name()='Heading']/@V='MU' or child::*[local-name()='Heading']/@V='RU' or child::*[local-name()='Heading']/@V='UP' or not(child::*[local-name()='Heading'])]">
						<li>
							<xsl:variable name="temp90" select="concat('Annen',$position)"/>
							<a href="#{$temp90}">Annen begrunnelse</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='ANAM' or child::*[local-name()='Type']/@V='TB' or child::*[local-name()='Type']/@V='US']">
						<li>
							<xsl:variable name="temp100" select="concat('ANAM',$position)"/>
							<a href="#{$temp100}">Sykehistorie</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='FUNN'] or //child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='FU']">
						<li>
							<xsl:variable name="temp110" select="concat('ResultItem',$position)"/>
							<a href="#{$temp110}">Funn/undersøkelsesresultat</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='OPIN' or child::*[local-name()='Type']/@V='MPRS' or child::*[local-name()='Type']/@V='PRS']">
						<li>
							<xsl:variable name="temp120" select="concat('OPIN',$position)"/>
							<a href="#{$temp120}">Prosedyrer</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='FO']">
						<li>
							<xsl:variable name="temp130" select="concat('FO',$position)"/>
							<a href="#{$temp130}">Forløp og behandling</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='HJ']">
						<li>
							<xsl:variable name="temp140" select="concat('HJ',$position)"/>
							<a href="#{$temp140}">Funksjonsnivå/hjelpetiltak</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='MEDB']">
						<li>
							<xsl:variable name="temp150" select="concat('Medication',$position)"/>
							<a href="#{$temp150}">Medisinering</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='FA']">
						<li>
							<xsl:variable name="temp160" select="concat('FA',$position)"/>
							<a href="#{$temp160}">Familie/sosialt</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='IP']">
						<li>
							<xsl:variable name="temp170" select="concat('IP',$position)"/>
							<a href="#{$temp170}">Informasjon til pasient/pårørende</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='SYKM']">
						<li>
							<xsl:variable name="temp180" select="concat('SYKM',$position)"/>
							<a href="#{$temp180}">Sykemelding</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='ServReq']/child::*[local-name()='Comment']">
						<li>
							<xsl:variable name="temp190" select="concat('Comment',$position)"/>
							<a href="#{$temp190}">Kommentarer</a>
						</li>
					</xsl:if>
					<xsl:for-each select="//child::*[local-name()='Patient']">
						<xsl:if test="child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='Sex'] or child::*[local-name()='DateOfBirth'] or child::*[local-name()='PatientPrecaution'] or child::*[local-name()='AssistertKommunikasjon'] or child::*[local-name()='ParorendeForesatt'] or child::*[local-name()='ContactPerson'] or child::*[local-name()='PatRelInst'] or child::*[local-name()='Consent'] or child::*[local-name()='AdditionalId'] or child::*[local-name()='NeedTranslator'] or child::*[local-name()='CareSituation']">
							<li>
								<xsl:variable name="temp200" select="concat('Patient',$position)"/>
								<a href="#{$temp200}">Pasient</a>
							</li>
						</xsl:if>
						<xsl:if test="child::*[local-name()='PatRelHCP']">
							<li>
								<xsl:variable name="temp210" select="concat('PatRelHCP',$position)"/>
								<a href="#{$temp210}">Helsetjenesteenheter</a>
							</li>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="child::*[local-name()='PatientPrecaution'] or child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='TilleggsopplysningPasient'] or ancestor::*[local-name()='Document']/child::*[local-name()='Consent'] or child::*[local-name()='ParorendeForesatt'] or child::*[local-name()='InfoAssistertKommunikasjon'] or child::*[local-name()='PasientrelatertKontaktperson']">
						<li>
							<xsl:variable name="temp220" select="concat('Patient',$position)"/>
							<a href="#{$temp220}">Pasientopplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="child::*[local-name()='TilknyttetEnhet'] or child::*[local-name()='KontaktpersonHelsepersonell'] or child::*[local-name()='AnsvarForRapport']">
						<li>
							<xsl:variable name="temp230" select="concat('PatRelHCP',$position)"/>
							<a href="#{$temp230}">Helsetjenesteenheter</a>
						</li>
					</xsl:if>
					<xsl:if test="child::*[local-name()='VurderingAvHenvisning']">
						<li>
							<xsl:variable name="temp240" select="concat('vurderingHenvisning',$position)"/>
							<a href="#{$temp240}">Henvisning mellom helseforetak</a>
						</li>
					</xsl:if>
					<xsl:if test="child::*[local-name()='RefDoc'] or count(//child::*[local-name()='RefDoc']) &gt; 1">
						<li>
							<xsl:variable name="temp250" select="concat('RefDoc',$position)"/>
							<a href="#{$temp250}">Vedlegg</a>
						</li>
					</xsl:if>
				</ul>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="Diagnosis">
		<div  class="eh-row">
			<span class="eh-field eh-label">
				<xsl:value-of select="child::*[local-name()='Concept']/@V"/>

				<xsl:if test="contains(child::*[local-name()='Concept']/@S, '7170')">(ICPC)</xsl:if>

				<xsl:if test="contains(child::*[local-name()='Concept']/@S, '7110')">(ICD-10)</xsl:if>
			</span>

			<xsl:if test="child::*[local-name()='Concept']/@DN or child::*[local-name()='Concept']/@OT">
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='Concept']">
						<xsl:call-template name="k-dummy"/>
					</xsl:for-each>
				</span>
			</xsl:if>

			<xsl:if test="child::*[local-name()='Modifier']"> <!-- maxOccurs="unbounded" -->
				<span class="eh-field eh-last-child"> <!-- 6 columns -->
					<xsl:for-each select="child::*[local-name()='Modifier']">
						<div>
							<span class="eh-strong">
								<xsl:call-template name="k-7305"/>
							</span>
							<xsl:value-of select="child::*[local-name()='Value']/@V"/>&#160;-&#160;<xsl:value-of select="child::*[local-name()='Value']/@DN"/>
						</div>
					</xsl:for-each>
				</span>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template name="ReasonAsText"> <!-- maxOccurs="unbounded" -->

		<div  class="eh-row">
			<xsl:if test="child::*[local-name()='Heading']/@V='BG' or  child::*[local-name()='Heading']/@V='BUP-BM' or child::*[local-name()='Heading']/@V='BUP-HG' or child::*[local-name()='Heading']/@V='KF' or child::*[local-name()='Heading']/@V='MAAL' or child::*[local-name()='Heading']/@V='MU' or child::*[local-name()='Heading']/@V='RU' or child::*[local-name()='Heading']/@V='UP'">
				<span class="eh-field eh-label">
					<xsl:call-template name="k-8231"/>
				</span>
			</xsl:if>
			<xsl:if test="not(child::*[local-name()='Heading'])">Begrunnelse (uspes.)</xsl:if>

			<span class="eh-field eh-last-child"> <!-- 7 columns -->

				<xsl:if test="child::*[local-name()='TextResultValue']">
					<div>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='TextResultValue']"/>
						</xsl:call-template>
					</div>
				</xsl:if>
				<xsl:for-each select="child::*[local-name()='TextCode'] | child::*[local-name()='TextCode']"> <!-- maxOccurs="unbounded" -->
					<div>
						<xsl:choose>
							<xsl:when test="@DN">
								<xsl:value-of select="@DN"/>&#160;</xsl:when>
							<xsl:when test="@OT">
								<xsl:value-of select="@OT"/>&#160;</xsl:when>
							<xsl:when test="@V">
								<xsl:value-of select="@V"/>&#160;<xsl:choose>
									<xsl:when test="contains(@S,'7010')">(SNOMED)</xsl:when>
									<xsl:when test="contains(@S,'7230')">(NKKKL)</xsl:when>
									<xsl:when test="contains(@S,'7240')">(NORAKO)</xsl:when>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>
					</div>
				</xsl:for-each>

			</span>

		</div>
	</xsl:template>

	<xsl:template name="Observation"> <!-- ServRec/Patient/InfItem/Observation -->
		<div class="eh-row">
			<xsl:variable name="cssClass">
				<xsl:choose>
					<xsl:when test="../child::*[local-name()='StartDateTime'] | ../child::*[local-name()='EndDateTime'] | ../child::*[local-name()='OrgDate']">
					</xsl:when>
					<xsl:otherwise>eh-last-child</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<span class="eh-field {$cssClass}" >
				<xsl:if test="child::*[local-name()='Description']">
					<div>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Description']"/>
						</xsl:call-template>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Comment']">
					<div>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
						</xsl:call-template>
					</div>
				</xsl:if>
			</span>

			<xsl:if test="../child::*[local-name()='StartDateTime'] | ../child::*[local-name()='EndDateTime'] | ../child::*[local-name()='OrgDate']">
				<span class="eh-field eh-last-child"> <!-- max 6 columns width -->
					<xsl:if test="../child::*[local-name()='StartDateTime']">
						<div>Start:&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../child::*[local-name()='StartDateTime']/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="../child::*[local-name()='EndDateTime']">
						<div>Slutt:&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../child::*[local-name()='EndDateTime']/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="../child::*[local-name()='OrgDate']">
						<div>Opprinnelse:&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../child::*[local-name()='OrgDate']/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</span>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template name="ResultItem"> <!-- merk: rad-element ikke inkludert her. Max 6 columns -->
		<span class="eh-field">
			<xsl:for-each select="child::*[local-name()='ClinInv']">
				<div>
					<xsl:for-each select="child::*[local-name()='Id']">
						<xsl:call-template name="k-dummy"/>
					</xsl:for-each>
				</div>
				<xsl:for-each select="child::*[local-name()='Spec']"> <!-- maxOccurs="unbounded" -->
					<div>
						<span class="eh-strong">Spesifisert:</span>&#160;
						<xsl:call-template name="k-dummy"/>
					</div>
				</xsl:for-each>
			</xsl:for-each>
		</span>

		<span class="eh-field">

			<xsl:for-each select="child::*[local-name()='Interval']">
				<xsl:if test="child::*[local-name()='Low']">
					<span class="eh-strong">Nedre:</span>&#160;<xsl:value-of select="child::*[local-name()='Low']/@V"/>
					<xsl:value-of select="child::*[local-name()='Low']/@U"/>&#160;
				</xsl:if>
				<xsl:if test="child::*[local-name()='High']">
					<span class="eh-strong">Øvre:</span>&#160;<xsl:value-of select="child::*[local-name()='High']/@V"/>
					<xsl:value-of select="child::*[local-name()='High']/@U"/>&#160;
				</xsl:if>
			</xsl:for-each>

			<xsl:for-each select="child::*[local-name()='DateResult']">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateResultValue']/@V"/>
				</xsl:call-template>
			</xsl:for-each>

			<xsl:for-each select="child::*[local-name()='NumResult']">
				<xsl:for-each select="child::*[local-name()='ArithmeticComp']">
					<xsl:call-template name="k-8239"/>
				</xsl:for-each>
				<xsl:value-of select="child::*[local-name()='NumResultValue']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='NumResultValue']/@U"/>&#160;
				<xsl:for-each select="../child::*[local-name()='DevResultInd']">
					<span class="eh-strong">
						<xsl:call-template name="k-8244"/>
					</span>
				</xsl:for-each>
			</xsl:for-each>

			<xsl:for-each select="child::*[local-name()='TextResult']/child::*[local-name()='Result']">
				<xsl:if test="child::*[local-name()='TextResultValue']">
					<div>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='TextResultValue']"/>
						</xsl:call-template>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='TextCode']">
					<div>
						<xsl:call-template name="k-dummy"/>
					</div>
				</xsl:if>
			</xsl:for-each>

			<xsl:if test="child::*[local-name()='Comment']">
				<div>
					<span class="eh-strong">Kommentar:</span>&#160;<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
					</xsl:call-template>
				</div>
			</xsl:if>

		</span>

		<xsl:if test="//child::*[local-name()='ResultItem']/child::*[local-name()='InvDate']"> 
			<span class="eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='InvDate']/@V"/>
				</xsl:call-template>
			</span>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='StartDateTime']"> <!-- up one level : InfItem -->
			<span class="eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='StartDateTime']/@V"/>
				</xsl:call-template>
			</span>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='EndDateTime']"> <!-- up one level : InfItem -->
			<span class="eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='EndDateTime']/@V | ../child::*[local-name()='EndDateTime']/@V"/>
				</xsl:call-template>
			</span>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='OrgDate']"> <!-- up one level : InfItem -->
			<span class="eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='OrgDate']/@V"/>
				</xsl:call-template>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template name="Medication"> <!-- merk: rad-element ikke inkludert her. Max 8 columns -->
		<span class="eh-field">
			<xsl:for-each select="child::*[local-name()='DrugId']">
				<xsl:call-template name="k-dummy"/>
			</xsl:for-each>
		</span>

		<span class="eh-field">
			<xsl:for-each select="child::*[local-name()='Status']">
				<xsl:call-template name="k-7307"/>
			</xsl:for-each>
		</span>

		<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='UnitDose'] or //child::*[local-name()='Medication']/child::*[local-name()='QuantitySupplied']">
			<span class="eh-field">
				<xsl:if test="child::*[local-name()='UnitDose']">
					<xsl:value-of select="child::*[local-name()='UnitDose']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='UnitDose']/@U "/>
					<xsl:if test="child::*[local-name()='QuantitySupplied']">&#160;x&#160;</xsl:if>
				</xsl:if>
				<xsl:if test="child::*[local-name()='QuantitySupplied']">
					<xsl:value-of select="child::*[local-name()='QuantitySupplied']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='QuantitySupplied']/@U"/>
				</xsl:if>&#160;
			</span>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='DosageText'] or //child::*[local-name()='Medication']/child::*[local-name()='IntendedDuration']">
			<span class="eh-field">
				<xsl:if test="child::*[local-name()='DosageText']">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='DosageText']"/>
					</xsl:call-template>
				</xsl:if>&#160;
				<xsl:if test="child::*[local-name()='IntendedDuration']">&#160;/&#160;<xsl:value-of select="child::*[local-name()='IntendedDuration']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='IntendedDuration']/@U"/>
				</xsl:if>
				<xsl:if test="not(child::*[local-name()='DosageText']) and not(child::*[local-name()='IntendedDuration'])">&#160;</xsl:if>
			</span>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='Comment']">
			<span class="eh-field">
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
				</xsl:call-template>
			</span>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='StartDateTime']">
			<span class="eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='StartDateTime']/@V "/>
				</xsl:call-template>
			</span>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='EndDateTime']">
			<span class="eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='EndDateTime']/@V"/>
				</xsl:call-template>
			</span>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='OrgDate']">
			<span class="eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='OrgDate']/@V"/>
				</xsl:call-template>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template name="PatientInformation"> <!-- Document/RefDoc/Content/Henvisning (v2.0) -->
		<xsl:if test="child::*[local-name()='PatientPrecaution']">
			<div class="eh-row">
				<span class="eh-field eh-label" style="color: red;">Advarsel</span>
				<span class="eh-field eh-last-child">
					<xsl:for-each select="child::*[local-name()='PatientPrecaution']">
						<xsl:value-of select="child::*[local-name()='Precaution']"/>
						<xsl:if test="child::*[local-name()='StartDateTime'] or child::*[local-name()='EndDateTime']">
							(<xsl:if test="child::*[local-name()='StartDateTime']"><xsl:call-template name="skrivUtTS"><xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']/@V"/></xsl:call-template></xsl:if>&#160;-&#160;<xsl:if test="child::*[local-name()='EndDateTime']"><xsl:call-template name="skrivUtTS"><xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']/@V"/></xsl:call-template></xsl:if>)
						</xsl:if>
						<xsl:if test="position()!=last()">,&#160;</xsl:if>
					</xsl:for-each>
				</span>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='TilleggsopplysningPasient'] or ancestor::*[local-name()='Document']/child::*[local-name()='Consent']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='SivilStatus'] or child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='BorAlene']">
					<span class="eh-field eh-label">
						<xsl:choose>
							<xsl:when test="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='BorAlene'] and not(child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='SivilStatus'])">Bostatus</xsl:when>
							<xsl:when test="not(child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='BorAlene']) and child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='SivilStatus']">Sivilstatus</xsl:when>
							<xsl:otherwise>Bo-&#160;/&#160;sivilstatus</xsl:otherwise>
						</xsl:choose>
					</span>
					<span class="eh-field">
						<xsl:choose>
							<xsl:when test="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='BorAlene']='true'">Bor alene</xsl:when>
							<xsl:otherwise>Bor ikke alene</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='SivilStatus']">,&#160;</xsl:if>
						<xsl:for-each select="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='SivilStatus']">
							<xsl:call-template name="k-8724"/>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='Sprak']">
					<span class="eh-field eh-label">Språk</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='Sprak']">
							<xsl:call-template name="k-3303"/>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='BasisForHealthServices']">
					<span class="eh-field eh-label">Refusjonsgrunnlag</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='BasisForHealthServices']">
							<xsl:call-template name="k-8246"/>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="ancestor::*[local-name()='Document']/child::*[local-name()='Consent']">
					<span class="eh-field eh-label">Samtykke gitt</span>
					<span class="eh-field">
						<xsl:for-each select="ancestor::*[local-name()='Document']/child::*[local-name()='Consent']">
							<xsl:choose>
								<xsl:when test="contains(@S,'3109')"><xsl:call-template name="k-3109"/></xsl:when>
								<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</span>
				</xsl:if>
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='ParorendeForesatt']">
			<div class="eh-row">
				<span class="eh-field eh-label">
					<xsl:for-each select="child::*[local-name()='Slektskap']">
						<xsl:call-template name="k-9033"/>&#160;
						<xsl:if test="../child::*[local-name()='Omsorgsfunksjon']">og&#160;</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()='Omsorgsfunksjon']">
						<xsl:call-template name="k-9050"/>&#160;
					</xsl:for-each>
					<xsl:if test="not(child::*[local-name()='Slektskap']) and not(child::*[local-name()='Omsorgsfunksjon'])">Pårørende/foresatt</xsl:if>
				</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='Referanseperson']">
						<div class="No-line-content">
							<xsl:call-template name="Person"/>
						</div>
					</xsl:for-each>
				</span>
				<xsl:if test="child::*[local-name()='FodselsarMindrearigParorende']">
					<span class="eh-field eh-label">Født</span>
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='FodselsarMindrearigParorende']"/>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Merknad']">
					<span class="eh-field eh-label">Merknad</span>
					<span class="eh-field eh-last-child">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
						</xsl:call-template>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='InfoAssistertKommunikasjon']/child::*[local-name()='AssistertKommunikasjon']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='PersonTolkebehov']">
					<span class="eh-field eh-label">Gjelder&#160;for</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='PersonTolkebehov']">
							<div class="No-line-content">
								<xsl:call-template name="Person"/>
							</div>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='BehovTolkSprak']">
					<span class="eh-field eh-label">Språk</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='BehovTolkSprak']">
							<xsl:call-template name="k-3303"/>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='PreferertTolk']">
					<span class="eh-field eh-label">Ønsket&#160;tolk</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='PreferertTolk']">
							<div class="No-line-content">
								<xsl:call-template name="Person"/>
							</div>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Horselsvikt'] or child::*[local-name()='Synsvikt'] or child::*[local-name()='BehovOpphortDato'] or child::*[local-name()='Merknad']">
					<span class="eh-field eh-label">Merknad</span>
					<span class="eh-field eh-last-child">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
						</xsl:call-template>
						<xsl:if test="child::*[local-name()='Horselsvikt']='true' or child::*[local-name()='Synsvikt']='true' or child::*[local-name()='BehovOpphortDato']">
							<div>
								<xsl:if test="child::*[local-name()='Horselsvikt']='true'">
									<span class="eh-strong">Hørselsvikt:</span>&#160;Ja&#160;
								</xsl:if>
								<xsl:if test="child::*[local-name()='Synsvikt']='true'">
									<span class="eh-strong">Synsvikt:</span>&#160;Ja&#160;
								</xsl:if>
							</div>
							<div>
								<xsl:if test="child::*[local-name()='BehovOpphortDato']/@V">
									<span class="eh-strong">Behov&#160;opphørte:</span>&#160;
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="child::*[local-name()='BehovOpphortDato']/@V"/>
									</xsl:call-template>&#160;
								</xsl:if>
							</div>
						</xsl:if>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='PasientrelatertKontaktperson']">
			<div class="eh-row">
				<span class="eh-field eh-label">
					<xsl:value-of select="child::*[local-name()='StillingRolle']"/>
				</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='Referanseperson']">
						<div class="No-line-content">
							<xsl:call-template name="Person"/>
						</div>
					</xsl:for-each>
				</span>
				<xsl:if test="child::*[local-name()='Arbeidssted']">
					<span class="eh-field eh-label">Arbeidssted</span>
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='Arbeidssted']"/>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Merknad']">
					<span class="eh-field eh-label">Merknad</span>
					<span class="eh-field eh-last-child">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
						</xsl:call-template>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="Patient"> <!-- Message/ServReq/Patient (v1.0, v1.1) -->
		<xsl:if test="child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='Sex'] or child::*[local-name()='DateOfBirth'] or child::*[local-name()='AdditionalId']">
			<div class="eh-row">
				<span class="eh-field eh-label">Pasientinfo</span>
				<xsl:if test="child::*[local-name()='Name']">
					<span class="eh-field eh-label">Navn</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='OffId']">
					<span class="eh-field eh-label">
						<xsl:for-each select="child::*[local-name()='TypeOffId']">
							<xsl:call-template name="k-8116"/> 
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Sex']">
					<span class="eh-field eh-label">Kjønn</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='DateOfBirth']">
					<span class="eh-field eh-label">Fødselsdag</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='DateOfDeath']">
					<span class="eh-field eh-label">Dødsdag</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='BasisForHealthServices']">
					<span class="eh-field eh-label">Refusjonsgrunnlag</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='AdditionalId']">
					<span class="eh-field eh-label">Tilleggs-Id</span>
				</xsl:if>
			</div>
			<div class="eh-row">
				<span class="eh-field"></span>
				<xsl:if test="child::*[local-name()='Name']">
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='Name']"/>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='OffId']">
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='OffId']"/>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Sex']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Sex']">
							<xsl:call-template name="k-3101"/> 
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='DateOfBirth']">
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfBirth']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='DateOfDeath']">
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfDeath']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='BasisForHealthServices']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='BasisForHealthServices']">
							<xsl:call-template name="k-8246"/> 
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='AdditionalId']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='AdditionalId']">
							<div>
								<xsl:if test="child::*[local-name()='Type']">
									<span class="eh-strong">
										<xsl:value-of select="child::*[local-name()='Type']/@V"/>:
									</span>
								</xsl:if>
								<xsl:value-of select="child::*[local-name()='Id']"/>
							</div>
						</xsl:for-each>
					</span>
				</xsl:if>
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='PatientPrecaution']">
			<xsl:if test="position()=1">
				<div class="eh-row">
					<span class="eh-field eh-last-child">
						<hr/>
					</span>
				</div>
				<div class="eh-row">
					<div class="eh-field eh-label">Advarsel til tjenesteyter</div>
					<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='Precaution']">
						<span class="eh-field eh-label">Advarsel</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='StartDateTime']">
						<span class="eh-field eh-label">Start&#173;tidspunkt</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='EndDateTime']">
						<span class="eh-field eh-label">Slut&#173;tidspunkt</span>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row">
				<div class="eh-field"></div>
				<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='Precaution']">
					<span class="eh-field">
						<xsl:value-of select="/child::*[local-name()='Precaution']"/>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='StartDateTime']">
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='EndDateTime']">
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='Consent']">
			<div class="eh-row">
				<span class="eh-field eh-last-child">
					<hr/>
				</span>
			</div>
			<div class="eh-row">
				<span class="eh-field eh-label" style="width: 25%; ">Samtykke</span>
				<xsl:if test="child::*[local-name()='ConsentStatus']">
					<span class="eh-field eh-label">Samtykke gitt</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='ConsentDate']">
					<span class="eh-field eh-label">Samtykkedato</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Merknad']">
					<span class="eh-field eh-label">Merknad</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='GivenBy']">
					<span class="eh-field eh-label">Gitt av</span>
				</xsl:if>
			</div>
			<div class="eh-row">
				<span class="eh-field eh-label" style="width: 25%; ">&#160;</span>
				<xsl:if test="child::*[local-name()='ConsentStatus']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='ConsentStatus']">
							<xsl:call-template name="k-3109"/>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='ConsentDate']">
					<span class="eh-field">
						<xsl:call-template name="skrivUtDate">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='ConsentDate']"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Merknad']">
					<span class="eh-field">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='GivenBy']">
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='GivenBy']"/>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='AssistertKommunikasjon']">
			<xsl:if test="position()=1">
				<div class="eh-row">
					<span class="eh-field eh-last-child">
						<hr/>
					</span>
				</div>
				<div class="eh-row">
					<div class="eh-field eh-label">Behov for tolk</div>
					<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='PersonTolkebehov']">
						<span class="eh-field eh-label">Personen behovet gjelder</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon'][child::*[local-name()='Horselsvikt']='true'] or ..//child::*[local-name()='AssistertKommunikasjon'][child::*[local-name()='Synsvikt']='true']">
						<span class="eh-field eh-label">Handikap</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='BehovTolkSprak']">
						<span class="eh-field eh-label">Språk</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='PreferertTolk']">
						<span class="eh-field eh-label">Foretrukket tolk</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='BehovOpphortDato']">
						<span class="eh-field eh-label">Behov opphørt dato</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='Merknad']">
						<span class="eh-field eh-label eh-last-child">Merknad</span>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row">
				<div class="eh-field"></div>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='PersonTolkebehov']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='PersonTolkebehov']">
							<div>
								<xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/>
							</div>
							<xsl:for-each select=".//fk1:TeleAddress">
								<xsl:call-template name="TeleAddressHode"/>
							</xsl:for-each>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon'][child::*[local-name()='Horselsvikt']='true'] or ..//child::*[local-name()='AssistertKommunikasjon'][child::*[local-name()='Synsvikt']='true']">
					<span class="eh-field">
						<xsl:if test="child::*[local-name()='Horselsvikt']='true'">Døv</xsl:if>
						<xsl:if test="child::*[local-name()='Horselsvikt']='true' and child::*[local-name()='Synsvikt']='true'">&#160;og&#160;</xsl:if>
						<xsl:if test="child::*[local-name()='Synsvikt']='true'">Blind</xsl:if>&#160;
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='BehovTolkSprak']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='BehovTolkSprak']">
							<xsl:call-template name="k-3303"/>&#160;
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='PreferertTolk']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='PreferertTolk']">
							<div>
								<xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/>
							</div>
							<xsl:for-each select=".//fk1:TeleAddress">
								<xsl:call-template name="TeleAddressHode"/>
							</xsl:for-each>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='BehovOpphortDato']">
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='BehovOpphortDato']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='Merknad']">
					<span class="eh-field eh-last-child">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
						</xsl:call-template>&#160;
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='ParorendeForesatt']">
			<xsl:if test="position()=1">
				<div class="eh-row">
					<span class="eh-field eh-last-child">
						<hr/>
					</span>
				</div>
				<div class="eh-row">
					<div class="eh-field eh-label">Pårørende/&#173;foresatt</div>				
					<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Referanseperson']">
						<span class="eh-field  eh-label">Person</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Slektskap']">
						<span class="eh-field  eh-label">Slektskap</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Omsorgsfunksjon']">
						<span class="eh-field  eh-label">Omsorgsfunksjon</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Merknad']">
						<span class="eh-field  eh-label eh-last-child">Merknad</span>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row">
				<div class="eh-field"></div>
				<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Referanseperson']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Referanseperson']">
							<div>
								<xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/>
							</div>
							<xsl:for-each select=".//fk1:TeleAddress">
								<xsl:call-template name="TeleAddressHode"/>
							</xsl:for-each>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Slektskap']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Slektskap']">
							<xsl:call-template name="k-9033"/>&#160;
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Omsorgsfunksjon']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Omsorgsfunksjon']">
							<xsl:call-template name="k-9050"/>&#160;
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Merknad']">
					<span class="eh-field eh-last-child">
						<xsl:value-of select="child::*[local-name()='Merknad']"/>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='NeedTranslator']">
			<xsl:if test="position()=1">
				<div class="eh-row">
					<span class="eh-field eh-last-child">
						<hr/>
					</span>
				</div>
				<div class="eh-row">
					<div class="eh-field eh-label">Behov for tolk</div>
					<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='Person']">
						<span class="eh-field  eh-label">Person-referanse</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='NeedTranslator'][/child::*[local-name()='IsDeaf']/@V='true'] or ..//child::*[local-name()='NeedTranslator'][/child::*[local-name()='IsBlind']/@V='true']">
						<span class="eh-field  eh-label">Handikap</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='NeedTranslator']//child::*[local-name()='Language']">
						<span class="eh-field  eh-label">Språk</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='PreferredTranslator']">
						<span class="eh-field  eh-label">Referanse til foretrukket tolk</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='TranslatorEndDate']">
						<span class="eh-field  eh-label">Behov opphørt dato</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='Note']">
						<span class="eh-field eh-label eh-last-child">Merknad</span>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row">
				<div class="eh-field"></div>
				<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='Person']">
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='Person']"/>&#160;
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='NeedTranslator'][child::*[local-name()='IsDeaf']/@V='true'] or ..//child::*[local-name()='NeedTranslator'][child::*[local-name()='IsBlind']/@V='true']">
					<span class="eh-field  eh-label">
						<xsl:if test="child::*[local-name()='IsDeaf']/@V='true'">Døv</xsl:if>
						<xsl:if test="child::*[local-name()='IsDeaf']/@V='true' and child::*[local-name()='IsBlind']/@V='true'">&#160;og&#160;</xsl:if>
						<xsl:if test="child::*[local-name()='IsBlind']/@V='true'">Blind</xsl:if>&#160;
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='Language']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Language']">
							<xsl:call-template name="k-3303"/>&#160;
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='PreferredTranslator']">
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='PreferredTranslator']"/>&#160;
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='TranslatorEndDate']">
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='TranslatorEndDate']/@V"/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='Note']">
					<span class="eh-field eh-last-child">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Note']"/>
						</xsl:call-template>&#160;
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='CareSituation']">
			<div class="eh-row">
				<span class="eh-field  eh-label" style="width: 25%; ">Omsorgssituasjon</span>
				<xsl:if test="child::*[local-name()='CustodyType']">
					<span class="eh-field  eh-label">Foreldreansvar</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='CareSituationType']">
					<span class="eh-field  eh-label">Type omsorgssituasjon</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='NativeLanguage']">
					<span class="eh-field  eh-label">Hjemmespråk</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Description']">
					<span class="eh-field  eh-label eh-last-child">Beskrivelse</span>
				</xsl:if>
			</div>
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='CustodyType']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='CustodyType']">
							<xsl:call-template name="k-9513"/>&#160;
						</xsl:for-each>
						<xsl:if test="child::*[local-name()='CustodyOwner']">
							<xsl:value-of select="child::*[local-name()='CustodyOwner']"/>
						</xsl:if>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='CareSituationType']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='CareSituationType']">
							<xsl:call-template name="k-3105"/>&#160;
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='NativeLanguage']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='NativeLanguage']">
							<xsl:call-template name="k-8417"/>&#160;
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Description']">
					<span class="eh-field eh-last-child">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Description']"/>
						</xsl:call-template>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='PatRelperson']">
			<xsl:if test="position()=1">
				<div class="eh-row">
					<span class="eh-field eh-last-child">
						<hr/>
					</span>
				</div>
				<div class="eh-row">
					<div class="eh-field eh-label">Referert person</div>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Relation'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='Description']">
						<span class="eh-field eh-label">Relasjon/beskrivelse</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Name']">
						<span class="eh-field eh-label">Navn</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='OffId']">
						<span class="eh-field eh-label">Offentlig id</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Sex'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='EthnicBelonging'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='DateOfBirth']">
						<span class="eh-field eh-label">Personlige opplysninger</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Occupation'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='Role']">
						<span class="eh-field eh-label">Stilling/annen rolle</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Consent']">
						<span class="eh-field eh-label">Samtykke</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Address']">
						<span class="eh-field eh-label">Adresse</span>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row">
				<div class="eh-field"></div>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Relation'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='Description']">
					<span class="eh-field">
						<xsl:if test="child::*[local-name()='Relation']/child::*[local-name()='Guardien']/@V='true'">
							<span class="eh-label">Foresatt</span>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="child::*[local-name()='Relation']/child::*[local-name()='RelationCode']/@V='9' and child::*[local-name()='Relation']/child::*[local-name()='Description']">
								<xsl:value-of select="child::*[local-name()='Relation']/child::*[local-name()='Description']"/>
							</xsl:when>
							<xsl:when test="child::*[local-name()='Relation']/child::*[local-name()='RelationCode']/@V">
								<xsl:for-each select="child::*[local-name()='Relation']/child::*[local-name()='RelationCode']">
									<xsl:call-template name="k-8422"/>&#160;</xsl:for-each>
							</xsl:when>
							<xsl:when test="child::*[local-name()='Relation']/child::*[local-name()='Description']">
								<xsl:value-of select="child::*[local-name()='Relation']/child::*[local-name()='Description']"/>
							</xsl:when>
							<xsl:when test="child::*[local-name()='Description']">
								<xsl:value-of select="child::*[local-name()='Description']"/>
							</xsl:when>
							<xsl:otherwise>Pasientrelatert person</xsl:otherwise>
						</xsl:choose>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Name']">
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='Name']"/>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='OffId']">
					<span class="eh-field">
						<span class="eh-strong">
							<xsl:for-each select="child::*[local-name()='TypeOffId']">
								<xsl:call-template name="k-8116"/>
							</xsl:for-each>
						</span>&#160;
						<xsl:value-of select="child::*[local-name()='OffId']"/>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Sex'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='EthnicBelonging'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='DateOfBirth']">
					<span class="eh-field">
						<xsl:if test="child::*[local-name()='Sex']">
							<span class="eh-label">Kjønn:</span>
							<xsl:for-each select="child::*[local-name()='Sex']">
								<xsl:call-template name="k-3101"/>&#160;
							</xsl:for-each>
							<xsl:if test="child::*[local-name()='EthnicBelonging'] or child::*[local-name()='DateOfBirth']">,&#160;</xsl:if>
						</xsl:if>
						<xsl:if test="child::*[local-name()='EthnicBelonging']">
							<xsl:for-each select="child::*[local-name()='EthnicBelonging']">
								<xsl:call-template name="k-8423"/>&#160;
							</xsl:for-each>
							<xsl:if test="child::*[local-name()='DateOfBirth']">,&#160;</xsl:if>
						</xsl:if>
						<xsl:if test="child::*[local-name()='DateOfBirth']">
							<span class="eh-label">født:&#160;</span>
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfBirth']/@V"/>
							</xsl:call-template>
						</xsl:if>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Occupation'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='Role']">
					<span class="eh-field">
						<xsl:choose>
							<xsl:when test="child::*[local-name()='Occupation']/@DN">
								<xsl:value-of select="child::*[local-name()='Occupation']/@DN"/>
							</xsl:when>
							<xsl:otherwise>
								<span class="eh-label">Stillingskode:</span>&#160;<xsl:value-of select="child::*[local-name()='Occupation']/@V"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="child::*[local-name()='Role']"/>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Consent']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Consent']">
							<xsl:if test="child::*[local-name()='ConsentStatus']">
								<span class="eh-label">Samtykke gitt:</span>
								<xsl:for-each select="child::*[local-name()='ConsentStatus']">
									<xsl:call-template name="k-3109"/>
								</xsl:for-each>
							</xsl:if>
							<xsl:if test="child::*[local-name()='ConsentDate']">
								<span class="eh-label">Dato:</span>
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()='ConsentDate']/@V"/>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="child::*[local-name()='Merknad']">
								<div>
									<span class="eh-label">Merknad:</span>&#160;<xsl:call-template name="line-breaks">
										<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
									</xsl:call-template>
								</div>
							</xsl:if>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Address']">
					<span class="eh-field">
						<xsl:apply-templates select="child::*[local-name()='Address']" mode="full"/>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='ContactPerson']">
			<xsl:if test="position()=1">
				<div class="eh-row">
					<span class="eh-field eh-last-child">
						<hr/>
					</span>
				</div>
				<div class="eh-row">
					<div class="eh-field eh-label">Kontaktperson</div>
					<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='Referanseperson']">
						<span class="eh-field eh-label">Person</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='OccupationRole']">
						<span class="eh-field eh-label">Stilling/rolle</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='WorkingPlace']">
						<span class="eh-field eh-label">Arbeidssted</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='Merknad']">
						<span class="eh-field eh-label eh-last-child">Merknad</span>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row">
				<div class="eh-field"></div>
				<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='Referanseperson']">
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Referanseperson']">
							<div>
								<xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/>
							</div>
							<xsl:for-each select=".//fk1:TeleAddress">
								<xsl:call-template name="TeleAddressHode"/>
							</xsl:for-each>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='OccupationRole']">
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='OccupationRole']"/>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='WorkingPlace']">
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='WorkingPlace']"/>
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='Merknad']">
					<span class="eh-field eh-last-child">
						<xsl:value-of select="child::*[local-name()='Merknad']"/>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='PatRelInst']">
			<xsl:if test="position()=1">
				<div class="eh-row">
					<span class="eh-field" style="width: 100%; ">
						<hr/>
					</span>
				</div>
				<div class="eh-row">
					<div class="eh-field eh-label">Referert virksomhet</div>
					<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='NameInst']">
						<span class="eh-field eh-label">Navn</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='RoleInst']">
						<span class="eh-field eh-label">Rolle</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='ContactPerson']">
						<span class="eh-field eh-label">Kontaktperson</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='Merknad']">
						<span class="eh-field eh-label eh-last-child">Merknad</span>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row">
				<div class="eh-field"></div>
				<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='NameInst']">
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='NameInst']"/>&#160;
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='RoleInst']">
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='RoleInst']"/>&#160;
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='ContactPerson']">
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='ContactPerson']"/>&#160;
					</span>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='Merknad']">
					<span class="eh-field eh-last-child">
						<xsl:value-of select="child::*[local-name()='Merknad']"/>&#160;
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="HealthCareProfessional_v1">
		<div class="eh-row">
			<xsl:if test="//child::*[local-name()='PatRelHCP']/child::*[local-name()='Relation']">
				<span class="eh-field eh-label">Pasientrelasjon</span>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='HCProf'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='HCPerson'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept']">
				<span class="eh-field">
					<xsl:choose>
						<xsl:when test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept'] and (//child::*[local-name()='PatRelHCP']//child::*[local-name()='HCProf'] or //child::*[local-name()='PatRelHCP']//child::*[local-name()='HCPerson'])">Person/avd.</xsl:when>
						<xsl:when test="not(//child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept'])">Person</xsl:when>
						<xsl:otherwise>Avdeling</xsl:otherwise>
					</xsl:choose>
				</span>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='HCProf']/child::*[local-name()='Id'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='HCProf']/child::*[local-name()='AdditionalId'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='HCPerson']/child::*[local-name()='Id'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='HCPerson']/child::*[local-name()='AdditionalId'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept']/child::*[local-name()='Id'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept']/child::*[local-name()='AdditionalId']">
				<span class="eh-field eh-label">Id</span>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='Inst']/child::*[local-name()='Name']">
				<span class="eh-field eh-label">Institusjon</span>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='MedSpeciality']">
				<span class="eh-field eh-label">Medisinsk spesialitet</span>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='Inst']/child::*[local-name()='Id']">
				<span class="eh-field eh-label">Institusjon-id</span>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']/child::*[local-name()='StartDateTime'] | //child::*[local-name()='PatRelHCP']/child::*[local-name()='EndDateTime']">
				<span class="eh-field eh-label">Tidsrom</span>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='Address']">
				<span class="eh-field eh-label">Adresse</span>
			</xsl:if>
		</div>
		<xsl:for-each select="child::*[local-name()='Patient']/child::*[local-name()='PatRelHCP']">
			<xsl:call-template name="PatRelHCP"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="HealthCareProfessional_v2">
		<xsl:for-each select="child::*[local-name()='TilknyttetEnhet']">
			<div class="eh-row">
				<xsl:choose>
					<xsl:when test="position() = 1">
						<span  class="eh-field eh-label">Tilknyttet enhet</span>
					</xsl:when>
					<xsl:otherwise>
						<span  class="eh-field eh-label DocRow">&#160;</span>
					</xsl:otherwise>
				</xsl:choose>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='Kontaktenhet']">
						<xsl:call-template name="Organisation"/>
					</xsl:for-each>
				</span>
				<xsl:if test="child::*[local-name()='Merknad']">
					<span  class="eh-field eh-label">Merknad</span>
					<span  class="eh-field eh-last-child">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
						</xsl:call-template>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='KontaktpersonHelsepersonell']">
			<div class="eh-row">
				<xsl:choose>
					<xsl:when test="position() = 1">
						<span  class="eh-field eh-label">Tilknyttet helseperson</span>
					</xsl:when>
					<xsl:otherwise>
						<span  class="eh-field eh-label DocRow">&#160;</span>
					</xsl:otherwise>
				</xsl:choose>
				<span  class="eh-field">
					<xsl:for-each select="child::*[local-name()='Kontaktperson']">
						<div class="No-line-content">
							<xsl:call-template name="HealthcareProfessional"/>
						</div>
					</xsl:for-each>
				</span>
				<xsl:if test="child::*[local-name()='Merknad']">
					<span  class="eh-field eh-label">Merknad</span>
					<span  class="eh-field eh-last-child">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
						</xsl:call-template>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='AnsvarForRapport']">
			<div class="eh-row">
				<xsl:choose>
					<xsl:when test="position() = 1">
						<span  class="eh-field eh-label">Ansvarlig for rapport</span>
					</xsl:when>
					<xsl:otherwise>
						<span  class="eh-field eh-label DocRow">&#160;</span>
					</xsl:otherwise>
				</xsl:choose>
				<span  class="eh-field">
					<xsl:for-each select="child::*[local-name()='TypeRelasjon']">
						<xsl:choose>
							<xsl:when test="contains(@S,'8254')"><xsl:call-template name="k-8254"/>&#160;</xsl:when>
							<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()='AnsvarligRapport']">
						<div class="No-line-content">
							<xsl:call-template name="HealthcareProfessional"/>
						</div>
					</xsl:for-each>
				</span>
				<xsl:if test="child::*[local-name()='Merknad'] or child::*[local-name()='GodkjentDato']">
					<span  class="eh-field eh-label">
						<xsl:choose>
							<xsl:when test="child::*[local-name()='GodkjentDato'] and not(child::*[local-name()='Merknad'])">Dato godkjent</xsl:when>
							<xsl:otherwise>Merknad</xsl:otherwise>
						</xsl:choose>
					</span>
					<span  class="eh-field">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
						</xsl:call-template>
						<xsl:if test="child::*[local-name()='GodkjentDato']">
							<div>
								<xsl:if test="child::*[local-name()='Merknad']"><span class="eh-strong">Dato godkjent</span>&#160;</xsl:if>
								<xsl:value-of select="child::*[local-name()='GodkjentDato']"/>
							</div>
						</xsl:if>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="VurderingAvHenvisning">
		<xsl:for-each select="child::*[local-name()='Opplysninger']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='FrittSykehusvalg']">
					<span class="eh-field eh-label">Fritt sykehusvalg</span>
					<span class="eh-field">
						<xsl:choose>
							<xsl:when test="child::*[local-name()='FrittSykehusvalg']='true'">Benyttes</xsl:when>
							<xsl:otherwise>Benyttes ikke</xsl:otherwise>
						</xsl:choose>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='VentetidSluttkode']">
					<span class="eh-field eh-label">Ventetid sluttkode</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='VentetidSluttkode']">
							<xsl:choose>
								<xsl:when test="contains(@S,'8445')"><xsl:call-template name="k-8445"/>&#160;</xsl:when>
								<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Omsorgsniva']">
					<span class="eh-field eh-label">Omsorgsnivå</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Omsorgsniva']">
							<xsl:choose>
								<xsl:when test="contains(@S,'8406')"><xsl:call-template name="k-8406"/>&#160;</xsl:when>
								<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</span>
				</xsl:if>
				<xsl:if test="child::*[local-name()='ForlopsId']">
					<span class="eh-field eh-label">Forløps-id</span>
					<span class="eh-field">
						<xsl:value-of select="child::*[local-name()='ForlopsId']"/>
					</span>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:if test="child::*[local-name()='DatoMottakOgVurdering']">
			<div class="eh-row">
				<xsl:for-each select="child::*[local-name()='DatoMottakOgVurdering']"> <!-- kodeverk: max 4 varianter -->
					<span class="eh-field eh-label">
						<xsl:for-each select="child::*[local-name()='TypeDato']">
							<xsl:choose>
								<xsl:when test="contains(@S,'9147')"><xsl:call-template name="k-9147"/></xsl:when>
								<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</span>
					<span class="eh-field">
						<xsl:call-template name="skrivUtDate">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='Dato']"/>
						</xsl:call-template>
					</span>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="PatRelHCP"> <!-- Message/ServReq/Patient/PatRelHCP  maxOccurs="unbounded -->

		<xsl:variable name="raw-rows" select="count(.//child::*[local-name()='HCProf'] | .//child::*[local-name()='HCPerson'] | .//child::*[local-name()='Dept'])"/>
		<xsl:variable name="rows">
			<xsl:choose>
				<xsl:when test="$raw-rows&gt;0">
					<xsl:value-of select="$raw-rows"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="eh-row">
			<xsl:if test="..//child::*[local-name()='PatRelHCP']/child::*[local-name()='Relation']">
				<span class="eh-field eh-label">
					<xsl:for-each select="child::*[local-name()='Relation']">
						<xsl:choose>
							<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/henvisning/2012-02-15'">
								<xsl:call-template name="k-8254"/>&#160; <!-- v1.1 -->
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="k-7319"/>&#160; <!-- v1.0 -->
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</span>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='PatRelHCP']//child::*[local-name()='HCProf'] | ..//child::*[local-name()='PatRelHCP']//child::*[local-name()='HCPerson'] | ..//child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept']">
				<xsl:choose>
					<xsl:when test=".//child::*[local-name()='HCProf'] | .//child::*[local-name()='HCPerson'] | .//child::*[local-name()='Dept']">
						<xsl:for-each select=".//child::*[local-name()='HCProf'] | .//child::*[local-name()='HCPerson'] | .//child::*[local-name()='Dept']">
							<xsl:if test="position()=1">
								<xsl:call-template name="HCProf_HCPerson_Dept"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<span class="eh-field">&#160;</span>
						<span class="eh-field">&#160;</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='PatRelHCP']//child::*[local-name()='Inst']/child::*[local-name()='Name']">
				<span class="eh-field">
					<xsl:value-of select=".//child::*[local-name()='Inst']/child::*[local-name()='Name']"/>
				</span>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='PatRelHCP']//child::*[local-name()='MedSpeciality']">
				<span class="eh-field">
					<xsl:for-each select=".//child::*[local-name()='MedSpeciality']">
						<xsl:call-template name="k-8451"/>&#160;
					</xsl:for-each>
				</span>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='PatRelHCP']//child::*[local-name()='Inst']/child::*[local-name()='Id']">
				<span class="eh-field">
					<xsl:if test=".//child::*[local-name()='Inst']/child::*[local-name()='TypeId']/@V">
						<span class="eh-strong">
							<xsl:value-of select=".//child::*[local-name()='Inst']/child::*[local-name()='TypeId']/@V"/>:
						</span>
					</xsl:if>&#160;
					<xsl:value-of select=".//child::*[local-name()='Inst']/child::*[local-name()='Id']"/>
				</span>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='PatRelHCP']//child::*[local-name()='StartDateTime'] | ..//child::*[local-name()='PatRelHCP']//child::*[local-name()='EndDateTime']">
				<span class="eh-field">
					<xsl:if test="child::*[local-name()='StartDateTime']">
						<span class="eh-strong">Start:</span>&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']/@V"/>
						</xsl:call-template>
					</xsl:if>&#160;
					<xsl:if test="child::*[local-name()='EndDateTime']">
						<div>
							<span class="eh-strong">Slutt:</span>&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']/@V"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</span>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='PatRelHCP']//child::*[local-name()='Address']">
				<span class="eh-field">
					<xsl:for-each select=".//child::*[local-name()='Address']">
						<xsl:call-template name="Address"/>
					</xsl:for-each>
				</span>
			</xsl:if>
		</div>
		<xsl:for-each select=".//child::*[local-name()='HCProf'] | .//child::*[local-name()='HCPerson'] | .//child::*[local-name()='Dept']">
			<xsl:if test="position()!=1">
				<div class="eh-row" style="margin-top: 0;">
					<span class="eh-field eh-label DocRow">&#160;</span>
					<xsl:call-template name="HCProf_HCPerson_Dept" />
					<span class="eh-field DocRow">&#160;</span>
					<span class="eh-field DocRow">&#160;</span>
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="HCProf_HCPerson_Dept"> <!--"h:HCProf | h:HCPerson | h:Dept"> -->
		<span class="eh-field">
			<xsl:if test="child::*[local-name()='Type']/@DN">
				<span class="eh-strong">
					<xsl:value-of select="child::*[local-name()='Type']/@DN"/>
				</span>
			</xsl:if>
			<xsl:value-of select="child::*[local-name()='Name']"/>&#160;
		</span>
		<span class="eh-field"><!-- ??? width ???-->
			<xsl:if test="child::*[local-name()='TypeId']/@V">
				<span class="eh-strong">
					<xsl:value-of select="child::*[local-name()='TypeId']/@V"/>:
				</span>
			</xsl:if>
			<xsl:value-of select="child::*[local-name()='Id']"/>&#160;
		</span>
	</xsl:template>

	<xsl:template name="Address" >
		<xsl:if test="child::*[local-name()='Type']">
			<span class="eh-strong">
				<xsl:for-each select="child::*[local-name()='Type']">
					<xsl:call-template name="k-3401"/>:&#160;
				</xsl:for-each>
			</span>
		</xsl:if>
		<xsl:if test="child::*[local-name()='StreetAdr']">
			<xsl:value-of select="child::*[local-name()='StreetAdr']"/>
		</xsl:if>
		<xsl:if test="child::*[local-name()='PostalCode'] or child::*[local-name()='City']">
			<xsl:if test="child::*[local-name()='StreetAdr']">,&#160;</xsl:if>
			<xsl:value-of select="child::*[local-name()='PostalCode']"/>&#160;<xsl:value-of select="child::*[local-name()='City']"/>
		</xsl:if>
		<xsl:if test="child::*[local-name()='CityDistr']">&#160;,<xsl:for-each select="child::*[local-name()='CityDistr']">
				<xsl:call-template name="k-3403"/>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="child::*[local-name()='County']">&#160;,<xsl:for-each select="child::*[local-name()='County']">
				<xsl:call-template name="k-3402"/>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Country']">&#160;,<xsl:for-each select="child::*[local-name()='Country']">
				<xsl:call-template name="k-9043"/>
			</xsl:for-each>
		</xsl:if>
		&#160;
		<xsl:for-each select="child::*[local-name()='TeleAddress']">
			<xsl:call-template name="TeleAddressHode"/>
		</xsl:for-each>
	</xsl:template>

	<!-- Visning av vedlegg -->
	<xsl:template name="RefDoc"> <!-- v1.0, v1.1 -->
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()='MsgType'] or child::*[local-name()='Id'] or child::*[local-name()='IssueDate'] or child::*[local-name()='MimeType'] or child::*[local-name()='Compression']">
			<div class="eh-row">
				<xsl:if test="child::*[local-name()='MsgType']">
					<span class="eh-field eh-label">Type</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='MsgType']">
							<xsl:choose>
								<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/henvisning/2012-02-15'">
									<xsl:call-template name="k-8114"/> <!-- v1.1 -->
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="k-8263"/> <!-- v1.0 -->
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

				<xsl:if test="child::*[local-name()='Booking']"> <!-- v1.0 only -->
					<span class="eh-field eh-label">Booking</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Booking']">
							<xsl:value-of select="child::*[local-name()='Name']"/>&#160;
							<span class="eh-label">
								<xsl:choose>
									<xsl:when test="child::*[local-name()='TypeId']/@V">
										<xsl:value-of select="child::*[local-name()='TypeId']/@V"/>:</xsl:when>
									<xsl:otherwise>Id:</xsl:otherwise>
								</xsl:choose>
							</span>&#160;
							<xsl:value-of select="child::*[local-name()='Id']"/>
							<xsl:for-each select=".//child::*[local-name()='SubOrg']">
								<xsl:call-template name="SubOrg" />
							</xsl:for-each>
						</xsl:for-each>
					</span>
					<span class="eh-field eh-label">Avtale</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Booking']/child::*[local-name()='Appointment']">
							<div>
								<span class="eh-label">Tidspunkt:</span>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']/@V"/>
								</xsl:call-template>
								&#160;<span class="eh-label">til</span>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']/@V"/>
								</xsl:call-template>
							</div>
							<div>
								<span class="eh-label">Ressurs:</span>&#160;
								<xsl:value-of select="child::*[local-name()='ResourceId']"/>&#160;
								<span class="eh-label">Index:</span>&#160;
								<xsl:value-of select="child::*[local-name()='Index']"/>
							</div>
							<div>
								<span class="eh-label">Service:</span>&#160;
								<xsl:for-each select="child::*[local-name()='Service']">
									<xsl:call-template name="k-8264"/>&#160;
								</xsl:for-each>
							</div>
						</xsl:for-each>
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
										<xsl:attribute name="data">
											<xsl:value-of select="concat(child::*[local-name()='FileReference'],'&#35;view&#61;FitH&#38;toolbar&#61;1')"/>
										</xsl:attribute>
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
												<xsl:attribute name="data">
													<xsl:value-of select="concat('data:application/pdf;base64,',child::*[local-name()='Content']/base:Base64Container)"/>
												</xsl:attribute>
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

	<xsl:template name="ServReq_Henvisning"> <!-- Message/ServReq -->
		<div  class="eh-row">
			<xsl:if test="child::*[local-name()='IssueDate']">
				<span class="eh-field eh-label">Utstedt</span>
				<span class="eh-field">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()='IssueDate']/@V"/>
					</xsl:call-template>
				</span>
			</xsl:if>
			<xsl:if test="child::*[local-name()='PaymentCat']">
				<span class="eh-field eh-label">Betalings&#173;kategori</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='PaymentCat']">
						<xsl:call-template name="k-8246"/>
					</xsl:for-each>
				</span>
			</xsl:if>
			<xsl:if test="child::*[local-name()='Ack']">
				<span class="eh-field eh-label">Meldings&#173;bekreftelse</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='Ack']">
						<xsl:call-template name="k-7304"/>
					</xsl:for-each>
				</span>
			</xsl:if>
		</div>

		<xsl:for-each select="child::*[local-name()='ReqServ']">
			<xsl:call-template name="ServReq_ReqServ"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="ServReq_ReqServ"> <!-- Message/ServReq/ReqServ -->
		<div  class="eh-row">
			<xsl:if test="child::*[local-name()='Priority']">
				<span class="eh-field eh-label">Hastegrad</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='Priority']">
						<xsl:call-template name="k-8304"/>
					</xsl:for-each>
				</span>
			</xsl:if>
			<xsl:if test="child::*[local-name()='Purpose']">
				<span class="eh-field eh-label">Formål</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='Purpose']">
						<xsl:call-template name="k-8248"/>
					</xsl:for-each>
				</span>
			</xsl:if>
			<xsl:if test="child::*[local-name()='ReqDate']">
				<span class="eh-field eh-label">Meldings&#173;bekreftelse</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='ReqDate']">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="@V"/>
						</xsl:call-template>
					</xsl:for-each>
				</span>
			</xsl:if>
		</div>

		<xsl:for-each select="child::*[local-name()='Service']">
			<xsl:call-template name="ReqServ_Service"/>
		</xsl:for-each>

		<xsl:if test="child::*[local-name()='Comment']">
			<div class="eh-row">
				<span class="eh-field eh-last-child">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>

	</xsl:template>

	<xsl:template name="ReqServ_Service"> <!-- Message/ServReq/ReqServ/Service -->
		<div  class="eh-row">
			<xsl:if test="child::*[local-name()='ServId']">
				<span class="eh-field eh-label">Spesifisert tjeneste</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='ServId']">
						<xsl:choose>
							<xsl:when test="@DN or @OT">
								<xsl:call-template name="k-dummy"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@V"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</span>
			</xsl:if>
			<xsl:if test="child::*[local-name()='MedSpeciality']">
				<span class="eh-field eh-label">Medisinsk spesialitet</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='MedSpeciality']">
						<xsl:choose>
							<xsl:when test="contains(@S,'7426')">
								<xsl:call-template name="k-7426"/>
							</xsl:when>
							<xsl:when test="contains(@S,'8451')">
								<xsl:call-template name="k-8451"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="k-dummy"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</span>
			</xsl:if>
			<xsl:if test="child::*[local-name()='AdmCat']">
				<span class="eh-field eh-label">Type tjeneste</span>
				<span class="eh-field">
					<xsl:for-each select="child::*[local-name()='AdmCat']">
						<xsl:call-template name="k-8240"/>
					</xsl:for-each>
				</span>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template name="SubOrg"> <!-- v1.0 only -->
		<div>
			<xsl:value-of select="child::*[local-name()='Name']"/>&#160;
			<span class="eh-strong">
				<xsl:choose>
					<xsl:when test="child::*[local-name()='TypeId']">
						<xsl:value-of select="child::*[local-name()='TypeId']"/>:</xsl:when>
					<xsl:otherwise>Id:</xsl:otherwise>
				</xsl:choose>
			</span>&#160;
			<xsl:value-of select="child::*[local-name()='Id']"/>
		</div>
	</xsl:template>


</xsl:stylesheet>
