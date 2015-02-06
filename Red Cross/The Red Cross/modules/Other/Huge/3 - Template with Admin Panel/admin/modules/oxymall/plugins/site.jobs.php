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
class COXYMallJobs extends CPlugin{
	
	var $tplvars; 

	function COXYMallJobs() {
		//$this->CPlugin($db, $tables , $templates);
	}

	function DoEvents(){
		global $base, $_CONF, $_TSM , $_VARS , $_USER , $_BASE , $_SESS;

		parent::DoEvents();

		if ($_GET["sub"] == "oxymall.plugin.jobs.xml") {
			return $this->GenerateXML();
		}

		if ($_GET["sub"] == "oxymall.plugin.jobs.send") {
			return $this->SendResume();
		}

		if ($_GET["sub"] == "oxymall.plugin.jobs.upload") {
			return $this->UploadResume();
		}

		if ($_GET["sub"] == "oxymall.plugin.jobs.download") {
			return $this->DownloadResume();
		}

	}

	function GenerateXml() {
		global $base;

		$this->module->plugins["modules"]->MimeXML();

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();

		$template = new CTemplate($this->tpl_path . "main.xml");

		if ($this->tpl_module["settings"]["set_reverseorder"]) {
			//load the images for this module
			$jobs = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:jobs_items']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} AND item_status=1 ORDER BY item_order DESC"
			);
		} else {
			$jobs = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:jobs_items']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} AND item_status=1 ORDER BY item_order ASC"
			);
		}

		$this->module->EncodeItems(
			&$jobs, 
			array(					
				"item_title" , 
				"item_url" , 
				"item_urltitle" , 
				"item_location" , 
			)
		);

		//process for date
		if (is_array($jobs)) {
			foreach ($jobs as $key => $val) {
				$jobs[$key]["item_date"] = date($this->tpl_module["settings"]["set_date_format"] , $val["item_date"]);
				$jobs[$key]["item_small_description"] = nl2br($val["item_small_description"]);

				if ($val["item_main_title"])
					$jobs[$key]["main_title"] = $val["item_main_title"];

				if ($val["item_upload_title"])
					$jobs[$key]["upload_title"] = $val["item_upload_title"];

				if ($val["item_contact_title"])
					$jobs[$key]["contact_title"] = $val["item_contact_title"];

				if ($val["item_readmore_title"])
					$jobs[$key]["readmore_title"] = $val["item_readmore_title"];
			}			
		}
		

		//check if upload is disabled
		if (!$this->tpl_module["settings"]["set_upload_field"]) {
			$this->tpl_module["settings"]["set_upload"] = "";
		}

		return CTemplateStatic::Replace(
			$template->blockReplace(
				"Main" ,
				array(
					"mod_url" => $this->tpl_module["mod_url"],
					"mod_urltitle" => $this->tpl_module["mod_urltitle"],
					"mod_long_name" => $this->tpl_module["mod_long_name"],

					"items" => $base->html->Table(
						$template,
						"Items",
						$jobs
					)
				)
			),
			array_merge(
				$this->tpl_module["settings"],
				array(
					"module_id" => 	$this->tpl_module["mod_id"],
					"main_title" => $this->tpl_module["settings"]["set_main_title"],
					"upload_title" => $this->tpl_module["settings"]["set_upload_title"],
					"contact_title" => $this->tpl_module["settings"]["set_contact_title"],
					"readmore_title" => $this->tpl_module["settings"]["set_readmore_title"]

				)
			)
		);
		
	}

	
	

	function SendResume() {
		global $_CONF;

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();

		if (!is_array($job = $this->db->QFetchArray("SELECT * FROM {$this->tables['plugin:jobs_items']} WHERE item_id='{$_POST[id]}'"))) {
			die("s=false");
		}
		
		

		$vars = array(
			"name" => stripslashes($_POST["name"]),
			"email" => stripslashes($_POST["e-mail"]),
			"phone" => stripslashes($_POST["phone"]),
			"note" => nl2br(stripslashes($_POST["mes"])),
		);

		foreach ($vars as $key => $val) {
			if (trim($val)=="") {
				//not all fields so returns error
				die("s=falsex&");
			}
		}

		//save the email to database
		$id = $this->db->QueryInsert(
			$this->tables["plugin:jobs_resumes"],
			$resume = array(
				"resume_date"	=> time(),
				"resume_job"	=> $job["item_id"],
				"module_id"		=> $job["module_id"],

				"resume_mail"	=> $vars["email"],
				"resume_name"	=> $vars["name"],
				"resume_phone"	=> $vars["phone"],
				"resume_note"	=> $vars["note"],

				"resume_cv"		=> $_POST["file"] != "nofile" ? 1 : 0,
				"resume_cv_file"=> $_POST["file"],
				"resume_code"		=> md5(microtime_float()),

			)
		);

		//process the image if needed
		if ($_POST["file"] != "nofile") {
			//process the file

			if (file_exists("upload/tmp/resume-" . $_POST["file"])) {
				rename("upload/tmp/resume-" . $_POST["file"] , "upload/resumes/{$id}.file");
				chmod("upload/resumes/{$id}.file" , 0777);
			}

			$vars["attachment_link"] = $_CONF["url"]. "resume-download.php?file=" . $resume["resume_code"]; 
		} else 
			$vars["attachment_link"] = "";

		//send the responder
		if ($this->tpl_module["settings"]["set_email_1"]) {

			$email = array(
				"email_to" => utf8_decode($this->tpl_module["settings"]["set_email_1_to_email"]),
				"email_to_name" => utf8_decode($this->tpl_module["settings"]["set_email_1_to_name"]),

				"email_from" => utf8_decode($this->tpl_module["settings"]["set_email_1_from_email"]),
				"email_from_name" => utf8_decode($this->tpl_module["settings"]["set_email_1_from_name"]),

				"email_subject" => utf8_decode($this->tpl_module["settings"]["set_email_1_subject"]),
				"email_body" => utf8_decode($this->tpl_module["settings"]["set_email_1_message"]),
				"email_type" => "html"				
				);

			foreach ($email as $key => $val) {
				$email[$key] = CTemplateStatic::Replace($val , $vars);
			}


			//send the email
			SendMail($email);
		}

		//send the responder
		if ($this->tpl_module["settings"]["set_email_2"]) {

				$email = array(	
				"email_to" => utf8_decode($vars["email"]),
				"email_to_name" => utf8_decode($vars["name"]),

				"email_from" => utf8_decode($this->tpl_module["settings"]["set_email_2_to_email"]),
				"email_from_name" => utf8_decode($this->tpl_module["settings"]["set_email_2_to_name"]),

				"email_subject" => utf8_decode($this->tpl_module["settings"]["set_email_2_subject"]),
				"email_body" => utf8_decode($this->tpl_module["settings"]["set_email_2_message"]),
				"email_type" => "html"
			);

			foreach ($email as $key => $val) {
				$email[$key] = CTemplateStatic::Replace($val , $vars);
			}

			//send the email
			SendMail($email);	
		}
		echo "status=ok&";
		die();
		
	}

	function UploadResume() {

		if (is_array($_FILES["Filedata"])) {

			if (!$_FILES["Filedata"]["error"]) {
				move_uploaded_file($_FILES["Filedata"]["tmp_name"] , "upload/tmp/resume-" . $_FILES["Filedata"]["name"]);
			}			
		}

	}


	function DownloadResume() {
		if (is_array($file = $this->db->QFetchArray("SELECT * FROM {$this->tables['plugin:jobs_resumes']} WHERE resume_code='{$_GET[file]}'"))) {
			$mime = new CMime();
			$mime->set("unknown");
			$mime->FileName($file["resume_cv_file"]);

			readfile("upload/resumes/{$file[resume_id]}.file");
			die();
		}

		else die("Invalid request!	");
		
	}

	function AlternateContent() {
		global $base;

		$this->tpl_module = $this->module->plugins["modules"]->LoadModuleInfo();
		$template = new CTemplate($this->tpl_path . "main.htm");	


		if ($_GET["sub"] == "landing") {
			//get all the news and build the list
			$news = $this->db->QFetchRowArray(
				"SELECT * FROM {$this->tables['plugin:jobs_items']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} ORDER BY item_date DESC"
			);

			//process for date
			if (is_array($news)) {
				foreach ($news as $key => $val) {
					$news[$key]["item_date"] = date($this->tpl_module["settings"]["set_date_format"] , $val["item_date"]);

					if ($val["item_main_title"]) {
						$news[$key]["main_title"] = $val["item_main_title"];
					}
					
				}			
			}

			//if empty use the module settings
			$this->module->plugins["modules"]->SetSeo($this->tpl_module);			

			return CTemplateStatic::Replace(
					$base->html->table(
						$template , 
						"Items",
						$news
					),
					$this->tpl_module
			);
		} else {
			$id = $this->module->plugins["modules"]->GetIdFromLink($_GET["sub"]);
			
			$news = $this->db->QFetchArray(
				"SELECT * FROM {$this->tables['plugin:jobs_items']} " .
				"WHERE module_id={$this->tpl_module[mod_id]} AND item_id='{$id}'"
			);

			//check for seo settings
			$this->module->plugins["modules"]->SetSeo($news);			
			//if empty use the module settings
			$this->module->plugins["modules"]->SetSeo($this->tpl_module);			

			return CTemplateStatic::Replace(
				$template->blockREplace(
					"Details",
					$news
				),
				$this->tpl_module
			);
		}
	}

	
	function GetAllLinks($module , $links) {
		//get all news for this module

		$news = $this->db->QFetchRowArray(
			"SELECT * FROM {$this->tables['plugin:jobs_items']} " .
			"WHERE module_id={$module[mod_id]}"
		);

		if (is_array($news)) {
			foreach ($news as $key => $val) {
				$links[] = array(
					"url" => $module["mod_url"] . "/" . $val["item_url"] . "-" . $val["item_id"] . "/",
					"priority" => "0.8",
				);
			}
		}
		

	}

}

?>