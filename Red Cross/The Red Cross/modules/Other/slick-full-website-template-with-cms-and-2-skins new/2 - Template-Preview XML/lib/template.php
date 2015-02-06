<?php
/*
	OXYLUS Developement web framweork
	copyright (c) 2003-2004 OXYLUS Developement

	$Id: template.php,v 0.0.1 09/03/2003 20:38:15 Exp $
	template library

	contact:
		www.oxylus.ro
		office@oxylus.ro
*/


/**
* template shared memory; the format of this variable is:
* array (
*	"BLOCK1" => array (
*		"VAR1" => "val1",
*		"VAR2" => "val2"
*	),
*	"BLOCK2" => array (
*		"VAR1" => "val1",
*		"VAR2" => "val2"
*	)
* )
* so anything that goes into tsm should be like $_TSM["BLOCK"]["VAR"] = "value";
* except the require flags from the layout tpl assign which can be inserted directly.
* do *not* trash the tsm.
*
* @var array
*
* @access public
*/
$_TSM = array();


class CTemplate {
	/**
	* template source data
	*
	* @var string
	*
	* @access private
	*/
	var $input;

	/**
	* template result data
	*
	* @var string
	*
	* @access public
	*/
	var $output;

	/**
	* template blocks if any
	*
	* @var array
	*
	* @access public
	*/
	var $blocks;

	/**
	* constructor which autoloads the template data
	*
	* @param string $source			source identifier; can be a filename or a string var name etc
	* @param string $source_type	source type identifier; currently file and string supported
	*
	* @return void
	*
	* @acces public
	*/
	function CTemplate($source,$source_type = "file") {
		$this->Load($source,$source_type);
	}

	/**
	* load a template from file. places the file content into input and output
	* also setup the blocks array if any found
	*
	* @param string $source			source identifier; can be a filename or a string var name etc
	* @param string $source_type	source type identifier; currently file and string supported
	*
	* @return void
	*
	* @acces public
	*/
	function Load($source,$source_type = "file") {
		switch ($source_type) {
			case "file":
				$this->template_file = $source;
				// get the data from the file
				$data = GetFileContents($source);
				//$data = str_Replace('$','\$',$data);
			break;
			
			case "rsl":
			case "string":
				$data = $source;
			break;
		}


		// blocks are in the form of <!--S:BlockName-->data<!--E:BlockName-->
		preg_match_all("'<!--S\:.*?-->.*?<!--E\:.*?-->'si",$data,$matches);

		// any blocks found?
		if (count($matches[0]) != 0)
			// iterate thru `em
			foreach ($matches[0] as $block) {
				// extract block name
				$name = substr($block,strpos($block,"S:") + 2,strpos($block,"-->") - 6);

				// cleanup block delimiters
				$block = substr($block,9 + strlen($name),strlen($block) - 18 - strlen($name) * 2);

				// insert into blocks array
				$this->blocks["$name"] = new CTemplate($block,"string");
			}

		// cleanup block delimiters and set the input/output
		$this->input = $this->output = preg_replace(array("'<!--S\:.*?-->(\r\n|\n|\n\r)'si","'<!--E\:.*?-->(\r\n|\n|\n\r)'si"),"",$data);
	}

	/**
	* replace template variables w/ actual values
	*
	* @param array $vars	array of vars to be replaced in the form of "VAR" => "val"
	* @param bool $clear	reset vars after replacement? defaults to TRUE
	*
	* @return string the template output
	*
	* @acces public
	*/
	function Replace($vars,$clear = TRUE) {
		if (is_array($vars)) {
			foreach ($vars as $key => $var) {
				if (is_array($var)) {
					unset($vars[$key]);
				}				
			}			
		}
		
		// init some temp vars
		$patterns = array();
		$replacements = array();

		// build patterns and replacements
		if (is_array($vars))
			// just a small check		
			foreach ($vars as $key => $val) {
				$patterns[] = "/\{" . strtoupper($key) . "\}/";

				//the $ bug
				$replacements[] = str_replace('$','\$',$val);
			}

		// do regex		
		$result = $this->output = @preg_replace($patterns,$replacements,$this->input);

		// do we clear?
		if ($clear == TRUE)
			$this->Clear();

		// return output
		return $result;
	}

