package com.text.examples;

import android.app.Activity;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;
import com.text.*;

public class SimpleExample extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.simpleexample);

        LinearLayout articleList = (LinearLayout) findViewById(R.id.articleList);

        Typeface nytmedium = Typeface.createFromAsset(getAssets(), "fonts/nyt-cheltenham-medium.ttf");
        Typeface nytnormal = Typeface.createFromAsset(getAssets(), "fonts/nyt-cheltenham-normal.ttf");

        articleList.addView(createDocumentView(Articles.getWelcome(), SpannedDocumentLayout.class, nytmedium,true));
        articleList.addView(createDocumentView(Articles.getAbout(), DocumentLayout.class, nytnormal,true));
        articleList.addView(createDocumentView(Articles.getArticle1(), SpannedDocumentLayout.class, nytnormal,true));
        articleList.addView(createDocumentView(Articles.getArticle2(), SpannedDocumentLayout.class, nytnormal,true));
    }

    public View createDocumentView(CharSequence article, Class<? extends DocumentLayout> layoutClass, Typeface typeface, boolean border){

        DocumentView documentView = new DocumentView(this, layoutClass);
        documentView.setColor(0xffffffff);
        documentView.setTypeface(typeface);
        documentView.getDocumentLayoutParams().setLeft(100.0f);
        documentView.getDocumentLayoutParams().setRight(100.0f);
        documentView.getDocumentLayoutParams().setTop(100.0f);
        documentView.getDocumentLayoutParams().setBottom(100.0f);
        documentView.getDocumentLayoutParams().setLineHeightMultiplier(1.3f);
        documentView.setText(article, true); // true: enable justification

        LinearLayout linearLayout = new LinearLayout(this);
        linearLayout.setOrientation(LinearLayout.VERTICAL);
        linearLayout.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.WRAP_CONTENT));
        linearLayout.addView(documentView);

        if(border) {
            linearLayout.setBackgroundDrawable(getResources().getDrawable(R.drawable.borderbottom));
        }

        return linearLayout;
    }
}
