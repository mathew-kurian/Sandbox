/**
 * @(#)TransparentBackground.java
 *
 *
 * @author 
 * @version 1.00 2010/2/26
 */


import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import java.text.NumberFormat;
 
public class TransparentBackground extends JLayeredPane implements ComponentListener, WindowFocusListener, Runnable{ 
    private JFrame frame; 
    private Image background;
	private long _lastUpdate = 0;
	private boolean _refreshRequested = true;
	public Robot rbt;
	public Toolkit tk;
	public Dimension dim;
	public Point pos;
	public Point offset;
	long total;
	long used;

public TransparentBackground(JFrame frame) {
    this.frame = frame;
    updateBackground();
    frame.addComponentListener(this);
	frame.addWindowFocusListener(this);
    new Thread(this).start();
}

public void updateBackground( ) {
    try {
    	total = Runtime.getRuntime().totalMemory();
    	used  = (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory())/1024;
    	//System.out.println("updateBackground() Run: Memory Usage: " + used +" MB");
        rbt = new Robot();
        tk = Toolkit.getDefaultToolkit( );
        dim = tk.getScreenSize( );
        background = rbt.createScreenCapture(
        new Rectangle(0,0,(int)dim.getWidth( ),
                          (int)dim.getHeight( )));
    } catch (Exception ex) {
        
    }
}
public void paintComponent(Graphics g) {
	//System.out.println("paintComponent() Run");
    pos = this.getLocationOnScreen();
    offset = new Point(-pos.x,-pos.y);
    g.drawImage(background,offset.x,offset.y,null);
}

protected void refresh() {
		if (frame.isVisible() && this.isVisible()) {
			repaint();
			_refreshRequested = true;
			_lastUpdate = System.currentTimeMillis();
		//System.out.println("refresh() Run");
		}
	}
	
// ComponentListener -------------------------------------------------------
	public void componentHidden(ComponentEvent e) {
	}
 
	public void componentMoved(ComponentEvent e) {
		repaint();
	}
 
	public void componentResized(ComponentEvent e) {
		repaint();
 
	}
 
	public void componentShown(ComponentEvent e) {
		repaint();
	}
 
	// WindowFocusListener -----------------------------------------------------
	public void windowGainedFocus(WindowEvent e) {
		refresh();
	}
 
	public void windowLostFocus(WindowEvent e) {
		refresh();
	}

public void run() {
		try {
			while (true) {
				Thread.sleep(10);
				long now = System.currentTimeMillis();
				if (_refreshRequested && ((now - _lastUpdate) > 100)) {
					if (frame.isVisible()) {
						
						Point location = frame.getLocation();
						frame.setLocation(-frame.getWidth(), -frame.getHeight());
						updateBackground();
						frame.setLocation(location);
						refresh();
					}
					_lastUpdate = now;
					_refreshRequested = false;
					//System.out.println("run() END------------");
				}
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}
