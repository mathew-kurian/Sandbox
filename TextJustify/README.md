![Logo](https://raw.github.com/bluejamesbond/TextJustify-Android/master/__misc/textjustify%20design%20logo%20%5Ba%5D.png)
=======
**Simple Android Full Justification**

#About
This library will provide you a way to justify text. It supports both plain text and Spannables. Additionally, the library can auto-hyphentate your displayed content.

#Donate
If for some reason you like the library and feel like thanking me. Here you go! Thank you in advance.

[![Donate](http://i.imgur.com/6tHWFwv.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=YTSYSHBANY9YG&lc=US&item_name=TextJustifyAndroid&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted)

#Known Issues

| Status| Issues    |
| :------------:    |:---------------|
|  **`OPEN`**       | Scroll caching for very large documents i.e. > 4000 paragaphs |
|  **`OPEN`**       | Support RTL languages; reverse text  |
|  **`OPEN`**       | Support more features like `TextView` in terms of `Paint` settings  |

#Preview
Screenshot from the example in `com.text.examples.SimpleExample`.  

![Preview](http://i.imgur.com/8PanCPg.png)

##Note
The article on the right is composed of only a single Spannable. Only one (1) `DocumentView` is being used.

![Preview](http://i.imgur.com/4gjANq6.png)

#Examples

##Basic Usage - Plain Text
Creating a `DocumentView` and enabling justification.
```java
// Create DocumentView and set plain text
// Important: Use DocumentLayout.class
DocumentView documentView = new DocumentView(this, DocumentLayout.class);  // Support plain text
documentView.getDocumentLayoutParams().setTextAlignment(TextAlignment.JUSTIFIED);
documentView.setText("Insert your text here", true); // Set to `true` to enable justification
```

##Basic Usage - Spanned
Creating a `DocumentView` and setting some features such as padding and typeface
```java
/*
 * To mark a region for justification in Spanned strings, you must setSpan(new JustifySpan(), start, end)
 * that particular region.
 */

// Create span
Spannable span = new SpannableString("In New York and New Jersey, governors Andrew Cuomo and Chris Christie have implemented controversial quarantines.");

// Set region to justify
span.setSpan(new JustifySpan(), 0, span.length(), Spannable.SPAN_INCLUSIVE_EXCLUSIVE);

// Create DocumentView and set span.
// Important: Use SpannedDocumentLayout.class
DocumentView documentView = new DocumentView(this, SpannedDocumentLayout.class);  // Support spanned text

// Set the fallback alignment if an alignment is not specified for a line
documentView.getDocumentLayoutParams().setTextAlignment(TextAlignment.JUSTIFIED); 

documentView.setText(span, true); // Set to `true` to enable justification
```
##Advanced Usage - Spanned
```java
/*
 * Class that builds spanned documents and enables multiple Spans to be set at once
 * to the last inserted text
 */

class ArticleBuilder extends SpannableStringBuilder {
    public ArticleBuilder append(CharSequence text, boolean newline, Object ... spans){
        int start = this.length();
        this.append(Html.fromHtml("<p>" + text + "</p>" + (newline ? "<br>" : "")));
        for(Object span : spans) {
            this.setSpan(span, start, this.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
        }
        return this;
    }
}

ArticleBuilder a = new ArticleBuilder();
a.append("WHO: Ebola Cases",
          false, new RelativeSizeSpan(2f), new StyleSpan(Typeface.BOLD))
 .append("<font color=0xFFC801>Sam Frizell</font><font color=0x888888> @Sam_Frizell  Oct. 25, 2014</font>",
          false, new RelativeSizeSpan(0.8f), new StyleSpan(Typeface.BOLD))
 .append("In New York and New Jersey, governors Andrew Cuomo and Chris Christie have implemented controversial quarantines on all healthcare workers returning from West Africa after a doctor returning from Guinea contracted the disease and was diagnosed in New York.",
          true, new RelativeSizeSpan(1f), new JustifySpan());

DocumentView documentView = new DocumentView(this, SpannedDocumentLayout.class);  // Support spanned text
documentView.setText(a, true); // Set to `true` to enable justification
```

##More
Refer to `com.text.examples.SimpleExample` for an Android application that demonstrates some of the features.

#API

##DocumentView
extends **View**
###Class Overview
Displays static text to user. Similar to `TextView` but provides additional features to support text-justification and auto-hyphenation.

####Constructors

| | Description |
| :------------:|:---------------|
|  | `DocumentView(Context context)` |
|  | `DocumentView(Context context, AttributeSet attrs)` |
|  | `DocumentView(Context context, AttributeSet attrs, int defStyle)` |
|  | `DocumentView(Context context, Class<? extends DocumentLayout> layoutClass)`<br>Constructs a DocumentView with the speficied DocumentLayout |

####Public Methods

| Return                                | Description |
| ------------:                         |:---------------|
| `void`                                | `setTextSize(float textSize)`<br>Set the internal `Paint` text size. |
| `void`                                | `setColor(int textColor)`<br>Set the internal `Paint` foreground color. |
| `void`                                | `setTypeface(Typeface typeface)`<br>Sets the typeface and style in which the text should be displayed. |
| `void`                                | `setText(CharSequence source)`<br>Set the content that needs to be displayed. |
| `CharSequence`                        | `getText()`<br>Return the text the this is displaying. |
| `DocumentLayout.LayoutParams`         | `getDocumentLayoutParams()`<br>Get the `LayoutParams` associated with this view. |
| `DocumentLayout`                      | `getLayout()`<br>Get the `DocumentLayout` associated with this view. |

##DocumentLayout
###Class Overview
Calculates the position of each line/word/paragraph. Call `measure` to calculate the positions. Call `draw` to render the text.

####Constructors

| | Description |
| :------------:|:---------------|
|  | `DocumentLayout(Paint paint)`<br>Constructs a DocumentLayout with the specified the Paint which will be used to draw |

####Public Methods

| Return                                | Description |
| ------------:                         |:---------------|
| `void`                                | `setText(CharSequence source)`<br>Set the content that needs to be displayed. |
| `void`                                | `getLayoutParams()`<br>Get the `LayoutParams` that would be used to configure the layout settings. |
| `CharSequence`                        | `getText()`<br>Return the text the this is displaying. |
| `int`                                 | `getMeasuredHeight()`<br>Get the height calculated by the layout with the specified text and `Paint`. |
| `void`                                | `measure()`<br>Construct the static text positions. |
| `void`                                | `draw(Canvas canvas)`<br>Draw the content measured by the layout onto the specified `Canvas`. |

##DocumentLayout
###Class Overview
Calculates the position of each line/word/paragraph. Call `measure` to calculate the positions. Call `draw` to render the text.

####Constructors

| | Description |
| :------------:|:---------------|
|  | `DocumentLayout(Paint paint)`<br>Constructs a DocumentLayout with the specified the Paint which will be used to draw |

####Public Methods

| Return                                | Description |
| ------------:                         |:---------------|
| `void`                                | `setText(CharSequence source)`<br>Set the content that needs to be displayed. |
| `void`                                | `getLayoutParams()`<br>Get the `LayoutParams` that would be used to configure the layout settings. |
| `CharSequence`                        | `getText()`<br>Return the text the this is displaying. |
| `int`                                 | `getMeasuredHeight()`<br>Get the height calculated by the layout with the specified text and `Paint`. |
| `void`                                | `measure()`<br>Construct the static text positions. |
| `void`                                | `draw(Canvas canvas)`<br>Draw the content measured by the layout onto the specified `Canvas`. |

##Document.TextAlignment
###Class Overview
Specify the alignment for text inside the `DocumentLayout` by using these constants.

####Constructors

| | Description |
| :------------:|:---------------|
|  | `LEFT`<br>Align the text to the left of the view |
|  | `CENTER`<br>Align the text at the center of the view |
|  | `RIGHT`<br>Align the text to the right of the view |
|  | `JUSTIFIED`<br>Wraps the text the view |

##DocumentLayout.LayoutParams
###Enum Overview
Calculates the position of each line/word/paragraph. Call `measure` to calculate the positions. Call `draw` to render the text.

####Constructors

| | Description |
| :------------:|:---------------|
|  | `DocumentLayout(Paint paint)`<br>Constructs a DocumentLayout with the specified the Paint which will be used to draw |

####Public Methods

| Return                                | Description |
| ------------:                         |:---------------|
| `void`                                | `setTextAlignment(TextAlignment textAlignment)`<br>Set the content that needs to be displayed. |
| `void`                                | `setHyphenator(Hyphenator hyphenator)`<br>Set the content that needs to be displayed. |
| `void`                                | `setLeft(float left)`<br>Set the content that needs to be displayed. |
| `void`                                | `setTop(float left)`<br>Set the content that needs to be displayed. |
| `void`                                | `setBottom(float left)`<br>Set the content that needs to be displayed. |
| `void`                                | `setRight(float left)`<br>Set the content that needs to be displayed. |
| `void`                                | `setParentWidth(float parentWidth)`<br>Set the content that needs to be displayed. |
| `void`                                | `setOffsetX(float offsetX)`<br>Set the content that needs to be displayed. |
| `void`                                | `setOffsetY(float offsetY)`<br>Set the content that needs to be displayed. |
| `void`                                | `setLineHeightMultiplier(float lineHeightMultiplier)`<br>Set the content that needs to be displayed. |
| `void`                                | `setHyphenated(boolean hyphenate)`<br>Set the content that needs to be displayed. |
| `void`                                | `setMaxLines(int maxLines)`<br>Set the content that needs to be displayed. |
| `void`                                | `setHyphen(String hyphen)`<br>Set the content that needs to be displayed. |
| `void`                                | `setReverse(boolean reverse)`<br>Set the content that needs to be displayed. |
| `void`                                | `getTextAlignment(TextAlignment textAlignment)`<br>Set the content that needs to be displayed. |
| `void`                                | `getHyphenator(Hyphenator hyphenator)`<br>Set the content that needs to be displayed. |
| `void`                                | `getLeft(float left)`<br>Set the content that needs to be displayed. |
| `void`                                | `getTop(float left)`<br>Set the content that needs to be displayed. |
| `void`                                | `getBottom(float left)`<br>Set the content that needs to be displayed. |
| `void`                                | `getRight(float left)`<br>Set the content that needs to be displayed. |
| `void`                                | `getParentWidth(float parentWidth)`<br>Set the content that needs to be displayed. |
| `void`                                | `getOffsetX(float offsetX)`<br>Set the content that needs to be displayed. |
| `void`                                | `getOffsetY(float offsetY)`<br>Set the content that needs to be displayed. |
| `void`                                | `getLineHeightMultiplier(float lineHeightMultiplier)`<br>Set the content that needs to be displayed. |
| `void`                                | `isHyphenated(boolean hyphenate)`<br>Set the content that needs to be displayed. |
| `void`                                | `getMaxLines(int maxLines)`<br>Set the content that needs to be displayed. |
| `void`                                | `getHyphen(String hyphen)`<br>Set the content that needs to be displayed. |
| `void`                                | `isReverse(boolean reverse)`<br>Set the content that needs to be displayed. |
