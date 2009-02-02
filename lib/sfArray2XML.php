<?php
sfContext::getInstance()->getConfiguration()->loadHelpers('Helper');
 
use_helper('Date');
/**
* associative array to xml transformation class
* Based on Johnny Brochard's Class Array 2 XML
* http://www.phpclasses.org/browse/package/1826.html
* 
*
* @author    Johnny Brochard - changes by John Wards White October Ltd
*/

class sfArray2XML {

	/*
	* XML Array
	* @var array
	* @access private
	*/
	private $XMLArray;

	/*
	* array is OK
	* @var bool
	* @access private
	*/
	private $arrayOK;

	/*
	* XML file name
	* @var string
	* @access private
	*/
	private $XMLFile;

	/*
	* file is present
	* @var bool
	* @access private
	*/
	private $fileOK;

	/*
	* DOM document instance
	* @var DomDocument
	* @access private
	*/
	private $doc;

	private $testforxml;

	/**
     * Constructor
     * @access public
     */

	public function __construct(){

	}

	/**
     * setteur setXMLFile
     * @access public
     * @param string $XMLFile
     * @return bool
     */

	public function setXMLFile($XMLFile){
		if (file_exists($XMLFile)){
			$this->XMLFile = $XMLFile;
			$this->fileOK = true;
		}else{
			$this->fileOK = false;
		}
		return $this->fileOK;
	}

	/**
     * saveArray
     * @access public
     * @param string $XMLFile
     * @return bool
     */

	public function saveArray($XMLFile, $rootName="",$testforxml=false,$dropdeclaration=false, $encoding="utf-8"){
		global $debug;
		$this->doc = new domdocument();
		$arr = array();
		$this->testforxml = $testforxml;
		if (count($this->XMLArray) > 1){
			if ($rootName != ""){
				$root = $this->doc->createElement($rootName);
			}else{
				$root = $this->doc->createElement("root");
				$rootName = "root";
			}
			$arr = $this->XMLArray;
		}else{

			$key = key($this->XMLArray);
			$val = $this->XMLArray[$key];

			if (!is_int($key)){
				$root = $this->doc->createElement($key);
				$rootName = $key;
			}else{
				if ($rootName != ""){
					$root = $this->doc->createElement($rootName);
				}else{
					$root = $this->doc->createElement("root");
					$rootName = "root";
				}
			}
			$arr = $this->XMLArray[$key];
		}

		$root = $this->doc->appendchild($root);

		$this->addArray($arr, $root, $rootName);

		/*        foreach ($arr as $key => $val){
		$n = $this->doc->createElement($key);
		$nText = $this->doc->createTextNode($val);
		$n->appendChild($nodeText);
		$root->appendChild($n);
		}
		*/
		if($dropdeclaration){
			$xml=explode("\n",$this->doc->saveXML());
			array_shift($xml);
			$xml=implode("\n",$xml);
		}else{
			$xml=$this->doc->saveXML();
		}
		if ($xml){
			return $xml;
		}else{
			return false;
		}
	}

	/**
     * addArray recursive function
     * @access public
     * @param array $arr
     * @param DomNode &$n
     * @param string $name
     */

