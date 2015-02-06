package tiffany.wordeditor;

import java.util.ArrayList;

import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.text.Editable;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.BackgroundColorSpan;
import android.text.style.BulletSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.ImageSpan;
import android.text.style.StrikethroughSpan;
import android.text.style.StyleSpan;
import android.text.style.SubscriptSpan;
import android.text.style.SuperscriptSpan;
import android.text.style.TabStopSpan;
import android.text.style.TypefaceSpan;
import android.text.style.UnderlineSpan;


@SuppressWarnings({ "unchecked", "rawtypes", "unused" })
public class Tiffany {	
	static SpannableStringBuilder builder;
	
	public static final class Default{		
		protected static boolean DIP_ENABLED = true;

		protected static final int CLIP_START = 0;
		protected static final int CLIP_END = 0;

		protected static final int TEXT_SIZE = 15;        
		protected static final int TEXT_COLOR = Color.BLACK; 
		protected static final int HIGHLIGHT_COLOR = Color.TRANSPARENT; 

		protected static int SPACING_OFFSET = 0;
		protected static int SPACING_LEFT_OFFSET = 0;
		protected static int SPACING_RIGHT_OFFSET = 0;		

		protected static int INDENTATION_OFFSET = 0;
		protected static int INDENTATION_AFTER_OFFSET = 0;
		protected static int INDENTATION_BEFORE_OFFSET = 0;

		protected static int PAGE_MARGIN_LEFT = 0;
		protected static int PAGE_MARGIN_TOP = 0;
		protected static int PAGE_MARGIN_RIGHT = 0;
		protected static int PAGE_MARGIN_BOTTOM = 0;

		protected static final Alignment.Mode ALIGNMENT = Alignment.Mode.LEFT;	
		protected static final BulletStyle.Mode BULLET_STYLE = BulletStyle.Mode.NONE;
		protected static final TextEffect.Mode TEXT_EFFCT = TextEffect.Mode.NONE;
		protected static final TextStyle.Mode TEXT_STYLE = TextStyle.Mode.NONE;
		protected static final String TEXT_FACE = TextFace.Family.MONOSPACE;
		protected static final IndentationStyle.Mode INDENTATION_STYLE = IndentationStyle.Mode.NONE;
		protected static final SpacingStyle.Mode SPACING_STYLE = SpacingStyle.Mode.SINGLE;
		protected static final Sort.Mode SORT = Sort.Mode.NONE;
	}

