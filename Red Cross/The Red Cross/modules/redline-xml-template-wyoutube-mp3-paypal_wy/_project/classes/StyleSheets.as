/**
 * StyleSheets
 * Html Texts  Style Sheets
 *
 * @version		1.0
 */
package _project.classes {
	import flash.text.StyleSheet;
	//
	public class StyleSheets {
		//private vars...
		private static var __list:Object = { 	news:		{	body: { tag: "body", style: { fontFamily: "_sans", fontSize: "12px", color: "#EEEEF7", leading: "-1px" } },
																a: { tag: "a", style: { fontSize: "12px", fontWeight: "bold", color: "#CCAAAA", textDecoration: "underline" } },
																a_hover: { tag: "a:hover", style: { color: "#AA8888" } },
																date: { tag: ".date", style: { fontSize: "16px", fontWeight: "bold", color: "#FFFFFF" } },
																title: { tag: ".title", style: { fontSize: "20px", fontWeight: "bold", color: "#FFFFFF" } }
															},
												minigallery:{	body: { tag: "body", style: { fontFamily: "_sans", fontSize: "12px", color: "#EEEEF7", leading: "-1px" } },
																a: { tag: "a", style: { fontSize: "12px", fontWeight: "bold", color: "#CCAAAA", textDecoration: "underline" } },
																a_hover: { tag: "a:hover", style: { color: "#AA8888" } },
																title: { tag: ".title", style: { fontSize: "20px", fontWeight: "bold", color: "#FFFFFF" } }
															},
												team:		{	body: { tag: "body", style: { fontFamily: "_sans", fontSize: "12px", color: "#EEEEF7", leading: "-1px" } },
																a: { tag: "a", style: { fontSize: "12px", fontWeight: "bold", color: "#CCAAAA", textDecoration: "underline" } },
																a_hover: { tag: "a:hover", style: { color: "#AA8888" } },
																position: { tag: ".position", style: { fontSize: "16px", fontWeight: "bold", color: "#FFFFFF" } },
																title: { tag: ".title", style: { fontSize: "20px", fontWeight: "bold", color: "#FFFFFF" } }
															},
												notes:		{	body: { tag: "body", style: { fontFamily: "_sans", fontSize: "11px", color: "#000000", leading: "-1px" } },
																itemid: { tag: ".itemid", style: { fontSize: "11px", fontWeight: "bold", color: "#000000" } },
																itemprice: { tag: ".itemprice", style: { fontSize: "11px", fontWeight: "bold", color: "#000000" } },
																a: { tag: "a", style: { fontSize: "12px", fontWeight: "bold", color: "#996666", textDecoration: "underline" } },
																a_hover: { tag: "a:hover", style: { color: "#775555" } },
																title: { tag: ".title", style: { fontSize: "14px", fontWeight: "bold" } }
															},
												title:		{ body: { tag: "body", style: { fontFamily: "_sans", fontSize: "28px", fontWeight: "normal", color: "#FFFFFF" } }
															},
												content:	{ body: { tag: "body", style: { fontFamily: "_sans", fontSize: "12px", color: "#EEEEF7", leading: "-1px" } },
															  a: { tag: "a", style: { fontSize: "12px", fontWeight: "bold", color: "#CCAAAA", textDecoration: "underline" } },
															  a_hover: { tag: "a:hover", style: { color: "#AA8888" } },
															  title: { tag: ".title", style: { fontSize: "18px", color: "#FFFFFF" } }
															}
											};
		//
		//public methods..
		public static function style(strTarget:String):StyleSheet {
			if (!(strTarget is String)) return undefined;
			if (strTarget == "") return undefined;
			//
			strTarget = strTarget.toLowerCase();
			for (var i in StyleSheets.__list) {
				if (strTarget == i) {
					var _target:Object = StyleSheets.__list[i];
					var _stylesheet:StyleSheet = new StyleSheet();
					for (var j in _target) {
						var _style:Object = { };
						for (var k in _target[j].style) _style[k] = _target[j].style[k];
						_stylesheet.setStyle(_target[j].tag, _style);
					};
					return _stylesheet;
				};
			};
			return undefined;
		};
	};
};