    function addArray($arr, &$parentNode, $name="")
    {
      self::appendArray($this->doc, $parentNode, $arr, $name);
    }
	
	  
	/**
	 * Append an array to the xml dom
	 *
	 * All self::append*() functions put the DomNode as the first parameter
	 * 
	 * @param DOMDocument $xmlDocument
	 * @param DomNode $n
	 * @param array $arr
	 * @param string $name
	 */
	public static function appendArray($xmlDocument, &$parentNode, $arr, $name=""){
		if(is_array($arr))
		foreach ($arr as $key => $val){
		    // Set up 'sheeps'->'sheep' naming pattern
			if (is_int($key)){
				if (strlen($name)>1){
					$newKey = substr($name, 0, strlen($name)-1);
				}else{
					$newKey="item";
				}
			}else{
				$newKey = $key;
			}
		
			/*
			// Element name validation
			if ( strpos($newKey, ' ') !== False || $newKey=='')
			{
				// Bad key name, skip this entry
				continue;
			}
			//If key is not alpha numeric
			if(!preg_match('|^\w+$|', $newKey)){
				// Bad key name, skip this entry
				continue;
			}
			*/
			if (!self::isElementNameValid($newKey)) { continue; }
			
			
			$node = $xmlDocument->createElement($newKey);
			
			$append=false;
			if (is_array($val)){
			  if (array_keys($val))
			  {
			    self::appendArray($xmlDocument, $node, $arr[$key], $key);
				$append=true;
			    
			  } else {
				self::appendArray($xmlDocument, $node, $arr[$key], $newKey);
				$append=true;
			  }
			}
			elseif(stristr($key,"XML") && $this->testforxml==true){
			  // $key contains 'XML' so add the $val as literal XML
			  self::appendXMLString($xmlDocument, $node, $val);
			  /*
				if(strlen($val)>0){
					$frag = $this->doc->createDocumentFragment();
					$frag->appendXML($val);
					$node->appendChild($frag);
					$append=true;
				}
              */
			}
			elseif(is_numeric($val)){
			  self::appendNumeric($xmlDocument, $node, $val);
			  /*
				$nodeText = $this->doc->createTextNode($val);
				$node->appendChild($nodeText);
				$append=true;
              */
			}
			elseif(is_string($val)){
				if(isValidDateTime($val)){
				    self::appendDateTime($xmlDocument, $node, $val);
				    $append=true;
				    /*
					$ts = strtotime($val);
					$timeinwords = distance_of_time_in_words($ts);
					$nodeText = $this->doc->createCDATASection($val);
					$node->setAttribute("timeinwords", $timeinwords);
					$node->setAttribute("ts", $ts);
					$node->setAttribute("d", date("d",$ts));
					$node->setAttribute("D", date("D",$ts));
					$node->setAttribute("l", date("l",$ts));
					$node->setAttribute("S", date("S",$ts));
					$node->setAttribute("m", date("m",$ts));
					$node->setAttribute("M", date("M",$ts));
					$node->setAttribute("F", date("F",$ts));
					$node->setAttribute("n", date("n",$ts));
					$node->setAttribute("t", date("t",$ts));
					$node->setAttribute("y", date("y",$ts));
					$node->setAttribute("Y", date("Y",$ts));
					$node->setAttribute("g", date("g",$ts));
					$node->setAttribute("G", date("G",$ts));
					$node->setAttribute("h", date("h",$ts));
					$node->setAttribute("H", date("H",$ts));
					$node->setAttribute("i", date("i",$ts));
					$node->setAttribute("s", date("s",$ts));
					$node->appendChild($nodeText);
					$append=true;
					*/
				}else{
				    self::appendCData($xmlDocument, $node, $val);
				    $append=true;
				    /*
					$nodeText = $this->doc->createCDATASection($val);
					$node->appendChild($nodeText);
					$append=true;
					*/
				}
			}
			elseif(is_bool($val)){
			    self::appendCData($xmlDocument, $node, intval($val));
			    $append=true;
			    /*
				$nodeText = $this->doc->createCDATASection(intval($val));
				$node->appendChild($nodeText);
				$append=true;
				*/
			}
			//elseif(true===method_exists($val,"toInlineArray")){
			//    $data = $val->toInlineArray();
			//    foreach ()
			//}
			elseif(true===method_exists($val,"toDom")){
			    if (self::appendDocumentFragment($xmlDocument, $node, $val->toDom($xmlDocument)))
			    {
			      $append = true;
			    }
			    /*
				$fragment = $val->toDom($xmlDocument);
				if ($fragment instanceof DOMDocumentFragment)
				{
					$node->appendChild($fragment);
					$append=true;
				}
				*/
			}
			elseif(true===method_exists($val,"toXml")){
			    if (self::appendDocumentFragment($xmlDocument, $node, $val->toXml($xmlDocument)))
			    {
			      $append = true;
			    }
				/*
			    $fragment = $val->toXml($xmlDocument);
				if ($fragment instanceof DOMDocumentFragment)
				{
					$node->appendChild($fragment);
					$append=true;
				}
				*/
			}
			/*
			elseif(true===method_exists($val,"toArray") && $val instanceof Doctrine_Collection){
				//echo "DEBUG_A";
				$data = array();
				$loadForeign = false;
				if(true===method_exists($val,"getLoadForeign")){
					$loadForeign = $val->getLoadForeign();
				}
				$data = $val->toArray($loadForeign);
				if(true===method_exists($val,"loadThese")){
					//Add what ever the values of each of the array to the data array
					$these = $val->loadThese();
					if(is_array($these)){
						foreach($these as $loadkey => $loadmethod){
							$data[$loadkey]=call_user_func(array($val,$loadmethod));
						}
					}
				}
				$this->addArray($data, $node, $key);
				$append=true;
			}
			*/
			elseif(true===method_exists($val,"toArray")){
			  self::appendObjectArray($xmlDocument,$node, $val, $key);
			  /*
				$data = array();
				// Doctrine/Propel compatibility
				if (class_exists('BasePeer'))
				{
    			  $data = $val->toArray(BasePeer::TYPE_FIELDNAME);
				} else {
				  $data = $val->toArray();
				}
				// If the user has decided to set up loading of foreign tables automatically
				
				if(true===method_exists($val,"getLoadForeign")){
					// If the value is set to true lets do some magic
					 
					if(true===$val->getLoadForeign()){
						//Get the class name
						$classname = (string) get_class($val);
						//Set up a reflection inspection
						$class = new ReflectionClass($classname);
						//Get the methods
						$methods = $class->getMethods();
						foreach($methods as $method){
							//check for getters
							if(strpos($method->getName(),"get")===0){
								//Get the params for this method
								$params = $method->getParameters();
								//Propel foreign loads only have one param
								if(isset($params[0]) && !isset($params[1])){
									//Only propel methods seem to have con params set
									if($params[0]->getName()=="con"){
										$callname = $method->getName();
										//Get the name minus "get"
										$methodname = substr($method->getName(),3);
										//This calls $model->getForignModel()
										$data[$methodname]=call_user_func(array($val,$callname));
									}
								}
							}
						}
					}
				}
				if(true===method_exists($val,"loadThese")){
					//Add what ever the values of each of the array to the data array
					$these = $val->loadThese();
					if(is_array($these)){
						foreach($these as $loadkey => $loadmethod){
							$data[$loadkey]=call_user_func(array($val,$loadmethod));
						}
					}
				}
				self::appendArray($xmlDocument,$node, $data, $key);
				$append=true;
			}
			elseif($val instanceof sfParameterHolder){
				self::appendArray($xmlDocument, $node, $val->getAll(), $key);
				$append=true;
			}
			elseif($val instanceof myUser){
			    self::appendUser($xmlDocument, $node, $val, $key);
			    /*
				$ns=$val->getAttributeHolder()->getNamespaces();

				$passnode = array("attributes"=>Array(),'is_authenticated'=>$val->isAuthenticated());
				foreach($ns as $name){
					$tmp=array();
					$tmp["namespace"]=$name;
					$array=$val->getAttributeHolder()->getAll($name);
					$array=$tmp+$array;
					$passnode["attributes"][]=$array;
				}
				//$this->addArray($passnode, $node, $key);
				self::appendArray($xmlDocument, $node, $passnode, $key);
				*/
				$append=true;
			}
			elseif($val instanceof sfPropelPager){
			  if (self::appendPropelPager($xmlDocument, $node, $val))
			  {
			    $append = true;
			  }
			  /*
				$data = array();
				$data = $val->getResults();
				if ($val->haveToPaginate()){
					$data["pagelinks"] = $val->getLinks();
					$data["pages"]['ResultCount'] = $val->getNbResults();
					$data["pages"]['FirstPage'] = $val->getFirstPage();
					$data["pages"]['PreviousPage'] = $val->getPreviousPage();
					$data["pages"]['NextPage'] = $val->getNextPage();
					$data["pages"]['LastPage'] = $val->getLastPage();
					$data["pages"]['CurrentPage'] = $val->getPage();
					$data["pages"]['CurrentMaxLink'] = $val->getCurrentMaxLink();
					$data["pages"]['MaxPerPage'] = $val->getMaxPerPage();
				}
				$data["total"] = $val->getNbResults();
				if($data){
					$this->addArray($data, $node, $key);
					$append=true;
				}
				*/
			}elseif($val instanceof Doctrine_Pager){
			  if (self::appendDoctrinePager($xmlDocument, $node, $val))
			  {
			    $append = true;
			  }
			  
			}elseif($val instanceof sfForm){
			  // Convert the form to the string representation
			  self::appendCData($xmlDocument, $node, (string) $val);
				/*
				$nodeText = $this->doc->createCDATASection((string) $val);
				$node->appendChild($nodeText);
				*/
				$append=true;
			}
			else {
				//var_dump($val);
			}
			if($append)
			{
              $parentNode->appendChild($node);
			}
		}
	}


/************************************************************************/
	/**
	 * Convert integer arrays to consecutive [sheeps],[sheeps] elements rather than
	 * using the [sheeps]/[sheep] naming convention 
	 *
	 * @param DOMDocument $xmlDocument
	 * @param DomNode $parentNode
	 * @param array $arr
	 * @param string $name
	 */ 
	public static function appendInlineArray($xmlDocument, &$parentNode, $arr, $name=""){
		if(is_array($arr))
		foreach ($arr as $key => $val){
		    $isInline = false;
		    // Set up 'sheeps','sheeps' naming pattern
			if (is_int($key)){
				if (strlen($name)>1){
					$newKey = $name;
					if (!isset($node))
					{
					  $node = $parentNode;
					  $mustAppend = false;
					} else {
					  $node = $xmlDocument->createElement($newKey);
					  $mustAppend = true;
					}
					self::selectNodeType($xmlDocument, $node, $arr[$key], $key, $newKey);
					if ($mustAppend)
					{
					  //print_r($parentNode);
					  //$parentNode->parentNode->appendChild($node);
					}
					continue;
					$isInline = true;
				}else{
					$newKey="item";
				}
			}else{
				$newKey = $key;
			}
		
			if (!self::isElementNameValid($newKey)) { continue; }
			
			if ($isInline)
			{
			  $node = $parentNode;  
			} else {
              $node = $xmlDocument->createElement($newKey);
			}
			
			if (self::selectNodeType($xmlDocument, $node, $arr[$key], $key, $newKey))
			{
				// If $isInline==true, then $parentNode==$node too!)
				if(!$isInline)
				{
	              $parentNode->appendChild($node);
				}
				  
			}
		}
	}
	
	
    public static function selectNodeType($xmlDocument, $node, $val, $key, $newKey)
	{
		$append=false;
		if (is_array($val)){
		  if (array_keys($val))
		  { //echo " A[$key]";
		    self::appendInlineArray($xmlDocument, $node, $val, $key);
			$append=true;
		    
		  } else {
		    //echo " B[$newkey]";
			self::appendInlineArray($xmlDocument, $node, $val, $newKey);
			$append=true;
		  }
		}
		elseif(stristr($key,"XML") && $this->testforxml==true){
		  // $key contains 'XML' so add the $val as literal XML
		  self::appendXMLString($xmlDocument, $node, $val);
		}
		elseif(is_numeric($val)){
		  self::appendNumeric($xmlDocument, $node, $val);
		}
		elseif(is_string($val)){
			if(isValidDateTime($val)){
			    self::appendDateTime($xmlDocument, $node, $val);
			    $append=true;
			}else{
			    self::appendCData($xmlDocument, $node, $val);
			    $append=true;
			}
		}
		elseif(is_bool($val)){
		    self::appendCData($xmlDocument, $node, intval($val));
		    $append=true;
		}
		elseif(true===method_exists($val,"toDom")){
		    if (self::appendDocumentFragment($xmlDocument, $node, $val->toDom($xmlDocument)))
		    {
		      $append = true;
		    }
		}
		elseif(true===method_exists($val,"toXml")){
		    if (self::appendDocumentFragment($xmlDocument, $node, $val->toXml($xmlDocument)))
		    {
		      $append = true;
		    }
		}
		elseif(true===method_exists($val,"toArray")){
		  self::appendObjectArray($xmlDocument, $node, $val, $key);
			$append=true;
		}
		elseif($val instanceof sfParameterHolder){
		    // No need to use an inline array here
			self::appendArray($xmlDocument, $node, $val->getAll(), $key);
			$append=true;
		}
		elseif($val instanceof myUser){
		    self::appendUser($xmlDocument, $node, $val, $key);
			$append=true;
		}
		elseif($val instanceof sfPropelPager){
		  if (self::appendPropelPager($xmlDocument, $node, $val))
		  {
		    $append = true;
		  }
		}elseif($val instanceof Doctrine_Pager){
		  if (self::appendDoctrinePager($xmlDocument, $node, $val))
		  {
		    $append = true;
		  }
		  
		}elseif($val instanceof sfForm){
		  // Convert the form to the string representation
		  self::appendCData($xmlDocument, $node, (string) $val);
			$append=true;
		}
		
		return $append;
	}
		
/************************************************************************/
	
	
    public static function isElementNameValid($strName)
    {
      // Element name validation
      if ( strpos($strName, ' ') !== False || $strName=='')
      {
		// Bad key name, skip this entry
		return false;
	  }
      //If key is not alpha numeric
      if(!preg_match('|^\w+$|', $strName))
      {
        // Bad key name, skip this entry
        return false;
      }
      
      return true;
    }
    
    
    public static function appendXMLString($xmldocument, $node, $val)
    {
      if(strlen($val)>0)
      {
        $frag = $xmldocument->createDocumentFragment();
        $frag->appendXML($val);
        $node->appendChild($frag);
        //$append=true;
        return true;
      }
      return false;
    }

