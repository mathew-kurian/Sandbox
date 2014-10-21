package com.textjustify;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Paint.Align;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.view.View;
import android.util.AttributeSet;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.ListIterator;

import com.textjustify.hyphen.HyphenPattern;
import com.textjustify.hyphen.Hyphenator;

/*
 * 
 * TextViewEx.java
 * @author Mathew Kurian
 * 
 * From TextJustify-Android Library v1.0.2
 * https://github.com/bluejamesbond/TextJustify-Android
 *
 * Please report any issues
 * https://github.com/bluejamesbond/TextJustify-Android/issues
 * 
 * Date: 10/18/2014 2:22 AM
 * 
 */

@SuppressWarnings("unused")
public class TextViewEx extends View {

    // To do
    // + Add ellipses
    // + Fix line-height
    // + Add max lines

    public static final String HYPHEN_SYMBOL = "-";

    private Paint paint;
    private boolean hyphenate = false;
    private boolean justify = true;
    private String text = "";

    // Caching content
    private boolean cacheEnabled = false;
    private Bitmap cacheBitmap = null;

    private Hyphenator hyphenator;

    private boolean invalid = true;

    private int lastWidthMeasureSpec = 0;
    private int lastHeightMeasureSpec = 0;
    private int calculatedWidth = 0;
    private int calculatedHeight = 0;
    private float lineHeightMultiplier = 1.0f;

    private JustifiedLayout jl; // Clear children

