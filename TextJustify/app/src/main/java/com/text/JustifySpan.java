package com.text;

import android.text.Layout;
import android.text.style.AlignmentSpan;

/**
 * Created by Mathew on 10/26/2014.
 */

public class JustifySpan implements AlignmentSpan {
    @Override
    public Layout.Alignment getAlignment() {
        return  Layout.Alignment.ALIGN_NORMAL;
    }
}