    public static function appendNumeric($xmldocument, $node, $val)
    {
      $nodeText = $xmldocument->createTextNode($val);
      $node->appendChild($nodeText);
      //$append=true;
      return true;
    }

    public static function appendDateTime($xmldocument, $node, $val)
    {
      $ts = strtotime($val);
      $timeinwords = distance_of_time_in_words($ts);
      $nodeText = $xmldocument->createCDATASection($val);
      $node->setAttribute("timeinwords", $timeinwords);
      $node->setAttribute("ts", $ts);
      $node->setAttribute("d", date("d",$ts));
      $node->setAttribute("D", date("D",$ts));
      $node->setAttribute("l", date("l",$ts));
      $node->setAttribute("S", date("S",$ts));
      $node->setAttribute("m", date("m",$ts));
      $node->setAttribute("M", date("M",$ts));
      $node->setAttribute("F", date("F",$ts));
      $node->setAttribute("n", date("n",$ts));
      $node->setAttribute("t", date("t",$ts));
      $node->setAttribute("y", date("y",$ts));
      $node->setAttribute("Y", date("Y",$ts));
      $node->setAttribute("g", date("g",$ts));
      $node->setAttribute("G", date("G",$ts));
      $node->setAttribute("h", date("h",$ts));
      $node->setAttribute("H", date("H",$ts));
      $node->setAttribute("i", date("i",$ts));
      $node->setAttribute("s", date("s",$ts));
      $node->appendChild($nodeText);
      //$append=true;
      return true;
    }

    
    public static function appendCData($xmldocument, $node, $val)
    {
      $nodeText = $xmldocument->createCDATASection($val);
      $node->appendChild($nodeText);
      //$append=true;
      return true;
    }


