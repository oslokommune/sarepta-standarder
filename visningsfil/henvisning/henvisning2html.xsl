<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    
Endringslogg
- 11.04.18: v4.1.8 - Noen endringer i overskrifter. Fikset bug hvor informasjon om nærmeste pårørende ikke ble vist. La til visning av Legemiddelgjennomgang fra poKomponent.
- 05.01.18: v4.1.7 - Tilpasset til Henvisning v2.0
- 20.06.17: v4.1.6 - Fjernt skillelinje under Helstjenesteenheter for avd. på samme. Erstattet hairspace med puncspace som mellomromtegn.
- 06.06.17: v4.1.5 - Adresse i Kontaktopplysninger: fjernet ledetekst type når adresse mangler.
- 17.03.17: v4.1.4 - Ny stil "Smooth".
- 07.03.17: v4.1.3 - Ny global parameter for "visningStil" fra kommando-linjen. Html/Css responsive.
- 07.02.17: v4.1.2 - Endret kodeverk fra 7319 til 8254 for v1.1 vedr. relasjonstype for helseperson.
- 13.01.16: v4.1.1 - Fix av CSS vedr. lang tekst i siste kolonne.
- 15.11.16: v4.1.0 - Inkluderer v2.0. Noe css-tilpasning for IE7/8.
- 26.10.16: v4.0.0 - Opprettet felles visning for alle versjonene av henvisning. (v1.0, v1.1)

