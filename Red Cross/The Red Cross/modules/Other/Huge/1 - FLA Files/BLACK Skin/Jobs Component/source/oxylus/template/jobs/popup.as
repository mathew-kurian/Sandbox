import caurina.transitions.*;
import caurina.transitions.properties.FilterShortcuts;
import ascb.util.Proxy;
import oxylus.Utils;
import mx.events.EventDispatcher;
import caurina.transitions.properties.TextShortcuts;
import flash.net.FileReference;

class oxylus.template.jobs.popup extends MovieClip 
{
	public var node:XMLNode;
	public var settings:Object;
	public var idx:Number;
	
	private var bg:MovieClip;
	private var navigation:MovieClip;
		private var next:MovieClip;
		private var prev:MovieClip;
		private var navigationBg:MovieClip;
	private var content:MovieClip;
		private var title:MovieClip;
		private var holder:MovieClip;
			private var lst:MovieClip;
				private var subTitle:MovieClip;
				private var date:MovieClip;
				private var ht:MovieClip;
			private var mask:MovieClip;
			private var scroller:MovieClip;
				private var bar:MovieClip;
				private var stick:MovieClip;
		private var close:MovieClip;
		
		/**
		 * variables to handle the job application form
		 */
		private var apply:MovieClip;
		private var jobTitle:MovieClip;
		private var form:MovieClip;
			private var name:MovieClip;	
			private var email:MovieClip;	
			private var subject:MovieClip;	
			private var mes:MovieClip;	
			private var submit:MovieClip; 
			private var upload:MovieClip;
		
		private var fr:FileReference;	
		private var lv:LoadVars;
		private var $cript:String;
		private var $cript2:String;
	
	/**
	 * Exclusively for the scroller
	 */
	private var HitZone:MovieClip;
	private var ScrollArea:MovieClip;
	private var ScrollButton:MovieClip;
	private var ContentMask:MovieClip;
	private var Content:MovieClip;
	private var viewHeight:Number;
	private var totalHeight:Number;
	private var ScrollHeight:Number;
	private var scrollable:Boolean;
	
	/**
	 * Customizable variables
	 */
	private var blurAmountX:Number = 40;
	private var blurAmountY:Number = 0;
	private var animationTime:Number = .5;
	private var animationType:String = "easeOutQuart";
	
	private var fadeInTimeJob:Number = .5;
	
	public var addEventListener:Function;
    public var removeEventListener:Function;
    public var dispatchEvent:Function;
	
