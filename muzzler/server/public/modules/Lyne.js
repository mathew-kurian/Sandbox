// Lyne.js (Graph)
// Copyright 2013 by Mathew Kurian
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT SPLICEED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

var Lyne = {};

Lyne.Graph = function Graph(Dataset, DOMCanvas, Opts, Labels) {

    if (typeof Dataset === 'undefined')
        return;

    if (typeof DOMCanvas === 'undefined' || $(DOMCanvas).attr('data-lyne-enabled') == 'true')
        return;

    if (typeof Opts === 'undefined')
        Opts = Lyne.Themes.Dark;

    var _DISTRO = this;

    _canvas = DOMCanvas,
    _canvas_parent = $(DOMCanvas).parent();
    _DISTRO.dataset = Dataset;
    _DISTRO.labels = typeof Labels === 'undefined' ? Dataset : Labels;

    var canvas,
        context,
        _context,
        canvas_fps = 0,
        canvas_temp_fps = 0,
        canvas_fpsFilter = 50,
        canvas_fpsTimeNow = 0,
        canvas_fpsTimeLast = 0,
        _resId = 0,
        _repaintFrameId = 0,
        _dataQueueNext,
        _ready = true,
        _generate = false;


    // finally query the various pixel ratios
    var devicePixelRatio = window.devicePixelRatio || 1;
    ratio = 1;


    _DISTRO.canvas_width = 0,
    _DISTRO.canvas_height = 0,
    _DISTRO.canvas_translate = 0.5;

    _DISTRO.yaxis_spacing = 0,
    _DISTRO.yaxis_lines = 0,
    _DISTRO.yaxis_scale = 0;

    _DISTRO.xaxis_spacing = 0,
    _DISTRO._xaxis_spacing = 0,
    _DISTRO.xaxis_lines = 0,
    _DISTRO.xaxis_scale = 0;

    // var _DISTRO.dataset = [ 10, 80, 50, 240, 50.5 , 80.5, 100, 400 ];

    _DISTRO.animationYStartStretch = 0,
    _DISTRO.animationXStartStretch = 2
    _DISTRO.animation_offset = 0;

    _DISTRO.dataExtendedLeftOffsetX = 0,
    _DISTRO.dataExtendedLeft = 0,
    _DISTRO.dataExtendedRight = 0;

    _DISTRO.VarTweener = {
        vars: {},
        history: {},

        add: function(key, value, zero, callback) {
            zero = typeof zero !== 'undefined' ? zero : false;

            if (isNaN(value) || typeof _DISTRO[key] === 'undefined')
                return;

            if (typeof this.history[key] === 'undefined')
                if (typeof _DISTRO[key] !== 'undefined' && history)
                    this.history[key] = [_DISTRO[key]];
                else
                    this.history[key] = [0];

            if (typeof this.vars[key] === 'undefined')
                this.vars[key] = [];

            var _var = {
                value: value,
                zero: zero,
                callback: callback
            };

            this.vars[key].push(_var);

            if (this.vars[key].length > 1 && Opts.animationClearQueue) {
                var arr = this.vars[key];
                this.history[key].push(_DISTRO[key]);
                this.vars[key].splice(0, 1);
            }
        },
        update: function() {
            for (var key in this.vars) {

                var arr = this.vars[key];

                if (typeof arr[0] == 'undefined') continue;

                var zero = arr[0].zero,
                    callback = arr[0].callback,
                    total = arr[0].value,
                    finished = false,
                    current = this.history[key].last(),
                    currentTime = (new Date()).getTime(),
                    startTime = typeof arr[0].time === 'undefined' ? (arr[0].time = currentTime) : arr[0].time;

                current = Number(Lyne.Tween[Lyne.Tween.
                    default](
                    currentTime - startTime,
                    current,
                    total - current,
                    Opts.animationTime
                ).toFixed(4));

                if (finished = ((currentTime - startTime + _DISTRO.animation_offset / 2) >= Opts.animationTime)) {
                    this.history[key].push(zero ? _DISTRO[key] = 0 : _DISTRO[key] = total);
                    this.history[key].splice(0, 1);

                    // _DISTRO[key] = total;
                    arr.splice(0, 1);

                } else {
                    _DISTRO[key] = current;
                }

                if (typeof callback !== 'undefined')
                    callback(finished);
            }
        },
        debug: function() {
            if (!Opts.debugVarTweener) return;

            context.font = Opts.debugVarTweenerLabelFontWeight + ' ' + Opts.debugVarTweenerLabelFontSize + ' ' + Opts.debugVarTweenerLabelFontFamily;
            context.textAlign = 'right';

            var i = 0;
            for (var key in this.vars) {
                context.lyneTextShadowText(
                    key + ' : ' + _DISTRO[key],
                    toX(_DISTRO.canvas_width * devicePixelRatio - Opts.canvasPadding / 2), (parseInt(Opts.debugVarTweenerLabelFontSize) + 2) * ++i + Opts.canvasPadding / 2,
                    Opts.debugVarTweenerLabelStrokeStyle,
                    Opts.debugVarTweenerLabelTextShadowStrokeStyle,
                    Opts.debugVarTweenerLabelTextShadowOffsetY
                );
            }
        }
    };

    function debugAboutLyneJS(id) {
        if (!Opts.debugAboutLyne) return;

        _repaintFrameId = ++_repaintFrameId % 5000;

        context.font = Opts.debugAboutLyneLabelFontWeight + ' ' + Opts.debugAboutLyneLabelFontSize + ' ' + Opts.debugAboutLyneLabelFontFamily;
        context.textAlign = 'left';

        context.lyneTextShadowText(
            "LYNE.JS | REPAINTING: " +
            CanvasManager.repainting.toString().toUpperCase() +
            " | SERIAL_ID: " +
            id +
            " | FPS: " +
            canvas_fps +
            " | FRAME_ID: " +
            _repaintFrameId,
            toX(Opts.canvasPadding / 2),
            Opts.canvasPadding / 2,
            Opts.debugAboutLyneLabelStrokeStyle,
            Opts.debugAboutLyneLabelTextShadowStrokeStyle,
            Opts.debugAboutLyneLabelTextShadowOffsetY
        );
    }

    function canvasResize() {

        _context.canvas.width = context.canvas.width = $(_canvas_parent).width();
        _context.canvas.height = context.canvas.height = $(_canvas_parent).height();

        devicePixelRatio = window.devicePixelRatio || 1;

        backingStoreRatio = context.webkitBackingStorePixelRatio ||
            context.mozBackingStorePixelRatio ||
            context.msBackingStorePixelRatio ||
            context.oBackingStorePixelRatio ||
            context.backingStorePixelRatio || 1;

        ratio = devicePixelRatio / backingStoreRatio;

        // upscale the canvas if the two ratios don't match

        var canvas = context.canvas;

        var oldWidth = parseInt(canvas.width);
        var oldHeight = parseInt(canvas.height);

        _context.canvas.width = context.canvas.width = oldWidth * ratio;
        _context.canvas.height = context.canvas.height = oldHeight * ratio;

        _context.canvas.style.width = context.canvas.style.width = oldWidth + 'px';
        _context.canvas.style.height = context.canvas.style.height = oldHeight + 'px';

        // now scale the context to counter
        // the fact that we've manually scaled
        // our canvas element
        context.scale(ratio, ratio);

        animationNoRepeat('FORCED-ON-RESIZE');

        clearTimeout(_resId);

        _resId = setTimeout(function() {

            _DISTRO.VarTweener.add('canvas_width', context.canvas.width);
            _DISTRO.VarTweener.add('canvas_height', context.canvas.height);

            calculateYAxis();
            calculateXAxis();

            if (_DISTRO.dataExtendedLeftOffsetX > 0)
                _DISTRO.VarTweener.add('dataExtendedLeftOffsetX', _DISTRO._xaxis_spacing, true, function(finished) {
                    if (finished)
                        _dataQueueNext();
                });

            CanvasManager.repaint();

        }, 500);
    }

    var CanvasManager = {
        _rptId: 0,
        repainting: false,
        repaintDuration: 2 * Opts.animationTime,
        repaint: function() {

            // Start repainting if it is finished
            if (!this.repainting) {
                this.repainting = true;
                animationRepeated(guid());
            }

            // Push more time for repainting. Always keep minimum time for
            // animation 2 X Opts.animationTime.
            // this.repaintDuration += Opts.animationTime;

            clearTimeout(this._rptId);

            this._rptId = setTimeout(function() {

                // Reset animation duration
                this.repaintDuration = Opts.animationTime * 2;

                // Disable animations
                CanvasManager.repainting = false;

            }, this.repaintDuration);
        }
    }

        function canvasStart() {

            // Mark as Lyne-enabled to prevent multiple instances
            $(_canvas).attr('data-lyne-enabled', 'true');

            _context = _canvas.getContext('2d');

            canvas = document.createElement('canvas');
            context = canvas.getContext('2d');

            _DISTRO.animationYStartStretch = Opts.animationYStartStretch;
            _DISTRO.animationXStartStretch = Opts.animationXStartStretch;

            _DISTRO.dataExtendedRight = _DISTRO.dataset.last();

            context.webkitImageSmoothingEnabled = true;
            _context.webkitImageSmoothingEnabled = true;

            canvasResize();

            setTimeout(function() {
                _DISTRO.VarTweener.add('animationYStartStretch', 1);
                _DISTRO.VarTweener.add('animationXStartStretch', 1);
            }, Opts.animationTime);

            // $(window).resize(canvasResize);

            console.log('Lyne Instance Started');

        }

        function calculateYAxis() {
            var max = 0,
                _orig = 0,
                height = context.canvas.height,
                width = context.canvas.width,
                _adjusted = 0,
                _adjustedIncremented = 0;

            max = Math.max.apply(null, _DISTRO.dataset);

            _spacing = Lyne.Tween.logInExpOut(
                height * max, (Opts.yAxisGridSpacingMax - Opts.yAxisGridSpacingMin),
                100,
                Opts.yAxisGridSpacingMin
            );


            _lines = (height - Opts.canvasPadding * 2) / _spacing;
            _scale = ((max + max / 8) / (height - Opts.canvasPadding * 2));

            _origUnit = _scale * _spacing;
            _adjustedUnit = Number((_origUnit).toFixed()).roundTo(5);
            _adjustedIncrementedUnit = (Number((_origUnit).toFixed()) + 2.5).roundTo(5);

            _scale = (_origUnit > _adjustedUnit ? _adjustedIncrementedUnit : _adjustedUnit) / _spacing;

            _DISTRO.VarTweener.add('yaxis_spacing', _spacing);
            _DISTRO.VarTweener.add('yaxis_lines', _lines);
            _DISTRO.VarTweener.add('yaxis_scale', _scale);
        }

        function calculateXAxis() {

            var height = context.canvas.height,
                width = context.canvas.width,
                _lines = _DISTRO.dataExtendedLeftOffsetX ? _DISTRO.dataset.length - 1 : _DISTRO.dataset.length;
            _spacing = (width - Opts.canvasPadding * 2) / _lines;
            _spacing = _spacing + _spacing / _lines;

            _DISTRO.VarTweener.add('xaxis_spacing', _DISTRO._xaxis_spacing = _spacing);
            _DISTRO.VarTweener.add('xaxis_lines', ++_lines);
        }

        function drawYAxis() {
            for (var x = 0; x < _DISTRO.yaxis_lines; x++) {
                if (x) {
                    context.strokeStyle = Opts.yAxisGridStrokeStyle;
                    context.lineWidth = Opts.yAxisGridLineWidth;
                    context.lyneDrawLine(
                        toX(Opts.canvasPadding + Opts.yAxisGridLineWidth),
                        toY(Opts.canvasPadding + (_DISTRO.yaxis_spacing * x)),
                        toX(_DISTRO.canvas_width * devicePixelRatio - Opts.canvasPadding),
                        toY(Opts.canvasPadding + (_DISTRO.yaxis_spacing * x))
                    );
                }

                context.font = Opts.yAxisLabelFontWeight + ' ' + Opts.yAxisLabelFontSize + ' ' + Opts.yAxisLabelFontFamily;
                context.textAlign = 'right';
                context.lyneTextShadowText(
                    (x * _DISTRO.yaxis_spacing * _DISTRO.yaxis_scale + 0.5) << 0,
                    Opts.canvasPadding - 10,
                    toY(Opts.canvasPadding + (_DISTRO.yaxis_spacing * x - 5)),
                    Opts.yAxisLabelStrokeStyle,
                    Opts.yAxisLabelTextShadowStrokeStyle,
                    Opts.yAxisLabelTextShadowOffsetY
                );
            }
        }

        function drawXAxis() {
            for (var x = 0; x < _DISTRO.xaxis_lines; x++) {
                context.strokeStyle = Opts.xAxisGridStrokeStyle;
                context.lineWidth = Opts.xAxisGridLineWidth;
                context.lyneDrawLine(
                    toX(Opts.canvasPadding + _DISTRO.xaxis_spacing * x) - _DISTRO.dataExtendedLeftOffsetX,
                    toY(Opts.canvasPadding + Opts.xAxisGridLineWidth),
                    toX(Opts.canvasPadding + _DISTRO.xaxis_spacing * x) - _DISTRO.dataExtendedLeftOffsetX,
                    toY(_DISTRO.canvas_height * devicePixelRatio - Opts.canvasPadding - Opts.xAxisGridLineWidth)
                );

                var text = typeof _DISTRO.labels[x]  !== 'undefined' ? _DISTRO.labels[x] :
                           (typeof _DISTRO.dataset[x] !== 'undefined' ? _DISTRO.dataset[x] : undefined);

                if(typeof text !== 'undefined'){
                    context.font = Opts.xAxisLabelFontWeight + ' ' + Opts.xAxisLabelFontSize + ' ' + Opts.xAxisLabelFontFamily;
                    context.textAlign = 'center';
                    context.lyneTextShadowText(
                        text,
                        Opts.canvasPadding + _DISTRO.xaxis_spacing * x - _DISTRO.dataExtendedLeftOffsetX,
                        toY(Opts.canvasPadding - 20),
                        Opts.xAxisLabelStrokeStyle,
                        Opts.xAxisLabelTextShadowStrokeStyle,
                        Opts.xAxisLabelTextShadowOffsetY
                    );
                }
            }
        }

        function plotData() {

            context.strokeStyle = Opts.plotPointStrokeStyle;
            context.fillStyle = Opts.plotPointFillStyle;
            context.lineWidth = Opts.plotPointLineWidth;

            for (var x = 0; x < _DISTRO.dataset.length; x++) {
                context.beginPath();
                context.arc(
                    toX(Opts.canvasPadding + _DISTRO.xaxis_spacing * x) - _DISTRO.dataExtendedLeftOffsetX,
                    toY(Opts.canvasPadding + _DISTRO.dataset[x] / _DISTRO.yaxis_scale * _DISTRO.animationYStartStretch),
                    Opts.plotPointRadius,
                    0,
                    2 * Math.PI);
                context.stroke();
                context.fill();
            }
        }

        function fillData() {

            var fillGradient = context.createLinearGradient(
                0, (Opts.plotAreaFillGradientStyle ? _DISTRO.canvas_height * devicePixelRatio : 0), (Opts.plotAreaFillGradientStyle ? 0 : _DISTRO.canvas_width * devicePixelRatio),
                0
            );

            var strokeGradient = context.createLinearGradient(0, 0, _DISTRO.canvas_width * devicePixelRatio, 0);

            var _lastX = 0,
                _lastY = 0;

            fillGradient.addColorStop(0, Opts.plotAreaFillColorStart);
            fillGradient.addColorStop(1, Opts.plotAreaFillColorStop);

            strokeGradient.addColorStop(0, Opts.plotAreaStrokeColorStart);
            strokeGradient.addColorStop(1, Opts.plotAreaStrokeColorStop);

            context.strokeStyle = strokeGradient;
            context.fillStyle = fillGradient;
            context.lineWidth = Opts.plotAreaLineWidth;

            context.beginPath();

            context.save();
            context.rect(
                Opts.canvasPadding + _DISTRO.canvas_translate,
                Opts.canvasPadding + _DISTRO.canvas_translate,
                context.canvas.width - Opts.canvasPadding * 2,
                context.canvas.height - Opts.canvasPadding * 2
            );

            context.clip();

            context.beginPath();
            context.moveTo(
                toX(_lastX = Opts.canvasPadding) - _DISTRO.dataExtendedLeftOffsetX,
                toY(Opts.canvasPadding + _DISTRO.dataset[0] / _DISTRO.yaxis_scale * _DISTRO.animationYStartStretch)
            );

            for (var x = 1; x < _DISTRO.dataset.length; x++) {
                var _cacheX = toX(((Opts.canvasPadding + _DISTRO.xaxis_spacing * x) + _lastX) * 0.5) * _DISTRO.animationXStartStretch - _DISTRO.dataExtendedLeftOffsetX;
                context.bezierCurveTo(
                    _cacheX,
                    toY((Opts.canvasPadding + _DISTRO.dataset[x - 1] / _DISTRO.yaxis_scale * _DISTRO.animationYStartStretch)),
                    _cacheX,
                    toY((Opts.canvasPadding + _DISTRO.dataset[x] / _DISTRO.yaxis_scale * _DISTRO.animationYStartStretch)),
                    toX(Opts.canvasPadding + _DISTRO.xaxis_spacing * x) * _DISTRO.animationXStartStretch - _DISTRO.dataExtendedLeftOffsetX,
                    toY(Opts.canvasPadding + _DISTRO.dataset[x] / _DISTRO.yaxis_scale * _DISTRO.animationYStartStretch)
                );

                _lastX = Opts.canvasPadding + _DISTRO.xaxis_spacing * x;
            }


            context.bezierCurveTo(
                toX(((Opts.canvasPadding + _DISTRO.xaxis_spacing * x) + _lastX) * 0.5) * _DISTRO.animationXStartStretch - _DISTRO.dataExtendedLeftOffsetX + Opts.canvasPadding * 2 * _DISTRO.animationXStartStretch,
                toY((Opts.canvasPadding + _DISTRO.dataset.last() / _DISTRO.yaxis_scale * _DISTRO.animationYStartStretch)),
                toX(((Opts.canvasPadding + _DISTRO.xaxis_spacing * x) + _lastX) * 0.5) * _DISTRO.animationXStartStretch - _DISTRO.dataExtendedLeftOffsetX + Opts.canvasPadding * 2 * _DISTRO.animationXStartStretch,
                toY((Opts.canvasPadding + _DISTRO.dataExtendedRight / _DISTRO.yaxis_scale * _DISTRO.animationYStartStretch)),
                toX(Opts.canvasPadding + _DISTRO.xaxis_spacing * x) * _DISTRO.animationXStartStretch - _DISTRO.dataExtendedLeftOffsetX + Opts.canvasPadding * 2 * _DISTRO.animationXStartStretch,
                toY(Opts.canvasPadding + _DISTRO.dataExtendedRight / _DISTRO.yaxis_scale * _DISTRO.animationYStartStretch)
            );


            context.stroke();

            context.lineTo(
                toX(Opts.canvasPadding + _DISTRO.xaxis_spacing * x) * _DISTRO.animationXStartStretch - _DISTRO.dataExtendedLeftOffsetX + Opts.canvasPadding * 2 * _DISTRO.animationXStartStretch,
                toY(Opts.canvasPadding)
            );

            context.lineTo(
                toX(Opts.canvasPadding) - _DISTRO.dataExtendedLeftOffsetX,
                toY(Opts.canvasPadding)
            );

            context.lineTo(
                toX(Opts.canvasPadding) - _DISTRO.dataExtendedLeftOffsetX,
                toY(Opts.canvasPadding + _DISTRO.dataset[0] / _DISTRO.yaxis_scale)
            );



            context.fill();

            context.restore();
        }

        function toX(point) {
            return point + _DISTRO.canvas_translate;
        }

        function toY(point) {
            return canvas.height - point + _DISTRO.canvas_translate;
        }

        function drawXYAxis() {

            context.lineWidth = Opts.xyAxisLineWidth;
            context.strokeStyle = Opts.xyAxisStrokeStyle;

            context.lyneDrawLine(
                toX(Opts.canvasPadding),
                toY(Opts.canvasPadding),
                toX(Opts.canvasPadding),
                toY(_DISTRO.canvas_height * devicePixelRatio - Opts.canvasPadding)
            );


            context.lyneDrawLine(
                toX(Opts.canvasPadding),
                toY(Opts.canvasPadding),
                toX(_DISTRO.canvas_width * devicePixelRatio - Opts.canvasPadding),
                toY(Opts.canvasPadding)
            );
        }

        function redraw() {
            drawYAxis();
            drawXAxis();

            fillData();

            drawXYAxis();

            plotData();
        }

        function calculateFPS() {
            if (!canvas_fpsTimeLast) {
                canvas_fpsTimeLast = (new Date()).getTime();
                return;
            }

            canvas_temp_fps = 1000 / (_DISTRO.animation_offset = (canvas_fpsTimeNow = (new Date()).getTime()) - canvas_fpsTimeLast);
            canvas_fps += (canvas_temp_fps - canvas_fps) / canvas_fpsFilter;
            canvas_fps = (0.5 + canvas_fps) << 0;
            canvas_fpsTimeLast = canvas_fpsTimeNow;
        }

        function animationRepeated(id) {
            if (CanvasManager.repainting)
                requestAnimFrame(function() {
                    _context.clearRect(0, 0, canvas.width, canvas.height);
                    _context.drawImage(canvas, 0, 0);
                    context.clearRect(0, 0, canvas.width, canvas.height);
                    calculateFPS();
                    redraw();
                    _DISTRO.VarTweener.update();
                    _DISTRO.VarTweener.debug();
                    debugAboutLyneJS(id);
                    animationRepeated(id);
                });
        }

        function animationNoRepeat(id) {
            requestAnimFrame(function() {
                _context.clearRect(0, 0, canvas.width, canvas.height);
                _context.drawImage(canvas, 0, 0);
                context.clearRect(0, 0, canvas.width, canvas.height);
                redraw();
                _DISTRO.VarTweener.update();
                _DISTRO.VarTweener.debug();
                debugAboutLyneJS(id);
            });
        }

        function addData(value, callback) {
            if (!_ready) return;
            else _ready = false;

            CanvasManager.repaint();
            _DISTRO.dataset.push(value);
            _DISTRO.VarTweener.add('dataExtendedRight', value, false);
            calculateYAxis();
            calculateXAxis();
            setReady(true, _DISTRO.animationTime, callback);
        }

    var _isReadyId = 0;

    function setReady(value, delay, callback) {
        callback = typeof callback === 'undefined' ? function() {} : callback;


        clearTimeout(_isReadyId);

        if (delay) {
            _isReadyId = setTimeout(function() {
                _ready = value;
                callback();
            }, delay);
        } else {
            _ready = value;
            callback();
        }
    }

    function removeData(index, callback) {

        if (!_ready || _DISTRO.dataset.length == 0 || index > _DISTRO.dataset.length - 1) return;
        else _ready = false;

        CanvasManager.repaint();
        if (index == _DISTRO.dataset.length - 1) {
            _DISTRO.dataset.safeSplice(_DISTRO.dataset.length - 1);
            _DISTRO.VarTweener.add('dataExtendedRight', _DISTRO.dataset[_DISTRO.dataset.length - 2], false);
            calculateXAxis();
            setReady(true, _DISTRO.animationTime, callback);
        } else {
            _DISTRO.VarTweener.add('dataExtendedRight', _DISTRO.dataset[_DISTRO.dataset.length - 1], false);
            for (var i = index; i < _DISTRO.dataset.length; i++) {
                (function(i, varname) {
                    _DISTRO[varname] = _DISTRO.dataset[i];
                    _DISTRO.VarTweener.add(varname, _DISTRO.dataset[i + 1], false, function(finished) {
                        _DISTRO.dataset[i] = _DISTRO[varname];
                        if (finished)
                            CanvasManager.repaint();
                        if (i == _DISTRO.dataset.length - 2 && finished) {
                            if (_DISTRO.dataset.length - 1 == 0) {
                                _DISTRO.VarTweener.add('animationYStartStretch', Opts.animationYStartStretch);
                                _DISTRO.VarTweener.add('animationXStartStretch', Opts.animationXStartStretch, function(finished) {
                                    if (finished)
                                        _DISTRO.dataset.safeSplice(_DISTRO.dataset.length - 1);
                                });
                            } else {
                                _DISTRO.dataset.safeSplice(_DISTRO.dataset.length - 1);
                                calculateXAxis();
                                calculateYAxis();
                            }

                            setReady(true, _DISTRO.animationTime, callback)
                        }
                    });
                })(i, 'dataVariator_' + i);
            }
        }
    }

    function dataQueue(value, callback) {
        CanvasManager.repaint();

        if (!_ready) return;
        else _ready = false;

        var _cancel = false;

        _dataQueueNext = function() {
            if (_cancel) return;
            _cancel = true;
            _DISTRO.dataset.splice(0, 1);
            calculateYAxis();
            setReady(true, 0, callback);
        }

        if (_DISTRO.VarTweener.history['dataExtendedRight'])
            _DISTRO.VarTweener.history['dataExtendedRight'].push(_DISTRO.dataset.last());

        _DISTRO.dataset.push(_DISTRO.dataset[_DISTRO.dataset.length - 1]);

        _DISTRO.VarTweener.add('dataExtendedRight', value, false, function(finished) {
            _DISTRO.dataset[_DISTRO.dataset.length - 1] = _DISTRO.dataExtendedRight;
        });

        _DISTRO.dataExtendedLeft = _DISTRO.dataset[0];
        _DISTRO.VarTweener.add('dataExtendedLeft', _DISTRO.dataset[1], false, function(finished) {
            _DISTRO.dataset[0] = _DISTRO.dataExtendedLeft;
        });

        _DISTRO.VarTweener.add('dataExtendedLeftOffsetX', _DISTRO._xaxis_spacing, true, function(finished) {
            if (finished)
                _dataQueueNext();
        });
    }

    function startGenerate() {
        if (_generate)
            dataQueue(parseInt((Math.random() * 5000).toFixed()), function() {
                if (_generate)
                    dataQueue(parseInt((Math.random() * 5000).toFixed()), startGenerate)
            });
    }

    canvasStart();

    return {
        add: addData,
        remove: removeData,
        resize : canvasResize,
        startGenerate: function() {
            _generate = true;
            startGenerate();
        },
        cancelGenerate: function() {
            _generate = false;
        },
        dataQueue: dataQueue,
        repaint: CanvasManager.repaint,
        isReady: function() {
            return _ready;
        }
    };

}

