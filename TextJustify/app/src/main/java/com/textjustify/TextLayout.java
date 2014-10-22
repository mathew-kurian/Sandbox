package com.textjustify;

import android.graphics.Canvas;
import android.graphics.Paint;

import com.textjustify.hyphen.Hyphenator;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.ListIterator;

@SuppressWarnings("unused")
public class TextLayout {

    class LayoutParams {

        private Hyphenator hyphenator;
        private float left = 0.0f;
        private float top = 0.0f;
        private float bottom = 0.0f;
        private float right = 0.0f;
        private float parentWidth;
        private float offsetX;
        private float offsetY;
        private float lineHeightMultiplier = 1.0f;
        private boolean hyphenate;
        private boolean justify;
        private int maxLines;
        private String hyphen = "-";
        private boolean changed;

        public Hyphenator getHyphenator() {
            return hyphenator;
        }

        public void setHyphenator(Hyphenator hyphenator) {
            this.hyphenator = hyphenator;
        }

        public float getLeft() {
            return left;
        }

        public void setLeft(float left) {
            this.left = left;
            this.changed = true;
        }

        public float getTop() {
            return top;
        }

        public void setTop(float top) {
            this.top = top;
            this.changed = true;
        }

        public float getBottom() {
            return bottom;
        }

        public void setBottom(float bottom) {
            this.bottom = bottom;
            this.changed = true;
        }

        public float getRight() {
            return right;
        }

        public void setRight(float right) {
            this.right = right;
            this.changed = true;
        }

        public float getParentWidth() {
            return parentWidth;
        }

        public void setParentWidth(float parentWidth) {
            if (this.parentWidth != parentWidth) {
                this.parentWidth = parentWidth;
                this.changed = true;
            }
        }

        public float getOffsetX() {
            return offsetX;
        }

        public void setOffsetX(float offsetX) {
            this.offsetX = offsetX;
        }

        public float getOffsetY() {
            return offsetY;
        }

        public void setOffsetY(float offsetY) {
            this.offsetY = offsetY;
        }

        public float getLineHeightMultiplier() {
            return lineHeightMultiplier;
        }

        public void setLineHeightMultiplier(float lineHeightMultiplier) {
            this.lineHeightMultiplier = lineHeightMultiplier;
            this.changed = true;
        }

        public boolean isHyphenate() {
            return hyphenate;
        }

        public void setHyphenate(boolean hyphenate) {
            this.hyphenate = hyphenate && hyphenator != null;
            this.changed = true;
        }

        public boolean isJustify() {
            return justify;
        }

        public void setJustify(boolean justify) {
            this.justify = justify;
            this.changed = true;
        }

        public int getMaxLines() {
            return maxLines;
        }

        public void setMaxLines(int maxLines) {
            this.maxLines = maxLines;
            this.changed = true;
        }

        public String getHyphen() {
            return hyphen;
        }

        public void setHyphen(String hyphen) {
            this.hyphen = hyphen;
            this.changed = true;
        }

        public boolean hasChanged() {
            return this.changed;
        }
    }

    public static abstract class Token {

        public int lineNumber;

        public Token(int lineNumber) {
            this.lineNumber = lineNumber;
        }

        public int getLineNumber() {
            return lineNumber;
        }

        abstract void draw(Canvas canvas, Paint paint, LayoutParams params);
    }

    public static class Unit extends Token {

        public float x;
        public float y;
        public String unit;

        public Unit(String unit) {
            super(0);
            this.unit = unit;
        }

        public Unit(int lineNumber, float x, float y, String unit) {
            super(lineNumber);
            this.x = x;
            this.y = y;
            this.unit = unit;
        }

        @Override
        void draw(Canvas canvas, Paint paint,LayoutParams params) {
            canvas.drawText(unit,x + params.getOffsetX(), y + params.getOffsetY(), paint);
        }
    }

    public static class LineBreak extends Token {
        public LineBreak(int lineNumber) {
            super(lineNumber);
        }

        @Override
        void draw(Canvas canvas, Paint paint, LayoutParams params) {}
    }

    public static class SingleLine extends Unit {
        public SingleLine(int lineNumber, float x, float y, String unit) {
            super(lineNumber, x, y, unit);
        }
    }

