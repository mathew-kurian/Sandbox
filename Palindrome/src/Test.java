import static org.junit.Assert.*;


public class Test {

	@org.junit.Test
	public void forLoopNaiveTest() {
		assertTrue(Driver.forLoopNaive("catac").equals("catac"));
		assertTrue(Driver.forLoopNaive("hooh").equals("hooh"));
		assertTrue(Driver.forLoopNaive("ahooh").equals("hooh"));
		assertTrue(Driver.forLoopNaive("aabahooh").equals("hooh"));
		assertTrue(Driver.forLoopNaive("aahooh").equals("hooh"));
		assertTrue(Driver.forLoopNaive("hooha").equals("hooh"));
		assertTrue(Driver.forLoopNaive("").equals(""));
		assertTrue(Driver.forLoopNaive("abc") == null);
		assertTrue(Driver.forLoopNaive(null) == null);
	}

	@org.junit.Test
	public void recursiveNaiveTest() {
		assertTrue(Driver.recursiveNaive("catac").equals("catac"));
		assertTrue(Driver.recursiveNaive("hooh").equals("hooh"));
		assertTrue(Driver.recursiveNaive("ahooh").equals("hooh"));
		assertTrue(Driver.recursiveNaive("aabahooh").equals("hooh"));
		assertTrue(Driver.recursiveNaive("aahooh").equals("hooh"));
		assertTrue(Driver.recursiveNaive("hooha").equals("hooh"));
		assertTrue(Driver.recursiveNaive("").equals(""));
		assertTrue(Driver.recursiveNaive("abc") == null);
		assertTrue(Driver.recursiveNaive(null) == null);
	}
}
