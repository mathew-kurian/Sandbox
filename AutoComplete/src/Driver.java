import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Enumeration;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.plaf.FontUIResource;

public class Driver {

	public static void main(String[] args) {

		setUIFont(new javax.swing.plaf.FontUIResource("Serif", Font.PLAIN, 30));

		SwingUtilities.invokeLater(new Runnable() {
			@Override
			public void run() {

				String file = readFile("sample.txt", Charset.defaultCharset());
				final AutoComplete ng = new NGram(3), nv = new Naive();

				ng.setContext(file);
				nv.setContext(file);

				JFrame jmf = new JFrame();
				jmf.getContentPane().setLayout(new BorderLayout());

				JPanel jp = new JPanel();
				jp.setLayout(new GridLayout(1, 2));
				jmf.getContentPane().add(jp, BorderLayout.CENTER);

				final JTextArea jtNaive = new JTextArea();
				final JScrollPane jtNaiveS = new JScrollPane(jtNaive);
				jp.add(jtNaiveS);

				final JTextArea jtNGram = new JTextArea();
				final JScrollPane jtGramS = new JScrollPane(jtNGram);
				jp.add(jtGramS);

				final JTextField ji = new JTextField();
				ji.addKeyListener(new KeyListener() {

					@Override
					public void keyPressed(KeyEvent arg0) {}
					@Override
					public void keyReleased(KeyEvent arg0) {
						Result[] resnv = nv.match(ji.getText());
						Result[] resng = ng.match(ji.getText());

						jtNaive.setText("Naive:\n=========\n\n"
								+ formatResults(resnv));
						jtNGram.setText("NGram:\n=========\n\n"
								+ formatResults(resng));

						SwingUtilities.invokeLater(new Runnable() {
							public void run() {
								jtNaiveS.getVerticalScrollBar().setValue(0);
								jtGramS.getVerticalScrollBar().setValue(0);
							}
						});
					}
					@Override
					public void keyTyped(KeyEvent arg0) {}
				});
				
				jmf.getContentPane().add(ji, BorderLayout.NORTH);
				jmf.setMinimumSize(new Dimension(800, 600));
				jmf.pack();
				jmf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
				jmf.setLocationRelativeTo(null);
				jmf.setVisible(true);

			}
		});
	}

	@SuppressWarnings("rawtypes")
	public static void setUIFont(FontUIResource f) {
		Enumeration keys = UIManager.getDefaults().keys();
		while (keys.hasMoreElements()) {
			Object key = keys.nextElement();
			Object value = UIManager.get(key);
			if (value != null
					&& value instanceof javax.swing.plaf.FontUIResource)
				UIManager.put(key, f);
		}
	}

	public static String formatResults(Result[] results) {
		if (results == null) {
			return "";
		}

		StringBuilder smb = new StringBuilder();

		for (Result result : results) {
			smb.append(result + "\n");
		}

		return smb.toString();
	}

	static String readFile(String path, Charset encoding) {
		try {
			byte[] encoded = Files.readAllBytes(Paths.get(path));
			return new String(encoded, encoding);
		} catch (IOException e) {
			return "";
		}
	}
}