    // Basic client-set properties
    private LayoutParams params;

    // Main content
    private String text;
    private boolean textChange = true;

    // Parsing objects
    private LinkedList<Token> tokens;
    private LinkedList<String> chunks;

    // Rendering
    private Paint paint;

    // Measurement output
    private int measuredHeight;

    public TextLayout(Paint paint) {

        this.paint = paint;

        params = new LayoutParams();
        params.setLineHeightMultiplier(1.0f);
        params.setHyphenate(true);
        params.setJustify(true);

        measuredHeight = 0;

        tokens = new LinkedList<Token>();
        chunks = new LinkedList<String>();
    }

    public Paint getPaint() {
        return paint;
    }

    public LayoutParams getLayoutParams() {
        return params;
    }

    public void setText(String text) {
        this.text = text;
        this.textChange = true;
    }

    public String getText() {
        return this.text;
    }

    private float getFontAscent() {
        return -paint.ascent() * params.lineHeightMultiplier;
    }

    private float getFontDescent() {
        return paint.descent() * params.lineHeightMultiplier;
    }

    public int getMeasuredHeight() {
        return measuredHeight;
    }

    public void measure() {
        if (!params.changed && !textChange) {
            return;
        }

        if (textChange) {
            chunks.clear();

            int start = 0;

            while(start > -1 ){
                int next = text.indexOf('\n', start + 1);
                chunks.add(text.substring(start, next < 0 ? text.length() : next));
                start = next;
            }

            textChange = false;
        }

        // Empty out any existing tokens
        tokens.clear();

        Paint paint = getPaint();
        paint.setTextAlign(Paint.Align.LEFT);

        // Get basic settings widget properties
        float width = params.parentWidth - params.right - params.left;
        float lineHeight = getFontAscent() + getFontDescent();
        float x, y = lineHeight + params.top, spaceOffset = paint.measureText(" ");

        int lineNumber = 0;

        for (String paragraph : chunks) {

            // Start at x = 0 for drawing text
            x = params.left;

            String trimParagraph = paragraph.trim();

            // If the line contains only spaces or line breaks
            if (trimParagraph.length() == 0) {
                tokens.add(new LineBreak(lineNumber++));
                y += lineHeight;
                continue;
            }

            float wrappedWidth = paint.measureText(trimParagraph);

            // Line fits, then don't wrap
            if (wrappedWidth < width) {
                // activeCanvas.drawText(paragraph, x, y, paint);
                tokens.add(new SingleLine(lineNumber++, x, y, trimParagraph));
                y += lineHeight;
                continue;
            }

            // Allow leading spaces
            int start = 0;
            int overallCounter = 0;

            LinkedList<Unit> units = tokenize(paragraph);
            ListIterator<Unit> unitIterator = units.listIterator();
            ListIterator<Unit> justifyIterator = units.listIterator();

            while (true) {

                x = params.left;

                // Line doesn't fit, then apply wrapping
                LineAnalysis format = justify(justifyIterator, start, spaceOffset, width);
                int tokenCount = format.end - format.start;
                boolean leftOverTokens = justifyIterator.hasNext();

                if (tokenCount == 0 && leftOverTokens) {
                    new TextDocumentException("Cannot fit word(s) into one line. Font size too large?").printStackTrace();
                    return;
                }

                // Draw each word here
                float offset = tokenCount > 2 && leftOverTokens && params.justify ? format.remainWidth / (tokenCount - 1) : 0;

                for (int i = format.start; i < format.end; i++) {
                    Unit unit = unitIterator.next();
                    unit.x = x;
                    unit.y = y;
                    unit.lineNumber = lineNumber;
                    x += offset + paint.measureText(unit.unit) + spaceOffset;

                    // Add to all tokens
                    tokens.add(unit);
                }

                // Increment to next line
                y += lineHeight;

                // Next line
                lineNumber++;

                // If there are more tokens leftover,
                // continue
                if (leftOverTokens) {

                    // Next start index for tokens
                    start = format.end;

                    continue;
                }

                // If all fit, then continue to next
                // paragraph
                break;
            }
        }

        params.changed = false;
        measuredHeight = (int) (y + params.bottom);
    }

