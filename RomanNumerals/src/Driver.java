
public class Driver {

	public static void main(String[] args) {
		System.out.println(Driver.toNumber("XXXIV"));
	}
	
	public static int toNumber(String roman){
		int value = 0, lastValue = 0;
		for(int i = roman.length() - 1; i >= 0; i--){
			int currValue = map(roman.charAt(i));
			if(currValue < lastValue){
				value -= currValue;
			} else {
				value += currValue;
			}
			
			lastValue = currValue;
		}	
		
		return value;
	}
	
	private static int map(char inp)
	{
		switch (inp)
		{
			case 'i':
			case 'I':
				return 1;
			case 'v':
			case 'V':
				return 5;
			case 'x':
			case 'X':
				return 10;
			case 'l':
			case 'L':
				return 50;
			case 'c':
			case 'C':
				return 100;
			case 'd':
			case 'D':
				return 500;
		default:
			return 0;
		}
	}
}
