        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">



<html xmlns="http://www.w3.org/1999/xhtml">

<head PROFILE="../../../../gmpg.org/xfn/11">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title>dESiGNERz-CREW.iNFO Caulk - Website Template</title>

<!-- begin style -->

<link rel="stylesheet" href="style.css" type="text/css" media="screen" />

<link rel="stylesheet" href="style/background-light.css" type="text/css" media="screen" />

<link rel="stylesheet" href="style/colors-grey.css" type="text/css" media="screen" />

<!-- styles the twitter panel -->
<link rel="stylesheet" type="text/css" href="js/jquery.twitter.css" media="screen" />
<!-- end style-->

<!-- begin javascript -->

<script type="text/javascript" SRC="js/jquery.tools.min.js"></script>
<script type="text/javascript" SRC="js/jquery.easing.1.2.js"></script>
<script type="text/javascript" SRC="js/jquery.anythingslider.js" charset="utf-8"></script>
<script type="text/javascript" SRC="js/jquery.twitter.js"></script>
<script type="text/javascript" SRC="js/cycle.js"></script>
<script type="text/javascript" SRC="js/quickcontactform.js"></script>
<script type="text/javascript" SRC="js/contactform.js"></script>

<script type="text/javascript">

    function formatText(index, panel) {
      return index + "";
    }

    $(function () {
    
        $('.anythingSlider').anythingSlider({
            easing: "easeInOutExpo",        // Anything other than "linear" or "swing" requires the easing plugin
            autoPlay: true,                 // This turns off the entire FUNCTIONALY, not just if it starts running or not.
            delay: 3000,                    // How long between slide transitions in AutoPlay mode
            startStopped: false,            // If autoPlay is on, this can force it to start stopped
            animationTime: 800,             // How long the slide transition takes
            hashTags: true,                 // Should links change the hashtag in the URL?
            buildNavigation: true,          // If true, builds and list of anchor links to link to each slide
            pauseOnHover: true,             // If true, and autoPlay is enabled, the show will pause on hover
            startText: "Go",             // Start text
            stopText: "Stop",               // Stop text
            navigationFormatter: formatText       // Details at the top of the file on this use (advanced use)
        });
        
        $("#slide-jump").click(function(){
            $('.anythingSlider').anythingSlider(6); //not used
        });
        
        $('.anythingSlider2').anythingSlider({
            easing: "easeInOutBack",        // Anything other than "linear" or "swing" requires the easing plugin
            autoPlay: true,                 // This turns off the entire FUNCTIONALY, not just if it starts running or not.
            delay: 3000,                    // How long between slide transitions in AutoPlay mode
            startStopped: false,            // If autoPlay is on, this can force it to start stopped
            animationTime: 1500,             // How long the slide transition takes
            hashTags: false,                 // Should links change the hashtag in the URL?
            buildNavigation: false,          // If true, builds and list of anchor links to link to each slide
            pauseOnHover: true,             // If true, and autoPlay is enabled, the show will pause on hover
            startText: "Go",             // Start text
            stopText: "Stop",               // Stop text
            navigationFormatter: formatText       // Details at the top of the file on this use (advanced use)
        });
        
    });
    $(document).ready(function() {                
        $("#twitter").getTwitter({
            userName: "outerspice", //adjust this in the theme options page
            numTweets: 3, //number of Tweets to show
            loaderText: "Loading-2520tweets..-2E", //text that displays while Tweets are first loading
            slideIn: true, //when Tweets load, how should they appear
            slideDuration: 1000, //not used
            showHeading: false, //shows the heading
            headingText: "Latest Tweets", //the heading text
            showProfileLink: true, //show your Tweet profile link at the bottom of your Latest Tweets?
            showTimestamp: true //show timestamps for each Tweet?
        });
		$('#testimonials').cycle({
			fx: 'scrollDown',
			speed:    1500, 
			timeout:  4000
			//fx:     'scrollDown', 
			//speedIn:  2000, 
			//speedOut: 500, 
			//easeIn:  'bounceout', 
			//easeOut: 'backin', 
			//delay:   -2000 
		});				
    });
</script>

<script type="text/javascript" SRC="js/scrollinit.js"></script>
	
<!-- end javascript -->

</head>

<body>

