import static org.junit.Assert.*;


public class Test {

	@org.junit.Test
	public void swapTest() {
		assertTrue(Driver.swap("cat").equals("tac"));
		assertTrue(Driver.swap("v").equals("v"));
		assertTrue(Driver.swap("lola").equals("alol"));
		assertTrue(Driver.swap("").equals(""));
		assertTrue(Driver.swap(null) == null);
	}

	@org.junit.Test
	public void naiveTest() {
		assertTrue(Driver.naive("cat").equals("tac"));
		assertTrue(Driver.naive("v").equals("v"));
		assertTrue(Driver.naive("lola").equals("alol"));
		assertTrue(Driver.naive("").equals(""));
		assertTrue(Driver.naive(null) == null);
	}
}