    public static function appendDocumentFragment($xmlDocument, $node, $fragment)
    {
      //$fragment = $val->toDom($xmlDocument);
      if ($fragment instanceof DOMDocumentFragment)
      {
        $node->appendChild($fragment);
        return true;
      }
      
      return false;
    }

    
    public static function appendObjectArray($xmlDocument, $node, $val, $key='')
    {
      $data = array();
      // Doctrine/Propel compatibility
      if (class_exists('BasePeer'))
      {
        $data = $val->toArray(BasePeer::TYPE_FIELDNAME);
      } else {
        $data = $val->toArray();
      }
      /*
       * If the user has decided to set up loading of foreign tables automatically
       */
      if(true===method_exists($val,"getLoadForeign"))
      {
        /**
         * If the value is set to true lets do some magic
         */
        if(true===$val->getLoadForeign())
        {
          //Get the class name
          $classname = (string) get_class($val);
          //Set up a reflection inspection
          $class = new ReflectionClass($classname);
          //Get the methods
          $methods = $class->getMethods();
          foreach($methods as $method)
          {
            //check for getters
            if(strpos($method->getName(),"get")===0)
            {
              //Get the params for this method
              $params = $method->getParameters();
              //Propel foreign loads only have one param
              if(isset($params[0]) && !isset($params[1]))
              {
                //Only propel methods seem to have con params set
                if($params[0]->getName()=="con")
                {
                  $callname = $method->getName();
                  //Get the name minus "get"
                  $methodname = substr($method->getName(),3);
                  //This calls $model->getForignModel()
                  $data[$methodname]=call_user_func(array($val,$callname));
                }
              }
            }
          }
        }
      }
      
      if(true===method_exists($val,"loadThese"))
      {
        //Add what ever the values of each of the array to the data array
        $these = $val->loadThese();
        if(is_array($these))
        {
          foreach($these as $loadkey => $loadmethod)
          {
            $data[$loadkey]=call_user_func(array($val,$loadmethod));
          }
        }
      }
      self::appendArray($xmlDocument,$node, $data, $key);
      
      return true;
    }



