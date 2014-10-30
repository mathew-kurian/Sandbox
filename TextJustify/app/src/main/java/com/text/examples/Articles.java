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
 * Articles.java
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

import android.graphics.Color;
import android.graphics.Typeface;
import android.text.Html;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.style.RelativeSizeSpan;
import android.text.style.StyleSpan;

import com.text.style.CenterSpan;
import com.text.style.JustifiedSpan;
import com.text.style.LeftSpan;
import com.text.style.RightSpan;

public class Articles {

    static class ArticleBuilder extends SpannableStringBuilder {
        public ArticleBuilder append(CharSequence text, boolean newline, Object... spans) {
            int start = this.length();
            this.append(Html.fromHtml("<p>" + text + "</p>" + (newline ? "<br/>" : "")));
            for (Object span : spans) {
                this.setSpan(span, start, this.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
            }
            return this;
        }
    }

    static ArticleBuilder getWelcome() {
        return new ArticleBuilder()
                .append("<font color=0xFFC801>Welcome to DocumentView</font>",
                        false, new RelativeSizeSpan(2.5f), new StyleSpan(Typeface.BOLD), new LeftSpan());
    }

    static String getAbout() {
        return new StringBuilder()
                .append("Document view now supports both String and Spannables. To support this, there are two (2) types of layouts: (a) DocumentLayout and (b) SpannedDocumentLayout. " +
                        "DocumentLayout supports just plain Strings just like the text you are reading. However, Spannables require the " +
                        "constructor to have SpannedDocumentLayout.class as a parameter. For now, DocumentLayout will offer significant speed improvements " +
                        "compared to SpannedDocumentLayout, so use each class accordingly. DocumentLayout also supports hyphenation. To learn more about" +
                        "these layouts and what they have to offer visit the link in the titlebar above. And please report all the issues on GitHub!").toString();
    }

    static ArticleBuilder getArticle1() {
        return new ArticleBuilder()
                .append("WHO: Ebola Cases",
                        false, new RelativeSizeSpan(2f), new StyleSpan(Typeface.BOLD))
                .append("<font color=0xFFC801>Sam Frizell</font><font color=0x888888> @Sam_Frizell  Oct. 25, 2014</font>",
                        false, new RelativeSizeSpan(0.8f), new StyleSpan(Typeface.BOLD))
                .append("<font color=0x888888>Updated: Oct. 25, 2014 2:34 PM</font>".toUpperCase(),
                        true, new RelativeSizeSpan(0.6f), new StyleSpan(Typeface.BOLD))
                .append("Among the affected are 450 healthcare workers",
                        true, new RelativeSizeSpan(1.2f), new StyleSpan(Typeface.BOLD), new StyleSpan(Typeface.ITALIC))
                .append("The number of cases in the Ebola outbreak has exceeded 10,000, with 4,922 deaths recorded as of October 23, according to a World Health Organization report published Saturday.",
                        true, new RelativeSizeSpan(1f), new JustifiedSpan())
                .append("Of the 10,141 reported cases, 450 are healthcare workers, more than half of them in Liberia with three in the United States. A total of 244 healthcare workers have died of the disease.",
                        true, new RelativeSizeSpan(1f), new JustifiedSpan())
                .append("Outside of the three most affected countries in West Africa—Sierra Leone, Guinea and Liberia—there have been only 27 reported cases of the deadly illness.",
                        true, new RelativeSizeSpan(1f), new JustifiedSpan())
                .append("In New York and New Jersey, governors Andrew Cuomo and Chris Christie have implemented controversial quarantines on all healthcare workers returning from West Africa after a doctor returning from Guinea contracted the disease and was diagnosed in New York.",
                        false, new RelativeSizeSpan(1f), new JustifiedSpan());
    }

