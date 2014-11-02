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
 * ChineseCharacterTest.java
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

import android.graphics.Typeface;
import android.os.Bundle;
import android.text.style.ForegroundColorSpan;
import android.text.style.RelativeSizeSpan;
import android.text.style.StyleSpan;

import com.text.DocumentView;
import com.text.style.JustifiedSpan;
import com.text.style.LeftSpan;
import com.text.test.helper.ArticleBuilder;
import com.text.test.helper.MyQuoteSpan;
import com.text.test.helper.TestActivity;

public class ChineseCharacterTest extends TestActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ArticleBuilder amb = new ArticleBuilder();

        amb.append(testName, false, new RelativeSizeSpan(2f), new StyleSpan(Typeface.BOLD),
                new LeftSpan());
        amb.append("<font color=0xFFC801>@levifan</font><font color=0x888888> Oct. 28, 2014</font>",
                true, new RelativeSizeSpan(0.8f), new StyleSpan(Typeface.BOLD));
        amb.append(
                "事訖乃返己轉身，可曰：以測機意」樂而不淫誨去出.，可曰：」誨耳出意.第十一回後竊聽己轉身訖乃返建章曰：.父親回衙汗流如雨玉，不題.，可事關雎覽誨.汗流如雨覽吉安而來冒認收了」關雎出曰：矣玉，不題事父親回衙.父親回衙玉，不題吉安而來汗流如雨冒認收了.在一處己轉身訖乃返危德至.建章曰：訖乃返以測機﻿白圭志不稱讚分得意.己轉身樂而不淫建章曰：﻿白圭志.誨意曰：去覽」耳矣.第八回」，可招」不題耳德泉淹曰：矣誨出事.汗流如雨冒認收了吉安而來父親回衙玉，不題.矣出意曰：.己轉身事在一處出建章曰：樂而不淫，可後竊聽以測機去.，愈聽愈惱饒爾去罷」此是後話也懊悔不了.玉，不題，可出汗流如雨父親回衙冒認收了耳關雎事曰：吉安而來.了」第一回不題第二回第九回第五回.，愈聽愈惱此是後話饒爾去罷」.意，可此是後話，愈聽愈惱」也懊悔不了覽饒爾去罷」耳關雎.此是後話，愈聽愈惱也懊悔不了饒爾去罷」<font color=0xFFC801>.意覽事出去.，愈聽愈惱饒爾去罷」也懊悔不了.第一回第三回德泉淹羨殺.了」第十回第八回.驚異第十回第五回第七回.，可驚異曰：德泉淹矣覽第二回出」相域去.意第十一回事訖乃返己轉身耳去﻿白圭志曰：.事」耳，可意關雎誨.事，可父親回衙曰：意出冒認收了吉安而來」去.矣出意曰：.己轉身事在一處出建章曰：樂而不淫，可後竊聽以測機去.，愈聽愈惱饒爾去罷」此是後話也懊悔不了.玉，不題，可出汗流如雨父親回衙冒認收了耳關雎事曰：吉安而來.了」第一回不題第二回第九回第五回.，愈聽愈惱此是後話饒爾去罷」.意，可此是後話，愈聽愈惱」也懊悔不了覽饒爾去罷」耳關雎.此是後話，愈聽愈惱也懊悔不了饒爾去罷」.意覽事出去.，愈聽愈惱饒爾去罷」也懊悔不了.第一回第三回德泉淹羨殺.了」第十回第八回.驚異第十回第五回第七回.，可驚異曰：德泉淹矣覽第二回出」相域去.意第十一回事訖乃返己轉身耳去﻿白圭志曰：.事」耳，可意關雎誨.事，可父親回衙曰：意出冒認收了吉安而來」去.矣出意曰：.己轉身事在一處出建章曰：樂而不淫，可後竊聽以測機去.，愈聽愈惱饒爾去罷」此是後話也懊悔不了.玉，不題，可出汗流如雨父親回衙冒認收了耳關雎事曰：吉安而來.了」第一回不題第二回第九回第五回.，愈聽愈惱此是後話饒爾去罷」.意，可此是後話，愈聽愈惱」也懊悔不了覽饒爾去罷」耳關雎.此是後話，愈聽愈惱也懊悔不了饒爾去罷」.意覽事出去.，愈聽愈惱饒爾去罷」也懊悔不了.第一回第三回德泉淹羨殺.了」第十回第八回.驚異第十回第五回第七回.，可驚異曰：德泉淹矣覽第二回出」相域去.意第十一回事訖乃返己轉身耳去﻿白圭志曰：.事」耳，可意關雎誨.事，可父親回衙曰：</font>意出冒認收了吉安而來」去.",
                true, new RelativeSizeSpan(0.8f), new JustifiedSpan(), new MyQuoteSpan(0xFFFFC801),
                new StyleSpan(Typeface.ITALIC), new ForegroundColorSpan(0xFF555555));
        amb.append(
                "矣意去出，可耳.，可意去矣不題招」德泉淹了」第二回.覽意誨事.吉安而來玉，不題父親回衙冒認收了汗流如雨.德泉淹出第六回第八回意第一回耳，可」第五回矣.樂而不淫建章曰：不稱讚第十一回訖乃返.吉安而來玉，不題父親回衙汗流如雨.曰：，可覽誨.不題德泉淹第二回第四回第十回第一回.去關雎出誨.饒爾去罷」也懊悔不了此是後話，愈聽愈惱.己轉身誨意第十一回事後竊聽去矣，可分得意」曰：.意，可出關雎覽」矣耳.出，可」事曰：耳.耳出事去.己轉身<font color=0xFFC801>訖乃返分得意.矣吉安而來」耳冒認收了汗流如雨覽事出，可.第八回相域第三回第十回第九回.出意分得意耳覽誨第十一回關雎，可事﻿白圭志.，愈聽愈惱饒爾去罷」也懊悔不了此是後話.矣意去出，可耳.，可意去矣不題招」德泉淹了」第二回.覽意誨事.吉安而來玉，不題父親回衙冒認收了汗流如雨.德泉淹出第六回第八回意第一回耳，可」第五回矣.樂而不淫建章曰：不稱讚第十一回訖乃返.吉安而來玉，不題父親回衙汗流如雨.曰：，可覽誨.不題德泉淹第二回第四回第十回第一回.去關雎出誨.饒爾去罷」也懊悔不了此是後話，愈聽愈惱.己轉身誨意第十一回事後竊聽去矣，可分得意」曰：.意，可出關雎覽」矣耳.出，可」事曰：耳.耳出事去.己轉身訖乃返分得意.矣吉安而來」耳冒認收了汗流如雨覽事出，可.第八回相域第三回第十回第九回.出意分得意耳覽誨第十一回關雎，可事﻿白圭志.，愈聽愈惱饒爾去罷」也懊悔不了此是後話.矣意去出，可耳.，可意去矣不題招」德泉淹了」第二回.覽意誨事.吉安而來玉，不題父親回衙冒認收了汗流如雨.德泉淹出第六回第八回意第一回耳，可」第五回矣.樂而不淫建章曰：不稱讚第十一回訖乃返.吉安而來玉，不題父親回衙汗流如雨.曰：，可覽誨.不題德泉淹第二回第四回第十回第一回.去關雎出誨.饒爾去罷」也懊悔不了此是後話，愈聽愈惱.己轉身誨意第十一回事後竊聽去矣，</font>可分得意」曰：.意，可出關雎覽」矣耳.出，可」事曰：耳.耳出事去.己轉身訖乃返分得意.矣吉安而來」耳冒認收了汗流如雨覽事出，可.第八回相域第三回第十回第九回.出意分得意耳覽誨第十一回關雎，可事﻿白圭志.，愈聽愈惱饒爾去罷」也懊悔不了此是後話.",
                true, new RelativeSizeSpan(0.8f), new JustifiedSpan());
        amb.append(
                "意關雎去覽矣曰：誨.去曰：覽關雎事意.意出關雎耳誨去覽.」事第八回不題曰：羨殺第三回誨第一回.去，可耳意關雎誨矣覽.曰：」出誨意事，可.父親回衙汗流如雨玉，不題冒認收了.第十一回樂而不淫以測機建章曰：危德至.訖乃返不稱讚第十一回建章曰：意己轉身關雎事後竊聽曰：去誨覽.去關雎耳，可」曰：矣.意矣」，可曰：.去意覽，可.父親回衙」出玉，不題誨事，可吉安而來冒認收了去曰：覽.耳此是後話，愈聽愈惱也懊悔不了曰：矣饒爾去罷」去出」.冒認收了汗流如雨吉安而來.誨」矣關雎事曰：覽，可.誨」曰：耳覽去關雎意.關雎事羨殺，可第十回耳了」招」矣德泉淹第七回覽去.饒爾去罷」也懊悔不了耳覽此是後話，愈聽愈惱，可矣」.第二回德泉淹第一回第七回不題第九回.在一處以測機分得意不稱讚.矣，可事曰：去意」.也懊悔不了此是後話，愈聽愈惱饒爾去罷」.意關雎去覽矣曰：誨.去曰：覽關雎事意.意<font color=0xFFC801>出關雎耳誨去覽.」事第八回不題曰：羨殺第三回誨第一回.去，可耳意關雎誨矣覽.曰：」出誨意事，可.父親回衙汗流如雨玉，不題冒認收了.第十一回樂而不淫以測機建章曰：危德至.訖乃返不稱讚第十一回建章曰：意己轉身關雎事後竊聽曰：去誨覽.去關雎耳，可」曰：矣.意矣」，可曰：.去意覽，可.父親回衙」出玉，不題誨事，可吉安而來冒認收了去曰：覽.耳此是後話，愈聽愈惱也懊悔不了曰：矣饒爾去罷」去出」.冒認收了汗流如雨吉安而來.誨」矣關雎事曰：覽，可.誨」曰：耳覽去關雎意.關雎事羨殺，可第十回耳了」招」矣德泉淹第七回覽去.饒爾去罷」也懊悔不了耳覽此是後話，愈聽愈惱，可矣」.第二回德泉淹第一回第七回不題第九回.在一處以測機分得意不稱讚.矣，可事曰：去意」.也懊悔不了此是後話，愈聽愈惱饒爾去罷」.意關雎去覽矣曰：誨.去曰：覽關雎事意.意出關雎耳誨去覽.」事第八回不題曰：羨殺第三回誨第一回.去，可耳意關雎誨矣覽.曰：」出誨意事，可.父親回衙汗流如雨玉，不題冒認收了.第十一回樂而不淫以測機建章曰：危德至.訖乃返不稱讚第十一回建章曰：意己轉身關雎事後竊聽曰：去誨覽.去關雎耳，可」曰：矣.意矣」，可曰：.去意覽，可.父親回衙」出玉，不題誨事，可吉安而來冒認收了去曰：覽.耳此是後話，愈聽愈惱也懊悔不了曰：矣饒爾去罷」去出」.冒認收了汗流如雨吉安而來.誨」矣關雎事曰：覽</font>，可.誨」曰：耳覽去關雎意.關雎事羨殺，可第十回耳了」招」矣德泉淹第七回覽去.饒爾去罷」也懊悔不了耳覽此是後話，愈聽愈惱，可矣」.第二回德泉淹第一回第七回不題第九回.在一處以測機分得意不稱讚.矣，可事曰：去意」.也懊悔不了此是後話，愈聽愈惱饒爾去罷」.意關雎去覽矣曰：誨.去曰：覽關雎事意.意出關雎耳誨去覽.」事第八回不題曰：羨殺第三回誨第一回.去，可耳意關雎誨矣覽.曰：」出誨意事，可.父親回衙汗流如雨玉，不題冒認收了.第十一回樂而不淫以測機建章曰：危德至.訖乃返不稱讚第十一回建章曰：意己轉身關雎事後竊聽曰：去誨覽.去關雎耳，可」曰：矣.意矣」，可曰：.去意覽，可.父親回衙」出玉，不題誨事，可吉安而來冒認收了去曰：覽.耳此是後話，愈聽愈惱也懊悔不了曰：矣饒爾去罷」去出」.冒認收了汗流如雨吉安而來.誨」矣關雎事曰：覽，可.誨」曰：耳覽去關雎意.關雎事羨殺，可第十回耳了」招」矣德泉淹第七回覽去.饒爾去罷」也懊悔不了耳覽此是後話，愈聽愈惱，可矣」.第二回德泉淹第一回第七回不題第九回.在一處以測機分得意不稱讚.矣，可事曰：去意」.也懊悔不了此是後話，愈聽愈惱饒爾去罷」.",
                true, new RelativeSizeSpan(1.3f), new JustifiedSpan());
        amb.append(
                "誨曰：覽出關雎.曰：，可矣誨事.意誨耳關雎出曰：去.覽吉安而來出父親回衙汗流如雨意誨」，可關雎玉，不題.關雎」出意覽去矣.以測機在一處訖乃返建章曰：.父親回衙汗流如雨吉安而來玉，不題.出曰：，可矣.曰：關雎誨覽耳.去父親回衙，可汗流如雨玉，不題意事誨曰：耳覽.關雎出，可意覽曰：」.事曰：，可矣去誨關雎.事覽誨關雎出矣.貢院第九回不題羨殺第八回第三回.第四回第一回第九回貢院.，可曰：吉安而來父親回衙汗流如雨玉，不題耳意.」曰：出關雎.第十回驚異德泉淹貢院.分得意己轉身建章曰：訖乃返.誨曰：覽出關雎.曰：，可矣誨事.意誨耳關雎出曰：去.覽吉安而來出父親回衙汗流如雨意誨」，可關雎玉，不題.關雎」出意覽去矣.以測機在一處訖乃返建章曰：.父親回衙汗流如雨吉安而來玉，不題.出曰：，可矣.曰：關雎誨覽耳.去父親回衙，可汗流如雨玉，不題意事誨曰：耳覽.關雎出，可意覽曰：」.事曰：，可矣去誨關雎.事<font color=0xFFC801>覽誨關雎出矣.貢院第九回不題羨殺第八回第三回.第四回第一回第九回貢院.，可曰：吉安而來父親回衙汗流如雨玉，不題耳意.」曰：出關雎.第十回驚異德泉淹貢院.分得意己轉身建章曰：訖乃返.誨曰：覽出關雎.曰：，可矣誨事.意誨耳關雎出曰：去.覽吉安而來出父親回衙汗流如雨意誨」，可關雎玉，不題.關雎」出意覽去矣.以測機在一處訖乃返建章曰：.父親回衙汗流如雨吉安而來玉，不題.出曰：，可矣.曰：關雎誨覽耳.去父親回衙，可汗流如雨玉，不題意事誨曰：耳覽.關雎出，可意覽曰：」.事曰：，可矣去誨關雎.事覽誨關雎出矣.貢院第九回不題羨殺第八回第三回.第四回第一回第九回貢院.，可曰：吉安而來父親回衙汗流如雨玉，不題耳意</font>.」曰：出關雎.第十回驚異德泉淹貢院.分得意己轉身建章曰：訖乃返.誨曰：覽出關雎.曰：，可矣誨事.意誨耳關雎出曰：去.覽吉安而來出父親回衙汗流如雨意誨」，可關雎玉，不題.關雎」出意覽去矣.以測機在一處訖乃返建章曰：.父親回衙汗流如雨吉安而來玉，不題.出曰：，可矣.曰：關雎誨覽耳.去父親回衙，可汗流如雨玉，不題意事誨曰：耳覽.關雎出，可意覽曰：」.事曰：，可矣去誨關雎.事覽誨關雎出矣.貢院第九回不題羨殺第八回第三回.第四回第一回第九回貢院.，可曰：吉安而來父親回衙汗流如雨玉，不題耳意.」曰：出關雎.第十回驚異德泉淹貢院.分得意己轉身建章曰：訖乃返.",
                true, new RelativeSizeSpan(0.8f), new JustifiedSpan());
        amb.append(
                "意矣去出誨關雎耳.饒爾去罷」此是後話也懊悔不了，愈聽愈惱.曰：」耳去事矣關雎出.去意出，可.曰：耳」事.耳覽去曰：矣事」意.不稱讚樂而不淫在一處己轉身.第二回第九回第七回.第九回第二回第八回羨殺第六回.第四回第二回第五回羨殺.汗流如雨玉，不題吉安而來父親回衙.玉，不題汗流如雨吉安而來冒認收了父親回衙.關雎誨曰：去.父親回衙冒認收了吉安而來.饒爾去罷」也懊悔不了，愈聽愈惱此是後話.以測機不稱讚樂而不淫第十一回建章曰：.第三回」第二回第六回誨出了」第十回耳矣.出矣誨覽關雎」去事.也懊悔不了，愈聽愈惱饒爾去罷」.第二回覽矣第一回」第七回相域誨意第八回去出.驚異意招」出第二回德泉淹第十回關雎覽第四回誨曰：.也懊悔不了事饒爾去罷」誨」此是後話出矣去覽意.曰：出，可意意矣去出誨關雎耳.饒爾去罷」此是後話也懊悔不了，愈聽愈惱.曰：」耳去事矣關雎出.去意出，可.曰：耳」事.耳覽去曰：矣事」意.不稱讚樂而不淫在一處己轉身.第二回第九回第七回.第九回第二回第八回羨殺第六回.第四回第二回第五回羨殺.汗流如雨玉，不題吉安而來父親回衙.玉，不題汗流如雨吉安而來冒認收了父親回衙.關雎誨曰：去.父親回衙冒認收了吉安而來.饒爾去罷」也懊悔不了，愈聽愈惱此是後話.以測機不稱讚樂而不淫第十一回建章曰：.第三回」第二回第六回誨出了」第十回耳矣.出矣誨覽關雎」去事.也懊悔不了，愈聽愈惱饒爾去罷」.第二回覽矣第一回」第七回相域誨意第八回去出.驚異意招」出第二回德泉淹第十回關雎覽第四回誨曰：.也懊悔不了事饒爾去罷」誨」此是後話出矣去覽意.曰：出，可意意矣去出誨關雎耳.饒爾去罷」此是後話也懊悔不了，愈聽愈惱.曰：」耳去事矣關雎出.去意出，可.曰：耳」事.耳覽去曰：矣事」意.不稱讚樂而不淫在一處己轉身.第二回第九回第七回.第九回第二回第八回羨殺第六回.第四回第二回第五回羨殺.汗流如雨玉，不題吉安而來父親回衙.玉，不題汗流如雨吉安而來冒認收了父親回衙.關雎誨曰：去.父親回衙冒認收了吉安而來.饒爾去罷」也懊悔不了，愈聽愈惱此是後話.以測機不稱讚樂而不淫第十一回建章曰：.第三回」第二回第六回誨出了」第十回耳矣.出矣誨覽關雎」去事.也懊悔不了，愈聽愈惱饒爾去罷」.第二回覽矣第一回」第七回相域誨意第八回去出.驚異意招」出第二回德泉淹第十回關雎覽第四回誨曰：.也懊悔不了事饒爾去罷」誨」此是後話出矣去覽意.曰：出，可意意矣去出誨關雎耳.饒爾去罷」此是後話也懊悔不了，愈聽愈惱.曰：」耳去事矣關雎出.去意出，可.曰：耳」事.耳覽去曰：矣事」意.不稱讚樂而不淫在一處己轉身.第二回第九回第七回.第九回第二回第八回羨殺第六回.第四回第二回第五回羨殺.汗流如雨玉，不題吉安而來父親回衙.玉，不題汗流如雨吉安而來冒認收了父親回衙.關雎誨曰：去.父親回衙冒認收了吉安而來.饒爾去罷」也懊悔不了，愈聽愈惱此是後話.以測機不稱讚樂而不淫第十一回建章曰：.第三回」第二回第六回誨出了」第十回耳矣.出矣誨覽關雎」去事.也懊悔不了，愈聽愈惱饒爾去罷」.第二回覽矣第一回」第七回相域誨意第八回去出.驚異意招」出第二回德泉淹第十回關雎覽第四回誨曰：.也懊悔不了事饒爾去罷」誨」此是後話出矣去覽意.曰：出，可意意矣去出誨關雎耳.饒爾去罷」此是後話也懊悔不了，愈聽愈惱.曰：」耳去事矣關雎出.去意出，可.曰：耳」事.耳覽去曰：矣事」意.不稱讚樂而不淫在一處己轉身.第二回第九回第七回.第九回第二回第八回羨殺第六回.第四回第二回第五回羨殺.汗流如雨玉，不題吉安而來父親回衙.玉，不題汗流如雨吉安而來冒認收了父親回衙.關雎誨曰：去.父親回衙冒認收了吉安而來.饒爾去罷」也懊悔不了，愈聽愈惱此是後話.以測機不稱讚樂而不淫第十一回建章曰：.第三回」第二回第六回誨出了」第十回耳矣.出矣誨覽關雎」去事.也懊悔不了，愈聽愈惱饒爾去罷」.第二回覽矣第一回」第七回相域誨意第八回去出.驚異意招」出第二回德泉淹第十回關雎覽第四回誨曰：.也懊悔不了事饒爾去罷」誨」此是後話出矣去覽意.曰：出，可意",
                false, new RelativeSizeSpan(0.8f), new JustifiedSpan(),
                new StyleSpan(Typeface.ITALIC));

        addDocumentView(amb, DocumentView.FORMATTED_TEXT);
    }
}
