import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.LinkedList;
import java.util.Arrays;
import java.util.List;

import javax.swing.*;

public class TextJustify {

	// To do 
	//  + Add ellipses
	//  + Fix line-height
	//  + Add max lines
	
	public static final String HYPHEN_SYMBOL = "-";

	@SuppressWarnings("serial")
	public void run() {

		JFrame jmf = new JFrame();
		JPanel jp = new JPanel() {

			public void paintComponent(Graphics g) {

				float insetLeft = 20, insetTop = 20, insetRight = 20, insetBottom = 20;

				// Remove the padding
				float width = getWidth() - insetRight - insetLeft;
				// Remove the padding
				float height = getHeight() - insetTop - insetBottom;

				Graphics2D g2d = (Graphics2D) g;

				g2d.setColor(Color.BLACK);
				g2d.fillRect(0, 0, getWidth(), getHeight());
				g2d.setFont(new Font("Helvetica", Font.PLAIN, 12));
				g2d.setColor(Color.RED);
				g2d.drawRect((int) insetLeft, (int) insetTop, (int) width, (int) height);
				g2d.setColor(Color.WHITE);
				g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_LCD_HRGB);

				FontMetrics fm = g2d.getFontMetrics();

				String text = "Error reading file.";

				File file = new File("article.txt");
				try {
					FileInputStream fis = new FileInputStream(file);
					byte[] data = new byte[(int) file.length()];
					fis.read(data);
					fis.close();
					text = new String(data, "UTF-8");
				} catch (IOException e) {
					e.printStackTrace();
				}

				// Replace all tabs to 4 spaces!
				text = text.replaceAll("\t", "    ");

				float lineHeight = getFont().getSize();
				float x = insetLeft, y = insetTop + lineHeight, spaceOffset = fm.stringWidth(" ");

				List<String> paragraphs = new LinkedList<String>(Arrays.asList(text.toString()
						.split("((?<=\n)|(?=\n))")));

				while (paragraphs.size() > 0) {

					String paragraph = paragraphs.get(0);

					// Start at x = 0 for drawing text
					x = insetLeft;

					// If the line contains only spaces or line breaks
					if (paragraph.trim().length() == 0) {
						y += lineHeight * (paragraph.length() - paragraph.replaceAll("\n", "").length());
						paragraphs.remove(0);
						continue;
					}

					// Remove all spaces from the end of the line
					String noLineBreaks = paragraph.replaceAll("\n", "");
					// Remove all trailingSpaces
					String noTrailingSpaces = noLineBreaks.replaceAll("\\s+$", "");
					// Remove newlines when drawing
					String noTrailingWhiteSpace = noTrailingSpaces.replaceAll("\n", "");

					float wrappedWidth = fm.stringWidth(noTrailingWhiteSpace);

					// Line fits, then don't wrap
					if (wrappedWidth < width) {
						g2d.drawString(paragraph, x, y);
						y += lineHeight * (paragraph.length() - noLineBreaks.length());
						paragraphs.remove(0);
						continue;
					}

					// Allow leading spaces
					int start = 0;
					boolean leadSpaces = true;
					String[] tokens = tokenize(paragraph);

					while (true) {

						x = insetLeft;

						// Line doesn't fit, then apply wrapping
						JustifiedLine format = justify(tokens, start, fm, spaceOffset, width, false, "*", leadSpaces);
						int tokenCount = format.end - format.start;
						boolean fitAll = format.end == tokens.length;
						boolean error = format.start == format.end;

						if (error) {
							new TextJustifyException("Cannot fit word(s) into one line. Font size too large?")
									.printStackTrace();
							return;
						}

						// Draw each word here
						float offset = tokenCount > 2 && !fitAll ? format.remainWidth / (tokenCount - 1) : 0;

						for (int i = format.start; i < format.end; i++) {
							String token = tokens[i];
							float groupWidth = fm.stringWidth(token);
							g2d.drawString(token, x, y);
							x += offset + groupWidth + spaceOffset;
						}

						// If all fit, then continue to next
						// paragraph
						if (fitAll) {
							break;
						}

						// Don't allow leading spaces
						leadSpaces = false;
						
						// Increment to next line
						y += lineHeight;
						
						// Next start index for tokens
						start = format.end;
						
						if(y > height){
							return;
						}
					}

					paragraphs.remove(0);
				}
			}
		};

