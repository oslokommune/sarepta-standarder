<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" exclude-result-prefixes="mh">
	
	<!-- Inngår i Hdirs visningsfiler versjon 1.0. Laget i XMLSpy v2012 rel2 (http://www.altova.com) av Jan Sigurd Dragsjø (helsedirektoratet.no) -->
	<!-- Layout av topp -->
	<xsl:template name="Topp">
		<div class="No-line-top">
			<div class="No-line-header">
				<div class="No-line-headerContent">
					<div class="No-line-caption">Avsender&#160;</div>
					<div class="No-line-content">
						<xsl:apply-templates select="//mh:Sender"/>
					</div>
				</div>
				<xsl:choose>
					<xsl:when test="//mh:MsgInfo/mh:Patient">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Pasient&#160;</div>
							<div class="No-line-content">
								<xsl:apply-templates select="//mh:MsgInfo/mh:Patient"/>
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
						<xsl:apply-templates select="//mh:Receiver"/>
					</div>
				</div>
				<xsl:choose>
					<xsl:when test="//mh:OtherReceiver">
						<div class="No-line-headerContent">
							<div class="No-line-caption">Kopimottaker&#160;</div>
							<div class="No-line-content">
								<xsl:apply-templates select="//mh:OtherReceiver"/>
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
	<!-- Layout av bunn -->
	<xsl:template name="Bunn">
		<xsl:param name="stil"/>
		<div class="{$stil}">
			<h2>Dokumentinformasjon</h2>
			<table>
				<tbody>
					<tr>
						<th>Melding&#160;opprettet</th>
						<td>
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="//mh:GenDate"/>
							</xsl:call-template>
						</td>
						<th>Meldingsid</th>
						<td><xsl:value-of select="//mh:MsgId"/></td>
					</tr>
				</tbody>
			</table>
		</div>
	</xsl:template>
	<!-- Layout av bunn med tillegg -->
	<xsl:template name="BunnTillegg">
		<xsl:param name="stil"/>
		<div class="{$stil}">
			<h2>Dokumentinformasjon</h2>
			<table>
				<tbody>
					<xsl:call-template name="EgetBunnTillegg"/>
					<tr>
						<th>Melding&#160;opprettet</th>
						<td>
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="//mh:GenDate"/>
							</xsl:call-template>
						</td>
						<th>Meldingsid</th>
						<td><xsl:value-of select="//mh:MsgId"/></td>
					</tr>
				</tbody>
			</table>
		</div>
	</xsl:template>
	<!-- Avsender -->
	<xsl:template match="mh:Sender">
		<xsl:apply-templates select="mh:Organisation"/>
	</xsl:template>
	<!-- Mottaker -->
	<xsl:template match="mh:Receiver">
		<xsl:apply-templates select="mh:Organisation"/>
	</xsl:template>
	<!-- Kopimottaker -->
	<xsl:template match="mh:OtherReceiver">
		<xsl:apply-templates select="mh:Organisation"/>
		<xsl:apply-templates select="mh:Patient"/>
		<xsl:apply-templates select="mh:Person"/>
		<xsl:apply-templates select="mh:HealthcareProfessional"/>
	</xsl:template>
	<!-- Organisasjon -->
	<xsl:template match="mh:Organisation" name="Organisation">
		<xsl:if test="not(mh:Organisation//mh:HealthcareProfessional)">
			<xsl:apply-templates select="mh:HealthcareProfessional"/>
		</xsl:if>
		<!-- Bruker axis her for bruk både i fk1: og mh: namespace -->
		<xsl:choose>
			<xsl:when test="local-name(..)!=&quot;Organisation&quot;">
				<div>
					<xsl:value-of select="child::*[local-name()=&quot;OrganisationName&quot;]"/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<div class="NoPrint">&#160;-&#160;</div>
					<xsl:value-of select="child::*[local-name()=&quot;OrganisationName&quot;]"/>&#160;
				</div>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="not(child::*[local-name()=&quot;Organisation&quot;]/descendant::*[local-name()=&quot;Address&quot;])">
			<xsl:for-each select="child::*[local-name()=&quot;Address&quot;]">
				<xsl:call-template name="Address"/>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="not(child::*[local-name()=&quot;Organisation&quot;]/descendant::*[local-name()=&quot;TeleAddress&quot;])">
			<xsl:for-each select="child::*[local-name()=&quot;TeleCom&quot;]/child::*[local-name()=&quot;TeleAddress&quot;]">
				<xsl:call-template name="TeleAddress"/>
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()=&quot;Organisation&quot;]">
			<xsl:call-template name="Organisation"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Pasient -->
	<xsl:template match="mh:Patient" name="Patient">
		<div>
			<xsl:if test="child::*[local-name()=&quot;GivenName&quot;]">
				<xsl:value-of select="child::*[local-name()=&quot;GivenName&quot;]"/>&#160;
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;MiddleName&quot;]">
				<xsl:value-of select="child::*[local-name()=&quot;MiddleName&quot;]"/>&#160;
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;FamilyName&quot;]">
				<xsl:value-of select="child::*[local-name()=&quot;FamilyName&quot;]"/>&#160;
			</xsl:if>
			<xsl:for-each select="child::*[local-name()=&quot;Ident&quot;]">
				<xsl:if test="not(child::*[local-name()=&quot;TypeId&quot;]/@V='XXX')">
					<b><xsl:value-of select="child::*[local-name()=&quot;TypeId&quot;]/@V"/>:&#160;</b>
					<xsl:value-of select="substring(child::*[local-name()=&quot;Id&quot;], 1,6)"/>&#160;
					<xsl:value-of select="substring(child::*[local-name()=&quot;Id&quot;], 7)"/>&#160;
				</xsl:if>
			</xsl:for-each>
		</div>
		<xsl:apply-templates select="mh:Address"/>
		<xsl:for-each select="child::*[local-name()=&quot;TeleCom&quot;]">
			<xsl:call-template name="TeleCom"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Person -->
	<xsl:template match="mh:Person" name="Person">
		<xsl:call-template name="Patient"/>
	</xsl:template>
	<!-- Helsepersonell -->
	<xsl:template match="mh:HealthcareProfessional" name="HealthcareProfessional">
		<div>
			<xsl:if test="child::*[local-name()=&quot;TypeHealthcareProfessional&quot;]">
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;TypeHealthcareProfessional&quot;]/@DN">
						<xsl:value-of select="child::*[local-name()=&quot;TypeHealthcareProfessional&quot;]/@DN"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="child::*[local-name()=&quot;TypeHealthcareProfessional&quot;]">
							<xsl:call-template name="k-9060"/>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>&#160;
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;TypeHealthcareProfessional&quot;] and child::*[local-name()=&quot;RoleToPatient&quot;]">
				og&#160;
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;RoleToPatient&quot;]">
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;RoleToPatient&quot;]/@DN">
						<xsl:value-of select="child::*[local-name()=&quot;RoleToPatient&quot;]/@DN"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="child::*[local-name()=&quot;RoleToPatient&quot;]">
							<xsl:call-template name="k-9034"/>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>&#160;
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;GivenName&quot;]">
				<xsl:value-of select="child::*[local-name()=&quot;GivenName&quot;]"/>&#160;
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;MiddleName&quot;]">
				<xsl:value-of select="child::*[local-name()=&quot;MiddleName&quot;]"/>&#160;
			</xsl:if>
			<xsl:if test="child::*[local-name()=&quot;FamilyName&quot;]">
				<xsl:value-of select="child::*[local-name()=&quot;FamilyName&quot;]"/>&#160;
			</xsl:if>
		</div>
		<xsl:for-each select="child::*[local-name()=&quot;TeleCom&quot;]">
			<xsl:call-template name="TeleCom"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Adresse -->
	<xsl:template match="mh:Address" name="Address">
		<!-- Bruker axis her for bruk både i fk1: og mh: namespace -->
		<div class="NoPrint">&#160;
			<b>
				<xsl:choose>
					<xsl:when test="child::*[local-name()=&quot;Type&quot;]">
						<xsl:choose>
							<xsl:when test="child::*[local-name()=&quot;Type&quot;]/@DN">
								<xsl:value-of select="child::*[local-name()=&quot;Type&quot;]/@DN"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]">
									<xsl:call-template name="k-3401"/>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>:&#160;
					</xsl:when>
					<xsl:otherwise>Adresse:&#160;</xsl:otherwise>
				</xsl:choose>
			</b>
		</div>
		<xsl:if test="child::*[local-name()=&quot;StreetAdr&quot;]">
			<div><xsl:value-of select="child::*[local-name()=&quot;StreetAdr&quot;]"/></div>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;PostalCode&quot;] or child::*[local-name()=&quot;City&quot;]">
			<xsl:if test="child::*[local-name()=&quot;StreetAdr&quot;]">
				<div class="NoPrint">,&#160;</div>
			</xsl:if>
			<div>
				<xsl:value-of select="child::*[local-name()=&quot;PostalCode&quot;]"/>&#160;
				<xsl:value-of select="child::*[local-name()=&quot;City&quot;]"/>
				<xsl:if test="not(child::*[local-name()=&quot;County&quot; or local-name()=&quot;Country&quot;])">&#160;</xsl:if>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;County&quot;]">
			<div class="NoPrint">,&#160;</div>
			<div>
				<xsl:value-of select="child::*[local-name()=&quot;County&quot;]/@DN"/>
				<xsl:if test="not(child::*[local-name()=&quot;Country&quot;])">&#160;</xsl:if>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;Country&quot;]">
			<div class="NoPrint">,&#160;</div>
			<div><xsl:value-of select="child::*[local-name()=&quot;Country&quot;]/@DN"/>&#160;</div>
		</xsl:if>
	</xsl:template>
	<!-- Telekommunikasjon -->
	<xsl:template match="mh:TeleCom" name="TeleCom">
		<xsl:for-each select="child::*[local-name()=&quot;TeleAddress&quot;]">
			<xsl:call-template name="TeleAddress"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Telekommunikasjon -->
	<xsl:template match="mh:TeleAddress" name="TeleAddress">
		<xsl:choose>
			<xsl:when test="starts-with(@V, &quot;tel:&quot;) or starts-with(@V, &quot;callto:&quot;)">
				<div><b>Telefon:</b>&#160;<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>&#160;</div>
			</xsl:when>
			<xsl:when test="starts-with(@V, &quot;fax:&quot;)">
				<div><b>Fax:</b>&#160;<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>&#160;</div>
			</xsl:when>
			<xsl:when test="starts-with(@V, &quot;mailto:&quot;)">
				<div><b>e-post:</b>&#160;<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>&#160;</div>
			</xsl:when>
			<xsl:when test="starts-with(@V, &quot;http:&quot;)">
				<div><b>Web:</b>&#160;<xsl:value-of select="@V"/>&#160;</div>
			</xsl:when>
			<!-- Bruker axis her for bruk både i fk1: og mh: namespace -->
			<xsl:when test="preceding-sibling::*/@DN">
				<div><b><xsl:value-of select="preceding-sibling::*/@DN"/>:</b>&#160;<xsl:value-of select="@V"/></div>
			</xsl:when>
			<xsl:when test="preceding-sibling::*/@V">
				<div><b>
					<xsl:for-each select="preceding-sibling::*">
						<xsl:call-template name="k-9061"/>:
					</xsl:for-each></b>&#160;
					<xsl:value-of select="@V"/>
				</div>
			</xsl:when>
			<xsl:when test="contains(@V, &quot;:&quot;)">
				<div><b>Kontakt:</b>&#160;<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>&#160;</div>
			</xsl:when>
			<xsl:otherwise>
				<div><b>Kontakt:</b>&#160;<xsl:value-of select="@V"/>&#160;</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<!-- Kodeverk -->
	<xsl:template name="k-3401">
		<xsl:choose>
			<xsl:when test="@V='H'">Bostedsadresse</xsl:when>
			<xsl:when test="@V='HP'">Folkeregisteradresse</xsl:when>
			<xsl:when test="@V='HV'">Ferieadresse</xsl:when>
			<xsl:when test="@V='INV'">Faktureringsadresse</xsl:when>
			<xsl:when test="@V='PST'">Postadresse</xsl:when>
			<xsl:when test="@V='RES'">Besøksadresse</xsl:when>
			<xsl:when test="@V='TMP'">Midlertidig adresse</xsl:when>
			<xsl:when test="@V='WP'">Arbeidsadresse</xsl:when>
			<xsl:when test="@V='BAD'">Ubrukelig&#160;adresse</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9034">
		<xsl:choose>
			<xsl:when test="@V='1'">Pasientansvarlig&#160;lege</xsl:when>
			<xsl:when test="@V='2'">Pasientansvarlig&#160;psykolog</xsl:when>
			<xsl:when test="@V='3'">Behandlingsansvarlig&#160;lege</xsl:when>
			<xsl:when test="@V='4'">Journalansvarlig</xsl:when>
			<xsl:when test="@V='5'">Informasjonsansvarlig</xsl:when>
			<xsl:when test="@V='6'">Fastlege</xsl:when>
			<xsl:when test="@V='7'">Faglig&#160;ansvarlig&#160;for&#160;vedtak&#160;i&#160;psykisk&#160;helsevern</xsl:when>
			<xsl:when test="@V='8'">Koordinator&#160;Individuel&#160;plan</xsl:when>
			<xsl:when test="@V='9'">Primærkontakt</xsl:when>
			<xsl:when test="@V='10'">Utskrivende&#160;lege</xsl:when>
			<xsl:when test="@V='11'">Utskrivende&#160;sykepleier</xsl:when>
			<xsl:when test="@V='12'">Instituerende&#160;lege</xsl:when>
			<xsl:when test="@V='13'">Innleggende&#160;lege</xsl:when>
			<xsl:when test="@V='14'">Ansvarlig&#160;jordmor</xsl:when>
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
		</xsl:choose>
	</xsl:template>
	<xsl:template name="k-9061">
		<xsl:choose>
			<xsl:when test="@V='HP'">Hovedtelefon</xsl:when>
			<xsl:when test="@V='MC'">Mobiltelefon</xsl:when>
			<xsl:when test="@V='HV'">Ferietelefon</xsl:when>
			<xsl:when test="@V='F'">Fax</xsl:when>
			<xsl:when test="@V='PG'">Personsøker</xsl:when>
			<xsl:when test="@V='AS'">Telefonsvarer</xsl:when>
			<xsl:when test="@V='WC'">Arbeidsplass,&#160;sentralbord</xsl:when>
			<xsl:when test="@V='WP'">Arbeidsplass</xsl:when>
			<xsl:when test="@V='WD'">Arbeidsplass,&#160;direktenummer</xsl:when>
			<xsl:when test="@V='EC'">Nødnummer</xsl:when>
			<xsl:when test="@V='H'">Hjemme</xsl:when>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