	/***************************************************************************************/
	static WordEditor wEditor;
	/***************************************************************************************/
	public Tiffany(WordEditor w){
		wEditor = w;
	}   
	//-------------------------------------------------------------------------------------------------------------------------------/PRIVATE METHODS. ONLY VISIBLE TO MAKER OF THIS CLASS NOT USERS
	private static SpannableStringBuilder _text(){
		builder = new SpannableStringBuilder();
		builder.append( wEditor.getText());
		return builder;
	}
	//JAVADOC: Can throw IllegalAccessException, InstantiationException
	private static boolean containsSpan(Class n){
		try {
			if(_start <= _text().getSpanStart(n.newInstance()) && _end <= _text().getSpanEnd(n.newInstance()))
				return true;
			else 
				return false;
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		}
		return false;
	}
	private static Object[] getSpans(Class n){
		return _text().getSpans(_start, _end, n);
	}
	private static boolean containsSpan(Object obj){
		if(_start <= _text().getSpanStart(obj) && _end <= _text().getSpanEnd(obj))
			return true;
		else 
			return false;
	}
	private static void removeSpans(Object [] obj){
		for(int x = 0; x<obj.length; x++)
			_text().removeSpan(obj[x]);
	}
	/***************************************************************************************/
	static ArrayList<Object> formats = new ArrayList<Object>();
	/***************************************************************************************/	
	private static void setSpan(Object format){
		removeSpans(getSpans(format.getClass()));
		_text().setSpan(format, _start , _end, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
		wEditor.setText(builder);
	}
	//-------------------------------------------------------------------------------------------------------------------------------/
	public static void setBackground(int color){
		wEditor.setBackgroundColor(color);
	}
	/***************************************************************************************/
	static int _start = Default.CLIP_START;
	static int _end = Default.CLIP_END;	
	/***************************************************************************************/
	public static void setClip(int start, int end){
		_start = start;
		_end = end;
	}
	public static void clearClip(int start, int end){
		setClip(Default.CLIP_START, Default.CLIP_END);
	}
	public static void fullClip(){    
		setClip(0, _text().length());
	}
	public static void setClipFromSelection(){
		setClip(wEditor.getSelectionStart(), wEditor.getSelectionEnd()); 
	}
	/***************************************************************************************/
	static int _textSize=  Default.TEXT_SIZE;
	static boolean _dpEnabled = Default.DIP_ENABLED;
	/***************************************************************************************/	
	public static void increaseTextSize(int offset){
		_textSize+=offset;
		setTextSize(_textSize);
	}
	public static void decreaseTextSize(int offset){		
		_textSize-=offset;
		setTextSize(_textSize);
	}
	public static void setTextSize(int size){
		setSpan(new AbsoluteSizeSpan(_textSize, _dpEnabled));
	}
	public static void addImage(int id){
		Drawable d2 = wEditor.getContext().getResources().getDrawable(id);
		d2.setBounds(0, 0, d2.getIntrinsicWidth(), d2.getIntrinsicHeight()); 
		setSpan(new ImageSpan(d2));
	}
	/***************************************************************************************/
	static String _textFace = TextFace.Family.DEFAULT;
	static TextStyle.Mode _textStyle = TextStyle.Mode.NONE;
	static int _textColor = Default.TEXT_COLOR;
	static int _highlightColor = Default.HIGHLIGHT_COLOR;
	/***************************************************************************************/		
	//JAVADOC: family set to TextFace.DEFAULT creates normal font. should not be used with TextFace.Mode.CUSTOM
	public static void setTextAppearance(String family, int textColor, int size, TextStyle.Mode style, TextEffect.Mode effect, int highlightColor){		
		_textFace = family;
		_textColor = textColor;
		_textStyle = style;
		_textSize = size;
		_textEffect = effect;
		_highlightColor = highlightColor;		

		setTextFace(_textFace);
		setTextColor(_textColor);
		setTextEffect(_textEffect);
		setTextHighlight(highlightColor);
	}
	/***************************************************************************************/
	static TextEffect.Mode _textEffect = TextEffect.Mode.NONE;
	/***************************************************************************************/
	public static void setTextEffect(TextEffect.Mode effect){
		_textEffect =  effect;
		switch(_textEffect){
		case SINGLE_STRIKETHROUGH:{    
			setSpan(new StrikethroughSpan());
			break;}
		case DOUBLE_STRIKETHROUGH:{
			setSpan(new StrikethroughSpan());
			break;}
		case SUPERSCRIPT:{
			setSpan(new SuperscriptSpan());
			break;}
		case SUBSCRIPT:{
			setSpan(new SubscriptSpan());
			break;}
		case SMALL_CAPS:    break;
		case ALL_CAPS:      break;
		case HIDDEN:        break;
		}
	}
	public static void setTextFace(String family){
		_textFace = family;
		setSpan(new TypefaceSpan(_textFace));
	}
	public static void setTextColor(int color){
		_textColor = color;
		setSpan(new ForegroundColorSpan(_textColor));
	}
	public static void setTextStyle(TextStyle.Mode mode){
		_textStyle = mode;
		switch(_textStyle){
		case NONE:{    
			setSpan(new StyleSpan(Typeface.NORMAL));
			break;}
		case BOLD:{
			setSpan(new StyleSpan(Typeface.BOLD));
			break;}
		case ITALIC:{
			setSpan(new StyleSpan(Typeface.ITALIC));
			break;}
		case BOLD_ITALIC:{
			setSpan(new StyleSpan(Typeface.BOLD_ITALIC));
			break;}
		case UNDERLINE:{
			setSpan(new UnderlineSpan());
			break;}
		}
	}
	public static void setTextHighlight(int color){
		_highlightColor = color;
		setSpan(new BackgroundColorSpan(_highlightColor));
	}
	public static void addBullet(BulletStyle.Mode style){
		setSpan(new BulletSpan());
	}
	public static void removeBullet(){
		if(containsSpan(BulletSpan.class)){
			BulletSpan [] bsp = (BulletSpan[]) getSpans(BulletSpan.class);
			removeSpans(bsp);
		}
	}
	public static void addTab(){
		setSpan(new TabStopSpan.Standard(_start));
	}
	public static void addTab(int count){
		for(int x = 0; x<count; x++)
			setSpan(new TabStopSpan.Standard(_start));        
	}
	/***************************************************************************************/
	static int _pageMarginLeft = Default.PAGE_MARGIN_LEFT;
	static int _pageMarginTop = Default.PAGE_MARGIN_TOP;
	static int _pageMarginRight = Default.PAGE_MARGIN_RIGHT;
	static int _pageMarginBottom = Default.PAGE_MARGIN_BOTTOM;
	/***************************************************************************************/	
	public static void setPageMargins(int left, int top, int right, int bottom){
		_pageMarginLeft = left; 
		_pageMarginTop = top;
		_pageMarginRight = right; 
		_pageMarginBottom = bottom;
		wEditor.setPadding(_pageMarginLeft,_pageMarginTop,_pageMarginRight, _pageMarginBottom);
		wEditor.invalidate();
	}
	/*	public static void setParagraphMargins(int left, int top, int right, int bottom){
		_pageMarginLeft = left; 
		_pageMarginTop = top;
		_pageMarginRight = right; 
		_pageMarginBottom = bottom;
		wEditor.setPadding(_pageMarginLeft,_pageMarginTop,_pageMarginRight, _pageMarginBottom);
	}*/
	//=========================================================================================================//<! STILL WORKING START >
	public static void setAlignment(Alignment a){}
	public static void setNumbering(int firstNum){} 
	/***************************************************************************************/
	static SpacingStyle.Mode _spacingStyle = Default.SPACING_STYLE;
	static int _spacingOffset = Default.SPACING_OFFSET;
	static int _spacingLeftOffset = Default.SPACING_LEFT_OFFSET;
	static int _spacingRightOffset = Default.SPACING_RIGHT_OFFSET;
	/***************************************************************************************/	
	public static void setSpacingLeft(int offset){}
	public static void setSpacingRight(int offset){}
	public static void setSpacing(int offset, SpacingStyle style){}
	/***************************************************************************************/
	static IndentationStyle.Mode _indentationStyle = IndentationStyle.Mode.NONE;
	static int _indentationOffset = Default.SPACING_OFFSET;
	static int _indentationAfterOffset = Default.INDENTATION_AFTER_OFFSET;
	static int _indentationBeforeOffset = Default.INDENTATION_BEFORE_OFFSET;
	/***************************************************************************************/
	public static void setIndentation(int offset, IndentationStyle style){}
	public static void setIndentationBefore(int offset){}
	public static void setIndentationAfter(int offset){}
	//=========================================================================================================//<! STILL WORKING END >
	public static int getTextSize(){
		return _textSize;
	}
	public static int getTextColor(){
		return _textColor;
	}
	public static int getTextHighlightColor(){
		return _highlightColor;
	}
	public static TextStyle.Mode getTextStyle(){
		return _textStyle;
	}
	public static TextEffect.Mode getTextEffect(){
		return _textEffect;
	}
	public static SpacingStyle.Mode getSpacingStyle(){
		return _spacingStyle;
	}
	public static int getSpacingOffset(){
		return _spacingOffset;
	}
	public static int getSpacingLeft(){
		return _spacingLeftOffset;
	}
	public static int getSpacingRight(){
		return _spacingRightOffset;
	}
	public static IndentationStyle.Mode getIndentationStyle(){
		return _indentationStyle;
	}
	public static int getIndentationOffset(){
		return _indentationOffset;
	}
	public static int getIndentationBefore(){
		return _indentationBeforeOffset;
	}
	public static int getIndentationAfter(){
		return _indentationAfterOffset;
	}
}
class Alignment {
	public enum Mode {
		LEFT,
		CENTERED,
		RIGHT,
		JUSTIFIED
	}
}
final class BulletStyle {
	public enum Mode {
		NONE,
		GENERIC,
		CIRCLE,
		SQUARE,
		DIAMOND,
		ARROW,
		CHECK,
		CUSTOM
	}
}
final class IndentationStyle {
	public enum Mode{
		NONE,
		FIRST_LINE,
		HANGING
	}
}
final class TextEffect {
	public enum Mode {
		NONE,
		SINGLE_STRIKETHROUGH,
		DOUBLE_STRIKETHROUGH,
		SUPERSCRIPT,
		SUBSCRIPT,
		SMALL_CAPS,
		ALL_CAPS,
		HIDDEN
	}
}	
final class TextStyle {
	public enum Mode {		
		NONE,
		ITALIC,
		BOLD,
		BOLD_ITALIC,
		UNDERLINE
	}
}
final class TextFace{
	public class Family {
		public static final String DEFAULT = "droid"; 
		public static final String MONOSPACE = "monospace"; 
		public static final String SERIF = "serif"; 
		public static final String SANS_SERIF = "sans-serif";
	}
}
final class SpacingStyle {
	public enum Mode {
		SINGLE,
		ONE_AND_HALF,
		DOUBLE,
		BOLD_ITALIC,
		ATLEAST,
		EXACTLY,
		MULTIPLE
	}
}
final class Sort {
	public enum Mode {
		NONE,
		A_Z,
		Z_A
	}
}	