<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:po="http://www.kith.no/xmlstds/po/poKomponent/2012-04-01" xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" xmlns:epj1="http://www.kith.no/xmlstds/epj/epj1/2008-02-20" xmlns:epj2="http://www.kith.no/xmlstds/epj/epj2/2008-02-20" xmlns:epj3="http://www.kith.no/xmlstds/epj/epj3/2008-02-20" exclude-result-prefixes="po fk1 epj1 epj2 epj3">
	<!-- Inngår i Hdirs visningsfiler versjon 1.0
		Laget i XMLSpy v2012 rel2 (http://www.altova.com) av Jan Sigurd Dragsjø (helsedirektoratet.no) -->
	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="8"/>
	<!-- Visning av innhold i Pårørende/foresatt -->
	<xsl:template match="po:ParorendeForesatt">
		<tr>
			<th>
				<xsl:if test="po:Slektskap">
					<xsl:choose>
						<xsl:when test="po:Slektskap/@DN">
							<xsl:value-of select="po:Slektskap/@DN"/>&#160;
						</xsl:when>
						<xsl:when test="po:Slektskap/@V">
							<xsl:for-each select="po:Slektskap">
								<xsl:call-template name="k-9033"/>&#160;
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="po:Omsorgsfunksjon">og&#160;</xsl:if>
				</xsl:if>
				<xsl:if test="po:Omsorgsfunksjon">
					<xsl:choose>
						<xsl:when test="po:Omsorgsfunksjon/@DN">
							<xsl:value-of select="po:Omsorgsfunksjon/@DN"/>&#160;
						</xsl:when>
						<xsl:when test="po:Omsorgsfunksjon/@V">
							<xsl:for-each select="po:Omsorgsfunksjon">
								<xsl:call-template name="k-9050"/>&#160;
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="not(po:Slektskap) and not(po:Omsorgsfunksjon)">Pårørende/foresatt</xsl:if>
			</th>
			<td colspan="{(($std-col)-2)*number(not(po:Referanseperson//fk1:TeleAddress | po:FodselsarMindrearigParorende | po:Merknad))+1}">
				<xsl:for-each select="po:Referanseperson">
					<div><xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/></div>
				</xsl:for-each>
			</td>
			<xsl:if test="po:Referanseperson//fk1:TeleAddress">
				<td colspan="{(($std-col)-3)*number(not(po:FodselsarMindrearigParorende | po:Merknad))+1}">
					<xsl:for-each select="po:Referanseperson//fk1:TeleAddress"><xsl:call-template name="TeleAddress"/></xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="po:FodselsarMindrearigParorende">
				<th>Født</th>
				<td colspan="{(($std-col)-4-number(boolean(po:Referanseperson//fk1:TeleAddress)))*number(not(po:Merknad))+1}">
					<xsl:value-of select="po:FodselsarMindrearigParorende"/>
				</td>
			</xsl:if>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-3-number(boolean(po:Referanseperson//fk1:TeleAddress))-count(po:FodselsarMindrearigParorende)*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Tilknyttet Enhet -->
	<xsl:template match="po:TilknyttetEnhet">
		<tr>
			<td>
				<div class="No-line-content">
					<xsl:for-each select="po:Kontaktenhet">
						<xsl:call-template name="Organisation"/>
					</xsl:for-each>
				</div>
			</td>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-2-count(po:Kontaktenhet))}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Kontaktperson helsepersonell -->
	<xsl:template match="po:KontaktpersonHelsepersonell">
		<tr>
			<td colspan="{(($std-col)-1)*number(not(po:Merknad))+1}">
				<div class="No-line-content">
					<xsl:for-each select="po:Kontaktperson">
						<xsl:call-template name="HealthcareProfessional"/>
					</xsl:for-each>
				</div>
			</td>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{($std-col)-2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Tilleggsopplysninger pasient -->
	<xsl:template match="po:TilleggsopplysningPasient">
		<tr>
			<xsl:if test="po:SivilStatus">
				<th>SivilStatus</th>
				<td colspan="{(($std-col)-2)*number(not(po:BorAlene | po:Sprak))+1}">
					<xsl:choose>
						<xsl:when test="po:SivilStatus/@DN">
							<xsl:value-of select="po:SivilStatus/@DN"/>&#160;
						</xsl:when>
						<xsl:when test="po:SivilStatus/@V">
							<xsl:for-each select="po:SivilStatus">
								<xsl:call-template name="k-8724"/>&#160;
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="po:BorAlene">
				<th>Bor&#160;alene</th>
				<td colspan="{(($std-col)-2-count(po:SivilStatus)*2)*number(not(po:Sprak))+1}">
					<xsl:choose>
						<xsl:when test="po:BorAlene='true'">Ja</xsl:when>
						<xsl:otherwise>Nei</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="po:Sprak">
				<th>Språk</th>
				<td colspan="{(($std-col)-1-count(po:SivilStatus | po:BorAlene)*2)}">
					<xsl:choose>
						<xsl:when test="po:Sprak/@DN"><xsl:value-of select="po:Sprak/@DN"/></xsl:when>
						<xsl:otherwise><b>Kodet:</b>&#160;<xsl:value-of select="po:Sprak/@V"/></xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Sendt dokument -->
	<xsl:template match="po:SendtDokument">
		<tr>
			<th>
				<xsl:for-each select="po:Opplysning">
					<xsl:choose>
						<xsl:when test="contains(@S, '8329')">
							<xsl:call-template name="k-8329"/>&#160;
						</xsl:when>
						<xsl:when test="@DN">
							<xsl:value-of select="@DN"/>
						</xsl:when>
						<xsl:when test="@OT">
							<xsl:value-of select="@OT"/>
						</xsl:when>
						<xsl:otherwise>
							Ukjent&#160;dokumenttype
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</th>
			<td colspan="{(($std-col)-2)*number(not(po:TypeMottaker | po:NavnMottaker | po:Merknad))+1}">
				<xsl:choose>
					<xsl:when test="po:JaNei='true' and po:DatoSendt">
						<b>Sendt</b>&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="po:DatoSendt"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="po:JaNei='true' and not(po:DatoSendt)">
						<b>Sendt:</b>&#160;Ja
					</xsl:when>
					<xsl:when test="po:JaNei='false' and po:DatoSendt">
						<b>Sendes</b>&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="po:DatoSendt"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="po:JaNei='false' and not(po:DatoSendt)">
						<b>Sendt:</b>&#160;Nei
					</xsl:when>
				</xsl:choose>
			</td>
			<xsl:if test="po:TypeMottaker or po:NavnMottaker">
				<th>Mottaker</th>
				<td colspan="{(($std-col)-4)*number(not(po:Merknad))+1}">
					<xsl:for-each select="po:TypeMottaker">
						<xsl:choose>
							<xsl:when test="contains(@S, '8330')">
								<xsl:call-template name="k-8330"/>
							</xsl:when>
							<xsl:when test="@DN">
								<xsl:value-of select="@DN"/>
							</xsl:when>
							<xsl:when test="@OT">
								<xsl:value-of select="@OT"/>
							</xsl:when>
							<xsl:otherwise>
								Ukjent&#160;mottakertype
							</xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
					<xsl:value-of select="po:NavnMottaker"/>
				</td>
			</xsl:if>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-2-number(boolean(po:TypeMottaker | po:NavnMottaker))*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Informasjon om forsendelsen -->
	<xsl:template match="po:InformasjonOmForsendelsen">
		<tr>
			<th>Status</th>
			<td colspan="{(($std-col)-2)*number(not(po:ForbeholdOmVideresending | po:SvarPaaForesporsel | //po:InnholdKonsultasjon/po:Merknad | //po:TypeInnholdIMelding/po:Merknad))+1}">
				<xsl:for-each select="po:Forsendelsesstatus">
					<xsl:call-template name="k-7309"/>
				</xsl:for-each>
			</td>
			<xsl:if test="po:ForbeholdOmVideresending">
				<th>Forbehold&#160;gitt om&#160;videresending</th>
				<td colspan="{(($std-col)-4)*number(not(po:SvarPaaForesporsel | //po:InnholdKonsultasjon/po:Merknad | //po:TypeInnholdIMelding/po:Merknad))+1}">
					<xsl:choose>
						<xsl:when test="po:ForbeholdOmVideresending='true'">Ja</xsl:when>
						<xsl:otherwise>Nei</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="po:SvarPaaForesporsel">
				<th>Svar&#160;på&#160;forespørsel</th>
				<td colspan="{(($std-col)-4-count(po:ForbeholdOmVideresending)*2)*number(not(//po:InnholdKonsultasjon/po:Merknad | //po:TypeInnholdIMelding/po:Merknad))+1}">
					<xsl:choose>
						<xsl:when test="po:SvarPaaForesporsel='true'">Ja</xsl:when>
						<xsl:otherwise>Nei</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="//po:InnholdKonsultasjon/po:Merknad or //po:TypeInnholdIMelding/po:Merknad">
				<th>Merknad&#160;til&#160;innhold</th>
				<td colspan="{(($std-col)-3-count(po:ForbeholdOmVideresending | po:SvarPaaForesporsel)*2)}">
					<xsl:for-each select="//po:InnholdKonsultasjon/po:Merknad">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each select="//po:TypeInnholdIMelding/po:Merknad">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</td>
			</xsl:if>
		</tr>
		<xsl:apply-templates select="po:Foresporsel"/>
	</xsl:template>
	<!-- Visning av innhold i Ansvar for rapport -->
	<xsl:template match="po:AnsvarForRapport">
		<tr>
			<xsl:if test="po:TypeRelasjon">
				<th>
					<xsl:for-each select="po:TypeRelasjon">
						<xsl:choose>
							<xsl:when test="contains(@S, '8330')">
								<xsl:call-template name="k-8330"/>
							</xsl:when>
							<xsl:when test="@DN">
								<xsl:value-of select="@DN"/>
							</xsl:when>
							<xsl:when test="@OT">
								<xsl:value-of select="@OT"/>
							</xsl:when>
							<xsl:otherwise>
								Ukjent&#160;relasjonstype
							</xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
				</th>
			</xsl:if>
			<td colspan="{(($std-col)-1-count(po:TypeRelasjon))*number(not(po:GodkjentDato | po:Merknad))+1}">
				<div class="No-line-content">
					<xsl:for-each select="po:AnsvarligRapport">
						<xsl:call-template name="HealthcareProfessional"/>
					</xsl:for-each>
				</div>
			</td>
			<xsl:if test="po:GodkjentDato">
				<th>Godkjent</th>
				<td colspan="{(($std-col)-3-count(po:TypeRelasjon))*number(not(po:Merknad))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="po:GodkjentDato"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-2-count(po:TypeRelasjon)-number(boolean(po:GodkjentDato))*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Forespørsel -->
	<xsl:template match="po:Foresporsel">
		<tr>
			<th colspan="{(($std-col)-1)*number(not(po:Sporsmal | po:Formål | po:Begrunnelse | po:TypeJournalinfo | po:Hastegrad | po:FraDato | po:TilDato))+1}">
				Opprinnelig&#160;forespørsel:&#160;
				<xsl:for-each select="po:TypeForesp">
					<xsl:choose>
						<xsl:when test="contains(@S, '9152') or contains(@S, '9153') or contains(@S, '9154')">
							<xsl:call-template name="k-9152-4"/>
						</xsl:when>
						<xsl:when test="@DN">
							<xsl:value-of select="@DN"/>
						</xsl:when>
						<xsl:when test="@OT">
							<xsl:value-of select="@OT"/>
						</xsl:when>
						<xsl:otherwise>
							Kodet:&#160;<xsl:value-of select="@V"/>
						</xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</th>
			<xsl:if test="po:Sporsmal">
				<td colspan="{(($std-col)-2)*number(not(po:Formål | po:Begrunnelse | po:TypeJournalinfo | po:Hastegrad | po:FraDato | po:TilDato))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Sporsmal"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="po:Formål or po:Begrunnelse or po:TypeJournalinfo">
				<th>Formål</th>
				<td colspan="{(($std-col)-2-count(po:Sporsmal))*number(not(po:Hastegrad | po:FraDato | po:TilDato))+1}">
					<xsl:for-each select="po:Formål">
						<xsl:choose>
							<xsl:when test="contains(@S, '9065')">
								<xsl:call-template name="k-9065"/>
							</xsl:when>
							<xsl:when test="@DN">
								<xsl:value-of select="@DN"/>
							</xsl:when>
							<xsl:when test="@OT">
								<xsl:value-of select="@OT"/>
							</xsl:when>
							<xsl:otherwise>
								Ukjent&#160;forespørselstype
							</xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
					<xsl:if test="po:Begrunnelse">
						<div>
							<b>Begrunnelse:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="po:Begrunnelse"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="po:TypeJournalinfo">
						<div>
							<b>Kategori:</b>&#160;
							<xsl:for-each select="po:TypeJournalinfo">
								<xsl:choose>
									<xsl:when test="@DN">
										<xsl:value-of select="@DN"/>
									</xsl:when>
									<xsl:when test="@OT">
										<xsl:value-of select="@OT"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@V"/>
									</xsl:otherwise>
								</xsl:choose>&#160;
							</xsl:for-each>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="po:Hastegrad">
				<th>Hastegrad</th>
				<td colspan="{(($std-col)-2-count(po:Sporsmal)-number(boolean(po:Formål | po:Begrunnelse | po:TypeJournalinfo))*2)*number(not(po:FraDato | po:TilDato))+1}">
					<xsl:choose>
						<xsl:when test="po:Hastegrad/@DN">
							<xsl:value-of select="po:Hastegrad/@DN"/>&#160;
						</xsl:when>
						<xsl:when test="po:Hastegrad/@V">
							<xsl:for-each select="po:Hastegrad">
								<xsl:call-template name="k-9067"/>&#160;
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="po:FraDato">
				<th>Tidsrom</th>
				<td colspan="{(($std-col)-1-count(po:Sporsmal)-number(boolean(po:Formål | po:Begrunnelse | po:TypeJournalinfo))*2-count(po:Hastegrad)*2)}">
					Fra&#160;
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="po:FraDato"/>
					</xsl:call-template>
					&#160;til&#160;
					<xsl:choose>
						<xsl:when test="po:TilDato">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="po:FraDato"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>d.d.</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Opplysninger til søknad -->
	<xsl:template match="po:OpplysningerTilSoknad">
		<tr>
			<th>Pasientens egensøknad sendt</th>
			<td>
				<xsl:choose>
					<xsl:when test="po:EgensoknadSendt='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{($std-col)-3}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Info om informasjon som er gitt -->
	<xsl:template match="po:InfoInformasjonGitt">
		<xsl:apply-templates select="po:InformasjonGitt"/>
	</xsl:template>
	<!-- Visning av innhold i Info om behov for assistert kommunikasjon mv -->
	<xsl:template match="po:InfoAssistertKommunikasjon">
		<xsl:apply-templates select="po:AssistertKommunikasjon"/>
	</xsl:template>
	<!-- Visning av innhold i Info om IPLOS-relevant informasjon -->
	<xsl:template match="po:InfoIPLOSrelevantInformasjon">
		<xsl:apply-templates select="po:TidsperiodeDiagnose"/>
		<xsl:apply-templates select="po:TidsfestetHendelse"/>
	</xsl:template>
	<!-- Visning av innhold i Info om kartlegging av funksjonsnivå -->
	<xsl:template match="po:InfoKartleggingFunksjonsniva">
		<xsl:apply-templates select="po:SamletVurderingFunksjonsniva"/>
		<xsl:apply-templates select="po:Ansvarlig"/>
		<xsl:if test="po:KartlagtFunksjon">
			<tr>
				<th>Kartlagt&#160;funksjon med&#160;vurdering</th>
				<td colspan="{($std-col)-1}">
					<xsl:apply-templates select="po:KartlagtFunksjon"/>
				</td>
			</tr>
			<tr>
				<td colspan="{($std-col)}">
					1 = ingen problem, 2 = ikke behov for bistand/assistanse, 3 = middels behov for bistand/assistanse, 4 = store behov for bistand/assistanse, 5 = fullt bistandsbehov, 9 = ikke relevant
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- Visning av innhold i Eksisterende tjeneste -->
	<xsl:template match="po:EksisterendeTjeneste">
		<tr>
			<th colspan="{(($std-col)-1)*number(not(po:PrivatTjeneste | po:TjenestenLevertAv | po:OpplysningerOmTjenesten | po:AntallEnheter | po:Startdato | po:Merknad))+1}">
				<xsl:for-each select="po:IPLOStjenestetype">
					<xsl:choose>
						<xsl:when test="contains(@S, '9151')">
							<xsl:call-template name="k-9151"/>
						</xsl:when>
						<xsl:when test="@DN">
							<xsl:value-of select="@DN"/>
						</xsl:when>
						<xsl:when test="@OT">
							<xsl:value-of select="@OT"/>
						</xsl:when>
						<xsl:otherwise>
							Ukjent&#160;tjenestetype
						</xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
				<xsl:if test="not(po:IPLOStjenestetype) and po:BetegnelseTjeneste">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:BetegnelseTjeneste"/>
					</xsl:call-template>
				</xsl:if>
			</th>
			<xsl:if test="po:PrivatTjeneste or po:TjenestenLevertAv or po:OpplysningerOmTjenesten">
				<td colspan="{(($std-col)-2)*number(not(po:AntallEnheter | po:Startdato | po:Merknad))+1}">
					<xsl:if test="po:OpplysningerOmTjenesten">
						<div>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="po:OpplysningerOmTjenesten"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="po:TjenestenLevertAv">
						<div>
							<b>Levert&#160;av:&#160;</b>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="po:TjenestenLevertAv"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="po:PrivatTjeneste">
						<div>
							<xsl:if test="po:PrivatTjeneste='true'">Privat&#160;tjeneste</xsl:if>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="po:AntallEnheter">
				<th>Antall</th>
				<td colspan="{(($std-col)-3-number(boolean(po:PrivatTjeneste | po:TjenestenLevertAv | po:OpplysningerOmTjenesten)))*number(not(po:Startdato | po:Merknad))+1}">
					<xsl:value-of select="po:AntallEnheter"/>&#160;<xsl:value-of select="po:Enhet"/>
				</td>
			</xsl:if>
			<xsl:if test="po:Startdato">
				<th>Tidsrom</th>
				<td colspan="{(($std-col)-3-number(boolean(po:PrivatTjeneste | po:TjenestenLevertAv | po:OpplysningerOmTjenesten))-count(po:AntallEnheter)*2)*number(not(po:Merknad))+1}">
					Fra&#160;
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="po:Startdato"/>
					</xsl:call-template>
					&#160;til&#160;
					<xsl:choose>
						<xsl:when test="po:Sluttdato">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="po:Sluttdato"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>d.d.</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-2-number(boolean(po:PrivatTjeneste | po:TjenestenLevertAv | po:OpplysningerOmTjenesten))-count(po:AntallEnheter | po:Startdato)*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Tidsfestet hendelse -->
	<xsl:template match="po:TidsfestetHendelse">
		<tr>
			<xsl:if test="po:Hendelsekode">
				<th colspan="{(($std-col)-1)*number(not(po:TidspunktForHendelse | po:StedForHendelse | po:BeskrivelseAvHendelse | po:Merknad))+1}">
					<xsl:for-each select="po:Hendelsekode">
						<xsl:choose>
							<xsl:when test="contains(@S, '9121') and @V='13'">
								<div class="viktig">
									<xsl:call-template name="k-9121"/>
								</div>
							</xsl:when>
							<xsl:when test="contains(@S, '9121')">
								<xsl:call-template name="k-9121"/>
							</xsl:when>
							<xsl:when test="@DN">
								<xsl:value-of select="@DN"/>
							</xsl:when>
							<xsl:when test="@OT">
								<xsl:value-of select="@OT"/>
							</xsl:when>
							<xsl:otherwise>
								Ukjent&#160;hendelsestype
							</xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
				</th>
			</xsl:if>
			<xsl:if test="po:TidspunktForHendelse">
				<th>Tidspunkt</th>
				<td colspan="{(($std-col)-2-count(po:Hendelsekode))*number(not(po:StedForHendelse | po:BeskrivelseAvHendelse | po:Merknad))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="po:TidspunktForHendelse/@V"/>
					</xsl:call-template>&#160;
					<xsl:if test="po:Anslag='true'">(anslagsvis)</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="po:StedForHendelse">
				<th>Sted</th>
				<td colspan="{(($std-col)-2-count(po:Hendelsekode)-count(po:TidspunktForHendelse)*2)*number(not(po:BeskrivelseAvHendelse | po:Merknad))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:StedForHendelse/po:StedHendelse"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="po:BeskrivelseAvHendelse">
				<td colspan="{(($std-col)-1-count(po:Hendelsekode)-count(po:TidspunktForHendelse | po:StedForHendelse)*2)*number(not(po:Merknad))+1}">
					<b>Beskrivelse:</b>&#160;
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:BeskrivelseAvHendelse"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-1-count(po:Hendelsekode)-count(po:BeskrivelseAvHendelse)-count(po:TidspunktForHendelse | po:StedForHendelse)*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Utskrevet til -->
	<xsl:template match="po:UtskrevetTil">
		<tr>
			<th>Ut&#160;til</th>
			<td colspan="{(($std-col)-2)*number(not(po:Uttilstand | po:Merknad))+1}">
				<xsl:for-each select="po:UtTil">
					<xsl:choose>
						<xsl:when test="contains(@S, '8408')">
							<xsl:call-template name="k-8408"/>
						</xsl:when>
						<xsl:when test="@DN">
							<xsl:value-of select="@DN"/>
						</xsl:when>
						<xsl:when test="@OT">
							<xsl:value-of select="@OT"/>
						</xsl:when>
						<xsl:otherwise>
							Ukjent
						</xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</td>
			<xsl:if test="po:Uttilstand">
				<th>Uttilstand</th>
				<td colspan="{(($std-col)-4)*number(not(po:Merknad))+1}">
				<xsl:for-each select="po:Uttilstand">
					<xsl:choose>
						<xsl:when test="contains(@S, '8431') and @V='2'">
							<div class="viktig">
								<xsl:call-template name="k-8431"/>
							</div>
						</xsl:when>
						<xsl:when test="contains(@S, '8431')">
							<xsl:call-template name="k-8431"/>
						</xsl:when>
						<xsl:when test="@DN">
							<xsl:value-of select="@DN"/>
						</xsl:when>
						<xsl:when test="@OT">
							<xsl:value-of select="@OT"/>
						</xsl:when>
						<xsl:otherwise>
							Ukjent
						</xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-3-count(po:Uttilstand)*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Avtale om adm. av legemidler -->
	<xsl:template match="po:AvtaleOmAdmLegemidler">
		<tr>
			<th>Avtale&#160;om&#160;adm.&#160;av&#160;legemidler</th>
			<td>
				<xsl:choose>
					<xsl:when test="po:AvtaleAdmLegemidler='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
			<td colspan="{(($std-col)-3)*number(not(po:AdmInstrukser | po:Merknad))+1}">
				<b>Avtale&#160;om adm.&#160;av&#160;multidose:</b>&#160;
				<xsl:choose>
					<xsl:when test="po:AvtaleAdmMultidose='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="po:AdmInstrukser">
				<th>Adm.&#160;instrukser</th>
				<td colspan="{(($std-col)-5)*number(not(po:Merknad))+1}">
					<div>
						<xsl:choose>
							<xsl:when test="po:AdmInstrukser/po:Utleveringsform/@DN">
								<xsl:value-of select="po:AdmInstrukser/po:Utleveringsform/@DN"/>&#160;
							</xsl:when>
							<xsl:when test="po:AdmInstrukser/po:Utleveringsform/@V">
								<xsl:for-each select="po:AdmInstrukser/po:Utleveringsform">
									<xsl:call-template name="k-9135"/>&#160;
								</xsl:for-each>
							</xsl:when>
						</xsl:choose>
					</div>
					<div>
						<xsl:choose>
							<xsl:when test="po:AdmInstrukser/po:SarskilteTiltak/@DN">
								<xsl:value-of select="po:AdmInstrukser/po:SarskilteTiltak/@DN"/>&#160;
							</xsl:when>
							<xsl:when test="po:AdmInstrukser/po:SarskilteTiltak/@V">
								<xsl:for-each select="po:AdmInstrukser/po:SarskilteTiltak">
									<xsl:call-template name="k-9136"/>&#160;
								</xsl:for-each>
							</xsl:when>
						</xsl:choose>
					</div>
				</td>
			</xsl:if>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-4-count(po:AdmInstrukser)*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
		<xsl:apply-templates select="po:Tiltaksbeskrivelse"/>
	</xsl:template>
	<!-- Visning av innhold i Medisinskfaglige opplysninger -->
	<xsl:template match="po:MedisinskfagligeOpplysninger">
		<xsl:apply-templates select="epj1:Cave"/>
		<xsl:apply-templates select="epj1:Allerginotat"/>
		<xsl:apply-templates select="po:InfoTidligereSykdommer"/>
		<xsl:apply-templates select="epj2:GenereltJournalnotat"/>
		<xsl:apply-templates select="po:RegistrertBlodtype"/>
	</xsl:template>
	<!-- Visning av innhold i Sykepleierdokumentasjon -->
	<xsl:template match="po:Sykepleierdokumentasjon">
		<xsl:apply-templates select="po:InfoFraSykepleier"/>
		<xsl:apply-templates select="po:InfoAvtaleOmLegemiddeladm"/>
		<xsl:apply-templates select="po:InfoVurderinger"/>
		<xsl:apply-templates select="po:IverksatteTiltak"/>
		<xsl:apply-templates select="po:AnbefaltVidereTiltak"/>
		<xsl:apply-templates select="po:InfoMaalForventetRes"/>
		<xsl:apply-templates select="po:Ansvarlig"/>
	</xsl:template>
	<!-- Visning av innhold i Info om medisinsk diagnose -->
	<xsl:template match="po:InfoMedisinskDiagnose">
		<xsl:apply-templates select="po:MedisinskDiagnose"/>
	</xsl:template>
	<!-- Visning av innhold i Info om kontaktepisode -->
	<xsl:template match="po:InfoKontaktepisode">
		<tr>
			<xsl:for-each select="po:FellesinfoKontaktepisode">
				<th>
					<xsl:for-each select="po:Kontakttype">
						<xsl:choose>
							<xsl:when test="contains(@S, '8432')">
								<xsl:call-template name="k-8432"/>
							</xsl:when>
							<xsl:when test="@DN">
								<xsl:value-of select="@DN"/>
							</xsl:when>
							<xsl:when test="@OT">
								<xsl:value-of select="@OT"/>
							</xsl:when>
							<xsl:otherwise>
								Kodet:&#160;<xsl:value-of select="@V"/>
							</xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
				</th>
				<xsl:if test="po:Konsultasjonsform">
					<td>
						<b>Konsultasjonsform:</b>&#160;
						<xsl:for-each select="po:Konsultasjonsform">
							<xsl:choose>
								<xsl:when test="@DN">
									<xsl:value-of select="@DN"/>
								</xsl:when>
								<xsl:when test="@OT">
									<xsl:value-of select="@OT"/>
								</xsl:when>
								<xsl:otherwise>
									Kodet:&#160;<xsl:value-of select="@V"/>
								</xsl:otherwise>
							</xsl:choose>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<th>Startet</th>
				<td colspan="{(($std-col)-3-count(po:Konsultasjonsform))*number(not(po:Merknad | ../po:TilleggsinfoKontaktepisode))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="po:KontaktStartet/@V"/>
					</xsl:call-template>&#160;
					<xsl:if test="po:KontaktAvsluttet">
						Avsluttet:&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="po:KontaktAvsluttet/@V"/>
						</xsl:call-template>&#160;
					</xsl:if>
				</td>
				<xsl:if test="po:Merknad">
					<th>Merknad</th>
					<td colspan="{(($std-col)-5-count(po:Konsultasjonsform))*number(not(po:Merknad | ../po:TilleggsinfoKontaktepisode))+1}">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="po:Merknad"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="po:TilleggsinfoKontaktepisode">
				<th>Sted</th>
				<td colspan="{(($std-col)-4-count(../po:FellesinfoKontaktepisode/po:Konsultasjonsform)-count(../po:FellesinfoKontaktepisode/po:Merknad)*2)}">
					<xsl:if test="po:StedForKontaktepisode">
						<div>
							<xsl:for-each select="po:StedForKontaktepisode">
								<xsl:choose>
									<xsl:when test="contains(@S, '8434')">
										<xsl:call-template name="k-8434"/>
									</xsl:when>
									<xsl:when test="@DN">
										<xsl:value-of select="@DN"/>
									</xsl:when>
									<xsl:when test="@OT">
										<xsl:value-of select="@OT"/>
									</xsl:when>
									<xsl:otherwise>
										Kodet:&#160;<xsl:value-of select="@V"/>
									</xsl:otherwise>
								</xsl:choose>&#160;
							</xsl:for-each>
						</div>
					</xsl:if>
					<xsl:if test="po:StedForKontakt">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="po:StedForKontakt"/>
						</xsl:call-template>
					</xsl:if>
				</td>
			</xsl:for-each>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Info om kontaktepisode -->
	<xsl:template match="po:InfoReservasjon">
		<xsl:apply-templates select="po:ReservasjonOnske"/>
	</xsl:template>
	<!-- Visning av innhold i Info om andre viktige opplysninger -->
	<xsl:template match="po:InfoAndreViktigeOpplysninger">
		<xsl:apply-templates select="epj2:GenereltJournalnotat"/>
		<xsl:apply-templates select="epj1:Allerginotat"/>
	</xsl:template>
	<!-- Visning av innhold i Opplysninger fra andre faggrupper -->
	<xsl:template match="po:OpplysningerAndreFaggrupper">
		<xsl:apply-templates select="po:AndreFagrapporter"/>
		<xsl:apply-templates select="po:AnbefaltVidereTiltak"/>
		<xsl:apply-templates select="po:InfoVurderinger"/>
	</xsl:template>
	<!-- Visning av innhold i Opplysninger om opphold -->
	<xsl:template match="po:OpplysningOpphold">
		<xsl:apply-templates select="po:TidsfestetHendelse"/>
	</xsl:template>
	<!-- Visning av innhold i Info om kontrolltime -->
	<xsl:template match="po:InfoKontrolltime">
		<xsl:apply-templates select="po:InformasjonOmTime"/>
		<xsl:apply-templates select="po:KontrolltimeBestill"/>
		<xsl:apply-templates select="po:InformasjonOmTentativTime"/>
	</xsl:template>
	<!-- Visning av innhold i Opplysninger om hjelpemidler -->
	<xsl:template match="po:OpplysningerOmHjelpemidler">
		<xsl:apply-templates select="po:FasteHjelpemidler"/>
		<xsl:apply-templates select="po:StatusHjelpemiddel"/>
	</xsl:template>
	<!-- Visning av innhold i Behov for tjeneste -->
	<xsl:template match="po:TjenesteBehov">
		<tr>
			<th colspan="{(($std-col)-1)*number(not(po:VedInstitusjon | po:BeskrivelseAvTjeneste | po:AntallEnheterOnsket))+1}">
				<xsl:for-each select="po:IPLOStjenestetype">
					<xsl:choose>
						<xsl:when test="contains(@S, '9151')">
							<xsl:call-template name="k-9151"/>
						</xsl:when>
						<xsl:when test="@DN">
							<xsl:value-of select="@DN"/>
						</xsl:when>
						<xsl:when test="@OT">
							<xsl:value-of select="@OT"/>
						</xsl:when>
						<xsl:otherwise>
							Ukjent&#160;tjenestetype
						</xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
				<xsl:if test="not(po:IPLOStjenestetype) and po:BetegnelseTjeneste">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:BetegnelseTjeneste"/>
					</xsl:call-template>
				</xsl:if>
			</th>
			<xsl:if test="po:VedInstitusjon">
				<th>Ønsket&#160;institusjon</th>
				<td colspan="{(($std-col)-3)*number(not(po:BeskrivelseAvTjeneste | po:AntallEnheterOnsket))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:VedInstitusjon"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="po:BeskrivelseAvTjeneste">
				<th>Beskrivelse</th>
				<td colspan="{(($std-col)-3-count(po:VedInstitusjon)*2)*number(not(po:AntallEnheterOnsket))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:BeskrivelseAvTjeneste"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="po:AntallEnheterOnsket">
				<th>Ønsket&#160;antall</th>
				<td colspan="{(($std-col)-2-count(po:VedInstitusjon | po:BeskrivelseAvTjeneste)*2)}">
					<xsl:value-of select="po:AntallEnheterOnsket"/>&#160;<xsl:value-of select="po:Enhet"/>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Assistert kommunikasjon -->
	<xsl:template match="po:AssistertKommunikasjon">
		<tr>
			<xsl:if test="po:PersonTolkebehov">
				<th>Gjelder&#160;for</th>
				<td colspan="{(($std-col)-2)*number(not(po:BehovTolkSprak | po:PreferertTolk | po:Horselsvikt | po:Synsvikt | po:BehovOpphortDato | po:Merknad))+1}">
					<div class="No-line-content">
						<xsl:for-each select="po:PersonTolkebehov">
							<xsl:call-template name="Person"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<xsl:if test="po:BehovTolkSprak">
				<th>Språk</th>
				<td colspan="{(($std-col)-2-count(po:PersonTolkebehov)*2)*number(not(po:PreferertTolk | po:Horselsvikt | po:Synsvikt | po:BehovOpphortDato | po:Merknad))+1}">
					<xsl:choose>
						<xsl:when test="po:BehovTolkSprak/@DN"><xsl:value-of select="po:BehovTolkSprak/@DN"/></xsl:when>
						<xsl:otherwise><b>Kodet:</b>&#160;<xsl:value-of select="po:BehovTolkSprak/@V"/></xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="po:PreferertTolk">
				<th>Ønsket&#160;tolk</th>
				<td colspan="{(($std-col)-2-count(po:PersonTolkebehov | po:BehovTolkSprak)*2)*number(not(po:Horselsvikt | po:Synsvikt | po:BehovOpphortDato | po:Merknad))+1}">
					<div class="No-line-content">
						<xsl:for-each select="po:PreferertTolk">
							<xsl:call-template name="Person"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<xsl:if test="po:Horselsvikt or po:Synsvikt or po:BehovOpphortDato or po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-1-count(po:PersonTolkebehov | po:BehovTolkSprak| po:PreferertTolk)*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
					<xsl:if test="po:Horselsvikt='true' or po:Synsvikt='true' or po:BehovOpphortDato">
						<div>
							<xsl:if test="po:Horselsvikt='true'">
								<b>Hørselsvikt:</b>&#160;Ja&#160;
							</xsl:if>
							<xsl:if test="po:Synsvikt='true'">
								<b>Synsvikt:</b>&#160;Ja&#160;
							</xsl:if>
						</div>
						<div>
							<xsl:if test="po:BehovOpphortDato/@V">
								<b>Behov&#160;opphørte:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="po:BehovOpphortDato/@V"/>
								</xsl:call-template>&#160;
							</xsl:if>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Registrert blodtype -->
	<xsl:template match="po:RegistrertBlodtype">
		<tr>
			<th>Registrert&#160;blodtype</th>
			<td colspan="{(($std-col)-2)*number(not(po:Merknad))+1}">
				<xsl:for-each select="po:Blodtype"><xsl:value-of select="@V"/></xsl:for-each>
				<xsl:for-each select="po:Rhesusgruppe">,&#160;<xsl:value-of select="@V"/></xsl:for-each>
			</td>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{($std-col)-3}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Andre fagrapporter -->
	<xsl:template match="po:AndreFagrapporter">
		<xsl:variable name="kol" select="number(boolean(po:BehandlingStart | po:StatusInnleggelse | po:StatusBehandlingsstart | po:ForventetStatusUtskriving))+count(po:AnsvarligRapport)*2+1"/>
		<xsl:variable name="rad" select="count(.//epj2:Journaltekst)"/>
		<tr>
			<th rowspan="{($rad)}">Fagrapport</th>
			<xsl:if test="po:BehandlingStart or po:StatusInnleggelse or po:StatusBehandlingsstart or po:ForventetStatusUtskriving">
				<td rowspan="{($rad)}" colspan="{(($std-col)-2)*number(not(po:AnsvarligRapport | epj2:Journaltekst))+1}">
					<xsl:if test="po:BehandlingStart">
						<div>
							<b>Behandlingstart:</b>&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="po:BehandlingStart"/>
							</xsl:call-template>&#160;
						</div>
					</xsl:if>
					<xsl:if test="po:StatusInnleggelse">
						<div>
							<b>Status&#160;innleggelse:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="po:StatusInnleggelse"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="po:StatusBehandlingsstart">
						<div>
							<b>Status&#160;behandlingsstart:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="po:StatusBehandlingsstart"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="po:ForventetStatusUtskriving">
						<div>
							<b>Forventet&#160;status&#160;utskriving:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="po:ForventetStatusUtskriving"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="po:AnsvarligRapport">
				<th rowspan="{($rad)}">Ansvarlig</th>
				<td rowspan="{($rad)}" colspan="{(($std-col)-3-number(boolean(po:BehandlingStart | po:StatusInnleggelse | po:StatusBehandlingsstart | po:ForventetStatusUtskriving)))*number(not(epj2:Journaltekst))+1}">
					<div class="No-line-content">
						<xsl:for-each select="po:AnsvarligRapport">
							<xsl:call-template name="HealthcareProfessional"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<xsl:for-each select="epj2:Journaltekst">
				<xsl:if test="position()=1">
					<xsl:apply-templates select="." mode="utenRad"><xsl:with-param name="antKolonner" select="$kol"/></xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select="epj2:Journaltekst">
			<xsl:if test="position()!=1">
				<xsl:apply-templates select="." mode="utenRad"><xsl:with-param name="antKolonner" select="$kol"/></xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om tidligere sykdommer -->
	<xsl:template match="po:InfoTidligereSykdommer">
		<xsl:variable name="rad" select="1+count(epj2:Journaltekst)"/>
		<tr>
			<th rowspan="{$rad}">
				Tidligere&#160;sykdom<xsl:choose>
					<xsl:when test="po:TidligereSykdomFragment/po:Diagnosekode/@DN">:<br/><xsl:value-of select="po:TidligereSykdomFragment/po:Diagnosekode/@DN"/></xsl:when>
					<xsl:when test="po:TidligereSykdomFragment/po:Diagnosekode/@OT">:<br/><xsl:value-of select="po:TidligereSykdomFragment/po:Diagnosekode/@OT"/></xsl:when>
				</xsl:choose>
			</th>
			<xsl:for-each select="po:TidligereSykdomFragment">
				<xsl:if test="po:Diagnosekode">
					<td colspan="{(($std-col)-2)*number(not(po:FunksjonshemmingKroniskSykdom | po:TidligereSykdom))+1}">
						<b>Kodet:</b>&#160;
						<xsl:value-of select="po:Diagnosekode/@V"/>&#160;
						<xsl:if test="contains(po:Diagnosekode/@S, '7170')">(ICPC)</xsl:if>
						<xsl:if test="contains(po:Diagnosekode/@S, '7110')">(ICD-10)</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="po:FunksjonshemmingKroniskSykdom">
					<td colspan="{(($std-col)-2-count(po:Diagnosekode))*number(not(po:TidligereSykdom))+1}">
						<xsl:if test="po:FunksjonshemmingKroniskSykdom='true'">Gjelder funksjonshemming/kronisk sykdom</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="po:TidligereSykdom">
					<th>Stikkord/beskrivelse</th>
					<td colspan="{(($std-col)-2-count(po:Diagnosekode | po:FunksjonshemmingKroniskSykdom))}">
						<xsl:for-each select="po:TidligereSykdom">
							<xsl:if test="position()!=1">,&#160;</xsl:if>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</td>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select="epj2:Journaltekst">
			<tr>
				<xsl:apply-templates select="." mode="utenRad"><xsl:with-param name="antKolonner" select="1"/></xsl:apply-templates>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info fra sykepleier -->
	<xsl:template match="po:InfoFraSykepleier">
		<tr>
			<xsl:for-each select="po:OpplysningerRelevantOppfolging">
				<xsl:if test="po:EndringFunksjonsnivaa">
					<th>Endring&#160;i funksjonsnivå</th>
					<td colspan="{(($std-col)-3)*number(not(po:BandasjemateriellEngangsutstyr | po:HjelpLegemiddeladm | po:MerknadTilBandasjemateriell | po:MerknadTilLegemiddeladministrering))+1}">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="po:EndringFunksjonsnivaa"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="po:BandasjemateriellEngangsutstyr">
					<td colspan="{(($std-col)-2-count(po:EndringFunksjonsnivaa)*2)*number(not(po:MerknadTilBandasjemateriell | po:HjelpLegemiddeladm | po:MerknadTilLegemiddeladministrering))+1}">
						Bandasjemateriell og engangsutstyr er <xsl:if test="po:BandasjemateriellEngangsutstyr='false'">ikke </xsl:if>sendt med pasienten
					</td>
				</xsl:if>
				<xsl:if test="po:MerknadTilBandasjemateriell">
					<td colspan="{(($std-col)-2-count(po:EndringFunksjonsnivaa)*2-count(po:BandasjemateriellEngangsutstyr))*number(not(po:HjelpLegemiddeladm | po:MerknadTilLegemiddeladministrering))+1}">
						<b>Merknad:</b>&#160;
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="po:MerknadTilBandasjemateriell"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="po:HjelpLegemiddeladm">
					<td colspan="{(($std-col)-2-count(po:EndringFunksjonsnivaa)*2-count(po:BandasjemateriellEngangsutstyr | po:MerknadTilBandasjemateriell))*number(not(po:MerknadTilLegemiddeladministrering))+1}">
						Pasienten trenger <xsl:if test="po:HjelpLegemiddeladm='false'">ikke </xsl:if>hjelp til legemiddeladministrering
					</td>
				</xsl:if>
				<xsl:if test="po:MerknadTilLegemiddeladministrering">
					<td colspan="{(($std-col)-1-count(po:EndringFunksjonsnivaa)*2-count(po:BandasjemateriellEngangsutstyr | po:MerknadTilBandasjemateriell | po:HjelpLegemiddeladm))}">
						<b>Merknad:</b>&#160;
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="po:MerknadTilLegemiddeladministrering"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select=".//epj2:Journaltekst">
			<tr>
				<xsl:apply-templates select="." mode="utenRad"><xsl:with-param name="antKolonner" select="0"/></xsl:apply-templates>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Informasjon om bestilt time -->
	<xsl:template match="po:InformasjonOmTime">
		<tr>
			<th>Informasjon&#160;om bestilt&#160;time</th>
			<td colspan="{(($std-col)-2)*number(not(po:StedTime | po:TidspunktTime | po:Varighet | po:InformertOm))+1}">
				Bestilt:&#160;
				<xsl:choose>
					<xsl:when test="po:BestiltKontrolltime='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="po:StedTime">
				<th>Sted</th>
				<td colspan="{(($std-col)-4)*number(not(po:TidspunktTime | po:Varighet | po:InformertOm))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:StedTime"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="po:TidspunktTime or po:Varighet">
				<th>
					<xsl:if test="po:TidspunktTime">Tidspunkt</xsl:if>
					<xsl:if test="po:TidspunktTime and po:Varighet">&#160;og&#160;varighet</xsl:if>
					<xsl:if test="not(po:TidspunktTime) and po:Varighet">Varighet</xsl:if>
				</th>
				<td colspan="{(($std-col)-4-count(po:StedTime)*2)*number(not(po:InformertOm))+1}">
					<xsl:if test="po:TidspunktTime">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="po:TidspunktTime"/>
						</xsl:call-template>&#160;
					</xsl:if>
					<xsl:if test="po:Varighet">
						<xsl:value-of select="po:Varighet"/>minutter&#160;
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="po:InformertOm">
				<th>Informert</th>
				<td colspan="{(($std-col)-3-count(po:StedTime)*2-number(boolean(po:TidspunktTime | po:Varighet))*2)}">
					<div>Pasient:&#160;
						<xsl:choose>
							<xsl:when test="po:InformertOm/po:PasientInformert='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
					<div>Pårørende:&#160;
						<xsl:choose>
							<xsl:when test="po:InformertOm/po:ParorendeInformert='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Kontrolltime skal bestilles -->
	<xsl:template match="po:KontrolltimeBestill">
		<tr>
			<th>Kontrolltime skal&#160;bestilles</th>
			<td colspan="{(($std-col)-2)*number(not(po:InformertOm))+1}">
				Bestilles&#160;av&#160;pasient/pårørende:&#160;
				<xsl:choose>
					<xsl:when test="po:PasientParorendeBestiller='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="po:InformertOm">
				<th>Informert</th>
				<td colspan="{(($std-col)-3)}">
					<div>Pasient:&#160;
						<xsl:choose>
							<xsl:when test="po:InformertOm/po:PasientInformert='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
					<div>Pårørende:&#160;
						<xsl:choose>
							<xsl:when test="po:InformertOm/po:ParorendeInformert='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Informasjon om tentativ kontrolltime -->
	<xsl:template match="po:InformasjonOmTentativTime">
		<tr>
			<th>Informasjon&#160;om tentativ&#160;kontrolltime</th>
			<xsl:if test="po.TentativtTidspunktTime">
				<td colspan="{(($std-col)-2)*number(not(po:StedTime | po:Merknad | po:InformertOm))+1}">
					Tentativt&#160;tidspunkt:&#160;
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:TentativtTidspunktTime"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="po:StedTime">
				<th>Sted</th>
				<td colspan="{(($std-col)-3-count(po:TentativtTidspunktTime))*number(not(po:Merknad | po:InformertOm))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:StedTime"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-3-count(po:TentativtTidspunktTime)-count(po:StedTime)*2)*number(not(po:InformertOm))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="po:InformertOm">
				<th>Informert</th>
				<td colspan="{(($std-col)-2-count(po:TentativtTidspunktTime)-count(po:StedTime | po:Merknad)*2)}">
					<div>Pasient:&#160;
						<xsl:choose>
							<xsl:when test="po:InformertOm/po:PasientInformert='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
					<div>Pårørende:&#160;
						<xsl:choose>
							<xsl:when test="po:InformertOm/po:ParorendeInformert='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Kartlagt funksjon -->
	<xsl:template match="po:KartlagtFunksjon">
		<div>
			<xsl:if test="po:Vurdering"><xsl:value-of select="po:Vurdering"/>&#160;-&#160;</xsl:if>
			<xsl:if test="po:Funksjonsvariabel">
				<xsl:for-each select="po:Funksjonsvariabel">
					<xsl:choose>
						<xsl:when test="contains(@S, '9111')">
							<xsl:call-template name="k-9111"/>
						</xsl:when>
						<xsl:when test="@DN">
							<xsl:value-of select="@DN"/>
						</xsl:when>
						<xsl:when test="@OT">
							<xsl:value-of select="@OT"/>
						</xsl:when>
						<xsl:otherwise>
							Kodet:&#160;<xsl:value-of select="@V"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>&#160;
			</xsl:if>
			<xsl:if test="po:Merknad">
				<b>Merknad</b>
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="po:Merknad"/>
				</xsl:call-template>
			</xsl:if>
		</div>
	</xsl:template>
	<!-- Visning av innhold i Informasjon gitt -->
	<xsl:template match="po:InformasjonGitt">
		<tr>
			<xsl:if test="po:TypeInformasjon">
				<th>
					<xsl:for-each select="po:TypeInformasjon">
						<xsl:choose>
							<xsl:when test="contains(@S, '9502')">
								<xsl:call-template name="k-9502"/>
							</xsl:when>
							<xsl:when test="@DN">
								<xsl:value-of select="@DN"/>
							</xsl:when>
							<xsl:when test="@OT">
								<xsl:value-of select="@OT"/>
							</xsl:when>
							<xsl:otherwise>
								Kodet:&#160;<xsl:value-of select="@V"/>
							</xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
				</th>
			</xsl:if>
			<xsl:if test="po:BeskrivelseInformasjon">
				<td>
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:BeskrivelseInformasjon"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<th>Gitt&#160;til</th>
			<td>
				<div class="No-line-content">
					<xsl:for-each select="po:InformasjonGittTil">
						<xsl:call-template name="Person"/>
					</xsl:for-each>
				</div>
				<xsl:choose>
					<xsl:when test="po:MuntligInformasjon='true'">
						<div>Gitt&#160;muntlig:&#160;Ja</div>
					</xsl:when>
					<xsl:when test="po:MuntligInformasjon='false'">
						<div>Gitt&#160;muntlig:&#160;Nei</div>
					</xsl:when>
				</xsl:choose>
			</td>
			<th>Gitt&#160;av</th>
			<td colspan="{(($std-col)-4-count(po:TypeInformasjon | po:BeskrivelseInformasjon))*number(not(po:InformasjonGittDato))+1}">
				<div class="No-line-content">
					<xsl:for-each select="po:InformasjonGittAv">
						<xsl:call-template name="HealthcareProfessional"/>
					</xsl:for-each>
				</div>
			</td>
			<xsl:if test="po:InformasjonGittDato">
				<th>Gitt&#160;dato</th>
				<td colspan="{(($std-col)-5-count(po:TypeInformasjon | po:BeskrivelseInformasjon))}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="po:InformasjonGittDato"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Info om avtale om legemiddeladministrering -->
	<xsl:template match="po:InfoAvtaleOmLegemiddeladm">
		<xsl:apply-templates select="po:AvtaleOmAdmLegemidler"/>
	</xsl:template>
	<!-- Visning av innhold i Ansvarlig -->
	<xsl:template match="po:Ansvarlig">
		<tr>
			<th>
				Ansvar
				<xsl:for-each select="po:TypeHendelse">
					:&#160;
					<xsl:choose>
						<xsl:when test="contains(@S, '9131')">
							<xsl:call-template name="k-9131"/>
						</xsl:when>
						<xsl:when test="@DN">
							<xsl:value-of select="@DN"/>
						</xsl:when>
						<xsl:when test="@OT">
							<xsl:value-of select="@OT"/>
						</xsl:when>
						<xsl:otherwise>
							Kodet:&#160;<xsl:value-of select="@V"/>
						</xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</th>
			<xsl:if test="po:AnsvarligTjenesteyter">
				<th>Ansvarlig&#160;tjenesteyter</th>
				<td>
					<div class="No-line-content">
						<xsl:for-each select="po:AnsvarligTjenesteyter">
							<xsl:call-template name="HealthcareProfessional"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<xsl:if test="po:Virksomhet">
				<th>Virksomhet</th>
				<td>
					<div class="No-line-content">
						<xsl:for-each select="po:Virksomhet">
							<xsl:call-template name="Organisation"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<td colspan="{(($std-col)-2-count(po:AnsvarligTjenesteyter | po:Virksomhet)*2)*number(not(po:Merknad))+1}">
				<div>
					<b>Tidspunkt:&#160;</b>
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="po:TidspunktForHendelse"/>
					</xsl:call-template>
				</div>
				<xsl:if test="po:Ekstern='true'">
					<div>Vurderingen er foretatt av helsepersonell utenfor journalførende virksomheten.</div>
				</xsl:if>
			</td>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-3-count(po:AnsvarligTjenesteyter | po:Virksomhet)*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Anbefalt videre tiltak -->
	<xsl:template match="po:AnbefaltVidereTiltak">
		<xsl:apply-templates select="po:Tiltaksbeskrivelse"/>
	</xsl:template>
	<!-- Visning av innhold i Reservasjon/ønske -->
	<xsl:template match="po:ReservasjonOnske">
		<tr>
			<td>
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="po:Gjelder"/>
				</xsl:call-template>
			</td>
			<th>Framsatt&#160;av</th>
			<td colspan="{(($std-col)-3)*number(not(po:TrukketTilbakeAv | po:TrukketTilbakeDato | po:Merknad))+1}">
				<div class="No-line-content">
					<xsl:for-each select="po:FramsattAv">
						<xsl:call-template name="Person"/>
					</xsl:for-each>
				</div>
				<b>Framsatt:&#160;</b>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="po:FramsattDato"/>
				</xsl:call-template>&#160;
			</td>
			<xsl:if test="po:TrukketTilbakeAv or po:TrukketTilbakeDato">
				<th>Trukket&#160;tilbake&#160;<xsl:if test="po:TrukketTilbakeAv">av</xsl:if></th>
				<td colspan="{(($std-col)-5)*number(not(po:Merknad))+1}">
					<xsl:if test="po:TrukketTilbakeAv">
						<div class="No-line-content">
							<xsl:for-each select="po:TrukketTilbakeAv">
								<xsl:call-template name="Person"/>
							</xsl:for-each>
						</div>
					</xsl:if>
					<xsl:if test="po:TrukketTilbakeAv"><b>Trukket&#160;tilbake:&#160;</b></xsl:if>
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="po:TrukketTilbakeDato"/>
					</xsl:call-template>&#160;
				</td>
			</xsl:if>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-4-number(boolean(po:TrukketTilbakeAv | po:TrukketTilbakeDato))*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Faste hjelpemidler -->
	<xsl:template match="po:FasteHjelpemidler">
		<tr>
			<xsl:if test="po:Briller">
				<th>Briller</th>
				<td colspan="{(($std-col)-2)*number(not(po:HjelpemiddelHorsel | po:Pacemaker | po:Merknad))+1}">
					<xsl:for-each select="po:Briller">
						<xsl:call-template name="k-9113"/>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="po:HjelpemiddelHorsel">
				<th>Hjelpemiddel hørsel</th>
				<td colspan="{(($std-col)-2-count(po:Briller)*2)*number(not(po:Pacemaker | po:Merknad))+1}">
					<xsl:for-each select="po:HjelpemiddelHorsel">
						<xsl:call-template name="k-9114"/>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="po:Pacemaker">
				<th>Pacemaker</th>
				<td colspan="{(($std-col)-2-count(po:Briller | po:HjelpemiddelHorsel)*2)*number(not(po:Merknad))+1}">
					<xsl:choose>
						<xsl:when test="po:Pacemaker='true'">Ja</xsl:when>
						<xsl:otherwise>Nei</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="po:Merknad">
				<th>Merknad</th>
				<td colspan="{(($std-col)-1-count(po:Briller | po:HjelpemiddelHorsel | po:Pacemaker)*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Faste hjelpemidler -->
	<xsl:template match="po:SamletVurderingFunksjonsniva">
		<tr>
			<th>Samlet&#160;vurdering</th>
			<xsl:if test="po:Merknad">
				<td colspan="{(($std-col)-2)*number(not(po:Pleietyngde | po:VurderingPleietyngde))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:Merknad"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="po:Pleietyngde">
				<th>Pleietyngde</th>
				<td colspan="{(($std-col)-3-count(po:Merknad))*number(not(po:VurderingPleietyngde))+1}">
					<xsl:value-of select="po:Pleietyngde"/>
				</td>
			</xsl:if>
			<xsl:if test="po:VurderingPleietyngde">
				<th>Vurdering&#160;pleietyngde</th>
				<td colspan="{(($std-col)-2-count(po:Merknad)-count(po:Pleietyngde)*2)}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:VurderingPleietyngde"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Tidsperiode for diagnosen -->
	<xsl:template match="po:TidsperiodeDiagnose">
		<!-- Start- og sluttdato for diagnosen vises i MedisinskDiagnose-template -->
		<xsl:apply-templates select="po:MedisinskDiagnose"/>
	</xsl:template>
	<!-- Visning av innhold i Info om mål/forventet resultat -->
	<xsl:template match="po:InfoMaalForventetRes">
		<xsl:variable name="rad" select="count(po:InnholdMaaldokument)+count(.//epj2:Journaltekst)"/>
		<tr>
			<th rowspan="{$rad}">
				Forventet&#160;mål
				<xsl:for-each select="po:InnholdMaaldokument/po:MaalForventetResultat">
					:&#160;
					<xsl:choose>
						<xsl:when test="@DN">
							<xsl:value-of select="@DN"/>
						</xsl:when>
						<xsl:when test="@OT">
							<xsl:value-of select="@OT"/>
						</xsl:when>
						<xsl:otherwise>
							Kodet:&#160;<xsl:value-of select="@V"/>
						</xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</th>
			<xsl:for-each select="po:InnholdMaaldokument">
				<xsl:if test="po:ForventetGradMaaloppnaaelse or po:Beskrivelse or po:ForventesOppnaadd">
					<td colspan="{(($std-col)-2)*number(not(po:KategoriHelsepersonell | po:FraDato | po:TilDato | po:Stikkord))+1}">
						<xsl:if test="po:Beskrivelse">
							<div>
								<b>Beskrivelse:</b>&#160;
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="po:Beskrivelse"/>
								</xsl:call-template>
							</div>
						</xsl:if>
						<xsl:if test="po:ForventesOppnaadd">
							<div>
								<b>Forventes&#160;oppnådd:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="po:ForventesOppnaadd"/>
								</xsl:call-template>&#160;
							</div>
						</xsl:if>
						<xsl:if test="po:ForventetGradMaaloppnaaelse">
							<div>
								<b>Forventet&#160;grad:</b>&#160;
								<xsl:for-each select="po:MaalForventetResultat">
									<xsl:choose>
										<xsl:when test="@DN">
											<xsl:value-of select="@DN"/>
										</xsl:when>
										<xsl:when test="@OT">
											<xsl:value-of select="@OT"/>
										</xsl:when>
										<xsl:otherwise>
											Kodet:&#160;<xsl:value-of select="@V"/>
										</xsl:otherwise>
									</xsl:choose>&#160;
								</xsl:for-each>
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="po:KategoriHelsepersonell">
					<th>Utformet&#160;av</th>
					<td colspan="{(($std-col)-3-number(boolean(po:ForventetGradMaaloppnaaelse | po:Beskrivelse | po:ForventesOppnaadd)))*number(not(po:FraDato | po:TilDato | po:Stikkord))+1}">
						<xsl:for-each select="po:KategoriHelsepersonell">
							<xsl:call-template name="k-9060"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="po:FraDato or po:TilDato">
					<th>Gyldighet</th>
					<td colspan="{(($std-col)-3-number(boolean(po:ForventetGradMaaloppnaaelse | po:Beskrivelse | po:ForventesOppnaadd))-count(po:KategoriHelsepersonell)*2)*number(not(po:Stikkord))+1}">
						<xsl:if test="po:FraDato">
							<div>
								<b>Fra:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="po:FraDato"/>
								</xsl:call-template>&#160;
							</div>
						</xsl:if>
						<xsl:if test="po:TilDato">
							<div>
								<b>Til:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="po:TilDato"/>
								</xsl:call-template>&#160;
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="po:Stikkord">
					<th>Stikkord</th>
					<td colspan="{(($std-col)-2-number(boolean(po:ForventetGradMaaloppnaaelse | po:Beskrivelse | po:ForventesOppnaadd))-count(po:KategoriHelsepersonell)*2-number(boolean(po:FraDato | po:TilDato))*2)}">
						<xsl:for-each select="po:Stikkord">
							<xsl:if test="position()!=1">,&#160;</xsl:if>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</td>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select=".//epj2:Journaltekst">
			<tr>
				<xsl:apply-templates select="." mode="utenRad"><xsl:with-param name="antKolonner" select="1"/></xsl:apply-templates>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om vurderinger -->
	<xsl:template match="po:InfoVurderinger">
		<xsl:variable name="rad" select="count(po:InnholdVurdering)+count(.//po:Enkeltvurdering)+count(.//epj2:Journaltekst)"/>
		<tr>
			<th rowspan="{$rad}">
				Vurdering&#160;av:&#160;
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="po:InnholdVurdering/po:VurderingenGjelder"/>
				</xsl:call-template>
			</th>
			<xsl:for-each select="po:InnholdVurdering">
				<xsl:if test="po:KategoriHelsepersonell">
					<th>Vurdert&#160;av</th>
					<td colspan="{(($std-col)-3)*number(not(po:FraDato | po:TilDato | po:Stikkord))+1}">
						<xsl:for-each select="po:KategoriHelsepersonell">
							<xsl:call-template name="k-9060"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="po:FraDato or po:TilDato">
					<th>Gyldighet</th>
					<td colspan="{(($std-col)-3-count(po:KategoriHelsepersonell)*2)*number(not(po:Stikkord))+1}">
						<xsl:if test="po:FraDato">
							<div>
								<b>Fra:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="po:FraDato"/>
								</xsl:call-template>&#160;
							</div>
						</xsl:if>
						<xsl:if test="po:TilDato">
							<div>
								<b>Til:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="po:TilDato"/>
								</xsl:call-template>&#160;
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="po:Stikkord">
					<th>Stikkord</th>
					<td colspan="{(($std-col)-2-count(po:KategoriHelsepersonell)*2-number(boolean(po:FraDato | po:TilDato))*2)}">
						<xsl:for-each select="po:Stikkord">
							<xsl:if test="position()!=1">,&#160;</xsl:if>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</td>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select=".//po:Enkeltvurdering">
			<tr>
				<xsl:if test="po:VurderingTekst">
					<td colspan="{(($std-col)-2)*number(not(po:Funksjonsområde | po:KodetVurdering))+1}">
						<b>Tekstlig&#160;vurdering:</b>&#160;
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="po:VurderingTekst"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="po:Funksjonsområde">
					<th>Funksjonsområde</th>
					<td colspan="{(($std-col)-2-count(po:VurderingTekst))*number(not(po:KodetVurdering))+1}">
						<xsl:for-each select="po:Funksjonsområde">
							<xsl:choose>
								<xsl:when test="contains(@S, '9536')">
									<xsl:call-template name="k-9536"/>
								</xsl:when>
								<xsl:when test="@DN">
									<xsl:value-of select="@DN"/>
								</xsl:when>
								<xsl:when test="@OT">
									<xsl:value-of select="@OT"/>
								</xsl:when>
								<xsl:otherwise>
									Kodet:&#160;<xsl:value-of select="@V"/>
								</xsl:otherwise>
							</xsl:choose>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="po:KodetVurdering">
					<th>Kodet vurdering</th>
					<td colspan="{(($std-col)-1-count(po:VurderingTekst)-count(po:Funksjonsområde)*2)}">
						<xsl:for-each select="po:KodetVurdering">
							<xsl:choose>
								<xsl:when test="@DN">
									<xsl:value-of select="@DN"/>
								</xsl:when>
								<xsl:when test="@OT">
									<xsl:value-of select="@OT"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@V"/>
								</xsl:otherwise>
							</xsl:choose>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select=".//epj2:Journaltekst">
			<tr>
				<xsl:apply-templates select="." mode="utenRad"><xsl:with-param name="antKolonner" select="1"/></xsl:apply-templates>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Iverksatte tiltak -->
	<xsl:template match="po:IverksatteTiltak">
		<xsl:apply-templates select="po:Tiltaksbeskrivelse"/>
	</xsl:template>
	<!-- Visning av innhold i Medisinsk diagnose -->
	<xsl:template match="po:MedisinskDiagnose">
		<tr>
			<xsl:if test="po:Diagnosekode">
				<th>
					<xsl:if test="po:Hoveddiagnose='true'">
						<div>Hovedtilstand:</div>
					</xsl:if>
					<xsl:value-of select="po:Diagnosekode/@V"/>&#160;
					<xsl:if test="contains(po:Diagnosekode/@S, '7170')">(ICPC)</xsl:if>
					<xsl:if test="contains(po:Diagnosekode/@S, '7110')">(ICD-10)</xsl:if>
				</th>
				<td colspan="{(($std-col)-2)*number(not(po:DiagnoseBeskrivelse | ../po:StartdatoDiagnose | ../po:SluttdatoDiagnose))+1}">
					<xsl:if test="po:Diagnosekode/@DN">
						<xsl:value-of select="po:Diagnosekode/@DN"/>&#160;</xsl:if>
					<xsl:if test="po:Diagnosekode/@OT">Fritekst:&#160;<xsl:value-of select="po:Diagnosekode/@OT"/>&#160;</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="po:DiagnoseBeskrivelse">
				<th>Beskrivelse</th>
				<td colspan="{(($std-col)-2-count(po:Diagnosekode)*2)*number(not(../po:StartdatoDiagnose | ../po:SluttdatoDiagnose))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="po:DiagnoseBeskrivelse"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="../po:StartdatoDiagnose">
				<th>Startdato</th>
				<td colspan="{(($std-col)-2-count(po:Diagnosekode | po:DiagnoseBeskrivelse)*2)*number(not(../po:SluttdatoDiagnose))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="../po:StartdatoDiagnose"/>
					</xsl:call-template>&#160;
				</td>
			</xsl:if>
			<xsl:if test="../po:SluttdatoDiagnose">
				<th>Sluttdato</th>
				<td colspan="{(($std-col)-1-count(po:Diagnosekode | po:DiagnoseBeskrivelse | ../po:StartdatoDiagnose)*2)}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="../po:SluttdatoDiagnose"/>
					</xsl:call-template>&#160;
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Status til hjelpemiddel -->
	<xsl:template match="po:StatusHjelpemiddel">
		<tr>
			<th>
				<xsl:choose>
					<xsl:when test="po:Hjelpemiddelbeskrivelse/po:HjelpemiddelkodeRTV">
						<xsl:for-each select="po:Hjelpemiddelbeskrivelse/po:HjelpemiddelkodeRTV">
							<xsl:choose>
								<xsl:when test="@DN">
									<xsl:value-of select="@DN"/>
								</xsl:when>
								<xsl:when test="@OT">
									<xsl:value-of select="@OT"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@V"/>
								</xsl:otherwise>
							</xsl:choose>&#160;
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Betegnelse</xsl:otherwise>
				</xsl:choose>
			</th>
			<td>
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="po:Hjelpemiddelbeskrivelse/po:BetegnelseHjelpemiddel"/>
				</xsl:call-template>
			</td>
			<th>Status</th>
			<td colspan="{(($std-col)-4)*number(not(po:Hjelpemiddelbeskrivelse/po:Sekvensnummer))+1}">
				<xsl:for-each select="po:Status">
					<xsl:call-template name="k-8230"/>
				</xsl:for-each>
			</td>
			<xsl:if test="po:Hjelpemiddelbeskrivelse/po:Sekvensnummer">
				<th>Sekvensnummer</th>
				<td colspan="{($std-col)-5}">
					<xsl:value-of select="po:Hjelpemiddelbeskrivelse/po:Sekvensnummer"/>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Tiltaksbeskrivelse -->
	<xsl:template match="po:Tiltaksbeskrivelse">
		<xsl:variable name="rad" select="1+count(.//po:GjennomforingAvTiltak)+count(po:PlanlagtGjennomforingTiltak)"/>
		<tr>
			<th rowspan="{$rad}">
				<xsl:choose>
					<xsl:when test="local-name(..)=&quot;IverksatteTiltak&quot;">
						Iverksatte&#160;tiltak:
					</xsl:when>
					<xsl:when test="local-name(..)=&quot;AnbefaltVidereTiltak&quot;">
						Anbefalte&#160;videre&#160;tiltak:
					</xsl:when>
					<xsl:when test="local-name(..)=&quot;AvtaleOmAdmLegemidler&quot;">
						Tiltak:
					</xsl:when>
				</xsl:choose>
			</th>
			<xsl:if test="po:IntervensjonTiltakBeskrivelse or po:IntervensjonTiltakKode">
				<td colspan="{(($std-col)-2)*number(not(po:KategoriHelsepersonell | po:Merknad | po:EvalueringTidspunkt | po:Stikkord))+1}">
					<xsl:if test="po:IntervensjonTiltakBeskrivelse">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="po:IntervensjonTiltakBeskrivelse"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:for-each select="po:IntervensjonTiltakKode">
						<div>&#160;-&#160;
							<xsl:choose>
								<xsl:when test="contains(@S, '9132')">
									<xsl:call-template name="k-9132"/>
								</xsl:when>
								<xsl:when test="@DN">
									<xsl:value-of select="@DN"/>
								</xsl:when>
								<xsl:when test="@OT">
									<xsl:value-of select="@OT"/>
								</xsl:when>
								<xsl:otherwise>
									Kodet:&#160;<xsl:value-of select="@V"/>
								</xsl:otherwise>
							</xsl:choose>&#160;
						</div>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="po:KategoriHelsepersonell">
				<th>Utformet&#160;av</th>
				<td colspan="{(($std-col)-3-number(boolean(po:IntervensjonTiltakBeskrivelse | po:IntervensjonTiltakKode)))*number(not(po:Merknad | po:EvalueringTidspunkt | po:Stikkord))+1}">
					<xsl:for-each select="po:KategoriHelsepersonell">
						<xsl:call-template name="k-9060"/>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="po:Merknad or po:EvalueringTidspunkt">
				<th>Merknad</th>
				<td colspan="{(($std-col)-3-number(boolean(po:IntervensjonTiltakBeskrivelse | po:IntervensjonTiltakKode))-count(po:KategoriHelsepersonell)*2)*number(not(po:Stikkord))+1}">
					<xsl:if test="po:Merknad">
						<div>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="po:Merknad"/>
						</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="po:EvalueringTidspunkt">
						<div>
							<b>Evalueringstidspunkt:</b>&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="po:EvalueringTidspunkt"/>
							</xsl:call-template>&#160;
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="po:Stikkord">
				<th>Stikkord</th>
				<td colspan="{(($std-col)-3-number(boolean(po:IntervensjonTiltakBeskrivelse | po:IntervensjonTiltakKode))-count(po:KategoriHelsepersonell)*2-number(boolean(po:FraDato | po:TilDato))*2)}">
					<xsl:for-each select="po:Stikkord">
						<xsl:if test="position()!=1">,&#160;</xsl:if>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</td>
			</xsl:if>
		</tr>
		<xsl:for-each select=".//po:GjennomforingAvTiltak">
			<tr>
				<th>Gjennomført tidspunkt</th>
				<td colspan="{(($std-col)-3)*number(not(po:TiltakKanTermineres | po:Merknad))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="po:UtfortTidspunkt"/>
					</xsl:call-template>&#160;
				</td>
				<xsl:if test="po:TiltakKanTermineres">
					<th>Kan termineres</th>
					<td colspan="{(($std-col)-3-count(po:UtfortTidspunkt)*2)*number(not(po:Merknad))+1}">
						<xsl:choose>
							<xsl:when test="po:TiltakKanTermineres='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="po:Merknad">
					<th>Merknad</th>
					<td colspan="{(($std-col)-2-count(po:UtfortTidspunkt | po:TiltakKanTermineres)*2)}">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="po:Merknad"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select=".//po:PlanlagtGjennomforingTiltak">
			<tr>
				<th>Tidsrom</th>
				<td colspan="{(($std-col)-3)*number(not(po:FasteUkedager | po:GjentagelseIntervall | po:EtterBehov))+1}">
					<div>
						<b>Planlagt&#160;start:</b>&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="po:PlanlagtStart"/>
						</xsl:call-template>&#160;
					</div>
					<xsl:if test="po:PlanlagtSlutt">
						<b>Planlagt&#160;slutt:</b>&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="po:PlanlagtSlutt"/>
						</xsl:call-template>&#160;
					</xsl:if>
				</td>
				<xsl:if test="po:FasteUkedager">
					<th>Faste&#160;ukedager</th>
					<td colspan="{(($std-col)-5)*number(not(po:GjentagelseIntervall | po:EtterBehov))+1}">
						<xsl:for-each select="po:FasteUkedager">
							<xsl:if test="position()!=1">,&#160;</xsl:if>
							<xsl:call-template name="k-9082"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="po:GjentagelseIntervall">
					<th>GjentagelseIntervall</th>
					<td colspan="{(($std-col)-5-count(po:FasteUkedager)*2)*number(not(po:EtterBehov))+1}">
						<xsl:value-of select="po:GjentagelseIntervall/@V"/>&#160;<xsl:value-of select="po:GjentagelseIntervall/@U"/>
					</td>
				</xsl:if>
				<xsl:if test="po:EtterBehov">
					<td colspan="{(($std-col)-3-count(po:FasteUkedager | po:GjentagelseIntervall)*2)}">
						<xsl:if test="po:EtterBehov='true'">Gjentas etter behov</xsl:if>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- Kodeverk -->
	<xsl:template name="k-8230">
		<xsl:choose>
			<xsl:when test="@V='1'">Foreslått</xsl:when>
			<xsl:when test="@V='2'">Bestilt</xsl:when>
			<xsl:when test="@V='3'">Avtalt</xsl:when>
			<xsl:when test="@V='4'">Utsatt</xsl:when>
			<xsl:when test="@V='5'">Kansellert</xsl:when>
			<xsl:when test="@V='6'">Aktiv</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8329">
		<xsl:choose>
			<xsl:when test="@V='1'">Egensøknad</xsl:when>
			<xsl:when test="@V='2'">Tidligmelding</xsl:when>
			<xsl:when test="@V='3'">Resept</xsl:when>
			<xsl:when test="@V='4'">Epikrise</xsl:when>
			<xsl:when test="@V='5'">Tverrfaglig&#160;epikrise</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8330">
		<xsl:choose>
			<xsl:when test="@V='1'">Pasient</xsl:when>
			<xsl:when test="@V='2'">Fastlege</xsl:when>
			<xsl:when test="@V='3'">Tilsynslege</xsl:when>
			<xsl:when test="@V='4'">Apotek</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8408">
		<xsl:choose>
			<xsl:when test="@V='1'">Vanlig&#160;bosted, arbeidssted&#160;m.v.</xsl:when>
			<xsl:when test="@V='2'">Skade-&#160;eller&#160;funnsted</xsl:when>
			<xsl:when test="@V='3'">Annen&#160;helseinstitusjon innen&#160;spesialisthelsetjenesten unntatt&#160;DPS</xsl:when>
			<xsl:when test="@V='5'">Utlandet</xsl:when>
			<xsl:when test="@V='6'">Annet</xsl:when>
			<xsl:when test="@V='7'">Annen&#160;somatisk&#160;enhet ved&#160;egen&#160;helseinstitusjon</xsl:when>
			<xsl:when test="@V='8'">Annen&#160;psykiatrisk&#160;enhet ved&#160;egen&#160;helseinstitusjon</xsl:when>
			<xsl:when test="@V='9'">Sykehotell</xsl:when>
			<xsl:when test="@V='10'">Pasienthotell</xsl:when>
			<xsl:when test="@V='11'">Aldershjem, sykehjem&#160;eller&#160;lignende</xsl:when>
			<xsl:when test="@V='12'">Annen&#160;enhet&#160;innen Tverrfaglig&#160;spesialisert&#160;behandling&#160;av rusmiddelbruk&#160;(TSB)&#160;ved egen&#160;helseinstitusjon</xsl:when>
			<xsl:when test="@V='13'">Intermediærenhet/forsterket&#160;sykehjem</xsl:when>
			<xsl:when test="@V='14'">Kommunal&#160;legevakt</xsl:when>
			<xsl:when test="@V='15'">Andre&#160;kommunale eller&#160;private&#160;bo-&#160;og&#160;hjelpetiltak</xsl:when>
			<xsl:when test="@V='16'">Distriktspsykiatrisk&#160;senter (DPS)</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8431">
		<xsl:choose>
			<xsl:when test="@V='1'">Som&#160;levende</xsl:when>
			<xsl:when test="@V='2'">Som&#160;død</xsl:when>
			<xsl:when test="@V='3'">Suicid</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8432">
		<xsl:choose>
			<xsl:when test="@V='1'">Utredning</xsl:when>
			<xsl:when test="@V='2'">Behandling</xsl:when>
			<xsl:when test="@V='3'">Kontroll</xsl:when>
			<xsl:when test="@V='5'">Indirekte&#160;pasientkontakt</xsl:when>
			<xsl:when test="@V='12'">Pasientadministrert&#160;behandling</xsl:when>
			<xsl:when test="@V='15'">Opplæring</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8434">
		<xsl:choose>
			<xsl:when test="@V='1'">På&#160;egen&#160;helseinstitusjon</xsl:when>
			<xsl:when test="@V='2'">Hos&#160;ekstern&#160;instans</xsl:when>
			<xsl:when test="@V='3'">Telemedisinsk&#160;behandling (der&#160;behandlende&#160;lege&#160;er)</xsl:when>
			<xsl:when test="@V='4'">Hjemme&#160;hos&#160;pasienten</xsl:when>
			<xsl:when test="@V='5'">Annet&#160;ambulant&#160;sted</xsl:when>
			<xsl:when test="@V='6'">Telemedisinsk&#160;behandling (der&#160;pasienten&#160;er)</xsl:when>
			<xsl:when test="@V='9'">Annet&#160;sted</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-8724">
		<xsl:choose>
			<xsl:when test="@V='1'">Ugift</xsl:when>
			<xsl:when test="@V='2'">Gift</xsl:when>
			<xsl:when test="@V='3'">Registrert&#160;partnerskap</xsl:when>
			<xsl:when test="@V='4'">Separert</xsl:when>
			<xsl:when test="@V='5'">Skilt</xsl:when>
			<xsl:when test="@V='6'">Enke/enkemann</xsl:when>
			<xsl:when test="@V='9'">Ukjent</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9033">
		<xsl:choose>
			<xsl:when test="@V='MO'">Mor</xsl:when>
			<xsl:when test="@V='FA'">Far</xsl:when>
			<xsl:when test="@V='SM'">Stemor</xsl:when>
			<xsl:when test="@V='SF'">Stefar</xsl:when>
			<xsl:when test="@V='FM'">Fostermor</xsl:when>
			<xsl:when test="@V='FF'">Fosterfar</xsl:when>
			<xsl:when test="@V='MM'">Medmor</xsl:when>
			<xsl:when test="@V='EF'">Ektefelle</xsl:when>
			<xsl:when test="@V='SA'">Samboer</xsl:when>
			<xsl:when test="@V='SI'">Søster</xsl:when>
			<xsl:when test="@V='BR'">Bror</xsl:when>
			<xsl:when test="@V='SS'">Stesøster</xsl:when>
			<xsl:when test="@V='SB'">Stebror</xsl:when>
			<xsl:when test="@V='DA'">Datter</xsl:when>
			<xsl:when test="@V='SO'">Sønn</xsl:when>
			<xsl:when test="@V='SD'">Stedatter</xsl:when>
			<xsl:when test="@V='SN'">Stesønn</xsl:when>
			<xsl:when test="@V='GM'">Bestemor</xsl:when>
			<xsl:when test="@V='GF'">Bestefar</xsl:when>
			<xsl:when test="@V='BB'">Barnebarn</xsl:when>
			<xsl:when test="@V='TO'">Foreldres&#160;søsken</xsl:when>
			<xsl:when test="@V='AS'">Annen&#160;slektning</xsl:when>
			<xsl:when test="@V='AN'">Annen&#160;foresatt</xsl:when>
			<xsl:when test="@V='AP'">Annen&#160;personlig&#160;relasjon</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9050">
		<xsl:choose>
			<xsl:when test="@V='1'">Forelder/foresatt</xsl:when>
			<xsl:when test="@V='2'">Verge</xsl:when>
			<xsl:when test="@V='3'">Hjelpeverge</xsl:when>
			<xsl:when test="@V='4'">Tilsynsfører</xsl:when>
			<xsl:when test="@V='5'">Støttekontakt</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9060">
		<xsl:choose>
			<xsl:when test="@V='AA'">Ambulansearbeider</xsl:when>
			<xsl:when test="@V='AT'">Apotektekniker</xsl:when>
			<xsl:when test="@V='AU'">Audiograf</xsl:when>
			<xsl:when test="@V='BI'">Bioingeniør</xsl:when>
			<xsl:when test="@V='ET'">Ergoterapeut</xsl:when>
			<xsl:when test="@V='FA1'">Provisorfarmasøyt</xsl:when>
			<xsl:when test="@V='FA2'">Reseptarfarmasøyt</xsl:when>
			<xsl:when test="@V='FO'">Fotterapeut</xsl:when>
			<xsl:when test="@V='FT'">Fysioterapeut</xsl:when>
			<xsl:when test="@V='HE'">Helsesekretær</xsl:when>
			<xsl:when test="@V='HF'">Helsefagarbeider</xsl:when>
			<xsl:when test="@V='HP'">Hjelpepleier</xsl:when>
			<xsl:when test="@V='JO'">Jordmor</xsl:when>
			<xsl:when test="@V='KE'">Klinisk ernæringsfysiolog</xsl:when>
			<xsl:when test="@V='KI'">Kiropraktor</xsl:when>
			<xsl:when test="@V='LE'">Lege</xsl:when>
			<xsl:when test="@V='OA'">Omsorgsarbeider</xsl:when>
			<xsl:when test="@V='OI'">Ortopedingeniør</xsl:when>
			<xsl:when test="@V='OP'">Optiker</xsl:when>
			<xsl:when test="@V='OR'">Ortoptist</xsl:when>
			<xsl:when test="@V='PE'">Perfusjonist</xsl:when>
			<xsl:when test="@V='PS'">Psykolog</xsl:when>
			<xsl:when test="@V='RA'">Radiograf</xsl:when>
			<xsl:when test="@V='SP'">Sykepleier</xsl:when>
			<xsl:when test="@V='TH'">Tannhelsesekretær</xsl:when>
			<xsl:when test="@V='TL'">Tannlege</xsl:when>
			<xsl:when test="@V='TP'">Tannpleier</xsl:when>
			<xsl:when test="@V='TT'">Tanntekniker</xsl:when>
			<xsl:when test="@V='VP'">Vernepleier</xsl:when>
			<xsl:when test="@V='XX'">Ukjent/uspesifisert</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9065">
		<xsl:choose>
			<xsl:when test="@V='1'">Spørsmål om å få oversendt hele journalen</xsl:when>
			<xsl:when test="@V='2'">Spørsmål om å få overført en eller flere kategorier opplysninger i journalen</xsl:when>
			<xsl:when test="@V='3'">Spørsmål om mottaker har ønske om å få tilsendt hele journalen eller flere opplysninger enn det det er spurt om</xsl:when>
			<xsl:when test="@V='4'">Spørsmål om mottaker kan motta et sett av journaler for deponering</xsl:when>
			<xsl:when test="@V='5'">Fritekst</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9067">
		<xsl:choose>
			<xsl:when test="@V='1'">Øyeblikkelig&#160;hjelp</xsl:when>
			<xsl:when test="@V='2'">Gjelder&#160;pågående&#160;helsehjelp</xsl:when>
			<xsl:when test="@V='3'">Innen&#160;24&#160;timer</xsl:when>
			<xsl:when test="@V='4'">Ubestemt</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9082">
		<xsl:choose>
			<xsl:when test="@V='1'">Mandag</xsl:when>
			<xsl:when test="@V='2'">Tirsdag</xsl:when>
			<xsl:when test="@V='3'">Onsdag</xsl:when>
			<xsl:when test="@V='4'">Torsdag</xsl:when>
			<xsl:when test="@V='5'">Fredag</xsl:when>
			<xsl:when test="@V='6'">Lørdag</xsl:when>
			<xsl:when test="@V='7'">Søndag</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9111">
		<xsl:choose>
			<xsl:when test="@V='1'">Sosial&#160;deltakelse</xsl:when>
			<xsl:when test="@V='2'">Skaffe&#160;seg&#160;varer&#160;og&#160;tjenester</xsl:when>
			<xsl:when test="@V='3'">Beslutninger&#160;i&#160;dagliglivet</xsl:when>
			<xsl:when test="@V='4'">Ivareta&#160;egen&#160;helse</xsl:when>
			<xsl:when test="@V='5'">Bevege&#160;seg&#160;innendørs</xsl:when>
			<xsl:when test="@V='6'">Alminnelig&#160;husarbeid</xsl:when>
			<xsl:when test="@V='7'">Personlig&#160;hygiene</xsl:when>
			<xsl:when test="@V='8'">På-&#160;og&#160;avkledning</xsl:when>
			<xsl:when test="@V='9'">Lage&#160;mat</xsl:when>
			<xsl:when test="@V='10'">Spise</xsl:when>
			<xsl:when test="@V='11'">Toalett</xsl:when>
			<xsl:when test="@V='12'">Bevege&#160;seg&#160;utendørs</xsl:when>
			<xsl:when test="@V='13'">Syn</xsl:when>
			<xsl:when test="@V='14'">Hørsel</xsl:when>
			<xsl:when test="@V='15'">Hukommelse</xsl:when>
			<xsl:when test="@V='16'">Kommunikasjon</xsl:when>
			<xsl:when test="@V='17'">Styre&#160;atferd</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9113">
		<xsl:choose>
			<xsl:when test="@V='1'">Lesebriller</xsl:when>
			<xsl:when test="@V='2'">Avstandsbriller</xsl:when>
			<xsl:when test="@V='3'">Databriller</xsl:when>
			<xsl:when test="@V='4'">Progressive&#160;briller</xsl:when>
			<xsl:when test="@V='5'">Lupebriller</xsl:when>
			<xsl:when test="@V='6'">Kikkertbriller</xsl:when>
			<xsl:when test="@V='7'">Filterbriller</xsl:when>
			<xsl:when test="@V='8'">Kontaktlinser</xsl:when>
			<xsl:when test="@V='99'">Uspesifisert&#160;hjelpemiddel for&#160;syn</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9114">
		<xsl:choose>
			<xsl:when test="@V='1'">Høreapparat</xsl:when>
			<xsl:when test="@V='2'">Implantat</xsl:when>
			<xsl:when test="@V='9'">Uspesifisert&#160;hjelpemiddel for&#160;hørsel</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9121">
		<xsl:choose>
			<xsl:when test="@V='1'">Pasient&#160;innlagt</xsl:when>
			<xsl:when test="@V='2'">Pasient&#160;utskrevet</xsl:when>
			<xsl:when test="@V='3'">Pasient&#160;utskrivningsklar</xsl:when>
			<xsl:when test="@V='4'">Avmelding&#160;av utskrivningsklar&#160;pasient</xsl:when>
			<xsl:when test="@V='13'">Pasienten&#160;er&#160;død</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9131">
		<xsl:choose>
			<xsl:when test="@V='1'">Vurdering&#160;av funksjonsnivå</xsl:when>
			<xsl:when test="@V='2'">Forskrivning&#160;av legemiddel</xsl:when>
			<xsl:when test="@V='3'">Utarbeiding&#160;av sykepleiesammenfatning</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9132">
		<xsl:choose>
			<xsl:when test="@V='1'">Fornyelse&#160;av resept&#160;hos&#160;fastlege</xsl:when>
			<xsl:when test="@V='2'">Innkjøp/henting&#160;av legemiddel&#160;på&#160;apotek</xsl:when>
			<xsl:when test="@V='3'">Oppbevaring&#160;av legemiddel</xsl:when>
			<xsl:when test="@V='4'">Vurdering&#160;av når&#160;legemiddel&#160;skal&#160;tas</xsl:when>
			<xsl:when test="@V='5'">Istandgjøring&#160;og&#160;kontroll&#160;av legemiddel</xsl:when>
			<xsl:when test="@V='6'">Overlevering&#160;av legemiddel</xsl:when>
			<xsl:when test="@V='7'">Overlevering&#160;og&#160;kontroll&#160;av at&#160;legemiddel&#160;blir&#160;anvendt</xsl:when>
			<xsl:when test="@V='8'">Hyppighet&#160;av sykepleiefaglig&#160;gjennomgang av&#160;legemiddelbruk</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9135">
		<xsl:choose>
			<xsl:when test="@V='1'">Enkeltdose</xsl:when>
			<xsl:when test="@V='2'">Dosett</xsl:when>
			<xsl:when test="@V='3'">Multidose</xsl:when>
			<xsl:when test="@V='8'">Annet</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9136">
		<xsl:choose>
			<xsl:when test="@V='1'">Forberedelser&#160;til&#160;insulininjeksjon</xsl:when>
			<xsl:when test="@V='2'">Injeksjon&#160;av&#160;insulin</xsl:when>
			<xsl:when test="@V='3'">Oppfølging&#160;av&#160;marevanbehandling</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9151">
		<xsl:choose>
			<xsl:when test="@V='1'">Praktisk&#160;bistand: daglige&#160;gjøremål</xsl:when>
			<xsl:when test="@V='2'">Praktisk&#160;bistand: opplæring&#160;-&#160;daglige gjøremål</xsl:when>
			<xsl:when test="@V='3'">Praktisk&#160;bistand: brukerstyrt&#160;-&#160;personlig assistanse</xsl:when>
			<xsl:when test="@V='4'">Dagsenter/dagtilbud</xsl:when>
			<xsl:when test="@V='5'">Matombringing</xsl:when>
			<xsl:when test="@V='6'">Trygghetsalarm</xsl:when>
			<xsl:when test="@V='7'">Avlastning -&#160;utenfor&#160;institusjon/bolig</xsl:when>
			<xsl:when test="@V='8'">Avlastning -&#160;i&#160;institusjon/bolig</xsl:when>
			<xsl:when test="@V='9'">Støttekontakt</xsl:when>
			<xsl:when test="@V='11'">Omsorgslønn</xsl:when>
			<xsl:when test="@V='12'">Omsorgsbolig</xsl:when>
			<xsl:when test="@V='13'">Annen&#160;bolig</xsl:when>
			<xsl:when test="@V='14'">Planlagte&#160;tiltak</xsl:when>
			<xsl:when test="@V='15'">Hjemmesykepleie</xsl:when>
			<xsl:when test="@V='16'">Re-/habilitering&#160;utenfor&#160;institusjon</xsl:when>
			<xsl:when test="@V='17'">Dagopphold&#160;i&#160;institusjon</xsl:when>
			<xsl:when test="@V='18'">Tidsbegrenset&#160;opphold -&#160;utredning/behandling</xsl:when>
			<xsl:when test="@V='19'">Tidsbegrenset&#160;opphold -&#160;re-/habilitering</xsl:when>
			<xsl:when test="@V='20'">Tidsbegrenset&#160;opphold -&#160;annet</xsl:when>
			<xsl:when test="@V='21'">Langtidsopphold&#160;i&#160;institusjon</xsl:when>
			<xsl:when test="@V='22'">Nattopphold&#160;i&#160;institusjon</xsl:when>
			<xsl:when test="@V='23'">Skadeavvergende&#160;tiltak i&#160;nødssituasjoner</xsl:when>
			<xsl:when test="@V='24'">Helsehjelp&#160;med&#160;tvang</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9152-4">
		<xsl:choose>
			<xsl:when test="@V='1'">Helseopplysninger</xsl:when>
			<xsl:when test="@V='4'">Legemiddelopplysninger</xsl:when>
			<xsl:when test="@V='3'">Tjenestetilbud</xsl:when>
			<xsl:when test="@V='5'">Tilstandsvurdering</xsl:when>
			<xsl:when test="@V='6'">Fornye&#160;resept(er)</xsl:when>
			<xsl:when test="@V='7'">Time&#160;til&#160;undersøkelse/behandling</xsl:when>
			<xsl:when test="@V='8'">Status/plan&#160;for&#160;utskrivning</xsl:when>
			<xsl:when test="@V='99'">Annen&#160;henvendelse</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9502">
		<xsl:choose>
			<xsl:when test="@V='I'">Innsynsrett&#160;i&#160;journal</xsl:when>
			<xsl:when test="@V='O'">Rutiner&#160;for&#160;overføring av&#160;journalinformasjon</xsl:when>
			<xsl:when test="@V='V'">Vaksinasjonsprogram og&#160;Sysvak</xsl:when>
			<xsl:when test="@V='R'">Retten&#160;til&#160;å&#160;motsette&#160;seg at&#160;helsepersonell&#160;får&#160;tilgang til&#160;informasjon&#160;i&#160;journalen uten&#160;eksplisitt&#160;samtykke</xsl:when>
			<xsl:when test="@V='K'">Klageadgang</xsl:when>
			<xsl:when test="@V='G'">Generelt&#160;om&#160;samtykke (til behandling)</xsl:when>
			<xsl:when test="@V='A'">Annet</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9536">
		<xsl:choose>
			<xsl:when test="@V='1'">Smerte</xsl:when>
			<xsl:when test="@V='2'">Bevegelsesevne</xsl:when>
			<xsl:when test="@V='3'">Naturlige&#160;funksjoner</xsl:when>
			<xsl:when test="@V='4'">Daglige&#160;gjøremål</xsl:when>
			<xsl:when test="@V='5'">Angst/depresjon</xsl:when>
			<xsl:when test="@V='6'">Pleie&#160;og&#160;omsorg</xsl:when>
			<xsl:when test="@V='7'">Barns&#160;vekst og&#160;utvikling</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
