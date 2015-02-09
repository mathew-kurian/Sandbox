String.prototype.rightChars = function (n) {
    if (n <= 0) {
        return "";
    } else if (n > this.length) {
        return this;
    } else {
        return this.substring(this.length, this.length - n);
    }
};

(function ($) {
    var
    options = {
        highlightSpeed: 10,
        typeSpeed: 10,
        clearDelay: 500,
        typeDelay: 0,
        clearOnHighlight: true,
        typerDataAttr: 'data-typer-targets',
        typerInterval: 1000
    },
        highlight,
        clearText,
        backspace,
        type,
        spanWithColor,
        clearDelay,
        typeDelay,
        clearData,
        isNumber,
        typeWithAttribute,
        getHighlightInterval,
        getTypeInterval,
        typerInterval;

    spanWithColor = function (color, backgroundColor) {
        if (color === 'rgba(0, 0, 0, 0)') {
            color = 'rgb(255, 255, 255)';
        }

        return $('<span></span>')
            .css({
                "padding-left":"2px",
                "margin-left":"-2px",
                "padding-right":"2px",
                "margin-right":"-2px",
                'border-radius':'3px',
                'color':color,
                'background-color':backgroundColor
            });
    };

    isNumber = function (n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    };

    clearData = function (element) {
        element
            .data('typePosition', null)
            .data('highlightPosition', null)
            .data('leftStop', null)
            .data('rightStop', null)
            .data('primaryColor', null)
            .data('backgroundColor', null)
            .data('text', null)
            .data('typing', null);
    };

    type = function (element) {
        var text = element.data('text'),
            oldLeft = element.data('oldLeft'),
            oldRight = element.data('oldRight');

        if (!text || text.length === 0) {
            clearData(element);
            setTimeout(element.data('callback'), 0);
            return;
        }

        element.text(
            oldLeft +
            text.charAt(0) +
            oldRight);

        element.data('oldLeft', oldLeft + text.charAt(0));
        element.data('text', text.substring(1));

        setTimeout(function () {
            type(element);
        }, getTypeInterval());
    };

    clearText = function (element) {
        element.find('span').remove();

        setTimeout(function () {
            type(element);
        }, typeDelay());
    };

    highlight = function (element) {
        var
        position = element.data('highlightPosition'),
            leftText,
            highlightedText,
            rightText;

        if (!isNumber(position)) {
            position = element.data('rightStop') + 1;
        }

        if (position <= element.data('leftStop')) {
            setTimeout(function () {
                clearText(element);
            }, clearDelay());
            return;
        }

        leftText = element.text().substring(0, position - 1);
        highlightedText = element.text().substring(position - 1, element.data('rightStop') + 1);
        rightText = element.text().substring(element.data('rightStop') + 1);

        element.html(leftText);
        element.append(spanWithColor(element.data('primaryColor'),element.data('backgroundColor'))
          .append(highlightedText))
          .append(rightText);

        element.data('highlightPosition', position - 1);

        setTimeout(function () {
            return highlight(element);
        }, getHighlightInterval());
    };

    typeWithAttribute = function (element) {
        var targets;

        if (element.data('typing')) {
            return;
        }

        try {
            targets = JSON.parse(element.attr($.typer.options.typerDataAttr)).targets;
        } catch (e) {}

        if (typeof targets === "undefined") {
            targets = $.map(element.attr($.typer.options.typerDataAttr).split(','), function (e) {
                return $.trim(e);
            });
        }

        element.typeTo(targets[Math.floor(Math.random() * targets.length)]);
    };

    // Expose our options to the world.
    $.typer = (function () {
        return {
            options: options
        };
    })();

    $.extend($.typer, {
        options: options
    });

    //-- Methods to attach to jQuery sets

    $.fn.typer = function () {
        var elementlements = $(this);

        elementlements = elementlements.filter(function () {
            return typeof $(this).attr($.typer.options.typerDataAttr) !== "undefined"
        });

        elementlements.each(function () {
            var element = $(this);

            typeWithAttribute(element);
            setInterval(function () {
                typeWithAttribute(element);
            }, typerInterval());
        });
    };

    $.fn.typeTo = function (newString, color, callback) {

        var element = $(this),
            currentText = element.text(),
            i = 0,
            j = 0;

        if (currentText === newString) {
            console.log("Our strings our equal, nothing to type");
            return;
        }

        if (currentText !== element.html()) {
            // console.error("Typer does not work on elements with child elements.");
            return;
        }

        element.data('typing', true);
        element.data('callback', callback);

        while (currentText.charAt(i) === newString.charAt(i)) {
            i++;
        }

        while (currentText.rightChars(j) === newString.rightChars(j)) {
            j++;
        }

        newString = newString.substring(i, newString.length - j + 1);

        element.data('oldLeft', currentText.substring(0, i));
        element.data('oldRight', currentText.rightChars(j - 1));
        element.data('leftStop', i);
        element.data('rightStop', currentText.length - j);
        element.data('primaryColor', element.css('color'));
        element.data('backgroundColor', color);
        element.data('text', newString);
        highlight(element);
    };

    //-- Helper methods. These can one day be customized further to include things like ranges of delays.

    getHighlightInterval = function () {
        return $.typer.options.highlightSpeed;
    };

    getTypeInterval = function () {
        return $.typer.options.typeSpeed;
    },

    clearDelay = function () {
        return $.typer.options.clearDelay;
    },

    typeDelay = function () {
        return $.typer.options.typeDelay;
    };

    typerInterval = function () {
        return $.typer.options.typerInterval;
    };
})(jQuery);