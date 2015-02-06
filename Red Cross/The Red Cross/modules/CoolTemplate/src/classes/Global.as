/*
Global.as
CoolTemplate

Created by Alexander Ruiz Ponce on 2/11/09.
Copyright 2009 goTo! Multimedia. All rights reserved.
*/
package classes {

	import flash.utils.getDefinitionByName;
	import flash.net.SharedObject;
	import flash.events.EventDispatcher;
	import flash.text.StyleSheet;
	import fl.motion.easing.*;
	import gT.utils.XMLUtils;
	import gT.utils.ObjectUtils;
	import gT.utils.ColorUtils;
	
	import classes.CustomEvent;
	
	/**
	 @changelog 09.12.05, backgroundNoise and backgroundGradinet settings add
	 */
	public class Global {
		
		public static const VERSION:String = "1.0.1";		
		public static const PROTECTED:Boolean = false;										// Security policy against ilegal use of the template (do not change this)
		public static const SECURITY_DOMAINS:String = "envato.com|activeden.net|gotomultimedia.com";			// To protect your file of ilegal use, set PROTECTED to true and add your domains split by "|"  
		public static const MIN_STAGE_HEIGHT:uint = 720;									// Defines the min stage size (Please not edit)
		public static const CONTENT_WIDTH:uint = 700;										// Defines the content width (Do not change it)
		public static const CONTENT_HEIGHT:uint = 480;										// Defines the content height (Do not change it)
		public static const OFFSET_Y_CIRCULAR_GALLERY:uint = 90;							// Define the offset 'y' position of circular gallery when the stage is too small
		public static const MAX_OFFSET_Y_CIRCULAR_GALLERY:uint = 30;						// Define the max offset 'y' position of circular gallery when the stage is too small
		public static const FORM_FILE:String = "data/form.php";								// Php script to send emails
		
		
		// JukeBox vars
		public static var playListEnabled:Boolean;											// Play list open or no
		public static var shuffle:Boolean;													// Shuffle state
		
		// General
		public static var so:SharedObject = SharedObject.getLocal("gTCoolTemplate");		// For the general user preferences
		public static var data:XML;															// XML content data
		public static var expanderClicked:Boolean;
		public static var currentSection:uint;												// Current Section
		public static var currentSubSection:Number;											// Current Sub Section
		public static var css:StyleSheet;
		
		// Easy Classes Fixer
		Back, Bounce, Circular, Cubic, Elastic, Exponential, Linear, Quadratic, Quartic, Quintic, Sine;
			
		// Private
		private static var __dispatcher:EventDispatcher = new EventDispatcher;
		
		public static var settings:Object = {												// A object that contains all configuration of the site
			time:									1,
			easeOut:								Exponential.easeOut,
			easeIn:									Exponential.easeIn,
			easeInOut:								Exponential.easeInOut,
			easeBack:								Back,
			logo:									"images/logo.png",
			backgroundBaseColor:					0x404853,
			backgroundImage:						null,
			backgroundNoise:						true,
			backgroundGradient:						true,
			globalColor1:							0x00c6ff,
			globalColor2:							0xfffffff,
			globalColor3:							0x000000,
			jukeBox:								true,
			jukeBoxTicketDelay:						4,
			jukeBoxDefaultVolume:					.7,
			jukeBoxAutoPlay:						true,
			jukeBoxShowSpectrum:					true,
			jukeBoxSpectrumXBlurSize:				50,
			jukeBoxSpectrumBlur:					false,
			jukeBoxSpectrumBlurQuality:				2,
			jukeBoxSpectrumAlpha:					.95,
			jukeBoxSpectrumColor1:					0x0066FF,
			jukeBoxSpectrumColor2:					0x00FFFF,
			jukeBoxSpectrumColor3:					0x0066FF,
			jukeBoxSpectrumGradientMode:			"linear",
			galleryInertia:							.73,
			fullViewBackgroundColor:				0x00,
			contentBackgroundColor:					0x00,
			contentThumbnailRandomRotation:			false,				
			imagesPath:								"",
			videoBufferTime:						10,
			months:									"Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec",
			showCircularGallery:					true
		};
		
		//////////////////////////////////////////////////////////
		//
		// Constrctor
		//
		//////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////
		//
		// Static Methods
		//
		//////////////////////////////////////////////////////////
		
		public static function render ():void 
		{
			__dispatcher.dispatchEvent(new CustomEvent(CustomEvent.GLOBAL_RENDER));
		}
		
		public static function addEventListener (type:String, listener:Function, useCapture:Boolean, priority:int, useWeakReference:Boolean):void 
		{
			__dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener (type:String, listener:Function):void 
		{
			__dispatcher.removeEventListener(type, listener);
		}
		
		public static function dispatchEvent (event:*):void 
		{
			__dispatcher.dispatchEvent(event);
		}
		
		public static function setData (value:XML):void
		{
			data = value;
			var settingsAttsList = data.settings.@*;			
			for each (var property in settingsAttsList) 
			{
				var prop:String = String(property.name());
				
				// Validates whether or not the property is a Ease Function
				
				if (prop) {
					if(prop.toLowerCase().indexOf("ease") != -1){
						settings[String(property.name())] = getEase(property.toXMLString());
					}else{
						settings[String(property.name())] = XMLUtils.validateValue(property.toXMLString());
					}
				}
			};
			
			// Style Sheet
			var sheet = new StyleSheet();
			sheet.setStyle("body", {color:ColorUtils.numberToHexString(settings.globalColor2)});
			sheet.setStyle(".strong", {color:ColorUtils.numberToHexString(settings.globalColor1)});
			sheet.setStyle(".title", {color:ColorUtils.numberToHexString(settings.globalColor1), fontWeight:"bold"});
			sheet.setStyle(".em", {color:ColorUtils.numberToHexString(settings.globalColor1), fontWeight:"bold"});
			sheet.setStyle("a", {color:ColorUtils.numberToHexString(settings.globalColor1), textDecoration:"underline"});
			
			css = sheet;
		}
		
		private static function getEase (value:String):Function
		{
			if (value) {
				
				var aux = value.split(".");
				var e = aux[1];
				
				if (!e) {
					e = "easeOut";
				}
				
				var EasyClass:Class = getDefinitionByName("fl.motion.easing."+aux[0]) as Class;

	           return EasyClass[e];
            }
			return null;
		}
		
		public static function get defaultPlayList ():Array
		{
			var result:Array;
			
			for each (var track in data.jukeBox.tracks.track) 
			{
				if (!result) result = [];
				var obj:Object = {};
				obj.name = track.name.text().toString();
				obj.url = track.song.text().toString();
				result.push(obj);
			}
				
			return result;
		}
		
		public static function get mainMenu ():Array 
		{
			var result:Array = [];
			
			for each (var item in data.sections.section.menuName) {
				result.push(item.text().toString());
			}
				
			return result;
		}
		
		public static function get circularGalleryMainItems ():Array 
		{
			var result:Array = [];
			
			for each (var section in data.sections.section) {
				var obj:Object = {};
				obj.src = settings.imagesPath + section.thumbnail.text().toString();
				
				if (section.hasOwnProperty("cover")) {
					obj.contentType = "gallery";
				} else {
					
					if (section.template.@type.toString() == "externalLink") 
					{
						obj.contentType = "externalLink";
						obj.link = {href:section.template.link.@href.toString(), target:XMLUtils.validateString(section.template.link.@target, "_self")};
					} else {
						obj.contentType = "content";
					}
					
				}
				
				obj.cover = {label:section.menuName.text().toString(), type:"menuCover"}
				
				result.push(obj);
			};
				
			return result;
		}
		
		public static function get circularGallerySubItems ():Array 
		{
			var result:Array = [];
			var sourceCont:uint;
			
			for each (var cover in data.sections.section[currentSection].cover) {
				var obj:Object = {};
				obj.src = settings.imagesPath + cover.thumbnail.text().toString();
				
				switch (cover.@type.toString()) {
					case "music":
						if (cover.hasOwnProperty("tracks"))
						{
							obj.contentType = "music";
							obj.cover = {type:"discCover"}
							obj.playList = [];
							
							for each (var track in cover.tracks.track) 
							{
								var objTrack:Object = {};
								objTrack.name = track.name.text().toString();
								objTrack.url = track.song.text().toString();
								obj.playList.push(objTrack);
							}
						} else {
							obj.contentType = "content";
							obj.cover = {type:"CDCover"}
						}
						break;
					
					case "image":
						obj.contentType = "image";
						obj.cover = {type:"cover"}
						obj.lgSource = settings.imagesPath + cover.large.text().toString();
						obj.sourceIndex = sourceCont;
						sourceCont++;
						break;
						
					case "video":
						obj.contentType = "video";
						obj.cover = {type:"cover"}
						obj.lgSource = settings.imagesPath + cover.large.text().toString();
						obj.video = cover.video.text().toString();
						obj.sourceIndex = sourceCont;
						sourceCont++;
						break;
						
					case "externalLink":
						obj.contentType = "externalLink";
						obj.cover = {type:"cover"}
						obj.link = {href:cover.link.@href.toString(), target:XMLUtils.validateString(cover.link.@target, "_self")};
						break;
				}
				
				result.push(obj);
			};
			
			return result;
		}
		
		public static function get templateInfo ():Object 
		{
			var path;
			var template;
			var result:Object = {};
			
			if (currentSubSection >= 0) {
				path = data.sections.section[currentSection].cover[currentSubSection];
				template = path.template;
			} else {
				path = data.sections.section[currentSection];
				template = path.template;
			}
			
			result.type = template.@type.toXMLString();
			result.data = {};
			
			switch (result.type) {
				case "text":	
					result.data.title = template.title.text().toString();
					result.data.textBlocks = [];
					
					for each (var textBlock in template.textBlock)
					{
						var obj:Object = {};
						obj.title = XMLUtils.validateString(textBlock.title, null);
						obj.subtitle = XMLUtils.validateString(textBlock.subTitle, null);
						obj.content = textBlock.content.text().toString();
						
						if (XMLUtils.contains(textBlock.thumbnail)) {
							obj.thumbnail = settings.imagesPath + XMLUtils.validateString(textBlock.thumbnail, null);
						} else {
							obj.thumbnail = null;
						}
						
						if (XMLUtils.contains(textBlock.moreLink)) {
							obj.moreLink = {label:textBlock.moreLink.text().toString().toUpperCase(), href:textBlock.moreLink.@href, target:XMLUtils.validateString(textBlock.moreLink.@target, "_self")};
						} else {
							obj.moreLink = null;
						}
						
						result.data.textBlocks.push(obj);
					}
					break;
				
				case "news":	
					result.data.title = template.title.text().toString();
					result.data.months = [];
					result.data.date = [];
					result.data.news = [];
					
					var months:Array = settings.months.split(", ");
					var sortedList = XMLUtils.sortListByAttribute(template.entry, "date", Array.CASEINSENSITIVE | Array.DESCENDING);
					
					var entryMonth:String ="";
					var deep:uint = 5;
					
					for each (var entry in sortedList)
					{
						var entryObj:Object = {};
						var cont:uint = 0;
						
						
						entryObj.date = entry.@date.toString();
						entryObj.month = int(entryObj.date.split("/")[1]);
						entryObj.year = int(entryObj.date.split("/")[0]);
						entryObj.textBlocks = [];
						
						if(entryMonth != entryObj.date.substr(0, 5) && (deep > 0)){
							entryMonth = entryObj.date.substr(0, 5);
							result.data.months.push(months[entryObj.month-1]);
							result.data.date.push({month:entryObj.month, year:entryObj.year});
							deep--;
						}
						
						for each (var textBlock in entry.textBlock)
						{
							var obj:Object = {};
							
							if (cont == 0) {
								obj.title = entryObj.date;
								cont++;
							} else {
								obj.title = null;
							}
							
							obj.subtitle = XMLUtils.validateString(textBlock.title, null);
							obj.content = textBlock.content.text().toString();
							
							if (XMLUtils.contains(textBlock.thumbnail)) {
								obj.thumbnail = settings.imagesPath + XMLUtils.validateString(textBlock.thumbnail, null);
							} else {
								obj.thumbnail = null;
							}
							
							if (XMLUtils.contains(textBlock.moreLink)) {
								obj.moreLink = {label:textBlock.moreLink.text().toString().toUpperCase(), href:textBlock.moreLink.@href, target:XMLUtils.validateString(textBlock.moreLink.@target, "_self") };
							} else {
								obj.moreLink = null;
							}
							
							entryObj.textBlocks.push(obj);
						}
						
						
						result.data.news.push(entryObj);
					};
					
					break;
				
				case "contact":
					result.data.title = template.title.text().toString();
					result.data.address = template.address.text().toString();
					result.data.socialText = template.socialText.text().toString();					
					result.data.social = [];
					
					for each (var social in template.social) {
						var obj = {};
						obj.url = XMLUtils.validateString(social.@url.toXMLString(), null);
						obj.icon = settings.imagesPath + XMLUtils.validateString(social.@icon.toXMLString(), null);
						result.data.social.push(obj);
					};
					
					result.data.formInfo = {
						name:getString("NAME_LABEL_CONTACT").toUpperCase(),
						email:getString("EMAIL_LABEL_CONTACT").toUpperCase(),
						phone:getString("PHONE_LABEL_CONTACT").toUpperCase(),
						message:getString("MESSAGE_LABEL_CONTACT").toUpperCase(),
						send:getString("SEND_BUTTON_CONTACT").toUpperCase(),
						invalidEmail:getString("INVALID_EMAIL_ERROR_CONTACT").toUpperCase(),
						sending:getString("SEND_MESSAGE_CONTACT").toUpperCase(),
						requiredMessage:getString("REQUIRED_FIELD_ERROR_CONTACT").toUpperCase(),
						errorMessage:getString("ERROR_MESSAGE_CONTACT").toUpperCase(),
						succesMessage:getString("SUCCESS_MESSAGE_CONTACT").toUpperCase(),
						infoForm:template.formMessage.text().toString()
					};
					break;
				
				case "music":	
					result.data.title = template.title.text().toString();
					result.data.cover = settings.imagesPath + path.thumbnail.text().toString();
					result.data.textBlocks = [];
					result.data.playList = [];
					
					for each (var textBlock in template.textBlock)
					{
						var obj:Object = {};
						obj.title = XMLUtils.validateString(textBlock.title, null);
						obj.subtitle = XMLUtils.validateString(textBlock.subTitle, null);
						obj.content = textBlock.content.text().toString();
						obj.thumbnail = null;
						
						if (XMLUtils.contains(textBlock.moreLink)) {
							obj.moreLink = {label:textBlock.moreLink.text().toString().toUpperCase(), href:textBlock.moreLink.@href, target:XMLUtils.validateString(textBlock.moreLink.@target, "_self")};
						} else {
							obj.moreLink = null;
						}
						
						result.data.textBlocks.push(obj);
					};
					
					for each (var track in template.tracks.track) 
					{
						var obj:Object = {};
						obj.name = track.name.text().toString();
						obj.url = track.song.text().toString();
						result.data.playList.push(obj);
					}
					break;
				
				case "custom":
					result.data.title = template.title.text().toString();
					result.data.path = "";
					result.data.src = template.src.text().toString();
					result.data.resizable = XMLUtils.validateValue(template.src.@resizable);
					break;
					
				case "plugin":
					result.data.title = template.title.text().toString();
					result.data.path = template.path.text().toString();
					result.data.src = result.data.path + template.src.text().toString();
					result.data.resizable = XMLUtils.validateValue(template.src.@resizable);
					break;
					
				case "externalLink":
					result.data.link = template.link.text();
					result.data.target = XMLUtils.validateString(template.target, "_self");
					break;
				
			}
			
			return result;
		}
		
		public static function getString(key:String):String
		{
			return data.strings.key.(@id == key);
		}
		
		public static function get fullViewContent ():Array
		{
			var result:Array = [];
			
			for each (var cover in data.sections.section[currentSection].cover.(@type == "image" || @type == "video"))
			{
				var obj:Object = {};
				obj.url = settings.imagesPath + cover.large.text().toString();
				if (XMLUtils.contains(cover.video)) {
					obj.video = cover.video.text().toString();
				} else {
					obj.video = null;
				}
				
				if (XMLUtils.contains(cover.description)) {
					obj.description = cover.description.text();
				} else {
					obj.description = null;
				}
				result.push(obj);
			}
			
			return result;
		}
	}
}