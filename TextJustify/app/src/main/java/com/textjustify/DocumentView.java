package com.textjustify;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.text.TextPaint;
import android.util.Log;
import android.view.View;
import android.util.AttributeSet;

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
public class DocumentView extends View {

    // To do
    // + Add ellipses
    // + Fix line-height
    // + Add max lines

    private DocumentLayout layout;
    private Paint paint;

    // Caching content
    private boolean cacheEnabled = false;
    private Bitmap cacheBitmap = null;

    public DocumentView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    public DocumentView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public DocumentView(Context context) {
        super(context);
        init();
    }

    public void init(){
        paint = new TextPaint();
        paint.setTypeface(Typeface.defaultFromStyle(Typeface.NORMAL));
        paint.setTextSize(34);
        paint.setAntiAlias(true);

        layout = new DocumentLayout(paint);
    }

    @Override
    public void setDrawingCacheEnabled(boolean cacheEnabled) {
        this.cacheEnabled = cacheEnabled;
    }

    public void setText(String text, boolean justify) {
        this.layout.setText(text);
        requestLayout();
    }

    public CharSequence getText() {
        return this.layout.getText();
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec){
        int width = MeasureSpec.getSize(widthMeasureSpec);
        this.layout.getLayoutParams().setParentWidth(width);
        this.layout.measure();
        this.setMeasuredDimension(width, this.layout.getMeasuredHeight());
    }

    @SuppressLint("DrawAllocation")
    @Override
    protected void onDraw(Canvas canvas) {

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

        this.layout.draw(activeCanvas);

        if (cacheEnabled) {
            // Draw the cache onto the OS provided
            // canvas.
            canvas.drawBitmap(cacheBitmap, 0, 0, paint);
        }
    }
}