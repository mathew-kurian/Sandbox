class com.Book
{
    var r, nameBook, depthBook, attCover, attPaper, attGrad, sound, attGradFlip, pathC, functC, importedData, mousecontroll, pages, cww, endSound, owner, phh, pww, chh, pw, ph, pleft, sp2, sp3, pright, pagesPosition, onEnterFrame, pageOrder, pageConfig, maxpage, pageNumber, ox, oy, r0, r1, pageN, pageO, offs, sound_temp, snd;
    function Book(nameB, _depth, _cover, _paper, _grad, _gradFlip, _info, _sound, path, funct)
    {
        r = _root;
        nameBook = nameB;
        depthBook = _depth;
        attCover = _cover;
        attPaper = _paper;
        attGrad = _grad;
        sound = _sound;
        attGradFlip = _gradFlip;
        pathC = path;
        functC = funct;
        importedData = new Array();
        importedData = _info;
        mousecontroll = new Object();
        this.playSnd();
    } // End of the function
    function init()
    {
        this.getSizes();
        this.createBook(nameBook, depthBook);
        pages._x = (Stage.width - cww) / 2;
        pages._y = Stage.height / 2;
        this.publishPages();
        this.reset();
        this.setPages(0, 0, 0, 1);
        endSound = true;
    } // End of the function
    function start()
    {
        page = 0;
        this.removeML();
        pages.owner = this;
        pages.onEnterFrame = function ()
        {
            owner.oef();
        };
        Mouse.addListener(mousecontroll);
        mousecontroll.owner = this;
        mousecontroll.onMouseDown = function ()
        {
            owner._onMouseDown();
        };
        mousecontroll.onMouseUp = function ()
        {
            owner._onMouseUp();
        };
        this.resetPages();
        this.reset();
        pages._x = Stage.width / 2 - cww / 2;
    } // End of the function
    function run()
    {
        pages.onEnterFrame = function ()
        {
            owner.oef();
        };
        Mouse.addListener(mousecontroll);
        mousecontroll.onMouseDown = function ()
        {
            owner._onMouseDown();
        };
        mousecontroll.onMouseUp = function ()
        {
            owner._onMouseUp();
        };
    } // End of the function
    function stop()
    {
        pages.onEnterFrame = undefined;
        mousecontroll.onMouseDown = undefined;
        mousecontroll.onMouseUp = undefined;
        this.removeML();
    } // End of the function
    function removeML()
    {
        Mouse.removeListener(mousecontroll);
    } // End of the function
    function createPage(place, name, d)
    {
        var _loc1 = place.createEmptyMovieClip(name, d);
        var _loc2 = _loc1.createEmptyMovieClip("page", 0);
        var _loc3 = _loc2.createEmptyMovieClip("pf", 0);
        var _loc4 = _loc3.createEmptyMovieClip("ph", 0);
        return (_loc1);
    } // End of the function
    function getSizes()
    {
        var _loc2 = r.createEmptyMovieClip("temp_mc", r.getNextHighestDepth(), {visible: false});
        _loc2.attachMovie("paper_mc", "paper_mc", 0);
        _loc2.attachMovie("cover_mc", "cover_mc", 1);
        phh = _loc2.paper_mc._height;
        pww = _loc2.paper_mc._width;
        chh = _loc2.cover_mc._height;
        cww = _loc2.cover_mc._width;
        _loc2.removeMovieClip();
    } // End of the function
    function createBook(name, d)
    {
        pw = cww;
        ph = chh;
        pages = r.createEmptyMovieClip(name, d);
        var _loc16 = this.createPage(pages, "pLL", 0);
        var _loc15 = this.createPage(pages, "pLR", 1);
        var _loc11 = this.createPage(pages, "p4", 2);
        var _loc14 = this.createPage(pages, "p1", 3);
        var _loc4 = pages.createEmptyMovieClip("mask", 4);
        _loc4.attachMovie("shape", "_holder", 0);
        _loc4._holder._width = 800;
        _loc4._holder._height = 1500;
        _loc4._holder._x = -_loc4._holder._width;
        _loc4._holder._y = -_loc4._holder._height / 2;
        var _loc8 = pages.createEmptyMovieClip("pgrad", 5);
        _loc8.attachMovie(attGrad, "_holder", 0);
        _loc8._holder._height = ph * 4;
        _loc8._holder._xscale = 110;
        _loc8._holder._y = -_loc8._holder._height / 2;
        var _loc3 = pages.createEmptyMovieClip("pgmask", 6);
        _loc3.attachMovie("shape", "_holder", 0);
        _loc3._holder._width = pw * 2;
        _loc3._holder._height = ph;
        _loc3._holder._x = -_loc3._holder._width / 2;
        _loc3._holder._y = -_loc3._holder._height / 2;
        _loc8.setMask(_loc3);
        var _loc7 = pages.createEmptyMovieClip("flip", 7);
        var _loc12 = this.createPage(_loc7, "p3", 0);
        var _loc5 = _loc7.createEmptyMovieClip("p3shadow", 1);
        _loc5.attachMovie(attGrad, "_holder", 0);
        _loc5._holder._height = ph * 4;
        _loc5._holder._xscale = -100;
        _loc5._holder._y = -_loc5._holder._height / 2;
        var _loc2 = _loc7.createEmptyMovieClip("p3mask", 2);
        _loc2.attachMovie("shape", "_holder", 0);
        _loc2._holder._width = pw * 2;
        _loc2._holder._height = ph;
        _loc2._holder._x = -_loc2._holder._width / 2;
        _loc2._holder._y = -_loc2._holder._height / 2;
        _loc5.setMask(_loc2);
        var _loc13 = this.createPage(_loc7, "p2", 3);
        var _loc6 = _loc7.createEmptyMovieClip("fgrad", 4);
        _loc6.attachMovie(attGradFlip, "_holder", 0);
        _loc6._holder._height = ph * 4;
        _loc6._holder._xscale = -100;
        _loc6._holder._y = -_loc6._holder._height / 2;
        var _loc10 = this.createPage(_loc7, "fmask", 5);
        var _loc9 = _loc10.page.pf.ph.attachMovie("shape", "_holder", 0);
        _loc9._width = pw;
        _loc9._height = ph;
        _loc9._y = -ph / 2;
        _loc6.setMask(_loc10);
        pleft = _loc14.page.pf.ph;
        sp2 = _loc13.page.pf.ph;
        sp3 = _loc12.page.pf.ph;
        pright = _loc11.page.pf.ph;
        pleft.num = -1;
        sp2.num = -1;
        sp3.num = -1;
        pright.num = -1;
        pagesPosition = new Array(pleft, sp2, sp3, pright);
        pages.owner = this;
        pages.onUnload = function ()
        {
            delete this.onEnterFrame;
            Mouse.removeListener(owner.mousecontroll);
        };
    } // End of the function
    function publishPages()
    {
        pageOrder = new Array();
        pageConfig = new Array();
        page = 0;
        this.addPage();
        this.addPage(attCover, importedData[0]);
        this.addPage(attCover, importedData[1]);
        for (var _loc2 = 2; _loc2 < importedData.length - 2; ++_loc2)
        {
            this.addPage(attPaper, importedData[_loc2]);
        } // end of for
        if (this.testSide(page))
        {
            this.addPage(attPaper);
        } // end if
        this.addPage(attCover, importedData[importedData.length - 2]);
        this.addPage(attCover, importedData[importedData.length - 1]);
        this.addPage();
        maxpage = page - 2;
        pages.pLL.page.pf.ph.attachMovie(attCover, "cover", 0);
        pages.pLR.page.pf.ph.attachMovie(attCover, "cover", 0);
        pages.pLL._visible = pages.pLR._visible = false;
        importedData = new Array();
    } // End of the function
    function addPage(bg, info)
    {
        var _loc4 = "p" + page;
        for (var _loc5 in pagesPosition)
        {
            var _loc2 = pagesPosition[_loc5].createEmptyMovieClip(_loc4, pagesPosition[_loc5].getNextHighestDepth());
            if (bg)
            {
                _loc2.attachMovie(bg, "bg", 0);
            } // end if
            if (bg == "paper_mc")
            {
                _loc2.attachMovie(attGrad, "grad", 1000);
            } // end if
            _loc2.grad._height = _loc2.bg._height;
            if (this.testSide(page))
            {
                _loc2.bg._xscale = -100;
                _loc2.bg._x = _loc2.bg._width;
                _loc2.grad._xscale = -100;
                _loc2.grad._x = _loc2.bg._width;
            } // end if
            _loc2._visible = false;
        } // end of for...in
        pageOrder[page] = _loc4;
        pageConfig[page] = info;
        ++page;
    } // End of the function
    function addContents()
    {
        for (var _loc2 in pageConfig)
        {
            this.addContent(_loc2);
        } // end of for...in
    } // End of the function
    function addContent(n)
    {
        var _loc2 = pageConfig[n];
        for (var _loc4 = 0; _loc4 < pagesPosition.length; ++_loc4)
        {
            var _loc3 = pagesPosition[_loc4][pageOrder[n]];
            if (_loc2 && !_loc2.funct && !_loc2.path)
            {
                var _loc5 = _loc3.attachMovie(_loc2, "content", 1);
                _loc5._x = (_loc3.bg._width - _loc3.content._width) / 2;
                _loc5._y = (_loc3.bg._height - _loc3.content._height) / 2;
                continue;
            } // end if
            if (_loc2.funct && _loc2.path)
            {
                _loc2.path[_loc2.funct](_loc3, _loc2.params);
            } // end if
        } // end of for
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
    function evalfcovers()
    {
        var _loc2 = pleft.num == 0 && sp2.num == 1 || pright.num > maxpage && sp3.num == maxpage - 1 ? (true) : (false);
        return (_loc2);
    } // End of the function
    function evalfcovers2()
    {
        var _loc2 = pleft.num == 0 && sp2.num == 2 || pright.num > maxpage && sp3.num == maxpage ? (true) : (false);
        return (_loc2);
    } // End of the function
    function setSizes()
    {
        if (this.evalfcovers2() || this.evalfcovers() || pleft.num == undefined)
        {
            pw = cww;
            ph = chh;
        }
        else
        {
            pw = pww;
            ph = phh;
        } // end else if
        var _loc5 = pleft[pageOrder[pleft.num]].bg._width || cww;
        var _loc3 = pright[pageOrder[pright.num]].bg._width || pww;
        pages.p4.page._x = -_loc3;
        pages.p4._x = _loc3;
        pages.p1.page._x = -_loc5;
        pages.p1._x = 0;
        var _loc2 = sp2[pageOrder[sp2.num]].bg._width || cww;
        var _loc4 = sp3[pageOrder[sp3.num]].bg._width || cww;
        if (sp2.num != 0)
        {
            if (pright.num == sp2.num + 1)
            {
                pages.flip.p2.page._x = 0;
                pages.flip.p2._x = _loc2;
                pages.flip.p3.page._x = 0;
                pages.flip.p3._x = 0;
            }
            else
            {
                pages.flip.p2.page._x = -_loc2;
                pages.flip.p2._x = _loc2;
                pages.flip.p3.page._x = -_loc4;
                pages.flip.p3._x = 0;
            } // end if
        } // end else if
    } // End of the function
    function reset()
    {
        pages.pLL.page._x = -cww;
        pages.pLL._x = 0;
        pages.pLR.page._x = -cww;
        pages.pLR._x = cww;
        this.setSizes();
        pages.pgrad._visible = pages.mask._visible = pages.flip._visible = false;
        pages.flip.p3mask._width = pages.pgmask._width = pw * 2;
        pages.flip.p3mask._height = pages.pgmask._height = ph;
        pages.flip.fmask.page.pf._width = pw;
        pages.flip.fmask.page.pf._height = ph;
        pages.mask._height = pages.pgrad._height = pages.flip.p3shadow._height = pages.flip.flipgrad._height = 2 * Math.sqrt(ph * ph + pw * pw);
        pageNumber = new Array();
        for (var _loc2 = 0; _loc2 <= maxpage + 1; ++_loc2)
        {
            pageNumber[_loc2] = _loc2;
        } // end of for
    } // End of the function
    function _onMouseDown()
    {
        if (flip && !aflip)
        {
            flipOK = false;
            if (sx < 0 && pages._xmouse > 0)
            {
                flipOK = true;
            } // end if
            if (sx > 0 && pages._xmouse < 0)
            {
                flipOK = true;
            } // end if
            flipOff = true;
            flip = false;
        }
        else if ((flipOff || aflip || !canflip) && !preflip)
        {
        }
        else
        {
            var _loc6 = ox;
            var _loc5 = oy;
            var _loc4 = sx;
            var _loc3 = sy;
            var _loc2 = this.hittest();
            if (_loc2)
            {
                flip = true;
                flipOff = false;
                ox = sx = _loc2 * pw;
                if (preflip)
                {
                    aflip = preflip = false;
                    (ox = _loc6, oy = _loc5, sx = _loc4, sy = _loc3);
                } // end if
                pages.flip.setMask(pages.mask);
                (mpx = pages._xmouse, mpy = pages._ymouse);
                this.oef();
            } // end else if
        } // end else if
    } // End of the function
    function _onMouseUp()
    {
        if (flip)
        {
            if (Math.abs(pages._xmouse) > pw - afa && Math.abs(pages._ymouse) > ph / 2 - afa && Math.abs(pages._xmouse - mpx) < afa || preflip)
            {
                flip = false;
                preflip = false;
                this.autoflip();
            }
            else if (!preflip)
            {
                preflip = false;
                flipOK = false;
                if (sx < 0 && pages._xmouse > 0)
                {
                    flipOK = true;
                } // end if
                if (sx > 0 && pages._xmouse < 0)
                {
                    flipOK = true;
                } // end if
                flipOff = true;
                flip = false;
            } // end if
        } // end else if
    } // End of the function
    function hittest()
    {
        var _loc3 = pages._xmouse;
        var _loc2 = pages._ymouse;
        var _loc4 = ph / 2;
        if (_loc2 <= _loc4 && _loc2 >= -_loc4 && _loc3 <= pw && _loc3 >= -pw)
        {
            var _loc5 = Math.sqrt(_loc3 * _loc3 + _loc2 * _loc2);
            var _loc6 = Math.asin(_loc2 / _loc5);
            _loc2 = Math.tan(_loc6) * pw;
            if (_loc2 > 0 && _loc2 > ph / 2)
            {
                _loc2 = ph / 2;
            } // end if
            if (_loc2 < 0 && _loc2 < -ph / 2)
            {
                _loc2 = -ph / 2;
            } // end if
            oy = sy = _loc2;
            r0 = Math.sqrt((sy + ph / 2) * (sy + ph / 2) + pw * pw);
            r1 = Math.sqrt((ph / 2 - sy) * (ph / 2 - sy) + pw * pw);
            pageN = pages.flip.p2.page;
            pageO = pages.flip.p3;
            offs = -pw;
            pages.flip.fmask._x = pw;
            if (_loc3 < -(pw - clickarea) && page > 0)
            {
                pages.flip.p3._x = 0;
                this.setPages(page - 2, page - 1, page, page + 1);
                return (-1);
            } // end if
            if (_loc3 > pw - clickarea && page < maxpage)
            {
                pages.flip.p3._x = pw;
                this.setPages(page, page + 2, page + 1, page + 3);
                return (1);
            } // end if
        }
        else
        {
            return (0);
        } // end else if
    } // End of the function
    function corner()
    {
        var _loc3 = Math.abs(pages._xmouse);
        var _loc2 = Math.abs(pages._ymouse);
        if (_loc3 > pw - afa && _loc3 < pw && _loc2 > ph / 2 - afa && _loc2 < ph / 2)
        {
            return (true);
        } // end if
        return (false);
    } // End of the function
    function oef()
    {
        if (!flip && this.corner())
        {
            preflip = true;
            if (!this.autoflip())
            {
                preflip = false;
            } // end if
        } // end if
        if (preflip && !this.corner())
        {
            preflip = false;
            flip = false;
            flipOK = false;
            flipOff = true;
        } // end if
        this.getm();
        if (aflip && !preflip)
        {
            y = ay = ay + (sy - ay) / (gflip ? (gs) : (ps));
            acnt = acnt + aadd;
            ax = ax - aadd;
            if (Math.abs(acnt) > pw)
            {
                flipOK = true;
                flipOff = true;
                flip = false;
                aflip = false;
            } // end if
        } // end if
        if (flip)
        {
            x = ox = ox + (x - ox) / (gflip ? (gs) : (ps));
            y = oy = oy + (y - oy) / (gflip ? (gs) : (ps));
            this.calc(x, y);
        } // end if
        if (flipOff)
        {
            if (flipOK)
            {
                x = ox = ox + (-sx - ox) / (gflip ? (gs) : (es));
                y = oy = oy + (sy - oy) / (gflip ? (gs) : (es));
                this.calc(x, y);
                if (x / -sx > 9.900000E-001)
                {
                    flip = false;
                    flipOK = flipOff = false;
                    pages.pgrad._visible = pages.flip._visible = false;
                    page = page + (sx < 0 ? (-2) : (2));
                    if (gskip)
                    {
                        page = gtarget;
                    } // end if
                    this.setPages(page, 0, 0, page + 1);
                    if (gpage > 0 && !gskip)
                    {
                        --gpage;
                        this.autoflip();
                    }
                    else
                    {
                        gflip = gskip = false;
                    } // end if
                } // end else if
            }
            else
            {
                x = ox = ox + (sx - ox) / 3;
                y = oy = oy + (sy - oy) / 3;
                this.calc(x, y);
                if (x / sx > 9.900000E-001)
                {
                    flip = false;
                    flipOff = false;
                    aflip = false;
                    pages.pgrad._visible = pages.flip._visible = false;
                    this.setPages(page, 0, 0, page + 1);
                } // end if
            } // end if
        } // end else if
        if (pleft.num == 0 && sp2.num == 2)
        {
            pages._x = Stage.width / 2 - pages.pgrad._x / 2;
        }
        else if (pleft.num == 0 && sp2.num == 1)
        {
            pages._x = Stage.width / 2 - (pw + pages.pgrad._x) / 2;
        }
        else if (pright.num > maxpage && sp3.num == maxpage)
        {
            pages._x = Stage.width / 2 - pages.pgrad._x / 2;
        }
        else if (pright.num > maxpage && sp3.num == maxpage - 1)
        {
            pages._x = Stage.width / 2 - (pages.pgrad._x - pw) / 2;
        }
        else if (pright.num > maxpage && sp3.num == maxpage - 1)
        {
            pages._x = Stage.width / 2;
        } // end else if
    } // End of the function
    function calc(x, y)
    {
        pages.flip.fgrad._visible = true;
        var _loc15 = Math.sqrt((y + ph / 2) * (y + ph / 2) + x * x);
        var _loc14 = Math.sqrt((ph / 2 - y) * (ph / 2 - y) + x * x);
        if (_loc15 > r0 || _loc14 > r1)
        {
            if (y < sy)
            {
                var _loc9 = Math.asin((ph / 2 - y) / _loc14);
                y = ph / 2 - Math.sin(_loc9) * r1;
                x = x < 0 ? (-Math.cos(_loc9) * r1) : (Math.cos(_loc9) * r1);
                if (y > sy)
                {
                    if (sx * x > 0)
                    {
                        y = sy;
                        x = sx;
                    }
                    else
                    {
                        y = sy;
                        x = -sx;
                    } // end if
                } // end else if
            }
            else
            {
                _loc9 = Math.asin((y + ph / 2) / _loc15);
                y = Math.sin(_loc9) * r0 - ph / 2;
                x = x < 0 ? (-Math.cos(_loc9) * r0) : (Math.cos(_loc9) * r0);
                if (y < sy)
                {
                    if (sx * x > 0)
                    {
                        y = sy;
                        x = sx;
                    }
                    else
                    {
                        y = sy;
                        x = -sx;
                    } // end if
                } // end if
            } // end else if
        } // end else if
        if (sx < 0 && x - sx < 10 || sx > 0 && sx - x < 10)
        {
            if (sx < 0)
            {
                x = -pw + 10;
            } // end if
            if (sx > 0)
            {
                x = pw - 10;
            } // end if
        } // end if
        pages.flip._visible = true;
        pages.flip.p3shadow._visible = this.evalfcovers2() ? (false) : (true);
        pages.pgrad._visible = this.evalfcovers() ? (false) : (true);
        pages.flip.p2._visible = pages.flip.p3._visible = true;
        var _loc13 = x - sx;
        var _loc12 = y - sy;
        var _loc17 = _loc12 / _loc13;
        var _loc16 = -_loc12 / _loc13;
        var _loc7 = sx + _loc13 / 2;
        var _loc6 = sy + _loc12 / 2;
        var _loc4 = Math.sqrt((sx - x) * (sx - x) + (sy - y) * (sy - y));
        _loc9 = Math.asin((sy - y) / _loc4);
        if (sx < 0)
        {
            _loc9 = -_loc9;
        } // end if
        var _loc11 = _loc9 / AM;
        pageN._rotation = _loc11 * 2;
        _loc4 = Math.sqrt((sx - x) * (sx - x) + (sy - y) * (sy - y));
        var _loc5 = pw * 2;
        if (sx > 0)
        {
            pages.mask._xscale = 100;
            var _loc8 = _loc7 - Math.tan(_loc9) * (ph / 2 - _loc6);
            var _loc10 = ph / 2;
            if (_loc8 > pw)
            {
                _loc8 = pw;
                _loc10 = _loc6 + Math.tan(1.570796E+000 + _loc9) * (pw - _loc7);
            } // end if
            pageN.pf._x = -(pw - _loc8);
            pages.flip.fgrad._xscale = _loc4 / _loc5 / 2 * pw;
            pages.pgrad._xscale = -_loc4 / _loc5 / 2 * pw;
            pages.flip.p3shadow._xscale = _loc4 / _loc5 / 2 * pw;
        }
        else
        {
            pages.mask._xscale = -100;
            _loc8 = _loc7 - Math.tan(_loc9) * (ph / 2 - _loc6);
            _loc10 = ph / 2;
            if (_loc8 < -pw)
            {
                _loc8 = -pw;
                _loc10 = _loc6 + Math.tan(1.570796E+000 + _loc9) * (-pw - _loc7);
            } // end if
            pageN.pf._x = -(pw - (pw + _loc8));
            pages.flip.fgrad._xscale = -_loc4 / _loc5 / 2 * pw;
            pages.pgrad._xscale = _loc4 / _loc5 / 2 * pw;
            pages.flip.p3shadow._xscale = -_loc4 / _loc5 / 2 * pw;
        } // end else if
        pages.mask._x = _loc7;
        pages.mask._y = _loc6;
        pages.mask._rotation = _loc11;
        pageN.pf._y = -_loc10;
        pageN._x = _loc8 + offs;
        pageN._y = _loc10;
        pages.flip.fgrad._x = _loc7;
        pages.flip.fgrad._y = _loc6;
        pages.flip.fgrad._rotation = _loc11;
        pages.flip.fgrad._alpha = _loc4 > _loc5 - 50 ? (100 - (_loc4 - (_loc5 - 50)) * 2) : (100);
        pages.flip.p3shadow._x = _loc7;
        pages.flip.p3shadow._y = _loc6;
        pages.flip.p3shadow._rotation = _loc11;
        pages.flip.p3shadow._alpha = _loc4 > _loc5 - 50 ? (100 - (_loc4 - (_loc5 - 50)) * 2) : (100);
        pages.pgrad._x = _loc7;
        pages.pgrad._y = _loc6;
        pages.pgrad._rotation = _loc11 + 180;
        pages.pgrad._alpha = _loc4 > _loc5 - 100 ? (100 - (_loc4 - (_loc5 - 100))) : (100);
        pages.flip.fmask.page._x = pageN._x;
        pages.flip.fmask.page._y = pageN._y;
        pages.flip.fmask.page.pf._x = pageN.pf._x;
        pages.flip.fmask.page.pf._y = pageN.pf._y;
        pages.flip.fmask.page._rotation = pageN._rotation;
    } // End of the function
    function setPages(p1, p2, p3, p4)
    {
        var _loc3 = new Array(p1, p2, p3, p4);
        if (pathC)
        {
            pathC[functC](pagesPosition, pageOrder, _loc3);
        } // end if
        for (var _loc2 = 0; _loc2 < pagesPosition.length; ++_loc2)
        {
            if (_loc3[_loc2] < 0)
            {
                _loc3[_loc2] = 0;
            } // end if
            pagesPosition[_loc2][pageOrder[pagesPosition[_loc2].num]]._visible = false;
            pagesPosition[_loc2][pageOrder[_loc3[_loc2]]]._visible = true;
            pagesPosition[_loc2]._y = _loc3[_loc2] > 2 && _loc3[_loc2] < maxpage - 1 ? (-phh / 2) : (-chh / 2);
            if (!pagesPosition[_loc2][pageOrder[_loc3[_loc2]]].content)
            {
                this.addContent(_loc3[_loc2]);
            } // end if
            pagesPosition[_loc2].num = _loc3[_loc2];
        } // end of for
        this.setSizes();
        var _loc5 = _loc3[0] - 2;
        var _loc6 = _loc3[3] + 2;
        var _loc4 = -2;
        if (_loc5 > _loc4)
        {
            pages.pLL.page.pf.ph._y = -chh / 2;
            pages.pLL._visible = true;
        }
        else
        {
            pages.pLL._visible = false;
        } // end else if
        if (_loc6 < maxpage - _loc4)
        {
            pages.pLR.page.pf.ph._y = -chh / 2;
            pages.pLR._visible = true;
        }
        else
        {
            pages.pLR._visible = false;
        } // end else if
    } // End of the function
    function resetPages()
    {
        this.setPages(page, 0, 0, page + 1);
    } // End of the function
    function autoflip()
    {
        if (!aflip && !flip && !flipOff && canflip)
        {
            acnt = 0;
            var _loc4 = ph / 2;
            aamp = Math.random() * _loc4 - ph / 4;
            var _loc5 = gflip ? (gdir * pw / 2) : (pages._xmouse < 0 ? (-pw / 2) : (pw / 2));
            var _loc2 = pages._ymouse;
            if (_loc2 > 0 && _loc2 > _loc4)
            {
                _loc2 = _loc4;
            } // end if
            if (_loc2 < 0 && _loc2 < -_loc4)
            {
                _loc2 = -_loc4;
            } // end if
            oy = sy = _loc2;
            ax = pages._xmouse < 0 ? (-_loc4) : (_loc4);
            ay = _loc2 * Math.random();
            offs = -pw;
            var _loc3 = 0;
            var _loc6 = true;
            if (_loc5 < 0 && page > 0)
            {
                pages.flip.p3._x = 0;
                if (!preflip || _loc6)
                {
                    if (gskip)
                    {
                        this.setPages(gtarget, gtarget + 1, page, page + 1);
                    }
                    else
                    {
                        this.setPages(page - 2, page - 1, page, page + 1);
                    } // end if
                } // end else if
                _loc3 = -1;
            } // end if
            if (_loc5 > 0 && page < maxpage)
            {
                pages.flip.p3._x = pw;
                if (!preflip || _loc6)
                {
                    if (gskip)
                    {
                        this.setPages(page, gtarget, page + 1, gtarget + 1);
                    }
                    else
                    {
                        this.setPages(page, page + 2, page + 1, page + 3);
                    } // end if
                } // end else if
                _loc3 = 1;
            } // end if
            if (_loc3 == 0)
            {
                _loc3 = 0;
                preflip = false;
                return (false);
            } // end if
            if (_loc3)
            {
                if (endSound)
                {
                    this.playSnd();
                } // end if
                flip = true;
                flipOff = false;
                ox = sx = _loc3 * pw;
                pages.flip.setMask(pages.mask);
                aadd = _loc3 * (pw / (gflip ? (5) : (10)));
                aflip = true;
                pages.flip.fmask._x = pw;
                if (preflip)
                {
                    oy = sy = pages._ymouse < 0 ? (-ph / 2) : (ph / 2);
                } // end if
                r0 = Math.sqrt((sy + ph / 2) * (sy + ph / 2) + pw * pw);
                r1 = Math.sqrt((ph / 2 - sy) * (ph / 2 - sy) + pw * pw);
                pageN = pages.flip.p2.page;
                pageO = pages.flip.p3;
                this.oef();
                return (true);
            } // end if
        }
        else
        {
            return (false);
        } // end else if
    } // End of the function
    function getm()
    {
        if (aflip && !preflip)
        {
            x = ax;
            y = ay;
        }
        else
        {
            x = pages._xmouse;
            y = pages._ymouse;
        } // end else if
    } // End of the function
    function gotoPage(i, skip)
    {
        i = this.getPN(i);
        gskip = skip == undefined ? (false) : (skip);
        if (i < 0)
        {
            return (false);
        } // end if
        var _loc3 = int(page / 2);
        var _loc2 = int(i / 2);
        if (_loc3 != _loc2 && canflip && !gflip)
        {
            if (_loc3 < _loc2)
            {
                gdir = 1;
                gpage = _loc2 - _loc3 - 1;
            }
            else
            {
                gdir = -1;
                gpage = _loc3 - _loc2 - 1;
            } // end else if
            gflip = true;
            if (gskip)
            {
                (gtarget = _loc2 * 2, gpage = 0);
            } // end if
            this.autoflip();
        }
        else
        {
            gskip = false;
        } // end else if
    } // End of the function
    function getPN(i)
    {
        if (i == 0)
        {
            return (0);
        } // end if
        var _loc4 = false;
        for (var _loc2 = 1; _loc2 <= maxpage; ++_loc2)
        {
            if (i == pageNumber[_loc2])
            {
                i = _loc2;
                _loc4 = true;
                break;
            } // end if
        } // end of for
        if (_loc4)
        {
            return (i);
        }
        else
        {
            return (-1);
        } // end else if
    } // End of the function
    function prevPage()
    {
        this.gotoPage(page - 2);
    } // End of the function
    function nextPage()
    {
        this.gotoPage(page + 2);
    } // End of the function
    function playSnd()
    {
        if (sound_temp == sound)
        {
            endSound = false;
            snd.start();
        }
        else
        {
            snd = new Sound();
            endSound = false;
            snd.owner = this;
            snd.onLoad = function ()
            {
                owner.sound_temp = owner.sound;
            };
            snd.loadSound(sound, false);
        } // end else if
        snd.owner = this;
        snd.onSoundComplete = function ()
        {
            owner.endSound = true;
        };
    } // End of the function
    var page = 0;
    var clickarea = 30;
    var afa = 30;
    var gs = 2;
    var ps = 5;
    var es = 3;
    var canflip = true;
    var gpage = 0;
    var gflip = false;
    var gdir = 0;
    var gskip = false;
    var gtarget = 0;
    var aflip = false;
    var flip = false;
    var flipOff = false;
    var flipOK = false;
    var preflip = false;
    var mpx = 0;
    var mpy = 0;
    var sx = 0;
    var sy = 0;
    var x = 0;
    var y = 0;
    var ax = 0;
    var ay = 0;
    var acnt = 0;
    var aadd = 0;
    var aamp = 0;
    var AM = 1.745329E-002;
} // End of Class