    /**
     * Convert a Propel Pager to XML
     *
     * @param DOMDocument $xmldocument
     * @param DomNode $node
     * @param sfPropelPager $val
     * @return boolean
     */
    public static function appendPropelPager($xmldocument, $node, $val)
    {
      $data = array();
      $data = $val->getResults();
      if ($val->haveToPaginate())
      {
        $data["pagelinks"] = $val->getLinks();
        $data["pages"]['ResultCount'] = $val->getNbResults();
        $data["pages"]['FirstPage'] = $val->getFirstPage();
        $data["pages"]['PreviousPage'] = $val->getPreviousPage();
        $data["pages"]['NextPage'] = $val->getNextPage();
        $data["pages"]['LastPage'] = $val->getLastPage();
        $data["pages"]['CurrentPage'] = $val->getPage();
        $data["pages"]['CurrentMaxLink'] = $val->getCurrentMaxLink();
        $data["pages"]['MaxPerPage'] = $val->getMaxPerPage();
      }
      $data["total"] = $val->getNbResults();
      if($data) // TODO: Not sure this test makes sense? $data["total"] should be set, forcing 'true'
      {
        //$this->addArray($data, $node, $key);
        self::appendArray($xmldocument, $node, $data, $key);
        //$append=true;
        return true;
      }
      return false;
    }
    