	function SepReplace($ssep , $esep , $vars,$clear = TRUE) {
		if (is_array($vars)) {
			foreach ($vars as $key => $var) {
				if (is_array($var)) {
					unset($vars[$key]);
				}				
			}			
		}
		
		// init some temp vars
		$patterns = array();
		$replacements = array();

		// build patterns and replacements
		if (is_array($vars))
			// just a small check		
			foreach ($vars as $key => $val) {
				$patterns[] = $ssep . strtoupper($key) . $esep;

				//the $ bug
				$replacements[] = str_replace('$','\$',$val);
			}

		// do regex		
		$result = $this->output = @preg_replace($patterns,$replacements,$this->input);

		// do we clear?
		if ($clear == TRUE)
			$this->Clear();

		// return output
		return $result;
	}

	/**
	* replace a single template variable
	*
	* @param string $var	variable to be replaced
	* @param string $value	replacement
	* @param bool $perm		makes the change permanent [i.e. replaces input also]; defaults to FALSE
	*
	* @return string result of replacement
	*
	* @acces public
	*/
	function ReplaceSingle($var,$value,$perm = FALSE) {

		if ($perm)
			$this->input = $this->Replace(array("$var" => $value));
		else		
			return $this->Replace(array("$var" => $value));
	}

	/**
	* resets all the replaced vars to their previous status
	*
	* @return void
	*
	* @acces public
	*/
	function Clear() {
		$this->output = $this->input;
	}

	/**
	* voids every template variable
	*
	* @return void
	*
	* @acces public
	*/
	function EmptyVars() {
		global $_TSM;

		//$this->output = $this->ReplacE($_TSM["_PERM"]);
		//return$this->output = preg_replace("'{[A-Z]}'si","",$this->output);
		return $this->output = preg_replace("'{[A-Z_\-0-9]*?}'si","",$this->output);
		//return $this->output = preg_replace("'{[\/\!]*?[^{}]*?}'si","",$this->output);
	}

	/**
	* checks if the specified template block exists
	*
	* @param string	$block_name	block name to look for
	*
	* @return bool TRUE if exists or FALSE if it doesnt
	*
	* @access public
	*/
	function BlockExists($block_name) {
		return isset($this->blocks[$block_name]) && is_object($this->blocks[$block_name])? TRUE : FALSE;

	}

/*
	function Block($block,$vars = array(),$return_error = false) {
		if ($this->BlockExists($block))
			return $this->blocks[$block]->Replace($vars);
		else {
			return "";
		}

				
	}
*/

	/*Extra functions to keep the compatibility with the new CTemplateDynamic library*/

	/**
	* description
	*
	* @param
	*
	* @return
	*
	* @access
	*/
	function BlockReplace($block , $vars = array(), $clear = true){
		if (!is_object($this->blocks[$block]))
			echo "CTemplate::{$this->template_file}::$block Doesnt exists.<br>";
		
		return $this->blocks[$block]->Replace($vars , $clear);
	}

	/**
	* description
	*
	* @param
	*
	* @return
	*
	* @access
	*/
	function BlockEmptyVars($block , $vars = array(), $clear = true) {
		if (!is_object($this->blocks[$block]))
			echo "CTemplate::{$this->template_file}::$block Doesnt exists.<br>";

		if (is_array($vars) && count($vars))
			$this->blocks[$block]->Replace($vars , false);
		
		return $this->blocks[$block]->EmptyVars();
	}
	
	/**
	* description
	*
	* @param
	*
	* @return
	*
	* @access
	*/
	function Block($block) {
		if (!is_object($this->blocks[$block]))
			echo "CTemplate::{$this->template_file}::$block Doesnt exists.<br>";

		return $this->blocks[$block]->output;
	}
	
	
}


/**
* description
*
* @library	
* @author	
* @since	
*/
class CTemplateStatic{
	/**
	* description
	*
	* @param
	*
	* @return
	*
	* @access
	*/
	
	/**
	* description
	*
	* @param
	*
	* @return
	*
	* @access
	*/
	function Replace($tmp , $data = array()) {
		$template = new CTemplate($tmp , "string");
		return $template->replace($data);
	}

	function EmptyVars($tmp , $data = array()) {
		$template = new CTemplate($tmp , "string");

		if (count($data)) {
			$template->replace($data , false);
		}
		
		return $template->emptyvars();
	}

	/**
	* description
	*
	* @param
	*
	* @return
	*
	* @access
	*/
	function ReplaceSingle($tmp , $var , $value) {
		return CTemplateStatic::Replace(
			$tmp , 
			array(
				$var => $value
			)
		);
	}
	
	
}

?>