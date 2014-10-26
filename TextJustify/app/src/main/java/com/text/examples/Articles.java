package com.text.examples;

import android.graphics.Typeface;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.style.ForegroundColorSpan;
import android.text.style.RelativeSizeSpan;
import android.text.style.StyleSpan;

import com.text.JustifySpan;

/**
 * Created by Mathew on 10/26/2014.
 */
public class Articles {

    static class ArticleBuilder extends SpannableStringBuilder {
        public ArticleBuilder append(CharSequence text, boolean newline, Object ... spans){
            int start = this.length();
            this.append(Html.fromHtml("<p>" + text + "</p>" + (newline ? "<br>" : "")));
            for(Object span : spans) {
                this.setSpan(span, start, this.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
            }
            return this;
        }
    }

    static ArticleBuilder getWelcome(){
        ArticleBuilder ambb = new ArticleBuilder();
        ambb.append("<font color=0xFFC801>Welcome to DocumentView</font>",
                false, new RelativeSizeSpan(2.5f), new StyleSpan(Typeface.BOLD));
        return ambb;
    }
    static String getAbout(){
        StringBuilder smb = new StringBuilder();
        smb.append("Document view now supports both String and Spannables. To support this, there are two (2) types of layouts: (a) DocumentLayout and (b) SpannedDocumentLayout. " +
                "DocumentLayout supports just plain Strings just like the text you are reading. However, Spannables require the " +
                "constructor to have SpannedDocumentLayout.class as a parameter. For now, DocumentLayout will offer significant speed improvements" +
                "compared to SpannedDocumentLayout, so use each class accordingly. DocumentLayout also supports hyphenation. To learn moe about" +
                "these layouts and what they have to offer visit the link in the titlebar above. And please report all the issues on GitHub!" );
        return smb.toString();
    }

    static ArticleBuilder getArticle1(){
        ArticleBuilder ambb = new ArticleBuilder();
        ambb.append("WHO: Ebola Cases",
                false, new RelativeSizeSpan(2f), new StyleSpan(Typeface.BOLD))
                .append("<font color=0xFFC801>Sam Frizell</font><font color=0x888888> @Sam_Frizell  Oct. 25, 2014</font>",
                        false, new RelativeSizeSpan(0.8f), new StyleSpan(Typeface.BOLD))
                .append("<font color=0x888888>Updated: Oct. 25, 2014 2:34 PM</font>".toUpperCase(),
                        true, new RelativeSizeSpan(0.6f), new StyleSpan(Typeface.BOLD))
                .append("Among the affected are 450 healthcare workers",
                        true, new RelativeSizeSpan(1.2f), new StyleSpan(Typeface.BOLD), new StyleSpan(Typeface.ITALIC))
                .append("The number of cases in the Ebola outbreak has exceeded 10,000, with 4,922 deaths recorded as of October 23, according to a World Health Organization report published Saturday.",
                        true, new RelativeSizeSpan(1f), new JustifySpan())
                .append("Of the 10,141 reported cases, 450 are healthcare workers, more than half of them in Liberia with three in the United States. A total of 244 healthcare workers have died of the disease.",
                        true, new RelativeSizeSpan(1f), new JustifySpan())
                .append("Outside of the three most affected countries in West Africa—Sierra Leone, Guinea and Liberia—there have been only 27 reported cases of the deadly illness.",
                        true, new RelativeSizeSpan(1f), new JustifySpan())
                .append("In New York and New Jersey, governors Andrew Cuomo and Chris Christie have implemented controversial quarantines on all healthcare workers returning from West Africa after a doctor returning from Guinea contracted the disease and was diagnosed in New York.",
                        true, new RelativeSizeSpan(1f), new JustifySpan());
        return ambb;
    }

    static ArticleBuilder getArticle2(){
        ArticleBuilder ambb = new ArticleBuilder();
        ambb.append("Christie and Cuomo Announce Mandatory Ebola Quarantine",
                false, new RelativeSizeSpan(2f), new StyleSpan(Typeface.BOLD))
                .append("<font color=0xFFC801>Justin Worland</font><font color=0x888888> @justinworland  Oct. 25, 2014</font>",
                        false,  new RelativeSizeSpan(0.8f), new StyleSpan(Typeface.BOLD))
                .append("<font color=0x888888>Updated: Oct. 25, 2014 2:34 PM</font>".toUpperCase(),
                        true, new RelativeSizeSpan(0.6f), new StyleSpan(Typeface.BOLD))
                .append("State health department staff will be on the ground at state airports",
                        true, new RelativeSizeSpan(1.2f), new StyleSpan(Typeface.BOLD), new StyleSpan(Typeface.ITALIC))
                .append("Healthcare workers returning to New York or New Jersey after treating Ebola patients in West Africa will be placed under a mandatory quarantine, officials announced Friday, one day after a Doctors Without Borders doctor was diagnosed with the virus in New York City. Illinois announced a similar policy Saturday, meaning it will be enforced in states with three of the five airports through which passengers traveling from the Ebola-stricken West African countries must enter the United States.",
                        true, new RelativeSizeSpan(1f), new JustifySpan())
                .append("N.J. Gov. Chris Christie and N.Y. Gov. Andrew Cuomo made the announcement as part of a broader procedural plan to help protect the densely packed, highly populated area from any further spread of the disease.",
                        true, new RelativeSizeSpan(1f), new JustifySpan())
                .append("“Since taking office, I have erred on the side of caution when it comes to the safety and protection of New Yorkers, and the current situation regarding Ebola will be no different,” Gov. Cuomo said. “The steps New York and New Jersey are taking today will strengthen our safeguards to protect our residents against this disease and help ensure those that may be infected by Ebola are treated with the highest precautions.”",
                        true, new RelativeSizeSpan(1f), new JustifySpan())
                .append("New York and New Jersey state health department staff will be present on the ground at John F. Kennedy International Airport in New York and Newark Liberty Airport in New Jersey. In addition to implementing the mandatory quarantine of health care workers and others who had direct contact with Ebola patients, health department officials in each state will determine whether others should travelers should be hospitalized or quarantined.",
                        true, new RelativeSizeSpan(1f), new JustifySpan(), new StyleSpan(Typeface.ITALIC))
                .append("“The announcements mark a dramatic escalation in measures designed to prevent the spread of Ebola in the United States. Previously, only individuals with symptoms of Ebola would be quarantined upon entry to the U.S. under a federal rule from the Centers for Diseases Control and the Department of Homeland Security.”",
                        true, new RelativeSizeSpan(1f), new JustifySpan());
        return ambb;
    }
}