    /**
     * Convert a Doctrine_Pager object to XML
     *
     * @param DOMDocument $xmldocument
     * @param DomNode $node
     * @param Doctrine_Pager $val
     * @return boolean
     */
    public static function appendDoctrinePager($xmldocument, $node, $val)
    {
      // If the pager has not been executed, it will throw Doctrine_Pager_Exception
      if (! $val->getExecuted())
      {
        $val->execute();
      }
      
      $data = array();
      $data = $val->getResults();
      if ($val->haveToPaginate())
      {
        //$data["pagelinks"] = $val->getLinks();
        $data["pages"]['ResultCount'] = $val->getNumResults();
        $data["pages"]['FirstPage'] = $val->getFirstPage();
        $data["pages"]['PreviousPage'] = $val->getPreviousPage();
        $data["pages"]['NextPage'] = $val->getNextPage();
        $data["pages"]['LastPage'] = $val->getLastPage();
        $data["pages"]['CurrentPage'] = $val->getPage();
        //$data["pages"]['CurrentMaxLink'] = $val->getCurrentMaxLink();
        $data["pages"]['MaxPerPage'] = $val->getMaxPerPage();
      }
      $data["total"] = $val->getNumResults();
      if($data) // TODO: Not sure this test makes sense? $data["total"] should be set, forcing 'true'
      {
        //$this->addArray($data, $node, $key);
        self::appendArray($xmldocument, $node, $data, $key);
        //$append=true;
        return true;
      }
      return false;
    }
    
