package mk.universityoftexas.austin;

import android.graphics.Color;
import android.text.Html;
import android.view.View;
import android.widget.TextView;
import mk.universityoftexas.austin.R;

public class NewspaperMenu extends Driver {
    /** Called when the activity is first created. */
	private static String rTitle = "Founding the University of Texas";
	private static String rDescription = "In this virtual museum you will find information on and images of many different aspects of the cultural legacy of Texas, " +
			"a legacy spanning at least 13,500 years. Yes, people have been living within the borders of the modern political state of Texas for at least " +
			"13,500 years. In more concrete terms, that is over 540 human generations! For most of that immense time span, there is no recorded history, " +
			"no books, and no eyewitness accounts. Instead all we have to tell the stories of much of the cultural heritage of Texas are mute stones, ancient ";
	
	private static String rContent = " <p>In this virtual museum you will find information on and images of many different aspects of the cultural legacy of Texas, " +
			"a legacy spanning at least 13,500 years. Yes, people have been living within the borders of the modern political state of Texas for at least " +
			"13,500 years. In more concrete terms, that is over 540 human generations! For most of that immense time span, there is no recorded history, " +
			"no books, and no eyewitness accounts. Instead all we have to tell the stories of much of the cultural heritage of Texas are mute stones, ancient " +
			"campfires, broken bones, and delicate traces of once-flourishing societies. This is the material evidence upon which archeologists base most of our " +
			"interpretations. The arrival of the first Spanish explorers in the region in 1528 ushered in the historic era in Texas and the creation of the written " +
			"documents and drawings upon which historians depend. </p>"
  +"    <p>Our collective cultural heritage is complex and fascinating, if sometimes painful to recount. The sixteenth-century arrival of the Spanish, for "
  +"       instance, also marks the beginning of over 300 years of often-brutal cultural  "
  +"       conflict between Texas' native peoples&#151;Indians or Native Americans&#151;and  "
  +"       the mainly European-derived immigrants who made the land their own. In a few short centuries the native population of Texas was decimated. <em>Texas  "
  +"       Beyond History</em> covers not only the prehistory and history of Texas' true native peoples,  "
  +"       but also much of the early history of the Spanish, French, Mexican, and  "
  +"       Anglo explorers, missionaries, soldiers, miners, traders, and settlers  "
  +"       who lived and often died in Texas. And later history, too&#151;that of  "
  +"       German farmers, Black freedmen, and Mexican-American laborers among many  "
  +"       others. </p> "
  +"     <p>What sets <em>Texas Beyond History</em> apart is that by focusing on  "
  +"       the broad subject of Texas' cultural heritage, we overcome the traditional  "
  +"       boundaries between the disciplines of archeology and history as well as  "
  +"       the bureaucratic and political fences between institutions of higher education, state  "
  +"       and federal agencies, museums, and private organizations. By working in  "
  +"       partnership and collaboration with dozens and dozens of individuals, institutions,  "
  +"       and organizations, our aim is to help tell the stories of the peoples  "
  +"       who have settled the land we call Texas. To do that we reply on diverse experts as well as the documents and  images that help put the  "
  +"       stories of the past into meaningful context. </p> ";
    public void modAVE(){
    }
	@Override
	public int setLayout() {
		return R.layout.newspaper_menu;
	}
	@Override
	public void action() {	
		((HighlightedTextView) findViewById(R.id.RSS0)).setText("247 Sports".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS1)).setText("UT News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS2)).setText("Africa News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS3)).setText("Architecture".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS4)).setText("At Texas".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS5)).setText("Austin Chronicle".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS6)).setText("Be A Longhorn".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS7)).setText("Business And Enterprise News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS8)).setText("China News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS9)).setText("CNN Education".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS10)).setText("CNN Entertainment".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS11)).setText("CNN Health".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS12)).setText("CNN Law".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS13)).setText("CNN Most Popular".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS14)).setText("CNN Off beat".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS15)).setText("CNN Politics".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS16)).setText("CNN Technology".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS17)).setText("CNN TopStories".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS18)).setText("CNN Travel".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS19)).setText("CNN US".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS20)).setText("CNN World".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS21)).setText("College of Communication".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS22)).setText("College of Education".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS23)).setText("College of Engineering".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS24)).setText("College of Pharmacy".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS25)).setText("Cyber Atlas".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS26)).setText("Daily Texan Headlines".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS27)).setText("Dallas FortWorth News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS28)).setText("El Paso News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS29)).setText("ESPN".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS30)).setText("Europe News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS31)).setText("Eyes of Texas".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS32)).setText("Fine Arts".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS33)).setText("General Libraries".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS34)).setText("Graduate Studies".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS35)).setText("GSLIS".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS36)).setText("Housing and Food".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS37)).setText("Houston News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS38)).setText("India News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS39)).setText("Intenational Office".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS40)).setText("Internet Advertising Report".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS41)).setText("Internet Ecommerce News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS42)).setText("Internet News Top Headlines".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS43)).setText("Internet Product News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS44)).setText("Intradoc Users".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS45)).setText("ISP News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS46)).setText("IT News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS47)).setText("ITunes Top10".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS48)).setText("Jackson School of GeoSciences".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS49)).setText("JavaScript Tip of the Day".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS50)).setText("Latin America News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS51)).setText("LBJ School of Public Affairs".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS52)).setText("Liberal Arts".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS53)).setText("Mideast New".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS54)).setText("Motivational Quote of the Day".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS55)).setText("Motley Fool".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS56)).setText("Natural Science".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS57)).setText("Office of Admissions".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS58)).setText("Office of Public Affairs".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS59)).setText("On Campus".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS60)).setText("On Campus Today".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS61)).setText("Purchasing".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS62)).setText("Quote of the Day".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS63)).setText("Red McCombs School of Business".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS64)).setText("Salon".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS65)).setText("School of Nursing".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS67)).setText("School of Social Work".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS68)).setText("Slashdot".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS69)).setText("Slashdot IT".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS70)).setText("Streaming Media News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS71)).setText("Student Central Spotlights".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS72)).setText("Study Abroad".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS73)).setText("Tx Tell".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS74)).setText("Us Education".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS75)).setText("UTSA FYI".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS76)).setText("UTSA Today".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS77)).setText("UT System".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS78)).setText("Web Central Spotlights".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS79)).setText("Web Developer News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS80)).setText("Web Reference".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS81)).setText("Wired News".toUpperCase());
		((HighlightedTextView) findViewById(R.id.RSS82)).setText("XML and Metadata News".toUpperCase());
		
		
		TextView title = (TextView) findViewById(R.id.newspaper_menu_article_title);
		title.setText(rTitle);
		title.setTextColor(Color.BLACK);		
		AVE.applyNewsFont(this, title);
		
		TextView description = (TextView) findViewById(R.id.newspaper_menu_article_description);
		description.setTextColor(Color.BLACK);
		description.setTextSize(11);
		description.setText(Html.fromHtml("<b><i>" + rDescription + "</b></i>"));
		
		TextView content = (TextView) findViewById(R.id.newspaper_menu_article_content);
		content.setText(Html.fromHtml(rContent));
		content.setTextColor(Color.BLACK);
		content.setTextSize(11);
		content.setPadding(0, 3, 5, 0);
		
		defaultAnimationEngine(500);
	}
	public void onClick(View target){	
		switch(target.getId()){
			case R.id.RSS0:		AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.Sports247; break;
			case R.id.RSS1:		AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.UtNews; break;
			case R.id.RSS2:		AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.AfricaNews; break;
			case R.id.RSS3:		AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.Architecture; break;
			case R.id.RSS4:		AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.AtTexas; break;
			case R.id.RSS5:		AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.AustinChronicle; break;
			case R.id.RSS6:		AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.BeaLonghorn; break;
			case R.id.RSS7:		AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.BusinessandEnterpriseNews; break;
			case R.id.RSS8:		AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.ChinaNews; break;
			case R.id.RSS9:		AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNEducation; break;
			case R.id.RSS10:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNEntertainment; break;
			case R.id.RSS11:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNHealth; break;
			case R.id.RSS12:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNLaw; break;
			case R.id.RSS13:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNMostPopular; break;
			case R.id.RSS14:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNOffbeat; break;
			case R.id.RSS15:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNPolitics; break;
			case R.id.RSS16:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNTechnology; break;
			case R.id.RSS17:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNTopStories; break;
			case R.id.RSS18:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNTravel; break;
			case R.id.RSS19:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNUS; break;
			case R.id.RSS20:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CNNWorld; break;
			case R.id.RSS21:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CollegeofCommunication; break;
			case R.id.RSS22:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CollegeofEducation; break;
			case R.id.RSS23:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CollegeofEngineering; break;
			case R.id.RSS24:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CollegeofPharmacy; break;
			case R.id.RSS25:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.CyberAtlas; break;
			case R.id.RSS26:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.DailyTexnHeadlines; break;
			case R.id.RSS27:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.DallasFortWorthNews; break;
			case R.id.RSS28:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.ElPasoNews; break;
			case R.id.RSS29:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.ESPN; break;
			case R.id.RSS30:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.EuropeNews; break;
			case R.id.RSS31:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.EyesofTexas; break;
			case R.id.RSS32:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.FineArts; break;
			case R.id.RSS33:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.GeneralLibraries; break;
			case R.id.RSS34:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.GraduateStudies; break;
			case R.id.RSS35:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.GSLIS; break;
			case R.id.RSS36:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.HousingandFood; break;
			case R.id.RSS37:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.HoustonNews; break;
			case R.id.RSS38:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.IndiaNews; break;
			case R.id.RSS39:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.IntenationalOffice; break;
			case R.id.RSS40:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.InternetAdvertisingReport; break;
			case R.id.RSS41:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.InternetEcommerceNews; break;
			case R.id.RSS42:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.InternetNewsTopHeadlines; break;
			case R.id.RSS43:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.InternetProductNews; break;
			case R.id.RSS44:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.IntradocUsers; break;
			case R.id.RSS45:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.ISPNews; break;
			case R.id.RSS46:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.ITNews; break;
			case R.id.RSS47:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.ITunesTop10; break;
			case R.id.RSS48:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.JacksonSchoolofGeoSciences; break;
			case R.id.RSS49:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.JavaScriptTipoftheDay; break;
			case R.id.RSS50:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.LatinAmericaNews; break;
			case R.id.RSS51:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.LBJSchoolofPublicAffairs; break;
			case R.id.RSS52:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.LiberalArts; break;
			case R.id.RSS53:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.MideastNew; break;
			case R.id.RSS54:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.MotivationalQuoteoftheDay; break;
			case R.id.RSS55:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.MotleyFool; break;
			case R.id.RSS56:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.NaturalScience; break;
			case R.id.RSS57:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.OfficeofAdmissions; break;
			case R.id.RSS58:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.OfficeofPublicAffairs; break;
			case R.id.RSS59:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.OnCampus; break;
			case R.id.RSS60:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.OnCampusToday; break;
			case R.id.RSS61:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.Purchasing; break;
			case R.id.RSS62:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.QuoteoftheDay; break;
			case R.id.RSS63:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.RedMcCombsSchoolofBusiness; break;
			case R.id.RSS64:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.Salon; break;
			case R.id.RSS65:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.SchoolofNursing; break;
			case R.id.RSS67:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.SchoolofSocialWork; break;
			case R.id.RSS68:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.Slashdot; break;
			case R.id.RSS69:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.SlashdotIT; break;
			case R.id.RSS70:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.StreamingMediaNews; break;
			case R.id.RSS71:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.StudentCentralSpotlights; break;
			case R.id.RSS72:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.StudyAbroad; break;
			case R.id.RSS73:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.TxTell; break;
			case R.id.RSS74:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.UsEducation; break;
			case R.id.RSS75:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.UTSAFYI; break;
			case R.id.RSS76:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.UTSAToday; break;
			case R.id.RSS77:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.UTSystem; break;
			case R.id.RSS78:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.WebCentralSpotlights; break;
			case R.id.RSS79:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.WebDeveloperNews; break;
			case R.id.RSS80:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.WebReference; break;
			case R.id.RSS81:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.WiredNews; break;
			case R.id.RSS82:	AVE.NEWSPAPER_RSS = XML_NEWS_BLOG.RSS.XMLamdMetadataNews; break;
		}
		startActivity(Newspaper.class);
	}
	@Override
	public int setProgressMAX() {
		return 0;
	}
	@Override
	public void applyFont() {}
	@Override
	public void showInstructions() {}
	@Override
	public void preAction() {}
	@Override
	public int[] animationTypes() {
		return new int [] {R.anim.slowfadein};
	}
	@Override
	public int[] toAnimate() {
		return new int [] {R.id.newspaper_sheet};
	}
}