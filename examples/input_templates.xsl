<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="xsl" xmlns:php="http://php.net/xsl">
 
  
  <xsl:template name="TextInput">
  	<xsl:param name="Name"/>
  	<xsl:param name="MaxLength"/>
  	<xsl:param name="Size"/>
  	<xsl:param name="Value"/>
  	<xsl:param name="Class" />
  		<input type="text" id="{$Name}" name="{$Name}" value="{$Value}">
  			<xsl:attribute name="value"><xsl:value-of select="$Value"/></xsl:attribute>
  			<xsl:if test="$Size!=''"><xsl:attribute name="size"><xsl:value-of select="$Size"/></xsl:attribute></xsl:if>
  			<xsl:if test="$MaxLength!=''"><xsl:attribute name="maxlength"><xsl:value-of select="$MaxLength"/></xsl:attribute></xsl:if>
  			<xsl:if test="$Class != ''"><xsl:attribute name="class"><xsl:value-of select="$Class"/></xsl:attribute></xsl:if>
  			<!-- cheating with the class parameter here - it should only be used to apply style sheets, not as a test to change other attributes, but the item that uses it (IP address) will eventually be removed anyway-->
  			<xsl:if test="$Class = 'readonly'"><xsl:attribute name="disabled">true</xsl:attribute></xsl:if>
  			<xsl:if test="/XML/RequestErrors/*[name()=$Name]"><xsl:attribute name="class">errorfield</xsl:attribute></xsl:if>
  			<xsl:text></xsl:text>
  		</input>
			<xsl:if test="/XML/RequestErrors/*[name()=$Name]">
  			<xsl:call-template name="ErrorIcon">
  				<xsl:with-param name="ErrorText" select="/XML/RequestErrors/*[name()=$Name]"/>
  			</xsl:call-template>
  		</xsl:if>
  </xsl:template>



  <xsl:template name="PwdInput">
  	<xsl:param name="Name"/>
  	<xsl:param name="MaxLength"/>
  	<xsl:param name="Size"/>
  	<xsl:param name="Value"/>
  		<input type="password" id="{$Name}" name="{$Name}" value="{$Value}">
  			<xsl:attribute name="value"><xsl:value-of select="$Value"/></xsl:attribute>
  			<xsl:if test="$Size!=''"><xsl:attribute name="size"><xsl:value-of select="$Size"/></xsl:attribute></xsl:if>
  			<xsl:if test="$MaxLength!=''"><xsl:attribute name="maxlength"><xsl:value-of select="$MaxLength"/></xsl:attribute></xsl:if>
  			<xsl:if test="/XML/RequestErrors/*[name()=$Name]"><xsl:attribute name="class">errorfield</xsl:attribute></xsl:if>
  			<xsl:text></xsl:text>
  		</input>
  		<xsl:if test="/XML/RequestErrors/*[name()=$Name]">
  			<xsl:call-template name="ErrorIcon">
  				<xsl:with-param name="ErrorText" select="/XML/RequestErrors/*[name()=$Name]"/>
  			</xsl:call-template>
  		</xsl:if>
  </xsl:template>

  <xsl:template name="ErrorIcon">
  	<xsl:param name="ErrorText"/>
  	
  	<p class="errornote">
  		<xsl:value-of select="$ErrorText"/>
  	</p>
  	
  </xsl:template>


<xsl:template name="RadioInput">
	<xsl:param name="Name"/>
	<xsl:param name="OptionValue"/>
	<xsl:param name="Value"/>
	<xsl:param name="ID"/>
	<xsl:param name="onchange"/>
	<xsl:param name="Label" />

		<input type="radio" id="{$ID}" name="{$Name}" value="{$OptionValue}" onclick="{$onchange}" >
			<xsl:attribute name="class">checkbox<xsl:if test="/XML/RequestErrors/*[name()=$Name]"> errorfield</xsl:if></xsl:attribute>
			<xsl:if test="$Value=$OptionValue"><xsl:attribute name="checked">yes</xsl:attribute></xsl:if>
		</input>
		<xsl:if test="string($Label)">
			<xsl:text> </xsl:text>
			<label for="{$ID}"><xsl:value-of select="$Label" /></label>
		</xsl:if>

</xsl:template>



<xsl:template name="CheckboxInput">
	<xsl:param name="Name"/>
	<xsl:param name="Value"/>
	<xsl:param name="Label" />
		<input type="checkbox" id="{$Name}" name="{$Name}" value="1">
			<xsl:attribute name="class">checkbox<xsl:if test="/XML/RequestErrors/*[name()=$Name]"> errorfield</xsl:if></xsl:attribute>
			<xsl:if test="$Value='1'"><xsl:attribute name="checked">yes</xsl:attribute></xsl:if>
			<xsl:text></xsl:text>
		</input>
		
		<xsl:if test="string($Label)">
			<xsl:text> </xsl:text>
			<label for="{$Name}"><xsl:value-of select="$Label" /></label>
		</xsl:if>
		
		<xsl:if test="/XML/RequestErrors/*[name()=$Name]">
			<xsl:call-template name="ErrorIcon">
				<xsl:with-param name="ErrorText" select="/XML/RequestErrors/*[name()=$Name]"/>
			</xsl:call-template>
		</xsl:if>
</xsl:template>

<xsl:template name="MultiCheckboxInput">
	<xsl:param name="Name"/>
	<xsl:param name="Value"/>
	<xsl:param name="Checked"/>
		<input type="checkbox" id="{$Name}" name="{$Name}" value="{$Value}">
			<xsl:attribute name="class">checkbox<xsl:if test="/XML/RequestErrors/*[name()=$Name]"> errorfield</xsl:if></xsl:attribute>
			<xsl:if test="$Checked='1'"><xsl:attribute name="checked">yes</xsl:attribute></xsl:if>
			<xsl:text></xsl:text>
		</input>
		<xsl:if test="/XML/RequestErrors/*[name()=$Name]">
			<xsl:call-template name="ErrorIcon">
				<xsl:with-param name="ErrorText" select="/XML/RequestErrors/*[name()=$Name]"/>
			</xsl:call-template>
		</xsl:if>
