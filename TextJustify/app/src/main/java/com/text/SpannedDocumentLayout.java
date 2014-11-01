package com.text;

/*
 * Copyright 2014 Mathew Kurian
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * -------------------------------------------------------------------------
 *
 * SpannedDocumentLayout.java
 * @author Mathew Kurian
 *
 * From TextJustify-Android Library v2.0
 * https://github.com/bluejamesbond/TextJustify-Android
 *
 * Please report any issues
 * https://github.com/bluejamesbond/TextJustify-Android/issues
 *
 * Date: 10/27/14 1:36 PM
 */

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.text.Layout;
import android.text.Spanned;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.text.style.LeadingMarginSpan;

import com.text.style.TextAlignment;
import com.text.style.TextAlignmentSpan;

import java.util.HashMap;
import java.util.LinkedList;

public class SpannedDocumentLayout extends DocumentLayout {


    private static boolean DEBUG = true;

    private static final int START = 0;
    private static final int END = 1;
    private static final int X = 2;
    private static final int Y = 3;
    private static final int ASCENT = 4;
    private static final int DESCENT = 5;
    private static final int LENGTH = 6;

    private Paint workPaint;
    private CharSequence text;
    private StaticLayout staticLayout;
    private LinkedList<LeadingMarginSpanDrawParameters> leadMarginSpanDrawEvents;
    private int[] tokensArray;

    public SpannedDocumentLayout(Paint paint) {
        super(paint);
        workPaint = new TextPaint(paint);
    }

    private static LinkedList<Integer> tokenize(CharSequence source,
                                                int start,
                                                int end) {

        LinkedList<Integer> units = new LinkedList<Integer>();

        if (start >= end) {
            return units;
        }

        boolean charSearch = source.charAt(start) == ' ';

        for (int i = start; i < end; i++) {
            // If the end add the word group
            if (i + 1 == end) {
                units.add(i + 1);
                start = i + 1;
            }
            // Search for the start of non-space
            else if (charSearch && source.charAt(i) != ' ') {
                if ((i - start) > 0) {
                    units.add(i);
                }
                start = i;
                charSearch = false;
            }
            // Search for the end of non-space
            else if (!charSearch && source.charAt(i) == ' ') {
                units.add(i);
                start = i + 1; // Skip the space
                charSearch = true;
            }
        }

        return units;
    }

    @Override
    public CharSequence getText() {
        return text;
    }

    @Override
    public void setText(CharSequence text) {
        this.text = text;
    }

    private int pushToken(int index, int start, int end, float x, float y, float ascent, float descent){
        tokensArray[index + START] = start;
        tokensArray[index + END] = end;
        tokensArray[index + X] = (int) x;
        tokensArray[index + Y] = (int) y;
        tokensArray[index + ASCENT] = (int) ascent;
        tokensArray[index + DESCENT] = (int) descent;
        return index + LENGTH;
    }

    private void ammortizeTokenArray(int index) {
        if (index + LENGTH > tokensArray.length) {
            int[] newTokenArray = new int[tokensArray.length * 2];
            System.arraycopy(tokensArray, 0, newTokenArray, 0, tokensArray.length);
            tokensArray = newTokenArray;
        }
    }