		jmf.getContentPane().setLayout(new BorderLayout());
		jmf.getContentPane().add(jp, BorderLayout.CENTER);
		jmf.setSize(500, 500);
		jmf.setLocationRelativeTo(null);
		jmf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		jmf.setVisible(true);
	}

	public void printList(String[] arr) {
		for (int i = 0; i < arr.length; i++) {
			System.out.print(arr[i] + (i + 1 == arr.length ? "" : "·"));
		}

		System.out.println();
	}

	@SuppressWarnings("serial")
	class TextJustifyException extends Exception {
		public TextJustifyException(String message) {
			super(message);
		}
	}

	/**
	 * Class and function to process wrapping Implements a greedy algorithm to
	 * fit as many words as possible into one line
	 */

	private class JustifiedLine {

		public final int start;
		public final int end;
		public final float remainWidth;

		public JustifiedLine(int start, int end, float remainWidth) {
			this.start = start;
			this.end = end;
			this.remainWidth = remainWidth;
		}
	}

	/**
	 * Break into word/space groups
	 */

	private String[] tokenize(String s) {

		// If empty string, just return one group
		if (s.trim().length() <= 1) {
			return new String[] { s };
		}

		List<String> groups = new LinkedList<String>();
		int start = 0;
		boolean charSearch = s.charAt(0) == ' ';

		for (int i = 1; i < s.length(); i++) {
			// If the end add the word group
			if (i + 1 == s.length()) {
				groups.add(s.substring(start, i + 1));
				start = i + 1;
			}
			// Search for the start of non-space
			else if (charSearch && s.charAt(i) != ' ') {
				String subtring = s.substring(start, i);
				if (subtring.length() != 0) {
					groups.add(s.substring(start, i));
				}
				start = i;
				charSearch = false;
			}
			// Search for the end of non-space
			else if (!charSearch && s.charAt(i) == ' ') {
				groups.add(s.substring(start, i));
				start = i + 1; // Skip the space
				charSearch = true;
			}
		}

		return groups.toArray(new String[] {});
	}

	/**
	 * By contract, parameter "block" must not have any line breaks
	 */

	private JustifiedLine justify(String[] tokens, int start, FontMetrics metrics, float spaceOffset,
			float availableWidth, boolean hyphenate, String syllableSeparator, boolean leadSpaces) {

		// Block is empty, then return empty
		if (tokens.length == 0) {
			return new JustifiedLine(0, 0, availableWidth);
		}

		// Greedy search to see if the word
		// can actually fit on a line
		for (int i = start; i < tokens.length; i++) {

			// Get word
			String token = tokens[i];
			String word = hyphenate ? token.replaceAll(syllableSeparator, "") : token;
			float wordWidth = metrics.stringWidth(word);
			float remainingWidth = availableWidth - wordWidth;

			// Word does not fit in line
			if (remainingWidth < 0) {

				// // Handle hyphening in the event
				// // the current word does not fit
				// if (hyphenate) {
				//
				// String[] syllables = token.split(syllableSeparator);
				// String lastPartial = null;
				//
				// for (String syllable : syllables) {
				//
				// // Create the hyphenated word
				// // aka. partial
				// String partial = syllable + HYPHEN_SYMBOL;
				// float partialWidth = metrics.stringWidth(partial);
				//
				// // See if the partial fits
				// if (availableWidth - partialWidth > 0) {
				// lastPartial = partial;
				// }
				// // If the partial doesn't fit
				// else {
				//
				// // Check if the lastPartial
				// // was even set
				// if (lastPartial != null) {
				// availableWidth -= partialWidth;
				// i += partial.length();
				// smb.append(partial);
				//
				// return new JustifiedLine(smb.toString(), availableWidth,
				// false, dirtyWord.replace(
				// syllable, "") + block.substring(i));
				// }
				// }
				// }
				// }

				return new JustifiedLine(start, i, availableWidth + spaceOffset);

			}
			// Word fits in the line
			else {

				availableWidth -= wordWidth + spaceOffset;

				// NO remaining space
				if (remainingWidth <= 0) {
					new JustifiedLine(start, i + 1, availableWidth + spaceOffset);
				}
			}
		}

		return new JustifiedLine(start, tokens.length, availableWidth);
	}
}