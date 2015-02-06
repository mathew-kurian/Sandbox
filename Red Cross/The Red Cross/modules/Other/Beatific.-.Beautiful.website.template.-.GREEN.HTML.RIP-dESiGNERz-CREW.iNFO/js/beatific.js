$(document).ready(function() {

	var changetime = 6000; // In miliseconds (1 second = 1000 milisecond)
	
	
	
	/* ----------------------------------------------- */
	/* Setting up the Image Scroller for the Home page */
	/* ----------------------------------------------- */
			
	var next = 0;
	
	function scroll(index) {
	
		clearInterval(activate_interval);
	
		next = index;
	
		if (next >= $('div.scroller ul').children().size()) next = 0;
		
		$('div.scroller ul li.active').fadeOut('normal', function() {
			$(this).attr('class', '');
			$('div.scroller ul li').eq(next).fadeIn('normal', function() {
				$(this).addClass('active');
			});
		});
	
		next++;
	
		if (next >= $('div.scroller ul').children().size()) next = 0;
		
		activate_interval = setInterval(function() { scroll(next); }, changetime);
		
	}
	
	activate_interval = setInterval(function() { scroll(next); }, changetime);
	
	
	
	/* -------------------------------------------------------------- */
	/* Adding the hover effect on the Image Scroller on the Home page */
	/* -------------------------------------------------------------- */
	
	$('div.scroller ul li').mouseover(function() {
		$(this).children('div.desc').stop().animate({'bottom': 0}, 300);
		clearInterval(activate_interval);
	}).mouseout(function() {
		$(this).children('div.desc').stop().animate({'bottom': '-50px'}, 300);
		activate_interval = setInterval(function() { scroll(next); }, changetime);
	});
	
	
	
	/* -------------------------------------------------------------------------------- */
	/* Clearing or filling the textareas when clicked, depending on their current value */
	/* -------------------------------------------------------------------------------- */
	
	$('textarea#message, textarea.message').focus(function() {
		if ($(this).attr('value') == 'Your message') $(this).attr('value', '');
		$(this).parent().addClass('selected');
	}).blur(function() {
		$(this).parent().removeClass('selected');
		if ($(this).attr('value') == '') { $(this).attr('value', 'Your message'); $(this).parent().removeClass('filled'); } else { $(this).parent().addClass('filled'); }
	});
	
	
	
	/* ------------------------------------------------------------ */
	/* Creating inputs array for containing the input fields' value	*/
	/* ------------------------------------------------------------ */
	
	var inputs = new Array();
	var i = 0;
	
	$('input:not(input.clear, input.sendit)').each(function() {
		inputs[i] = $(this).attr('value');
		i++;
	});
	
	
	/* ------------------------------------------------------------------------------------- */
	/* Clearing or filling the input elements when clicked, depending on their current value */
	/* ------------------------------------------------------------------------------------- */
		
	$('input:not(input.clear, input.sendit)').each(function() {
		$(this).focus(function() {
			if ($(this).attr('value') == inputs[$('input').index(this)]) $(this).attr('value', '');
		}).blur(function() {
			if ($(this).attr('value') == '') { $(this).attr('value', inputs[$('input').index(this)]); $(this).parent().removeClass('filled'); } else { $(this).parent().addClass('filled'); }
		});
	});
	
	
	
	/* -------------------------------------------------------------- */
	/* Adding selected class on the input fields' parent element divs */
	/* -------------------------------------------------------------- */
	
	$('body.contact div.input input').focus(function() {
		$(this).parent().addClass('selected');
	}).blur(function() {
		$(this).parent().removeClass('selected');
	});
	
	
	
	/* ----------------------------------------------------------------------------- */
	/* Fixing the input element's to get in focus when clicked on the containing div */
	/* ----------------------------------------------------------------------------- */
	
	$('div.input').click(function() { $(this).children('input:text:visible:enabled:first').focus(); });
	$('div.search').click(function() { $(this).children('form').children('input:text:visible:enabled:first').focus(); });
	
	
	
	/* ------------------------------- */
	/* Addig lightbox to the portfolio */
	/* ------------------------------- */
	
	$('div.big a.gallery').lightBox(); 
	
	var ie7 = (document.all && !window.opera && window.XMLHttpRequest);
	if (ie7) $('input.search, input.sendit, input#sendit').attr('value', '');
	
});