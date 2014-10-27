THE NEW TEXT JUSTIFY FOR ANDROID - SUPPORT FOR SPANNABLES!
===
NOTE: THIS IS A WORK IN PROGRESS. PORTIONS OF THIS README ARE INCOMPLETE

JUST COMPILE THE EXAMPLE TO SEE HOW IT LOOKS
----

![Logo](https://raw.github.com/bluejamesbond/TextJustify-Android/master/__misc/textjustify%20design%20logo%20%5Ba%5D.png)
=======
**Simple Android Full Justification**

#About
This library will provide you a way to justify text. It supports both plain text and Spannables. Additionally, the library can auto-hyphentate your displayed content.

#Examples

##Basic Usage - Plain Text
Creating a `DocumentView` and enabling justification.
```java
// Create DocumentView and set plain text
// Important: Use DocumentLayout.class
DocumentView documentView = new DocumentView(this, DocumentLayout.class);  // Support plain text
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

####Issues

| Status| Issues    |
| :------------:    |:---------------|
|  **`OPEN`**       | Scroll caching for very large documents i.e. > 4000 paragaphs |
|  **`OPEN`**       | Support RTL languages; reverse text  |
|  **`OPEN`**       | Support more features like `TextView` in terms of `Paint` settings  |

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
| `void`                                | `setTextSize(float textSize)`<br>Set the paint's text size. |
| `void`                                | `setColor(int textColor)`<br>Set the paint's foreground color. |
| `void`                                | `setTypeface(Typeface typeface)`<br>Sets the typeface and style in which the text should be displayed. |
| `CharSequence`                        | `getText()`<br>Return the text the this is displaying. |
| `DocumentLayout.LayoutParams`         | `getDocumentLayoutParams()`<br>Get the LayoutParams associated with this view. |
| `DocumentLayout`                      | `getLayout()`<br>Get the DocumentLayout associated with this view. |

##DocumentLayout
###Class Overview
Displays static text to user. Similar to `TextView` but provides additional features to support text-justification and auto-hyphenation.

####Issues

| Status| Issues    |
| :------------:    |:---------------|
|  **`OPEN`**       | Scroll caching for very large documents i.e. > 4000 paragaphs |
|  **`OPEN`**       | Support RTL languages; reverse text  |

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
| `void`                                | `setTextSize(float textSize)`<br>Set the paint's text size. |
| `void`                                | `setColor(int textColor)`<br>TextWatcher to the list of those whose methods are called whenever this TextView's text changes. |
| `void`                                | `setTypeface(Typeface typeface)`<br>Sets the typeface and style in which the text should be displayed. |
| `CharSequence`                        | `getText()`<br>TextWatcher to the list of those whose methods are called whenever this TextView's text changes. |
| `DocumentLayout.LayoutParams`         | `getDocumentLayoutParams()`<br>Get the LayoutParams associated with this view. |
| `DocumentLayout`                      | `getLayout()`<br>Get the DocumentLayout associated with this view. |
