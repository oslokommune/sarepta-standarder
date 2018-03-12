<?xml version="1.0" encoding="UTF-8"?>
	<!-- Endringslogg
	- 02.12.15: Innføring av felles kodeverksfil. Småjusteringer på layout.
	- 01.12.15: Omskrivning av fila for å unngå bruk av po-navnerommet. Dette for at flere ulike versjoner av plo-meldingene kan bruke fila.
	-->
	<!-- Om
	- Inngår i Hdirs visningsfiler versjon 2.0
	- Laget i XMLSpy v2016 (http://www.altova.com) av Jan Sigurd Dragsjø (nhn.no)
	-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" exclude-result-prefixes="fk1">

	<!-- Filer som må importeres. Vanligvis gjøres dette i hovedfila som importerer denne komponentfila. Derfor er de kommentert ut.
	<xsl:import href="funksjoner.xsl"/> 
	<xsl:import href="meldingshode2html.xsl"/>
	<xsl:import href="kodeverk.xsl"/> 
	<xsl:import href="cave2html.xsl"/>
	<xsl:import href="journalnotat2html.xsl"/> -->

	<!-- Variabel for standard antall kolonner i tabellene-->
	<xsl:variable name="std-col" select="8"/>
	<xsl:variable name="std-td" select="100"/>
	
	<!-- Visning av innhold i Pårørende/foresatt -->
	<xsl:template name="ParorendeForesatt">
		<tr>
			<th>
				<xsl:for-each select="child::*[local-name()=&quot;Slektskap&quot;]">
					<xsl:call-template name="k-9033"/>&#160;
				</xsl:for-each>
				<xsl:if test="child::*[local-name()=&quot;Slektskap&quot;] and child::*[local-name()=&quot;Omsorgsfunksjon&quot;]">og&#160;</xsl:if>
				<xsl:for-each select="child::*[local-name()=&quot;Omsorgsfunksjon&quot;]">
					<xsl:call-template name="k-9050"/>&#160;
				</xsl:for-each>
				<xsl:if test="not(child::*[local-name()=&quot;Slektskap&quot;]) and not(child::*[local-name()=&quot;Omsorgsfunksjon&quot;])">Pårørende/foresatt</xsl:if>
			</th>
			<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Referanseperson&quot;]//fk1:TeleAddress | child::*[local-name()=&quot;FodselsarMindrearigParorende&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Referanseperson&quot;]//fk1:TeleAddress | child::*[local-name()=&quot;FodselsarMindrearigParorende&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<xsl:for-each select="child::*[local-name()=&quot;Referanseperson&quot;]">
					<div><xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/></div>
				</xsl:for-each>
			</td>
			<xsl:if test="child::*[local-name()=&quot;Referanseperson&quot;]//fk1:TeleAddress">
				<td width="{((($std-col)-3)*number(not(child::*[local-name()=&quot;FodselsarMindrearigParorende&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3)*number(not(child::*[local-name()=&quot;FodselsarMindrearigParorende&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;Referanseperson&quot;]//fk1:TeleAddress"><xsl:call-template name="TeleAddress"/></xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;FodselsarMindrearigParorende&quot;]">
				<th>Født</th>
				<td width="{((($std-col)-4-number(boolean(child::*[local-name()=&quot;Referanseperson&quot;]//fk1:TeleAddress)))*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-4-number(boolean(child::*[local-name()=&quot;Referanseperson&quot;]//fk1:TeleAddress)))*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:value-of select="child::*[local-name()=&quot;FodselsarMindrearigParorende&quot;]"/>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-3-number(boolean(child::*[local-name()=&quot;Referanseperson&quot;]//fk1:TeleAddress))-count(child::*[local-name()=&quot;FodselsarMindrearigParorende&quot;])*2)*$std-td}px" colspan="{($std-col)-3-number(boolean(child::*[local-name()=&quot;Referanseperson&quot;]//fk1:TeleAddress))-count(child::*[local-name()=&quot;FodselsarMindrearigParorende&quot;])*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Tilknyttet Enhet -->
	<xsl:template name="TilknyttetEnhet">
		<tr>
			<td>
				<div class="No-line-content">
					<xsl:for-each select="child::*[local-name()=&quot;Kontaktenhet&quot;]">
						<xsl:call-template name="Organisation"/>
					</xsl:for-each>
				</div>
			</td>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-2-count(child::*[local-name()=&quot;Kontaktenhet&quot;]))*$std-td}px" colspan="{($std-col)-2-count(child::*[local-name()=&quot;Kontaktenhet&quot;])}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Kontaktperson helsepersonell -->
	<xsl:template name="KontaktpersonHelsepersonell">
		<tr>
			<td width="{((($std-col)-1)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-1)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<div class="No-line-content">
					<xsl:for-each select="child::*[local-name()=&quot;Kontaktperson&quot;]">
						<xsl:call-template name="HealthcareProfessional"/>
					</xsl:for-each>
				</div>
			</td>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-2)*$std-td}px" colspan="{($std-col)-2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Tilleggsopplysninger pasient -->
	<xsl:template name="TilleggsopplysningPasient">
		<tr>
			<xsl:if test="child::*[local-name()=&quot;SivilStatus&quot;]">
				<th>SivilStatus</th>
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;BorAlene&quot;] | child::*[local-name()=&quot;Sprak&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;BorAlene&quot;] | child::*[local-name()=&quot;Sprak&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;SivilStatus&quot;]">
						<xsl:call-template name="k-8724"/>&#160;
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;BorAlene&quot;]">
				<th>Bor&#160;alene</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;SivilStatus&quot;])*2)*number(not(child::*[local-name()=&quot;Sprak&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;SivilStatus&quot;])*2)*number(not(child::*[local-name()=&quot;Sprak&quot;]))+1}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;BorAlene&quot;]='true'">Ja</xsl:when>
						<xsl:otherwise>Nei</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Sprak&quot;]">
				<th>Språk</th>
				<td width="{(($std-col)-1-count(child::*[local-name()=&quot;SivilStatus&quot;] | child::*[local-name()=&quot;BorAlene&quot;])*2)*$std-td}px" colspan="{($std-col)-1-count(child::*[local-name()=&quot;SivilStatus&quot;] | child::*[local-name()=&quot;BorAlene&quot;])*2}">
					<xsl:for-each select="child::*[local-name()=&quot;Sprak&quot;]">
						<xsl:call-template name="k-3303"/>&#160;
					</xsl:for-each>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Sendt dokument -->
	<xsl:template name="SendtDokument">
		<tr>
			<th>
				<xsl:for-each select="child::*[local-name()=&quot;Opplysning&quot;]">
					<xsl:choose>
						<xsl:when test="contains(@S, '8329')"><xsl:call-template name="k-8329"/>&#160;</xsl:when>
						<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</th>
			<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;TypeMottaker&quot;] | child::*[local-name()=&quot;NavnMottaker&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;TypeMottaker&quot;] | child::*[local-name()=&quot;NavnMottaker&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;JaNei&quot;]='true' and child::*[local-name()=&quot;DatoSendt&quot;]">
						<b>Sendt</b>&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;DatoSendt&quot;]"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="child::*[local-name()=&quot;JaNei&quot;]='true' and not(child::*[local-name()=&quot;DatoSendt&quot;])">
						<b>Sendt:</b>&#160;Ja
					</xsl:when>
					<xsl:when test="child::*[local-name()=&quot;JaNei&quot;]='false' and child::*[local-name()=&quot;DatoSendt&quot;]">
						<b>Sendes</b>&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;DatoSendt&quot;]"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="child::*[local-name()=&quot;JaNei&quot;]='false' and not(child::*[local-name()=&quot;DatoSendt&quot;])">
						<b>Sendt:</b>&#160;Nei
					</xsl:when>
				</xsl:choose>
			</td>
			<xsl:if test="child::*[local-name()=&quot;TypeMottaker&quot;] or child::*[local-name()=&quot;NavnMottaker&quot;]">
				<th>Mottaker</th>
				<td width="{((($std-col)-4)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-4)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;TypeMottaker&quot;]">
						<xsl:choose>
							<xsl:when test="contains(@S, '8330')"><xsl:call-template name="k-8330"/>&#160;</xsl:when>
							<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
					<xsl:value-of select="child::*[local-name()=&quot;NavnMottaker&quot;]"/>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-2-number(boolean(child::*[local-name()=&quot;TypeMottaker&quot;] | child::*[local-name()=&quot;NavnMottaker&quot;]))*2)*$std-td}px" colspan="{($std-col)-2-number(boolean(child::*[local-name()=&quot;TypeMottaker&quot;] | child::*[local-name()=&quot;NavnMottaker&quot;]))*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Informasjon om forsendelsen -->
	<xsl:template name="InformasjonOmForsendelsen">
		<tr>
			<th>Status</th>
			<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;ForbeholdOmVideresending&quot;] | child::*[local-name()=&quot;SvarPaaForesporsel&quot;] | //child::*[local-name()=&quot;InnholdKonsultasjon&quot;]/child::*[local-name()=&quot;Merknad&quot;] | //child::*[local-name()=&quot;TypeInnholdIMelding&quot;]/child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;ForbeholdOmVideresending&quot;] | child::*[local-name()=&quot;SvarPaaForesporsel&quot;] | //child::*[local-name()=&quot;InnholdKonsultasjon&quot;]/child::*[local-name()=&quot;Merknad&quot;] | //child::*[local-name()=&quot;TypeInnholdIMelding&quot;]/child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<xsl:for-each select="child::*[local-name()=&quot;Forsendelsesstatus&quot;]">
					<xsl:call-template name="k-7309"/>
				</xsl:for-each>
			</td>
			<xsl:if test="child::*[local-name()=&quot;ForbeholdOmVideresending&quot;]">
				<th>Forbehold&#160;gitt om&#160;videresending</th>
				<td width="{((($std-col)-4)*number(not(child::*[local-name()=&quot;SvarPaaForesporsel&quot;] | //child::*[local-name()=&quot;InnholdKonsultasjon&quot;]/child::*[local-name()=&quot;Merknad&quot;] | //child::*[local-name()=&quot;TypeInnholdIMelding&quot;]/child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-4)*number(not(child::*[local-name()=&quot;SvarPaaForesporsel&quot;] | //child::*[local-name()=&quot;InnholdKonsultasjon&quot;]/child::*[local-name()=&quot;Merknad&quot;] | //child::*[local-name()=&quot;TypeInnholdIMelding&quot;]/child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;ForbeholdOmVideresending&quot;]='true'">Ja</xsl:when>
						<xsl:otherwise>Nei</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;SvarPaaForesporsel&quot;]">
				<th>Svar&#160;på&#160;forespørsel</th>
				<td width="{((($std-col)-4-count(child::*[local-name()=&quot;ForbeholdOmVideresending&quot;])*2)*number(not(//child::*[local-name()=&quot;InnholdKonsultasjon&quot;]/child::*[local-name()=&quot;Merknad&quot;] | //child::*[local-name()=&quot;TypeInnholdIMelding&quot;]/child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-4-count(child::*[local-name()=&quot;ForbeholdOmVideresending&quot;])*2)*number(not(//child::*[local-name()=&quot;InnholdKonsultasjon&quot;]/child::*[local-name()=&quot;Merknad&quot;] | //child::*[local-name()=&quot;TypeInnholdIMelding&quot;]/child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;SvarPaaForesporsel&quot;]='true'">Ja</xsl:when>
						<xsl:otherwise>Nei</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="//child::*[local-name()=&quot;InnholdKonsultasjon&quot;]/child::*[local-name()=&quot;Merknad&quot;] or //child::*[local-name()=&quot;TypeInnholdIMelding&quot;]/child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad&#160;til&#160;innhold</th>
				<td width="{(($std-col)-3-count(child::*[local-name()=&quot;ForbeholdOmVideresending&quot;] | child::*[local-name()=&quot;SvarPaaForesporsel&quot;])*2)*$std-td}px" colspan="{($std-col)-3-count(child::*[local-name()=&quot;ForbeholdOmVideresending&quot;] | child::*[local-name()=&quot;SvarPaaForesporsel&quot;])*2}">
					<xsl:for-each select="//child::*[local-name()=&quot;InnholdKonsultasjon&quot;]/child::*[local-name()=&quot;Merknad&quot;]">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each select="//child::*[local-name()=&quot;TypeInnholdIMelding&quot;]/child::*[local-name()=&quot;Merknad&quot;]">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</td>
			</xsl:if>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;Foresporsel&quot;]">
			<xsl:call-template name="Foresporsel"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Ansvar for rapport -->
	<xsl:template name="AnsvarForRapport">
		<tr>
			<xsl:if test="child::*[local-name()=&quot;TypeRelasjon&quot;]">
				<th>
					<xsl:for-each select="child::*[local-name()=&quot;TypeRelasjon&quot;]">
						<xsl:choose>
							<xsl:when test="contains(@S, '8254')"><xsl:call-template name="k-8254"/>&#160;</xsl:when>
							<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
				</th>
			</xsl:if>
			<td width="{((($std-col)-1-count(child::*[local-name()=&quot;TypeRelasjon&quot;]))*number(not(child::*[local-name()=&quot;GodkjentDato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-1-count(child::*[local-name()=&quot;TypeRelasjon&quot;]))*number(not(child::*[local-name()=&quot;GodkjentDato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<div class="No-line-content">
					<xsl:for-each select="child::*[local-name()=&quot;AnsvarligRapport&quot;]">
						<xsl:call-template name="HealthcareProfessional"/>
					</xsl:for-each>
				</div>
			</td>
			<xsl:if test="child::*[local-name()=&quot;GodkjentDato&quot;]">
				<th>Godkjent</th>
				<td width="{((($std-col)-3-count(child::*[local-name()=&quot;TypeRelasjon&quot;]))*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-count(child::*[local-name()=&quot;TypeRelasjon&quot;]))*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;GodkjentDato&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-2-count(child::*[local-name()=&quot;TypeRelasjon&quot;])-number(boolean(child::*[local-name()=&quot;GodkjentDato&quot;]))*2)*$std-td}px" colspan="{($std-col)-2-count(child::*[local-name()=&quot;TypeRelasjon&quot;])-number(boolean(child::*[local-name()=&quot;GodkjentDato&quot;]))*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Forespørsel -->
	<xsl:template name="Foresporsel">
		<tr>
			<th width="{((($std-col)-1)*number(not(child::*[local-name()=&quot;Sporsmal&quot;] | child::*[local-name()=&quot;Formål&quot;] | child::*[local-name()=&quot;Begrunnelse&quot;] | child::*[local-name()=&quot;TypeJournalinfo&quot;] | child::*[local-name()=&quot;Hastegrad&quot;] | child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))+1)*$std-td}px" colspan="{(($std-col)-1)*number(not(child::*[local-name()=&quot;Sporsmal&quot;] | child::*[local-name()=&quot;Formål&quot;] | child::*[local-name()=&quot;Begrunnelse&quot;] | child::*[local-name()=&quot;TypeJournalinfo&quot;] | child::*[local-name()=&quot;Hastegrad&quot;] | child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))+1}">
				Opprinnelig&#160;forespørsel:&#160;
				<xsl:for-each select="child::*[local-name()=&quot;TypeForesp&quot;]">
					<xsl:choose>
						<xsl:when test="contains(@S, '9152')"><xsl:call-template name="k-9152"/></xsl:when>
						<xsl:when test="contains(@S, '9153')"><xsl:call-template name="k-9153"/></xsl:when>
						<xsl:when test="contains(@S, '9154')"><xsl:call-template name="k-9154"/></xsl:when>
						<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</th>
			<xsl:if test="child::*[local-name()=&quot;Sporsmal&quot;]">
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Formål&quot;] | child::*[local-name()=&quot;Begrunnelse&quot;] | child::*[local-name()=&quot;TypeJournalinfo&quot;] | child::*[local-name()=&quot;Hastegrad&quot;] | child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Formål&quot;] | child::*[local-name()=&quot;Begrunnelse&quot;] | child::*[local-name()=&quot;TypeJournalinfo&quot;] | child::*[local-name()=&quot;Hastegrad&quot;] | child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Sporsmal&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Formål&quot;] or child::*[local-name()=&quot;Begrunnelse&quot;] or child::*[local-name()=&quot;TypeJournalinfo&quot;]">
				<th>Formål</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Sporsmal&quot;]))*number(not(child::*[local-name()=&quot;Hastegrad&quot;] | child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Sporsmal&quot;]))*number(not(child::*[local-name()=&quot;Hastegrad&quot;] | child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;Formål&quot;]">
						<xsl:choose>
							<xsl:when test="contains(@S, '9065')"><xsl:call-template name="k-9065"/></xsl:when>
							<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
					<xsl:if test="child::*[local-name()=&quot;Begrunnelse&quot;]">
						<div>
							<b>Begrunnelse:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()=&quot;Begrunnelse&quot;]"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;TypeJournalinfo&quot;]">
						<div>
							<b>Kategori:</b>&#160;
							<xsl:for-each select="child::*[local-name()=&quot;TypeJournalinfo&quot;]">
								<xsl:call-template name="k-9066"/>&#160;
							</xsl:for-each>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Hastegrad&quot;]">
				<th>Hastegrad</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Sporsmal&quot;])-number(boolean(child::*[local-name()=&quot;Formål&quot;] | child::*[local-name()=&quot;Begrunnelse&quot;] | child::*[local-name()=&quot;TypeJournalinfo&quot;]))*2)*number(not(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Sporsmal&quot;])-number(boolean(child::*[local-name()=&quot;Formål&quot;] | child::*[local-name()=&quot;Begrunnelse&quot;] | child::*[local-name()=&quot;TypeJournalinfo&quot;]))*2)*number(not(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;Hastegrad&quot;]">
						<xsl:call-template name="k-9067"/>&#160;
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;FraDato&quot;]">
				<th>Tidsrom</th>
				<td width="{(($std-col)-1-count(child::*[local-name()=&quot;Sporsmal&quot;])-number(boolean(child::*[local-name()=&quot;Formål&quot;] | child::*[local-name()=&quot;Begrunnelse&quot;] | child::*[local-name()=&quot;TypeJournalinfo&quot;]))*2-count(child::*[local-name()=&quot;Hastegrad&quot;])*2)*$std-td}px" colspan="{($std-col)-1-count(child::*[local-name()=&quot;Sporsmal&quot;])-number(boolean(child::*[local-name()=&quot;Formål&quot;] | child::*[local-name()=&quot;Begrunnelse&quot;] | child::*[local-name()=&quot;TypeJournalinfo&quot;]))*2-count(child::*[local-name()=&quot;Hastegrad&quot;])*2}">
					Fra&#160;
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;FraDato&quot;]"/>
					</xsl:call-template>
					&#160;til&#160;
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;TilDato&quot;]">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;FraDato&quot;]"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>d.d.</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Opplysninger til søknad -->
	<xsl:template name="OpplysningerTilSoknad">
		<tr>
			<th>Pasientens egensøknad sendt</th>
			<td>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;EgensoknadSendt&quot;]='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-3)*$std-td}px" colspan="{($std-col)-3}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Info om informasjon som er gitt -->
	<xsl:template name="InfoInformasjonGitt">
		<xsl:for-each select="child::*[local-name()=&quot;InformasjonGitt&quot;]">
			<xsl:call-template name="InformasjonGitt"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om behov for assistert kommunikasjon mv -->
	<xsl:template name="InfoAssistertKommunikasjon">
		<xsl:for-each select="child::*[local-name()=&quot;AssistertKommunikasjon&quot;]">
			<xsl:call-template name="AssistertKommunikasjon"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om IPLOS-relevant informasjon -->
	<xsl:template name="InfoIPLOSrelevantInformasjon">
		<xsl:for-each select="child::*[local-name()=&quot;TidsperiodeDiagnose&quot;]">
			<xsl:call-template name="TidsperiodeDiagnose"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;TidsfestetHendelse&quot;]">
			<xsl:call-template name="TidsfestetHendelse"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om kartlegging av funksjonsnivå -->
	<xsl:template name="InfoKartleggingFunksjonsniva">
		<xsl:for-each select="child::*[local-name()=&quot;SamletVurderingFunksjonsniva&quot;]">
			<xsl:call-template name="SamletVurderingFunksjonsniva"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Ansvarlig&quot;]">
			<xsl:call-template name="Ansvarlig"/>
		</xsl:for-each>
		<xsl:if test="child::*[local-name()=&quot;KartlagtFunksjon&quot;]">
			<tr>
				<th>Kartlagt&#160;funksjon med&#160;vurdering</th>
				<td width="{(($std-col)-1)*$std-td}px" colspan="{($std-col)-1}">
					<xsl:for-each select="child::*[local-name()=&quot;KartlagtFunksjon&quot;]">
						<xsl:call-template name="KartlagtFunksjon"/>
					</xsl:for-each>
				</td>
			</tr>
			<tr>
				<td width="{($std-col)*$std-td}px" colspan="{($std-col)}">
					1 = ingen problem, 2 = ikke behov for bistand/assistanse, 3 = middels behov for bistand/assistanse, 4 = store behov for bistand/assistanse, 5 = fullt bistandsbehov, 9 = ikke relevant
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- Visning av innhold i Eksisterende tjeneste -->
	<xsl:template name="EksisterendeTjeneste">
		<tr>
			<th width="{((($std-col)-1)*number(not(child::*[local-name()=&quot;BetegnelseTjeneste&quot;] | child::*[local-name()=&quot;TjenestenLevertAv&quot;] | child::*[local-name()=&quot;OpplysningerOmTjenesten&quot;] | child::*[local-name()=&quot;PrivatTjeneste&quot;] | child::*[local-name()=&quot;AntallEnheter&quot;] | child::*[local-name()=&quot;Startdato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-1)*number(not(child::*[local-name()=&quot;BetegnelseTjeneste&quot;] | child::*[local-name()=&quot;TjenestenLevertAv&quot;] | child::*[local-name()=&quot;OpplysningerOmTjenesten&quot;] | child::*[local-name()=&quot;PrivatTjeneste&quot;] | child::*[local-name()=&quot;AntallEnheter&quot;] | child::*[local-name()=&quot;Startdato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<xsl:for-each select="child::*[local-name()=&quot;IPLOStjenestetype&quot;]">
					<xsl:choose>
						<xsl:when test="contains(@S, '9151')"><xsl:call-template name="k-9151"/></xsl:when>
						<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</th>
			<xsl:if test="child::*[local-name()=&quot;BetegnelseTjeneste&quot;] or child::*[local-name()=&quot;TjenestenLevertAv&quot;] or child::*[local-name()=&quot;OpplysningerOmTjenesten&quot;] or child::*[local-name()=&quot;PrivatTjeneste&quot;]">
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;AntallEnheter&quot;] | child::*[local-name()=&quot;Startdato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;AntallEnheter&quot;] | child::*[local-name()=&quot;Startdato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:if test="child::*[local-name()=&quot;BetegnelseTjeneste&quot;]">
						<div>
							<b>Betegnelse:&#160;</b>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()=&quot;BetegnelseTjeneste&quot;]"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;OpplysningerOmTjenesten&quot;]">
						<div>
							<b>Opplysninger:&#160;</b>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()=&quot;OpplysningerOmTjenesten&quot;]"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;TjenestenLevertAv&quot;]">
						<div>
							<b>Levert&#160;av:&#160;</b>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()=&quot;TjenestenLevertAv&quot;]"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;PrivatTjeneste&quot;]">
						<div>
							<xsl:if test="child::*[local-name()=&quot;PrivatTjeneste&quot;]='true'">Privat&#160;tjeneste</xsl:if>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;AntallEnheter&quot;]">
				<th>Antall</th>
				<td width="{((($std-col)-3-number(boolean(child::*[local-name()=&quot;PrivatTjeneste&quot;] | child::*[local-name()=&quot;TjenestenLevertAv&quot;] | child::*[local-name()=&quot;OpplysningerOmTjenesten&quot;])))*number(not(child::*[local-name()=&quot;Startdato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-number(boolean(child::*[local-name()=&quot;PrivatTjeneste&quot;] | child::*[local-name()=&quot;TjenestenLevertAv&quot;] | child::*[local-name()=&quot;OpplysningerOmTjenesten&quot;])))*number(not(child::*[local-name()=&quot;Startdato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:value-of select="child::*[local-name()=&quot;AntallEnheter&quot;]"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;Enhet&quot;]"/>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Startdato&quot;]">
				<th>Tidsrom</th>
				<td width="{((($std-col)-3-number(boolean(child::*[local-name()=&quot;PrivatTjeneste&quot;] | child::*[local-name()=&quot;TjenestenLevertAv&quot;] | child::*[local-name()=&quot;OpplysningerOmTjenesten&quot;]))-count(child::*[local-name()=&quot;AntallEnheter&quot;])*2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-number(boolean(child::*[local-name()=&quot;PrivatTjeneste&quot;] | child::*[local-name()=&quot;TjenestenLevertAv&quot;] | child::*[local-name()=&quot;OpplysningerOmTjenesten&quot;]))-count(child::*[local-name()=&quot;AntallEnheter&quot;])*2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
					Fra&#160;
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;Startdato&quot;]"/>
					</xsl:call-template>
					&#160;til&#160;
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;Sluttdato&quot;]">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;Sluttdato&quot;]"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>d.d.</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-2-number(boolean(child::*[local-name()=&quot;PrivatTjeneste&quot;] | child::*[local-name()=&quot;TjenestenLevertAv&quot;] | child::*[local-name()=&quot;OpplysningerOmTjenesten&quot;]))-count(child::*[local-name()=&quot;AntallEnheter&quot;] | child::*[local-name()=&quot;Startdato&quot;])*2)*$std-td}px" colspan="{($std-col)-2-number(boolean(child::*[local-name()=&quot;PrivatTjeneste&quot;] | child::*[local-name()=&quot;TjenestenLevertAv&quot;] | child::*[local-name()=&quot;OpplysningerOmTjenesten&quot;]))-count(child::*[local-name()=&quot;AntallEnheter&quot;] | child::*[local-name()=&quot;Startdato&quot;])*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Tidsfestet hendelse -->
	<xsl:template name="TidsfestetHendelse">
		<tr>
			<xsl:if test="child::*[local-name()=&quot;Hendelsekode&quot;]">
				<th width="{((($std-col)-1)*number(not(child::*[local-name()=&quot;TidspunktForHendelse&quot;] | child::*[local-name()=&quot;StedForHendelse&quot;] | child::*[local-name()=&quot;BeskrivelseAvHendelse&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-1)*number(not(child::*[local-name()=&quot;TidspunktForHendelse&quot;] | child::*[local-name()=&quot;StedForHendelse&quot;] | child::*[local-name()=&quot;BeskrivelseAvHendelse&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;Hendelsekode&quot;]">
						<xsl:choose>
							<xsl:when test="contains(@S, '9121')">
								<xsl:choose>
									<xsl:when test="@V='13'">
										<div class="viktig">
											<xsl:call-template name="k-9121"/>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="k-9121"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
				</th>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;TidspunktForHendelse&quot;]">
				<th>Tidspunkt</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Hendelsekode&quot;]))*number(not(child::*[local-name()=&quot;StedForHendelse&quot;] | child::*[local-name()=&quot;BeskrivelseAvHendelse&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Hendelsekode&quot;]))*number(not(child::*[local-name()=&quot;StedForHendelse&quot;] | child::*[local-name()=&quot;BeskrivelseAvHendelse&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;TidspunktForHendelse&quot;]/@V"/>
					</xsl:call-template>&#160;
					<xsl:if test="child::*[local-name()=&quot;Anslag&quot;]='true'">(anslagsvis)</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;StedForHendelse&quot;]">
				<th>Sted</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Hendelsekode&quot;])-count(child::*[local-name()=&quot;TidspunktForHendelse&quot;])*2)*number(not(child::*[local-name()=&quot;BeskrivelseAvHendelse&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Hendelsekode&quot;])-count(child::*[local-name()=&quot;TidspunktForHendelse&quot;])*2)*number(not(child::*[local-name()=&quot;BeskrivelseAvHendelse&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;StedForHendelse&quot;]/child::*[local-name()=&quot;StedHendelse&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;BeskrivelseAvHendelse&quot;]">
				<td width="{((($std-col)-1-count(child::*[local-name()=&quot;Hendelsekode&quot;])-count(child::*[local-name()=&quot;TidspunktForHendelse&quot;] | child::*[local-name()=&quot;StedForHendelse&quot;])*2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-1-count(child::*[local-name()=&quot;Hendelsekode&quot;])-count(child::*[local-name()=&quot;TidspunktForHendelse&quot;] | child::*[local-name()=&quot;StedForHendelse&quot;])*2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<b>Beskrivelse:</b>&#160;
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;BeskrivelseAvHendelse&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-1-count(child::*[local-name()=&quot;Hendelsekode&quot;])-count(child::*[local-name()=&quot;BeskrivelseAvHendelse&quot;])-count(child::*[local-name()=&quot;TidspunktForHendelse&quot;] | child::*[local-name()=&quot;StedForHendelse&quot;])*2)*$std-td}px" colspan="{($std-col)-1-count(child::*[local-name()=&quot;Hendelsekode&quot;])-count(child::*[local-name()=&quot;BeskrivelseAvHendelse&quot;])-count(child::*[local-name()=&quot;TidspunktForHendelse&quot;] | child::*[local-name()=&quot;StedForHendelse&quot;])*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Utskrevet til -->
	<xsl:template name="UtskrevetTil">
		<tr>
			<th>Ut&#160;til</th>
			<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Uttilstand&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Uttilstand&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<xsl:for-each select="child::*[local-name()=&quot;UtTil&quot;]">
					<xsl:choose>
						<xsl:when test="contains(@S, '8408')"><xsl:call-template name="k-8408"/></xsl:when>
						<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</td>
			<xsl:if test="child::*[local-name()=&quot;Uttilstand&quot;]">
				<th>Uttilstand</th>
				<td width="{((($std-col)-4)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-4)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<xsl:for-each select="child::*[local-name()=&quot;Uttilstand&quot;]">
					<xsl:choose>
						<xsl:when test="contains(@S, '8431')">
							<xsl:choose>
								<xsl:when test="@V='2'">
									<div class="viktig">
										<xsl:call-template name="k-8431"/>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="k-8431"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-3-count(child::*[local-name()=&quot;Uttilstand&quot;])*2)*$std-td}px" colspan="{($std-col)-3-count(child::*[local-name()=&quot;Uttilstand&quot;])*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Avtale om adm. av legemidler -->
	<xsl:template name="AvtaleOmAdmLegemidler">
		<tr>
			<th>Avtale&#160;om&#160;adm.&#160;av&#160;legemidler</th>
			<td>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;AvtaleAdmLegemidler&quot;]='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
			<td width="{((($std-col)-3)*number(not(child::*[local-name()=&quot;AdmInstrukser&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3)*number(not(child::*[local-name()=&quot;AdmInstrukser&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<b>Avtale&#160;om adm.&#160;av&#160;multidose:</b>&#160;
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;AvtaleAdmMultidose&quot;]='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="child::*[local-name()=&quot;AdmInstrukser&quot;]">
				<th>Adm.&#160;instrukser</th>
				<td width="{((($std-col)-5)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-5)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<div>
						<xsl:for-each select="child::*[local-name()=&quot;AdmInstrukser&quot;]/child::*[local-name()=&quot;Utleveringsform&quot;]">
							<xsl:call-template name="k-9135"/>&#160;
						</xsl:for-each>
					</div>
					<div>
						<xsl:for-each select="child::*[local-name()=&quot;AdmInstrukser&quot;]/child::*[local-name()=&quot;SarskilteTiltak&quot;]">
							<xsl:call-template name="k-9136"/>&#160;
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-4-count(child::*[local-name()=&quot;AdmInstrukser&quot;])*2)*$std-td}px" colspan="{($std-col)-4-count(child::*[local-name()=&quot;AdmInstrukser&quot;])*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;Tiltaksbeskrivelse&quot;]">
			<xsl:call-template name="Tiltaksbeskrivelse"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Medisinskfaglige opplysninger -->
	<xsl:template name="MedisinskfagligeOpplysninger">
		<xsl:for-each select="child::*[local-name()=&quot;Cave&quot;]">
			<xsl:call-template name="Cave"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Allerginotat&quot;]">
			<xsl:call-template name="Allerginotat"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;InfoTidligereSykdommer&quot;]">
			<xsl:call-template name="InfoTidligereSykdommer"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;GenereltJournalnotat&quot;]">
			<xsl:call-template name="GenereltJournalnotat"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;RegistrertBlodtype&quot;]">
			<xsl:call-template name="RegistrertBlodtype"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Sykepleierdokumentasjon -->
	<xsl:template name="Sykepleierdokumentasjon">
		<xsl:for-each select="child::*[local-name()=&quot;InfoFraSykepleier&quot;]">
			<xsl:call-template name="InfoFraSykepleier"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;InfoAvtaleOmLegemiddeladm&quot;]">
			<xsl:call-template name="InfoAvtaleOmLegemiddeladm"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;InfoVurderinger&quot;]">
			<xsl:call-template name="InfoVurderinger"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;IverksatteTiltak&quot;]">
			<xsl:call-template name="IverksatteTiltak"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;AnbefaltVidereTiltak&quot;]">
			<xsl:call-template name="AnbefaltVidereTiltak"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;InfoMaalForventetRes&quot;]">
			<xsl:call-template name="InfoMaalForventetRes"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Ansvarlig&quot;]">
			<xsl:call-template name="Ansvarlig"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om medisinsk diagnose -->
	<xsl:template name="InfoMedisinskDiagnose">
		<xsl:for-each select="child::*[local-name()=&quot;MedisinskDiagnose&quot;]">
			<xsl:call-template name="MedisinskDiagnose"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om kontaktepisode -->
	<xsl:template name="InfoKontaktepisode">
		<tr>
			<xsl:for-each select="child::*[local-name()=&quot;FellesinfoKontaktepisode&quot;]">
				<th>
					<xsl:for-each select="child::*[local-name()=&quot;Kontakttype&quot;]">
						<xsl:choose>
							<xsl:when test="contains(@S, '8432')"><xsl:call-template name="k-8432"/></xsl:when>
							<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
				</th>
				<xsl:if test="child::*[local-name()=&quot;Konsultasjonsform&quot;]">
					<td>
						<b>Konsultasjonsform:</b>&#160;
						<xsl:for-each select="child::*[local-name()=&quot;Konsultasjonsform&quot;]">
							<xsl:call-template name="k-dummy"/>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<th>Startet</th>
				<td width="{((($std-col)-3-count(child::*[local-name()=&quot;Konsultasjonsform&quot;]))*number(not(child::*[local-name()=&quot;Merknad&quot;] | ../child::*[local-name()=&quot;TilleggsinfoKontaktepisode&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-count(child::*[local-name()=&quot;Konsultasjonsform&quot;]))*number(not(child::*[local-name()=&quot;Merknad&quot;] | ../child::*[local-name()=&quot;TilleggsinfoKontaktepisode&quot;]))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;KontaktStartet&quot;]/@V"/>
					</xsl:call-template>&#160;
					<xsl:if test="child::*[local-name()=&quot;KontaktAvsluttet&quot;]">
						Avsluttet:&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;KontaktAvsluttet&quot;]/@V"/>
						</xsl:call-template>&#160;
					</xsl:if>
				</td>
				<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
					<th>Merknad</th>
					<td width="{((($std-col)-5-count(child::*[local-name()=&quot;Konsultasjonsform&quot;]))*number(not(child::*[local-name()=&quot;Merknad&quot;] | ../child::*[local-name()=&quot;TilleggsinfoKontaktepisode&quot;]))+1)*$std-td}px" colspan="{(($std-col)-5-count(child::*[local-name()=&quot;Konsultasjonsform&quot;]))*number(not(child::*[local-name()=&quot;Merknad&quot;] | ../child::*[local-name()=&quot;TilleggsinfoKontaktepisode&quot;]))+1}">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="child::*[local-name()=&quot;TilleggsinfoKontaktepisode&quot;]">
				<th>Sted</th>
				<td width="{(($std-col)-4-count(../child::*[local-name()=&quot;FellesinfoKontaktepisode&quot;]/child::*[local-name()=&quot;Konsultasjonsform&quot;])-count(../child::*[local-name()=&quot;FellesinfoKontaktepisode&quot;]/child::*[local-name()=&quot;Merknad&quot;])*2)*$std-td}px" colspan="{($std-col)-4-count(../child::*[local-name()=&quot;FellesinfoKontaktepisode&quot;]/child::*[local-name()=&quot;Konsultasjonsform&quot;])-count(../child::*[local-name()=&quot;FellesinfoKontaktepisode&quot;]/child::*[local-name()=&quot;Merknad&quot;])*2}">
					<xsl:if test="child::*[local-name()=&quot;StedForKontaktepisode&quot;]">
						<div>
							<xsl:for-each select="child::*[local-name()=&quot;StedForKontaktepisode&quot;]">
								<xsl:choose>
									<xsl:when test="contains(@S, '8434')"><xsl:call-template name="k-8434"/></xsl:when>
									<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
								</xsl:choose>&#160;
							</xsl:for-each>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;StedForKontakt&quot;]">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()=&quot;StedForKontakt&quot;]"/>
						</xsl:call-template>
					</xsl:if>
				</td>
			</xsl:for-each>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Info om kontaktepisode -->
	<xsl:template name="InfoReservasjon">
		<xsl:for-each select="child::*[local-name()=&quot;ReservasjonOnske&quot;]">
			<xsl:call-template name="ReservasjonOnske"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om andre viktige opplysninger -->
	<xsl:template name="InfoAndreViktigeOpplysninger">
		<xsl:for-each select="child::*[local-name()=&quot;GenereltJournalnotat&quot;]">
			<xsl:call-template name="GenereltJournalnotat"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;Allerginotat&quot;]">
			<xsl:call-template name="Allerginotat"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Opplysninger fra andre faggrupper -->
	<xsl:template name="OpplysningerAndreFaggrupper">
		<xsl:for-each select="child::*[local-name()=&quot;AndreFagrapporter&quot;]">
			<xsl:call-template name="AndreFagrapporter"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;AnbefaltVidereTiltak&quot;]">
			<xsl:call-template name="AnbefaltVidereTiltak"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;InfoVurderinger&quot;]">
			<xsl:call-template name="InfoVurderinger"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Opplysninger om opphold -->
	<xsl:template name="OpplysningOpphold">
		<xsl:for-each select="child::*[local-name()=&quot;TidsfestetHendelse&quot;]">
			<xsl:call-template name="TidsfestetHendelse"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om kontrolltime -->
	<xsl:template name="InfoKontrolltime">
		<xsl:for-each select="child::*[local-name()=&quot;InformasjonOmTime&quot;]">
			<xsl:call-template name="InformasjonOmTime"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;KontrolltimeBestill&quot;]">
			<xsl:call-template name="KontrolltimeBestill"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;InformasjonOmTentativTime&quot;]">
			<xsl:call-template name="InformasjonOmTentativTime"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Opplysninger om hjelpemidler -->
	<xsl:template name="OpplysningerOmHjelpemidler">
		<xsl:for-each select="child::*[local-name()=&quot;FasteHjelpemidler&quot;]">
			<xsl:call-template name="FasteHjelpemidler"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;StatusHjelpemiddel&quot;]">
			<xsl:call-template name="StatusHjelpemiddel"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Behov for tjeneste -->
	<xsl:template name="TjenesteBehov">
		<tr>
			<th width="{((($std-col)-1)*number(not(child::*[local-name()=&quot;VedInstitusjon&quot;] | child::*[local-name()=&quot;BeskrivelseAvTjeneste&quot;] | child::*[local-name()=&quot;AntallEnheterOnsket&quot;]))+1)*$std-td}px" colspan="{(($std-col)-1)*number(not(child::*[local-name()=&quot;VedInstitusjon&quot;] | child::*[local-name()=&quot;BeskrivelseAvTjeneste&quot;] | child::*[local-name()=&quot;AntallEnheterOnsket&quot;]))+1}">
				<xsl:for-each select="child::*[local-name()=&quot;IPLOStjenestetype&quot;]">
					<xsl:choose>
						<xsl:when test="contains(@S, '9151')"><xsl:call-template name="k-9151"/></xsl:when>
						<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
				<xsl:if test="not(child::*[local-name()=&quot;IPLOStjenestetype&quot;]) and child::*[local-name()=&quot;BetegnelseTjeneste&quot;]">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;BetegnelseTjeneste&quot;]"/>
					</xsl:call-template>
				</xsl:if>
			</th>
			<xsl:if test="child::*[local-name()=&quot;VedInstitusjon&quot;]">
				<th>Ønsket&#160;institusjon</th>
				<td width="{((($std-col)-3)*number(not(child::*[local-name()=&quot;BeskrivelseAvTjeneste&quot;] | child::*[local-name()=&quot;AntallEnheterOnsket&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3)*number(not(child::*[local-name()=&quot;BeskrivelseAvTjeneste&quot;] | child::*[local-name()=&quot;AntallEnheterOnsket&quot;]))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;VedInstitusjon&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;BeskrivelseAvTjeneste&quot;]">
				<th>Beskrivelse</th>
				<td width="{((($std-col)-3-count(child::*[local-name()=&quot;VedInstitusjon&quot;])*2)*number(not(child::*[local-name()=&quot;AntallEnheterOnsket&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-count(child::*[local-name()=&quot;VedInstitusjon&quot;])*2)*number(not(child::*[local-name()=&quot;AntallEnheterOnsket&quot;]))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;BeskrivelseAvTjeneste&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;AntallEnheterOnsket&quot;]">
				<th>Ønsket&#160;antall</th>
				<td width="{(($std-col)-2-count(child::*[local-name()=&quot;VedInstitusjon&quot;] | child::*[local-name()=&quot;BeskrivelseAvTjeneste&quot;])*2)*$std-td}px" colspan="{($std-col)-2-count(child::*[local-name()=&quot;VedInstitusjon&quot;] | child::*[local-name()=&quot;BeskrivelseAvTjeneste&quot;])*2}">
					<xsl:value-of select="child::*[local-name()=&quot;AntallEnheterOnsket&quot;]"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;Enhet&quot;]"/>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Assistert kommunikasjon -->
	<xsl:template name="AssistertKommunikasjon">
		<tr>
			<xsl:if test="child::*[local-name()=&quot;PersonTolkebehov&quot;]">
				<th>Gjelder&#160;for</th>
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;BehovTolkSprak&quot;] | child::*[local-name()=&quot;PreferertTolk&quot;] | child::*[local-name()=&quot;Horselsvikt&quot;] | child::*[local-name()=&quot;Synsvikt&quot;] | child::*[local-name()=&quot;BehovOpphortDato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;BehovTolkSprak&quot;] | child::*[local-name()=&quot;PreferertTolk&quot;] | child::*[local-name()=&quot;Horselsvikt&quot;] | child::*[local-name()=&quot;Synsvikt&quot;] | child::*[local-name()=&quot;BehovOpphortDato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<div class="No-line-content">
						<xsl:for-each select="child::*[local-name()=&quot;PersonTolkebehov&quot;]">
							<xsl:call-template name="Person"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;BehovTolkSprak&quot;]">
				<th>Språk</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;PersonTolkebehov&quot;])*2)*number(not(child::*[local-name()=&quot;PreferertTolk&quot;] | child::*[local-name()=&quot;Horselsvikt&quot;] | child::*[local-name()=&quot;Synsvikt&quot;] | child::*[local-name()=&quot;BehovOpphortDato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;PersonTolkebehov&quot;])*2)*number(not(child::*[local-name()=&quot;PreferertTolk&quot;] | child::*[local-name()=&quot;Horselsvikt&quot;] | child::*[local-name()=&quot;Synsvikt&quot;] | child::*[local-name()=&quot;BehovOpphortDato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;BehovTolkSprak&quot;]">
						<xsl:call-template name="k-3303"/>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;PreferertTolk&quot;]">
				<th>Ønsket&#160;tolk</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;PersonTolkebehov&quot;] | child::*[local-name()=&quot;BehovTolkSprak&quot;])*2)*number(not(child::*[local-name()=&quot;Horselsvikt&quot;] | child::*[local-name()=&quot;Synsvikt&quot;] | child::*[local-name()=&quot;BehovOpphortDato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;PersonTolkebehov&quot;] | child::*[local-name()=&quot;BehovTolkSprak&quot;])*2)*number(not(child::*[local-name()=&quot;Horselsvikt&quot;] | child::*[local-name()=&quot;Synsvikt&quot;] | child::*[local-name()=&quot;BehovOpphortDato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<div class="No-line-content">
						<xsl:for-each select="child::*[local-name()=&quot;PreferertTolk&quot;]">
							<xsl:call-template name="Person"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Horselsvikt&quot;] or child::*[local-name()=&quot;Synsvikt&quot;] or child::*[local-name()=&quot;BehovOpphortDato&quot;] or child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-1-count(child::*[local-name()=&quot;PersonTolkebehov&quot;] | child::*[local-name()=&quot;BehovTolkSprak&quot;]| child::*[local-name()=&quot;PreferertTolk&quot;])*2)*$std-td}px" colspan="{($std-col)-1-count(child::*[local-name()=&quot;PersonTolkebehov&quot;] | child::*[local-name()=&quot;BehovTolkSprak&quot;]| child::*[local-name()=&quot;PreferertTolk&quot;])*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
					<xsl:if test="child::*[local-name()=&quot;Horselsvikt&quot;]='true' or child::*[local-name()=&quot;Synsvikt&quot;]='true' or child::*[local-name()=&quot;BehovOpphortDato&quot;]">
						<div>
							<xsl:if test="child::*[local-name()=&quot;Horselsvikt&quot;]='true'">
								<b>Hørselsvikt:</b>&#160;Ja&#160;
							</xsl:if>
							<xsl:if test="child::*[local-name()=&quot;Synsvikt&quot;]='true'">
								<b>Synsvikt:</b>&#160;Ja&#160;
							</xsl:if>
						</div>
						<div>
							<xsl:if test="child::*[local-name()=&quot;BehovOpphortDato&quot;]/@V">
								<b>Behov&#160;opphørte:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;BehovOpphortDato&quot;]/@V"/>
								</xsl:call-template>&#160;
							</xsl:if>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Registrert blodtype -->
	<xsl:template name="RegistrertBlodtype">
		<tr>
			<th>Registrert&#160;blodtype</th>
			<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<xsl:for-each select="child::*[local-name()=&quot;Blodtype&quot;]"><xsl:value-of select="@V"/></xsl:for-each>
				<xsl:for-each select="child::*[local-name()=&quot;Rhesusgruppe&quot;]">,&#160;<xsl:value-of select="@V"/></xsl:for-each>
			</td>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-3)*$std-td}px" colspan="{($std-col)-3}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Andre fagrapporter -->
	<xsl:template name="AndreFagrapporter">
		<xsl:variable name="kol" select="number(boolean(child::*[local-name()=&quot;BehandlingStart&quot;] | child::*[local-name()=&quot;StatusInnleggelse&quot;] | child::*[local-name()=&quot;StatusBehandlingsstart&quot;] | child::*[local-name()=&quot;ForventetStatusUtskriving&quot;]))+count(child::*[local-name()=&quot;AnsvarligRapport&quot;])*2+1"/>
		<xsl:variable name="rad" select="count(.//child::*[local-name()=&quot;Journaltekst&quot;])"/>
		<tr>
			<th rowspan="{($rad)}">Fagrapport</th>
			<xsl:if test="child::*[local-name()=&quot;BehandlingStart&quot;] or child::*[local-name()=&quot;StatusInnleggelse&quot;] or child::*[local-name()=&quot;StatusBehandlingsstart&quot;] or child::*[local-name()=&quot;ForventetStatusUtskriving&quot;]">
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;AnsvarligRapport&quot;] | child::*[local-name()=&quot;Journaltekst&quot;]))+1)*$std-td}px" rowspan="{($rad)}" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;AnsvarligRapport&quot;] | child::*[local-name()=&quot;Journaltekst&quot;]))+1}">
					<xsl:if test="child::*[local-name()=&quot;BehandlingStart&quot;]">
						<div>
							<b>Behandlingstart:</b>&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;BehandlingStart&quot;]"/>
							</xsl:call-template>&#160;
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;StatusInnleggelse&quot;]">
						<div>
							<b>Status&#160;innleggelse:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()=&quot;StatusInnleggelse&quot;]"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;StatusBehandlingsstart&quot;]">
						<div>
							<b>Status&#160;behandlingsstart:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()=&quot;StatusBehandlingsstart&quot;]"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;ForventetStatusUtskriving&quot;]">
						<div>
							<b>Forventet&#160;status&#160;utskriving:</b>&#160;
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()=&quot;ForventetStatusUtskriving&quot;]"/>
							</xsl:call-template>
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;AnsvarligRapport&quot;]">
				<th rowspan="{($rad)}">Ansvarlig</th>
				<td width="{((($std-col)-3-number(boolean(child::*[local-name()=&quot;BehandlingStart&quot;] | child::*[local-name()=&quot;StatusInnleggelse&quot;] | child::*[local-name()=&quot;StatusBehandlingsstart&quot;] | child::*[local-name()=&quot;ForventetStatusUtskriving&quot;])))*number(not(child::*[local-name()=&quot;Journaltekst&quot;]))+1)*$std-td}px" rowspan="{($rad)}" colspan="{(($std-col)-3-number(boolean(child::*[local-name()=&quot;BehandlingStart&quot;] | child::*[local-name()=&quot;StatusInnleggelse&quot;] | child::*[local-name()=&quot;StatusBehandlingsstart&quot;] | child::*[local-name()=&quot;ForventetStatusUtskriving&quot;])))*number(not(child::*[local-name()=&quot;Journaltekst&quot;]))+1}">
					<div class="No-line-content">
						<xsl:for-each select="child::*[local-name()=&quot;AnsvarligRapport&quot;]">
							<xsl:call-template name="HealthcareProfessional"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<xsl:for-each select="child::*[local-name()=&quot;Journaltekst&quot;]">
				<xsl:if test="position()=1">
				<xsl:call-template name="Journaltekst"><xsl:with-param name="antKolonner" select="$kol"/></xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;Journaltekst&quot;]">
			<xsl:if test="position()!=1">
				<xsl:call-template name="Journaltekst"><xsl:with-param name="antKolonner" select="$kol"/></xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om tidligere sykdommer -->
	<xsl:template name="InfoTidligereSykdommer">
		<xsl:variable name="rad" select="1+count(child::*[local-name()=&quot;Journaltekst&quot;])"/>
		<tr>
			<th rowspan="{$rad}">Tidligere&#160;sykdom<div>
					<xsl:for-each select="child::*[local-name()=&quot;TidligereSykdomFragment&quot;]/child::*[local-name()=&quot;Diagnosekode&quot;]">
						&#160;<xsl:value-of select="@V"/>&#160;
						<xsl:if test="contains(@S, '7170')">(ICPC)</xsl:if>
						<xsl:if test="contains(@S, '7110')">(ICD-10)</xsl:if>
					</xsl:for-each>
				</div>
			</th>
			<xsl:for-each select="child::*[local-name()=&quot;TidligereSykdomFragment&quot;]">
				<xsl:if test="child::*[local-name()=&quot;Diagnosekode&quot;]">
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;FunksjonshemmingKroniskSykdom&quot;] | child::*[local-name()=&quot;TidligereSykdom&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;FunksjonshemmingKroniskSykdom&quot;] | child::*[local-name()=&quot;TidligereSykdom&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Diagnosekode&quot;]">
							<xsl:call-template name="k-dummy"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;FunksjonshemmingKroniskSykdom&quot;]">
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Diagnosekode&quot;]))*number(not(child::*[local-name()=&quot;TidligereSykdom&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Diagnosekode&quot;]))*number(not(child::*[local-name()=&quot;TidligereSykdom&quot;]))+1}">
						<xsl:if test="child::*[local-name()=&quot;FunksjonshemmingKroniskSykdom&quot;]='true'">Gjelder funksjonshemming/kronisk sykdom</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;TidligereSykdom&quot;]">
					<th>Stikkord/beskrivelse</th>
					<td width="{(($std-col)-2-count(child::*[local-name()=&quot;Diagnosekode&quot;] | child::*[local-name()=&quot;FunksjonshemmingKroniskSykdom&quot;]))*$std-td}px" colspan="{($std-col)-2-count(child::*[local-name()=&quot;Diagnosekode&quot;] | child::*[local-name()=&quot;FunksjonshemmingKroniskSykdom&quot;])}">
						<xsl:for-each select="child::*[local-name()=&quot;TidligereSykdom&quot;]">
							<xsl:if test="position()!=1">,&#160;</xsl:if>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</td>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select="child::*[local-name()=&quot;Journaltekst&quot;]">
			<tr>
				<xsl:call-template name="Journaltekst"><xsl:with-param name="antKolonner" select="1"/></xsl:call-template>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info fra sykepleier -->
	<xsl:template name="InfoFraSykepleier">
		<tr>
			<xsl:for-each select="child::*[local-name()=&quot;OpplysningerRelevantOppfolging&quot;]">
				<xsl:if test="child::*[local-name()=&quot;EndringFunksjonsnivaa&quot;]">
					<th>Endring&#160;i funksjonsnivå</th>
					<td width="{((($std-col)-3)*number(not(child::*[local-name()=&quot;BandasjemateriellEngangsutstyr&quot;] | child::*[local-name()=&quot;HjelpLegemiddeladm&quot;] | child::*[local-name()=&quot;MerknadTilBandasjemateriell&quot;] | child::*[local-name()=&quot;MerknadTilLegemiddeladministrering&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3)*number(not(child::*[local-name()=&quot;BandasjemateriellEngangsutstyr&quot;] | child::*[local-name()=&quot;HjelpLegemiddeladm&quot;] | child::*[local-name()=&quot;MerknadTilBandasjemateriell&quot;] | child::*[local-name()=&quot;MerknadTilLegemiddeladministrering&quot;]))+1}">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()=&quot;EndringFunksjonsnivaa&quot;]"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;BandasjemateriellEngangsutstyr&quot;]">
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;EndringFunksjonsnivaa&quot;])*2)*number(not(child::*[local-name()=&quot;MerknadTilBandasjemateriell&quot;] | child::*[local-name()=&quot;HjelpLegemiddeladm&quot;] | child::*[local-name()=&quot;MerknadTilLegemiddeladministrering&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;EndringFunksjonsnivaa&quot;])*2)*number(not(child::*[local-name()=&quot;MerknadTilBandasjemateriell&quot;] | child::*[local-name()=&quot;HjelpLegemiddeladm&quot;] | child::*[local-name()=&quot;MerknadTilLegemiddeladministrering&quot;]))+1}">
						Bandasjemateriell og engangsutstyr er <xsl:if test="child::*[local-name()=&quot;BandasjemateriellEngangsutstyr&quot;]='false'">ikke </xsl:if>sendt med pasienten
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;MerknadTilBandasjemateriell&quot;]">
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;EndringFunksjonsnivaa&quot;])*2-count(child::*[local-name()=&quot;BandasjemateriellEngangsutstyr&quot;]))*number(not(child::*[local-name()=&quot;HjelpLegemiddeladm&quot;] | child::*[local-name()=&quot;MerknadTilLegemiddeladministrering&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;EndringFunksjonsnivaa&quot;])*2-count(child::*[local-name()=&quot;BandasjemateriellEngangsutstyr&quot;]))*number(not(child::*[local-name()=&quot;HjelpLegemiddeladm&quot;] | child::*[local-name()=&quot;MerknadTilLegemiddeladministrering&quot;]))+1}">
						<b>Merknad:</b>&#160;
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()=&quot;MerknadTilBandasjemateriell&quot;]"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;HjelpLegemiddeladm&quot;]">
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;EndringFunksjonsnivaa&quot;])*2-count(child::*[local-name()=&quot;BandasjemateriellEngangsutstyr&quot;] | child::*[local-name()=&quot;MerknadTilBandasjemateriell&quot;]))*number(not(child::*[local-name()=&quot;MerknadTilLegemiddeladministrering&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;EndringFunksjonsnivaa&quot;])*2-count(child::*[local-name()=&quot;BandasjemateriellEngangsutstyr&quot;] | child::*[local-name()=&quot;MerknadTilBandasjemateriell&quot;]))*number(not(child::*[local-name()=&quot;MerknadTilLegemiddeladministrering&quot;]))+1}">
						Pasienten trenger <xsl:if test="child::*[local-name()=&quot;HjelpLegemiddeladm&quot;]='false'">ikke </xsl:if>hjelp til legemiddeladministrering
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;MerknadTilLegemiddeladministrering&quot;]">
					<td width="{(($std-col)-1-count(child::*[local-name()=&quot;EndringFunksjonsnivaa&quot;])*2-count(child::*[local-name()=&quot;BandasjemateriellEngangsutstyr&quot;] | child::*[local-name()=&quot;MerknadTilBandasjemateriell&quot;] | child::*[local-name()=&quot;HjelpLegemiddeladm&quot;]))*$std-td}px" colspan="{($std-col)-1-count(child::*[local-name()=&quot;EndringFunksjonsnivaa&quot;])*2-count(child::*[local-name()=&quot;BandasjemateriellEngangsutstyr&quot;] | child::*[local-name()=&quot;MerknadTilBandasjemateriell&quot;] | child::*[local-name()=&quot;HjelpLegemiddeladm&quot;])}">
						<b>Merknad:</b>&#160;
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()=&quot;MerknadTilLegemiddeladministrering&quot;]"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select=".//child::*[local-name()=&quot;Journaltekst&quot;]">
			<tr>
				<xsl:call-template name="Journaltekst"><xsl:with-param name="antKolonner" select="0"/></xsl:call-template>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Informasjon om bestilt time -->
	<xsl:template name="InformasjonOmTime">
		<tr>
			<th>Informasjon&#160;om bestilt&#160;time</th>
			<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;StedTime&quot;] | child::*[local-name()=&quot;TidspunktTime&quot;] | child::*[local-name()=&quot;Varighet&quot;] | child::*[local-name()=&quot;InformertOm&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;StedTime&quot;] | child::*[local-name()=&quot;TidspunktTime&quot;] | child::*[local-name()=&quot;Varighet&quot;] | child::*[local-name()=&quot;InformertOm&quot;]))+1}">
				Bestilt:&#160;
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;BestiltKontrolltime&quot;]='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="child::*[local-name()=&quot;StedTime&quot;]">
				<th>Sted</th>
				<td width="{((($std-col)-4)*number(not(child::*[local-name()=&quot;TidspunktTime&quot;] | child::*[local-name()=&quot;Varighet&quot;] | child::*[local-name()=&quot;InformertOm&quot;]))+1)*$std-td}px" colspan="{(($std-col)-4)*number(not(child::*[local-name()=&quot;TidspunktTime&quot;] | child::*[local-name()=&quot;Varighet&quot;] | child::*[local-name()=&quot;InformertOm&quot;]))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;StedTime&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;TidspunktTime&quot;] or child::*[local-name()=&quot;Varighet&quot;]">
				<th>
					<xsl:if test="child::*[local-name()=&quot;TidspunktTime&quot;]">Tidspunkt</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;TidspunktTime&quot;] and child::*[local-name()=&quot;Varighet&quot;]">&#160;og&#160;varighet</xsl:if>
					<xsl:if test="not(child::*[local-name()=&quot;TidspunktTime&quot;]) and child::*[local-name()=&quot;Varighet&quot;]">Varighet</xsl:if>
				</th>
				<td width="{((($std-col)-4-count(child::*[local-name()=&quot;StedTime&quot;])*2)*number(not(child::*[local-name()=&quot;InformertOm&quot;]))+1)*$std-td}px" colspan="{(($std-col)-4-count(child::*[local-name()=&quot;StedTime&quot;])*2)*number(not(child::*[local-name()=&quot;InformertOm&quot;]))+1}">
					<xsl:if test="child::*[local-name()=&quot;TidspunktTime&quot;]">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;TidspunktTime&quot;]"/>
						</xsl:call-template>&#160;
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;Varighet&quot;]">
						<xsl:value-of select="child::*[local-name()=&quot;Varighet&quot;]"/>minutter&#160;
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;InformertOm&quot;]">
				<th>Informert</th>
				<td width="{(($std-col)-3-count(child::*[local-name()=&quot;StedTime&quot;])*2-number(boolean(child::*[local-name()=&quot;TidspunktTime&quot;] | child::*[local-name()=&quot;Varighet&quot;]))*2)*$std-td}px" colspan="{($std-col)-3-count(child::*[local-name()=&quot;StedTime&quot;])*2-number(boolean(child::*[local-name()=&quot;TidspunktTime&quot;] | child::*[local-name()=&quot;Varighet&quot;]))*2}">
					<div>Pasient:&#160;
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;InformertOm&quot;]/child::*[local-name()=&quot;PasientInformert&quot;]='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
					<div>Pårørende:&#160;
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;InformertOm&quot;]/child::*[local-name()=&quot;ParorendeInformert&quot;]='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Kontrolltime skal bestilles -->
	<xsl:template name="KontrolltimeBestill">
		<tr>
			<th>Kontrolltime skal&#160;bestilles</th>
			<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;InformertOm&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;InformertOm&quot;]))+1}">
				Bestilles&#160;av&#160;pasient/pårørende:&#160;
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;PasientParorendeBestiller&quot;]='true'">Ja</xsl:when>
					<xsl:otherwise>Nei</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="child::*[local-name()=&quot;InformertOm&quot;]">
				<th>Informert</th>
				<td width="{(($std-col)-3)*$std-td}px" colspan="{($std-col)-3}">
					<div>Pasient:&#160;
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;InformertOm&quot;]/child::*[local-name()=&quot;PasientInformert&quot;]='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
					<div>Pårørende:&#160;
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;InformertOm&quot;]/child::*[local-name()=&quot;ParorendeInformert&quot;]='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Informasjon om tentativ kontrolltime -->
	<xsl:template name="InformasjonOmTentativTime">
		<tr>
			<th>Informasjon&#160;om tentativ&#160;kontrolltime</th>
			<xsl:if test="po.TentativtTidspunktTime">
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;StedTime&quot;] | child::*[local-name()=&quot;Merknad&quot;] | child::*[local-name()=&quot;InformertOm&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;StedTime&quot;] | child::*[local-name()=&quot;Merknad&quot;] | child::*[local-name()=&quot;InformertOm&quot;]))+1}">
					Tentativt&#160;tidspunkt:&#160;
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;TentativtTidspunktTime&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;StedTime&quot;]">
				<th>Sted</th>
				<td width="{((($std-col)-3-count(child::*[local-name()=&quot;TentativtTidspunktTime&quot;]))*number(not(child::*[local-name()=&quot;Merknad&quot;] | child::*[local-name()=&quot;InformertOm&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-count(child::*[local-name()=&quot;TentativtTidspunktTime&quot;]))*number(not(child::*[local-name()=&quot;Merknad&quot;] | child::*[local-name()=&quot;InformertOm&quot;]))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;StedTime&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{((($std-col)-3-count(child::*[local-name()=&quot;TentativtTidspunktTime&quot;])-count(child::*[local-name()=&quot;StedTime&quot;])*2)*number(not(child::*[local-name()=&quot;InformertOm&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-count(child::*[local-name()=&quot;TentativtTidspunktTime&quot;])-count(child::*[local-name()=&quot;StedTime&quot;])*2)*number(not(child::*[local-name()=&quot;InformertOm&quot;]))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;InformertOm&quot;]">
				<th>Informert</th>
				<td width="{(($std-col)-2-count(child::*[local-name()=&quot;TentativtTidspunktTime&quot;])-count(child::*[local-name()=&quot;StedTime&quot;] | child::*[local-name()=&quot;Merknad&quot;])*2)*$std-td}px" colspan="{($std-col)-2-count(child::*[local-name()=&quot;TentativtTidspunktTime&quot;])-count(child::*[local-name()=&quot;StedTime&quot;] | child::*[local-name()=&quot;Merknad&quot;])*2}">
					<div>Pasient:&#160;
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;InformertOm&quot;]/child::*[local-name()=&quot;PasientInformert&quot;]='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
					<div>Pårørende:&#160;
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;InformertOm&quot;]/child::*[local-name()=&quot;ParorendeInformert&quot;]='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</div>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Kartlagt funksjon -->
	<xsl:template name="KartlagtFunksjon">
		<div>
			<xsl:if test="child::*[local-name()=&quot;Vurdering&quot;]"><xsl:value-of select="child::*[local-name()=&quot;Vurdering&quot;]"/>&#160;-&#160;</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Funksjonsvariabel&quot;]">
				<xsl:for-each select="child::*[local-name()=&quot;Funksjonsvariabel&quot;]">
					<xsl:choose>
						<xsl:when test="contains(@S, '9111')"><xsl:call-template name="k-9111"/></xsl:when>
						<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<b>Merknad</b>
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
				</xsl:call-template>
			</xsl:if>
		</div>
	</xsl:template>
	<!-- Visning av innhold i Informasjon gitt -->
	<xsl:template name="InformasjonGitt">
		<tr>
			<xsl:if test="child::*[local-name()=&quot;TypeInformasjon&quot;]">
				<th>
					<xsl:for-each select="child::*[local-name()=&quot;TypeInformasjon&quot;]">
						<xsl:choose>
							<xsl:when test="contains(@S, '9502')"><xsl:call-template name="k-9502"/></xsl:when>
							<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
						</xsl:choose>&#160;
					</xsl:for-each>
				</th>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;BeskrivelseInformasjon&quot;]">
				<td>
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;BeskrivelseInformasjon&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<th>Gitt&#160;til</th>
			<td>
				<div class="No-line-content">
					<xsl:for-each select="child::*[local-name()=&quot;InformasjonGittTil&quot;]">
						<xsl:call-template name="Person"/>
					</xsl:for-each>
				</div>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;MuntligInformasjon&quot;]='true'">
						<div>Gitt&#160;muntlig:&#160;Ja</div>
					</xsl:when>
					<xsl:when test="child::*[local-name()=&quot;MuntligInformasjon&quot;]='false'">
						<div>Gitt&#160;muntlig:&#160;Nei</div>
					</xsl:when>
				</xsl:choose>
			</td>
			<th>Gitt&#160;av</th>
			<td width="{((($std-col)-4-count(child::*[local-name()=&quot;TypeInformasjon&quot;] | child::*[local-name()=&quot;BeskrivelseInformasjon&quot;]))*number(not(child::*[local-name()=&quot;InformasjonGittDato&quot;]))+1)*$std-td}px" colspan="{(($std-col)-4-count(child::*[local-name()=&quot;TypeInformasjon&quot;] | child::*[local-name()=&quot;BeskrivelseInformasjon&quot;]))*number(not(child::*[local-name()=&quot;InformasjonGittDato&quot;]))+1}">
				<div class="No-line-content">
					<xsl:for-each select="child::*[local-name()=&quot;InformasjonGittAv&quot;]">
						<xsl:call-template name="HealthcareProfessional"/>
					</xsl:for-each>
				</div>
			</td>
			<xsl:if test="child::*[local-name()=&quot;InformasjonGittDato&quot;]">
				<th>Gitt&#160;dato</th>
				<td width="{(($std-col)-5-count(child::*[local-name()=&quot;TypeInformasjon&quot;] | child::*[local-name()=&quot;BeskrivelseInformasjon&quot;]))*$std-td}px" colspan="{($std-col)-5-count(child::*[local-name()=&quot;TypeInformasjon&quot;] | child::*[local-name()=&quot;BeskrivelseInformasjon&quot;])}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;InformasjonGittDato&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Info om avtale om legemiddeladministrering -->
	<xsl:template name="InfoAvtaleOmLegemiddeladm">
		<xsl:for-each select="child::*[local-name()=&quot;AvtaleOmAdmLegemidler&quot;]">
			<xsl:call-template name="AvtaleOmAdmLegemidler"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Ansvarlig -->
	<xsl:template name="Ansvarlig">
		<tr>
			<th>
				Ansvar
				<xsl:for-each select="child::*[local-name()=&quot;TypeHendelse&quot;]">
					:&#160;<xsl:choose>
						<xsl:when test="contains(@S, '9131')"><xsl:call-template name="k-9131"/></xsl:when>
						<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
					</xsl:choose>&#160;
				</xsl:for-each>
			</th>
			<xsl:if test="child::*[local-name()=&quot;AnsvarligTjenesteyter&quot;]">
				<th>Ansvarlig&#160;tjenesteyter</th>
				<td>
					<div class="No-line-content">
						<xsl:for-each select="child::*[local-name()=&quot;AnsvarligTjenesteyter&quot;]">
							<xsl:call-template name="HealthcareProfessional"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Virksomhet&quot;]">
				<th>Virksomhet</th>
				<td>
					<div class="No-line-content">
						<xsl:for-each select="child::*[local-name()=&quot;Virksomhet&quot;]">
							<xsl:call-template name="Organisation"/>
						</xsl:for-each>
					</div>
				</td>
			</xsl:if>
			<td width="{((($std-col)-2-count(child::*[local-name()=&quot;AnsvarligTjenesteyter&quot;] | child::*[local-name()=&quot;Virksomhet&quot;])*2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;AnsvarligTjenesteyter&quot;] | child::*[local-name()=&quot;Virksomhet&quot;])*2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<div>
					<b>Tidspunkt:&#160;</b>
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;TidspunktForHendelse&quot;]"/>
					</xsl:call-template>
				</div>
				<xsl:if test="child::*[local-name()=&quot;Ekstern&quot;]='true'">
					<div>Vurderingen er foretatt av helsepersonell utenfor journalførende virksomheten.</div>
				</xsl:if>
			</td>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-3-count(child::*[local-name()=&quot;AnsvarligTjenesteyter&quot;] | child::*[local-name()=&quot;Virksomhet&quot;])*2)*$std-td}px" colspan="{($std-col)-3-count(child::*[local-name()=&quot;AnsvarligTjenesteyter&quot;] | child::*[local-name()=&quot;Virksomhet&quot;])*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Anbefalt videre tiltak -->
	<xsl:template name="AnbefaltVidereTiltak">
		<xsl:for-each select="child::*[local-name()=&quot;Tiltaksbeskrivelse&quot;]">
			<xsl:call-template name="Tiltaksbeskrivelse"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Reservasjon/ønske -->
	<xsl:template name="ReservasjonOnske">
		<tr>
			<td>
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="child::*[local-name()=&quot;Gjelder&quot;]"/>
				</xsl:call-template>
			</td>
			<th>Framsatt&#160;av</th>
			<td width="{((($std-col)-3)*number(not(child::*[local-name()=&quot;TrukketTilbakeAv&quot;] | child::*[local-name()=&quot;TrukketTilbakeDato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3)*number(not(child::*[local-name()=&quot;TrukketTilbakeAv&quot;] | child::*[local-name()=&quot;TrukketTilbakeDato&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
				<div class="No-line-content">
					<xsl:for-each select="child::*[local-name()=&quot;FramsattAv&quot;]">
						<xsl:call-template name="Person"/>
					</xsl:for-each>
				</div>
				<b>Framsatt:&#160;</b>
				<xsl:call-template name="skrivUtTS">
					<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;FramsattDato&quot;]"/>
				</xsl:call-template>&#160;
			</td>
			<xsl:if test="child::*[local-name()=&quot;TrukketTilbakeAv&quot;] or child::*[local-name()=&quot;TrukketTilbakeDato&quot;]">
				<th>Trukket&#160;tilbake&#160;<xsl:if test="child::*[local-name()=&quot;TrukketTilbakeAv&quot;]">av</xsl:if></th>
				<td width="{((($std-col)-5)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-5)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:if test="child::*[local-name()=&quot;TrukketTilbakeAv&quot;]">
						<div class="No-line-content">
							<xsl:for-each select="child::*[local-name()=&quot;TrukketTilbakeAv&quot;]">
								<xsl:call-template name="Person"/>
							</xsl:for-each>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;TrukketTilbakeAv&quot;]"><b>Trukket&#160;tilbake:&#160;</b></xsl:if>
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;TrukketTilbakeDato&quot;]"/>
					</xsl:call-template>&#160;
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-4-number(boolean(child::*[local-name()=&quot;TrukketTilbakeAv&quot;] | child::*[local-name()=&quot;TrukketTilbakeDato&quot;]))*2)*$std-td}px" colspan="{($std-col)-4-number(boolean(child::*[local-name()=&quot;TrukketTilbakeAv&quot;] | child::*[local-name()=&quot;TrukketTilbakeDato&quot;]))*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Faste hjelpemidler -->
	<xsl:template name="FasteHjelpemidler">
		<tr>
			<xsl:if test="child::*[local-name()=&quot;Briller&quot;]">
				<th>Briller</th>
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;HjelpemiddelHorsel&quot;] | child::*[local-name()=&quot;Pacemaker&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;HjelpemiddelHorsel&quot;] | child::*[local-name()=&quot;Pacemaker&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;Briller&quot;]">
						<xsl:call-template name="k-9113"/>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;HjelpemiddelHorsel&quot;]">
				<th>Hjelpemiddel hørsel</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Briller&quot;])*2)*number(not(child::*[local-name()=&quot;Pacemaker&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Briller&quot;])*2)*number(not(child::*[local-name()=&quot;Pacemaker&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;HjelpemiddelHorsel&quot;]">
						<xsl:call-template name="k-9114"/>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Pacemaker&quot;]">
				<th>Pacemaker</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Briller&quot;] | child::*[local-name()=&quot;HjelpemiddelHorsel&quot;])*2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Briller&quot;] | child::*[local-name()=&quot;HjelpemiddelHorsel&quot;])*2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;Pacemaker&quot;]='true'">Ja</xsl:when>
						<xsl:otherwise>Nei</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<th>Merknad</th>
				<td width="{(($std-col)-1-count(child::*[local-name()=&quot;Briller&quot;] | child::*[local-name()=&quot;HjelpemiddelHorsel&quot;] | child::*[local-name()=&quot;Pacemaker&quot;])*2)*$std-td}px" colspan="{($std-col)-1-count(child::*[local-name()=&quot;Briller&quot;] | child::*[local-name()=&quot;HjelpemiddelHorsel&quot;] | child::*[local-name()=&quot;Pacemaker&quot;])*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Faste hjelpemidler -->
	<xsl:template name="SamletVurderingFunksjonsniva">
		<tr>
			<th>Samlet&#160;vurdering</th>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Pleietyngde&quot;] | child::*[local-name()=&quot;VurderingPleietyngde&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Pleietyngde&quot;] | child::*[local-name()=&quot;VurderingPleietyngde&quot;]))+1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Pleietyngde&quot;]">
				<th>Pleietyngde</th>
				<td width="{((($std-col)-3-count(child::*[local-name()=&quot;Merknad&quot;]))*number(not(child::*[local-name()=&quot;VurderingPleietyngde&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-count(child::*[local-name()=&quot;Merknad&quot;]))*number(not(child::*[local-name()=&quot;VurderingPleietyngde&quot;]))+1}">
					<xsl:value-of select="child::*[local-name()=&quot;Pleietyngde&quot;]"/>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;VurderingPleietyngde&quot;]">
				<th>Vurdering&#160;pleietyngde</th>
				<td width="{(($std-col)-2-count(child::*[local-name()=&quot;Merknad&quot;])-count(child::*[local-name()=&quot;Pleietyngde&quot;])*2)*$std-td}px" colspan="{($std-col)-2-count(child::*[local-name()=&quot;Merknad&quot;])-count(child::*[local-name()=&quot;Pleietyngde&quot;])*2}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()=&quot;VurderingPleietyngde&quot;]"/>
					</xsl:call-template>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Tidsperiode for diagnosen -->
	<xsl:template name="TidsperiodeDiagnose">
		<!-- Start- og sluttdato for diagnosen vises i MedisinskDiagnose-template -->
		<xsl:for-each select="child::*[local-name()=&quot;MedisinskDiagnose&quot;]">
			<xsl:call-template name="MedisinskDiagnose"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om mål/forventet resultat -->
	<xsl:template name="InfoMaalForventetRes">
		<xsl:variable name="rad" select="count(child::*[local-name()=&quot;InnholdMaaldokument&quot;])+count(.//child::*[local-name()=&quot;Journaltekst&quot;])"/>
		<tr>
			<th rowspan="{$rad}">
				Forventet&#160;mål
				<xsl:for-each select="child::*[local-name()=&quot;InnholdMaaldokument&quot;]/child::*[local-name()=&quot;MaalForventetResultat&quot;]">
					:&#160;<xsl:call-template name="k-dummy"/>&#160;
				</xsl:for-each>
			</th>
			<xsl:for-each select="child::*[local-name()=&quot;InnholdMaaldokument&quot;]">
				<xsl:if test="child::*[local-name()=&quot;ForventetGradMaaloppnaaelse&quot;] or child::*[local-name()=&quot;Beskrivelse&quot;] or child::*[local-name()=&quot;ForventesOppnaadd&quot;]">
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;KategoriHelsepersonell&quot;] | child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;] | child::*[local-name()=&quot;Stikkord&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;KategoriHelsepersonell&quot;] | child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;] | child::*[local-name()=&quot;Stikkord&quot;]))+1}">
						<xsl:if test="child::*[local-name()=&quot;Beskrivelse&quot;]">
							<div>
								<b>Beskrivelse:</b>&#160;
								<xsl:call-template name="line-breaks">
									<xsl:with-param name="text" select="child::*[local-name()=&quot;Beskrivelse&quot;]"/>
								</xsl:call-template>
							</div>
						</xsl:if>
						<xsl:if test="child::*[local-name()=&quot;ForventesOppnaadd&quot;]">
							<div>
								<b>Forventes&#160;oppnådd:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;ForventesOppnaadd&quot;]"/>
								</xsl:call-template>&#160;
							</div>
						</xsl:if>
						<xsl:if test="child::*[local-name()=&quot;ForventetGradMaaloppnaaelse&quot;]">
							<div>
								<b>Forventet&#160;grad</b>
								<xsl:for-each select="child::*[local-name()=&quot;ForventetGradMaaloppnaaelse&quot;]">
									:&#160;<xsl:call-template name="k-dummy"/>&#160;
								</xsl:for-each>
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;KategoriHelsepersonell&quot;]">
					<th>Utformet&#160;av</th>
					<td width="{((($std-col)-3-number(boolean(child::*[local-name()=&quot;ForventetGradMaaloppnaaelse&quot;] | child::*[local-name()=&quot;Beskrivelse&quot;] | child::*[local-name()=&quot;ForventesOppnaadd&quot;])))*number(not(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;] | child::*[local-name()=&quot;Stikkord&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-number(boolean(child::*[local-name()=&quot;ForventetGradMaaloppnaaelse&quot;] | child::*[local-name()=&quot;Beskrivelse&quot;] | child::*[local-name()=&quot;ForventesOppnaadd&quot;])))*number(not(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;] | child::*[local-name()=&quot;Stikkord&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;KategoriHelsepersonell&quot;]">
							<xsl:call-template name="k-9060"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;FraDato&quot;] or child::*[local-name()=&quot;TilDato&quot;]">
					<th>Gyldighet</th>
					<td width="{((($std-col)-3-number(boolean(child::*[local-name()=&quot;ForventetGradMaaloppnaaelse&quot;] | child::*[local-name()=&quot;Beskrivelse&quot;] | child::*[local-name()=&quot;ForventesOppnaadd&quot;]))-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2)*number(not(child::*[local-name()=&quot;Stikkord&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-number(boolean(child::*[local-name()=&quot;ForventetGradMaaloppnaaelse&quot;] | child::*[local-name()=&quot;Beskrivelse&quot;] | child::*[local-name()=&quot;ForventesOppnaadd&quot;]))-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2)*number(not(child::*[local-name()=&quot;Stikkord&quot;]))+1}">
						<xsl:if test="child::*[local-name()=&quot;FraDato&quot;]">
							<div>
								<b>Fra:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;FraDato&quot;]"/>
								</xsl:call-template>&#160;
							</div>
						</xsl:if>
						<xsl:if test="child::*[local-name()=&quot;TilDato&quot;]">
							<div>
								<b>Til:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;TilDato&quot;]"/>
								</xsl:call-template>&#160;
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Stikkord&quot;]">
					<th>Stikkord</th>
					<td width="{(($std-col)-2-number(boolean(child::*[local-name()=&quot;ForventetGradMaaloppnaaelse&quot;] | child::*[local-name()=&quot;Beskrivelse&quot;] | child::*[local-name()=&quot;ForventesOppnaadd&quot;]))-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2-number(boolean(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))*2)*$std-td}px" colspan="{($std-col)-2-number(boolean(child::*[local-name()=&quot;ForventetGradMaaloppnaaelse&quot;] | child::*[local-name()=&quot;Beskrivelse&quot;] | child::*[local-name()=&quot;ForventesOppnaadd&quot;]))-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2-number(boolean(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))*2}">
						<xsl:for-each select="child::*[local-name()=&quot;Stikkord&quot;]">
							<xsl:if test="position()!=1">,&#160;</xsl:if>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</td>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select=".//child::*[local-name()=&quot;Journaltekst&quot;]">
			<tr>
				<xsl:call-template name="Journaltekst"><xsl:with-param name="antKolonner" select="1"/></xsl:call-template>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Info om vurderinger -->
	<xsl:template name="InfoVurderinger">
		<xsl:variable name="rad" select="count(child::*[local-name()=&quot;InnholdVurdering&quot;])+count(.//child::*[local-name()=&quot;Enkeltvurdering&quot;])+count(.//child::*[local-name()=&quot;Journaltekst&quot;])"/>
		<tr>
			<th rowspan="{$rad}">
				Vurdering&#160;av:&#160;
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="child::*[local-name()=&quot;InnholdVurdering&quot;]/child::*[local-name()=&quot;VurderingenGjelder&quot;]"/>
				</xsl:call-template>
			</th>
			<xsl:for-each select="child::*[local-name()=&quot;InnholdVurdering&quot;]">
				<xsl:if test="child::*[local-name()=&quot;KategoriHelsepersonell&quot;]">
					<th>Vurdert&#160;av</th>
					<td width="{((($std-col)-3)*number(not(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;] | child::*[local-name()=&quot;Stikkord&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3)*number(not(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;] | child::*[local-name()=&quot;Stikkord&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;KategoriHelsepersonell&quot;]">
							<xsl:call-template name="k-9060"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;FraDato&quot;] or child::*[local-name()=&quot;TilDato&quot;]">
					<th>Gyldighet</th>
					<td width="{((($std-col)-3-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2)*number(not(child::*[local-name()=&quot;Stikkord&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2)*number(not(child::*[local-name()=&quot;Stikkord&quot;]))+1}">
						<xsl:if test="child::*[local-name()=&quot;FraDato&quot;]">
							<div>
								<b>Fra:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;FraDato&quot;]"/>
								</xsl:call-template>&#160;
							</div>
						</xsl:if>
						<xsl:if test="child::*[local-name()=&quot;TilDato&quot;]">
							<div>
								<b>Til:</b>&#160;
								<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;TilDato&quot;]"/>
								</xsl:call-template>&#160;
							</div>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Stikkord&quot;]">
					<th>Stikkord</th>
					<td width="{(($std-col)-2-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2-number(boolean(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))*2)*$std-td}px" colspan="{($std-col)-2-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2-number(boolean(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))*2}">
						<xsl:for-each select="child::*[local-name()=&quot;Stikkord&quot;]">
							<xsl:if test="position()!=1">,&#160;</xsl:if>
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</td>
				</xsl:if>
			</xsl:for-each>
		</tr>
		<xsl:for-each select=".//child::*[local-name()=&quot;Enkeltvurdering&quot;]">
			<tr>
				<xsl:if test="child::*[local-name()=&quot;VurderingTekst&quot;]">
					<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;Funksjonsområde&quot;] | child::*[local-name()=&quot;KodetVurdering&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;Funksjonsområde&quot;] | child::*[local-name()=&quot;KodetVurdering&quot;]))+1}">
						<b>Tekstlig&#160;vurdering:</b>&#160;
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()=&quot;VurderingTekst&quot;]"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Funksjonsområde&quot;]">
					<th>Funksjonsområde</th>
					<td width="{((($std-col)-2-count(child::*[local-name()=&quot;VurderingTekst&quot;]))*number(not(child::*[local-name()=&quot;KodetVurdering&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;VurderingTekst&quot;]))*number(not(child::*[local-name()=&quot;KodetVurdering&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;Funksjonsområde&quot;]">
							<xsl:choose>
								<xsl:when test="contains(@S, '9536')"><xsl:call-template name="k-9536"/></xsl:when>
								<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
							</xsl:choose>&#160;
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;KodetVurdering&quot;]">
					<th>Kodet vurdering</th>
					<td width="{(($std-col)-1-count(child::*[local-name()=&quot;VurderingTekst&quot;])-count(child::*[local-name()=&quot;Funksjonsområde&quot;])*2)*$std-td}px" colspan="{($std-col)-1-count(child::*[local-name()=&quot;VurderingTekst&quot;])-count(child::*[local-name()=&quot;Funksjonsområde&quot;])*2}">
						<xsl:for-each select="child::*[local-name()=&quot;KodetVurdering&quot;]">
							<xsl:value-of select="@V"/>&#160;
							<xsl:if test="contains(@S, '7150')">(NANDA)</xsl:if>
							<xsl:if test="contains(@S, '7140')">(NOC)</xsl:if>
							<xsl:if test="contains(@S, '7130')">(NIC)</xsl:if>
							<xsl:if test="contains(@S, '7250')">(ICF)</xsl:if>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select=".//child::*[local-name()=&quot;Journaltekst&quot;]">
			<tr>
				<xsl:call-template name="Journaltekst"><xsl:with-param name="antKolonner" select="1"/></xsl:call-template>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Iverksatte tiltak -->
	<xsl:template name="IverksatteTiltak">
		<xsl:for-each select="child::*[local-name()=&quot;Tiltaksbeskrivelse&quot;]">
			<xsl:call-template name="Tiltaksbeskrivelse"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Visning av innhold i Medisinsk diagnose -->
	<xsl:template name="MedisinskDiagnose">
		<tr>
			<xsl:if test="child::*[local-name()=&quot;Diagnosekode&quot;]">
				<th>
					<xsl:value-of select="child::*[local-name()=&quot;Diagnosekode&quot;]/@V"/>&#160;
					<xsl:if test="contains(child::*[local-name()=&quot;Diagnosekode&quot;]/@S, '7170')">(ICPC)</xsl:if>
					<xsl:if test="contains(child::*[local-name()=&quot;Diagnosekode&quot;]/@S, '7110')">(ICD-10)</xsl:if>
				</th>
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;DiagnoseBeskrivelse&quot;] |  ../child::*[local-name()=&quot;StartdatoDiagnose&quot;] | ../child::*[local-name()=&quot;SluttdatoDiagnose&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;DiagnoseBeskrivelse&quot;] |  ../child::*[local-name()=&quot;StartdatoDiagnose&quot;] | ../child::*[local-name()=&quot;SluttdatoDiagnose&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;Diagnosekode&quot;]">
						<xsl:call-template name="k-dummy"/>&#160;
					</xsl:for-each>
					<xsl:if test="child::*[local-name()=&quot;Hoveddiagnose&quot;]">
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;Hoveddiagnose&quot;]='true'">(Hoveddiagnose)</xsl:when>
							<xsl:otherwise>(Bidiagnose)</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;DiagnoseBeskrivelse&quot;]">
				<th>Beskrivelse</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Diagnosekode&quot;])*2)*number(not(../child::*[local-name()=&quot;StartdatoDiagnose&quot;] | ../child::*[local-name()=&quot;SluttdatoDiagnose&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Diagnosekode&quot;])*2)*number(not(../child::*[local-name()=&quot;StartdatoDiagnose&quot;] | ../child::*[local-name()=&quot;SluttdatoDiagnose&quot;]))+1}">
					<xsl:if test="child::*[local-name()=&quot;DiagnoseBeskrivelse&quot;]">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()=&quot;DiagnoseBeskrivelse&quot;]"/>
						</xsl:call-template>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="../child::*[local-name()=&quot;StartdatoDiagnose&quot;]">
				<th>Startdato</th>
				<td width="{((($std-col)-2-count(child::*[local-name()=&quot;Diagnosekode&quot;] | child::*[local-name()=&quot;DiagnoseBeskrivelse&quot;])*2)*number(not(../child::*[local-name()=&quot;SluttdatoDiagnose&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2-count(child::*[local-name()=&quot;Diagnosekode&quot;] | child::*[local-name()=&quot;DiagnoseBeskrivelse&quot;])*2)*number(not(../child::*[local-name()=&quot;SluttdatoDiagnose&quot;]))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;StartdatoDiagnose&quot;]"/>
					</xsl:call-template>&#160;
				</td>
			</xsl:if>
			<xsl:if test="../child::*[local-name()=&quot;SluttdatoDiagnose&quot;]">
				<th>Sluttdato</th>
				<td width="{(($std-col)-1-count(child::*[local-name()=&quot;Diagnosekode&quot;] | child::*[local-name()=&quot;DiagnoseBeskrivelse&quot;] | ../child::*[local-name()=&quot;StartdatoDiagnose&quot;])*2)*$std-td}px" colspan="{($std-col)-1-count(child::*[local-name()=&quot;Diagnosekode&quot;] | child::*[local-name()=&quot;DiagnoseBeskrivelse&quot;] | ../child::*[local-name()=&quot;StartdatoDiagnose&quot;])*2}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="../child::*[local-name()=&quot;SluttdatoDiagnose&quot;]"/>
					</xsl:call-template>&#160;
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Status til hjelpemiddel -->
	<xsl:template name="StatusHjelpemiddel">
		<tr>
			<th>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;Hjelpemiddelbeskrivelse&quot;]/child::*[local-name()=&quot;HjelpemiddelkodeRTV&quot;]">
						<xsl:for-each select="child::*[local-name()=&quot;Hjelpemiddelbeskrivelse&quot;]/child::*[local-name()=&quot;HjelpemiddelkodeRTV&quot;]">
							<xsl:call-template name="k-dummy"/>&#160;
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>Betegnelse</xsl:otherwise>
				</xsl:choose>
			</th>
			<td>
				<xsl:call-template name="line-breaks">
					<xsl:with-param name="text" select="child::*[local-name()=&quot;Hjelpemiddelbeskrivelse&quot;]/child::*[local-name()=&quot;BetegnelseHjelpemiddel&quot;]"/>
				</xsl:call-template>
			</td>
			<th>Status</th>
			<td width="{((($std-col)-4)*number(not(child::*[local-name()=&quot;Hjelpemiddelbeskrivelse&quot;]/child::*[local-name()=&quot;Sekvensnummer&quot;]))+1)*$std-td}px" colspan="{(($std-col)-4)*number(not(child::*[local-name()=&quot;Hjelpemiddelbeskrivelse&quot;]/child::*[local-name()=&quot;Sekvensnummer&quot;]))+1}">
				<xsl:for-each select="child::*[local-name()=&quot;Status&quot;]">
					<xsl:call-template name="k-8230"/>
				</xsl:for-each>
			</td>
			<xsl:if test="child::*[local-name()=&quot;Hjelpemiddelbeskrivelse&quot;]/child::*[local-name()=&quot;Sekvensnummer&quot;]">
				<th>Sekvensnummer</th>
				<td width="{(($std-col)-5)*$std-td}px" colspan="{($std-col)-5}">
					<xsl:value-of select="child::*[local-name()=&quot;Hjelpemiddelbeskrivelse&quot;]/child::*[local-name()=&quot;Sekvensnummer&quot;]"/>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!-- Visning av innhold i Tiltaksbeskrivelse -->
	<xsl:template name="Tiltaksbeskrivelse">
		<xsl:variable name="rad" select="1+count(.//child::*[local-name()=&quot;GjennomforingAvTiltak&quot;])+count(child::*[local-name()=&quot;PlanlagtGjennomforingTiltak&quot;])"/>
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
			<xsl:if test="child::*[local-name()=&quot;IntervensjonTiltakBeskrivelse&quot;] or child::*[local-name()=&quot;IntervensjonTiltakKode&quot;]">
				<td width="{((($std-col)-2)*number(not(child::*[local-name()=&quot;KategoriHelsepersonell&quot;] | child::*[local-name()=&quot;Merknad&quot;] | child::*[local-name()=&quot;EvalueringTidspunkt&quot;] | child::*[local-name()=&quot;Stikkord&quot;]))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(child::*[local-name()=&quot;KategoriHelsepersonell&quot;] | child::*[local-name()=&quot;Merknad&quot;] | child::*[local-name()=&quot;EvalueringTidspunkt&quot;] | child::*[local-name()=&quot;Stikkord&quot;]))+1}">
					<xsl:if test="child::*[local-name()=&quot;IntervensjonTiltakBeskrivelse&quot;]">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()=&quot;IntervensjonTiltakBeskrivelse&quot;]"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:for-each select="child::*[local-name()=&quot;IntervensjonTiltakKode&quot;]">
						<div>&#160;-&#160;
							<xsl:choose>
								<xsl:when test="contains(@S, '9132')"><xsl:call-template name="k-9132"/></xsl:when>
								<xsl:otherwise><xsl:call-template name="k-dummy"/></xsl:otherwise>
							</xsl:choose>&#160;
						</div>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;KategoriHelsepersonell&quot;]">
				<th>Utformet&#160;av</th>
				<td width="{((($std-col)-3-number(boolean(child::*[local-name()=&quot;IntervensjonTiltakBeskrivelse&quot;] | child::*[local-name()=&quot;IntervensjonTiltakKode&quot;])))*number(not(child::*[local-name()=&quot;Merknad&quot;] | child::*[local-name()=&quot;EvalueringTidspunkt&quot;] | child::*[local-name()=&quot;Stikkord&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-number(boolean(child::*[local-name()=&quot;IntervensjonTiltakBeskrivelse&quot;] | child::*[local-name()=&quot;IntervensjonTiltakKode&quot;])))*number(not(child::*[local-name()=&quot;Merknad&quot;] | child::*[local-name()=&quot;EvalueringTidspunkt&quot;] | child::*[local-name()=&quot;Stikkord&quot;]))+1}">
					<xsl:for-each select="child::*[local-name()=&quot;KategoriHelsepersonell&quot;]">
						<xsl:call-template name="k-9060"/>
					</xsl:for-each>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Merknad&quot;] or child::*[local-name()=&quot;EvalueringTidspunkt&quot;]">
				<th>Merknad</th>
				<td width="{((($std-col)-3-number(boolean(child::*[local-name()=&quot;IntervensjonTiltakBeskrivelse&quot;] | child::*[local-name()=&quot;IntervensjonTiltakKode&quot;]))-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2)*number(not(child::*[local-name()=&quot;Stikkord&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-number(boolean(child::*[local-name()=&quot;IntervensjonTiltakBeskrivelse&quot;] | child::*[local-name()=&quot;IntervensjonTiltakKode&quot;]))-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2)*number(not(child::*[local-name()=&quot;Stikkord&quot;]))+1}">
					<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
						<div>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
						</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="child::*[local-name()=&quot;EvalueringTidspunkt&quot;]">
						<div>
							<b>Evalueringstidspunkt:</b>&#160;
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;EvalueringTidspunkt&quot;]"/>
							</xsl:call-template>&#160;
						</div>
					</xsl:if>
				</td>
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;Stikkord&quot;]">
				<th>Stikkord</th>
				<td width="{(($std-col)-3-number(boolean(child::*[local-name()=&quot;IntervensjonTiltakBeskrivelse&quot;] | child::*[local-name()=&quot;IntervensjonTiltakKode&quot;]))-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2-number(boolean(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))*2)*$std-td}px" colspan="{($std-col)-3-number(boolean(child::*[local-name()=&quot;IntervensjonTiltakBeskrivelse&quot;] | child::*[local-name()=&quot;IntervensjonTiltakKode&quot;]))-count(child::*[local-name()=&quot;KategoriHelsepersonell&quot;])*2-number(boolean(child::*[local-name()=&quot;FraDato&quot;] | child::*[local-name()=&quot;TilDato&quot;]))*2}">
					<xsl:for-each select="child::*[local-name()=&quot;Stikkord&quot;]">
						<xsl:if test="position()!=1">,&#160;</xsl:if>
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</td>
			</xsl:if>
		</tr>
		<xsl:for-each select=".//child::*[local-name()=&quot;GjennomforingAvTiltak&quot;]">
			<tr>
				<th>Gjennomført tidspunkt</th>
				<td width="{((($std-col)-3)*number(not(child::*[local-name()=&quot;TiltakKanTermineres&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3)*number(not(child::*[local-name()=&quot;TiltakKanTermineres&quot;] | child::*[local-name()=&quot;Merknad&quot;]))+1}">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;UtfortTidspunkt&quot;]"/>
					</xsl:call-template>&#160;
				</td>
				<xsl:if test="child::*[local-name()=&quot;TiltakKanTermineres&quot;]">
					<th>Kan termineres</th>
					<td width="{((($std-col)-3-count(child::*[local-name()=&quot;UtfortTidspunkt&quot;])*2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3-count(child::*[local-name()=&quot;UtfortTidspunkt&quot;])*2)*number(not(child::*[local-name()=&quot;Merknad&quot;]))+1}">
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;TiltakKanTermineres&quot;]='true'">Ja</xsl:when>
							<xsl:otherwise>Nei</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;Merknad&quot;]">
					<th>Merknad</th>
					<td width="{(($std-col)-2-count(child::*[local-name()=&quot;UtfortTidspunkt&quot;] | child::*[local-name()=&quot;TiltakKanTermineres&quot;])*2)*$std-td}px" colspan="{($std-col)-2-count(child::*[local-name()=&quot;UtfortTidspunkt&quot;] | child::*[local-name()=&quot;TiltakKanTermineres&quot;])*2}">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()=&quot;Merknad&quot;]"/>
						</xsl:call-template>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		<xsl:for-each select=".//child::*[local-name()=&quot;PlanlagtGjennomforingTiltak&quot;]">
			<tr>
				<th>Tidsrom</th>
				<td width="{((($std-col)-3)*number(not(child::*[local-name()=&quot;FasteUkedager&quot;] | child::*[local-name()=&quot;GjentagelseIntervall&quot;] | child::*[local-name()=&quot;EtterBehov&quot;]))+1)*$std-td}px" colspan="{(($std-col)-3)*number(not(child::*[local-name()=&quot;FasteUkedager&quot;] | child::*[local-name()=&quot;GjentagelseIntervall&quot;] | child::*[local-name()=&quot;EtterBehov&quot;]))+1}">
					<div>
						<b>Planlagt&#160;start:</b>&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;PlanlagtStart&quot;]"/>
						</xsl:call-template>&#160;
					</div>
					<xsl:if test="child::*[local-name()=&quot;PlanlagtSlutt&quot;]">
						<b>Planlagt&#160;slutt:</b>&#160;
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()=&quot;PlanlagtSlutt&quot;]"/>
						</xsl:call-template>&#160;
					</xsl:if>
				</td>
				<xsl:if test="child::*[local-name()=&quot;FasteUkedager&quot;]">
					<th>Faste&#160;ukedager</th>
					<td width="{((($std-col)-5)*number(not(child::*[local-name()=&quot;GjentagelseIntervall&quot;] | child::*[local-name()=&quot;EtterBehov&quot;]))+1)*$std-td}px" colspan="{(($std-col)-5)*number(not(child::*[local-name()=&quot;GjentagelseIntervall&quot;] | child::*[local-name()=&quot;EtterBehov&quot;]))+1}">
						<xsl:for-each select="child::*[local-name()=&quot;FasteUkedager&quot;]">
							<xsl:if test="position()!=1">,&#160;</xsl:if>
							<xsl:call-template name="k-9082"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;GjentagelseIntervall&quot;]">
					<th>GjentagelseIntervall</th>
					<td width="{((($std-col)-5-count(child::*[local-name()=&quot;FasteUkedager&quot;])*2)*number(not(child::*[local-name()=&quot;EtterBehov&quot;]))+1)*$std-td}px" colspan="{(($std-col)-5-count(child::*[local-name()=&quot;FasteUkedager&quot;])*2)*number(not(child::*[local-name()=&quot;EtterBehov&quot;]))+1}">
						<xsl:value-of select="child::*[local-name()=&quot;GjentagelseIntervall&quot;]/@V"/>&#160;<xsl:value-of select="child::*[local-name()=&quot;GjentagelseIntervall&quot;]/@U"/>
					</td>
				</xsl:if>
				<xsl:if test="child::*[local-name()=&quot;EtterBehov&quot;]">
					<td width="{(($std-col)-3-count(child::*[local-name()=&quot;FasteUkedager&quot;] | child::*[local-name()=&quot;GjentagelseIntervall&quot;])*2)*$std-td}px" colspan="{($std-col)-3-count(child::*[local-name()=&quot;FasteUkedager&quot;] | child::*[local-name()=&quot;GjentagelseIntervall&quot;])*2}">
						<xsl:if test="child::*[local-name()=&quot;EtterBehov&quot;]='true'">Gjentas etter behov</xsl:if>
					</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="RefDoc">
		<xsl:apply-templates select=".">
			<xsl:with-param name="std-col" select="$std-col"/>
			<xsl:with-param name="std-td" select="$std-td"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
