package com.text.test.helper;

import android.text.Html;
import android.text.SpannableStringBuilder;
import android.text.Spanned;

/**
 * Created by Mathew Kurian on 10/31/2014.
 */
public class ArticleBuilder extends SpannableStringBuilder {
    public ArticleBuilder append(CharSequence text, boolean newline, Object... spans) {
        int start = this.length();
        this.append(Html.fromHtml(text + "<br/>" + (newline ? "<br/>" : "")));
        for (Object span : spans) {
            this.setSpan(span, start, this.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
        }
        return this;
    }
}