<div id="outer">
	
	<div id="inner">
	
		<div id="mainTop">&nbsp;</div>	
		
		<div id="header">
		
			<div class="content">
			
				<div id="logo">
			
					<a class="title" HREF="index.php"> 
                                       	
						<img alt="Caulk Logo" SRC="images/caulk_logo.gif" /> 
                                                  
					</a>
					
				</div>	
                
                <!-- begin menu 2 -->
                
                <div id="menu" class="menu">
                
                	<ul>
                
                		<li><a HREF="index.php">Home</a></li>
                        
                        <li><a HREF="portfolio.php">Portfolio</a></li>
                        
                        <li><a HREF="services.php">Services</a></li>
                        
                        <li><a HREF="company.php">Company</a></li> 
                        
                        <li class="current-cat"><a HREF="contact.php">Contact</a></li>
                    
                    </ul>
                
                </div>
                
                <!-- end menu 2 -->
			
			</div>
		
		</div>        
        <img alt="maintop" class="featured-top" SRC="images/featuredtop-grey.jpg" />
        
       	<div id="sub-strapline">
        
        	<div class="content">
            
            	<div class="floatleft">

                	<img alt="Contact" SRC="images/contact.png" />
                
                </div>
                
                <div class="floatright">
            
                    <h3>Call us anytime 24/7: 1-800-555-1234</h3>
                
                </div>
            
            </div>
            
            <br class="clearer" />
            
        </div>
	
		<div id="main" class="subpage1">	
			
			<div class="content">
				
				<div id="leftpanel">
				
                	<img alt="Contact Tagline" SRC="images/contacttagline.png" />

                    <div class="panel">
                    
                        <div class="thumbnail">
                        
                            <img alt="Chat" SRC="images/chat.png" />
                        
                        </div>
                        
                      	<p>Cras non libero orci. Nulla vel ligula et turpis porttitor porta. Suspendisse potenti. Duis malesuada ultrices bibendum. Donec aliquam venenatis risus, quis venenatis dui tincidunt ut. Etiam venenatis rhoncus ipsum, id laoreet nunc ullamcorper vel. Nulla vitae sapien nisl, ut scelerisque neque. Morbi ut velit neque, ac accumsan augue.</p>
                        
                        <br /><br />

                        
                        <div id="contact">
                        
                        	<!-- NOTE, since there are two contact forms (this one and quick contact)
                            all of the elements are named with a "2" appended in this contact form
                            so they are distinguished with the one in the footer. -->
                        
                            <form name="contact" action="">
						
                                <label for="name2" id="name2_label">Name</label>
                                <label class="error2" for="name2" id="name2_error">*</label><br />
                                <input type="text" name="name2" id="name2" /><br />							
                                
                                <label for="email" id="email2_label">Email</label>
                                <label class="error2" for="email2" id="email2_error">*</label><br />
                                <input type="text" name="email2" id="email2" /><br />
                                
                                <label for="website2" id="website2_label">Website</label>
                                <label class="error2" for="website2" id="website2_error">*</label><br />
                                <input type="text" name="website2" id="website2" /><br />
                                
                                <label for="subject2" id="subject2_label">Subject</label>
                                <label class="error2" for="subject2" id="subject2_error">*</label><br />
                                <input type="text" name="subject2" id="subject2" /><br />
                                
                                <label for="message2" id="message2_label">Message</label>
                                <label class="error2" for="message2" id="message2_error">*</label><br />
                                <textarea rows="20" cols="50" name="message2" id="message2"></textarea><br />
                                
                                <div class="floatleft">                                
                                    <label for="verify2" id="verify2_label">What is two plus three?</label>
                                </div>
                                <div class="floatleft">							
                                    <input type="text" name="verify2" id="verify2" />
                                </div>
                                <div class="floatleft">							
                                    <label class="error2" for="verify2" id="verify2_error">*</label>
                                </div>                                
                                <div class="floatright">                                
                                    <input id="submit2" name="submit2" class="button2" type="submit" value="Send &raquo;" />                                    
                                </div>
                            
                            </form>
                        
                        </div>
                        
                        
                        <br class="clearer" />
    
                    </div>
					
				</div>
				
				<div id="rightpanel">
                
                	<div class="thumbnail">
                    
                    	<img alt="Clock" SRC="images/clock.png" />
                        
                    </div>
                    
                    <div class="panel">
                    
                    	<h3>Business Hours</h3>
                    
                    	Our customer service department is open:<br /><br />
                        
                        <b>Monday - Friday</b><br /><br />
                        
                        <b>8:00 AM - 5:00 PM EST</b><br /><br />
                        
                        We will attempt to respond to your message within 24 business hours of receiving it.

                        
                        <br class="clearer" />
    
                    </div>
                    
                    <div class="clearer20">&nbsp;</div>
                    
                    <div class="clearer20">&nbsp;</div>
                    
                    <div class="thumbnail">
                    
                    	<img alt="Email" SRC="images/email.png" />
                        
                    </div>
                    
                    <div class="panel">
                    
                    	<h3>Contact Form</h3>
                    
                    	Please fill out the contact form on this page for inquiries, questions, feedback, or technical support. Enter the subject of your correspondance in the subject line and please be as descriptive as possible when filling out the message box. If you have a phone number you would like us to call you at, please include that in the body of your message. 
                        
                        <br class="clearer" />
    
                    </div>
                    
                    <div class="clearer20">&nbsp;</div>
                    
                    <div class="clearer20">&nbsp;</div>
                    
                    <div class="thumbnail">
                    
                    	<img alt="Info" SRC="images/info.png" />
                        
                    </div>
                    
                    <div class="panel">
                    
                    	<h3>An Informational Snippet</h3>
                    
                    	Aliquam pretium erat ut mi molestie dignissim. Sed semper, nisi sit amet semper sollicitudin, risus odio luctus nisl, iaculis fermentum diam turpis eget urna. <b>Here's something in bold text</b>. Nunc sem eros, vehicula vel tincidunt ut, condimentum non augue.
                        
                        <ul>
                        
                        	<li>Aliquam pretium</li>
                            
                            <li>Condimentum non</li>
                            
                            <li>Molestie dignissim</li>
                        
                        </ul>
                        
                        Sed semper, nisi sit amet semper sollicitudin, risus odio luctus nisl, iaculis fermentum diam turpis eget urna. <em>Here's something in italics</em>. Nunc sem eros, vehicula vel tincidunt ut, condimentum non augue.
                        
                        <br /><br />
                        
                        <a href="#">Aliquam pretium &raquo;</a>
                        
                        <br class="clearer" />
    
                    </div>
                    
                    <div class="clearer20">&nbsp;</div>
                    
                    <div class="clearer20">&nbsp;</div>
									
				</div>
                
                <br class="clearer" />
				
			</div>
            
						<div id="footer">
            
            	<!-- BEGIN FOOTER LEFT PANEL -->
            
                <div class="widget">
                
                    <div class="header">
                
                        <img alt="Archives" SRC="images/latesttweets.jpg" />
                        
                    </div>
                    
                    <div class="content">
                    
                        <div id="twitter">
                            
                        </div>
                                                  
                    </div>
                
                </div>
                
                <!-- END FOOTER LEFT PANEL -->
                
                <!-- BEGIN FOOTER MIDDLE PANEL -->
        
                <div class="widget">
                
                    <div class="header">
                
                        <img alt="Links" SRC="images/quickcontact.jpg" />
                        
                    </div>
                    
                    <div class="content" id="quickcontact">
                    
                        <form name="quickcontact" action="">
						
							<label for="name" id="name_label">Name</label>
							<label class="error" for="name" id="name_error">*</label><br />
							<input type="text" name="name" id="name" /><br />							
							
							<label for="email" id="email_label">Email</label>
							<label class="error" for="email" id="email_error">*</label><br />
							<input type="text" name="email" id="email" /><br />
							
							<label for="message" id="message_label">Message</label>
							<label class="error" for="message" id="message_error">*</label><br />
							<textarea rows="20" cols="50" name="message" id="message"></textarea><br />
                            
                            <div class="floatleft">							
                                <label for="verify" id="verify_label">What is two plus three?</label>
                            </div>
                            <div class="floatleft">							
                                <input type="text" name="verify" id="verify" />	
                            </div>
                            <div class="floatleft">						
                                <label class="error" for="verify" id="verify_error">*</label>
                            </div>  
                            <div class="spacer10">&nbsp;</div>                         
                            <div class="floatleft">							
								<input id="submit" name="submit" class="button" type="submit" value="Send" />                                
                            </div>
						
						</form>
                                                  
                    </div>
                
                </div>
                
                <!-- END FOOTER MIDDLE PANEL -->                
                
                <!-- BEGIN FOOTER RIGHT PANEL -->
				
				<div class="widget">
                
                	<div class="header">
                    
                        <img alt="Copyright" SRC="images/copyright.jpg" />
                        
                    </div>
                    
                    <div class="content rightmost">
                        
                        Copyright &copy; 2010<br />
                        <a title="title" HREF="index.php">Caulk - Website Template</a><br />
                        All Rights Reserved
                        
                        <br /><br /><br /><br />

                        Website Theme By<br />
                        <a title="Outer Spice Web Company" HREF="../../../../www.outerspiceweb.com/index.htm">Outer Spice Web Company</a><br />
                        Fonts by <a title="Campivisivi" HREF="../../../../www.campivisivi.net/titillium/index.htm">Campivisivi</a> &amp;<br /><a HREF="../../../../www.theleagueofmoveabletype.com/index.htm">The League of Moveable Type</a><br />
                        Bag icon by <a HREF="../../../../artdesigner.lv/archives/321">Armany</a>
                                                  
                    </div>
									
				</div>
                
                <!-- END FOOTER RIGHT PANEL -->
				
				<div class="clearer">&nbsp;</div>			
				
			</div>
            
            <div class="clearer">&nbsp;</div>
		
		</div>
		
		<div id="mainBottom">&nbsp;</div>
		
	</div>
	
</div>

</body>
</html>