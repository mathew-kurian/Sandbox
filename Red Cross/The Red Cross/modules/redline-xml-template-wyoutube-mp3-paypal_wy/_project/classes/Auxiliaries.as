/**
 * Auxiliaries
 * Auxiliaries implementation
 *
 * @version		1.0
 */
package _project.classes {
	use namespace AS3;
	//
	import _project.classes.Datasource;
	//
	public class Auxiliaries {
		//constants...
		private static const __KAMBIENT_OFF:String = "off";
		private static const __KNEWS:Object = { date: { begin: '<span class="date">', end: '</span>' }, separator: "<br />" };
		private static const __KTEAM:Object = { position: { begin: '<span class="position">', end: '</span>' } };
		//
		public static function xml2gallery(objDatasource:Datasource, arrayRoot:Array):Array {
			if (!(objDatasource is Datasource)) return undefined;
			if (!(arrayRoot is Array)) return undefined;
			var _gallery:Array = [];
			var i:int = 0;
			while (objDatasource.getField(arrayRoot.concat( [ "data", "item", i ] ))) {
				var _url:String = objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@url" ] ));
				if (_url is String) {
					if (_url != "") {
						var _hq:Boolean = false;
						try {
							_hq = objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@hq" ] )).toLowerCase() == "on";
						}
						catch (_error:Error) {
							//...
						};
						var _type:String = undefined;
						try {
							_type = objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@type" ] )).toLowerCase();
						}
						catch (_error:Error) {
							//...
						};
						var _item:Object = { id: i, 
											 info: objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@label" ] )), 
											 attributes: { hq: _hq,
														   notes: objDatasource.getField(arrayRoot.concat( [ "data", "item", i ] )),
														   itemid: objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@id" ] )),
														   itemprice: objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@price" ] )) },
											 thumb: objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@thumb" ] )),
											 type: _type,
											 url: _url };
						_gallery.push(_item);
					};
				};
				i++;
			};
			return _gallery;
		};
		public static function xml2minigallery(objDatasource:Datasource, arrayRoot:Array):Array {
			if (!(objDatasource is Datasource)) return undefined;
			if (!(arrayRoot is Array)) return undefined;
			var _minigallery:Array = [];
			var i:int = 0;
			while (objDatasource.getField(arrayRoot.concat( [ "data", "item", i ] ))) {
				var _info:String = objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@label" ] ));
				if (_info is String) {
					if (_info != "") {
						var _thumb:String = objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@thumb" ] ));
						if (!(_thumb is String)) _thumb = undefined
						else if (_thumb == "") _thumb = undefined;
						var _attributes:String = objDatasource.getField(arrayRoot.concat( [ "data", "item", i ] ));
						if (!(_attributes is String)) _attributes = "";
						var _item:Object = { id: i, 
											 info: _info, 
											 thumb: _thumb,
											 attributes: _attributes };
						_minigallery.push(_item);
					};
				};
				i++;
			};
			return _minigallery;
		};
		public static function xml2nav(objDatasource:Datasource, arrayRoot:Array):Array {
			if (!(objDatasource is Datasource)) return undefined;
			if (!(arrayRoot is Array)) return undefined;
			var _menu:Array = [];
			var i:int = 0;
			while (objDatasource.getField(arrayRoot.concat( [ "item", i ] ))) {
				var _info:String = objDatasource.getField(arrayRoot.concat( [ "item", i, "@label" ] ));
				if (_info is String) {
					if (_info != "") {
						var _item:Object = { id: i, info: _info };
						try {
							_item.node = Auxiliaries.xml2nav(objDatasource, arrayRoot.concat( [ "item", i ]));
						}
						catch (_error:Error) {
							//
						};
						try {
							_item.attributes = { align: objDatasource.getField(arrayRoot.concat( [ "item", i, "loadswf", "@align" ] )), //NOTE: "ambient" (an optional attribute of the <loadswf> XML's element) controls the external SWF alignment on screen...
												 ambientoff: (String(objDatasource.getField(arrayRoot.concat( [ "item", i, "loadswf", "@ambient" ] ))).toLowerCase() == Auxiliaries.__KAMBIENT_OFF), //NOTE: "ambient" (an optional attribute of the <loadswf> XML's element) controls the ambient music on/off status when an external SWF is loaded...
												 gallery: Auxiliaries.xml2gallery(objDatasource, arrayRoot.concat( [ "item", i, "gallery"])), 
												 link: objDatasource.getField(arrayRoot.concat( [ "item", i, "link"] )),
												 loadswf: objDatasource.getField(arrayRoot.concat( [ "item", i, "loadswf"] )),
												 minigallery: Auxiliaries.xml2minigallery(objDatasource, arrayRoot.concat( [ "item", i, "minigallery"])),
												 news: Auxiliaries.xml2news(objDatasource, arrayRoot.concat( [ "item", i, "news"])),
												 team: Auxiliaries.xml2team(objDatasource, arrayRoot.concat( [ "item", i, "team"])),
												 text: (_item.node.length < 1) ? objDatasource.getField(arrayRoot.concat( [ "item", i ] )) : undefined };
						}
						catch (_error:Error) {
							//
						};
						_menu.push(_item);
					};
				};
				i++;
			};
			return _menu;
		};
		public static function xml2news(objDatasource:Datasource, arrayRoot:Array):Array {
			if (!(objDatasource is Datasource)) return undefined;
			if (!(arrayRoot is Array)) return undefined;
			var _news:Array = [];
			var i:int = 0;
			while (objDatasource.getField(arrayRoot.concat( [ "data", "item", i ] ))) {
				var _info:String = objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@label" ] ));
				if (_info is String) {
					if (_info != "") {
						var _date:String = objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@date" ] ));
						if (!(_date is String)) _date = "";
						if (_date != "") {
							_date = Auxiliaries.__KNEWS.date.begin + _date + Auxiliaries.__KNEWS.date.end;
							_info = _date + Auxiliaries.__KNEWS.separator + _info;
						};
						var _thumb:String = objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@thumb" ] ));
						if (!(_thumb is String)) _thumb = undefined
						else if (_thumb == "") _thumb = undefined;
						var _item:Object = { id: i, 
											 info: _info, 
											 thumb: _thumb,
											 attributes: objDatasource.getField(arrayRoot.concat( [ "data", "item", i ] )) };
						_news.push(_item);
					};
				};
				i++;
			};
			return _news;
		};
		public static function xml2team(objDatasource:Datasource, arrayRoot:Array):Array {
			if (!(objDatasource is Datasource)) return undefined;
			if (!(arrayRoot is Array)) return undefined;
			var _team:Array = [];
			var i:int = 0;
			while (objDatasource.getField(arrayRoot.concat( [ "data", "item", i ] ))) {
				var _info:String = objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@label" ] ));
				if (_info is String) {
					if (_info != "") {
						var _position:String = objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@position" ] ));
						if (!(_position is String)) _position = "";
						var _thumb:String = objDatasource.getField(arrayRoot.concat( [ "data", "item", i, "@thumb" ] ));
						if (!(_thumb is String)) _thumb = undefined
						else if (_thumb == "") _thumb = undefined;
						var _attributes:String = objDatasource.getField(arrayRoot.concat( [ "data", "item", i ] ));
						if (!(_attributes is String)) _attributes = "";
						if (_position != "") {
							_position = Auxiliaries.__KTEAM.position.begin + _position + Auxiliaries.__KTEAM.position.end;
							if (_attributes != "") _position += "<br /><br /><br />";
						};
						_attributes = _position + _attributes;
						var _item:Object = { id: i, 
											 info: _info, 
											 thumb: _thumb,
											 attributes: _attributes };
						_team.push(_item);
					};
				};
				i++;
			};
			return _team;
		};
	};
};