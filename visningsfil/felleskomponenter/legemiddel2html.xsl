<?xml version="1.0" encoding="UTF-8"?>
	<!-- Endringslogg
	- 04.12.15: Innføring av felles kodeverksfil. Småjusteringer på layout.
	-->
	<!-- Om
	- Inngår i Hdirs visningsfiler versjon 2.0
	- Laget i XMLSpy v2016 (http://www.altova.com) av Jan Sigurd Dragsjø (nhn.no)
	-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Filer som må importeres. Vanligvis gjøres dette i hovedfila som importerer denne komponentfila. Derfor er de kommentert ut.
	<xsl:import href="funksjoner.xsl"/>
	<xsl:import href="meldingshode2html.xsl"/>
	<xsl:import href="kodeverk.xsl"/> -->

	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="8"/>
	<xsl:variable name="std-td" select="100"/>
	
	<!-- Visning av innhold i Legemiddelinfo -->
	<xsl:template name="Legemiddelinfo">
		<xsl:variable name="Atc" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;Atc&quot;])"/>
		<xsl:variable name="Form" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;Legemiddelform&quot;])"/>
		<xsl:variable name="Styrke" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;Styrke&quot;])"/>
		<xsl:variable name="BrukT" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;BruksomradeTekst&quot;])"/>
		<xsl:variable name="Bruk" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;Bruk&quot;])"/>
		<xsl:variable name="Dos" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;DosVeiledEnkel&quot;])"/>
		<xsl:variable name="Skal" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;SkalIkkeTasSammenMedAnnetLegemiddel&quot;])"/>
		<xsl:variable name="Start" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;DoseringStarttidspunkt&quot;])"/>
		<xsl:variable name="Slutt" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;DoseringSluttidspunkt&quot;])"/>
		<xsl:variable name="Status" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;StatusTilForskrivningen&quot;])"/>
		<xsl:variable name="Forskr" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;Forskriver&quot;])"/>
		<xsl:variable name="Merk" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;Merknad&quot;])"/>
		<xsl:variable name="Multi" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]//child::*[local-name()=&quot;InngaarIMultidose&quot;])"/>
		<xsl:variable name="Viktig" select="boolean(../child::*[local-name()=&quot;Legemiddelinfo&quot;]/@referanseViktigTilleggsinfo)"/>
		<!-- Variabler for beregning av colspan i legemiddel-tabellen -->
		<xsl:variable name="lege-atc-col" select="(($std-col)-2)*number(not($Form or $Styrke or $BrukT or $Bruk or $Dos or $Skal or $Start or $Slutt or $Status or $Forskr or $Multi or $Merk or $Viktig))+1"/>
		<xsl:variable name="lege-form-col" select="(($std-col)-2-number($Atc))*number(not($Styrke or $BrukT or $Bruk or $Dos or $Skal or $Start or $Slutt or $Status or $Forskr or $Multi or $Merk or $Viktig))+1"/>
		<xsl:variable name="lege-bruk-col" select="(($std-col)-2-number($Atc)-number($Form or $Styrke))*number(not($Start or $Slutt or $Status or $Forskr or $Multi or $Merk or $Viktig))+1"/>
		<xsl:variable name="lege-tid-col" select="(($std-col)-2-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal))*number(not($Status or $Forskr or $Multi or $Merk or $Viktig))+1"/>
		<xsl:variable name="lege-status-col" select="(($std-col)-2-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal)-number($Start or $Slutt))*number(not($Forskr or $Multi or $Merk or $Viktig))+1"/>
		<xsl:variable name="lege-forskr-col" select="(($std-col)-2-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal)-number($Start or $Slutt)-number($Status))*number(not($Multi or $Merk or $Viktig))+1"/>
		<xsl:variable name="lege-multi-col" select="(($std-col)-2-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal)-number($Start or $Slutt)-number($Status)-number($Forskr))*number(not($Merk or $Viktig))+1"/>
		<xsl:variable name="lege-merk-col" select="(($std-col)-2-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal)-number($Start or $Slutt)-number($Status)-number($Forskr)-number($Multi))*number(not($Viktig))+1"/>
		<xsl:variable name="lege-viktig-col" select="(($std-col)-1-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal)-number($Start or $Slutt)-number($Status)-number($Forskr)-number($Multi)-number($Merk))"/>
		<!-- Visning av legemiddel-tabellen -->
		<xsl:if test="not(preceding-sibling::*[local-name()=&quot;Legemiddelinfo&quot;])">
			<!-- Visning av legemiddel-tabellen header-overskrifter -->
			<tr>
				<th>Navn og nr.</th>
				<xsl:if test="$Atc">
					<th colspan="{($lege-atc-col)}">Atc</th>
				</xsl:if>
				<xsl:if test="$Form or $Styrke">
					<th colspan="{($lege-form-col)}">Form&#160;og&#160;styrke</th>
				</xsl:if>
				<xsl:if test="$BrukT or $Bruk or $Dos or $Skal">
					<th colspan="{($lege-bruk-col)}">Bruk&#160;og&#160;dosering</th>
				</xsl:if>
				<xsl:if test="$Start or $Slutt">
					<th colspan="{($lege-tid-col)}">Start&#160;-&#160;slutt</th>
				</xsl:if>
				<xsl:if test="$Status">
					<th colspan="{($lege-status-col)}">Status</th>
				</xsl:if>
				<xsl:if test="$Forskr">
					<th colspan="{($lege-forskr-col)}">Forskriver</th>
				</xsl:if>
				<xsl:if test="$Multi">
					<th colspan="{($lege-multi-col)}">Multidose</th>
				</xsl:if>
				<xsl:if test="$Merk">
					<th colspan="{($lege-merk-col)}">Merknad</th>
				</xsl:if>
				<xsl:if test="$Viktig">
					<th colspan="{($lege-viktig-col)}">Viktig&#160;tilleggsinfo</th>
				</xsl:if>
			</tr>
		</xsl:if>
		<tr>
			<td width="{($std-td)}px">
				<div>
					<b>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select=".//child::*[local-name()=&quot;Navn&quot;]"/>
						</xsl:call-template>
					</b>
				</div>
				<xsl:if test=".//child::*[local-name()=&quot;GeneriskNavn&quot;]">
					<div>
						<b>Generisk:</b>&#160;
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select=".//child::*[local-name()=&quot;GeneriskNavn&quot;]"/>
						</xsl:call-template>
					</div>
				</xsl:if>
				<xsl:if test=".//child::*[local-name()=&quot;Nr&quot;]">
					<div>
						<b>V.nr:</b>&#160;
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select=".//child::*[local-name()=&quot;Nr&quot;]"/>
						</xsl:call-template>
					</div>
				</xsl:if>
			</td>
			<xsl:if test="$Atc">
				<td width="{($lege-atc-col)*$std-td}px" colspan="{($lege-atc-col)}">
					<xsl:for-each select=".//child::*[local-name()=&quot;Atc&quot;]">
						<xsl:call-template name="k-dummy"/>&#160;
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="$Form or $Styrke">
				<td width="{($lege-form-col)*$std-td}px" colspan="{($lege-form-col)}">
					<xsl:for-each select=".//child::*[local-name()=&quot;Legemiddelform&quot;]">
						<xsl:call-template name="k-dummy"/>&#160;
					</xsl:for-each>
					<xsl:for-each select=".//child::*[local-name()=&quot;Styrke&quot;]">
						<xsl:value-of select="@V"/>&#160;<xsl:value-of select="@U"/>&#160;
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="$BrukT or $Bruk or $Dos or $Skal">
				<td width="{($lege-bruk-col)*$std-td*1.5}px" colspan="{($lege-bruk-col)}">
					<xsl:if test=".//child::*[local-name()=&quot;Bruk&quot;] or .//child::*[local-name()=&quot;BruksomradeTekst&quot;]">
						<xsl:for-each select=".//child::*[local-name()=&quot;Bruk&quot;]">
							<xsl:call-template name="k-9101"/>&#160;
						</xsl:for-each>
						<xsl:for-each select=".//child::*[local-name()=&quot;BruksomradeTekst&quot;]">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="."/>
							</xsl:call-template>&#160;
						</xsl:for-each>
					</xsl:if>
					<xsl:if test=".//child::*[local-name()=&quot;DosVeiledEnkel&quot;]">
						<xsl:for-each select=".//child::*[local-name()=&quot;DosVeiledEnkel&quot;]">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test=".//child::*[local-name()=&quot;SkalIkkeTasSammenMedAnnetLegemiddel&quot;]">
						<xsl:if test=".//child::*[local-name()=&quot;SkalIkkeTasSammenMedAnnetLegemiddel&quot;]='true'">
							<div>Skal&#160;ikke&#160;tas&#160;sammen med&#160;annet&#160;legemiddel</div>
						</xsl:if>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="$Start or $Slutt">
				<td width="{($lege-tid-col)*$std-td}px" colspan="{($lege-tid-col)}">
					<xsl:if test=".//child::*[local-name()=&quot;DoseringStarttidspunkt&quot;]">
						<xsl:for-each select=".//child::*[local-name()=&quot;DoseringStarttidspunkt&quot;]">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="@V"/>
							</xsl:call-template>&#160;
						</xsl:for-each>
					</xsl:if>
					<xsl:if test=".//child::*[local-name()=&quot;DoseringSluttidspunkt&quot;]">
						<xsl:for-each select=".//child::*[local-name()=&quot;DoseringSluttidspunkt&quot;]">
							-&#160;<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="@V"/>
							</xsl:call-template>&#160;
						</xsl:for-each>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="$Status">
				<td width="{($lege-status-col)*$std-td}px" colspan="{($lege-status-col)}">
					<xsl:for-each select=".//child::*[local-name()=&quot;StatusTilForskrivningen&quot;]">
						<xsl:call-template name="k-9104"/>&#160;
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="$Forskr">
				<td width="{($lege-forskr-col)*$std-td}px" colspan="{($lege-forskr-col)}">
					<div class="No-line-content">
						<xsl:for-each select=".//child::*[local-name()=&quot;Forskriver&quot;]">
							<xsl:call-template name="HealthcareProfessional"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<xsl:if test="$Multi">
				<td width="{($lege-multi-col)*$std-td*0.5}px" colspan="{($lege-multi-col)}">
					<xsl:for-each select=".//child::*[local-name()=&quot;InngaarIMultidose&quot;]">
						<xsl:choose>
							<xsl:when test="@V='2'"><input type="checkbox" checked="checked" disabled="disabled"/></xsl:when>
							<xsl:otherwise><input type="checkbox" disabled="disabled"/></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="$Merk">
				<td width="{($lege-merk-col)*$std-td*1.5}px" colspan="{($lege-merk-col)}">
					<xsl:if test=".//child::*[local-name()=&quot;Merknad&quot;]">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select=".//child::*[local-name()=&quot;Merknad&quot;]"/>
						</xsl:call-template>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="$Viktig">
				<td width="{($lege-viktig-col)*$std-td}px" colspan="{($lege-viktig-col)}">
					<xsl:if test="@komponentID = //child::*[local-name()=&quot;tilleggsinfoEPJKomponent&quot;]//child::*[local-name()=&quot;linkTilKomponent&quot;]">
						Referert versjon
					</xsl:if>
					<xsl:if test="@referanseViktigTilleggsinfo">
						<xsl:variable name="var" select="./@referanseViktigTilleggsinfo"/>
						<div class="viktig">
							<xsl:for-each select="//child::*[local-name()=&quot;tilleggsinfoEPJKomponent&quot;][@komponentID = $var]//child::*[local-name()=&quot;linktype&quot;]">
								<xsl:call-template name="k-9205"/>&#160;
							</xsl:for-each>
						</div>
						<xsl:if test="//child::*[local-name()=&quot;tilleggsinfoEPJKomponent&quot;][@komponentID = $var]//child::*[local-name()=&quot;linkstyrke&quot;]">
							<div>
								<xsl:for-each select="//child::*[local-name()=&quot;tilleggsinfoEPJKomponent&quot;][@komponentID = $var]//child::*[local-name()=&quot;linkstyrke&quot;]">
									<xsl:call-template name="k-9206"/>&#160;
								</xsl:for-each>
							</div>
						</xsl:if>
						<xsl:if test="//child::*[local-name()=&quot;tilleggsinfoEPJKomponent&quot;][@komponentID = $var]//child::*[local-name()=&quot;merknad&quot;]">
							<div>
								<xsl:value-of select="//child::*[local-name()=&quot;tilleggsinfoEPJKomponent&quot;][@komponentID = $var]//child::*[local-name()=&quot;merknad&quot;]"/>
							</div>
						</xsl:if>
					</xsl:if>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	
	<!-- Visning av innhold i Legemidler administrert ved overføring -->
	<xsl:template name="LegemidlerAdministrertVedOverforing">
		<xsl:variable name="Atc" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;Atc&quot;])"/>
		<xsl:variable name="Form" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;Legemiddelform&quot;])"/>
		<xsl:variable name="Styrke" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;Styrke&quot;])"/>
		<xsl:variable name="BrukT" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;BruksomradeTekst&quot;])"/>
		<xsl:variable name="Bruk" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;Bruk&quot;])"/>
		<xsl:variable name="Dos" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;DosVeiledEnkel&quot;])"/>
		<xsl:variable name="Skal" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;SkalIkkeTasSammenMedAnnetLegemiddel&quot;])"/>
		<xsl:variable name="Start" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;DoseringStarttidspunkt&quot;])"/>
		<xsl:variable name="Slutt" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;DoseringSluttidspunkt&quot;])"/>
		<xsl:variable name="Dose" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;AdmEnkeltdose&quot;])"/>
		<xsl:variable name="Kvant" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;Kvantum&quot;])"/>
		<xsl:variable name="Ant" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;AntEnkeltdoser&quot;])"/>
		<xsl:variable name="AStart" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;AdmStart&quot;])"/>
		<xsl:variable name="ASlutt" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;AdmSlutt&quot;])"/>
		<xsl:variable name="AStatus" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;AdmStatus&quot;])"/>
		<xsl:variable name="AAv" select="boolean(../child::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;]//child::*[local-name()=&quot;AdministrertAv&quot;])"/>
		<!-- Variabler for beregning av colspan i legemiddel-tabellen -->
		<xsl:variable name="lavo-adm-col" select="(($std-col)-1-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal)-number($Start or $Slutt)-number($Dose or $Kvant or $Ant)-number($AStart or $ASlutt or $AStatus))"/>
		<!-- Visning av legemiddel-tabellen -->
		<xsl:if test="not(preceding-sibling::*[local-name()=&quot;LegemidlerAdministrertVedOverforing&quot;])">
			<!-- Visning av legemiddel-tabellen header-overskrifter -->
			<tr>
				<th>Navn og nr.</th>
				<xsl:if test="$Atc">
					<th>Atc</th>
				</xsl:if>
				<xsl:if test="$Form or $Styrke">
					<th>Form&#160;og&#160;styrke</th>
				</xsl:if>
				<xsl:if test="$BrukT or $Bruk or $Dos or $Skal">
					<th>Bruk&#160;og&#160;dosering</th>
				</xsl:if>
				<xsl:if test="$Start or $Slutt">
					<th>Start&#160;og&#160;slutt</th>
				</xsl:if>
				<xsl:if test="$Dose or $Kvant or $Ant">
					<th>Administrert&#160;mengde</th>
				</xsl:if>
				<xsl:if test="$AStart or $ASlutt or $AStatus">
					<th>Administrasjon</th>
				</xsl:if>
				<th colspan="{($lavo-adm-col)}">Administrert&#160;av</th>
			</tr>
		</xsl:if>
		<xsl:for-each select="child::*">
			<tr>
				<td>
					<div>
						<b>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select=".//child::*[local-name()=&quot;Navn&quot;]"/>
							</xsl:call-template>
						</b>
					</div>
					<xsl:if test=".//child::*[local-name()=&quot;GeneriskNavn&quot;]">
						<div>
							<b>Generisk:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select=".//child::*[local-name()=&quot;GeneriskNavn&quot;]"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test=".//child::*[local-name()=&quot;Nr&quot;]">
						<div>
							<b>Varenummer:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select=".//child::*[local-name()=&quot;Nr&quot;]"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</td>
				<xsl:if test="$Atc">
					<td>
						<xsl:for-each select=".//child::*[local-name()=&quot;Atc&quot;]">
							<xsl:call-template name="k-dummy"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="$Form or $Styrke">
					<td>
						<xsl:for-each select=".//child::*[local-name()=&quot;Legemiddelform&quot;]">
							<xsl:call-template name="k-dummy"/>&#160;
						</xsl:for-each>
						<xsl:for-each select=".//child::*[local-name()=&quot;Styrke&quot;]">
							<xsl:value-of select="@V"/>&#160;<xsl:value-of select="@U"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="$BrukT or $Bruk or $Dos or $Skal">
					<td>
						<xsl:if test=".//child::*[local-name()=&quot;Bruk&quot;] or .//child::*[local-name()=&quot;BruksomradeTekst&quot;]">
							<b>Bruk:</b>&#160;
							<xsl:for-each select=".//child::*[local-name()=&quot;Bruk&quot;]">
								<xsl:call-template name="k-9101"/>&#160;
							</xsl:for-each>
							<xsl:for-each select=".//child::*[local-name()=&quot;BruksomradeTekst&quot;]">
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="."/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test=".//child::*[local-name()=&quot;DosVeiledEnkel&quot;]">
							<div>
								<b>Dosering:</b>&#160;
								<xsl:for-each select=".//child::*[local-name()=&quot;DosVeiledEnkel&quot;]">
									<xsl:call-template name="line-breaks">
										<xsl:with-param name="text" select="."/>
									</xsl:call-template>
								</xsl:for-each>
							</div>
						</xsl:if>
						<xsl:if test=".//child::*[local-name()=&quot;SkalIkkeTasSammenMedAnnetLegemiddel&quot;]">
							<xsl:if test=".//child::*[local-name()=&quot;SkalIkkeTasSammenMedAnnetLegemiddel&quot;]='true'">
								<div>Skal&#160;ikke&#160;tas&#160;sammen med&#160;annet&#160;legemiddel</div>
							</xsl:if>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="$Start or $Slutt">
					<td>
						<xsl:if test=".//child::*[local-name()=&quot;DoseringStarttidspunkt&quot;]">
							<b>Start:</b>&#160;
							<xsl:for-each select=".//child::*[local-name()=&quot;DoseringStarttidspunkt&quot;]">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="@V"/>
								</xsl:call-template>&#160;
							</xsl:for-each>
						</xsl:if>
						<xsl:if test=".//child::*[local-name()=&quot;DoseringSluttidspunkt&quot;]">
							<div>
								<b>Slutt:</b>&#160;
								<xsl:for-each select=".//child::*[local-name()=&quot;DoseringSluttidspunkt&quot;]">
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="@V"/>
									</xsl:call-template>&#160;
								</xsl:for-each>
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="$Dose or $Kvant or $Ant">
					<td>
						<xsl:if test=".//child::*[local-name()=&quot;Kvantum&quot;]">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select=".//child::*[local-name()=&quot;Kvantum&quot;]"/>
							</xsl:call-template>
							&#160;x&#160;
						</xsl:if>
						<xsl:if test=".//child::*[local-name()=&quot;AntEnkeltdoser&quot;]">
							<xsl:value-of select=".//child::*[local-name()=&quot;AntEnkeltdoser&quot;]"/>
							&#160;x&#160;
						</xsl:if>
						<xsl:if test=".//child::*[local-name()=&quot;AdmEnkeltdose&quot;]">
							<xsl:value-of select=".//child::*[local-name()=&quot;AdmEnkeltdose&quot;]/@V"/>&#160;<xsl:value-of select=".//child::*[local-name()=&quot;AdmEnkeltdose&quot;]/@U"/>&#160;
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="$AStart or $ASlutt or $AStatus">
					<td>
						<xsl:if test=".//child::*[local-name()=&quot;AdmStart&quot;]">
							<b>Start:</b>&#160;
							<xsl:for-each select=".//child::*[local-name()=&quot;AdmStart&quot;]">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="@V"/>
								</xsl:call-template>&#160;
							</xsl:for-each>
						</xsl:if>
						<xsl:if test=".//child::*[local-name()=&quot;AdmSlutt&quot;]">
							<div>
								<b>Slutt:</b>&#160;
								<xsl:for-each select=".//child::*[local-name()=&quot;AdmSlutt&quot;]">
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="@V"/>
									</xsl:call-template>&#160;
								</xsl:for-each>
							</div>
						</xsl:if>
						<xsl:if test=".//child::*[local-name()=&quot;AdmStatus&quot;]">
							<div>
								<b>Status:</b>&#160;
								<xsl:for-each select=".//child::*[local-name()=&quot;AdmStatus&quot;]">
									<xsl:call-template name="k-9083"/>
								</xsl:for-each>
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<td colspan="{($lavo-adm-col)}">
					<xsl:choose>
						<xsl:when test=".//child::*[local-name()=&quot;AdministrertAv&quot;]">
							<div class="No-line-content">
								<xsl:for-each select=".//child::*[local-name()=&quot;AdministrertAv&quot;]">
									<xsl:call-template name="HealthcareProfessional"/>
								</xsl:for-each>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="local-name(.)=&quot;AdmAvHelsepersonell&quot;">Helsepersonell</xsl:if>
							<xsl:if test="local-name(.)=&quot;Egenadministrering&quot;">Pasient/pårørende</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
