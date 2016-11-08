<?xml version="1.0" encoding="UTF-8"?>
	<!-- Endringslogg
	- 02.12.15: Generalisert til å håndtere alle plo-versjoner opp til v1.6
	- 01.12.15: Oppdatering for bruk av poKomponent uten navnerom. Innføring av felles kodeverksfil. Småjustering på layout.
	- 01.10.12: Oppdatert til versjon 1.6
	-->
	<!-- Om
	- Inngår i Hdirs visningsfiler versjon 2.0
	- Laget i XMLSpy v2016 (http://www.altova.com) av Jan Sigurd Dragsjø (nhn.no)
	-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" exclude-result-prefixes="mh fk1">
	<xsl:import href="../../Felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../../Felleskomponenter/meldingshode2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/poKomponent2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/cave2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/journalnotat2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/legemiddel2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/kodeverk.xsl"/>
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	
	<!-- Variabel for hvilken stil visning har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'One-line-doc'"/>
	
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
				<xsl:for-each select="mh:MsgHead">
					<xsl:call-template name="MsgHead"/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
	
	<!-- Visning av meldingshodet. Tilpasset vinduskonvolutt ved utskrift -->
	<xsl:template name="MsgHead">
		<xsl:call-template name="Topp"/>
		<xsl:call-template name="Innhold"/>
		<xsl:choose>
			<xsl:when test="//child::*[local-name()=&quot;InformasjonOmForsendelsen&quot;]">
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
	<!-- Visning av innhold -->
	<xsl:template name="Innhold">
		<div class="{$stil}">
			<!-- Overskrift for meldingen -->
			<h1>
				<xsl:for-each select="//mh:MsgInfo/mh:Type">
					<xsl:call-template name="k-8279"/>&#160;
				</xsl:for-each>
				<xsl:for-each select="//child::*[local-name()=&quot;TypeInnholdKonsultasjon&quot;]">-&#160;
					<xsl:choose>
						<xsl:when test="contains(@S, '9137')"><xsl:call-template name="k-9137"/></xsl:when>
						<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
				<xsl:for-each select="//child::*[local-name()=&quot;TypeInnhold&quot;]">-&#160;
					<xsl:choose>
						<xsl:when test="contains(@S, '9138')"><xsl:call-template name="k-9138"/></xsl:when>
						<xsl:when test="contains(@S, '9139')"><xsl:call-template name="k-9139"/></xsl:when>
						<xsl:when test="contains(@S, '9140')"><xsl:call-template name="k-9140"/></xsl:when>
						<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
				<xsl:if test="//child::*[local-name()=&quot;Forsendelsesstatus&quot;]">
					<xsl:if test="not(//child::*[local-name()=&quot;Forsendelsesstatus&quot;][@V='N' or @V='X' or @V='O'])">-&#160;
						<xsl:for-each select="//child::*[local-name()=&quot;Forsendelsesstatus&quot;]">
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
					<xsl:if test="//child::*[local-name()=&quot;InfoMedisinskDiagnose&quot;]">
						<li>
							<a href="#InfoMedisinskDiagnose">Medisinske&#160;diagnoser</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfoIPLOSrelevantInformasjon&quot;]">
						<li>
							<a href="#InfoIPLOSrelevantInformasjon">IPLOSrelevant&#160;informasjon</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;MedisinskfagligeOpplysninger&quot;]">
						<li>
							<a href="#MedisinskfagligeOpplysninger">Medisinskfaglige&#160;opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfoAndreViktigeOpplysninger&quot;]">
						<li>
							<a href="#InfoAndreViktigeOpplysninger">Andre&#160;viktige&#160;opplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//mh:Content/child::*[local-name()=&quot;Cave&quot;]">
						<li>
							<a href="#Cave">Cave/allergier</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Legemiddelinfo&quot;]">
						<li>
							<a href="#Legemiddelinfo">Legemidler</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]">
						<li>
							<a href="#LegemidlerAdministrertVedOverforing">Legemidler administrert ved overføring/utskrivning</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;Sykepleierdokumentasjon&quot;]">
						<li>
							<a href="#Sykepleierdokumentasjon">Sykepleieopplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;OpplysningerAndreFaggrupper&quot;]">
						<li>
							<a href="#OpplysningerAndreFaggrupper">Opplysninger&#160;fra&#160;andre&#160;faggrupper</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfoKartleggingFunksjonsniva&quot;]">
						<li>
							<a href="#InfoKartleggingFunksjonsniva">Kartlegging&#160;av&#160;funksjonsnivå</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfoReservasjon&quot;]">
						<li>
							<a href="#InfoReservasjon">Reservasjoner</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;TjenesteBehov&quot;]">
						<li>
							<a href="#TjenesteBehov">Behov&#160;for&#160;tjenester</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfoKontrolltime&quot;]">
						<li>
							<a href="#InfoKontrolltime">Kontrolltime</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;OrienteringOmDod&quot;] or //child::*[local-name()=&quot;MeldingOmUtskrevetPasient&quot;] or //child::*[local-name()=&quot;MeldingUtskrivningsklarPasient&quot;] or //child::*[local-name()=&quot;AvmeldingUtskrivningsklarPasient&quot;] or //child::*[local-name()=&quot;MeldingInnlagtPasient&quot;]">
						<xsl:if test="//child::*[local-name()=&quot;TidsfestetHendelse&quot;]">
							<li>
								<a href="#TidsfestetHendelse">Tidsfestet&#160;hendelse</a>
							</li>
						</xsl:if>
						<xsl:if test="//child::*[local-name()=&quot;UtskrevetTil&quot;]">
							<li>
								<a href="#UtskrevetTil">Utskrevet&#160;til</a>
							</li>
						</xsl:if>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfoInformasjonGitt&quot;]">
						<li>
							<a href="#InfoInformasjonGitt">Informasjon&#160;gitt</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;OpplysningerOmHjelpemidler&quot;]">
						<li>
							<a href="#OpplysningerOmHjelpemidler">Hjelpemidler</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;OpplysningOpphold&quot;]">
						<li>
							<a href="#OpplysningOpphold">Opplysninger&#160;om&#160;opphold</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;EksisterendeTjeneste&quot;]">
						<li>
							<a href="#EksisterendeTjeneste">Eksisterende&#160;tjenester</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;InfoAssistertKommunikasjon&quot;]">
						<li>
							<a href="#InfoAssistertKommunikasjon">Assistert&#160;kommunikasjon</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;TilleggsopplysningPasient&quot;]">
						<li>
							<a href="#TilleggsopplysningPasient">Andre&#160;pasientopplysninger</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;ParorendeForesatt&quot;]">
						<li>
							<a href="#ParorendeForesatt">Pårørende/foresatte</a>
						</li>
					</xsl:if>
					<xsl:if test="//mh:Content/child::*[local-name()=&quot;Notater&quot;]">
						<li>
							<a href="#AndreNotater">Andre notater</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;TilknyttetEnhet&quot;]">
						<li>
							<a href="#TilknyttetEnhet">Kontaktinformasjon&#160;virksomhet</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;KontaktpersonHelsepersonell&quot;]">
						<li>
							<a href="#KontaktpersonHelsepersonell">Kontaktpersoner&#160;helsepersonell</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;AnsvarForRapport&quot;]">
						<li>
							<a href="#AnsvarForRapport">Ansvar&#160;for&#160;rapport</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;SendtDokument&quot;]">
						<li>
							<a href="#SendtDokument">Tilknyttet&#160;dokument</a>
						</li>
					</xsl:if>
					<xsl:if test="//child::*[local-name()=&quot;OpplysningerTilSoknad&quot;]">
						<li>
							<a href="#OpplysningerTilSoknad">Opplysninger&#160;til&#160;søknad</a>
						</li>
					</xsl:if>
					<xsl:if test="count(//mh:RefDoc) &gt; 1">
						<li>
							<a href="#Vedlegg">Vedlegg</a>
						</li>
					</xsl:if>
				</ul>
			</div>
		</div>
	</xsl:template>
	<!-- Visning av vedlagte dokument -->
	<xsl:template name="Dokument">
		<!-- Tabell og overskrift for Medisinske diagnoser -->
		<xsl:if test="//child::*[local-name()=&quot;InfoMedisinskDiagnose&quot;]">
			<h2 id="InfoMedisinskDiagnose">Medisinske&#160;diagnoser</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;InfoMedisinskDiagnose&quot;]">
						<xsl:call-template name="InfoMedisinskDiagnose"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for IPLOSrelevant informasjon -->
		<xsl:if test="//child::*[local-name()=&quot;InfoIPLOSrelevantInformasjon&quot;]">
			<h2 id="InfoIPLOSrelevantInformasjon">IPLOSrelevant&#160;informasjon</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;InfoIPLOSrelevantInformasjon&quot;]">
						<xsl:call-template name="InfoIPLOSrelevantInformasjon"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Medisinskfaglige opplysninger -->
		<xsl:if test="//child::*[local-name()=&quot;MedisinskfagligeOpplysninger&quot;]">
			<h2 id="MedisinskfagligeOpplysninger">Medisinskfaglige&#160;opplysninger</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;MedisinskfagligeOpplysninger&quot;]">
						<xsl:call-template name="MedisinskfagligeOpplysninger"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Andre viktige opplysninger -->
		<xsl:if test="//child::*[local-name()=&quot;InfoAndreViktigeOpplysninger&quot;]">
			<h2 id="InfoAndreViktigeOpplysninger">Andre&#160;viktige&#160;opplysninger</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;InfoAndreViktigeOpplysninger&quot;]">
						<xsl:call-template name="InfoAndreViktigeOpplysninger"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Cave/allergier -->
		<xsl:if test="//mh:Content/child::*[local-name()=&quot;Cave&quot;]">
			<h2 id="Cave">Cave/allergier</h2>
			<table>
				<tbody>
					<xsl:for-each select="//mh:Content/child::*[local-name()=&quot;Cave&quot;]">
						<xsl:call-template name="Cave"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Legemidler -->
		<xsl:if test="//child::*[local-name()=&quot;Legemiddelinfo&quot;]">
			<h2 id="Legemiddelinfo">Legemidler</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;Legemiddelinfo&quot;]">
						<xsl:call-template name="Legemiddelinfo"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Administrerte legemidler -->
		<xsl:if test="//child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]">
			<h2 id="LegemidlerAdministrertVedOverforing">Legemidler administrert ved overføring/utskrivning</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]">
						<xsl:call-template name="LegemidlerAdministrertVedOverforing"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Sykepleieopplysninger -->
		<xsl:if test="//child::*[local-name()=&quot;Sykepleierdokumentasjon&quot;]">
			<h2 id="Sykepleierdokumentasjon">Sykepleieopplysninger</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;Sykepleierdokumentasjon&quot;]">
						<xsl:call-template name="Sykepleierdokumentasjon"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Opplysninger fra andre faggrupper -->
		<xsl:if test="//child::*[local-name()=&quot;OpplysningerAndreFaggrupper&quot;]">
			<h2 id="OpplysningerAndreFaggrupper">Opplysninger&#160;fra&#160;andre&#160;faggrupper</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;OpplysningerAndreFaggrupper&quot;]">
						<xsl:call-template name="OpplysningerAndreFaggrupper"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Kartlegging av funksjonsnivå -->
		<xsl:if test="//child::*[local-name()=&quot;InfoKartleggingFunksjonsniva&quot;]">
			<h2 id="InfoKartleggingFunksjonsniva">Kartlegging&#160;av&#160;funksjonsnivå</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;InfoKartleggingFunksjonsniva&quot;]">
						<xsl:call-template name="InfoKartleggingFunksjonsniva"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Reservasjoner -->
		<xsl:if test="//child::*[local-name()=&quot;InfoReservasjon&quot;]">
			<h2 id="InfoReservasjon">Reservasjoner</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;InfoReservasjon&quot;]">
						<xsl:call-template name="InfoReservasjon"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Behov for tjenester -->
		<xsl:if test="//child::*[local-name()=&quot;TjenesteBehov&quot;]">
			<h2 id="TjenesteBehov">Behov&#160;for&#160;tjenester</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;TjenesteBehov&quot;]">
						<xsl:call-template name="TjenesteBehov"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Kontrolltime -->
		<xsl:if test="//child::*[local-name()=&quot;InfoKontrolltime&quot;]">
			<h2 id="InfoKontrolltime">Kontrolltime</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;InfoKontrolltime&quot;]">
						<xsl:call-template name="InfoKontrolltime"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Pasientlogistikk-meldingene -->
		<xsl:if test="//child::*[local-name()=&quot;OrienteringOmDod&quot;] or //child::*[local-name()=&quot;MeldingOmUtskrevetPasient&quot;] or //child::*[local-name()=&quot;MeldingUtskrivningsklarPasient&quot;] or //child::*[local-name()=&quot;AvmeldingUtskrivningsklarPasient&quot;] or //child::*[local-name()=&quot;MeldingInnlagtPasient&quot;]">
			<xsl:if test="//child::*[local-name()=&quot;TidsfestetHendelse&quot;]">
				<h2 id="TidsfestetHendelse">Tidsfestet&#160;hendelse</h2>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;TidsfestetHendelse&quot;]">
						<xsl:call-template name="TidsfestetHendelse"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
			<xsl:if test="//child::*[local-name()=&quot;UtskrevetTil&quot;]">
				<h2 id="UtskrevetTil">Utskrevet&#160;til</h2>
				<table>
					<tbody>
						<xsl:for-each select="//child::*[local-name()=&quot;UtskrevetTil&quot;]">
						<xsl:call-template name="UtskrevetTil"/>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:if>
		</xsl:if>
		<!-- Tabell og overskrift for Informasjon gitt -->
		<xsl:if test="//child::*[local-name()=&quot;InfoInformasjonGitt&quot;]">
			<h2 id="InfoInformasjonGitt">Informasjon&#160;gitt</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;InfoInformasjonGitt&quot;]">
						<xsl:call-template name="InfoInformasjonGitt"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Hjelpemidler -->
		<xsl:if test="//child::*[local-name()=&quot;OpplysningerOmHjelpemidler&quot;]">
			<h2 id="OpplysningerOmHjelpemidler">Hjelpemidler</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;OpplysningerOmHjelpemidler&quot;]">
						<xsl:call-template name="OpplysningerOmHjelpemidler"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Opplysninger om opphold -->
		<xsl:if test="//child::*[local-name()=&quot;OpplysningOpphold&quot;]">
			<h2 id="OpplysningOpphold">Opplysninger&#160;om&#160;opphold</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;OpplysningOpphold&quot;]">
						<xsl:call-template name="OpplysningOpphold"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Eksisterende tjenester -->
		<xsl:if test="//child::*[local-name()=&quot;EksisterendeTjeneste&quot;]">
			<h2 id="EksisterendeTjeneste">Eksisterende&#160;tjenester</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;EksisterendeTjeneste&quot;]">
						<xsl:call-template name="EksisterendeTjeneste"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Assistert kommunikasjon -->
		<xsl:if test="//child::*[local-name()=&quot;InfoAssistertKommunikasjon&quot;]">
			<h2 id="InfoAssistertKommunikasjon">Assistert&#160;kommunikasjon</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;InfoAssistertKommunikasjon&quot;]">
						<xsl:call-template name="InfoAssistertKommunikasjon"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Andre pasientopplysninger -->
		<xsl:if test="//child::*[local-name()=&quot;TilleggsopplysningPasient&quot;]">
			<h2 id="TilleggsopplysningPasient">Andre&#160;pasientopplysninger</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;TilleggsopplysningPasient&quot;]">
						<xsl:call-template name="TilleggsopplysningPasient"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Pårørende/foresatte -->
		<xsl:if test="//child::*[local-name()=&quot;ParorendeForesatt&quot;]">
			<h2 id="ParorendeForesatt">Pårørende/foresatte</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;ParorendeForesatt&quot;]">
						<xsl:call-template name="ParorendeForesatt"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Andre notater -->
		<xsl:if test="//mh:Content/child::*[local-name()=&quot;Notater&quot;]">
			<h2 id="AndreNotater">Andre notater</h2>
			<table>
				<tbody>
					<xsl:for-each select="//mh:Content/child::*[local-name()=&quot;Notater&quot;]">
						<xsl:call-template name="Notater"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Kontaktinformasjon virksomhet -->
		<xsl:if test="//child::*[local-name()=&quot;TilknyttetEnhet&quot;]">
			<h2 id="TilknyttetEnhet">Kontaktinformasjon&#160;virksomhet</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;TilknyttetEnhet&quot;]">
						<xsl:call-template name="TilknyttetEnhet"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Kontaktpersoner helsepersonell -->
		<xsl:if test="//child::*[local-name()=&quot;KontaktpersonHelsepersonell&quot;]">
			<h2 id="KontaktpersonHelsepersonell">Kontaktpersoner&#160;helsepersonell</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;KontaktpersonHelsepersonell&quot;]">
						<xsl:call-template name="KontaktpersonHelsepersonell"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Ansvar for rapport -->
		<xsl:if test="//child::*[local-name()=&quot;AnsvarForRapport&quot;]">
			<h2 id="AnsvarForRapport">Ansvar&#160;for&#160;rapport</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;AnsvarForRapport&quot;]">
						<xsl:call-template name="AnsvarForRapport"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Sendt dokument -->
		<xsl:if test="//child::*[local-name()=&quot;SendtDokument&quot;]">
			<h2 id="SendtDokument">Tilknyttet&#160;dokument</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;SendtDokument&quot;]">
						<xsl:call-template name="SendtDokument"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<!-- Tabell og overskrift for Opplysninger til søknad -->
		<xsl:if test="//child::*[local-name()=&quot;OpplysningerTilSoknad&quot;]">
			<h2 id="OpplysningerTilSoknad">Opplysninger&#160;til&#160;søknad</h2>
			<table>
				<tbody>
					<xsl:for-each select="//child::*[local-name()=&quot;OpplysningerTilSoknad&quot;]">
						<xsl:call-template name="OpplysningerTilSoknad"/>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
		<xsl:if test="count(//mh:RefDoc) &gt; 1">
			<xsl:for-each select="//mh:RefDoc">
				<xsl:if test="position() != 1">
					<h2 id="Vedlegg">Vedlegg</h2>
					<table>
						<tbody>
							<xsl:call-template name="RefDoc"/>
						</tbody>
					</table>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<!-- Template som kalles fra BunnTillegg i meldingshodet. Kan brukes til visning av egenkomponert bunn -->
	<xsl:template name="EgetBunnTillegg">
		<xsl:for-each select="//child::*[local-name()=&quot;InformasjonOmForsendelsen&quot;]">
			<xsl:call-template name="InformasjonOmForsendelsen"/>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
