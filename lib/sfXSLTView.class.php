<?php

//Not sure why i have this set..commenting out for now
//$e = error_reporting(0);
//error_reporting($e);

/**
 * sfXSLTView
 *
 * @package
 * @author John Wards - White October Ltd http://www.whiteoctober.co.uk.
 * @copyright Copyright (c) 2007
 * @version $Id$
 * @access public
 **/
class sfXSLTView extends sfPHPView {
	protected $xsl = false;
	protected $dom = false;
	protected $buildcomp = false;
	/**
     * sfXSLTView::initialize()
     * This method is used instead of sfPHPView::initialze
     *
     * @param mixed $context
     * @param mixed $moduleName
     * @param mixed $actionName
     * @param mixed $viewName
     * @return
     **/
	
  public function __construct($context, $moduleName, $actionName, $viewName, $buildcomponents=true)
  {
    $this->initialize($context, $moduleName, $actionName, $viewName, $buildcomponents);
  }
  
	public function initialize($context, $moduleName, $actionName, $viewName,$buildcomponents=true)
	{
		if (sfConfig::get('sf_logging_enabled'))
		{
			$context->getLogger()->info(sprintf('{sfXSLTView} initialize view for "%s/%s"', $moduleName, $actionName));
		}
		
		$this->setExtension(".xsl");
		$this->moduleName = $moduleName;
		$this->actionName = $actionName;
		$this->viewName   = $viewName;
		if(class_exists("xsltCache",false)){
			$this->xsl = new xsltCache;
		}else{
			$this->xsl = new XSLTProcessor();
			$this->dom = new DOMDocument();
		}
		$this->buildcomp = $buildcomponents;
		$this->context = $context;
	
	    $this->dispatcher = $context->getEventDispatcher();
		
		$this->attributeHolder = $this->initializeAttributeHolder();
		$this->parameterHolder = new sfParameterHolder();
		$this->parameterHolder->add(sfConfig::get('mod_'.strtolower($moduleName).'_view_param', array()));
		$this->decoratorDirectory = sfConfig::get('sf_app_template_dir');

		// include view configuration
		$this->configure();
		$this->setDecorator(false);

		if($buildcomponents==true){
			$this->buildComponents();
		}

		return true;
	}

	protected function buildComponents(){
		$components = $this->componentSlots;
		$setcomponents = array();
		foreach($components as $name => $component){
			$setcomponents[$name]=$this->get_component($component["module_name"],$component["component_name"]);
		}
		$this->attributeHolder->set("components",$setcomponents);
	}
	function _get_cache($cacheManager, $uri)
	{
		$retval = $cacheManager->get($uri);

		if (sfConfig::get('sf_web_debug'))
		{
			$retval = sfWebDebug::getInstance()->decorateContentWithDebug($uri, $retval, false);
		}

		return $retval;
	}

	function _set_cache($cacheManager, $uri, $retval)
	{
		$saved = $cacheManager->set($retval, $uri);
		
		if ($saved && sfConfig::get('sf_web_debug'))
		{
			$retval = sfWebDebug::getInstance()->decorateContentWithDebug($uri, $retval, true);
		}

		return $retval;
	}
	