Lyne.Themes = {
    Dark: {
        xyAxisStrokeStyle: '#FFF',
        xyAxisLineWidth: 2,
        /*-------------------------------------*/
        yAxisLabelTextShadowStrokeStyle: "transparent",
        yAxisLabelTextShadowOffsetY: 1,
        yAxisLabelStrokeStyle: "#777",
        yAxisLabelFontSize: "12px",
        yAxisLabelFontWeight: "300",
        yAxisLabelFontFamily: "'Proxima Nova'",
        yAxisGridSpacingMin: 15,
        yAxisGridSpacingMax: 55,
        yAxisGridStrokeStyle: "rgba(255,255,255, 0.03)",
        yAxisGridLineWidth: 1,
        /*-------------------------------------*/
        xAxisLabelTextShadowStrokeStyle: "transparent",
        xAxisLabelTextShadowOffsetY: 1,
        xAxisGridStrokeStyle: "rgba(255,255,255, 0.03)",
        xAxisGridLineWidth: 1,
        xAxisLabelStrokeStyle: "#777",
        xAxisLabelFontSize: "12px",
        xAxisLabelFontWeight: "300",
        xAxisLabelFontFamily: "'Proxima Nova'",
        /*-------------------------------------*/
        plotPointStrokeStyle: '#222',
        plotPointFillStyle: '#FFF',
        plotPointLineWidth: 8,
        plotPointRadius: 3,
        /*-------------------------------------*/
        plotAreaFillGradientStyle: 1, // { 1 : vertical } { 0 : horizontal }
        plotAreaStrokeColorStart: '#FFF',
        plotAreaStrokeColorStop: '#FFF',
        plotAreaFillColorStart: '#111111',
        plotAreaFillColorStop: '#333333',
        plotAreaLineWidth: 3,
        /*-------------------------------------*/
        canvasPadding: 50,
        /*-------------------------------------*/
        debugVarTweener: false,
        debugVarTweenerLabelTextShadowStrokeStyle: "transparent",
        debugVarTweenerLabelTextShadowOffsetY: 1,
        debugVarTweenerLabelStrokeStyle: "#555",
        debugVarTweenerLabelFontSize: "10px",
        debugVarTweenerLabelFontWeight: "bold",
        debugVarTweenerLabelFontFamily: "'Proxima Nova'",
        /*-------------------------------------*/
        debugAboutLyne: false,
        debugAboutLyneLabelTextShadowStrokeStyle: "transparent",
        debugAboutLyneLabelTextShadowOffsetY: 1,
        debugAboutLyneLabelStrokeStyle: "#777",
        debugAboutLyneLabelFontSize: "10px",
        debugAboutLyneLabelFontWeight: "bold",
        debugAboutLyneLabelFontFamily: "'Proxima Nova'",
        /*-------------------------------------*/
        animationTime: 1800,
        animationYStartStretch: 0,
        animationXStartStretch: 2,
        animationClearQueue: true
    },
    Light: {
        xyAxisStrokeStyle: '#eeeedd',
        xyAxisLineWidth: 2,
        /*-------------------------------------*/
        yAxisLabelTextShadowStrokeStyle: "#DDD",
        yAxisLabelTextShadowOffsetY: 1,
        yAxisLabelStrokeStyle: "#555",
        yAxisLabelFontSize: "12px",
        yAxisLabelFontWeight: "300",
        yAxisLabelFontFamily: "'Proxima Nova'",
        yAxisGridSpacingMin: 15,
        yAxisGridSpacingMax: 55,
        yAxisGridStrokeStyle: "rgba(255,255,255, 0.1)",
        yAxisGridLineWidth: 1,
        /*-------------------------------------*/
        xAxisLabelTextShadowStrokeStyle: "#DDD",
        xAxisLabelTextShadowOffsetY: 1,
        xAxisGridStrokeStyle: "rgba(255,255,255, 0.1)",
        xAxisGridLineWidth: 1,
        xAxisLabelStrokeStyle: "#555",
        xAxisLabelFontSize: "12px",
        xAxisLabelFontWeight: "300",
        xAxisLabelFontFamily: "'Proxima Nova'",
        /*-------------------------------------*/
        plotPointStrokeStyle: '#eeeedd',
        plotPointFillStyle: '#222',
        plotPointLineWidth: 8,
        plotPointRadius: 3,
        /*-------------------------------------*/
        plotAreaFillGradientStyle: 1, // { 1 : vertical } { 0 : horizontal }
        plotAreaStrokeColorStart: '#eeeedd',
        plotAreaStrokeColorStop: '#eeeedd',
        plotAreaFillColorStart: '#333',
        plotAreaFillColorStop: '#333',
        plotAreaLineWidth: 3,
        /*-------------------------------------*/
        canvasPadding: 50,
        /*-------------------------------------*/
        debugVarTweener: true,
        debugVarTweenerLabelTextShadowStrokeStyle: "#DDD",
        debugVarTweenerLabelTextShadowOffsetY: 1,
        debugVarTweenerLabelStrokeStyle: "#555",
        debugVarTweenerLabelFontSize: "10px",
        debugVarTweenerLabelFontWeight: "bold",
        debugVarTweenerLabelFontFamily: "'Proxima Nova'",
        /*-------------------------------------*/
        debugAboutLyne: true,
        debugAboutLyneLabelTextShadowStrokeStyle: "#DDD",
        debugAboutLyneLabelTextShadowOffsetY: 1,
        debugAboutLyneLabelStrokeStyle: "#555",
        debugAboutLyneLabelFontSize: "10px",
        debugAboutLyneLabelFontWeight: "bold",
        debugAboutLyneLabelFontFamily: "'Proxima Nova'",
        /*-------------------------------------*/
        animationTime: 1800,
        animationYStartStretch: 0,
        animationXStartStretch: 2,
        animationClearQueue: true
    }
}

