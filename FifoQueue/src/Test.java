import static org.junit.Assert.*;

public class Test {

	@org.junit.Test
	public void test() {
		Queue<Integer> queue = new Queue<Integer>(5);
		
		assertTrue(queue.add(0));
		assertTrue(queue.add(1));
		assertTrue(queue.add(2));
		assertTrue(queue.add(3));
		assertTrue(queue.add(4));
		assertFalse(queue.add(5));
		
		assertTrue(queue.get().equals(0));
		assertTrue(queue.get().equals(1));
		assertTrue(queue.get().equals(2));
		assertTrue(queue.get().equals(3));
		assertTrue(queue.get().equals(4));
	}

}
