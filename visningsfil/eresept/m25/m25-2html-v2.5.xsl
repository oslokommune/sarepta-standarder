<?xml version="1.0" encoding="UTF-8"?>
<!-- Edited with Atova XLMSpy (x64) ver. 2013 rel.2  sp.2 (http://www.altova.com) by Jan Sigurd Dragsjø - avd. Standardisering, Helsedirektoratet-->
<xsl:stylesheet version="1.0" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" 
	xmlns:ki="http://www.kith.no/xmlstds/eresept/ki/2013-04-25" 
	xmlns:dt="http://xsltsl.org/date-time" 
	exclude-result-prefixes="mh ki dt">

	<!-- Visningsfil M25 Legemidler i bruk
	- Visningsfilen kan benyttes til alle kategorier av M25 (M25.1-4) -->
	<!-- Endringslogg:
	-	2016-10-25: La til visningsversjonnr
	-	2016-04-04: Rettet visning for Antall/Mengde
	-	2016-03-30: La til ny linje for hva som faktisk ble utlevert i pakking/multidose. Aktuelt for M25.3.
	-	2015-06-16: Rettet logisk feil hvor overskriftsrad manglet enkelte ganger i legemiddeltabellene.
	-	2014-11-26: La til fet skrift på enkelte medikamentnavn
	-	2014-10-20: Endret visning for Spørsmål og Svar, hvor innhold i Kode blir nå overskrift/header
	-	2014-03-04: Dato for seponering og årsak flyttet til første kolonne
	-	2014-02-12: Antall tas nå med i legemiddelblanding
	-	2014-02-11: Kategoriserte legemiddel seponert frem i tid under legemidler i bruk
	-	2013-11-07 Første versjon -->

	<xsl:import href="../../Felleskomponenter/meldingshode2html.xsl"/>
	<xsl:import href="../../Felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../../Felleskomponenter/kodeverk.xsl"/>
	<xsl:import href="../../Felleskomponenter/kritiskInfo2html-v2.5.xsl"/>
	<xsl:import href="../../Felleskomponenter/base64decoder.xsl"/>

	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" 
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

	<!-- Variabel for hvilken stil visningen har. Tilgjengelige stiler er: Document, One-line-doc, No-line-doc -->
	<xsl:variable name="stil" select="'One-line-doc'"/>
	<!-- Variabel for hvilken versjon av visningsfilen -->
	<xsl:variable name="versjon" select="'eresept-m25-2.5 v3.1.0 '"/>

	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>LegemidlerIBruk</title>
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
		<xsl:call-template name="BunnTillegg">
			<xsl:with-param name="stil" select="$stil"/>
			<xsl:with-param name="versjon" select="$versjon"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Template som kalles fra BunnTillegg i meldingshodet. Kan brukes til visning av egenkomponert bunn -->
	<xsl:template name="EgetBunnTillegg">
		<xsl:if test="descendant::*[local-name()=&quot;LegemidlerIBruk&quot;]/child::*[local-name()=&quot;Merknad&quot;] or descendant::*[local-name()=&quot;LegemidlerIBruk&quot;]/child::*[local-name()=&quot;Vikar&quot;]">
			<xsl:for-each select="descendant::*[local-name()=&quot;LegemidlerIBruk&quot;]">
				<tr>
					<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
						<th>Merknad</th>
						<td>
							<xsl:value-of select="child::*[local-name()=&quot;Merknad&quot;]"/>
						</td>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;Vikar&quot;]">
						<th>Vikar</th>
						<td>
							<xsl:choose>
								<xsl:when test="child::*[local-name()=&quot;Vikar&quot;]/@V = '1'">Ja</xsl:when>
								<xsl:otherwise>Nei</xsl:otherwise>
							</xsl:choose>
						</td>
					</xsl:if>
				</tr>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="FellesMeny">
		<xsl:param name="position"/>
		<xsl:param name="boolSeponert"/>
		<xsl:if test="$boolSeponert or child::*[local-name()=&quot;Rolle&quot;]">
			<div class="NoPrint">
				<div id="FellesMeny" class="FellesMeny">
					<ul>
						<!--<xsl:if test="ki:Allergi">
							<li>
								<xsl:variable name="temp10" select="concat('CAVE',$position)"/>
								<a href="#{$temp10}">CAVE</a>
							</li>
						</xsl:if>
						<xsl:if test="child::*[local-name()=&quot;EnkeltoppforingLIB&quot; and not(child::*[local-name()=&quot;Seponering&quot;])]">
							<li>
								<xsl:variable name="temp20" select="concat('Legemidler',$position)"/>
								<a href="#{$temp20}">Legemidler</a>
							</li>
						</xsl:if> -->
						<xsl:if test="$boolSeponert">
							<li>
								<xsl:variable name="temp30" select="concat('SeponerteLegemidler',$position)"/>
								<a href="#{$temp30}">Seponerte&#160;legemidler</a>
							</li>
						</xsl:if>
						<xsl:if test="child::*[local-name()=&quot;Rolle&quot;]">
							<li>
								<xsl:variable name="temp40" select="concat('Rolle',$position)"/>
								<a href="#{$temp40}">Roller</a>
							</li>
						</xsl:if>
					</ul>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Innhold">
		<div class="{$stil}">
			<xsl:for-each select="descendant::*[local-name()=&quot;LegemidlerIBruk&quot;]">
				<xsl:variable name="boolSeponertString">
					<xsl:for-each select="descendant::*[local-name()=&quot;Seponering&quot;]/child::*[local-name()=&quot;Tidspunkt&quot;]">
						<xsl:variable name="datoSeponertFormatert">
							<xsl:call-template name="formaterDatoForSammenligning">
								<xsl:with-param name="gittDato" select="."/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="datoSendtFormatert">
							<xsl:call-template name="formaterDatoForSammenligning">
								<xsl:with-param name="gittDato" select="/.//mh:GenDate"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$datoSeponertFormatert&lt;$datoSendtFormatert">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="position" select="position()"/>
				<xsl:call-template name="FellesMeny">
					<xsl:with-param name="position" select="position()"/>
					<xsl:with-param name="boolSeponert" select="contains($boolSeponertString, 'true')"/>
				</xsl:call-template>
				<h1 align="center">Legemidler&#160;i&#160;bruk</h1>
				<!-- Tabell for pakkeinfo -->
				<xsl:if test="child::*[local-name()=&quot;Pakkeinfo&quot;]">
					<table>
						<tbody>
							<tr>
								<td width="20%">
									<xsl:for-each select="child::*[local-name()=&quot;Pakkeinfo&quot;]/child::*[local-name()=&quot;Bestillingsfrist&quot;]">
										<b>Bestillingsfrist:</b>&#160;<xsl:call-template name="skrivUtDateTime">
											<xsl:with-param name="oppgittTid" select="."/>
										</xsl:call-template>
									</xsl:for-each>
								</td>
								<xsl:if test="child::*[local-name()=&quot;Pakkeinfo&quot;]/child::*[local-name()=&quot;ForsteDoseringsdato&quot;] or child::*[local-name()=&quot;Pakkeinfo&quot;]/child::*[local-name()=&quot;SisteDoseringsdato&quot;]">
									<td>
										<b>Pakkeperiode:</b>&#160;<xsl:for-each select="child::*[local-name()=&quot;Pakkeinfo&quot;]/child::*[local-name()=&quot;ForsteDoseringsdato&quot;]">
											<xsl:call-template name="skrivUtDate">
												<xsl:with-param name="oppgittTid" select="."/>
											</xsl:call-template>
										</xsl:for-each>&#160;-&#160;<xsl:for-each select="child::*[local-name()=&quot;Pakkeinfo&quot;]/child::*[local-name()=&quot;SisteDoseringsdato&quot;]">
											<xsl:call-template name="skrivUtDate">
												<xsl:with-param name="oppgittTid" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</td>
								</xsl:if>
							</tr>
						</tbody>
					</table>
				</xsl:if>
				<!-- Overskrift og tabell for Allergier -->
				<xsl:if test="ki:Allergi">
					<xsl:variable name="id10">
						<xsl:value-of select="concat('CAVE',$position)"/>
					</xsl:variable>
					<h2 id="{$id10}" align="center">CAVE</h2>
					<table>
						<tbody>
							<tr>
								<th width="20%">Legemiddel</th>
								<th width="20%">Allergi</th>
								<th>Annet</th>
							</tr>
							<xsl:apply-templates select="ki:Allergi"/>
						</tbody>
					</table>
				</xsl:if>
				<!-- Tabell for Enkeloppføringer (ikke seponert) -->
				<xsl:if test="child::*[local-name()=&quot;EnkeltoppforingLIB&quot; and not(child::*[local-name()=&quot;Seponering&quot;])] or contains($boolSeponertString, 'false')">
					<xsl:variable name="id20">
						<xsl:value-of select="concat('Legemidler',$position)"/>
					</xsl:variable>
					<h2 id="{$id20}" align="center">Legemidler (ikke seponert)</h2>
					<table>
						<tbody>
							<tr>
								<th width="10%">Seponert</th>
								<th width="5%">Bruk</th>
								<th width="5%">ATC</th>
								<th width="20%">NavnFormStyrke/Virkestoff</th>
								<th width="20%">Bruksområde/Dosering</th>
								<th width="5%">Mengde</th>
								<th width="5%">Reit</th>
								<th width="5%">Refusjon</th>
								<th width="5%">Instituert&#160;av</th>
								<th width="5%">Forskrevet&#160;av</th>
								<th width="5%">Resept&#160;gyldig&#160;til</th>
							</tr>
							<xsl:for-each select="child::*[local-name()=&quot;EnkeltoppforingLIB&quot;]">
								<xsl:choose>
									<xsl:when test="child::*[local-name()=&quot;Seponering&quot;]">
										<xsl:variable name="datoSeponertFormatert">
											<xsl:call-template name="formaterDatoForSammenligning">
												<xsl:with-param name="gittDato" select="child::*[local-name()=&quot;Seponering&quot;]/child::*[local-name()=&quot;Tidspunkt&quot;]"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:variable name="datoSendtFormatert">
											<xsl:call-template name="formaterDatoForSammenligning">
												<xsl:with-param name="gittDato" select="/.//mh:GenDate"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:if test="$datoSeponertFormatert&gt;$datoSendtFormatert">
											<xsl:call-template name="EnkeltoppforingLIB"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="EnkeltoppforingLIB"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Tabell for Enkeloppføringer (seponert) -->
				<xsl:if test="contains($boolSeponertString, 'true')">
					<xsl:variable name="id30">
						<xsl:value-of select="concat('SeponerteLegemidler',$position)"/>
					</xsl:variable>
					<h2 id="{$id30}" align="center">Seponerte&#160;legemidler</h2>
					<table>
						<tbody>
							<tr>
								<th width="10%">Seponert</th>
								<th width="5%">Bruk</th>
								<th width="5%">ATC</th>
								<th width="20%">NavnFormStyrke/Virkestoff</th>
								<th width="20%">Bruksområde/Dosering</th>
								<th width="5%">Mengde</th>
								<th width="5%">Reit</th>
								<th width="5%">Refusjon</th>
								<th width="5%">Instituert&#160;av</th>
								<th width="5%">Forskrevet&#160;av</th>
								<th width="5%">Resept&#160;gyldig&#160;til</th>
							</tr>
							<xsl:for-each select="child::*[local-name()=&quot;EnkeltoppforingLIB&quot; and child::*[local-name()=&quot;Seponering&quot;]]">
								<xsl:variable name="datoSeponertFormatert">
									<xsl:call-template name="formaterDatoForSammenligning">
										<xsl:with-param name="gittDato" select="child::*[local-name()=&quot;Seponering&quot;]/child::*[local-name()=&quot;Tidspunkt&quot;]"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="datoSendtFormatert">
									<xsl:call-template name="formaterDatoForSammenligning">
										<xsl:with-param name="gittDato" select="/.//mh:GenDate"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:if test="$datoSeponertFormatert&lt;$datoSendtFormatert">
									<xsl:call-template name="EnkeltoppforingLIB"/>
								</xsl:if>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
				<!-- Tabell for Roller -->
				<xsl:if test="child::*[local-name()=&quot;Rolle&quot;]">
					<xsl:variable name="id40">
						<xsl:value-of select="concat('Rolle',$position)"/>
					</xsl:variable>
					<h2 id="{$id40}" align="center">Roller i forhold til pasient </h2>
					<table>
						<tbody>
							<xsl:for-each select="child::*[local-name()=&quot;Rolle&quot;]">
								<xsl:call-template name="Rolle"/>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
			</xsl:for-each>
		</div>
	</xsl:template>
	<xsl:template name="EnkeltoppforingLIB">
		<tr>
			<!-- Dato seponert, Årsak -->
			<td valign="top">
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;Seponering&quot;]">
						<xsl:for-each select="child::*[local-name()=&quot;Seponering&quot;]">
							<xsl:if test="child::*[local-name()=&quot;Tidspunkt&quot;]">
								<div>
									<xsl:call-template name="skrivUtDateTime">
										<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;Tidspunkt&quot;]"/>
									</xsl:call-template>&#160;&#160;
								</div>
							</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;Arsak&quot;]">
								<div>
									<xsl:for-each select="child::*[local-name()=&quot;Arsak&quot;]">
										<xsl:call-template name="k-7494"/>
									</xsl:for-each>
								</div>
							</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
								<div>
									<b>Merknad</b>:&#160;<xsl:value-of select="child::*[local-name()=&quot;Merknad&quot;]"/>
								</div>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>&#160;</xsl:otherwise>
				</xsl:choose>
			</td>
			<!--<td valign="top">
				<xsl:call-template name="skrivUtDateTime">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;SistEndret&quot;]"/>
				</xsl:call-template>&#160;
				<xsl:if test="child::*[local-name()=&quot;MedEndring&quot;]='true'">
					<div>
						<b>Endret</b>
					</div>
				</xsl:if>
			</td>-->
			<xsl:choose>
				<xsl:when test="child::*[local-name()=&quot;ReseptDokLegemiddelB64&quot;]/child::*">
					<xsl:for-each select="child::*[local-name()=&quot;ReseptDokLegemiddelB64&quot;]">
						<!-- Bruk -->
						<td valign="top">
							<xsl:if test="descendant::*[local-name()=&quot;Bruk&quot;]">
								<xsl:for-each select="descendant::*[local-name()=&quot;Bruk&quot;]">
									<xsl:call-template name="k-9101"/>
								</xsl:for-each>
							</xsl:if>&#160;
						</td>
						<!-- B64/Atc/@V -->
						<td valign="top">
							<xsl:for-each select="descendant::*[local-name()=&quot;Atc&quot;]">
								<div>
									<xsl:value-of select="@V"/>
								</div>
							</xsl:for-each>&#160;
						</td>
						<!-- B64/NavnFormStyrke, B64/Atc/@DN -->
						<td valign="top">
							<xsl:choose>
								<xsl:when test="descendant::*[local-name()=&quot;Legemiddelblanding&quot;]">
									<xsl:for-each select="descendant::*[local-name()=&quot;Legemiddelblanding&quot;]">
										<xsl:value-of select="child::*[local-name()=&quot;Navn&quot;]"/>
										<xsl:for-each select="child::*[local-name()=&quot;BestanddelLegemiddel&quot; or local-name()=&quot;BestanddelAnnet&quot;]">
											<xsl:if test="descendant::*[local-name()=&quot;NavnFormStyrke&quot;]">
												<div>
													<b>
														<xsl:value-of select="substring-before(descendant::*[local-name()=&quot;NavnFormStyrke&quot;],' ')"/>
													</b>&#160;<xsl:value-of select="substring-after(descendant::*[local-name()=&quot;NavnFormStyrke&quot;],' ')"/>&#160;
												</div>
											</xsl:if>
											<xsl:if test="descendant::*[local-name()=&quot;Atc&quot;]/@DN">
												<div>&#160;&#160;&#160;<em>
														<xsl:value-of select="descendant::*[local-name()=&quot;Atc&quot;]/@DN"/>
													</em>
												</div>
											</xsl:if>
										</xsl:for-each>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="descendant::*[local-name()=&quot;NavnFormStyrke&quot;]">
										<b>
											<xsl:value-of select="substring-before(descendant::*[local-name()=&quot;NavnFormStyrke&quot;],' ')"/>
										</b>&#160;<xsl:value-of select="substring-after(descendant::*[local-name()=&quot;NavnFormStyrke&quot;],' ')"/>&#160;
									</xsl:if>&#160;<xsl:if test="descendant::*[local-name()=&quot;Atc&quot;]/@DN">
										<div>&#160;&#160;&#160;<em>
												<xsl:value-of select="descendant::*[local-name()=&quot;Atc&quot;]/@DN"/>
											</em>
										</div>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<!-- B64/Bruksomrade, B64/DosVeiledEnkel, (B64/Dosering) -->
						<td valign="top">
							<xsl:if test="descendant::*[local-name()=&quot;Bruksomrade&quot;]">
								<xsl:value-of select="descendant::*[local-name()=&quot;Bruksomrade&quot;]"/>
								<br/>
							</xsl:if>
							<xsl:if test="descendant::*[local-name()=&quot;DosVeiledEnkel&quot;]">
								<xsl:value-of select="descendant::*[local-name()=&quot;DosVeiledEnkel&quot;]"/>
								<br/>
							</xsl:if>
							<xsl:if test="descendant::*[local-name()=&quot;Dosering&quot;]">Strukturert&#160;dosering</xsl:if>&#160;
						</td>
						<!-- B64/Mengde eller B64/Antall x B64/Legemiddelpakning/PakningsinfoResept/Pakning-->
						<td valign="top">
							<xsl:choose>
								<xsl:when test="descendant::*[local-name()=&quot;Antall&quot;]">
									<xsl:value-of select="descendant::*[local-name()=&quot;Antall&quot;]"/>&#160;x&#160;<xsl:value-of select="descendant::*[local-name()=&quot;Pakningsstr&quot;]"/>&#160;<xsl:value-of select="descendant::*[local-name()=&quot;EnhetPakning&quot;]/@V"/>&#160;
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="descendant::*[local-name()=&quot;Mengde&quot;]/@V"/>&#160;<xsl:value-of select="descendant::*[local-name()=&quot;Mengde&quot;]/@U"/>&#160;
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<!-- B64/Reiterasjon -->
						<td valign="top">
							<xsl:if test="descendant::*[local-name()=&quot;Reiterasjon&quot;]">
								<xsl:value-of select="descendant::*[local-name()=&quot;Reiterasjon&quot;]"/>
							</xsl:if>&#160;
						</td>
						<!-- B64/Refusjon -->
						<td valign="top">
							<xsl:if test="descendant::*[local-name()=&quot;RefHjemmel&quot;]">
								<xsl:value-of select="descendant::*[local-name()=&quot;RefHjemmel&quot;]/@DN"/>
							</xsl:if>&#160;
						</td>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="konvertertBase64">
						<xsl:call-template name="convertBase64ToAscii">
							<xsl:with-param name="base64String" select="child::*[local-name()=&quot;ReseptDokLegemiddelB64&quot;]"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- B64/Bruk -->
					<td valign="top">
						<xsl:if test="contains($konvertertBase64, 'Bruk ')">
							<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'Bruk '),'/'),'DN=&quot;'),'&quot;')"/>
							<!--<xsl:call-template name="k-9101">
								<xsl:with-param name="V" select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'Bruk '),'/'),'V=&quot;'),'&quot;')"/>
							</xsl:call-template>-->
						</xsl:if>&#160;
					</td>
					<!-- B64/Atc/@V -->
					<td valign="top">
						<xsl:if test="contains($konvertertBase64, 'Atc ')">
							<xsl:call-template name="skrivUtAtc">
								<xsl:with-param name="tekst" select="substring-after($konvertertBase64,'Atc ')"/>
							</xsl:call-template>
						</xsl:if>
					</td>
					<!-- B64/NavnFormStyrke, B64/Atc/@DN -->
					<td valign="top">
						<xsl:choose>
							<xsl:when test="contains($konvertertBase64, 'Legemiddelblanding')">
								<xsl:variable name="LegemiddelBlanding" select="substring-after(substring-after($konvertertBase64, 'Legemiddelblanding'),'&gt;')"/>
								<xsl:variable name="LegemiddelBlandingNavn" select="substring-before(substring-after(substring-after($LegemiddelBlanding, 'Navn'),'&gt;'),'&lt;/')"/>
								<xsl:choose>
									<xsl:when test="contains($LegemiddelBlandingNavn, ' ')">
										<div>
											<b>
												<xsl:value-of select="substring-before($LegemiddelBlandingNavn, ' ')"/>
											</b>&#160;<xsl:value-of select="substring-after($LegemiddelBlandingNavn, ' ')"/>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<div>
											<b>
												<xsl:value-of select="$LegemiddelBlandingNavn"/>
											</b>
										</div>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="contains($LegemiddelBlanding, 'BestanddelLegemiddel')">
									<xsl:call-template name="skrivUtBestanddelLegemiddel">
										<xsl:with-param name="tekst" select="substring-after(substring-after($LegemiddelBlanding, 'BestanddelLegemiddel'),'&gt;')"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="contains($LegemiddelBlanding, 'BestanddelAnnet')">
									<xsl:call-template name="skrivUtBestanddelAnnet">
										<xsl:with-param name="tekst" select="substring-after(substring-after($LegemiddelBlanding, 'BestanddelAnnet'),'&gt;')"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="contains($konvertertBase64, 'NavnFormStyrke')">
									<b>
										<xsl:value-of select="substring-before(substring-after(substring-after($konvertertBase64, 'NavnFormStyrke'),'&gt;'),' ')"/>
									</b>&#160;<xsl:value-of select="substring-before(substring-after(substring-after(substring-after($konvertertBase64, 'NavnFormStyrke'),'&gt;'),' '),'&lt;/')"/>
								</xsl:if>&#160;<xsl:if test="contains($konvertertBase64, 'Atc') and contains(substring-before(substring-after($konvertertBase64,'Atc '),'/'), 'DN')">
									<div>&#160;&#160;&#160;<em>
											<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'Atc '),'/'),'DN=&quot;'),'&quot;')"/>
										</em>
									</div>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<!-- B64/Bruksomrade, B64/DosVeiledEnkel, (B64/Dosering) -->
					<td valign="top">
						<xsl:if test="contains($konvertertBase64, 'Bruksomrade')">
							<xsl:value-of select="substring-before(substring-after(substring-after($konvertertBase64, 'Bruksomrade'),'&gt;'),'&lt;/')"/>
							<br/>
						</xsl:if>
						<xsl:if test="contains($konvertertBase64, 'DosVeiledEnkel')">
							<xsl:value-of select="substring-before(substring-after(substring-after($konvertertBase64, 'DosVeiledEnkel'),'&gt;'),'&lt;/')"/>
							<br/>
						</xsl:if>
						<xsl:if test="contains($konvertertBase64, 'Dosering')">Strukturert&#160;dosering</xsl:if>&#160;
					</td>
					<!-- B64/Mengde eller B64/Antall x B64/Legemiddelpakning/PakningsinfoResept/Pakning-->
					<td valign="top">
						<xsl:choose>
							<xsl:when test="contains($konvertertBase64, 'Antall')">
								<xsl:value-of select="substring-before(substring-after(substring-after($konvertertBase64, 'Antall'),'&gt;'),'&lt;/')"/>&#160;x&#160;<xsl:value-of select="substring-before(substring-after(substring-after($konvertertBase64, 'Pakningsstr'),'&gt;'),'&lt;/')"/>&#160;<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'EnhetPakning '),'/'),'V=&quot;'),'&quot;')"/>&#160;
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'Mengde '),'/'),'V=&quot;'),'&quot;')"/>&#160;<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'Mengde '),'/'),'U=&quot;'),'&quot;')"/>&#160;
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<!-- B64/Reiterasjon -->
					<td valign="top">
						<xsl:if test="contains($konvertertBase64, 'Reiterasjon')">
							<xsl:value-of select="substring-before(substring-after(substring-after($konvertertBase64, 'Reiterasjon'),'&gt;'),'&lt;/')"/>
						</xsl:if>&#160;
					</td>
					<!-- B64/Refusjon -->
					<td valign="top">
						<xsl:if test="contains($konvertertBase64, 'RefHjemmel ')">
							<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'RefHjemmel '),'/'),'DN=&quot;'),'&quot;')"/>
						</xsl:if>&#160;
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Instituert av -->
			<td valign="top">
				<xsl:for-each select="child::*[local-name()=&quot;Rolle&quot; and child::*[local-name()=&quot;Rolle&quot; and @V='I']]">
					<xsl:for-each select="child::*[local-name()=&quot;Helseperson&quot;]">
						<xsl:value-of select="child::*[local-name()=&quot;Fornavn&quot;]"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;Etternavn&quot;]"/>
					</xsl:for-each>
					<xsl:for-each select="child::*[local-name()=&quot;Organisasjon&quot;]">
						<xsl:value-of select="child::*[local-name()=&quot;Inst&quot;]"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;Dept&quot;]"/>
					</xsl:for-each>
				</xsl:for-each>&#160;
			</td>
			<!-- Forskrevet av -->
			<td valign="top">
				<xsl:for-each select="child::*[local-name()=&quot;Rolle&quot; and child::*[local-name()=&quot;Rolle&quot; and @V='R']]">
					<xsl:for-each select="child::*[local-name()=&quot;Helseperson&quot;]">
						<xsl:value-of select="child::*[local-name()=&quot;Fornavn&quot;]"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;Etternavn&quot;]"/>
					</xsl:for-each>
				</xsl:for-each>&#160;
			</td>
			<!-- Gyldig -->
			<td valign="top">
				<xsl:call-template name="skrivUtDate">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;UtlopsdatoResept&quot;]"/>
				</xsl:call-template>&#160;
			</td>
		</tr>
		<!-- Siste utlevering -->
		<xsl:for-each select="child::*[local-name()=&quot;SisteUtlevering&quot;]">
			<tr class="No-line-doc">
				<td colspan="3">
					<b>Legemiddel som er pakket:</b>
				</td>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;UtleveringB64&quot;]/child::*">
						<xsl:for-each select="child::*[local-name()=&quot;UtleveringB64&quot;]">
							<!-- B64/NavnFormStyrke, B64/Atc/@DN -->
							<td valign="top">
								<xsl:choose>
									<xsl:when test="descendant::*[local-name()=&quot;Legemiddelblanding&quot;]">
										<xsl:for-each select="descendant::*[local-name()=&quot;Legemiddelblanding&quot;]">
											<xsl:value-of select="child::*[local-name()=&quot;Navn&quot;]"/>
											<xsl:for-each select="child::*[local-name()=&quot;BestanddelLegemiddel&quot; or local-name()=&quot;BestanddelAnnet&quot;]">
												<xsl:if test="descendant::*[local-name()=&quot;NavnFormStyrke&quot;]">
													<div>
														<b>
															<xsl:value-of select="substring-before(descendant::*[local-name()=&quot;NavnFormStyrke&quot;],' ')"/>
														</b>&#160;<xsl:value-of select="substring-after(descendant::*[local-name()=&quot;NavnFormStyrke&quot;],' ')"/>&#160;
													</div>
												</xsl:if>
												<xsl:if test="descendant::*[local-name()=&quot;Atc&quot;]/@DN">
													<div>&#160;&#160;&#160;<em>
															<xsl:value-of select="descendant::*[local-name()=&quot;Atc&quot;]/@DN"/>
														</em>
													</div>
												</xsl:if>
											</xsl:for-each>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="descendant::*[local-name()=&quot;NavnFormStyrke&quot;]">
											<b>
												<xsl:value-of select="substring-before(descendant::*[local-name()=&quot;NavnFormStyrke&quot;],' ')"/>
											</b>&#160;<xsl:value-of select="substring-after(descendant::*[local-name()=&quot;NavnFormStyrke&quot;],' ')"/>&#160;
										</xsl:if>&#160;<xsl:if test="descendant::*[local-name()=&quot;Atc&quot;]/@DN">
											<div>&#160;&#160;&#160;<em>
													<xsl:value-of select="descendant::*[local-name()=&quot;Atc&quot;]/@DN"/>
												</em>
											</div>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<!-- B64/Bruksomrade, B64/DosVeiledEnkel, (B64/Dosering) -->
							<td valign="top">
								<xsl:if test="descendant::*[local-name()=&quot;Bruksomrade&quot;]">
									<xsl:value-of select="descendant::*[local-name()=&quot;Bruksomrade&quot;]"/>
									<br/>
								</xsl:if>
								<xsl:if test="descendant::*[local-name()=&quot;DosVeiledEnkel&quot;]">
									<xsl:value-of select="descendant::*[local-name()=&quot;DosVeiledEnkel&quot;]"/>
									<br/>
								</xsl:if>
								<xsl:if test="descendant::*[local-name()=&quot;Dosering&quot;]">Strukturert&#160;dosering</xsl:if>&#160;
							</td>
							<!-- B64/Mengde eller B64/Antall x B64/Legemiddelpakning/PakningsinfoResept/Pakning-->
							<td valign="top">
								<xsl:choose>
									<xsl:when test="descendant::*[local-name()=&quot;Antall&quot;]">
										<xsl:value-of select="descendant::*[local-name()=&quot;Antall&quot;]"/>&#160;x&#160;<xsl:value-of select="descendant::*[local-name()=&quot;Pakningsstr&quot;]"/>&#160;<xsl:value-of select="descendant::*[local-name()=&quot;EnhetPakning&quot;]/@V"/>&#160;
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="descendant::*[local-name()=&quot;Mengde&quot;]/@V"/>&#160;<xsl:value-of select="descendant::*[local-name()=&quot;Mengde&quot;]/@U"/>&#160;
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="konvertertBase64">
							<xsl:call-template name="convertBase64ToAscii">
								<xsl:with-param name="base64String" select="child::*[local-name()=&quot;UtleveringB64&quot;]"/>
							</xsl:call-template>
						</xsl:variable>
							<!-- B64/NavnFormStyrke, B64/Atc/@DN -->
							<td valign="top">
								<xsl:choose>
									<xsl:when test="contains($konvertertBase64, 'Legemiddelblanding')">
										<xsl:variable name="LegemiddelBlanding" select="substring-after(substring-after($konvertertBase64, 'Legemiddelblanding'),'&gt;')"/>
										<xsl:variable name="LegemiddelBlandingNavn" select="substring-before(substring-after(substring-after($LegemiddelBlanding, 'Navn'),'&gt;'),'&lt;/')"/>
										<xsl:choose>
											<xsl:when test="contains($LegemiddelBlandingNavn, ' ')">
												<div>
													<b>
														<xsl:value-of select="substring-before($LegemiddelBlandingNavn, ' ')"/>
													</b>&#160;<xsl:value-of select="substring-after($LegemiddelBlandingNavn, ' ')"/>
												</div>
											</xsl:when>
											<xsl:otherwise>
												<div>
													<b>
														<xsl:value-of select="$LegemiddelBlandingNavn"/>
													</b>
												</div>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:if test="contains($LegemiddelBlanding, 'BestanddelLegemiddel')">
											<xsl:call-template name="skrivUtBestanddelLegemiddel">
												<xsl:with-param name="tekst" select="substring-after(substring-after($LegemiddelBlanding, 'BestanddelLegemiddel'),'&gt;')"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="contains($LegemiddelBlanding, 'BestanddelAnnet')">
											<xsl:call-template name="skrivUtBestanddelAnnet">
												<xsl:with-param name="tekst" select="substring-after(substring-after($LegemiddelBlanding, 'BestanddelAnnet'),'&gt;')"/>
											</xsl:call-template>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="contains($konvertertBase64, 'NavnFormStyrke')">
											<b>
												<xsl:value-of select="substring-before(substring-after(substring-after($konvertertBase64, 'NavnFormStyrke'),'&gt;'),' ')"/>
											</b>&#160;<xsl:value-of select="substring-before(substring-after(substring-after(substring-after($konvertertBase64, 'NavnFormStyrke'),'&gt;'),' '),'&lt;/')"/>
										</xsl:if>&#160;<xsl:if test="contains($konvertertBase64, 'Atc') and contains(substring-before(substring-after($konvertertBase64,'Atc '),'/'), 'DN')">
											<div>&#160;&#160;&#160;<em>
													<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'Atc '),'/'),'DN=&quot;'),'&quot;')"/>
												</em>
											</div>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<!-- B64/Bruksomrade, B64/DosVeiledEnkel, (B64/Dosering) -->
							<td valign="top">
								<xsl:if test="contains($konvertertBase64, 'Bruksomrade')">
									<xsl:value-of select="substring-before(substring-after(substring-after($konvertertBase64, 'Bruksomrade'),'&gt;'),'&lt;/')"/>
									<br/>
								</xsl:if>
								<xsl:if test="contains($konvertertBase64, 'DosVeiledEnkel')">
									<xsl:value-of select="substring-before(substring-after(substring-after($konvertertBase64, 'DosVeiledEnkel'),'&gt;'),'&lt;/')"/>
									<br/>
								</xsl:if>
								<xsl:if test="contains($konvertertBase64, 'Dosering')">Strukturert&#160;dosering</xsl:if>&#160;
								</td>
							<!-- B64/Mengde eller B64/Antall x B64/Legemiddelpakning/PakningsinfoResept/Pakning-->
							<td valign="top">
								<xsl:choose>
									<xsl:when test="contains($konvertertBase64, 'Antall')">
										<xsl:value-of select="substring-before(substring-after(substring-after($konvertertBase64, 'Antall'),'&gt;'),'&lt;/')"/>&#160;x&#160;<xsl:value-of select="substring-before(substring-after(substring-after($konvertertBase64, 'Pakningsstr'),'&gt;'),'&lt;/')"/>&#160;<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'EnhetPakning '),'/'),'V=&quot;'),'&quot;')"/>&#160;
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'Mengde '),'/'),'V=&quot;'),'&quot;')"/>&#160;<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($konvertertBase64,'Mengde '),'/'),'U=&quot;'),'&quot;')"/>&#160;
									</xsl:otherwise>
								</xsl:choose>
							</td>
					</xsl:otherwise>
				</xsl:choose>
				<td colspan="5">&#160;</td>
			</tr>
		</xsl:for-each>
		<!-- Spørsmål -->
		<xsl:if test="child::*[local-name()=&quot;Sporsmal&quot;]">
			<tr class="No-line-doc">
				<xsl:if test="child::*[local-name()=&quot;Sporsmal&quot;]">
					<td colspan="11">
						<xsl:for-each select="child::*[local-name()=&quot;Sporsmal&quot;]">
							<xsl:if test="child::*[local-name()=&quot;Kode&quot;]">
								<b>
									<xsl:call-template name="k-7495">
										<xsl:with-param name="V" select="child::*[local-name()=&quot;Kode&quot;]/@V"/>
									</xsl:call-template>
								</b><xsl:if test="child::*[local-name()=&quot;Merknad&quot;] and string-length(child::*[local-name()=&quot;Merknad&quot;]) &gt; 0">
