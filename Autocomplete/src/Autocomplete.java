import java.util.Comparator;


public interface Autocomplete {

	void setContext(String s);
	Result [] match(String s);
}
