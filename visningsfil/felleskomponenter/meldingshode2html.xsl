<?xml version="1.0" encoding="UTF-8"?>

	<!-- Endringslogg
	- 06.06.17: template "mh:Address"/"Address": fjernet ledetekst type når adresse mangler.
	- 25.10.16: La til visningsversjonnr
	- 19.11.15: Småjusteringer ift. kodeverkskall.
	- 01.01.13: Oppdatert versjon av hodemelding2html for å håndtere ulike css-stiler.
	-->
	<!-- Om
	- Inngår i Hdirs visningsfiler versjon 2.0
	- Laget i XMLSpy v2016 (http://www.altova.com) av Jan Sigurd Dragsjø (nhn.no)
	-->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24"
	xmlns:base="http://www.kith.no/xmlstds/base64container"
	exclude-result-prefixes="mh base">

	<!-- Filer som må importeres. Vanligvis gjøres dette i hovedfila som importerer denne komponentfila. Derfor er de kommentert ut.
	<xsl:import href="funksjoner.xsl"/> -->

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
		<xsl:param name="versjon"/>
		<div class="{$stil}">
			<h2>Dokumentinformasjon</h2>
			<table>
				<tbody>
					<tr>
						<th>Melding&#160;opprettet</th>
						<td>
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="/descendant::mh:GenDate[1]"/>
							</xsl:call-template>
						</td>
						<th>Meldingsid</th>
						<td>
							<xsl:value-of select="/descendant::mh:MsgId[1]"/>
						</td>
					</tr>
					<xsl:if test="$versjon">
						<tr>
							<th>Visningsversjon</th>
							<td colspan="3">
								<xsl:value-of select="$versjon"/>
							</td>
						</tr>
					</xsl:if>
				</tbody>
			</table>
		</div>
	</xsl:template>
	<!-- Layout av bunn med tillegg -->
	<xsl:template name="BunnTillegg">
		<xsl:param name="stil"/>
		<xsl:param name="versjon"/>
		<div class="{$stil}">
			<h2>Dokumentinformasjon</h2>
			<table>
				<tbody>
					<!-- EgetBunnTillegg er en template alle som importerer denne må ha. Den muliggjør spesifikke komponenter i bunnen av visningen -->
					<xsl:call-template name="EgetBunnTillegg"/>
					<tr>
						<th>Melding&#160;opprettet</th>
						<td>
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="/descendant::mh:GenDate[1]"/>
							</xsl:call-template>
						</td>
						<th>Meldingsid</th>
						<td>
							<xsl:value-of select="/descendant::mh:MsgId[1]"/>
						</td>
					</tr>
					<xsl:if test="$versjon">
						<tr>
							<th>Visningsversjon</th>
							<td colspan="3">
								<xsl:value-of select="$versjon"/>
							</td>
						</tr>
					</xsl:if>
				</tbody>
			</table>
		</div>
	</xsl:template>
	<!-- Avsender -->
	<xsl:template match="mh:Sender">
		<xsl:for-each select="mh:Organisation">
			<xsl:call-template name="Organisation"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Mottaker -->
	<xsl:template match="mh:Receiver">
		<xsl:for-each select="mh:Organisation">
			<xsl:call-template name="Organisation"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Kopimottaker -->
	<xsl:template match="mh:OtherReceiver">
		<xsl:for-each select="mh:Organisation">
			<xsl:call-template name="Organisation"/>
		</xsl:for-each>
		<xsl:for-each select="mh:Patient">
			<xsl:call-template name="Patient"/>
		</xsl:for-each>
		<xsl:for-each select="mh:Person">
			<xsl:call-template name="Person"/>
		</xsl:for-each>
		<xsl:for-each select="mh:HealthcareProfessional">
			<xsl:call-template name="HealthcareProfessional"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Organisasjon -->
	<xsl:template match="mh:Organisation" name="Organisation">
		<xsl:if test="not(mh:Organisation//mh:HealthcareProfessional)">
			<xsl:for-each select="mh:HealthcareProfessional">
				<xsl:call-template name="HealthcareProfessional"/>
			</xsl:for-each>
		</xsl:if>
		<!-- Bruker axis her for bruk både i fk1: og mh: namespace -->
		<xsl:choose>
			<xsl:when test="local-name(..)!=&quot;Organisation&quot;">
				<div>
					<xsl:value-of select="child::*[local-name()=&quot;OrganisationName&quot;]"/>&#160;
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<div class="NoPrint">-&#160;</div>
					<xsl:value-of select="child::*[local-name()=&quot;OrganisationName&quot;]"/>&#160;(
					<xsl:value-of select="child::*[local-name()=&quot;Ident&quot;]/child::*[local-name()=&quot;Id&quot;]"/>&#160;)
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
					<span class="strong">
						<xsl:value-of select="child::*[local-name()=&quot;TypeId&quot;]/@V"/>:&#160;</span>
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
			<xsl:for-each select="child::*[local-name()=&quot;TypeHealthcareProfessional&quot;]">
				<xsl:call-template name="k-9060"/>&#160;
			</xsl:for-each>
			<xsl:if test="child::*[local-name()=&quot;TypeHealthcareProfessional&quot;] and child::*[local-name()=&quot;RoleToPatient&quot;]">
				og&#160;
			</xsl:if>
			<xsl:for-each select="child::*[local-name()=&quot;RoleToPatient&quot;]">
				<xsl:call-template name="k-9034"/>&#160;
			</xsl:for-each>
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
		<xsl:for-each select="child::*[local-name()=&quot;Ident&quot;]">
			<xsl:call-template name="Ident"/>
		</xsl:for-each>
		<xsl:for-each select="child::*[local-name()=&quot;TeleCom&quot;]">
			<xsl:call-template name="TeleCom"/>
		</xsl:for-each>
	</xsl:template>
	<!-- Adresse -->
	<xsl:template match="mh:Address" name="Address">
		<!-- Bruker axis her for bruk både i fk1: og mh: namespace -->
		<xsl:if test="child::*[local-name()='StreetAdr'] or child::*[local-name()='PostalCode'] or child::*[local-name()='City'] or child::*[local-name()='County'] or child::*[local-name()='Country']">
			<div class="NoPrint">&#160;
				<span class="strong">
					<xsl:choose>
						<xsl:when test="child::*[local-name()=&quot;Type&quot;]">
							<xsl:for-each select="child::*[local-name()=&quot;Type&quot;]">
								<xsl:call-template name="k-3401"/>:&#160;
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>Adresse:&#160;</xsl:otherwise>
					</xsl:choose>
				</span>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()=&quot;StreetAdr&quot;]">
			<div>
				<xsl:value-of select="child::*[local-name()=&quot;StreetAdr&quot;]"/>
			</div>
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
			<div>
				<xsl:value-of select="child::*[local-name()=&quot;Country&quot;]/@DN"/>&#160;</div>
		</xsl:if>
	</xsl:template>
	<!-- Ident -->
	<xsl:template match="mh:Ident" name="Ident">
		<xsl:if test="child::*[local-name()=&quot;Id&quot;] and child::*[local-name()=&quot;TypeId&quot;]/@V = 'HPR'">
			<span class="italic">HPR-nummer:</span>&#160;
			<xsl:value-of select="child::*[local-name()=&quot;Id&quot;]"/>
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
				<div>
					<span class="strong">Telefon:</span>&#160;<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>&#160;</div>
			</xsl:when>
			<xsl:when test="starts-with(@V, &quot;fax:&quot;)">
				<div>
					<span class="strong">Fax:</span>&#160;<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>&#160;</div>
			</xsl:when>
			<xsl:when test="starts-with(@V, &quot;mailto:&quot;)">
				<div>
					<span class="strong">e-post:</span>&#160;<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>&#160;</div>
			</xsl:when>
			<xsl:when test="starts-with(@V, &quot;http:&quot;)">
				<div>
					<span class="strong">Web:</span>&#160;<xsl:value-of select="@V"/>&#160;</div>
			</xsl:when>
			<!-- Bruker axis her for bruk både i fk1: og mh: namespace -->
			<xsl:when test="preceding-sibling::*/@DN">
				<div>
					<span class="strong">
						<xsl:value-of select="preceding-sibling::*/@DN"/>:</span>&#160;<xsl:value-of select="@V"/>
				</div>
			</xsl:when>
			<xsl:when test="preceding-sibling::*/@V">
				<div>
					<span class="strong">
						<xsl:for-each select="preceding-sibling::*">
							<xsl:call-template name="k-9061"/>:
					</xsl:for-each>
					</span>&#160;
					<xsl:value-of select="@V"/>
				</div>
			</xsl:when>
			<xsl:when test="contains(@V, &quot;:&quot;)">
				<div>
					<span class="strong">Kontakt:</span>&#160;<xsl:value-of select="substring-after(@V, &quot;:&quot;)"/>&#160;</div>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<span class="strong">Kontakt:</span>&#160;<xsl:value-of select="@V"/>&#160;</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Visning av vedllegg -->
	<xsl:template match="mh:RefDoc">
		<xsl:param name="std-col"/>
		<xsl:param name="std-td"/>
		<xsl:if test="mh:MsgType or mh:Id or mh:IssueDate or mh:MimeType or mh:Compression">
			<tr>
				<xsl:if test="mh:MsgType">
					<th>Type</th>
					<td width="{((($std-col)-2)*number(not(mh:Id | mh:IssueDate | mh:MimeType | mh:Compression))+1)*$std-td}px" colspan="{(($std-col)-2)*number(not(mh:Id | mh:IssueDate | mh:MimeType | mh:Compression))+1}">
						<xsl:for-each select="mh:MsgType">
							<xsl:call-template name="k-8114"/>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="mh:Id">
					<th>Id</th>
					<td width="{((($std-col)-2-count(mh:MsgType)*2)*number(not(mh:IssueDate | mh:MimeType | mh:Compression))+1)*$std-td}px" colspan="{(($std-col)-2-count(mh:MsgType)*2)*number(not(mh:IssueDate | mh:MimeType | mh:Compression))+1}">
						<xsl:value-of select="mh:Id"/>
					</td>
				</xsl:if>
				<xsl:if test="mh:IssueDate">
					<th>Utstedt-dato</th>
					<td width="{((($std-col)-2-count(mh:MsgType | mh:Id)*2)*number(not(mh:MimeType | mh:Compression))+1)*$std-td}px" colspan="{(($std-col)-2-count(mh:MsgType | mh:Id)*2)*number(not(mh:MimeType | mh:Compression))+1}">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="mh:IssueDate/@V"/>
						</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="mh:MimeType">
					<th>Mimetype</th>
					<td width="{((($std-col)-2-count(mh:MsgType | mh:Id | mh:IssueDate)*2)*number(not(mh:Compression))+1)*$std-td}px" colspan="{(($std-col)-2-count(mh:MsgType | mh:Id | mh:IssueDate)*2)*number(not(mh:Compression))+1}">
						<xsl:value-of select="mh:MimeType"/>
					</td>
				</xsl:if>
				<xsl:if test="mh:Compression">
					<th>Komprimering</th>
					<td colspan="{($std-col)-1-count(mh:MsgType | mh:Id | mh:IssueDate | mh:MimeType)*2}">
						<xsl:for-each select="mh:Compression">
							<xsl:call-template name="k-1204"/>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="mh:Description">
			<tr>
				<th>Beskrivelse</th>
				<td colspan="{($std-col)-1}">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="mh:Description"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="mh:Content or mh:FileReference">
			<xsl:choose>
				<xsl:when test="contains(mh:MimeType,'image')">
					<tr>
						<th>Bilde</th>
						<xsl:choose>
							<xsl:when test="mh:FileReference">
								<td colspan="{($std-col)-1}">
									<img style="max-width: 90%;">
										<xsl:attribute name="src"><xsl:value-of select="mh:FileReference"/></xsl:attribute>
										<xsl:attribute name="alt">Bilde fra ekstern URL</xsl:attribute>
									</img>
								</td>
							</xsl:when>
							<xsl:when test="mh:Content">
								<td colspan="{($std-col)-1}">
									<xsl:choose>
										<xsl:when test="mh:Content/base:Base64Container">
											<img style="max-width: 90%;">
												<xsl:attribute name="src"><xsl:value-of select="concat('data:',mh:MimeType,';base64,',mh:Content/base:Base64Container)"/></xsl:attribute>
												<xsl:attribute name="alt">Bilde vedlagt som base64-kode</xsl:attribute>
											</img>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="mh:Content"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</xsl:when>
						</xsl:choose>
					</tr>
				</xsl:when>
				<xsl:when test="contains(mh:MimeType,'pdf')">
					<tr>
						<th>pdf</th>
						<td colspan="{($std-col)-1}">Hvis du ikke ser pdf-vedlegget kan du prøve en annen nettleser.</td>
					</tr>
					<tr>
						<td>&#160;</td>
						<xsl:choose>
							<xsl:when test="mh:FileReference">
								<td colspan="{($std-col)-1}">
									<object>
										<xsl:attribute name="data"><xsl:value-of select="concat(mh:FileReference,'&#35;view&#61;FitH&#38;toolbar&#61;1')"/></xsl:attribute>
										<xsl:attribute name="type">application/pdf</xsl:attribute>
										<xsl:attribute name="width">100%</xsl:attribute>
										<xsl:attribute name="height">500px</xsl:attribute>
									</object>
								</td>
							</xsl:when>
							<xsl:when test="mh:Content">
								<td colspan="{($std-col)-1}">
									<xsl:choose>
										<xsl:when test="mh:Content/base:Base64Container">
											<object>
												<xsl:attribute name="data"><xsl:value-of select="concat('data:application/pdf;base64,',mh:Content/base:Base64Container)"/></xsl:attribute>
												<xsl:attribute name="type">application/pdf</xsl:attribute>
												<xsl:attribute name="width">100%</xsl:attribute>
												<xsl:attribute name="height">500px</xsl:attribute>
											</object>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="mh:Content"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</xsl:when>
						</xsl:choose>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td colspan="{($std-col)-1}">
							<xsl:choose>
								<xsl:when test="mh:Content">
									<xsl:value-of select="mh:Content"/>
								</xsl:when>
								<xsl:when test="mh:FileReference">
									<xsl:value-of select="mh:FileReference"/>
								</xsl:when>
							</xsl:choose>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
