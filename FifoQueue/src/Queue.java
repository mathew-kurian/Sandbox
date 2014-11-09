@SuppressWarnings("unchecked")
public class Queue<T> {

	private Object list[];
	private int head;
	private int tail;
	private int size;

	public Queue(int size) {
		this.size = size + 1;
		this.list = new Object[this.size];
		this.head = 1;
		this.tail = 0;
	}

	public T get() {
		if ((tail + 1) % size == head) {
			return null;
		}

		tail = ++tail % size;
		T t = (T) list[tail];

		return t;
	}

	public boolean add(T t){
		if(head == tail){
			return false;
		}

		list[head] = t;		
		head = ++head % size;
		
		return true;
	}
}
