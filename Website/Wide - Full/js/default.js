/* jTweetsAnywhere settings - enter your username. */
/*---------------------------------------------------------------------*/
var twitter_user_name = 'envato';


/* Fancybox settings */
/*---------------------------------------------------------------------*/
function fancybox(){
    jQuery(".single_image, .iframe").fancybox({
        'transitionIn'	: 'none',
        'transitionOut'	: 'none',
        'easingIn'      : 'none',
        'easingOut'     : 'none',
        'speedIn'		: 600, 
        'speedOut'		: 200,
        'titlePosition'	: 'inside',
        'overlayShow'	: true,
        'overlayColor'	: '#000',
        'overlayOpacity': 0.25
    });
}


/* Nivo Slider Settings */
/*-----------------------------------------------------------------------*/
function nivo_settings(){
	jQuery('#slider').nivoSlider({
		effect: 'random', // Specify sets like: 'fold,fade,sliceDown'
		slices: 15, // For slice animations
		boxCols: 8, // For box animations
		boxRows: 4, // For box animations
		animSpeed: 500, // Slide transition speed
		pauseTime: 5000, // How long each slide will show
		startSlide: 0, // Set starting Slide (0 index)
		directionNav: true, // Next & Prev navigation
		directionNavHide: true, // Only show on hover
		controlNav: true, // 1,2,3... navigation
		controlNavThumbs: false, // Use thumbnails for Control Nav
		controlNavThumbsFromRel: false, // Use image rel for thumbs
		controlNavThumbsSearch: '.jpg', // Replace this with...
		controlNavThumbsReplace: '_thumb.jpg', // ...this in thumb Image src
		keyboardNav: true, // Use left & right arrows
		pauseOnHover: true, // Stop animation while hovering
		manualAdvance: false, // Force manual transitions
		captionOpacity: 0.8, // Universal caption opacity
		prevText: 'Prev', // Prev directionNav text
		nextText: 'Next' // Next directionNav text
	});
}


/* Animate image frame containing image and description */
/*---------------------------------------------------------------------*/
function img_frame_hover(){
	jQuery(".img_frame").hover(
		function () {
			description_height = jQuery(this).find(".description").height() + 10;
			jQuery("ul", this).not(':animated').animate({top: -description_height}, 'fast')
		}, 
		function () {
			jQuery("ul", this).animate({top: 0}, 'fast')
		}
	);
}


