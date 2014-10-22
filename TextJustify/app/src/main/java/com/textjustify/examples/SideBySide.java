package com.textjustify.examples;

import android.app.Activity;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import com.textjustify.*;

public class SideBySide extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.sidebyside);

        DocumentView documentView = (DocumentView) findViewById(R.id.documentView);
        documentView.setText(getString(R.string.sample_text2), true); // true: enable justification

        CharSequence boldText = Html.fromHtml("<b>ABCDEFG</b>HIJK");
        TextPaint paint = new TextPaint();

        float measureTextWidth = paint.measureText(boldText, 0 , boldText.length());

        StaticLayout tempLayout = new StaticLayout(boldText, paint, 10000, android.text.Layout.Alignment.ALIGN_NORMAL, 1, 0, false);
        int lineCount = tempLayout.getLineCount();
        float textWidth =0;
        for(int i=0 ; i < lineCount ; i++){
            textWidth += tempLayout.getLineWidth(i);
        }

        Console.log("Width", textWidth);
        Console.log("Height", tempLayout.getHeight());
//        TextView txtView = (TextView) findViewById(R.id.textView);
//        txtView.setText(getString(R.string.sample_text2));
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.example1, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
