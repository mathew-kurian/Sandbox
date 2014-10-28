import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.LinkedList;

public class Tokenize {
	public static void main(String[] args) throws FileNotFoundException {

		File file = new File("out.txt");
		FileOutputStream fos = new FileOutputStream(file);
		PrintStream ps = new PrintStream(fos);

		System.setOut(ps);

		String text = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

		int start = 0;
		int end = text.length();
		LinkedList<Integer> tokens = tokenize(text, 0, 50);

		for (int stop : tokens) {

			System.out.println("word:" + text.subSequence(start, stop).toString() + "|start:" + start + "|stop:" + stop + "|length:" + text.length());

			start = stop + 1;
		}
	}

	private static LinkedList<Integer> tokenize(CharSequence source, int start, int end) {

		LinkedList<Integer> units = new LinkedList<Integer>();

		if (start >= end) {
			return units;
		}

		boolean charSearch = source.charAt(start) == ' ';

		for (int i = start; i < end; i++) {
			// If the end add the word group
			if (i + 1 == end) {
				units.add(i + 1);
				start = i + 1;
			}
			// Search for the start of non-space
			else if (charSearch && source.charAt(i) != ' ') {
				if ((i - start) > 0) {
					units.add(i);
				}
				start = i;
				charSearch = false;
			}
			// Search for the end of non-space
			else if (!charSearch && source.charAt(i) == ' ') {
				units.add(i);
				start = i + 1; // Skip the space
				charSearch = true;
			}
		}

		return units;
	}
}
