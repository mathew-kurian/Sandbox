class mx.skins.CustomBorder extends mx.skins.Border
{
	var __width, __height, l_mc, setSkin, minHeight, minWidth, m_mc, r_mc;
	function CustomBorder () {
		super();
	}
	function get width() {
		return(__width);
	}
	function get height() {
		return(__height);
	}
	function init(Void) {
		super.init();
	}
	function createChildren(Void) {
	}
	function draw(Void) {
		if (l_mc == undefined) {
			var _local2 = setSkin(tagL, leftSkin);
			if (horizontal) {
				minHeight = l_mc._height;
				minWidth = l_mc._width;
			} else {
				minHeight = l_mc._height;
				minWidth = l_mc._width;
			}
		}
		if (m_mc == undefined) {
			setSkin(tagM, middleSkin);
			if (horizontal) {
				minHeight = m_mc._height;
				minWidth = minWidth + m_mc._width;
			} else {
				minHeight = minHeight + m_mc._height;
				minWidth = m_mc._width;
			}
		}
		if (r_mc == undefined) {
			setSkin(tagR, rightSkin);
			if (horizontal) {
				minHeight = r_mc._height;
				minWidth = minWidth + r_mc._width;
			} else {
				minHeight = minHeight + r_mc._height;
				minWidth = r_mc._width;
			}
		}
		this.size();
	}
	function size(Void) {
		l_mc.move(0, 0);
		if (horizontal) {
			r_mc.move(width - r_mc.width, 0);
			m_mc.move(l_mc.width, 0);
			m_mc.setSize(r_mc.x - m_mc.x, m_mc.height);
		} else {
			r_mc.move(0, height - r_mc.height, 0);
			m_mc.move(0, l_mc.height);
			m_mc.setSize(m_mc.width, r_mc.y - m_mc.y);
		}
	}
	static var symbolName = "CustomBorder";
	static var symbolOwner = mx.skins.CustomBorder;
	static var version = "2.0.2.127";
	var className = "CustomBorder";
	static var tagL = 0;
	static var tagM = 1;
	static var tagR = 2;
	var idNames = new Array("l_mc", "m_mc", "r_mc");
	var leftSkin = "F3PieceLeft";
	var middleSkin = "F3PieceMiddle";
	var rightSkin = "F3PieceRight";
	var horizontal = true;
}
