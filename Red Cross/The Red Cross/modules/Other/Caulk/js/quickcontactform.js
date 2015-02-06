  $(function() {
    $('.error').hide();
    $(".button").click(function() {
      // validate and process form here
      
      $('.error').hide();
  	  var name = $("input#name").val();
  		if (name == "") {
        $("label#name_error").show();
        $("input#name").focus();
        return false;
      }
  		var email = $("input#email").val();
  		if (email == "") {
        $("label#email_error").show();
        $("input#email").focus();
        return false;
      }	
  		var message = $("textarea#message").val();
  		if (message == "") {
        $("label#message_error").show();
        $("textarea#message").focus();
        return false;
      }
	  	var verify = $("input#verify").val();
		if ((verify != "five" && verify != "5") || verify == "") {
		$("label#verify_error").show();
		$("input#verify").focus();
		return false;
	  }
	  
	  var dataString = 'name='+ name + '&email=' + email + '&message=' + message;
	  //alert (dataString);return false;
	  $.ajax({
		type: "POST",
		url: "includes/quickcontact.php",
		data: dataString,
		success: function() {
		  $('#quickcontact').html("<div id='quickcontact_message'></div>");
		  $('#quickcontact_message').html("<h2>Contact Form Submitted!</h2>")
		  .append("<p>We will be in touch soon.</p>")
		  .hide()
		  .fadeIn(1500, function() {
			$('#quickcontact_message').append("<img id='check' src='images/check.gif' />");
		  });
		}
	  });
	  return false;  
      
    });
  });
  