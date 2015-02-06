<?php
/*
	PHPbase web framework
	copyright (c) 2003 @authors

	$Id: name.php,v 0.0.1 dd/mm/yyyy hh:mm:ss author Exp $
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
class CAuth extends CModule{
	/**
	* description
	*
	* @param
	*
	* @return
	*
	* @access
	*/
	function CAuth() {
		parent::CModule("auth");
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
	function DoEvents() {
		global $_CONF, $base , $_TSM , $_USER , $_SESS;

		parent::DoEvents();
		//$this->GetInfoBlock();
		//$this->__protect();

		switch ($_GET["sub"]) {
#settings valid for admins only

			case "ajax":
				return $this->__ajax();
			break;
# LOGIN PART
			
			default:
/*
				if (is_array($_USER)) {
					return false;
				}				

				//check if there a cookie for autologin 
				if ($_COOKIE["autologin"] == "true") {
					//read the user
					if (is_array($user = $this->db->QFetchArray("SELECT * FROM {$this->private->tables[users]} WHERE `user_login`='{$_COOKIE[username]}'") )) {
						//check if password match
						if (md5($user["user_login"] . $user["user_password"]) == $_COOKIE["keycode"]) {

							//redirect the looser
							$this->__redirect($user);
						}						
					}					
				}

				$_GET["action"] = "edit";
				$data = new CFormSettings($_CONF["forms"]["adminpath"] . "login.xml" ,$_CONF["forms"]["admintemplate"] , $this->db,$this->private->tables);

				if ($_SESS["tries"] < 3) {
					unset($data->form["fields"]["check"]);
				}				

				//check for redirect
				if (!$_POST["redirect"]) {

					if ($_SERVER["REQUEST_METHOD"] == "POST") {
					
						$original = CSYS::ExtractVars($_SERVER["REQUEST_URI"]);

						if (in_array($original["mod"] , $_CONF["modules_back"]) && ($original["mod"] != "auth")) {
							//build the redirect
							$_POST["redirect"] = base64_encode(
													serialize(
														array_merge(
															$_POST,
															array("_original_redirect_url" => $_SERVER["REQUEST_URI"])
														)
													)
												);

							$_POST["redirect_encode"] = "1";

							//force get request
							$_SERVER["REQUEST_METHOD"] = "GET";						
						}
					} else {
						$_POST["redirect"] = $_SERVER["REQUEST_URI"];
					}
				}


				if ($data->Done()) {
					// check if valid user
					if (is_array($user = $this->db->QFetchArray("SELECT * FROM {$this->private->tables[users]} WHERE `user_login`='{$_POST[username]}' AND `user_password`=md5('{$_POST[password]}')"))) {
						
						//save this login info and date
						$this->db->Query("UPDATE {$this->private->tables[users]} SET user_log_last_login=" . time() . " , user_log_last_ip='" . $_SERVER["REMOTE_ADDR"] . "' WHERE user_id='{$user[user_id]}'");

						//reset the counter
						unset($_SESS["tries"]);

						//redirect the user to the proper location

						if ($_POST["remember"]) {
							$time = time()+3600 *24 * 3600 ; // one year ahead
							setcookie("autologin", "true", $time);  
							setcookie("username", $_POST["username"], $time);  
							setcookie("keycode" , md5($_POST["username"] . $user["user_password"]) , $time);
						}

						//redirecing to viuw sites
						$this->__redirect($user);

					} else {
						$_SESS["tries"] = (int) $_SESS["tries"] + 1;
						//increment the tries for this user
						$this->db->Query("UPDATE {$this->private->tables[users]} SET user_log_tries=user_log_tries+1 WHERE user_login='{$_POST[username]}'");

						$data->_errors = array(
								"errors" => array("password" => "1" , "username" => "1"),
								"error" => "Invalid username or password!",
								"values" => $_POST
							);
					}				
				}				

				return $data->Show($_POST);	
*/
			break;

# RECOVER

			case "recover":
			case "verify":
				$_GET["action"] = "edit";

				$data = new CFormSettings($_CONF["forms"]["adminpath"] . $_GET["sub"] . ".xml" ,$_CONF["forms"]["admintemplate"] , $this->db,$this->private->tables);
				if ($data->done()) {
					switch ($_GET["sub"]) {

						case "verify":
							if (is_array($user = $this->db->QFetchArray("SELECT * FROM {$this->private->tables[users]} WHERE user_key='{$_POST[key]}'"))) {

								$user["user_link"] = $_CONF["_url"];
								$user["pass"] = RandomWord(6);

								$this->db->Query("UPDATE {$this->private->tables[users]} SET user_password=md5('$user[pass]'),user_key='' WHERE user_key='{$user[user_key]}'");

								//send the notify email
								SendMail(array(
										"email_to" => $user["user_email"],
										"email_to_name" => $user["user_first_name"] . " " . $user["user_last_name"],

										"email_from_name" => "Administration Panel", 
										"email_from" => "support@oxylus-development.com", 

										"email_subject" => "Recover Password Instructions",
										"email_body" => $this->private->templates["mail"]->blocks["Login"]->Replace($user)
									),
									$user
								);										

								urlRedirect("index.php");
							}	else {					
								$data->_errors = array(
										"errors" => array("key" => "1"),
										"error" => "Invalid recover key!",
										"values" => $_POST
									);
							}
						break;

						case "recover":
							if (is_array($user = $this->db->QFetchArray("SELECT * FROM {$this->private->tables[users]} WHERE user_email='{$_POST[email]}'"))) {

								//geenrate the key 
								$key = strtoupper(md5($user["user_login"]));
								$user["user_key"] = $key;
								$user["user_link"] = $_CONF["_url"];

								$this->db->Query("UPDATE {$this->private->tables[users]} SET user_key='$key' WHERE user_email='{$_POST[email]}'");

								//send the notify email
								SendMail(array(
										"email_to" => $user["user_email"],
										"email_to_name" => $user["user_first_name"] . " " . $user["user_last_name"],

										"email_from_name" => "Administration Panel", 
										"email_from" => "support@oxylus-development.com", 

										"email_subject" => "Recover Password Instructions",
										"email_body" => $this->private->templates["mail"]->blocks["Recover"]->Replace($user)
									),
									$user
								);										


								urlRedirect("index.php?sub=verify");
							} else {					
								$data->_errors = array(
										"errors" => array("email" => "1"),
										"error" => "Invalid email address!",
										"values" => $_POST
									);
							}

						break;
					}
					
				}
				
				return $data->Show($_POST);	

			break;

#LOGOUT
			case "logout":
				unset($_SESS["minibase"]);
				if (isset($_USER)) {
					unset($_USER);
				}

				//remove the cookie
				setcookie("autologin", "", time() - 3600);  
				setcookie("username", "", time() - 3600);  
				setcookie("keycode" , "" , time() - 3600);

				header("Location: index.php");
				exit;
			break;

#USERS MANAGEMENT

			case "profile":
				URLRedirect($_SERVER["PHP_SCRIPT"] . "?mod={$this->name}&sub=users&action=details&user_id={$_USER[user_id]}");
			break;

			case "users":
				$data = new CSQLAdmin($_GET["sub"], $_CONF["forms"]["admintemplate"],$this->db,$this->private->tables,$extra);
				if (!strlen($_POST["user_password"]))
					unset($_POST["user_password"]);

				$data->functions = array( 
						"onstore" => array(&$this , "__call_user_store"),
				);

				return $data->DoEvents();
			break;
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
	function __redirect($user) {
		global $_CONF , $_SESS , $_USER;

		//save the current user in the session

		$redirect = "index.php";

		//overwrite the default location with the site config one
		if ($_CONF["default_location"]) {
				$redirect = $_CONF["default_location"];
		}

		//check if this is a cookie redirect 
		if ($_COOKIE["autologin"]) {
			//get all the data from $_GET
			$original = CSYS::ExtractVars($_SERVER["REQUEST_URI"]);

			if (in_array($original["mod"] , $_CONF["modules_back"]) && ($original["mod"] != "auth")) {

				//okay, redirect there
				if ($_SERVER["REQUEST_METHOD"] == "POST") {

					$user["user_log_last_hostname"] = @gethostbyaddr($user["user_log_last_ip"]);
					$_SESS["minibase"]["user"] = 1;
					$_SESS["minibase"]["raw"] = $user;
					$_USER = $user;

					$this->__private_post($_POST , $_SERVER["REQUEST_URI"]);
					die("POST");

				} else {
					$redirect = $_SERVER["REQUEST_URI"];
				}
			}			

		} else {
			//if there was a redirect overwrite the current with the one from redirect
			if (strlen($_POST["redirect"])){

				if ($_POST["redirect_encode"] == "1") {
					$post = unserialize(base64_decode($_POST["redirect"]));

					$user["user_log_last_hostname"] = @gethostbyaddr($user["user_log_last_ip"]);
					$_SESS["minibase"]["user"] = 1;
					$_SESS["minibase"]["raw"] = $user;
					$_USER = $user;

					$this->__private_post($post , $post["_original_redirect_url"]);
				}
				
				$redirect = $_POST["redirect"];
			} 
		}	

		$user["user_log_last_hostname"] = @gethostbyaddr($user["user_log_last_ip"]);
		$_SESS["minibase"]["user"] = 1;
		$_SESS["minibase"]["raw"] = $user;
		$_USER = $user;

		URLRedirect($redirect);
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
	function __private_post($vars , $url) {
		$html = "<html><body><form method='post' action='{$url}'>";

		if (is_array($vars))
		//add the values;
		foreach ($vars as $key => $val) {
			$html .= "<textarea style='visibility:hidden' name='{$key}'>" . trim($val) . "</textarea>";
		}

		$html .= "</form><script>document.forms[0].submit();</script>";

		die($html);
		
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
	function __call_user_store($record , $type) {
		if ($_POST["user_password"]) {
			
			$this->db->Query("UPDATE {$this->private->tables[users]} SET user_password=md5('$_POST[user_password]') WHERE user_id='{$record[user_id]}'");
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
	function __ajax() {
		switch ($_GET["action"]) {
			case "login":
				$code = $this->__login_user($_POST["username"] , $_POST["password"] , $_POST["code"] );
				die("x");
			break;
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
	function __login_user($username , $pass , $code = "") {
		global $_SESS , $_USER;

		//read the user
		$user = $this->db->QFetchArray("SELECT * FROM {$this->private->tables[users]} WHERE `user_login`='$username'");


		if (!is_array($user)) 
			die("invalid");

		//update the tries
		$this->db->QueryUpdate(
			$this->private->tables["users"],
			array(
				"user_log_tries" => $user["user_log_tries"] + 1
			),
			"user_id={$user[user_id]}"
		);

		//check for user status
		if ($user["user_log_status"])
			die("suspended");

		if (($user["user_log_tries"] >= 3) && (!$code)) {
			die("code");
		}
		
		if ($code) {		
			if ($_SESS["XML_verify_key"] != $code) {
				die("code");
			}
		}
		
		
		//check for the password
		if ($user["user_password"] != md5($pass))
			die("password");


		if ($_POST["remember"]) {
			$time = time()+3600 *24 * 3600 ; // one year ahead
			setcookie("autologin", "true", $time);  
			setcookie("username", $user, $time);  
			setcookie("keycode" , md5($user["username"] . $user["user_password"]) , $time);
		}

		//reset the tries and save the last login info
		$this->db->QueryUpdate(
			$this->private->tables["users"],
			array(
				"user_log_tries" => 0,
				"user_log_last_login" => time(),
				"user_log_last_ip" => $_SERVER["REMOTE_ADDR"]
			),
			"user_id={$user[user_id]}"
		);

		$_SESS["minibase"]["user"] = 1;
		$_SESS["minibase"]["raw"] = $user;
		$_USER = $user;

		die("ok");

	}
	

	


}

?>