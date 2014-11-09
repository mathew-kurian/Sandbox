
public class Driver {

	public static void main(String[] args) {
		if(args.length == 0){
			System.err.println("Requires at least one (1) argument");
		}	
		
		System.out.println(swap(args[1]));
	}
	
	public static String swap(String str){
		
		if(str == null){
			return null;
		}
		
		StringBuilder smb = new StringBuilder(str);
		int length = smb.length();
		int offset = length - 1;
		
		for(int i = 0; i < length / 2; i++){
			int other = i + offset;
			char s = smb.charAt(i);
			char s2 = smb.charAt(other);
			smb.setCharAt(i, s2);
			smb.setCharAt(other, s);
			offset -= 2;
		}

		return smb.toString();
	}
	
	public static String naive(String str){
		if(str == null){
			return null;
		}
		
		StringBuilder smb = new StringBuilder();
		
		for(int i = str.length() - 1; i > -1; i--){
			smb.append(str.charAt(i));
		}
		
		return smb.toString();
	}

}
