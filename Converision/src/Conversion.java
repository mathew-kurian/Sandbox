import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.PrintWriter;

public class Conversion {
	public static void main(String[] args)throws FileNotFoundException{
		File file = new File("start.h");
		int ch;
		StringBuffer strContent = new StringBuffer("");
		FileInputStream fin = null;
		try {
			fin = new FileInputStream(file);
			while ((ch = fin.read()) != -1)
				strContent.append((char) ch);
			fin.close();
		} catch (Exception e) {
			System.out.println(e);
		}
		PrintWriter print = new PrintWriter(new File("Converted.txt"));
		String line;
		line = strContent.toString().replaceAll("(?s)<!--.*?-->", ""); 
		System.out.println(line);
		print.close();
	}
}