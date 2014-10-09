public class Result implements Comparable<Result> {

	public String value;
	public int index;
	public double score;

	public Result(String s, int i, double c) {
		value = s;
		index = i;
		score = c;
	}

	public String toString() {
		return "{ " + value + " :: " + index + " :: " + score + " }";
	}

	@Override
	public int compareTo(Result arg1) {
		return score < arg1.score ? 1 : score == arg1.score ? 0 : -1;
	}
}