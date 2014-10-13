import java.util.ArrayList;
import java.util.Collections;

public class Naive implements AutoComplete {
	
	private String context = "";
	private String [] words = new String [0];
	
	@Override
	public void setContext(String s) {
		context = s == null ? context : s;
		words = context.replaceAll("[^a-zA-Z ]", "").toLowerCase().split("\\s+");
	}

	@Override
	public Result[] match(String s) {
		
		s = s.toLowerCase();
		
		ArrayList<Result> results = new ArrayList<Result>();
		
		for(int i = 0; i < words.length; i++){
			if (words[i].contains(s)) {
				results.add(new Result(words[i], i, (double) s.length() / (double) words[i].length()));
			} else if(s.contains(words[i])){
				results.add(new Result(words[i], i, (double) words[i].length() / (double) s.length()));
				
			} 
		}
		
		Collections.sort(results);
		
		return results.toArray(new Result[0]);
	}
}
