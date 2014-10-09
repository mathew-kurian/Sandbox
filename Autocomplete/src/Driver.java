import org.apache.commons.lang3.StringUtils;


public class Driver {

	public static void main(String[] args) {
		AutoComplete ac = new Naive();
		ac.setContext("This is funny");
		printResults(ac.match("n"));

		System.out.println(StringUtils.countMatches("bbbbbz", "bbbbz"));
	}

	public static void printResults(Result [] results){
		for(Result result : results){
			System.out.println(result);
		}
	}
}
