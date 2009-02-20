<?php
/**
 * extension of Johnny Brochard's Class Array 2 XML
 * http://www.phpclasses.org/browse/package/1826.html
 * 
 * defines custom array key handlers and custom pass-through variables
 * 
 * @author    Kevin McGlynn, Phoria - changes by John Wards White October Ltd.
 */

class sfArray2XML extends PluginArray2XML
{
  /**
   * setteur setArray
   *   intervening the setting of the array to assign/pass custom variables
   * 
   * @access public
   * @param array $XMLArray
   * @return bool
   */
  
  public function setArray($XMLArray)
  {
    $newXMLArray = array();
    
    $newXMLArray["MetaData"] = sfContext::getInstance()->getResponse()->getMetas();
    $newXMLArray["sf_user"] = sfContext::getInstance()->getUser();
    $newXMLArray["RootPath"] = sfContext::getInstance()->getRequest()->getRelativeUrlRoot().'/';
    $newXMLArray["ControllerPath"] = sfContext::getInstance()->getRequest()->getPathInfoPrefix().'/';
    $newXMLArray["ControllerPathURL"] = sfContext::getInstance()->getRequest()->getUriPrefix().sfContext::getInstance()->getRequest()->getPathInfoPrefix().'/';
    $newXMLArray["Year"] = date('Y');
    $newXMLArray["Date"] = date('F jS Y');
    $newXMLArray["UploadPath"] =  sfContext::getInstance()->getRequest()->getRelativeUrlRoot().'/'.sfConfig::get('sf_upload_dir');

    // values pulled straight from request methods (just in case)
    $newXMLArray["UriPrefix"] =  sfContext::getInstance()->getRequest()->getUriPrefix();
    $newXMLArray["Uri"] =  sfContext::getInstance()->getRequest()->getUri();
    $newXMLArray["PathInfoPrefix"] =  sfContext::getInstance()->getRequest()->getPathInfoPrefix();
    $newXMLArray["PathInfo"] =  sfContext::getInstance()->getRequest()->getPathInfo();
    $newXMLArray["Host"] =  sfContext::getInstance()->getRequest()->getHost();
    $newXMLArray["ScriptName"] =  sfContext::getInstance()->getRequest()->getScriptName();
    
    $newXMLArray = $newXMLArray + $XMLArray; 
    
    return parent::setArray($newXMLArray);
  }
  
}
