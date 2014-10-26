package com.text;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.text.Layout;
import android.text.Spanned;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.text.TextUtils;

import com.text.examples.Console;

import java.util.LinkedList;
import java.util.ListIterator;

/**
 * Created by Mathew on 10/25/2014.
 */

public class SpannedDocumentLayout extends DocumentLayout {

    private Paint workPaint;
    private CharSequence text;
    private StaticLayout staticLayout;
    private LinkedList<TokenInfo> tokenInfos; // start, end, x, y

    public SpannedDocumentLayout(Paint paint) {
        super(paint);
        workPaint = new TextPaint(paint);
    }

    class TokenInfo {

        public int start;
        public int end;
        public float x;
        public float y;

        public TokenInfo(int start, int end, float x, float y) {
            this.start = start;
            this.end = end;
            this.x = x;
            this.y = y;
        }
    }

    @Override
    public void setText(CharSequence text) {
        this.text = text;
    }

    @Override
    public CharSequence getText() {
        return text;
    }

    @Override
    public void measure() {
        if (!hasParamsChanged() && !textChange) {
            return;
        }

        int parentWidth = (int) (params.getParentWidth() - params.getLeft() - params.getRight());

        staticLayout = new StaticLayout(getText(), (TextPaint) getPaint(),
                parentWidth, Layout.Alignment.ALIGN_NORMAL, 1, 0, false);

        tokenInfos = new LinkedList<TokenInfo>();

        boolean justify = params.isJustify();
        float left = params.getLeft(), y = params.getTop(), lastDescent = 0.0f;
        int lines = staticLayout.getLineCount();
        float lineHeightMultiplier = params.getLineHeightMultiplier();
        Spanned text = (Spanned) this.text;

        for (int i = 0; i < lines; i++) {

            y += (-staticLayout.getLineAscent(i) * lineHeightMultiplier);

            int start = staticLayout.getLineStart(i);
            int end = staticLayout.getLineEnd(i);

            lastDescent = staticLayout.getLineDescent(i) * lineHeightMultiplier;

            // Console.log(start + " => " + end + " :: " + text.subSequence(start, end).toString());

            if(start == end){
                break;
            }

            if(text.charAt(Math.min(end, text.length() - 1)) == '\n'){
                tokenInfos.push(new TokenInfo(start, end, left, y));
                i++;
                y += lastDescent;
                continue;
            }

            if(text.getSpans(start, end, JustifySpan.class).length == 0 || !justify){
                tokenInfos.push(new TokenInfo(start, end, left, y));
                y += lastDescent;
                continue;
            }

            float[] textWidths = new float[end - start];

            Styled.getTextWidths((TextPaint) paint, (TextPaint) workPaint, text,
                    start, end, textWidths, paint.getFontMetricsInt());

            LinkedList<Integer> tokens = tokenize(text, start, end);

            float totalWidth = 0;
            LinkedList<TokenInfo> lineTokenInfos = new LinkedList<TokenInfo>();
            Paint.FontMetricsInt fmi = paint.getFontMetricsInt();

            for (int stop : tokens) {
                lineTokenInfos.add(new TokenInfo(start, stop, left + totalWidth, y));
                totalWidth += Styled.measureText((TextPaint) paint, (TextPaint) workPaint, text, start, stop, fmi);
                start = stop + 1;
            }

            float offset = (parentWidth - totalWidth) / (float) (tokens.size() - 1);
            ListIterator<TokenInfo> listIterator = lineTokenInfos.listIterator();
            int m = 1;

            // Skip first one
            if(listIterator.hasNext()){
                listIterator.next();
            }

            while (listIterator.hasNext()) {
                TokenInfo tokenInfo = listIterator.next();
                tokenInfo.x += offset * (float) m++;
                listIterator.set(tokenInfo);
            }

            tokenInfos.addAll(lineTokenInfos);

            y += lastDescent;
        }

        setParamsChanged(false);
        textChange = false;
        measuredHeight = (int) (y + params.getBottom() - lastDescent);
    }

    @Override
    public void draw(Canvas canvas) {
        for (TokenInfo tokenInfo : tokenInfos ) {
            Styled.drawText(canvas, text, tokenInfo.start, tokenInfo.end, Layout.DIR_LEFT_TO_RIGHT, false, (int) tokenInfo.x, 0,
                    (int) tokenInfo.y, 0, (TextPaint) paint, (TextPaint) workPaint, false);
        }
    }

    private static LinkedList<Integer> tokenize(CharSequence source, int start,
                                                int end) {

        LinkedList<Integer> units = new LinkedList<Integer>();

        if(start >= end){
            return units;
        }

        boolean charSearch = source.charAt(start) == ' ';

        for (int i = start; i < end; i++) {
            // If the end add the word group
            if (i + 1 == source.length()) {
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
}
