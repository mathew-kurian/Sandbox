import java.awt.Color;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.GraphicsEnvironment;
import java.awt.Toolkit;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.text.NumberFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.SwingConstants;

public class CountDown implements Runnable
{
        private static NumberFormat formatter = NumberFormat.getInstance();
        private JFrame frame;
        private JLabel label;
        private long newYearMillis;
        private String message;

        public CountDown(JFrame frame, JLabel label)
        {
                // store argument GUI elements
                this.frame = frame;
                this.label = label;
                // compute beginning of next year
                Calendar cal = new GregorianCalendar();
                int nextYear = cal.get(Calendar.YEAR) + 1;
                cal.set(Calendar.YEAR, nextYear);
                cal.set(Calendar.MONTH, Calendar.JANUARY);
                cal.set(Calendar.DAY_OF_MONTH, 1);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                newYearMillis = cal.getTime().getTime();
                // prepare a message
                message = "Happy " + nextYear + "!";
        }

        public static int determineFontSize(JFrame frame,
        int componentWidth, String fontName, int fontStyle,
        String text)
        {
                int fontSize = componentWidth * 2 / text.length();
                Font font = new Font(fontName, fontStyle, fontSize);
                FontMetrics fontMetrics = frame.getGraphics().
                getFontMetrics(font);
                int stringWidth = fontMetrics.stringWidth(text);
                return (int)(fontSize * 0.95 *
                componentWidth / stringWidth);
        }

        public static void main(String[] args)
        {
                JFrame frame = new JFrame();
                frame.addKeyListener(new KeyListener()
                {
                        public void keyPressed(KeyEvent event) {}
                        public void keyReleased(KeyEvent event) {
                                if (event.getKeyChar() == KeyEvent.VK_ESCAPE)
                                {
                                        System.exit(0);
                                }
                        }
                        public void keyTyped(KeyEvent event) {}
                }
                );
                frame.setUndecorated(true);
                JLabel label = new JLabel(".");
                label.setBackground(Color.BLACK);
                label.setForeground(Color.WHITE);
                label.setOpaque(true);
                label.setHorizontalAlignment(SwingConstants.CENTER);
                frame.getContentPane().add(label);
                GraphicsEnvironment.getLocalGraphicsEnvironment().
                getDefaultScreenDevice().setFullScreenWindow(frame);
                final int fontStyle = Font.BOLD;
                final String fontName = "SansSerif";
                int fontSizeNumber = determineFontSize(frame,
                Toolkit.getDefaultToolkit().getScreenSize().width,
                fontName, fontStyle, formatter.format(88888888));
                int fontSizeText = determineFontSize(frame,
                Toolkit.getDefaultToolkit().getScreenSize().width,
                fontName, fontStyle, "Happy 8888!");
                label.setFont(new Font(fontName, fontStyle,
                Math.min(fontSizeNumber, fontSizeText)));
                new CountDown(frame, label).run();
        }

        public void run()
        {
                boolean newYear = false;
                do
                {
                        long time = System.currentTimeMillis();
                        long remaining = (newYearMillis - time) / 1000L;
                        String output;
                        if (remaining < 1)
                        {
                                // new year!
                                newYear = true;
                                output = message;
                        }
                        else
                        {
                                // make a String from the number of seconds
                                output = formatter.format(remaining);
                        }
                        label.setText(output);
                        try
                        {
                                Thread.sleep(1000);
                        }
                        catch (InterruptedException ie)
                        {
                                ie.printStackTrace(System.err);
                        }
                }
                while (!newYear);
        }
}