	public function popup() {
		TextShortcuts.init();
		FilterShortcuts.init();
		EventDispatcher.initialize(this);
		
		title = content["title"];
		holder = content["holder"];
		lst = holder["lst"];
		subTitle = lst["subTitle"];
			subTitle["txt"].selectable = false; 
			subTitle["txt"].autoSize = true;
			subTitle["txt"].wordWrap = true;
			subTitle["txt"]._width = 430;
		date = lst["date"];
			date["txt"].selectable = false; 
			date["txt"].autoSize = true;
		ht = lst["html"];
		mask = holder["mask"];
		scroller = holder["scroller"];
		bar = scroller["bar"];
		stick = scroller["stick"];
		mask._height += 4;
		stick._height = mask._height;
		Utils.initMhtf(ht["txt"], false);
		ht["txt"]._width = mask._width;
		close = content["close"];
		
		
		
		next = navigation["next"];
		prev = navigation["prev"];
		navigationBg = navigation["bg"];
		next._y = prev._y = Math.round(navigationBg._height / 2 - next._height / 2);
		next._x = Math.round(navigationBg._width - next._width - 8);
		
		navigation._x = Math.round(bg._width / 2 - navigation["bg"]._width / 2);
		navigation._y = Math.round(bg._height / 2 - navigation["bg"]._height / 2);
		
		close.onRollOver = Proxy.create(this, closeOnRollOver);
		close.onRollOut = Proxy.create(this, closeOnRollOut);
		close.onPress = Proxy.create(this, closeOnPress);
		
		next.onRollOver = Proxy.create(this, nextOnRollOver);
		next.onRollOut = Proxy.create(this, nextOnRollOut);
		next.onPress = Proxy.create(this, nextOnPress);
		
		prev.onRollOver = Proxy.create(this, prevOnRollOver);
		prev.onRollOut = Proxy.create(this, prevOnRollOut);
		prev.onPress = Proxy.create(this, prevOnPress);
		
		
		/**
		 * added variables to handle the job application form
		 */
		
		apply = content["apply"];
		jobTitle = content["jobTitle"]; jobTitle._visible = false; jobTitle._alpha = 0;
		jobTitle["txt"].selectable = false; 
		jobTitle["txt"].autoSize = true;
		
		form = content["form"]; form._visible = false; form._alpha = 0;
		submit = form["submit"];
		upload = form["upload"];
		name = form["name"]; name["txt"].restrict = "A-Za-z \\-.,'";
		email = form["email"]; email["txt"].restrict = "A-Za-z0-9!#$%&'*+\\-/=?\\^_`{|}~.@";
		subject = form["phone"]; subject["txt"].restrict = "0-9\\/-+*# ";
		mes = form["mes"];
		
		name["txt"].tabIndex = 1;
		email["txt"].tabIndex = 2;
		subject["txt"].tabIndex = 3;
		mes["txt"].tabIndex = 4;
		
		submit.onRollOver = Proxy.create(this, submitOnRollOver);
		submit.onRollOut = Proxy.create(this, submitOnRollOut);
		submit.onPress = Proxy.create(this, submitOnPress);
		
		upload.onRollOver = Proxy.create(this, uploadOnRollOver);
		upload.onRollOut = Proxy.create(this, uploadOnRollOut);
		upload.onPress = Proxy.create(this, uploadOnPress);
		
		apply.onRollOver = Proxy.create(this, applyOnRollOver);
		apply.onRollOut = Proxy.create(this, applyOnRollOut);
		apply.onPress = Proxy.create(this, applyOnPress);
		
		
		
		fr = new FileReference();
		fr.addListener(this);

		lv = new LoadVars();
		lv.onLoad = Proxy.create(this, lvll);
		
		
		
		TextField.prototype.setText2 = function(s:String) {
			Tweener.addTween(this, {_text:s, time:.5, transition:"easeoutquad"});
		};
		
		TextField.prototype.getText2 = function() {
			return this.text;
		};
		
		TextField.prototype.addProperty("text2", TextField.prototype.getText2, TextField.prototype.setText2);
	}
	
	
	/**
	 * function launched when pressing the submit button
	 */
	private function submitOnPress() {
		submitOnRollOut();
		
		if (!validFields()) {
			return;
		}
		
		disableAll();

		if(fr.name != null){
			sendFile();
		}
		else{
			sendText();
		}
	}
	
	
	/**
	 * actions for pressing the upload button
	 */
	private function uploadOnPress() {
		uploadOnRollOut();
		
		fr.browse();
	}
	
	private function lvll(s:Boolean)
	{
		if (!s) {
			form["status_txt"].text2 = "Could not send the message !";
		}
		else {
			clearAll();
			form["status_txt"].text2 = "Message sent successfully !";
			
			form["upload_txt"].text = " ";
		}
		
		enableAll();
			
	}
	
	private function onSelect() {
		form["upload_txt"].text = fr.name + " ( "+String(Math.round(fr.size/102.4)/10)+" KB ) ";
	}
	
	private function onHTTPError() {
		form["upload_txt"].text2 = "( onHTTPError ) Could not upload file. Please, try again later";
		enableAll();
	}
		
	private function onIOError() {
		form["upload_txt"].text2 = "( onIOError ) Could not upload file. Please, try again later";
		enableAll();
	}
	
	/**
	 * this will detect the uploading progress
	 * @param	xxx
	 * @param	bl
	 * @param	bt
	 */
	private function onProgress(xxx, bl, bt) {
		var per = "";
		if (!isNaN(bl) && !isNaN(bt) && bt>0) {
			per = String(Math.floor(100*bl/bt))+"%";
		}
		Tweener.removeTweens(apply["status_txt"]);
		form["status_txt"].text = "Uploading. Please wait . . . " + per;
	}
	
	/**
	 * this will send the file
	 */
	private function sendFile() {
		fr.upload($cript2);
		form["status_txt"].text2 = "Uploading, please wait...";
	}
	
