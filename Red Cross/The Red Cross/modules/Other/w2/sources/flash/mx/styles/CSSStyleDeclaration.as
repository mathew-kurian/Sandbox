class mx.styles.CSSStyleDeclaration
{
	var _tf;
	function CSSStyleDeclaration () {
	}
	function __getTextFormat(tf, bAll) {
		var _local5 = false;
		if (_tf != undefined) {
			var _local2;
			for (_local2 in mx.styles.StyleManager.TextFormatStyleProps) {
				if (bAll || (mx.styles.StyleManager.TextFormatStyleProps[_local2])) {
					if (tf[_local2] == undefined) {
						var _local3 = _tf[_local2];
						if (_local3 != undefined) {
							tf[_local2] = _local3;
						} else {
							_local5 = true;
						}
					}
				}
			}
		} else {
			_local5 = true;
		}
		return(_local5);
	}
	function getStyle(styleProp) {
		var _local2 = this[styleProp];
		var _local3 = mx.styles.StyleManager.getColorName(_local2);
		return(((_local3 == undefined) ? (_local2) : (_local3)));
	}
	static function classConstruct() {
		mx.styles.CSSTextStyles.addTextStyles(mx.styles.CSSStyleDeclaration.prototype, true);
		return(true);
	}
	static var classConstructed = classConstruct();
	static var CSSTextStylesDependency = mx.styles.CSSTextStyles;
}
