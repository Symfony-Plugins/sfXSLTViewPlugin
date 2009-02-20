<?php

class sfXSLTViewConfigHandler extends sfYamlConfigHandler {
  
  public function __construct($parameters = null)
  {
    $this->initialize($parameters);
  }
  
  public function execute($configFiles){
    
    $config = $this->parseYamls($configFiles);
    
    $data  = "<?php\n";
    if(isset($config["keytests"]) && is_array($config["keytests"])){
      foreach($config["keytests"] as $key => $test)
      {
        $data .= sprintf("PluginArray2XML::\$key_test[\"%s\"]=\"%s\";\n",$key,$test);
      }
    }
    
    return $data;
  }
}