/**
 * @(#)BoardPieces.java
 *
 *
 * @Mathew Kurian 
 * @version 1.00 2010/2/14
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

public class BoardPieces{

	//Center
    public ImageIcon center = new ImageIcon("images\\boards\\center3.png");
    
    //Corners
    public ImageIcon FreeParking = new ImageIcon("images\\corners\\free_parking.png");
    public ImageIcon GoToJail = new ImageIcon("images\\corners\\go_to_jail.png");
    public ImageIcon VisitOrJail = new ImageIcon("images\\corners\\in_just_visiting_in_jail.png");
    public ImageIcon Go = new ImageIcon("images\\corners\\go_start.png");
    
    //NorthEdge
    public ImageIcon KYAvenue = new ImageIcon("images\\upside down\\1_kentucky_avenue.png");
    public ImageIcon ChanceNorth = new ImageIcon("images\\upside down\\2_chance.png");
    public ImageIcon INAvenue = new ImageIcon("images\\upside down\\3_indiana_avenue.png");
    public ImageIcon ILAvenue = new ImageIcon("images\\upside down\\4_illinois_avenue.png");
    public ImageIcon Railroad = new ImageIcon("images\\upside down\\5_railroad.png");
    public ImageIcon ATAvenue = new ImageIcon("images\\upside down\\6_atlantic_avenue.png");
    public ImageIcon VEAvenue = new ImageIcon("images\\upside down\\7_ventor_avenue.png");
    public ImageIcon WWorks = new ImageIcon("images\\upside down\\8_waterworks.png");
    public ImageIcon MAGardens = new ImageIcon("images\\upside down\\9_marvin_gardens.png");
    
    //EastEdge
    public ImageIcon PAAvenue = new ImageIcon("images\\right\\1_pacific_avenue.png");
    public ImageIcon NCAvenue = new ImageIcon("images\\right\\2_north_carolina_avenue.png");
    public ImageIcon CommChestEast = new ImageIcon("images\\right\\3_community_chest.png");
    public ImageIcon PNAvenue = new ImageIcon("images\\right\\4_penn_avenue.png");
    public ImageIcon ShortLine = new ImageIcon("images\\right\\5_short_line.png");
    public ImageIcon ChanceEast = new ImageIcon("images\\right\\6_chance.png");
    public ImageIcon ParkPlace = new ImageIcon("images\\right\\7_park_place.png");
    public ImageIcon LXTax = new ImageIcon("images\\right\\8_luxury_tax.png");
    public ImageIcon BroadWalk = new ImageIcon("images\\right\\9_broadwalk.png");
    
    //WestEdge
    public ImageIcon NYAvenue = new ImageIcon("images\\left\\1_newyork_avenue.png");
    public ImageIcon TNAvenue = new ImageIcon("images\\left\\2_tenn_avenue.png");
    public ImageIcon CommChestWest = new ImageIcon("images\\left\\3_com_chest_west.png");
    public ImageIcon STJamesAvenue = new ImageIcon("images\\left\\4_st_james_place.png");
    public ImageIcon PNRail = new ImageIcon("images\\left\\5_penn_railroad.png");
    public ImageIcon VAAvenue = new ImageIcon("images\\left\\6_va_avenue.png");
    public ImageIcon STAvenue = new ImageIcon("images\\left\\7_states_avenue.png");
    public ImageIcon ELCompany = new ImageIcon("images\\left\\8_electric_avenue.png");
    public ImageIcon STCharlesAvenue = new ImageIcon("images\\left\\9_st_charles_place.png");
      	
    //SouthEdge
    public ImageIcon CNAvenue = new ImageIcon("images\\bottom\\1_conn_avenue.png");
    public ImageIcon VTAvenue = new ImageIcon("images\\bottom\\2_ver_avenue.png");
    public ImageIcon ChanceSouth = new ImageIcon("images\\bottom\\3_chance_south.png");
    public ImageIcon ORAvenue = new ImageIcon("images\\bottom\\4_orient_avenue.png");
    public ImageIcon ReadRailroad = new ImageIcon("images\\bottom\\5_reading_railraod.png");
    public ImageIcon INTax = new ImageIcon("images\\bottom\\6_income_tax.png");
    public ImageIcon BAAvenue = new ImageIcon("images\\bottom\\7_baltic_avenue.png");
    public ImageIcon CommChestSouth = new ImageIcon("images\\bottom\\8_comm_chest_south.png");
    public ImageIcon MEAvenue = new ImageIcon("images\\bottom\\9_medit_avenue.png");
        
    	//Corners
		ModJLabel FreeParkingLabel = new ModJLabel(FreeParking);
		ModJLabel GoToJailLabel = new ModJLabel(GoToJail);
		ModJLabel VisitOrJailLabel = new ModJLabel(VisitOrJail);
		ModJLabel GoLabel = new ModJLabel(Go);
				
		//NorthEdge Labels
    	ModJLabel KYAvenueLabel = new ModJLabel(KYAvenue);
    	ModJLabel ChanceNorthLabel = new ModJLabel(ChanceNorth);
    	ModJLabel INAvenueLabel = new ModJLabel(INAvenue);
    	ModJLabel ILAvenueLabel = new ModJLabel(ILAvenue);
    	ModJLabel RailroadLabel = new ModJLabel(Railroad);
    	ModJLabel ATAvenueLabel = new ModJLabel(ATAvenue);
    	ModJLabel VEAvenueLabel = new ModJLabel(VEAvenue);
    	ModJLabel WWorksLabel = new ModJLabel(WWorks); 
    	ModJLabel MAGardensLabel = new ModJLabel(MAGardens); 	
    	
    	//EastEdge Labels
    	ModJLabel PAAvenueLabel = new ModJLabel(PAAvenue);
    	ModJLabel NCAvenueLabel = new ModJLabel(NCAvenue);
    	ModJLabel CommChestEastLabel = new ModJLabel(CommChestEast);
    	ModJLabel PNAvenueLabel = new ModJLabel(PNAvenue);
    	ModJLabel ShortLineLabel = new ModJLabel(ShortLine);
    	ModJLabel ChanceEastLabel = new ModJLabel(ChanceEast);
    	ModJLabel ParkPlaceLabel = new ModJLabel(ParkPlace);
    	ModJLabel LXTaxLabel = new ModJLabel(LXTax); 
    	ModJLabel BroadWalkLabel = new ModJLabel(BroadWalk);
    	
        //WestEdge Labels
    	ModJLabel NYAvenueLabel = new ModJLabel(NYAvenue);
    	ModJLabel TNAvenueLabel = new ModJLabel(TNAvenue);
    	ModJLabel CommChestWestLabelLabel = new ModJLabel(CommChestWest);
    	ModJLabel STJamesAvenueLabel = new ModJLabel(STJamesAvenue);
    	ModJLabel PNRailLabel = new ModJLabel(PNRail);
    	ModJLabel VAAvenueLabel = new ModJLabel(VAAvenue);
    	ModJLabel STAvenueLabel = new ModJLabel(STAvenue); 
    	ModJLabel ELCompanyLabel = new ModJLabel(ELCompany);
    	ModJLabel STCharlesAvenueLabel = new ModJLabel(STCharlesAvenue);
    	
    	//SouthEdge Labels
    	ModJLabel CNAvenueLabel = new ModJLabel(CNAvenue);
    	ModJLabel VTAvenueLabel = new ModJLabel(VTAvenue);
    	ModJLabel ChanceSouthLabel = new ModJLabel(ChanceSouth);
    	ModJLabel ORAvenueLabel = new ModJLabel(ORAvenue);
    	ModJLabel ReadRailroadLabel = new ModJLabel(ReadRailroad);
    	ModJLabel INTaxLabel = new ModJLabel(INTax);
    	ModJLabel BAAvenueLabel = new ModJLabel(BAAvenue);
    	ModJLabel CommChestSouthLabel = new ModJLabel(CommChestSouth); 
    	ModJLabel MEAvenueLabel = new ModJLabel(MEAvenue); 
    		
    	ModJLabel CenterLabel = new ModJLabel(center);
    
    public BoardPieces() {
    	    		    	
    	//NorthEdge Label Names
    	KYAvenueLabel.setName("Kentucky Avenue");  
		ChanceNorthLabel.setName("Chance North");  
		INAvenueLabel.setName("Indiana Avenue");  
		ILAvenueLabel.setName("Illinois Avenue");
		RailroadLabel.setName("B and O Railroad");
		ATAvenueLabel.setName("Atlantic Avenue");		
    	VEAvenueLabel.setName("Ventor Avenue");
    	WWorksLabel.setName("Waterworks");
    	MAGardensLabel.setName("Marvin Gardens");
    	
    	//EastEdge Label Names
    	PAAvenueLabel.setName("Pacific Avenue");  
		NCAvenueLabel.setName("North Carolina Avenue");  
		CommChestEastLabel.setName("Community Chest East");  
		PNAvenueLabel.setName("Pennsylvania Avenue");
		ShortLineLabel.setName("Short Line");
		ChanceEastLabel.setName("Chance East");		
    	ParkPlaceLabel.setName("Park Place");
    	LXTaxLabel.setName("Luxury Tax");
    	BroadWalkLabel.setName("Boardwalk");
    	
    	//Corners
    	FreeParkingLabel.setName("Free Parking"); 
    	GoToJailLabel.setName("Go To Jail");
    	VisitOrJailLabel.setName("Just Visiting or In Jail"); 
    	GoLabel.setName("Go Start");
    	
    	//SouthEdge Label Names
    	CNAvenueLabel.setName("Connecticut Avenue");  
		VTAvenueLabel.setName("Vermont Avenue");  
		ChanceSouthLabel.setName("Chance South");  
		ORAvenueLabel.setName("Oriental Avenue");
		ReadRailroadLabel.setName("Reading Railroad");
		INTaxLabel.setName("Income Tax");		
    	BAAvenueLabel.setName("Baltic Avenue");
    	CommChestSouthLabel.setName("Community Chest South");
    	MEAvenueLabel.setName("Mediterranean Avenue");
    	
    	//WestEdge Label Names
    	NYAvenueLabel.setName("New York Avenue");  
		TNAvenueLabel.setName("Tennessee Avenue");  
		CommChestWestLabelLabel.setName("Community Chest West");  
		STJamesAvenueLabel.setName("St. James Place");
		PNRailLabel.setName("Pennsylvania Railroad");
		VAAvenueLabel.setName("Virginia Avenue");		
    	STAvenueLabel.setName("States Avenue");
    	ELCompanyLabel.setName("Electric Company");
    	STCharlesAvenueLabel.setName("St. Charles Place");
    	    	
    	//NorthEdge Label Names
    	KYAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\upside down\\1_kentucky_avenue.png\">" + "</html>"); 
		ChanceNorthLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\upside down\\2_chance.png\">" + "</html>");
		INAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\upside down\\3_indiana_avenue.png\">" + "</html>");
		ILAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\upside down\\4_illinois_avenue.png\">" + "</html>");
		RailroadLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\upside down\\5_railroad.png\">" + "</html>");
		ATAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\upside down\\6_atlantic_avenue.png\">" + "</html>");
    	VEAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\upside down\\7_ventor_avenue.png\">" + "</html>");
    	WWorksLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\upside down\\8_waterworks.png\">" + "</html>");
    	MAGardensLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\upside down\\9_marvin_gardens.png\">" + "</html>");    	 	
    	
    	//EastEdge Label Names
    	PAAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\right\\1_pacific_avenue.png\">" + "</html>");
		NCAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\right\\2_north_carolina_avenue.png\">" + "</html>");  
		CommChestEastLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\right\\3_community_chest.png\">" + "</html>");
		PNAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\right\\4_penn_avenue.png\">" + "</html>");
		ShortLineLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\right\\5_short_line.png\">" + "</html>");
		ChanceEastLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\right\\6_chance.png\">" + "</html>");		
    	ParkPlaceLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\right\\7_park_place.png\">" + "</html>");
    	LXTaxLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\right\\8_luxury_tax.png\">" + "</html>");
    	BroadWalkLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\right\\9_broadwalk.png\">" + "</html>");
      	
    	//Corners
    	FreeParkingLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\corners\\free_parking.png\">" + "</html>");
    	GoToJailLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\corners\\go_to_jail.png\">" + "</html>");
    	VisitOrJailLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\corners\\in_just_visiting_in_jail.png\">" + "</html>");
    	GoLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\corners\\go_start.png\">" + "</html>");
    	
    	//SouthEdge Label Names
    	CNAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\bottom\\1_conn_avenue.png\">" + "</html>"); 
		VTAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\bottom\\2_ver_avenue.png\">" + "</html>");
		ChanceSouthLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\bottom\\3_chance_south.png\">" + "</html>");
		ORAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\bottom\\4_orient_avenue.png\">" + "</html>");
		ReadRailroadLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\bottom\\5_reading_railraod.png\">" + "</html>");
		INTaxLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\bottom\\6_income_tax.png\">" + "</html>");		
    	BAAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\bottom\\7_baltic_avenue.png\">" + "</html>");
    	CommChestSouthLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\bottom\\8_comm_chest_south.png\">" + "</html>");
    	MEAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\bottom\\9_medit_avenue.png\">" + "</html>");
    	
    	//WestEdge Label Names
    	NYAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\left\\1_newyork_avenue.png\">" + "</html>");
		TNAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\left\\2_tenn_avenue.png\">" + "</html>");
		CommChestWestLabelLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\left\\3_com_chest_west.png\">" + "</html>");  
		STJamesAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\left\\4_st_james_place.png\">" + "</html>");
		PNRailLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\left\\5_penn_railroad.png\">" + "</html>");
		VAAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\left\\6_va_avenue.png\">" + "</html>");
    	STAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\left\\7_states_avenue.png\">" + "</html>");
    	ELCompanyLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\left\\8_electric_avenue.png\">" + "</html>");
    	STCharlesAvenueLabel.setToolTipText("<html>" + "<img src=\"file:images\\xxl\\left\\9_st_charles_place.png\">" + "</html>");
  
    }
  public ArrayList<ModJLabel> getEdge(String side)
    {
   	 ArrayList <ModJLabel> edge = new ArrayList<ModJLabel>();
    	
    	edge.add(CenterLabel);
    	
    	if (side.equals("north"))
    	{
    		edge.add(FreeParkingLabel);
			edge.add(KYAvenueLabel);
			edge.add(ChanceNorthLabel);
			edge.add(INAvenueLabel);
			edge.add(ILAvenueLabel);
			edge.add(RailroadLabel);
			edge.add(ATAvenueLabel);
			edge.add(VEAvenueLabel);
			edge.add(WWorksLabel);
			edge.add(MAGardensLabel);
			edge.add(GoToJailLabel);
    	}
    	else if (side.equals("east"))
    	{
    		edge.add(PAAvenueLabel);
			edge.add(NCAvenueLabel);
			edge.add(CommChestEastLabel);
			edge.add(PNAvenueLabel);
			edge.add(ShortLineLabel);
			edge.add(ChanceEastLabel);
			edge.add(ParkPlaceLabel);
			edge.add(LXTaxLabel);
			edge.add(BroadWalkLabel);
    	}
    	else if (side.equals("west"))
    	{
    		
    		edge.add(NYAvenueLabel);
			edge.add(TNAvenueLabel);
			edge.add(CommChestWestLabelLabel);
			edge.add(STJamesAvenueLabel);
			edge.add(PNRailLabel);
			edge.add(VAAvenueLabel);
			edge.add(STAvenueLabel);
			edge.add(ELCompanyLabel);
			edge.add(STCharlesAvenueLabel);
    	}
    	else if (side.equals("south"))
    	{
    	
    		edge.add(VisitOrJailLabel);	    	
			edge.add(CNAvenueLabel);
			edge.add(VTAvenueLabel);
			edge.add(ChanceSouthLabel);
			edge.add(ORAvenueLabel);
			edge.add(ReadRailroadLabel);
			edge.add(INTaxLabel);
			edge.add(BAAvenueLabel);
			edge.add(CommChestSouthLabel);
			edge.add(MEAvenueLabel);
			edge.add(GoLabel);
    	}
    	else
    	{
    		edge.add(CenterLabel);
    	}
    	
    	return edge;
    }
   
}