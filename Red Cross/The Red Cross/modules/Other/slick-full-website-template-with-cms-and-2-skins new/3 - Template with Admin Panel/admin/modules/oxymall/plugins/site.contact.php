<?php
/*
	OXYLUS Development web framework
	copyright (c) 2002-2007 OXYLUS Development
		web:  www.oxylus.ro
		mail: support@oxylus.ro		

	$Id: name.php,v 0.0.1 dd/mm/yyyy hh:mm:ss oxylus Exp $
	description
*/

// dependencies

/**
* description
*
* @library	
* @author	
* @since	
*/
class COXYMallContact extends CPlugin{
	
	var $tplvars; 

	function COXYMallContact() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if ($_GET["sub"] == "oxymall.plugin.contact.xml") {
			return $this->GenerateXML();
		}

		if ($_GET["sub"] == "oxymall.plugin.contact.send") {
			return $this->SendMessage();
		}

		if ($_GET["sub"] == "oxymall.plugin.contact.upload") {
			return $this->UploadMessage();
		}

		if ($_GET["sub"] == "oxymall.plugin.contact.download") {
			return $this->DownloadMessage();
		}

	}

	function GenerateXml() {
		global $base;

		$this->module->plugins["modules"]->MimeXML();

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();

		$template = new CTemplate($this->tpl_path . "main.xml");

		//check if upload is disabled
		if (!$this->tpl_module["settings"]["set_enable_upload"]) {
			$this->tpl_module["settings"]["set_upload"] = "";
		}
		

		return CTemplateStatic::Replace(
			$template->blockReplace(
				"Main" ,
				array(
					"mod_url" => $this->tpl_module["mod_url"],
					"header" => $this->vars->data["contact_header_" . $this->tpl_module["mod_id"]],
					"title" => $this->tpl_module["mod_long_name"],

					"email" => $this->vars->data["contact_email_" . $this->tpl_module["mod_id"]],
					"email_url" => $this->vars->data["contact_email_url_" . $this->tpl_module["mod_id"]],
					"email_togle" => $this->vars->data["contact_email_" . $this->tpl_module["mod_id"]] ? "1" : "0",

					"web" => $this->vars->data["contact_web_" . $this->tpl_module["mod_id"]],
					"web_url" => $this->vars->data["contact_web_url_" . $this->tpl_module["mod_id"]],
					"web_togle" => $this->vars->data["contact_web_" . $this->tpl_module["mod_id"]] ? "1" : "0",

					"ym" => $this->vars->data["contact_ym_" . $this->tpl_module["mod_id"]],
					"ym_url" => $this->vars->data["contact_ym_url_" . $this->tpl_module["mod_id"]],
					"ym_togle" => $this->vars->data["contact_ym_" . $this->tpl_module["mod_id"]] ? "1" : "0",

					"msn" => $this->vars->data["contact_msn_" . $this->tpl_module["mod_id"]],
					"msn_url" => $this->vars->data["contact_msn_url_" . $this->tpl_module["mod_id"]],
					"msn_togle" => $this->vars->data["contact_msn_" . $this->tpl_module["mod_id"]] ? "1" : "0",

					"skype" => $this->vars->data["contact_skype_" . $this->tpl_module["mod_id"]],
					"skype_url" => $this->vars->data["contact_skype_url_" . $this->tpl_module["mod_id"]],
					"skype_togle" => $this->vars->data["contact_skype_" . $this->tpl_module["mod_id"]] ? "1" : "0",

				)
			),
			array_merge(
				$this->tpl_module["settings"],
				array(
					"module_id" => 	$this->tpl_module["mod_id"],
				)
			)
		);
		
	}
	

	function SendMessage() {
		global $_CONF , $_NO_HTACCESS;

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();
		

		$vars = array(
			"name" => stripslashes($_POST["name"]),
			"email" => stripslashes($_POST["e-mail"]),
			"subject" => stripslashes($_POST["subject"]),
			"message" => nl2br(stripslashes($_POST["mes"])),
		);

		foreach ($vars as $key => $val) {
			if (trim($val)=="") {
				//not all fields so returns error
				die("s=false&");
			}
		}

		//save the email to database
		$id = $this->db->QueryInsert(
			$this->tables["plugin:contact_messages"],
			$contact = array(
				"module_id"		=> $this->tpl_module["mod_id"],
				"item_new"		=> 1,
				"item_date"		=> time(),
				"item_email"	=> $vars["email"],
				"item_name"		=> $vars["name"],
				"item_subject"	=> $vars["subject"],
				"item_message"	=> $vars["message"],
				"item_file"		=> $_POST["file"] != "nofile" ? 1 : 0,
				"item_file_file"=> $_POST["file"],
				"item_code"		=> md5(microtime_float()),

			)
		);

		//process the image if needed
		if ($_POST["file"] != "nofile") {
			//process the file

			if (file_exists("upload/tmp/contact-" . $_POST["file"])) {
				rename("upload/tmp/contact-" . $_POST["file"] , "upload/contact/{$id}.file");
				chmod("upload/contact/{$id}.file" , 0777);
			}

			$vars["attachment_link"] = $_CONF["url"]. "contact-download.php?file=" . $contact["item_code"];
		} else 
			$vars["attachment_link"] = "";

		



		$email = array(
			"email_to" => $this->tpl_module["settings"]["set_email_1_to_email"],
			"email_to_name" => $this->tpl_module["settings"]["set_email_1_to_name"],

			"email_from" => $this->tpl_module["settings"]["set_email_1_from_email"],
			"email_from_name" => $this->tpl_module["settings"]["set_email_1_from_name"],

			"email_subject" => $this->tpl_module["settings"]["set_email_1_subject"],
			"email_body" => $this->tpl_module["settings"]["set_email_1_message"],
			"email_type" => "html"
		);

		foreach ($email as $key => $val) {
			$email[$key] = CTemplateStatic::Replace($val , $vars);
		}


		//send the email
		SendMail($email);

		//send the responder
		if ($this->tpl_module["settings"]["set_email_2"]) {

			$email = array(
				"email_to" => $vars["email"],
				"email_to_name" => $vars["name"],

				"email_from" => $this->tpl_module["settings"]["set_email_2_to_email"],
				"email_from_name" => $this->tpl_module["settings"]["set_email_2_to_name"],

				"email_subject" => $this->tpl_module["settings"]["set_email_2_subject"],
				"email_body" => $this->tpl_module["settings"]["set_email_2_message"],
				"email_type" => "html"
			);

			foreach ($email as $key => $val) {
				$email[$key] = CTemplateStatic::Replace($val , $vars);
			}

			//send the email
			SendMail($email);
		}

		echo "status=ok";
		die();
		
	}

	function UploadMessage() {

		if (is_array($_FILES["Filedata"])) {

			if (!$_FILES["Filedata"]["error"]) {
				move_uploaded_file($_FILES["Filedata"]["tmp_name"] , "upload/tmp/contact-" . $_FILES["Filedata"]["name"]);
			}			
		}

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
	function DownloadMessage() {
		if (is_array($file = $this->db->QFetchArray("SELECT * FROM {$this->tables['plugin:contact_messages']} WHERE item_code='{$_GET[file]}'"))) {
			$mime = new CMime();
			$mime->set("unknown");
			$mime->FileName($file["item_file_file"]);

			readfile("upload/contact/{$file[item_id]}.file");
			die();
		}

		else die("Invalid request!");
		
	}
	
	
}

?>