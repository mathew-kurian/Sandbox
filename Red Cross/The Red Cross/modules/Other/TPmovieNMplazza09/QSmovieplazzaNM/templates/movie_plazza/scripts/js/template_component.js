/**
* TemplatePlazza Javascript
* TemplatePlazza.com 
**/
function setlayout(){
	var sysmsg 		= document.getElementById('system-message');
	if(sysmsg){
		var timer	= hideWarning.delay(12000);
		$('system-message').setStyle("width", "340px");
		$('system-message').addEvent('click', function(event){ hideWarning(); });
	}
	function hideWarning(){
		var fx = new Fx.Styles($('system-message'),{duration: 200,wait: false,transition: Fx.Transitions.Quad.easeOut });
		var msgs = $('system-message').getStyle('visibility');
		if(msgs == "visible" || msgs == "inherit"){ fx.start({ 'opacity': [1, 0] }); }
	}
}
window.addEvent('domready', function(){ setlayout(); });