    @SuppressWarnings("unused")
    public TextViewEx(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context);
    }

    @SuppressWarnings("unused")
    public TextViewEx(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    @SuppressWarnings("unused")
    public TextViewEx(Context context) {
        super(context);
        init(context);
    }

    public void init(Context context){
        paint = new Paint();
        paint.setTypeface(Typeface.defaultFromStyle(Typeface.NORMAL));
        paint.setTextSize(32);
        paint.setAntiAlias(true);
    }

    @Override
    public void setDrawingCacheEnabled(boolean cacheEnabled) {
        this.cacheEnabled = cacheEnabled;
    }

    @SuppressWarnings("unused")
    public void setText(String text, boolean justify) {
        this.justify = justify;
        this.text = text;
        this.invalid = true;
        this.requestLayout();
    }

    @SuppressWarnings("unused")
    public CharSequence getText() {
        return text;
    }

    public void setLineHeightMultiplier(float lineHeightMultiplier){
        this.lineHeightMultiplier = lineHeightMultiplier;
    }

    private float ascent(){
        return -paint.ascent() * lineHeightMultiplier;
    }

    private float descent(){
        return paint.descent() * lineHeightMultiplier;
    }

    public float getLineHeight(){
        return ascent() + descent();
    }

    public Paint getPaint(){
        return this.paint;
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec){

        if(!invalid && widthMeasureSpec == lastWidthMeasureSpec && heightMeasureSpec == lastHeightMeasureSpec){
            this.setMeasuredDimension(calculatedWidth, calculatedHeight);
            return;
        }

        // Create new instance of layout
        jl = new JustifiedLayout();

        int parentWidth = MeasureSpec.getSize(widthMeasureSpec);

        Paint paint = getPaint();
        paint.setTextAlign(Align.LEFT);

        // Get basic settings widget properties
        float insetLeft = getPaddingLeft(), insetTop = getPaddingTop(), insetRight = getPaddingRight(), insetBottom = getPaddingBottom();
        float width = parentWidth - insetRight - insetLeft;
        float lineHeight = getLineHeight();
        float x, y = lineHeight, spaceOffset = paint.measureText(" ");

        List<String> paragraphs = new LinkedList<String>(Arrays.asList(getText().toString().split("((?<=\n)|(?=\n))")));
        ListIterator<String> pIterator = paragraphs.listIterator();

        while (pIterator.hasNext()) {

            String paragraph = pIterator.next();

            // Start at x = 0 for drawing text
            x = insetLeft;

            // If the line contains only spaces or line breaks
            if (paragraph.trim().length() == 0) {
                jl.addSection(new com.textjustify.TextViewEx.JustifiedLayout.LineBreak());
                y += lineHeight * (paragraph.length() - paragraph.replaceAll("\n", "").length());
                continue;
            }

            // Remove all spaces from the end of the line
            String noLineBreaks = paragraph.replaceAll("\n", "");
            // Remove all trailingSpaces
            String noTrailingSpaces = noLineBreaks.replaceAll("\\s+$", "");
            // Remove newlines when drawing
            String noTrailingWhiteSpace = noTrailingSpaces.replaceAll("\n", "");

            float wrappedWidth = paint.measureText(noTrailingWhiteSpace);

            // Line fits, then don't wrap
            if (wrappedWidth < width) {
                // activeCanvas.drawText(paragraph, x, y, paint);
                jl.addSection(new JustifiedLayout.ShortLine(paragraph, x, y));
                y += lineHeight * (paragraph.length() - noLineBreaks.length());
                continue;
            }

            // Allow leading spaces
            int start = 0;
            boolean leadSpaces = true;
            LinkedList<String> tokens = tokenize(paragraph);
            ListIterator<String> tokenIterator = tokens.listIterator();
            JustifiedLayout.Paragraph jlp = new JustifiedLayout.Paragraph(tokens);

            while (true) {

                x = insetLeft;

                // Line doesn't fit, then apply wrapping
                JustifiedLine format = justify(tokens, start, paint, spaceOffset, width, hyphenate, leadSpaces);
                int tokenCount = format.end - format.start;
                boolean fitAll = format.end == tokens.size();
                boolean error = format.start == format.end;

                if (error) {
                    new TextJustifyException("Cannot fit word(s) into one line. Font size too large?").printStackTrace();
                    return;
                }

                // Draw each word here
                float offset = tokenCount > 2 && !fitAll && justify ? format.remainWidth / (tokenCount - 1) : 0;

                // Create line object
                JustifiedLayout.Paragraph.Line jll = new JustifiedLayout.Paragraph.Line(format.start, format.end, offset, spaceOffset);

                for (int i = format.start; i < format.end; i++) {
                    // activeCanvas.drawText(token, x, y, paint);
                    jll.addWord(new JustifiedLayout.Paragraph.Line.Word(x, y));
                    x += offset + paint.measureText(tokenIterator.next()) + spaceOffset;
                }

                jlp.addLine(jll);

                // If all fit, then continue to next
                // paragraph
                if (fitAll) {
                    break;
                }

                // Don't allow leading spaces
                leadSpaces = false;

                // Increment to next line
                y += lineHeight;

                // Next start index for tokens
                start = format.end;
            }

            jl.addSection(jlp);
        }

        invalid = false;
        calculatedWidth = parentWidth;
        calculatedHeight = (int)( y + insetTop + insetBottom + ascent() - descent());

        this.setMeasuredDimension(calculatedWidth, calculatedHeight);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        // If wrap is disabled then,
        // request original onDraw
        if (!justify) {
            super.onDraw(canvas);
            return;
        }

        // Active canas needs to be set
        // based on cacheEnabled
        Canvas activeCanvas;

        // Set the active canvas based on
        // whether cache is enabled
        if (cacheEnabled) {
            if (cacheBitmap != null) {
                // Draw to the OS provided canvas
                // if the cache is not empty
                canvas.drawBitmap(cacheBitmap, 0, 0, paint);
                return;
            } else {
                // Create a bitmap and set the activeCanvas
                // to the one derived from the bitmap
                cacheBitmap = Bitmap.createBitmap(getWidth(), getHeight(), Config.ARGB_4444);
                activeCanvas = new Canvas(cacheBitmap);
            }
        } else {
            // Active canvas is the OS
            // provided canvas
            activeCanvas = canvas;
        }

        ListIterator<JustifiedLayout.Section> jli = jl.paragraphs.listIterator();

        while(jli.hasNext()){

            JustifiedLayout.Section jls = jli.next();

            if(jls instanceof JustifiedLayout.LineBreak){
                continue;
            }

            if(jls instanceof JustifiedLayout.ShortLine){
                JustifiedLayout.ShortLine jlsl = (JustifiedLayout.ShortLine) jls;
                activeCanvas.drawText(jlsl.line, jlsl.x, jlsl.y, paint);
                continue;
            }

            JustifiedLayout.Paragraph jlp = (JustifiedLayout.Paragraph) jls;
            ListIterator<JustifiedLayout.Paragraph.Line> jlpli = jlp.lines.listIterator();
            ListIterator<String> jlpt = jlp.tokens.listIterator();

            while(jlpli.hasNext()){

                JustifiedLayout.Paragraph.Line jln = jlpli.next();
                ListIterator<JustifiedLayout.Paragraph.Line.Word> jlplwi = jln.words.listIterator();

                while(jlplwi.hasNext()){

                    JustifiedLayout.Paragraph.Line.Word jlplw = jlplwi.next();
                    activeCanvas.drawText(jlpt.next(), jlplw.x, jlplw.y, paint);

                }

            }
        }

        if (cacheEnabled) {
            // Draw the cache onto the OS provided
            // canvas.
            canvas.drawBitmap(cacheBitmap, 0, 0, paint);
        }
    }

    private static class JustifiedLayout {

        public final List<Section> paragraphs;

        private static class Section {
        }

        private static class LineBreak extends Section {
        }

        private static class ShortLine extends Section {

            public final float x;
            public final float y;
            public final String line;

            public ShortLine(String line, float x, float y) {
                this.x = x;
                this.y = y;
                this.line = line;
            }
        }

        private static class Paragraph extends Section {

            private static class Line {

                private static class Word {

                    public final float x;
                    public final float y;

                    public Word(float x, float y){
                        this.x = x;
                        this.y = y;
                    }
                }

                public final int start;
                public final int end;
                public final float spaceOffset;
                public final float offset;

                public final List<Word> words;

                public Line(int start, int end, float offset, float spaceOffset) {
                    this.words = new LinkedList<Word>();
                    this.start = start;
                    this.end = end;
                    this.offset = offset;
                    this.spaceOffset = spaceOffset;
                }

                public void addWord(Word word) {
                    words.add(word);
                }
            }

            public final List<String> tokens;
            public final List<Line> lines;

            public Paragraph(LinkedList<String> tokens) {
                this.tokens = tokens;
                this.lines = new LinkedList<Line>();
            }

            public void addLine(Line line) {
                lines.add(line);
            }
        }

        public JustifiedLayout() {
            this.paragraphs = new LinkedList<Section>();
        }

        public void addSection(Section section) {
            paragraphs.add(section);
        }
    }


    @SuppressWarnings("serial")
    class TextJustifyException extends Exception {
        public TextJustifyException(String message) {
            super(message);
        }
    }

    /**
     * Class and function to process wrapping Implements a greedy algorithm to
     * fit as many words as possible into one line
     */

    private class JustifiedLine {

        public final int start;
        public final int end;
        public final float remainWidth;

        public String hyphenLeftover;

        public JustifiedLine(int start, int end, float remainWidth) {
            this.start = start;
            this.end = end;
            this.remainWidth = remainWidth;
            this.hyphenLeftover = null;
        }

        public JustifiedLine(int start, int end, float remainWidth, String hyphenLeftover) {
            this(start, end, remainWidth);
            this.hyphenLeftover = hyphenLeftover;
        }
    }

    /**
     * Break into word/space groups
     */

    private LinkedList<String> tokenize(String s) {

        LinkedList<String> groups = new LinkedList<String>();

        // If empty string, just return one group
        if (s.trim().length() <= 1) {
            groups.add(s);
            return groups;
        }

        int start = 0;
        boolean charSearch = s.charAt(0) == ' ';

        for (int i = 1; i < s.length(); i++) {
            // If the end add the word group
            if (i + 1 == s.length()) {
                groups.add(s.substring(start, i + 1));
                start = i + 1;
            }
            // Search for the start of non-space
            else if (charSearch && s.charAt(i) != ' ') {
                String substring = s.substring(start, i);
                if (substring.length() != 0) {
                    groups.add(s.substring(start, i));
                }
                start = i;
                charSearch = false;
            }
            // Search for the end of non-space
            else if (!charSearch && s.charAt(i) == ' ') {
                groups.add(s.substring(start, i));
                start = i + 1; // Skip the space
                charSearch = true;
            }
        }

        return groups;
    }



    /**
     * By contract, parameter "block" must not have any line breaks
     */

    private JustifiedLine justify(List<String> tokens, int start,
                                  Paint paint, float spaceOffset, float availableWidth,
                                  boolean hyphenate, boolean leadSpaces) {

        // Block is empty, then return empty
        if (tokens.size() == 0) {
            return new JustifiedLine(0, 0, availableWidth);
        }

        ListIterator<String> iterator = tokens.listIterator(start);

        // Greedy search to see if the word
        // can actually fit on a line
        for (int i = start; i < tokens.size(); i++) {

            // Get word
            String word = iterator.next();
            float wordWidth = paint.measureText(word);
            float remainingWidth = availableWidth - wordWidth;

            // Word does not fit in line
            if (remainingWidth < 0 && word.trim().length() != 0) {

                // Handle hyphening in the event
                // the current word does not fit
                if (hyphenate && justify) {

                    float lastFormattedPartialWidth = 0.0f;
                    String lastFormattedPartial = null;
                    String lastConcatPartial = null;
                    String concatPartial = "";

                    ArrayList<String> partials = hyphenator.hyphenate(word);

                    for (String partial : partials) {

                        concatPartial += partial;

                        // Create the hyphenated word
                        // aka. partial
                        String formattedPartial = concatPartial + HYPHEN_SYMBOL;
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

                                iterator.set(lastFormattedPartial);
                                iterator.add(word.substring(lastConcatPartial.length()));
                                availableWidth -= lastFormattedPartialWidth;

                                return new JustifiedLine(start, i + 1, availableWidth);
                            }
                        }
                    }
                }

                return new JustifiedLine(start, i, availableWidth + spaceOffset);

            }
            // Word fits in the line
            else {

                availableWidth -= wordWidth + spaceOffset;

                // NO remaining space
                if (remainingWidth <= 0) {
                    new JustifiedLine(start, i + 1, availableWidth
                            + spaceOffset);
                }
            }
        }

        return new JustifiedLine(start, tokens.size(), availableWidth);
    }
}