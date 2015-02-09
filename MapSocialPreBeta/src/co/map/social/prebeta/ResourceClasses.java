package co.map.social.prebeta;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorFilter;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.text.Html;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.view.View.OnClickListener;

class MyriadProText extends TextView implements OnClickListener{

	private float [] fontSizes = { 12, 15, 18 };
	private int sizeCount = 0;
	private boolean varyingSizes = true;

	public MyriadProText(Context context) {
		super(context);
		//	Ave.applyMyriadProFont(context, this);
		setTextColor(getResources().getColor(R.color.normalText_textColor));
		setOnClickListener(this);
	}
	public MyriadProText(Context context, AttributeSet attrs,
			int defStyle) {
		super(context, attrs, defStyle);
		customAttributes(attrs);
		//	Ave.applyMyriadProFont(context, this);
		setTextColor(getResources().getColor(R.color.normalText_textColor));
		setOnClickListener(this);
	}
	public MyriadProText(Context context, AttributeSet attrs) {
		super(context, attrs);
		customAttributes(attrs);
		//	Ave.applyMyriadProFont(context, this);
		setTextColor(getResources().getColor(R.color.normalText_textColor));
		setOnClickListener(this);
	}
	public void customAttributes(AttributeSet attrs){
		TypedArray a = getContext().obtainStyledAttributes(attrs,
				R.styleable.MyriadProText);

		final int N = a.getIndexCount();
		for (int i = 0; i < N; ++i)
		{
			int attr = a.getIndex(i);
			switch (attr)
			{
			case R.styleable.MyriadProText_varySizes:
				varyingSizes = a.getBoolean(attr, false);
				break;
			case R.styleable.MyriadProText_normalTextSize:
				fontSizes[0] = a.getDimension(attr, 12);
				setTextSize(TypedValue.COMPLEX_UNIT_PX, fontSizes[0]);							//default textsize
				break;
			case R.styleable.MyriadProText_largeTextSize:
				fontSizes[1] = a.getDimension(attr, 12);
				break;
			case R.styleable.MyriadProText_largestTextSize:
				fontSizes[2] = a.getDimension(attr, 12);
				break;			
			}
		}
		a.recycle();

	}
	public void onClick(View arg0) {
		if(varyingSizes){
			sizeCount++;
			setTextSize(TypedValue.COMPLEX_UNIT_PX, fontSizes[sizeCount%3]);
		}
	}
	public void setVaryingSizes(boolean bool){
		varyingSizes = bool;
	}
}
class BlockQuote extends LinearLayout{

	private String sampleQuote = "Easy support for blockquoting: Premade resources for blockquotes. This is a space filler.";
	private String sampleAuthor = "Last name, First name";

	private MyriadProText quote;
	private MyriadProText author;
	private ImageView quoteImg;

	public BlockQuote(Context context) {
		super(context);
		setUp(null);
	}
	public BlockQuote(Context context, AttributeSet attrs) {
		super(context, attrs);
		setUp(attrs);
	}
	public void setUp(AttributeSet attrs){
		setOrientation(LinearLayout.HORIZONTAL);

		LayoutParams lp = new LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);

		lp = new LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.CENTER_VERTICAL;
		LinearLayout ll = new LinearLayout(this.getContext());
		ll.setOrientation(LinearLayout.VERTICAL);
		ll.setPadding(10, 0, 0, 0);
		ll.setLayoutParams(lp);

		lp = new LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.TOP;
		quote = new MyriadProText(this.getContext());
		quote.customAttributes(attrs);
		quote.setLayoutParams(lp);

		quote.setTextColor(getResources().getColor(R.color.blockQuote_textColor));
		quote.setTextSize(TypedValue.COMPLEX_UNIT_PX, getContext().getResources().getDimension(R.dimen.blockQuote_textSize));

		lp = new LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.RIGHT;
		author = new MyriadProText(this.getContext());
		author.customAttributes(attrs);
		author.setPadding(0, 5, 0, 0);
		author.setLayoutParams(lp);

		author.setTextColor(getResources().getColor(R.color.blockQuote_authorTextColor));
		author.setTextSize(TypedValue.COMPLEX_UNIT_PX, getResources().getDimension(R.dimen.blockQuote_authorTextSize));

		lp = new LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
		lp.gravity = Gravity.TOP;
		quoteImg = new ImageView(this.getContext());
		quoteImg.setImageResource(R.drawable.blockquote);
		quoteImg.setLayoutParams(lp);

		ll.addView(quote);
		ll.addView(author);

		addView(quoteImg);
		addView(ll);

