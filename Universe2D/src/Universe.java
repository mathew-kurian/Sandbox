import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics2D;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.ButtonGroup;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JRadioButton;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;
import javax.swing.Timer;

import de.javasoft.swing.AboutDialog;
import de.javasoft.swing.DropDownButton;


public abstract class Universe implements MouseMotionListener, MouseListener, KeyListener{
	
	private Universe UNIVERSE = this;	
	private static State STATE;
	
	private Dimension DIMENSION = new Dimension(800, 500);	
	private JFrame FRAME;
	private JPanel MAIN_PANEL;
	private JPanel SUB_PANEL1;		
	private ImageCanvas CANVAS;	
	private Thread REPAINT_THREAD;	
	private ButtonGroup PRIORITIES_LIST = new ButtonGroup();	
	private ArrayList<JRadioButton> JRADIO_LIST = new ArrayList<JRadioButton>();	
	private int DEFAULT_PRIORITY = 4;	
	private DropDownButton DDB = new DropDownButton("PRIORITY " + DEFAULT_PRIORITY);	
	private JPopupMenu JPM = DDB.getPopupMenu();	
	private JButton JB1 = new JButton("EXIT");
	private JButton JB2 = new JButton("ABOUT");
	
	final protected RenderingHints hints = createRenderingHints();
	final protected int TYPE = BufferedImage.TYPE_INT_ARGB;
	final protected int SCALE_TYPE = Image.SCALE_FAST ;
	
	public int TIME = 0;
	public int GARBAGE_DIVISOR = 8;
	
	public static boolean MOUSE_DRAGGED = false;
	public static boolean MOUSE_RELEASED = false;
	public static boolean MOUSE_PRESSED = false;
	public static boolean MOUSE_ENTERED = false;
	public static boolean MOUSE_EXITED = false;
	public static boolean MOUSE_WHEEL = false;
	public static boolean MOUSE_MOVED = false;
	public static boolean MOUSE_CLICKED = false;
	
	public static boolean BUTTON1 = false;
	public static boolean BUTTON2 = false;
	public static boolean BUTTON3 = false;
	public static boolean NOBUTTON = false;
	
	public static int MOUSE_X = 0;
	public static int MOUSE_Y = 0;
	
	final protected Timer timer = new Timer(30, new ActionListener() {
        public void actionPerformed(ActionEvent e) {
        	combiner(); TIME++;
        	if(TIME%GARBAGE_DIVISOR==0) System.gc();
        }
    });
	
	boolean SLEEP = false;
	
