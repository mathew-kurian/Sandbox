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
import android.graphics.Paint;
import android.text.Layout;
import android.text.Spanned;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.text.style.LeadingMarginSpan;

import com.text.examples.Console;
import com.text.style.TextAlignment;
import com.text.style.TextAlignmentSpan;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.ListIterator;

public class SpannedDocumentLayout extends DocumentLayout {

    private Paint workPaint;
    private CharSequence text;
    private StaticLayout staticLayout;
    private LinkedList<Token> tokens; // start, end, x, y
    private LinkedList<LeadMarginSpanDrawParameters> leadMarginSpanDrawEvents;

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


    @Override
    public void measure() {
        if (!params.changed && !textChange) {
            return;
        }

        int parentWidth = (int) params.getParentWidth();
        int boundWidth = (int) (params.getParentWidth() - params.getPaddingLeft() - params.getPaddingRight());

        leadMarginSpanDrawEvents = new LinkedList<LeadMarginSpanDrawParameters>();

        staticLayout = new StaticLayout(getText(), (TextPaint) getPaint(),
                boundWidth, Layout.Alignment.ALIGN_NORMAL, 1, 0, false);

        tokens = new LinkedList<Token>();

        LeadingMarginSpan[] activeLeadSpans = new LeadingMarginSpan[0];
        HashMap<LeadingMarginSpan, Integer> leadSpans = new HashMap<LeadingMarginSpan, Integer>();
        TextAlignment defAlign = params.textAlignment;
        float left = params.paddingLeft, right = params.paddingRight;
        float x, y = params.paddingTop, lastDescent, lastAscent;
        int lines = staticLayout.getLineCount();
        float lineHeightMultiplier = params.lineHeightMultiplier;
        Spanned text = (Spanned) this.text;
        Paint.FontMetricsInt fmi = paint.getFontMetricsInt();
        boolean isParaStart = true;
        int maxTextIndex = text.length() - 1;

        for (int i = 0; i < lines; i++) {

            int start = staticLayout.getLineStart(i);
            int end = staticLayout.getLineEnd(i);
            int realWidth = boundWidth;

            if (start == end || i >= params.maxLines) {
                break;
            }

            TextAlignmentSpan[] textAlignmentSpans = text.getSpans(start, end, TextAlignmentSpan.class);
            TextAlignment lineTextAlignment = textAlignmentSpans.length == 0 ? defAlign : textAlignmentSpans[0].getTextAlignment();

            lastAscent = -staticLayout.getLineAscent(i) * lineHeightMultiplier;
            lastDescent = staticLayout.getLineDescent(i) * lineHeightMultiplier;

            // Handle line breaks
            if (start + 1 == end && Character.getNumericValue(text.charAt(start)) == -1) {
                isParaStart = true;
                float lineBreakHeight = lastAscent + lastDescent;
                if(i + 1 < lines){
                    lastAscent = -staticLayout.getLineAscent(i + 1) * lineHeightMultiplier;
                    lastDescent = staticLayout.getLineDescent(i + 1) * lineHeightMultiplier;
                    lineBreakHeight = lastAscent + lastDescent;
                }
                y += lineBreakHeight;
                continue;
            }

            x = lineTextAlignment == TextAlignment.RIGHT ? right : left;
            y += lastAscent;

            // Console.log(start + " => " + end + " :: " + text.subSequence(start, end).toString());

            boolean isParaEnd = end == maxTextIndex ||
                    text.charAt(Math.min(end, maxTextIndex)) == '\n' ||
                    text.charAt(end - 1) == '\n';

            // Console.log(isParaStart + " " + isParaEnd + " " + start + " => " + end + " :: " + text.subSequence(start, end).toString());

            {/*LeadingMarginSpan block*/
                if (isParaStart) {

                    /*
                     * Process LeadingMarginSpan
                     */

                    activeLeadSpans = text.getSpans(start, end, LeadingMarginSpan.class);

                    /*
                     * Set up all the spans
                     */

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

                for (LeadingMarginSpan leadSpan : activeLeadSpans) {

                    // Sum the margins
                    float margin = 0.0f;

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
                        leadMarginSpanDrawEvents.push(new LeadMarginSpanDrawParameters(leadSpan, (int) calcX, lineAlignmentVal, (int) (y - lastAscent), (int) y,
                                (int) (y + lastDescent), start, end, isParaStart));

                        // Is margin required?
                        margin = leadSpan.getLeadingMargin(isParaStart);
                        totalMargin += margin;
                    }
                }

                x += totalMargin;
                realWidth -= totalMargin;

                /*
                 * Disable/enable new paragraph
                 */

                isParaStart = false;

                if (isParaEnd) {
                    isParaStart = true;
                }
            }

            Console.log(isParaStart + " " + isParaEnd + " " + start + " => " + end + " :: " + text.subSequence(start, end).toString());

            /*
             * Process TextAlignmentSpan
             */
            if (isParaEnd) {
                switch (lineTextAlignment) {
                    case LEFT:
                    case JUSTIFIED:
                        tokens.push(new Token(start, end, x, y));
                        y += lastDescent;
                        continue;
                }
            }

            switch (lineTextAlignment) {
                case RIGHT: {
                    float lineWidth = paint.measureText(text, start, end);
                    tokens.push(new Token(start, end, parentWidth - x - lineWidth, y));
                    y += lastDescent;
                    continue;
                }
                case CENTER: {
                    float lineWidth = paint.measureText(text, start, end);
                    tokens.push(new Token(start, end, x + (realWidth - lineWidth) / 2, y));
                    y += lastDescent;
                    continue;
                }
                case LEFT: {
                    tokens.push(new Token(start, end, x, y));
                    y += lastDescent;
                    continue;
                }
            }

            float totalWidth = 0;
            LinkedList<Token> lineTokens = new LinkedList<Token>();
            LinkedList<Integer> tokens = tokenize(text, start, end);

            if (tokens.size() == 1) {
                int stop = tokens.get(0);
                if (getTrimmedLength(text, start, stop) == 0) {
                    y += lastDescent;
                    continue;
                } else {
                    float[] textWidths = new float[stop - start];
                    float sum = 0.0f, textsOffset = 0.0f, offset;
                    int m = 0;

                    Styled.getTextWidths((TextPaint) paint, (TextPaint) workPaint, text, start, stop, textWidths, fmi);

                    for (float tw : textWidths) {
                        sum += tw;
                    }

                    offset = (realWidth - sum) / (textWidths.length - 1);

                    for (int k = start; k < stop; k++) {
                        lineTokens.add(new Token(k, k + 1, x + textsOffset + (offset * m), y));
                        textsOffset += textWidths[m++];
                    }

                    this.tokens.addAll(lineTokens);

                    y += lastDescent;

                    continue;
                }
            }

            for (int stop : tokens) {
                lineTokens.add(new Token(start, stop, x + totalWidth, y));
                totalWidth += Styled.measureText((TextPaint) paint, (TextPaint) workPaint, text, start, stop, fmi);
                start = stop + 1;
            }

            int m = 1;
            float offset = (realWidth - totalWidth) / (float) (tokens.size() - 1);
            ListIterator<Token> listIterator = lineTokens.listIterator();

            // Skip first one
            if (listIterator.hasNext()) {
                listIterator.next();
            }

            while (listIterator.hasNext()) {
                Token token = listIterator.next();
                token.x += offset * (float) m++;
                listIterator.set(token);
            }

            this.tokens.addAll(lineTokens);

            y += lastDescent;
        }

        params.changed = true;
        textChange = false;
        measuredHeight = (int) (y + staticLayout.getBottomPadding() + params.getPaddingBottom());
    }

    @Override
    public void draw(Canvas canvas) {

        for (LeadMarginSpanDrawParameters parameters : leadMarginSpanDrawEvents) {
            parameters.span.drawLeadingMargin(canvas, paint, parameters.x,
                    parameters.dir, parameters.top, parameters.baseline,
                    parameters.bottom, text, parameters.start,
                    parameters.end, parameters.first, null);
        }

        for (Token token : tokens) {
            Styled.drawText(canvas, text, token.start, token.end, Layout.DIR_LEFT_TO_RIGHT, false, (int) token.x, 0,
                    (int) token.y, 0, (TextPaint) paint, (TextPaint) workPaint, false);
        }
    }

    private class LeadMarginSpanDrawParameters {

        public int x;
        public int top;
        public int baseline;
        public int bottom;
        public int dir;
        public int start;
        public int end;
        public boolean first;
        public LeadingMarginSpan span;

        public LeadMarginSpanDrawParameters(LeadingMarginSpan span,
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

    private class Token {

        public int start;
        public int end;
        public float x;
        public float y;

        public Token(int start,
                     int end,
                     float x,
                     float y) {
            this.start = start;
            this.end = end;
            this.x = x;
            this.y = y;
        }
    }
}