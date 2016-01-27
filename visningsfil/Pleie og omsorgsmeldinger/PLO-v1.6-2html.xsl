<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" xmlns:po="http://www.kith.no/xmlstds/po/poKomponent/2012-04-01" xmlns:p1="http://www.kith.no/xmlstds/po/Pasientlogistikk/2012-04-01" xmlns:p3="http://www.kith.no/xmlstds/po/OrienteringOmTjenestetilbud/2012-04-01" xmlns:p4="http://www.kith.no/xmlstds/po/MedisinskeOpplysninger/2012-04-01" xmlns:p5="http://www.kith.no/xmlstds/po/HelseopplysningerVedSoknad/2012-04-01" xmlns:p6="http://www.kith.no/xmlstds/po/HelseopplysningerTilLege/2012-04-01" xmlns:p7="http://www.kith.no/xmlstds/po/Innleggelsesrapport/2012-04-01" xmlns:p8="http://www.kith.no/xmlstds/po/TverrfagligEpikrise/2012-04-01" xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" xmlns:epj1="http://www.kith.no/xmlstds/epj/epj1/2008-02-20" xmlns:epj2="http://www.kith.no/xmlstds/epj/epj2/2008-02-20" xmlns:epj3="http://www.kith.no/xmlstds/epj/epj3/2008-02-20" exclude-result-prefixes="po mh p1 p3 p4 p5 p6 p7 p8 fk1 epj1 epj2 epj3">
	<xsl:import href="../../Felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../../Felleskomponenter/meldingshode2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/poKomponent2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/cave2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/journalnotat2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/legemiddel2html.xsl"/>
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	<!-- Inngår i Hdirs visningsfiler versjon 1.0

		FORMÅL
		XSLT for generering av html-visning av plo-meldinger v1.6

		ENDRINGER:
		01.10.2012: Første versjon

		Laget i XMLSpy v2012 rel2 (http://www.altova.com) av Jan Sigurd Dragsjø (helsedirektoratet.no) -->
	<!-- Variabel for hvilken stil visning har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'One-line-doc'"/>
	<!-- html oppsett -->
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>PLO</title>
				<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
				<style type="text/css">
					<xsl:value-of select="document('../../Felleskomponenter/KITH-visning.css')" disable-output-escaping="yes"/>
				</style>
			</head>
			<body>
				<xsl:apply-templates select="mh:MsgHead"/>
			</body>
		</html>
	</xsl:template>
	<!-- Visning av meldingshodet. Tilpasset vinduskonvolutt ved utskrift -->
	<xsl:template match="mh:MsgHead">
		<xsl:call-template name="Topp"/>
		<xsl:call-template name="Innhold"/>
		<xsl:choose>
			<xsl:when test="//po:InformasjonOmForsendelsen">
				<xsl:call-template name="BunnTillegg">
					<xsl:with-param name="stil" select="$stil"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="Bunn">
					<xsl:with-param name="stil" select="$stil"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="EgetBunnTillegg">
		<xsl:for-each select="//po:InformasjonOmForsendelsen">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold -->
	<xsl:template name="Innhold">
		<div class="{$stil}">
			<!-- Overskrift for meldingen -->
			<h1>
				<xsl:choose>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='INNLEGGELSESRAPPORT']">Innleggelsesrapport</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='LEGEMIDDELHANDTERING']">Legemiddelhåndtering</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='LOG_INNLAGT']">Melding&#160;om&#160;innlagt&#160;pasient</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='LOG_AVMELDING']">Avmelding&#160;av&#160;utskrivningsklar&#160;pasient</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='LOG_DOD']">Orientering&#160;om&#160;dødsfall</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='LOG_UTSKREVET']">Melding&#160;om&#160;utskrevet&#160;pasient</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='LOG_UTSKRIVNINGSKLAR']">Melding&#160;om&#160;utskrivningsklar&#160;pasient</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='HELSEOPPL_SOKNAD']">Helseopplysninger
						<xsl:for-each select="//po:TypeInnhold">
							&#160;-&#160;
							<xsl:choose>
								<xsl:when test="contains(@S, '9140')">
									<xsl:call-template name="k-9140"/>
								</xsl:when>
								<xsl:when test="@DN">
									<xsl:value-of select="@DN"/>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='HELSEOPPLYSNINGER_LEGE']">Helseopplysninger&#160;til&#160;lege
						<xsl:for-each select="//po:TypeInnholdKonsultasjon">
							&#160;-&#160;<xsl:call-template name="k-9137"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='MEDISINSKE_OPPLYSNINGER']">Medisinske&#160;opplysninger
						<xsl:for-each select="//po:TypeInnhold">
							<xsl:choose>
								<xsl:when test="contains(@S, '9138')">
									<xsl:call-template name="k-9138"/>
								</xsl:when>
								<xsl:when test="@DN">
									<xsl:value-of select="@DN"/>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='ORIENTERING_TJENESTETILBUD']">Orientering&#160;om&#160;tjenestetilbud</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='UTSKRIVNINGSRAPPORT']">
						<xsl:for-each select="//po:TypeInnhold">
							<xsl:choose>
								<xsl:when test="contains(@S, '9139')">
									<xsl:call-template name="k-9139"/>
								</xsl:when>
								<xsl:when test="@DN">
									<xsl:value-of select="@DN"/>
								</xsl:when>
								<xsl:otherwise>Utskrivningsrapport</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="//mh:MsgInfo[mh:Type/@V='EPJ-EKSTRAKT']">Kommunikasjon&#160;av&#160;EPJ-innhold</xsl:when>
					<xsl:when test="//mh:MsgInfo/mh:Type/@DN">
						<xsl:value-of select="//mh:MsgInfo/mh:Type/@DN"/>
					</xsl:when>
					<xsl:otherwise>PLO-melding:&#160;<xsl:value-of select="//mh:MsgInfo/mh:Type/@V"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="//po:Forsendelsesstatus">
					<xsl:if test="not(//po:Forsendelsesstatus[@V='N' or @V='X' or @V='O'])">
						&#160;-&#160;
						<xsl:for-each select="//po:Forsendelsesstatus">
							<xsl:call-template name="k-7309"/>
						</xsl:for-each>
					</xsl:if>
				</xsl:if>
			</h1>
			<xsl:call-template name="FellesMeny"/>
			<xsl:call-template name="Dokument"/>
		</div>
	</xsl:template>
	<!-- Visning av klikkbar overskriftsliste. Ikke synlig ved utskrift -->
	<xsl:template name="FellesMeny">
		<div class="NoPrint">
			<div id="FellesMeny" class="FellesMeny">
				<ul>
					<xsl:if test="//po:InfoMedisinskDiagnose">
						<li>
							<a href="#InfoMedisinskDiagnose">Medisinske&#160;diagnoser</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:InfoIPLOSrelevantInformasjon">
						<li>
							<a href="#InfoIPLOSrelevantInformasjon">IPLOSrelevant&#160;informasjon</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:MedisinskfagligeOpplysninger">
						<li>
							<a href="#MedisinskfagligeOpplysninger">Medisinskfaglige&#160;opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:InfoAndreViktigeOpplysninger">
						<li>
							<a href="#InfoAndreViktigeOpplysninger">Andre&#160;viktige&#160;opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//mh:Content/epj1:Cave">
						<li>
							<a href="#Cave">Cave/allergier</a>
						</li>
					</xsl:if>
					<xsl:if test="//epj3:Legemiddelinfo">
						<li>
							<a href="#Legemiddelinfo">Legemidler</a>
						</li>
					</xsl:if>
					<xsl:if test="//epj3:LegemidlerAdministrertVedOverforing">
						<li>
							<a href="#LegemidlerAdministrertVedOverforing">Legemidler administrert ved overføring/utskrivning</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:Sykepleierdokumentasjon">
						<li>
							<a href="#Sykepleierdokumentasjon">Sykepleieopplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:OpplysningerAndreFaggrupper">
						<li>
							<a href="#OpplysningerAndreFaggrupper">Opplysninger&#160;fra&#160;andre&#160;faggrupper</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:InfoKartleggingFunksjonsniva">
						<li>
							<a href="#InfoKartleggingFunksjonsniva">Kartlegging&#160;av&#160;funksjonsnivå</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:InfoReservasjon">
						<li>
							<a href="#InfoReservasjon">Reservasjoner</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:TjenesteBehov">
						<li>
							<a href="#TjenesteBehov">Behov&#160;for&#160;tjenester</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:InfoKontrolltime">
						<li>
							<a href="#InfoKontrolltime">Kontrolltime</a>
						</li>
					</xsl:if>
					<xsl:if test="//p1:OrienteringOmDod or //p1:MeldingOmUtskrevetPasient or //p1:MeldingUtskrivningsklarPasient or //p1:AvmeldingUtskrivningsklarPasient or //p1:MeldingInnlagtPasient">
						<xsl:if test="//po:TidsfestetHendelse">
							<li>
								<a href="#TidsfestetHendelse">Tidsfestet&#160;hendelse</a>
							</li>
						</xsl:if>
						<xsl:if test="//po:UtskrevetTil">
							<li>
								<a href="#UtskrevetTil">Utskrevet&#160;til</a>
							</li>
						</xsl:if>
					</xsl:if>
					<xsl:if test="//po:InfoInformasjonGitt">
						<li>
							<a href="#InfoInformasjonGitt">Informasjon&#160;gitt</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:OpplysningerOmHjelpemidler">
						<li>
							<a href="#OpplysningerOmHjelpemidler">Hjelpemidler</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:OpplysningOpphold">
						<li>
							<a href="#OpplysningOpphold">Opplysninger&#160;om&#160;opphold</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:EksisterendeTjeneste">
						<li>
							<a href="#EksisterendeTjeneste">Eksisterende&#160;tjenester</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:InfoAssistertKommunikasjon">
						<li>
							<a href="#InfoAssistertKommunikasjon">Assistert&#160;kommunikasjon</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:TilleggsopplysningPasient">
						<li>
							<a href="#TilleggsopplysningPasient">Andre&#160;pasientopplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:ParorendeForesatt">
						<li>
							<a href="#ParorendeForesatt">Pårørende/foresatte</a>
						</li>
					</xsl:if>
					<xsl:if test="//mh:Content/epj2:Notater">
						<li>
							<a href="#AndreNotater">Andre notater</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:TilknyttetEnhet">
						<li>
							<a href="#TilknyttetEnhet">Kontaktinformasjon&#160;virksomhet</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:KontaktpersonHelsepersonell">
						<li>
							<a href="#KontaktpersonHelsepersonell">Kontaktpersoner&#160;helsepersonell</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:AnsvarForRapport">
						<li>
							<a href="#AnsvarForRapport">Ansvar&#160;for&#160;rapport</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:SendtDokument">
						<li>
							<a href="#SendtDokument">Tilknyttet&#160;dokument</a>
						</li>
					</xsl:if>
					<xsl:if test="//po:OpplysningerTilSoknad">
						<li>
							<a href="#OpplysningerTilSoknad">Opplysninger&#160;til&#160;søknad</a>
						</li>
					</xsl:if>
				</ul>
			</div>
		</div>
	</xsl:template>
	<!-- Visning av vedlagte dokument -->
	<xsl:template name="Dokument">
		<!-- Tabell og overskrift for Medisinske diagnoser -->
		<xsl:if test="//po:InfoMedisinskDiagnose">
			<h2 id="InfoMedisinskDiagnose">Medisinske&#160;diagnoser</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:InfoMedisinskDiagnose">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for IPLOSrelevant informasjon -->
		<xsl:if test="//po:InfoIPLOSrelevantInformasjon">
			<h2 id="InfoIPLOSrelevantInformasjon">IPLOSrelevant&#160;informasjon</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:InfoIPLOSrelevantInformasjon">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Medisinskfaglige opplysninger -->
		<xsl:if test="//po:MedisinskfagligeOpplysninger">
			<h2 id="MedisinskfagligeOpplysninger">Medisinskfaglige&#160;opplysninger</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:MedisinskfagligeOpplysninger">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Andre viktige opplysninger -->
		<xsl:if test="//po:InfoAndreViktigeOpplysninger">
			<h2 id="InfoAndreViktigeOpplysninger">Andre&#160;viktige&#160;opplysninger</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:InfoAndreViktigeOpplysninger">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Cave/allergier -->
		<xsl:if test="//mh:Content/epj1:Cave">
			<h2 id="Cave">Cave/allergier</h2>
			<table>
				<tbody>
					<xsl:for-each select="//mh:Content/epj1:Cave">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Legemidler -->
		<xsl:if test="//epj3:Legemiddelinfo">
			<h2 id="Legemiddelinfo">Legemidler</h2>
			<table>
				<tbody>
					<xsl:for-each select="//epj3:Legemiddelinfo">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Administrerte legemidler -->
		<xsl:if test="//epj3:LegemidlerAdministrertVedOverforing">
			<h2 id="LegemidlerAdministrertVedOverforing">Legemidler administrert ved overføring/utskrivning</h2>
			<table>
				<tbody>
					<xsl:for-each select="//epj3:LegemidlerAdministrertVedOverforing">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Sykepleieopplysninger -->
		<xsl:if test="//po:Sykepleierdokumentasjon">
			<h2 id="Sykepleierdokumentasjon">Sykepleieopplysninger</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:Sykepleierdokumentasjon">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Opplysninger fra andre faggrupper -->
		<xsl:if test="//po:OpplysningerAndreFaggrupper">
			<h2 id="OpplysningerAndreFaggrupper">Opplysninger&#160;fra&#160;andre&#160;faggrupper</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:OpplysningerAndreFaggrupper">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Kartlegging av funksjonsnivå -->
		<xsl:if test="//po:InfoKartleggingFunksjonsniva">
			<h2 id="InfoKartleggingFunksjonsniva">Kartlegging&#160;av&#160;funksjonsnivå</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:InfoKartleggingFunksjonsniva">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Reservasjoner -->
		<xsl:if test="//po:InfoReservasjon">
			<h2 id="InfoReservasjon">Reservasjoner</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:InfoReservasjon">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Behov for tjenester -->
		<xsl:if test="//po:TjenesteBehov">
			<h2 id="TjenesteBehov">Behov&#160;for&#160;tjenester</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:TjenesteBehov">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Kontrolltime -->
		<xsl:if test="//po:InfoKontrolltime">
			<h2 id="InfoKontrolltime">Kontrolltime</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:InfoKontrolltime">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Pasientlogistikk-meldingene -->
		<xsl:if test="//p1:OrienteringOmDod or //p1:MeldingOmUtskrevetPasient or //p1:MeldingUtskrivningsklarPasient or //p1:AvmeldingUtskrivningsklarPasient or //p1:MeldingInnlagtPasient">
			<xsl:if test="//po:TidsfestetHendelse">
				<h2 id="TidsfestetHendelse">Tidsfestet&#160;hendelse</h2>
				<table>
					<tbody>
						<xsl:for-each select="//po:TidsfestetHendelse">
							<xsl:apply-templates select="."/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<xsl:if test="//po:UtskrevetTil">
				<h2 id="UtskrevetTil">Utskrevet&#160;til</h2>
				<table>
					<tbody>
						<xsl:for-each select="//po:UtskrevetTil">
							<xsl:apply-templates select="."/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
		</xsl:if>
		<!-- Tabell og overskrift for Informasjon gitt -->
		<xsl:if test="//po:InfoInformasjonGitt">
			<h2 id="InfoInformasjonGitt">Informasjon&#160;gitt</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:InfoInformasjonGitt">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Hjelpemidler -->
		<xsl:if test="//po:OpplysningerOmHjelpemidler">
			<h2 id="OpplysningerOmHjelpemidler">Hjelpemidler</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:OpplysningerOmHjelpemidler">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Opplysninger om opphold -->
		<xsl:if test="//po:OpplysningOpphold">
			<h2 id="OpplysningOpphold">Opplysninger&#160;om&#160;opphold</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:OpplysningOpphold">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Eksisterende tjenester -->
		<xsl:if test="//po:EksisterendeTjeneste">
			<h2 id="EksisterendeTjeneste">Eksisterende&#160;tjenester</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:EksisterendeTjeneste">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Assistert kommunikasjon -->
		<xsl:if test="//po:InfoAssistertKommunikasjon">
			<h2 id="InfoAssistertKommunikasjon">Assistert&#160;kommunikasjon</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:InfoAssistertKommunikasjon">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Andre pasientopplysninger -->
		<xsl:if test="//po:TilleggsopplysningPasient">
			<h2 id="TilleggsopplysningPasient">Andre&#160;pasientopplysninger</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:TilleggsopplysningPasient">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Pårørende/foresatte -->
		<xsl:if test="//po:ParorendeForesatt">
			<h2 id="ParorendeForesatt">Pårørende/foresatte</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:ParorendeForesatt">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Andre notater -->
		<xsl:if test="//mh:Content/epj2:Notater">
			<h2 id="AndreNotater">Andre notater</h2>
			<table>
				<tbody>
					<xsl:for-each select="//mh:Content/epj2:Notater">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Kontaktinformasjon virksomhet -->
		<xsl:if test="//po:TilknyttetEnhet">
			<h2 id="TilknyttetEnhet">Kontaktinformasjon&#160;virksomhet</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:TilknyttetEnhet">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Kontaktpersoner helsepersonell -->
		<xsl:if test="//po:KontaktpersonHelsepersonell">
			<h2 id="KontaktpersonHelsepersonell">Kontaktpersoner&#160;helsepersonell</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:KontaktpersonHelsepersonell">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Ansvar for rapport -->
		<xsl:if test="//po:AnsvarForRapport">
			<h2 id="AnsvarForRapport">Ansvar&#160;for&#160;rapport</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:AnsvarForRapport">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Sendt dokument -->
		<xsl:if test="//po:SendtDokument">
			<h2 id="SendtDokument">Tilknyttet&#160;dokument</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:SendtDokument">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Opplysninger til søknad -->
		<xsl:if test="//po:OpplysningerTilSoknad">
			<h2 id="OpplysningerTilSoknad">Opplysninger&#160;til&#160;søknad</h2>
			<table>
				<tbody>
					<xsl:for-each select="//po:OpplysningerTilSoknad">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- Kodeverk -->
	<xsl:template name="k-7309">
		<xsl:choose>
			<xsl:when test="@V='N'">Ny</xsl:when>
			<xsl:when test="@V='M'">Endring</xsl:when>
			<xsl:when test="@V='A'">Tillegg</xsl:when>
			<xsl:when test="@V='H'">Historikk</xsl:when>
			<xsl:when test="@V='C'">Kansellering</xsl:when>
			<xsl:when test="@V='O'">Oppdatert&#160;og&#160;erstatter&#160;tidligere&#160;mottatt&#160;melding</xsl:when>
			<xsl:when test="@V='X'">Annet</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9137">
		<xsl:choose>
			<xsl:when test="@V='2'">Statusrapport</xsl:when>
			<xsl:when test="@V='3'">Ønske&#160;om&#160;legevurdering</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9138">
		<xsl:choose>
			<xsl:when test="@V='1'">Rapport&#160;etter&#160;konsultasjon</xsl:when>
			<xsl:when test="@V='4'">Svar&#160;på&#160;forespørsel</xsl:when>
			<xsl:when test="@V='5'">Opplysninger&#160;til&#160;søknad</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9139">
		<xsl:choose>
			<xsl:when test="@V='11'">Utskrivningsrapport</xsl:when>
			<xsl:when test="@V='12'">Fødselsepikrise</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9140">
		<xsl:choose>
			<xsl:when test="@V='1'">Varsel&#160;om&#160;innlagt&#160;pasient</xsl:when>
			<xsl:when test="@V='2'">Oppdaterte&#160;opplysninger</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