    @Override
    public void measure() {
        if (!params.changed && !textChange) {
            return;
        }

        int parentWidth = (int) params.getParentWidth();
        int boundWidth = (int) (params.getParentWidth() - params.getPaddingLeft() - params.getPaddingRight());

        leadMarginSpanDrawEvents = new LinkedList<LeadingMarginSpanDrawParameters>();

        staticLayout = new StaticLayout(getText(), (TextPaint) getPaint(),
                boundWidth, Layout.Alignment.ALIGN_NORMAL, 1, 0, false);

        tokensArray = new int[LENGTH * 1000];

        LeadingMarginSpan[] activeLeadSpans = new LeadingMarginSpan[0];
        HashMap<LeadingMarginSpan, Integer> leadSpans = new HashMap<LeadingMarginSpan, Integer>();
        TextAlignment defAlign = params.textAlignment;
        Spanned text = (Spanned) this.text;
        Paint.FontMetricsInt fmi = paint.getFontMetricsInt();

        int maxTextIndex = text.length() - 1;
        int lines = staticLayout.getLineCount();
        int enableLineBreak = 0;
        int index = 0;

        float x;
        float y = params.paddingTop;
        float left = params.paddingLeft;
        float right = params.paddingRight;
        float lastAscent;
        float lastDescent;
        float lineHeightAdd = 0;

        boolean isParaStart = true;

        for (int i = 0; i < lines; i++) {

            ammortizeTokenArray(index);

            int start = staticLayout.getLineStart(i);
            int end = staticLayout.getLineEnd(i);
            int realWidth = boundWidth;

            // Console.log(start + " => " + end + " :: " + " " + -staticLayout.getLineAscent(i) + " " +  staticLayout.getLineDescent(i) + " " + text.subSequence(start, end).toString());

            // start == end => end of text
            if (start == end || i >= params.maxLines) {
                break;
            }

            // Get text alignment for the line
            TextAlignmentSpan[] textAlignmentSpans = text.getSpans(start, end, TextAlignmentSpan.class);
            TextAlignment lineTextAlignment = textAlignmentSpans.length == 0 ? defAlign : textAlignmentSpans[0].getTextAlignment();

            // Calculate components of line height
            lastAscent = -staticLayout.getLineAscent(i);
            lastDescent = staticLayout.getLineDescent(i) + lineHeightAdd;

            /**
             * Line is ONLY a <br/> or \n
             */
            if (start + 1 == end &&
                    (Character.getNumericValue(text.charAt(start)) == -1 ||
                            text.charAt(start) == '\n')) {

                // Line break indicates a new paragraph
                // is next
                isParaStart = true;

                // Use the line-height of the next line
                y += enableLineBreak * (-staticLayout.getLineAscent(i + 1) + staticLayout.getLineDescent(i + 1));

                // Don't ignore the next line breaks
                enableLineBreak = 1;

                continue;

            } else {
                // Ignore the next line break
                enableLineBreak = 0;
            }

            x = lineTextAlignment == TextAlignment.RIGHT ? right : left;
            y += lastAscent;

            // Console.log(start + " => " + end + " :: " + text.subSequence(start, end).toString());
            // Console.log(isParaStart + " " + isParaEnd + " " + start + " => " + end + " :: " + text.subSequence(start, end).toString());

            /**
             * Line CONTAINS a \n
             */
            boolean isParaEnd = end == maxTextIndex ||
                    text.charAt(Math.min(end, maxTextIndex)) == '\n' ||
                    text.charAt(end - 1) == '\n';

            if (isParaEnd) {
                enableLineBreak = 1;
            }

            /**
             * LeadingMarginSpan block
             */
            if (isParaStart) {

                // Process LeadingMarginSpan
                activeLeadSpans = text.getSpans(start, end, LeadingMarginSpan.class);

                // Set up all the spans
                if (activeLeadSpans.length > 0) {
                    for (LeadingMarginSpan leadSpan : activeLeadSpans) {
                        if (!leadSpans.containsKey(leadSpan)) {

                            // Default margin is everything
                            int marginLineCount = -1;

                            if (leadSpan instanceof LeadingMarginSpan.LeadingMarginSpan2) {
                                LeadingMarginSpan.LeadingMarginSpan2 leadSpan2 = ((LeadingMarginSpan.LeadingMarginSpan2) leadSpan);
                                marginLineCount = leadSpan2.getLeadingMarginLineCount();
                            }

                            leadSpans.put(leadSpan, marginLineCount);
                        }
                    }
                }
            }

            float totalMargin = 0.0f;

            int top = (int) (y - lastAscent);
            int baseline = (int) (y);
            int bottom = (int) (y + lastDescent);

            for (LeadingMarginSpan leadSpan : activeLeadSpans) {

                // X based on alignment
                float calcX = x;

                // LineAlignment
                int lineAlignmentVal = 1;

                if (lineTextAlignment == TextAlignment.RIGHT) {
                    lineAlignmentVal = -1;
                    calcX = parentWidth - x;
                }

                // Get current line count
                int spanLines = leadSpans.get(leadSpan);

                // Update only if the valid next valid
                if (spanLines > 0 || spanLines == -1) {
                    leadSpans.put(leadSpan, spanLines == -1 ? -1 : spanLines - 1);
                    leadMarginSpanDrawEvents.push(new LeadingMarginSpanDrawParameters(leadSpan, (int) calcX, lineAlignmentVal, top, baseline,
                            bottom, start, end, isParaStart));

                    // Is margin required?
                    totalMargin += leadSpan.getLeadingMargin(isParaStart);
                }
            }

            x += totalMargin;
            realWidth -= totalMargin;

            // Disable/enable new paragraph
            isParaStart = false;

            if (isParaEnd) {
                isParaStart = true;
            }

            /**
             * TextAlignmentSpan block
             */
            if (isParaEnd) {
                switch (lineTextAlignment) {
                    case LEFT:
                    case JUSTIFIED:
                        index = pushToken(index, start, end, x, y, lastAscent, lastDescent);;
                        y += lastDescent;
                        continue;
                }
            }

            switch (lineTextAlignment) {
                case RIGHT: {
                    // FIXME: Space at the end of each line, possibly due to scrollbar offset
                    index = pushToken(index, start, end, parentWidth - x - paint.measureText(text, start, end - 1), y, lastAscent, lastDescent);
                    y += lastDescent;
                    continue;
                }
                case CENTER: {
                    index = pushToken(index, start, end, x + (realWidth - paint.measureText(text, start, end)) / 2, y, lastAscent, lastDescent);
                    y += lastDescent;
                    continue;
                }
                case LEFT: {
                    index = pushToken(index, start, end, x, y, lastAscent, lastDescent);
                    y += lastDescent;
                    continue;
                }
            }

            // FIXME: Space at the end of each line, possibly due to scrollbar offset
            LinkedList<Integer> tokenized = tokenize(text, start, end - 1);

            /**
             * If one long word without any spaces
             */
            if (tokenized.size() == 1) {
                int stop = tokenized.get(0);

                // If not all space, process
                // characters individually
                if (getTrimmedLength(text, start, stop) != 0) {

                    float[] textWidths = new float[stop - start];
                    float sum = 0.0f, textsOffset = 0.0f, offset;
                    int m = 0;

                    Styled.getTextWidths((TextPaint) paint, (TextPaint) workPaint, text, start, stop, textWidths, fmi);

                    for (float tw : textWidths) {
                        sum += tw;
                    }

                    offset = (realWidth - sum) / (textWidths.length - 1);

                    for (int k = start; k < stop; k++) {
                        index = pushToken(index, k, k + 1, x + textsOffset + (offset * m), y, lastAscent, lastDescent);
                        ammortizeTokenArray(index);
                        textsOffset += textWidths[m++];
                    }
                }
            }

            /**
             * NOTE: Handle multiple words
             */
            else {

                int m = 1;
                int startIndex = index;
                float lineWidth = 0;
                float offset;

                for (int stop : tokenized) {
                    index = pushToken(index, start, stop, x + lineWidth, y, lastAscent, lastDescent);
                    ammortizeTokenArray(index);

                    lineWidth += Styled.measureText((TextPaint) paint, (TextPaint) workPaint, text, start, stop, fmi);
                    start = stop + 1;
                }

                offset = (realWidth - lineWidth) / (float) ((index - startIndex) / LENGTH - 1);

                for (int pos = startIndex + LENGTH; pos < index; pos += LENGTH) {
                    tokensArray[pos + X] = (int)(((float) tokensArray[pos + X]) + (offset * (float) m++));
                }

            }

            y += lastDescent;
        }

        params.changed = false;
        textChange = false;
        measuredHeight = (int) (y + params.paddingBottom);
    }