:&#160;<xsl:value-of select="child::*[local-name()=&quot;Merknad&quot;]"/>
								</xsl:if>
								<br/>
							</xsl:if>
							<xsl:for-each select="child::*[local-name()=&quot;Svar&quot;]">
								<xsl:if test="child::*[local-name()=&quot;Kode&quot;]">
									<b>
										<xsl:call-template name="k-7493">
											<xsl:with-param name="V" select="child::*[local-name()=&quot;Kode&quot;]/@V"/>
										</xsl:call-template>
									</b><xsl:if test="child::*[local-name()=&quot;Merknad&quot;] and string-length(child::*[local-name()=&quot;Merknad&quot;]) &gt; 0">
:&#160;<xsl:value-of select="child::*[local-name()=&quot;Merknad&quot;]"/>
									</xsl:if>
									<br/>
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Rolle">
		<tr>
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;Rolle&quot;] and string-length(child::*[local-name()=&quot;Rolle&quot;]/@V)!=0">
						<xsl:for-each select="child::*[local-name()=&quot;Rolle&quot;]">
							<xsl:call-template name="k-7490"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Rolle ikke oppgitt</xsl:otherwise>
				</xsl:choose>
			</th>
			<td>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;Helseperson&quot;]">
						<xsl:for-each select="child::*[local-name()=&quot;Helseperson&quot;]">
							<xsl:if test="child::*[local-name()=&quot;Fornavn&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;Fornavn&quot;]"/>&#160;</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;Etternavn&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;Etternavn&quot;]"/>&#160;</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;Spesialitet&quot;]/@DN">
								<b>Spes</b>:&#160;<xsl:value-of select="child::*[local-name()=&quot;Spesialitet&quot;]/@DN"/>&#160;</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;HprId&quot;]">
								<b>HPR</b>:&#160;<xsl:value-of select="child::*[local-name()=&quot;HprId&quot;]/child::*[local-name()=&quot;Id&quot;]"/>&#160;</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<!-- Organisasjon -->
						<xsl:for-each select="child::*[local-name()=&quot;Organisasjon&quot;]">
							<xsl:if test="child::*[local-name()=&quot;Inst&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;Inst&quot;]"/>&#160;</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;Dept&quot;]">
								<xsl:value-of select="child::*[local-name()=&quot;Dept&quot;]"/>&#160;</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;InstitusjonsID&quot;]/@DN">
								<b>RESH</b>:&#160;<xsl:value-of select="child::*[local-name()=&quot;InstitusjonsID&quot;]/@DN"/>&#160;</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;HerId&quot;]">
								<b>HER</b>:&#160;<xsl:value-of select="child::*[local-name()=&quot;HerId&quot;]/child::*[local-name()=&quot;Id&quot;]"/>&#160;</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	<!-- Rekursive funksjoner -->
	<xsl:template name="skrivUtAtc">
		<xsl:param name="tekst"/>
		<div>
			<xsl:value-of select="substring-before(substring-after(substring-before($tekst,'/'),'V=&quot;'),'&quot;')"/>
		</div>
		<xsl:if test="contains(substring-after($tekst,'&lt;/Atc&gt;'), 'Atc ')">
			<xsl:call-template name="skrivUtAtc">
				<xsl:with-param name="tekst" select="substring-after($tekst,'Atc ')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="skrivUtBestanddelLegemiddel">
		<xsl:param name="tekst"/>
		<xsl:if test="contains($tekst, 'NavnFormStyrke')">
			<div>
				<b>
					<xsl:value-of select="substring-before(substring-after(substring-after(substring-before($tekst, '&lt;/NavnFormStyrke&gt;'),'&lt;NavnFormStyrke'),'&gt;'),' ')"/>
				</b>&#160;<xsl:value-of select="substring-after(substring-after(substring-after(substring-before($tekst, '&lt;/NavnFormStyrke&gt;'),'&lt;NavnFormStyrke'),'&gt;'),' ')"/>&#160;
			</div>
		</xsl:if>
		<xsl:if test="contains($tekst, 'Atc') and contains(substring-before(substring-after($tekst,'&lt;Atc '),'/'), 'DN')">
			<div>&#160;&#160;&#160;<em>
					<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'&lt;Atc '),'/'),'DN=&quot;'),'&quot;')"/>
				</em>
			</div>
		</xsl:if>
		<xsl:if test="contains(substring-after($tekst,'&lt;/BestanddelLegemiddel&gt;'), 'BestanddelLegemiddel')">
			<xsl:call-template name="skrivUtBestanddelLegemiddel">
				<xsl:with-param name="tekst" select="substring-after($tekst,'&lt;/BestanddelLegemiddel&gt;')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="skrivUtBestanddelAnnet">
		<xsl:param name="tekst"/>
		<xsl:if test="contains($tekst, 'NavnFormStyrke')">
			<div>
				<b>
					<xsl:value-of select="substring-before(substring-after(substring-after(substring-before($tekst, '&lt;/NavnFormStyrke&gt;'),'&lt;NavnFormStyrke'),'&gt;'),' ')"/>
				</b>&#160;<xsl:value-of select="substring-after(substring-after(substring-after(substring-before($tekst, '&lt;/NavnFormStyrke&gt;'),'&lt;NavnFormStyrke'),'&gt;'),' ')"/>&#160;
			</div>
		</xsl:if>
		<xsl:if test="contains($tekst, 'Atc') and contains(substring-before(substring-after($tekst,'&lt;Atc '),'/'), 'DN')">
			<div>&#160;&#160;&#160;<em>
					<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($tekst,'&lt;Atc '),'/'),'DN=&quot;'),'&quot;')"/>
				</em>
			</div>
		</xsl:if>
		<xsl:if test="contains(substring-after($tekst,'&lt;/BestanddelAnnet&gt;'), 'BestanddelAnnet')">
			<xsl:call-template name="skrivUtBestanddelAnnet">
				<xsl:with-param name="tekst" select="substring-after($tekst,'&lt;/BestanddelAnnet&gt;')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- Funksjon for klargjøring av datoer for sammenligning -->
	<!-- Benytter funskjoner fra date-time biblioteket -->
	<xsl:template name="formaterDatoForSammenligning">
		<xsl:param name="gittDato"/>
		<xsl:call-template name="dt:get-xsd-datetime-year">
			<xsl:with-param name="xsd-date-time" select="$gittDato"/>
		</xsl:call-template>
		<xsl:call-template name="dt:get-xsd-datetime-month">
			<xsl:with-param name="xsd-date-time" select="$gittDato"/>
		</xsl:call-template>
		<xsl:call-template name="dt:get-xsd-datetime-day">
			<xsl:with-param name="xsd-date-time" select="$gittDato"/>
		</xsl:call-template>
		<xsl:call-template name="dt:get-xsd-datetime-hour">
			<xsl:with-param name="xsd-date-time" select="$gittDato"/>
		</xsl:call-template>
		<xsl:call-template name="dt:get-xsd-datetime-minute">
			<xsl:with-param name="xsd-date-time" select="$gittDato"/>
		</xsl:call-template>
		<xsl:call-template name="dt:get-xsd-datetime-second">
			<xsl:with-param name="xsd-date-time" select="$gittDato"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
