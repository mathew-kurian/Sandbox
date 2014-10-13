public interface AutoComplete {

	void setContext(String s);
	Result [] match(String s);
}