</xsl:template>


<xsl:template name="TextareaInput">
	<xsl:param name="Name"/>
	<xsl:param name="Value"/>
	<textarea id="{$Name}" name="{$Name}" rows="5" cols="30">
		<xsl:if test="/XML/RequestErrors/*[name()=$Name]"><xsl:attribute name="class">errorfield</xsl:attribute></xsl:if>
		<xsl:value-of select="$Value" />
		<xsl:text> </xsl:text>
	</textarea>
	<xsl:if test="/XML/RequestErrors/*[name()=$Name]">
		<xsl:call-template name="ErrorIcon">
			<xsl:with-param name="ErrorText" select="/XML/RequestErrors/*[name()=$Name]"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>


<xsl:template name="SelectTitle">
  <xsl:param name="Value" select="'Mr'" />
	<xsl:param name="FieldName"/>
	<xsl:param name="Problem"/>
	<select name="{$FieldName}" id="{$FieldName}">
	  <xsl:attribute name="class"><xsl:if test="/XML/RequestErrors/*[name()=$FieldName]">errorfield</xsl:if></xsl:attribute>
		<xsl:if test="$Problem='Yes'"><xsl:attribute name="style">background-color: pink;</xsl:attribute></xsl:if>
		
		  <option value="Dr"><xsl:if test="$Value='Dr'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Dr</option>
		  <option value="Professor"><xsl:if test="$Value='Professor'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Professor</option>
		  <option value="Mr"><xsl:if test="$Value='Mr'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Mr</option>
		  <option value="Ms"><xsl:if test="$Value='Ms'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Ms</option>
		  <option value="Miss"><xsl:if test="$Value='Miss'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Miss</option>
		  <option value="Mrs"><xsl:if test="$Value='Mrs'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Mrs</option>
		  <option value="Dame"><xsl:if test="$Value='Dame'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Dame</option>
		  <option value="Sir"><xsl:if test="$Value='Sir'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Sir</option>
		  <option value="Lady"><xsl:if test="$Value='Lady'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Lady</option>
		  <option value="Lord"><xsl:if test="$Value='Lord'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Lord</option>
		
		</select>
		<xsl:if test="/XML/RequestErrors/*[name()=$FieldName]">
			<xsl:call-template name="ErrorIcon">
				<xsl:with-param name="ErrorText" select="/XML/RequestErrors/*[name()=$FieldName]"/>
			</xsl:call-template>
		</xsl:if>

</xsl:template>


<!--
	Countries option 
	
	build from data/symfony/i18n/en.dat with this :
	
	<?php
	$arr = unserialize(file_get_contents('en.dat'));
	foreach($arr['Countries'] as $id=>$v)
	{
	  echo "<option value=\"$id\"><xsl:if test=\"\$CountryCode='$id'\"><xsl:attribute name=\"selected\">yes</xsl:attribute></xsl:if>{$v[0]}</option>\n";
	}

