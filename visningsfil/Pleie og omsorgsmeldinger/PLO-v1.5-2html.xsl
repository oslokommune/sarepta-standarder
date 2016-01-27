<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" xmlns:po="http://www.kith.no/xmlstds/po/poKomponent/2009-06-30" xmlns:p1="http://www.kith.no/xmlstds/po/Pasientlogistikk/2009-06-30" xmlns:p2="http://www.kith.no/xmlstds/po/MeldingFravar/2009-06-30" xmlns:p3="http://www.kith.no/xmlstds/po/OrienteringOmTjenestetilbud/2009-06-30" xmlns:p4="http://www.kith.no/xmlstds/po/OverforingMedisinskeOpplysninger/2009-06-30" xmlns:p5="http://www.kith.no/xmlstds/po/HelseopplysningerVedSoknad/2009-06-30" xmlns:p6="http://www.kith.no/xmlstds/po/Konsultasjon/2009-06-30" xmlns:p7="http://www.kith.no/xmlstds/po/Innleggelsesrapport/2009-06-30" xmlns:p8="http://www.kith.no/xmlstds/po/TverrfagligEpikrise/2009-06-30" xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" xmlns:epj3="http://www.kith.no/xmlstds/epj/epj3/2008-02-20" xmlns:epj2="http://www.kith.no/xmlstds/epj/epj2/2008-02-20" xmlns:epj1="http://www.kith.no/xmlstds/epj/epj1/2008-02-20" exclude-result-prefixes="po mh fk1 p1 p2 p3 p4 p5 p6 p7 p8 epj1 epj2 epj3">
	<xsl:output method="html" version="1.0" encoding="UTF-8"/>
	<!--
Inngår i KITHs visningsfiler versjon 10

