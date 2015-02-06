class tm.utils.RegExp
{
	function RegExp () {
		if (arguments[0] == null) {
		} else {
			const = "RegExp";
			compile.apply(this, arguments);
		}
	}
	function invStr(sVal) {
		var _local5 = sVal;
		var _local4 = length(_local5);
		var _local1;
		var _local3;
		var _local6 = "";
		var _local2 = 1;
		while (_local2 < 255) {
			_local3 = chr(_local2);
			_local1 = 0;
			while ((_local1 <= _local4) && ((substring(_local5, 1 + (_local1++), 1)) != _local3)) {
			}
			if (_local1 > _local4) {
				_local6 = _local6 + _local3;
			}
			_local2++;
		}
		return(_local5);
	}
	function compile() {
		source = arguments[0];
		if (arguments.length > 1) {
			var _local17 = (arguments[1] + "").toLowerCase();
			var _local11 = 0;
			while (_local11 < length(_local17)) {
				if ((substring(_local17, _local11 + 1, 1)) == "g") {
					global = true;
				}
				if ((substring(_local17, _local11 + 1, 1)) == "i") {
					ignoreCase = true;
				}
				if ((substring(_local17, _local11 + 1, 1)) == "m") {
					multiline = true;
				}
				_local11++;
			}
		}
		if (arguments.length < 3) {
			var _local20 = true;
			_xrStatic = 1;
			var _local11 = 0;
		} else {
			var _local20 = false;
			_xr = _xrStatic++;
			var _local11 = arguments[2];
		}
		lastIndex = 0;
		var _local9 = source;
		var _local21;
		var _local14 = length(_local9);
		var _local6 = [];
		var _local4 = 0;
		var _local5;
		var _local8 = false;
		var _local16;
		var _local15;
		var _local18 = false;
		var _local19;
		for ( ; _local11 < _local14 ; _local11++) {
			var _local3 = substring(_local9, _local11 + 1, 1);
			if (_local3 == "\\") {
				_local11++;
				_local19 = false;
				_local3 = substring(_local9, _local11 + 1, 1);
			} else {
				_local19 = true;
			}
			var _local13 = substring(_local9, _local11 + 2, 1);
			_local6[_local4] = new Object();
			_local6[_local4].t = 0;
			_local6[_local4].a = 0;
			_local6[_local4].b = 999;
			_local6[_local4].c = -10;
			if (_local19) {
				if (_local3 == "(") {
					_local21 = new tm.utils.RegExp(_local9, (ignoreCase ? "gi" : "g"), _local11 + 1);
					_local11 = _xiStatic;
					_local6[_local4].t = 3;
					_local3 = _local21;
					_local13 = substring(_local9, _local11 + 2, 1);
				} else {
					if ((!_local20) && (_local3 == ")")) {
						break;
					}
					if (_local3 == "^") {
						if ((_local4 == 0) || (_local6[_local4 - 1].t == 7)) {
							_local6[_local4].t = 9;
							_local6[_local4].a = 1;
							_local6[_local4].b = 1;
							_local4++;
						}
					} else if (_local3 == "$") {
						if (_local20) {
							_local18 = true;
						}
					} else {
						if (_local3 == "[") {
							_local11++;
							if (_local13 == "^") {
								_local6[_local4].t = 2;
								_local11++;
							} else {
								_local6[_local4].t = 1;
							}
							_local3 = "";
							_local8 = false;
							while ((_local11 < _local14) && ((_local5 = substring(_local9, 1 + (_local11++), 1)) != "]")) {
								if (_local8) {
									if (_local5 == "\\") {
									}
									_local15 = ((_local5 == "\\") ? ((_local5 == "b") ? "\b" : (substring(_local9, 1 + (_local11++), 1))) : _local5);
									_local16 = ord(substring(_local3, length(_local3), 1)) + 1;
									_local5 = chr(_local16++);
									while (_local15 >= _local5) {
										_local3 = _local3 + _local5;
									}
									_local8 = false;
								} else if ((_local5 == "-") && (length(_local3) > 0)) {
									_local8 = true;
								} else if (_local5 == "\\") {
									_local5 = substring(_local9, 1 + (_local11++), 1);
									if (_local5 == "d") {
										_local3 = _local3 + "0123456789";
									} else if (_local5 == "D") {
										_local3 = _local3 + invStr("0123456789");
									} else if (_local5 == "s") {
										_local3 = _local3 + " \f\n\r\t\\";
									} else if (_local5 == "S") {
										_local3 = _local3 + invStr(" \f\n\r\t\\");
									} else if (_local5 == "w") {
										_local3 = _local3 + "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_";
									} else if (_local5 == "W") {
										_local3 = _local3 + invStr("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_");
									} else if (_local5 == "b") {
										_local3 = _local3 + "\b";
									} else if (_local5 == "\\") {
										_local3 = _local3 + _local5;
									}
								} else {
									_local3 = _local3 + _local5;
								}
							}
							if (_local8) {
								_local3 = _local3 + "-";
							}
							_local11--;
							_local13 = substring(_local9, _local11 + 2, 1);
						} else {
							if (_local3 == "|") {
								if (_local18) {
									_local6[_local4].t = 10;
									_local6[_local4].a = 1;
									_local6[_local4].b = 1;
									_local4++;
									_local6[_local4] = new Object();
									_local18 = false;
								}
								_local6[_local4].t = 7;
								_local6[_local4].a = 1;
								_local6[_local4].b = 1;
								_local4++;
								continue;
							}
							if (_local3 == ".") {
								_local6[_local4].t = 2;
								_local3 = newline;
							} else if (((_local3 == "*") || (_local3 == "?")) || (_local3 == "+")) {
								continue;
							}
						}
						// unexpected jump
						if ((_local3 >= "1") && (_local3 <= "9")) {
							_local6[_local4].t = 4;
						} else if (_local3 == "b") {
							_local6[_local4].t = 1;
							_local3 = "--wb--";
						} else if (_local3 == "B") {
							_local6[_local4].t = 2;
							_local3 = "--wb--";
						} else if (_local3 == "d") {
							_local6[_local4].t = 1;
							_local3 = "0123456789";
						} else if (_local3 == "D") {
							_local6[_local4].t = 2;
							_local3 = "0123456789";
						} else if (_local3 == "s") {
							_local6[_local4].t = 1;
							_local3 = " \f\n\r\t\\";
						} else if (_local3 == "S") {
							_local6[_local4].t = 2;
							_local3 = " \f\n\r\t\\";
						} else if (_local3 == "w") {
							_local6[_local4].t = 1;
							_local3 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_";
						} else if (_local3 == "W") {
							_local6[_local4].t = 2;
							_local3 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_";
						}
						if (_local13 == "*") {
							_local6[_local4].s = _local3;
							_local4++;
							_local11++;
						} else if (_local13 == "?") {
							_local6[_local4].s = _local3;
							_local6[_local4].b = 1;
							_local4++;
							_local11++;
						} else if (_local13 == "+") {
							_local6[_local4].s = _local3;
							_local6[_local4].a = 1;
							_local4++;
							_local11++;
						} else if (_local13 == "{") {
							var _local12 = false;
							var _local7 = 0;
							_local8 = "";
							_local11++;
							while (((_local11 + 1) < _local14) && ((_local5 = substring(_local9, 2 + (_local11++), 1)) != "}")) {
								if ((!_local12) && (_local5 == ",")) {
									_local12 = true;
									_local7 = Number(_local8);
									_local7 = Math.floor((isNaN(_local7) ? 0 : _local7));
									if (_local7 < 0) {
										_local7 = 0;
									}
									_local8 = "";
								} else {
									_local8 = _local8 + _local5;
								}
							}
							var _local10 = Number(_local8);
							_local10 = Math.floor((isNaN(_local10) ? 0 : _local10));
							if (_local10 < 1) {
								_local10 = 999;
							}
							if (_local10 < _local7) {
								_local10 = _local7;
							}
							_local6[_local4].s = _local3;
							_local6[_local4].b = _local10;
							_local6[_local4].a = (_local12 ? _local7 : _local10);
							_local4++;
						} else {
							_local6[_local4].s = _local3;
							_local6[_local4].a = 1;
							_local6[_local4].b = 1;
							_local4++;
						}
					}
				}
			} else if ((_local3 >= "1") && (_local3 <= "9")) {
				_local6[_local4].t = 4;
			} else if (_local3 == "b") {
				_local6[_local4].t = 1;
				_local3 = "--wb--";
			} else if (_local3 == "B") {
				_local6[_local4].t = 2;
				_local3 = "--wb--";
			} else if (_local3 == "d") {
				_local6[_local4].t = 1;
				_local3 = "0123456789";
			} else if (_local3 == "D") {
				_local6[_local4].t = 2;
				_local3 = "0123456789";
			} else if (_local3 == "s") {
				_local6[_local4].t = 1;
				_local3 = " \f\n\r\t\\";
			} else if (_local3 == "S") {
				_local6[_local4].t = 2;
				_local3 = " \f\n\r\t\\";
			} else if (_local3 == "w") {
				_local6[_local4].t = 1;
				_local3 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_";
			} else if (_local3 == "W") {
				_local6[_local4].t = 2;
				_local3 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_";
			}
			if (_local13 == "*") {
				_local6[_local4].s = _local3;
				_local4++;
				_local11++;
			} else if (_local13 == "?") {
				_local6[_local4].s = _local3;
				_local6[_local4].b = 1;
				_local4++;
				_local11++;
			} else if (_local13 == "+") {
				_local6[_local4].s = _local3;
				_local6[_local4].a = 1;
				_local4++;
				_local11++;
			} else if (_local13 == "{") {
				var _local12 = false;
				var _local7 = 0;
				_local8 = "";
				_local11++;
				while (((_local11 + 1) < _local14) && ((_local5 = substring(_local9, 2 + (_local11++), 1)) != "}")) {
					if ((!_local12) && (_local5 == ",")) {
						_local12 = true;
						_local7 = Number(_local8);
						_local7 = Math.floor((isNaN(_local7) ? 0 : _local7));
						if (_local7 < 0) {
							_local7 = 0;
						}
						_local8 = "";
					} else {
						_local8 = _local8 + _local5;
					}
				}
				var _local10 = Number(_local8);
				_local10 = Math.floor((isNaN(_local10) ? 0 : (_local10)));
				if (_local10 < 1) {
					_local10 = 999;
				}
				if (_local10 < _local7) {
					_local10 = _local7;
				}
				_local6[_local4].s = _local3;
				_local6[_local4].b = _local10;
				_local6[_local4].a = (_local12 ? (_local7) : (_local10));
				_local4++;
			} else {
				_local6[_local4].s = _local3;
				_local6[_local4].a = 1;
				_local6[_local4].b = 1;
				_local4++;
			}
		}
		if (_local20 && (_local18)) {
			_local6[_local4] = new Object();
			_local6[_local4].t = 10;
			_local6[_local4].a = 1;
			_local6[_local4].b = 1;
			_local4++;
		}
		if (!_local20) {
			_xiStatic = _local11;
			source = substring(_local9, arguments[2] + 1, _local11 - arguments[2]);
		}
		if (d) {
			_local11 = 0;
			while (_local11 < _local4) {
				trace((((((((("xr" + _xr) + " ") + _local6[_local11].t) + " : ") + _local6[_local11].a) + " : ") + _local6[_local11].b) + " : ") + _local6[_local11].s);
				_local11++;
			}
		}
		_xq = _local6;
		_xqc = _local4;
		_xp = 0;
	}
	function test() {
		if ((_xp++) == 0) {
			_xxa = [];
			_xxlp = 0;
		}
		var _local11 = arguments[0] + "";
		var _local15;
		var _local4 = _xq;
		var _local18 = _xqc;
		var _local14;
		var _local7;
		var _local8;
		var _local9;
		var _local13;
		var _local12 = length(_local11);
		var _local5 = (global ? (lastIndex) : 0);
		var _local21 = _local5;
		var _local19 = _local11;
		if (ignoreCase) {
			_local11 = _local11.toLowerCase();
		}
		var _local16 = new Object();
		_local16.i = -1;
		var _local3 = -1;
		while (_local3 < (_local18 - 1)) {
			_local3++;
			if (d) {
				trace("New section started at i=" + _local3);
			}
			_local5 = _local21;
			_local14 = _local3;
			_local4[_local14].c = -10;
			var _local20 = false;
			while ((_local3 > _local14) || (_local5 < (_local12 + 1))) {
				if (_local4[_local3].t == 7) {
					break;
				}
				if (_local4[_local3].t == 9) {
					_local3++;
					if (_local3 == (_local14 + 1)) {
						var _local17 = true;
						_local14 = _local3;
					}
					_local4[_local14].c = -10;
					continue;
				}
				if ((_local16.i >= 0) && (_local5 >= _local16.i)) {
					break;
				}
				if (_local4[_local3].c == -10) {
					if (d) {
						trace((((((("Lookup #" + _local3) + " at index ") + _local5) + " for \\\\\\\\\\\\\\\\'") + _local4[_local3].s) + "\\\\\\\\\\\\\\\\' type ") + _local4[_local3].t);
					}
					var _local6 = 0;
					_local4[_local3].i = _local5;
					if (_local4[_local3].t == 0) {
						_local7 = (ignoreCase ? (_local4[_local3].s.toLowerCase()) : (_local4[_local3].s));
						while ((_local6 < _local4[_local3].b) && (_local5 < _local12)) {
							if ((substring(_local11, 1 + _local5, 1)) == _local7) {
								_local6++;
								_local5++;
							} else {
								break;
							}
						}
					} else if (_local4[_local3].t == 1) {
						if (_local4[_local3].s == "--wb--") {
							_local4[_local3].a = 1;
							if ((_local5 > 0) && (_local5 < _local12)) {
								_local9 = substring(_local11, _local5, 1);
								if ((_local9 == " ") || (_local9 == "\\\\\\\\\\\\\\\\n")) {
									_local6 = 1;
								}
								if (_local6 == 0) {
									_local9 = substring(_local11, 1 + _local5, 1);
									if ((_local9 == " ") || (_local9 == "\\\\\\\\\\\\\\\\n")) {
										_local6 = 1;
									}
								}
							} else {
								_local6 = 1;
							}
						} else {
							_local7 = (ignoreCase ? (_local4[_local3].s.toLowerCase()) : (_local4[_local3].s));
							_local8 = length(_local7);
							var _local10;
							while ((_local6 < _local4[_local3].b) && (_local5 < _local12)) {
								_local9 = substring(_local11, 1 + _local5, 1);
								_local10 = 0;
								while ((_local10 <= _local8) && ((substring(_local7, 1 + (_local10++), 1)) != _local9)) {
								}
								if (_local10 <= _local8) {
									_local6++;
									_local5++;
								} else {
									break;
								}
							}
						}
					} else if (_local4[_local3].t == 2) {
						_local7 = (ignoreCase ? (_local4[_local3].s.toLowerCase()) : (_local4[_local3].s));
						_local8 = length(_local7);
						if (_local4[_local3].s == "--wb--") {
							_local4[_local3].a = 1;
							if ((_local5 > 0) && (_local5 < _local12)) {
								_local9 = substring(_local11, _local5, 1);
								_local13 = substring(_local11, 1 + _local5, 1);
								if ((((_local9 != " ") && (_local9 != "\\\\\\\\\\\\\\\\n")) && (_local13 != " ")) && (_local13 != "\\\\\\\\\\\\\\\\n")) {
									_local6 = 1;
								}
							} else {
								_local6 = 0;
							}
						} else {
							while ((_local6 < _local4[_local3].b) && (_local5 < _local12)) {
								_local9 = substring(_local11, 1 + _local5, 1);
								var _local10 = 0;
								while ((_local10 <= _local8) && ((substring(_local7, 1 + (_local10++), 1)) != _local9)) {
								}
								if (_local10 <= _local8) {
									break;
								}
								_local6++;
								_local5++;
							}
						}
					} else if (_local4[_local3].t == 10) {
						_local13 = substring(_local11, 1 + _local5, 1);
						_local6 = (((multiline && ((_local13 == "\\\\\\\\\\\\\\\\n") || (_local13 == "\\\\\\\\\\\\\\\\r"))) || (_local5 == _local12)) ? 1 : 0);
					} else if (_local4[_local3].t == 3) {
						_local15 = _local4[_local3].s;
						_local4[_local3].ix = [];
						_local4[_local3].ix[_local6] = _local5;
						_local15.lastIndex = _local5;
						while ((_local6 < _local4[_local3].b) && _local15.test(_local19)) {
							_local8 = length(_xxlm);
							if (_local8 > 0) {
								_local5 = _local5 + _local8;
								_local6++;
								_local4[_local3].ix[_local6] = _local5;
							} else {
								_local6 = _local4[_local3].a;
								_local4[_local3].ix[_local6 - 1] = _local5;
								break;
							}
						}
						if (_local6 == 0) {
							_xxlm = "";
						}
						if (_local15._xr > _xxlp) {
							_xxlp = _local15._xr;
						}
						_xxa[Number(_local15._xr)] = _xxlm;
					} else if (_local4[_local3].t == 4) {
						_local7 = Number(_local4[_local3].s);
						if (_xp >= _local7) {
							_local7 = _xxa[_local7];
							_local7 = (ignoreCase ? _local7.toLowerCase() : _local7);
							_local8 = length(_local7);
							_local4[_local3].ix = [];
							_local4[_local3].ix[_local6] = _local5;
							if (_local8 > 0) {
								while ((_local6 < _local4[_local3].b) && (_local5 < _local12)) {
									if ((substring(_local11, 1 + _local5, _local8)) == _local7) {
										_local6++;
										_local5 = _local5 + _local8;
										_local4[_local3].ix[_local6] = _local5;
									} else {
										break;
									}
								}
							} else {
								_local6 = 0;
								_local4[_local3].a = 0;
							}
						} else {
							_local7 = chr(_local7);
							_local4[_local3].ix = [];
							_local4[_local3].ix[_local6] = _local5;
							while ((_local6 < _local4[_local3].b) && (_local5 < _local12)) {
								if ((substring(_local11, 1 + _local5, 1)) == _local7) {
									_local6++;
									_local5++;
									_local4[_local3].ix[_local6] = _local5;
								} else {
									break;
								}
							}
						}
					}
					_local4[_local3].c = _local6;
					if (d) {
						trace(("   " + _local6) + " matches found");
					}
				}
				if (_local4[_local3].c < _local4[_local3].a) {
					if (d) {
						trace("   not enough matches");
					}
					if (_local3 > _local14) {
						_local3--;
						_local4[_local3].c--;
						if (_local4[_local3].c >= 0) {
							_local5 = (((_local4[_local3].t == 3) || (_local4[_local3].t == 4)) ? (_local4[_local3].ix[_local4[_local3].c]) : (_local4[_local3].i + _local4[_local3].c));
						}
						if (d) {
							trace((((("Retreat to #" + _local3) + " c=") + _local4[_local3].c) + " index=") + _local5);
						}
					} else {
						if (_xp > 1) {
							break;
						}
						if (_local17) {
							if (multiline) {
								do {
									if (_local5 > _local12) { 
										break;
									}
									_local13 = substring(_local11, 1 + (_local5++), 1);
								} while  (!((_local13 == "\\\\\\\\\\\\\\\\n") || (_local13 == "\\\\\\\\\\\\\\\\r")));
								_local4[_local3].c = -10;
							} else {
								break;
							}
						} else {
							_local5++;
							_local4[_local3].c = -10;
						}
					}
				} else {
					if (d) {
						trace("   enough matches!");
					}
					_local3++;
					if ((_local3 == _local18) || (_local4[_local3].t == 7)) {
						if (d) {
							trace((("Saving better result: r.i = q[" + _local14) + "].i = ") + _local4[_local14].i);
						}
						_local16.i = _local4[_local14].i;
						_local16.li = _local5;
						break;
					}
					_local4[_local3].c = -10;
				}
			}
			while ((_local3 < _local18) && (_local4[_local3].t != 7)) {
				_local3++;
			}
		}
		if (_local16.i < 0) {
			lastIndex = 0;
			if ((_xp--) == 1) {
				_xxa = [];
				_xxlp = 0;
			}
			return(false);
		}
		_local5 = _local16.li;
		_xi = _local16.i;
		_xxlm = substring(_local19, _local16.i + 1, _local5 - _local16.i);
		_xxlc = substring(_local19, 1, _local16.i);
		_xxrc = substring(_local19, _local5 + 1, _local12 - _local5);
		if (_local5 == _local16.i) {
			_local5++;
		}
		lastIndex = _local5;
		if ((_xp--) == 1) {
			lastMatch = _xxlm;
			leftContext = _xxlc;
			rightContext = _xxrc;
			_xaStatic = _xxa;
			lastParen = _xxa[Number(_xxlp)];
			_local3 = 1;
			while (_local3 < 10) {
				tm.utils.RegExp["$" + _local3] = _xaStatic[Number(_local3)];
				_local3++;
			}
		}
		return(true);
	}
	function exec() {
		var _local5 = arguments[0] + "";
		if (_local5 == "") {
			return(false);
		}
		var _local6 = test(_local5);
		if (_local6) {
			var _local7 = new Array();
			_local7.index = _xi;
			_local7.input = _local5;
			_local7[0] = lastMatch;
			var _local4 = _xaStatic.length;
			var _local3 = 1;
			while (_local3 < _local4) {
				_local7[_local3] = _xaStatic[Number(_local3)];
				_local3++;
			}
		} else {
			var _local7 = null;
		}
		return(_local7);
	}
	static function setStringMethods() {
		if (String.prototype.match != undefined) {
			return(undefined);
		}
		String.prototype.match = function () {
			if (typeof(arguments[0]) != "object") {
				return(null);
			}
			if (arguments[0].const != "RegExp") {
				return(null);
			}
			var _local3 = arguments[0];
			var _local5 = this.valueOf();
			var _local6 = 0;
			var _local4 = 0;
			if (_local3.global) {
				_local3.lastIndex = 0;
				while (_local3.test(_local5)) {
					if (_local4 == 0) {
						var _local7 = new Array();
					}
					_local7[_local4++] = tm.utils.RegExp.lastMatch;
					_local6 = _local3.lastIndex;
				}
				_local3.lastIndex = _local6;
			} else {
				var _local7 = _local3.exec(_local5);
				_local4++;
			}
			return(((_local4 == 0) ? null : (_local7)));
		};
		String.prototype.replace = function () {
			if (typeof(arguments[0]) != "object") {
				return(null);
			}
			if (arguments[0].const != "RegExp") {
				return(null);
			}
			var _local8 = arguments[0];
			var _local7 = arguments[1] + "";
			var _local11 = this;
			var _local12 = "";
			_local8.lastIndex = 0;
			if (_local8.global) {
				var _local13 = 0;
				var _local10 = 0;
				while (_local8.test(_local11)) {
					var _local5 = 0;
					var _local9 = length(_local7);
					var _local3 = "";
					var _local6 = "";
					var _local4 = "";
					while (_local5 < _local9) {
						_local3 = substring(_local7, 1 + (_local5++), 1);
						if ((_local3 == "$") && (_local6 != "\\")) {
							_local3 = substring(_local7, 1 + (_local5++), 1);
							if (isNaN(Number(_local3)) || (Number(_local3) > 9)) {
								_local4 = _local4 + ("$" + _local3);
							} else {
								_local4 = _local4 + tm.utils.RegExp._xaStatic[Number(_local3)];
							}
						} else {
							_local4 = _local4 + _local3;
						}
						_local6 = _local3;
					}
					_local12 = _local12 + ((substring(_local11, _local10 + 1, _local8._xi - _local10)) + _local4);
					_local10 = _local8._xi + length(tm.utils.RegExp.lastMatch);
					_local13 = _local8.lastIndex;
				}
				_local8.lastIndex = _local13;
			} else if (_local8.test(_local11)) {
				_local12 = _local12 + (tm.utils.RegExp.leftContext + _local7);
			}
			_local12 = _local12 + ((_local8.lastIndex == 0) ? (_local11) : (tm.utils.RegExp.rightContext));
			return(_local12);
		};
		String.prototype.search = function () {
			if (typeof(arguments[0]) != "object") {
				return(null);
			}
			if (arguments[0].const != "RegExp") {
				return(null);
			}
			var _local3 = arguments[0];
			var _local5 = this;
			_local3.lastIndex = 0;
			var _local4 = _local3.test(_local5);
			return((_local4 ? (_local3._xi) : -1));
		};
		String.prototype.old_split = String.prototype.split;
		String.prototype.split = function () {
			if ((typeof(arguments[0]) == "object") && (arguments[0].const == "RegExp")) {
				var _local3 = arguments[0];
				var _local8 = ((arguments[1] == null) ? 9999 : (Number(arguments[1])));
				if (isNaN(_local8)) {
					_local8 = 9999;
				}
				var _local6 = this;
				var _local9 = new Array();
				var _local5 = 0;
				var _local11 = _local3.global;
				_local3.global = true;
				_local3.lastIndex = 0;
				var _local7 = 0;
				var _local10 = 0;
				var _local4 = 0;
				while ((_local5 < _local8) && (_local3.test(_local6))) {
					if (_local3._xi != _local4) {
						_local9[_local5++] = substring(_local6, _local4 + 1, _local3._xi - _local4);
					}
					_local4 = _local3._xi + length(tm.utils.RegExp.lastMatch);
					_local10 = _local7;
					_local7 = _local3.lastIndex;
				}
				if (_local5 == _local8) {
					_local3.lastIndex = _local10;
				} else {
					_local3.lastIndex = _local7;
				}
				if (_local5 == 0) {
					_local9[_local5] = _local6;
				} else if ((_local5 < _local8) && (length(tm.utils.RegExp.rightContext) > 0)) {
					_local9[_local5++] = tm.utils.RegExp.rightContext;
				}
				_local3.global = _local11;
				return(_local9);
			}
			return(this.old_split(arguments[0], arguments[1]));
		};
		return(true);
	}
	var const = null;
	var source = null;
	var global = false;
	var ignoreCase = false;
	var multiline = false;
	var lastIndex = null;
	static var _xrStatic = null;
	var _xr = null;
	static var _xp = null;
	static var _xxa = null;
	static var _xxlp = null;
	var _xq = null;
	var _xqc = null;
	static var d = null;
	static var _xiStatic = null;
	var _xi = 0;
	static var _xxlm = null;
	static var _xxlc = null;
	static var _xxrc = null;
	static var lastMatch = null;
	static var leftContext = null;
	static var rightContext = null;
	static var _xa = new Array();
	static var lastParen = null;
	static var _xaStatic = new Array();
	static var $1 = null;
	static var $2 = null;
	static var $3 = null;
	static var $4 = null;
	static var $5 = null;
	static var $6 = null;
	static var $7 = null;
	static var $8 = null;
	static var $9 = null;
	static var _setString = setStringMethods();
}
