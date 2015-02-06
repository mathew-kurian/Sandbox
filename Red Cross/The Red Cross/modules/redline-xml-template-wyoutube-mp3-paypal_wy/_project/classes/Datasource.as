/**
 * Datasource
 * cascading XML files loader & parser...
 *
 * @version		1.0
 */
package _project.classes {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	//
	public class Datasource extends EventDispatcher {
		//private constants...
		private const __NODE_KINDS:Array = [ "attribute", "comment", "processing-instruction", "text" ];
		//private vars...
		private var __datasource:XML;
		private var __status:Object;
		//
		//constructor...
		public function Datasource(ignoreComments:Boolean, ignoreProcessingInstructions:Boolean, ignoreWhitespace:Boolean) {
			XML.ignoreComments = ignoreComments;
			XML.ignoreProcessingInstructions = ignoreProcessingInstructions;
			XML.ignoreWhitespace = ignoreWhitespace;
			//
			this.__status = { addfiles: undefined, fields: undefined, ready: false, tasks: undefined, url: { loader: undefined, request: undefined } };
		};
		//
		//private methods...
		private function __addfiles(xmlTarget:XML, arrayFields:Array, arrayTags:Array, intTag:int):void {
			if (!(xmlTarget is XML)) return;
			if (!(arrayTags is Array)) return;
			if (arrayTags.length < 1) return;
			if (isNaN(intTag)) return;
			if (intTag < 0) return;
			if (!(arrayTags[intTag] is String)) return;
			if (arrayTags[intTag] == "") return;
			var _xmllist:XMLList = xmlTarget.child(arrayTags[intTag]);
			if (!(_xmllist is XMLList)) return;
			intTag++;
			var _xml:XML;
			if (intTag < arrayTags.length) {
				for each (_xml in _xmllist) this.__addfiles(_xml, arrayFields, arrayTags, intTag);
			}
			else {
				for each (_xml in _xmllist) arrayFields.push(_xml);
			};
		};
		private function __htmlconvert(strText:String, sense:Boolean):String {
			if (!(strText is String)) return "";
			if (strText == "") return "";
			//
			var _after:int = (sense) ? 1 : 0;
			var _before:int = (sense) ? 0 : 1;
			var _html:Array = [["<b>", "{b}"], ["</b>", "{/b}"], 
							   ["<a>", "{a}"], ["</a>", "{/a}"], 
							   ["<br />", "{br /}"], ["<br/>", "{br/}"], 
							   ["<font>", "{font}"], ["</font>", "{/font}"], 
							   ["<i>", "{i}"], ["</i>", "{/i}"], 
							   ["<img />", "{img /}"], ["<img/>", "{img/}"], 
							   ["<li>", "{li}"], ["</li>", "{/li}"], 
							   ["<p>", "{p}"], ["</p>", "{/p}"], 
							   ["<span>", "{span}"], ["</span>", "{/span}"], 
							   ["<textformat>", "{textformat}"], ["</textformat>", "{/textformat}"], 
							   ["<u>", "{u}" ], [ "</u>", "{/u}"]];
			var _htmlattr:Array = [["<b ", "{b "], 
								   ["<a ", "{a "], 
								   ["<font ", "{font "], 
								   ["<i ", "{i "], 
								   ["<img ", "{img "], 
								   ["<li ", "{li "], 
								   ["<p ", "{p "], 
								   ["<span ", "{span "], 
								   ["<textformat ", "{textformat "], 
								   ["<u ", "{u "]];
			var _htmlclose:Array = [">", "}"];
			//
			for (var h in _html) strText = strText.split(_html[h][_before]).join(_html[h][_after]);
			for (var i in _htmlattr) {
				var _temp:Array = strText.split(_htmlattr[i][_before]);
				for (var j:int = 1; j < _temp.length; j++ ) {
					var _closure:int = _temp[j].indexOf(_htmlclose[_before]);
					if (_closure >= 0) _temp[j] = _temp[j].substr(0, _closure) + _htmlclose[_after] + _temp[j].substr(_closure + _htmlclose[_before].length);
				};
				strText = _temp.join(_htmlattr[i][_after]);
			};
			//
			return strText;
		};
		private function __load():void {
			if (this.__status.tasks.length > 0) {
				this.__status.url.request = new URLRequest(this.__status.tasks[0].path);
				this.__status.url.loader = new URLLoader(this.__status.url.request);
				this.__status.url.loader.addEventListener(Event.COMPLETE, this.__onComplete);
				this.__status.url.loader.addEventListener(IOErrorEvent.IO_ERROR, this.__onIoError);
			}
			else {
				this.__status.ready = true;
				this.dispatchEvent(new Event(Event.COMPLETE));
			};
		};
		private function __onComplete(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, this.__onComplete);
			var _doc:XML = new XML(this.__htmlconvert(this.__status.url.loader.data, true));
			if (!_doc) {
				this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
				if (!this.__datasource) return;
				this.__load();
			}
			else {
				if (!this.__datasource) {
					this.__datasource = _doc;
					if (this.__status.addfiles.length < 1) {
						this.__status.ready = true;
						this.dispatchEvent(new Event(Event.COMPLETE));
					}
					else {
						for (var i:int = 0; i < this.__status.addfiles.length; i++) this.__addfiles(this.__datasource, this.__status.fields, this.__status.addfiles[i], 0);
						for (var j:int = 0; j < this.__status.fields.length; j++) {
							var _exists:Boolean = false;
							for (var k:int = 0; k < this.__status.tasks.length && !_exists; k++) {
								if (String(this.__status.fields[j]) == this.__status.tasks[k].path) _exists = true;
							};
							if (_exists) this.__status.tasks[--k].fields.push(this.__status.fields[j])
							else this.__status.tasks.push( { fields: [this.__status.fields[j]], path: String(this.__status.fields[j]) } );
						};
						this.__load();
					};
				}
				else {
					for (var x:int = 0; x < this.__status.tasks[0].fields.length; x++) this.__status.tasks[0].fields[x].replace(0, _doc);
					this.__status.tasks.shift();
					this.__load();
				};
			};
		};
		private function __onIoError(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, this.__onIoError);
			if (!(this.__status.tasks is Array)) return;
			if (this.__status.tasks.length < 1) return;
			for (var x:int = 0; x < this.__status.tasks[0].fields.length; x++) this.__status.tasks[0].fields[x].replace(0, "");
			this.__status.tasks.shift();
			this.__load();
		};
		//
		//properties...
		public function get ready():Boolean {
			return this.__status.ready;
		};
		//
		//public methods...
		public function count(arrayGuides:Array):int {
			if (!(arrayGuides is Array)) return undefined;
			var _field = this.__datasource;
			for (var g:int = 0; g < arrayGuides.length && _field != undefined; g++) _field = _field[arrayGuides[g]];
			if (_field is XML) return 1
			else if (_field is XMLList) {
				var i:int = -1;
				while (_field[++i] != undefined);
				return i;
			};
			return undefined;
		};
		public function getField(arrayGuides:Array):* {
			if (!(arrayGuides is Array)) return undefined;
			var _field = this.__datasource;
			for (var g:int = 0; g < arrayGuides.length && _field != undefined; g++) _field = _field[arrayGuides[g]];
			if (!_field) return undefined;
			var _kind:String;
			try {
				_kind = _field.nodeKind();
				for (var i in this.__NODE_KINDS) {
					if (_kind == this.__NODE_KINDS[i]) return this.__htmlconvert(String(_field), false);
				};
			}
			catch (_error:Error) {
				//...
			};
			if (_field is XML) return ((_field.hasSimpleContent()) ? this.__htmlconvert(String(_field), false) : _field)
			else if (_field is XMLList) {
				var _result:Array = [];
				var _item:XML;
				for each (_item in _field.child(0)) {
					_kind = _item.nodeKind();
					var _valid:Boolean = false;
					for (var j in this.__NODE_KINDS) {
						if (_kind == this.__NODE_KINDS[j]) {
							_valid = true;
							break;
						};
					};
					_result.push((_valid) ? this.__htmlconvert(String(_item), false) : _item);
				};
				return ((_result.length > 1) ? _result : _result[0]);
			};
			return undefined;
		};
		public function setField(arrayGuides:Array, newValue:*):void {
			if (!(arrayGuides is Array)) return;
			var _field = this.__datasource;
			for (var g:int = 0; g < arrayGuides.length && _field != undefined; g++) _field = _field[arrayGuides[g]];
			if (_field is XML) _field.replace(0, newValue)
			else if (_field is XMLList) {
				var item:XML;
				for each (item in _field) item.replace(0, newValue);
			};
		};
		public function load(strPath:String, addFiles:Array = undefined):void {
			if (!(strPath is String)) return;
			if (!(addFiles is Array)) addFiles = [];
			this.__status.ready = false;
			this.__status.addfiles = new Array();
			this.__status.fields = new Array();
			this.__status.tasks = new Array();
			for (var i:int = 0; i < addFiles.length; i++) this.__status.addfiles.push(addFiles[i]);
			this.__status.url.request = new URLRequest(strPath);
			this.__status.url.loader = new URLLoader(this.__status.url.request);
			this.__status.url.loader.addEventListener(Event.COMPLETE, this.__onComplete);
			this.__status.url.loader.addEventListener(IOErrorEvent.IO_ERROR, this.__onIoError);
		};
	};
};