01.12.2010: Import av felles CSS-fil
03.09.2009: Oppdatert til PLO v1.5
-->
	<xsl:include href="../../Hodemelding/v1.2/Hodemelding2html.xsl"/>
	<xsl:include href="../../Felleskomponenter/EPJ-journalnotat2html.xsl"/>
	<xsl:include href="../../Felleskomponenter/EPJ-cave2html.xsl"/>
	<xsl:include href="../../Felleskomponenter/EPJ-legemiddel2html.xsl"/>
	<xsl:template match="/">
		<html>
			<head>
				<style type="text/css"><xsl:value-of select="document('../../Felleskomponenter/KITH-visning.css')" disable-output-escaping="yes" /></style>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="FellesMeny">
		<!--*** Sjekker om meldingen er pasientlogistikk, da skrives ikke fellesmeny ut pga. av logistikkmeldigen er veldig kort ***-->
		<xsl:if test="not(../../../../mh:MsgInfo/mh:Type/@V='PASIENTLOGISTIKK')">
			<div id="FellesMeny">
				<ul>
					<xsl:if test="po:InfoMedisinskDiagnose">
						<li>
							<a href="#InfoMedisinskDiagnose">Medisinske diagnoser</a>
						</li>
					</xsl:if>
					<xsl:if test="po:MedisinskfagligeOpplysninger">
						<li>
							<a href="#MedisinskfagligeOpplysninger">Medisinskfaglige opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="po:MedisinskfagligeOpplysninger/epj1:Cave">
						<li>
							<a href="#Cave">Cave</a>
						</li>
					</xsl:if>
					<xsl:if test="po:InfoReservasjon">
						<li>
							<a href="#InfoReservasjon">Reservasjoner</a>
						</li>
					</xsl:if>
					<xsl:if test="epj3:Legemiddelinfo">
						<li>
							<a href="#Legemiddelinfo">Legemidler</a>
						</li>
					</xsl:if>
					<xsl:if test="po:Sykepleierdokumentasjon">
						<li>
							<a href="#Sykepleieopplysninger">Sykepleieopplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="po:OpplysningerAndreFaggrupper">
						<li>
							<a href="#OpplysningerAndreFaggrupper">Opplysninger fra andre faggrupper</a>
						</li>
					</xsl:if>
					<xsl:if test="po:InfoKartleggingFunksjonsniva">
						<li>
							<a href="#InfoKartleggingFunksjonsniva">Kartlegging av funksjonsnivå</a>
						</li>
					</xsl:if>
					<xsl:if test="po:TjenesteBehov">
						<li>
							<a href="#TjenesteBehov">Behov for tjenester</a>
						</li>
					</xsl:if>
					<xsl:if test="po:InfoKontrolltime">
						<li>
							<a href="#InfoKontrolltime">Kontrolltime</a>
						</li>
					</xsl:if>
					<xsl:if test="po:OpplysningerOmHjelpemidler">
						<li>
							<a href="#OpplysningerOmHjelpemidler">Hjelpemidler</a>
						</li>
					</xsl:if>
					<xsl:if test="po:OpplysningOpphold">
						<li>
							<a href="#OpplysningOpphold">Opplysninger om opphold</a>
						</li>
					</xsl:if>
					<xsl:if test="po:EksisterendeTjeneste">
						<a href="#EksisterendeTjeneste">Eksisterende tjenester</a>
					</xsl:if>
					<xsl:if test="po:TilleggsopplysningPasient">
						<li>
							<a href="#TilleggsopplysningPasient">Andre pasientopplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="po:ParorendeForesatt">
						<li>
							<a href="#ParorendeForesatt">Pårørende/foresatte</a>
						</li>
					</xsl:if>
					<xsl:if test="po:TilknyttetEnhet">
						<li>
							<a href="#KontaktinformasjonVirksomhet">Kontaktinformasjon virksomhet</a>
						</li>
					</xsl:if>
					<xsl:if test="po:KontaktpersonHelsepersonell">
						<li>
							<a href="#KontaktpersonHelsepersonell">Kontaktpersoner helsepersonell</a>
						</li>
					</xsl:if>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="FellesHode">
		<!--<xsl:apply-templates select="po:InformasjonOmForsendelsen/po:Foresporsel"/>
		<xsl:apply-templates select="po:TilleggsopplysningPasient"/>
		<xsl:apply-templates select="po:ParorendeForesatt"/>
		<xsl:apply-templates select="po:KontaktpersonHelsepersonell"/>
		<xsl:apply-templates select="po:AnsvarForRapport"/>
		<xsl:apply-templates select="po:SendtDokument"/>-->
	</xsl:template>
	<!-- slutt felles hode -->
	<xsl:template name="FellesBunn">
		<xsl:apply-templates select="po:TilleggsopplysningPasient"/>
		<xsl:apply-templates select="po:ParorendeForesatt"/>
		<xsl:apply-templates select="po:TilknyttetEnhet"/>
		<xsl:apply-templates select="po:KontaktpersonHelsepersonell"/>
		<xsl:apply-templates select="po:AnsvarForRapport"/>
		<xsl:apply-templates select="po:SendtDokument"/>
		<xsl:apply-templates select="po:InformasjonOmForsendelsen/po:Foresporsel"/>
	</xsl:template>
	<!-- slutt felles bunn -->
	<xsl:template match="p1:Pasientlogistikk">
		<h1>
			<!--Pasientlogistikk -->
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='C'">Kansellering av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='M'">Endring av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='A'">Tillegg til melding: </xsl:if>
			<xsl:choose>
				<xsl:when test="p1:OrienteringOmDod">Orientering om dødsfall</xsl:when>
				<xsl:when test="p1:MeldingInnlagtPasient">Melding om innlagt pasient</xsl:when>
				<xsl:when test="p1:MeldingUtskrivningsklarPasient">Melding om utskrivningsklar pasient</xsl:when>
				<xsl:when test="p1:AvmeldingUtskrivningsklarPasient">Avmelding utskrivningsklar pasient</xsl:when>
				<xsl:when test="p1:MeldingOmUtskrevetPasient">Melding om utskrevet pasient</xsl:when>
				<xsl:otherwise>Ukjent meldingstype</xsl:otherwise>
			</xsl:choose>
		</h1>
		<xsl:call-template name="FellesMeny"/>
		<xsl:apply-templates select="p1:OrienteringOmDod"/>
		<xsl:apply-templates select="p1:MeldingOmUtskrevetPasient"/>
		<xsl:apply-templates select="p1:MeldingUtskrivningsklarPasient"/>
		<xsl:apply-templates select="p1:AvmeldingUtskrivningsklarPasient"/>
		<xsl:apply-templates select="p1:MeldingInnlagtPasient"/>
		<xsl:call-template name="FellesBunn"/>
	</xsl:template>
	<!-- p1:Pasientlogistikk-->
	<xsl:template match="p1:MeldingOmUtskrevetPasient">
		<xsl:apply-templates select="po:UtskrevetTil"/>
		<xsl:if test="po:TidsfestetHendelse">
			<table>
				<tr>
					<th width="20%">Hendelse</th>
					<th width="20%">Tidspunkt</th>
					<th width="20%">Sted</th>
					<th width="40%">Merknad</th>
				</tr>
				<xsl:apply-templates select="po:TidsfestetHendelse"/>
			</table>
		</xsl:if>
		<xsl:apply-templates select="po:InfoInformasjonGitt"/>
	</xsl:template>
	<xsl:template match="po:UtskrevetTil">
		<table id="tableWidth50">
			<tbody>
				<tr>
					<xsl:if test="po:Uttilstand">
						<th>Uttilstand</th>
					</xsl:if>
					<th>Pasienten utskrevet til</th>
					<xsl:if test="po:Merknad">
						<th>Merknad</th>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="po:Uttilstand">
						<xsl:choose>
							<xsl:when test="po:Uttilstand/@V='2'">
								<td id="tdBold">
									<font color="red"><xsl:value-of select="po:Uttilstand/@DN"/></font>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td>
									<xsl:value-of select="po:Uttilstand/@DN"/>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<td>
						<xsl:value-of select="po:UtTil/@DN"/>
					</td>
					<xsl:if test="po:Merknad">
						<td>
							<xsl:value-of select="po:Merknad"/>
						</td>
					</xsl:if>
				</tr>
			</tbody>
		</table>
		<br/>
	</xsl:template>
	<xsl:template match="p1:AvmeldingUtskrivningsklarPasient">
		<table>
			<xsl:if test="not(preceding-sibling::p1:AvmeldingUtskrivningsklarPasient)">
				<tr>
					<th width="20%">Hendelse</th>
					<th width="20%">Tidspunkt</th>
					<th width="20%">Sted</th>
					<th width="40%">Merknad</th>
				</tr>
			</xsl:if>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	<xsl:template match="p1:OrienteringOmDod">
		<table width="95%">
			<xsl:if test="not(preceding-sibling::p1:OrienteringOmDod)">
				<tr>
					<th width="20%">Hendelse</th>
					<th width="20%">Tidspunkt</th>
					<th width="20%">Sted</th>
					<th width="40%">Merknad</th>
				</tr>
			</xsl:if>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	<xsl:template match="p1:MeldingInnlagtPasient">
		<table width="95%">
			<xsl:if test="not(preceding-sibling::p1:MeldingInnlagtPasient)">
				<tr>
					<th width="20%">Hendelse</th>
					<th width="20%">Tidspunkt</th>
					<th width="20%">Sted</th>
					<th width="40%">Merknad</th>
				</tr>
			</xsl:if>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	<xsl:template match="p1:MeldingUtskrivningsklarPasient">
		<table width="95%">
			<xsl:if test="not(preceding-sibling::p1:MeldingUtskrivningsklarPasient)">
				<tr>
					<th width="20%">Hendelse</th>
					<th width="20%">Tidspunkt</th>
					<th width="20%">Sted</th>
					<th width="40%">Merknad</th>
				</tr>
			</xsl:if>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	<xsl:template match="p2:MeldingFravar">
		<h1>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='C'">Kansellering av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='M'">Endring av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='A'">Tillegg til melding: </xsl:if>		
		Melding om fravær</h1>
		<xsl:call-template name="FellesMeny"/>
		<xsl:apply-templates select="po:Fraversassistent"/>
		<xsl:call-template name="FellesBunn"/>
	</xsl:template>
	<xsl:template match="p3:OrienteringOmTjenestetilbud">
		<h1>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='C'">Kansellering av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='M'">Endring av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='A'">Tillegg til melding: </xsl:if>		
		Orientering om tjenestetilbud</h1>
		<xsl:call-template name="FellesMeny"/>
		<!--<h2>Tjenester som mottas</h2>
		<table>
			<tr>
				<th>Fra dato</th>
				<th>Til dato</th>
				<th>Tjeneste</th>
				<th>Omfang (art/tiltak)</th>
				<th>Merknad</th>
			</tr>-->
		<xsl:apply-templates select="po:EksisterendeTjeneste"/>
		<xsl:apply-templates select="po:AssistertKommunikasjon"/>
		<!--</table>-->
		<xsl:call-template name="FellesHode"/>
		<xsl:call-template name="FellesBunn"/>
	</xsl:template>
	<xsl:template match="p4:OverforingMedisinskeOpplysninger">
		<h1>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='C'">Kansellering av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='M'">Endring av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='A'">Tillegg til melding: </xsl:if>		
		Medisinske opplysninger
		<xsl:if test="po:TypeInnholdIMelding">
			&#160;-&#160;<xsl:value-of select="po:TypeInnholdIMelding/po:TypeInnhold/@DN"/>
			</xsl:if>
		</h1>
		<xsl:call-template name="FellesMeny"/>
		<!--<xsl:apply-templates/>-->
		<xsl:apply-templates select="po:TypeInnholdIMelding"/>
		<xsl:apply-templates select="po:InfoMedisinskDiagnose"/>
		<xsl:apply-templates select="po:MedisinskfagligeOpplysninger"/>
		<xsl:apply-templates select="po:InfoReservasjon"/>
		<xsl:apply-templates select="epj3:Legemiddelinfo"/>
		<xsl:apply-templates select="po:InfoIPLOSrelevantInformasjon"/>
		<xsl:apply-templates select="po:Sykepleierdokumentasjon"/>
		<xsl:apply-templates select="po:OpplysningerAndreFaggrupper"/>
		<xsl:apply-templates select="po:InfoKartleggingFunksjonsniva"/>
		<xsl:apply-templates select="po:InfoAssistertKommunikasjon"/>
		<xsl:apply-templates select="po:InfoInformasjonGitt"/>
		<xsl:apply-templates select="po:TjenesteBehov"/>
		<xsl:apply-templates select="po:InfoKontaktepisode"/>
		<xsl:apply-templates select="po:InfoAndreViktigeOpplysninger"/>
		<xsl:apply-templates select="po:OpplysningerTilSoknad"/>
		<xsl:call-template name="FellesBunn"/>
	</xsl:template>
	<xsl:template match="p5:HelseopplysningerVedSoknad">
		<h1>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='C'">Kansellering av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='M'">Endring av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='A'">Tillegg til melding: </xsl:if>		
		Helseopplysninger ved søknad</h1>
		<xsl:call-template name="FellesMeny"/>
		<xsl:apply-templates select="po:InfoMedisinskDiagnose"/>
		<xsl:apply-templates select="po:MedisinskfagligeOpplysninger"/>
		<xsl:apply-templates select="po:Sykepleierdokumentasjon"/>
		<xsl:apply-templates select="po:OpplysningerAndreFaggrupper"/>
		<xsl:apply-templates select="po:InfoKartleggingFunksjonsniva"/>
		<xsl:apply-templates select="po:InfoAssistertKommunikasjon"/>
		<xsl:apply-templates select="po:InfoInformasjonGitt"/>
		<xsl:apply-templates select="po:TjenesteBehov"/>
		<xsl:apply-templates select="po:OpplysningerTilSoknad"/>
		<xsl:call-template name="FellesBunn"/>
	</xsl:template>
	<xsl:template match="p6:Konsultasjon">
		<h1>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='C'">Kansellering av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='M'">Endring av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='A'">Tillegg til melding: </xsl:if>		
			Helseopplysninger til lege
		<xsl:if test="po:InnholdKonsultasjon">
		 &#160;-&#160;<xsl:value-of select="po:InnholdKonsultasjon/po:TypeInnholdKonsultasjon/@DN"/>
			</xsl:if>
		</h1>
		<xsl:call-template name="FellesMeny"/>
		<xsl:apply-templates select="po:InnholdKonsultasjon"/>
		<xsl:apply-templates select="po:InfoMedisinskDiagnose"/>
		<xsl:apply-templates select="po:MedisinskfagligeOpplysninger"/>
		<xsl:apply-templates select="po:InfoReservasjon"/>
		<xsl:apply-templates select="epj3:Legemiddelinfo"/>
		<xsl:apply-templates select="po:InfoAndreViktigeOpplysninger"/>
		<xsl:apply-templates select="po:Sykepleierdokumentasjon"/>
		<xsl:apply-templates select="po:InfoKartleggingFunksjonsniva"/>
		<xsl:apply-templates select="po:InfoInformasjonGitt"/>
		<xsl:apply-templates select="po:InfoAssistertKommunikasjon"/>
		<xsl:call-template name="FellesBunn"/>
	</xsl:template>
	<xsl:template match="p7:Innleggelsesrapport">
		<h1>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='C'">Kansellering av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='M'">Endring av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='A'">Tillegg til melding: </xsl:if>		
			Innleggelsesrapport
		</h1>
		<xsl:call-template name="FellesMeny"/>
		<xsl:apply-templates select="po:InfoMedisinskDiagnose"/>
		<xsl:apply-templates select="po:MedisinskfagligeOpplysninger"/>
		<xsl:apply-templates select="po:InfoReservasjon"/>
		<xsl:apply-templates select="epj3:Legemiddelinfo"/>
		<xsl:apply-templates select="po:EksisterendeTjeneste"/>
		<xsl:apply-templates select="po:InfoKartleggingFunksjonsniva"/>
		<xsl:apply-templates select="po:InfoAndreViktigeOpplysninger"/>
		<xsl:apply-templates select="po:Sykepleierdokumentasjon"/>
		<xsl:apply-templates select="po:OpplysningerAndreFaggrupper"/>
		<xsl:apply-templates select="po:OpplysningerOmHjelpemidler"/>
		<xsl:apply-templates select="po:InfoAssistertKommunikasjon"/>
		<xsl:apply-templates select="po:InfoInformasjonGitt"/>
		<xsl:call-template name="FellesBunn"/>
	</xsl:template>
	<xsl:template match="p8:TverrfagligEpikrise">
		<h1>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='C'">Kansellering av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='M'">Endring av melding: </xsl:if>
			<xsl:if test="po:InformasjonOmForsendelsen/po:Forsendelsesstatus/@V='A'">Tillegg til melding: </xsl:if>	
			Utskrivningsrapport
		</h1>
		<xsl:call-template name="FellesMeny"/>
		<xsl:apply-templates select="po:InfoMedisinskDiagnose"/>
		<xsl:apply-templates select="po:InfoAndreViktigeOpplysninger"/>
		<xsl:apply-templates select="po:MedisinskfagligeOpplysninger"/>
		<xsl:apply-templates select="po:InfoReservasjon"/>
		<xsl:apply-templates select="epj3:Legemiddelinfo"/>
		<xsl:apply-templates select="po:InfoLegemidlerIBruk"/>
		<xsl:apply-templates select="po:InfoSeponertLegemiddel"/>
		<xsl:apply-templates select="po:Sykepleierdokumentasjon"/>
		<xsl:if test="po:OpplysningerAndreFaggrupper">
			<h2 id="OpplysningerAndreFaggrupper">Opplysninger fra andre faggrupper</h2>
			<xsl:apply-templates select="po:OpplysningerAndreFaggrupper"/>
		</xsl:if>
		<xsl:apply-templates select="po:InfoKartleggingFunksjonsniva"/>
		<xsl:if test="po:TjenesteBehov">
			<h2 id="TjenesteBehov">Behov for tjenester</h2>
			<xsl:apply-templates select="po:TjenesteBehov"/>
		</xsl:if>
		<xsl:apply-templates select="po:InfoKontrolltime"/>
		<xsl:apply-templates select="po:OpplysningerOmHjelpemidler"/>
		<xsl:apply-templates select="po:InfoInformasjonGitt"/>
		<xsl:apply-templates select="po:InfoAssistertKommunikasjon"/>
		<xsl:if test="po:OpplysningOpphold">
			<h2 id="OpplysningOpphold">Opplysninger om opphold</h2>
			<table width="95%">
				<xsl:if test="not(preceding-sibling::po:OpplysningOpphold)">
					<tr>
						<th width="20%">Beskrivelse</th>
						<th width="20%">Tidspunkt</th>
						<!--<th width="10%">Anslått</th>-->
						<th width="20%">Sted</th>
						<th width="40%">Merknad</th>
						<!--<th width="25%">Beskrivelse</th>-->
					</tr>
				</xsl:if>
				<xsl:for-each select="po:OpplysningOpphold">
					<xsl:apply-templates/>
				</xsl:for-each>
			</table>
		</xsl:if>
		<xsl:call-template name="FellesBunn"/>
	</xsl:template>
	<xsl:template match="po:ParorendeForesatt">
		<xsl:if test="not(preceding-sibling::po:ParorendeForesatt)">
			<xsl:for-each select="..">
				<h2 id="ParorendeForesatt">Pårørende/foresatte</h2>
				<table width="95%">
					<tr>
						<th width="40%">Person</th>
						<th width="10%">Slektskap</th>
						<th width="20%">Omsorgsfunksjon</th>
						<th width="30%">Merknad</th>
					</tr>
					<xsl:for-each select="po:ParorendeForesatt">
						<tr valign="top">
							<td>
								<xsl:apply-templates select="po:Referanseperson"/>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="po:Slektskap">
										<xsl:value-of select="po:Slektskap/@DN"/>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="po:Omsorgsfunksjon">
										<xsl:value-of select="po:Omsorgsfunksjon/@DN"/>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="po:Merknad">
										<xsl:value-of select="po:Merknad"/>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</xsl:if>
		<br/>
	</xsl:template>
	<!-- po:ParorendeForesatt -->
	<xsl:template match="po:InfoAssistertKommunikasjon">
		<h2>Behov for assistert kommunikasjon </h2>
		<xsl:apply-templates select="po:AssistertKommunikasjon"/>
	</xsl:template>
	<xsl:template match="po:AssistertKommunikasjon">
		<xsl:if test="po:PersonTolkebehov or po:Horselsvikt or po:Synsvikt or po:BehovTolkSprak or po:BehovOpphortDato or po:Merknad">
			<table width="95%">
				<xsl:if test="po:PersonTolkebehov">
					<tr>
						<th>Person med tolkebehov</th>
						<td colspan="3">
							<xsl:value-of select="po:PersonTolkebehov/fk1:GivenName"/>&#160;<xsl:value-of select="po:PersonTolkebehov/fk1:MiddleName"/>&#160;<xsl:value-of select="po:PersonTolkebehov/fk1:FamilyName"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="po:Horselsvikt or po:Synsvikt or po:BehovTolkSprak or po:BehovOpphortDato">
						<tr>
							<th width="15%">Hørselsvikt</th>
							<th width="15%">Synsvikt</th>
							<th width="15%">Tolk for språk</th>
							<th width="15%">Behov opphørte dato</th>
							<th width="40%">Merknad</th>
						</tr>
						<tr>
							<td>
								<xsl:if test="po:Horselsvikt = 'true' or po:Horselsvikt='1'">Ja</xsl:if>
								<xsl:if test="po:Horselsvikt = 'false' or po:Horselsvikt='0'">Nei</xsl:if>
							</td>
							<td>
								<xsl:if test="po:Synsvikt = 'true' or po:Synsvikt='1'">Ja</xsl:if>
								<xsl:if test="po:Synsvikt = 'false' or po:Synsvikt='0'">Nei</xsl:if>
							</td>
							<td>
								<xsl:value-of select="po:BehovTolkSprak/@DN"/>&#160;
							</td>
							<td>
								<xsl:call-template name="skrivUtDateTime">
									<xsl:with-param name="oppgittTid" select="po:BehovOpphortDato/@V"/>
								</xsl:call-template>
							</td>
							<td>
								<xsl:value-of select="po:Merknad"/>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td>
								<xsl:value-of select="po:Merknad"/>
							</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</table>
		</xsl:if>
		<xsl:if test="po:PreferertTolk">
			<h3>Ønsket tolk</h3>
			<xsl:for-each select="po:PreferertTolk">
				<div style="width:50%">
					<xsl:call-template name="fk1:Person"/>
				</div>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:TilknyttetEnhet">
		<xsl:if test="not(preceding-sibling::po:TilknyttetEnhet)">
			<h2 id="KontaktinformasjonVirksomhet">Kontaktinformasjon enhet</h2>
		</xsl:if>
		<xsl:apply-templates select="po:Kontaktenhet"/>
	</xsl:template>
	<xsl:template match="po:Kontaktenhet">
		<table>
			<tbody>
				<tr>
					<td width="20%">
						<xsl:value-of select="fk1:OrganisationName"/>
						<xsl:if test="fk1:Organisation">
							,&#160;<xsl:value-of select="fk1:Organisation/fk1:OrganisationName"/>
						</xsl:if>
					</td>
					<td width="35%">
						<xsl:value-of select="fk1:Address/fk1:StreetAdr"/>&#160;<xsl:value-of select="fk1:Address/fk1:PostalCode"/>&#160;<xsl:value-of select="fk1:Address/fk1:City"/>
					</td>
					<td width="15%">
						<xsl:if test="fk1:TeleCom">
							<xsl:value-of select="fk1:TeleCom/fk1:TeleAddress/@V"/>
						</xsl:if>
					</td>
					<td width="30%">
						<xsl:value-of select="../po:Merknad"/>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template match="po:KontaktpersonHelsepersonell">
		<xsl:if test="not(preceding-sibling::po:KontaktpersonHelsepersonell)">
			<xsl:for-each select="..">
				<h2 id="KontaktpersonHelsepersonell">Kontaktpersoner helsepersonell</h2>
				<table width="95%">
					<xsl:for-each select="po:KontaktpersonHelsepersonell">
						<tr>
							<td width="60%">
								<xsl:apply-templates select="po:Kontaktperson"/>
							</td>
							<td width="15%">
								<xsl:value-of select="po:Kontaktperson/fk1:TeleCom/fk1:TeleAddress/@V"/>
							</td>
							<td width="25%">
								<xsl:if test="po:Merknad">
									<xsl:value-of select="po:Merknad"/>
								</xsl:if>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<!-- po:KontaktpersonHelsepersonell -->
	<xsl:template match="po:AnsvarForRapport">
		<xsl:if test="not(preceding-sibling::po:AnsvarForRapport)">
			<h2>Ansvarlig</h2>
			<table>
				<tr>
					<th width="45%">Ansvarlig</th>
					<th width="15%">Relasjon</th>
					<th width="15%">Godkjent dato</th>
					<th width="25%">Merknad</th>
				</tr>
				<xsl:for-each select="..">
					<xsl:for-each select="po:AnsvarForRapport">
						<tr>
							<td>
								<xsl:apply-templates select="po:AnsvarligRapport"/>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="po:TypeRelasjon">
										<xsl:value-of select="po:TypeRelasjon/@DN"/>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="po:GodkjentDato">
										<xsl:value-of select="po:GodkjentDato"/>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="po:Merknad">
										<xsl:value-of select="po:Merknad"/>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- AnsvarForRapport-->
	<xsl:template match="po:SendtDokument">
		<xsl:if test="not(preceding-sibling::po:SendtDokument)">
			<xsl:for-each select="..">
				<h2>Sendte dokumenter</h2>
				<table width="95%">
					<tr>
						<th width="20%">Type opplysninger</th>
						<th width="20%">Oversendt/ikke oversendt</th>
						<th width="10%">Dato</th>
						<th width="20%">Mottaker</th>
						<th width="30%">Merknad</th>
					</tr>
					<xsl:for-each select="po:SendtDokument">
						<tr>
							<td>
								<xsl:value-of select="po:Opplysning/@DN"/>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="po:JaNei = 'true' or po:JaNei = '1'">Oversendt</xsl:when>
									<xsl:otherwise>Ikke oversendt</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:value-of select="po:DatoSendt"/>
							</td>
							<td>
								<xsl:if test="po:TypeMottaker">
									<b>
										<xsl:value-of select="po:TypeMottaker/@DN"/>:</b>
									<br/>
								</xsl:if>
								<xsl:value-of select="po:NavnMottaker"/>
							</td>
							<td>
								<xsl:value-of select="po:Merknad"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<!--<xsl:template match="po:InfoKartleggingFunksjonsniva">
		<h2 id="InfoKartleggingFunksjonsniva">Kartlegging av funksjonsnivå</h2>
		<xsl:for-each select="po:SamletVurderingFunksjonsniva">
			<h3>Samlet vurdering</h3>
			<table>
				<tr>
					<th>Pleietyngde</th>
					<th>Vurdering</th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="po:Pleietyngde"/>&#160;</td>
					<td>
						<xsl:value-of select="po:VurderingPleietyngde"/>&#160;</td>
				</tr>
				<tr>
					<th>Merknad</th>
					<td>
						<xsl:value-of select="po:Merknad"/>&#160;</td>
				</tr>
			</table>
		</xsl:for-each>
		<h3>Kartlagte funksjoner</h3>
		<table width="70%">
			<tr>
				<th width="20%">Funksjonsvariabel</th>
				<th width="40%">Vurdering</th>
				<th width="40%">Merknad</th>
			</tr>
			<xsl:for-each select="po:KartlagtFunksjon">
				<tr>
					<td>
						<xsl:value-of select="po:Funksjonsvariabel/@DN"/>
					</td>
					<td>
						<xsl:value-of select="po:Vurdering"/>
					</td>
					<td>
						<xsl:value-of select="po:Merknad"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
		<xsl:apply-templates select="po:Ansvarlig"/>
	</xsl:template>-->
	<!-- infokartleggingfunksjonsnivå -->
	<xsl:template match="po:InfoIPLOSrelevantInformasjon">
		<h2>IPLOS-relevant informasjon</h2>
		<table width="70%">
			<tr>
				<th width="15%">Start</th>
				<th width="15%">Slutt</th>
				<th width="15%">Type diagnose</th>
				<th width="20%">Diagnosekode</th>
				<th width="35%">Diagnosebeskrivelse</th>
			</tr>
			<xsl:for-each select="po:TidsperiodeDiagnose">
				<tr>
					<td>
						<xsl:value-of select="po:StartdatoDiagnose"/>&#160;</td>
					<td>
						<xsl:value-of select="po:SluttdatoDiagnose"/>&#160;</td>
					<td>
						<xsl:choose>
							<xsl:when test="po:MedisinskDiagnose/po:Hoveddiagnose='true' or po:MedisinskDiagnose/po:Hoveddiagnose='1'">
								Hoveddiagnose
							</xsl:when>
							<xsl:otherwise>Bidiagnose</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<xsl:if test="string-length(po:MedisinskDiagnose/po:Diagnosekode/@DN) &gt; 1">
							<xsl:value-of select="po:MedisinskDiagnose/po:Diagnosekode/@DN"/> (<xsl:value-of select="po:MedisinskDiagnose/po:Diagnosekode/@V"/>)
						</xsl:if>
					</td>
					<td>
						<xsl:value-of select="po:MedisinskDiagnose/po:DiagnoseBeskrivelse"/>&#160;</td>
				</tr>
			</xsl:for-each>
		</table>
		<xsl:if test="po:TidsfestetHendelse">
			<h3>Hendelse</h3>
			<table>
				<tr>
					<th width="20%">Hendelse</th>
					<th width="20%">Tidspunkt</th>
					<th width="20%">Sted</th>
					<th width="40%">Merknad</th>
				</tr>
				<xsl:apply-templates select="po:TidsfestetHendelse"/>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:InfoReservasjon">
		<div id="InfoReservasjon">
			<!--<h3>Reservasjoner</h3>--><br/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="po:ReservasjonOnske">
		<xsl:if test="not(preceding-sibling::po:ReservasjonOnske)">
			<xsl:for-each select="..">
				<table width="95%">
					<tr>
						<th width="30%">Reservasjoner</th>
						<th width="15%">Framsatt av</th>
						<th width="10%">Framsatt dato</th>
						<th width="15%">Trukket tilbake av</th>
						<th width="10%">Trukket tilbake dato</th>
						<th width="20%">Merknad</th>
					</tr>
					<xsl:for-each select="po:ReservasjonOnske">
						<tr>
							<td>
								<xsl:value-of select="po:Gjelder"/>
							</td>
							<td>
								<xsl:value-of select="po:FramsattAv/fk1:GivenName"/>&#160;<xsl:value-of select="po:FramsattAv/fk1:FamilyName"/>
							</td>
							<td>
								<xsl:value-of select="po:FramsattDato"/>
							</td>
							<td>
								<xsl:value-of select="po:TrukketTilbakeAv/fk1:GivenName"/>&#160;<xsl:value-of select="po:TrukketTilbakeAv/fk1:FamilyName"/>
							</td>
							<td>
								<xsl:value-of select="po:TrukketTilbakeDato"/>
							</td>
							<td>
								<xsl:value-of select="po:Merknad"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:InfoKontrolltime">
		<xsl:if test="not(preceding-sibling::po:InfoKontrolltime)">
			<h2 id="InfoKontrolltime">Kontrolltime</h2>
			<xsl:for-each select="..">
				<xsl:for-each select="po:InfoKontrolltime">
					<table width="95%">
						<xsl:apply-templates/>
					</table>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:InformasjonOmTime">
		<b>Informasjon om kontrolltime</b>
		<!--<tr>
			<td colspan="6">
				
			</td>
		</tr>-->
		<tr>
			<th width="20%">Er kontrolltime bestillt</th>
			<th width="15%">Tidspunkt for time</th>
			<th width="15%">Varighet</th>
			<th width="20%">Sted</th>
			<th width="15%">Pasient informert</th>
			<th width="15%">Pårørende informert</th>
		</tr>
		<tr>
			<xsl:choose>
				<xsl:when test="po:BestiltKontrolltime">
					<td>Ja</td>
				</xsl:when>
				<xsl:otherwise>
					<td>Nei</td>
				</xsl:otherwise>
			</xsl:choose>
			<td>
				<xsl:call-template name="skrivUtDateTime">
					<xsl:with-param name="oppgittTid" select="po:TidspunktTime"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:value-of select="po:Varighet"/> min</td>
			<td>
				<xsl:value-of select="po:StedTime"/>
			</td>
			<xsl:if test="po:InformertOm">
			<xsl:choose>
				<xsl:when test="po:InformertOm/po:PasientInformert='true'">
					<td>Ja</td>
				</xsl:when>
				<xsl:otherwise>
					<td>Nei</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="po:InformertOm/po:ParorendeInformert='true'">
					<td>Ja</td>
				</xsl:when>
				<xsl:otherwise>
					<td>Nei</td>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:if>
		</tr>
	</xsl:template>
	<xsl:template match="po:KontrolltimeBestill">
		<b>&#160;</b>
		<!--<tr>
			<td colspan="6">
				<b>Kontrolltime må bestilles</b>
			</td>
		</tr>-->
		<tr>
			<th colspan="4">Kontrolltime skal bestilles</th>
			<th width="15%">Pasient informert</th>
			<th width="15%">Pårørende informert</th>
		</tr>
		<tr>
			<xsl:choose>
				<xsl:when test="po:PasientParorendeBestiller='true'">
					<td colspan="4">Pasient/pårørende må selv bestille kontrolltime hos egen lege</td>
				</xsl:when>
				<xsl:otherwise>
					<td colspan="4">Kontrolltimen vil bestilles for pasienten</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="po:InformertOm">
			<xsl:choose>
				<xsl:when test="po:InformertOm/po:PasientInformert='true'">
					<td>Ja</td>
				</xsl:when>
				<xsl:otherwise>
					<td>Nei</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="po:InformertOm/po:ParorendeInformert='true'">
					<td>Ja</td>
				</xsl:when>
				<xsl:otherwise>
					<td>Nei</td>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:if>
		</tr>
	</xsl:template>
	<xsl:template match="po:OpplysningerOmHjelpemidler">
		<h2 id="OpplysningerOmHjelpemidler">Registrerte hjelpemidler</h2>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="po:FasteHjelpemidler">
		<xsl:if test="not(preceding-sibling::po:FasteHjelpemidler)">
			<b>Personlige hjelpemidler</b>
			<xsl:choose>
				<!-- ** Dersom det er flere forekomster av FasteHjelpemidler skrives det ut i tabell med overkskriftsrader ** -->
				<xsl:when test="count(../po:FasteHjelpemidler)>1">
					<table width="100%">
						<tr>
							<th width="20%">Briller</th>
							<th width="20%">Hjelpemiddel hørsel</th>
							<th width="20%">Pacemaker</th>
							<th width="40%">Annet</th>
						</tr>
						<xsl:for-each select="..">
							<xsl:for-each select="po:FasteHjelpemidler">
								<tr>
									<td>
										<xsl:value-of select="po:Briller/@DN"/>
									</td>
									<td>
										<xsl:value-of select="po:HjelpemiddelHorsel/@DN"/>
									</td>
									<td>
										<xsl:if test="po:Pacemaker='true' or po:Pacemaker='1'">Ja</xsl:if>
										<xsl:if test="po:Pacemaker='false' or po:Pacemaker='0'">Nei</xsl:if>
									</td>
									<td>
										<xsl:value-of select="po:Merknad"/>
									</td>
								</tr>
							</xsl:for-each>
						</xsl:for-each>
					</table>
				</xsl:when>
				<!-- ** Kun en forekomst av FasteHjelpemidler og innhold skrives ut uten bruk av tabell med overkskriftsrader ** -->
				<xsl:otherwise>
					<table>
						<tr>
							<td>
								<xsl:if test="po:Briller">
										Briller: <xsl:value-of select="po:Briller/@DN"/>
									<br/>
								</xsl:if>
								<xsl:if test="po:HjelpemiddelHorsel">
										Hjelpemiddel hørsel: <xsl:value-of select="po:HjelpemiddelHorsel/@DN"/>
									<br/>
								</xsl:if>
								<xsl:if test="po:Pacemaker='true'">
										Pacemaker<br/>
								</xsl:if>
								<xsl:if test="po:Merknad">
										Annet: <xsl:value-of select="po:Merknad"/>
								</xsl:if>
							</td>
						</tr>
					</table>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:StatusHjelpemiddel">
		<xsl:if test="not(preceding-sibling::po:StatusHjelpemiddel)">
			<xsl:if test="../po:FasteHjelpemidler">
				<br/>
				<!--<b>Andre hjelpemidler</b>-->
			</xsl:if>
			<table id="tableWidth50">
				<!--<tr>
					<td colspan="4">
						<b>Andre hjelpemidler</b>
					</td>
				</tr>-->
				<tr>
					<th width="40%">Andre hjelpemiddel</th>
					<th width="20%">Status</th>
					<!--<th width="40%">Hjelpemiddelkode RTV</th>-->
				</tr>
				<xsl:for-each select="..">
					<xsl:for-each select="po:StatusHjelpemiddel">
						<tr>
							<td>
								<xsl:value-of select="po:Hjelpemiddelbeskrivelse/po:BetegnelseHjelpemiddel"/>
							</td>
							<td>
								<xsl:value-of select="po:Status/@DN"/>
							</td>
							<!--<td>
								<xsl:value-of select="po:Hjelpemiddelbeskrivelse/po:HjelpemiddelkodeRTV"/>
							</td>-->
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:Foresporsel">
		<h2>Opprinnelig forespørsel</h2>
		<table>
			<tbody>
				<tr>
					<th>Type forespørsel</th>
					<td colspan="5">
						<xsl:value-of select="po:TypeForesp/@DN"/>
					</td>
				</tr>
				<xsl:if test="po:Hastegrad">
					<tr>
						<th>Hastegrad</th>
						<td colspan="5">
							<xsl:value-of select="po:Hastegrad/@DN"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="po:Formål or po:Begrunnelse">
					<tr>
						<th>Formål (kodet)</th>
						<td>
							<xsl:value-of select="po:Formål/@DN"/>
						</td>
						<th>Utdyping av formål</th>
						<td colspan="3">
							<xsl:value-of select="po:Begrunnelse"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="po:typeJournalinfo or po:FraDato or po:TilDato">
					<tr>
						<th>Type journalinformasjon</th>
						<td>
							<xsl:value-of select="po:TypeJournalinfo/@DN"/>
						</td>
						<th>Fra dato</th>
						<td>
							<xsl:value-of select="po:FraDato"/>
						</td>
						<th>Til dato</th>
						<td>
							<xsl:value-of select="po:TilDato"/>
						</td>
					</tr>
				</xsl:if>
				<tr>
					<td colspan="6">
						<xsl:value-of select="po:Sporsmal"/>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template match="po:EksisterendeTjeneste">
		<xsl:if test="not(preceding-sibling::po:EksisterendeTjeneste)">
			<h2 id="EksisterendeTjeneste">Eksisterende tjenester</h2>
		</xsl:if>
		<table width="100%">
			<xsl:if test="not(preceding-sibling::po:EksisterendeTjeneste)">
				<tr>
					<th width="20%">Tjeneste</th>
					<!--<th width="19%">IPLOS tj. type</th>-->
					<!--<th width="15%">Privat tj.</th>-->
					<th width="20%">Levert av</th>
					<th width="20%">Merknad</th>
					<th width="10%">Antall enheter</th>
					<th width="10%">Omfang</th>
					<th width="10%">Start</th>
					<th width="10%">Slutt</th>
				</tr>
			</xsl:if>
			<tr>
				<td width="20%">
					<xsl:choose>
						<xsl:when test="po:BetegnelseTjeneste">
							<xsl:value-of select="po:BetegnelseTjeneste"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="po:IPLOStjenestetype/@DN"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<!--<td width="19%">
					<xsl:choose>
						<xsl:when test="po:IPLOStjenestetype">
							<xsl:value-of select="po:IPLOStjenestetype/@DN"/>
							<br/>
						</xsl:when>
						<xsl:otherwise>Ikke oppgitt.<br/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td width="15%">
					<xsl:if test="po:PrivatTjeneste = 'true'">Ja</xsl:if>
				</td>-->
				<td width="20%">
					<xsl:value-of select="po:TjenestenLevertAv"/>
				</td>
				<td width="20%">
					<xsl:value-of select="po:OpplysningerOmTjenesten"/>
				</td>
				<td width="10%">
					<xsl:value-of select="po:AntallEnheter"/>
				</td>
				<td width="10%">
					<xsl:value-of select="po:Enhet"/>
				</td>
				<td width="10%">
					<xsl:value-of select="po:Startdato"/>
				</td>
				<td width="10%">
					<xsl:value-of select="po:Sluttdato"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="po:TjenestenLevertAv">
		Tjenesten leveres av <xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="po:Sykepleierdokumentasjon">
		<h2 id="Sykepleieopplysninger">Sykepleieopplysninger</h2>
		<xsl:apply-templates select="epj3:LegemidlerAdministrertVedOverforing"/>
		<xsl:apply-templates select="po:InfoFraSykepleier"/>
		<xsl:apply-templates select="po:InfoAvtaleOmLegemiddeladm"/>
		<xsl:apply-templates select="po:InfoVurderinger"/>
		<xsl:apply-templates select="po:IverksatteTiltak"/>
		<xsl:apply-templates select="po:AnbefaltVidereTiltak"/>
		<xsl:apply-templates select="po:InfoMaalForventetRes"/>
		<xsl:apply-templates select="po:Ansvarlig"/>
		<xsl:apply-templates select="po:TjenesterSomMottas"/>
		<!-- <xsl:apply-templates/>-->
	</xsl:template>
	<xsl:template match="po:TjenesterSomMottas">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="po:OpplysningerAndreFaggrupper">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="po:AndreFagrapporter" name="po:AndreFagrapporter">
		<h2 Id="OpplysningerAndreFaggrupper">Andre fagrapporter</h2>
		<table width="95%">
			<xsl:if test="(po:BehandlingStart) or (po:StatusInnleggelse) or (po:StatusBehandlingsstart) or po:ForventetStatusUtskriving">
				<tr>
					<th width="20%">Behandling start</th>
					<th width="30%">Status innleggelse</th>
					<th width="25%">Status behandlingsstart</th>
					<th width="25%">Forventet status v. utskriving</th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="po:BehandlingStart"/>
					</td>
					<td>
						<xsl:value-of select="po:StatusInnleggelse"/>
					</td>
					<td>
						<xsl:value-of select="po:StatusBehandlingsstart"/>
					</td>
					<td>
						<xsl:value-of select="po:ForventetStatusUtskriving"/>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="po:AnsvarligRapport">
				<tr>
					<th valign="top">Ansvarlig for rapport</th>
					<td colspan="3">
						<xsl:if test="po:AnsvarligRapport/fk1:TypeHealthcareProfessional">
							<xsl:value-of select="po:AnsvarligRapport/fk1:TypeHealthcareProfessional/@DN"/>&#160;
						</xsl:if>
						<xsl:value-of select="po:AnsvarligRapport/fk1:GivenName"/>&#160;<xsl:value-of select="po:AnsvarligRapport/fk1:FamilyName"/>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="epj2:Journaltekst">
				<tr>
					<td colspan="4">
						<xsl:apply-templates select="epj2:Journaltekst"/>
					</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>
	<xsl:template match="po:InfoKartleggingFunksjonsniva" name="po:InfoKartleggingFunksjonsniva">
		<h2 id="InfoKartleggingFunksjonsniva">IPLOS: Kartlegging av funksjonsnivå</h2>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="po:SamletVurderingFunksjonsniva" name="po:SamletVurderingFunksjonsniva">
		<xsl:if test="not(preceding-sibling::po:SamletVurderingFunksjonsniva)">
			<xsl:for-each select="..">
				<h3>
					<i>Samlet vurdering av funksjonsnivå</i>
				</h3>
				<table width="95%">
					<tr>
						<th width="35%">Pleietyngde</th>
						<th width="15%">VurderingPleietyngde</th>
						<th width="50%">Merknad</th>
					</tr>
					<xsl:for-each select="po:SamletVurderingFunksjonsniva">
						<tr>
							<td>
								<xsl:value-of select="po:Pleietyngde"/>
							</td>
							<td>
								<xsl:value-of select="po:VurderingPleietyngde"/>
							</td>
							<td>
								<xsl:value-of select="po:Merknad"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:KartlagtFunksjon" name="po:KartlagtFunksjon">
		<xsl:if test="not(preceding-sibling::po:KartlagtFunksjon)">
			<xsl:for-each select="..">
				<!--<br/>
				<b>
					<i>Kartlagt funksjon</i>
				</b>-->
				<table width="95%">
					<tr>
						<th width="35%">Funksjonsvariabel</th>
						<th width="15%">Vurdering</th>
						<th width="50%">Merknad</th>
					</tr>
					<xsl:for-each select="po:KartlagtFunksjon">
						<tr>
							<td>
								<xsl:value-of select="po:Funksjonsvariabel/@DN"/>
							</td>
							<td>
								<xsl:value-of select="po:Vurdering"/>
							</td>
							<td>
								<xsl:value-of select="po:Merknad"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:TjenesteBehov" name="po:TjenesteBehov">
		<xsl:if test="not(preceding-sibling::po:TjenesteBehov)">
			<xsl:for-each select="..">
				<h3>Behov for tjenester</h3>
				<table width="95%">
					<tr>
						<!--<th width="25%">IPLOS tjenestetype</th>-->
						<th width="20%">Betegnelse tjeneste</th>
						<th width="35%">Beskrivelse tjeneste</th>
						<th width="20%">Ved institusjon</th>
						<th width="10%">Enheter ønsket</th>
						<th width="10%">Enhet</th>
					</tr>
					<xsl:for-each select="po:TjenesteBehov">
						<tr>
							<!--<td>
								<xsl:value-of select="po:IPLOStjenestetype/@DN"/>
							</td>-->
							<td>
								<xsl:value-of select="po:BetegnelseTjeneste"/>
							</td>
							<td>
								<xsl:value-of select="po:BeskrivelseAvTjeneste"/>
							</td>
							<td>
								<xsl:value-of select="po:VedInstitusjon"/>
							</td>
							<td>
								<xsl:value-of select="po:AntallEnheterOnsket"/>
							</td>
							<td>
								<xsl:value-of select="po:Enhet"/>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:Ansvarlig" name="po:Ansvarlig">
		<xsl:if test="not(preceding-sibling::po:Ansvarlig)">
			<xsl:for-each select="..">
				<br/>
				<table width="95%">
					<tr>
						<th width="15%">Hendelse</th>
						<th width="25%">Tidspunkt for hendelse</th>
						<th width="15%">Eksternt helsepersonell</th>
						<th width="45">Merknad</th>
					</tr>
					<xsl:for-each select="po:Ansvarlig">
						<tr>
							<td>
								<xsl:value-of select="po:TypeHendelse/@DN"/>
							</td>
							<td>
								<xsl:call-template name="skrivUtDateTime">
									<xsl:with-param name="oppgittTid" select="po:TidspunktForHendelse"/>
								</xsl:call-template>
							</td>
							<xsl:choose>
								<xsl:when test="po:Ekstern='True'">
									<td>Ja</td>
								</xsl:when>
								<xsl:otherwise>
									<td>Nei</td>
								</xsl:otherwise>
							</xsl:choose>
							<td>
								<xsl:value-of select="po:Merknad"/>
							</td>
						</tr>
						<xsl:if test="po:AnsvarligTjenesteyter">
							<th>Tjenesteyter</th>
							<td colspan="1">
								<xsl:value-of select="po:AnsvarligTjenesteyter/fk1:FamilyName"/>, <xsl:value-of select="po:AnsvarligTjenesteyter/fk1:GivenName"/>
							</td>
						</xsl:if>
						<xsl:if test="po:Virksomhet">
							<th>Virksomhet</th>
							<td colspan="1">
								<xsl:value-of select="po:Virksomhet/fk1:OrganisationName"/>
							</td>
						</xsl:if>
						<xsl:if test="po:AnsvarligTjenesteyter">
							<!-- <tr>
							<th>Ansvarlig</th>
							<td colspan="3"><xsl:apply-templates select="po:AnsvarligTjenesteyter"/></td>	
						</tr>-->
						</xsl:if>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:InfoMedisinskDiagnose">
		<h2 id="InfoMedisinskDiagnose">Medisinske diagnoser</h2><br/>
		<table>
			<tbody>
				<tr>
					<th width="30%">Medisinske diagnoser</th>
					<th width="50%">Diagnosebeskrivelse</th>
					<th width="20%">Hoved-/bidiagnose</th>
				</tr>
				<xsl:apply-templates/>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template match="po:MedisinskDiagnose">
		<tr>
			<td>
				<xsl:value-of select="po:Diagnosekode/@DN"/> (<xsl:value-of select="po:Diagnosekode/@V"/>)
			</td>
			<td>
				<xsl:value-of select="po:DiagnoseBeskrivelse"/>
			</td>
			<xsl:choose>
				<xsl:when test="po:Hoveddiagnose = 'true' or po:Hoveddiagnose = '1'">
					<td>
						<b>Hoveddiagnose</b>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>Bidiagnose</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
	</xsl:template>
	<xsl:template match="po:InfoLegemidlerIBruk">
		<div id="InfoLegemidlerIBruk">
			<h2>Legemidler i bruk</h2>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="po:InfoSeponertLegemiddel">
		<h2>Seponerte legemiddel</h2>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="po:InfoFraSykepleier">
		<br/>
		<xsl:apply-templates select="epj2:Journaltekst"/>
		<xsl:apply-templates select="po:OpplysningerRelevantOppfolging"/>
		<!--<xsl:apply-templates/>-->
	</xsl:template>
	<xsl:template match="po:MedisinskfagligeOpplysninger">
		<h2 id="MedisinskfagligeOpplysninger">Medisinskfaglige opplysninger</h2>
		<xsl:apply-templates select="po:RegistrertBlodtype"/>
		<xsl:apply-templates select="epj1:Cave"/>
		<xsl:apply-templates select="epj1:Allerginotat"/>
		<xsl:apply-templates select="epj2:GenereltJournalnotat"/>
		<xsl:apply-templates select="po:InfoTidligereSykdommer"/>
	</xsl:template>
	<xsl:template match="po:RegistrertBlodtype">
		<h3>Bloddtype</h3>
		<table id="tableWidth50">
			<tbody>
				<tr>
					<th>Blodtype</th>
					<th>Rhesusgruppe</th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="po:Blodtype/@DN"/>
					</td>
					<td>
						<xsl:value-of select="po:Rhesusgruppe/@DN"/>
					</td>
				</tr>
				<xsl:if test="po:Merknad">
					<tr>
						<th>Merknad</th>
						<td colspan="2">
							<xsl:value-of select="po:Merknad"/>
						</td>
					</tr>
				</xsl:if>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template match="po:InfoTidligereSykdommer" name="po:InfoTidligereSykdommer">
		<xsl:if test="not(preceding-sibling::po:InfoTidligereSykdommer)">
			<!--<h3>Tidligere sykdom</h3>--><br/>
		</xsl:if>
		<table border="0">
			<xsl:if test="not(preceding-sibling::po:InfoTidligereSykdommer)">
				<tr>
					<th width="40%">Diagnosekode tidligere sykdom</th>
					<th width="30%">Funksjonshemming/kronisk sykdom</th>
					<th width="30%">Stikkord</th>
				</tr>
			</xsl:if>
			<xsl:apply-templates select="po:TidligereSykdomFragment"/>
		</table>
	</xsl:template>
	<xsl:template match="po:TidligereSykdomFragment" name="po:TidligereSykdomFragment">
		<tr>
			<td width="40%">
				<xsl:value-of select="po:Diagnosekode/@DN"/> (<xsl:value-of select="po:Diagnosekode/@V"/>)</td>
			<xsl:choose>
				<xsl:when test="po:FunksjonshemmingKroniskSykdom='true'">
					<td width="30%">Ja</td>
				</xsl:when>
				<xsl:otherwise>
					<td width="30%">Nei</td>
				</xsl:otherwise>
			</xsl:choose>
			<td width="30%">
				<xsl:value-of select="po:TidligereSykdom"/>
			</td>
		</tr>
		<xsl:if test="../epj2:Journaltekst">
			<tr>
				<td colspan="3">
					<i>Merknad:</i>&#160;
					<xsl:if test="../epj2:Journaltekst/epj2:Notat">
						<xsl:value-of select="../epj2:Journaltekst/epj2:Notat"/>
					</xsl:if>
					<xsl:if test="../epj2:Journaltekst/epj2:Merknad">
						<br/>
						<xsl:value-of select="../epj2:Journaltekst/epj2:Merknad"/>
					</xsl:if>
				</td>
				<!--<td>
					<xsl:apply-templates select="epj2:Journaltekst"/>
				</td>-->
			</tr>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:InnholdKonsultasjon" name="po:InnholdKonsultasjon">
		<xsl:if test="not(preceding-sibling::po:InnholdKonsultasjon)">
			<!--<h3>Type innhold i melding</h3>-->
			<table>
				<tr>
					<th>Type Melding</th>
					<th>Merknad</th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="po:TypeInnholdKonsultasjon/@DN"/>
					</td>
					<td>
						Merknad: <xsl:value-of select="po:Merknad"/>
					</td>
				</tr>
			</table>
		</xsl:if>
		<!--<table>
			<tr>
				<th width="50%">Type konsultasjon</th>
				<th width="50%">Merknad</th>
			</tr>
			<tr>
				<td>
					<xsl:value-of select="po:TypeInnholdKonsultasjon/@DN"/>
				</td>
				<td>
					<xsl:value-of select="po:Merknad"/>
				</td>
			</tr>
		</table>-->
	</xsl:template>
	<xsl:template match="po:TypeInnholdIMelding" name="po:TypeInnholdIMelding">
		<xsl:if test="not(preceding-sibling::po:TypeInnholdIMelding)">
			<!--<h3>Type innhold i melding</h3>-->
		</xsl:if>
		<table>
			<tr>
				<th width="30%">Type melding</th>
				<th width="70%">Merknad</th>
			</tr>
			<tr>
				<td>
					<xsl:value-of select="po:TypeInnhold/@DN"/>
				</td>
				<td>
					<xsl:value-of select="po:Merknad"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="po:InfoKontaktepisode" name="po:InfoKontaktepisode">
		<xsl:if test="not(preceding-sibling::po:InfoKontaktepisode)">
			<xsl:for-each select="..">
				<h2>Kontaktepisode</h2>
				<xsl:for-each select="po:InfoKontaktepisode">
					<table>
						<xsl:for-each select="po:FellesinfoKontaktepisode">
							<tr>
								<th>Kontakttype</th>
								<th>Konsultasjonsform</th>
								<th>Kontakt startet</th>
								<th>Kontakt avsluttet</th>
							</tr>
							<tr>
								<td>
									<xsl:value-of select="po:Kontakttype/@DN"/>
								</td>
								<td>
									<xsl:value-of select="po:Konsultasjonsform/@DN"/>
								</td>
								<td>
									<xsl:call-template name="skrivUtDateTime">
										<xsl:with-param name="oppgittTid" select="po:KontaktStartet/@V"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:call-template name="skrivUtDateTime">
										<xsl:with-param name="oppgittTid" select="po:KontaktAvsluttet/@V"/>
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Merknad</th>
								<td>
									<xsl:value-of select="po:Merknad"/>
								</td>
							</tr>
						</xsl:for-each>
						<xsl:for-each select="po:TilleggsinfoKontaktepisode">
							<tr>
								<th colspan="2">Sted for kontaktepisode</th>
								<th colspan="2">Sted for kontakt</th>
							</tr>
							<tr>
								<td>
									<xsl:value-of select="po:StedForKontaktepisode/@DN"/>
								</td>
								<td>
									<xsl:value-of select="po:StedForKontakt"/>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:Fraversassistent" name="po:Fraversassistent">
		<!--<h2>Fraværsassistent</h2>-->
		<table width="80%">
			<tr>
				<th width="20%">Mottaker er fraværende</th>
				<th width="20%">Melding er videresendt</th>
				<th width="20%">Fraværende fra dato</th>
				<th width="20%">Fraværende til dato</th>
				<th width="20%">Videresendt til</th>
			</tr>
			<tr>
				<xsl:choose>
					<xsl:when test="po:MottakerFravarende='true' or po:MottakerFravarende='1'">
						<td>Ja</td>
					</xsl:when>
					<xsl:otherwise>
						<td>Nei</td>
					</xsl:otherwise>
				</xsl:choose>
				<td>
					<xsl:if test="po:MeldingVideresendt='true' or po:MeldingVideresendt='1'">Ja</xsl:if>
					<xsl:if test="po:MeldingVideresendt='false' or po:MeldingVideresendt='0'">Nei</xsl:if>
				</td>
				<td>
					<xsl:value-of select="po:FravarendeFraDato"/>
				</td>
				<td>
					<xsl:value-of select="po:FravarendeTilDato"/>
				</td>
				<td>
					<xsl:value-of select="po:VideresendtTil/fk1:GivenName"/>&#160;<xsl:value-of select="po:VideresendtTil/fk1:FamilyName"/>
				</td>
			</tr>
			<xsl:if test="po:Merknad">
				<tr>
					<td colspan="5">
					Merknad:&#160;<xsl:value-of select="po:Merknad"/>
					</td>
				</tr>
			</xsl:if>
		</table>
		<br/>
	</xsl:template>
	<xsl:template match="po:InfoAndreViktigeOpplysninger">
		<h2 id="InfoAndreViktigeOpplysninger">Andre viktige opplysninger</h2>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="po:OpplysningerRelevantOppfolging">
		<!--<h3>Opplysninger relevant for oppfølging</h3>--><br/>
		<table style="border-style: outset;">
			<tr>
				<th width="40%">Er bandasjemateriell og engangsutstyr sendt med pasient</th>
				<th width="30%">Trenger hjelp til legemiddeladm</th>
				<th width="30%">Endring i funksjonsnivå</th>
			</tr>
			<tr>
				<td>
					<xsl:if test="po:BandasjemateriellEngangsutstyr = 'true' or po:BandasjemateriellEngangsutstyr = '1'">Ja</xsl:if>
					<xsl:if test="po:BandasjemateriellEngangsutstyr = 'false' or po:BandasjemateriellEngangsutstyr = '0'">Nei</xsl:if>
				</td>
				<td>
					<xsl:if test="po:HjelpLegemiddeladm = 'true' or po:HjelpLegemiddeladm = '1'">Ja</xsl:if>
					<xsl:if test="po:HjelpLegemiddeladm = 'false' or po:HjelpLegemiddeladm = '1'">Nei</xsl:if>
				</td>
				<td>
					<xsl:value-of select="po:EndringFunksjonsnivaa"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="po:InfoAvtaleOmLegemiddeladm">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="po:AvtaleOmAdmLegemidler">
		<!--<h3>Avtale om administrering av legemidler</h3>--><br/>
		<table>
			<tr>
				<th width="20%">Avtale om adm. av legemidler</th>
				<th width="20%">Avtale om adm. av multidose</th>
				<th colspan="2" width="60%">Merknad</th>
			</tr>
			<tr>
				<xsl:choose>
					<xsl:when test="po:AvtaleAdmLegemidler = 'true' or po:AvtaleAdmLegemidler='1'">
						<td>Ja</td>
					</xsl:when>
					<xsl:otherwise>
						<td>Nei</td>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="po:AvtaleAdmMultidose = 'true' or po:AvtaleAdmMultidose = '1'">
						<td>Ja</td>
					</xsl:when>
					<xsl:otherwise>
						<td>Nei</td>
					</xsl:otherwise>
				</xsl:choose>
				<td colspan="2">
					<xsl:value-of select="po:Merknad"/>
				</td>
			</tr>
			<xsl:if test="po:AdmInstrukser">
				<tr>
					<th>Utleveringsform</th>
					<td>
						<xsl:value-of select="po:AdmInstrukser/po:Utleveringsform/@DN"/>
					</td>
					<th>Særskilte tiltak</th>
					<td>
						<xsl:for-each select="po:AdmInstrukser/po:SarskilteTiltak">
							<xsl:value-of select="./@DN"/>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>
	<xsl:template match="po:InfoVurderinger" name="po:InfoVurderinger">
		<xsl:if test="not(preceding-sibling::po:InfoVurderinger)">
			<!--<h3>Vurderinger</h3>--><br/>
		</xsl:if>
		<table width="95%">
			<xsl:for-each select="po:InnholdVurdering">
				<xsl:if test="po:KategoriHelsepersonell">
					<tr>
						<th colspan="4">Utført av:&#160;<xsl:value-of select="po:KategoriHelsepersonell/@DN"/>
						</th>
					</tr>
				</xsl:if>
				<tr>
					<th width="40%">Vurderinger</th>
					<th width="20%">Stikkord</th>
					<th width="20%">Fra dato</th>
					<th width="20%">Til dato</th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="po:VurderingenGjelder"/>
					</td>
					<td>
						<xsl:value-of select="po:Stikkord"/>
					</td>
					<td>
						<xsl:value-of select="po:FraDato"/>
					</td>
					<td>
						<xsl:value-of select="po:TilDato"/>
					</td>
				</tr>
				<xsl:if test="po:EnkeltVurdering">
					<tr>
						<th>Funksjonsområde</th>
						<th>Kodet vurdering</th>
						<th colspan="2">Vurdering</th>
					</tr>
					<xsl:for-each select="po:EnkeltVurdering">
						<tr>
							<td>
								<xsl:value-of select="po:Funksjonsområde/@DN"/>
							</td>
							<td>
								<xsl:value-of select="po:KodetVurdering/@DN"/>
							</td>
							<td colspan="2">
								<xsl:value-of select="po:VurderingTekst"/>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
			<tr>
				<td colspan="4">
					<xsl:apply-templates select="epj2:Journaltekst"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="po:IverksatteTiltak" name="po:IverksatteTiltak">
		<xsl:if test="not(preceding-sibling::po:IverksatteTiltak)">
			<h3>Observasjoner og iverksatte tiltak</h3>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="po:AnbefaltVidereTiltak" name="po:AnbefaltVidereTiltak">
		<xsl:if test="not(preceding-sibling::po:AnbefaltVidereTiltak)">
			<h3>Anbefalt videre tiltak</h3>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="po:Tiltaksbeskrivelse">
		<table id="tableWidth50">
			<!--<tr>
				<th width="100%">Stikkord</th>
				<th width="35%">Beskrivelse intervensjon/tiltak</th>
				<th width="15%">Kategori helsepersonell</th>
				<th width="10%">Tidspunkt for eval.</th>
				<th width="20%">Merknad</th>
			</tr>-->
			<tr>
				<td>
					<xsl:value-of select="po:Stikkord"/>&#160;<xsl:value-of select="po:IntervensjonTiltakBeskrivelse"/>&#160;<xsl:value-of select="po:Merknad"/>
				</td>
				<!--<td>
					<xsl:value-of select="po:IntervensjonTiltakKode/@DN"/>&#160;<xsl:value-of select="po:IntervensjonTiltakBeskrivelse"/>
				</td>
				<td>
					<xsl:value-of select="po:KategoriHelsepersonell/@DN"/>
				</td>
				<td>
					<xsl:value-of select="po:EvalueringTidspunkt"/>
				</td>
				<td>
					<xsl:value-of select="po:Merknad"/>
				</td>-->
			</tr>
			<xsl:for-each select="po:PlanlagtGjennomforingTiltak">
				<tr>
					<th colspan="4">Planlagt gjennomføring av tiltak</th>
				</tr>
				<tr>
					<th>Planlagt start</th>
					<th>Planlagt slutt</th>
					<th>Tidspunkt</th>
					<th>Etter behov?</th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="po:PlanlagtStart"/>
					</td>
					<td>
						<xsl:value-of select="po:PlanlagtSlutt"/>
					</td>
					<td>
						<xsl:for-each select="po:FasteUkedager">
							<xsl:apply-templates/>
						</xsl:for-each>
						<xsl:value-of select="po:GjentakelseIntervall/@V"/> per <xsl:value-of select="po:GjentakelseIntervall/@U"/>
						<xsl:if test="po:Tidsenhet">Tidsenhet:<xsl:value-of select="po:Tidsenhet/@DN"/>
						</xsl:if>
					</td>
					<td>
						<xsl:if test="po:EtterBehov = 'true' or po:EtterBehov = '1'">Ja</xsl:if>
						<xsl:if test="po:EtterBehov = 'false' or po:EtterBehov = '0'">Nei</xsl:if>
					</td>
				</tr>
			</xsl:for-each>
			<xsl:if test="po:GjennomforingAvTiltak">
				<tr>
					<th colspan="4">Gjennomføring av tiltak</th>
				</tr>
				<tr>
					<th>Utført</th>
					<th>Kan termineres</th>
					<th colspan="2">Merknad</th>
				</tr>
				<xsl:for-each select="po:GjennomforingAvTiltak">
					<tr>
						<td>
							<xsl:value-of select="po:UtfortTidspunkt"/>
						</td>
						<td>
							<xsl:if test="po:TiltakKanTermineres='true' or po:TiltakKanTermineres='1'">Ja</xsl:if>
							<xsl:if test="po:TiltakKanTermineres='false' or po:TiltakKanTermineres='0'">Nei</xsl:if>
						</td>
						<td colspan="2">
							<xsl:value-of select="po:Merknad"/>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:if>
		</table>
	</xsl:template>
	<xsl:template match="po:InfoMaalForventetRes" name="po:InfoMaalForventetRes">
		<xsl:if test="not(preceding-sibling::po:InfoMaalForventetRes)">
			<h3>Mål for opphold</h3>
			<xsl:for-each select="..">
				<table width="95%">
					<xsl:choose>
						<xsl:when test="po:InnholdMaaldokument/po:MaalForventetResultat or po:InnholdMaaldokument/po:ForventetGradMaaloppnaaelse or po:InnholdMaaldokument/po:ForventesOppnaadd or po:InnholdMaaldokument/po:FraDato or po:InfoMaalForventetRes/po:InnholdMaaldokument/po:TilDato or po:InnholdMaaldokument/po:Stikkord">
							<tr>
								<th width="25%">Beskrivelse</th>
								<th width="15%">Mål/forventet res.</th>
								<th width="15%">Forventet grad måloppnåelse</th>
								<th width="15%">Forventes oppnådd</th>
								<th width="9%">Fra dato</th>
								<th width="9%">Til dato</th>
								<th width="12%">Stikkord</th>
							</tr>
							<xsl:for-each select="po:InfoMaalForventetRes">
								<tr>
									<td>
										<xsl:value-of select="po:InnholdMaaldokument/po:Beskrivelse"/>
									</td>
									<td>
										<xsl:value-of select="po:InnholdMaaldokument/po:MaalForventetResultat/@DN"/>
									</td>
									<td>
										<xsl:value-of select="po:InnholdMaaldokument/po:ForventetGradMaaloppnaaelse/@DN"/>
									</td>
									<td>
										<xsl:value-of select="po:InnholdMaaldokument/po:ForventesOppnaadd"/>
									</td>
									<td>
										<xsl:value-of select="po:InnholdMaaldokument/po:FraDato"/>
									</td>
									<td>
										<xsl:value-of select="po:InnholdMaaldokument/po:TilDato"/>
									</td>
									<td>
										<xsl:value-of select="po:InnholdMaaldokument/po:Stikkord"/>
									</td>
								</tr>
							</xsl:for-each>
							<xsl:if test="po:InfoMaalForventetRes/epj2:Journaltekst">
								<tr>
									<td colspan="7">
										<xsl:apply-templates select="po:InfoMaalForventetRes/epj2:Journaltekst"/>
									</td>
								</tr>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="po:InfoMaalForventetRes">
								<tr>
									<td colspan="7">
										<xsl:value-of select="po:InnholdMaaldokument/po:Beskrivelse"/>
									</td>
								</tr>
								<xsl:if test="epj2:Journaltekst">
									<tr>
										<td colspan="7">
											<xsl:apply-templates select="epj2:Journaltekst"/>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:InfoInformasjonGitt">
		<h2>Pasient/pårørende som er informert</h2>
		<table width="95%">
			<xsl:for-each select="po:InformasjonGitt">
				<tr>
					<!--<th width="10%">Type informasjon</th>-->
					<th width="20%">Person som er informert</th>
					<th width="10%">Form</th>
					<th width="10%">Dato</th>
					<th width="30%">Informert av</th>
					<th width="30%">Beskrivelse</th>
				</tr>
				<tr>
					<!--<td>
						<xsl:value-of select="po:TypeInformasjon/@DN"/>&#160;</td>-->
					<td valign="top" width="20%">
						<xsl:for-each select="po:InformasjonGittTil">
							<xsl:call-template name="fk1:Person-short"/>
						</xsl:for-each>
					</td>
					<td valign="top" width="10%">
						<xsl:choose>
							<xsl:when test="po:MuntligInformasjon = 'true'">Muntlig</xsl:when>
							<xsl:otherwise>Skriftlig</xsl:otherwise>
						</xsl:choose>
					</td>
					<td valign="top" width="10%">
						<xsl:value-of select="po:InformasjonGittDato"/>
					</td>
					<td valign="top" width="30%">
						<xsl:for-each select="po:InformasjonGittAv">
							<xsl:call-template name="fk1:HealthcareProfessional"/>
						</xsl:for-each>
					</td>
					<td valign="top" width="30%">
						<xsl:value-of select="po:BeskrivelseInformasjon"/>
					</td>
				</tr>
				<!--<tr>
					<th>Beskrivelse av informasjonen</th>
					<td colspan="4">
						<xsl:value-of select="po:BeskrivelseInformasjon"/>&#160;</td>
				</tr>-->
			</xsl:for-each>
		</table>
	</xsl:template>
	<!-- InfoInformasjonGitt -->
	<xsl:template match="po:TidsfestetHendelse" name="po:TidsfestetHendelse">
		<xsl:if test="not(preceding-sibling::po:TidsfestetHendelse)">
			<xsl:for-each select="..">
				<xsl:for-each select="po:TidsfestetHendelse">
					<tr>
						<td>
							<xsl:choose>
								<xsl:when test="contains(po:Hendelsekode/@S, '9121') and po:Hendelsekode/@V='13'">
									<font color="red"><xsl:value-of select="po:Hendelsekode/@DN"/></font>&#160;
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="po:Hendelsekode/@DN"/>&#160;
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td>
							<xsl:call-template name="skrivUtDateTime">
								<xsl:with-param name="oppgittTid" select="po:TidspunktForHendelse/@V"/>
							</xsl:call-template>
						</td>
						<!--<td>
							<xsl:choose>
								<xsl:when test="po:Anslag='true' or po:Anslag='1'">Anslått tidspunkt</xsl:when>
								<xsl:otherwise>Ikke anslått</xsl:otherwise>
							</xsl:choose>
						</td>-->
						<td>
							<xsl:value-of select="po:StedForHendelse"/>
						</td>
						<td>
							<xsl:value-of select="po:BeskrivelseAvHendelse"/>
							<xsl:if test="(po:BeskrivelseAvHendelse and po:Merknad)">
								<br/>
							</xsl:if>
							<xsl:value-of select="po:Merknad"/>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:for-each>
			<!--</table>-->
		</xsl:if>
	</xsl:template>
	<xsl:template match="po:InformasjonOmForsendelsen">
		<xsl:apply-templates select="po:Foresporsel"/>
	</xsl:template>
	<xsl:template match="po:OpplysningerTilSoknad">
		<h2>Opplysninger til søknad</h2>
		<table id="tableWidth50">
			<!--<tr>
				<xsl:if test="po:LegemiddellisteVedlagt">
					<th>Legemiddelliste vedlagt</th>
				</xsl:if>
				<xsl:if test="po:EgensoknadSendt">
					<th>Egensøknad sendt</th>
				</xsl:if>
				<xsl:if test="po:LegemidlerMedPasienten">
					<th>Legemidler sendt med pasienten</th>
				</xsl:if>
				<xsl:if test="po:Merknad">
					<th>Merknad</th>
				</xsl:if>
			</tr>-->
			<tr>
				<xsl:if test="po:LegemiddellisteVedlagt">
					<td>
						<xsl:choose>
							<xsl:when test="po:LegemiddellisteVedlagt='true'">Legemiddelliste er vedlagt</xsl:when>
							<xsl:otherwise>Legemiddelliste er ikke vedlagt</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="po:EgensoknadSendt">
					<td>
						<xsl:choose>
							<xsl:when test="po:EgensoknadSendt='true'">Egensøknad er sendt</xsl:when>
							<xsl:otherwise>Egensøknad er ikke sendt</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="po:LegemidlerMedPasienten">
					<td>
						<xsl:if test="po:LegemidlerMedPasienten='true'">Legemidler er sendt med pasienten</xsl:if>
						<xsl:if test="po:LegemidlerMedPasienten='false'">Legemidler er ikke sendt med pasienten</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="po:Merknad">
					<td>
						Merknad: <xsl:value-of select="po:Merknad"/>&#160;</td>
				</xsl:if>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="po:TypeInnholdOverforingHelseopplysninger">
		<h2>Type innhold i overføring av helseopplysninger</h2>
		<table>
			<tr>
				<th>Svar på forespørsel</th>
				<th>Søknadsbehandling</th>
				<th>Pasientsamtykke</th>
			</tr>
			<td>
				<xsl:choose>
					<xsl:when test="po:SvarForesp='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="po:Soknadsbehandling='true'">Ja</xsl:if>
				<xsl:if test="po:Soknadsbehandling='false'">Nei</xsl:if>
			</td>
			<td>
				<xsl:value-of select="po:Pasientsamtykke/@DN"/>
			</td>
			<tr>
				<th>Merknad</th>
				<td colspan="2">
					<xsl:value-of select="po:Merknad"/>&#160;</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="fk1:Organisation">
		<div class="Organisation">
			<table>
				<tr>
					<th colspan="2">Organisasjon</th>
				</tr>
				<tr>
					<th>Navn</th>
					<th>Id</th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="fk1:OrganisationName"/>&#160;<xsl:if test="fk1:TypeOrganisation">(<xsl:value-of select="fk1:TypeOrganisation/@DN"/>
						</xsl:if>
					</td>
					<td>
						<xsl:apply-templates select="fk1:Ident"/>
					</td>
				</tr>
				<tr>
					<th>Adresse</th>
					<td>
						<xsl:apply-templates select="fk1:Address"/>
					</td>
					<th>Elektronisk kommunikasjon</th>
					<td>
						<xsl:apply-templates select="fk1:TeleCom"/>
					</td>
				</tr>
			</table>
			<xsl:apply-templates select="fk1:Organisation"/>
		</div>
	</xsl:template>
	<xsl:template match="fk1:Person" name="fk1:Person-short" mode="short">
		<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/>&#160;<xsl:value-of select="fk1:FamilyName"/>&#160;<xsl:apply-templates select="fk1:TeleCom"/>
	</xsl:template>
	<xsl:template match="fk1:Person" name="fk1:Person">
		<div class="Person">
			<table width="95%">
				<!--<tr>
					<th width="50%">Navn</th>
					<th width="50%">Kontakt</th>-->
				<!--<th>Nasjonalitet</th>
					<th>Fødselsdato</th>-->
				<!--</tr>-->
				<tr>
					<td>
						<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/>&#160;<xsl:value-of select="fk1:FamilyName"/>
					</td>
					<!-- <td>
						<xsl:apply-templates select="fk1:Sex"/>
					</td>
					<td>
						<xsl:apply-templates select="fk1:Nationality"/>
					</td>
					<td>
						<xsl:apply-templates select="fk1:DateOfBirth"/>
					</td>
				</tr>
				<tr>
					<th>Id</th>
					<td colspan="3">
						<xsl:apply-templates select="fk1:Ident"/>
					</td>
				</tr>
				<tr>
					<th>Adresse</th>
					<td>
						<xsl:apply-templates select="fk1:Address"/>
					</td>
					<th>Elektronisk kommunikasjon</th>-->
					<td>
						<xsl:apply-templates select="fk1:TeleCom"/>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="po:Referanseperson">
		<xsl:call-template name="fk1:Person"/>
	</xsl:template>
	<!--<xsl:template match="fk1:HealthcareProfessional" name="fk1:HealthcareProfessional-short" mode="short">
		<b>
			<xsl:choose>
				<xsl:when test="fk1:RoleToPatient">
					<xsl:value-of select="fk1:RoleToPatient/@DN"/>
				</xsl:when>
				<xsl:otherwise>Helsepersonell: </xsl:otherwise>
			</xsl:choose>
		</b>
		<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/>&#160;<xsl:value-of select="fk1:FamilyName"/>&#160;
					<xsl:if test="fk1:TypeHealthcareProfessional">
			<xsl:value-of select="fk1:TypeHealthcareProfessional/@DN"/>&#160;</xsl:if>
	</xsl:template>-->
	<xsl:template match="fk1:HealthcareProfessional" name="fk1:HealthcareProfessional">
		<div class="HealthcareProfessional">
			<table style="border-width: 0px;" width="100%">
				<xsl:if test="fk1:RoleToPatient">
					<td width="30%">
						<b>
							<xsl:value-of select="fk1:RoleToPatient/@DN"/>
						</b>
					</td>
				</xsl:if>
				<td width="40%" valign="top">
					<xsl:if test="fk1:GivenName">
						<xsl:value-of select="fk1:GivenName"/>&#160;
					</xsl:if>
					<xsl:if test="fk1:MiddleName">
						<xsl:value-of select="fk1:MiddleName"/>&#160;
						</xsl:if>
					<xsl:if test="fk1:FamilyName">
						<xsl:value-of select="fk1:FamilyName"/>
					</xsl:if>
				</td>
				<td width="30%">
					<xsl:if test="fk1:TypeHealthcareProfessional">
						<xsl:value-of select="fk1:TypeHealthcareProfessional/@DN"/>&#160;</xsl:if>
				</td>
			</table>
		</div>
	</xsl:template>
	<!-- HCP-->
	<xsl:template match="po:Kontaktperson">
		<xsl:call-template name="fk1:HealthcareProfessional"/>
	</xsl:template>
	<xsl:template match="po:AnsvarligRapport">
		<xsl:call-template name="fk1:HealthcareProfessional"/>
	</xsl:template>
	<xsl:template match="po:AnsvarligTjenesteyter">
		<xsl:call-template name="fk1:HealthcareProfessional"/>
	</xsl:template>
	<xsl:template match="fk1:Address">
		<xsl:if test="fk1:TypeAddress">
			<xsl:value-of select="fk1:TypeAddress/@DN"/>:<br/>
		</xsl:if>
		<xsl:if test="fk1:StreetAdr">
			<xsl:value-of select="fk1:StreetAdr"/>
			<br/>
		</xsl:if>
		<xsl:if test="fk1:Postbox">
			<xsl:value-of select="fk1:Postbox"/>
			<br/>
		</xsl:if>
		<xsl:if test="fk1:PostalCode">
			<xsl:value-of select="fk1:PostalCode"/>&#xA0;</xsl:if>
		<xsl:if test="fk1:City">
			<xsl:value-of select="fk1:City"/>
			<br/>
		</xsl:if>
		<xsl:if test="fk1:County">
			<xsl:value-of select="fk1:County/@DN"/>
			<br/>
		</xsl:if>
		<xsl:if test="fk1:Country">
			<xsl:value-of select="fk1:Country/@DN"/>
			<br/>
		</xsl:if>
		<br/>
	</xsl:template>
	<xsl:template match="fk1:TeleCom">
		<xsl:if test="fk1:TypeTeleCom">
			<xsl:value-of select="fk1:TypeTelecom/@DN"/>:&#xA0;</xsl:if>
		<xsl:value-of select="fk1:TeleAddress/@V"/>
		<br/>
	</xsl:template>
	<xsl:template match="po:Sex">Kjønn: <xsl:value-of select="@DN"/>
		<br/>
	</xsl:template>
	<xsl:template match="po:Nationality">Nasjonalitet: <xsl:value-of select="@DN"/>
		<br/>
	</xsl:template>
	<xsl:template match="po:DateOfBirth">Fødselsdato: <xsl:value-of select="."/>
		<br/>
	</xsl:template>
	<xsl:template match="fk1:Ident">
		<xsl:value-of select="fk1:TypeId/@DN"/>:&#160;<xsl:value-of select="fk1:Id"/>
		<br/>
	</xsl:template>
	<xsl:template match="po:TypeHealthcareProfessional">
	Kategori helsepersonell: <xsl:value-of select="@DN"/>
	</xsl:template>
	<xsl:template match="po:Foresporsel">
		<h2>Mottatt forespørsel</h2>
		<table width="90%">
			<tbody>
				<tr>
					<th>Type forespørsel</th>
					<!--<th>Hastegrad</th>-->
					<th>Spørsmål</th>
				</tr>
				<tr>
					<td>
						<xsl:value-of select="po:TypeForesp/@DN"/>
					</td>
					<!--<td>
						<xsl:value-of select="po:Hastegrad/@DN"/>
					</td>-->
					<td>
						<xsl:value-of select="po:Sporsmal"/>
					</td>
				</tr>
				<!--<tr>
					<th>Type forespørsel</th>
					<td colspan="5">
						<xsl:value-of select="po:TypeForesp/@DN"/>
					</td>
				</tr>
				<xsl:if test="po:Hastegrad">
					<tr>
						<th>Hastegrad</th>
						<td colspan="5">
							<xsl:value-of select="po:Hastegrad/@DN"/>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="po:Formål or po:Begrunnelse">
					<tr>
						<th>Formål (kodet)</th>
						<td>
							<xsl:value-of select="po:Formål/@DN"/>
						</td>
						<th>Utdyping av formål</th>
						<td colspan="3">
							<xsl:value-of select="po:Begrunnelse"/>
						</td>
					</tr>
				</xsl:if>-->
				<xsl:if test="po:typeJournalinfo or po:FraDato or po:TilDato">
					<tr>
						<th>Type journalinformasjon</th>
						<th>Fra dato</th>
						<th>Til dato</th>
					</tr>
					<tr>
						<td>
							<xsl:value-of select="po:TypeJournalinfo/@DN"/>
						</td>
						<td>
							<xsl:value-of select="po:FraDato"/>
						</td>
						<td>
							<xsl:value-of select="po:TilDato"/>
						</td>
					</tr>
				</xsl:if>
				<!--<tr>
					<td colspan="6">
						<xsl:value-of select="po:Sporsmal"/>
					</td>
				</tr>-->
			</tbody>
		</table>
	</xsl:template>
	<xsl:template match="po:TilleggsopplysningPasient">
		<h2 id="TilleggsopplysningPasient">Andre pasientopplysninger</h2>
		<table id="tableWidth50">
			<tbody>
				<tr>
					<xsl:if test="po:SivilStatus">
						<th>Sivil status</th>
					</xsl:if>
					<xsl:if test="po:BorAlene">
						<th>Bor alene</th>
					</xsl:if>
					<xsl:if test="po:Sprak">
						<th>Språk</th>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="po:SivilStatus">
						<td>
							<xsl:value-of select="po:SivilStatus/@DN"/>
						</td>
					</xsl:if>
					<xsl:if test="po:BorAlene">
						<xsl:choose>
							<xsl:when test="po:BorAlene = 'true' or po:BorAlene = '1'">
								<td>Ja</td>
							</xsl:when>
							<xsl:when test="po:BorAlene = 'false' or po:BorAlene = '0'">
								<td>Nei</td>
							</xsl:when>
							<xsl:otherwise>
								<td>Ikke oppgitt</td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="po:Sprak">
						<td>
							<xsl:value-of select="po:Sprak/@DN"/>
						</td>
					</xsl:if>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<!-- Hack for å få til linjeskift - for bruk ved datatypen ST eller string -->
	<xsl:template name="line-breaks">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text,'&#10;')">
				<xsl:value-of select="substring-before($text,'&#10;')"/>
				<br/>
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
