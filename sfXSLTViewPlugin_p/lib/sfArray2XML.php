<?php

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

			$node = $this->doc->createElement($newKey);
			$append=false;
			if (is_array($val)){
				$this->addArray($arr[$key], $node, $key);
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
				$nodeText = $this->doc->createCDATASection($val);
				$node->appendChild($nodeText);
				$append=true;
			}
			elseif(is_bool($val)){
				$nodeText = $this->doc->createCDATASection(intval($val));
				$node->appendChild($nodeText);
				$append=true;
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
					$data["pages"] = $val->getLinks();
					$data["pages"]['ResultCount'] = $val->getNbResults();
					$data["pages"]['FirstPage'] = $val->getFirstPage();
					$data["pages"]['PreviousPage'] = $val->getPreviousPage();
					$data["pages"]['NextPage'] = $val->getNextPage();
					$data["pages"]['LastPage'] = $val->getLastPage();
					$data["pages"]['CurrentPage'] = $val->getPage();
					$data["pages"]['CurrentMaxLink'] = $val->getCurrentMaxLink();
				}
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

?>
