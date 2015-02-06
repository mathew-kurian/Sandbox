/**
 * SWFForceSize v1.0: Flash container size limiter for SWFObject - http://blog.pixelbreaker.com/
 *
 * SWFForceSize is (c) 2006 Gabriel Bucknall and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Dependencies: 
 * SWFObject v2.0 - (c) 2006 Geoff Stearns.
 * http://blog.deconcept.com/swfobject/
 */
function SWFForceSize( swfObject, minWidth, minHeight )
{
	this.div = swfObject.getAttribute('id');
	this.minW = minWidth;
	this.minH = minHeight;
	
	var o = this;
	this.addWindowEvent( 'onload', this, this.onLoadDiv );
	this.addWindowEvent( 'onresize', this, this.onResizeDiv );
}

SWFForceSize.prototype = {
	addWindowEvent: function( eventName, scope, func )
	{
		var oldEvent = window[ eventName ];
		if (typeof window[ eventName ] != 'function') window[ eventName ] = function(){ func.call( scope ); };		else
		{			window[ eventName ] = function()
			{ 
				if( oldEvent ) oldEvent();				func.call( scope );			}
		}
		
	},

	getWinSize: function()
	{
		var winH, winW;
		if (parseInt(navigator.appVersion)>3) {
			if ( document.body.offsetWidth ){ // Gecko / WebKit
				winW = document.body.offsetWidth;
				winH = document.body.offsetHeight;
			} else if ( document.body.offsetWidth ){ // MS
				winW = document.body.offsetWidth;
				winH = document.body.offsetHeight;
			}
		}
		return { height: winH, width: winW };
	},
	
	onLoadDiv: function()
	{
		document.getElementById( this.div ).style.width = "100%";
		document.getElementById( this.div ).style.height = "100%";
		this.onResizeDiv();
	},
	
	onResizeDiv: function()
	{
		var winSize = this.getWinSize();
		var w = winSize.width < this.minW? this.minW+"px" : "100%";
		var h = winSize.height < this.minH? this.minH+"px" : "100%";
		/*
		 for IE on PC, turn off the disabled scrollbar 
		 on the right when there's no content to scroll
		*/
		if( document.all ) document.body.scroll = ( w!="100%" || h!="100%" )? "auto" : "no";
		document.getElementById( this.div ).style.width = w;
		document.getElementById( this.div ).style.height = h;
	}
}