    public void draw(Canvas canvas) {
        for (Token token : tokens) {
            token.draw(canvas, paint, params);
        }
    }

    private LinkedList<Unit> tokenize(String s) {

        LinkedList<Unit> units = new LinkedList<Unit>();

        // If empty string, just return one group
        if (s.trim().length() <= 1) {
            units.add(new Unit(s));
            return units;
        }

        int start = 0;
        boolean charSearch = s.charAt(0) == ' ';

        for (int i = 1; i < s.length(); i++) {
            // If the end add the word group
            if (i + 1 == s.length()) {
                units.add(new Unit(s.substring(start, i + 1)));
                start = i + 1;
            }
            // Search for the start of non-space
            else if (charSearch && s.charAt(i) != ' ') {
                String substring = s.substring(start, i);
                if (substring.length() != 0) {
                    units.add(new Unit(s.substring(start, i)));
                }
                start = i;
                charSearch = false;
            }
            // Search for the end of non-space
            else if (!charSearch && s.charAt(i) == ' ') {
                units.add(new Unit(s.substring(start, i)));
                start = i + 1; // Skip the space
                charSearch = true;
            }
        }

        return units;
    }

    /**
     * Class and function to process wrapping Implements a greedy algorithm to
     * fit as many words as possible into one line
     */

    private class LineAnalysis {

        public int start;
        public int end;
        public float remainWidth;

        public LineAnalysis(int start, int end, float remainWidth) {
            this.start = start;
            this.end = end;
            this.remainWidth = remainWidth;
        }
    }


    /**
     * By contract, parameter "block" must not have any line breaks
     */

    private LineAnalysis justify(ListIterator<Unit> iterator, int startIndex, float spaceOffset, float availableWidth) {

        int i = startIndex;

        // Greedy search to see if the word
        // can actually fit on a line
        while (iterator.hasNext()) {


            // Get word
            Unit unit = iterator.next();
            String word = unit.unit;
            float wordWidth = paint.measureText(word);
            float remainingWidth = availableWidth - wordWidth;

            // Word does not fit in line
            if (remainingWidth < 0 && word.trim().length() != 0) {

                // Handle hyphening in the event
                // the current word does not fit
                if (params.hyphenate && params.justify) {

                    float lastFormattedPartialWidth = 0.0f;
                    String lastFormattedPartial = null;
                    String lastConcatPartial = null;
                    String concatPartial = "";

                    ArrayList<String> partials = params.hyphenator.hyphenate(word);

                    for (String partial : partials) {

                        concatPartial += partial;

                        // Create the hyphenated word
                        // aka. partial
                        String formattedPartial = concatPartial + params.hyphen;
                        float formattedPartialWidth = paint
                                .measureText(formattedPartial);

                        // See if the partial fits
                        if (availableWidth - formattedPartialWidth > 0) {
                            lastFormattedPartial = formattedPartial;
                            lastFormattedPartialWidth = formattedPartialWidth;
                            lastConcatPartial = concatPartial;
                        }
                        // If the partial doesn't fit
                        else {

                            // Check if the lastPartial
                            // was even set
                            if (lastFormattedPartial != null) {

                                unit.unit = lastFormattedPartial;
                                iterator.add(new Unit(word.substring(lastConcatPartial.length())));
                                availableWidth -= lastFormattedPartialWidth;

                                return new LineAnalysis(startIndex, i + 1, availableWidth);
                            }
                        }
                    }
                }

                // Redo this word on the next run
                iterator.previous();

                return new LineAnalysis(startIndex, i, availableWidth + spaceOffset);

            }
            // Word fits in the line
            else {

                availableWidth -= wordWidth + spaceOffset;

                // NO remaining space
                if (remainingWidth == 0) {
                    return new LineAnalysis(startIndex, i + 1, availableWidth
                            + spaceOffset);
                }
            }

            // Increment i
            i++;
        }

        return new LineAnalysis(startIndex, i, availableWidth + spaceOffset);
    }
}

@SuppressWarnings("serial")
class TextDocumentException extends Exception {
    public TextDocumentException(String message) {
        super(message);
    }
}