Lyne.Start = function Start() {

    Array.prototype.last = function() {
        return this[this.length - 1];
    };

    Array.prototype.safeSplice = function(from, to) {
        var rest = this.slice((to || from) + 1 || this.length);
        this.length = from < 0 ? this.length + from : from;
        return this.push.apply(this, rest);
    };

    Number.prototype.roundTo = function(num) {
        var resto = this % num;
        if (resto <= (num / 2)) {
            return this - resto;
        } else {
            return this + num - resto;
        }
    };

    CanvasRenderingContext2D.prototype.lyneDrawLine = function(a, b, c, d) {
        this.beginPath();
        this.moveTo(a, b);
        this.lineTo(c, d);
        this.stroke();
    };

    CanvasRenderingContext2D.prototype.lyneTextShadowText = function(text, x, y, textColor, shadowColor, offset) {
        this.fillStyle = shadowColor;
        this.fillText(text, x, y + offset);
        this.fillStyle = textColor;
        this.fillText(text, x, y);
    };

    window['guid'] = function() {
        var s4 = function() {
            return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
        };
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
            s4() + '-' + s4() + s4() + s4();
    }

    window['requestAnimFrame'] = (function(callback) {
        return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame ||
            function(callback) {
                window.setTimeout(callback, 1000 / 60);
        };
    })();

};

