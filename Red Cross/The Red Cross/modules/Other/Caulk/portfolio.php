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
                        
                        <li class="current-cat"><a HREF="portfolio.php">Portfolio</a></li>
                        
                        <li><a HREF="services.php">Services</a></li>
                        
                        <li><a HREF="company.php">Company</a></li> 
                        
                        <li><a HREF="contact.php">Contact</a></li>
                    
                    </ul>
                
                </div>
                
                <!-- end menu 2 -->
			
			</div>
		
		</div>        
        <img alt="maintop" class="featured-top" SRC="images/featuredtop-grey.jpg" />
        
       	<div id="sub-strapline">
        
        	<div class="content">
            
            	<div class="floatleft">

                	<img alt="Portfolio" SRC="images/portfolio.png" />
                
                </div>
                
                <div class="floatright">
            
                    <h3>Call us anytime 24/7: 1-800-555-1234</h3>
                
                </div>
            
            </div>
            
            <br class="clearer" />
            
        </div>
	
		<div id="main" class="subpage2">	
			
			<div class="content">
				
				<div id="leftpanel">
				
                	<img alt="Portfolio Tagline" SRC="images/portfoliotagline.png" />

                    <div class="panel">
                    
                    	<div class="subpanel leftmost" onmouseover="this.style.backgroundColor='#ECECEC';this.style.borderColor='#AAAAAA';this.style.cursor='pointer'" onmouseout="this.style.backgroundColor='';this.style.borderColor='#CCCCCC'">
                            
                            <img alt="Portfolio Image" SRC="images/portfolio1.jpg" />
                            
                            <p>
                        
                                Cras non libero orci. Nulla vel ligula et turpis porttitor porta. Suspendisse potenti.
                                
                                <br /><br />
                                
                                <a href="#">Suspendisse potenti &raquo;</a>
                            
                            </p>
                        
                        </div>
                        
                        <div class="subpanel" onmouseover="this.style.backgroundColor='#ECECEC';this.style.borderColor='#AAAAAA';this.style.cursor='pointer'" onmouseout="this.style.backgroundColor='';this.style.borderColor='#CCCCCC'">
                            
                            <img alt="Portfolio Image" SRC="images/portfolio2.jpg" />
                            
                            <p>
                        
                                Cras non libero orci. Nulla vel ligula et turpis porttitor porta. Suspendisse potenti.
                                
                                <br /><br />
                                
                                <a href="#">Suspendisse potenti &raquo;</a>
                            
                            </p>
                        
                        </div>
                        
                        <div class="subpanel" onmouseover="this.style.backgroundColor='#ECECEC';this.style.borderColor='#AAAAAA';this.style.cursor='pointer'" onmouseout="this.style.backgroundColor='';this.style.borderColor='#CCCCCC'">
                            
                            <img alt="Portfolio Image" SRC="images/portfolio3.jpg" />
                            
                            <p>
                        
                                Cras non libero orci. Nulla vel ligula et turpis porttitor porta. Suspendisse potenti.
                                
                                <br /><br />
                                
                                <a href="#">Suspendisse potenti &raquo;</a>
                            
                            </p>
                        
                        </div>                        
                        
                        <br class="clearer" /><br />
                        
                        
                        
                        <div class="subpanel leftmost" onmouseover="this.style.backgroundColor='#ECECEC';this.style.borderColor='#AAAAAA';this.style.cursor='pointer'" onmouseout="this.style.backgroundColor='';this.style.borderColor='#CCCCCC'">
                            
                            <img alt="Portfolio Image" SRC="images/portfolio4.jpg" />
                            
                            <p>
                        
                                Cras non libero orci. Nulla vel ligula et turpis porttitor porta. Suspendisse potenti.
                                
                                <br /><br />
                                
                                <a href="#">Suspendisse potenti &raquo;</a>
                            
                            </p>
                        
                        </div>
                        
                        <div class="subpanel" onmouseover="this.style.backgroundColor='#ECECEC';this.style.borderColor='#AAAAAA';this.style.cursor='pointer'" onmouseout="this.style.backgroundColor='';this.style.borderColor='#CCCCCC'">
                            
                            <img alt="Portfolio Image" SRC="images/portfolio5.jpg" />
                            
                            <p>
                        
                                Cras non libero orci. Nulla vel ligula et turpis porttitor porta. Suspendisse potenti.
                                
                                <br /><br />
                                
                                <a href="#">Suspendisse potenti &raquo;</a>
                            
                            </p>
                        
                        </div>
                        
                        <div class="subpanel" onmouseover="this.style.backgroundColor='#ECECEC';this.style.borderColor='#AAAAAA';this.style.cursor='pointer'" onmouseout="this.style.backgroundColor='';this.style.borderColor='#CCCCCC'">
                            
                            <img alt="Portfolio Image" SRC="images/portfolio6.jpg" />
                            
                            <p>
                        
                                Cras non libero orci. Nulla vel ligula et turpis porttitor porta. Suspendisse potenti.
                                
                                <br /><br />
                                
                                <a href="#">Suspendisse potenti &raquo;</a>
                            
                            </p>
                        
                        </div>                        
                        
                        <br class="clearer" /><br />
                        
                        
                        
                        <div class="subpanel leftmost" onmouseover="this.style.backgroundColor='#ECECEC';this.style.borderColor='#AAAAAA';this.style.cursor='pointer'" onmouseout="this.style.backgroundColor='';this.style.borderColor='#CCCCCC'">
                            
                            <img alt="Portfolio Image" SRC="images/portfolio7.jpg" />
                            
                            <p>
                        
                                Cras non libero orci. Nulla vel ligula et turpis porttitor porta. Suspendisse potenti.
                                
                                <br /><br />
                                
                                <a href="#">Suspendisse potenti &raquo;</a>
                            
                            </p>
                        
                        </div>
                        
                        <div class="subpanel" onmouseover="this.style.backgroundColor='#ECECEC';this.style.borderColor='#AAAAAA';this.style.cursor='pointer'" onmouseout="this.style.backgroundColor='';this.style.borderColor='#CCCCCC'">
                            
                            <img alt="Portfolio Image" SRC="images/portfolio8.jpg" />
                            
                            <p>
                        
                                Cras non libero orci. Nulla vel ligula et turpis porttitor porta. Suspendisse potenti.
                                
                                <br /><br />
                                
                                <a href="#">Suspendisse potenti &raquo;</a>
                            
                            </p>
                        
                        </div>
                        
                        <div class="subpanel" onmouseover="this.style.backgroundColor='#ECECEC';this.style.borderColor='#AAAAAA';this.style.cursor='pointer'" onmouseout="this.style.backgroundColor='';this.style.borderColor='#CCCCCC'">
                            
                            <img alt="Portfolio Image" SRC="images/portfolio9.jpg" />
                            
                            <p>
                        
                                Cras non libero orci. Nulla vel ligula et turpis porttitor porta. Suspendisse potenti.
                                
                                <br /><br />
                                
                                <a href="#">Suspendisse potenti &raquo;</a>
                            
                            </p>
                        
                        </div>                        
                        
                        <br class="clearer" /><br />
                        
                        
                        
    
                    </div>
					
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