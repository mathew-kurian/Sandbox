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

import com.text.styles.TextAlignment;
import com.text.styles.TextAlignmentSpan;

import java.util.LinkedList;
import java.util.ListIterator;

public class SpannedDocumentLayout extends DocumentLayout {

    private Paint workPaint;
    private CharSequence text;
    private StaticLayout staticLayout;
    private LinkedList<Token> tokens; // start, end, x, y

    public SpannedDocumentLayout(Paint paint) {
        super(paint);
        workPaint = new TextPaint(paint);
    }

    private static LinkedList<Integer> tokenize(CharSequence source, int start,
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

        int parentWidth = (int) (params.getParentWidth() - params.getPaddingLeft() - params.getPaddingRight());

        staticLayout = new StaticLayout(getText(), (TextPaint) getPaint(),
                parentWidth, Layout.Alignment.ALIGN_NORMAL, 1, 0, false);

        tokens = new LinkedList<Token>();

        TextAlignment defAlign = params.textAlignment;
        float left = params.paddingLeft, y = params.paddingTop, lastDescent, lastAscent;
        int lines = staticLayout.getLineCount();
        float lineHeightMultiplier = params.lineHeightMultiplier;
        Spanned text = (Spanned) this.text;
        Paint.FontMetricsInt fmi = paint.getFontMetricsInt();

        for (int i = 0; i < lines; i++) {

            int start = staticLayout.getLineStart(i);
            int end = staticLayout.getLineEnd(i);

            if (start == end || i >= params.maxLines) {
                break;
            }

            lastAscent = -staticLayout.getLineAscent(i) * lineHeightMultiplier;
            lastDescent = staticLayout.getLineDescent(i) * lineHeightMultiplier;

            y += lastAscent;
            // Console.log(start + " => " + end + " :: " + text.subSequence(start, end).toString());

            TextAlignmentSpan[] textAlignmentSpans = text.getSpans(start, end, TextAlignmentSpan.class);
            TextAlignment lineTextAlignment = textAlignmentSpans.length == 0 ? defAlign : textAlignmentSpans[0].getTextAlignment();

            switch (lineTextAlignment) {
                case LEFT:
                case JUSTIFIED:
                    if (text.charAt(Math.min(end, text.length() - 1)) == '\n') {
                        tokens.push(new Token(start, end, left, y));
                        i++;
                        y += lastDescent;
                        continue;
                    }
            }

            switch (lineTextAlignment) {
                case RIGHT: {
                    float width = paint.measureText(text, start, end);
                    tokens.push(new Token(start, end, left + parentWidth - width, y));
                    y += lastDescent;
                    continue;
                }
                case CENTER: {
                    float width = paint.measureText(text, start, end);
                    tokens.push(new Token(start, end, left + (parentWidth - width) / 2, y));
                    y += lastDescent;
                    continue;
                }
                case LEFT: {
                    tokens.push(new Token(start, end, left, y));
                    y += lastDescent;
                    continue;
                }
            }

            float totalWidth = 0;
            LinkedList<Token> lineTokens = new LinkedList<Token>();
            LinkedList<Integer> tokens = tokenize(text, start, end);

            if(tokens.size() == 1){
                int stop = tokens.get(0);
                if(getTrimmedLength(text, start, stop) == 0){
                    y += lastDescent;
                    continue;
                } else {
                    float [] textWidths = new float[stop - start];
                    float sum = 0.0f, textsOffset = 0.0f, offset;
                    int m = 0;

                    Styled.getTextWidths((TextPaint) paint, (TextPaint) workPaint, text, start, stop, textWidths, fmi);

                    for(float tw : textWidths) {
                        sum+= tw;
                    }

                    offset = (parentWidth - sum) / (textWidths.length - 1);

                    for(int k = start; k < stop; k++) {
                        lineTokens.add(new Token(k, k + 1, left + textsOffset + (offset * m), y));
                        textsOffset += textWidths[m++];
                    }

                    this.tokens.addAll(lineTokens);

                    y+=lastDescent;

                    continue;
                }
            }

            for (int stop : tokens) {
                lineTokens.add(new Token(start, stop, left + totalWidth, y));
                totalWidth += Styled.measureText((TextPaint) paint, (TextPaint) workPaint, text, start, stop, fmi);
                start = stop + 1;
            }

            int m = 1;
            float offset = (parentWidth - totalWidth) / (float) (tokens.size() - 1);
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
        measuredHeight = (int) (y + params.getPaddingBottom());
    }

    @Override
    public void draw(Canvas canvas) {
        for (Token token : tokens) {
            Styled.drawText(canvas, text, token.start, token.end, Layout.DIR_LEFT_TO_RIGHT, false, (int) token.x, 0,
                    (int) token.y, 0, (TextPaint) paint, (TextPaint) workPaint, false);
        }
    }

    private class Token {

        public int start;
        public int end;
        public float x;
        public float y;

        public Token(int start, int end, float x, float y) {
            this.start = start;
            this.end = end;
            this.x = x;
            this.y = y;
        }
    }
}