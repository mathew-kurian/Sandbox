class com.Interface extends com.oop.loaders.ContentLoader
{
    var r, config, configFile, stringRefClass, gotoStringFunct, mainBorderC, mainBgC, mainBorderCO, mainBgCO, soundBtn, soundEffect, music_mcs, nPreloads, qualityB, skipPages, animator, delayF, music, imgShowed, css, owner, bgListener, mainLoader, bgTypeDefault, bgImageDefault, bg, maskBook, book, preloader, maskPage, _alpha, _parent, link, music_mc, _type, img, popMenu, miniMusic_mc, gotoAndStop, control, onRollOut, txt, msgOver, msgOut, border, colorT, view, load, sound_temp, snd, write;
    function Interface(refClass, xmlFile, borderC, bgC, borderCO, bgCO, qty, skip, sound1, sound2, preloadsN)
    {
        super();
        r = _root;
        config = new com.oop.data.XmlDatum();
        configFile = xmlFile;
        stringRefClass = String(r) + "." + refClass;
        gotoStringFunct = stringRefClass + "." + "gotoPage";
        mainBorderC = borderC;
        mainBgC = bgC;
        mainBorderCO = borderCO;
        mainBgCO = bgCO;
        soundBtn = sound1;
        soundEffect = sound2;
        music_mcs = new Array();
        this.playSnd(soundBtn);
        nPreloads = preloadsN;
        qualityB = qty;
        skipPages = skip;
        delayF = 1 + animator.defaultIntervalTime / 100;
        animator = new com.oop.animation.Animator();
        music = new com.oop.data.Music();
        imgShowed = 1;
        Stage.align = "TL";
        Stage.scaleMode = "noScale";
        css = new TextField.StyleSheet();
        css.owner = this;
        css.onLoad = function ()
        {
            owner.importConfigData();
        };
        css.load("styles/main.css");
        bgListener = new Object();
        bgListener.owner = this;
        bgListener.onResize = function ()
        {
            owner.resizeSite();
        };
        Stage.addListener(bgListener);
    } // End of the function
    function importConfigData()
    {
        this.addLoader("<loader>Loading <loader_desc>Xml Data</loader_desc></loader>", r, 100, "init");
        config.loadDatum(configFile, mainLoader.bar);
    } // End of the function
    function loadBgDefault()
    {
        bgTypeDefault = config.itemFinder("backgrounds").childNodes[0].attributes.bgType;
        bgImageDefault = "backgrounds/" + config.itemFinder("backgrounds").childNodes[0].attributes.bgImg;
        bg = new com.Background();
        if (bgTypeDefault == "image")
        {
            bg.addImage(bgImageDefault);
        }
        else
        {
            bg.addPattern(bgImageDefault);
        } // end else if
        bg.bar_temp._visible = false;
    } // End of the function
    function addBg(img, _type)
    {
        if (img != bgImageDefault)
        {
            bgImageDefault = img;
            bgTypeDefault = _type;
            if (bgTypeDefault == "image")
            {
                bg.addImage(bgImageDefault);
            }
            else
            {
                bg.addPattern(bgImageDefault);
            } // end if
        } // end else if
    } // End of the function
    function init()
    {
        this.loadBgDefault();
        var _loc2 = config.itemFinder("music").childNodes[0].attributes.link;
        var _loc3 = config.itemFinder("music").childNodes[0].attributes.title;
        music.loadTrack(_loc2, _loc3);
        this.initBook();
        this.playMusic();
        this.setMusicBar(music_mcs[3]);
        maskBook = r.attachMovie("mask_book", "mask_book", 6);
        maskBook._height = book.chh;
        maskBook._width = maskBook._width * maskBook._yscale / 100;
        maskBook._x = (Stage.width - maskBook._width) / 2;
        maskBook._y = (Stage.height - maskBook._height) / 2;
        book.pages.setMask(maskBook);
        new com.oop.core.Watcher(maskBook, "end", true, maskBook, "removeMovieClip");
        this.preload();
    } // End of the function
    function initBook()
    {
        book = new com.Book("mybook", 1000, "cover_mc", "paper_mc", "grad_mc", "gradFlip_mc", this.compileData(), soundEffect, this, "pagesController");
        book.init();
        book.pages._quality = qualityB.toUpperCase();
        book.stop();
    } // End of the function
    function preload()
    {
        var _loc5 = new Array();
        if (config.img)
        {
            _loc5.push(config.img);
        } // end if
        var _loc7 = config.items;
        for (var _loc10 in _loc7)
        {
            var _loc2 = _loc7[_loc10].attributes.img;
            if (_loc2)
            {
                _loc5.push(_loc2);
            } // end if
            var _loc6 = _loc7[_loc10].childNodes;
            for (var _loc9 in _loc6)
            {
                _loc2 = _loc6[_loc9].attributes.img;
                if (_loc2)
                {
                    if (_loc6[_loc9].nodeName == "background")
                    {
                        _loc5.push("thumbs_bg/" + _loc2);
                    }
                    else
                    {
                        _loc5.push(_loc2);
                    } // end if
                } // end else if
                var _loc4 = _loc6[_loc9].childNodes;
                var _loc3 = 0;
                for (var _loc8 in _loc4)
                {
                    _loc2 = _loc4[_loc8].attributes.img;
                    if (_loc4[_loc8].nodeName == "image")
                    {
                        if (_loc2)
                        {
                            _loc5.push((_loc3 == 0 ? ("thumbs_b/") : ("thumbs/")) + _loc2);
                            _loc3 = _loc3 == 9 ? (0) : (_loc3 + 1);
                        } // end if
                        continue;
                    } // end if
                    if (_loc2)
                    {
                        _loc5.push(_loc2);
                    } // end if
                } // end of for...in
            } // end of for...in
        } // end of for...in
        this.addLoader("<loader>PREPARING TO PRELOAD GRAPHICS</loader>", book.pright.p1.content.view, 1000, undefined, book.pright.p1.content.mask);
        preloader = new com.oop.loaders.Preloader(mainLoader, _loc5, nPreloads, this, "start");
        preloader.init();
        _loc5 = new Array();
    } // End of the function
    function start()
    {
        mainLoader.removeMovieClip();
        this.addPopMenu();
        book.start();
        book.gotoPage(2);
        maskPage = r.attachMovie("mask_menupage", "mask_page", 6);
        maskPage._height = book.chh;
        maskPage._width = maskPage._width * maskPage._yscale / 100;
        maskPage._x = (Stage.width - maskPage._width) / 2;
        maskPage._y = (Stage.height - maskPage._height) / 2;
        book.pright.p3.content.view.setMask(maskPage);
        new com.oop.core.Watcher(maskPage, "end", true, maskPage, "removeMovieClip");
    } // End of the function
    function compileData()
    {
        var _loc3 = new Array();
        _loc3.push({path: this, funct: "createCover"});
        var _loc16 = "<title>MAINPAGE/</title><subtitle>MENU OPTIONS</subtitle>";
        var _loc20 = "<description>Click or drag the borders to turn the page</description>";
        _loc3.push({path: this, funct: "createLP", params: {title: _loc16, description: _loc20, img: config.img}});
        _loc3.push({path: this, funct: "createMenu"});
        var _loc14 = config.items;
        for (var _loc10 = 0; _loc10 < _loc14.length - 2; ++_loc10)
        {
            var _loc17 = _loc14[_loc10];
            switch (_loc17.nodeName)
            {
                case "contact":
                {
                    _loc16 = "<title>" + _loc17.attributes.title.toUpperCase() + "</title>";
                    _loc20 = "<description>" + (_loc17.attributes.description || " ") + "</description>";
                    _loc3.push({path: this, funct: "createLP", params: {title: _loc16, description: _loc20, img: _loc17.attributes.img}});
                    _loc3.push({path: this, funct: "createRPTC", params: {node: _loc17}});
                    break;
                } 
                case "clients":
                {
                    var _loc6 = _loc17.childNodes;
                    for (var _loc5 = 0; _loc5 < _loc6.length; ++_loc5)
                    {
                        var _loc11 = 0;
                        _loc16 = "<title>" + _loc17.attributes.title.toUpperCase() + "/</title>" + "<subtitle>" + _loc6[_loc5].attributes.title.toUpperCase() + "</subtitle>";
                        _loc20 = "<description>" + (_loc6[_loc5].attributes.description || " ") + "</description>";
                        _loc3.push({path: this, funct: "createLP", params: {title: _loc16, description: _loc20, img: _loc6[_loc5].attributes.img}});
                        var _loc9 = _loc6[_loc5].childNodes;
                        ++_loc11;
                        for (var _loc2 = 0; _loc2 < _loc9.length / 4; ++_loc2)
                        {
                            var _loc7 = _loc2 * 4;
                            _loc3.push({path: this, funct: "createPC", params: {node: _loc6[_loc5], start: _loc7, end: Number(_loc7 + 4)}});
                            ++_loc11;
                        } // end of for
                        if (!this.testSide(_loc11))
                        {
                            _loc3.push({path: this, funct: "createBlank"});
                        } // end if
                    } // end of for
                    break;
                } 
                case "portfolio":
                {
                    _loc6 = _loc17.childNodes;
                    for (var _loc5 = 0; _loc5 < _loc6.length; ++_loc5)
                    {
                        _loc11 = 0;
                        var _loc4 = _loc6[_loc5].childNodes;
                        for (var _loc2 = 0; _loc2 < _loc4.length; ++_loc2)
                        {
                            var _loc8 = _loc2 < 10 ? ("00" + _loc2.toString()) : ("0" + _loc2.toString());
                            _loc16 = "<title>" + _loc8 + "/</title>" + "<subtitle>" + _loc6[_loc5].attributes.title.toUpperCase() + "</subtitle>";
                            _loc20 = "<description>" + _loc4[_loc2].attributes.title + "</description>";
                            _loc3.push({path: this, funct: "createLPI", params: {node: _loc4[_loc2], title: _loc16, description: _loc20, img: "thumbs_b/" + _loc4[_loc2].attributes.img}});
                            ++_loc2;
                            _loc3.push({path: this, funct: "createRPI", params: {node: _loc6[_loc5], start: _loc2, end: Number(_loc2 + 9)}});
                            _loc2 = _loc2 + 8;
                            ++_loc11;
                        } // end of for
                    } // end of for
                    break;
                } 
                default:
                {
                    if (_loc14[_loc10].attributes.img && _loc14[_loc10].attributes.title)
                    {
                        _loc16 = "<title>" + _loc17.attributes.title.toUpperCase() + "</title>";
                        _loc20 = "<description>" + (_loc17.attributes.description || " ") + "</description>";
                        _loc3.push({path: this, funct: "createLP", params: {title: _loc16, description: _loc20, img: _loc17.attributes.img}});
                        _loc3.push({path: this, funct: "createRPT", params: {node: _loc17}});
                    }
                    else
                    {
                        _loc6 = _loc17.childNodes;
                        for (var _loc5 = 0; _loc5 < _loc6.length; ++_loc5)
                        {
                            _loc16 = "<title>" + _loc17.attributes.title.toUpperCase() + "/</title>" + "<subtitle>" + _loc6[_loc5].attributes.title.toUpperCase() + "</subtitle>";
                            _loc20 = "<description>" + (_loc6[_loc5].attributes.description || " ") + "</description>";
                            _loc3.push({path: this, funct: "createLP", params: {title: _loc16, description: _loc20, img: _loc6[_loc5].attributes.img}});
                            _loc3.push({path: this, funct: "createRPT", params: {node: _loc6[_loc5]}});
                        } // end of for
                    } // end else if
                    break;
                } 
            } // End of switch
        } // end of for
        _loc3.push(undefined);
        _loc3.push(undefined);
        return (_loc3);
    } // End of the function
    function addNavigation(place, compact)
    {
        var _loc8 = place.createEmptyMovieClip("menu", place.getNextHighestDepth());
        _loc8.compact = compact;
        var _loc10 = config.items;
        var _loc13 = "";
        var _loc2 = 5;
        var _loc3;
        var _loc7;
        for (var _loc6 = 0; _loc6 < _loc10.length - 2; ++_loc6)
        {
            var _loc4 = _loc10[_loc6];
            switch (_loc4.nodeName)
            {
                case "contact":
                {
                    _loc3 = this.addTree(_loc8, _loc4.attributes.title.toUpperCase(), _loc2);
                    if (!compact)
                    {
                        _loc2 = _loc2 + 2;
                    } // end if
                    break;
                } 
                case "clients":
                {
                    _loc3 = this.addTree(_loc8, _loc4.attributes.title.toUpperCase());
                    var _loc9 = _loc4.childNodes;
                    for (var _loc5 = 0; _loc5 < _loc9.length; ++_loc5)
                    {
                        _loc7 = this.addTreeChild(_loc3, _loc9[_loc5].attributes.title, _loc2);
                        _loc2 = _loc2 + (Math.ceil((_loc9[_loc5].childNodes.length - 4) / 8) * 2 + 2);
                    } // end of for
                    break;
                } 
                case "portfolio":
                {
                    _loc3 = this.addTree(_loc8, _loc4.attributes.title.toUpperCase());
                    _loc9 = _loc4.childNodes;
                    for (var _loc5 = 0; _loc5 < _loc9.length; ++_loc5)
                    {
                        _loc7 = this.addTreeChild(_loc3, _loc9[_loc5].attributes.title, _loc2);
                        _loc2 = _loc2 + (Math.ceil((_loc9[_loc5].childNodes.length - 10) / 10) * 2 + 2);
                    } // end of for
                    break;
                } 
                default:
                {
                    if (_loc10[_loc6].attributes.img && _loc10[_loc6].attributes.title)
                    {
                        _loc3 = this.addTree(_loc8, _loc4.attributes.title.toUpperCase(), _loc2);
                        _loc2 = _loc2 + 2;
                    }
                    else
                    {
                        _loc3 = this.addTree(_loc8, _loc4.attributes.title.toUpperCase());
                        _loc9 = _loc4.childNodes;
                        for (var _loc5 = 0; _loc5 < _loc9.length; ++_loc5)
                        {
                            _loc7 = this.addTreeChild(_loc3, _loc9[_loc5].attributes.title, _loc2);
                            _loc2 = _loc2 + 2;
                        } // end of for
                    } // end else if
                    break;
                } 
            } // End of switch
        } // end of for
        if (compact)
        {
            _loc3 = this.addTree(_loc8, "MAIN PAGE", 3);
        } // end if
        _loc8.hDefault = _loc8._height;
        return (_loc8);
    } // End of the function
    function addTree(place, msg, page)
    {
        var _loc10 = place._height;
        var _loc4 = place.createEmptyMovieClip("tree" + place.getNextHighestDepth(), place.getNextHighestDepth());
        var _loc5 = _loc4.createEmptyMovieClip("btn", 0);
        var _loc8 = _loc5.attachMovie("tree_icon", "icon", 0);
        var _loc6 = this.addText("<h2>" + msg + "</h2>", "p_txt", _loc5);
        _loc6._x = _loc8._width + 2;
        _loc6._y = (_loc8._height - _loc6._height) / 2;
        var _loc3 = _loc4.createEmptyMovieClip("childs", 1);
        _loc3.attachMovie("shape", "mask", 1);
        _loc3.txtField = this.addText(" ", "p_txt", _loc3);
        _loc3.txtField.write.selectable = false;
        _loc3.txtField.setMask(_loc3.mask);
        _loc4.StrChilds = "";
        _loc3._x = _loc6._x;
        _loc3._y = _loc8._height;
        _loc3.txtField._height = 0;
        _loc3.mask.hDefault = _loc3.mask._height = 5;
        _loc5.owner = this;
        _loc5.onRollOver = function ()
        {
            owner.playSnd(owner.soundBtn);
            _alpha = 70;
        };
        _loc5.onRollOut = function ()
        {
            _alpha = 100;
        };
        _loc5.onRelease = function ()
        {
            owner.playSnd(owner.soundBtn);
            if (page)
            {
                owner.gotoPage(page);
            }
            else if (_parent._parent.compact)
            {
                owner.setTree(_parent, true);
            }
            else
            {
                var _loc2 = owner.book.pagesPosition;
                for (var _loc3 in _loc2)
                {
                    if (_loc2[_loc3].p3.content.view.menu == _parent._parent)
                    {
                        owner.setTree(_parent, true);
                        continue;
                    } // end if
                    owner.setTree(_loc2[_loc3].p3.content.view.menu[_parent._name]);
                } // end of for...in
            } // end else if
        };
        if (page)
        {
            _loc8.gotoAndStop("none");
        } // end if
        _loc4._y = _loc10;
        _loc4.yDefault = _loc4._y;
        return (_loc4);
    } // End of the function
    function setTree(tree, animated)
    {
        var _loc2 = tree._parent;
        var _loc9 = tree.getDepth();
        var _loc6 = 300;
        for (var _loc14 in _loc2)
        {
            if (_loc2[_loc14] instanceof MovieClip)
            {
                var _loc5 = _loc2[_loc14].getDepth();
                var _loc3 = _loc2[_loc14].yDefault;
                if (_loc5 > _loc9)
                {
                    _loc3 = _loc2[_loc14].yDefault + tree.childs.txtField.write._height;
                } // end if
                if (animated)
                {
                    animator.tween(_loc2[_loc14], "_y", _loc2[_loc14]._y, _loc3, _loc6, "Linear", "easeIn");
                    continue;
                } // end if
                _loc2[_loc14]._y = _loc3;
            } // end if
        } // end of for...in
        var _loc10 = tree._parent.selected;
        _loc10.btn.enabled = true;
        _loc10.btn._alpha = 100;
        _loc10.btn.icon.gotoAndStop("close");
        tree.btn.enabled = false;
        tree.btn.icon.gotoAndStop("open");
        tree.childs.txtField._yscale = 100;
        if (animated)
        {
            animator.tween(_loc10.childs.mask, "_height", _loc10.childs.mask._height, 0, _loc6, "Linear", "easeIn");
            animator.tween(tree.childs.mask, "_height", tree.childs.mask._height, tree.childs.txtField.write._height, _loc6, "Linear", "easeIn");
        }
        else
        {
            _loc10.childs.mask._height = 0;
            tree.childs.mask._height = tree.childs.txtField.write._height;
        } // end else if
        tree._parent.selected = tree;
        if (_loc2.compact)
        {
            var _loc11 = _loc2._parent.info;
            var _loc8 = _loc2._parent.bg;
            var _loc12 = _loc2._parent.music_mc;
            trace (_loc8);
            var _loc15 = tree.childs.txtField.write._height;
            if (animated)
            {
                animator.tween(_loc11, "_y", _loc11._y, _loc11.yDefault + _loc15, _loc6, "Linear", "easeIn");
                animator.tween(_loc12, "_y", _loc12._y, _loc12.yDefault + _loc15, _loc6, "Linear", "easeIn");
                animator.tween(_loc8, "_height", _loc8._height, _loc8.hDefault + _loc15, _loc6, "Linear", "easeIn");
            }
            else
            {
                _loc11._y = _loc11.yDefault + _loc15;
                _loc12._y = _loc12.yDefault + _loc15;
                _loc8._height = _loc8.hDefault + _loc15;
            } // end else if
        }
        else
        {
            _loc15 = _loc2.hDefault + tree.childs.txtField.write._height;
            var _loc13 = _loc2._parent.header;
            var _loc16 = _loc2._parent.bgs;
            _loc3 = _loc13._y + _loc13._height + (_loc16._y - (_loc13._y + _loc13._height) - _loc15) / 2;
            if (animated)
            {
                animator.tween(_loc2, "_y", _loc2._y, _loc3, _loc6, "Linear", "easeIn");
            }
            else
            {
                _loc2._y = _loc3;
            } // end else if
        } // end else if
    } // End of the function
    function addTreeChild(place, msg, page)
    {
        place.StrChilds = place.StrChilds + ("<h2>- <a href=\'asfunction:" + gotoStringFunct + "," + page + "\'>" + msg + "</a></h2>");
        place.childs.txtField.write.htmlText = place.StrChilds;
        place.childs.mask._width = place.childs.txtField._width;
    } // End of the function
    function createBlank(place, params)
    {
        var _loc2 = this.addContainer(place);
    } // End of the function
    function createRPI(place, params)
    {
        var _loc6 = this.addContainer(place);
        var _loc19 = 2;
        var _loc11 = 1;
        var _loc18 = 0;
        var _loc7 = 0;
        var _loc22 = _loc6.mask._height / 3 - 1.075000E+002;
        for (var _loc3 = params.start; _loc3 < params.end; ++_loc3)
        {
            ++_loc7;
            var _loc2 = params.node.childNodes[_loc3];
            if (_loc2.nodeName == "image")
            {
                var thumb = _loc6.view.attachMovie("box_mc", "t" + _loc6.view.getNextHighestDepth(), _loc6.view.getNextHighestDepth());
                thumb.setColors(mainBorderC, mainBgC, mainBorderC);
                thumb.setMargins(2.500000E+000, 2.500000E+000, 6, 2.500000E+000, 0);
                thumb.setSize(105, 105 + _loc22);
                thumb._x = _loc11;
                thumb._y = _loc19;
                if (_loc7 > 2)
                {
                    _loc11 = 1;
                    ++_loc18;
                    _loc7 = 0;
                } // end if
                _loc11 = (thumb._width + 1) * _loc7 + 1;
                _loc19 = (thumb._height + 2) * _loc18 + 2;
                var _loc12 = "thumbs/" + _loc2.attributes.img;
                var _loc5 = this.addImg(thumb.view, _loc12, 100, 100);
                var _loc4 = this.addShape(thumb.view, "space", _loc5.mask._width, thumb._top, 0, _loc5.mask._height, this.hex(mainBorderC));
                var _loc13 = _loc3 < 10 ? (String("00" + _loc3)) : (String("0" + _loc3));
                var _loc14 = "<title>" + _loc13 + "</title>";
                var _loc16 = "<description>" + this.cutTxt(_loc2.attributes.title, 14) + "</description>";
                var _loc20 = "<a href=\'" + _loc2.attributes.link + "\'>" + _loc2.attributes.link + "</a>";
                var _loc9 = _loc6.mask._width - (_loc5.mask._width + _loc4._width + 10);
                var _loc10 = 6;
                var _loc17 = _loc4._y + _loc4._height + 4;
                var _loc8 = this.addText(_loc14, "title_txt", thumb.view, _loc10, _loc17, _loc9);
                var _loc21 = this.addText(_loc16, "p_txt", thumb.view, _loc10 + 1, _loc8._y + _loc8._height - 10, _loc9);
                this.addRollOver(thumb);
                thumb.owner = this;
                thumb.node = _loc2;
                thumb.onPress = function ()
                {
                    thumb.owner.loadImage(this);
                };
            } // end if
        } // end of for
    } // End of the function
    function createPC(place, params)
    {
        var _loc4 = this.addContainer(place);
        var _loc19 = 2;
        var _loc18 = _loc4.mask._height / 4 - 1.075000E+002;
        for (var _loc7 = params.start; _loc7 < params.end; ++_loc7)
        {
            var _loc3 = params.node.childNodes[_loc7];
            if (_loc3.nodeName == "client")
            {
                var _loc2 = _loc4.view.attachMovie("box_mc", "t" + _loc4.view.getNextHighestDepth(), _loc4.view.getNextHighestDepth());
                _loc2.setColors(mainBorderC, mainBgC, mainBorderC);
                _loc2.setMargins(2.500000E+000, 2.500000E+000, 2.500000E+000 + _loc18, 2.500000E+000, 0);
                _loc2.setSize(_loc4.mask._width - 4, 105 + _loc18);
                _loc2._x = 2;
                _loc2._y = _loc19;
                _loc19 = _loc4.view._height + 4;
                var _loc13 = _loc3.attributes.img;
                var _loc5 = this.addImg(_loc2.view, _loc13, 100, 100);
                var _loc10 = this.addShape(_loc2.view, "space", _loc2._left, _loc5.mask._height, _loc5.mask._width, 0, this.hex(mainBorderC));
                var _loc15 = "<title>" + _loc3.attributes.title + "</title>";
                var _loc17 = "<description>" + (_loc3.attributes.description || " ") + "</description>";
                var link = "<a>" + (_loc3.attributes.link || "No link available") + "</a>";
                var _loc14 = "<dateClient>" + (_loc3.attributes.date || " ") + "</dateClient>";
                var _loc9 = _loc4.mask._width - (_loc5.mask._width + _loc10._width + 10);
                var _loc8 = _loc5.mask._width + _loc10._width + 7;
                var _loc12 = this.addText(_loc15, "title_txt", _loc2.view, _loc8, 5, _loc9);
                var _loc11 = this.addText(_loc17, "p_txt", _loc2.view, _loc8 + 1, _loc12._y + _loc12._height - 10, _loc9);
                var _loc20 = this.addText(link, "p_txt", _loc2.view, _loc8 + 1, _loc11._y + _loc11._height - 2, _loc9);
                var _loc6 = this.addText(_loc14, "p_txt", _loc2.view, 0, 0);
                _loc6._x = _loc4.mask._width - _loc6._width - 10;
                _loc6._y = _loc5.mask._height - _loc6._height;
                if (_loc3.attributes.link)
                {
                    this.addRollOver(_loc2);
                    _loc2.link = _loc3.attributes.link;
                    _loc2.onPress = function ()
                    {
                        getURL(link, "_blank");
                    };
                    continue;
                } // end if
                _loc2.onPress = function ()
                {
                };
            } // end if
        } // end of for
    } // End of the function
    function createCover(place)
    {
        var _loc2 = this.addContainer(place);
        var _loc3 = this.addHeader(_loc2.view, _loc2.mask._width - 20);
        _loc3._x = (_loc2.mask._width - _loc3._width) / 2;
        _loc3._y = (_loc2.mask._height - _loc3._height) / 2 - 70;
    } // End of the function
    function createMenu(place)
    {
        var _loc2 = this.addContainer(place);
        var _loc3 = this.addHeader(_loc2.view, _loc2.mask._width - 20);
        var _loc4 = this.addNavigation(_loc2.view);
        var _loc5 = this.addBgBtns(_loc2.view, _loc2.mask._width - 40);
        _loc3._x = (_loc2.mask._width - _loc3._width) / 2;
        _loc4._x = (_loc2.mask._width - _loc4._width) / 2;
        _loc5._x = (_loc2.mask._width - _loc5._width) / 2;
        this.addMusicPlayer(_loc2.view);
        music_mcs.push(music_mc);
        music_mc._x = (_loc2.mask._width - music_mc._width) / 2 + 3;
        music_mc._y = _loc2.mask._height - music_mc._height + 3;
        music_mc.musicBars.play();
        _loc3._x = (_loc2.mask._width - _loc3._width) / 2;
        _loc3._y = 40;
        _loc5._y = music_mc._y - _loc5._height - music_mc.musicBars.h + music_mc.info._height;
        _loc4._y = _loc3._y + _loc3._height + (_loc5._y - (_loc3._y + _loc3._height) - _loc4.hDefault) / 2;
        this.setTree(_loc4.tree0);
    } // End of the function
    function createLP(place, params)
    {
        var _loc2 = this.addContainer(place);
        var _loc5 = this.addImg(_loc2.view, params.img, 320, 400);
        var _loc4 = this.addShape(_loc2.view, "space", _loc2.mask._width, _loc2._top, 0, _loc5.mask._height, this.hex(mainBorderC));
        var _loc3 = this.addText(params.title, "title_txt", _loc2.view, 5, _loc4._y + 5, _loc2.mask._width - 10);
        var _loc7 = this.addText(params.description, "p_txt", _loc2.view, 6, _loc3._y + _loc3._height - 10, _loc2.mask._width - 10);
        return (_loc2);
    } // End of the function
    function createLPI(place, params)
    {
        var _loc2 = this.createLP(place, params);
        this.addRollOver(_loc2);
        _loc2.owner = this;
        _loc2.node = params.node;
        _loc2.onPress = function ()
        {
            owner.loadImage(this);
        };
    } // End of the function
    function createRPTC(place, params)
    {
        var _loc2 = this.addContainer(place);
        var _loc4 = params.node;
        var _loc5 = _loc2.mask._width - 10;
        var _loc3 = this.addText(_loc4, "p_txt", _loc2.view, 0, 0, _loc5);
        _loc3._x = (_loc2.mask._width - _loc3._width) / 2;
        _loc3._y = (_loc2.mask._height - _loc3._height) / 2 - 10;
    } // End of the function
    function createRPT(place, params)
    {
        var _loc2 = this.addContainer(place);
        var _loc3 = params.node;
        var _loc5 = _loc2.mask._width - 20;
        var _loc4 = this.addText(_loc3, "p_txt", _loc2.view, 0, 0, _loc5);
        _loc4._x = 10;
        _loc2.view._y = _loc2.view._y + 10;
        _loc2.mask._y = _loc2.mask._y + 10;
        _loc2.mask._height = _loc2.mask._height - 19;
        _loc2.setScroll(true);
    } // End of the function
    function addHeader(place, w)
    {
        var _loc2 = place.createEmptyMovieClip("header", place.getNextHighestDepth());
        var _loc4 = "<mtitle>" + config.title.toUpperCase() + "</mtitle>";
        var _loc5 = "<mdescription>" + config.description + "</mdescription>";
        var _loc6 = this.addText(_loc4, "title_txt", _loc2, 0, 0, w);
        var _loc3 = this.addText(_loc5, "p_txt", _loc2, 0, 0, w);
        _loc3._y = _loc6._height - 10;
        return (_loc2);
    } // End of the function
    function addBgBtns(place, w)
    {
        var bgs = place.createEmptyMovieClip("bgs", place.getNextHighestDepth());
        var title = "<h2>Choose your favourite background</h2>";
        var btns = bgs.createEmptyMovieClip("btns", 0);
        var txt = this.addText(title, "p_txt", bgs, 0, 0);
        btns._y = txt._height;
        var items = this.config.itemFinder("backgrounds").childNodes;
        var t = Math.floor();
        var line = 0;
        var pos = 0;
        var i = 0;
        while (i < items.length)
        {
            var btn = btns.createEmptyMovieClip("btn" + i, i);
            var bg = btn.attachMovie("shape", "bg", 1);
            var pic = this.addImg(btn, "thumbs_bg/" + items[i].attributes.img);
            bg._width = pic._width + 2;
            bg._height = pic._height + 2;
            pic._x = pic._y = 1;
            btn.img = "backgrounds/" + items[i].attributes.bgImg;
            btn._type = items[i].attributes.bgType;
            btn.owner = this;
            btn.onPress = function ()
            {
                owner.addBg(img, _type);
            };
            btn.onRollOver = function ()
            {
                with (this.owner)
                {
                    setColor(this.bg, 16776960);
                    playSnd(soundBtn);
                } // End of with
            };
            btn.onRollOut = function ()
            {
                owner.setColor(bg, 0);
            };
            btn._x = pos * (btn._width + 3);
            btn._y = line * (btn._height + 3);
            if (pos >= w / Math.floor(btn._width + 3) - 1)
            {
                ++line;
                pos = 0;
            }
            else
            {
                ++pos;
            } // end else if
            ++i;
        } // end while
        txt._x = (bgs._width - txt._width) / 2;
        return (bgs);
    } // End of the function
    function addContainer(clip)
    {
        var _loc3 = clip.bg;
        var _loc2 = clip.attachMovie("box_mc", "content", 1);
        _loc2.setColors(mainBorderC, mainBgC, mainBorderC);
        _loc2.setMargins(2.500000E+000, 2.500000E+000, 2.500000E+000, 2.500000E+000, 0);
        _loc2.setSize(324, 456);
        _loc2._x = (_loc3._width - _loc2._width) / 2;
        _loc2._y = (_loc3._height - _loc2._height) / 2;
        return (_loc2);
    } // End of the function
    function setPopMenu(val)
    {
        _global.clearTimeout(popMenu.intT);
        _global.clearTimeout(popMenu.intS);
        _global.clearTimeout(popMenu.intSet);
        _global.clearTimeout(popMenu.intV);
        _global.clearTimeout(popMenu.int);
        _global.clearInterval(popMenu.intTest);
        popMenu.show = false;
        popMenu.swapDepths(-1);
        book.run();
        var _loc3 = -book.cww;
        var _loc4 = -book.cww + popMenu.btn._width;
        if (val == true)
        {
            if (!music._on)
            {
                miniMusic_mc.speaker_btn.control.p._visible = false;
                miniMusic_mc.speaker_btn.control.s._visible = true;
            }
            else
            {
                miniMusic_mc.speaker_btn.control.s._visible = false;
                miniMusic_mc.speaker_btn.control.p._visible = true;
            } // end else if
            popMenu.show = true;
            if (popMenu._x != _loc3)
            {
                popMenu._visible = true;
                animator.tween(popMenu, "_x", popMenu._x, _loc3, 500, "Quad", "easeOut");
            } // end if
        }
        else if (val == false)
        {
            if (popMenu._x != _loc4)
            {
                animator.tween(popMenu, "_x", popMenu._x, _loc4, 300, "Quad", "easeOut");
                popMenu.int = _global.setTimeout(this, "setPopMenu", 420);
            }
            else
            {
                popMenu._visible = false;
            } // end else if
        }
        else
        {
            popMenu._visible = false;
        } // end else if
    } // End of the function
    function testOnPopMenu()
    {
        if (popMenu._xmouse > -20 && popMenu._xmouse < popMenu._width && popMenu._ymouse > -20 && popMenu._ymouse < popMenu._height + 20)
        {
            book.stop();
        }
        else if (!book.pages.onMouseMove)
        {
            book.run();
        } // end else if
    } // End of the function
    function openPopMenu(open, show)
    {
        _global.clearTimeout(popMenu.intT);
        _global.clearTimeout(popMenu.intS);
        _global.clearTimeout(popMenu.intSet);
        _global.clearTimeout(popMenu.intV);
        _global.clearTimeout(popMenu.intVV);
        _global.clearTimeout(popMenu.int);
        _global.clearInterval(popMenu.intTest);
        popMenu.open = undefined;
        var _loc3 = -book.cww - popMenu.bg._width;
        var _loc4 = -book.cww - 20;
        var _loc5 = show ? (-book.cww) : (-book.cww + popMenu.btn._width);
        if (open)
        {
            popMenu.intTest = _global.setInterval(this, "testOnPopMenu", 40);
            book.stop();
            popMenu.menu._visible = true;
            popMenu.music_mc._visible = true;
            popMenu.swapDepths(-1);
            animator.tween(popMenu, "_x", popMenu._x, _loc3, 100, "Quad", "easeOut");
            popMenu.intT = _global.setTimeout(animator, "tween", 140, popMenu, "_x", _loc3, _loc4, 200, "Quad", "easeOut");
            popMenu.intS = _global.setTimeout(popMenu, "swapDepths", 140, book.pages.getNextHighestDepth());
            popMenu.intSet = _global.setTimeout(this, "setProp", 420, popMenu, "open", true);
        }
        else
        {
            _global.clearInterval(popMenu.intTest);
            book.run();
            popMenu.menu._visible = true;
            popMenu.music_mc._visible = true;
            popMenu.swapDepths(book.pages.getNextHighestDepth());
            animator.tween(popMenu, "_x", _loc4, _loc3, 100, "Quad", "easeOut");
            popMenu.intT = _global.setTimeout(animator, "tween", 140, popMenu, "_x", _loc3, _loc5, 200, "Quad", "easeOut");
            popMenu.intS = _global.setTimeout(popMenu, "swapDepths", 140, -1);
            popMenu.intSet = _global.setTimeout(this, "setProp", 420, popMenu, "open", false);
            popMenu.intV = _global.setTimeout(this, "setProp", 420, popMenu.menu, "_visible", false);
            popMenu.intVV = _global.setTimeout(this, "setProp", 420, popMenu.music_mc, "_visible", false);
        } // end else if
    } // End of the function
    function setProp(path, prop, val)
    {
        path[prop] = val;
    } // End of the function
    function gotoPage(i)
    {
        if (book.pleft.num != i && book.pright.num != i)
        {
            _global.clearInterval(popMenu.intTest);
            book.run();
            this.setPopMenu(true);
            book.gotoPage(i, skipPages);
        } // end if
    } // End of the function
    function addMiniMusicBox(place)
    {
        miniMusic_mc = place.createEmptyMovieClip("music_mc", place.getNextHighestDepth());
        var _loc4 = miniMusic_mc.attachMovie("prev_btn", "prev_btn", 0);
        var _loc3 = miniMusic_mc.attachMovie("next_btn", "next_btn", 1);
        _loc3._x = miniMusic_mc._width + 3;
        var _loc2 = miniMusic_mc.attachMovie("speaker_btn", "speaker_btn", 2);
        _loc2._x = miniMusic_mc._width + 8;
        _loc2._y = (_loc3._height - _loc2._height) / 2;
        _loc4.owner = this;
        _loc4.onPress = function ()
        {
            owner.music_mcs[3].prev_btn.onPress();
            _parent.speaker_btn.control.s._visible = false;
            _parent.speaker_btn.control.p._visible = true;
        };
        _loc4.onRollOver = function ()
        {
            owner.playSnd(owner.soundBtn);
            this.gotoAndStop("over");
        };
        _loc4.onRollOut = function ()
        {
            this.gotoAndStop("out");
        };
        _loc3.owner = this;
        _loc3.onPress = function ()
        {
            owner.music_mcs[3].next_btn.onPress();
            _parent.speaker_btn.control.s._visible = false;
            _parent.speaker_btn.control.p._visible = true;
        };
        _loc3.onRollOver = function ()
        {
            owner.playSnd(owner.soundBtn);
            this.gotoAndStop("over");
        };
        _loc3.onRollOut = function ()
        {
            this.gotoAndStop("out");
        };
        _loc2.owner = this;
        _loc2.onPress = function ()
        {
            if (owner.music._on)
            {
                control.p._visible = false;
                control.s._visible = true;
                owner.music_mcs[3].pause_btn.onPress();
            }
            else
            {
                control.s._visible = false;
                control.p._visible = true;
                owner.music_mcs[3].play_btn.onPress();
            } // end else if
        };
        _loc2.onRollOver = function ()
        {
            owner.playSnd(owner.soundBtn);
            this.gotoAndStop("over");
        };
        _loc2.onRollOut = function ()
        {
            this.gotoAndStop("out");
        };
        _loc2.control.s._visible = false;
    } // End of the function
    function addPopMenu()
    {
        popMenu = book.pages.createEmptyMovieClip("popMenu", -1);
        var _loc6 = popMenu.attachMovie("bgPopUpMenu", "bg", 0);
        var _loc4 = this.addNavigation(popMenu, true);
        this.addMiniMusicBox(popMenu);
        var _loc3 = this.addText("<info>Click or drag the corners to flip pages</info>", "p_txt", popMenu, 0, 0, _loc4._width);
        _loc3.write.selectable = false;
        popMenu.info = _loc3;
        _loc3._x = _loc4._x = _loc4._y = 10;
        _loc3._y = _loc4._height + 10;
        miniMusic_mc._y = _loc3._height + _loc4._height + 10 + 10;
        miniMusic_mc._x = _loc4._width - miniMusic_mc._width + 10;
        _loc6._width = _loc4._width + 20;
        _loc6._height = _loc3._height + _loc4._height + miniMusic_mc._height + 30;
        _loc6.hDefault = _loc6._height;
        miniMusic_mc.yDefault = miniMusic_mc._y;
        _loc3.yDefault = _loc3._y;
        var _loc2 = popMenu.createEmptyMovieClip("btn", -1);
        var _loc5 = _loc2.attachMovie("bgPopUpMenu", "bg", 0);
        _loc2.msgOut = "<info_btn>MAIN OPTIONS</info_btn>";
        _loc2.msgOver = "<info_btn_over>MAIN OPTIONS</info_btn_over>";
        _loc2.txt = this.addText(_loc2.msgOut, "p_txt", _loc2);
        _loc5._width = _loc2.txt._width + 20;
        _loc5._height = _loc2.txt._height - 1;
        _loc2.txt._x = (_loc5._width - _loc2.txt._width) / 2;
        _loc2._rotation = -90;
        _loc2._x = -_loc5._height + 1;
        _loc2._y = _loc2._height + 10;
        popMenu._visible = false;
        popMenu._y = -popMenu._height + 40;
        popMenu._x = -book.cww;
        popMenu.owner = this;
        _loc2.owner = this;
        _loc2.onPress = function ()
        {
            if (_parent.open == true)
            {
                owner.openPopMenu(false, _parent.show);
            }
            else
            {
                owner.openPopMenu(true, _parent.show);
            } // end else if
            this.onRollOut();
        };
        _loc2.onRollOver = function ()
        {
            owner.playSnd(owner.soundBtn);
            txt.write.htmlText = msgOver;
        };
        _loc2.onRollOut = function ()
        {
            txt.write.htmlText = msgOut;
        };
        popMenu.menu._visible = false;
        popMenu.music_mc._visible = false;
    } // End of the function
    function pagesController(targets, pageOrder, sets)
    {
        if (sets[0] > 2)
        {
            if (popMenu.open == true)
            {
                this.openPopMenu(false, true);
            }
            else
            {
                this.setPopMenu(true);
            } // end else if
        }
        else if (popMenu.open == true)
        {
            this.openPopMenu(false, false);
        }
        else
        {
            this.setPopMenu(false);
        } // end else if
        if (sets[1] == 0 && sets[2] == 0)
        {
            popMenu.btn.enabled = true;
        }
        else
        {
            popMenu.btn.enabled = false;
        } // end else if
        if (sets[2] == 0 && sets[3] == book.maxpage - 3)
        {
            book.pages.onMouseMove = function ()
            {
                if (owner.pages._xmouse > 0)
                {
                    owner.stop();
                }
                else
                {
                    owner.run();
                } // end else if
            };
        }
        else
        {
            delete book.pages.onMouseMove;
        } // end else if
        if (sets[1] == 0 && sets[2] == 0)
        {
            this.enableGlobal(sets, true);
        }
        else
        {
            this.enableGlobal(sets, false);
        } // end else if
        for (var _loc11 = 0; _loc11 < music_mcs.length; ++_loc11)
        {
            var _loc8 = targets[_loc11][pageOrder[sets[_loc11]]];
            if (String(music_mcs[_loc11]).indexOf(String(_loc8)) != -1)
            {
                if (music._on)
                {
                    music_mcs[_loc11].musicBars.play();
                }
                else
                {
                    music_mcs[_loc11].musicBars.reset();
                } // end else if
                this.setMusicBar(music_mcs[_loc11]);
                continue;
            } // end if
            if (music_mcs[_loc11].musicBars._on)
            {
                music_mcs[_loc11].musicBars.reset();
            } // end if
        } // end of for
        for (var _loc11 in targets)
        {
            var _loc7 = targets[_loc11][pageOrder[targets[_loc11].num]];
            _loc7.content.scroll.setTo();
            var _loc5 = _loc7.content.scroll.yScroll;
            if (_loc5 != undefined)
            {
                for (var _loc10 in targets)
                {
                    for (var _loc9 in sets)
                    {
                        if (targets[_loc11].num == sets[_loc9])
                        {
                            var _loc4 = targets[_loc10][pageOrder[sets[_loc9]]];
                            _loc4.content.scroll.setTo(_loc5);
                        } // end if
                    } // end of for...in
                } // end of for...in
            } // end if
        } // end of for...in
    } // End of the function
    function addRollOver(thumb)
    {
        thumb.colorT.applyHex(thumb.border, mainBorderC, 100, mainBorderCO, 100);
        thumb.colorT.applyHex(thumb.bg, mainBgC, 100, mainBgCO, 100);
        thumb.colorT.applyHex(thumb.view.space, mainBorderC, 100, mainBorderCO, 100);
        thumb.owner = this;
        thumb.onRollOut = function ()
        {
            colorT.toStart(border, "Quad", "easeOut", 500);
            colorT.toStart(bg, "Quad", "easeOut", 500);
            colorT.toStart(view.space, "Quad", "easeOut", 500);
        };
        thumb.onRollOver = function ()
        {
            owner.playSnd(owner.soundBtn);
            colorT.toEnd(border, "Quad", "easeOut", 500);
            colorT.toEnd(bg, "Quad", "easeOut", 1000);
            colorT.toEnd(view.space, "Quad", "easeOut", 500);
        };
    } // End of the function
    function addShape(place, name, w, h, x, y, c)
    {
        var _loc2 = place.attachMovie("shape", name, place.getNextHighestDepth());
        this.setColor(_loc2, c);
        _loc2._x = x;
        _loc2._y = y;
        _loc2._width = w;
        _loc2._height = h;
        return (_loc2);
    } // End of the function
    function addImg(place, file, w, h)
    {
        var _loc3 = place.createEmptyMovieClip("pic", place.getNextHighestDepth());
        var _loc6 = _loc3.attachMovie("shape", "mask", 1, {_visible: false, _height: h || preloader.bitmaps[file].data.height, _width: w || preloader.bitmaps[file].data.width});
        var _loc4 = _loc3.createEmptyMovieClip("_holder", 2);
        _loc4.setMask(_loc6);
        _loc4.attachBitmap(preloader.bitmaps[file].data, 0, "never", false);
        place.pic._x = (place.mask._width - place._holder._width) / 2;
        place._holder._y = (place.mask._height - place._holder._height) / 2;
        return (_loc3);
    } // End of the function
    function loadImage(thumb)
    {
        thumb.onRollOut();
        this.enableBtns(false);
        thumb.view.pic._visible = false;
        var _loc2 = r.attachMovie("box_mc", "img" + ++imgShowed, book.pages.getDepth() - imgShowed);
        _loc2._depth = _loc2.getDepth();
        thumb.imgBox = _loc2;
        _loc2._visible = false;
        _loc2.setColors(mainBorderC, mainBgC, mainBorderC);
        _loc2.setMargins(4, 4, 4, 4, -6);
        _loc2.setSize(50, 50);
        _loc2._x = Stage.width / 2;
        _loc2._y = Stage.height / 2;
        var _loc4 = _loc2.view.createEmptyMovieClip("img", 0);
        var _loc5 = this.addImgLoader(thumb);
        this.load("images/" + thumb.node.attributes.img, _loc4, _loc5.bar, undefined, "percentThumb");
    } // End of the function
    function closeImage(thumb)
    {
        var _loc3 = thumb.imgBox;
        thumb.onRollOut();
        _loc3.moveX(0, 300, "Quad", "easeOut", -_loc3._width);
        _loc3.moveY(0, 300, "Quad", "easeOut", 0);
        _loc3.rotate(0, 300, "Quad", "easeOut", -10);
        _loc3.scale(300, 500, "Quad", "easeOut", 70);
        _loc3.moveX(300, 500, "Quad", "easeOut", _loc3.xStart);
        _loc3.moveY(300, 500, "Quad", "easeOut", _loc3.yStart);
        _loc3.rotate(300, 500, "Quad", "easeOut", 0);
        _global.setTimeout(_loc3, "swapDepths", 420, _loc3._depth);
        _global.setTimeout(this, "removeImage", 1120, thumb);
    } // End of the function
    function removeImage(thumb)
    {
        book.run();
        this.enableBtns(true);
        popMenu.btn.enabled = true;
        var _loc2 = thumb.imgBox;
        var _loc3 = _loc2.view.img;
        _loc2.removeMovieClip();
    } // End of the function
    function showImage(thumb)
    {
        book.stop();
        this.setPopMenu(true);
        popMenu.btn.enabled = false;
        thumb.loader.removeMovieClip();
        thumb.view.pic._visible = true;
        thumb.onRollOver();
        var _loc6 = thumb.node;
        var _loc3 = thumb.imgBox;
        var _loc4 = _loc3.view.img;
        var _loc11 = "<title>" + _loc6.attributes.title.toUpperCase() + "</title>";
        var _loc8 = _loc6.attributes.description;
        var _loc5 = _loc6.attributes.link;
        var _loc7 = "";
        if (_loc8)
        {
            _loc7 = _loc7 + ("<description>" + _loc8 + "</description>");
        } // end if
        if (_loc5)
        {
            _loc7 = _loc7 + ("<a href=\'" + _loc5 + "\' target=\'_blank\'>Visit Link >></s>");
        } // end if
        var _loc10 = this.addShape(_loc3.view, "space", _loc4._width, _loc3._top, 0, _loc4._height, this.hex(mainBorderC));
        var _loc9 = this.addText(_loc11, "title_txt", _loc3.view, 5, _loc10._y + 7, _loc4._width - 10);
        if (_loc8 || _loc5)
        {
            var _loc12 = this.addText(_loc7, "p_txt", _loc3.view, 6, _loc9._y + _loc9._height - 10, _loc4._width - 10);
        } // end if
        _loc3.setSize(_loc3.view._width + _loc3._left + _loc3._right, _loc3.view._height + _loc3._bottom + _loc3._top + 2);
        _loc3.view.img.owner = this;
        _loc3.view.img.onPress = function ()
        {
            owner.closeImage(thumb);
        };
        _loc3.xDefault = (Stage.width - _loc3._width) / 2;
        _loc3.yDefault = (Stage.height - _loc3._height) / 2;
        _loc3._xscale = _loc3._yscale = 70;
        _loc3.xStart = _loc3._x = (Stage.width - _loc3._width) / 2;
        _loc3.yStart = _loc3._y = (Stage.height - _loc3._height) / 2;
        _loc3._visible = true;
        _loc3.scale(0, 300, "Quad", "easeOut", 100);
        _loc3.moveX(0, 300, "Quad", "easeOut", Stage.width);
        _loc3.moveY(0, 300, "Quad", "easeOut", -50);
        _loc3.rotate(0, 300, "Quad", "easeOut", 10);
        _loc3.moveX(300, 500, "Quad", "easeOut", _loc3.xDefault);
        _loc3.moveY(300, 500, "Quad", "easeOut", _loc3.yDefault);
        _loc3.rotate(300, 500, "Quad", "easeOut", 0);
        _global.setTimeout(_loc3, "swapDepths", 420, r.getNextHighestDepth());
    } // End of the function
    function enableGlobal(sets, val)
    {
        var _loc3 = book.pagesPosition;
        for (var _loc7 in _loc3)
        {
            var _loc2 = _loc3[_loc7]["p" + sets[_loc7]].content.view;
            _loc3[_loc7]["p" + sets[_loc7]].content.enabled = val;
            for (var _loc6 in _loc2)
            {
                if (_loc2[_loc6] instanceof MovieClip)
                {
                    _loc2[_loc6].enabled = val;
                } // end if
            } // end of for...in
        } // end of for...in
    } // End of the function
    function enableBtns(val)
    {
        var _loc2 = book.pleft["p" + book.pleft.num].content.view;
        var _loc3 = book.pright["p" + book.pright.num].content.view;
        book.pleft["p" + book.pleft.num].content.enabled = val;
        book.pright["p" + book.pright.num].content.enabled = val;
        for (var _loc5 in _loc2)
        {
            if (_loc2[_loc5] instanceof MovieClip)
            {
                _loc2[_loc5].enabled = val;
            } // end if
        } // end of for...in
        for (var _loc6 in _loc3)
        {
            if (_loc3[_loc6] instanceof MovieClip)
            {
                _loc3[_loc6].enabled = val;
            } // end if
        } // end of for...in
    } // End of the function
    function resizeSite()
    {
        mainLoader._x = (Stage.width - mainLoader.w) / 2;
        mainLoader._y = (Stage.height - mainLoader.y) / 2;
        bg.resize(Stage.width, Stage.height);
        if (book.pleft.num > book.maxpage - 1)
        {
            book.pages._x = (Stage.width + book.cww) / 2;
        }
        else if (book.pleft.num == 0)
        {
            book.pages._x = (Stage.width - book.cww) / 2;
        }
        else
        {
            book.pages._x = Stage.width / 2;
        } // end else if
        book.pages._y = Stage.height / 2;
    } // End of the function
    function addLoader(msg, place, d, funct, ref)
    {
        mainLoader.removeMovieClip();
        mainLoader._visible = false;
        if (!d)
        {
            d = place.getNextHighestDepth();
        } // end if
        mainLoader = place.createEmptyMovieClip("ld" + d, d);
        var _loc3 = mainLoader.attachMovie("mainloader_mc", "bar", 0);
        _loc3._width = 200;
        mainLoader.w = mainLoader._width;
        mainLoader.h = mainLoader._height;
        mainLoader.msg = this.addText(msg.toUpperCase(), "p_txt", mainLoader);
        mainLoader.msg._y = _loc3._height;
        mainLoader.msg._x = (_loc3._width - mainLoader.msg._width) / 2;
        if (funct)
        {
            new com.oop.core.Watcher(mainLoader.bar, "_loaded", true, this, funct, arguments[4]);
        } // end if
        mainLoader._x = ((ref._width || Stage.width) - mainLoader._width) / 2;
        mainLoader._y = ((ref._height || Stage.height) - mainLoader._height) / 2;
    } // End of the function
    function addImgLoader(thumb)
    {
        var _loc4 = thumb.view.pic;
        var _loc2 = thumb.view.createEmptyMovieClip("ld" + thumb.view.getNextHighestDepth(), thumb.view.getNextHighestDepth());
        var _loc3 = _loc2.attachMovie("mainloader_mc", "bar", 0);
        _loc3._width = _loc4._width > 100 ? (_loc4._width / 2) : (_loc4._width - 10);
        _loc2.w = _loc2._width;
        _loc2.h = _loc2._height;
        _loc2.msg = this.addText("<loader>Loading <loader_desc>Graphic</loader_desc></loader>", "p_txt", _loc2);
        _loc2.msg._y = _loc3._height;
        _loc2.msg._x = (_loc3._width - _loc2.msg._width) / 2;
        _loc2._x = (_loc4._width - _loc3._width) / 2;
        _loc2._y = (_loc4._height - _loc3._height) / 2;
        new com.oop.core.Watcher(_loc3, "_loaded", true, this, "showImage", thumb);
        thumb.loader = _loc2;
        return (_loc2);
    } // End of the function
    function addText(msg, attach, clip, x, y, w)
    {
        var _loc2 = clip.attachMovie(attach, "txt" + clip.getNextHighestDepth(), clip.getNextHighestDepth());
        _loc2._x = x - 3.500000E+000;
        _loc2._y = y;
        _loc2.write.autoSize = "left";
        if (w != undefined)
        {
            _loc2.write.multiline = true;
            _loc2.write._width = w;
            _loc2.write.wordWrap = true;
            if (attach == "p_txt")
            {
                _loc2.write.selectable = true;
            } // end if
        } // end if
        _loc2.write.styleSheet = css;
        _loc2.write.htmlText = msg;
        return (_loc2);
    } // End of the function
    function setColor(clip, c)
    {
        var _loc1 = new Color(clip);
        _loc1.setRGB(c);
    } // End of the function
    function testSide(val)
    {
        var _loc1 = val.toString();
        _loc1 = _loc1.substring(_loc1.length - 1, _loc1.length);
        if (_loc1 == "1" || _loc1 == "3" || _loc1 == "5" || _loc1 == "7" || _loc1 == "9")
        {
            return (false);
        }
        else
        {
            return (true);
        } // end else if
    } // End of the function
    function hex(val)
    {
        var _loc1 = val.toString();
        if (val.substring(0, 1) == "#")
        {
            _loc1 = _loc1.substring(1, _loc1.length);
        } // end if
        _loc1 = "0x" + _loc1;
        return (Number(_loc1));
    } // End of the function
    function clean(clip)
    {
        for (var _loc2 in clip)
        {
            if (clip[_loc2] instanceof MovieClip)
            {
                clip[_loc2].removeMovieClip();
            } // end if
        } // end of for...in
    } // End of the function
    function playSnd(n)
    {
        if (sound_temp == n)
        {
            snd.start();
        }
        else
        {
            snd = new Sound();
            snd.owner = this;
            snd.onLoad = function ()
            {
                owner.sound_temp = n;
            };
            snd.loadSound(n, false);
        } // end else if
    } // End of the function
    function cutTxt(txt, n)
    {
        var _loc2 = txt.length;
        if (_loc2 > n)
        {
            while (_loc2 > n)
            {
                txt = txt.substring(0, txt.lastIndexOf(" "));
                _loc2 = txt.length;
            } // end while
            return (txt + " ...");
        }
        else
        {
            return (txt);
        } // end else if
    } // End of the function
    function addMusicPlayer(place)
    {
        music_mc = place.createEmptyMovieClip("player_mc", place.getNextHighestDepth());
        var _loc2 = music_mc.attachMovie("musicLoader", "bar", music_mc.getNextHighestDepth());
        music_mc.info = this.addText("<p>Playing " + music.title + "</p>", "p_txt", music_mc, 0, 0, _loc2._width);
        music_mc.info._y = -((music_mc.info._height - _loc2._height) / 2 - 1);
        music_mc.info._visible = false;
        var _loc4 = music_mc.attachMovie("prev_btn", "prev_btn", music_mc.getNextHighestDepth());
        var _loc5 = music_mc.attachMovie("next_btn", "next_btn", music_mc.getNextHighestDepth());
        _loc4._x = music_mc._width + 7;
        _loc5._x = music_mc._width;
        music_mc.play_btn = this.addText("<p>PLAY</p>", "p_txt", music_mc, music_mc._width + 5, music_mc.info._y);
        music_mc.pause_btn = this.addText("<p>STOP</p>", "p_txt", music_mc, music_mc._width, music_mc.info._y);
        var _loc3 = music_mc.attachMovie("musicBars", "musicBars", music_mc.getNextHighestDepth());
        _loc3._x = music_mc._width + 3;
        _loc3._y = _loc2._height;
        music_mc.play_btn.owner = this;
        music_mc.play_btn.onPress = function ()
        {
            owner.addMusicInfo();
            owner.playMusic();
            _parent.musicBars.play();
        };
        music_mc.play_btn.onRollOver = function ()
        {
            write.htmlText = "<a>PLAY</a>";
        };
        music_mc.play_btn.onRollOut = function ()
        {
            write.htmlText = "<p>PLAY</p>";
        };
        music_mc.pause_btn.owner = this;
        music_mc.pause_btn.onPress = function ()
        {
            owner.addMusicInfo("Paused");
            owner.stopMusic();
            _parent.musicBars.stop();
        };
        music_mc.pause_btn.onRollOver = function ()
        {
            write.htmlText = "<a>STOP</a>";
        };
        music_mc.pause_btn.onRollOut = function ()
        {
            write.htmlText = "<p>STOP</p>";
        };
        music_mc.prev_btn.owner = this;
        music_mc.prev_btn.onPress = function ()
        {
            owner.prevMusic();
            _parent.play_btn.enabled = true;
            _parent.play_btn.onRollOver();
            _parent.play_btn.enabled = false;
            _parent.pause_btn.enabled = true;
            _parent.pause_btn.onRollOut();
        };
        music_mc.prev_btn.onRollOver = function ()
        {
            this.gotoAndStop("over");
        };
        music_mc.prev_btn.onRollOut = function ()
        {
            this.gotoAndStop("out");
        };
        music_mc.next_btn.owner = this;
        music_mc.next_btn.onPress = function ()
        {
            owner.nextMusic();
            _parent.play_btn.enabled = true;
            _parent.play_btn.onRollOver();
            _parent.play_btn.enabled = false;
            _parent.pause_btn.enabled = true;
            _parent.pause_btn.onRollOut();
        };
        music_mc.next_btn.onRollOver = function ()
        {
            this.gotoAndStop("over");
        };
        music_mc.next_btn.onRollOut = function ()
        {
            this.gotoAndStop("out");
        };
    } // End of the function
    function stopMusic()
    {
        if (music._on)
        {
            music.pause();
        } // end if
        for (var _loc2 in music_mcs)
        {
            music_mcs[_loc2].play_btn.enabled = true;
            music_mcs[_loc2].play_btn.onRollOut();
            music_mcs[_loc2].pause_btn.onRollOver();
            music_mcs[_loc2].pause_btn.enabled = false;
        } // end of for...in
    } // End of the function
    function playMusic()
    {
        if (!music._on)
        {
            music.play();
        } // end if
        for (var _loc2 in music_mcs)
        {
            music_mcs[_loc2].pause_btn.enabled = true;
            music_mcs[_loc2].pause_btn.onRollOut();
            music_mcs[_loc2].play_btn.onRollOver();
            music_mcs[_loc2].play_btn.enabled = false;
        } // end of for...in
    } // End of the function
    function addMusicInfo(msg)
    {
        for (var _loc3 in music_mcs)
        {
            music_mcs[_loc3].info.write.htmlText = "<p>" + (msg || "Playing") + " " + music.title + "</p>";
        } // end of for...in
    } // End of the function
    function setMusicBar(targ)
    {
        music_mc = targ || music_mcs[3];
        music.setBar(music_mc.bar);
        new com.oop.core.Watcher(music, "_loaded", true, this, "trackLoaded", targ);
        if (targ == undefined)
        {
            music_mc.bar._alpha = 0;
            music_mc._parent._parent.tween(music_mc.bar, "_alpha", 100, 300, "Quad", "easeIn");
            for (var _loc2 in music_mcs)
            {
                music_mcs[_loc2].info._visible = false;
                music_mcs[_loc2].bar._visible = true;
            } // end of for...in
        } // end if
    } // End of the function
    function trackLoaded(targ)
    {
        music_mc = targ || music_mcs[3];
        for (var _loc2 in music_mcs)
        {
            music_mcs[_loc2].info._visible = true;
            music_mcs[_loc2].bar._visible = false;
        } // end of for...in
        music.unsetBar();
    } // End of the function
    function nextMusic()
    {
        var _loc3 = config.itemFinder("music").childNodes;
        for (var _loc2 = 0; _loc2 < _loc3.length; ++_loc2)
        {
            var _loc7 = _loc3[_loc2].attributes.title;
            if (_loc7 == music.title)
            {
                var _loc4 = _loc2 == _loc3.length - 1 ? (0) : (_loc2 + 1);
                var _loc5 = _loc3[_loc4].attributes.link;
                var _loc6 = _loc3[_loc4].attributes.title;
                music.loadTrack(_loc5, _loc6);
                break;
            } // end if
        } // end of for
        this.addMusicInfo();
        music_mcs[3].musicBars.play();
        this.setMusicBar();
    } // End of the function
    function prevMusic()
    {
        var _loc3 = config.itemFinder("music").childNodes;
        for (var _loc2 = 0; _loc2 < _loc3.length; ++_loc2)
        {
            var _loc7 = _loc3[_loc2].attributes.title;
            if (_loc7 == music.title)
            {
                var _loc4 = _loc2 == 0 ? (_loc3.length - 1) : (_loc2 - 1);
                var _loc5 = _loc3[_loc4].attributes.link;
                var _loc6 = _loc3[_loc4].attributes.title;
                music.loadTrack(_loc5, _loc6);
                break;
            } // end if
        } // end of for
        this.addMusicInfo();
        music_mcs[3].musicBars.play();
        this.setMusicBar();
    } // End of the function
} // End of Class