/* Regular expression to validate email address */
/*---------------------------------------------------------------------*/
function validateEmail(emailValue){  
	var emailPattern = /^[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/;
	return emailPattern.test(emailValue); 
}


/* Form input fields border animation on error */
/*---------------------------------------------------------------------*/
function blinkBorder(element){
	element
	.animate({borderColor: '#f36f36'}, 1000)
	.animate({borderColor: '#d2d1d0'});
}


/* Validate Form fields */
/*---------------------------------------------------------------------*/
function validateForm(bName, bEmail, bMessage){
	var fields_valid = true;
	
	if (bName && jQuery("input#name").val().length < 1) {
		blinkBorder(jQuery("input#name"));
		fields_valid = false;
    }
	if (bEmail && !validateEmail(jQuery("input#email").val())) {
		if(!bMessage) {
			jQuery("label#email_error").fadeIn('slow');
			jQuery("input#email").focus();
		} else {
			blinkBorder(jQuery("input#email"));
		}
		fields_valid = false;
    }
	if (bMessage && jQuery("textarea#message").val().length < 1) {
		blinkBorder(jQuery("textarea#message"));
		fields_valid = false;
    }
	return fields_valid;
}


jQuery(function(){
	
	/* Minor fixes for IE7 */
	/*-----------------------------------------------------------------------*/
	if ($.browser.msie && $.browser.version.substr(0,1)<8) {
		jQuery("#search fieldset").width(125);
		jQuery("#middle_footer .wrap .content").css('padding-bottom','20px');
		jQuery(".portfolio_content").not(".standard").css('padding-bottom','60px');
		jQuery(".standard li").css('padding-bottom','30px');
	}
	
	
	/* Calling function */
    /*---------------------------------------------------------------------*/
    fancybox();
	nivo_settings();
	img_frame_hover();
	
	
	/* Image Frames - set width */
	/*-----------------------------------------------------------------------*/
	jQuery('.img_frame .container').each( function(){
		img_width = jQuery(this).find("img").width();
		img_height = jQuery(this).find("img").height();
		
		jQuery(this).width(img_width);
		jQuery(this).height(img_height);
		
		jQuery(this).parent(".img_frame").not("li").width(img_width);
	});
	
	
	/* Drop-down Top Navigation */
	/*-----------------------------------------------------------------------*/
	jQuery("#top_nav li").hover(
		function () {
			sub_navigation = jQuery(this).children('ul');
			sub_navigation.not(':animated').slideDown(100);
			sub_navigation.not('.lower_level').parent().addClass('sub_nav_arrow');
		}, 
		function () {
			jQuery("ul", this).slideUp(100);
			jQuery(this).removeClass('sub_nav_arrow');
		}
	);
	
	
	/* Testimonials Rotator */
	/*-----------------------------------------------------------------------*/
	jQuery(".testimonials").hover(
		function () {
			jQuery("ul.quotes_buttons").show();
		},
		function () {
			jQuery("ul.quotes_buttons").fadeOut(100);
		}
	)
	
	jQuery(".quotes_buttons a").click(
		function () {
			if (!jQuery(this).hasClass('selected')) {
				jQuery(".quotes_buttons a").removeClass();
				
				quote_id_in = jQuery(this).attr('data-id');
				quote_id_out = jQuery(".quotes_buttons a").attr('data-id');
				
				y_offset = 182 * (quote_id_in - 1);
				if (quote_id_in > quote_id_out) {y_offset = - y_offset;};
				
				jQuery(".quotes").animate({top: y_offset}, 400);
				
				jQuery(this).addClass('selected');
			}
			
			return false;
		}
	)
	
	
	/* Screenshots Carousel on home page */
    /*---------------------------------------------------------------------*/
	var li_width = 195;
    var ul_width = jQuery("ul.carousel_items").children().length * li_width;
    jQuery("ul.carousel_items").css('width', ul_width);
    
    jQuery(".carousel").hover(
        function () {
            jQuery(".carousel_btn_left").not(':animated').show();
            jQuery(".carousel_btn_right").not(':animated').show();
        }, 
        function () {
            jQuery(".carousel_btn_left").not(':animated').hide();
            jQuery(".carousel_btn_right").not(':animated').hide();
        }
    );
    
    jQuery(".carousel_btn_left").click(function(){
        var ul_position = jQuery("ul.carousel_items").position();
		
        if(ul_position.left < 0){
            jQuery("ul.carousel_items").not(':animated').animate({ left: '+=195' }, {
                            duration: 'slow',
                            easing: 'easeOutExpo'});
        }
        return false;
    });
    
    jQuery(".carousel_btn_right").click(function(){
        var ul_position = jQuery("ul.carousel_items").position();
        var current_position = ul_width - (-ul_position.left) - 980;
        
        if(current_position > 0){
            jQuery("ul.carousel_items").not(':animated').animate({ left: '-=195' }, {
                            duration: 'slow',
                            easing: 'easeOutExpo'});
        }
        return false;
    });
	
	
    /* jTweetsAnywhere */
    /*---------------------------------------------------------------------*/
	jQuery(".tweetsFeed").jTweetsAnywhere({
		username: twitter_user_name,
		count: 1
	});
	
	
	/* Subscribe Form input placeholder */
    /*---------------------------------------------------------------------*/    
    jQuery(".placeholder, input#email").bind("click keyup", function(){
        jQuery("input#email").focus();
        jQuery(".placeholder").not(':animated').fadeOut('fast');
    });
	
	
	/* Subscribe Form on fly validation */
    /*---------------------------------------------------------------------*/
    jQuery(".error").hide();
    
    jQuery("input#email").bind("keyup focusout", function(){
		if(validateEmail(jQuery(this).val())){
			jQuery("label#email_error").not(':animated').fadeOut('fast');
        } else if(jQuery(this).val()){
			jQuery("label#email_error").fadeIn('fast'); 
        } else {
            jQuery(".placeholder").fadeIn('fast');
			jQuery(".error").hide();
        }
	});
    
	
    /* Submitting Subscribe Form using AJAX */
    /*---------------------------------------------------------------------*/
	jQuery("form#subscribe").submit(function() {
        
		var dataString = jQuery(this).serialize();
        
		if(validateForm(0,1,0)){
			jQuery.ajax({
			type: "POST",
			url: "php/subscribe.php",
			data: dataString,
			success: function() {
				jQuery('#subscribe').slideUp('slow', function(){
                    jQuery(this).html("<div id='confirmation'></div>");
                    jQuery('#confirmation').html("Request Submitted Successfully! Thank you.")
					.css({'margin-bottom':'20px', 'padding':'7px 12px', 'background':'#FFDF85'});
                    jQuery(this).slideDown('fast');
                })
			}
			});
		}
		return false;
	});
	
	
	/* Scroll page to top */
	/*---------------------------------------------------------------------*/
	jQuery(".to_top").click(function() {
		jQuery("html:not(:animated), body:not(:animated)").animate({ scrollTop: 0}, 400 );
	});
	
	
	/* Tab boxes */
	/*---------------------------------------------------------------------*/
	jQuery(".tabs_container .tab_content").hide();
	jQuery(".tabs_container ul.tabs").find("li:first").addClass("active").show();
	jQuery(".tabs_container").find(".tab_content:first").show();

	jQuery("ul.tabs li").click(function() {
		var tabs_container = jQuery(this).parent().parent();
		var tabs = tabs_container.children(".tabs");
		var tabs_contents = tabs_container.children(".tabs_contents");
		
		tabs.children("li").removeClass("active");
		jQuery(this).addClass("active");
		
		var clicked_li_id = tabs.children("li").index(this);
		var tab_content = tabs_contents.children("div").eq(clicked_li_id);
		
		tabs_contents.children(".tab_content").hide();
		jQuery(tab_content).fadeIn();
		return false;
	});
	
	
	/* QuickSand plugin */
	/*---------------------------------------------------------------------*/
	var galleryData = jQuery(".portfolio_content").clone();
	
	jQuery(".portfolio_filter li a").click(function() {
		jQuery(".portfolio_filter li a").removeClass("selected");
		jQuery(this).addClass('selected');
		
		var filterClass = jQuery(this).attr('id');
		
		if (filterClass == 'all') {
			var filteredData = galleryData.find('.item');
		} else {
			var filteredData = galleryData.find('.item[data-type~=' + filterClass + ']');
		}
		jQuery(".portfolio_content").quicksand(filteredData, {
			adjustHeight: 'dynamic',
			duration: 500,
			easing: 'easeInOutQuad',
			enhancement: function() {
				fancybox();
				img_frame_hover();
			}
		});
		return false;
	});
	
    
    /* Submitting Contact Form using AJAX */
    /*---------------------------------------------------------------------*/
	jQuery("form#contact").submit(function() {
        
		var dataString = jQuery(this).serialize();
        
		if(validateForm(1,1,1)){
			jQuery.ajax({
			type: "POST",
			url: "php/send_mail.php",
			data: dataString,
			success: function() {
				jQuery('#contact').slideUp('slow', function(){
                    jQuery(this).html("<div id='confirmation'></div>");
                    jQuery('#confirmation').html("<h2>Message Submitted Successfully!</h2>")
				    .append("<p>Thank you for contacting us. We will be in touch with you very soon.</p>");
                    jQuery(this).slideDown('slow');
                })
			}
			});
		}
		return false;
	});
	
})