package common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * {@link ObjectFreq} is utility that can be used to count the number of similar
 * objects in a list. One such use is case is trying to measure the frequency of
 * words in a {@link String}.
 * 
 * @author Mathew Kurian
 * @version 1.0
 */

public class ObjectFreq {

	private static final boolean DEBUG;
	private static final Console console;

	// default pre-compiled punctuation remover
	private static final Pattern defPuncPat;

	static {
		DEBUG = false; // production mode enabled
		console = Console.getInstance(ObjectFreq.class);
		defPuncPat = Pattern.compile("[\\[\\]\\{\\}<>/!?,.;:()]");
	}

	/**
	 * {@link FreqInfo} will provide the user with information about the
	 * count/frequency analysis
	 */
	public static class FreqInfo<T> {

		private final Map<Integer, Set<T>> valuesByFreq;
		private final int maxFreq;

		/**
		 * Private constructor invokable only {@link ObjectFreq}
		 * 
		 * @param valuesByFreq
		 *            map with set of values corresponding the frequency
		 * @param maxFreq
		 *            maximum frequency of any value
		 */
		private FreqInfo(Map<Integer, Set<T>> valuesByFreq, int maxFreq) {
			this.valuesByFreq = valuesByFreq;
			this.maxFreq = maxFreq;
		}

		/**
		 * Get the values associated with a provided count
		 * 
		 * @param freq
		 *            indicates the frequency
		 * @return the set of values associated with a particular frequency
		 */
		public Set<T> getValuesByFrequency(int freq) {
			return valuesByFreq.containsKey(freq) ? valuesByFreq.get(freq)
					: null;
		}

		/**
		 * @return the maximum frequency of any value
		 */
		public int getMaxFrequency() {
			return maxFreq;
		}

		/**
		 * Return the most frequent values
		 * 
		 * @param top
		 *            the top k values
		 * @return ordered list of top k values
		 */
		public List<T> getFrequent(int top) {
			return getSortedValues(true, top);
		}

		/**
		 * Get a list of the top values by ordered by frequency
		 * 
		 * @param descend
		 *            set ascending or descending frequency
		 * @param top
		 *            top "k" values
		 * @return
		 */
		public List<T> getSortedValues(boolean ascend, int top) {
			if (maxFreq == 0 || top < 1) {
				return new ArrayList<T>(0);
			}

			int start, end, ofst;

			// descending
			start = 1;
			end = maxFreq + 1;
			ofst = 1;

			// ascending
			if (ascend) {
				start = maxFreq;
				end = 0;
				ofst = -1;
			}

			ArrayList<T> values = new ArrayList<T>();

			countLoop:

			for (int i = start; i != end; i += ofst) {
				Set<T> countedSet = getValuesByFrequency(i);
				if (countedSet != null) {
					for (T word : countedSet) {
						values.add(word);
						if (--top == 0) {
							break countLoop;
						}
					}
				}
			}

			return values;
		}
	}

	/**
	 * Get the word frequency
	 * 
	 * @param src
	 *            text to count
	 * @return {@link FreqInfo} object containing the frequency data
	 */
	public static FreqInfo<String> getFrequency(String src) {
		return getFrequency(src, true);
	}

	/**
	 * Get the word frequency
	 * 
	 * @param src
	 *            text to count
	 * @param ignoreCase
	 *            convert uppercase to lowercase
	 * @return {@link FreqInfo} object containing the frequency data
	 */
	public static FreqInfo<String> getFrequency(String src, boolean ignoreCase) {
		return getFrequency(src, true, defPuncPat);
	}

	/**
	 * Get the word frequency
	 * 
	 * @param src
	 *            text to count
	 * @param ignoreCase
	 *            convert uppercase to lowercase
	 * @param puncPatt
	 *            punctuation matching pattern
	 * @return {@link FreqInfo} object containing the frequency data
	 */
	public static FreqInfo<String> getFrequency(String src, boolean ignoreCase,
			Pattern puncPatt) {
		// normalize words
		String[] words = ObjectFreq.extractWords(src, ignoreCase, puncPatt);
		FreqInfo<String> freqInfo = getFrequency(words);
		return freqInfo;
	}

	/**
	 * Get a list of the words from the input string
	 * 
	 * @param src
	 *            text to extract words from
	 * @param ignoreCase
	 *            convert uppercase to lowercase
	 * @param puncPatt
	 *            punctuation matching pattern
	 * @return an String [] of words
	 */
	public static String[] extractWords(String src, boolean ignoreCase,
			Pattern puncPatt) {
		if (src == null || src.length() == 0) {
			return new String[0];
		}

		if (ignoreCase) {
			src = src.toLowerCase();
		}

		if (puncPatt != null) {
			src = puncPatt.matcher(src).replaceAll("");
		}

		return src.split("\\s+");
	}

	/**
	 * Calculate the frequency of each object in the provided array. The
	 * complexity of this function O(n) since each value in the values array is
	 * only visited at most two (2) times. The function also performs several
	 * amortizations which will increase that constant but this value is usually
	 * ignored in the calculation of the complexity. It must be noted that in
	 * order to keep the complexity to O(n), the function has to use a larger
	 * space complexity that it would might with a higher order complexity.
	 * 
	 * @param values
	 *            values for which to measure the frequency
	 * @return a {@link FreqInfo} object containing the information
	 */
	public static <T> FreqInfo<T> getFrequency(T[] values) {
		if (values == null || values.length == 0) {
			return new FreqInfo<T>(null, 0);
		}

		int currMaxFreq = 0;
		Map<T, Integer> freqByValue = new HashMap<T, Integer>();
		Map<Integer, Set<T>> valuesByFreq = new HashMap<Integer, Set<T>>();

		if (DEBUG) {
			console.log("values.length: " + values.length);
		}

		for (T word : values) {

			int freq = 1;

			if (freqByValue.containsKey(word)) {
				freq = freqByValue.get(word) + 1;
			}

			freqByValue.put(word, freq);

			// remove the object from previous set
			if (freq > 1) {
				valuesByFreq.get(freq - 1).remove(word);
			}

			Set<T> countedSet;

			if (valuesByFreq.containsKey(freq)) {
				countedSet = valuesByFreq.get(freq);
			} else {

				countedSet = new HashSet<T>();
				valuesByFreq.put(freq, countedSet);

				currMaxFreq++;

				if (DEBUG) {
					console.log("Freq(" + freq + ", Set<T>)");
				}
			}

			countedSet.add(word);
		}

		if (DEBUG) {
			console.log("maxValueFreq: " + currMaxFreq);
		}

		// Strip out the empty keys
		for (int i = 1; i <= currMaxFreq; i++) {
			if (valuesByFreq.get(i).size() == 0) {
				valuesByFreq.remove(i);
			}
		}

		return new FreqInfo<T>(valuesByFreq, currMaxFreq);

	}
}