-->
<xsl:template name="SelectCountries">
	<xsl:param name="CountryCode"/>
	<xsl:param name="DisplayBlank"/>
	<xsl:param name="Name"/>
	<xsl:param name="Problem"/>
	<select name="{$Name}" id="{$Name}">
	  <xsl:attribute name="class"><xsl:if test="/XML/RequestErrors/*[name()=$Name]">errorfield</xsl:if></xsl:attribute>
		<xsl:if test="$Problem='Yes'"><xsl:attribute name="style">background-color: pink;</xsl:attribute></xsl:if>
		<xsl:if test="$DisplayBlank=true"><option value=""></option></xsl:if>
		<option value="AD"><xsl:if test="$CountryCode='AD'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Andorra</option>
		<option value="AE"><xsl:if test="$CountryCode='AE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>United Arab Emirates</option>
		<option value="AF"><xsl:if test="$CountryCode='AF'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Afghanistan</option>
		<option value="AG"><xsl:if test="$CountryCode='AG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Antigua and Barbuda</option>
		<option value="AI"><xsl:if test="$CountryCode='AI'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Anguilla</option>
		<option value="AL"><xsl:if test="$CountryCode='AL'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Albania</option>
		<option value="AM"><xsl:if test="$CountryCode='AM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Armenia</option>
		<option value="AN"><xsl:if test="$CountryCode='AN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Netherlands Antilles</option>
		<option value="AO"><xsl:if test="$CountryCode='AO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Angola</option>
		<option value="AQ"><xsl:if test="$CountryCode='AQ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Antarctica</option>
		<option value="AR"><xsl:if test="$CountryCode='AR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Argentina</option>
		<option value="AS"><xsl:if test="$CountryCode='AS'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>American Samoa</option>
		<option value="AT"><xsl:if test="$CountryCode='AT'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Austria</option>
		<option value="AU"><xsl:if test="$CountryCode='AU'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Australia</option>
		<option value="AW"><xsl:if test="$CountryCode='AW'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Aruba</option>
		<option value="AZ"><xsl:if test="$CountryCode='AZ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Azerbaijan</option>
		<option value="BA"><xsl:if test="$CountryCode='BA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Bosnia and Herzegovina</option>
		<option value="BB"><xsl:if test="$CountryCode='BB'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Barbados</option>
		<option value="BD"><xsl:if test="$CountryCode='BD'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Bangladesh</option>
		<option value="BE"><xsl:if test="$CountryCode='BE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Belgium</option>
		<option value="BF"><xsl:if test="$CountryCode='BF'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Burkina Faso</option>
		<option value="BG"><xsl:if test="$CountryCode='BG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Bulgaria</option>
		<option value="BH"><xsl:if test="$CountryCode='BH'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Bahrain</option>
		<option value="BI"><xsl:if test="$CountryCode='BI'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Burundi</option>
		<option value="BJ"><xsl:if test="$CountryCode='BJ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Benin</option>
		<option value="BM"><xsl:if test="$CountryCode='BM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Bermuda</option>
		<option value="BN"><xsl:if test="$CountryCode='BN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Brunei</option>
		<option value="BO"><xsl:if test="$CountryCode='BO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Bolivia</option>
		<option value="BR"><xsl:if test="$CountryCode='BR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Brazil</option>
		<option value="BS"><xsl:if test="$CountryCode='BS'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Bahamas</option>
		<option value="BT"><xsl:if test="$CountryCode='BT'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Bhutan</option>
		<option value="BV"><xsl:if test="$CountryCode='BV'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Bouvet Island</option>
		<option value="BW"><xsl:if test="$CountryCode='BW'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Botswana</option>
		<option value="BY"><xsl:if test="$CountryCode='BY'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Belarus</option>
		<option value="BZ"><xsl:if test="$CountryCode='BZ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Belize</option>
		<option value="CA"><xsl:if test="$CountryCode='CA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Canada</option>
		<option value="CC"><xsl:if test="$CountryCode='CC'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Cocos (Keeling) Islands</option>
		<option value="CD"><xsl:if test="$CountryCode='CD'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Democratic Republic of the Congo</option>
		<option value="CF"><xsl:if test="$CountryCode='CF'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Central African Republic</option>
		<option value="CG"><xsl:if test="$CountryCode='CG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Congo</option>
		<option value="CH"><xsl:if test="$CountryCode='CH'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Switzerland</option>
		<option value="CI"><xsl:if test="$CountryCode='CI'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Côte d’Ivoire</option>
		<option value="CK"><xsl:if test="$CountryCode='CK'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Cook Islands</option>
		<option value="CL"><xsl:if test="$CountryCode='CL'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Chile</option>
		<option value="CM"><xsl:if test="$CountryCode='CM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Cameroon</option>
		<option value="CN"><xsl:if test="$CountryCode='CN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>China</option>
		<option value="CO"><xsl:if test="$CountryCode='CO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Colombia</option>
		<option value="CR"><xsl:if test="$CountryCode='CR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Costa Rica</option>
		<option value="CU"><xsl:if test="$CountryCode='CU'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Cuba</option>
		<option value="CV"><xsl:if test="$CountryCode='CV'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Cape Verde</option>
		<option value="CX"><xsl:if test="$CountryCode='CX'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Christmas Island</option>
		<option value="CY"><xsl:if test="$CountryCode='CY'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Cyprus</option>
		<option value="CZ"><xsl:if test="$CountryCode='CZ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Czech Republic</option>
		<option value="DE"><xsl:if test="$CountryCode='DE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Germany</option>
		<option value="DJ"><xsl:if test="$CountryCode='DJ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Djibouti</option>
		<option value="DK"><xsl:if test="$CountryCode='DK'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Denmark</option>
		<option value="DM"><xsl:if test="$CountryCode='DM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Dominica</option>
		<option value="DO"><xsl:if test="$CountryCode='DO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Dominican Republic</option>
		<option value="DZ"><xsl:if test="$CountryCode='DZ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Algeria</option>
		<option value="EC"><xsl:if test="$CountryCode='EC'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Ecuador</option>
		<option value="EE"><xsl:if test="$CountryCode='EE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Estonia</option>
		<option value="EG"><xsl:if test="$CountryCode='EG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Egypt</option>
		<option value="EH"><xsl:if test="$CountryCode='EH'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Western Sahara</option>
		<option value="ER"><xsl:if test="$CountryCode='ER'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Eritrea</option>
		<option value="ES"><xsl:if test="$CountryCode='ES'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Spain</option>
		<option value="ET"><xsl:if test="$CountryCode='ET'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Ethiopia</option>
		<option value="FI"><xsl:if test="$CountryCode='FI'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Finland</option>
		<option value="FJ"><xsl:if test="$CountryCode='FJ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Fiji</option>
		<option value="FK"><xsl:if test="$CountryCode='FK'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Falkland Islands</option>
		<option value="FM"><xsl:if test="$CountryCode='FM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Micronesia</option>
		<option value="FO"><xsl:if test="$CountryCode='FO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Faroe Islands</option>
		<option value="FR"><xsl:if test="$CountryCode='FR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>France</option>
		<option value="GA"><xsl:if test="$CountryCode='GA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Gabon</option>
		<option value="GB"><xsl:if test="$CountryCode='GB'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>United Kingdom</option>
		<option value="GD"><xsl:if test="$CountryCode='GD'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Grenada</option>
		<option value="GE"><xsl:if test="$CountryCode='GE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Georgia</option>
		<option value="GF"><xsl:if test="$CountryCode='GF'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>French Guiana</option>
		<option value="GH"><xsl:if test="$CountryCode='GH'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Ghana</option>
		<option value="GI"><xsl:if test="$CountryCode='GI'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Gibraltar</option>
		<option value="GL"><xsl:if test="$CountryCode='GL'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Greenland</option>
		<option value="GM"><xsl:if test="$CountryCode='GM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Gambia</option>
		<option value="GN"><xsl:if test="$CountryCode='GN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Guinea</option>
		<option value="GP"><xsl:if test="$CountryCode='GP'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Guadeloupe</option>
		<option value="GQ"><xsl:if test="$CountryCode='GQ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Equatorial Guinea</option>
		<option value="GR"><xsl:if test="$CountryCode='GR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Greece</option>
		<option value="GS"><xsl:if test="$CountryCode='GS'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>South Georgia and the South Sandwich Islands</option>
		<option value="GT"><xsl:if test="$CountryCode='GT'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Guatemala</option>
		<option value="GU"><xsl:if test="$CountryCode='GU'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Guam</option>
		<option value="GW"><xsl:if test="$CountryCode='GW'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Guinea-Bissau</option>
		<option value="GY"><xsl:if test="$CountryCode='GY'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Guyana</option>
		<option value="HK"><xsl:if test="$CountryCode='HK'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Hong Kong S.A.R., China</option>
		<option value="HM"><xsl:if test="$CountryCode='HM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Heard Island and McDonald Islands</option>
		<option value="HN"><xsl:if test="$CountryCode='HN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Honduras</option>
		<option value="HR"><xsl:if test="$CountryCode='HR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Croatia</option>
		<option value="HT"><xsl:if test="$CountryCode='HT'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Haiti</option>
		<option value="HU"><xsl:if test="$CountryCode='HU'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Hungary</option>
		<option value="ID"><xsl:if test="$CountryCode='ID'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Indonesia</option>
		<option value="IE"><xsl:if test="$CountryCode='IE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Ireland</option>
		<option value="IL"><xsl:if test="$CountryCode='IL'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Israel</option>
		<option value="IN"><xsl:if test="$CountryCode='IN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>India</option>
		<option value="IO"><xsl:if test="$CountryCode='IO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>British Indian Ocean Territory</option>
		<option value="IQ"><xsl:if test="$CountryCode='IQ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Iraq</option>
		<option value="IR"><xsl:if test="$CountryCode='IR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Iran</option>
		<option value="IS"><xsl:if test="$CountryCode='IS'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Iceland</option>
		<option value="IT"><xsl:if test="$CountryCode='IT'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Italy</option>
		<option value="JM"><xsl:if test="$CountryCode='JM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Jamaica</option>
		<option value="JO"><xsl:if test="$CountryCode='JO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Jordan</option>
		<option value="JP"><xsl:if test="$CountryCode='JP'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Japan</option>
		<option value="KE"><xsl:if test="$CountryCode='KE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Kenya</option>
		<option value="KG"><xsl:if test="$CountryCode='KG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Kyrgyzstan</option>
		<option value="KH"><xsl:if test="$CountryCode='KH'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Cambodia</option>
		<option value="KI"><xsl:if test="$CountryCode='KI'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Kiribati</option>
		<option value="KM"><xsl:if test="$CountryCode='KM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Comoros</option>
		<option value="KN"><xsl:if test="$CountryCode='KN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Saint Kitts and Nevis</option>
		<option value="KP"><xsl:if test="$CountryCode='KP'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>North Korea</option>
		<option value="KR"><xsl:if test="$CountryCode='KR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>South Korea</option>
		<option value="KW"><xsl:if test="$CountryCode='KW'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Kuwait</option>
		<option value="KY"><xsl:if test="$CountryCode='KY'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Cayman Islands</option>
		<option value="KZ"><xsl:if test="$CountryCode='KZ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Kazakhstan</option>
		<option value="LA"><xsl:if test="$CountryCode='LA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Laos</option>
		<option value="LB"><xsl:if test="$CountryCode='LB'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Lebanon</option>
		<option value="LC"><xsl:if test="$CountryCode='LC'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Saint Lucia</option>
		<option value="LI"><xsl:if test="$CountryCode='LI'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Liechtenstein</option>
		<option value="LK"><xsl:if test="$CountryCode='LK'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Sri Lanka</option>
		<option value="LR"><xsl:if test="$CountryCode='LR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Liberia</option>
		<option value="LS"><xsl:if test="$CountryCode='LS'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Lesotho</option>
		<option value="LT"><xsl:if test="$CountryCode='LT'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Lithuania</option>
		<option value="LU"><xsl:if test="$CountryCode='LU'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Luxembourg</option>
		<option value="LV"><xsl:if test="$CountryCode='LV'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Latvia</option>
		<option value="LY"><xsl:if test="$CountryCode='LY'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Libya</option>
		<option value="MA"><xsl:if test="$CountryCode='MA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Morocco</option>
		<option value="MC"><xsl:if test="$CountryCode='MC'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Monaco</option>
		<option value="MD"><xsl:if test="$CountryCode='MD'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Moldova</option>
		<option value="MG"><xsl:if test="$CountryCode='MG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Madagascar</option>
		<option value="MH"><xsl:if test="$CountryCode='MH'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Marshall Islands</option>
		<option value="MK"><xsl:if test="$CountryCode='MK'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Macedonia</option>
		<option value="ML"><xsl:if test="$CountryCode='ML'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Mali</option>
		<option value="MM"><xsl:if test="$CountryCode='MM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Myanmar</option>
		<option value="MN"><xsl:if test="$CountryCode='MN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Mongolia</option>
		<option value="MO"><xsl:if test="$CountryCode='MO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Macao S.A.R., China</option>
		<option value="MP"><xsl:if test="$CountryCode='MP'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Northern Mariana Islands</option>
		<option value="MQ"><xsl:if test="$CountryCode='MQ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Martinique</option>
		<option value="MR"><xsl:if test="$CountryCode='MR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Mauritania</option>
		<option value="MS"><xsl:if test="$CountryCode='MS'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Montserrat</option>
		<option value="MT"><xsl:if test="$CountryCode='MT'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Malta</option>
		<option value="MU"><xsl:if test="$CountryCode='MU'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Mauritius</option>
		<option value="MV"><xsl:if test="$CountryCode='MV'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Maldives</option>
		<option value="MW"><xsl:if test="$CountryCode='MW'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Malawi</option>
		<option value="MX"><xsl:if test="$CountryCode='MX'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Mexico</option>
		<option value="MY"><xsl:if test="$CountryCode='MY'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Malaysia</option>
		<option value="MZ"><xsl:if test="$CountryCode='MZ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Mozambique</option>
		<option value="NA"><xsl:if test="$CountryCode='NA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Namibia</option>
		<option value="NC"><xsl:if test="$CountryCode='NC'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>New Caledonia</option>
		<option value="NE"><xsl:if test="$CountryCode='NE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Niger</option>
		<option value="NF"><xsl:if test="$CountryCode='NF'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Norfolk Island</option>
		<option value="NG"><xsl:if test="$CountryCode='NG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Nigeria</option>
		<option value="NI"><xsl:if test="$CountryCode='NI'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Nicaragua</option>
		<option value="NL"><xsl:if test="$CountryCode='NL'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Netherlands</option>
		<option value="NO"><xsl:if test="$CountryCode='NO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Norway</option>
		<option value="NP"><xsl:if test="$CountryCode='NP'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Nepal</option>
		<option value="NR"><xsl:if test="$CountryCode='NR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Nauru</option>
		<option value="NU"><xsl:if test="$CountryCode='NU'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Niue</option>
		<option value="NZ"><xsl:if test="$CountryCode='NZ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>New Zealand</option>
		<option value="OM"><xsl:if test="$CountryCode='OM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Oman</option>
		<option value="PA"><xsl:if test="$CountryCode='PA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Panama</option>
		<option value="PE"><xsl:if test="$CountryCode='PE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Peru</option>
		<option value="PF"><xsl:if test="$CountryCode='PF'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>French Polynesia</option>
		<option value="PG"><xsl:if test="$CountryCode='PG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Papua New Guinea</option>
		<option value="PH"><xsl:if test="$CountryCode='PH'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Philippines</option>
		<option value="PK"><xsl:if test="$CountryCode='PK'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Pakistan</option>
		<option value="PL"><xsl:if test="$CountryCode='PL'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Poland</option>
		<option value="PM"><xsl:if test="$CountryCode='PM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Saint Pierre and Miquelon</option>
		<option value="PN"><xsl:if test="$CountryCode='PN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Pitcairn</option>
		<option value="PR"><xsl:if test="$CountryCode='PR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Puerto Rico</option>
		<option value="PS"><xsl:if test="$CountryCode='PS'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Palestinian Territory</option>
		<option value="PT"><xsl:if test="$CountryCode='PT'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Portugal</option>
		<option value="PW"><xsl:if test="$CountryCode='PW'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Palau</option>
		<option value="PY"><xsl:if test="$CountryCode='PY'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Paraguay</option>
		<option value="QA"><xsl:if test="$CountryCode='QA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Qatar</option>
		<option value="RE"><xsl:if test="$CountryCode='RE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Réunion</option>
		<option value="RO"><xsl:if test="$CountryCode='RO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Romania</option>
		<option value="RU"><xsl:if test="$CountryCode='RU'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Russia</option>
		<option value="RW"><xsl:if test="$CountryCode='RW'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Rwanda</option>
		<option value="SA"><xsl:if test="$CountryCode='SA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Saudi Arabia</option>
		<option value="SB"><xsl:if test="$CountryCode='SB'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Solomon Islands</option>
		<option value="SC"><xsl:if test="$CountryCode='SC'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Seychelles</option>
		<option value="SD"><xsl:if test="$CountryCode='SD'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Sudan</option>
		<option value="SE"><xsl:if test="$CountryCode='SE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Sweden</option>
		<option value="SG"><xsl:if test="$CountryCode='SG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Singapore</option>
		<option value="SH"><xsl:if test="$CountryCode='SH'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Saint Helena</option>
		<option value="SI"><xsl:if test="$CountryCode='SI'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Slovenia</option>
		<option value="SJ"><xsl:if test="$CountryCode='SJ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Svalbard and Jan Mayen</option>
		<option value="SK"><xsl:if test="$CountryCode='SK'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Slovakia</option>
		<option value="SL"><xsl:if test="$CountryCode='SL'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Sierra Leone</option>
		<option value="SM"><xsl:if test="$CountryCode='SM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>San Marino</option>
		<option value="SN"><xsl:if test="$CountryCode='SN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Senegal</option>
		<option value="SO"><xsl:if test="$CountryCode='SO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Somalia</option>
		<option value="SP"><xsl:if test="$CountryCode='SP'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Serbia</option>
		<option value="SR"><xsl:if test="$CountryCode='SR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Suriname</option>
		<option value="ST"><xsl:if test="$CountryCode='ST'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Sao Tome and Principe</option>
		<option value="SV"><xsl:if test="$CountryCode='SV'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>El Salvador</option>
		<option value="SY"><xsl:if test="$CountryCode='SY'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Syria</option>
		<option value="SZ"><xsl:if test="$CountryCode='SZ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Swaziland</option>
		<option value="TC"><xsl:if test="$CountryCode='TC'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Turks and Caicos Islands</option>
		<option value="TD"><xsl:if test="$CountryCode='TD'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Chad</option>
		<option value="TF"><xsl:if test="$CountryCode='TF'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>French Southern Territories</option>
		<option value="TG"><xsl:if test="$CountryCode='TG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Togo</option>
		<option value="TH"><xsl:if test="$CountryCode='TH'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Thailand</option>
		<option value="TJ"><xsl:if test="$CountryCode='TJ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Tajikistan</option>
		<option value="TK"><xsl:if test="$CountryCode='TK'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Tokelau</option>
		<option value="TL"><xsl:if test="$CountryCode='TL'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Timor-Leste</option>
		<option value="TM"><xsl:if test="$CountryCode='TM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Turkmenistan</option>
		<option value="TN"><xsl:if test="$CountryCode='TN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Tunisia</option>
		<option value="TO"><xsl:if test="$CountryCode='TO'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Tonga</option>
		<option value="TR"><xsl:if test="$CountryCode='TR'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Turkey</option>
		<option value="TT"><xsl:if test="$CountryCode='TT'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Trinidad and Tobago</option>
		<option value="TV"><xsl:if test="$CountryCode='TV'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Tuvalu</option>
		<option value="TW"><xsl:if test="$CountryCode='TW'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Taiwan</option>
		<option value="TZ"><xsl:if test="$CountryCode='TZ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Tanzania</option>
		<option value="UA"><xsl:if test="$CountryCode='UA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Ukraine</option>
		<option value="UG"><xsl:if test="$CountryCode='UG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Uganda</option>
		<option value="UM"><xsl:if test="$CountryCode='UM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>United States Minor Outlying Islands</option>
		<option value="US"><xsl:if test="$CountryCode='US'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>United States</option>
		<option value="UY"><xsl:if test="$CountryCode='UY'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Uruguay</option>
		<option value="UZ"><xsl:if test="$CountryCode='UZ'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Uzbekistan</option>
		<option value="VA"><xsl:if test="$CountryCode='VA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Vatican</option>
		<option value="VC"><xsl:if test="$CountryCode='VC'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Saint Vincent and the Grenadines</option>
		<option value="VE"><xsl:if test="$CountryCode='VE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Venezuela</option>
		<option value="VG"><xsl:if test="$CountryCode='VG'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>British Virgin Islands</option>
		<option value="VI"><xsl:if test="$CountryCode='VI'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>U.S. Virgin Islands</option>
		<option value="VN"><xsl:if test="$CountryCode='VN'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Vietnam</option>
		<option value="VU"><xsl:if test="$CountryCode='VU'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Vanuatu</option>
		<option value="WF"><xsl:if test="$CountryCode='WF'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Wallis and Futuna</option>
		<option value="WS"><xsl:if test="$CountryCode='WS'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Samoa</option>
		<option value="YE"><xsl:if test="$CountryCode='YE'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Yemen</option>
		<option value="YT"><xsl:if test="$CountryCode='YT'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Mayotte</option>
		<option value="YU"><xsl:if test="$CountryCode='YU'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Yugoslavia</option>
		<option value="ZA"><xsl:if test="$CountryCode='ZA'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>South Africa</option>
		<option value="ZM"><xsl:if test="$CountryCode='ZM'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Zambia</option>
		<option value="ZW"><xsl:if test="$CountryCode='ZW'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Zimbabwe</option>
	</select>
	<xsl:if test="/XML/RequestErrors/*[name()=$Name]">
		<xsl:call-template name="ErrorIcon">
			<xsl:with-param name="ErrorText" select="/XML/RequestErrors/*[name()=$Name]"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>


