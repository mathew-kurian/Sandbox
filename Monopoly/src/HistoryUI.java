/**
 * @(#)HistoryUI.java
 *
 *
 * @Mathew Kurian 
 * @version 1.00 2010/2/16
 */

import java.awt.GridLayout;
import java.awt.BorderLayout;
import java.awt.GridBagLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.MouseListener;
import java.awt.event.MouseEvent;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.Component;
import java.awt.Font;
import java.awt.Toolkit;

import java.io.File;
import java.io.IOException;

import javax.swing.JFrame;
import javax.swing.JFormattedTextField;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JMenu;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.BoxLayout;
import javax.swing.SwingUtilities;
import javax.swing.border.*;
import javax.swing.SwingConstants;

import javax.imageio.ImageIO;

import java.util.*;
import java.lang.Object;

import java.text.SimpleDateFormat;

public class HistoryUI extends JFrame{
	
	public JFrame HistoryFrame = new JFrame("History");
	public JPanel HistoryPanel = new JPanel(new GridBagLayout());
	public JTextArea HistoryText= new JTextArea(25,25);
	public Date Today;
	public SimpleDateFormat TimeFormat;	
	public String TimeStamp;
	public JScrollPane HistoryScroll;
			
    public HistoryUI() {
    	 
    	HistoryPanel.setLayout(new BoxLayout(HistoryPanel, BoxLayout.Y_AXIS));
    	   	
    	//TextArea
		HistoryText.setEditable(false);
		HistoryText.setLineWrap(true);
		HistoryText.setOpaque(false);
		HistoryText.setFont(new Font("Arial", Font.BOLD, 14));
		HistoryText.setForeground(Color.WHITE);
					
		//ScrollPane and add background
		HistoryScroll = new JScrollPane(HistoryText);
		HistoryScroll.getViewport().setOpaque(false);
		try{HistoryScroll.setViewportBorder(new InsetBackground(ImageIO.read(new File("images\\paper\\history_background.png"))));}catch (IOException e) {        }
		
		HistoryPanel.add(HistoryScroll);
		this.createAndShowGUI();
    }
    public void createAndShowGUI()
    {
    	Toolkit tk = Toolkit.getDefaultToolkit();
		Dimension screenSize = tk.getScreenSize();
		final int width = screenSize.width;
		final int height = screenSize.height;
		
    	HistoryFrame.setContentPane(HistoryPanel);
		HistoryFrame.setUndecorated(false);
		HistoryFrame.setAlwaysOnTop(true);
		HistoryFrame.setDefaultCloseOperation(EXIT_ON_CLOSE);		
		HistoryFrame.pack();
		HistoryFrame.setResizable(false);
		HistoryFrame.setLocation(width/8, height/8);
		
		/////////////////////////ADD SET VISIBLE TO SHOW
    }
    public void addHistory(String a)
    {
    	TimeFormat = new SimpleDateFormat("hh.mm.ss");
		Today = new Date();
		TimeStamp = TimeFormat.format(Today);
		
    //	HistoryText.append("\n"+"<html>" + "<img src=\"file:\\C:\\Users\\MKone\\Desktop\\Monopoly\\images\\history.png\">" + "</html>" + TimeStamp + ": " + a);
    	HistoryText.append("\n"+ TimeStamp + ": " + a);
    	
        HistoryText.setCaretPosition(HistoryText.getDocument().getLength());
    		
    }
    
    
}