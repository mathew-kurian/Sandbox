/**
 * @(#)HelpUI.java
 *
 *
 * @author 
 * @version 1.00 2010/3/12
 */

import java.awt.GridLayout;
import java.awt.BorderLayout;
import java.awt.GridBagLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.MouseListener;
import java.awt.event.MouseEvent;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.Component;
import java.awt.Font;
import java.awt.geom.RoundRectangle2D;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Rectangle2D;
import java.awt.Shape;
import java.awt.Graphics2D;
import java.awt.Graphics;

import java.io.FileReader;
import java.io.IOException;
import java.io.File;
import javax.swing.JFrame;
import javax.swing.JTree;
import javax.swing.JSplitPane;
import javax.swing.tree.*;
import javax.swing.JFormattedTextField;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JMenu;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.BoxLayout;
import javax.swing.SwingUtilities;
import javax.swing.border.*;
import javax.swing.SwingConstants;
import javax.swing.JOptionPane;
import javax.swing.border.Border;
import javax.swing.JRadioButtonMenuItem;
import javax.swing.ButtonGroup;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.plaf.basic.BasicTabbedPaneUI;

import javax.imageio.ImageIO;

import java.util.*;
import java.lang.Object;

public class HelpUI implements TreeSelectionListener{

	//JFrame	
	JFrame helpMain = new JFrame("Help");	
	
	//JPanel
	TransparentBackground mainPanel = new TransparentBackground(helpMain);
	ImagePanel innerShell = new ImagePanel("images\\helpui\\helpback.png");
	
	//JTabbedPane
	JTabbedPane helpTab = new JTabbedPane();
	
	//JButton
	JLabel OKButton = new JLabel(new ImageIcon(("images\\button\\BACK.png")));
	
	//JPanel
	JSplitPane helpPanel;// one row, 1 columns
	JPanel aboutPanel = new JPanel(new BorderLayout(3,1));// one row, 1 columns    
    JPanel internalPane = new JPanel ();
    
    public JLabel titleLabel = new JLabel("Help");
    public JLabel lineLabel = new JLabel("___________________"); 
    	
    public HelpUI help;
    
    public SplashScreenUI splash;
    
    /**********************/
 	JTree sideTree;
 	
 	public JPanel updatingPane = new JPanel();
    /************************/
    
    public ImageIcon openIcon = new ImageIcon("images//tree//open.png");
    public ImageIcon closedIcon = new ImageIcon("images//tree//closed.png");
    public ImageIcon tipIcon = new ImageIcon("images//tree//tips.png");
    
    public ImageIcon findSize = new ImageIcon("images\\button\\BACK.png");
    public ImageIcon edge = new ImageIcon("images\\credits\\edge.png");
    
    public JLabel edgeLabel = new JLabel(edge);
    
