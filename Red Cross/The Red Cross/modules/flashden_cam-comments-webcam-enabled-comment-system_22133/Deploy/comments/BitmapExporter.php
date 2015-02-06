<?php
	//------------------------------------------------------------	
	//
	// BitmapExporter Class v2.1
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
	// BitmapExporter.timeslice = 500;
	// This will set the maximum allowed time for each Bitmap Scanning pass to
	// 500 milliseconds - the default value is 1000. The higher you set this value the 
	// more pixels will be processed in one frame and thus the more data gets sent in
	// on chunk, but at the same time flash will become less responsive and you risk to get the
	// "Flash is running slow" warning message.
	//
	//
	// BitmapExporter.blocksize = 100000;
	// Only applies to palette modes. This will set the maximum data chunk size that is sent 
	// in one pass to 100000 bytes.
	// A value to experiment with - I have experienced some strange supposedly flash initiated
	// timeouts with high values in the standalone player. 
	//
	//
	// BitmapExporter.connectionTimeout = 5000;
	// The amount of milliseconds after which the connection will be reset if the server
	// does not answer.
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
	//		    the system warning could sometimes get triggered with very wide bitmaps
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
	//		  - removed getfile.php and moved image download script into BitmapExporter.php	
	//
	// v2.1   - added   ini_set ( "memory_limit", "32M"); option to php
	//           - added https connection comment to script
	//
	//v2.2  - added check for php safe mode at restricted commands
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
	
	
	

	// $RELATIVE_SAVEPATH contains the path to the folder where the temporary files are stored
	// the location is relative to this file:
	
	$RELATIVE_SAVEPATH = "BitmapExporter_Tempfiles/";
	
	
	// $DOWNLOADURL contains the url to the script that returns the final image as seen from the Flash file.
	// By default this is the url of BitmapExporter.php itself and you have to adjust the path if you copy it to
	// a subfolder. 

	$DOWNLOADURL = "http://".$PHP_SELF."/BitmapExporter.php?mode=download&name=";
	
	//Alternatively you can also return the direct link tothe image - but then you'llhave to take care
	//yourself about cleaning up afterwards:
	//$DOWNLOADURL = "http://localhost/BitmapExporter_Tempfiles/";
	
	// The maximum allowed time in seconds the script is allowed to calculate - if you deal with big bitmaps
	// and lzw compression you might have to increase this value. A value of 0 removes any time limit.
	// Depending on your servers PHP configuration this value might be ignored and there is a fixed time limit.
	// In that case you will have to contact your administrator if you experience timeout errors. 
	
	$MAX_CALCULATION_TIME = 0;
	
	
	// if you happen to get "error [unefined]" messages PHP probably does not have enough memory
	// to process the bitmap. Uncomment the following lines to give PHP 32MB.
	/*
	if( ini_get('safe_mode') ){
		if ($LOGGING) error_log( "WARNING: php safe mode is activated on this server, thus the memory limit can not be overridden. This might cause the script to quit prematurely on big images\n",3,$RELATIVE_SAVEPATH."be_log");
	}else{
		ini_set ( "memory_limit", "32M");
	}
	*/
	
	// if you are experiences errors, try to set $LOGGING to true. 
	// All errors/messages will be stored in $RELATIVE_SAVEPATH."be_log" in the same directory
	// as this file
	$LOGGING = false;
	
	// for debugging purposes only - if  KEEP_TEMP_FILES=true temporary files will not be deleted
	$KEEP_TEMP_FILES = false;
	
	error_reporting(E_ALL);
	set_error_handler("errorHandler");

	// If you use a https:// connection to save the bitmaps you will have to uncomment two of the header commands
	// in order to ensure that the script works in IE:
	
	header("Expires: Mon, 25 Jan 1970 05:00:00 GMT");   // comment this line out in https
	header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT"); 
    header("Cache-Control: no-store, no-cache, must-revalidate");  
	header("Cache-Control: post-check=0, pre-check=0", false);
	header("Pragma: no-cache");   // and comment this line out in https
	
	if( ini_get('safe_mode') ){
		if ($LOGGING) error_log( "WARNING: php safe mode is activated on this server, thus the script time limit can not be overridden. This might cause the script to quit prematurely on big images\n",3,$RELATIVE_SAVEPATH."be_log");
	}else{
		set_time_limit ( $MAX_CALCULATION_TIME );
	}
	
	
	$postsize=0;
	
	if ( isset( $_POST ) )
	{
		foreach ($_POST as $key => $value) 
		{
			$postsize += strlen($value);
		}
	}
	
	$mode = "";
	
	if ( isset( $_REQUEST["mode"] ) ) {
		$mode = $_REQUEST["mode"];
		if ($LOGGING) error_log( "mode: ".$mode."\n",3,$RELATIVE_SAVEPATH."be_log");
	}
	
	switch ($mode)
	{
		case "getImageHandle":
	
			$uniqueID = md5( microtime() . rand() );
			sendResult( "success=1&uniqueID=$uniqueID" );
		break;
		
		case "turboscan":
		
			$uniqueID     = $_POST["uniqueID"];
		 	$bitmapString = $_POST["bitmapString"];
			$data         = explode( ",", $bitmapString );
			
			$l            = count($data);
			$bitmapData   = "";	
			
			for ($i=0; $i<$l; $i++ )
			{
				$d = $data[$i];
				$bitmapData .= pack("nC", ($d >> 8) & 0xffff, $d & 0xff );
			}
			
			appendToTempFile( $uniqueID, $bitmapData );
			
			sendResult( "success=1&sentBytes=".$postsize );
			
		break;
	
		case "fastscan":
		
			$uniqueID     = $_POST["uniqueID"];
		 	$bitmapString = $_POST["bitmapString"];
			
			$data         = explode( ",", $bitmapString );
			$l            = count($data);
			$bitmapData   = "";	
			
			for ($i=0; $i<$l; $i++ )
			{
				$d = base_convert( $data[$i], 36, 10 );
				$bitmapData .= pack("nC", ($d >> 8) & 0xffff, $d & 0xff );
			}
			
			appendToTempFile( $uniqueID, $bitmapData );
			sendResult( "success=1&sentBytes=".$postsize );
		
		break;
	
		case "default":
			
	  		appendToTempFile( $_POST["uniqueID"], base64_decode( $_POST["bitmapString"] ) );
			sendResult( "success=1&sentBytes=".$postsize );		
		
		break;
		
		case "palette":
		
			
		 	$uniqueID      = $_POST["uniqueID"];
			$paletteString = $_POST["paletteString"];
		 	$bitmapString  = $_POST["bitmapString"];
			
			$bitmapString= base64_decode( $bitmapString );
			$l = strlen($bitmapString);
			$bitmapData = array();
			
			for ($i=0; $i<$l; $i++){
				$bitmapData[$i] = ord($bitmapString{$i});
			}
			
			$paletteString = base64_decode( $paletteString );
			$paletteData = array();
			$l = strlen($paletteString);
			$idx = 0;
			
			for ($i=0; $i<$l; $i+=3)
			{
				$paletteData[$idx++] = $paletteString{$i}.$paletteString{$i+1}.$paletteString{$i+2};
			}
			
			$idx = 0;
			$paletteIdx = 0;
			$decodedBitmap = "";	
			
			while ( $idx < count( $bitmapData ) ) 
			{
				$repeat = 2;
				if ( $bitmapData[$idx]==0x80 && $bitmapData[$idx+1]==0)
				{
					$repeat = 2 * ( ($bitmapData[$idx+2]<<8) + $bitmapData[$idx+3]);
					$idx+=4;
				} 
				
				$pointer = 0;
				while ($repeat>0)
				{
					$offset = ( ( $bitmapData[$idx + $pointer] << 8 ) + $bitmapData[ $idx+1+$pointer]);
					if ( $offset > 0x7fff ) $offset -= 0x10000;
					$paletteIdx += $offset;
					
					$decodedBitmap .=  $paletteData[$paletteIdx];
					$repeat--;
					$pointer = 2 - $pointer;
				}
				$idx+=4;
			}
			appendToTempFile( $uniqueID, $decodedBitmap );
			sendResult( "success=1&sentBytes=".$postsize );
		break;
		
		case "rgb_rle":
			$uniqueID = $_POST["uniqueID"];
		 	$rString = $_POST["red"];
			$gString = $_POST["green"];
			$bString = $_POST["blue"];
			
			$rString= base64_decode( $rString );
			$l = strlen($rString);
			$rData = array();
			for ($i=0; $i<$l; $i++){
				$rData[$i] = ord($rString{$i});
			}
			
			$gString= base64_decode( $gString );
			$l = strlen($gString);
			$gData = array();
			for ($i=0; $i<$l; $i++){
				$gData[$i] = ord($gString{$i});
			}
			
			$bString= base64_decode( $bString );
			$l = strlen($bString);
			$bData = array();
			for ($i=0; $i<$l; $i++){
				$bData[$i] = ord($bString{$i});
			}
			
			$pixels = array();
			$i_in = 0;
			$i_out = 0;
			$r = $rData[$i_in++];
			$pixels[$i_out++] = $r << 16;
			while ($i_in < count($rData))
			{
				if ( $rData[$i_in] == 0 )
				{
					if ( $rData[++$i_in] == 0 )
					{
						$count = $rData[++$i_in] | ( $rData[++$i_in] << 8 );
						$i_in++;
					} else {
						$count = $rData[$i_in++];
					}
					$p = $rData[$i_in++];
					for ( $i=0; $i < $count; $i++ )
					{
						$r = ( $r + $p ) & 0xff;
						$pixels[$i_out++] = $r << 16;
					}
				} else {
					$r = ( $r + $rData[$i_in++] ) & 0xff;
					$pixels[$i_out++] = $r << 16;
				}
			}
			
			$i_in = 0;
			$i_out = 0;
			$g = $gData[$i_in++];
			$pixels[$i_out++] |= $g << 8;
			while ($i_in < count($gData))
			{
				if ($gData[$i_in]==0)
				{
					if ( $gData[++$i_in]==0)
					{
						$count = $gData[++$i_in] | ( $gData[++$i_in] << 8 );
						$i_in++;
					} else {
						$count = $gData[$i_in++];
					}
					$p = $gData[$i_in++];
					for ($i=0;$i<$count;$i++)
					{
						$g = ( $g + $p ) & 0xff;
					
						$pixels[$i_out] |= $g << 8;
						$i_out++;
					}
				} else {
					$g = ( $g + $gData[$i_in++] ) & 0xff;
					$pixels[$i_out] |= $g << 8;
					$i_out++;
				}
			}
			
		 	$i_in = 0;
			$i_out = 0;
			$b = $bData[$i_in++];
			$d = $pixels[$i_out++];
			$bitmapData = pack("nC", ($d >> 8) & 0xffff, $b );
			
			while ($i_in < count($bData))
			{
				if ($bData[$i_in]==0)
				{
					if ( $bData[++$i_in]==0)
					{
						$count = $bData[++$i_in] | ( $bData[++$i_in] << 8);
						$i_in++;
					} else {
						$count = $bData[$i_in++];
					}
					$p = $bData[$i_in++];
					for ( $i=0; $i<$count; $i++ )
					{
						$b = ( $b + $p ) & 0xff;
						$d = $pixels[$i_out++];
						$bitmapData .= pack("nC", ($d >> 8) & 0xffff,$b );
					}
				} else {
					$b = ( $b + $bData[$i_in++] ) & 0xff;
					$d = $pixels[$i_out++] | $b;
					$bitmapData .= pack("nC", ($d >> 8) & 0xffff, $b );
				}
			}
			
			appendToTempFile( $uniqueID, $bitmapData );
			sendResult( "success=1&sentBytes=".$postsize );
		
		break;
		
		case "save":
		
			$width    = $_POST["width"];
			$height   = $_POST["height"];
			$uniqueID = $_POST["uniqueID"];
			$filename = $_POST["filename"];
			$quality  = $_POST["quality"];
			
			if ( $width <= 0 || $height <= 0 )
			{
				if ($LOGGING) error_log("Wrong width or height data submitted\n",3,$RELATIVE_SAVEPATH."be_log");
				sendResult( "success=0&error=".urlencode("Wrong width or height data submitted") );
			}
			
			$tempImagePath = $RELATIVE_SAVEPATH.$uniqueID.".tmp";
			checkTempImage();
			
			echo "keepalive&";
			flush();
			
			$_format = explode(  ".", $filename);
			$format  = strtolower( $_format[1] );
			
			$tempFileName = $_POST["uniqueName"].".".$format;
			
			switch ( $format )
			{
				case "bmp":
					$fp = fopen( $RELATIVE_SAVEPATH.$tempFileName, "w" );
					fputs( $fp, stringToBmp( file_get_contents( $tempImagePath ), $width, $height ) );
					fclose ( $fp );
					if (!$KEEP_TEMP_FILES) @unlink( $tempImagePath );
				break;
				
				case "png":
				case "jpg":
				case "jpeg":
					$fp = fopen( $RELATIVE_SAVEPATH.$tempFileName, "w" );
					fputs( $fp, stringToPNG( file_get_contents( $tempImagePath ), $width, $height ) );
					fclose ( $fp );
					if (!$KEEP_TEMP_FILES) @unlink( $tempImagePath );
					
					echo "keepalive&";
					flush();
					
					if ( $format  != "png")
					{
						if ( !function_exists("imagecreatefrompng") )
						{
							if ($LOGGING) error_log("No GD installed on Server\n",3,$RELATIVE_SAVEPATH."be_log");
							sendResult( "success=0&error=".urlencode("No GD installed on Server"), false );
						}
						
						$im = @imagecreatefrompng ( $RELATIVE_SAVEPATH.$tempFileName );
						
						if (!$im)
						{
							if ($LOGGING) error_log("Could not create GD-image: ".$php_errormsg."\n",3,$RELATIVE_SAVEPATH."be_log");
							sendResult( "success=0&error=".urlencode("Could not create GD-image (".$php_errormsg.")"), false );
						}
					
						if (!@imagejpeg ( $im , $RELATIVE_SAVEPATH.$tempFileName, $quality )){
							sendResult( "success=0&error=".urlencode("Could not generate JPEG file"), false );
						}
					 
					}
				break;	
				
				default:
				
					if ( $format != "jpg" && $format != "jpeg" && $format != "png" ){
						sendResult( "success=0&error=".urlencode("Desired file-format is not available (".$format.")"), false);	
					}	
				break;
			}
			
			$size = filesize( $RELATIVE_SAVEPATH.$tempFileName );
			if ($LOGGING) error_log("File ".$RELATIVE_SAVEPATH.$tempFileName." (".$size." Bytes) created\n",3,$RELATIVE_SAVEPATH."be_log");
			
			//sendResult( "success=1&url=".urlencode( $DOWNLOADURL.$tempFileName )."&filename=".urlencode($tempFileName)."&size=".$size, false );
			
		break;
		
	
		case "dropImageHandle":
		
			$uniqueID = $_POST["uniqueID"];
			
			$imageFilePath = $RELATIVE_SAVEPATH.$uniqueID.".tmp";
			
			if ( !$KEEP_TEMP_FILES && file_exists( $imageFilePath ) )
			{
				unlink( $imageFilePath );
			} 
			
			sendResult( "success=1" );
			
		break;
			
		case "":
			sendResult( "success=1" );
		break;
		
		case "download":
			$file = $RELATIVE_SAVEPATH.basename($_GET["name"]);
			if (isset($_GET["delete"]))
			{
				$deleteFile = ($_GET["delete"] == "1");
			}
			if (file_exists($file)) 
			{
				$_format = explode(  ".", $file);
				$format  = strtolower( $_format[1] );
					
				switch ( $format )
				{
					case "png":
						header ("Content-type: image/png");
						break;
						
					case "jpg":
					case "jpeg":
						header ("Content-type: image/jpeg");
						break;
						
					case "bmp":
						header ("Content-type: image/bmp");
						break;
						
					default:
						if ($LOGGING) error_log("Unknown filetype: ".$format, 3, $RELATIVE_SAVEPATH."be_log" );
						exit();
						break;
				}
				header("Content-Length: ".(string)(filesize($file)));
		     
				readfile( $file );
				if ($deleteFile) while(!unlink( $file ));  
			} else {
				if ($LOGGING) error_log($file." does not exist", 3, $RELATIVE_SAVEPATH."be_log" );
				exit();
			}
			
			cleanUpTempFolder();
		break;
		
		
		
		default:
			sendResult( "success=0&error=Unknown Command: ".$mode );
		break;
		
	}
	
	function sendResult( $data, $sendHeader=true, $exit = true )
	{
		if ($sendHeader) header( "content-length: ".strlen($data) );
		echo $data;
		if ($exit) exit();
	}

	function checkTempImage()
	{
		global $tempImagePath;
		
		if ( !file_exists( $tempImagePath ) )
		{
			sendResult( "success=0&error=".urlencode("No temporary image with provided uniqueID found: ".$tempImagePath) );
		}
	}
	
	function appendToTempFile( $uniqueID, $bitmapString )
	{
		global $RELATIVE_SAVEPATH, $LOGGING;
		
		if ( $LOGGING ) error_log( "appendToTempFile: ".$uniqueID." ".strlen( $bitmapString )." Bytes\n",3,$RELATIVE_SAVEPATH."be_log");
		
		if ( strlen( $bitmapString ) ==0 ) return;
		
		$tempImagePath = $RELATIVE_SAVEPATH.$uniqueID.".tmp";
		
		$fp = fopen( $tempImagePath, "ab+" );
			
		if ( !$fp )
		{
			sendResult( "success=0&error=".urlencode("Could not write to temporary file ".$tempImagePath ) );
		}
		
		fputs( $fp, $bitmapString );
		
		fclose ( $fp );
				
	}
	
	
	// stringToBmp function with kind permission 
	// by Patrick Mineault, http://www.5etdemi.com/
	// adapted to BitmapExporter data stream format
	
	function stringToBmp($stream, $width, $height)
	{
	//Bitmap header
	$bmpHeader = "BM";
	
	//Length is number of bytes + header size (54 bytes)
	$len = $width*$height*3;
	//write as little endian
	$bmpHeader .= pack("V", $len + 54);
	
	//Four empty bytes
	$bmpHeader .= "\0\0\0\0";
	//Offset to beginning of data
	$bmpHeader .= chr(54) . "\0\0\0";
	
	//Size of the bmpinfo header
	$bmpHeader .= chr(40) . "\0\0\0";
	//width
	$bmpHeader .= pack("V", $width);
	//height
	$bmpHeader .= pack("V", $height);
	//Number of biplanes
	$bmpHeader .= chr(1) . "\0";
	//Bits per pixel
	$bmpHeader .= chr(24) . "\0\0\0";
	//Compression type (0 = none)
	$bmpHeader .= "\0\0";
	//Image data size
	$bmpHeader .= pack("V", $len);
	//BiXPelsPerMeter & BiYPelsPerMeter (this is the value Fireworks writes)
	$bmpHeader .= pack("V", 2834) . pack("V", 2834);
	//Extra useless bytes
	$bmpHeader .= "\0\0\0\0\0\0\0\0";
	
	//Normalize the string so it's the right length, fill with white
	//pixels if necesary
	
	$idx = $width * $height + 1 ;
	
	$slicedStream = str_pad(strrev($stream), $len, str_repeat(chr(255), 1024));
	
	//And we're done
	return $bmpHeader . $slicedStream;
	}
	
	function stringToPNG($stream, $width, $height)
	{
		    $png = pack("V",0x474e5089);
	        $png .= pack("V",0x0a1a0a0d);
	       
	        $IHDR = pack("N", $width);
	        $IHDR .= pack("N", $height);
	        $IHDR .= pack("C",8); 
			$IHDR .= pack("C",2); 
			$IHDR .= pack("C",0);
			$IHDR .= pack("C",0);
	        $IHDR .= pack("C",0);
			
			$png .= pack("N", strlen($IHDR) );
			$png .= "IHDR";
			$png .= $IHDR;
			$png .= pack("N", crc32("IHDR".$IHDR));
	        
			$img = "";
			for ($i=0;$i<$height;$i++)
			{
				$img .= "\0".substr($stream,$i * $width*3,$width*3);
			}
			
			$img = gzcompress($img);
			$png .= pack("N", strlen($img) );
			$png .= "IDAT";
			$png .= $img;
			$png .= pack("N", crc32("IDAT".$img));
	        
			$png .= pack("N",0 );
			$png .= "IEND";
			$png .= pack("N", crc32("IEND"));
			
	        return $png;
	}
	
	function cleanUpTempFolder()
	{
		// The following routine will delete all orphan files from the
		// temp folder that are older than 1 day
		// Orphans can happen when the save routine got interrupted
		// and the dropImageHandle method hadn't been called:
	
		$days = 1;
		
		$dir = opendir( $RELATIVE_SAVEPATH );
		while( false !== ( $file = readdir( $dir ) ) )
		{
			$tsuffix = explode(".",$file);
			$suffix = $suffix[count($tsuffix)-1];
			if ( $suffix=="tmp" || $suffix=="png" || $suffix=="jpg" || $suffix=="jpeg" || $suffix=="bmp" )
			{
				$find_date = ( time() - filemtime($file) )/60/60/24;
				if( $find_date > $days )
				{
					while( !unlink($file) );
				}
			}
		}
		closedir($dir);	
		
	}
	
	function errorHandler($errno, $errstr, $errfile, $errline) 
	{
	  
	  switch ($errno) {
	 
	  case E_ERROR:
	  case E_USER_ERROR:
	   	$message = "ERROR [$errno] $errstr ";
	   	$message .= "in line $errline of file $errfile";
	   	$message .= ", PHP " . PHP_VERSION . " (" . PHP_OS . ")";
	   	break;
	   	
	  case E_WARNING:
	  case E_USER_WARNING:
	   	$message = "WARNING [$errno] $errstr";
	   	break;
	
	  case E_NOTICE:
	  case E_USER_NOTICE:
	   	$message = "NOTICE [$errno] $errstr";
	   	break;   	
	
	  default:
	   	$message =  "Unkown error type: [$errno] $errstr";
	   	break;
	  }
	  
	  sendResult( "success=0&error=".urlencode($message) );
	  
	}


?>