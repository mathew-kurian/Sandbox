import java.util.List;

import common.Console;
import common.ObjectFreq;
import common.ObjectFreq.FreqInfo;

/**
 * {@link Main} class is the entry point for command-line input count the number of
 * words in a String
 * 
 * @author Mathew Kurian
 * @version 1.0
 */

public class Main {

	private static final Console console;

	static {
		console = Console.getInstance(Main.class);
	}

	/**
	 * Method that takes in the following arguments and prints out the output to
	 * the console
	 * 
	 * @param args
	 *            0: <string>: the input text
	 *            1:<integer>: the k most frequent words to display
	 */
	public static void main(String[] args) {
		if (args.length < 2) {
			console.err("Provide 2 arguments");
			console.err("\t(1) <string>: the input text");
			console.err("\t(2) <integer>: the k most frequent words to display");
			System.exit(-1);
			return;
		}

		int k = Integer.MAX_VALUE;

		try {
			k = Integer.parseInt(args[1]);
		} catch (NumberFormatException nfe) {
			console.err("Argument 2 is not a valid <integer>");
		}

		FreqInfo<String> freqInfo = ObjectFreq.getFrequency(args[0]);
		List<String> words = freqInfo.getFrequent(k);
		StringBuilder smb = new StringBuilder();

		for (String word : words) {
			smb.append(word + " ");
		}

		// Remove trailing space
		String ret = smb.toString().trim();

		console.log(ret);
	}
}
