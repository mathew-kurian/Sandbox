
public class Driver {

	public static void main(String[] args) {
		System.out.println(Driver.toExcelColumnValue(704));
	}
	
	public static String toExcelColumnValue(int val){
		int res = val;
		StringBuilder smb = new StringBuilder();
		while(res > 0){
			int ch = ((res - 1) % 26);
			smb.insert(0, (char) (ch + 65));
			// res = (res - ch) / 26; // or
			res = (int) Math.floor(res / 26);
		}
		
		return smb.toString();
	}

}
