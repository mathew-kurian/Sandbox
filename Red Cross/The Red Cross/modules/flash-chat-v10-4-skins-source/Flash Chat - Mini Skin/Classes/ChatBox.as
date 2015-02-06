package Classes {
	import fl.events.ScrollEvent;

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;

	import fl.controls.ScrollBar;
	import fl.controls.UIScrollBar;
	import fl.controls.ScrollBarDirection;
	
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import flash.text.TextFormat;
	
	import flash.net.URLRequest;
	import flash.system.System;
	
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	import flash.events.Event;
	import flash.events.ContextMenuEvent;
	import fl.events.ScrollEvent;
	
	import flash.geom.Rectangle;

	import Classes.ChatBoxProcess;

	public class ChatBox extends Sprite {
		
		private var chatTextBg:Number = 0xE6E6E6;
		
		private var scrollMask:Sprite;
		private var scrollClip:MovieClip;
		public var scrollBar:UIScrollBar;
		private var textFields:Array;
		private var smileys:Array;
		private var librarySmileys:Array;
		private var maskWidth:int;
		private var bg:Sprite;

		private var size:int;
		private var lineHeight:int;
		private var blankWidth:int;
		private var textFormat:TextFormat;
		private var textFormatBlanks:TextFormat;
		private var contextMenue:ContextMenu;
		private var xOffset:uint = 3;

		public var completeWidth:int;
		public var completeHeight:int;
		public var maxRows:int = 50;
		
		public function ChatBox(sWidth:int, sHeight:int, size:int, maxRows:int = 50) {
			scrollBar = new UIScrollBar();

			completeWidth = sWidth;
			completeHeight = sHeight;
			maskWidth = completeWidth - scrollBar.width;

			// ScrollBar
			scrollBar.direction = ScrollBarDirection.VERTICAL;
			scrollBar.x = maskWidth;
			scrollBar.height = completeHeight;
			scrollBar.alpha = .6;
			addChild(scrollBar);

			// Background
			bg = new Sprite();
			bg.graphics.beginFill(chatTextBg);
			bg.graphics.drawRect(0, 0, maskWidth, completeHeight);
			bg.width = maskWidth;
			bg.height = completeHeight;
			addChild(bg);
			
			// Mask
			scrollMask = new Sprite();
			scrollMask.graphics.beginFill(chatTextBg);
			scrollMask.graphics.drawRect(0, 0, maskWidth, completeHeight);
			addChild(scrollMask);
			
			// MovieClip to scroll
			scrollClip = new MovieClip();
			scrollClip.mask = scrollMask;
			addChild(scrollClip);
			
			// TextFormat for texts
			textFormat = new TextFormat();
			textFormat.font = "Arial";
			textFormat.size = size;
			

			//textFormat.color = 0xFFFFFF;
			
			// TextFormat for blanks
			textFormatBlanks = new TextFormat();
			textFormatBlanks.font = "Arial";
			textFormatBlanks.size = size;
			textFormatBlanks.color = chatTextBg;
			
			// Discover the width of one blank space with the given font size
			var tf:TextField = new TextField();
			tf.setTextFormat(textFormat);
			tf.selectable = true;
			tf.htmlText = ".";
			for(var tfi:int=20; tfi>-1; tfi--)
				if(tf.getCharIndexAtPoint(tfi, size / 2) > -1) break;
			tf = null;
			blankWidth = tfi;
			
			// Contextmenu
			contextMenue = new ContextMenu();
			contextMenue.hideBuiltInItems();
			//var clipboardLineItem:ContextMenuItem = new ContextMenuItem('Copy line to clipboard');
			//clipboardLineItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, copyLineToClipboard);
			var clipboardAllItem:ContextMenuItem = new ContextMenuItem('Copy chat messages to clipboard');
			clipboardAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, copyAllToClipboard);
			//contextMenue.customItems.push(clipboardLineItem);
			contextMenue.customItems.push(clipboardAllItem);
			
			textFields = new Array();
			smileys = new Array();
			librarySmileys = new Array();
			
			this.maxRows = maxRows;
			this.size = size;
			this.lineHeight = size + 5;
			
			scrollBar.addEventListener(ScrollEvent.SCROLL, scrollEvent);
		}

		public function addText(text:String, cleanup:Boolean = true):void {
			var yOffset:uint = 0;

			if(cleanup && textFields.length >= maxRows)
				removeOldRows();

			var newTIndex:int = textFields.length;

			for(var tin:int=0; tin<newTIndex; tin++) {
				yOffset += textFields[tin].numLines * lineHeight;
			}

			textFields[newTIndex] = new ChatBoxProcess();
			textFields[newTIndex].x = xOffset;
			textFields[newTIndex].y = yOffset;
			textFields[newTIndex].width = maskWidth;
			textFields[newTIndex].realText = text;
			textFields[newTIndex].htmlText = text;
			textFields[newTIndex].setTextFormat(textFormat);
			textFields[newTIndex].contextMenu = contextMenue;
			scrollClip.addChild(textFields[newTIndex]);

			var addedSmileys:Array = new Array();
			var lineText:String = textFields[newTIndex].text;
			var charIndexFound:int;

			for(var n:int=0; n<textFields[newTIndex].numLines; n++) {
				charIndexFound = -1;

				// Use string functions to detect whether a smiley exists in the
				// given row to prevent the next loop to be forced to get every charindex
				// (Performance increases when using setSize function with many SmileRows)
				var smileyFound:Boolean = false;
				for(var cs:uint=0; cs<librarySmileys.length; cs++) {
					if(textFields[newTIndex].realText.toLowerCase().indexOf(librarySmileys[cs][0]) > -1)
						smileyFound = true;
				}
				if(!smileyFound) continue;

				var tfWidth:uint = textFields[newTIndex].width;
				charIndexLoop: for(var i:int=0; i<tfWidth; i++) {
					var charIndex:int = textFields[newTIndex].getCharIndexAtPoint(i, 5 + n*5 + n*size);

					if(charIndex > -1) {
						for(var ls:uint=0; ls<librarySmileys.length; ls++) {
							var codeLength:int = librarySmileys[ls][0].length;

							if(lineText.substr(charIndex, codeLength).toLowerCase() == librarySmileys[ls][0]) {
								// Prevent double smileys
								for(var a:uint=0; a<addedSmileys.length; a++) {
									if(addedSmileys[a] == charIndex+"-"+(charIndex+codeLength)+"-"+lineText.substr(charIndex, charIndex+codeLength))
										continue charIndexLoop;
								}

								// Get the boundaries using the found charIndex
								// They help to detect the correct y coordinate for the smiley positioning
								var boundaries:Rectangle = textFields[newTIndex].getCharBoundaries(charIndex);

								// The TextLineMetrics help to get the char descent (influences y-position)
								var lineMetrics:TextLineMetrics = textFields[newTIndex].getLineMetrics(n);

								var newIndex = smileys.length;
								smileys[newIndex] = new Bitmap();
								smileys[newIndex].bitmapData = librarySmileys[ls][2].bitmapData.clone();
								smileys[newIndex].x = i + xOffset;
								smileys[newIndex].y = yOffset + boundaries.y + boundaries.height - smileys[newIndex].bitmapData.height - lineMetrics.descent;

								scrollClip.addChild(smileys[newIndex]);

								// Assign the index of the smiley array to the SmileRow (necessary for removing)
								textFields[newTIndex].addSmiley(newIndex);

								// Replace smiley code with blanks
								var blanks:String = "";
								var fillBlanks:uint = Math.ceil(smileys[newIndex].bitmapData.width / blankWidth)

								while(fillBlanks > blanks.length - 1)
									blanks += ".";
									
								textFields[newTIndex].replaceText(charIndex, charIndex+codeLength, blanks);

								// Add the smiley to a temporary array
								addedSmileys.push(charIndex+"-"+(charIndex+codeLength)+"-"+librarySmileys[ls][0]);

								// Skip some pixels
								i += smileys[newIndex].bitmapData.width;

								// Make the space filled with blanks invisible (bg == fg)
								textFields[newTIndex].setTextFormat(textFormatBlanks, charIndex, charIndex+blanks.length);

								// Update this variable because of the added blanks
								lineText = textFields[newTIndex].text;

								// Remove stuff that isn't needed anymore
								boundaries = null;
								lineMetrics = null;
								blanks = null;
							}
						}
					}
				}
			}
			
			textFields[newTIndex].height = textFields[newTIndex].numLines * (lineHeight + 2);

			scrollBar.setScrollProperties(scrollClip.height - scrollMask.height, 0, scrollClip.height - scrollMask.height);
			scrollBar.scrollPosition = scrollBar.maxScrollPosition;
		}
		
		private function removeOldRows():void {
			var stayOffset:int = textFields.length - maxRows + 1;
			var yOffset:uint = textFields[0].y;

			for(var tin:int=0; tin<stayOffset; tin++) {
				yOffset += textFields[0].numLines * lineHeight;

				// Remove smileys for this SmileRow
				var assignedSmileys:Array = textFields[0].getAssignedSmileys();
				for(var ras:uint = 0; ras<assignedSmileys.length; ras++) {
					if(smileys[assignedSmileys[ras]] is Bitmap) {
						scrollClip.removeChild(smileys[assignedSmileys[ras]]);
						smileys[assignedSmileys[ras]] = null;
					}
				}

				scrollClip.removeChild(textFields[0]);
				textFields[0] = null;
				textFields.shift();
			}

			// Adjust textFields y
			for(tin=0; tin<textFields.length; tin++) {
				textFields[tin].y -= yOffset;
			}
			// Adjust smileys y
			for(tin=0; tin<smileys.length; tin++) {
				if(smileys[tin] is Bitmap)
					smileys[tin].y -= yOffset;
			}
		}

		// Getter for width & height
		public override function get width():Number {
			return completeWidth;
		}

		public override function get height():Number {
			return completeHeight;
		}
		
		// Setter for width & height
		public override function set width(newWidth:Number):void {
			setSize(newWidth, completeHeight);
		}

		public override function set height(newHeight:Number):void {
			setSize(completeWidth, newHeight);
		}

		public function setSize(newWidth:int, newHeight:int):void {
			scrollBar.scrollPosition = scrollBar.maxScrollPosition;
			scrollClip.y = 0;

			newWidth = Math.round(newWidth);
			newHeight = Math.round(newHeight);
			completeWidth = newWidth;
			completeHeight = scrollBar.height = newHeight;
			
			maskWidth = completeWidth - scrollBar.width;
			
			scrollMask.width = completeWidth;
			scrollMask.height = completeHeight;
			scrollBar.x = maskWidth;

			bg.width = maskWidth;
			bg.height = completeHeight;
			
			// Duplicate the TextField array before removing old items
			var newTextFields:Array = textFields.slice(0);
			
			// Remove all smileys
			for(var rs:int=smileys.length-1; rs>-1; rs--) {
				if(smileys[rs] is Bitmap) {
					scrollClip.removeChild(smileys[rs]);
					smileys[rs] = null;
				}
				smileys.splice(rs, 1);
			}

			// Remove all TextFields
			for(var tin:int=textFields.length-1; tin>-1; tin--) {
				scrollClip.removeChild(textFields[tin]);
				textFields[tin] = null;
				textFields.splice(tin, 1);
			}

			// Add new TextFields
			for(tin=0; tin<newTextFields.length; tin++) {
				addText(newTextFields[tin].realText);
			}
		}

		public function registerBitmap(code:String, bmp:BitmapData):void {
			var newIndex:int = librarySmileys.length;
			librarySmileys[newIndex] = new Array();
			librarySmileys[newIndex][0] = code.toLowerCase();
			librarySmileys[newIndex][1] = "";
			librarySmileys[newIndex][2] = new Bitmap(bmp);
		}
		
		public function registerSmiley(code:String, url:String):void {
			var newIndex:int = librarySmileys.length;
			librarySmileys[newIndex] = new Array();
			librarySmileys[newIndex][0] = code.toLowerCase();
			librarySmileys[newIndex][1] = url;

			var tmp:Loader = new Loader();
			tmp.contentLoaderInfo.addEventListener(Event.COMPLETE, smileyLoaded, false, 0, true);
			tmp.load(new URLRequest(url+"?newIndex="+newIndex));
		}
		
		private function smileyLoaded(event:Event):void {
			var newIndex:int = event.target.url.substring(event.target.url.lastIndexOf("?newIndex=")+10);
			librarySmileys[newIndex][2] = new Bitmap();
			librarySmileys[newIndex][2] = event.target.content as Bitmap;
		}

		private function scrollEvent(event:ScrollEvent):void {
			scrollClip.y = -event.position;
		}
		
		/*private function copyLineToClipboard(event:ContextMenuEvent):void {
			System.setClipboard(removeHtml((event.mouseTarget as SmileRow).realText));
		}*/
		
		private function copyAllToClipboard(event:ContextMenuEvent):void {
			var cbString:String = "";
			for(var tin:int=0; tin<textFields.length; tin++)
				cbString += textFields[tin].realText + "\n";

			System.setClipboard(removeHtml(cbString.substring(0, cbString.length - 1)));
		}

		private function removeHtml(text:String):String {
			/*text = text.split("<b>").join("");
			text = text.split("</b>").join("");
			text = text.split("<i>").join("");
			text = text.split("</i>").join("");
			text = text.split("</font>").join("");*/
			return text;
		}
	}
}