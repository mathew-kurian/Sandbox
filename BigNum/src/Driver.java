
public class Driver {

	public static void main(String [] args){
		BigNum bignum = new BigNum(5);
		bignum.add(Integer.MAX_VALUE);
		System.out.println(bignum);
		bignum.add(5);
		System.out.println(bignum);
	}
}
