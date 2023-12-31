<xsl:stylesheet xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:mix="http://www.loc.gov/mix/v20"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:dv="http://dfg-viewer.de/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:vl="http://visuallibrary.net/vl"
    xmlns:vls="http://semantics.de/vls"
    xmlns:marcxml="http://www.loc.gov/MARC21/slim"
    xmlns:epicur="urn:nbn:de:1111-2004033116"
    xmlns:zvdd="http://zvdd.gdz-cms.de/"
    xmlns:vlz="http://visuallibrary.net/vlz/1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="xsl" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8" />
  <xsl:variable name="oai_id" select="//oai:record/oai:header/oai:identifier" />
  <xsl:variable name="dmd_id" select="concat(&apos;md&apos;,substring-after($oai_id,&apos;de:&apos;))" />
  <xsl:variable name="rel_dmd_id" select="//mets:structMap/mets:div/mets:div/@DMDID" />
  <xsl:template match="/">
    <xsl:apply-templates select="//mets:mets" />
  </xsl:template>
  <xsl:template match="//mets:mets">
    <mets:mets xmlns:mets="http://www.loc.gov/METS/">
      <mets:dmdSec ID="ie-dmd">
        <mets:mdWrap MDTYPE="DC">
          <mets:xmlData>
            <dc:record xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
              <!-- map mods md into dc -->
              <xsl:apply-templates select="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/*" mode="mods2dc" />
              <xsl:if test="mets:structMap/mets:div/mets:div/@TYPE=&apos;multivolumework&apos;">
                <xsl:if test="mets:structMap/mets:div/mets:div/@DMDID=$dmd_id">
                  <xsl:apply-templates select="mets:dmdSec[not(@ID=$dmd_id)]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/*" mode="mods2dc" />
                </xsl:if>
              </xsl:if>
              <dc:identifier>
                <xsl:value-of select="concat(&apos;https://nbn-resolving.org/&apos;,//mods:identifier[@type=&apos;urn&apos;])" />
              </dc:identifier>
              <dc:identifier>
                <xsl:value-of select="concat(&apos;https://elekpub.bib.uni-wuppertal.de/doi/&apos;,//mods:identifier[@type=&apos;doi&apos;])" />
              </dc:identifier>
            </dc:record>
          </mets:xmlData>
        </mets:mdWrap>
      </mets:dmdSec>
      <!-- IE AMDMD Section -->
      <mets:amdSec ID="ie-amd">
        <mets:techMD ID="ie-amd-tech">
          <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
            <mets:xmlData>
              <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
                <section id="objectIdentifier" />
              </dnx>
            </mets:xmlData>
          </mets:mdWrap>
        </mets:techMD>
        <mets:rightsMD ID="ie-amd-rights">
          <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
            <mets:xmlData>
              <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
                <section id="accessRightsPolicy" />
              </dnx>
            </mets:xmlData>
          </mets:mdWrap>
        </mets:rightsMD>
        <!-- 				<mets:sourceMD ID="ie-amd-source">					<mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">						<mets:xmlData>							<dnx xmlns="http://www.exlibrisgroup.com/dps/dnx"/>						</mets:xmlData>					</mets:mdWrap>				</mets:sourceMD> -->
        <mets:sourceMD ID="ie-amd-source-MODS">
          <mets:mdWrap MDTYPE="MODS">
            <mets:xmlData>
              <!-- /dmdSec -->
              <xsl:apply-templates select="mets:dmdSec" />
              <!-- structMap ID="LOGICAL" -->
              <xsl:apply-templates select="mets:structMap[@TYPE=&apos;LOGICAL&apos;]" mode="structMap" />
            </mets:xmlData>
          </mets:mdWrap>
        </mets:sourceMD>
        <mets:digiprovMD ID="ie-amd-digiprov">
          <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
            <mets:xmlData>
              <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx" />
            </mets:xmlData>
          </mets:mdWrap>
        </mets:digiprovMD>
      </mets:amdSec>
      <xsl:if test="mets:structMap/mets:div/mets:div/@TYPE=&apos;multivolumework&apos;">
        <xsl:if test="not(mets:structMap/mets:div/mets:div/@DMDID=$dmd_id)">
          <xsl:apply-templates select="mets:fileSec" mode="fileSec" />
        </xsl:if>
      </xsl:if>
      <xsl:if test="not(mets:structMap/mets:div/mets:div/@TYPE=&apos;multivolumework&apos;)">
        <xsl:apply-templates select="mets:fileSec" mode="fileSec" />
      </xsl:if>
    </mets:mets>
  </xsl:template>
  <!-- mods SECTION Copy original dmdSec Data to sourceMD/dmdSec -->
  <xsl:template match="mets:dmdSec">
    <xsl:copy-of select="." />
  </xsl:template>
  <!-- mods SECTION Copy original amdSec Data to sourceMD/admSec -->
  <xsl:template match="mets:amdSec[@ID=&apos;imageInfo&apos;]">
    <xsl:copy-of select="." />
  </xsl:template>
  <!-- mods SECTION Copy original structMap Data to sourceMD/structMap -->
  <xsl:template match="mets:structMap[@TYPE=&apos;LOGICAL&apos;]" mode="structMap">
    <xsl:copy-of select="." />
  </xsl:template>
  <!-- DVRights Section -->
  <xsl:template match="mets:amdSec/mets:rightsMD">
    <mets:rightsMD>
      <xsl:attribute name="ID">
        <xsl:value-of select="./@ID" />
      </xsl:attribute>
      <xsl:for-each select="mets:mdWrap">
        <xsl:attribute name="MIMETYPE">
          <xsl:value-of select="./@MIMETYPE" />
        </xsl:attribute>
        <xsl:attribute name="MDTYPE">
          <xsl:value-of select="./@MDTYPE" />
        </xsl:attribute>
        <xsl:attribute name="OTHERMDTYPE">
          <xsl:value-of select="./@OTHERMDTYPE" />
        </xsl:attribute>
        <mets:mdWrap>
          <xsl:copy-of select="mets:xmlData" />
        </mets:mdWrap>
      </xsl:for-each>
    </mets:rightsMD>
  </xsl:template>
  <!-- digiProv Section -->
  <xsl:template match="mets:amdSec/mets:digiprovMD">
    <mets:digiprovMD>
      <xsl:attribute name="ID">
        <xsl:value-of select="./@ID" />
      </xsl:attribute>
      <xsl:for-each select="mets:mdWrap">
        <xsl:attribute name="MIMETYPE">
          <xsl:value-of select="./@MIMETYPE" />
        </xsl:attribute>
        <xsl:attribute name="MDTYPE">
          <xsl:value-of select="./@MDTYPE" />
        </xsl:attribute>
        <xsl:attribute name="OTHERMDTYPE">
          <xsl:value-of select="./@OTHERMDTYPE" />
        </xsl:attribute>
        <mets:mdWrap>
          <xsl:copy-of select="mets:xmlData" />
        </mets:mdWrap>
      </xsl:for-each>
    </mets:digiprovMD>
  </xsl:template>
  <!-- amdSec Representation specific Section -->
  <xsl:template match="mets:fileSec/mets:fileGrp[@USE=&quot;pdf document&quot; or @USE=&quot;fulltext FR&quot;]" mode="repres">
    <xsl:variable name="representationID" select="concat(&apos;rep&apos;, position(), &apos;-amd&apos;)" />
    <xsl:variable name="preservationType" select="./@USE" />
    <mets:amdSec>
      <xsl:attribute name="ID">
        <xsl:value-of select="$representationID" />
      </xsl:attribute>
      <mets:techMD>
        <xsl:attribute name="ID">
          <xsl:value-of select="concat($representationID, &apos;-tech&apos;)" />
        </xsl:attribute>
        <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
          <mets:xmlData>
            <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
              <section id="generalRepCharacteristics">
                <record>
                  <xsl:choose>
                    <xsl:when test="$preservationType = &apos;pdf document&apos;">
                      <key id="label">PDF</key>
                      <key id="preservationType">PRESERVATION_MASTER</key>
                      <key id="representationEntityType">
                        <xsl:value-of select="$preservationType" />
                      </key>
                    </xsl:when>
                    <xsl:when test="$preservationType = &apos;fulltext FR&apos;">
                      <key id="label">XML</key>
                      <key id="preservationType">MODIFIED_MASTER</key>
                      <key id="representationEntityType">
                        <xsl:value-of select="$preservationType" />
                      </key>
                    </xsl:when>
                    <xsl:otherwise>
                      <key id="preservationType">DERIVATIVE_COPY</key>
                      <key id="representationEntityType">UNSPECIFIC</key>
                      <key id="RepresentationCode">MEDIUM</key>
                    </xsl:otherwise>
                  </xsl:choose>
                  <key id="usageType">VIEW</key>
                  <key id="DigitalOriginal">false</key>
                </record>
              </section>
            </dnx>
          </mets:xmlData>
        </mets:mdWrap>
      </mets:techMD>
    </mets:amdSec>
  </xsl:template>
  <!-- amdSec File specific Section -->
  <xsl:template match="mets:fileSec/mets:fileGrp[@USE=&quot;pdf document&quot; or @USE=&quot;fulltext FR&quot;]" mode="file">
    <xsl:variable name="representationPos" select="position()" />
    <xsl:for-each select="mets:file">
      <xsl:variable name="fileMIMEType" select="./@MIMETYPE" />
      <xsl:variable name="fileFixityType" select="./@CHECKSUMTYPE" />
      <xsl:variable name="fileChecksum" select="./@CHECKSUM" />
      <xsl:variable name="fileName" select="./mets:FLocat/@xlink:href" />
      <xsl:variable name="filePos" select="position()" />
      <xsl:variable name="fileID" select="./@ID" />
      <xsl:variable name="fileSizeBytes" select="./@SIZE" />
      <xsl:variable name="fileCreationDate" select="./@CREATED" />
      <mets:amdSec>
        <xsl:attribute name="ID">
          <xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $representationPos, &apos;-amd&apos;)" />
        </xsl:attribute>
        <mets:techMD>
          <xsl:attribute name="ID">
            <xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $representationPos, &apos;-amd-tech&apos;)" />
          </xsl:attribute>
          <mets:mdWrap MDTYPE="OTHER" OTHERMDTYPE="dnx">
            <mets:xmlData>
              <dnx xmlns="http://www.exlibrisgroup.com/dps/dnx">
                <section id="generalFileCharacteristics">
                  <record>
                    <key id="label">
                      <xsl:choose>
                        <xsl:when test="$fileMIMEType = &quot;application/pdf&quot;">
                          <xsl:value-of select="$LabelPDF/PDFLabel[@label=$fileID]" />
                        </xsl:when>
                        <xsl:when test="$fileMIMEType = &quot;text/xml&quot;">
                          <xsl:value-of select="$LabelFR/FRLabel[@label=$fileID]" />
                        </xsl:when>
                      </xsl:choose>
                    </key>
                    <key id="fileMIMEType">
                      <xsl:value-of select="$fileMIMEType" />
                    </key>
                    <key id="note">
                      <xsl:value-of select="$fileID" />
                    </key>
                    <xsl:if test="$fileSizeBytes">
                      <key id="fileSizeBytes">
                        <xsl:value-of select="$fileSizeBytes" />
                      </key>
                    </xsl:if>
                    <xsl:if test="$fileCreationDate">
                      <key id="fileCreationDate">
                        <xsl:value-of select="$fileCreationDate" />
                      </key>
                    </xsl:if>
                  </record>
                </section>
                <xsl:choose>
                  <xsl:when test="$fileChecksum != &apos;&apos;">
                    <section id="fileFixity">
                      <record>
                        <key id="fixityType">
                          <xsl:value-of select="$fileFixityType" />
                        </key>
                        <key id="fixityValue">
                          <xsl:value-of select="$fileChecksum" />
                        </key>
                      </record>
                    </section>
                  </xsl:when>
                </xsl:choose>
              </dnx>
            </mets:xmlData>
          </mets:mdWrap>
        </mets:techMD>
      </mets:amdSec>
    </xsl:for-each>
  </xsl:template>
  <!-- mets:fileSec Section -->
  <xsl:template match="mets:fileSec" mode="fileSec">
    <xsl:apply-templates select="mets:fileGrp[@USE=&quot;pdf document&quot; or @USE=&quot;fulltext FR&quot;]" mode="repres" />
    <xsl:apply-templates select="mets:fileGrp[@USE=&quot;pdf document&quot; or @USE=&quot;fulltext FR&quot;]" mode="file" />
    <mets:fileSec>
      <xsl:for-each select="mets:fileGrp[@USE=&quot;pdf document&quot; or @USE=&quot;fulltext FR&quot;]">
        <xsl:variable name="pos" select="position()" />
        <mets:fileGrp>
          <xsl:attribute name="USE">
            <xsl:value-of select="&apos;VIEW&apos;" />
          </xsl:attribute>
          <xsl:attribute name="ID">
            <xsl:value-of select="concat(&apos;rep&apos;, $pos)" />
          </xsl:attribute>
          <xsl:attribute name="ADMID">
            <xsl:value-of select="concat(&apos;rep&apos;, $pos, &apos;-amd&apos;)" />
          </xsl:attribute>
          <xsl:for-each select="mets:file">
            <xsl:variable name="filePos">
              <xsl:value-of select="position()" />
            </xsl:variable>
            <mets:file>
              <xsl:attribute name="MIMETYPE">
                <xsl:choose>
                  <xsl:when test="./@MIMETYPE = &quot;image/jpeg&quot;">
                    <xsl:text>image/tiff</xsl:text>
                  </xsl:when>
                  <xsl:when test="./@MIMETYPE = &quot;image/png&quot;">
                    <xsl:text>image/tiff</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="./@MIMETYPE" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="ID">
                <xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $pos)" />
              </xsl:attribute>
              <xsl:attribute name="ADMID">
                <xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $pos, &apos;-amd&apos;)" />
              </xsl:attribute>
              <xsl:copy-of select="mets:FLocat" copy-namespaces="no" />
            </mets:file>
          </xsl:for-each>
        </mets:fileGrp>
      </xsl:for-each>
    </mets:fileSec>
    <!-- mets:structMap LOGICAL Section -->
    <xsl:for-each select="mets:fileGrp[@USE=&quot;pdf document&quot; or @USE=&quot;fulltext FR&quot;]">
      <xsl:variable name="pos" select="position()" />
      <mets:structMap>
        <xsl:attribute name="TYPE">
          <xsl:value-of select="&apos;LOGICAL&apos;" />
        </xsl:attribute>
        <xsl:attribute name="ID">
          <xsl:value-of select="concat(&apos;rep&apos;, $pos, &apos;-1&apos;)" />
        </xsl:attribute>
        <mets:div>
          <xsl:for-each select="./mets:file">
            <xsl:variable name="fileMIMEType" select="./@MIMETYPE" />
            <xsl:variable name="fileID" select="./@ID" />
            <xsl:variable name="filePos" select="position()" />
            <mets:div>
              <xsl:attribute name="TYPE">
                <xsl:value-of select="&apos;FILE&apos;" />
              </xsl:attribute>
              <xsl:attribute name="LABEL">
                <xsl:choose>
                  <xsl:when test="$fileMIMEType = &quot;application/pdf&quot;">
                    <xsl:value-of select="$LabelPDF/PDFLabel[@label=$fileID]" />
                  </xsl:when>
                  <xsl:when test="$fileMIMEType = &quot;text/xml&quot;">
                    <xsl:value-of select="$LabelFR/FRLabel[@label=$fileID]" />
                  </xsl:when>
                </xsl:choose>
              </xsl:attribute>
              <mets:fptr>
                <xsl:attribute name="FILEID">
                  <xsl:value-of select="concat(&apos;fid&apos;, $filePos, &apos;-&apos;, $pos)" />
                </xsl:attribute>
              </mets:fptr>
            </mets:div>
          </xsl:for-each>
        </mets:div>
      </mets:structMap>
    </xsl:for-each>
  </xsl:template>
  <!-- mods2DC SECTION generate DC from mods -->
  <xsl:template match="*" mode="mods">
    <xsl:element name="mods:{name()}" namespace="http://www.loc.gov/mods/v3">
      <xsl:copy-of select="namespace::*" />
      <xsl:apply-templates mode="mods" />
    </xsl:element>
  </xsl:template>
  <xsl:template match="@*|text()" mode="copy">
    <xsl:copy>
      <xsl:apply-templates mode="copy" />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="*" mode="copy">
    <xsl:element name="{name()}">
      <xsl:apply-templates mode="copy" />
    </xsl:element>
  </xsl:template>
  <!-- MD section -->
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:titleInfo/mods:title" mode="mods2dc">
    <xsl:choose>
      <xsl:when test="../@type=&apos;alternative&apos;">
        <dcterms:alternative>
          <xsl:value-of select="." />
        </dcterms:alternative>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="../mods:subTitle">
            <dc:title>
              <xsl:value-of select="concat(.,&apos; : &apos;,../mods:subTitle)" />
            </dc:title>
          </xsl:when>
          <xsl:otherwise>
            <dc:title>
              <xsl:value-of select="." />
            </dc:title>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:name[@type=&apos;personal&apos;]/mods:displayForm" mode="mods2dc">
    <dc:creator>
      <xsl:value-of select="." />
    </dc:creator>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:name[@type=&apos;corporate&apos;]/mods:namePart" mode="mods2dc">
    <dc:description>
      <xsl:value-of select="." />
    </dc:description>
    <dc:description>
      <xsl:value-of select="../mods:role/mods:roleTerm[@type=&quot;text&quot;]" />
    </dc:description>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:originInfo/mods:edition" mode="mods2dc">
    <dc:description>
      <xsl:value-of select="." />
    </dc:description>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:originInfo/mods:dateIssued[@keyDate=&apos;yes&apos;]" mode="mods2dc">
    <dc:date>
      <xsl:value-of select="." />
    </dc:date>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:originInfo/mods:issuance" mode="mods2dc">
    <dc:type>
      <xsl:value-of select="." />
    </dc:type>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:originInfo/mods:publisher" mode="mods2dc">
    <dc:publisher>
      <xsl:value-of select="." />
    </dc:publisher>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:language/mods:languageTerm" mode="mods2dc">
    <dc:language>
      <xsl:value-of select="." />
    </dc:language>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:note" mode="mods2dc">
    <xsl:if test="./@type=&apos;citation/reference&apos;">
      <dc:identifier>
        <xsl:value-of select="." />
      </dc:identifier>
    </xsl:if>
    <xsl:if test="not(./@type=&apos;citation/reference&apos;)">
      <dc:description>
        <xsl:value-of select="." />
      </dc:description>
    </xsl:if>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:typeOfResource" mode="mods2dc">
    <dc:type>
      <xsl:value-of select="." />
    </dc:type>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:genre" mode="mods2dc">
    <dc:type>
      <xsl:value-of select="." />
    </dc:type>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:physicalDescription/child::*" mode="mods2dc">
    <dc:format>
      <xsl:value-of select="." />
    </dc:format>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:identifier" mode="mods2dc">
    <dc:identifier>
      <xsl:choose>
        <xsl:when test="not(./@type = &apos;urn&apos;)">
          <xsl:value-of select="concat(./@type,&apos;:&apos;,.)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="." />
        </xsl:otherwise>
      </xsl:choose>
    </dc:identifier>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:relatedItem/mods:identifier[@type=&apos;eki&apos;]" mode="mods2dc">
    <dc:relation>
      <xsl:value-of select="." />
    </dc:relation>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:recordInfo/mods:recordIdentifier" mode="mods2dc">
    <dc:identifier>
      <xsl:value-of select="concat(&apos;system:&apos;,.)" />
    </dc:identifier>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:subject/child::*" mode="mods2dc">
    <xsl:choose>
      <xsl:when test="./child::*">
        <dc:subject>
          <xsl:value-of select="./child::*" />
        </dc:subject>
      </xsl:when>
      <xsl:otherwise>
        <dc:subject>
          <xsl:value-of select="." />
        </dc:subject>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:classification" mode="mods2dc">
    <xsl:choose>
      <xsl:when test="./@authority=&apos;ddc&apos;">
        <dc:subject>
          <xsl:value-of select="concat(&apos;DDC: &apos;,.)" />
        </dc:subject>
        <dc:subject>
          <xsl:value-of select="./@displayLabel" />
        </dc:subject>
      </xsl:when>
      <xsl:otherwise>
        <dc:subject>
          <xsl:value-of select="." />
        </dc:subject>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:accessCondition" mode="mods2dc">
    <dc:rights>
      <xsl:value-of select="." />
    </dc:rights>
    <xsl:if test="./@xlink:href">
      <dc:rights>
        <xsl:value-of select="./@xlink:href" />
      </dc:rights>
    </xsl:if>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:relatedItem[@type=&quot;host&quot; or @type=&quot;series&quot;]/mods:identifier" mode="mods2dc">
    <dc:relation>
      <xsl:value-of select="." />
    </dc:relation>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:relatedItem[@type=&quot;host&quot; or @type=&quot;series&quot;]/mods:titleInfo[not(@type=&quot;alternative&quot;)]/mods:title" mode="mods2dc">
    <xsl:choose>
      <xsl:when test="../mods:subTitle">
        <dcterms:isPartOf>
          <xsl:value-of select="concat(.,&apos; : &apos;,../mods:subTitle)" />
        </dcterms:isPartOf>
      </xsl:when>
      <xsl:otherwise>
        <dcterms:isPartOf>
          <xsl:value-of select="." />
        </dcterms:isPartOf>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="mets:dmdSec[@ID=$dmd_id]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:relatedItem[@type=&quot;host&quot; or @type=&quot;series&quot;]/mods:recordInfo/mods:recordIdentifier[@source=&quot;hbz&quot;]" mode="mods2dc">
    <dcterms:isPartOf>
      <xsl:value-of select="." />
    </dcterms:isPartOf>
  </xsl:template>
  <xsl:template match="mets:dmdSec[not(@ID=$dmd_id)]/mets:mdWrap[@MDTYPE=&apos;MODS&apos;]/mets:xmlData/mods:mods/mods:recordInfo/mods:recordIdentifier[@source=&quot;ubwretro&quot;]" mode="mods2dc">
    <dcterms:hasPart>
      <xsl:value-of select="." />
    </dcterms:hasPart>
  </xsl:template>
  <xsl:template match="node()" mode="mods2dc">
    <xsl:apply-templates mode="mods2dc" />
  </xsl:template>
  <!-- mets:structMap PHYSICAL Section -->
  <xsl:template match="mets:structMap[@TYPE=&apos;PHYSICAL&apos;]">
    <mets:structMap>
      <xsl:attribute name="TYPE">
        <xsl:value-of select="./@TYPE" />
      </xsl:attribute>
      <xsl:attribute name="ID">
        <xsl:value-of select="concat(&apos;structMap-&apos;, ./@TYPE, &apos;-&apos;, position())" />
      </xsl:attribute>
      <mets:div>
        <xsl:apply-templates select="mets:div/mets:div" mode="phys" />
      </mets:div>
    </mets:structMap>
  </xsl:template>
  <!-- mets:structMap LOGICAL Section -->
  <xsl:template match="mets:structMap[@TYPE=&apos;LOGICAL&apos;]">
    <mets:structMap>
      <xsl:attribute name="TYPE">
        <xsl:value-of select="./@TYPE" />
      </xsl:attribute>
      <xsl:attribute name="ID">
        <xsl:value-of select="concat(&apos;structMap-&apos;, ./@TYPE, &apos;-&apos;, position())" />
      </xsl:attribute>
      <mets:div>
        <xsl:apply-templates select="mets:div/mets:div" mode="logic" />
      </mets:div>
    </mets:structMap>
  </xsl:template>
  <!--  List file labels -->
  <!-- Differentiate between book and multivolumework -->
  <!-- PDFs -->
  <xsl:variable name="LabelPDF">
    <xsl:for-each select="//mets:structMap/mets:div">
      <PDFLabel label="{./mets:fptr/@FILEID}">
        <xsl:choose>
          <xsl:when test="not(./@LABEL)">
            <xsl:text>No label</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="./@LABEL" />
          </xsl:otherwise>
        </xsl:choose>
      </PDFLabel>
    </xsl:for-each>
  </xsl:variable>
  <!-- FRs -->
  <xsl:variable name="LabelFR">
    <xsl:for-each select="//mets:structMap/mets:div/mets:div">
      <FRLabel label="{./mets:fptr[2]/@FILEID}">
        <xsl:choose>
          <xsl:when test="not(./@LABEL)">
            <xsl:text>No label</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="./@LABEL" />
          </xsl:otherwise>
        </xsl:choose>
      </FRLabel>
    </xsl:for-each>
  </xsl:variable>
  <!-- Templates by default : do nothing -->
  <xsl:template match="@*|node()" />
</xsl:stylesheet>