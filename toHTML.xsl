<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">

  <xsl:output method="html" encoding="UTF8"/>


  <!-- on ajoute des liens pour les navigateurs qui n'ont pas javascript -->
  
  <xsl:template match="/">
    <html>
      <meta charset="UTF-8"/>
      <script
	  src="http://code.jquery.com/jquery-1.12.4.js"
	  integrity="sha256-Qw82+bXyGq6MydymqBxNPYTaUXXq7c8v3CwiYwLLNXU="
	  crossorigin="anonymous"></script>

      <script type='text/javascript'>
	<![CDATA[
		 $(document).ready(function(){
		      noteManagement();
		      $(window).scroll(function(){
		      noteManagement();   
		      })
		      $(window).resize(function(){
		      noteManagement();   
		      })
		 });
		 
		 function noteManagement(){
                    var noteList = document.getElementsByClassName("appelNote");
		    var i = 0;
		    var leHr=document.getElementById('leHrPourLesNotes');
		    leHrPourLesNotes.style.display = 'none';
		    for (i = 0; i < noteList.length; i++){
                       if (estVisible2(noteList[i].getAttribute("id"))){
		          document.getElementById(noteList[i].getAttribute("rel")).style.display = 'block';
		          leHrPourLesNotes.style.display = '';
		       }
		       else{
		          document.getElementById(noteList[i].getAttribute("rel")).style.display = 'none';
		       }; 
		    };
		 };


                 function estVisible2(elId){
                    var el = document.getElementById(elId);
                    var elemTop = el.getBoundingClientRect().top;
                    var elemBottom = el.getBoundingClientRect().bottom;
                    var isVisible = (elemTop >= 0) && (elemBottom <= window.innerHeight);
                    return isVisible;
                 };

                 function mouseOverAppel(t){
                    var el = document.getElementById(t.getAttribute('rel'));
		    el.style.color =  'blue';
                 };

                 function mouseOutAppel(t){
                    var el = document.getElementById(t.getAttribute('rel'));
		    el.style.color =  '';
                 };
		 function mouseOverNote(t){
                    var el = document.getElementById(t.getAttribute('rel'));
		    el.style.border =  'solid';
                 };
		 function mouseOutNote(t){
		    var el = document.getElementById(t.getAttribute('rel'));
		    el.style.border = '';
		 };
]]>
      </script>
      <!-- <div class="texte" style="overflow-y:auto; height:500px;" onscroll="noteManagement();">-->
    <div class="texte" style="border-style : solid; border-width  : 0cm 0cm 0.5cm 0cm; border-color:white; margin-left: 15%; margin-right: 15%; font-family: Georgia, serif; font-size: 130%; line-height: 150%;">
      <xsl:apply-templates select="//tei:text"/>
    </div>
    <!-- on met toute les notes dans un bandeau de bas de page.... -->
    <div class="notes" style="position: fixed; bottom :0;left:0;background: white; width: 100%;border-style : solid; border-width  : 0cm 0cm 0.5cm 0cm; border-color:white;">
      <div style="margin-left : 15%; margin-right: 15%;">
      <hr id="leHrPourLesNotes" width="40%" align="left"/>
      <xsl:for-each select="//tei:note">
	<span class="spNote"  id="{concat('note', generate-id())}" rel="{concat('appel', generate-id())}" onmouseover="mouseOverNote(this);" onmouseout="mouseOutNote(this);"><p style="text-align: justify;"><sup><xsl:value-of select="position()"/></sup><xsl:apply-templates/><a href="{concat('#appel', generate-id())}">⏎</a><br/></p></span>
      </xsl:for-each>
      
    </div></div>
    </html>
  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:p">
    <xsl:choose>
      <xsl:when test="ancestor::tei:note and not(preceding-sibling::*)">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<p style="text-align: justify; text-indent: 50px;">
	  <xsl:apply-templates/>
	</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
  <xsl:template match="text()">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template match="tei:head">
    <xsl:variable name="prof" select="count(ancestor::tei:div)"/>
    <xsl:element name="{concat('h', $prof)}">
      <xsl:apply-templates/>
    </xsl:element>
    
  </xsl:template>

  <xsl:template match="tei:hi">
    <xsl:variable name="rend" select="tokenize(@rend, ' ')"/>
    <span>
      <xsl:attribute name="style">
	<xsl:for-each select="$rend">
	  <xsl:choose>
	    <xsl:when test=".= 'italic'">
	      <xsl:text>font-style: italic;</xsl:text>
	    </xsl:when>
	    <xsl:when test=".= 'bold'">
	      <xsl:text>font-weight: bold;</xsl:text>
	    </xsl:when>
	  </xsl:choose> 
	</xsl:for-each>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:note">
    <span class="appelNote" rel="{concat('note', generate-id())}" id="{concat('appel', generate-id())}" onmouseover="mouseOverAppel(this);" onmouseout="mouseOutAppel(this);"><a href="{concat('#note', generate-id())}"><sup><xsl:value-of select="count(preceding::tei:note)+1"/></sup></a></span>
  </xsl:template>
  
</xsl:stylesheet>