	/**
	 * function executed when the upload completed
	 */
	private function onComplete() {
		sendText();
	}
	
	
	/**
	 * this will send the text
	 */
	private function sendText() {
		form["status_txt"].text2 = "Sending mes, please wait...";
		lv["name"] = name["txt"].text;
		lv["e-mail"] = email["txt"].text;
		lv["phone"] = subject["txt"].text;
		lv["mes"] = mes["txt"].text;
		lv["file"] = fr.name == null ? "nofile" : fr.name;
		lv["id"] = node.attributes.id;
		lv.sendAndLoad($cript, lv, "POST");
	}
	
	
	/**
	 * this will validate the fields
	 */
	private function validFields() {
		var str:String;
		str = name["txt"].text;
		
		if (Utils.remExtraSpace(str).length == 0) {
			form["status_txt"].text2 = "Please enter name";
			Selection.setFocus(name["txt"]);
			return false;
		}
		
		if (!Utils.isValidEmail(email["txt"].text)) {
			form["status_txt"].text2 = "Please enter a valid e-mail address";
			Selection.setFocus(email["txt"]);
			return false;
		}
		
		str = subject["txt"].text;
		if (Utils.remExtraSpace(str).length == 0) {
			form["status_txt"].text2 = "Please enter a valid phone number";
			Selection.setFocus(subject["txt"]);
			return false;
		}
		

		return true;
	}
	
	private function disableAll() {
		
		name["txt"].type = "dynamic";
		email["txt"].type = "dynamic";
		subject["txt"].type = "dynamic";
		mes["txt"].type = "dynamic";
		
		submit.enabled = false;
	}
	
	private function enableAll() {
		
		name["txt"].type = "input";
		email["txt"].type = "input";
		subject["txt"].type = "input";
		mes["txt"].type = "input";
		
		submit.enabled = true;
	}
	
	public function clearAll() {
		
		name["txt"].text = "";
		email["txt"].text = "";
		subject["txt"].text = "";
		mes["txt"].text = "";
		
	}
	
	/**
	 * actions for rolling over the apply button
	 */
	private function applyOnRollOver() {
		Tweener.addTween(apply , { _alpha:100, time: .2, transition: "linear" } );
	}
	
	/**
	 * actions for rolling out of the apply button
	 */
	private function applyOnRollOut() {
		Tweener.addTween(apply , { _alpha:50, time: .2, transition: "linear" } );
	}
	
	
	/**
	 * actions for pressing the apply button
	 */
	private function applyOnPress() {
		apply.onRollOver = apply.onRollOut = null;
		
		Tweener.addTween(title , { _alpha:0, time: fadeInTimeJob, transition: "linear" } );
		Tweener.addTween(navigation , { _alpha:0, time: fadeInTimeJob, transition: "linear" } );
		Tweener.addTween(holder , { _alpha:0, time: fadeInTimeJob, transition: "linear" } );
		Tweener.addTween(apply , { _alpha:0, time: fadeInTimeJob, transition: "linear", onComplete:Proxy.create(this, cancelApplyButton) } );
		
	}
	
	private function cancelApplyButton() {
		apply._visible = navigation._visible = title._visible = holder._visible = false;
	
		jobTitle._visible = form._visible = true;
		Tweener.addTween(jobTitle , { _alpha:100, time: fadeInTimeJob, transition: "linear" } );
		Tweener.addTween(form , { _alpha:100, time: fadeInTimeJob, transition: "linear" } );
	}
	
	private function nextOnPress() {
		dispatchEvent( { target:this, type:"popupNext", mc:this } );
	}
	
	private function prevOnPress() {
		dispatchEvent( { target:this, type:"popupPrev", mc:this } );
	}
	
	
	private function nextOnRollOver() {
		Tweener.addTween(next["over"] , { _alpha:100, time: .2, transition: "linear" } );
	}
	
	private function nextOnRollOut() {
		Tweener.addTween(next["over"] , { _alpha:0, time: .2, transition: "linear" } );
	}
	
	private function prevOnRollOver() {
		Tweener.addTween(prev["over"] , { _alpha:100, time: .2, transition: "linear" } );
	}
	
	private function prevOnRollOut() {
		Tweener.addTween(prev["over"] , { _alpha:0, time: .2, transition: "linear" } );
	}
	
	private function closeOnRollOver() {
		Tweener.addTween(close["over"] , { _alpha:100, time: .2, transition: "linear" } );
		Tweener.addTween(close["over"]["a"] , { _rotation:180, time: .2, transition: "linear" } );
		Tweener.addTween(close["normal"]["a"] , { _rotation:180, time: .2, transition: "linear" } );
	}
	
