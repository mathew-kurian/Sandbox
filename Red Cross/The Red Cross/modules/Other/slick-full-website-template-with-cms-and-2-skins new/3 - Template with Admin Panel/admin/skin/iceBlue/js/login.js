
		var __code = false;
		var __url_submit = "index.php?mod=auth&sub=ajax&action=login";

		function ShowError(txt){
			document.getElementById("errorContent").innerHTML = txt;
			document.getElementById("errorMsg").style.display = "block";
		}

		function SubmitLogin(){
			var form = document.getElementById("form");

			if (!form.username.value || !form.password.value) {
				ShowError(__code ? "Please fill in all fields!" : "Please fill in both username and password!");

			} else {

				var response = HTTPPostRequest(
					false,
					__url_submit,
					{
						"username" : form.username.value,
						"password" : form.password.value,
						"code" : form.code.value
					}
				);

				switch (response) {
					case "invalid":
						ShowError("Invalid account!");
					break;

					case "password":
						ShowError("Invalid password!");
						form.password.value = "";
						form.password.focus();
					break;

					case "ok":
						window.location.reload();				
					break;

					case "code":
						//show the fill in value
						document.getElementById("content").className = "fullform";
						document.getElementById("security").src='index.php?global=security&date=' + (new Date()).getTime();

						//reset the code
						form.code.value = "";

						if (__code == true) {
							ShowError("Verification code and image must match!");
						} else {
							ShowError("Enter the verification code in order to login!");
							__code = true;
						}
						
					break;
				}
				
			}
		}