    public static function appendUser($xmlDocument, $node, $val, $key)
    {
      $ns=$val->getAttributeHolder()->getNamespaces();

      $passnode = array("attributes"=>Array(),'is_authenticated'=>$val->isAuthenticated());
      foreach($ns as $name)
      {
        $tmp=array();
        $tmp["namespace"]=$name;
        $array=$val->getAttributeHolder()->getAll($name);
        $array=$tmp+$array;
        $passnode["attributes"][]=$array;
      }
      self::appendArray($xmlDocument, $node, $passnode, $key);
      return true;
    }
       
    
	/**
     * setteur setArray
     * @access public
     * @param array $XMLArray
     * @return bool
     */

	public function setArray($XMLArray){
		if (is_array($XMLArray) && count($XMLArray) != 0){
			$this->XMLArray = $XMLArray;
			$this->arrayOK = true;
		}else{
			$this->arrayOK = false;
		}
		return $this->arrayOK;
	}
	public function getDom(){
		return $this->doc;
	}
	
	
	/**
	 * To be called by objects that want to display numerically index  
	 * arrays by the parent name, rather than dropping the final letter
	 *
	 * @param DOMDocument $domdoc
	 * @param array $arr
	 * 
	 */
	public static function arrayItemsToXML(DOMDocument $domdoc, $arrValues, $name='')
	{
	  $frag = $domdoc->createDocumentFragment();
      
	  $nodeText = $domdoc->createCDATASection(print_r($arrValues, true));
      $frag->appendChild($nodeText);
      
      self::appendInlineArray($domdoc, $frag, $arrValues, $name);
      /*
	  foreach ($arrValues as $key=>$val)
	  {
	    if (is_array($val) && isset($val[0]) && is_integer($val[0]))
	    {
	      // Indexed array!
	      $node = $domdoc->createElement($key);
	      $frag->appendChild($node);
	    } else {
	      self::appendInlineArray($domdoc, $frag, $val);
	    }
	  }
      */
      
      /*
	  $node = $domdoc->createElement('Testing');
      $nodeText = $domdoc->createCDATASection('foobar');
      $node->appendChild($nodeText);
      $frag->appendChild($node);
	  */
      return $frag;
	}
}

function isValidDateTime($dateTime)
{
	$matches = array();
    if (preg_match("/^(\d{4})-(\d{2})-(\d{2}) ([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/", $dateTime, $matches)) {
    	if(isset($matches[1]) && isset($matches[2]) && isset($matches[3])){
        	if (checkdate($matches[2], $matches[3], $matches[1])) {
           		return true;
        	}
    	}
    }

    return false;
}