    public HelpUI(SplashScreenUI s) {    	
    	
		helpTab.setUI(new BasicTabbedPaneUI(){
      	protected void paintTabBackground(Graphics g,int tabPlacement,int tabIndex,int x,int y,int w,int h,boolean isSelected){}
      	protected void paintContentBorder(Graphics g,int tabPlacement,int selectedIndex){}
    	});
		
		/***************************************/
		DefaultMutableTreeNode base1 = new DefaultMutableTreeNode("Trivia");
    		DefaultMutableTreeNode child1 = new DefaultMutableTreeNode("History");    	
				base1.add(child1);
				
		DefaultMutableTreeNode child2 = new DefaultMutableTreeNode("Objective");
		DefaultMutableTreeNode child3 = new DefaultMutableTreeNode("Equipment");
		DefaultMutableTreeNode child4 = new DefaultMutableTreeNode("Preparation");
		DefaultMutableTreeNode child5 = new DefaultMutableTreeNode("Game Play");
		DefaultMutableTreeNode child21 = new DefaultMutableTreeNode("Limited Time");
		
		DefaultMutableTreeNode base2 = new DefaultMutableTreeNode("Banking");
			DefaultMutableTreeNode child6 = new DefaultMutableTreeNode("Bank");
			DefaultMutableTreeNode child7 = new DefaultMutableTreeNode("Banker");
			DefaultMutableTreeNode child8 = new DefaultMutableTreeNode("Bankruptcy");
				base2.add(child6);
				base2.add(child7);
				base2.add(child8);
				
		DefaultMutableTreeNode base3 = new DefaultMutableTreeNode("Property");
			DefaultMutableTreeNode child9 = new DefaultMutableTreeNode("Property");
			DefaultMutableTreeNode child10 = new DefaultMutableTreeNode("Selling Property");
			DefaultMutableTreeNode child11 = new DefaultMutableTreeNode("Rent");
			DefaultMutableTreeNode child12 = new DefaultMutableTreeNode("Mortgage");
			DefaultMutableTreeNode child13 = new DefaultMutableTreeNode("Hotels");
			DefaultMutableTreeNode child14 = new DefaultMutableTreeNode("Houses");
				base3.add(child9);
				base3.add(child10);
				base3.add(child11);
				base3.add(child12);
				base3.add(child13);
				base3.add(child11);				
			
		DefaultMutableTreeNode base4 = new DefaultMutableTreeNode("Specials");
			DefaultMutableTreeNode child15 = new DefaultMutableTreeNode("Go");
			DefaultMutableTreeNode child16 = new DefaultMutableTreeNode("Cards");		
			DefaultMutableTreeNode child17 = new DefaultMutableTreeNode("Free Parking");
			DefaultMutableTreeNode child18 = new DefaultMutableTreeNode("Jail");
				base4.add(child15);	
				base4.add(child16);
				base4.add(child17);	
				base4.add(child18);	
				
		DefaultMutableTreeNode base5 = new DefaultMutableTreeNode("Miscellaneous");
			DefaultMutableTreeNode child19 = new DefaultMutableTreeNode("Tax");
			DefaultMutableTreeNode child20 = new DefaultMutableTreeNode("Other");
				base5.add(child19);	
				base5.add(child20);	
		
		DefaultMutableTreeNode fullBase = new DefaultMutableTreeNode("Help");
		fullBase.add(base1);
		fullBase.add(child2);
		fullBase.add(child3);
		fullBase.add(child4);
		fullBase.add(child5);
		fullBase.add(child21);
		fullBase.add(base2);
		fullBase.add(base3);
		fullBase.add(base4);
		fullBase.add(base5);				
		
		sideTree = new JTree(fullBase);
		sideTree.addTreeSelectionListener(this);
				
		DefaultTreeCellRenderer renderer = 	new DefaultTreeCellRenderer();
		renderer.setClosedIcon(closedIcon);
		renderer.setOpenIcon(openIcon);
		renderer.setLeafIcon(tipIcon);
    	sideTree.setCellRenderer(renderer);
		renderer.setOpaque(false);
		  		
		updatingPane.setLayout(new GridLayout(1,1));
		internalPane.setLayout(new BoxLayout(internalPane, BoxLayout.Y_AXIS));
		
		internalPane.setBackground(Color.WHITE);
				
		updatingPane.add(internalPane);
		
		JScrollPane sideScroll = new JScrollPane(sideTree);		
		sideScroll.getViewport().setOpaque(false);	
		sideScroll.setBorder(null);
		sideScroll.setOpaque(false);
		
		sideTree.setOpaque(true);
			
		helpPanel = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, sideScroll, updatingPane);
    	helpPanel.setOneTouchExpandable(true);
		helpPanel.setDividerLocation(150);
				
		titleLabel.setAlignmentX(Component.LEFT_ALIGNMENT);
		titleLabel.setFont(new Font("Calibri", Font.BOLD, 15));
		titleLabel.setForeground(new Color(0, 129, 255));
		
		lineLabel.setAlignmentX(Component.LEFT_ALIGNMENT);
		lineLabel.setFont(new Font("Calibri", Font.BOLD, 15));
		lineLabel.setForeground(new Color(0, 129, 255));
		/*****************************************/
				
    	splash = s;
    	help = this;
    	
    	helpTab.addTab("Help", helpPanel);
    	helpTab.addTab("About", aboutPanel);
    	    	
