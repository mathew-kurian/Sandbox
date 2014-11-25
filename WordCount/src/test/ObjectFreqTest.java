package test;

import static org.junit.Assert.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;

import common.Console;
import common.ObjectFreq;
import common.ObjectFreq.FreqInfo;

/**
 * Basic JUnit tests for {@linkplain ObjectFreq}. The following tests are
 * created to meet the following coverage requirements:
 * <ul>
 * <li>Node coverage
 * <li>Edge coverage
 * <li>Predicate coverage -> Branch coverage
 * </ul>
 * 
 * @author Mathew Kurian
 * @version 1.0
 */

public class ObjectFreqTest {

	@SuppressWarnings("unused")
	private static final Console console;
	private static final String randText;

	static {
		console = Console.getInstance(ObjectFreqTest.class);
		randText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur lacinia est eget "
				+ "ultrices pulvinar. Morbi tempus maximus justo nec interdum. Cras ornare, elit eu tempus "
				+ "auctor, nisl orci auctor augue, at sodales quam velit et massa. Sed quis sapien neque. "
				+ "Phasellus a tristique ante, vitae semper lorem. Integer gravida enim quis nunc semper, "
				+ "nec tempor lorem volutpat. Praesent vitae ultricies quam, nec vehicula erat. Proin "
				+ "lobortis libero ac nisl fermentum, id lobortis quam tincidunt. Ut sit amet arcu lacus. "
				+ "Ut quis placerat sem. Cras a semper libero. Praesent mattis, nulla ut tempus varius, "
				+ "arcu urna laoreet ante, eget congue nisi libero ut metus. Etiam eget porttitor massa. "
				+ "Morbi ultrices ac purus nec suscipit. Interdum et malesuada fames ac ante ipsum primis "
				+ "in faucibus. Proin eget placerat massa. Pellentesque nec nisi ac felis suscipit ornare. "
				+ "Aenean purus sem, dapibus mollis tellus ac, faucibus interdum urna. Sed congue dolor a "
				+ "sagittis tempor. Suspendisse fermentum ex ut eleifend feugiat. Phasellus porttitor, arcu "
				+ "nec aliquam elementum, augue nisi fermentum mi, sed volutpat dui elit eu erat. Cras "
				+ "rhoncus nisi et sem posuere, et consequat ipsum bibendum. Proin tempus bibendum turpis "
				+ "eget elementum.";
	}

	@org.junit.Test
	public void sortByFrequencyTest1() {
		/* Ensuring that multiple spaces won't split into multiple words */
		FreqInfo<String> freqInfo = ObjectFreq
				.getFrequency("funny        man funny");
		String output = freqInfo.getFrequent(Integer.MAX_VALUE).get(0);
		assertTrue(output.equals("funny"));
		assertEquals(freqInfo.getMaxFrequency(), 2);
		assertEquals(freqInfo.getValuesByFrequency(1).size(), 1);
		output = freqInfo.getSortedValues(false, 1).get(0);
		assertTrue(output.equals("man"));
	}

	@org.junit.Test
	public void sortByFrequencyTest2() {
		/* Testing different cases of the the same word */
		FreqInfo<String> freqInfo = ObjectFreq
				.getFrequency("funny Man mAn maN man funny");
		String output = freqInfo.getFrequent(1).get(0);
		assertTrue(output.equals("man"));
	}

	@org.junit.Test
	public void sortByFrequencyTest3() {
		/* Testing empty string input */
		FreqInfo<String> freqInfo = ObjectFreq.getFrequency("");
		assertEquals(freqInfo.getMaxFrequency(), 0);
	}

	@org.junit.Test
	public void sortByFrequencyTest4() {
		/* Testing NULL input */
		Object[] objs = null;
		FreqInfo<Object> freqInfo = ObjectFreq.getFrequency(objs);
		assertEquals(freqInfo.getMaxFrequency(), 0);
	}

	@org.junit.Test
	public void sortByFrequencyTest5() {
		/* Testing with a more complex input */
		FreqInfo<String> freqInfo = ObjectFreq
				.getFrequency("a b c d e e e e e g g g g g ggg g g g g");
		List<String> words = freqInfo.getFrequent(2);
		assertTrue(words.get(0).equals("g"));
		assertTrue(words.get(1).equals("e"));
	}

	@org.junit.Test
	public void sortByFrequencyTest6() {
		/* Testing common punctuation */
		FreqInfo<String> freqInfo = ObjectFreq
				.getFrequency("e e e e e e e e e G: g, G; G (g) [g.] [g,] [g] {g?} {g!} (#@g)");
		List<String> words = freqInfo.getFrequent(3);
		assertTrue(words.get(0).equals("g"));
		assertTrue(words.get(1).equals("e"));
		assertTrue(words.get(2).equals("#@g"));
	}

	@org.junit.Test
	public void sortByFrequencyTest7() {
		/* Testing a single word/character */
		FreqInfo<String> freqInfo = ObjectFreq.getFrequency("a");
		List<String> words = freqInfo.getFrequent(2);
		assertTrue(words.get(0).equals("a"));
	}

	@org.junit.Test
	public void sortByFrequencyTest8() {
		/* Testing with longer text with basic frequency search */

		HashMap<String, Integer> wordMap = new HashMap<String, Integer>();
		String[] words = randText.replaceAll("[,.!?]", "").split("\\s+");

		for (String word : words) {
			int k = wordMap.containsKey(word) ? wordMap.get(word) : 0;
			wordMap.put(word, k + 1);
		}

		int max = 0;
		int smax = 0;
		String maxStr = "";
		String sMaxStr = "";

		for (Entry<String, Integer> entry : wordMap.entrySet()) {
			int count = entry.getValue();
			if (count > max) {
				sMaxStr = maxStr;
				smax = max;
				maxStr = entry.getKey();
				max = count;
			} else if (count > smax) {
				sMaxStr = entry.getKey();
				smax = count;
			}
		}

		FreqInfo<String> freqInfo = ObjectFreq.getFrequency(randText);
		List<String> sortedWords = freqInfo.getFrequent(2);
		assertTrue(sortedWords.get(0).equals(maxStr));
		assertTrue(sortedWords.get(1).equals(sMaxStr));
	}

	@org.junit.Test
	public void sortByFrequencyTest9() {
		/* Testing negative value for (k) */
		Exception exc = null;
		try {
			FreqInfo<String> freqInfo = ObjectFreq.getFrequency("a");
			freqInfo.getFrequent(-1);
		} catch (Exception e) {
			exc = e;
		}

		assertEquals(exc, null);
	}
}
