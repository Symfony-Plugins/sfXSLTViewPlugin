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

	public function saveArray($XMLFile, $rootName="",$testforxml=false,$dropdecleration=false, $encoding="utf-8"){
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
		if($dropdecleration){
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

	function addArray($arr, &$n, $name=""){
		if(is_array($arr))
		foreach ($arr as $key => $val){
			if (is_int($key)){
				if (strlen($name)>1){
					$newKey = substr($name, 0, strlen($name)-1);
				}else{
					$newKey="item";
				}
			}else{
				$newKey = $key;
			}
		
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
			
			$node = $this->doc->createElement($newKey);
			
			$append=false;
			if (is_array($val)){
				$this->addArray($arr[$key], $node, $newKey);
				$append=true;
			}
			elseif(stristr($key,"XML") && $this->testforxml==true){
				if(strlen($val)>0){
					$frag = $this->doc->createDocumentFragment();
					$frag->appendXML($val);
					$node->appendChild($frag);
					$append=true;
				}
			}
			elseif(is_numeric($val)){
				$nodeText = $this->doc->createTextNode($val);
				$node->appendChild($nodeText);
				$append=true;
			}
			elseif(is_string($val)){
				if(isValidDateTime($val)){
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
				}else{
					$nodeText = $this->doc->createCDATASection($val);
					$node->appendChild($nodeText);
					$append=true;
				}
			}
			elseif(is_bool($val)){
				$nodeText = $this->doc->createCDATASection(intval($val));
				$node->appendChild($nodeText);
				$append=true;
			}
			elseif(true===method_exists($val,"toDom")){
				$fragment = $val->toDom($this->doc);
				if ($fragment instanceof DOMDocumentFragment)
				{
					$node->appendChild($fragment);
					$append=true;
				}
			}
			elseif(true===method_exists($val,"toArray")){
				$data = array();
				$data = $val->toArray(BasePeer::TYPE_FIELDNAME);
				/**
				 * If the user has decided to set up loading of foriegn tables automatically
				 */
				if(true===method_exists($val,"getLoadForeign")){
					/**
					 * If the value is set to true lets do some magic
					 */
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
				$this->addArray($data, $node, $key);
				$append=true;
			}
			elseif($val instanceof sfParameterHolder){
				$this->addArray($val->getAll(), $node, $key);
				$append=true;
			}
			elseif($val instanceof myUser){
				$ns=$val->getAttributeHolder()->getNamespaces();

				$passnode = array("attributes"=>Array(),'is_authenticated'=>$val->isAuthenticated());
				foreach($ns as $name){
					$tmp=array();
					$tmp["namespace"]=$name;
					$array=$val->getAttributeHolder()->getAll($name);
					$array=$tmp+$array;
					$passnode["attributes"][]=$array;
				}
				$this->addArray($passnode, $node, $key);
				$append=true;
			}
			elseif($val instanceof sfPropelPager){
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
			}
			else {
			}
			if($append)
			$n->appendChild($node);
		}
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