/**
* TemplatePlazza Javascript
* TemplatePlazza.com 
**/
function setlayout(){
	var sysmsg 		= document.getElementById('system-message');
	if(sysmsg){
		var timer	= hideWarning.delay(12000);
		var size	= $('system-message').getSize();
		var sizex	= (screen.width - size['size']['x'])/2;
		var	wint	= ((screen.height - size['size']['y'])/2)-200;
		$('system-message').setStyle("left", sizex + "px");
		$('system-message').setStyle("top", wint + "px");
		$('system-message').addEvent('click', function(event){ hideWarning(); });
	}
	function hideWarning(){
		var fx = new Fx.Styles($('system-message'),{duration: 200,wait: false,transition: Fx.Transitions.Quad.easeOut });
		var msgs = $('system-message').getStyle('visibility');
		if(msgs == "visible" || msgs == "inherit"){ fx.start({ 'opacity': [1, 0] }); }
	}
	
	var tooltips = new Tips($$('.tooltips'),{
		initialize:function(){
		this.fx = new Fx.Style(this.toolTip, 'opacity', {duration: 500, wait: false}).set(0);
		},
		onShow: function(toolTip){ this.fx.start(1); },
		onHide: function(toolTip){ this.fx.start(0); }
	});
}
window.addEvent('domready', function(){ setlayout(); });