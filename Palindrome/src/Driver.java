public class Driver {

	public static void main(String[] args) {
		if (args.length == 0) {
			System.err.println("Requires at least one (1) argument");
		}

		System.out.println(forLoopNaive(args[1]));
	}

	public static String forLoopNaive(String s) {

		if (s == null) {
			return null;
		}

		if (s.length() == 0) {
			return "";
		}

		String lastPalin = "";
		int length = s.length();
		for (int i = 0; i < length; i++) {
			int max = Math.min(i, length - i - 1);
			for (int m = 1; m <= max; m++) {
				String palin = s.substring(i - m, i + m + 1);
				if (isPalindrome(palin) && lastPalin.length() < palin.length()) {
					lastPalin = palin;
				}
				if (i + m + 2 <= length) {
					palin = s.substring(i - m, i + m + 2);
					if (isPalindrome(palin) && lastPalin.length() < palin.length()) {
						lastPalin = palin;
					}
				}
			}
		}

		return lastPalin == "" ? null : lastPalin;
	}
	
	private static boolean isPalindrome(String p) {
		int length = p.length();
		int offset = length - 1;

		for (int i = 0; i < length / 2; i++) {
			if (p.charAt(i) != p.charAt(i + offset)) {
				return false;
			}
			offset -= 2;
		}

		return true;
	}
	
	public static String recursiveNaive(String s) {

		if (s == null) {
			return null;
		}

		if (s.length() == 0) {
			return "";
		}

		String palin = recursiveNaiveHelper(s, 0, s.length());
	
		return palin == "" ? null : palin;
	}
	
	public static String recursiveNaiveHelper(String s, int start, int end) {
		if(isPalindrome(s.substring(0, end))){
			return s;
		}
		
		return s;
	}
}