    static ArticleBuilder getArticle4() {
        return new ArticleBuilder()
                .append("LeadingMarginSpan2 Test",
                        false, new RelativeSizeSpan(2f), new StyleSpan(Typeface.BOLD))
                .append("<font color=0xFFC801>@levifan</font><font color=0x888888> Oct 9. 28, 2014</font>",
                        true, new RelativeSizeSpan(0.8f), new StyleSpan(Typeface.BOLD))
                .append("现代计算机中内存空间都是按照byte划分的，从理论上讲似乎对任何类型的变量的访问可以从任何地址开始，<font color=0xFFC801>现代计算机中内存空间都是按照byte划分的，从理论上讲似乎对任何类型的变量的访问可以从任何地址开始</font>，" +
                        "但实际情况是在访问特定变量的时候经一定的规则在空间上排列，而不是顺序的一个接一个的排放，这就是对齐。现代计算机中内存空间都是按照byte划分的，从理论上讲似乎对任何类型的变量的访问可以从任何地址开始，但实际情况是在访问特定变量的时候" +
                        "经一定的规则在空间上排列，而不是顺序的一个接一个的排放，这就是对齐。"
                        , false, new RelativeSizeSpan(1f), new JustifiedSpan(), new TextLeadingMarginSpan(2, 100));
    }

    static ArticleBuilder getArticle2() {
        return new ArticleBuilder()
                .append("Christie and Cuomo Announce Mandatory Ebola Quarantine",
                        false, new RelativeSizeSpan(2f), new StyleSpan(Typeface.BOLD), new LeftSpan())
                .append("<font color=0xFFC801>Justin Worland</font><font color=0x888888> @justinworland  Oct. 25, 2014</font>",
                        false, new RelativeSizeSpan(0.8f), new StyleSpan(Typeface.BOLD))
                .append("<font color=0x888888>Updated: Oct. 25, 2014 2:34 PM</font>".toUpperCase(),
                        true, new RelativeSizeSpan(0.6f), new StyleSpan(Typeface.BOLD))
                .append("State health department staff will be on the ground at state airports",
                        true, new RelativeSizeSpan(1.2f), new StyleSpan(Typeface.BOLD), new StyleSpan(Typeface.ITALIC))
                .append("Healthcare workers returning to New York or New Jersey after treating Ebola patients in West Africa will be placed under a mandatory quarantine, officials announced Friday, one day after a Doctors Without Borders doctor was diagnosed with the virus in New York City. Illinois announced a similar policy Saturday, meaning it will be enforced in states with three of the five airports through which passengers traveling from the Ebola-stricken West African countries must enter the United States.",
                        true, new RelativeSizeSpan(1f), new JustifiedSpan())
                .append("N.J. Gov. Chris Christie and N.Y. Gov. Andrew Cuomo made the announcement as part of a broader procedural plan to help protect the densely packed, highly populated area from any further spread of the disease.",
                        true, new RelativeSizeSpan(1f), new RightSpan())
                .append("“Since taking office, I have erred on the side of caution when it comes to the safety and protection of New Yorkers, and the current situation regarding Ebola will be no different,” Gov. Cuomo said. “The steps New York and New Jersey are taking today will strengthen our safeguards to protect our residents against this disease and help ensure those that may be infected by Ebola are treated with the highest precautions.”",
                        true, new RelativeSizeSpan(1f), new CenterSpan(), new StyleSpan(Typeface.ITALIC))
                .append("New York and New Jersey state health department staff will be present on the ground at John F. Kennedy International Airport in New York and Newark Liberty Airport in New Jersey. In addition to implementing the mandatory quarantine of health care workers and others who had direct contact with Ebola patients, health department officials in each state will determine whether others should travelers should be hospitalized or quarantined.",
                        true, new RelativeSizeSpan(1f), new JustifiedSpan(), new StyleSpan(Typeface.ITALIC))
                .append("“The announcements mark a dramatic escalation in measures designed to prevent the spread of Ebola in the United States. Previously, only individuals with symptoms of Ebola would be quarantined upon entry to the U.S. under a federal rule from the Centers for Diseases Control and the Department of Homeland Security.”",
                        false, new RelativeSizeSpan(1f), new CenterSpan());
    }

