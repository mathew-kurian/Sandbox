package mk.universityoftexas.austin;

import android.view.View;
import mk.universityoftexas.austin.R;

public class BlogMenu extends Driver {    
    public void modAVE(){
    }
	@Override
	public int setLayout() {
		return R.layout.blog_menu;
	}
	@Override
	public void action() {	
		defaultAnimationEngine(500);
	}
	public void onClick(View target){	
		switch(target.getId()){
		case R.id.RSS1:		AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.UTESSocialStudies; break;
		case R.id.RSS2:		AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.GradStudentDev; break;
		case R.id.RSS3:		AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.TarltonLibraryNews; break;
		case R.id.RSS4:		AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.CreativePorblemSolving; break;
		case R.id.RSS5:		AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.FreeMindsProject; break;
		case R.id.RSS6:		AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.ThelLAHHerald; break;
		case R.id.RSS7:		AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.Polyphony; break;
		case R.id.RSS8:		AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.PublicAffairsReporting; break;
		case R.id.RSS9:		AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.GeoNews; break;
		case R.id.RSS10:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.ElementsofComputing; break;
		case R.id.RSS11:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.LegalwritingDotnetBlog; break;
		case R.id.RSS12:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.StraussIntistuteDidYouKnow; break;
		case R.id.RSS13:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.UTAikidoClub; break;
		case R.id.RSS14:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.CeneterforTramsportationResearchNews; break;
		case R.id.RSS15:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.HoggBlog; break;
		case R.id.RSS16:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.TexasTaiChi; break;
		case R.id.RSS17:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.URBAdvising; break;
		case R.id.RSS18:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.GenderEquity; break;
		case R.id.RSS19:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.TowerTalk; break;
		case R.id.RSS20:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.WtotheMWPMBACMB; break;
		case R.id.RSS21:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.questionsoveranswer; break;
		case R.id.RSS22:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.UTCommAbroad; break;
		case R.id.RSS23:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.KeriStephensBlog; break;
		case R.id.RSS24:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.HCMPHealthCareersMentorshipProgram; break;
		case R.id.RSS25:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.JohnMcCalpinsblog; break;
		case R.id.RSS26:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.HEASPA; break;
		case R.id.RSS27:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.UTLARP; break;
		case R.id.RSS28:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.AdministrativeSystemsMasterPlan; break;
		case R.id.RSS29:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.DesireePallais; break;
		case R.id.RSS30:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.CMRG; break;
		case R.id.RSS31:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.ProjectMALES; break;
		case R.id.RSS32:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.UTESWellness; break;
		case R.id.RSS33:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.ECOAdvising; break;
		case R.id.RSS34:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.UTESEducatorReasources; break;
		case R.id.RSS35:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.ThimblesandCare; break;
		case R.id.RSS36:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.NMC; break;
		case R.id.RSS37:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.RCWPS; break;
		case R.id.RSS38:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.SC11; break;
		case R.id.RSS39:	AVE.BLOG_RSS = XML_NEWS_BLOG.RSS.DMatUTA; break;
		}
		startActivity(Blog.class);
	}
	@Override
	public int setProgressMAX() {
		return 0;
	}
	@Override
	public void applyFont() {
		
	}
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
		return new int [] {R.id.blog_menu};
	}
}