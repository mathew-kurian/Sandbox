/**
 * @(#)GlassMotionUI.java
 *
 *
 * @author 
 * @version 1.00 2010/2/14
 */
 
import java.awt.GridLayout;
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

import java.util.*;
import java.lang.Object;

public class GlassMotionUI {

	public JPanel glassPane = new JPanel(new GridLayout(1,1));
	public JLabel label = new JLabel("RANDOMAOFDASKLFNASDKLFNASDFNSDLKFJSDKL");
	
    public GlassMotionUI() {
 
    	glassPane.add(label);
    	   	
    }
    
    public Component getGlassPanel()
    {
    	return glassPane;
    }
    
    
    
}