		OKButton.addMouseListener(new MouseListener() {
                
        public void mouseClicked(MouseEvent e) {
  			   					
        }        
        public void mouseExited(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\BACK.png")));
  			((JLabel)e.getSource()).repaint();
        }
        public void mousePressed(MouseEvent e) {        
  			((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\BACK_click.png")));
  			((JLabel)e.getSource()).repaint();
  			 
        }
        public void mouseReleased(MouseEvent e) {
        
        	((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\BACK.png")));
  			((JLabel)e.getSource()).repaint();
  			
  				help.hideMe();
    			splash.showMe();
        }
        public void mouseEntered(MouseEvent e) {
       		((JLabel)e.getSource()).setIcon(new ImageIcon(("images\\button\\BACK_over.png")));
  			((JLabel)e.getSource()).repaint();
  			
       	}
        });
    	
    	createAndShowGUI();
    }
    public void createAndShowGUI()
    {    
    	OKButton.setBounds(435, 460, findSize.getIconWidth(), findSize.getIconHeight());    	
    	helpTab.setBounds(188, 50, 445, 412);
    	edgeLabel.setBounds(25, 70, 165, 392);
    	    	
    	updatingPane.setOpaque(false);
  		helpTab.setOpaque(false);
    	aboutPanel.setOpaque(false);
    	mainPanel.setOpaque(false);
    	innerShell.setOpaque(false);
    	internalPane.setOpaque(false);
    	helpPanel.setOpaque(false);
    	
    //	helpPanel.setBackground(Color.BLACK);
    	
    	innerShell.add(helpTab);
    	innerShell.add(OKButton);
    	innerShell.add(edgeLabel);
    	
    	mainPanel.add(innerShell);
    	    	
    	helpMain.setContentPane(mainPanel);
		helpMain.setResizable(true);
		helpMain.setUndecorated(true);
		helpMain.setSize(innerShell.getSize());
		helpMain.setAlwaysOnTop(true);
		helpMain.setLocationRelativeTo(null);
		helpMain.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
    public void hideMe()
    {
    	helpMain.hide();
    	
    }
    public void showMe()
    {
    	helpMain.show();     	
    }
     public void valueChanged(TreeSelectionEvent event) 
   	{
       /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("History"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("intro.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
       /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Objective"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("objective.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);
		IntroScroll.setBorder(null);
				
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
       /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Equipment"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("equipment.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
       /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Preparation"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("preparation.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
       /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Game Play"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("game_play.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
       /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Bank"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("bank.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
       /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Banker"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("banker.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
       /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Bankruptcy"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("bankruptcy.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
        /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Property"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("property.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
        /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Selling Property"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("selling_property.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
        /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Rent"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("rent.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
        /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Mortgage"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("mortgage.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
        /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Hotels"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("hotels.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
        /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Houses"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("houses.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
        /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Go"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("go.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
        /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Cards"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("chance_community_chest.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
        /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Free Parking"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("free_parking.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
        /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Jail"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("jail.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
       /***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Tax"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("tax.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }/***********************************************************************************************************************************/
       if(sideTree.getLastSelectedPathComponent().toString().equals("Other"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("misc.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
          if(sideTree.getLastSelectedPathComponent().toString().equals("Limited Time"))
       {
       	System.out.println (sideTree.getLastSelectedPathComponent().toString());
       		//TextArea
    	JTextArea Intro = new JTextArea();
		Intro.setEditable(false);
		Intro.setLineWrap(true);  Intro.setWrapStyleWord(true); //FIX
		Intro.setOpaque(false); Intro.setBorder(null); //FIX
		Intro.setFont(new Font("Calibri", Font.BOLD, 11));
		Intro.setForeground(Color.BLACK);
		Intro.setSize(20,50);
		try{Intro.read(new FileReader("short.txt"),null);}catch(IOException ie){}
					
		//ScrollPane
		JScrollPane IntroScroll = new JScrollPane(Intro);
		IntroScroll.getViewport().setOpaque(false);  IntroScroll.setOpaque(false);		IntroScroll.setBorder(null);
		
		internalPane.removeAll();
		titleLabel.setText(sideTree.getLastSelectedPathComponent().toString()+ " in MONOPOLY");
		internalPane.add(titleLabel);		internalPane.add(lineLabel);
		internalPane.add(IntroScroll);
		internalPane.validate();
		internalPane.repaint();
				
		helpPanel.validate();
		helpPanel.repaint();
		
		helpTab.validate();
		helpTab.repaint();
       }
        
      }
  }