    static ArticleBuilder getArticle3() {
        return new ArticleBuilder()
                .append("Chinese Text",
                        false, new RelativeSizeSpan(2f), new StyleSpan(Typeface.BOLD))
                .append("<font color=0xFFC801>@levifan</font><font color=0x888888> Oct. 28, 2014</font>",
                        true, new RelativeSizeSpan(0.8f), new StyleSpan(Typeface.BOLD))
                .append("现代计算机中内存空间都是按照byte划分的，从理论上讲似乎对任何类型的变量的访问可以从任何地址开始，<font color=0xFFC801>现代计算机中内存空间都是按照byte划分的，从理论上讲似乎对任何类型的变量的访问可以从任何地址开始</font>，" +
                        "但实际情况是在访问特定变量的时候经一定的规则在空间上排列，而不是顺序的一个接一个的排放，这就是对齐。现代计算机中内存空间都是按照byte划分的，从理论上讲似乎对任何类型的变量的访问可以从任何地址开始，但实际情况是在访问特定变量的时候" +
                        "经一定的规则在空间上排列，而不是顺序的一个接一个的排放，这就是对齐。"
                        , false, new RelativeSizeSpan(1f), new JustifiedSpan());
    }

    static ArticleBuilder getArticle5() {
        return new ArticleBuilder()
                .append("QuoteSpan Test",
                        false, new RelativeSizeSpan(2f), new StyleSpan(Typeface.BOLD))
                .append("<font color=0xFFC801>Jon Brodkin</font><font color=0x888888> Oct. 28, 2014</font>",
                        true, new RelativeSizeSpan(0.8f), new StyleSpan(Typeface.BOLD))
                .append("But now we have more numbers on the performance declines, thanks to a new report from the Measurement Lab Consortium (M-Lab). M-Lab hosts measuring equipment at Internet exchange points to analyze connections between network operators and has more than five years' worth of measurements. A report released today examines connections between consumer Internet service providers (\"Access ISPs\" in M-Lab parlance) and backbone operators (\"Transit ISPs\"), including the ones that sent traffic from Netflix to ISPs while the money fights were still going on."
                        , true, new RelativeSizeSpan(1f), new JustifiedSpan(), new QuoteSpan(Color.RED))
                .append("Netflix eventually agreed to pay Comcast, Verizon, Time Warner Cable, and AT&T for direct connections to their networks, but until that happened there was severe degradation in links carrying traffic from Netflix and many other Web services to consumers. Connections were particularly bad between ISPs and Cogent, one of the backbone operators that Netflix paid to carry its traffic."
                        , true, new RelativeSizeSpan(1f), new LeftSpan(), new QuoteSpan(Color.GREEN))
                .append("Using Measurement Lab (M-Lab) data, and constraining our research to the United States, we observed sustained performance degradation experienced by customers of Access ISPs AT&T, Comcast, CenturyLink, Time Warner Cable, and Verizon when their traffic passed over interconnections with Transit ISPs Cogent Communications (Cogent), Level 3 Communications (Level 3), and XO Communications (XO),\" researchers wrote. \"In a large number of cases we observed similar patterns of performance degradation whenever and wherever specific pairs of Access/Transit ISPs interconnected. From this we conclude that ISP interconnection has a substantial impact on consumer internet performance—sometimes a severely negative impact—and that business relationships between ISPs, and not major technical problems, are at the root of the problems we observed."
                        , false, new RelativeSizeSpan(1f), new RightSpan(), new QuoteSpan(Color.WHITE));
    }

    static SpannableStringBuilder getArticle6() {
        SpannableStringBuilder result = new SpannableStringBuilder();
        result.append("SpaceBug\n");
        result.append("现代计算机中内存空间都是按照byte划分的，从理论上讲似乎对任何类型的变量的访问可以从任何地址开始，<font color=0xFFC801>现代计算机中内存空间都是按照byte划分的，从理论上讲似乎对任何类型的变量的访问可以从任何地址开始</font>，" +
                "但实际情况是在访问特定变量的时候经一定的规则在空间上排列，而不是顺序的一个接一个的排放，这就是对齐。现代计算机中内存空间都是按照byte划分的，从理论上讲似乎对任何类型的变量的访问可以从任何地址开始，但实际情况是在访问特定变量的时候" +
                "经一定的规则在空间上排列，而不是顺序的一个接一个的排放，这就是对齐。\n");
        result.append("现代计算机\n");
        result.setSpan(new JustifiedSpan(), 0, result.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        result.setSpan(new TextLeadingMarginSpan(2, 100), 0, result.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);

        return result;
    }
}