	function get_component($moduleName, $componentName, $vars = array())
	{

		$context = $this->context;
		$actionName = '_'.$componentName;

		// check cache
		if ($cacheManager = $context->getViewCacheManager())
		{
			$cacheManager->registerConfiguration($moduleName);
			$uri = '@sf_cache_partial?module='.$moduleName.'&action='.$actionName.'&sf_cache_key='.(isset($vars['sf_cache_key']) ? $vars['sf_cache_key'] : md5(serialize($vars)));
			if ($retval = $this->_get_cache($cacheManager, $uri))
			{
				return $retval;
			}
		}

		$controller = $context->getController();

		if (!$controller->componentExists($moduleName, $componentName))
		{
			// cannot find component
			$error = 'The component does not exist: "%s", "%s"';
			$error = sprintf($error, $moduleName, $componentName);

			throw new sfConfigurationException($error);
		}

		// create an instance of the action
		
		$componentInstance = $controller->getComponent($moduleName, $componentName);

		// initialize the action
		$componentInstance->initialize($context, $moduleName, $actionName);

		// load component's module config file
		if(file_exists(sfConfig::get('sf_app_module_dir_name').'/'.$moduleName.'/config/module.yml')){
		  require(sfContext::getInstance ()->getConfigCache()->checkConfig(sfConfig::get('sf_app_module_dir_name').'/'.$moduleName.'/config/module.yml'));
		}

		$componentInstance->getVarHolder()->add($vars);

		// dispatch component
		$componentToRun = 'execute'.ucfirst($componentName);
		if (!method_exists($componentInstance, $componentToRun))
		{
			if (!method_exists($componentInstance, 'execute'))
			{
				// component not found
				$error = 'sfComponent initialization failed for module "%s", component "%s"';
				$error = sprintf($error, $moduleName, $componentName);
				throw new sfInitializationException($error);
			}

			$componentToRun = 'execute';
		}

		if (sfConfig::get('sf_logging_enabled'))
		{
			$context->getLogger()->info('{PartialHelper} call "'.$moduleName.'->'.$componentToRun.'()'.'"');
		}

		// run component
		if (sfConfig::get('sf_debug') && sfConfig::get('sf_logging_enabled'))
		{
			$timer = sfTimerManager::getTimer(sprintf('Component "%s/%s"', $moduleName, $componentName));
		}

		$retval = $componentInstance->$componentToRun();

		if (sfConfig::get('sf_debug') && sfConfig::get('sf_logging_enabled'))
		{
			$timer->addTime();
		}

		if ($retval != sfView::NONE)
		{
			// render
			$view = new sfXSLTView($context,$moduleName,$actionName,  '',false);
			$view->attributeHolder = $componentInstance->getVarHolder();
			$retval = $view->render($componentInstance->getVarHolder()->getAll());
			if ($cacheManager = $context->getViewCacheManager())
			{
				$retval = $this->_set_cache($cacheManager, $uri, $retval);
			}

			return $retval;
		}
	}

	/**
     * sfXSLTView::renderFile()
     * this method is used instead of sfPHPView::renderFile()
     *
     * @param mixed $file
     * @return
	 * @access protected
     **/
	protected function renderFile($_sfFile)
	{

		$timer = sfTimerManager::getTimer('renderFile');
		
		if (sfConfig::get('sf_logging_enabled'))
    	{
      		$this->dispatcher->notify(new sfEvent($this, 'application.log', array(sprintf('Render "%s"', $_sfFile))));
    	}

		$this->loadCoreAndStandardHelpers();
		
		$this->attributeHolder->set("file",$_sfFile);
		$this->attributeHolder->set("MetaData",sfContext::getInstance()->getResponse()->getMetas());
		$this->attributeHolder->set("RootPath",sfContext::getInstance()->getRequest()->getRelativeUrlRoot() .'/');
		$this->attributeHolder->set("RootDomain",sfContext::getInstance()->getRequest()->getUriPrefix() .'/');
		$this->attributeHolder->set("Year",date('Y'));
		$this->attributeHolder->set("Date",date('F jS Y'));
		$this->attributeHolder->set("UploadPath", sfContext::getInstance()->getRequest()->getRelativeUrlRoot().'/'.sfConfig::get('sf_upload_dir_name'));

		$array2xml = new sfArray2XML();

		$array2xml->setArray($this->attributeHolder->getAll());

		$xmlstr=$array2xml->saveArray("","XML",true);
		$GLOBALS['XMLSTR'] = $xmlstr;
		if($this->context->getRequest()->hasParameter("dumpXML") && $this->buildcomp==true){
			header('Content-type: text/xml');
			echo $xmlstr;
			flush();
			die();
		}

		$doc = $array2xml->getDom();

		if($this->dom){

			$this->dom->load($_sfFile);
			$this->xsl->importStyleSheet($this->dom);
		}else{
			$this->xsl->importStyleSheet($_sfFile);
		}

		$this->xsl->registerPHPFunctions();
		$result=$this->xsl->transformToXML($doc);
		extract($this->attributeHolder->getAll());
		$timer->addTime();

		return $result;
	}

}
