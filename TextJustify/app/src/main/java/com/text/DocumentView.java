package com.text;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.text.TextPaint;
import android.view.View;
import android.util.AttributeSet;

import java.lang.reflect.InvocationTargetException;
import java.util.NoSuchElementException;

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
        init(DocumentLayout.class);
    }

    public DocumentView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(DocumentLayout.class);
    }

    public DocumentView(Context context) {
        super(context);
        init(DocumentLayout.class);
    }

    public DocumentView(Context context, Class<? extends DocumentLayout> layoutClass){
        super(context);
        init(layoutClass);
    }

    private void init(Class<? extends DocumentLayout> layoutClass){
        this.paint = new TextPaint();

        // Initialize paint
        initPaint(this.paint);

        // Get default layout
        try {
            this.layout = getDocumentLayoutInstance(layoutClass, paint);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        }

    }

    public void setTextSize(float textSize) {
        paint.setTextSize(textSize);
    }
    public void setColor(int textColor){
        paint.setColor(textColor);
    }
    public void setTypeface(Typeface typeface) { paint.setTypeface(typeface); }

    public void initPaint(Paint paint){
        paint.setTypeface(Typeface.defaultFromStyle(Typeface.NORMAL));
        paint.setTextSize(34);
        paint.setAntiAlias(true);
    }

    public DocumentLayout getDocumentLayoutInstance(Class<? extends DocumentLayout> layoutClass, Paint paint) throws NoSuchElementException,
            NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException {
        return (DocumentLayout) layoutClass.getDeclaredConstructor(Paint.class).newInstance(paint);
    }

    @Override
    public void setDrawingCacheEnabled(boolean cacheEnabled) {
        this.cacheEnabled = cacheEnabled;
    }

    public void setText(CharSequence text, boolean justify) {
        this.layout.setText(text);
        requestLayout();
    }

    public CharSequence getText() {
        return this.layout.getText();
    }

    public DocumentLayout.LayoutParams getDocumentLayoutParams(){
        return this.layout.getLayoutParams();
    }

    public DocumentLayout getLayout(){
        return this.layout;
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