	private function closeOnRollOut() {
		Tweener.addTween(close["over"] , { _alpha:0, time: .2, transition: "linear" } );
		Tweener.addTween(close["over"]["a"] , { _rotation:0, time: .2, transition: "linear" } );
		Tweener.addTween(close["normal"]["a"] , { _rotation:0, time: .2, transition: "linear" } );
	}
	
	private function closeOnPress() {
		dispatchEvent( { target:this, type:"closePopup", mc:this } );
	}
	
	
	/**
	 * this will set the node
	 * @param	n
	 * @param	goJobScreen
	 */
	public function setNode(n:XMLNode, goJobScreen:Number) {
		node = n;
		
		title["txt"].autoSize = true;
		title["txt"].text = node.attributes.mainTitle;
		
		$cript = settings.text;
		$cript2 = settings.upload;
		
		if ($cript2.length == 0) {
			upload._visible = false;
		}
		
		if (goJobScreen == 1) {
			apply._visible = navigation._visible = title._visible = holder._visible = false;
			jobTitle._visible = form._visible = true;
			jobTitle._alpha = form._alpha = 100;
		}
		else {
			subTitle["txt"].text = node.attributes.title;
			date["txt"].text = node.attributes.date;
			date._y = Math.round(subTitle._y + subTitle._height);
			ht._y = Math.round(date._y + date._height);
			ht["txt"].htmlText = node.firstChild.nextSibling.firstChild.nodeValue;
			ScrollBox();
		}
		
		jobTitle["jobAp"].autoSize = true;
		jobTitle["jobAp"].text = node.attributes.contactTitle;
		jobTitle["txt"]._x = Math.round(jobTitle["jobAp"]._width);
		jobTitle["txt"].text = "(" + node.attributes.title + ")";
		Utils.TFTrim(jobTitle["txt"], jobTitle["txt"].text, 250, " . . . )");
		
		if (!node.nextSibling) {
			next.enabled = false;
			next._alpha = 50;
		}
		
		if (!node.previousSibling) {
			prev.enabled = false;
			prev._alpha = 50;
		}
		
			name["txt"].onSetFocus = function() {
			_global.myMAIN.killFullScreen();
		}
		
		email["txt"].onSetFocus = function() {
			_global.myMAIN.killFullScreen();
		}
		
		subject["txt"].onSetFocus = function() {
			_global.myMAIN.killFullScreen();
		}
		
		mes["txt"].onSetFocus = function() {
			_global.myMAIN.killFullScreen();
		}
		show();
	}
	
	private function show() {
		Utils.setMcBlur(this, 90, 0, 1);
		Tweener.addTween(this, { _x:0, _Blur_blurX:0, _Blur_blurY:0, time: animationTime, transition: animationType, rounded:true, onComplete:Proxy.create(this, showDone) } );
	}
	
	public function hideNext() {
		Tweener.addTween(this, { _x:Stage.width, _Blur_blurX:blurAmountX, _Blur_blurY:blurAmountY, time: animationTime, transition: animationType, rounded:true, onComplete:Proxy.create(this, removeMe) } );
	}
	
	public function hidePrev() {
		Tweener.addTween(this, { _x:-Stage.width, _Blur_blurX:blurAmountX, _Blur_blurY:blurAmountY, time: animationTime, transition: animationType, rounded:true, onComplete:Proxy.create(this, removeMe) } );
	}
	
	private function removeMe() {
		this.removeMovieClip();
	}
	
	private function showDone(){
		dispatchEvent( { target:this, type:"showDone", mc:this } );
	}
	
	private function submitOnRollOver() {
		Tweener.addTween(submit , { _alpha:100, time: .2, transition: "linear" } );
	}
	
	private function submitOnRollOut() {
		Tweener.addTween(submit , { _alpha:70, time: .2, transition: "linear" } );
	}
	
	private function uploadOnRollOver() {
		Tweener.addTween(upload , { _alpha:100, time: .2, transition: "linear" } );
	}
	