Lyne.Tween = {
    default: 'easeOutQuart',
    linear: function(t, b, c, d) {
        return c * t / d + b;
    },
    easeInQuad: function(t, b, c, d) {
        return c * (t /= d) * t + b;
    },
    easeOutQuad: function(t, b, c, d) {
        return -c * (t /= d) * (t - 2) + b;
    },
    easeInOutQuad: function(t, b, c, d) {
        if ((t /= d / 2) < 1) return c / 2 * t * t + b;
        return -c / 2 * ((--t) * (t - 2) - 1) + b;
    },
    easeInCubic: function(t, b, c, d) {
        return c * (t /= d) * t * t + b;
    },
    easeOutCubic: function(t, b, c, d) {
        return c * ((t = t / d - 1) * t * t + 1) + b;
    },
    easeInOutCubic: function(t, b, c, d) {
        if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
        return c / 2 * ((t -= 2) * t * t + 2) + b;
    },
    easeInQuart: function(t, b, c, d) {
        return c * (t /= d) * t * t * t + b;
    },
    easeOutQuart: function(t, b, c, d) {
        return -c * ((t = t / d - 1) * t * t * t - 1) + b;
    },
    easeInOutQuart: function(t, b, c, d) {
        if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
        return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
    },
    easeInQuint: function(t, b, c, d) {
        return c * (t /= d) * t * t * t * t + b;
    },
    easeOutQuint: function(t, b, c, d) {
        return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
    },
    easeInOutQuint: function(t, b, c, d) {
        if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
        return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
    },
    easeInSine: function(t, b, c, d) {
        return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
    },
    easeOutSine: function(t, b, c, d) {
        return c * Math.sin(t / d * (Math.PI / 2)) + b;
    },
    easeInOutSine: function(t, b, c, d) {
        return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
    },
    easeInExpo: function(t, b, c, d) {
        return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;
    },
    easeOutExpo: function(t, b, c, d) {
        return (t == d) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
    },
    easeInOutExpo: function(t, b, c, d) {
        if (t == 0) return b;
        if (t == d) return b + c;
        if ((t /= d / 2) < 1) return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
        return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
    },
    easeInCirc: function(t, b, c, d) {
        return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
    },
    easeOutCirc: function(t, b, c, d) {
        return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
    },
    easeInOutCirc: function(t, b, c, d) {
        if ((t /= d / 2) < 1) return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
        return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
    },
    easeInElastic: function(t, b, c, d) {
        var s = 1.70158;
        var p = 0;
        var a = c;
        if (t == 0) return b;
        if ((t /= d) == 1) return b + c;
        if (!p) p = d * .3;
        if (a < Math.abs(c)) {
            a = c;
            var s = p / 4;
        } else var s = p / (2 * Math.PI) * Math.asin(c / a);
        return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
    },
    easeOutElastic: function(t, b, c, d) {
        var s = 1.70158;
        var p = 0;
        var a = c;
        if (t == 0) return b;
        if ((t /= d) == 1) return b + c;
        if (!p) p = d * .3;
        if (a < Math.abs(c)) {
            a = c;
            var s = p / 4;
        } else var s = p / (2 * Math.PI) * Math.asin(c / a);
        return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
    },
    easeInOutElastic: function(t, b, c, d) {
        var s = 1.70158;
        var p = 0;
        var a = c;
        if (t == 0) return b;
        if ((t /= d / 2) == 2) return b + c;
        if (!p) p = d * (.3 * 1.5);
        if (a < Math.abs(c)) {
            a = c;
            var s = p / 4;
        } else var s = p / (2 * Math.PI) * Math.asin(c / a);
        if (t < 1) return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
        return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * .5 + c + b;
    },
    easeInBack: function(t, b, c, d, s) {
        if (s == undefined) s = 1.70158;
        return c * (t /= d) * t * ((s + 1) * t - s) + b;
    },
    easeOutBack: function(t, b, c, d, s) {
        if (s == undefined) s = 1.70158;
        return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
    },
    easeInOutBack: function(t, b, c, d, s) {
        if (s == undefined) s = 1.70158;
        if ((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
        return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
    },
    easeInBounce: function(t, b, c, d) {
        return c - jQuery.easing.easeOutBounce(d - t, 0, c, d) + b;
    },
    easeOutBounce: function(t, b, c, d) {
        if ((t /= d) < (1 / 2.75)) {
            return c * (7.5625 * t * t) + b;
        } else if (t < (2 / 2.75)) {
            return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
        } else if (t < (2.5 / 2.75)) {
            return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
        } else {
            return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
        }
    },
    easeInOutBounce: function(t, b, c, d) {
        if (t < d / 2) return jQuery.easing.easeInBounce(x, t * 2, 0, c, d) * .5 + b;
        return jQuery.easing.easeOutBounce(x, t * 2 - d, 0, c, d) * .5 + c * .5 + b;
    },
    logInExpOut: function(x, range, period, offset) {
        var resty = x % period,
            range = Math.abs(range);
        if (resty < period / 2)
            return (range / Math.log(period / 2)) * Math.log(resty + 1) + offset;
        else
            return (range + 1) * Math.exp(-Math.abs(resty - period / 2) / ((period / 2) / Math.log(range + 1))) - 1 + offset;
    }
};

Lyne.Start();