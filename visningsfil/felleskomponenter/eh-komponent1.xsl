<?xml version="1.0" encoding="UTF-8"?>

<!--
	Felleskomponenter basert på CSS styling i "ehelse-visning.css"
	og versjonuavhengige xsl-filer (dvs. bruker ikke namespace prefiks).
-->

<xsl:stylesheet version="1.0" 
	xmlns:xhtml="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fk1="http://www.kith.no/xmlstds/felleskomponent1" 
	xmlns:mh="http://www.kith.no/xmlstds/msghead/2006-05-24" 
	xmlns:base="http://www.kith.no/xmlstds/base64container" 
	exclude-result-prefixes="xsl xhtml fk1 mh base"
	>

	<!-- Disse må være importert i hovedfila:
	<xsl:import href="../felleskomponenter/funksjoner.xsl"/>
	<xsl:import href="../felleskomponenter/kodeverk.xsl"/>
	<xsl:import href="../felleskomponenter/meldingshode2html.xsl"/>
	-->

	<!-- Disse templater må være definert (evt. tom) i hovefila fordi de kan kalles herfa:
		"Diagnosis-DiagComment-CodedDescr-CodedComment"
	-->

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<xsl:template name="eh-Observation"> 
		<!-- Henvisning v2.0: 				MsgHead/Document/RefDoc/Content/Henvisning/InfItem/Observation  -->
		<!-- Henvisning v1.0, v1.1 :		Message/ServReq/Patient/InfItem/Observation -->
		<!-- Epikrise v1.0, v1.1, v1.2 : 	Message/ServRprt/Event/InfItem/Observation -->
		<!-- Svarrapport m.fl? -->
		<div class="eh-row-5">

			<xsl:variable name="cssClass">
				<xsl:choose>
					<xsl:when test="../child::*[local-name()='StartDateTime'] | ../child::*[local-name()='EndDateTime'] | ../child::*[local-name()='OrgDate'] | child::*[local-name()='CodedDescr']"></xsl:when>
					<xsl:otherwise>eh-last-child</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="../child::*[local-name()='StartDateTime'] | ../child::*[local-name()='EndDateTime'] | ../child::*[local-name()='OrgDate']">
				<div class="eh-col-1">
					<span class="eh-field">
						<xsl:if test="../child::*[local-name()='StartDateTime']">
							Start:&#160;<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="../child::*[local-name()='StartDateTime']/@V"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="../child::*[local-name()='EndDateTime']">
							<xsl:if test="../child::*[local-name()='StartDateTime']">
								<xsl:value-of select="', '"/>
							</xsl:if>
							Slutt:&#160;<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="../child::*[local-name()='EndDateTime']/@V"/>
									<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
								</xsl:call-template>
						</xsl:if>
						<xsl:if test="../child::*[local-name()='OrgDate']">
							<xsl:if test="../child::*[local-name()='StartDateTime'] or ../child::*[local-name()='EndDateTime']">
								<xsl:value-of select="', '"/>
							</xsl:if>
							Opprinnelse:&#160;<xsl:call-template name="skrivUtTS">
									<xsl:with-param name="oppgittTid" select="../child::*[local-name()='OrgDate']"/>
									<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
								</xsl:call-template>
						</xsl:if>
					</span>
				</div>
			</xsl:if>

			<!-- Epikrise only -->
			<xsl:for-each select="child::*[local-name()=&quot;CodedDescr&quot;]">
				<xsl:call-template name="Diagnosis-DiagComment-CodedDescr-CodedComment"/>
			</xsl:for-each>
    		<xsl:if test="child::*[local-name()='Description'] or child::*[local-name()='Comment']">
				<div class="eh-col-1 eh-last-child" >
					<span class="eh-field">
						<xsl:if test="child::*[local-name()='Description']"> <!--  type="kith:ST" eller "anyType" -->
							<xsl:choose>
								<xsl:when test="child::*[local-name()='Description']/child::*[1][namespace-uri()='http://www.w3.org/1999/xhtml']">
									<xsl:copy-of select="child::*[local-name()='Description']/child::*[1]"/>
								</xsl:when>
								<xsl:when test="child::*[local-name()='Description'][count(child::*)>0]">
									<xsl:copy-of select="child::*[local-name()='Description']/node()"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="line-breaks">
										<xsl:with-param name="text" select="child::*[local-name()='Description']"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="child::*[local-name()='Description'] and child::*[local-name()='Comment']">
							<br/>
						</xsl:if>
						<xsl:if test="child::*[local-name()='Comment']"> <!-- type="kith:ST" -->
							<xsl:call-template name="line-breaks">
								<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
							</xsl:call-template>
						</xsl:if>
					</span>
				</div>
			</xsl:if>

		</div>
	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<xsl:template name="eh-Medication"> <!-- Henvisning/InfItem/Medication -->
		<xsl:param name="striped" />
		<!-- Henvisning v1.0, v1.1, v2.0 -->
		<!-- Epikrise v1.0, v1.1, v1.2. Skjema epikrise har flere elementer enn henvisning, men de brukes ikke i denne templaten. -->
		<!-- Merk: rad-element ikke inkludert her. -->
	
		<xsl:variable name="stripedCss">
			<xsl:choose>
				<xsl:when test="$striped = 'true'">striped</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="eh-col-1 eh-field {$stripedCss}">
			<span class="eh-label">Legemiddel</span>
			<span class="eh-text">
				<xsl:for-each select="child::*[local-name()='DrugId']">
					<xsl:call-template name="k-dummy"/>
				</xsl:for-each>
			</span>
		</div>

		<div class="eh-col-1 eh-field {$stripedCss}">
			<span class="eh-label">Status</span>
			<span class="eh-text">
				<xsl:choose>
					<xsl:when test="namespace-uri() = 'http://ehelse.no/xmlstds/henvisning/2017-11-30'"><!-- Henvisning v2.0-->
						<xsl:for-each select="child::*[local-name()='Status']">
							<xsl:call-template name="k-9101"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise><!-- Henvisning v1.0 og v1.1 -->
						<xsl:for-each select="child::*[local-name()='Status']">
							<xsl:call-template name="k-7307"/>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</div>

		<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='UnitDose'] or //child::*[local-name()='Medication']/child::*[local-name()='QuantitySupplied']">
			<div class="eh-col-1 eh-field {$stripedCss}">
				<span class="eh-label">Mengde</span>
				<span class="eh-text">
					<xsl:if test="child::*[local-name()='UnitDose']">
						<xsl:value-of select="child::*[local-name()='UnitDose']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='UnitDose']/@U "/>
						<xsl:if test="child::*[local-name()='QuantitySupplied']">&#160;x&#160;</xsl:if>
					</xsl:if>
					<xsl:if test="child::*[local-name()='QuantitySupplied']">
						<xsl:value-of select="child::*[local-name()='QuantitySupplied']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='QuantitySupplied']/@U"/>
					</xsl:if>
				</span>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='DosageText'] or //child::*[local-name()='Medication']/child::*[local-name()='IntendedDuration']">
			<div class="eh-col-1 eh-field {$stripedCss}">
				<span class="eh-label">
					<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='DosageText']">Dosering</xsl:if>
					<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='DosageText'] and //child::*[local-name()='Medication']/child::*[local-name()='IntendedDuration']">/</xsl:if>
					<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='IntendedDuration']">Varighet</xsl:if>
				</span>
				<span class="eh-text">
					<xsl:if test="child::*[local-name()='DosageText']">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='DosageText']"/>
						</xsl:call-template>
					</xsl:if>&#160;
					<xsl:if test="child::*[local-name()='IntendedDuration']">&#160;/&#160;<xsl:value-of select="child::*[local-name()='IntendedDuration']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='IntendedDuration']/@U"/>
					</xsl:if>
					<xsl:if test="not(child::*[local-name()='DosageText']) and not(child::*[local-name()='IntendedDuration'])">&#160;</xsl:if>
				</span>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='Medication']/child::*[local-name()='Comment']">
			<div class="eh-col-1 eh-field {$stripedCss}">
				<span class="eh-label">Kommentar</span>
				<span class="eh-text">
					<xsl:call-template name="line-breaks">
						<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='StartDateTime']">
			<div class="eh-col-1 eh-field {$stripedCss}">
				<span class="eh-label">Starttidspunkt</span>
				<span class="eh-text">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="../child::*[local-name()='StartDateTime']/@V "/>
						<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='EndDateTime']">
			<div class="eh-col-1 eh-field {$stripedCss}">
				<span class="eh-label">Sluttidspunkt</span>
				<span class="eh-text">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="../child::*[local-name()='EndDateTime']/@V"/>
						<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='Medication']]/child::*[local-name()='OrgDate']">
			<div class="eh-col-1 eh-field eh-last-child {$stripedCss}">
				<span class="eh-label">Tidspunkt for opprinnelse</span>
				<span class="eh-text">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="../child::*[local-name()='OrgDate']/@V"/>
						<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>

	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<xsl:template name="eh-ResultItem"> 
		<!-- Henvisning v2.0 			MsgHead/Document/RefDoc/Content/Henvisning/InfItem/ResultItem  -->
		<!-- Henvisning v1.0, v1.1 		Message/ServReq/Patient/InfItem/ResultItem -->
		<!-- merk: rad-element ikke inkludert her. -->
		<!-- Kan brukes av Henvisning, Epikrise, Svarrapport m.fl? -->
		<!-- <div class="eh-col-1 eh-field"> -->
		<xsl:param name="striped" />
		
			<xsl:variable name="stripedCss">
				<xsl:choose>
					<xsl:when test="$striped = 'true'">striped</xsl:when>
				<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<div class="eh-col-1 eh-field {$stripedCss}">
				<span class="eh-label">Undersøkelse</span>
				<span class="eh-text">
					<xsl:for-each select="child::*[local-name()='ClinInv']">
						<xsl:for-each select="child::*[local-name()='Id']"> 	<!-- minOccurs="1" -->
							<xsl:call-template name="k-dummy"/>
						</xsl:for-each>
						<xsl:for-each select="child::*[local-name()='Spec']"> 	<!-- maxOccurs="unbounded" -->
							<br/>
							<span class="eh-strong">Spesifisert:</span>&#160;
							<xsl:call-template name="k-dummy"/>
						</xsl:for-each>
					</xsl:for-each>
				</span>
			</div>

		<div class="eh-col-3 eh-field {$stripedCss}">
			<span class="eh-label">Funn/resultat</span>
			<span class="eh-text">
				<xsl:for-each select="child::*[local-name()='Interval']">
					<xsl:if test="child::*[local-name()='Low']">
						<span class="eh-strong">Nedre:</span>&#160;<xsl:value-of select="child::*[local-name()='Low']/@V"/>
						<xsl:value-of select="child::*[local-name()='Low']/@U"/>&#160;
					</xsl:if>
					<xsl:if test="child::*[local-name()='High']">
						<span class="eh-strong">Øvre:</span>&#160;<xsl:value-of select="child::*[local-name()='High']/@V"/>
						<xsl:value-of select="child::*[local-name()='High']/@U"/>&#160;
					</xsl:if>
				</xsl:for-each>

				<xsl:for-each select="child::*[local-name()='DateResult']">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()='DateResultValue']/@V"/>
						<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
					</xsl:call-template>
				</xsl:for-each>

				<xsl:for-each select="child::*[local-name()='NumResult']">
					<xsl:for-each select="child::*[local-name()='ArithmeticComp']">
						<xsl:call-template name="k-8239"/>
					</xsl:for-each>
					<xsl:value-of select="child::*[local-name()='NumResultValue']/@V"/>&#160;<xsl:value-of select="child::*[local-name()='NumResultValue']/@U"/>&#160;
					<xsl:for-each select="../child::*[local-name()='DevResultInd']">
						<span class="eh-strong">
							<xsl:call-template name="k-8244"/>
						</span>
					</xsl:for-each>
				</xsl:for-each>

				<xsl:for-each select="child::*[local-name()='TextResult']/child::*[local-name()='Result']">

					<xsl:if test="child::*[local-name()='TextResultValue']"> <!--  type="kith:ST" eller "anyType" -->
						<xsl:choose>
							<xsl:when test="child::*[local-name()='TextResultValue']/child::*[1][namespace-uri()='http://www.w3.org/1999/xhtml']">
								<xsl:copy-of select="child::*[local-name()='TextResultValue']/child::*[1]"/>
							</xsl:when>
							<xsl:when test="child::*[local-name()='TextResultValue'][count(child::*)>0]">
								<xsl:copy-of select="child::*[local-name()='TextResultValue']/node()"/>
							</xsl:when>
							<xsl:otherwise>
								<div>
									<xsl:call-template name="line-breaks">
										<xsl:with-param name="text" select="child::*[local-name()='TextResultValue']"/>
									</xsl:call-template>
								</div>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="child::*[local-name()='TextCode']">
						<xsl:for-each select="child::*[local-name()='TextCode']">
							<div>
								<xsl:call-template name="k-dummy"/>
							</div>
						</xsl:for-each>
					</xsl:if>
				</xsl:for-each>

				<xsl:if test="child::*[local-name()='Comment']">
					<div>
						<span class="eh-strong">Kommentar:</span>&#160;<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Comment']"/>
						</xsl:call-template>
					</div>
				</xsl:if>
			</span>
		</div>

		<xsl:if test="//child::*[local-name()='ResultItem']/child::*[local-name()='InvDate']"> 
			<div class="eh-col-1 eh-field">
				<span class="eh-label">Tidspunkt for undersøkelsen</span>
				<span class="eh-text">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="child::*[local-name()='InvDate']/@V"/>
						<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>


		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='StartDateTime']"> <!-- up one level : InfItem -->
			<div class="eh-col-1 eh-field">
				<span class="eh-label">Starttidspunkt</span>
				<span class="eh-text">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="../child::*[local-name()='StartDateTime']/@V"/>
						<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='EndDateTime']"> <!-- up one level : InfItem -->
			<div class="eh-col-1 eh-field">
				<span class="eh-label">Sluttidspunkt</span>
				<span class="eh-text">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="../child::*[local-name()='EndDateTime']/@V | ../child::*[local-name()='EndDateTime']/@V"/>
						<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>

		<xsl:if test="//child::*[local-name()='InfItem'][child::*[local-name()='ResultItem']]/child::*[local-name()='OrgDate']"> <!-- up one level : InfItem -->
			<div class="eh-col-1 eh-field eh-last-child">
				<span class="eh-label">Tidspunkt for opprinnelse</span>
				<span class="eh-text">
					<xsl:call-template name="skrivUtTS">
						<xsl:with-param name="oppgittTid" select="../child::*[local-name()='OrgDate']/@V"/>
						<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>
		
	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<xsl:template name="eh-ReasonAsText"> <!-- maxOccurs="unbounded" -->
		<!-- Henvisning v2.0 					MsgHead/Document/RefDoc/Content/Henvisning/ReasonAsText  -->
		<!-- Henvisning v1.0, v1.1 				Message/ServReq/ReasonAsText -->
		<!-- Epikrise v1.0, v1.1, v1.2 (ikke i bruk)	Message/ServRprt/ServReq/ReasonAsText -->
		<div  class="eh-row-4">
			<xsl:choose>
				<xsl:when test="child::*[local-name()='Heading']/@V='BG' or  child::*[local-name()='Heading']/@V='BUP-BM' or child::*[local-name()='Heading']/@V='BUP-HG' or child::*[local-name()='Heading']/@V='KF' or child::*[local-name()='Heading']/@V='MAAL' or child::*[local-name()='Heading']/@V='MU' or child::*[local-name()='Heading']/@V='RU' or child::*[local-name()='Heading']/@V='UP'">
					<div class="eh-col-1">
						<span class="eh-label">
							<xsl:call-template name="k-8231"/>
							<xsl:if test="not(child::*[local-name()='Heading'])">Begrunnelse (uspes.)</xsl:if>
						</span>
					</div>
				</xsl:when>
				<xsl:when test="not(child::*[local-name()='Heading'])">
					<div class="eh-col-1"><span class="eh-label">Begrunnelse (uspes.)</span></div>
				</xsl:when>
			</xsl:choose>

			<div class="eh-col-1 eh-last-child">
				<span class="eh-field">

					<xsl:if test="child::*[local-name()='TextResultValue']"> <!--  type="kith:ST" eller "anyType" -->
						<xsl:choose>
							<xsl:when test="child::*[local-name()='TextResultValue']/child::*[1][namespace-uri()='http://www.w3.org/1999/xhtml']">
								<xsl:copy-of select="child::*[local-name()='TextResultValue']/child::*[1]"/>
							</xsl:when>
							<xsl:when test="child::*[local-name()='TextResultValue'][count(child::*)>0]">
								<xsl:copy-of select="child::*[local-name()='TextResultValue']/node()"/>
							</xsl:when>
							<xsl:otherwise>
								<div>
									<xsl:call-template name="line-breaks">
										<xsl:with-param name="text" select="child::*[local-name()='TextResultValue']"/>
									</xsl:call-template>
								</div>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:for-each select="child::*[local-name()='TextCode'] | child::*[local-name()='TextCode']"> <!-- maxOccurs="unbounded" -->
						<xsl:if test="position() &gt; 1">
							<br/>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="@DN"><xsl:value-of select="@DN"/>&#160;</xsl:when>
							<xsl:when test="@OT"><xsl:value-of select="@OT"/>&#160;</xsl:when>
							<xsl:when test="@V">
								<xsl:value-of select="@V"/>&#160;<xsl:choose>
									<xsl:when test="contains(@S,'7010')">(SNOMED)</xsl:when>
									<xsl:when test="contains(@S,'7230')">(NKKKL)</xsl:when>
									<xsl:when test="contains(@S,'7240')">(NORAKO)</xsl:when>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</span>

			</div>

		</div>
		
	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<xsl:template name="eh-AssistertKommunikasjon"> <!-- maxOccurs="unbounded" -->
		<!-- Henvisning v1.1 		Message/ServReq/Patient/AssistertKommunikasjon -->
		<!-- Kan brukes av Henvisning v1.1 og PLO -->
		<xsl:if test="position()=1">
			<div class="eh-row-8">
				<div class="eh-col-1 eh-label">Behov for tolk</div>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='PersonTolkebehov']">
					<div class="eh-col-1 md eh-label">Personen behovet gjelder</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon'][child::*[local-name()='Horselsvikt']='true'] or ..//child::*[local-name()='AssistertKommunikasjon'][child::*[local-name()='Synsvikt']='true']">
					<div class="eh-col-1 md eh-label">Handikap</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='BehovTolkSprak']">
					<div class="eh-col-1 md eh-label">Språk</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='PreferertTolk']">
					<div class="eh-col-1 md eh-label">Foretrukket tolk</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='BehovOpphortDato']">
					<div class="eh-col-1 md eh-label">Behov opphørt dato</div>
				</xsl:if>
				<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='Merknad']">
					<div class="eh-col-1 md eh-last-child eh-label">Merknad</div>
				</xsl:if>
			</div>
		</xsl:if>
		<div class="eh-row-8">
			<div class="eh-col-1 md eh-label">&#160;</div>
			<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='PersonTolkebehov']">
				<div class="eh-col-1 eh-field">
					<span class="eh-label xs">Personen behovet gjelder</span>
					<span class="eh-text">
						<xsl:for-each select="child::*[local-name()='PersonTolkebehov']">
							<div>
								<xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/>
							</div>
							<xsl:for-each select=".//fk1:TeleAddress">
								<xsl:call-template name="eh-TeleAddressHode"/>
							</xsl:for-each>
						</xsl:for-each>
					</span>
				</div>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon'][child::*[local-name()='Horselsvikt']='true'] or ..//child::*[local-name()='AssistertKommunikasjon'][child::*[local-name()='Synsvikt']='true']">
				<div class="eh-col-1 eh-field">
					<span class="eh-label xs">Handikap</span>
					<span class="eh-text">
						<xsl:if test="child::*[local-name()='Horselsvikt']='true'">Døv</xsl:if>
						<xsl:if test="child::*[local-name()='Horselsvikt']='true' and child::*[local-name()='Synsvikt']='true'">&#160;og&#160;</xsl:if>
						<xsl:if test="child::*[local-name()='Synsvikt']='true'">Blind</xsl:if>&#160;
					</span>
				</div>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='BehovTolkSprak']">
				<div class="eh-col-1 eh-field">
					<span class="eh-label xs">Spr&#197;k</span>
					<span class="eh-text">
						<xsl:for-each select="child::*[local-name()='BehovTolkSprak']">
							<xsl:call-template name="k-3303"/>&#160;
						</xsl:for-each>
					</span>
				</div>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='PreferertTolk']">
				<div class="eh-col-1 eh-field">
					<span class="eh-label xs">Foretrukket tolk</span>
					<span class="eh-text">
						<xsl:for-each select="child::*[local-name()='PreferertTolk']">
							<div>
								<xsl:value-of select="fk1:FamilyName"/>,&#160;<xsl:value-of select="fk1:GivenName"/>&#160;<xsl:value-of select="fk1:MiddleName"/>
							</div>
							<xsl:for-each select=".//fk1:TeleAddress">
								<xsl:call-template name="eh-TeleAddressHode"/>
							</xsl:for-each>
						</xsl:for-each>
					</span>
				</div>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='BehovOpphortDato']">
				<div class="eh-col-1 eh-field">
					<span class="eh-label xs">Behov opph&#248;rt dato</span>
					<span class="eh-text">
						<xsl:call-template name="skrivUtTS">
							<xsl:with-param name="oppgittTid" select="child::*[local-name()='BehovOpphortDato']/@V"/>
							<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
						</xsl:call-template>
					</span>
				</div>
			</xsl:if>
			<xsl:if test="..//child::*[local-name()='AssistertKommunikasjon']/child::*[local-name()='Merknad']">
				<div class="eh-col-1 eh-last-child eh-field">
					<span class="eh-label xs">Merknad</span>
					<span class="eh-text">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Merknad']"/>
						</xsl:call-template>
					</span>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<!-- Visning av vedlegg -->
	<xsl:template name="eh-RefDoc">
		<!-- Epikrise v1.0, v1.1, v1.2 -->
		<!-- Henvisning v1.0, v1.1 -->
		<!-- Svarrapport : Message/ServReport/RefDoc -->
		<xsl:param name="col"/>
		<xsl:if test="child::*[local-name()='MsgType'] or child::*[local-name()='Id'] or child::*[local-name()='IssueDate'] or child::*[local-name()='MimeType'] or child::*[local-name()='Compression']">
			<div class="eh-row-5">
				<xsl:if test="child::*[local-name()='MsgType']">
					<div class="eh-col-1">
						<span class="eh-label">Type</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='MsgType']">
								<xsl:choose>
									<xsl:when test="namespace-uri() = 'http://www.kith.no/xmlstds/henvisning/2012-02-15'">
										<xsl:call-template name="k-8114"/> <!-- v1.1 -->
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="k-8263"/> <!-- v1.0 -->
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Id']">
					<div class="eh-col-1">
						<span class="eh-label">Id</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='Id']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='IssueDate']">
					<div class="eh-col-1">
						<span class="eh-label">Utstedt-dato</span>
						<span class="eh-field blk">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="child::*[local-name()='IssueDate']"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>

				<xsl:if test="child::*[local-name()='MimeType']">
					<div class="eh-col-1">
						<span class="eh-label">Mimetype</span>
						<span class="eh-field">
							<xsl:value-of select="child::*[local-name()='MimeType']"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="child::*[local-name()='Compression']">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Komprimering</span>
						<span class="eh-field blk">
							<xsl:for-each select="child::*[local-name()='Compression']">
								<xsl:call-template name="k-1204"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
			</div>
			<xsl:if test="child::*[local-name()='Booking']"> <!-- Henvisning v1.0 only -->
				<div class="eh-row-4">
					<div class="eh-col-1">
						<span class="eh-label">Booking</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='Booking']">
								<xsl:value-of select="child::*[local-name()='Name']"/>&#8200;
								<span class="eh-strong">
									<xsl:choose>
										<xsl:when test="child::*[local-name()='TypeId']/@V">
											<xsl:value-of select="child::*[local-name()='TypeId']/@V"/>:</xsl:when>
										<xsl:otherwise>Id:</xsl:otherwise>
									</xsl:choose>
								</span>&#8200;
								<xsl:value-of select="child::*[local-name()='Id']"/>
								<xsl:for-each select=".//child::*[local-name()='SubOrg']">
									<xsl:call-template name="eh-SubOrg" />
								</xsl:for-each>
							</xsl:for-each>
						</span>
					</div>
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Avtale</span>
						<span class="eh-field">
							<xsl:for-each select="child::*[local-name()='Booking']/child::*[local-name()='Appointment']">
								<div>
									<span class="eh-strong">Tidspunkt: </span>
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="child::*[local-name()='StartDateTime']/@V"/>
										<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
									</xsl:call-template>
									<span class="eh-strong"> til </span>
									<xsl:call-template name="skrivUtTS">
										<xsl:with-param name="oppgittTid" select="child::*[local-name()='EndDateTime']/@V"/>
										<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
									</xsl:call-template>
								</div>
								<div>
									<span class="strong"> Ressurs: </span>
									<xsl:value-of select="child::*[local-name()='ResourceId']"/>
									<span class="eh-strong"> Index: </span>
									<xsl:value-of select="child::*[local-name()='Index']"/>
								</div>
								<div>
									<span class="eh-strong"> Service: </span>
									<xsl:for-each select="child::*[local-name()='Service']">
										<xsl:call-template name="k-8264"/>
									</xsl:for-each>
								</div>
							</xsl:for-each>
						</span>
					</div>
				</div>
			</xsl:if>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Description']">
			<div class="eh-row-4 blk-cmt">
				<div class="eh-col-1 eh-last-child">
					<span class="eh-label">Beskrivelse</span>
					<span class="eh-field">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="child::*[local-name()='Description']"/>
						</xsl:call-template>
					</span>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Content'] or child::*[local-name()='FileReference']"> <!-- v1.1 only -->
			<xsl:choose>
				<xsl:when test="contains(child::*[local-name()='MimeType'],'image')">
					<div class="eh-row-8">
						<div class="eh-col-1 eh-label">Bilde</div>
						<div class="eh-col-1 eh-field eh-last-child">
							<xsl:choose>
								<xsl:when test="child::*[local-name()='FileReference']">
									<img style="max-width: 100%;">
										<xsl:attribute name="src"><xsl:value-of select="child::*[local-name()='FileReference']"/></xsl:attribute>
										<xsl:attribute name="alt">Bilde fra ekstern URL</xsl:attribute>
									</img>
								</xsl:when>
								<xsl:when test="child::*[local-name()='Content']">
									<xsl:choose>
										<xsl:when test="child::*[local-name()='Content']/base:Base64Container">
											<img style="max-width: 100%;">
												<xsl:attribute name="src"><xsl:value-of select="concat('data:',child::*[local-name()='MimeType'],';base64,',child::*[local-name()='Content']/base:Base64Container)"/></xsl:attribute>
												<xsl:attribute name="alt">Bilde vedlagt som base64-kode</xsl:attribute>
											</img>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="child::*[local-name()='Content']"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
						</div>
					</div>
				</xsl:when>
				<xsl:when test="contains(child::*[local-name()='MimeType'],'pdf')">
					<div class="eh-row-4 blk-cmt">
						<div class="eh-col-1 eh-last-child">
							<span class="eh-label">PDF</span>
							<span class="eh-field">Hvis du ikke ser pdf-vedlegget kan du prøve en annen nettleser.</span>
						</div>
					</div>
					<div class="eh-row-8 NoPrint">
						<div class="eh-col-1 md eh-field">&#160;</div>
						<div class="eh-col-1 eh-field">
							<xsl:choose>
								<xsl:when test="child::*[local-name()='FileReference']">
									<object>
										<xsl:attribute name="data">
											<xsl:value-of select="concat(child::*[local-name()='FileReference'],'&#35;view&#61;FitH&#38;toolbar&#61;1')"/>
										</xsl:attribute>
										<xsl:attribute name="type">application/pdf</xsl:attribute>
										<xsl:attribute name="width">100%</xsl:attribute>
										<xsl:attribute name="height">500px</xsl:attribute>
									</object>
								</xsl:when>
								<xsl:when test="child::*[local-name()='Content']">
									<xsl:choose>
										<xsl:when test="child::*[local-name()='Content']/base:Base64Container">
											<object>
												<xsl:attribute name="data">
													<xsl:value-of select="concat('data:application/pdf;base64,',child::*[local-name()='Content']/base:Base64Container)"/>
												</xsl:attribute>
												<xsl:attribute name="type">application/pdf</xsl:attribute>
												<xsl:attribute name="width">100%</xsl:attribute>
												<xsl:attribute name="height">500px</xsl:attribute>
											</object>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="child::*[local-name()='Content']"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
						</div>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="eh-row-4">
						<div class="eh-col-1 eh-last-field">
							<span class="eh-field">
								<xsl:choose>
									<xsl:when test="child::*[local-name()='Content']">
										<xsl:value-of select="child::*[local-name()='Content']"/>
									</xsl:when>
									<xsl:when test="child::*[local-name()='FileReference']">
										<xsl:value-of select="child::*[local-name()='FileReference']"/>
									</xsl:when>
								</xsl:choose>
							</span>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<!-- Visning av vedlegg -->
	<xsl:template name="eh-msghead-RefDoc">
		<!-- felleskomponent : MsgHead/Document/RefDoc -->
		<!-- Henvisning v2.0 -->
		<xsl:if test="mh:MsgType or mh:Id or mh:IssueDate or mh:MimeType or mh:Compression">
			<div class="eh-row-5">
				<xsl:if test="mh:MsgType">
					<div class="eh-col-1">
						<span class="eh-label">Type</span>
						<span class="eh-field">
							<xsl:for-each select="mh:MsgType">
								<xsl:call-template name="k-8114"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="mh:Id">
					<div class="eh-col-1">
						<span class="eh-label">Id</span>
						<span class="eh-field">
							<xsl:value-of select="mh:Id"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="mh:IssueDate">
					<div class="eh-col-1">
						<span class="eh-label">Utstedt-dato</span>
						<span class="eh-field blk">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid" select="mh:IssueDate/@V"/>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="mh:MimeType">
					<div class="eh-col-1">
						<span class="eh-label">Mimetype</span>
						<span class="eh-field">
							<xsl:value-of select="mh:MimeType"/>
						</span>
					</div>
				</xsl:if>
				<xsl:if test="mh:Compression">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Komprimering</span>
						<span class="eh-field blk">
							<xsl:for-each select="mh:Compression">
								<xsl:call-template name="k-1204"/>
							</xsl:for-each>
						</span>
					</div>
				</xsl:if>
			</div>
		</xsl:if>
		<xsl:if test="mh:Description">
			<div class="eh-row-4 blk-cmt">
				<div class="eh-col-1 eh-last-child">
					<span class="eh-label">Beskrivelse</span>
					<span class="eh-field">
						<xsl:call-template name="line-breaks">
							<xsl:with-param name="text" select="mh:Description"/>
						</xsl:call-template>
					</span>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="mh:Content or mh:FileReference">
			<xsl:choose>
				<xsl:when test="contains(mh:MimeType,'image')">
					<div class="eh-row-8">
						<div class="eh-col-1 eh-label">Bilde</div>
						<div class="eh-col-1 eh-field eh-last-child">
								<xsl:choose>
									<xsl:when test="mh:FileReference">
										<img style="max-width: 100%;">
											<xsl:attribute name="src"><xsl:value-of select="mh:FileReference"/></xsl:attribute>
											<xsl:attribute name="alt">Bilde fra ekstern URL</xsl:attribute>
										</img>
									</xsl:when>
									<xsl:when test="mh:Content">
										<xsl:choose>
											<xsl:when test="mh:Content/base:Base64Container">
												<img style="max-width: 100%;">
													<xsl:attribute name="src"><xsl:value-of select="concat('data:',mh:MimeType,';base64,',mh:Content/base:Base64Container)"/></xsl:attribute>
													<xsl:attribute name="alt">Bilde vedlagt som base64-kode</xsl:attribute>
												</img>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="mh:Content"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
								</xsl:choose>
						</div>
					</div>
				</xsl:when>
				<xsl:when test="contains(mh:MimeType,'pdf')">
					<div class="eh-row-4 blk-cmt">
						<div class="eh-col-1 eh-last-child">
							<span class="eh-label">pdf</span>
							<span class="eh-field">Hvis du ikke ser pdf-vedlegget kan du prøve en annen nettleser.</span>
						</div>
					</div>
					<div class="eh-row-8 NoPrint">
						<div class="eh-col-1 md eh-field">&#160;</div>
						<div class="eh-col-1 eh-field">
								<xsl:choose>
									<xsl:when test="mh:FileReference">
										<object>
											<xsl:attribute name="data"><xsl:value-of select="concat(mh:FileReference,'&#35;view&#61;FitH&#38;toolbar&#61;1')"/></xsl:attribute>
											<xsl:attribute name="type">application/pdf</xsl:attribute>
											<xsl:attribute name="width">100%</xsl:attribute>
											<xsl:attribute name="height">500px</xsl:attribute>
										</object>
									</xsl:when>
									<xsl:when test="mh:Content">
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
									</xsl:when>
								</xsl:choose>
						</div>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="eh-row-4">
						<div class="eh-col-1 eh-last-child">
							<span class="eh-field">
								<xsl:choose>
									<xsl:when test="mh:Content">
										<xsl:value-of select="mh:Content"/>
									</xsl:when>
									<xsl:when test="mh:FileReference">
										<xsl:value-of select="mh:FileReference"/>
									</xsl:when>
								</xsl:choose>
							</span>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<xsl:template name="eh-SubOrg"> <!-- Henvisning v1.0  -->
		<div>
			<xsl:value-of select="child::*[local-name()='Name']"/>&#8200;
			<span class="eh-strong">
				<xsl:choose>
					<xsl:when test="child::*[local-name()='TypeId']">
						<xsl:value-of select="child::*[local-name()='TypeId']"/>:</xsl:when>
					<xsl:otherwise>Id:</xsl:otherwise>
				</xsl:choose>
			</span>&#8200;
			<xsl:value-of select="child::*[local-name()='Id']"/>
		</div>
	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<xsl:template name="eh-Address" >
		<xsl:if test="child::*[local-name()='StreetAdr'] or child::*[local-name()='PostalCode'] or child::*[local-name()='City'] or child::*[local-name()='CityDistr'] or child::*[local-name()='County'] or child::*[local-name()='Country']">
			<xsl:if test="child::*[local-name()='Type']">
				<span class="eh-strong">
					<xsl:for-each select="child::*[local-name()='Type']">
						<xsl:call-template name="k-3401"/>:&#160;
					</xsl:for-each>
				</span>
			</xsl:if>
		</xsl:if>
		<xsl:if test="child::*[local-name()='StreetAdr']">
			<xsl:value-of select="child::*[local-name()='StreetAdr']"/>
		</xsl:if>
		<xsl:if test="child::*[local-name()='PostalCode'] or child::*[local-name()='City']">
			<xsl:if test="child::*[local-name()='StreetAdr']">, </xsl:if>
			<xsl:value-of select="child::*[local-name()='PostalCode']"/>&#8200;<xsl:value-of select="child::*[local-name()='City']"/>
		</xsl:if>
		<xsl:if test="child::*[local-name()='CityDistr']">, <xsl:for-each select="child::*[local-name()='CityDistr']">
				<xsl:call-template name="k-3403"/>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="child::*[local-name()='County']">, <xsl:for-each select="child::*[local-name()='County']">
				<xsl:call-template name="k-3402"/>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="child::*[local-name()='Country']">, <xsl:for-each select="child::*[local-name()='Country']">
				<xsl:call-template name="k-9043"/>
			</xsl:for-each>
		</xsl:if>
		<xsl:for-each select="child::*[local-name()='TeleAddress']">
			<xsl:call-template name="eh-TeleAddressHode"/>
		</xsl:for-each>
	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<xsl:template name="eh-TeleAddress">
		<div class="eh-col-2">
			<span class="eh-label">
				<xsl:choose>
					<xsl:when test="starts-with(@V, 'tel:') or starts-with(@V, 'callto:')">Telefon</xsl:when>
					<xsl:when test="starts-with(@V, 'fax:')">Faks</xsl:when>
					<xsl:when test="starts-with(@V, 'mailto:')">e-post</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(@V, ':')"/>
					</xsl:otherwise>
				</xsl:choose>
			</span>
			<span class="eh-field">
				<xsl:value-of select="substring-after(@V, ':')"/>
			</span>
		</div>
	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<xsl:template name="eh-TeleAddressHode">
		<div>
			<span class="eh-strong">
				<xsl:choose>
					<xsl:when test="starts-with(@V, 'tel:') or starts-with(@V, 'callto:')">Telefon</xsl:when>
					<xsl:when test="starts-with(@V, 'fax:')">Faks</xsl:when>
					<xsl:when test="starts-with(@V, 'mailto:')">e-post</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(@V, ':')"/>
					</xsl:otherwise>
				</xsl:choose>
			</span>:&#160;<xsl:value-of select="substring-after(@V, ':')"/>
		</div>
	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<xsl:template name="eh-Footer">
		<xsl:param name="stil"/>
		<xsl:param name="versjon"/>
		<xsl:param name="VisDokInfoVisSkjul"/>

		<div class="{$stil}">
			<h2>Dokumentinformasjon</h2>

			<xsl:if test="$VisDokInfoVisSkjul">
				<label for="visFooter" class="VisSkjul">Vis/Skjul</label>
				<input type="checkbox" checked="true" id="visFooter" style="display: none;"/>
			</xsl:if>

			<div class="eh-section">
				<xsl:call-template name="EgetBunnTillegg"/>	
				<div class="eh-row-5">
					<div class="eh-col-2">
						<span class="eh-label">Melding opprettet</span>
						<span class="eh-field">
							<xsl:call-template name="skrivUtTS">
								<xsl:with-param name="oppgittTid">
									<xsl:choose>
										<xsl:when test="local-name()='ServReq'">
											<xsl:value-of select="../child::*[local-name()='GenDate']" />	<!-- /Message/GenDate -->
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="/descendant::mh:GenDate[1]" />	<!-- /MsgHead/MsgInfo/GenDate -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
							</xsl:call-template>
						</span>
					</div>
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Meldingsid</span>
						<span class="eh-field">
							<xsl:choose>
 								<xsl:when test="local-name()='ServReq'">
  									<xsl:value-of select="../child::*[local-name()='MsgId']" />	<!-- /Message/MsgId -->
   								</xsl:when>
   								<xsl:otherwise>
  									<xsl:value-of select="/descendant::mh:MsgId[1]" />	<!-- /MsgHead/MsgInfo/MsgId -->
   								</xsl:otherwise>
  							</xsl:choose> 
						</span>
					</div>
				</div>
				<xsl:if test="local-name()='ServReq'">
   					<div class="eh-row-5">
   						<xsl:if test="child::*[local-name()='IssueDate']">
  							<div class="eh-col-2">
   								<span class="eh-label">Utstedt</span>
   								<span class="eh-field">
   									<xsl:call-template name="skrivUtTS">
   										<xsl:with-param name="oppgittTid" select="child::*[local-name()='IssueDate']"/>
   										<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
   									</xsl:call-template>
   								</span>
   							</div>
   						</xsl:if>
   						<xsl:if test="child::*[local-name()='Priority']">
   							<div class="eh-col-1">
   								<span class="eh-label">Hastegrad</span>
   								<span class="eh-field">
   									<xsl:for-each select="child::*[local-name()='Priority']">
   										<xsl:call-template name="k-7303"/>
   									</xsl:for-each>
   								</span>
   							</div>
   						</xsl:if>
   						<xsl:if test="child::*[local-name()='ApprDate']">
   							<div class="eh-col-1">
   								<span class="eh-label">Godkjent</span>
   								<span class="eh-field">
   									<xsl:call-template name="skrivUtTS">
   										<xsl:with-param name="oppgittTid" select="child::*[local-name()='ApprDate']/@V"/>
   										<xsl:with-param name="useNormalSpaceSeparator" select="true()"/>
   									</xsl:call-template>
   								</span>
   							</div>
   						</xsl:if>
   						<xsl:if test="child::*[local-name()='Ack']">
   							<div class="eh-col-1 eh-last-child">
   								<span class="eh-label">Meldingsbekreftelse</span>
   								<span class="eh-field">
   									<xsl:for-each select="child::*[local-name()='Ack']">
   										<xsl:call-template name="k-7304"/>
   									</xsl:for-each>
   								</span>
   							</div>
  						</xsl:if>
   					</div>
  				</xsl:if>
 				<div class="eh-row-5">
					<div class="eh-col-1 eh-last-child">
						<span class="eh-label">Visningsversjon</span>
						<span class="eh-field"><xsl:value-of select="$versjon"/></span>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- ++++++++++++++++++++++++++++++++++++++++++++ -->

	<xsl:template name="eh-Pakkeforlop"> <!-- Henvisning/Pakkeforlop -->
		<xsl:param name="striped" />
		<!-- Henvisning v2.0 -->
			
		<xsl:variable name="stripedCss">
			<xsl:choose>
				<xsl:when test="$striped = 'true'">striped</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<div class="eh-col-1 eh-field {$stripedCss}">
				<span class="eh-label">Kode</span>
				<span class="eh-text">
					<xsl:value-of select="child::*[local-name()='Pakkeforlopskode']/@V"/>
				</span>
		</div>
		
		<div class="eh-col-2 eh-field {$stripedCss}">
				<span class="eh-label">Navn</span>
				<span class="eh-text">
				<xsl:for-each select="child::*[local-name()='Pakkeforlopskode']">
					<xsl:choose>
						<xsl:when test="contains('8480','8480')">
							<xsl:call-template name="k-8480"/>
						</xsl:when>
						<xsl:when test="contains(child::*[local-name()='Pakkeforlopskode']/@S,'9173')">
							<xsl:call-template name="k-9173"/>
						</xsl:when>
						<xsl:when test="contains(child::*[local-name()='Pakkeforlopskode']/@S,'9174')">
							<xsl:call-template name="k-9174"/>
						</xsl:when>
						<xsl:when test="contains(child::*[local-name()='Pakkeforlopskode']/@S,'9175')">
							<xsl:call-template name="k-9175"/>
						</xsl:when>
						<xsl:when test="contains(child::*[local-name()='Pakkeforlopskode']/@S,'9176')">
							<xsl:call-template name="k-9176"/>
						</xsl:when>
						<xsl:when test="contains(child::*[local-name()='Pakkeforlopskode']/@S,'9321')">
							<xsl:call-template name="k-9321"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				</span>
		</div>
		<div class="eh-col-3 eh-field {$stripedCss}">
				<span class="eh-label">Merknad</span>
				<span class="eh-text">
					<xsl:value-of select="child::*[local-name()='Merknad']"/>
				</span>
		</div>
		<!-- <div class="eh-col-1 eh-field {$stripedCss}">
			<span class="eh-label">Status</span>
			<span class="eh-text">
				<xsl:choose>
					<xsl:when test="namespace-uri() = 'http://ehelse.no/xmlstds/henvisning/2017-11-30'"> 
						<xsl:for-each select="child::*[local-name()='Status']">
							<xsl:call-template name="k-9101"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="child::*[local-name()='Status']">
							<xsl:call-template name="k-7307"/>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</div>
-->
	
	</xsl:template>
	
</xsl:stylesheet>
