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
 * QuoteSpanTest.java
 * @author Mathew Kurian
 *
 * From TextJustify-Android Library v2.0
 * https://github.com/bluejamesbond/TextJustify-Android
 *
 * Please report any issues
 * https://github.com/bluejamesbond/TextJustify-Android/issues
 *
 * Date: 11/1/14 3:21 AM
 */

package com.text.test;

import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Bundle;
import android.text.style.RelativeSizeSpan;
import android.text.style.StyleSpan;

import com.text.DocumentView;
import com.text.style.JustifiedSpan;
import com.text.style.LeftSpan;
import com.text.style.RightSpan;
import com.text.test.helper.ArticleBuilder;
import com.text.test.helper.MyQuoteSpan;
import com.text.test.helper.TestActivity;

public class QuoteSpanTest extends TestActivity{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        addDocumentView(new ArticleBuilder()
                .append(testName,
                        true, new RelativeSizeSpan(2f), new StyleSpan(Typeface.BOLD), new LeftSpan())
                .append("<font color=0xFFC801>Jon Brodkin</font><font color=0x888888> Oct. 28, 2014</font>",
                        true, new RelativeSizeSpan(0.8f), new StyleSpan(Typeface.BOLD))
                .append("But now we have more numbers on the performance declines, thanks to a new report from the Measurement Lab Consortium (M-Lab). M-Lab hosts measuring equipment at Internet exchange points to analyze connections between network operators and has more than five years' worth of measurements. A report released today examines connections between consumer Internet service providers (\"Access ISPs\" in M-Lab parlance) and backbone operators (\"Transit ISPs\"), including the ones that sent traffic from Netflix to ISPs while the money fights were still going on."
                        , true, new RelativeSizeSpan(1f), new JustifiedSpan(), new MyQuoteSpan(Color.RED))
                .append("Netflix eventually agreed to pay Comcast, Verizon, Time Warner Cable, and AT&T for direct connections to their networks, but until that happened there was severe degradation in links carrying traffic from Netflix and many other Web services to consumers. Connections were particularly bad between ISPs and Cogent, one of the backbone operators that Netflix paid to carry its traffic."
                        , true, new RelativeSizeSpan(1f), new LeftSpan(), new MyQuoteSpan(Color.GREEN))
                .append("Using Measurement Lab (M-Lab) data, and constraining our research to the United States, we observed sustained performance degradation experienced by customers of Access ISPs AT&T, Comcast, CenturyLink, Time Warner Cable, and Verizon when their traffic passed over interconnections with Transit ISPs Cogent Communications (Cogent), Level 3 Communications (Level 3), and XO Communications (XO),\" researchers wrote. \"In a large number of cases we observed similar patterns of performance degradation whenever and wherever specific pairs of Access/Transit ISPs interconnected. From this we conclude that ISP interconnection has a substantial impact on consumer internet performance—sometimes a severely negative impact—and that business relationships between ISPs, and not major technical problems, are at the root of the problems we observed."
                        , false, new RelativeSizeSpan(1f), new RightSpan(), new MyQuoteSpan(Color.WHITE)), DocumentView.FORMATTED_TEXT);
    }
}
