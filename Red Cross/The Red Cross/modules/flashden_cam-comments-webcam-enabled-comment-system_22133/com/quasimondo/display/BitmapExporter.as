	
	//------------------------------------------------------------	
	//
	// BitmapExporter Class v2.2
	//
	// Author:  Mario Klingemann
	// Contact: mario@quasimondo.com
	// Site: 	http://www.quasimondo.com
	//
	//
	// Simple Usage:
	//
	// BitmapExporter.gatewayURL = "http://www.yourserver.com/yourscripts/BitmapExporter.php";
	// BitmapExporter.saveBitmap( bitmapDataObject, "test.jpg" );
	//
	// Options:
	// 
	// BitmapExporter.timeslice = 2000;
	// This will set the maximum allowed time for each Bitmap Scanning pass to
	// 2000 milliseconds. This is in order to avoid the "Flash is running slow"
	// warning message. You can experiment with higher values.
	//
	//
	//
	// BitmapExporter.blocksize = 100000;
	// Only applies to palette modes. This will set the maximum data chunk size that is sent 
	// in on pass to 100000 bytes.
	// A value to experiment with - I have experienced some strange supposedly flash initiated
	// timeouts with high values in the standalone player. 
	//
	//
	// BitmapExporter.connectionTimeout = 5000;
	// The amount of milliseconds after which the connection will be reset if the server
	// does not answer.
	//
	//
	// BitmapExporter.deleteAfterDownload = false;
	// In its default setting the image file will be deleted from the server after is has been
	// downloaded by the user. Set this property to false if you want to keep the image.
	// This does only apply for the download mode, if you use the dontRetrieve the image
	// will not be deleted.
	//
	//
	// Events:
	// 
	//  BitmapExporter.addEventListener("progress", this);
	//	BitmapExporter.addEventListener("status", this);
	//	BitmapExporter.addEventListener("complete", this);
	//	BitmapExporter.addEventListener("error", this);
	//  BitmapExporter.addEventListener("saved", this);
	//
	//
	//  Syntax:
	//  BitmapExporter.saveBitmap( bitmap:BitmapData, filename:String, [mode:String], [lossBits:Number], [jpegQuality:Number], [dontRetrieve:Boolean] );
	//
	//  bitmap: accepts transparent and non-transparent BitmapData objects, but currenty
	//  the transparency information is ignored and a opaque white background is applied
	//  to transparent images. This might change in a later version.
	//
	//
	//  filename: The suffix of the filename automatically decides which output format you get, possible values are:
	//  "yourfilename.jpg" or "yourfilename.jpeg" for JPEG format
	//  "yourfilename.png" for PNG format
	//  "yourfilename.bmp" for BMP format
	//
	//
	//  mode: currently supported values for "mode" are:
	//
	//  "turboscan":  pixels are converted to base10 - no timeout checking, no bitmask. Fastest scan, but biggest data size.
	//  "fastscan":   pixels are converted to base36 - with timer check, 
	//  "default":    pixels are converted to base128 
	//  "palette":    a lookup table is created and the pixels are run length encoded
	//  "rgb_rle":     each color color channels is separately run length encoded 
	//
	//
	// lossbits: is a bitmask that strips away least significant bits in order to
	// get a better compression rate by having more equal bytes in succession possible
	// for the price of reduced quality. Possible values come between 0 and 7.
	//
	//
	//  jpegquality: is a value between 0 and 100 and sets the jpeg compression rate.
	//
	//
	//  dontretrieve: if this value is set to true the download popup will not automatically be triggered
	// this allows you to use the saved image for other purposes, like adding it to a gallery, emailing it etc.
	// if you use this feature you should listen to the "saved" event in order to know when the image
	// is ready on the server
	//
	//
	//  Version History:
	//  v1.1: - fixed Timeout bug that occured when cancelling a save
	//
	//  v1.2: - changed the temporaty file handling: data chunks are now stored
	//		    as strings in a tempory file on the server (instead of partial
	//	        PNGs and converted to bitmaps at the retrieval stage.
	//        - improved the timeout handling. In earlier versions the
	//		    the system warning could sometims get triggered with very wide bitmaps
	//		  - slightly reduced the data overhead with "turboscan", "fastscan",
	//          "default","lzw" modes
	//		  - an clone of the to be saved bitmap is created in order to 
	//          avoid that the data gets changed or deleted during the saving
	//          process
	//        - made a tiny change to the onAddPixelBlock error handling
	//        - added httpStatus event handling
	//
	//  v1.3: - added the dontRetrieve option which allows to just save a
	//			bitmap on the server without automatically popping up the
	//			download window
	//        - added deleteImage() function to delete an uploaded image from
	//			the server manually
	//
	//  v1.4  - made several changes to ensure MTASC compatibility
	//        - added optional mx.utils.Delegate class for net.hiddenresource.util.Delegate
	//
	//  v1.5  - changed the target of all events from "this" to "BitmapExporter" 
	//        - made several optimizations on the server side which greatly reduce memory requirements
	//
	// v1.6   - fixed a bug in the BMP encoding on the server side
	//
	// v1.7  - removed palettelzw mode
	//		  - removed init() method and fixed initialization of addEventListener
	//		  - added keep-alive echos on server side to keep flash from closing the connection		
	//
	// v2.0   - removed System.useCodePage = true
	//		  - changed data encoding to base64 due to incompatibilities of previous
	//		    modes on Asian OS	
	//		  - enabled rgb_rle mode which unfortunately is not any better than palette mode
	//		  - removed lzw mode since it was much slower than any other mode	
	//		  - added deleteAfterDownload property
	//
	// v2.1   - added   ini_set ( "memory_limit", "32M"); option to php
	//           - added https connection comment to script
	//
	// v2.2  - added check for php safe mode at restricted commands
	//
	//   License:
	//   
	//   NON-COMMERCIAL/PRIVATE USE:
	//   The use of the BitmapExporter package is free for all non-commercial
	//   work if PROPER ATTRIBUTION is given. "non-commercial" means that you
	//   do not get paid for this work or you do not intend to sell it. 
	//   "proper attribution" is a credit line somewhere visible along your
	//   piece of work which reads like this: 
	//   
	//   "[Insert your work title here] uses BitmapExporter by <a href="http://www.quasimondo.com">Mario Klingemann</a>"
	//
	//   If you cannot comply to this rule please contact me for a special
	//   permission at mario@quasimondo.com
	//
	//   COMMERCIAL USE:
	//   The use of the BitmapExporter package is NOT AUTOMATICALLY FREE for 
	//   all commercial works or services.
	//   
	//   If you are able to show the follwing attribution line along with the work:
	//   "[Insert your product title here] uses BitmapExporter by <a href="http://www.quasimondo.com">Mario Klingemann</a>"
	//   there is no license fee though it would be better for your karma if
	//	 you shared a tiny amount of the money you get paid for this job with me.
	//   
	//   If you do not want to or are not able to show the credit line
	//   the one time license fee is EURO €250.- per site/product
	//
	//   Please contact me for special agency/studio conditions regarding licensing for 
	//   multiple sites/products/clients: mario@quasimondo.com
	//
	//---------------------------------------------------------------------
	
	
	import flash.display.BitmapData;
	import flash.net.FileReference;
	import mx.events.EventDispatcher;
	
	import mx.utils.Delegate;
	//import net.hiddenresource.util.Delegate
	// exchange the Delegate class if you intend to compile
	// with MTASC
	
	class com.quasimondo.display.BitmapExporter 
	{
		
		public  static var gatewayURL:String           = "http://localhost/BitmapExporter.php";
		public  static var timeslice:Number            = 1000;
		public  static var blocksize:Number            = 150000;
		public  static var connectionTimeout:Number    = 5000;
		public  static var deleteAfterDownload:Boolean = true;
		
		
		private static var instance:BitmapExporter;
		
   	 	private static var dispatchEvent:Function;
		
		private var connectionTimeoutID:Number;
		private var timeoutID:Number;
		
		
		private var initialized:Boolean    = false;
		private var busy:Boolean           = false;
		private var dontRetrieve:Boolean   = false;
		private var saveMode:String;
		private var fileRef:FileReference;
		private var status:String = "idle";
		private var lastY:Number;
		private var lastX:Number;
		private var pixels:Array;
		private var pixels_r:Array;
		private var pixels_g:Array;
		private var pixels_b:Array;
		
		private var palette:Array;
		
		private var totaltimer:Number;
		private var uniqueID:String;
		private var filename:String;
		private var jpegQuality:Number;
		private var bitmap:BitmapData;
		private var bitmapWidth:Number;
		private var bitmapHeight:Number;
		private var sentBytes:Number;
		private var bitmask:Number;
		private var service:LoadVars;
		private var encodeBase:Number = 128;
		private var lastHTTPStatus:Number;
		
		private static var b64chars:Array;
		
		private function BitmapExporter()
		{
			EventDispatcher.initialize ( BitmapExporter ) ;
			initArrays();
		}
		
		static public function addEventListener( event:String, listener:Object ):Void
		{
			if ( instance == undefined )
			{
				instance = new BitmapExporter();
			}
			addEventListener( event, listener );
		}
		
		static public function removeEventListener( event:String, listener:Object ):Void
		{
			if ( instance == undefined )
			{
				instance = new BitmapExporter();
			}
			removeEventListener( event, listener );
		}
		
		static public function saveBitmap( bitmap:BitmapData, filename:String, mode:String, lossBits:Number, jpegQuality:Number, dontRetrieve:Boolean ):Boolean
		{
			// currently supported modes are:
			//
			// "turboscan":  pixels are converted to base10 - no timeout checking, no bitmask. Fastest scan, but biggest data size.
			// "fastscan":   pixels are converted to base36 - with timer check, 
			// "default":    pixels are converted to base128 
			// "palette":    a lookup table is created and the pixels are run length encoded
			// "rgb_rle":    
			
			return BitmapExporter.getInstance()._saveBitmap( bitmap, filename, mode, lossBits, jpegQuality, dontRetrieve );
		}
		
		static public function getStatus():String
		{
			return BitmapExporter.getInstance().status;
		}
		static public function getService():LoadVars
		{
			return BitmapExporter.getInstance().service;
		}
		
		static public function resetStatus():Void
		{
			BitmapExporter.getInstance().reset();
		}
		
		static public function cancel():Void
		{
			if ( BitmapExporter.getStatus() != "idle" )
			{
				BitmapExporter.getInstance().dropImageHandle();
				BitmapExporter.getInstance().setStatus( "cancelled" );
			}
		}
		
		static public function getInstance():BitmapExporter
		{
			if ( instance == undefined )
			{
				instance = new BitmapExporter();
			}
			return instance;
		}
		
		static public function deleteImage( externalID:String ):Void
		{
			BitmapExporter.getInstance().dropImageHandle( externalID );
		}
		
		private function _saveBitmap( _bitmap:BitmapData, _filename:String, mode:String, lossBits:Number, _jpegQuality:Number, _dontRetrieve:Boolean ):Boolean
		{
			if ( status == "idle" && _bitmap != null && _bitmap.height > 0 && _bitmap.width > 0 && _filename!=null )
			{
				totaltimer 					= getTimer();
				bitmap                  = _bitmap.clone();
				filename                = _filename;
				jpegQuality             = ( _jpegQuality == null ? 75 : _jpegQuality );
				bitmapWidth             = bitmap.width;
				bitmapHeight            = bitmap.height;
				dontRetrieve            = ( _dontRetrieve == true );

				
				if ( mode == undefined ) mode = "default";
				saveMode                = mode.toLowerCase()
				
				lossBits = Math.floor( Number( lossBits ) );
				if ( isNaN ( lossBits ) ) lossBits = 0;
				if ( lossBits < 0)        lossBits = 0;
				if ( lossBits > 7)        lossBits = 7;
				bitmask = 0xff - ( Math.pow( 2, lossBits ) - 1 );
				bitmask = ( bitmask << 16 ) | ( bitmask << 8 ) | bitmask; 
				
				if ( filename.split(".").pop().toLowerCase() == "bmp" )
				{
					flipBMP();
				}
				
				getImageHandle();
				
				onScanProgress ( 0, "initializing" );
				
				return true;
				
			} else {
				error( "saveBitmap Arguments are not correct" );
				return false;
				
			}
		}
		
		private function reset( keepImage:Boolean ):Void
		{
			if ( !keepImage && uniqueID != null ) dropImageHandle();
			
			setStatus( "idle" );
			busy = false;
			
			bitmap.dispose();
			
			_global.clearTimeout( timeoutID );
			
			delete uniqueID;
			delete saveMode;
			delete filename;
			delete jpegQuality;
			delete pixels;
			delete palette;
			delete bitmapWidth;
			delete bitmapHeight;
		}
		
		private function initArrays():Void
		{
			b64chars = String('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/').split("");
		}
		
		private function getImageHandle():Void
		{
			setStatus( "contacting server" );
				
			connectionTimeoutID = _global.setTimeout( this, "onConnectionTimeout", connectionTimeout );
			
			initService();
			service.mode    = "getImageHandle";
			service.width   = bitmapWidth;
			service.height  = bitmapHeight;
			service.onLoad  = Delegate.create( this, onImageHandle );
			service.sendAndLoad( gatewayURL, service, "POST" );
		}
		
		private function scanBitmap():Void
		{
			var pixel:Number;
			
			if ( status == "contacting server" )
			{
				setStatus( "sending" );
				lastX     = 0;
				lastY     = 0;
				sentBytes = 0;
				busy      = false;
				
			} else if ( lastY == bitmapHeight )
			{
				if ( !busy )
				{
					onScanProgress ( 0.95, "retrieving" );
					save();
				} else 
				{
					timeoutID = _global.setTimeout( this, "scanBitmap", 50 );
				}
				return;
			}
			
			var x:Number;
			var y:Number      = lastY;
			var timer:Number  = getTimer();
			var lines:Number  = 0;
			var firstX:Number = lastX;
			var thebitmask:Number = this.bitmask;
            var thebitmapWidth:Number = this.bitmapWidth;
            var thebitmapHeight:Number = this.bitmapHeight;
					
			onScanProgress ( 0.05 + 0.9 * ( lastY / thebitmapHeight ), "reading pixels" );
			
			var p:Number = 0;
			pixels = [];
			
			var tempPixels:Array  = [];
			
			switch ( saveMode ){
				
				case "turboscan":
				
					var i:Number = thebitmapWidth * thebitmapHeight;
					y            = thebitmapHeight - 1;
					do {
						x = thebitmapWidth;
						do {
							pixels[ --i ] = bitmap.getPixel( --x, y );
						} while ( x > 0 )
					}  while (  --y > -1 )
					
					lines = y = thebitmapHeight;
					x = thebitmapWidth;
					break;
					
				case "fastscan":
				
					do {
						x = lastX;
						lastX = 0;
						do {
							pixels[p++] = ( bitmap.getPixel( x, y ) & thebitmask ).toString(36);
						} while ( ++x < thebitmapWidth  && ( getTimer() - timer < timeslice ))
						if ( x == thebitmapWidth )
						{
							lines++;
						} else {
							lastX = x;
							break;
						}
					}  while ( ( ++y < thebitmapHeight ) && ( getTimer() - timer < timeslice ) )
				
				break;
				
				case "default":
				
					do {
						x = lastX;
						lastX = 0;
						do {
							pixels[p++] =  bitmap.getPixel( x, y ) & thebitmask ;
						} while ( ++x  < thebitmapWidth && ( getTimer() - timer < timeslice ) )
						if ( x == thebitmapWidth )
						{
							lines++;
						} else {
							lastX = x;
							break;
						}
					}  while ( ( ++y  < thebitmapHeight ) && ( getTimer() - timer < timeslice ))
				
				break;
				
				case "palette":
				
					palette = [];
					var idxLookup:Object    = new Object();
					var lastIdx:Number      = 0;
					var offsetLimit:Boolean = false;
					var bytePointer:Number  = 16;
					var currentByte:Number  = 0;
					var offset:Number;
					var lookup:Number;
					
					do {
						x     = lastX;
						lastX = 0;
						do {
							pixel = bitmap.getPixel( x, y ) & thebitmask;
							if ( idxLookup[ pixel ] == null )
							{
								 idxLookup[ pixel ] = palette.push( pixel ) - 1;
							}
							
							lookup  = idxLookup[ pixel ];
							offset  = lookup - lastIdx;
							lastIdx = lookup;
							
							if ( offset < -0x7fff || offset > 0x7fff )
							{
								offsetLimit = true;
								lastX = x;
								if ( bytePointer < 16 )
								{
									tempPixels[p++] = currentByte;
								}
							} else 
							{
								if ( offset < 0 ) 
								{
									offset += 0x10000;
								}
								currentByte |=  offset << bytePointer;
								bytePointer -= 16;
								if ( bytePointer < 0 )
								{
									tempPixels[p++] = currentByte;
									bytePointer = 16;
									currentByte = 0;
								}
							}
						} 
						while ( !offsetLimit && ++x  < thebitmapWidth )
						lines++;
					}  
					while ( !offsetLimit && ( ++y  < thebitmapHeight ) && ( p + palette.length < blocksize ) && ( getTimer() - timer < timeslice ))
				
					if ( !offsetLimit )
					{
						lastX = thebitmapWidth;
						if ( bytePointer < 16 )
						{
							tempPixels[p++] = currentByte;
						}
					}
					
					var lastPixel:Number = tempPixels[ 0 ];
					var c:Number  = 1;
					var tl:Number = tempPixels.length; 
					p = 0;
					for ( var i:Number = 1; i < tl; i++ )
					{
						if ( lastPixel == tempPixels[i] )
						{
							c++;
							if ( c == 0x10000 )
							{
								pixels[p++] = 0x8000ffff;
								pixels[p++] = lastPixel;
								c = 1;
							}
						} else {
							if ( c > 1 )
							{
								if ( c > 2 )
								{
									pixels[p++] = 0x80000000 | c;
								} else 
								{
									pixels[p++] = lastPixel;
								}
							}
							pixels[p++] = lastPixel;
							c = 1;
							lastPixel = tempPixels[ i ];
						}
					}
					if ( c > 1 )
					{
						if ( c > 2 )
						{
							pixels[p++] = 0x80000000 | c ;
						} else 
						{
							pixels[p++] = lastPixel;
						}
					}
					pixels[p++] = lastPixel;
							
					delete tempPixels;
					delete idxLookup;
					
				break;
				
				case "rgb_rle":
				
					// in development - not active yet
					
					pixels_r = [];
					pixels_g = [];
					pixels_b = [];
					
					pixel = bitmap.getPixel( lastX, y ) & thebitmask;
					
					var pr:Number = 0;
					var pg:Number = 0;
					var pb:Number = 0;
					
					
					var pixel_r:Number;
					var pixel_g:Number;
					var pixel_b:Number;
					
					var last_r:Number = ( pixel >> 16 ) & 0xff;
					var last_g:Number = ( pixel >> 8 ) & 0xff;
					var last_b:Number =   pixel & 0xff;
					
					pixels_r[pr++] = last_r;
					pixels_g[pg++] = last_g;
					pixels_b[pb++] = last_b;
					
					var r:Number;
					var g:Number;
					var b:Number;
					
					var count_r:Number = 0;
					var count_g:Number = 0;
					var count_b:Number = 0;
					
					var last_rd:Number = null;
					var last_gd:Number = null;
					var last_bd:Number = null;
					
					lastX++;
					if ( lastX == thebitmapWidth){
						lastX = 0;
						y++
						lines++;
					}
					
					do {
						x     = lastX;
						lastX = 0;
						do {
							pixel = bitmap.getPixel(  x, y ) & thebitmask;
							pixel_r = ( pixel >> 16 ) & 0xff;
							r = pixel_r - last_r;
							if ( r == last_rd && count_r < 0xffff ) 
							{
								count_r++;
							} else {
								if (count_r == 0 ) 
								{
									if ( last_rd != r && last_rd!=null && last_rd!=0 )
									{
										pixels_r[pr++] =( last_rd + 256 ) & 0xff ;
									} else if ( last_rd==0)
									{
										pixels_r[pr++] = 0;
										pixels_r[pr++] = 1;
										pixels_r[pr++] = 0;
									}
								} else 
								{
									count_r++;
									pixels_r[pr++] = 0;
									if ( count_r > 0xff ) pixels_r[pr++] = 0;
									while (count_r > 0)
									{
										pixels_r[pr++] = count_r & 0xff;
										count_r >>= 8;
									}
									pixels_r[pr++] = ( last_rd + 256 ) & 0xff;
								}
								
							}
							last_r = pixel_r;
							last_rd = r;
							
							pixel_g = ( pixel & 0x00ff00) >> 8;
							g = pixel_g - last_g;
							if ( g == last_gd && count_g < 0xffff ) 
							{
								count_g++;
							} else {
								if (count_g == 0 ) {
									if (last_gd != g && last_gd!=null && last_gd!=0){
										pixels_g[pg++] = ( last_gd + 256 ) & 0xff;
									} else if ( last_gd==0)
									{
										pixels_g[pg++] = 0;
										pixels_g[pg++] = 1;
										pixels_g[pg++] = 0;
									}
								} else {
									count_g++;
									pixels_g[pg++] =0;
									if ( count_g > 0xff ) pixels_g[pg++] =0;
									while (count_g>0) {
										pixels_g[pg++] =count_g & 0xff;
										count_g >>= 8;
									}
									pixels_g[pg++] =( last_gd + 256 ) & 0xff;
								}
							}
							last_g = pixel_g;
							last_gd = g;
							
							pixel_b =  pixel & 0xff;
							b = pixel_b - last_b;
							if ( b == last_bd && count_b < 0xffff ) 
							{
								count_b++;
							} else {
								if (count_b == 0 ) {
									if (last_bd != b && last_bd!=null && last_bd!=0){
										pixels_b[pb++] =( last_bd + 256 ) & 0xff;
									} else if ( last_bd==0)
									{
										pixels_b[pb++] = 0;
										pixels_b[pb++] = 1;
										pixels_b[pb++] = 0;
									}
								} else {
									count_b++;
									pixels_b[pb++] =0;
									if ( count_b > 0xff ) pixels_b[pb++] =0;
									
									while (count_b>0) {
										pixels_b[pb++] =count_b & 0xff;
										count_b >>= 8;
									}
									pixels_b[pb++] =( last_bd + 256 ) & 0xff;
								}
							}
							last_b = pixel_b;
							last_bd = b;
						
						} while ( ++x  < thebitmapWidth  )
						lines++;
					}  while ( ( ++y  < thebitmapHeight ) && ( pr+pg+pb < blocksize * 3 ) && ( getTimer() - timer < timeslice ) )
					
					if (count_r > 0 || last_rd==0 ) {
						count_r++;
						pixels_r[pr++] = 0;
						if ( count_r > 0xff ) pixels_r[pr++] = 0;
						while (count_r>0) {
							pixels_r[pr++] = count_r & 0xff;
							count_r >>= 8;
						}
						pixels_r[pr++] = ( last_rd + 256 ) & 0xff;
					} else {
						pixels_r[pr++] = ( last_rd + 256 ) & 0xff;
					}
					
					if (count_g > 0 || last_gd==0) {
						count_g++;
						pixels_g[pg++] = 0;
						if ( count_g > 0xff ) pixels_g[pg++] = 0;
						
						while (count_g>0) {
							pixels_g[pg++] = count_g & 0xff;
							count_g >>= 8;
						}
						pixels_g[pg++] = ( last_gd + 256 ) & 0xff;
					} else {
						pixels_g[pg++] = ( last_gd + 256 ) & 0xff;
					}
					
					if (count_b > 0 || last_bd==0 ) {
						count_b++;
						pixels_b[pb++] = 0;
						if ( count_b > 0xff ) pixels_b[pb++] = 0;
						
						while (count_b>0) {
							pixels_b[pb++] = count_b & 0xff;
							count_b >>= 8;
						}
						pixels_b[pb++] = ( last_bd + 256 ) & 0xff;
					} else {
						pixels_b[pb++] = ( last_bd + 256 ) & 0xff;
					}
					break;
			}
			
			addPixelBlock( lastY, lines );
			
			lastY  = y;
			lastX %= thebitmapWidth;
		}
		
		private function dropImageHandle( externalID:String ):Void
		{
			
			initService();
			service.mode         = "dropImageHandle";
			service.uniqueID     = ( externalID != null ? externalID : uniqueID );
			service.onLoad       = Delegate.create( this, onDropImageHandle );

			service.sendAndLoad( gatewayURL, service, "POST" );
			
		}
			
		private function addPixelBlock( top:Number, lines:Number ):Void
		{
			if (!busy)
			{
				onScanProgress ( 0.05 + 0.9 * ( ( top + lines ) / bitmapHeight ), "sending" );
			
				busy = true;
				
				initService();
				service.mode      = saveMode;
				service.sentBytes = 0;
				service.uniqueID  = uniqueID;
				
				switch ( saveMode ){
					
					case "turboscan":
					case "fastscan":
					 	service.bitmapString  = pixels.join( "," );
					break;
					
					case "default":
						service.bitmapString  = arrayToBase64( pixels, 24 );
					break;
					
					case "palette":
						service.paletteString = arrayToBase64( palette, 24 );
						service.bitmapString  = arrayToBase64( pixels, 32 );
					break;
					
					case "rgb_rle":
						service.red			  = arrayToBase64( pixels_r, 8 );
						service.green		  = arrayToBase64( pixels_g, 8 );
						service.blue		  = arrayToBase64( pixels_b, 8 );

					break;
				
				}
				
				service.onHTTPStatus = Delegate.create( this, onHTTPStatus );
				service.onLoad       = Delegate.create( this, onAddPixelBlock );
				service.sendAndLoad( gatewayURL, service, "POST" );
				
				timeoutID = _global.setTimeout( this, "scanBitmap", 50 );
				
			} else 
			{
				onScanProgress ( 0.05 + 0.9 * ( ( top + lines ) / bitmapHeight ), "Waiting for Server..." );
				timeoutID = _global.setTimeout( this, "addPixelBlock" , 100, top, lines );
			}
		}
		
		private function save():Void
		{
			if ( status == "sending" )
			{
				delete pixels;
				delete palette;
				
				setStatus( "retrieving" );
				
				initService();
				service.mode         = "save";
				service.width        = bitmapWidth;
				service.height       = bitmapHeight;
				service.uniqueID     = uniqueID;
				service.filename     = filename;
				service.uniqueName 	 = _global.uniqueName
				service.quality      = jpegQuality;
				service.onLoad       = Delegate.create( this, onSave );
				
				service.sendAndLoad( gatewayURL, service, "POST" );
			}
		}
		
		function arrayToBase64( data:Array, bits:Number ):String
		{
			
			var l:Number = data.length;
			var n:Number;
			var a:String = "";
			var i:Number = 0;
			var remain:Number;
			var b64:Array = b64chars;
			
			switch ( bits )
			{
				case 8:
					remain = l % 3;
					l-=remain;
					while ( l  > 0 ){
						n = data[ i++ ] << 16 | data[ i++ ] << 8 | data[ i++ ];
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						l-=3;
					}  
					if ( remain == 1 )
					{
						n = data[ i ];
						a += b64[(n>>2) & 0x3F];
						a += b64[(n<<4) & 0x3F];
						a += "=";
					} else if ( remain == 2 )
					{
						n = (data[ i++ ] << 8) | data[ i ];
						a += b64[(n>>10) & 0x3F];
						a += b64[(n>>4) & 0x3F];
						a += b64[(n<<2) & 0x3F];
						a += "=";
						
					}
					
				break;
				
				case 16:
				
					remain = l % 3;
					l-=remain;
					while ( l  > 0 ) {
						n = (data[ i++ ] << 16) | data[ i ];
						a += b64[(n>>26) & 0x3F];
						a += b64[(n>>20) & 0x3F];
						a += b64[(n>>14) & 0x3F];
						a += b64[(n>> 8) & 0x3F];
						a += b64[(n>> 2) & 0x3F];
						n = ((data[i++] & 0x3) << 16) | data[i++];
						a += b64[(n>>12) & 0x3F];
						a += b64[(n>>6) & 0x3F];
						a += b64[n & 0x3F];
						l-=3;
					} 
					
					if ( remain == 1 )
					{
						n = data[ i ];
						a += b64[(n>>10) & 0x3F];
						a += b64[(n>>4) & 0x3F];
						a += b64[(n<<2) & 0x3F];
						a += "=";
					} else if ( remain == 2 )
					{
						n = (data[ i++ ] << 16) | data[ i ];
						a += b64[(n>>26) & 0x3F ];
						a += b64[(n>>20) & 0x3F ];
						a += b64[(n>>14) & 0x3F ];
						a += b64[(n>> 8) & 0x3F ];
						a += b64[(n>> 2) & 0x3F ];
						n = ( (data[i]<< 4) & 0x3F );
						a += b64[n];
						a += "==";
					}
					
				break;
				
				case 24:
					 while ( l--  > 0 ) {
						n = data[ i++ ];
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
					} 
				break;
				
				case 32:
					remain = l % 3;
					l-=remain;
					
					while ( l  > 0 ) {
						
						n = (data[ i ] >> 8) & 0xffffff;
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						
						n = ((data[ i++ ] & 0xff) << 16) | ((data[ i ] >> 16)& 0xffff);
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						
						n = ((data[ i++ ] & 0xffff) << 8) | ((data[ i ] >> 24) & 0xff);
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						
						n = (data[ i++ ] & 0xffffff);
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						
						l-=3;
					}  
					
					if ( remain == 1)
					{
						n = data[ i ];
						a += b64[(n>>26) & 0x3F ];
						a += b64[(n>>20) & 0x3F ];
						a += b64[(n>>14) & 0x3F ];
						a += b64[(n>> 8) & 0x3F ];
						a += b64[(n>> 2) & 0x3F ];
						a += b64[(n<< 4) & 0x3F ];
						a += "==";
					}  else if ( remain == 2)
					{
						n = (data[ i ] >> 8) & 0xffffff;
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[ n & 0x3F];
						
						n = ((data[ i++ ] & 0xff) << 16) | ((data[ i ] >> 16)& 0xffff) ;
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						
						n = ((data[ i++ ] & 0xffff) << 8) 
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a+="=";
						
					} 
					
				break;
			}
			
			return a;
			
		}
			
		private function initService():Void
		{
			service              = new LoadVars();
			service.success      = 0;
			service.onHTTPStatus = Delegate.create( this, onHTTPStatus );
			lastHTTPStatus       = null;
		}
			
		private function error( message:String ):Void
		{
			trace( message );		
			
			BitmapExporter.dispatchEvent({
										 type:    "error", 
										 target:  this, 
										 message: "ERROR: " + message
										 });
		
			reset();
		}
		
		private function flipBMP():Void
		{
			var temp_bitmap:BitmapData = bitmap.clone();
			bitmap.fillRect( bitmap.rectangle, 0 );
			bitmap.draw( temp_bitmap, new flash.geom.Matrix( -1, 0, 0, 1, bitmap.width, 0 ) );
			temp_bitmap.dispose();
		}
		
		/*----------------------------------------------------------
								EVENTS
		----------------------------------------------------------*/
			
		private function onImageHandle( success:Boolean ):Void
		{
			_global.clearTimeout( connectionTimeoutID );
			
			if (!success)
			{
				error( "[onImageHandle] HTTP Error " + lastHTTPStatus );
				return;
			}
			
			if  ( status == "cancelled" )
			{
				reset();
				return;
			}
			
			if ( service.success == "1" )
			{
					uniqueID = service.uniqueID;
					onScanProgress( 0.05, "Analysing Bitmap" );
					timeoutID = _global.setTimeout( this, "scanBitmap" ,50 );
			} else 
			{
				error( "[onImageHandle] " + service.error );
			}
		}
		
		private function onHTTPStatus( httpStatus:Number ):Void
		{
			lastHTTPStatus = httpStatus;
			
			if ( httpStatus >= 400 )
			{
				error( "HTTP error " + httpStatus );
			}
		}
			
		private function onAddPixelBlock( success:Boolean ):Void
		{
			busy = false;
			
			if ( !success )
			{
				error( "[onAddPixelBlock] HTTP error " + lastHTTPStatus );
				return;
			} 
			
			if  ( status == "cancelled" )
			{
				reset();
				return;
			}
			
			if ( service.success == "1" )
			{
				sentBytes += Number( service.sentBytes );
			} else if ( service.success == "0" )
			{
				error( "[onAddPixelBlock] " + service.error );
			} else {
				error( "[onAddPixelBlock] No Server Response (possible silent PHP crash)");
			}
			
		}
		
		private function onSave( success:Boolean ):Void
		{
			if (!success)
			{
				error( "[onSave] HTTP error "+lastHTTPStatus );
				return;
			}
			
			if  ( status == "cancelled" )
			{
				reset();
				return;
			}
			
			if ( service.success=="1" )
			{
				totaltimer = getTimer() - totaltimer;
				if ( !dontRetrieve )
				{
					setStatus( "downloading" );
					
					fileRef = new FileReference();
					fileRef.addListener( this );
					
					onProgress( fileRef, 0 , 0 );
					
					if( !fileRef.download( service.url + ( deleteAfterDownload ? "&delete=1" : "" ), filename ) ) 
					{
						error( "[onSave] Dialog box failed to open." );
					}
				} else {
					onSaved( service.url, service.filename );
				}
			} else 
			{
				error( "[onSave] " + service.error );
			}
		}
		
		private function onDropImageHandle( success:Boolean ):Void
		{
			if (!success)
			{
				error( "[onDropImageHandle] HTTP error "+ lastHTTPStatus );
			}
		}
		
		
		private function onScanProgress( progress:Number, message:String ):Void {
			BitmapExporter.dispatchEvent({
										 type:    "progress", 
										 target:  BitmapExporter, 
										 current: progress, 
										 total:   1, 
										 message: message 
										 })
		}
		
		private function onSelect( file:FileReference ):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:   "select", 
										 target: BitmapExporter 
										 })
		}

		private function onCancel( file:FileReference ):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:   "cancel", 
										 target: BitmapExporter 
										 })
			reset();
		}

		private function onOpen(file:FileReference):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:     "open", 
										 target:   BitmapExporter, 
										 filename: file.name 
										 })
		}

		private function onProgress( file:FileReference, bytesLoaded:Number, bytesTotal:Number):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:    "progress", 
										 target:  BitmapExporter, 
										 current: bytesLoaded, 
										 total:   bytesTotal, 
										 message: "downloading" 
										 })
		}

		private function onComplete( file:FileReference ):Void 
		{
			BitmapExporter.dispatchEvent({
										 type:             "complete", 
										 target:           BitmapExporter, 
										 filename:         file.name,
										 sentBytes:		   sentBytes,
										 time:			   totaltimer,
										 compressionRatio: sentBytes / (bitmapWidth * bitmapHeight * 4)
										 });
			reset();
		}
		
		private function onSaved( serviceUrl:String, fileName:String ):Void 
		{
			BitmapExporter.dispatchEvent({
										 type:             "saved", 
										 target:           BitmapExporter, 
										 url:              serviceUrl,
										 fileName:		   fileName,
										 uniqueID:		   uniqueID,
										 sentBytes:		   sentBytes,
										 time:			   totaltimer,
										 compressionRatio: sentBytes / (bitmapWidth * bitmapHeight * 4)
										 });
			reset( true );
		}

		private function onIOError( file:FileReference ):Void 
		{
			error ( "IO error with file " + file.name);
		}
		
		private function onConnectionTimeout():Void {
			error ( "Connection Timeout - no response from server" );
		}

		private function setStatus( _status:String ):Void
		{
			status = _status;
			BitmapExporter.dispatchEvent({
										 type:   "status", 
										 target: BitmapExporter, 
										 status: status
										 });
			
		}
		
	}
