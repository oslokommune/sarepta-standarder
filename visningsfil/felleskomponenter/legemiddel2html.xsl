<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epj3="http://www.kith.no/xmlstds/epj/epj3/2008-02-20" xmlns:epj-t="http://www.kith.no/xmlstds/epj/EPJTilleggsinfo/2008-02-20" exclude-result-prefixes="epj3 epj-t">

	<!-- Inngår i Hdirs visningsfiler versjon 1.0
		Laget i XMLSpy v2012 rel2 (http://www.altova.com) av Jan Sigurd Dragsjø (helsedirektoratet.no) -->
	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="9"/>
	
	<!-- Visning av innhold i Legemiddelinfo -->
	<xsl:template match="epj3:Legemiddelinfo">
		<xsl:variable name="Atc" select="boolean(../child::epj3:Legemiddelinfo//epj3:Atc)"/>
		<xsl:variable name="Form" select="boolean(../child::epj3:Legemiddelinfo//epj3:Legemiddelform)"/>
		<xsl:variable name="Styrke" select="boolean(../child::epj3:Legemiddelinfo//epj3:Styrke)"/>
		<xsl:variable name="BrukT" select="boolean(../child::epj3:Legemiddelinfo//epj3:BruksomradeTekst)"/>
		<xsl:variable name="Bruk" select="boolean(../child::epj3:Legemiddelinfo//epj3:Bruk)"/>
		<xsl:variable name="Dos" select="boolean(../child::epj3:Legemiddelinfo//epj3:DosVeiledEnkel)"/>
		<xsl:variable name="Skal" select="boolean(../child::epj3:Legemiddelinfo//epj3:SkalIkkeTasSammenMedAnnetLegemiddel)"/>
		<xsl:variable name="Start" select="boolean(../child::epj3:Legemiddelinfo//epj3:DoseringStarttidspunkt)"/>
		<xsl:variable name="Slutt" select="boolean(../child::epj3:Legemiddelinfo//epj3:DoseringSluttidspunkt)"/>
		<xsl:variable name="Status" select="boolean(../child::epj3:Legemiddelinfo//epj3:StatusTilForskrivningen)"/>
		<xsl:variable name="Forskr" select="boolean(../child::epj3:Legemiddelinfo//epj3:Forskriver)"/>
		<xsl:variable name="Merk" select="boolean(../child::epj3:Legemiddelinfo//epj3:Merknad)"/>
		<xsl:variable name="Multi" select="boolean(../child::epj3:Legemiddelinfo//epj3:InngaarIMultidose)"/>
		<xsl:variable name="Viktig" select="boolean(../child::epj3:Legemiddelinfo/@referanseViktigTilleggsinfo)"/>
		<!-- Variabler for beregning av colspan i legemiddel-tabellen -->
		<xsl:variable name="lege-atc-col" select="(($std-col)-2)*number(not($Form or $Styrke or $BrukT or $Bruk or $Dos or $Skal or $Start or $Slutt or $Status or $Forskr or $Merk or $Multi or $Viktig))+1"/>
		<xsl:variable name="lege-form-col" select="(($std-col)-2-number($Atc))*number(not($Styrke or $BrukT or $Bruk or $Dos or $Skal or $Start or $Slutt or $Status or $Forskr or $Merk or $Multi or $Viktig))+1"/>
		<xsl:variable name="lege-bruk-col" select="(($std-col)-2-number($Atc)-number($Form or $Styrke))*number(not($Start or $Slutt or $Status or $Forskr or $Merk or $Multi or $Viktig))+1"/>
		<xsl:variable name="lege-tid-col" select="(($std-col)-2-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal))*number(not($Status or $Forskr or $Merk or $Multi or $Viktig))+1"/>
		<xsl:variable name="lege-status-col" select="(($std-col)-2-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal)-number($Start or $Slutt))*number(not($Forskr or $Merk or $Multi or $Viktig))+1"/>
		<xsl:variable name="lege-forskr-col" select="(($std-col)-2-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal)-number($Start or $Slutt)-number($Status))*number(not($Merk or $Multi or $Viktig))+1"/>
		<xsl:variable name="lege-merk-col" select="(($std-col)-2-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal)-number($Start or $Slutt)-number($Status)-number($Forskr))*number(not($Viktig))+1"/>
		<xsl:variable name="lege-viktig-col" select="(($std-col)-1-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal)-number($Start or $Slutt)-number($Status)-number($Forskr)-number($Merk or $Multi))"/>
		<!-- Visning av legemiddel-tabellen -->
		<xsl:if test="not(preceding-sibling::epj3:Legemiddelinfo)">
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
					<th colspan="{($lege-tid-col)}">Start&#160;og&#160;slutt</th>
				</xsl:if>
				<xsl:if test="$Status">
					<th colspan="{($lege-status-col)}">Status</th>
				</xsl:if>
				<xsl:if test="$Forskr">
					<th colspan="{($lege-forskr-col)}">Forskriver</th>
				</xsl:if>
				<xsl:if test="$Merk or $Multi">
					<th colspan="{($lege-merk-col)}">Merknad</th>
				</xsl:if>
				<xsl:if test="$Viktig">
					<th colspan="{($lege-viktig-col)}">Viktig&#160;tilleggsinfo</th>
				</xsl:if>
			</tr>
		</xsl:if>
		<tr>
			<td>
				<div>
					<b>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select=".//epj3:Navn"/>
						</xsl:call-template>
					</b>
				</div>
				<xsl:if test=".//epj3:GeneriskNavn">
					<div>
						<b>Generisk:</b>&#160;
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select=".//epj3:GeneriskNavn"/>
						</xsl:call-template>
					</div>
				</xsl:if>
				<xsl:if test=".//epj3:Nr">
					<div>
						<b>Varenummer:</b>&#160;
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select=".//epj3:Nr"/>
						</xsl:call-template>
					</div>
				</xsl:if>
			</td>
			<xsl:if test="$Atc">
				<td colspan="{($lege-atc-col)}">
					<xsl:for-each select=".//epj3:Atc">
						<xsl:value-of select="@V"/>,&#160;<xsl:value-of select="@DN"/>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="$Form or $Styrke">
				<td colspan="{($lege-form-col)}">
					<xsl:for-each select=".//epj3:Legemiddelform">
						<xsl:value-of select="@DN"/>&#160;
					</xsl:for-each>
					<xsl:for-each select=".//epj3:Styrke">
						<xsl:value-of select="@V"/>&#160;<xsl:value-of select="@U"/>&#160;
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="$BrukT or $Bruk or $Dos or $Skal">
				<td colspan="{($lege-bruk-col)}">
					<xsl:if test=".//epj3:Bruk or .//epj3:BruksomradeTekst">
						<b>Bruk:</b>&#160;
						<xsl:for-each select=".//epj3:Bruk">
							<xsl:call-template name="k-9101"/>&#160;
						</xsl:for-each>
						<xsl:for-each select=".//epj3:BruksomradeTekst">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test=".//epj3:DosVeiledEnkel">
						<div>
							<b>Dosering:</b>&#160;
							<xsl:for-each select=".//epj3:DosVeiledEnkel">
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="."/>
								</xsl:call-template>
							</xsl:for-each>
						</div>
					</xsl:if>
					<xsl:if test=".//epj3:SkalIkkeTasSammenMedAnnetLegemiddel">
						<xsl:if test=".//epj3:SkalIkkeTasSammenMedAnnetLegemiddel='true'">
							<div>Skal&#160;ikke&#160;tas&#160;sammen med&#160;annet&#160;legemiddel</div>
						</xsl:if>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="$Start or $Slutt">
				<td colspan="{($lege-tid-col)}">
					<xsl:if test=".//epj3:DoseringStarttidspunkt">
						<b>Start:</b>&#160;
						<xsl:for-each select=".//epj3:DoseringStarttidspunkt">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="@V"/>
							</xsl:call-template>&#160;
						</xsl:for-each>
					</xsl:if>
					<xsl:if test=".//epj3:DoseringSluttidspunkt">
						<div>
							<b>Slutt:</b>&#160;
							<xsl:for-each select=".//epj3:DoseringSluttidspunkt">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="@V"/>
								</xsl:call-template>&#160;
							</xsl:for-each>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="$Status">
				<td colspan="{($lege-status-col)}">
					<xsl:for-each select=".//epj3:StatusTilForskrivningen">
						<xsl:call-template name="k-9104"/>&#160;
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="$Forskr">
				<td colspan="{($lege-forskr-col)}">
					<div class="No-line-content">
						<xsl:for-each select=".//epj3:Forskriver">
							<xsl:call-template name="HealthcareProfessional"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<xsl:if test="$Merk or $Multi">
				<td colspan="{($lege-merk-col)}">
					<xsl:if test=".//epj3:Merknad">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select=".//epj3:Merknad"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:for-each select=".//epj3:InngaarIMultidose">
						<div>
							<xsl:call-template name="k-9103"/>&#160;
						</div>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="$Viktig">
				<td colspan="{($lege-viktig-col)}">
					<xsl:if test="@komponentID = //epj-t:tilleggsinfoEPJKomponent//epj-t:linkTilKomponent">
						Referert versjon
					</xsl:if>
					<xsl:if test="@referanseViktigTilleggsinfo">
						<xsl:variable name="var" select="./@referanseViktigTilleggsinfo"/>
						<div class="viktig">
							<xsl:for-each select="//epj-t:tilleggsinfoEPJKomponent[@komponentID = $var]//epj-t:linktype">
								<xsl:call-template name="k-9205"/>&#160;
							</xsl:for-each>
						</div>
						<xsl:if test="//epj-t:tilleggsinfoEPJKomponent[@komponentID = $var]//epj-t:linkstyrke">
							<div>
								<xsl:for-each select="//epj-t:tilleggsinfoEPJKomponent[@komponentID = $var]//epj-t:linkstyrke">
									<xsl:call-template name="k-9206"/>&#160;
								</xsl:for-each>
							</div>
						</xsl:if>
						<xsl:if test="//epj-t:tilleggsinfoEPJKomponent[@komponentID = $var]//epj-t:merknad">
							<div>
								<xsl:value-of select="//epj-t:tilleggsinfoEPJKomponent[@komponentID = $var]//epj-t:merknad"/>
							</div>
						</xsl:if>
					</xsl:if>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	
	<!-- Visning av innhold i Legemidler administrert ved overføring -->
	<xsl:template match="epj3:LegemidlerAdministrertVedOverforing">
		<xsl:variable name="Atc" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:Atc)"/>
		<xsl:variable name="Form" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:Legemiddelform)"/>
		<xsl:variable name="Styrke" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:Styrke)"/>
		<xsl:variable name="BrukT" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:BruksomradeTekst)"/>
		<xsl:variable name="Bruk" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:Bruk)"/>
		<xsl:variable name="Dos" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:DosVeiledEnkel)"/>
		<xsl:variable name="Skal" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:SkalIkkeTasSammenMedAnnetLegemiddel)"/>
		<xsl:variable name="Start" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:DoseringStarttidspunkt)"/>
		<xsl:variable name="Slutt" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:DoseringSluttidspunkt)"/>
		<xsl:variable name="Dose" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:AdmEnkeltdose)"/>
		<xsl:variable name="Kvant" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:Kvantum)"/>
		<xsl:variable name="Ant" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:AntEnkeltdoser)"/>
		<xsl:variable name="AStart" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:AdmStart)"/>
		<xsl:variable name="ASlutt" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:AdmSlutt)"/>
		<xsl:variable name="AStatus" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:AdmStatus)"/>
		<xsl:variable name="AAv" select="boolean(../child::epj3:LegemidlerAdministrertVedOverforing//epj3:AdministrertAv)"/>
		<!-- Variabler for beregning av colspan i legemiddel-tabellen -->
		<xsl:variable name="lavo-adm-col" select="(($std-col)-1-number($Atc)-number($Form or $Styrke)-number($BrukT or $Bruk or $Dos or $Skal)-number($Start or $Slutt)-number($Dose or $Kvant or $Ant)-number($AStart or $ASlutt or $AStatus))"/>
		<!-- Visning av legemiddel-tabellen -->
		<xsl:if test="not(preceding-sibling::epj3:LegemidlerAdministrertVedOverforing)">
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
								<xsl:with-param name="text" select=".//epj3:Navn"/>
							</xsl:call-template>
						</b>
					</div>
					<xsl:if test=".//epj3:GeneriskNavn">
						<div>
							<b>Generisk:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select=".//epj3:GeneriskNavn"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test=".//epj3:Nr">
						<div>
							<b>Varenummer:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select=".//epj3:Nr"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</td>
				<xsl:if test="$Atc">
					<td>
						<xsl:for-each select=".//epj3:Atc">
							<xsl:value-of select="@V"/>,&#160;<xsl:value-of select="@DN"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="$Form or $Styrke">
					<td>
						<xsl:for-each select=".//epj3:Legemiddelform">
							<xsl:value-of select="@DN"/>&#160;
						</xsl:for-each>
						<xsl:for-each select=".//epj3:Styrke">
							<xsl:value-of select="@V"/>&#160;<xsl:value-of select="@U"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="$BrukT or $Bruk or $Dos or $Skal">
					<td>
						<xsl:if test=".//epj3:Bruk or .//epj3:BruksomradeTekst">
							<b>Bruk:</b>&#160;
							<xsl:for-each select=".//epj3:Bruk">
								<xsl:call-template name="k-9101"/>&#160;
							</xsl:for-each>
							<xsl:for-each select=".//epj3:BruksomradeTekst">
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="."/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test=".//epj3:DosVeiledEnkel">
							<div>
								<b>Dosering:</b>&#160;
								<xsl:for-each select=".//epj3:DosVeiledEnkel">
									<xsl:call-template name="line-breaks">
										<xsl:with-param name="text" select="."/>
									</xsl:call-template>
								</xsl:for-each>
							</div>
						</xsl:if>
						<xsl:if test=".//epj3:SkalIkkeTasSammenMedAnnetLegemiddel">
							<xsl:if test=".//epj3:SkalIkkeTasSammenMedAnnetLegemiddel='true'">
								<div>Skal&#160;ikke&#160;tas&#160;sammen med&#160;annet&#160;legemiddel</div>
							</xsl:if>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="$Start or $Slutt">
					<td>
						<xsl:if test=".//epj3:DoseringStarttidspunkt">
							<b>Start:</b>&#160;
							<xsl:for-each select=".//epj3:DoseringStarttidspunkt">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="@V"/>
								</xsl:call-template>&#160;
							</xsl:for-each>
						</xsl:if>
						<xsl:if test=".//epj3:DoseringSluttidspunkt">
							<div>
								<b>Slutt:</b>&#160;
								<xsl:for-each select=".//epj3:DoseringSluttidspunkt">
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
						<xsl:if test=".//epj3:Kvantum">
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select=".//epj3:Kvantum"/>
							</xsl:call-template>
							&#160;x&#160;
						</xsl:if>
						<xsl:if test=".//epj3:AntEnkeltdoser">
							<xsl:value-of select=".//epj3:AntEnkeltdoser"/>
							&#160;x&#160;
						</xsl:if>
						<xsl:if test=".//epj3:AdmEnkeltdose">
							<xsl:value-of select=".//epj3:AdmEnkeltdose/@V"/>&#160;<xsl:value-of select=".//epj3:AdmEnkeltdose/@U"/>&#160;
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="$AStart or $ASlutt or $AStatus">
					<td>
						<xsl:if test=".//epj3:AdmStart">
							<b>Start:</b>&#160;
							<xsl:for-each select=".//epj3:AdmStart">
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="@V"/>
								</xsl:call-template>&#160;
							</xsl:for-each>
						</xsl:if>
						<xsl:if test=".//epj3:AdmSlutt">
							<div>
								<b>Slutt:</b>&#160;
								<xsl:for-each select=".//epj3:AdmSlutt">
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="@V"/>
									</xsl:call-template>&#160;
								</xsl:for-each>
							</div>
						</xsl:if>
						<xsl:if test=".//epj3:AdmStatus">
							<div>
								<b>Status:</b>&#160;
								<xsl:for-each select=".//epj3:AdmStatus">
									<xsl:call-template name="k-9083"/>
								</xsl:for-each>
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<td colspan="{($lavo-adm-col)}">
						<xsl:choose>
							<xsl:when test=".//epj3:AdministrertAv">
								<div class="No-line-content">
									<xsl:for-each select=".//epj3:AdministrertAv">
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

	<!-- Kodeverk -->
	<xsl:template name="k-9083">
		<xsl:choose>
			<xsl:when test="@V='1'">Inntatt&#160;i&#160;sin&#160;helhet</xsl:when>
			<xsl:when test="@V='2'">Delvis&#160;inntatt</xsl:when>
			<xsl:when test="@V='3'">Nektet&#160;inntatt</xsl:when>
			<xsl:when test="@V='4'">Ikke&#160;gitt</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9101">
		<xsl:choose>
			<xsl:when test="@V='1'">Fast</xsl:when>
			<xsl:when test="@V='2'">Kur</xsl:when>
			<xsl:when test="@V='3'">Ved&#160;behov</xsl:when>
			<xsl:when test="@V='4'">Vaksine</xsl:when>
			<xsl:when test="@V='5'">Næringsmiddel/vitaminer</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9103">
		<xsl:choose>
			<xsl:when test="@V='1'">Legemiddeldosering&#160;inngår&#160;ikke&#160;i&#160;en&#160;multidose</xsl:when>
			<xsl:when test="@V='2'">Legemiddeldosering&#160;inngår&#160;i&#160;multidose og&#160;informasjon&#160;er&#160;sendt&#160;til&#160;leverandør</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9104">
		<xsl:choose>
			<xsl:when test="@V='1'">Originalforskrivning</xsl:when>
			<xsl:when test="@V='2'">Seponert</xsl:when>
			<xsl:when test="@V='3'">Utlevert&#160;legemiddel</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9205">
		<xsl:choose>
			<xsl:when test="@V='01'">Erstatter&#160;tidligere&#160;versjon</xsl:when>
			<xsl:when test="@V='11'">Se&#160;også</xsl:when>
			<xsl:when test="@V='L1'">Erstatter&#160;referert&#160;forskrivning (doseendring)</xsl:when>
			<xsl:when test="@V='L2'">Erstatter&#160;referert&#160;forskrivning (annet legemiddel)</xsl:when>
			<xsl:when test="@V='L3'">Referert&#160;forskrivning&#160;seponeres</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9206">
		<xsl:choose>
			<xsl:when test="@V='1'">Tidligere&#160;versjon&#160;uten&#160;relevans for&#160;framtidig&#160;helsehjelp</xsl:when>
			<xsl:when test="@V='2'">Tilleggsopplysninger&#160;uten&#160;særlig&#160;relevans for&#160;framtidig&#160;helsehjelp</xsl:when>
			<xsl:when test="@V='5'">Tilleggsopplysninger&#160;som&#160;kan&#160;være&#160;relevante i&#160;forbindelse&#160;framtidig&#160;helsehjelp</xsl:when>
			<xsl:when test="@V='9'">Tilleggsopplysninger&#160;som&#160;er&#160;helt&#160;nødvendige for&#160;forståelsen&#160;av&#160;dokumentasjonen</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
