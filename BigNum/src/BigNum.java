
public class BigNum {

	private final int integers;
	private int [] value;
	
	public BigNum(int integers){
		this.integers = integers;
		this.value = new int[integers];
	}
	
	class Result {
		int value = 0;
		int cout = 0;
		public Result(int a, int b){
			value = a;
			cout = b;
		}
	}
	
	public int getCarry(int x, int y){
		if(x > 0 & x > 0 & (y + x) < 0){
			return Math.abs(x + y);
		}
		return 0;
	}
	
	public Result fullAdder(int x, int y, int cin){
		int total = x ^ y ^ cin;
		int cout = getCarry(x, cin) + getCarry(x, y) + getCarry(y, cin);
		return new Result(total, cout);
	}
	
	public void add(int x){
		int cout = 0;
		for(int i = 0; i < integers & ((cout > 0 & i > 0) | i == 0); i++){
			Result res = fullAdder(x, value[i], cout);
			cout = res.cout;
			value[i] = res.value;
		}
	}
	
	public String toString(){
		StringBuilder smb = new StringBuilder();
		for(int i = 0; i < integers; i++){
			smb.insert(0, Integer.toString(value[i]));
		}
		return smb.toString();
	}
}
