import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public class Driver {

	public static void main(String[] args) {
		List<Integer> ans = 
				find(Arrays.asList(new Integer [] { 2, 6, 3, 4, 1, 2, 9, 5, 8 }));
		for(Integer i : ans){
			System.out.print(i + ", ");
		}
	}
	
	public static List<Integer> find(List<Integer> vals){
		ArrayList<Integer> arr = new ArrayList<Integer>();
		for(int i = 0; i < vals.size(); i++){
			if(arr.size() == 0){
				arr.add(vals.get(i));
				continue;
			}
			
			int lastIndex = arr.size() - 1;
			int val = vals.get(i);
			
			if(arr.get(lastIndex) > val){
				int idx = 0;
				while(idx < arr.size() && arr.get(idx) < val){
					idx++;
				}
				arr.remove(idx);
				arr.add(idx, val);
			} else {
				arr.add(val);
			}
		}
		
		return arr;
	}
}