<xsl:template name="FileInput">
	<xsl:param name="Name"/>
	<xsl:param name="Size"/>
	<xsl:param name="Value"/>
	<xsl:param name="Class" />
		<!-- File input fields cannot be pre-filled, so pass the value through the hidden field so that the value isn't lost -->
		<input type="hidden" id="hdn{$Name}" name="hdn{$Name}" value="{$Value}" />
		<input type="file" id="{$Name}" name="{$Name}" value="{$Value}">
			<xsl:attribute name="value"><xsl:value-of select="$Value"/></xsl:attribute>
			<xsl:if test="$Size!=''"><xsl:attribute name="size"><xsl:value-of select="$Size"/></xsl:attribute></xsl:if>
			<xsl:if test="$Class != ''"><xsl:attribute name="class"><xsl:value-of select="$Class"/></xsl:attribute></xsl:if>
			<!-- cheating with the class parameter here - it should only be used to apply style sheets, not as a test to change other attributes, but the item that uses it (IP address) will eventually be removed anyway-->
			<xsl:if test="$Class = 'readonly'"><xsl:attribute name="disabled">true</xsl:attribute></xsl:if>
			<xsl:if test="/XML/RequestErrors/*[name()=$Name]"><xsl:attribute name="class">errorfield</xsl:attribute></xsl:if>
			<xsl:text></xsl:text>
		</input>
		<xsl:if test="/XML/RequestErrors/*[name()=$Name]">
			<xsl:call-template name="ErrorIcon">
				<xsl:with-param name="ErrorText" select="/XML/RequestErrors/*[name()=$Name]"/>
			</xsl:call-template>
		</xsl:if>