	public Universe(int width, int height, String jf_title, State s)
	{		
		STATE = s;
		DIMENSION = new Dimension(width, height+20);
				
		FRAME = new JFrame(jf_title);		
		FRAME.setLayout(new BoxLayout(FRAME.getContentPane(), BoxLayout.Y_AXIS));
		FRAME.setResizable(false);
		
		CANVAS = new ImageCanvas();
		CANVAS.addMouseMotionListener(this);
		CANVAS.addMouseListener(this);
		CANVAS.addKeyListener(this);
		
		REPAINT_THREAD = new Thread(CANVAS, "CANVAS[IC]_REPAINT_THREAD ID: " + CANVAS.toString());
		REPAINT_THREAD.setPriority(DEFAULT_PRIORITY);
				
		MAIN_PANEL = new JPanel();
		MAIN_PANEL.setBackground(new Color(0,0,0,0));
		MAIN_PANEL.setBorder(BorderFactory.createTitledBorder("Canvas"));
		MAIN_PANEL.setSize(DIMENSION);
		MAIN_PANEL.setPreferredSize(DIMENSION);
		MAIN_PANEL.setLayout(new GridLayout());
		
		SUB_PANEL1 = new JPanel();
		SUB_PANEL1.setBackground(new Color(0,0,0,0));
		SUB_PANEL1.setBorder(BorderFactory.createTitledBorder("Options"));
		SUB_PANEL1.setFocusable(false);
		SUB_PANEL1.setLayout(new GridLayout());
		
		for(int x = Thread.MIN_PRIORITY; x<= Thread.MAX_PRIORITY; x++)
		{
			
			String TEMP_STRING = Integer.toString(x);
			
			JRadioButton JRB = new JRadioButton("   " + TEMP_STRING + "                               ");
			JRB.setName(TEMP_STRING);
			JRB.setFocusable(false);
			JRB.setBackground(new Color(0,0,0,0));
			JRB.setOpaque(false);
			JRB.setAlignmentX(JRadioButton.LEFT_ALIGNMENT);
			JRB.addActionListener(new ActionListener(){
				@Override
				public void actionPerformed(ActionEvent arg0) {
					UNIVERSE.setPriority(((JRadioButton)arg0.getSource()).getName());
				}				
			});
			
			if(x == 4)
			{
				JRB.setForeground(Color.GREEN);
				JRB.setSelected(true);
				JRB.repaint();
			}
			
			if(x == Thread.MAX_PRIORITY)
			{
				JRB.setForeground(Color.RED);
				JRB.repaint();
			}
					
			JPM.add(JRB);
			PRIORITIES_LIST.add(JRB);
		}
				
		JB1.setFocusable(false);
		JB1.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent arg0) {
				System.exit(1);
			}				
		});
		
		JB2.setFocusable(false);
		JB2.addActionListener(new ActionListener()
	    {
			@SuppressWarnings("deprecation")
			public void actionPerformed(ActionEvent evt)
		      {
		        try
		        {
		        	File HTML = new File("web/about.html");
		        			        	
		        	AboutDialog AD = new AboutDialog(SwingUtilities.getWindowAncestor((Component)evt.getSource()), false, null, false);		        	
		        	AD.setTitle("About");
		        	AD.setDescription("<html><b>About the Unverse</b><p>An Extension of Conquerer IDE</p></html>");
		        	AD.setAboutText(HTML.toURL());
		        	AD.showDialog();		        	
		        }
		        catch (IOException e)
		        {
		          e.printStackTrace();
		        }
		      }
		    });
		
		DDB.setFocusable(false);
				
		SUB_PANEL1.add(JB2);        
		SUB_PANEL1.add(DDB);
		SUB_PANEL1.add(JB1);
		
		MAIN_PANEL.add(CANVAS);
		
		LogoRenderer logoRenderer = new LogoRenderer();
		logoRenderer.setHorizontalAlignment(SwingConstants.CENTER);
		logoRenderer.setFont(new Font("Segoe UI", Font.BOLD, 12));
		logoRenderer.setForeground(Color.GRAY);
		logoRenderer.setText(jf_title.toUpperCase());
		
		FRAME.add(MAIN_PANEL);
		FRAME.add(SUB_PANEL1);
		FRAME.setIconImage(Toolkit.getDefaultToolkit().createImage("res/icon.png"));
		FRAME.pack();
		FRAME.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		FRAME.getRootPane().putClientProperty("Synthetica.logoRenderer", logoRenderer);		
		FRAME.setLocationRelativeTo(null);
				
		action();
		
		FRAME.setVisible(true);
	}
	public void placeImage(Image IMG, int X, int Y)
	{
		int WIDTH = IMG.getWidth(null);
		int HEIGHT = IMG.getHeight(null);
		
		CANVAS.addImage(new ImageWSpec(IMG, X, Y, WIDTH, HEIGHT));
	}
	public void placeImage(Image IMG, int Y)
	{
		int WIDTH = IMG.getWidth(null);
		int HEIGHT = IMG.getHeight(null);
		
		CANVAS.addImage(new ImageWSpec(IMG, DIMENSION.width/2-WIDTH/2, Y, WIDTH, HEIGHT));
	}
	public Image layerImages(Image IMG, int X, int Y, Image BASE)
	{
		int WIDTH = BASE.getWidth(null);
		int HEIGHT = BASE.getHeight(null);
		
		BufferedImage BI = new BufferedImage(WIDTH, HEIGHT, TYPE);
	    Graphics2D g2d = BI.createGraphics();
        g2d.setRenderingHints(hints); //Disable to boost performance.
        g2d.setComposite(AlphaComposite.SrcOver);
        g2d.drawImage(BASE, 0, 0, null); 
        g2d.drawImage(IMG, X, Y, null);
        g2d.dispose();	
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}
	public void clearAll()
	{
		CANVAS.imgs.clear();
		REPAINT_THREAD.run();
	}
	protected RenderingHints createRenderingHints() 
	{
	        RenderingHints hints = new RenderingHints(RenderingHints.KEY_ANTIALIASING,
	                RenderingHints.VALUE_ANTIALIAS_ON);
	        hints.put(RenderingHints.KEY_INTERPOLATION,
	                RenderingHints.VALUE_INTERPOLATION_BILINEAR);
	        hints.put(RenderingHints.KEY_RENDERING,
	                RenderingHints.VALUE_RENDER_QUALITY);
	        return hints;
	}
	private void combiner()
	{
		if(SLEEP==false)
		{
			CANVAS.imgs.clear();
			STATE = onTick(STATE); 
			STATE = stop(STATE);
		}
		
		STATE = toDraw(STATE);
		REPAINT_THREAD.run();
	}	
	public abstract State onTick(State s);
	public abstract State onKey(State s, String k);
	public abstract State onRelease(State s, String k);
	public abstract State onMouse(State s);
	public abstract State toDraw(State s);
	public abstract State stop(State s);
	
	protected void action() {        
        timer.start();
    }
	protected void sleep(int TIME) 
	{  
		timer.stop();
        
        try {
			Thread.sleep(TIME);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
        timer.start();
    }
	protected void pausePlay() 
	{  
		SLEEP = SLEEP ? false : true;
    }
	public void setPriority(String a)
	{
		REPAINT_THREAD.setPriority(Integer.parseInt(a));
		
		for(int x = 0; x<JRADIO_LIST.size(); x++)
		{
			if(JRADIO_LIST.get(x).getName().equals(a))
				JRADIO_LIST.get(x).setSelected(true);
		}
		
		DDB.setText("PRIORITY " + a);
	}
	public Image rotate(Image IMG, int DEG)
	{
		double RAD = ((double)DEG/180.0)*Math.PI;
		
		int WIDTH = new ImageIcon(IMG).getIconWidth();
		int HEIGHT = new ImageIcon(IMG).getIconHeight();	
		
	    BufferedImage BI = new BufferedImage(WIDTH, HEIGHT, TYPE);
	    Graphics2D g2d = BI.createGraphics();
	    g2d.setRenderingHints(hints);
        g2d.rotate(RAD, (double)WIDTH/2.0, (double)HEIGHT/2.0);
        g2d.drawImage(IMG, 0, 0, WIDTH, HEIGHT, null); 
        g2d.dispose();
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}
	public Image fillRect(int WIDTH, int HEIGHT, Color COLOR)
	{	
		BufferedImage BI = new BufferedImage(WIDTH, HEIGHT, TYPE);
	    Graphics2D g2d = BI.createGraphics();
	    g2d.setRenderingHints(hints);
	    g2d.setColor(COLOR);
        g2d.fillRect(0, 0, WIDTH, HEIGHT);
        g2d.dispose();
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}
	public Image drawRect(int WIDTH, int HEIGHT, Color COLOR)
	{		
		BufferedImage BI = new BufferedImage(WIDTH, HEIGHT, TYPE);
	    Graphics2D g2d = BI.createGraphics();
	    g2d.setRenderingHints(hints);
	    g2d.setColor(COLOR);
        g2d.drawRect(0, 0, WIDTH, HEIGHT);
        g2d.dispose();
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}	
	public Image drawRounedRect(int WIDTH, int HEIGHT, int ARCH_WDITH, int ARCH_HEIGHT, Color COLOR)
	{		
		BufferedImage BI = new BufferedImage(WIDTH, HEIGHT, TYPE);
	    Graphics2D g2d = BI.createGraphics();
	    g2d.setRenderingHints(hints);
	    g2d.setColor(COLOR);
        g2d.drawRoundRect(0, 0, WIDTH, HEIGHT, ARCH_WDITH, ARCH_HEIGHT);
        g2d.dispose();
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}
	public Image fillRounedRect(int WIDTH, int HEIGHT, int ARCH_WDITH, int ARCH_HEIGHT, Color COLOR)
	{		
		BufferedImage BI = new BufferedImage(WIDTH, HEIGHT, TYPE);
	    Graphics2D g2d = BI.createGraphics();
	    g2d.setRenderingHints(hints);
	    g2d.setColor(COLOR);
        g2d.fillRoundRect(0, 0, WIDTH, HEIGHT, ARCH_WDITH, ARCH_HEIGHT);
        g2d.dispose();
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}
	public Image drawEllipse(int WIDTH, int HEIGHT, Color COLOR)
	{		
		BufferedImage BI = new BufferedImage(WIDTH, HEIGHT, TYPE);
	    Graphics2D g2d = BI.createGraphics();
	    g2d.setRenderingHints(hints);
	    g2d.setColor(COLOR);
        g2d.drawOval(0, 0, WIDTH, HEIGHT);
        g2d.dispose();
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}
	public Image fillEllipse(int WIDTH, int HEIGHT, Color COLOR)
	{		
		BufferedImage BI = new BufferedImage(WIDTH, HEIGHT, TYPE);
	    Graphics2D g2d = BI.createGraphics();
	    g2d.setRenderingHints(hints);
	    g2d.setColor(COLOR);
        g2d.fillOval(0, 0, WIDTH, HEIGHT);
        g2d.dispose();
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}
	public Image drawArc(int WIDTH, int HEIGHT, int ARC_START, int ARC_STOP, Color COLOR)
	{		
		BufferedImage BI = new BufferedImage(WIDTH*2, HEIGHT*2, TYPE);
	    Graphics2D g2d = BI.createGraphics();
	    g2d.setRenderingHints(hints);
	    g2d.setColor(COLOR);
        g2d.drawArc(0, 0, WIDTH, HEIGHT, ARC_START, ARC_STOP);
        g2d.dispose();
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}
	public Image fillArc(int WIDTH, int HEIGHT, int ARC_START, int ARC_STOP, Color COLOR)
	{		
		BufferedImage BI = new BufferedImage(WIDTH*2, HEIGHT*2, TYPE);
	    Graphics2D g2d = BI.createGraphics();
	    g2d.setRenderingHints(hints);
	    g2d.setColor(COLOR);
        g2d.fillArc(0, 0, WIDTH, HEIGHT, ARC_START, ARC_STOP);
        g2d.dispose();
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}
	public Image drawString(String STR, String FONT, String FORMAT, int SIZE, Color COLOR)
	{	
		int WIDTH = 0;
		int HEIGHT = 0;;
		int FONT_TYPE = 0;
		int X = 0;
		int Y = 0;
		
		if(FORMAT.toLowerCase().equals("plain"))
			FONT_TYPE = Font.PLAIN;
		if(FORMAT.toLowerCase().equals("bold"))
			FONT_TYPE = Font.BOLD;
		if(FORMAT.toLowerCase().equals("italic"))
			FONT_TYPE = Font.ITALIC;
		
		Font FT = new Font(FONT, FONT_TYPE, SIZE);
		FontMetrics F_METRICS = new JLabel().getFontMetrics(FT);
		
		WIDTH = F_METRICS.stringWidth(STR)+2;
		HEIGHT = F_METRICS.getAscent() + F_METRICS.getDescent();		
		X = 0;
		Y += F_METRICS.getAscent();
		
		BufferedImage BI = new BufferedImage(WIDTH, HEIGHT, TYPE);
	    Graphics2D g2d = BI.createGraphics();
	    g2d.setRenderingHints(hints);    
	    g2d.setFont(FT);
        	g2d.setColor(new Color(0,0,0,180));
        		g2d.drawString(STR, X+2, Y+1);
        	g2d.setColor(COLOR);
        		g2d.drawString(STR, X, Y);
        g2d.dispose();
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}	
	public Image resize(Image IMG, int PERCENT)
	{		
		int WIDTH = new ImageIcon(IMG).getIconWidth()*PERCENT/100;
		int HEIGHT = new ImageIcon(IMG).getIconHeight()*PERCENT/100;
		
	    BufferedImage BI = new BufferedImage(WIDTH, HEIGHT, TYPE);
	    Graphics2D g2d = BI.createGraphics();
   //   g2d.setRenderingHints(hints); //Disable to boost performance.
        g2d.drawImage(IMG.getScaledInstance(WIDTH, HEIGHT, SCALE_TYPE), 0, 0, null); 
        g2d.dispose();	
        
	    return Toolkit.getDefaultToolkit().createImage(BI.getSource());
	}

	@Override
	public void mouseMoved(MouseEvent e) {
		STATE = onMouse(STATE);
		
		MOUSE_DRAGGED = false;	MOUSE_RELEASED = false;
		MOUSE_PRESSED = false;	MOUSE_ENTERED = false;
		MOUSE_EXITED = false;	MOUSE_WHEEL = false;
		MOUSE_MOVED = true; 	MOUSE_CLICKED = false;
		
		BUTTON1 = (e.getButton() ==  MouseEvent.BUTTON1) ? true : false;
		BUTTON2 = (e.getButton() ==  MouseEvent.BUTTON2) ? true : false;
		BUTTON3 = (e.getButton() ==  MouseEvent.BUTTON3) ? true : false;
		NOBUTTON = (e.getButton() ==  MouseEvent.NOBUTTON) ? true : false;
		
		MOUSE_X = e.getX();
		MOUSE_Y = e.getY();
	}
	@Override
	public void mouseDragged(MouseEvent e) {
		STATE = onMouse(STATE);
		
		MOUSE_DRAGGED = true;	MOUSE_RELEASED = false;
		MOUSE_PRESSED = false;	MOUSE_ENTERED = false;
		MOUSE_EXITED = false;	MOUSE_WHEEL = false;
		MOUSE_MOVED = false; 	MOUSE_CLICKED = false;
		
		BUTTON1 = (e.getButton() ==  MouseEvent.BUTTON1) ? true : false;
		BUTTON2 = (e.getButton() ==  MouseEvent.BUTTON2) ? true : false;
		BUTTON3 = (e.getButton() ==  MouseEvent.BUTTON3) ? true : false;
		NOBUTTON = (e.getButton() ==  MouseEvent.NOBUTTON) ? true : false;
		
		MOUSE_X = e.getX();
		MOUSE_Y = e.getY();
	}
	@Override
	public void mouseClicked(MouseEvent e) {
		STATE = onMouse(STATE);
		
		MOUSE_DRAGGED = false;	MOUSE_RELEASED = false;
		MOUSE_PRESSED = false;	MOUSE_ENTERED = false;
		MOUSE_EXITED = false;	MOUSE_WHEEL = false;
		MOUSE_MOVED = false; 	MOUSE_CLICKED = true;
		
		BUTTON1 = (e.getButton() ==  MouseEvent.BUTTON1) ? true : false;
		BUTTON2 = (e.getButton() ==  MouseEvent.BUTTON2) ? true : false;
		BUTTON3 = (e.getButton() ==  MouseEvent.BUTTON3) ? true : false;
		NOBUTTON = (e.getButton() ==  MouseEvent.NOBUTTON) ? true : false;
		
		MOUSE_X = e.getX();
		MOUSE_Y = e.getY();
	}
	@Override
	public void mouseEntered(MouseEvent e) {
		STATE = onMouse(STATE);
		
		MOUSE_DRAGGED = false;	MOUSE_RELEASED = false;
		MOUSE_PRESSED = false;	MOUSE_ENTERED = true;
		MOUSE_EXITED = false;	MOUSE_WHEEL = false;
		MOUSE_MOVED = false; 	MOUSE_CLICKED = false;
		
		BUTTON1 = (e.getButton() ==  MouseEvent.BUTTON1) ? true : false;
		BUTTON2 = (e.getButton() ==  MouseEvent.BUTTON2) ? true : false;
		BUTTON3 = (e.getButton() ==  MouseEvent.BUTTON3) ? true : false;
		NOBUTTON = (e.getButton() ==  MouseEvent.NOBUTTON) ? true : false;
		
		MOUSE_X = e.getX();
		MOUSE_Y = e.getY();
	}
	@Override
	public void mouseExited(MouseEvent e) {
		STATE = onMouse(STATE);
		
		MOUSE_DRAGGED = false;	MOUSE_RELEASED = false;
		MOUSE_PRESSED = false;	MOUSE_ENTERED = false;
		MOUSE_EXITED = true;	MOUSE_WHEEL = false;
		MOUSE_MOVED = false; 	MOUSE_CLICKED = false;
		
		BUTTON1 = (e.getButton() ==  MouseEvent.BUTTON1) ? true : false;
		BUTTON2 = (e.getButton() ==  MouseEvent.BUTTON2) ? true : false;
		BUTTON3 = (e.getButton() ==  MouseEvent.BUTTON3) ? true : false;
		NOBUTTON = (e.getButton() ==  MouseEvent.NOBUTTON) ? true : false;;
		
		MOUSE_X = e.getX();
		MOUSE_Y = e.getY();
	}
	@Override
	public void mousePressed(MouseEvent e) {
		STATE = onMouse(STATE);
		
		MOUSE_DRAGGED = false;	MOUSE_RELEASED = false;
		MOUSE_PRESSED = true;	MOUSE_ENTERED = false;
		MOUSE_EXITED = false;	MOUSE_WHEEL = false;
		MOUSE_MOVED = false; 	MOUSE_CLICKED = false;
		
		BUTTON1 = (e.getButton() ==  MouseEvent.BUTTON1) ? true : false;
		BUTTON2 = (e.getButton() ==  MouseEvent.BUTTON2) ? true : false;
		BUTTON3 = (e.getButton() ==  MouseEvent.BUTTON3) ? true : false;
		NOBUTTON = (e.getButton() ==  MouseEvent.NOBUTTON) ? true : false;
		
		MOUSE_X = e.getX();
		MOUSE_Y = e.getY();
	}
	@Override
	public void mouseReleased(MouseEvent e) {
		STATE = onMouse(STATE);
		
		MOUSE_DRAGGED = false;	MOUSE_RELEASED = true;
		MOUSE_PRESSED = false;	MOUSE_ENTERED = false;
		MOUSE_EXITED = false;	MOUSE_WHEEL = false;
		MOUSE_MOVED = false; 	MOUSE_CLICKED = false;
		
		BUTTON1 = (e.getButton() ==  MouseEvent.BUTTON1) ? true : false;
		BUTTON2 = (e.getButton() ==  MouseEvent.BUTTON2) ? true : false;
		BUTTON3 = (e.getButton() ==  MouseEvent.BUTTON3) ? true : false;
		NOBUTTON = (e.getButton() ==  MouseEvent.NOBUTTON) ? true : false;
		
		MOUSE_X = e.getX();
		MOUSE_Y = e.getY();
	}
	@Override
	public void keyTyped(KeyEvent e) {}
	@Override
	public void keyPressed(KeyEvent e) {
		STATE = onKey(STATE, Character.toString(e.getKeyChar()));
		REPAINT_THREAD.run();	
	}
	@Override
	public void keyReleased(KeyEvent e) {
		STATE = onRelease(STATE, Character.toString(e.getKeyChar()));
	}
}