	private function uploadOnRollOut() {
		Tweener.addTween(upload , { _alpha:70, time: .2, transition: "linear" } );
	}
	
	
	/**
	 * this function will handle the scroller
	 */
	private function ScrollBox() {
		ScrollArea = stick;
		ScrollButton = bar;
		Content = lst;
		ContentMask = mask;
		
		HitZone = ContentMask.duplicateMovieClip("_hitzone_", this.getNextHighestDepth());
		HitZone._alpha = 0;
		HitZone._width = ContentMask._width;
		HitZone._height = ContentMask._height;
		Content.setMask(ContentMask);
		ScrollArea.onPress = Proxy.create(this, startScroll);
		ScrollArea.onRelease = ScrollArea.onReleaseOutside=Proxy.create(this, stopScroll);
		totalHeight = Content._height;
		scrollable = false;
		updateScrollbar();
		Mouse.addListener(this);
		
		ScrollButton.onRollOver = Proxy.create(this, barOnRollOver);
		ScrollButton.onRollOut = Proxy.create(this, barOnRollOut);
		ScrollButton.onPress = Proxy.create(this, startScroll);
		ScrollButton.onRelease = ScrollButton.onReleaseOutside= Proxy.create(this, stopScroll)
	}
	
	private function updateScrollbar() {
		viewHeight = ContentMask._height;
		
		var prop:Number = viewHeight/totalHeight;
		
		if (prop >= 1) {
			scrollable = false;
			scroller._alpha = 0
			ScrollArea.enabled = false;
			ScrollButton._y = 0;
			Content._y = 0;
			scroller._visible = false;
			mask._width += 24;
			ht["txt"]._width = mask._width;
		
		} else {
			scrollable = true;
			ScrollButton._visible = true;
			ScrollArea.enabled = true;
			ScrollButton._y = 0;
			scroller._alpha = 100
			ScrollHeight = ScrollArea._height - ScrollButton._height;
			
			if(lst._height-4<mask._height){
				scrollable = false;
				scroller._alpha = 0
				ScrollArea.enabled = false;
				ScrollButton._y = 0;
				Content._y = 0;
				scroller._visible = false;
				
				mask._width += 24;
				ht["txt"]._width = mask._width;
			}
			
			
			scroller._alpha = 100;
		}
	}
	
	private function startScroll() {
		var center:Boolean = !ScrollButton.hitTest(_level0._xmouse, _level0._ymouse, true);
		var sbx:Number = ScrollButton._x;
		if (center) {
			var sby:Number = ScrollButton._parent._ymouse-ScrollButton._height/2;
			sby<0 ? sby=0 : (sby>ScrollHeight ? sby=ScrollHeight : null);
			ScrollButton._y = sby;
		}

			
		ScrollButton.startDrag(false, sbx, 0, sbx, ScrollHeight);
		ScrollButton.onMouseMove = Proxy.create(this, updateContentPosition);
		updateContentPosition();
	}
	
	private function stopScroll() {
		ScrollButton.stopDrag();
		delete ScrollButton.onMouseMove;
		barOnRollOut();

	}
	
	private function updateContentPosition() {
		if (scrollable == true) {
			var contentPos:Number = (viewHeight-totalHeight)*(ScrollButton._y/ScrollHeight);
		this.onEnterFrame = function() {
			if (Math.abs(Content._y-contentPos)<1) {
				Content._y = contentPos;
				delete this.onEnterFRame;
				return;
			}
			Content._y += (contentPos - Content._y) / 4;
		};
		}
		else{
			Content._y = 0;
			delete Content.onEnterFRame;
		}
		
	}
	
	private function scrollDown() {
		var sby:Number = ScrollButton._y+ScrollButton._height/4;
		if (sby>ScrollHeight) {
			sby = ScrollHeight;
		}
		ScrollButton._y = sby;
		updateContentPosition();
	}
	
	private function scrollUp() {
		var sby:Number = ScrollButton._y-ScrollButton._height/4;
		if (sby<0) {
			sby = 0;
		}
		ScrollButton._y = sby;
		updateContentPosition();
	}
	
	private function onMouseWheel(delt:Number) {
		if (!HitZone.hitTest(_level0._xmouse, _level0._ymouse, true)) {
			return;
		}
		var dir:Number = delt/Math.abs(delt);
		if (dir<0) {
			scrollDown();
		} else {
			scrollUp();
		}
	}
	
	private function barOnRollOver() {
		Tweener.addTween(bar, { _alpha:60, time:0.15, transition:"linear" } );
	}
	
	private function barOnRollOut() {
		Tweener.addTween(bar, { _alpha:35, time:0.15, transition:"linear" } );
	}
	
}