</xsl:template>




	<xsl:template name="DateInput">
		<!-- TODO: Add formatting -->
		<xsl:param name="Name"/>
		<xsl:param name="Value"/>
		<xsl:param name="Format">%Y/%m/%d</xsl:param>
		<!-- Default date format is year, month, day.
			It could be set to "%Y-%m-%d %k:%M" to display date+time
		-->
		<input type="text" name="{$Name}" id="{$Name}" value="{$Value}">
			<xsl:if test="/XML/RequestErrors/*[name()=$Name]"><xsl:attribute name="class">errorfield</xsl:attribute></xsl:if>
		</input><img id="trigger_{$Name}" style="cursor: pointer; vertical-align: middle" src="{$RootPath}sf/sf_admin/images/date.png" alt="Date" />
	<script type="text/javascript">
    document.getElementById("trigger_<xsl:value-of select="$Name" />").disabled = false;
    Calendar.setup({
      inputField : "<xsl:value-of select="$Name" />",
      ifFormat : "<xsl:value-of select="$Format" />",
      daFormat : "<xsl:value-of select="$Format" />",
      button : "trigger_<xsl:value-of select="$Name" />",
 showsTime : true
    });
  </script>
		<xsl:if test="/XML/RequestErrors/*[name()=$Name]">
			<xsl:call-template name="ErrorIcon">
				<xsl:with-param name="ErrorText" select="/XML/RequestErrors/*[name()=$Name]"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template name="SimpleDateInput">
		<xsl:param name="Name"/>
		<xsl:param name="Size"/>
		<xsl:param name="Value"/>
		<xsl:param name="DateType"/>
		<select name="[year]" id="_year">
			<option value="1965">1965</option> 
			<option value="1966">1966</option> 
			<option value="1967">1967</option> 
			<option value="1968">1968</option> 
			<option value="1969">1969</option> 
			<option value="1970" selected="selected">1970</option> 
			<option value="1971">1971</option> 
			<option value="1972">1972</option> 
			<option value="1973">1973</option> 
			<option value="1974">1974</option> 
			<option value="1975">1975</option> 
		</select>-<select name="[month]" id="_month">
			<option value="1" selected="selected">January</option> 
			<option value="2">February</option> 
			<option value="3">March</option> 
			<option value="4">April</option> 
			<option value="5">May</option> 
			<option value="6">June</option> 
			<option value="7">July</option> 
			<option value="8">August</option> 
			<option value="9">September</option> 
			<option value="10">October</option> 
			<option value="11">November</option> 
			<option value="12">December</option> 
		</select>-<select name="[day]" id="_day">
			<option value="1" selected="selected">01</option> 
			<option value="2">02</option> 
			<option value="3">03</option> 
			<option value="4">04</option> 
			<option value="5">05</option> 
			<option value="6">06</option> 
			<option value="7">07</option> 
			<option value="8">08</option> 
			<option value="9">09</option> 
			<option value="10">10</option> 
			<option value="11">11</option> 
			<option value="12">12</option> 
			<option value="13">13</option> 
			<option value="14">14</option> 
			<option value="15">15</option> 
			<option value="16">16</option> 
			<option value="17">17</option> 
			<option value="18">18</option> 
			<option value="19">19</option> 
			<option value="20">20</option> 
			<option value="21">21</option> 
			<option value="22">22</option> 
			<option value="23">23</option> 
			<option value="24">24</option> 
			<option value="25">25</option> 
			<option value="26">26</option> 
			<option value="27">27</option> 
			<option value="28">28</option> 
			<option value="29">29</option> 
			<option value="30">30</option> 
			<option value="31">31</option>
		</select>
	</xsl:template>

	<xsl:template name="SubmitButton">
		<xsl:param name="Label">Submit</xsl:param>
		<input type="submit" value="{$Label}" />
	</xsl:template>


	<xsl:template name="SelectOccupation">
		<xsl:param name="Value" />
		<xsl:param name="Name"/>
		<xsl:param name="Problem"/>
		<select name="{$Name}" id="{$Name}">
			<xsl:attribute name="class"><xsl:if test="/XML/RequestErrors/*[name()=$FieldName]">errorfield</xsl:if></xsl:attribute>
			<xsl:if test="$Problem='Yes'"><xsl:attribute name="style">background-color: pink;</xsl:attribute></xsl:if>

			<option value="Accounting &amp; Finance"><xsl:if test="$Value='Accounting &amp; Finance'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Accountanting &amp; Finance</option>
			<option value="Administration"><xsl:if test="$Value='Administration'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Administration</option>
			<option value="Advertising"><xsl:if test="$Value='Advertising'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Advertising</option>
			<option value="Air Trafic Control"><xsl:if test="$Value='Air Trafic Control'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Air Trafic Control</option>
			<option value="Archiving"><xsl:if test="$Value='Archiving'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Archiving</option>
			<option value="Armed forces"><xsl:if test="$Value='Armed forces'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Armed forces</option>
			<option value="Arts Admin /management"><xsl:if test="$Value='Arts Admin /management'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Arts Admin /management</option>
			<option value="Auctioneering &amp; Valuation work"><xsl:if test="$Value='Auctioneering &amp; Valuation work'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Auctioneering &amp; Valuation work</option>
			<option value="Bookselling &amp; Publishing"><xsl:if test="$Value='Bookselling &amp; Publishing'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Bookselling &amp; Publishing</option>
			<option value="Broadcasting"><xsl:if test="$Value='Broadcasting'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Broadcasting</option>
			<option value="Buying &amp; Purchasing"><xsl:if test="$Value='Buying &amp; Purchasing'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Buying &amp; Purchasing</option>
			<option value="Civil Service"><xsl:if test="$Value='Civil Service'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Civil Service</option>
			<option value="Company Secretary"><xsl:if test="$Value='Company Secretary'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Company Secretary</option>
			<option value="Conference / Events Management"><xsl:if test="$Value='Conference / Events Management'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Conference / Events Management</option>
			<option value="Counselling and Advising"><xsl:if test="$Value='Counselling and Advising'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Counselling and Advising</option>
			<option value="Customs &amp; Excise"><xsl:if test="$Value='Customs &amp; Excise'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Customs &amp; Excise</option>
			<option value="Fundraising"><xsl:if test="$Value='Fundraising'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Fundraising</option>
			<option value="Health Managmen"><xsl:if test="$Value='Health Managmen'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Health Managmen</option>
			<option value="Hospitality &amp; Leisure Management"><xsl:if test="$Value='Hospitality &amp; Leisure Management'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Hospitality &amp; Leisure Management</option>
			<option value="Housing Management"><xsl:if test="$Value='Housing Management'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Housing Management</option>
			<option value="Human Resources"><xsl:if test="$Value='Human Resources'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Human Resources</option>
			<option value="IT sector"><xsl:if test="$Value='IT sector'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>IT sector</option>
			<option value="Import / Export"><xsl:if test="$Value='Import / Export'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Import / Export</option>
			<option value="Insurance Banking &amp; Building Society"><xsl:if test="$Value='Insurance Banking &amp; Building Society'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Insurance Banking &amp; Building Society</option>
			<option value="Journalism"><xsl:if test="$Value='Journalism'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Journalism</option>
			<option value="Legal Sector"><xsl:if test="$Value='Legal Sector'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Legal Sector</option>
			<option value="Library / Information Management"><xsl:if test="$Value='Library / Information Management'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Library / Information Management</option>
			<option value="Local Government"><xsl:if test="$Value='Local Government'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Local Government</option>
			<option value="Management Consultancy"><xsl:if test="$Value='Management Consultancy'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Management Consultancy</option>
			<option value="Market Research"><xsl:if test="$Value='Market Research'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Market Research</option>
			<option value="Marketing"><xsl:if test="$Value='Marketing'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Marketing</option>
			<option value="Museum work"><xsl:if test="$Value='Museum work'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Museum work</option>
			<option value="Police &amp; Emergency Services"><xsl:if test="$Value='Police &amp; Emergency Services'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Police &amp; Emergency Services</option>
			<option value="Prison Service"><xsl:if test="$Value='Prison Service'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Prison Service</option>
			<option value="Probation Service"><xsl:if test="$Value='Probation Service'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Probation Service</option>
			<option value="Property management &amp; sales"><xsl:if test="$Value='Property management &amp; sales'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Property management &amp; sales</option>
			<option value="Public Relations"><xsl:if test="$Value='Public Relations'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Public Relations</option>
			<option value="Recrutment Consultancy"><xsl:if test="$Value='Recrutment Consultancy'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Recrutment Consultancy</option>
			<option value="Retail Management"><xsl:if test="$Value='Retail Management'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Retail Management</option>
			<option value="Security Service"><xsl:if test="$Value='Security Service'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Security Service</option>
			<option value="Social Work"><xsl:if test="$Value='Social Work'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Social Work</option>
			<option value="Surveying"><xsl:if test="$Value='Surveying'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Surveying</option>
			<option value="Teaching"><xsl:if test="$Value='Teaching'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Teaching</option>
			<option value="Tourism Management"><xsl:if test="$Value='Tourism Management'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Tourism Management</option>
			<option value="Voluntary Sector project work"><xsl:if test="$Value='Voluntary Sector project work'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Voluntary Sector project work</option>
			<option value="Youth &amp; Community work"><xsl:if test="$Value='Youth &amp; Community work'"><xsl:attribute name="selected">yes</xsl:attribute></xsl:if>Youth &amp; Community work</option>

		</select>
		<xsl:if test="/XML/RequestErrors/*[name()=$FieldName]">
			<xsl:call-template name="ErrorIcon">
				<xsl:with-param name="ErrorText" select="/XML/RequestErrors/*[name()=$FieldName]"/>
			</xsl:call-template>
		</xsl:if>

	</xsl:template>

	
	<!-- Build the default namespace string used by the Paging system. Default is to join the module and action -->
	<xsl:template name="DefaultAttributeNamespace"><xsl:value-of select="/XML/sf_params/module" />/<xsl:value-of select="/XML/sf_params/action" /></xsl:template>

	
	<!-- Display sortable headings -->
	<xsl:template name="TableHeaderOrder">
		<xsl:param name="Name" />
		<xsl:param name="Namespace"><xsl:call-template name="DefaultAttributeNamespace" /></xsl:param>
	
		<!-- If this is the column being used for sorting, create a SortOrder parameter -->
		<xsl:choose>
			<xsl:when test="/XML/sf_user/attributes/attribute[namespace=$Namespace and sort=$Name and type='asc']">
				asc
			</xsl:when>
			<xsl:when test="/XML/sf_user/attributes/attribute[namespace=$Namespace and sort=$Name and type='desc']">
				desc
			</xsl:when>
			<xsl:otherwise>
				none
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Display sortable headings -->
	<xsl:template name="TableHeader">
		<xsl:param name="Name" />
		<xsl:param name="Label" />
		<xsl:param name="Namespace"><xsl:call-template name="DefaultAttributeNamespace" /></xsl:param>
		<xsl:param name="Path" />
	
		<!-- If this is the column being used for sorting, create a SortOrder parameter -->
		<xsl:variable name="SortOrder"><xsl:call-template name="TableHeaderOrder">
			<xsl:with-param name="Name"><xsl:value-of select="$Name" /></xsl:with-param>
			<xsl:with-param name="Namespace"><xsl:value-of select="$Namespace" /></xsl:with-param>
		</xsl:call-template></xsl:variable>
		
		<!--
		<xsl:choose>
			<xsl:when test="/XML/sf_user/attributes/attribute[namespace=$Namespace and sort=$Name and type='asc']">
				<xsl:variable name="SortOrder">asc</xsl:variable>
			</xsl:when>
			<xsl:when test="/XML/sf_user/attributes/attribute[namespace=$Namespace and sort=$Name and type='desc']">
				<xsl:variable name="SortOrder">desc</xsl:variable>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="SortOrder">none</xsl:variable>
			</xsl:otherwise>
		</xsl:choose>
		-->
		
		<th>
			<xsl:choose>
				<xsl:when test="normalize-space($SortOrder)='asc'">
					<!-- Switch the search order -->
					<a href="{$Path}?sort={$Name}&amp;type=desc"><xsl:value-of select="$Label" /></a> (asc)
				</xsl:when>
				<xsl:when test="normalize-space($SortOrder)='desc'">
					<a href="{$Path}?sort={$Name}&amp;type=asc"><xsl:value-of select="$Label" /></a> (desc)
				</xsl:when>
				<xsl:otherwise>
					<a href="{$Path}?sort={$Name}&amp;type=asc"><xsl:value-of select="$Label" /></a>
				</xsl:otherwise>
			</xsl:choose>
		</th>
	</xsl:template>
	
	
	<!-- Use this to output the value or write a dash if the value is empty -->
	<!-- Yes, this may be a bit iffy, but it should make it easier to sanity-check values quickly -->
	<xsl:template match="*" mode="StuffIfEmpty">
		<xsl:param name="Default">-</xsl:param>
		<xsl:choose>
			<xsl:when test="normalize-space(.)"><xsl:value-of select="." /></xsl:when>
			<xsl:otherwise><xsl:value-of select="$Default" /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>