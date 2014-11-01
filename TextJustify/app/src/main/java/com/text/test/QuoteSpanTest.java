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
import android.text.style.ForegroundColorSpan;
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
                        false, new RelativeSizeSpan(2f), new StyleSpan(Typeface.BOLD), new LeftSpan())
                .append("<font color=0xFFC801>Jon Brodkin</font><font color=0x888888> Oct. 28, 2014</font>",
                        true, new RelativeSizeSpan(0.8f), new StyleSpan(Typeface.BOLD))
                .append("But now we have more numbers on the performance declines, thanks to a new report from the Measurement Lab Consortium (M-Lab). M-Lab hosts measuring equipment at Internet exchange points to analyze connections between network operators and has more than five years' worth of measurements. A report released today examines connections between consumer Internet service providers (\"Access ISPs\" in M-Lab parlance) and backbone operators (\"Transit ISPs\"), including the ones that sent traffic from Netflix to ISPs while the money fights were still going on."
                        , true, new RelativeSizeSpan(1f), new JustifiedSpan(), new MyQuoteSpan(0xFFFFC801, 2, 30), new StyleSpan(Typeface.ITALIC), new ForegroundColorSpan(0xFF555555))
                .append("Using Measurement Lab (M-Lab) data, and constraining our research to the United States, we observed sustained performance degradation experienced by customers of Access ISPs AT&T, Comcast, CenturyLink, Time Warner Cable, and Verizon when their traffic passed over interconnections with Transit ISPs Cogent Communications (Cogent), Level 3 Communications (Level 3), and XO Communications (XO),\" researchers wrote. \"In a large number of cases we observed similar patterns of performance degradation whenever and wherever specific pairs of Access/Transit ISPs interconnected. From this we conclude that ISP interconnection has a substantial impact on consumer internet performance—sometimes a severely negative impact—and that business relationships between ISPs, and not major technical problems, are at the root of the problems we observed.", true, new RelativeSizeSpan(1f), new JustifiedSpan())
                .append("矣意去出，可耳.，可意去矣不題招」德泉淹了」第二回.覽意誨事.吉安而來玉，不題父親回衙冒認收了汗流如雨.德泉淹出第六回第八回意第一回耳，可」第五回矣.樂而不淫建章曰：不稱讚第十一回訖乃返.吉安而來玉，不題父親回衙汗流如雨.曰：，可覽誨.不題德泉淹第二回第四回第十回第一回.去關雎出誨.饒爾去罷」也懊悔不了此是後話，愈聽愈惱.己轉身誨意第十一回事後竊聽去矣，可分得意」曰：.意，可出關雎覽」矣耳.出，可」事曰：耳.耳出事去.己轉身<font color=0xFFC801>訖乃返分得意.矣吉安而來」耳冒認收了汗流如雨覽事出，可.第八回相域第三回第十回第九回.出意分得意耳覽誨第十一回關雎，可事﻿白圭志.，愈聽愈惱饒爾去罷」也懊悔不了此是後話.矣意去出，可耳.，可意去矣不題招」德泉淹了」第二回.覽意誨事.吉安而來玉，不題父親回衙冒認收了汗流如雨.德泉淹出第六回第八回意第一回耳，可」第五回矣.樂而不淫建章曰：不稱讚第十一回訖乃返.吉安而來玉，不題父親回衙汗流如雨.曰：，可覽誨.不題德泉淹第二回第四回第十回第一回.去關雎出誨.饒爾去罷」"
                        , false, new RelativeSizeSpan(1f), new RightSpan(), new MyQuoteSpan(0xFFFFC801, 2, 30), new StyleSpan(Typeface.ITALIC), new ForegroundColorSpan(0xFF555555)), DocumentView.FORMATTED_TEXT);
    }
}
