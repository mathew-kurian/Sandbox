	$(document).ready(function() { 
		function filterPath(string) {
		  return string
		 .replace(/^\//,'')
		 .replace(/(index|default).[a-zA-Z]{3,4}$/,'')
		 .replace(/\/$/,'');
		  }
		  var locationPath = filterPath(location.pathname);
		  $('a[href*=#]').each(function() {
		 var thisPath = filterPath(this.pathname) || locationPath;
		 if (locationPath == thisPath && (location.hostname == this.hostname || !this.hostname) && this.hash.replace(/#/,'') ) {
		   var $target = $(this.hash), target = this.hash;
		   if (target) {
		  var targetOffset = $target.offset().top;
		  $(this).click(function(event) {
			event.preventDefault();
			$('html, body').animate({scrollTop: targetOffset}, 800, 'easeInOutExpo', function() {
		   location.hash = target;
			});
		  });
		   }
		 }
		});
	});