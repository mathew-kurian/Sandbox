class mx.managers.DepthManager
{
	var _childCounter, createClassObject, createObject, _parent, swapDepths, _topmost, getDepth;
	function DepthManager () {
		MovieClip.prototype.createClassChildAtDepth = createClassChildAtDepth;
		MovieClip.prototype.createChildAtDepth = createChildAtDepth;
		MovieClip.prototype.setDepthTo = setDepthTo;
		MovieClip.prototype.setDepthAbove = setDepthAbove;
		MovieClip.prototype.setDepthBelow = setDepthBelow;
		MovieClip.prototype.findNextAvailableDepth = findNextAvailableDepth;
		MovieClip.prototype.shuffleDepths = shuffleDepths;
		MovieClip.prototype.getDepthByFlag = getDepthByFlag;
		MovieClip.prototype.buildDepthTable = buildDepthTable;
		_global.ASSetPropFlags(MovieClip.prototype, "createClassChildAtDepth", 1);
		_global.ASSetPropFlags(MovieClip.prototype, "createChildAtDepth", 1);
		_global.ASSetPropFlags(MovieClip.prototype, "setDepthTo", 1);
		_global.ASSetPropFlags(MovieClip.prototype, "setDepthAbove", 1);
		_global.ASSetPropFlags(MovieClip.prototype, "setDepthBelow", 1);
		_global.ASSetPropFlags(MovieClip.prototype, "findNextAvailableDepth", 1);
		_global.ASSetPropFlags(MovieClip.prototype, "shuffleDepths", 1);
		_global.ASSetPropFlags(MovieClip.prototype, "getDepthByFlag", 1);
		_global.ASSetPropFlags(MovieClip.prototype, "buildDepthTable", 1);
	}
	static function sortFunction(a, b) {
		if (a.getDepth() > b.getDepth()) {
			return(1);
		}
		return(-1);
	}
	static function test(depth) {
		if (depth == reservedDepth) {
			return(false);
		}
		return(true);
	}
	static function createClassObjectAtDepth(className, depthSpace, initObj) {
		var _local1;
		switch (depthSpace) {
			case kCursor : 
				_local1 = holder.createClassChildAtDepth(className, kTopmost, initObj);
				break;
			case kTooltip : 
				_local1 = holder.createClassChildAtDepth(className, kTop, initObj);
				break;
		}
		return(_local1);
	}
	static function createObjectAtDepth(linkageName, depthSpace, initObj) {
		var _local1;
		switch (depthSpace) {
			case kCursor : 
				_local1 = holder.createChildAtDepth(linkageName, kTopmost, initObj);
				break;
			case kTooltip : 
				_local1 = holder.createChildAtDepth(linkageName, kTop, initObj);
				break;
		}
		return(_local1);
	}
	function createClassChildAtDepth(className, depthFlag, initObj) {
		if (_childCounter == undefined) {
			_childCounter = 0;
		}
		var _local3 = buildDepthTable();
		var _local2 = getDepthByFlag(depthFlag, _local3);
		var _local5 = "down";
		if (depthFlag == kBottom) {
			_local5 = "up";
		}
		var _local6;
		if (_local3[_local2] != undefined) {
			_local6 = _local2;
			_local2 = findNextAvailableDepth(_local2, _local3, _local5);
		}
		var _local4 = createClassObject(className, "depthChild" + (_childCounter++), _local2, initObj);
		if (_local6 != undefined) {
			_local3[_local2] = _local4;
			shuffleDepths(_local4, _local6, _local3, _local5);
		}
		if (depthFlag == kTopmost) {
			_local4._topmost = true;
		}
		return(_local4);
	}
	function createChildAtDepth(linkageName, depthFlag, initObj) {
		if (_childCounter == undefined) {
			_childCounter = 0;
		}
		var _local3 = buildDepthTable();
		var _local2 = getDepthByFlag(depthFlag, _local3);
		var _local5 = "down";
		if (depthFlag == kBottom) {
			_local5 = "up";
		}
		var _local6;
		if (_local3[_local2] != undefined) {
			_local6 = _local2;
			_local2 = findNextAvailableDepth(_local2, _local3, _local5);
		}
		var _local4 = createObject(linkageName, "depthChild" + (_childCounter++), _local2, initObj);
		if (_local6 != undefined) {
			_local3[_local2] = _local4;
			shuffleDepths(_local4, _local6, _local3, _local5);
		}
		if (depthFlag == kTopmost) {
			_local4._topmost = true;
		}
		return(_local4);
	}
	function setDepthTo(depthFlag) {
		var _local2 = _parent.buildDepthTable();
		var _local3 = _parent.getDepthByFlag(depthFlag, _local2);
		if (_local2[_local3] != undefined) {
			shuffleDepths(MovieClip(this), _local3, _local2, undefined);
		} else {
			this.swapDepths(_local3);
		}
		if (depthFlag == kTopmost) {
			_topmost = true;
		} else {
			delete _topmost;
		}
	}
	function setDepthAbove(targetInstance) {
		if (targetInstance._parent != _parent) {
			return(undefined);
		}
		var _local2 = targetInstance.getDepth() + 1;
		var _local3 = _parent.buildDepthTable();
		if ((_local3[_local2] != undefined) && (this.getDepth() < _local2)) {
			_local2 = _local2 - 1;
		}
		if (_local2 > highestDepth) {
			_local2 = highestDepth;
		}
		if (_local2 == highestDepth) {
			_parent.shuffleDepths(this, _local2, _local3, "down");
		} else if (_local3[_local2] != undefined) {
			_parent.shuffleDepths(this, _local2, _local3, undefined);
		} else {
			this.swapDepths(_local2);
		}
	}
	function setDepthBelow(targetInstance) {
		if (targetInstance._parent != _parent) {
			return(undefined);
		}
		var _local6 = targetInstance.getDepth() - 1;
		var _local3 = _parent.buildDepthTable();
		if ((_local3[_local6] != undefined) && (this.getDepth() > _local6)) {
			_local6 = _local6 + 1;
		}
		var _local4 = lowestDepth + numberOfAuthortimeLayers;
		var _local5;
		for (_local5 in _local3) {
			var _local2 = _local3[_local5];
			if (_local2._parent != undefined) {
				_local4 = Math.min(_local4, _local2.getDepth());
			}
		}
		if (_local6 < _local4) {
			_local6 = _local4;
		}
		if (_local6 == _local4) {
			_parent.shuffleDepths(this, _local6, _local3, "up");
		} else if (_local3[_local6] != undefined) {
			_parent.shuffleDepths(this, _local6, _local3, undefined);
		} else {
			this.swapDepths(_local6);
		}
	}
	function findNextAvailableDepth(targetDepth, depthTable, direction) {
		var _local5 = lowestDepth + numberOfAuthortimeLayers;
		if (targetDepth < _local5) {
			targetDepth = _local5;
		}
		if (depthTable[targetDepth] == undefined) {
			return(targetDepth);
		}
		var _local1 = targetDepth;
		var _local2 = targetDepth;
		if (direction == "down") {
			while (depthTable[_local2] != undefined) {
				_local2--;
			}
			return(_local2);
		}
		while (depthTable[_local1] != undefined) {
			_local1++;
		}
		return(_local1);
	}
	function shuffleDepths(subject, targetDepth, depthTable, direction) {
		var _local9 = lowestDepth + numberOfAuthortimeLayers;
		var _local8 = _local9;
		var _local5;
		for (_local5 in depthTable) {
			var _local7 = depthTable[_local5];
			if (_local7._parent != undefined) {
				_local9 = Math.min(_local9, _local7.getDepth());
			}
		}
		if (direction == undefined) {
			if (subject.getDepth() > targetDepth) {
				direction = "up";
			} else {
				direction = "down";
			}
		}
		var _local1 = new Array();
		for (_local5 in depthTable) {
			var _local7 = depthTable[_local5];
			if (_local7._parent != undefined) {
				_local1.push(_local7);
			}
		}
		_local1.sort(sortFunction);
		if (direction == "up") {
			var _local3;
			var _local11;
			do {
				if (_local1.length <= 0) { 
					break;
				}
				_local3 = _local1.pop();
			} while  (_local3 != subject);
			do {
				if (_local1.length <= 0) { 
					break;
				}
				_local11 = subject.getDepth();
				_local3 = _local1.pop();
				var _local4 = _local3.getDepth();
				if (_local11 > (_local4 + 1)) {
					if (_local4 >= 0) {
						subject.swapDepths(_local4 + 1);
					} else if ((_local11 > _local8) && (_local4 < _local8)) {
						subject.swapDepths(_local8);
					}
				}
				subject.swapDepths(_local3);
			} while  (_local4 != targetDepth);
		} else if (direction == "down") {
			var _local3;
			do {
				if (_local1.length <= 0) { 
					break;
				}
				_local3 = _local1.shift();
			} while  (_local3 != subject);
			do {
				if (_local1.length <= 0) { 
					break;
				}
				var _local11 = _local3.getDepth();
				_local3 = _local1.shift();
				var _local4 = _local3.getDepth();
				if ((_local11 < (_local4 - 1)) && (_local4 > 0)) {
					subject.swapDepths(_local4 - 1);
				}
				subject.swapDepths(_local3);
			} while  (_local4 != targetDepth);
		}
	}
	function getDepthByFlag(depthFlag, depthTable) {
		var _local2 = 0;
		if ((depthFlag == kTop) || (depthFlag == kNotopmost)) {
			var _local5 = 0;
			var _local7 = false;
			var _local8;
			for (_local8 in depthTable) {
				var _local9 = depthTable[_local8];
				var _local3 = typeof(_local9);
				if ((_local3 == "movieclip") || ((_local3 == "object") && (_local9.__getTextFormat != undefined))) {
					if (_local9.getDepth() <= highestDepth) {
						if (!_local9._topmost) {
							_local2 = Math.max(_local2, _local9.getDepth());
						} else if (!_local7) {
							_local5 = _local9.getDepth();
							_local7 = true;
						} else {
							_local5 = Math.min(_local5, _local9.getDepth());
						}
					}
				}
			}
			_local2 = _local2 + 20;
			if (_local7) {
				if (_local2 >= _local5) {
					_local2 = _local5 - 1;
				}
			}
		} else if (depthFlag == kBottom) {
			for (var _local8 in depthTable) {
				var _local9 = depthTable[_local8];
				var _local3 = typeof(_local9);
				if ((_local3 == "movieclip") || ((_local3 == "object") && (_local9.__getTextFormat != undefined))) {
					if (_local9.getDepth() <= highestDepth) {
						_local2 = Math.min(_local2, _local9.getDepth());
					}
				}
			}
			_local2 = _local2 - 20;
		} else if (depthFlag == kTopmost) {
			for (var _local8 in depthTable) {
				var _local9 = depthTable[_local8];
				var _local3 = typeof(_local9);
				if ((_local3 == "movieclip") || ((_local3 == "object") && (_local9.__getTextFormat != undefined))) {
					if (_local9.getDepth() <= highestDepth) {
						_local2 = Math.max(_local2, _local9.getDepth());
					}
				}
			}
			_local2 = _local2 + 100;
		}
		if (_local2 >= highestDepth) {
			_local2 = highestDepth;
		}
		var _local6 = lowestDepth + numberOfAuthortimeLayers;
		for (var _local9 in depthTable) {
			var _local4 = depthTable[_local9];
			if (_local4._parent != undefined) {
				_local6 = Math.min(_local6, _local4.getDepth());
			}
		}
		if (_local2 <= _local6) {
			_local2 = _local6;
		}
		return(_local2);
	}
	function buildDepthTable(Void) {
		var _local5 = new Array();
		var _local4;
		for (_local4 in this) {
			var _local2 = this[_local4];
			var _local3 = typeof(_local2);
			if ((_local3 == "movieclip") || ((_local3 == "object") && (_local2.__getTextFormat != undefined))) {
				if (_local2._parent == this) {
					_local5[_local2.getDepth()] = _local2;
				}
			}
		}
		return(_local5);
	}
	static var reservedDepth = 1048575;
	static var highestDepth = 1048574;
	static var lowestDepth = -16383;
	static var numberOfAuthortimeLayers = 383;
	static var kCursor = 101;
	static var kTooltip = 102;
	static var kTop = 201;
	static var kBottom = 202;
	static var kTopmost = 203;
	static var kNotopmost = 204;
	static var holder = _root.createEmptyMovieClip("reserved", reservedDepth);
	static var __depthManager = new mx.managers.DepthManager();
}