Design:
- Responsive kollaps ved 767px bredde.
Om:
- Inngår i Direktoratet for e-helse visningsfiler
Forfatter:
- Jan Sigurd Dragsjø
 
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
	<xsl:import href="../felleskomponenter/cave2html.xsl"/>
	<xsl:import href="../felleskomponenter/journalnotat2html.xsl"/>
	<xsl:import href="../felleskomponenter/poKomponent2html.xsl"/>
	<xsl:import href="../felleskomponenter/eh-komponent1.xsl"/>
	<xsl:import href="../felleskomponenter/eh-komponent2.xsl"/>
	


	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="8"/>
	<xsl:variable name="std-td" select="100"/>
	<!-- Variabel for hvilken versjon av visningsfilen -->
	<xsl:variable name="versjon" select="'henvisning v.uavhengig - v4.1.8 '"/>

	<xsl:variable name="VisOvrigHelsetjenesteInfoVisSkjul" select="true()"/>
	<xsl:variable name="VisDokInfoVisSkjul" select="true()"/>
	<xsl:variable name="VisRefDokVisSkjul" select="true()"/>

	 <xsl:template match="/">
		<html>
			<head>
				<title>Henvisning</title>
				<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
				<style type="text/css">
					<xsl:value-of select="document('../felleskomponenter/KITH-visning.css')" disable-output-escaping="yes"/>
				</style>
				<style type="text/css">
					<xsl:value-of select="document('../felleskomponenter/ehelse-visning.css')" disable-output-escaping="yes"/>
				</style>
				<style type="text/css">
					<xsl:value-of select="document('../felleskomponenter/smooth-visning.css')" disable-output-escaping="yes"/>
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
		<xsl:call-template name="EgetBunnTillegg_v2"/>
	</xsl:template>

	<xsl:template name="Message">  <!-- v1.0, v1.1 -->
		<xsl:for-each select="child::*[local-name()='ServReq']">
			<!-- utelater meldingsid og kommunikasjonsinformasjon -->
			<xsl:call-template name="Header"/>
			<xsl:call-template name="ResultBody"/>
			<xsl:call-template name="eh-Footer">
				<xsl:with-param name="stil" select="$stil"/>
				<xsl:with-param name="versjon" select="$versjon"/>
				<xsl:with-param name="VisDokInfoVisSkjul" select="$VisDokInfoVisSkjul"/>
			</xsl:call-template>
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
			<span class="eh-strong">
				<xsl:for-each select="child::*[local-name()='TypeOffId']">
					<xsl:call-template name="k-8116"/>
				</xsl:for-each>:&#160;
			</span>
			<xsl:value-of select="child::*[local-name()='OffId']"/>&#160;
		</div>
		<xsl:if test="child::*[local-name()='DateOfDeath']">
			<div>
				<span class="eh-strong">Dødsdato:&#160;</span>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfDeath']/@V"/>
					<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
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
				<span class="eh-strong">Institusjon:&#160;</span>
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
			<span class="eh-strong">
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
			<xsl:call-template name="eh-TeleAddress"/>
		</xsl:for-each>
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
					<xsl:when test="namespace-uri() = 'http://ehelse.no/xmlstds/henvisning/2017-11-30'">
						<xsl:for-each select="child::*[local-name()='TypeInnholdIMelding']/child::*[local-name()='TypeInnhold']">
							<xsl:choose>
								<xsl:when test="contains(@S,'8455')"><xsl:call-template name="k-8455"/></xsl:when>
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
	
				<xsl:choose>
					<xsl:when test="//child::*[local-name()='ServReq']/child::*[local-name()='ReqComment']"> <!-- v1.0 og v1.1 -->
						<div class="eh-row-4">
							<span class="eh-label">Kommentar</span>
					    	<div class="eh-col-1 eh-last-child">
						    	<span class="eh-field">
							    	<xsl:call-template name="line-breaks">
								    	<xsl:with-param name="text" select="//child::*[local-name()='ServReq']/child::*[local-name()='ReqComment']"/>
								    </xsl:call-template>
							    </span>
						    </div>
					    </div>
				    </xsl:when>
					<xsl:otherwise>
						<xsl:if test="//child::*[local-name()='ReqComment']">
							<div class="eh-row-4">
								<div class="eh-col-1 eh-last-child">
									<span class="eh-label">Kommentar</span>
									<span class="eh-field">
										<xsl:call-template name="line-breaks">
											<xsl:with-param name="text" select="//child::*[local-name()='ReqComment']"/>
										</xsl:call-template>
									</span>
								</div>
							</div>
						</xsl:if>
						
					</xsl:otherwise>
				</xsl:choose>
					
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
						<xsl:call-template name="eh-ReasonAsText"/>
					</xsl:for-each>

					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='H' or child::*[local-name()='Type']/@V='B']">
						<xsl:for-each select="child::*[local-name()='ResultItem']">
							<xsl:call-template name="eh-ResultItem" />
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="eh-Medication" />
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="eh-Observation" />
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
							<xsl:call-template name="eh-ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="eh-Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="eh-Observation"/>
						</xsl:for-each>
						<!-- Men ResultItem og Medication er kankje ikke aktuell herfra siden rad-element mangler ?? -->
					</xsl:for-each> 
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Aktuell problemstilling -->
			<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='PROB'] or //child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='SYMP' or child::*[local-name()='Type']/@V='PROG' or child::*[local-name()='Type']/@V='SM']">
				<xsl:variable name="id30">
					<xsl:value-of select="concat('PROB',$position)"/>
				</xsl:variable>
				<h2 id="{$id30}">Aktuell problemstilling</h2>

				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='PROB']">
						<xsl:call-template name="eh-ReasonAsText"/>
					</xsl:for-each>
	
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='SYMP' or child::*[local-name()='Type']/@V='PROG' or child::*[local-name()='Type']/@V='SM']">
	
						<xsl:for-each select="child::*[local-name()='ResultItem']">
							<xsl:call-template name="eh-ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="eh-Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="eh-Observation"/>
						</xsl:for-each>
						<!-- Men ResultItem og Medication er kankje ikke aktuell herfra siden rad-element mangler ?? -->
					</xsl:for-each>
				</div>
			</xsl:if>
			<!-- Overskrift og tabell for Andre relevante tilstander -->
			<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='ART']">
				<xsl:variable name="id35">
					<xsl:value-of select="concat('ART',$position)"/>
				</xsl:variable>
				<h2 id="{$id35}">Andre relevante tilstander</h2>

				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='ART']">
						<xsl:call-template name="eh-ReasonAsText"/>
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
						<xsl:call-template name="eh-ReasonAsText"/>
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
							<xsl:call-template name="eh-ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="eh-Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="eh-Observation"/>
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
							<xsl:call-template name="eh-ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="eh-Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="eh-Observation"/>
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
						<xsl:call-template name="eh-ReasonAsText"/>
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
						<xsl:call-template name="eh-ReasonAsText"/>
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
						<xsl:call-template name="eh-ReasonAsText"/>
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
							<xsl:call-template name="eh-ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="eh-Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="eh-Observation"/>
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
						<xsl:call-template name="eh-Observation"/>
					</xsl:for-each>
					<!-- ORG <xsl:for-each select="//child::*[local-name()='ResultItem']">-->
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='FUNN']/child::*[local-name()='ResultItem']">
						<!-- <xsl:if test="position()=1">
							<div class="eh-row-8">
								<div class="eh-col-1 md eh-label">Under&#173;søkelse</div>
								<div class="eh-col-3 md eh-label">Funn/&#173;resultat</div>
								<xsl:if test="//child::*[local-name()='ResultItem']/child::*[local-name()='InvDate']">
									<div class="eh-col-1 md eh-label">Tidspunkt for under&#173;søkelsen</div>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='StartDateTime']">
									<div class="eh-col-1 md eh-label">Start&#173;tidspunkt</div>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='EndDateTime']">
									<div class="eh-col-1 md eh-label">Sluttidspunkt</div>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='OrgDate']">
									<div class="eh-col-1 md eh-label">Tidspunkt for opprinnelse</div>
								</xsl:if>
							</div>
						</xsl:if>
						-->
						<div class="eh-row-8">
							<xsl:call-template name="eh-ResultItem"/>
						</div>
					
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='FU']">
						<xsl:call-template name="eh-ReasonAsText"/>
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
						<div class="eh-row-8">
							<xsl:for-each select="child::*[local-name()='ResultItem']">
							<xsl:call-template name="eh-ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="eh-Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="eh-Observation"/>
						</xsl:for-each>
						</div>
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
						<xsl:call-template name="eh-ReasonAsText"/>
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
						<xsl:call-template name="eh-ReasonAsText"/>
					</xsl:for-each>
				</div>
			</xsl:if>

			<!-- Overskrift og tabell for Legemiddelopplysninger -->
			<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='MEDB'] or child::*[local-name()='Legemiddelgjennomgang']">
				<xsl:variable name="id150">
					<xsl:value-of select="concat('Medication',$position)"/>
				</xsl:variable>

				<h2 id="{$id150}">Legemiddelopplysninger</h2>

				<div class="eh-section">
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='MEDB']/child::*[local-name()='Observation']">
						<xsl:call-template name="eh-Observation"/>
					</xsl:for-each>
					<xsl:for-each select="//child::*[local-name()='InfItem'][child::*[local-name()='Type']/@V='MEDB']/child::*[local-name()='ResultItem']">
					<!-- 	<xsl:call-template name="eh-ResultItem"/> --><!-- Mangler rad-element for ResultItem -->
					</xsl:for-each>
	
					<xsl:for-each select="//child::*[local-name()='Medication']">
						<xsl:variable name="stripedCss">
							<xsl:choose>
								<xsl:when test="boolean(position() mod 2)">striped</xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!--		
						<xsl:if test="position()=1">
							<div class="eh-row-8">
								<div class="eh-col-1 md eh-label">Lege&#173;middel</div>
								<div class="eh-col-1 md eh-label">Status</div>
								<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='UnitDose'] or //child::*[local-name()='Medication']/child::*[local-name()='QuantitySupplied']">
									<div class="eh-col-1 md eh-label">Mengde</div>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='DosageText'] or //child::*[local-name()='Medication']/child::*[local-name()='IntendedDuration']">
									<div class="eh-col-1 md eh-label">
										<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='DosageText']">Dosering</xsl:if>
										<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='DosageText'] and //child::*[local-name()='Medication']/child::*[local-name()='IntendedDuration']">/</xsl:if>
										<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='IntendedDuration']">Varighet</xsl:if>
									</div>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='Comment']">
									<div class="eh-col-1 md eh-label">Kommentar</div>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='StartDateTime']">
									<div class="eh-col-1 md eh-label">Start&#173;tidspunkt</div>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='EndDateTime']">
									<div class="eh-col-1 md eh-label">Slut&#173;tidspunkt</div>
								</xsl:if>
								<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='OrgDate']">
									<div class="eh-col-1 md eh-label">Tidspunkt for opprinnelse</div>
								</xsl:if>
							</div>
						</xsl:if>
						-->
						<div class="eh-row-8 {$stripedCss}" >
							<xsl:call-template name="eh-Medication">
								<xsl:with-param name="striped">
									<xsl:choose>
										<xsl:when test="boolean(position() mod 2)"><xsl:value-of select="true()"/></xsl:when>
										<xsl:otherwise><xsl:value-of select="false()"/></xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</div>
					</xsl:for-each>
					
					<xsl:for-each select="child::*[local-name()='Legemiddelgjennomgang']">
						<div class="eh-row-4">
							<xsl:if test="child::*[local-name()='DatoLegemiddelgjennomgang']">
								<div class="eh-col-1">
									<span class="eh-label">Dato for siste legemiddelgjennomgang</span>
									<span class="eh-field">
										<xsl:call-template name="skrivUtDate">
											<xsl:with-param name="oppgittTid" select="child::*[local-name()='DatoLegemiddelgjennomgang']"/>
										</xsl:call-template>
									</span>
								</div>
							</xsl:if>
					
							<xsl:if test="child::*[local-name()='DatoSamstemming']">
								<div class="eh-col-1">
									<span class="eh-label">Dato for siste samstemming</span>
									<span class="eh-field">
										<xsl:call-template name="skrivUtDate">
											<xsl:with-param name="oppgittTid" select="child::*[local-name()='DatoSamstemming']"/>
										</xsl:call-template>
									</span>
								</div>
							</xsl:if>
					
							<xsl:if test="child::*[local-name()='Merknad']">
								<div class="eh-col-2 eh-last-child">
									<span class="eh-label">Merknad</span>
									<span class="eh-field">
										<xsl:call-template name="line-breaks">
											<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
										</xsl:call-template>
									</span>
								</div>
							</xsl:if>
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
						<xsl:call-template name="eh-ReasonAsText"/>
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
						<xsl:call-template name="eh-ReasonAsText"/>
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
							<xsl:call-template name="eh-ResultItem"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Medication']">
							<xsl:call-template name="eh-Medication"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Observation']">
							<xsl:call-template name="eh-Observation"/>
						</xsl:for-each>
						<!-- Men ResultItem og Medication er kankje ikke aktuell herfra siden rad-element mangler -->
					</xsl:for-each>
				</div>
			</xsl:if>
			  <!-- Pakkeforløp -->
		    <!-- Overskrift og tabell for pakkeforløp -->
			<xsl:if test="child::*[local-name()='Pakkeforlop']">
				<xsl:variable name="id185">
					<xsl:value-of select="concat('Pakkeforlop',$position)"/>
				</xsl:variable>
				<h2 id="{$id185}">Pakkeforløp</h2>
	
			<div class="eh-section">
				<xsl:for-each select="child::*[local-name()='Pakkeforlop']">
					<xsl:variable name="stripedCss">
						<xsl:choose>
							<xsl:when test="boolean(position() mod 2)">striped</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<div class="eh-row-8 {$stripedCss}" >
						<xsl:call-template name="eh-Pakkeforlop">
							<xsl:with-param name="striped">
								<xsl:choose>
									<xsl:when test="boolean(position() mod 2)"><xsl:value-of select="true()"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="false()"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</div>
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
						<div class="eh-row-5">
							<div class="eh-col-1 eh-last-child">
								<span class="eh-label">
									<xsl:choose>
										<xsl:when test="child::*[local-name()='Heading']">
											<xsl:for-each select="child::*[local-name()='Heading']">
												<xsl:call-template name="k-8234"/>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>Kommentar</xsl:otherwise>
									</xsl:choose>
								</span>
								<span class="eh-field">
									<xsl:if test="child::*[local-name()='TextResultValue']">
										<xsl:value-of select="child::*[local-name()='TextResultValue']"/>
									</xsl:if>
									<xsl:for-each select="child::*[local-name()='CodedComment']">
										<br/>
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
									</xsl:for-each>
								</span>
							</div>
						</div>
					</xsl:for-each>
				</div>
			</xsl:if>
		  


			<xsl:choose>
				<xsl:when test="namespace-uri() = 'http://ehelse.no/xmlstds/henvisning/2017-11-30'">
					<!--  v2.0 -->
					<!-- Overskrift og tabell for pasientopplysninger  -->
					<xsl:if test="child::*[local-name()='PatientPrecaution'] or child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='TilleggsopplysningPasient'] or ancestor::*[local-name()='Consent'] or child::*[local-name()='ParorendeForesatt'] or child::*[local-name()='InfoAssistertKommunikasjon'] or child::*[local-name()='PasientrelatertKontaktperson']">
						<xsl:variable name="id200"><xsl:value-of select="concat('PatientInformation',$position)"/></xsl:variable>
						<h2 id="{$id200}">Pasientopplysninger</h2>
						<div class="eh-section">
							<xsl:call-template name="PatientInformation"/>
						</div>
					</xsl:if>


					<!-- Overskrift og tabell for Kontaktopplysninger -->
					<xsl:if test="child::*[local-name()='TilknyttetEnhet'] or child::*[local-name()='KontaktpersonHelsepersonell'] or child::*[local-name()='AnsvarForRapport']">
						<xsl:variable name="id210"><xsl:value-of select="concat('PatRelHCP',$position)"/></xsl:variable>
						<h2 id="{$id210}">Kontaktopplysninger</h2>
						<xsl:if test="$VisOvrigHelsetjenesteInfoVisSkjul">
							<label for="vis{$id210}" class="VisSkjul">Vis/Skjul</label>
							<input type="checkbox" checked="true" id="vis{$id210}" style="display: none;"/>
						</xsl:if>
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
								<xsl:call-template name="Patient_v1"/>
							</div>
						</xsl:if>
					</xsl:for-each>

					<!-- Overskrift og tabell for Kontaktopplysninger -->
					<xsl:if test="child::*[local-name()='Patient']/child::*[local-name()='PatRelHCP']">
						<xsl:variable name="id210">
							<xsl:value-of select="concat('PatRelHCP',$position)"/>
						</xsl:variable>

						<h2 id="{$id210}">Kontaktopplysninger</h2>

						<xsl:if test="$VisOvrigHelsetjenesteInfoVisSkjul">
							<label for="vis{$id210}" class="VisSkjul">Vis/Skjul</label>
							<input type="checkbox" checked="true" id="vis{$id210}" style="display: none;"/>
						</xsl:if>
						
						<div class="eh-section xs">
							<xsl:call-template name="HealthCareProfessional_v1"/>
						</div>
					</xsl:if>

				</xsl:otherwise>
			</xsl:choose>

			<!-- Overskrift og tabell for henvisning mellom helseforetak -->
			<xsl:if test="child::*[local-name()='VurderingAvHenvisning']">
				<xsl:variable name="id215"><xsl:value-of select="concat('vurderingHenvisning',$position)"/></xsl:variable>
				<h2 id="{$id215}">Rettighetsvurdering</h2>
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

				<xsl:if test="$VisRefDokVisSkjul">
					<label for="vis{$id220}" class="VisSkjul">Vis/Skjul</label>
					<input type="checkbox" id="vis{$id220}" style="display: none;"/>
				</xsl:if>

				<div class="eh-section">
					<xsl:for-each select="child::*[local-name()='RefDoc']"> <!-- v1.0, v1.1 -->
						<xsl:call-template name="eh-RefDoc"/> 
					</xsl:for-each>

					<xsl:for-each select="//mh:RefDoc"> <!-- v2.0 -->
						<xsl:if test="position() != 1"> 
							<div class="eh-section">
								<xsl:call-template name="eh-msghead-RefDoc" /> 
							</div>
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
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
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
						<div class="eh-row-5">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Meldingsstatus</span>
						<span class="eh-field">
							<xsl:for-each select="//mh:Status">
								<xsl:call-template name="k-8419"/>
							</xsl:for-each>
						</span>	
					</div>
				</div>

	</xsl:template>

	<!-- Template som kalles fra BunnTillegg i meldingshodet. Kan brukes til visning av egenkomponert bunn -->
	<xsl:template name="EgetBunnTillegg_v2"> <!-- v2.0 -->
		<div class="{$stil}">	

			<h2>Dokumentinformasjon</h2>

			<xsl:if test="$VisDokInfoVisSkjul">
				<label for="visFooter" class="VisSkjul">Vis/Skjul</label>
				<input type="checkbox" checked="true" id="visFooter" style="display: none;"/>
			</xsl:if>

			<div class="eh-section">
				<div class="eh-row-5">
					<div class="eh-col-2">
						<span class="eh-label">Melding opprettet</span>
						<span class="eh-field">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="//mh:GenDate"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</span>
					</div>
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Meldingsid</span>
						<span class="eh-field">
							<xsl:value-of select="//mh:MsgId"/>
						</span>
					</div>
				</div>
				<div class="eh-row-5">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Visningsversjon</span>
						<span class="eh-field"><xsl:value-of select="$versjon"/></span>
					</div>
				</div>
				<xsl:if test="//child::*[local-name()='ProcessingStatus']">
					<div class="eh-row-1">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Meldingsstatus</span>
						<span class="eh-field">
							<xsl:for-each select="//child::*[local-name()='ProcessingStatus']">
								<xsl:call-template name="k-8113"/>
							</xsl:for-each>
						</span>	
					</div>
				</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="EgetBunnTillegg" /> <!-- v1.0, v1.1 -->
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
							<a href="#{$temp30}">Aktuell problemstilling</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()='ReasonAsText'][child::*[local-name()='Heading']/@V='ART']">
						<li>
							<xsl:variable name="temp35" select="concat('ART',$position)"/>
							<a href="#{$temp35}">Andre relevante tilstander</a>
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
							<a href="#{$temp150}">Legemiddelopplysninger</a>
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
					<xsl:if test="//child::*[local-name()='Pakkeforlop']">
						<li>
							<xsl:variable name="temp185" select="concat('Pakkeforlop',$position)"/>
							<a href="#{$temp185}">Pakkeforløp</a>
						</li>
					</xsl:if>
					<!-- <xsl:if test="//child::*[local-name()='ServReq']/child::*[local-name()='Comment']"> -->
					<xsl:if test="//child::*[local-name()='Comment']">
						<li>
							<xsl:variable name="temp190" select="concat('Comment',$position)"/>
							<a href="#{$temp190}">Kommentarer</a>
						</li>
					</xsl:if>
					
					<xsl:for-each select="//child::*[local-name()='Patient']">
					<!--
						<xsl:if test="child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='Sex'] or child::*[local-name()='DateOfBirth'] or child::*[local-name()='PatientPrecaution'] or child::*[local-name()='AssistertKommunikasjon'] or child::*[local-name()='ParorendeForesatt'] or child::*[local-name()='ContactPerson'] or child::*[local-name()='PatRelInst'] or child::*[local-name()='Consent'] or child::*[local-name()='AdditionalId'] or child::*[local-name()='NeedTranslator'] or child::*[local-name()='CareSituation']">
							<li>
								<xsl:variable name="temp200" select="concat('Patient',$position)"/>
								<a href="#{$temp200}">Pasient</a>
							</li>
						</xsl:if>
					-->
						<xsl:if test="child::*[local-name()='PatRelHCP']">
							<li>
								<xsl:variable name="temp210" select="concat('PatRelHCP',$position)"/>
								<a href="#{$temp210}">Kontaktopplysninger</a>
							</li>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="child::*[local-name()='PatientPrecaution'] or child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='TilleggsopplysningPasient'] or ancestor::*[local-name()='Document']/child::*[local-name()='Consent'] or child::*[local-name()='ParorendeForesatt'] or child::*[local-name()='InfoAssistertKommunikasjon'] or child::*[local-name()='PasientrelatertKontaktperson']">
						<li>
							<xsl:variable name="temp220" select="concat('PatientInformation',$position)"/>
							<a href="#{$temp220}">Pasientopplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="child::*[local-name()='TilknyttetEnhet'] or child::*[local-name()='KontaktpersonHelsepersonell'] or child::*[local-name()='AnsvarForRapport']">
						<li>
							<xsl:variable name="temp230" select="concat('PatRelHCP',$position)"/>
							<a href="#{$temp230}">Kontaktopplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="child::*[local-name()='VurderingAvHenvisning']">
						<li>
							<xsl:variable name="temp240" select="concat('vurderingHenvisning',$position)"/>
							<a href="#{$temp240}">Rettighetsvurdering</a>
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
		<div  class="eh-row-5">
			<div class="eh-col-1 eh-last-child">
				<span class="eh-label">
					<xsl:value-of select="child::*[local-name()='Concept']/@V"/>&#160;

					<xsl:if test="contains(child::*[local-name()='Concept']/@S, '7170')">(ICPC)</xsl:if>

					<xsl:if test="contains(child::*[local-name()='Concept']/@S, '7110')">(ICD-10)</xsl:if>
				</span>
				<span class="eh-field">
					<xsl:if test="child::*[local-name()='Concept']/@DN or child::*[local-name()='Concept']/@OT">
						<xsl:for-each select="child::*[local-name()='Concept']">
							<xsl:call-template name="k-dummy"/>
						</xsl:for-each>
					</xsl:if>

					<xsl:if test="child::*[local-name()='Modifier']"> <!-- maxOccurs="unbounded" -->
						<xsl:for-each select="child::*[local-name()='Modifier']/child::*[local-name()='Name']">
							<br/>
							<span class="eh-strong">
								<xsl:call-template name="k-7305"/>
							</span>
							&#160;<xsl:value-of select="../child::*[local-name()='Value']/@V"/>&#160;-&#160;<xsl:value-of select="../child::*[local-name()='Value']/@DN"/>
						</xsl:for-each>
					</xsl:if>
				</span>
			</div>
		</div>
	</xsl:template>

	<!-- Deprecated: erstattet av felleskomponenter/eh_komponent1.xsl : eh-ReasonAsText -->
	<xsl:template name="ReasonAsText"> <!-- maxOccurs="unbounded" -->

		<div  class="eh-row-4">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='Heading']/@V='BG' or  child::*[local-name()='Heading']/@V='BUP-BM' or child::*[local-name()='Heading']/@V='BUP-HG' or child::*[local-name()='Heading']/@V='KF' or child::*[local-name()='Heading']/@V='MAAL' or child::*[local-name()='Heading']/@V='MU' or child::*[local-name()='Heading']/@V='RU' or child::*[local-name()='Heading']/@V='UP'">
					<div class="eh-col-1 eh-label">
						<xsl:call-template name="k-8231"/>
						<xsl:if test="not(child::*[local-name()='Heading'])">Begrunnelse (uspes.)</xsl:if>
					</div>
				</xsl:when>
				<xsl:when test="not(child::*[local-name()='Heading'])">
					<div class="eh-col-1 eh-label">Begrunnelse (uspes.)</div>
				</xsl:when>
			</xsl:choose>

			<div class="eh-col-1 eh-field eh-last-child">

				<xsl:if test="child::*[local-name()='TextResultValue']">
					<div>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='TextResultValue']"/>
						</xsl:call-template>
					</div>
				</xsl:if>
				<xsl:for-each select="child::*[local-name()='TextCode'] | child::*[local-name()='TextCode']"> <!-- maxOccurs="unbounded" -->
					<xsl:if test="position() &gt; 1">
						<br/>
					</xsl:if>
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
				</xsl:for-each>

			</div>

		</div>
	</xsl:template>

	<!-- Deprecated: erstattet av felleskomponenter/eh-komponent1.xsl : eh-Observation -->
	<xsl:template name="Observation"> <!-- ServRec/Patient/InfItem/Observation -->
		<div class="eh-row-4">
			<xsl:variable name="cssClass">
				<xsl:choose>
					<xsl:when test="../child::*[local-name()='StartDateTime'] | ../child::*[local-name()='EndDateTime'] | ../child::*[local-name()='OrgDate']">
					</xsl:when>
					<xsl:otherwise>eh-last-child</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<div class="eh-col-1 {$cssClass}" >
				<span class="eh-field">
					<xsl:if test="child::*[local-name()='Description']">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Description']"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="child::*[local-name()='Description'] and child::*[local-name()='Comment']">
						<br/>
					</xsl:if>
					<xsl:if test="child::*[local-name()='Comment']">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
						</xsl:call-template>
					</xsl:if>
				</span>
			</div>

			<xsl:if test="../child::*[local-name()='StartDateTime'] | ../child::*[local-name()='EndDateTime'] | ../child::*[local-name()='OrgDate']">
				<div class="eh-col-1 eh-last-child">
					<span class="eh-field">
						<xsl:if test="../child::*[local-name()='StartDateTime']">
							Start:&#160;<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../child::*[local-name()='StartDateTime']"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="../child::*[local-name()='EndDateTime']">
							<xsl:if test="../child::*[local-name()='StartDateTime']">
								<br/>
							</xsl:if>
							Slutt:&#160;<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="../child::*[local-name()='EndDateTime']"/>
									<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
								</xsl:call-template>
						</xsl:if>
						<xsl:if test="../child::*[local-name()='OrgDate']">
							<xsl:if test="../child::*[local-name()='StartDateTime'] or ../child::*[local-name()='EndDateTime']">
								<br/>
							</xsl:if>
							Opprinnelse:&#160;<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="../child::*[local-name()='OrgDate']/@V"/>
									<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
								</xsl:call-template>
						</xsl:if>
					</span>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- Deprecated: erstattet av felleskomponenter/eh-komponent1.xsl : template eh-resultItem -->
	<xsl:template name="ResultItem"> <!-- merk: rad-element ikke inkludert her. Max 6 columns -->
		<div class="eh-col-1 eh-field">
			<xsl:for-each select="child::*[local-name()='ClinInv']">
				<xsl:for-each select="child::*[local-name()='Id']"> 	<!-- minOccurs="1" -->
					<xsl:call-template name="k-dummy"/>
				</xsl:for-each>
				<xsl:for-each select="child::*[local-name()='Spec']"> 	<!-- maxOccurs="unbounded" -->
					<br/>
					<span class="eh-strong">Spesifisert:</span>&#160;
					<xsl:call-template name="k-dummy"/>
				</xsl:for-each>
			</xsl:for-each>
		</div>

		<div class="eh-col-1 eh-field">
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
					<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
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
		</div>

		<xsl:if test="//child::*[local-name()='ResultItem']/child::*[local-name()='InvDate']"> 
			<div class="eh-col-1 eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()='InvDate']/@V"/>
					<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
				</xsl:call-template>
			</div>
		</xsl:if>


		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='StartDateTime']"> <!-- up one level : InfItem -->
			<div class="eh-col-1 eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='StartDateTime']"/>
					<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
				</xsl:call-template>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='EndDateTime']"> <!-- up one level : InfItem -->
			<div class="eh-col-1 eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='EndDateTime'] | ../child::*[local-name()='EndDateTime']"/>
					<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
				</xsl:call-template>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='OrgDate']"> <!-- up one level : InfItem -->
			<div class="eh-col-1 eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='OrgDate']/@V"/>
					<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- Deprecated: erstattet av felleskomponenter/eh-komponent1.xsl : eh-Medication -->
	<xsl:template name="Medication"> <!-- merk: rad-element ikke inkludert her. -->
		<div class="eh-col-1 eh-field">
			<xsl:for-each select="child::*[local-name()='DrugId']">
				<xsl:call-template name="k-dummy"/>
			</xsl:for-each>
		</div>

		<div class="eh-col-1 eh-field">
			<xsl:for-each select="child::*[local-name()='Status']">
				<xsl:call-template name="k-7307"/>
			</xsl:for-each>
		</div>

		<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='UnitDose'] or //child::*[local-name()='Medication']/child::*[local-name()='QuantitySupplied']">
			<div class="eh-col-1 eh-field">
				<xsl:if test="child::*[local-name()='UnitDose']">
					<xsl:value-of select="child::*[local-name()='UnitDose']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='UnitDose']/@U "/>
					<xsl:if test="child::*[local-name()='QuantitySupplied']">&#160;x&#160;</xsl:if>
				</xsl:if>
				<xsl:if test="child::*[local-name()='QuantitySupplied']">
					<xsl:value-of select="child::*[local-name()='QuantitySupplied']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='QuantitySupplied']/@U"/>
				</xsl:if>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='DosageText'] or //child::*[local-name()='Medication']/child::*[local-name()='IntendedDuration']">
			<div class="eh-col-1 eh-field">
				<xsl:if test="child::*[local-name()='DosageText']">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='DosageText']"/>
					</xsl:call-template>
				</xsl:if>&#160;
				<xsl:if test="child::*[local-name()='IntendedDuration']">&#160;/&#160;<xsl:value-of select="child::*[local-name()='IntendedDuration']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='IntendedDuration']/@U"/>
				</xsl:if>
				<xsl:if test="not(child::*[local-name()='DosageText']) and not(child::*[local-name()='IntendedDuration'])">&#160;</xsl:if>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='Comment']">
			<div class="eh-col-1 eh-field">
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
				</xsl:call-template>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='StartDateTime']">
			<div class="eh-col-1 eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='StartDateTime']/@V "/>
					<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
				</xsl:call-template>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='EndDateTime']">
			<div class="eh-col-1 eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='EndDateTime']/@V"/>
					<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
				</xsl:call-template>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='OrgDate']">
			<div class="eh-col-1 eh-field">
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="../child::*[local-name()='OrgDate']/@V"/>
					<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="PatientInformation"> <!-- Document/RefDoc/Content/Henvisning (v2.0) -->
		<xsl:if test="child::*[local-name()='PatientPrecaution']">
			<div class="eh-row-4">
				<div class="eh-col-1 eh-last-child">
					<span class="eh-label" style="color: red;">Advarsel</span>				
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='PatientPrecaution']"> <!-- maxOccurs="unbounded" -->
							<xsl:value-of select="child::*[local-name()='Precaution']"/>
							<xsl:if test="child::*[local-name()='StartDateTime'] or child::*[local-name()='EndDateTime']">
								(<xsl:if test="child::*[local-name()='StartDateTime']"><xsl:call-template name="skrivUtTS"><xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']/@V"/><xsl:with-param name="useNormalSpaceSeparator" select="true()"/></xsl:call-template></xsl:if>&#160;-&#160;<xsl:if test="child::*[local-name()='EndDateTime']"><xsl:call-template name="skrivUtTS"><xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']/@V"/></xsl:call-template></xsl:if>)
							</xsl:if>
							<xsl:if test="position()!=last()">,&#160;</xsl:if>
						</xsl:for-each>
					</span>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='TilleggsopplysningPasient'] or ancestor::*[local-name()='Document']/child::*[local-name()='Consent']">
			<div class="eh-row-4">
			
				<xsl:if test="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='BorAlene']">
					<div class="eh-col-1">
						<span  class="eh-label">Bostatus</span>
						<span class="eh-field">
							<xsl:choose>
								<xsl:when test="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='BorAlene']='true'">Bor alene</xsl:when>
								<xsl:otherwise>Bor ikke alene</xsl:otherwise>
							</xsl:choose>
						</span>
					</div>	
				</xsl:if>
				
				<xsl:if test="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='SivilStatus']">
					<div class="eh-col-1">
						<span  class="eh-label">Sivilstatus	</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='SivilStatus']">
								<xsl:call-template name="k-8724"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				
				<xsl:if test="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='Sprak']">
					<div class="eh-col-1">
						<span class="eh-label">Spr&#229;k</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='Sprak']">
								<xsl:call-template name="k-3303"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				
				<xsl:if test="child::*[local-name()='BasisForHealthServices']">
					<div class="eh-col-1">
						<span class="eh-label">Refusjonsgrunnlag</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='BasisForHealthServices']">
								<xsl:call-template name="k-8246"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				
			</div>
			<xsl:for-each select="child::*[local-name()='Consent']">
				<div class="eh-row-4">
					<div class="eh-col-1">
						<span class="eh-label">Samtykke gitt</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='ConsentStatus']">
								<xsl:choose>
									<xsl:when test="contains(@V,'9064')"><xsl:call-template name="k-9064"/></xsl:when>
									<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</span>
					</div>
					<!--Dato samtykke ble gitt-->
					<xsl:if test="child::*[local-name()='ConsentDate']">
						<div class="eh-col-1">	
							<span class="eh-label">Dato gitt</span>
							<span class="eh-field">
								<xsl:for-each select="child::*[local-name()='ConsentDate']">
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="."/>
										<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
									</xsl:call-template>
								</xsl:for-each>
							</span>
						</div>
					</xsl:if>
					<!--Samtykke gitt av-->
					<xsl:if test="child::*[local-name()='GivenBy']">
						<div class="eh-col-1">	
							<span class="eh-label">Samtykke gitt av</span>
							<span class="eh-field">
								<xsl:value-of select="child::*[local-name()='GivenBy']"/>
							</span>
						</div>
					</xsl:if>
					<!--Merknad-->
					<xsl:if test="child::*[local-name()='Merknad']">
						<div class="eh-col-1 eh-last-child">	
							<span class="eh-label">Merknad</span>
							<span class="eh-field">
								<xsl:value-of select="child::*[local-name()='Merknad']"/>
							</span>
						</div>
					</xsl:if>
				</div>
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='ParorendeForesatt']">
			<div class="eh-row-4">
				<div class="eh-col-1">
					<span class="eh-label">
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
				</div>
				<xsl:if test="child::*[local-name()='FodselsarMindrearigParorende']">
					<div class="eh-col-1">
						<span class="eh-label">Født</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='FodselsarMindrearigParorende']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='NarmesteParorende']">
					<div class="eh-col-1">
						<span class="eh-label">Nærmeste pårørende</span>
						<span class="eh-field">
							<xsl:choose>
								<xsl:when test="child::*[local-name()='NarmesteParorende']='true'">Ja</xsl:when>
								<xsl:otherwise>Nei</xsl:otherwise>
							</xsl:choose>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Merknad']">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Merknad</span>
						<span class="eh-field">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='InfoAssistertKommunikasjon']/child::*[local-name()='AssistertKommunikasjon']">
		    <div class="eh-row-4">
				<div  class="eh-col-4">
						<span class="eh-label">Assistert kommunikasjon</span>
						<span class="eh-field"></span>
				</div>
		    </div>
		    <div class="eh-row-4">
				<xsl:if test="child::*[local-name()='PersonTolkebehov']">
					<div class="eh-col-1">
						<span class="eh-label">Gjelder&#160;for</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='PersonTolkebehov']">
								<div class="No-line-content">
									<xsl:call-template name="Person"/>
								</div>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='BehovTolkSprak']">
					<div class="eh-col-1">
						<span class="eh-label">Språk</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='BehovTolkSprak']">
								<xsl:call-template name="k-3303"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='PreferertTolk']">
					<div class="eh-col-1">
						<span class="eh-label">Ønsket&#160;tolk</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='PreferertTolk']">
								<div class="No-line-content">
									<xsl:call-template name="Person"/>
								</div>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Horselsvikt'] or child::*[local-name()='Synsvikt'] or child::*[local-name()='BehovOpphortDato'] or child::*[local-name()='Merknad']">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Merknad</span>
						<span class="eh-field">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
							</xsl:call-template>
							<xsl:if test="child::*[local-name()='Horselsvikt']='true' or child::*[local-name()='Synsvikt']='true' or child::*[local-name()='BehovOpphortDato']">
								<xsl:if test="child::*[local-name()='Horselsvikt']='true'">
									<span class="eh-strong">Hørselsvikt:</span>&#160;Ja&#160;
								</xsl:if>
								<xsl:if test="child::*[local-name()='Synsvikt']='true'">
									<span class="eh-strong">Synsvikt:</span>&#160;Ja&#160;
								</xsl:if>
								<xsl:if test="child::*[local-name()='BehovOpphortDato']/@V">
									<span class="eh-strong">Behov&#160;opphørte:</span>&#160;
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="child::*[local-name()='BehovOpphortDato']/@V"/>
										<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
									</xsl:call-template>&#160;
								</xsl:if>
							</xsl:if>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='PasientrelatertKontaktperson']">
			<div class="eh-row-4">
				<div class="eh-col-1">
					<span class="eh-label">
						<xsl:value-of select="child::*[local-name()='StillingRolle']"/>
					</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Referanseperson']">
							<div class="No-line-content">
								<xsl:call-template name="Person"/>
							</div>
						</xsl:for-each>
					</span>
				</div>
				<xsl:if test="child::*[local-name()='Arbeidssted']">
					<div class="eh-col-1">
						<span class="eh-label">Arbeidssted</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='Arbeidssted']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Merknad']">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Merknad</span>
						<span class="eh-field">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="PatientInformation_test"> <!-- Document/RefDoc/Content/Henvisning (v2.0) -->
		<xsl:if test="child::*[local-name()='PatientPrecaution']">
			<div class="eh-row-4">
				<div class="eh-col-1 eh-last-child">
					<span class="eh-label" style="color: red;">Advarsel</span>				
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='PatientPrecaution']"> <!-- maxOccurs="unbounded" -->
							<xsl:value-of select="child::*[local-name()='Precaution']"/>
							<xsl:if test="child::*[local-name()='StartDateTime'] or child::*[local-name()='EndDateTime']">
								(<xsl:if test="child::*[local-name()='StartDateTime']"><xsl:call-template name="skrivUtTS"><xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']/@V"/><xsl:with-param name="useNormalSpaceSeparator" select="true()"/></xsl:call-template></xsl:if>&#160;-&#160;<xsl:if test="child::*[local-name()='EndDateTime']"><xsl:call-template name="skrivUtTS"><xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']/@V"/></xsl:call-template></xsl:if>)
							</xsl:if>
							<xsl:if test="position()!=last()">,&#160;</xsl:if>
						</xsl:for-each>
					</span>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='TilleggsopplysningPasient'] or ancestor::*[local-name()='Document']/child::*[local-name()='Consent']">
			<div class="eh-row-4">
				<xsl:if test="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='SivilStatus'] or child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='BorAlene']">
					<div class="eh-col-1">
						<span  class="eh-label">
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
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='Sprak']">
					<div class="eh-col-1">
						<span class="eh-label">Språk</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='TilleggsopplysningPasient']/child::*[local-name()='Sprak']">
								<xsl:call-template name="k-3303"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='BasisForHealthServices']">
					<div class="eh-col-1">
						<span class="eh-label">Refusjonsgrunnlag</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='BasisForHealthServices']">
								<xsl:call-template name="k-8246"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="ancestor::*[local-name()='Document']/child::*[local-name()='Consent']">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Samtykke gitt</span>
						<span class="eh-field">
							<xsl:for-each select="ancestor::*[local-name()='Document']/child::*[local-name()='Consent']">
								<xsl:choose>
									<xsl:when test="contains(@S,'3109')"><xsl:call-template name="k-3109"/></xsl:when>
									<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='ParorendeForesatt']">
			<div class="eh-row-4">
				<div class="eh-col-1">
					<span class="eh-label">
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
				</div>
				<xsl:if test="child::*[local-name()='FodselsarMindrearigParorende']">
					<div class="eh-col-1">
						<span class="eh-label">Født</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='FodselsarMindrearigParorende']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Merknad']">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Merknad</span>
						<span class="eh-field">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='InfoAssistertKommunikasjon']/child::*[local-name()='AssistertKommunikasjon']">
			<div class="eh-row-4">
				<span class="eh-label">Assistert kommunikasjon:</span>
				<xsl:if test="child::*[local-name()='PersonTolkebehov']">
					<div class="eh-col-1">
						<span class="eh-label">Gjelder&#160;for</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='PersonTolkebehov']">
								<div class="No-line-content">
									<xsl:call-template name="Person"/>
								</div>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='BehovTolkSprak']">
					<div class="eh-col-1">
						<span class="eh-label">Språk</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='BehovTolkSprak']">
								<xsl:call-template name="k-3303"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='PreferertTolk']">
					<div class="eh-col-1">
						<span class="eh-label">Ønsket&#160;tolk</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='PreferertTolk']">
								<div class="No-line-content">
									<xsl:call-template name="Person"/>
								</div>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Horselsvikt'] or child::*[local-name()='Synsvikt'] or child::*[local-name()='BehovOpphortDato'] or child::*[local-name()='Merknad']">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Merknad</span>
						<span class="eh-field">
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
											<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
										</xsl:call-template>&#160;
									</xsl:if>
								</div>
							</xsl:if>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='PasientrelatertKontaktperson']">
			<div class="eh-row-4">
				<div class="eh-col-1">
					<span class="eh-label">
						<xsl:value-of select="child::*[local-name()='StillingRolle']"/>
					</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Referanseperson']">
							<div class="No-line-content">
								<xsl:call-template name="Person"/>
							</div>
						</xsl:for-each>
					</span>
				</div>
				<xsl:if test="child::*[local-name()='Arbeidssted']">
					<div class="eh-col-1">
						<span class="eh-label">Arbeidssted</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='Arbeidssted']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Merknad']">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Merknad</span>
						<span class="eh-field">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="Patient_v1"> <!-- Message/ServReq/Patient (v1.0, v1.1) -->

		<xsl:if test="child::*[local-name()='BasisForHealthServices'] or child::*[local-name()='Sex'] or child::*[local-name()='DateOfBirth'] or child::*[local-name()='AdditionalId']">
			<div class="eh-row-8">
				<div class="eh-col-1 eh-label">Pasient&#173;info</div>
				<xsl:if test="child::*[local-name()='Name']">
					<div class="eh-col-1 md eh-label">Navn</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='OffId']">
					<div class="eh-col-1 md eh-label">
							<xsl:for-each select="child::*[local-name()='TypeOffId']">
								<xsl:call-template name="k-8116"/> 
							</xsl:for-each>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Sex']">
					<div class="eh-col-1 md eh-label">Kjønn</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='DateOfBirth']">
					<div class="eh-col-1 md eh-label">Fødsels&#173;dag</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='DateOfDeath']">
					<div class="eh-col-1 md eh-label">Dødsdag</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='BasisForHealthServices']">
					<div class="eh-col-1 md eh-label">Refusjons&#173;grunnlag</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='AdditionalId']">
					<div class="eh-col-1 md eh-last-child eh-label">Tilleggs-Id</div>
				</xsl:if>
			</div>
			<div class="eh-row-8">
				<div class="eh-col-1 md eh-label">&#160;</div>
				<xsl:if test="child::*[local-name()='Name']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Navn</span>
						<span class="eh-text">
							<xsl:value-of select="child::*[local-name()='Name']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='OffId']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">
							<xsl:for-each select="child::*[local-name()='TypeOffId']">
								<xsl:call-template name="k-8116"/> 
							</xsl:for-each>
						</span>
						<span class="eh-text">
							<xsl:value-of select="child::*[local-name()='OffId']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Sex']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Kjønn</span>
						<span class="eh-text">
							<xsl:for-each select="child::*[local-name()='Sex']">
								<xsl:call-template name="k-3101"/> 
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='DateOfBirth']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Fødselsdag</span>
						<span class="eh-text">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfBirth']"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='DateOfDeath']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Dødsdag</span>
						<span class="eh-text">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfDeath']"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='BasisForHealthServices']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Refusjonsgrunnlag</span>
						<span class="eh-text">
							<xsl:for-each select="child::*[local-name()='BasisForHealthServices']">
								<xsl:call-template name="k-8246"/> 
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='AdditionalId']">
					<div class="eh-col-1 eh-field eh-last-child">
						<span class="eh-label xs">Tilleggs-Id</span>
						<span class="eh-text">
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
					</div>
				</xsl:if>
			</div>
		</xsl:if>

		<xsl:for-each select="child::*[local-name()='PatientPrecaution']">
			<xsl:if test="position()=1">
				<div class="eh-row-8 md">
					<div class="eh-col-1 eh-last-child">
						<hr/>
					</div>
				</div>
				<div class="eh-row-8">
					<div class="eh-col-1 eh-label">Advarsel til tjenesteyter</div>
					<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='Precaution']">
						<div class="eh-col-1 md eh-label">Advarsel</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='StartDateTime']">
						<div class="eh-col-1 md eh-label">Start&#173;tidspunkt</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='EndDateTime']">
						<div class="eh-col-1 md eh-label">Slut&#173;tidspunkt</div>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row-8">
				<div class="eh-col-1 md eh-label">&#160;</div>
				<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='Precaution']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Advarsel</span>
						<span class="eh-text">
							<xsl:value-of select="child::*[local-name()='Precaution']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='StartDateTime']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Starttidspunkt</span>
						<span class="eh-text">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatientPrecaution']/child::*[local-name()='EndDateTime']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Sluttidspunkt</span>
						<span class="eh-text">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>

		<xsl:for-each select="child::*[local-name()='Consent']"> <!-- maxOccurs="1" -->
			<div class="eh-row-8 md">
				<div class="eh-col-1 eh-last-child">
					<hr/>
				</div>
			</div>
			<div class="eh-row-8">
				<div class="eh-col-1 eh-label">Samtykke</div>
				<xsl:if test="child::*[local-name()='ConsentStatus']">
					<div class="eh-col-1 md eh-label">Samtykke gitt</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='ConsentDate']">
					<div class="eh-col-1 md eh-label">Samtykkedato</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Merknad']">
					<div class="eh-col-1 md eh-label">Merknad</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='GivenBy']">
					<div class="eh-col-1 md eh-label eh-last-child">Gitt av</div>
				</xsl:if>
			</div>
			<div class="eh-row-8">
				<div class="eh-col-1 md eh-label">&#160;</div>
				<xsl:if test="child::*[local-name()='ConsentStatus']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Samtykke gitt</span>
						<span class="eh-text">
							<xsl:for-each select="child::*[local-name()='ConsentStatus']">
								<xsl:call-template name="k-3109"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='ConsentDate']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Samtykkedato</span>
						<span class="eh-text">
							<xsl:call-template name="skrivUtDate">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='ConsentDate']"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Merknad']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Merknad</span>
						<span class="eh-text">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='GivenBy']">
					<div class="eh-col-1 eh-field eh-last-child">
						<span class="eh-label xs">Gitt av</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='GivenBy']"/></span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>

		<xsl:for-each select="child::*[local-name()='AssistertKommunikasjon']"> <!-- v1.1, maxOccurs="unbounded" -->
			<xsl:if test="position()=1">
				<div class="eh-row-8 md">
					<div class="eh-col-1 eh-last-child">
						<hr/>
					</div>
				</div>
			</xsl:if>
			<xsl:call-template name="eh-AssistertKommunikasjon" />
		</xsl:for-each>

		<xsl:for-each select="child::*[local-name()='ParorendeForesatt']"> <!-- maxOccurs="unbounded" -->
			<xsl:if test="position()=1">
				<div class="eh-row-8 md">
					<span class="eh-col-1 eh-last-child" style="width: 100%;">
						<hr/>
					</span>
				</div>
				<div class="eh-row-8">
					<div class="eh-col-1 eh-label">Pårørende/&#173;foresatt</div>				
					<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Referanseperson']">
						<div class="eh-col-1 md eh-label">Person</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Slektskap']">
						<div class="eh-col-1 md eh-label">Slektskap</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Omsorgsfunksjon']">
						<div class="eh-col-1 md eh-label">Omsorgsfunksjon</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Merknad']">
						<div class="eh-col-1 md eh-label eh-last-child">Merknad</div>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row-8">
				<div class="eh-col-1 md eh-label">&#160;</div>
				<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Referanseperson']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Person</span>

						<span class="eh-text"><xsl:for-each select="child::*[local-name()='Referanseperson']">
								<div>
									<xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/>
								</div>
								<xsl:for-each select=".//fk1:TeleAddress">
									<xsl:call-template name="eh-TeleAddressHode"/>
								</xsl:for-each>
							</xsl:for-each></span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Slektskap']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Slektskap</span>
						<span class="eh-text"><xsl:for-each select="child::*[local-name()='Slektskap']">
								<xsl:call-template name="k-9033"/>&#160;
							</xsl:for-each></span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Omsorgsfunksjon']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Omsorgsfunksjon</span>
						<span class="eh-text"><xsl:for-each select="child::*[local-name()='Omsorgsfunksjon']">
							<xsl:call-template name="k-9050"/>&#160;
						</xsl:for-each></span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ParorendeForesatt']/child::*[local-name()='Merknad']">
					<div class="eh-col-1 eh-field eh-last-child">
						<span class="eh-label xs">Merknad</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='Merknad']"/></span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>

		<xsl:for-each select="child::*[local-name()='NeedTranslator']"> <!-- v1.0, maxOccurs="unbounded" -->
			<xsl:if test="position()=1">
				<div class="eh-row-8 md">
					<div class="eh-col-1 eh-last-child">
						<hr/>
					</div>
				</div>
				<div class="eh-row-8">
					<div class="eh-col-1 eh-label">Behov for tolk</div>
					<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='Person']">
						<div class="eh-col-1 md eh-label">Person-referanse</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='NeedTranslator'][child::*[local-name()='IsDeaf']/@V='true'] or ..//child::*[local-name()='NeedTranslator'][child::*[local-name()='IsBlind']/@V='true']">
						<div class="eh-col-1 md eh-label">Handikap</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='Language']">
						<div class="eh-col-1 md eh-label">Språk</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='PreferredTranslator']">
						<div class="eh-col-1 md eh-label">Referanse til foretrukket tolk</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='TranslatorEndDate']">
						<div class="eh-col-1 md eh-label">Behov opphørt dato</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='Note']">
						<div class="eh-col-1 md eh-label eh-last-child">Merknad</div>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row-8">
				<div class="eh-col-1 md eh-label">&#160;</div>
				<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='Person']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Person-referanse</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='Person']"/></span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='NeedTranslator'][child::*[local-name()='IsDeaf']/@V='true'] or ..//child::*[local-name()='NeedTranslator'][child::*[local-name()='IsBlind']/@V='true']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Handikap</span>
						<span class="eh-text">
							<xsl:if test="child::*[local-name()='IsDeaf']/@V='true'">Døv</xsl:if>
							<xsl:if test="child::*[local-name()='IsDeaf']/@V='true' and child::*[local-name()='IsBlind']/@V='true'">&#160;og&#160;</xsl:if>
							<xsl:if test="child::*[local-name()='IsBlind']/@V='true'">Blind</xsl:if>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='Language']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Språk</span>
						<span class="eh-text">
							<xsl:for-each select="child::*[local-name()='Language']">
								<xsl:call-template name="k-3303"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='PreferredTranslator']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Referanse til foretrukket tolk</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='PreferredTranslator']"/></span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='TranslatorEndDate']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Behov opphørt dato</span>
						<span class="eh-text">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='TranslatorEndDate']/@V"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='NeedTranslator']/child::*[local-name()='Note']">
					<div class="eh-col-1 eh-field eh-last-child">
						<span class="eh-label xs">Merknad</span>
						<span class="eh-text">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()='Note']"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>

		<xsl:for-each select="child::*[local-name()='CareSituation']"> <!-- v1.0, maxOccurs="1"-->
			<xsl:if test="position()=1">
				<div class="eh-row-8 md">
					<div class="eh-col-1 eh-last-child">
						<hr/>
					</div>
				</div>
				<div class="eh-row-8">
					<div class="eh-col-1 eh-label">Omsorgs&#173;situasjon</div>
					<xsl:if test="child::*[local-name()='CustodyType']">
						<div class="eh-col-1 md eh-label">Foreldreansvar</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()='CareSituationType']">
						<div class="eh-col-1 md eh-label">Type omsorgssituasjon</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()='NativeLanguage']">
						<div class="eh-col-1 md eh-label">Hjemmespråk</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()='Description']">
						<div class="eh-col-3 md eh-label eh-last-child">Beskrivelse</div>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row-8">
				<div class="eh-col-1 md eh-label">&#160;</div>
				<xsl:if test="child::*[local-name()='CustodyType']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Foreldreansvar</span>
						<span class="eh-text">
							<xsl:for-each select="child::*[local-name()='CustodyType']">
								<xsl:call-template name="k-9513"/>&#160;
							</xsl:for-each>
							<xsl:if test="child::*[local-name()='CustodyOwner']">
								<xsl:value-of select="child::*[local-name()='CustodyOwner']"/>
							</xsl:if>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='CareSituationType']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Type omsorgssituasjon</span>
						<span class="eh-text">
							<xsl:for-each select="child::*[local-name()='CareSituationType']">
								<xsl:call-template name="k-3105"/>&#160;
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='NativeLanguage']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Hjemmespråk</span>
						<span class="eh-text">
							<xsl:for-each select="child::*[local-name()='NativeLanguage']">
								<xsl:call-template name="k-8417"/>&#160;
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Description']">
					<div class="eh-col-3 eh-field eh-last-child">
						<span class="eh-label xs">Beskrivelse</span>
						<span class="eh-text">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()='Description']"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>

		<xsl:for-each select="child::*[local-name()='PatRelperson']"> <!-- maxOccurs="unbounded" -->
			<xsl:if test="position()=1">
				<div class="eh-row-4 md">
					<div class="eh-col-1 eh-last-child" style="width: 100%;">
						<hr/>
					</div>
				</div>
				<div class="eh-row-8">
					<div class="eh-col-1 eh-label">Referert person</div>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Relation'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='Description']">
						<div class="eh-col-1 md eh-label">Relasjon/beskrivelse</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Name']">
						<div class="eh-col-1 md eh-label">Navn</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='OffId']">
						<div class="eh-col-1 md eh-label">Offentlig id</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Sex'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='EthnicBelonging'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='DateOfBirth']">
						<div class="eh-col-1 md eh-label">Personlige opplysninger</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Occupation'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='Role']">
						<div class="eh-col-1 md eh-label">Stilling/annen rolle</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Consent']">
						<div class="eh-col-1 md eh-label">Samtykke</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Address']">
						<div class="eh-col-1 md eh-label">Adresse</div>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row-8">
				<div class="eh-col-1 md el-label">&#160;</div>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Relation'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='Description']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Relasjon/beskrivelse</span>
						<span class="eh-text">
							<xsl:if test="child::*[local-name()='Relation']/child::*[local-name()='Guardien']/@V='true'">
								<span class="eh-strong">Foresatt: </span>
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
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Name']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Navn</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='Name']"/></span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='OffId']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Offentlig id</span>
						<span class="eh-text">
							<span class="eh-strong">
								<xsl:for-each select="child::*[local-name()='TypeOffId']">
									<xsl:call-template name="k-8116"/>
								</xsl:for-each>
							</span>&#160;
							<xsl:value-of select="child::*[local-name()='OffId']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Sex'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='EthnicBelonging'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='DateOfBirth']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Personlige opplysninger</span>
						<span class="eh-text">
							<xsl:if test="child::*[local-name()='Sex']">
								<span class="eh-label">Kjønn: </span>
								<xsl:for-each select="child::*[local-name()='Sex']">
									<xsl:call-template name="k-3101"/>
								</xsl:for-each>
								<xsl:if test="child::*[local-name()='EthnicBelonging'] or child::*[local-name()='DateOfBirth']">, </xsl:if>
							</xsl:if>
							<xsl:if test="child::*[local-name()='EthnicBelonging']">
								<xsl:for-each select="child::*[local-name()='EthnicBelonging']">
									<xsl:call-template name="k-8423"/>
								</xsl:for-each>
								<xsl:if test="child::*[local-name()='DateOfBirth']">, </xsl:if>
							</xsl:if>
							<xsl:if test="child::*[local-name()='DateOfBirth']">
								<span class="eh-label">født: </span>
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateOfBirth']/@V"/>
									<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
								</xsl:call-template>
							</xsl:if>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Occupation'] or ..//child::*[local-name()='PatRelperson']/child::*[local-name()='Role']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Stilling/annen rolle</span>
						<span class="eh-text">
							<xsl:choose>
								<xsl:when test="child::*[local-name()='Occupation']/@DN">
									<xsl:value-of select="child::*[local-name()='Occupation']/@DN"/>
								</xsl:when>
								<xsl:otherwise>
									<span class="eh-strong">Stillingskode: </span><xsl:value-of select="child::*[local-name()='Occupation']/@V"/>
								</xsl:otherwise>
							</xsl:choose>&#8200;
							<xsl:value-of select="child::*[local-name()='Role']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Consent']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Samtykke</span>
						<span class="eh-text">
							<xsl:for-each select="child::*[local-name()='Consent']">
								<xsl:if test="child::*[local-name()='ConsentStatus']">
									<span class="eh-label">Samtykke gitt: </span>
									<xsl:for-each select="child::*[local-name()='ConsentStatus']">
										<xsl:call-template name="k-3109"/>
									</xsl:for-each>&#8200;
								</xsl:if>
								<xsl:if test="child::*[local-name()='ConsentDate']">
									<span class="eh-label">Dato: </span>
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="child::*[local-name()='ConsentDate']/@V"/>
										<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="child::*[local-name()='Merknad']">
									<div>
										<span class="eh-label">Merknad: </span>&#160;<xsl:call-template name="line-breaks">
											<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
										</xsl:call-template>
									</div>
								</xsl:if>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelperson']/child::*[local-name()='Address']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Adresse</span>
						<span class="eh-text">
							<xsl:for-each select="child::*[local-name()='Address']">
								<xsl:call-template name="Address" />
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>

		<xsl:for-each select="child::*[local-name()='ContactPerson']">
			<xsl:if test="position()=1">
				<div class="eh-row-8 md">
					<div class="eh-col-1 eh-last-child">
						<hr/>
					</div>
				</div>
				<div class="eh-row-8">
					<div class="eh-col-1 eh-label">Kontaktperson</div>
					<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='Referanseperson']">
						<div class="eh-col-1 md eh-label">Person</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='OccupationRole']">
						<div class="eh-col-1 md eh-label">Stilling/rolle</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='WorkingPlace']">
						<div class="eh-col-1 md eh-label">Arbeidssted</div>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='Merknad']">
						<div class="eh-col-1 md eh-label eh-last-child">Merknad</div>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row-8">
				<div class="eh-col-1 md eh-label">&#160;</div>
				<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='Referanseperson']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Person</span>
						<span class="eh-text">
							<xsl:for-each select="child::*[local-name()='Referanseperson']">
								<div>
									<xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/>
								</div>
								<xsl:for-each select=".//fk1:TeleAddress">
									<xsl:call-template name="eh-TeleAddressHode"/>
								</xsl:for-each>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='OccupationRole']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Stilling/rolle</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='OccupationRole']"/></span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='WorkingPlace']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Arbeidssted</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='WorkingPlace']"/></span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='ContactPerson']/child::*[local-name()='Merknad']">
					<div class="eh-col-1 eh-field eh-last-child">
						<span class="eh-label xs">Merknad</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='Merknad']"/></span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>

		<xsl:for-each select="child::*[local-name()='PatRelInst']">
			<xsl:if test="position()=1">
				<div class="eh-row-8 md">
					<div class="eh-col-1">
						<hr/>
					</div>
				</div>
				<div class="eh-row-8">
					<div class="eh-col-1 eh-label">Referert virksomhet</div>
					<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='NameInst']">
						<span class="eh-col-1 md eh-label">Navn</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='WorkingTime']">
						<span class="eh-col-1 md eh-label">Arbeidstid</span> <!-- v1.0 -->
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='RoleInst']">
						<span class="eh-col-1 md eh-label">Rolle</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='ContactPerson']">
						<span class="eh-col-1 md eh-label">Kontaktperson</span>
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='Address']">
						<span class="eh-col-1 md eh-label">Adresse</span> <!-- v1.0 -->
					</xsl:if>
					<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='Merknad']">
						<span class="eh-col-1 md eh-label eh-last-child">Merknad</span>
					</xsl:if>
				</div>
			</xsl:if>
			<div class="eh-row-8">
				<div class="eh-col-1 md eh-label">&#160;</div>
				<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='NameInst']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Navn</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='NameInst']"/></span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='WorkingTime']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Arbeidstid</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='WorkingTime']"/></span> <!-- v1.0 -->
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='RoleInst']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Rolle</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='RoleInst']"/></span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='ContactPerson']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Kontaktperson</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='ContactPerson']"/></span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='Address']">
					<div class="eh-col-1 eh-field">
						<span class="eh-label xs">Adresse</span>
						<span class="eh-text">
							<xsl:for-each select="child::*[local-name()='Address']" > <!-- v1.0 -->
								<xsl:call-template name="Address" />
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='PatRelInst']/child::*[local-name()='Merknad']">
					<div class="eh-col-1 eh-field eh-last-child">
						<span class="eh-label xs">Merknad</span>
						<span class="eh-text"><xsl:value-of select="child::*[local-name()='Merknad']"/></span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="HealthCareProfessional_v1">
		<div class="eh-row-8">
			<xsl:if test="//child::*[local-name()='PatRelHCP']/child::*[local-name()='Relation']">
				<div class="eh-col-1 md eh-label">Pasientrelasjon</div>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='HCProf'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='HCPerson'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept']">
				<div class="eh-col-1 md eh-label">
					<xsl:choose>
						<xsl:when test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept'] and (//child::*[local-name()='PatRelHCP']//child::*[local-name()='HCProf'] or //child::*[local-name()='PatRelHCP']//child::*[local-name()='HCPerson'])">Person/avd.</xsl:when>
						<xsl:when test="not(//child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept'])">Person</xsl:when>
						<xsl:otherwise>Avdeling</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='HCProf']/child::*[local-name()='Id'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='HCProf']/child::*[local-name()='AdditionalId'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='HCPerson']/child::*[local-name()='Id'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='HCPerson']/child::*[local-name()='AdditionalId'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept']/child::*[local-name()='Id'] | //child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept']/child::*[local-name()='AdditionalId']">
				<div class="eh-col-1 md eh-label">Id</div>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='Inst']/child::*[local-name()='Name']">
				<div class="eh-col-1 md eh-label">Institusjon</div>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='MedSpeciality']">
				<div class="eh-col-1 md eh-label">Medisinsk spesialitet</div>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='Inst']/child::*[local-name()='Id']">
				<div class="eh-col-1 md eh-label">Institusjon-id</div>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']/child::*[local-name()='StartDateTime'] | //child::*[local-name()='PatRelHCP']/child::*[local-name()='EndDateTime']">
				<div class="eh-col-1 md eh-label">Tidsrom</div>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='Address']">
				<div class="eh-col-1 md eh-label eh-last-child">Kontaktinformasjon</div>
			</xsl:if>
		</div>
		<xsl:for-each select="child::*[local-name()='Patient']/child::*[local-name()='PatRelHCP']">
			<xsl:call-template name="PatRelHCP"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="HealthCareProfessional_v2">
		<xsl:for-each select="child::*[local-name()='TilknyttetEnhet']">
			<div class="eh-row-4">
				<div  class="eh-col-1">
					<span class="eh-label">Tilknyttet enhet</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Kontaktenhet']">
							<xsl:call-template name="TilknyttetEnhet"/>
						</xsl:for-each>
					</span>
				</div>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='KontaktPersonHelsepersonell']">
			<div class="eh-row-4">
				<div  class="eh-col-1">
					<span class="eh-label">Tilknyttet helseperson</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Kontaktperson']">
							<xsl:for-each select="child::*[local-name()='HealthcareProfessional']">
								<xsl:call-template name="HealthcareProfessional"/>
							</xsl:for-each>
						</xsl:for-each>
					</span>
				</div>
				<xsl:if test="child::*[local-name()='Merknad']">
					<div  class="eh-col-1 eh-last-child">
						<span class="eh-label">Merknad</span>
						<span class="eh-field">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()='AnsvarForRapport']">
			<div class="eh-row-4">
				<div class="eh-col-1">
					<!-- <span class="eh-label">Ansvarlig for rapport</span> -->
					<!-- <span class="eh-field"> -->
						<span class="eh-label">
						<xsl:for-each select="child::*[local-name()='TypeRelasjon']">
							<xsl:choose>
								<xsl:when test="contains(@S,'8254')"><xsl:call-template name="k-8254"/>&#160;</xsl:when>
								<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						</span>
						 <span class="eh-field"> 
						<xsl:for-each select="child::*[local-name()='AnsvarligRapport']">
							<br/>
							<xsl:call-template name="HealthcareProfessional"/>
						</xsl:for-each>
					</span>
				</div>
				<xsl:if test="child::*[local-name()='Merknad'] or child::*[local-name()='GodkjentDato']">
					<div class="eh-col-1 eh-last-child">
						<span  class="eh-label">
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
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="VurderingAvHenvisning">
		<xsl:for-each select="child::*[local-name()='Opplysninger']">
			<div class="eh-row-7">
				<xsl:if test="child::*[local-name()='FrittSykehusvalg']">
					<div class="eh-col-1">
						<span class="eh-label">Fritt sykehusvalg</span>
						<span class="eh-field">
							<xsl:choose>
								<xsl:when test="child::*[local-name()='FrittSykehusvalg']='true'">Benyttes</xsl:when>
								<xsl:otherwise>Benyttes ikke</xsl:otherwise>
							</xsl:choose>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='VentetidSluttkode']">
					<div class="eh-col-1">
						<span class="eh-label">Ventetid sluttkode</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='VentetidSluttkode']">
								<xsl:choose>
									<xsl:when test="contains(@S,'8445')"><xsl:call-template name="k-8445"/>&#160;</xsl:when>
									<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Omsorgsniva']">
					<div class="eh-col-1">
						<span class="eh-label">Omsorgsnivå</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='Omsorgsniva']">
								<xsl:choose>
									<xsl:when test="contains(@S,'8406')"><xsl:call-template name="k-8406"/>&#160;</xsl:when>
									<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='ForlopsId']">
					<div class="eh-col-1">
						<span class="eh-label">Forløps-id</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='ForlopsId']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='RettTilHelsehjelp']">
					<div class="eh-col-1">
						<span class="eh-label">Rett til helsehjelp</span>
						<span class="eh-field">
							<xsl:choose>
								<xsl:when test="child::*[local-name()='RettTilHelsehjelp']='true'">Ja</xsl:when>
								<xsl:otherwise>Nei</xsl:otherwise>
							</xsl:choose>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='UtfallAvVurdering']">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Utfall av vurdering</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='UtfallAvVurdering']">
								<xsl:choose>
									<xsl:when test="contains(@S,'8485')"><xsl:call-template name="k-8485"/>&#160;</xsl:when>
									<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:for-each>
		<xsl:if test="child::*[local-name()='DatoMottakOgVurdering']">
			<div class="eh-row-4">
				<xsl:for-each select="child::*[local-name()='DatoMottakOgVurdering']"> <!-- kodeverk: max 4 varianter -->
					<div class="eh-col-1">
						<span class="eh-label">
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
					</div>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="PatRelHCP"> <!-- Message/ServReq/Patient/PatRelHCP  maxOccurs="unbounded" (1.0, 1.1) -->

		<xsl:variable name="raw-rows" select="count(.//child::*[local-name()='HCProf'] | .//child::*[local-name()='HCPerson'] | .//child::*[local-name()='Dept'])"/>
		<xsl:variable name="rows">
			<xsl:choose>
				<xsl:when test="$raw-rows&gt;0">
					<xsl:value-of select="$raw-rows"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="cssDocRow" >
			<xsl:if test="count(.//child::*[local-name()='HCProf'] | .//child::*[local-name()='HCPerson'] | .//child::*[local-name()='Dept']) &gt; 1">DocRow</xsl:if>
		</xsl:variable>
		
		<div class="eh-row-8 {$cssDocRow}">
			<xsl:if test="..//child::*[local-name()='PatRelHCP']/child::*[local-name()='Relation']">
				<div class="eh-col-1 eh-field">
					<span class="xs eh-label">Pasientrelasjon</span>
					<span class="eh-text">
						<xsl:for-each select="child::*[local-name()='Relation']">
							<xsl:choose>
								<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/henvisning/2012-02-15'">
									<xsl:call-template name="k-8254"/> <!-- v1.1 -->
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="k-7319"/> <!-- v1.0 -->
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</span>
				</div>
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
						<div class="eh-col-1 eh-field">&#160;</div>
						<div class="eh-col-1 eh-field">&#160;</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='PatRelHCP']//child::*[local-name()='Inst']/child::*[local-name()='Name']">
				<div class="eh-col-1 eh-field">
					<span class="eh-label xs">Institusjon</span>
					<span class="eh-text"><xsl:value-of select=".//child::*[local-name()='Inst']/child::*[local-name()='Name']"/></span>
				</div>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='PatRelHCP']//child::*[local-name()='MedSpeciality']">
				<div class="eh-col-1 eh-field">
					<span class="eh-label xs">Medisinsk spesialitet</span>
					<span class="eh-text">
						<xsl:for-each select=".//child::*[local-name()='MedSpeciality']">
							<xsl:call-template name="k-8451"/>&#160;
						</xsl:for-each>
					</span>
				</div>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='PatRelHCP']//child::*[local-name()='Inst']/child::*[local-name()='Id']">
				<div class="eh-col-1 eh-field">
					<span class="eh-label xs">Institusjon-id</span>
					<span class="eh-text">
						<xsl:if test=".//child::*[local-name()='Inst']/child::*[local-name()='TypeId']/@V">
							<span class="eh-strong">
								<xsl:value-of select=".//child::*[local-name()='Inst']/child::*[local-name()='TypeId']/@V"/>:
							</span>
						</xsl:if>&#160;
						<xsl:value-of select=".//child::*[local-name()='Inst']/child::*[local-name()='Id']"/>
					</span>
				</div>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='PatRelHCP']//child::*[local-name()='StartDateTime'] | ..//child::*[local-name()='PatRelHCP']//child::*[local-name()='EndDateTime']">
				<div class="eh-col-1 eh-field">
					<span class="eh-label xs">Tidsrom</span>
					<span class="eh-text">
						<xsl:if test="child::*[local-name()='StartDateTime']">
							<span class="eh-strong">Start:</span>&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</xsl:if>&#160;
						<xsl:if test="child::*[local-name()='EndDateTime']">
							<div>
								<span class="eh-strong">Slutt:</span>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']"/>
									<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
								</xsl:call-template>
							</div>
						</xsl:if>
					</span>
				</div>
			</xsl:if>
			<xsl:if test=".//child::*[local-name()='Address']">
				<div class="eh-col-1 eh-field">
					<span class="eh-label xs">Kontaktinformasjon</span>
					<span class="eh-text">
						<xsl:for-each select=".//child::*[local-name()='Address']">
							<xsl:call-template name="eh-Address"/>
						</xsl:for-each>
					</span>
				</div>
			</xsl:if>
		</div>

		<xsl:for-each select=".//child::*[local-name()='HCProf'] | .//child::*[local-name()='HCPerson'] | .//child::*[local-name()='Dept']">
			<xsl:if test="position()!=1">
				<div class="eh-row-8" style="margin-top: 0;">
					<div class="eh-col-1 eh-label DocRow">&#160;</div>
					<xsl:call-template name="HCProf_HCPerson_Dept" />
					<div class="eh-col-1 eh-field DocRow">&#160;</div>
					<div class="eh-col-1 eh-field DocRow">&#160;</div>
				</div>
			</xsl:if>
		</xsl:for-each>

	</xsl:template>

	<xsl:template name="HCProf_HCPerson_Dept"> <!-- "h:HCProf | h:HCPerson | h:Dept" -->
		<div class="eh-col-1 eh-field">
			<span class="eh-label xs">
				<xsl:choose>
					<xsl:when test="//child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept'] and (//child::*[local-name()='PatRelHCP']//child::*[local-name()='HCProf'] or //child::*[local-name()='PatRelHCP']//child::*[local-name()='HCPerson'])">Person/avd.</xsl:when>
					<xsl:when test="not(//child::*[local-name()='PatRelHCP']//child::*[local-name()='Dept'])">Person</xsl:when>
					<xsl:otherwise>Avdeling</xsl:otherwise>
				</xsl:choose>
			</span>
			<span class="eh-text">
				<xsl:if test="child::*[local-name()='Type']/@DN">
					<span class="eh-strong">
						<xsl:value-of select="child::*[local-name()='Type']/@DN"/>&#8200;
					</span>
				</xsl:if>
				<xsl:value-of select="child::*[local-name()='Name']"/>
			</span>
		</div>
		<div class="eh-col-1 eh-field">
			<span class="eh-label xs">Id</span>
			<span class="eh-text">
				<xsl:if test="child::*[local-name()='TypeId']/@V">
					<span class="eh-strong">
						<xsl:value-of select="child::*[local-name()='TypeId']/@V"/>:
					</span>
				</xsl:if>
				<xsl:value-of select="child::*[local-name()='Id']"/>
			</span>
		</div>
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
			<xsl:if test="child::*[local-name()='StreetAdr']">, </xsl:if>
			<xsl:value-of select="child::*[local-name()='PostalCode']"/>&#8200;<xsl:value-of select="child::*[local-name()='City']"/>
		</xsl:if>
		<xsl:if test="child::*[local-name()='CityDistr']">, <xsl:for-each select="child::*[local-name()='CityDistr']">
				<xsl:call-template name="k-3403"/>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="child::*[local-name()='County']">, <xsl:for-each select="child::*[local-name()='County']">
				<xsl:call-template name="k-3402"/>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Country']">, <xsl:for-each select="child::*[local-name()='Country']">
				<xsl:call-template name="k-9043"/>
			</xsl:for-each>
		</xsl:if>
		&#160;
		<xsl:for-each select="child::*[local-name()='TeleAddress']">
			<xsl:call-template name="eh-TeleAddressHode"/>
		</xsl:for-each>
	</xsl:template>

	<!-- Visning av vedlegg -->
	<!-- Deprecated: se felleskomponenter/eh-komponent1.xsl : eh-RefDoc -->
	<xsl:template name="RefDoc"> <!-- v1.0 og v1.1 only. (v1.0 har ikke selve vedlegget). v2.0 : se meldinshode2html.xsl. -->
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()='MsgType'] or child::*[local-name()='Id'] or child::*[local-name()='IssueDate'] or child::*[local-name()='MimeType'] or child::*[local-name()='Compression']">
			<div class="eh-row-5">
				<xsl:if test="child::*[local-name()='MsgType']">
					<div class="eh-col-1">
						<span class="eh-label">Type</span>
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
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Id']">
					<div class="eh-col-1">
						<span class="eh-label">Id</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='Id']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='IssueDate']">
					<div class="eh-col-1">
						<span class="eh-label">Utstedt-dato</span>
						<span class="eh-field blk">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='IssueDate']/@V"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>

				<xsl:if test="child::*[local-name()='MimeType']">
					<div class="eh-col-1">
						<span class="eh-label">Mimetype</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='MimeType']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Compression']">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Komprimering</span>
						<span class="eh-field blk">
							<xsl:for-each select="child::*[local-name()='Compression']">
								<xsl:call-template name="k-1204"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
			</div>
			<xsl:if test="child::*[local-name()='Booking']"> <!-- v1.0 only -->
				<div class="eh-row-4">
					<div class="eh-col-1">
						<span class="eh-label">Booking</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='Booking']">
								<xsl:value-of select="child::*[local-name()='Name']"/>&#8200;
								<span class="eh-strong">
									<xsl:choose>
										<xsl:when test="child::*[local-name()='TypeId']/@V">
											<xsl:value-of select="child::*[local-name()='TypeId']/@V"/>:</xsl:when>
										<xsl:otherwise>Id:</xsl:otherwise>
									</xsl:choose>
								</span>&#8200;
								<xsl:value-of select="child::*[local-name()='Id']"/>
								<xsl:for-each select=".//child::*[local-name()='SubOrg']">
									<xsl:call-template name="eh-SubOrg" />
								</xsl:for-each>
							</xsl:for-each>
						</span>
					</div>
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Avtale</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='Booking']/child::*[local-name()='Appointment']">
								<div>
									<span class="eh-strong">Tidspunkt: </span>
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']"/>
										<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
									</xsl:call-template>
									<span class="eh-strong"> til </span>
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']"/>
										<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
									</xsl:call-template>
								</div>
								<div>
									<span class="strong"> Ressurs: </span>
									<xsl:value-of select="child::*[local-name()='ResourceId']"/>
									<span class="eh-strong"> Index: </span>
									<xsl:value-of select="child::*[local-name()='Index']"/>
								</div>
								<div>
									<span class="eh-strong"> Service: </span>
									<xsl:for-each select="child::*[local-name()='Service']">
										<xsl:call-template name="k-8264"/>
									</xsl:for-each>
								</div>
							</xsl:for-each>
						</span>
					</div>
				</div>
			</xsl:if>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Description']">
			<div class="eh-row-4 blk-cmt">
				<div class="eh-col-1 eh-last-child">
					<span class="eh-label">Beskrivelse</span>
					<span class="eh-field">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Description']"/>
						</xsl:call-template>
					</span>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Content'] or child::*[local-name()='FileReference']"> <!-- v1.1 only -->
			<xsl:choose>
				<xsl:when test="contains(child::*[local-name()='MimeType'],'image')">
					<div class="eh-row-8">
						<div class="eh-col-1 eh-label">Bilde</div>
						<div class="eh-col-1 eh-field eh-last-child">
							<xsl:choose>
								<xsl:when test="child::*[local-name()='FileReference']">
									<img style="max-width: 100%;">
										<xsl:attribute name="src"><xsl:value-of select="child::*[local-name()='FileReference']"/></xsl:attribute>
										<xsl:attribute name="alt">Bilde fra ekstern URL</xsl:attribute>
									</img>
								</xsl:when>
								<xsl:when test="child::*[local-name()='Content']">
									<xsl:choose>
										<xsl:when test="child::*[local-name()='Content']/base:Base64Container">
											<img style="max-width: 100%;">
												<xsl:attribute name="src"><xsl:value-of select="concat('data:',child::*[local-name()='MimeType'],';base64,',child::*[local-name()='Content']/base:Base64Container)"/></xsl:attribute>
												<xsl:attribute name="alt">Bilde vedlagt som base64-kode</xsl:attribute>
											</img>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="child::*[local-name()='Content']"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
						</div>
					</div>
				</xsl:when>
				<xsl:when test="contains(child::*[local-name()='MimeType'],'pdf')">
					<div class="eh-row-4 bl-cmt">
						<div class="eh-col-1 eh-last-child">
							<span class="eh-label">pdf</span>
							<span class="eh-field">Hvis du ikke ser pdf-vedlegget kan du prøve en annen nettleser.</span>
						</div>
					</div>
					<div class="eh-row-8 NoPrint">
						<div class="eh-col-1">
							<div class="eh-col-1 md eh-field">&#160;</div>
							<div class="eh-col-1 eh-field">
								<xsl:choose>
									<xsl:when test="child::*[local-name()='FileReference']">
										<object>
											<xsl:attribute name="data">
												<xsl:value-of select="concat(child::*[local-name()='FileReference'],'&#35;view&#61;FitH&#38;toolbar&#61;1')"/>
											</xsl:attribute>
											<xsl:attribute name="type">application/pdf</xsl:attribute>
											<xsl:attribute name="width">100%</xsl:attribute>
											<xsl:attribute name="height">500px</xsl:attribute>
										</object>
									</xsl:when>
									<xsl:when test="child::*[local-name()='Content']">
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
									</xsl:when>
								</xsl:choose>
							</div>
						</div>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="eh-row-4">
						<div class="eh-col-1 eh-last-field">
							<span class="eh-field">
								<xsl:choose>
									<xsl:when test="child::*[local-name()='Content']">
										<xsl:value-of select="child::*[local-name()='Content']"/>
									</xsl:when>
									<xsl:when test="child::*[local-name()='FileReference']">
										<xsl:value-of select="child::*[local-name()='FileReference']"/>
									</xsl:when>
								</xsl:choose>
							</span>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template name="ServReq_Henvisning"> <!-- Message/ServReq (1.0, 1.1) eller /MsgHead/Document/Content/Henvisning (v2.0)-->
		<div  class="eh-row-4">
			<xsl:if test="child::*[local-name()='IssueDate']">
				<div class="eh-col-1">
					<span class="eh-label">Utstedt</span>
					<span class="eh-field">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='IssueDate']"/>
							<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
						</xsl:call-template>
					</span>
				</div>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="child::*[local-name()='PaymentCat'] and not(namespace-uri() = 'http://www.kith.no/xmlstds/henvisning/2005-07-08')" >
					<div class="eh-col-1">
					<span class="eh-label">Betalings&#173;kategori</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='PaymentCat']">
							<xsl:call-template name="k-4101"/>
						</xsl:for-each>
					</span>
				</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="child::*[local-name()='PaymentCat']">
						<div class="eh-col-1">
							<span class="eh-label">Betalings&#173;kategori</span>
							<span class="eh-field">
								<xsl:for-each select="child::*[local-name()='PaymentCat']">
									<xsl:call-template name="k-4101"/>
								</xsl:for-each>
							</span>
						</div>
					</xsl:if>	
			    </xsl:otherwise>
			</xsl:choose>
				
			<xsl:if test="child::*[local-name()='Ack']"> <!-- (1.0, 1.1) -->
				<div class="eh-col-1">
					<span class="eh-label">Meldings&#173;bekreftelse</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Ack']">
							<xsl:call-template name="k-7304"/>
						</xsl:for-each>
					</span>
				</div>
			</xsl:if>
			<xsl:if test="//child::*[local-name()='MsgInfo']/child::*[local-name()='Ack']"> <!-- (2.0) -->
				<div class="eh-col-1">
					<span class="eh-label">Meldings&#173;bekreftelse</span>
					<span class="eh-field">
						<xsl:for-each select="//child::*[local-name()='MsgInfo']/child::*[local-name()='Ack']">
							<xsl:call-template name="k-7304"/>
						</xsl:for-each>
					</span>
				</div>
			</xsl:if>
				
				
		</div>
      
		<xsl:for-each select="child::*[local-name()='ReqServ']">
			<xsl:call-template name="ServReq_ReqServ"/>
		</xsl:for-each>
		
	   <!-- Legger inn sjekk om noen dokumenter er sendt som kan være relevante (v2.0) SendtDokument-->
         <div>
			<xsl:if test="child::*[local-name()='SendtDokument']">
				<div class="eh-col-1">
					<span class="eh-label">Sendte dokumenter</span>
					<span class="eh-field">
						<div  class="eh-row-5">
						<xsl:for-each select="child::*[local-name()='SendtDokument']">
							<xsl:if test="//child::*[local-name()='SendtDokument']/child::*[local-name()='Opplysning']">
								<div class="eh-col-1">
									<span class="eh-label">Dokument&#173;type</span>
									<span class="eh-field">
										<xsl:for-each select="child::*[local-name()='Opplysning']">
											<xsl:call-template name="k-8329"/>
										</xsl:for-each>
									</span>
								</div>
							</xsl:if>
							<xsl:if test="//child::*[local-name()='SendtDokument']/child::*[local-name()='JaNei']">
								<div class="eh-col-1">
									<span class="eh-label">Sendt</span>
									<span class="eh-field">
										<xsl:if test="//child::*[local-name()='SendtDokument']/child::*[local-name()='JaNei']='false'">
											Nei
										</xsl:if>
										<xsl:if test="//child::*[local-name()='SendtDokument']/child::*[local-name()='JaNei']='true'">
											Ja
										</xsl:if>
									</span>
								</div>
							</xsl:if>
							<xsl:if test="//child::*[local-name()='JaNei'] and //child::*[local-name()='DatoSendt']">
								<div class="eh-col-1">
									<span class="eh-label">Dato sendt</span>
									<span class="eh-field">
										<xsl:call-template name="skrivUtDate">
											<xsl:with-param name="oppgittTid" select="//child::*[local-name()='DatoSendt']"/>
										</xsl:call-template>
     								</span>
								</div>
							</xsl:if>
							<xsl:if test="//child::*[local-name()='TypeMottaker']/@V and //child::*[local-name()='NavnMottaker']">
								<div class="eh-col-1">
									<span class="eh-label">Mottaker</span>
									<span class="eh-field">
										<xsl:for-each select="//child::*[local-name()='TypeMottaker']">
											<xsl:call-template name="k-8330"/>
										</xsl:for-each>&#160;,&#160;
										<xsl:value-of select="//child::*[local-name()='NavnMottaker']"/>
									</span>
								</div>
							</xsl:if>
							<xsl:if test="not(//child::*[local-name()='TypeMottaker']) and //child::*[local-name()='NavnMottaker']">
								<div class="eh-col-1">
									<span class="eh-label">Mottaker</span>
									<span class="eh-field">
										<xsl:value-of select="//child::*[local-name()='NavnMottaker']"/>
									</span>
								</div>
							</xsl:if>
							<xsl:if test="//child::*[local-name()='TypeMottaker']/@V and not(//child::*[local-name()='NavnMottaker'])">
								<div class="eh-col-1">
									<span class="eh-label">Mottaker</span>
									<span class="eh-field">
										<xsl:for-each select="//child::*[local-name()='TypeMottaker']">
											<xsl:call-template name="k-8330"/>
										</xsl:for-each>
									</span>
								</div>
							</xsl:if>
							<xsl:if test="//child::*[local-name()='Merknad']">
								<div class="eh-col-1">
									<span class="eh-label">Merknad</span>
									<span class="eh-field">
										<xsl:value-of select="//child::*[local-name()='Merknad']"/>
									</span>
								</div>
							</xsl:if>
						</xsl:for-each>
						</div>	
					</span>
				</div>	
     		</xsl:if>
		</div>
		<!-- SendDokumenter slutt -->
	</xsl:template>

	<xsl:template name="ServReq_ReqServ"> <!-- Message/ServReq/ReqServ (1.0, 1.1) eller .../Content/Henvisning/ReqServ (v2.0) -->
		<div class="eh-row-4">
			<xsl:if test="child::*[local-name()='Priority']">
				<div class="eh-col-1">
					<span class="eh-label">Hastegrad</span>
					<span class="eh-field">
					<xsl:choose>
						<xsl:when test="namespace-uri() = 'http://ehelse.no/xmlstds/henvisning/2017-11-30'"><!-- Henvisning v2.0-->
							<xsl:for-each select="child::*[local-name()='Priority']">
								<xsl:call-template name="k-8306"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise><!-- Henvisning v1.0 og v1.1 -->
							<xsl:for-each select="child::*[local-name()='Priority']">
							<xsl:call-template name="k-8304"/>
						</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					</span>
				</div>
			</xsl:if>
			<xsl:if test="child::*[local-name()='Purpose']">
				<div class="eh-col-1">
					<span class="eh-label">Formål</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='Purpose']">
							<xsl:call-template name="k-8248"/>
						</xsl:for-each>
					</span>
				</div>
			</xsl:if>
			<xsl:if test="child::*[local-name()='ReqDate']">
				<div class="eh-col-1">
					<span class="eh-label">Utstedt</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='ReqDate']">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="@V"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</xsl:for-each>
					</span>
				</div>
			</xsl:if>
		</div>

		<xsl:for-each select="child::*[local-name()='Service']">
			<xsl:call-template name="ReqServ_Service"/>
		</xsl:for-each>

		<xsl:if test="child::*[local-name()='Comment']">
			<div class="eh-row-4">
				<div class="eh-col-1 eh-last-child">
				<span class="eh-label">Kommentar</span>
					<span class="eh-field">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
						</xsl:call-template>
					</span>
				</div>
			</div>
		</xsl:if>

	</xsl:template>

	<xsl:template name="ReqServ_Service"> <!-- Message/ServReq/ReqServ/Service (1.0, 1.1) eller .../Content/Henvisning/ReqServ/Service (v2.0)-->
		<div  class="eh-row-4">
			<xsl:if test="child::*[local-name()='ServId']">
				<div class="eh-col-1">
					<span class="eh-label">Spesifisert tjeneste</span>
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
				</div>
			</xsl:if>
			<xsl:if test="child::*[local-name()='MedSpeciality']">
				<div class="eh-col-1">
					<span class="eh-label">Medisinsk spesialitet</span>
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
				</div>
			</xsl:if>
			<xsl:if test="child::*[local-name()='AdmCat']">
				<div class="eh-col-1 eh-last-child">
					<span class="eh-label">Type tjeneste</span>
					<span class="eh-field">
						<xsl:for-each select="child::*[local-name()='AdmCat']">
							<xsl:call-template name="k-8240"/>
						</xsl:for-each>
					</span>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- Deprecated: se felleskomponenter/eh-komponent1.xsl : eh-SubOrg -->
	<xsl:template name="SubOrg"> <!-- v1.0 only -->
		<div>
			<xsl:value-of select="child::*[local-name()='Name']"/>&#8200;
			<span class="eh-strong">
				<xsl:choose>
					<xsl:when test="child::*[local-name()='TypeId']">
						<xsl:value-of select="child::*[local-name()='TypeId']"/>:</xsl:when>
					<xsl:otherwise>Id:</xsl:otherwise>
				</xsl:choose>
			</span>&#8200;
			<xsl:value-of select="child::*[local-name()='Id']"/>
		</div>
	</xsl:template>

	<xsl:template name="Diagnosis-DiagComment-CodedDescr-CodedComment">
	</xsl:template>
</xsl:stylesheet>
