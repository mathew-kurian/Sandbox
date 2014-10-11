import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

public class NGram implements AutoComplete {

	private int N = 0;
	private String context = "";
	private String[] words = new String[0];
	private HashMap<String, ArrayList<Integer>> map = new HashMap<String, ArrayList<Integer>>();

	public NGram(int n) throws IllegalArgumentException {
		N = n;
		if (N <= 0) {
			throw new IllegalArgumentException();
		}
	}

	@Override
	public void setContext(String s) {
		context = s == null ? context : s;
		words = context.replaceAll("[^a-zA-Z ]", "").toLowerCase()
				.split("\\s+");
		map = new HashMap<String, ArrayList<Integer>>();

		for (int x = 0; x < words.length; x++) {
			String word = words[x];
			int length = word.length();
			for (int i = 0; i < length; i += N) {
				String part = word.substring(i, Math.min(length, i + N));
				if (map.containsKey(part)) {
					map.get(part).add(x);
				} else {
					ArrayList<Integer> indices = new ArrayList<Integer>();
					indices.add(x);
					map.put(part, indices);
				}
			}
		}
	}

	@SuppressWarnings("unused")
	private <T> void printArray(T[] arr) {
		for (int i = 0; i < arr.length; i++) {
			System.out.println("[" + i + "]:" + arr[i]);
		}
	}

	@SuppressWarnings("unused")
	private <T> void printKeys(HashMap<String, ArrayList<Integer>> map) {
		for (String key : map.keySet()) {
			System.out.println("[" + key + "]:" + map.get(key).size());
		}
	}

	@Override
	public Result[] match(String s) {

		s = s.toLowerCase();
		
		int length = s.length();

		ArrayList<Result> results = new ArrayList<Result>();
		ArrayList<Integer> indices = new ArrayList<Integer>();
		HashMap<Integer, String> matches = new HashMap<Integer, String>();

		for (int i = 0; i < length; i += N) {
			String part = s.substring(i, Math.min(length, i + N));
			if (map.containsKey(part)) {
				indices.addAll(map.get(part));
			}
		}

		for (int i = 0; i < indices.size(); i++) {
			matches.put(indices.get(i), words[indices.get(i)]);
		}

		for (int index : matches.keySet()) {
			String match = matches.get(index);
			if (match.contains(s)) {
				results.add(new Result(match, index, (double) s.length()
						/ (double) match.length()));
			} else if (s.contains(match)) {
				results.add(new Result(match, index, (double) match.length()
						/ (double) s.length()));
			} else {
				results.add(new Result(match, index, 0));
			}
		}

		Collections.sort(results);

		return results.toArray(new Result[0]);
	}
	
	@SuppressWarnings("unused")
	private ArrayList<Integer> removeAll(ArrayList<String> words, 
			ArrayList<Integer> indices, String word) {
		ArrayList<Integer> found = new ArrayList<Integer>();
		for (int i = 0; i < words.size(); i++) {
			if (words.get(i).equalsIgnoreCase(word)) {
				words.remove(i);
				found.add(indices.remove(i));
				i--;
			}
		}

		return found;
	}

}