		setText(sampleQuote);
		setAuthor(sampleAuthor);
	}
	public void setText(String s){
		quote.setText(Html.fromHtml(sampleQuote));
	}
	public void setAuthor(String s){
		author.setText(Html.fromHtml("-<i>"+s+"</i>"));
	}
}
class ImageFactory{
	public static Bitmap createGroupBanner(Context c, int resId){
		Canvas canvas;
		Paint paint;

		int shadowOffsetY = 2;
		int bannerHeight = Ave.getScreenHeight()/2;
		int bannerWidth = Ave.getScreenWidth();
		int arrowHeight;	

		Bitmap foldMask =  BitmapFactory.decodeResource(c.getResources(), R.drawable.imagefactory_banner_fold_mask);
		Bitmap foldAndShadow =  BitmapFactory.decodeResource(c.getResources(), R.drawable.imagefactory_banner_fold_and_shadow);
		Bitmap foldShadowMask =  BitmapFactory.decodeResource(c.getResources(), R.drawable.imagefactory_banner_fold_shadow_mask);
		Bitmap arrowMask =  BitmapFactory.decodeResource(c.getResources(), R.drawable.imagefactory_banner_arrow_mask);

		//set the height of the arrow : should be constant
		arrowHeight = arrowMask.getHeight();

		//create arrow mask
		Bitmap mask = Bitmap.createBitmap(bannerWidth, arrowHeight, Bitmap.Config.ARGB_8888);
		canvas = new Canvas(mask);
		canvas.drawColor(Color.RED);
		paint = new Paint(Paint.ANTI_ALIAS_FLAG);
		paint.setXfermode(new PorterDuffXfermode(Mode.DST_OUT));
		canvas.drawBitmap(arrowMask, 25, 0, paint);

		Drawable shadowDrawable =  c.getResources().getDrawable(R.drawable.bg_paper_shadow);
		Bitmap shadow = Bitmap.createBitmap(bannerWidth, shadowDrawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
		canvas = new Canvas(shadow);
		shadowDrawable.setBounds(0, 0, bannerWidth, shadowDrawable.getIntrinsicHeight());
		shadowDrawable.draw(canvas);


		/*
		 * ADD ALGORITHM FOR RESIZING THE ORIGNAL IMAGE TO SHOW IMPORTANT DATA
		 * ORIGINAL RESOLUTION: 1920 x 1080 (HD)
		 * 
		 * ******FIXED********
		 */

		Bitmap originalLarge = BitmapFactory.decodeResource(c.getResources(), resId);

		float resizeRatio = ((float) originalLarge.getHeight())/((float) bannerHeight);

		if((((float) originalLarge.getWidth())/((float) resizeRatio))<bannerWidth)
			resizeRatio = ((float) originalLarge.getWidth())/((float) bannerWidth);

		float originalResizedWidth = (((float) originalLarge.getWidth())/((float) resizeRatio));
		float originalResizedHeight = (((float) originalLarge.getHeight())/((float) resizeRatio));

		//drawing in banner from original image
		Bitmap orignalResized = Bitmap.createScaledBitmap(originalLarge, (int) originalResizedWidth, (int) originalResizedHeight, true);
		ColorMatrix saturationMatrix = new ColorMatrix();
		saturationMatrix.setSaturation(5);
		ColorFilter saturationFilter = new ColorMatrixColorFilter(saturationMatrix);
		Bitmap banner = Bitmap.createBitmap(bannerWidth, bannerHeight, Bitmap.Config.ARGB_8888);
		canvas = new Canvas(banner);
		paint.setXfermode(null);
		paint.setColorFilter(saturationFilter);
		canvas.drawBitmap(orignalResized, -(originalResizedWidth-bannerWidth)/2,-(originalResizedHeight-bannerHeight)/2, paint);
		paint.setColorFilter(null);

		paint.setXfermode(new PorterDuffXfermode(Mode.DST_OUT));		
		//create arrow shape by deleting part of picture
		canvas.drawBitmap(mask, 0, bannerHeight-arrowHeight, paint);
		//prevent shadow from being drawn onto arrow
		paint.setXfermode(new PorterDuffXfermode(Mode.DST_OVER));
		//draw base shadow
		canvas.drawBitmap(shadow, 0, bannerHeight-arrowHeight-shadowOffsetY, paint);
		paint.setXfermode(new PorterDuffXfermode(Mode.DST_OUT));
		//create room for paper fold
		canvas.drawBitmap(foldMask, bannerWidth-foldMask.getWidth(), bannerHeight-arrowHeight-foldMask.getHeight(), paint);		
		//remove extra shadow
		canvas.drawBitmap(foldShadowMask, bannerWidth-foldShadowMask.getWidth(), bannerHeight-arrowHeight-shadowOffsetY, paint);
		//draw fold and built in shadow
		canvas.drawBitmap(foldAndShadow, bannerWidth-foldMask.getWidth(), bannerHeight-arrowHeight-foldMask.getHeight(), null);

		return banner;
	}
}