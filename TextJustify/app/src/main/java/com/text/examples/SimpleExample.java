package com.text.examples;

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
 * SimpleExample.java
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

import android.app.Activity;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;

import com.text.DocumentLayout;
import com.text.DocumentView;
import com.text.SpannedDocumentLayout;
import com.text.styles.TextAlignment;

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

        articleList.addView(createDocumentView(Articles.getWelcome(), SpannedDocumentLayout.class, nytmedium, true));
        articleList.addView(createDocumentView(Articles.getAbout(), DocumentLayout.class, nytnormal, true));
        articleList.addView(createDocumentView(Articles.getArticle1(), SpannedDocumentLayout.class, nytnormal, true));
        articleList.addView(createDocumentView(Articles.getArticle2(), SpannedDocumentLayout.class, nytnormal, true));
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (Build.VERSION.SDK_INT >= 19) {
            if (hasFocus) {
                getWindow().getDecorView().setSystemUiVisibility(
                        View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                                | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                                | View.SYSTEM_UI_FLAG_FULLSCREEN
                                | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
            }
        }
    }

    public View createDocumentView(CharSequence article, Class<? extends DocumentLayout> layoutClass, Typeface typeface, boolean border) {

        DocumentView documentView = new DocumentView(this, layoutClass);
        documentView.setColor(0xffffffff);
        documentView.setTypeface(typeface);
        documentView.getDocumentLayoutParams().setTextAlignment(TextAlignment.JUSTIFIED);
        documentView.getDocumentLayoutParams().setLeft(100.0f);
        documentView.getDocumentLayoutParams().setRight(100.0f);
        documentView.getDocumentLayoutParams().setTop(100.0f);
        documentView.getDocumentLayoutParams().setBottom(100.0f);
        documentView.getDocumentLayoutParams().setLineHeightMultiplier(1.3f);
        documentView.setText(article, true); // true: enable justification

        LinearLayout linearLayout = new LinearLayout(this);
        linearLayout.setOrientation(LinearLayout.VERTICAL);
        linearLayout.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));
        linearLayout.addView(documentView);

        if (border) {
            linearLayout.setBackgroundDrawable(getResources().getDrawable(R.drawable.borderbottom));
        }

        return linearLayout;
    }
}
