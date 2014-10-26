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

    private Typeface notoSans;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.simpleexample);

        LinearLayout articleList = (LinearLayout) findViewById(R.id.articleList);

        notoSans = Typeface.createFromAsset(getAssets(), "fonts/notosans.ttf");

        articleList.addView(createDocumentView(Articles.getWelcome(), SpannedDocumentLayout.class, true));
        articleList.addView(createDocumentView(Articles.getAbout(), DocumentLayout.class, true));
        articleList.addView(createDocumentView(Articles.getArticle1(), SpannedDocumentLayout.class, true));
        articleList.addView(createDocumentView(Articles.getArticle2(), SpannedDocumentLayout.class, true));
    }

    public View createDocumentView(CharSequence article, Class<? extends DocumentLayout> layoutClass, boolean border){

        DocumentView documentView = new DocumentView(this, layoutClass);
        documentView.setColor(0xffffffff);
        documentView.setTypeface(notoSans);
        documentView.getDocumentLayoutParams().setLeft(100.0f);
        documentView.getDocumentLayoutParams().setRight(100.0f);
        documentView.getDocumentLayoutParams().setTop(100.0f);
        documentView.getDocumentLayoutParams().setBottom(100.0f);
        documentView.getDocumentLayoutParams().setLineHeightMultiplier(1.0f);
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