    @Override
    public void draw(Canvas canvas) {

        if (DEBUG) {
            int lastColor = paint.getColor();
            paint.setColor(Color.BLUE);
            canvas.drawRect(params.paddingLeft, params.paddingTop, params.parentWidth - params.paddingRight, measuredHeight - params.paddingBottom, paint);
            paint.setColor(lastColor);
        }

        for (LeadingMarginSpanDrawParameters parameters : leadMarginSpanDrawEvents) {
            parameters.span.drawLeadingMargin(canvas, paint, parameters.x,
                    parameters.dir, parameters.top, parameters.baseline,
                    parameters.bottom, text, parameters.start,
                    parameters.end, parameters.first, null);
        }

        for (int index = 0; index < tokensArray.length; index += LENGTH) {
            Styled.drawText(canvas, text, tokensArray[index + START],
                    tokensArray[index + END], Layout.DIR_LEFT_TO_RIGHT, false, tokensArray[index + X], 0,
                    tokensArray[index + Y], 0, (TextPaint) paint, (TextPaint) workPaint, false);
            if (DEBUG) {
                int lastColor = paint.getColor();
                paint.setColor(Color.GREEN);
                canvas.drawLine(0, tokensArray[index + Y] - tokensArray[index + ASCENT], params.parentWidth, tokensArray[index + Y] - tokensArray[index + ASCENT], paint);
                paint.setColor(Color.MAGENTA);
                canvas.drawLine(0, tokensArray[index + Y], params.parentWidth, tokensArray[index + Y], paint);
                paint.setColor(Color.CYAN);
                canvas.drawLine(0, tokensArray[index + Y] + tokensArray[index + DESCENT], params.parentWidth, tokensArray[index + Y] + tokensArray[index + DESCENT], paint);
                paint.setColor(lastColor);
            }
        }
    }

    /**
     * Class to handle onDrawLeadingSpanMargin
     */

    private class LeadingMarginSpanDrawParameters {

        public int x;
        public int top;
        public int baseline;
        public int bottom;
        public int dir;
        public int start;
        public int end;
        public boolean first;
        public LeadingMarginSpan span;

        public LeadingMarginSpanDrawParameters(LeadingMarginSpan span,
                                               int x,
                                               int dir,
                                               int top,
                                               int baseline,
                                               int bottom,
                                               int start,
                                               int end,
                                               boolean first) {
            this.span = span;
            this.x = x;
            this.dir = dir;
            this.top = top;
            this.baseline = baseline;
            this.bottom = bottom;
            this.start = start;
            this.end = end;
            this.first = first;
        }
    }
}