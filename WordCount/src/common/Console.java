package common;

import java.util.HashMap;
import java.util.Map;

/**
 * {@link Console} is the logging system. A Console object will can be requested by each
 * class in order to the write to the system declared default {@link PrintWriter}. This
 * state currently only two basic functions:
 * <ul>
 * <li>{@link Console#log(Object)}
 * <li>{@link Console#err(Object)}
 * </ul>
 * <p>
 * 
 * @author Mathew Kurian
 * @version 1.0
 */

@SuppressWarnings("rawtypes")
public class Console {

	private static final Map<Class, Console> perClass;
	private final String tag;

	static {
		perClass = new HashMap<Class, Console>();
	}

	/**
	 * Returns an instance of {@link Console} object specified by that
	 * {@link Class}. Every class will only have at most one (1) Console object
	 * created for it. This function is thread-safe.
	 * <p>
	 *
	 * @param cls
	 *            the specified {@link Class} will be re
	 * @return the Console object mapped to {@link Class} specified by the
	 *         parameter
	 *
	 */
	public static synchronized Console getInstance(Class cls) {
		Console instance;

		if (perClass.containsKey(cls)) {
			instance = perClass.get(cls);
		} else {
			instance = new Console(cls);
			perClass.put(cls, instance);
		}

		return instance;
	}

	/**
	 * Constructor used for invocation by {@link Console#getInstance(Class)}
	 * 
	 * @see Console#getInstance(Class)
	 */
	private Console(Class cls) {
		this.tag = "[" + cls.getCanonicalName() + "] ";
	}

	/**
	 * Streams into the {@link PrintWriter} specified by {@link System.out}
	 *
	 * @param obj
	 *            the object to be piped out
	 * 
	 * @see {@link System.out#println(Object)}
	 */
	public void log(Object obj) {
		System.out.println(tag + obj.toString());
	}

	/**
	 * Streams into the {@link PrintWriter} specified by {@link System.err}
	 *
	 * @param obj
	 *            the object to be piped out
	 * 
	 * @see {@link System.err#println(Object)}
	 */
	public void err(Object s) {
		System.err.println(tag + s.toString());
	}
}
