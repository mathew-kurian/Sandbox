/**
 * Main
 * Layout implementation
 *
 * @version		1.0
 */
package _project.classes {
	use namespace AS3;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	//
	import _project.classes.Auxiliaries;
	import _project.classes.ContactForm;
	import _project.classes.Content;
	import _project.classes.Datasource;
	import _project.classes.GalleryEvent;
	import _project.classes.HGallery;
	import _project.classes.HInfoGallery;
	import _project.classes.MenuSystem;
	import _project.classes.TFade;
	import _project.classes.ThumbSource;
	import _project.classes.TMask;
	import _project.classes.SwfLoader;
	import _project.classes.TxtField;
	import _project.classes.VInfoGallery;
	import _project.classes.XPlayer;
	import _project.classes.YouTubeDecoder;
	//
	public class Main extends Sprite {
		//constants...
		private const __KACTIONS:Object = { content: "content", gallery: "gallery", link: "link", loadswf: "loadswf", minigallery: "minigallery", news: "news", team: "team" };
		private const __KALIGN:Object = { spectrum: "", swf: "", video: "" };
		private const __KBORDER:Object = { spectrum: 110, swf: 0, video: 110 };
		private const __KCONTACTFORM:Object = { transitions: { intro: 1, outro: 1 } };
		private const __KCONTENT:Object = { title: { padding: { bottom: 0, left: 0, right: 10, top: 0 } }, txtfield: { padding: { bottom: 100, left: 10, right: 0, top: 100 }, transitions: { intro: 1, outro: 2 } } };
		private const __KEYWORD:Object = { on: "on", same: "same" };
		private const __KGALLERY:Object = { margin: { left: 70, right: 240 }, padding: { bottom: 12, left: 5, right: 5, top: 20 } };
		private const __KLOADSWF:Object = { api: { onResize: "onResize", onUnload: "onRemove" }, transitions: { intro: 1, outro: 1 } };
		private const __KLOGOS:Object = { videos: { thumb: undefined, url: "videos.png" }, 
										  youtube: { thumb: undefined, url: "youtube.png" },
										  youtubehq: { thumb: undefined, url: "youtubehq.png" } };
		private const __KMARGIN:Object = { audio: { bottom: 0, left: 0, right: 0, top: 0 }, 
										   spectrum: { bottom: 0, left: 0, right: 0, top: 0 }, 
										   swf: { bottom: 0, left: 0, right: 0, top: 0 }, 
										   video: { bottom: 40, left: 40, right: 40, top: 40 } };
		private const __KMEDIA:Object = { transitions: { intro: 1, outro: 1 } };
		private const __KMEDIATYPE:Array = [ "AUDIO MP3", "VIDEO" ];
		private const __KMENU:Object = { height: undefined, padding: { bottom: 70, left: 10, right: 70, top: 20 } };
		private const __KMENUDEPTH:int = 10;
		private const __KNEWS:Object = { width: 650, showthumb: false, padding: { gallery: { bottom: 0, left: 150, right: 25, top: 0 }, item: { bottom: 150, left: 20, right: 150, top: 150 } }, transitions: { intro: 1, outro: 1 } };
		private const __KMINAUTOPLAY:Number = 6;
		private const __KMINIGALLERY:Object = { height: 350, width: 800, filters: [ new GlowFilter(0xFFFFFF, 0.07, 32, 32, 1, 3) ], showthumb: true, padding: { gallery: { bottom: 40, left: 10, right: 10, top: 10 }, item: { bottom: 10, left: 10, right: 10, top: 10 } }, transitions: { image: { intro: 2, outro: 1 }, item: { intro: 1, outro: 1 } } };
		private const __KNOTES:Object = { autoshow: false, 
										  buy: { begin: '<br />', itemid: 'ITEM ID:', middle1: ' <span class="itemid">', middle2: '</span><br />', itemprice: 'ITEM PRICE:', middle3: ' <span class="itemprice">', end: '</span>' }, 
										  paypal: { begin: '<br /><a href="', middle: '"><img src="', end: '" /></a><br />' },
										  height: 190, 
										  padding: { bottom: 40, left: 8, right: 20, top: 5 }, title: { begin: "<body><span class='title'>", end: "</span>" }, 
										  body: { begin: "<br /><br />", end: "</body>" }, 
										  transitions: { intro: 1, outro: 1 },
										  width: 350 };
		private const __KOFFSET:Object = { menusystem: 2, notes: 0, screen: 0 };
		private const __KPADDING:Object = { ambientcontrol: { right: 150, top: 5 }, 
											autorun: { bottom: 29, left: 15 }, 
											footer: { right: 320, top: 4 }, 
											notes: { bottom: 29, left: 55 }, 
											notesbtn: { bottom: 29, left: 40 } };
		private const __KPAYPAL:Object = { add: 1, cmd: '_cart', business: 'yourpaypaladdress@somedomain.com', 
										  item_id: undefined, item_number: undefined, amount: undefined, 
										  page_style: 'Primary', no_shipping: '2', undefined_quantity: '1', 
										  no_note: '1', currency_code: 'USD', lc: 'US', bn: 'PP-ShopCartBF',
										  target_winName: 'paypal', shopping_url: ('www.yourshoppingcartsite.com'),
										  url: 'https://www.paypal.com/cgi-bin/webscr?' };
		private const __KPLAYERCONTROL_MARGIN:Number = 10;
		private const __KSTAGE:Object = { align: StageAlign.TOP_LEFT, minheight: 650, minwidth: 1100, scalemode: StageScaleMode.NO_SCALE };
		private const __KTEAM:Object = { height: 350, width: 800, filters: [ new GlowFilter(0xFFFFFF, 0.07, 32, 32, 1, 3) ], showthumb: true, padding: { gallery: { bottom: 40, left: 10, right: 10, top: 10 }, item: { bottom: 10, left: 10, right: 10, top: 10 } }, transitions: { image: { intro: 2, outro: 1 }, item: { intro: 1, outro: 1 } } };
		private const __KTHUMBS:Object = { audio: { thumb: undefined, url: "thumbaudio.png" }, 
										   minigallery: { thumb: undefined, url: "thumbminigallery.png" }, 
										   team: { thumb: undefined, url: "thumbteam.png" }, 
										   video: { thumb: undefined, url: "thumbvideo.png" }, 
										   youtube: { thumb: undefined, url: "thumbyoutube.png" } };
		private const __KUPDATES:Object = { ambientautostart: true, ambientvolume: 30, audiobuffer: 1, autoplaytimer: 15, 
											bkg: { filters: undefined, alphaout: 0.75, aspectratio: undefined, deblocking: false, smoothing: false, slowmotion: { active: true, pause: 800, play: 200 }, url: "bkg.flv" }, 
											contactform: undefined, footer: "", paypal: "paypal.swf", linkswindow: "_blank",
											gallery: { thumbsource: { height: 100, width: 150 } }, 
											logo: { url: undefined, showoverexternalswf: false },
											minigallery: { mask: true, thumbsource: { height: 120, width: 200 } }, 
											news: { thumbsource: { height: 100, width: 170 } }, 
											team: { mask: true, thumbsource: { height: 168, width: 120 } }, 
											videobuffer: 1, volume: 80 };
		private const __KXML_URL:String = "data.xml";
		//
		//private vars...
		private var __autorunbtn:MovieClip;
		private var __baloon:MovieClip;
		private var __contactbtn:MovieClip;
		private var __contactform:ContactForm;
		private var __content:Content;
		private var __data:Array;
		private var __datasource:Datasource;
		private var __footer:MovieClip;
		private var __gallery:HGallery;
		private var __loadswf:SwfLoader;
		private var __logo:SwfLoader;
		private var __menusystem:MenuSystem;
		private var __menutimer:Timer;
		private var __minigallery:HInfoGallery;
		private var __news:VInfoGallery;
		private var __notes:TxtField;
		private var __notesbtn:MovieClip;
		private var __initprogress:MovieClip;
		private var __resources:ThumbSource;
		private var __screenbtn:MovieClip;
		private var __status:Object;
		private var __team:HInfoGallery;
		private var __transitions:Sprite;
		private var __videobkg:VideoBkg;
		private var __xplayer:XPlayer;
		//
		public function Main() {
			var _timer:Timer = new Timer(10);
			_timer.addEventListener(TimerEvent.TIMER, this.__onTimer);
			_timer.start();
		};
		//
		private function __addlistener(target:*, event:String, listener:Function):void {
			try {
				target.removeEventListener(event, listener);
			}
			catch (_error:Error) {
				//...
			};
			target.addEventListener(event, listener);
		};
		private function __hidegallery():void {
			try {
				this.__autorunbtn.setHide();
			}
			catch (_error:Error) {
				//...
			};
			this.__gallery.reset();
			this.__xplayer.reset();
			try {
				this.__notes.removeEventListener(Event.CLOSE, this.__onNotesClose);
			}
			catch (_error:Error) {
				//...
			};
			this.__notes.hide();
			this.__notesbtn.setVisible(false);
		};
		private function __loadmedia(objMedia:Object):void {
			this.__status.mediaend = false;
			this.__gallery.thumbsuspend();
			var _hq:Boolean = false;
			try {
				_hq = objMedia.attributes.hq;
			}
			catch (_error:Error) {
				//...
			};
			this.__xplayer.load(objMedia.url, objMedia.info, _hq);
		};
		private function __loadnotes(objMedia:Object):void {
			if (!objMedia) return;
			var _title:String = objMedia.info;
			var _buy:String;
			try {
				_buy = objMedia.attributes.itemid;
			}
			catch (_error:Error) {
				//...
			};
			if (!(_buy is String)) _buy = "";
			if (_buy != "") {
				var _price:String;
				try {
					_price = objMedia.attributes.itemprice;
				}
				catch (_error:Error) {
					//...
				};
				if (!(_price is String)) _price = "";
				if (_price == "") _buy = ""
				else if (isNaN(parseFloat(_price))) _buy = ""
				else {
					var _paypalurl:String = this.__KPAYPAL.url;
					var _paypal:Object = { };
					for (var i in this.__KPAYPAL) _paypal[i] = this.__KPAYPAL[i];
					_paypal.item_name = _title;
					_paypal.item_number = _buy;
					_paypal.amount = _price;
					for (var j in _paypal) _paypalurl  += j + "=" + _paypal[j] + "&";
					_buy = this.__KNOTES.buy.begin + this.__KNOTES.buy.itemid + this.__KNOTES.buy.middle1 + _buy + 
							this.__KNOTES.buy.middle2 + this.__KNOTES.buy.itemprice + this.__KNOTES.buy.middle3 + _price + this.__KPAYPAL.currency_code + this.__KNOTES.buy.end + 
							this.__KNOTES.paypal.begin + _paypalurl + this.__KNOTES.paypal.middle + this.__KUPDATES.paypal + this.__KNOTES.paypal.end;
				};
			};
			var _notes:String;
			try {
				_notes = objMedia.attributes.notes;
			}
			catch (_error:Error) {
				//...
			};
			if (!(_notes is String)) _notes = "";
			if (_notes != "") _notes = this.__KNOTES.body.begin + _notes;
			_notes += this.__KNOTES.body.end;
			this.__notes.htmlText = this.__KNOTES.title.begin + _title + this.__KNOTES.title.end + _buy + _notes;
		};
		private function __menuSystemTransition():ITransition {
			return (new TFade(0.33, 0.33));
		};
		private function __onAutoRunClick(event:MouseEvent):void {
			this.__status.autorun = !this.__status.autorun;
			try {
				this.__autorunbtn.setAutoRun(this.__status.autorun);
			}
			catch (_error:Error) {
				//...
			};
			if (this.__status.autorun && this.__status.mediaend) this.__onMediaEnd();
		};
		private function __onCloseBtnClick(event:MouseEvent):void {
			if (this.__status.fullscreen) this.stage.displayState = StageDisplayState.FULL_SCREEN;
			try {
				this.__screenbtn.removeEventListener(MouseEvent.CLICK, this.__onScreenBtnClick);
			}
			catch (_error:Error) {
				//...
			};
			this.__screenbtn.addEventListener(MouseEvent.CLICK, this.__onScreenBtnClick);
			this.__screenbtn.buttonMode = true;
			this.__contactform.hide();
			try {
				this.__contactbtn.removeEventListener(MouseEvent.CLICK, this.__onContactBtnClick);
			}
			catch (_error:Error) {
				//...
			};
			this.__contactbtn.addEventListener(MouseEvent.CLICK, this.__onContactBtnClick);
			this.__contactbtn.buttonMode = true;
			if (this.__status.playing != this.__xplayer.playing && !this.__xplayer.playing) this.__xplayer.play();
		};
		private function __onContactBtnClick(event:MouseEvent):void {
			if (this.__contactform.visible) return;
			this.__status.playing = this.__xplayer.playing;
			this.__xplayer.pause();
			this.__contactform.x = 0.5 * (this.stage.stageWidth - this.__contactform.width);
			this.__contactform.y = 0.5 * (this.stage.stageHeight - this.__contactform.height);
			this.__contactform.show();
			this.__contactbtn.buttonMode = false;
			try {
				this.__contactbtn.removeEventListener(MouseEvent.CLICK, this.__onContactBtnClick);
			}
			catch (_error:Error) {
				//...
			};
			var displayState:String = (this.stage.displayState is String) ? this.stage.displayState : StageDisplayState.NORMAL;
			this.__status.fullscreen = (displayState == StageDisplayState.FULL_SCREEN);
			if (this.__status.fullscreen) this.stage.displayState = StageDisplayState.NORMAL;
			try {
				this.__screenbtn.removeEventListener(MouseEvent.CLICK, this.__onScreenBtnClick);
			}
			catch (_error:Error) {
				//...
			};
			this.__screenbtn.buttonMode = false;
		};
		private function __onContactFormInit(event:Event):void {
			this.__contactform.removeEventListener(Event.INIT, this.__onContactFormInit);
			if (this.__contactform.stage is Stage) {
				this.__contactform.x = 0.5 * (this.stage.stageWidth - this.__contactform.width);
				this.__contactform.y = 0.5 * (this.stage.stageHeight - this.__contactform.height);
			};
			this.__contactbtn.buttonMode = true;
			this.__contactbtn.addEventListener(MouseEvent.CLICK, this.__onContactBtnClick);
		};
		private function __onContactFormIOError(event:IOErrorEvent):void {
			//...
		};
		private function __onContentInit(event:Event):void {
			this.__content.removeEventListener(Event.INIT, this.__onContentInit);
			try {
				this.__content.height = this.stage.stageHeight;
				this.__content.width = this.stage.stageWidth;
			}
			catch (_error:Error) {
				//...
			};
			var funcNewsDrawMask = function(target:Sprite, height:Number, width:Number):Boolean {
				if (!(target is Sprite)) return false;
				if (isNaN(height)) return false;
				if (height < 0) return false;
				if (isNaN(width)) return false;
				if (width < 0) return false;
				target.graphics.clear();
				target.graphics.beginFill(0x000000);
				target.graphics.moveTo(0, 0);
				target.graphics.lineTo(width, 0);
				target.graphics.lineTo(width, height);
				target.graphics.lineTo(0, height);
				target.graphics.endFill();
				//
				return true;
			};
			var funcNewsModel = function():MovieClip {
				return MovieClip(new NewsGalleryItem());
			};
			var _newsthumbsource:ThumbSource = new ThumbSource( { height: this.__KUPDATES.news.thumbsource.height, width: this.__KUPDATES.news.thumbsource.width } );
			_newsthumbsource.addEventListener(IOErrorEvent.IO_ERROR, this.__onNewsThumbIOError);
			var _newsthumbsurl:Array = [];
			this.__news = new VInfoGallery(this.__KNEWS.showthumb, funcNewsDrawMask, funcNewsModel, false, new NewsGalleryBkg(), this.__KNEWS.padding.gallery, new TMask(Sprite(this.__transitions.addChild(new Sprite())), new NewsGalleryIntro(), new NewsGalleryOutro()), undefined, this.__baloon, _newsthumbsource, _newsthumbsurl,
										   new NewsItemScrollBar(), this.__KNEWS.padding.item, undefined, new NewsItemBkg(), StyleSheets.style("news"), new TFade(this.__KNEWS.transitions.intro, this.__KNEWS.transitions.outro), undefined);
			//
			this.__news.addEventListener(Event.INIT, this.__onNewsInit);
			this.__news.addEventListener(Event.SELECT, this.__onNewsSelect);
			this.__news.addEventListener(Event.OPEN, this.__onNewsOpen);
		};
		private function __onContentOpen(event:Event):void {
			this.__videobkg.pause();
		};
		private function __onDataComplete(event:Event):void {
			this.__datasource.removeEventListener(Event.COMPLETE, this.__onDataComplete);
			this.__status.initprogress = 0.5;
			this.__onInitProgressResize();
			this.__data = Auxiliaries.xml2nav(this.__datasource, [ "nav" ] );
			if (this.__data.length < 1) return;
			var _string:String;
			var _number:Number;
			_string = this.__datasource.getField( [ "videobkg", "url" ] );
			if (_string is String) this.__KUPDATES.bkg.url = _string;
			_string = this.__datasource.getField( [ "videobkg", "aspectratio" ] );
			if (_string is String) {
				this.__KUPDATES.bkg.aspectratio = (_string.toLowerCase() == this.__KEYWORD.on);
			};
			_string = this.__datasource.getField( [ "videobkg", "slowmotion" ] );
			if (_string is String) {
				this.__KUPDATES.bkg.slowmotion.active = (_string.toLowerCase() == this.__KEYWORD.on);
			};
			if (this.__KUPDATES.bkg.slowmotion.active) {
				_number = this.__datasource.getField( [ "videobkg", "slowmotion", "@pause" ] );
				if (isNaN(_number)) _number = this.__KUPDATES.bkg.slowmotion.pause
				else if (_number < 0) _number = this.__KUPDATES.bkg.slowmotion.pause;
				this.__KUPDATES.bkg.slowmotion.pause = _number;
				_number = this.__datasource.getField( [ "videobkg", "slowmotion", "@play" ] );
				if (isNaN(_number)) _number = this.__KUPDATES.bkg.slowmotion.play
				else if (_number < 0) _number = this.__KUPDATES.bkg.slowmotion.play;
				this.__KUPDATES.bkg.slowmotion.play = _number;
			};
			_string = this.__datasource.getField( [ "AVpresets", "ambientautostart" ] );
			if (_string is String) {
				this.__KUPDATES.ambientautostart = (_string.toLowerCase() == this.__KEYWORD.on);
			};
			_number = this.__datasource.getField( [ "AVpresets", "ambientvolume" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.ambientvolume
			else if (_number < 0) _number = this.__KUPDATES.ambientvolume;
			this.__KUPDATES.ambientvolume = _number;
			_number = this.__datasource.getField( [ "AVpresets", "audiobuffer" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.audiobuffer
			else if (_number < 0) _number = this.__KUPDATES.audiobuffer;
			this.__KUPDATES.audiobuffer = _number;
			_number = this.__datasource.getField( [ "AVpresets", "autoplaytimer" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.autoplaytimer
			else if (_number < this.__KMINAUTOPLAY) _number = this.__KMINAUTOPLAY;
			this.__KUPDATES.autoplaytimer = _number;
			_number = this.__datasource.getField( [ "AVpresets", "videobuffer" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.videobuffer
			else if (_number < this.__KUPDATES.videobuffer) _number = this.__KUPDATES.videobuffer;
			this.__KUPDATES.videobuffer = _number;
			_number = this.__datasource.getField( [ "AVpresets", "volume" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.volume
			else if (_number < 0) _number = this.__KUPDATES.volume;
			this.__KUPDATES.volume = _number;
			_number = this.__datasource.getField( [ "thumbnails", "gallery", "@height" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.gallery.thumbsource.height
			else if (_number < 0) _number = this.__KUPDATES.gallery.thumbsource.height;
			this.__KUPDATES.gallery.thumbsource.height = _number;
			_number = this.__datasource.getField( [ "thumbnails", "gallery", "@width" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.gallery.thumbsource.width
			else if (_number < 0) _number = this.__KUPDATES.gallery.thumbsource.width;
			this.__KUPDATES.gallery.thumbsource.width = _number;
			_number = this.__datasource.getField( [ "thumbnails", "minigallery", "@height" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.minigallery.thumbsource.height
			else if (_number < 0) _number = this.__KUPDATES.minigallery.thumbsource.height;
			this.__KUPDATES.minigallery.thumbsource.height = _number;
			_number = this.__datasource.getField( [ "thumbnails", "minigallery", "@width" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.minigallery.thumbsource.width
			else if (_number < 0) _number = this.__KUPDATES.minigallery.thumbsource.width;
			this.__KUPDATES.minigallery.thumbsource.width = _number;
			_number = this.__datasource.getField( [ "thumbnails", "news", "@height" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.news.thumbsource.height
			else if (_number < 0) _number = this.__KUPDATES.news.thumbsource.height;
			this.__KUPDATES.news.thumbsource.height = _number;
			_number = this.__datasource.getField( [ "thumbnails", "news", "@width" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.news.thumbsource.width
			else if (_number < 0) _number = this.__KUPDATES.news.thumbsource.width;
			this.__KUPDATES.news.thumbsource.width = _number;
			_number = this.__datasource.getField( [ "thumbnails", "team", "@height" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.team.thumbsource.height
			else if (_number < 0) _number = this.__KUPDATES.team.thumbsource.height;
			this.__KUPDATES.team.thumbsource.height = _number;
			_number = this.__datasource.getField( [ "thumbnails", "team", "@width" ] );
			if (isNaN(_number)) _number = this.__KUPDATES.team.thumbsource.width
			else if (_number < 0) _number = this.__KUPDATES.team.thumbsource.width;
			this.__KUPDATES.team.thumbsource.width = _number;
			_string = this.__datasource.getField( [ "styledshape", "@minigallery" ] );
			if (_string is String) {
				this.__KUPDATES.minigallery.mask = (_string.toLowerCase() == this.__KEYWORD.on);
			};
			_string = this.__datasource.getField( [ "styledshape", "@team" ] );
			if (_string is String) {
				this.__KUPDATES.team.mask = (_string.toLowerCase() == this.__KEYWORD.on);
			};
			_string = this.__datasource.getField( [ "linkswindow" ] );
			if (_string is String) {
				this.__KUPDATES.linkswindow = (_string.toLowerCase() == this.__KEYWORD.same) ? "_self" : "_blank";
			};
			_string = this.__datasource.getField( [ "contactform" ] );
			if (_string is String) this.__KUPDATES.contactform = _string;
			_string = this.__datasource.getField( [ "footer" ] );
			if (_string is String) this.__KUPDATES.footer = _string;
			_string = this.__datasource.getField( [ "logo" ] );
			if (_string is String) this.__KUPDATES.logo.url = _string;
			_string = this.__datasource.getField( [ "logo", "@showoverexternalswf" ] );
			if (_string is String) {
				this.__KUPDATES.logo.showoverexternalswf = (_string.toLowerCase() == this.__KEYWORD.on);
			};
			_string = this.__datasource.getField( [ "paypal", "business" ] );
			if (_string is String) this.__KPAYPAL.business = _string;
			_string = this.__datasource.getField( [ "paypal", "currency" ] );
			if (_string is String) this.__KPAYPAL.currency_code = _string;
			_string = this.__datasource.getField( [ "paypal", "location" ] );
			if (_string is String) this.__KPAYPAL.lc = _string;
			_string = this.__datasource.getField( [ "paypal", "shoppingurl" ] );
			if (_string is String) this.__KPAYPAL.shopping_url = _string;
			_string = this.__datasource.getField( [ "paypal", "itemid" ] );
			if (_string is String) this.__KNOTES.buy.itemid = _string;
			_string = this.__datasource.getField( [ "paypal", "itemprice" ] );
			if (_string is String) this.__KNOTES.buy.itemprice = _string;
			_string = this.__datasource.getField( [ "paypal", "pplogo" ] );
			if (_string is String) this.__KUPDATES.paypal = _string;
			_string = this.__datasource.getField( [ "resources", "thumbminigallery" ] );
			if (_string is String) this.__KTHUMBS.minigallery.url = _string;
			_string = this.__datasource.getField( [ "resources", "thumbteam" ] );
			if (_string is String) this.__KTHUMBS.team.url = _string;
			_string = this.__datasource.getField( [ "resources", "thumbaudio" ] );
			if (_string is String) this.__KTHUMBS.audio.url = _string;
			_string = this.__datasource.getField( [ "resources", "thumbvideo" ] );
			if (_string is String) this.__KTHUMBS.video.url = _string;
			_string = this.__datasource.getField( [ "resources", "thumbyoutube" ] );
			if (_string is String) this.__KTHUMBS.youtube.url = _string;
			_string = this.__datasource.getField( [ "resources", "videos" ] );
			if (_string is String) this.__KLOGOS.videos.url = _string;
			_string = this.__datasource.getField( [ "resources", "youtube" ] );
			if (_string is String) this.__KLOGOS.youtube.url = _string;
			_string = this.__datasource.getField( [ "resources", "youtubehq" ] );
			if (_string is String) this.__KLOGOS.youtubehq.url = _string;
			//
			this.__transitions = Sprite(this.addChild(new Sprite()));
			this.__transitions.visible = false;
			this.__resources = new ThumbSource();
			this.__resources.addEventListener(Event.INIT, this.__onResources);
			this.__resources.addEventListener(IOErrorEvent.IO_ERROR, this.__onResources);
			var _resources:Array = [];
			for (var i in this.__KLOGOS) _resources.push(this.__KLOGOS[i].url);
			for (var j in this.__KTHUMBS) _resources.push(this.__KTHUMBS[j].url);
			this.__resources.load(_resources);
		};
		private function __onFooterInit(event:TimerEvent):void {
			if (!(this.__footer.setContent is Function)) return;
			event.target.removeEventListener(TimerEvent.TIMER, this.__onFooterInit);
			event.target.stop();
			try {
				this.__footer.setContent(this.__KUPDATES.footer);
			}
			catch (_error:Error) {
				//...
			};
			this.__logo = new SwfLoader(false, undefined, undefined, new TFade());
			this.__logo.alpha = 0;
			this.__logo.hide();
			this.__logo.addEventListener(Event.INIT, this.__onLogoInit);
			this.__logo.addEventListener(IOErrorEvent.IO_ERROR, this.__onLogoIOError);
			this.__loadswf = new SwfLoader(true, this.__KLOADSWF.api.onResize, this.__KLOADSWF.api.onUnload, new TFade(this.__KLOADSWF.transitions.intro, this.__KLOADSWF.transitions.outro));
			this.__loadswf.addEventListener(Event.INIT, this.__onSwfLoaderInit);
			this.__loadswf.addEventListener(IOErrorEvent.IO_ERROR, this.__onLoadSwfIOError);
			this.__content = new Content(undefined, this.__KCONTENT.title.padding, undefined, new TitleBkg(), StyleSheets.style("title"), new TMask(Sprite(this.__transitions.addChild(new Sprite())), new ContentIntro(), new ContentOutro()), undefined,
										 new ContentScrollBar(), this.__KCONTENT.txtfield.padding, undefined, new ContentBkg(), StyleSheets.style("content"), new TFade(this.__KCONTENT.txtfield.transitions.intro, this.__KCONTENT.txtfield.transitions.outro), undefined);
			this.__content.addEventListener(Event.INIT, this.__onContentInit);
			this.__content.addEventListener(Event.OPEN, this.__onContentOpen);
		};
		private function __onGalleryItemClick(event:GalleryEvent = undefined):void {
			try {
				this.__loadmedia(this.__gallery.selected.target);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__notes.removeEventListener(Event.CLOSE, this.__onNotesClose);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__notes.removeEventListener(Event.OPEN, this.__onNotesOpen);
			}
			catch (_error:Error) {
				//...
			};
			this.__notesbtn.setVisible(false);
			this.__notes.hide();
		};
		private function __onGalleryThumbIOError(event:IOErrorEvent):void {
			//...
		};
		private function __onGalleryUpdated(event:GalleryEvent):void {
			this.__gallery.selected = 0;
		};
		private function __onInitProgressAdded(event:Event):void {
			event.currentTarget.removeEventListener(Event.ADDED, this.__onInitProgressAdded);
			this.__onInitProgressResize();
			this.stage.addEventListener(Event.RESIZE, this.__onInitProgressResize);
			//
			this.__data = [ ];
			this.__datasource = new Datasource(true, true, true);
			this.__datasource.addEventListener(Event.COMPLETE, this.__onDataComplete);
			var _innerXMLs:Array = [];
			for (var i:int = 0; i < this.__KMENUDEPTH; i++) {
				var _gallery:Array = [ "nav", "item" ];
				var _minigallery:Array = [ "nav", "item" ];
				var _news:Array = [ "nav", "item" ];
				var _team:Array = [ "nav", "item" ];
				for (var j:int = 0; j < i; j++) {
					_gallery.push( "item" );
					_minigallery.push( "item" );
					_news.push( "item" );
					_team.push( "item" );
				};
				_gallery.push( "gallery" );
				_minigallery.push( "minigallery" );
				_news.push( "news" );
				_team.push( "team" );
				_innerXMLs.push(_gallery);
				_innerXMLs.push(_minigallery);
				_innerXMLs.push(_news);
				_innerXMLs.push(_team);
			};
			this.__datasource.load(this.__KXML_URL, _innerXMLs);
		};
		private function __onInitProgressResize(event:Event = undefined):void {
			this.__initprogress.height = this.__status.initprogress * this.stage.stageHeight;
			this.__initprogress.x = 0.5 * this.stage.stageWidth;
			this.__initprogress.y = this.stage.stageHeight - this.__initprogress.height;
		};
		private function __onLoadSwfInit(event:Event):void {
			this.__loadswf.resize(this.stage.stageHeight, this.stage.stageWidth);
		};
		private function __onLoadSwfIOError(event:IOErrorEvent):void {
			//...
		};
		private function __onLogoInit(event:Event):void {
			if (this.__status.showlogo) this.__logo.show();
		};
		private function __onLogoIOError(event:IOErrorEvent):void {
			//...
		};
		private function __onMediaEnd(event:XPlayerEvent = undefined):void {
			if (this.__menutimer.running) return;
			if (this.__status.autorun) this.__gallery.selectnext()
			else this.__status.mediaend = true;
		};
		private function __onMediaError(event:XPlayerEvent):void {
			this.__onMediaEnd();
		};
		private function __onMediaLoading(event:XPlayerEvent):void {
			//...
			this.__videobkg.play();
		};
		private function __onMediaReady(event:XPlayerEvent):void {
			this.__gallery.thumbresume();
			try {
				this.__loadnotes(this.__gallery.selected.target);
				this.__addlistener(this.__notesbtn, MouseEvent.ROLL_OVER, this.__onRollOverNotesBtn);
				this.__addlistener(this.__notes, Event.CLOSE, this.__onNotesClose);
				this.__addlistener(this.__notes, Event.OPEN, this.__onNotesOpen);
				if (!this.__KNOTES.autoshow) this.__notesbtn.setVisible(true);
			}
			catch (_error:Error) {
				//...
			};
			//
			var _mediatype:String = this.__xplayer.mediaType;
			if (!(_mediatype is String)) {
				this.__gallery.showBkg();
				this.__videobkg.pause();
			}
			else {
				(_mediatype == this.__KMEDIATYPE[0] && this.__KUPDATES.bkg.slowmotion.active) ? this.__videobkg.slowmotion() : this.__videobkg.pause();
				//
				for (var i in this.__KMEDIATYPE) {
					if (_mediatype == this.__KMEDIATYPE[i]) {
						(this.__xplayer.wallpaper) ? this.__gallery.hideBkg() : this.__gallery.showBkg();
						return;
					};
				};
				this.__gallery.hideBkg();
			};
			this.__onPostpone();
		};
		private function __onMediaResize(event:Event):void {
			var _mediatype:String = this.__xplayer.mediaType;
			if (!(_mediatype is String)) this.__gallery.showBkg()
			else {
				for (var i in this.__KMEDIATYPE) {
					if (_mediatype == this.__KMEDIATYPE[i]) {
						(this.__xplayer.wallpaper) ? this.__gallery.hideBkg() : this.__gallery.showBkg();
						return;
					};
				};
				this.__gallery.hideBkg();
			};
		};
		private function __onMenuSelect(event:Event):void {
			this.__status.mediaend = false;
			this.__status.playing = false;
			if (!this.__xplayer.ambientAutoStart) this.__xplayer.ambientAutoStart = this.__KUPDATES.ambientautostart;
			var _oldselected:Object = this.__status.menuselection;
			var _selected:Object = this.__menusystem.selected;
			//
			var _link:String = _selected.target.attributes.link;
			if (_link) this.__status.menuselection = { action: this.__KACTIONS.link, params: _link }
			else {
				var _loadswf:String = _selected.target.attributes.loadswf;
				if (_loadswf) {
					this.__status.showlogo = this.__KUPDATES.logo.showoverexternalswf;
					(this.__status.showlogo) ? this.__logo.show() : this.__logo.hide();
					//
					this.__content.reset();
					this.__hidegallery();
					this.__minigallery.reset();
					this.__news.reset();
					this.__team.reset();
					this.__videobkg.play();
					this.__status.menuselection = { action: this.__KACTIONS.loadswf, params: { align: _selected.target.attributes.align, ambient: _selected.target.attributes.ambientoff, load: _loadswf } };
				}
				else {
					var _news:Array = _selected.target.attributes.news;
					if (!(_news is Array)) _news = [];
					if (_news.length > 0) {
						this.__status.showlogo = true;
						this.__logo.show();
						//
						this.__content.reset();
						this.__hidegallery();
						this.__loadswf.reset();
						this.__minigallery.reset();
						this.__team.reset();
						this.__videobkg.play();
						this.__status.menuselection = { action: this.__KACTIONS.news, params: _news };
					}
					else {
						var _minigallery:Array = _selected.target.attributes.minigallery;
						if (!(_minigallery is Array)) _minigallery = [];
						if (_minigallery.length > 0) {
							this.__status.showlogo = true;
							this.__logo.show();
							//
							this.__content.reset();
							this.__hidegallery();
							this.__loadswf.reset();
							this.__news.reset();
							this.__team.reset();
							this.__videobkg.play();
							this.__status.menuselection = { action: this.__KACTIONS.minigallery, params: _minigallery };
						}
						else {
							var _team:Array = _selected.target.attributes.team;
							if (!(_team is Array)) _team = [];
							if (_team.length > 0) {
								this.__status.showlogo = true;
								this.__logo.show();
								//
								this.__content.reset();
								this.__hidegallery();
								this.__loadswf.reset();
								this.__minigallery.reset();
								this.__news.reset();
								this.__videobkg.play();
								this.__status.menuselection = { action: this.__KACTIONS.team, params: _team };
							}
							else {
								var _gallery:Array = _selected.target.attributes.gallery;
								if (!(_gallery is Array)) _gallery = [];
								if (_gallery.length > 0) {
									this.__status.showlogo = true;
									this.__logo.show();
									//
									this.__content.reset();
									this.__loadswf.reset();
									this.__minigallery.reset();
									this.__news.reset();
									this.__team.reset();
									this.__videobkg.play();
									this.__status.menuselection = { action: this.__KACTIONS.gallery, params: _gallery };
								}
								else {
									var _text:String = _selected.target.attributes.text;
									if (_text is String) {
										this.__status.showlogo = true;
										this.__logo.show();
										//
										this.__loadswf.reset();
										this.__minigallery.reset();
										this.__news.reset();
										this.__team.reset();
										this.__videobkg.play();
										this.__hidegallery();
										//
										if (_text != "") this.__status.menuselection = { action: this.__KACTIONS.content, params: { title: _selected.target.info, text: _text } }
										else return;
									}
									else return;
								};
							};
						};
					};
				};
			};
			var _delay:Number = 10;
			if (_oldselected) {
				switch (_oldselected.action) {
					case this.__KACTIONS.content:
						_delay = 1000 * this.__content.durationOutro;
						break;
					case this.__KACTIONS.gallery:
						_delay = (this.__status.menuselection.action != _oldselected.action) ? 1000 * Math.max(this.__gallery.durationOutro, this.__xplayer.durationOutro) : 10;
						break;
					case this.__KACTIONS.loadswf:
						_delay = 1000 * this.__loadswf.durationOutro;
						break;
					case this.__KACTIONS.minigallery:
						_delay = 1000 * this.__minigallery.durationOutro;
						break;
					case this.__KACTIONS.news:
						_delay = 1000 * this.__news.durationOutro;
						break;
					case this.__KACTIONS.team:
						_delay = 1000 * this.__team.durationOutro;
						break;
				};
			};
			this.__menutimer.reset();
			this.__menutimer.delay = _delay;
			this.__menutimer.start();
		};
		private function __onMenuSelectAction(event:TimerEvent):void {
			this.__menutimer.reset();
			if (this.__status.menuselection.action == this.__KACTIONS.link) navigateToURL(new URLRequest(this.__status.menuselection.params), this.__KUPDATES.linkswindow)
			else if (this.__status.menuselection.action == this.__KACTIONS.loadswf) {
				this.__loadswf.load(this.__status.menuselection.params.load, this.__status.menuselection.params.align);
				if (this.__status.ambient) {
					if (this.__status.menuselection.ambient) this.__xplayer.ambientAutoStart = false;
				}
				else if (this.__status.menuselection.ambient) this.__xplayer.ambientPause();
			}
			else if (this.__status.menuselection.action == this.__KACTIONS.news) {
				this.__news.load(this.__status.menuselection.params);
				this.__onPostpone();
			}
			else if (this.__status.menuselection.action == this.__KACTIONS.minigallery) {
				this.__minigallery.load(this.__status.menuselection.params);
				this.__onPostpone();
			}
			else if (this.__status.menuselection.action == this.__KACTIONS.team) {
				this.__team.load(this.__status.menuselection.params);
				this.__onPostpone();
			}
			else if (this.__status.menuselection.action == this.__KACTIONS.gallery) {
				this.__addlistener(this.__notes, Event.CLOSE, this.__onNotesClose);
				try {
					this.__autorunbtn.setAutoRun(this.__status.autorun);
				}
				catch (_error:Error) {
					//...
				};
				this.__gallery.thumbresume();
				this.__gallery.load(this.__status.menuselection.params);
			}
			else if (this.__status.menuselection.action == this.__KACTIONS.content) {
				this.__content.load(this.__status.menuselection.params.title, this.__status.menuselection.params.text);
				this.__onPostpone();
			};
			this.__status.menuselection.params = undefined;
		};
		private function __onMenuSystemAdded(event:Event):void {
			event.currentTarget.removeEventListener(Event.ADDED, this.__onMenuSystemAdded);
			//
			this.addEventListener(Event.UNLOAD, this.__onUnload);
			//
			this.__transitions.visible = false;
			this.__menusystem.x = this.__menusystem.y = this.__KOFFSET.menusystem;
			this.__autorunbtn.x = this.__KPADDING.autorun.left;
			this.__footer.y = this.__KPADDING.footer.top;
			this.__screenbtn.y = this.__KOFFSET.screen;
			this.__xplayer.ambientControl.y = this.__KPADDING.ambientcontrol.top;
			this.__gallery.x = this.__KGALLERY.margin.left;
			this.__contactform.resize(this.stage.stageHeight, this.stage.stageWidth);
			this.__content.x = 0.5 * (this.stage.stageWidth - this.__content.width);
			this.__content.height = this.stage.stageWidth;
			this.__loadswf.resize(this.stage.stageHeight, this.stage.stageWidth);
			this.__menusystem.x = this.__menusystem.y = this.__KOFFSET.menusystem;
			this.__contactbtn.x = this.__contactbtn.y = this.__KOFFSET.menusystem;
			this.__notesbtn.x = this.__KPADDING.notesbtn.left;
			this.__notes.x = this.__KPADDING.notes.left;
			this.__logo.load(this.__KUPDATES.logo.url, "TL");
			try {
				this.stage.removeEventListener(Event.RESIZE, this.__onVideoBkgResize);
			}
			catch (_error:Error) {
				//...
			};
			this.__onResize();
			this.stage.addEventListener(Event.RESIZE, this.__onResize);
			this.__screenbtn.addEventListener(MouseEvent.CLICK, this.__onScreenBtnClick);
			this.__menutimer = new Timer(1000);
			this.__menutimer.addEventListener(TimerEvent.TIMER, this.__onMenuSelectAction);
			this.__menusystem.load(this.__data);
		};
		private function __onMiniGalleryInit(event:Event):void {
			this.__minigallery.removeEventListener(Event.INIT, this.__onMiniGalleryInit);
			this.__minigallery.width = this.__KMINIGALLERY.width;
			this.__minigallery.reset();
			var funcTeamDrawMask = function(target:Sprite, height:Number, width:Number):Boolean {
				if (!(target is Sprite)) return false;
				if (isNaN(height)) return false;
				if (height < 0) return false;
				if (isNaN(width)) return false;
				if (width < 0) return false;
				target.graphics.clear();
				target.graphics.beginFill(0x000000);
				target.graphics.moveTo(0, 0);
				target.graphics.lineTo(width, 0);
				target.graphics.lineTo(width, height);
				target.graphics.lineTo(0, height);
				target.graphics.endFill();
				//
				return true;
			};
			var funcTeamModel = function():MovieClip {
				return MovieClip(new TeamGalleryItem());
			};
			var _teamthumbsource:ThumbSource = new ThumbSource( { height: this.__KUPDATES.team.thumbsource.height, width: this.__KUPDATES.team.thumbsource.width } );
			_teamthumbsource.addEventListener(IOErrorEvent.IO_ERROR, this.__onTeamThumbIOError);
			var _teamthumbsurl:Array = [];
			this.__team = new HInfoGallery(this.__KTEAM.showthumb, funcTeamDrawMask, funcTeamModel, false, new TeamGalleryBkg(), this.__KTEAM.padding.gallery, new TMask(Sprite(this.__transitions.addChild(new Sprite())), new TeamGalleryIntro(), new TeamGalleryOutro()), undefined, this.__baloon, _teamthumbsource, _teamthumbsurl,
										   new TeamItemScrollBar(), this.__KTEAM.padding.item, undefined, new TeamItemBkg(), StyleSheets.style("team"), new TFade(this.__KTEAM.transitions.item.intro, this.__KTEAM.transitions.item.outro), undefined, 
										   new TeamItemMask(), this.__KTHUMBS.team.thumb, new TFade(this.__KTEAM.transitions.image.intro, this.__KTEAM.transitions.image.outro), this.__KTEAM.filters);
			//
			this.__team.addEventListener(Event.INIT, this.__onTeamInit);
			this.__team.addEventListener(Event.SELECT, this.__onTeamSelect);
			this.__team.addEventListener(Event.OPEN, this.__onTeamOpen);
		};
		private function __onMiniGalleryOpen(event:Event):void {
			this.__videobkg.pause();
		};
		private function __onMiniGallerySelect(event:Event):void {
			this.__videobkg.play();
		};
		private function __onMiniGalleryThumbIOError(event:IOErrorEvent):void {
			//...
		};
		private function __onNewsInit(event:Event):void {
			this.__news.removeEventListener(Event.INIT, this.__onNewsInit);
			this.__news.height = (this.stage.stageHeight > this.__KSTAGE.minheight) ? this.stage.stageHeight : this.__KSTAGE.minheight;
			this.__news.width = this.__KNEWS.width;
			this.__news.reset();
			var funcMiniGalleryDrawMask = function(target:Sprite, height:Number, width:Number):Boolean {
				if (!(target is Sprite)) return false;
				if (isNaN(height)) return false;
				if (height < 0) return false;
				if (isNaN(width)) return false;
				if (width < 0) return false;
				target.graphics.clear();
				target.graphics.beginFill(0x000000);
				target.graphics.moveTo(0, 0);
				target.graphics.lineTo(width, 0);
				target.graphics.lineTo(width, height);
				target.graphics.lineTo(0, height);
				target.graphics.endFill();
				//
				return true;
			};
			var funcMiniGalleryModel = function():MovieClip {
				return MovieClip(new MiniGalleryItem());
			};
			var _minigallerythumbsource:ThumbSource = new ThumbSource( { height: this.__KUPDATES.minigallery.thumbsource.height, width: this.__KUPDATES.minigallery.thumbsource.width } );
			_minigallerythumbsource.addEventListener(IOErrorEvent.IO_ERROR, this.__onMiniGalleryThumbIOError);
			var _minigallerythumbsurl:Array = [];
			this.__minigallery = new HInfoGallery(this.__KMINIGALLERY.showthumb, funcMiniGalleryDrawMask, funcMiniGalleryModel, false, new MiniGalleryBkg(), this.__KMINIGALLERY.padding.gallery, new TMask(Sprite(this.__transitions.addChild(new Sprite())), new MiniGalleryIntro(), new MiniGalleryOutro()), undefined, this.__baloon, _minigallerythumbsource, _minigallerythumbsurl,
												  new MiniGalleryItemScrollBar(), this.__KMINIGALLERY.padding.item, undefined, new MiniGalleryItemBkg(), StyleSheets.style("minigallery"), new TFade(this.__KMINIGALLERY.transitions.item.intro, this.__KMINIGALLERY.transitions.item.outro), undefined, 
												  (this.__KUPDATES.minigallery.mask) ? new MiniGalleryItemMask() : new MiniGalleryItemMaskRect(), this.__KTHUMBS.minigallery.thumb, new TFade(this.__KMINIGALLERY.transitions.image.intro, this.__KMINIGALLERY.transitions.image.outro), this.__KMINIGALLERY.filters);
			//
			this.__minigallery.addEventListener(Event.INIT, this.__onMiniGalleryInit);
			this.__minigallery.addEventListener(Event.SELECT, this.__onMiniGallerySelect);
			this.__minigallery.addEventListener(Event.OPEN, this.__onMiniGalleryOpen);
		};
		private function __onNewsOpen(event:Event):void {
			this.__videobkg.pause();
		};
		private function __onNewsSelect(event:Event):void {
			this.__videobkg.play();
		};
		private function __onNewsThumbIOError(event:IOErrorEvent):void {
			//...
		};
		private function __onNotesInit(event:Event):void {
			this.__notes.removeEventListener(Event.INIT, this.__onNotesInit);
			this.__notes.resize(this.__KNOTES.height, this.__KNOTES.width);
			var funcGalleryDrawMask = function(target:Sprite, height:Number, width:Number):Boolean {
				if (!(target is Sprite)) return false;
				if (isNaN(height)) return false;
				if (height < 0) return false;
				if (isNaN(width)) return false;
				if (width < 0) return false;
				target.graphics.clear();
				target.graphics.beginFill(0x000000);
				target.graphics.moveTo(0, 0);
				target.graphics.lineTo(width, 0);
				target.graphics.lineTo(width, height);
				target.graphics.lineTo(0, height);
				target.graphics.endFill();
				//
				return true;
			};
			var funcGalleryModel = function():MovieClip {
				return MovieClip(new GalleryItem());
			};
			//
			var _thumbsource:ThumbSource = new ThumbSource( { height: this.__KUPDATES.gallery.thumbsource.height, width: this.__KUPDATES.gallery.thumbsource.width } );
			_thumbsource.addEventListener(IOErrorEvent.IO_ERROR, this.__onGalleryThumbIOError);
			var _thumbsurl:Array = [];
			for (var t in this.__KTHUMBS) _thumbsurl.push( { type: t, thumb: this.__KTHUMBS[t].thumb } );
			this.__gallery = new HGallery(funcGalleryDrawMask, funcGalleryModel, false, new GalleryBkg(), this.__KGALLERY.padding, new TMask(Sprite(this.__transitions.addChild(new Sprite())), new GalleryIntro(), new GalleryOutro()), this.__baloon, _thumbsource, _thumbsurl);
			if (this.stage is Stage) {
				this.__gallery.width = ((this.stage.stageWidth > this.__KSTAGE.minwidth) ? this.stage.stageWidth : this.__KSTAGE.minwidth) - this.__KGALLERY.margin.left - this.__KGALLERY.margin.right;
				this.__gallery.y = ((this.stage.stageHeight > this.__KSTAGE.minheight) ? this.stage.stageHeight : this.__KSTAGE.minheight) - this.__gallery.height;
			};
			this.__gallery.addEventListener(GalleryEvent.ITEM_CLICK, this.__onGalleryItemClick);
			this.__gallery.addEventListener(GalleryEvent.UPDATED, this.__onGalleryUpdated);
			this.__autorunbtn = new BtnAutorun();
			this.__autorunbtn.visible = false;
			this.__autorunbtn.buttonMode = true;
			this.__autorunbtn.addEventListener(MouseEvent.CLICK, this.__onAutoRunClick);
			this.__screenbtn = new BtnScreen();
			this.__contactbtn = new BtnContact();
			var _closeform:MovieClip = new BtnClose();
			_closeform.addEventListener(MouseEvent.CLICK, this.__onCloseBtnClick);
			this.__contactform = new ContactForm(_closeform, false, new TFade(this.__KCONTACTFORM.transitions.intro, this.__KCONTACTFORM.transitions.outro));
			this.__contactform.hide();
			this.__contactform.addEventListener(Event.INIT, this.__onContactFormInit);
			this.__contactform.addEventListener(IOErrorEvent.IO_ERROR, this.__onContactFormIOError);
			//
			this.__contactform.load(this.__KUPDATES.contactform);
			var funcMenuSystemBkg = function():MovieClip {
				return MovieClip(new MenuBkg());
			};
			var funcMenuSystemDrawMask = function(target:Sprite, height:Number, width:Number):Boolean {
				if (!(target is Sprite)) return false;
				if (isNaN(height)) return false;
				if (height < 0) return false;
				if (isNaN(width)) return false;
				if (width < 0) return false;
				target.graphics.clear();
				target.graphics.beginFill(0x000000);
				target.graphics.moveTo(0, 0);
				target.graphics.lineTo(width, 0);
				target.graphics.lineTo(width, height);
				target.graphics.lineTo(0, height);
				target.graphics.endFill();
				//
				return true;
			};
			var funcMenuSystemModel = function():MovieClip {
				return MovieClip(new MenuItem());
			};
			var _models:Array = [ { bkg: funcMenuSystemBkg, drawmask: funcMenuSystemDrawMask, model: funcMenuSystemModel, padding: this.__KMENU.padding } ];
			this.__menusystem = new MenuSystem(new Sprite(), new MenuStart(), _models, false, "TL", this.__KMENU.height, true, true, this.__menuSystemTransition);
			this.__menusystem.addEventListener(Event.SELECT, this.__onMenuSelect);
			//
			this.__logo = SwfLoader(this.addChild(this.__logo));
			this.__xplayer = XPlayer(this.addChild(this.__xplayer));
			this.__loadswf = SwfLoader(this.addChild(this.__loadswf));
			this.__content = Content(this.addChild(this.__content));
			this.__news = VInfoGallery(this.addChild(this.__news));
			this.__minigallery = HInfoGallery(this.addChild(this.__minigallery));
			this.__team = HInfoGallery(this.addChild(this.__team));
			this.__footer = MovieClip(this.addChild(this.__footer));
			this.__gallery = HGallery(this.addChild(this.__gallery));
			this.__notesbtn = MovieClip(this.addChild(this.__notesbtn));
			this.__notesbtn.visible = false;
			this.__notes = TxtField(this.addChild(this.__notes));
			this.__autorunbtn = MovieClip(this.addChild(this.__autorunbtn));
			this.__baloon = MovieClip(this.addChild(this.__baloon));
			this.__screenbtn = MovieClip(this.addChild(this.__screenbtn));
			this.__contactbtn = MovieClip(this.addChild(this.__contactbtn));
			this.__contactform = ContactForm(this.addChild(this.__contactform));
			this.__menusystem.container.addEventListener(Event.ADDED, this.__onMenuSystemAdded);
			this.addChild(this.__menusystem.container);
		};
		private function __onNotesClose(event:Event):void {
			try {
				this.__notesbtn.removeEventListener(MouseEvent.ROLL_OVER, this.__onRollOverNotesBtn);
			}
			catch (_error:Error) {
				//...
			};
			this.__notesbtn.addEventListener(MouseEvent.ROLL_OVER, this.__onRollOverNotesBtn);
			try {
				this.__notesbtn.setVisible(true);
			}
			catch (_error:Error) {
				//...
			};
		};
		private function __onNotesOpen(event:Event):void {
			try {
				this.__notes.removeEventListener(MouseEvent.ROLL_OUT, this.__onRollOutNotes);
			}
			catch (_error:Error) {
				//...
			};
			this.__notes.addEventListener(MouseEvent.ROLL_OUT, this.__onRollOutNotes);
		};
		private function __onPostpone():void {
			if (this.__status.ambient) {
				this.__status.ambient = false;
				try {
					this.__xplayer.ambientPlaylist = this.__datasource.getField( [ "ambient", "item" ] );
				}
				catch (_error:Error) {
					//...
				};
			};
		};
		private function __onResize(event:Event = undefined):void {
			this.__onVideoBkgResize();
			//
			var _height:Number = (this.stage.stageHeight > this.__KSTAGE.minheight) ? this.stage.stageHeight : this.__KSTAGE.minheight;
			var _width:Number = (this.stage.stageWidth > this.__KSTAGE.minwidth) ? this.stage.stageWidth : this.__KSTAGE.minwidth;
			this.__footer.x = _width - this.__footer.width - this.__KPADDING.footer.right
			this.__content.height = _height;
			this.__content.x = 0.5 * (_width - this.__content.width);
			this.__loadswf.resize(_height, _width);
			this.__gallery.width = _width - this.__gallery.x - this.__KGALLERY.margin.right;
			this.__gallery.y = _height - this.__gallery.height;
			this.__xplayer.ambientControl.x = _width - this.__KPADDING.ambientcontrol.right;
			this.__xplayer.resize(_height, _width);
			this.__minigallery.width = _width;
			this.__minigallery.y = 0.5 * (_height - this.__minigallery.height);
			this.__news.height = _height;
			this.__news.x = 0.5 * (_width - this.__news.width);
			this.__team.width = _width;
			this.__team.y = 0.5 * (_height - this.__team.height);
			this.__autorunbtn.y = _height - this.__KPADDING.autorun.bottom;
			this.__notesbtn.y = _height - this.__KPADDING.notesbtn.bottom;
			this.__notes.y = _height - this.__KPADDING.notes.bottom - this.__notes.height;
			this.__screenbtn.x = _width - this.__KOFFSET.screen;
			this.__contactform.resize(_height, _width);
		};
		private function __onResources(event:Event):void {
			var _completedTasks:int = this.__resources.completedTasks;
			if (isNaN(_completedTasks)) _completedTasks = 0;
			var _totalTasks:int = this.__resources.totalTasks;
			if (isNaN(_totalTasks)) _totalTasks = 1;
			this.__status.initprogress = 0.5 * (1 + _completedTasks / _totalTasks);
			this.__onInitProgressResize();
			if (_completedTasks >= _totalTasks) {
				try {
					this.__resources.removeEventListener(Event.INIT, this.__onResources);
				}
				catch (_error:Error) {
					//...
				};
				try {
					this.__resources.removeEventListener(IOErrorEvent.IO_ERROR, this.__onResources);
				}
				catch (_error:Error) {
					//...
				};
				this.__status.initprogress = 0.5 * (1 + _completedTasks / _totalTasks);
				this.__onInitProgressResize();
				for (var i in this.__KTHUMBS) this.__KTHUMBS[i].thumb = this.__resources.thumb(this.__KTHUMBS[i].url);
				for (var j in this.__KLOGOS) this.__KLOGOS[j].thumb = this.__resources.thumb(this.__KLOGOS[j].url);
				//
				this.__videobkg = new VideoBkg(this.__KUPDATES.bkg.url, this.__KUPDATES.bkg.aspectratio, this.__KUPDATES.bkg.deblocking, this.__KUPDATES.bkg.smoothing, this.__KUPDATES.bkg.alphaout, this.__KUPDATES.bkg.filters, this.__KUPDATES.bkg.slowmotion.pause, this.__KUPDATES.bkg.slowmotion.play);
				this.__videobkg.addEventListener(Event.ADDED, this.__onVideoBkgAdded);
				this.__videobkg = VideoBkg(this.addChild(this.__videobkg));
			};
		};
		private function __onRollOutNotes(event:MouseEvent):void {
			try {
				this.__notes.removeEventListener(MouseEvent.ROLL_OUT, this.__onRollOutNotes);
			}
			catch (_error:Error) {
				//...
			};
			this.__notes.hide();
		};
		private function __onRollOverNotesBtn(event:MouseEvent):void {
			try {
				this.__notesbtn.removeEventListener(MouseEvent.ROLL_OVER, this.__onRollOverNotesBtn);
			}
			catch (_error:Error) {
				//...
			};
			this.__notesbtn.setVisible(false);
			this.__notes.show();
		};
		private function __onScreenBtnClick(event:MouseEvent):void {
			var displayState:String = (this.stage.displayState is String) ? this.stage.displayState : StageDisplayState.NORMAL;
			var normalScreen:Boolean = (displayState == StageDisplayState.NORMAL);
			this.stage.displayState = (normalScreen) ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
			this.__screenbtn.setScreen(normalScreen);
		};
		private function __onSwfLoaderInit(event:Event):void {
			this.__videobkg.pause();
			this.stage.align = this.__KSTAGE.align;
			this.stage.scaleMode = this.__KSTAGE.scalemode;
			this.__onPostpone();
		};
		private function __onTeamInit(event:Event):void {
			this.__team.removeEventListener(Event.INIT, this.__onTeamInit);
			this.__team.width = this.__KTEAM.width;
			this.__team.reset();
			var fCursor:Function = function():MovieClip {
				return new Cursor();
			};
			var _offset:Object = { audio: this.__KMARGIN.audio, 
								   spectrum: this.__KMARGIN.spectrum, 
								   swf: this.__KMARGIN.swf, 
								   video: this.__KMARGIN.video };
			var _bkg:Object;
			var _vignetting:Object;
			var _borderfill:uint = 0x88050B15;
			var _border:Object = { spectrum: { fill: _borderfill, offset: 0, thickness: this.__KBORDER.spectrum }, 
								   swf: { fill: _borderfill, offset: 0, thickness: this.__KBORDER.swf },
								   video: { fill: _borderfill, offset: 0, thickness: this.__KBORDER.video } };
			var _spectrumcolors:Object = { band: [], peak: [] };
			var i:int = 0;
			while (this.__datasource.getField( [ "spectrumcolors", "item", i, "@band" ] )) {
				var _band:uint = parseInt(this.__datasource.getField( [ "spectrumcolors", "item", i, "@band" ] ), 16);
				if (!isNaN(_band)) {
					var _peak:uint = parseInt(this.__datasource.getField( [ "spectrumcolors", "item", i, "@peak" ] ), 16);
					if (!isNaN(_peak)) {
						_spectrumcolors.band.push(_band);
						_spectrumcolors.peak.push(_peak);
					};
				};
				i++;
			};
			var _urldecoders:Object = { video: [new YouTubeDecoder(this.__KLOGOS.youtube.thumb, this.__KLOGOS.youtubehq.thumb)] };
			this.__xplayer = new XPlayer(new PlayerControlAssets(), new AmbientControlAssets(), 
										 new TFade(this.__KMEDIA.transitions.intro, this.__KMEDIA.transitions.outro), 
										 new SpectrumCursor(), fCursor, fCursor, undefined, undefined, 
										 this.__KLOGOS.videos.thumb, _offset, this.__KPLAYERCONTROL_MARGIN, _bkg, _vignetting, _border, _spectrumcolors, 
										 this.__KALIGN, _urldecoders );
			this.__xplayer.addEventListener(XPlayerEvent.MEDIA_END, this.__onMediaEnd);
			this.__xplayer.addEventListener(XPlayerEvent.MEDIA_ERROR, this.__onMediaError);
			this.__xplayer.addEventListener(XPlayerEvent.MEDIA_LOADING, this.__onMediaLoading);
			this.__xplayer.addEventListener(XPlayerEvent.MEDIA_READY, this.__onMediaReady);
			this.__xplayer.addEventListener(XPlayerEvent.MEDIA_RESIZE, this.__onMediaResize);
			this.__xplayer.addEventListener(XPlayerEvent.INIT, this.__onXPlayerInit);
		};
		private function __onTeamOpen(event:Event):void {
			this.__videobkg.pause();
		};
		private function __onTeamSelect(event:Event):void {
			this.__videobkg.play();
		};
		private function __onTeamThumbIOError(event:IOErrorEvent):void {
			//...
		};
		private function __onTimer(event:TimerEvent):void {
			if (!(this.stage is Stage)) return;
			event.target.removeEventListener(TimerEvent.TIMER, this.__onTimer);
			event.target.stop();
			this.stage.align = this.__KSTAGE.align;
			this.stage.scaleMode = this.__KSTAGE.scalemode;
			this.__status = { ambient: true, autorun: true, fullscreen: false, initprogress: 0.25, mediaend: false, menuselection: { action: "", params: "" }, playing: false, showlogo: this.__KUPDATES.logo.showoverexternalswf };
			this.__initprogress = MovieClip(this.addChild(new InitProgress()));
			this.__initprogress.addEventListener(Event.ADDED, this.__onInitProgressAdded);
		};
		private function __onUnload(event:Event):void {
			try {
				this.stage.removeEventListener(Event.RESIZE, this.__onResize);
			}
			catch (_error:Error) {
				//...
			};
			try {
				this.__xplayer.destroy();
			}
			catch (_error:Error) {
				//...
			};
		};
		private function __onVideoBkgAdded(event:Event):void {
			event.currentTarget.removeEventListener(Event.ADDED, this.__onVideoBkgAdded);
			try {
				this.stage.removeEventListener(Event.RESIZE, this.__onInitProgressResize);
			}
			catch (_error:Error) {
				//...
			};
			this.__initprogress.parent.removeChild(this.__initprogress);
			this.stage.addEventListener(Event.RESIZE, this.__onVideoBkgResize);
			this.__baloon = new HBaloon();
			this.__baloon.filters = [new DropShadowFilter(1, 45, 0x000000, 0.75, 2, 2, 1, 3)];
			this.__footer = new Footer();
			var _timer:Timer = new Timer(10);
			_timer.addEventListener(TimerEvent.TIMER, this.__onFooterInit);
			_timer.start();
		};
		private function __onVideoBkgResize(event:Event = undefined):void {
			this.__videobkg.resize(this.stage.stageHeight, this.stage.stageWidth);
		};
		private function __onXPlayerInit(event:XPlayerEvent):void {
			this.__xplayer.removeEventListener(XPlayerEvent.INIT, this.__onXPlayerInit);
			this.__xplayer.ambientAutoStart = this.__KUPDATES.ambientautostart;
			this.__xplayer.ambientVolume = this.__KUPDATES.ambientvolume;
			this.__xplayer.audioBuffer = this.__KUPDATES.audiobuffer;
			this.__xplayer.ttl = this.__KUPDATES.autoplaytimer;
			this.__xplayer.videoBuffer = this.__KUPDATES.videobuffer;
			this.__xplayer.volume = this.__KUPDATES.volume;
			this.__xplayer.resize(this.stage.stageHeight, this.stage.stageWidth);
			this.__xplayer.ambientControl.x = this.stage.stageWidth - this.__KPADDING.ambientcontrol.right;
			this.__xplayer.ambientControl.y = this.__KPADDING.ambientcontrol.top;
			this.__notesbtn = new NotesBtn();
			var _notesbkg:MovieClip = new NotesBkg();
			if (_notesbkg is MovieClip) {
				if (!isNaN(_notesbkg.height)) this.__KNOTES.height = _notesbkg.height;
				if (!isNaN(_notesbkg.width)) this.__KNOTES.width = _notesbkg.width;
			};
			this.__notes = new TxtField(new NotesScrollBar(), this.__KNOTES.padding, undefined, _notesbkg, new TFade(this.__KNOTES.transitions.intro, this.__KNOTES.transitions.outro), this.__KNOTES.autoshow);
			this.__notes.multiline = true;
			this.__notes.wordWrap = true;
			this.__notes.styleSheet = StyleSheets.style("notes");
			this.__notes.visible = false;
			this.__notes.addEventListener(Event.INIT, this.__onNotesInit);
		};
	};
};