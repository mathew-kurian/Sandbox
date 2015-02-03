/**
 * @(#)ChanceCards.java
 *
 *
 * @author 
 * @version 1.00 2010/3/18
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

import javax.swing.JFrame;
import javax.swing.JFormattedTextField;
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

public class ChanceCards{

    public ImageIcon AdvanceGo = new ImageIcon("images\\chance\\adv_go.png");
    public ImageIcon AdvanceIllinois = new ImageIcon("images\\chance\\adv_ill.png");
    public ImageIcon AdvanceCharles = new ImageIcon("images\\chance\\adv_stch.png");
    public ImageIcon AdvanceRailRoad = new ImageIcon("images\\chance\\adv_rail.png");
    public ImageIcon AdvanceUtil = new ImageIcon("images\\chance\\adv_util.png");
    public ImageIcon WalkBoard = new ImageIcon("images\\chance\\board.png");
    public ImageIcon Bank = new ImageIcon("images\\chance\\div.png");
    public ImageIcon Fund = new ImageIcon("images\\chance\\fund.png");
    public ImageIcon Jail = new ImageIcon("images\\chance\\jail.png");
    public ImageIcon PayAll = new ImageIcon("images\\chance\\payall.png");
    public ImageIcon ParkFine = new ImageIcon("images\\chance\\pfine.png");
    public ImageIcon PoorTax = new ImageIcon("images\\chance\\ptax.png");
    public ImageIcon ReadRail = new ImageIcon("images\\chance\\rr.png");
    public ImageIcon SchoolTax  = new ImageIcon("images\\chance\\stax.png");
    	
    	JLabel AdvanceGoLabel = new JLabel(AdvanceGo);
    	JLabel AdvanceIllinoisLabel = new JLabel(AdvanceIllinois);
    	JLabel AdvanceCharlesLabel = new JLabel(AdvanceCharles);
    	JLabel AdvanceRailRoadLabel = new JLabel(AdvanceRailRoad);
    	JLabel AdvanceUtilLabel = new JLabel(AdvanceUtil);
    	JLabel WalkBoardLabel = new JLabel(WalkBoard);
    	JLabel BankLabel = new JLabel(Bank);     	
    	JLabel FundLabel = new JLabel(Fund);
    	JLabel JailLabel = new JLabel(Jail);
    	JLabel PayAllLabel = new JLabel(PayAll);
    	JLabel ParkFineLabel = new JLabel(ParkFine);
    	JLabel PoorTaxLabel = new JLabel(PoorTax);
    	JLabel ReadRailLabel = new JLabel(ReadRail);
    	JLabel SchoolTaxLabel = new JLabel(SchoolTax);    	
    
    public ChanceCards() {
       		    	
    
    	AdvanceGoLabel.setName("Advance to Go");  
		AdvanceIllinoisLabel.setName("Advance to Illinois Ave");  
		AdvanceRailRoadLabel.setName("Advance to nearest railroad");  
		AdvanceCharlesLabel.setName("Advance to St. Charles");
		AdvanceUtilLabel.setName("Advance to nearest utility");
		WalkBoardLabel.setName("Take a walk on the Boardwalk");		
    	BankLabel.setName("Bank pays you dividend of $50");
    	FundLabel.setName("Your Xmans fund matures collect $100");
    	JailLabel.setName("Get out of jail free");
    	PayAllLabel.setName("You are elected chairman of the board. Pay each player $50");  
		ParkFineLabel.setName("Parking fine $15");  
		PoorTaxLabel.setName("Pay poor tax of $15");  
		ReadRailLabel.setName("Take on the Reading Railroad");		
  		SchoolTaxLabel.setName("Pay the school tax of $150");	
    }
  public ArrayList<JLabel> getCardList()
    {
   	 
   	 ArrayList <JLabel> chanceCards = new ArrayList<JLabel>();
    	
    	chanceCards.add(AdvanceGoLabel);
    	chanceCards.add(AdvanceIllinoisLabel);
    	chanceCards.add(AdvanceRailRoadLabel);
    	chanceCards.add(AdvanceCharlesLabel);
    	chanceCards.add(AdvanceUtilLabel);
    	chanceCards.add(WalkBoardLabel);
    	chanceCards.add(BankLabel);
    	chanceCards.add(FundLabel);
    	chanceCards.add(JailLabel);
    	chanceCards.add(PayAllLabel);
    	chanceCards.add(ParkFineLabel);
    	chanceCards.add(PoorTaxLabel);
    	chanceCards.add(ReadRailLabel);
    	chanceCards.add(SchoolTaxLabel);
    	
    	return chanceCards;
    }
   
}