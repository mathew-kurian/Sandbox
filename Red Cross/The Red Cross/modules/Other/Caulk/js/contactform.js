  $(function() {
    $('.error2').hide();
    $(".button2").click(function() {
      // validate and process form here
      
      $('.error2').hide();
  	  var name = $("input#name2").val();
  		if (name == "") {
        $("label#name2_error").show();
        $("input#name2").focus();
        return false;
      }
  		var email = $("input#email2").val();
  		if (email == "") {
        $("label#email2_error").show();
        $("input#email2").focus();
        return false;
      }	
	    var website = $("input#website2").val();
  		//if (website == "") {
        //$("label#website2_error").show();
        //$("input#website2").focus();
        //return false;
      //}
	    var subject = $("input#subject2").val();
  		if (subject == "") {
        $("label#subject2_error").show();
        $("input#subject2").focus();
        return false;
      }
  		var message = $("textarea#message2").val();
  		if (message == "") {
        $("label#message2_error").show();
        $("textarea#message2").focus();
        return false;
      }
	  	var verify = $("input#verify2").val();
		if ((verify != "five" && verify != "5") || verify == "") {
		$("label#verify2_error").show();
		$("input#verify2").focus();
		return false;
	  }
	  
	  var dataString = 'name='+ name + '&email=' + email + '&website=' + website + '&subject=' + subject + '&message=' + message;
	  //alert (dataString);return false;
	  $.ajax({
		type: "POST",
		url: "includes/contact.php",
		data: dataString,
		success: function() {
		  $('#contact').html("<div id='contact_message'></div>");
		  $('#contact_message').html("<h2>Contact Form Submitted!</h2>")
		  .append("<p>We will be in touch soon.</p>")
		  .hide()
		  .fadeIn(1500, function() {
			$('#contact_message').append("<img id='check' src='images/check_large.gif' />");
		  });
		}
	  });
	  return false;  
      
    });
  });
  