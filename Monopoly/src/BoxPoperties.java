/**
 * @(#)BoxPoperties.java
 *
 *
 * @Mathew Kurian
 * @version 1.00 2010/2/13
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

public class BoxPoperties {
	
	public String name;

	public ArrayList<JLabel> SubObjects = new ArrayList<JLabel>();
	public ArrayList<JLabel> ExtrasObjects = new ArrayList<JLabel>();
	
	public ImageIcon GoStart = new ImageIcon("images\\extras\\go_start.jpg");
	public ImageIcon CommChestSouth = new ImageIcon("images\\extras\\comm_chest_south.jpg");
    public ImageIcon InTax = new ImageIcon("images\\extras\\income_tax.jpg");
    public ImageIcon ReadRail = new ImageIcon("images\\extras\\reading_railraod.jpg");
    public ImageIcon ChanceSouth = new ImageIcon("images\\extras\\chance_red.jpg");
    public ImageIcon Jail = new ImageIcon("images\\extras\\in_just_visiting_in_jail.jpg");
    public ImageIcon ELCompany = new ImageIcon("images\\extras\\electric_avenue.jpg");
    public ImageIcon PARailroad = new ImageIcon("images\\extras\\penn_railroad.jpg");
    public ImageIcon CommChestWest = new ImageIcon("images\\extras\\com_chest_west.jpg");
    public ImageIcon FreeParking = new ImageIcon("images\\extras\\free_parking.jpg");
    public ImageIcon ChanceNorth = new ImageIcon("images\\extras\\chance_blue.jpg");
    public ImageIcon BRail = new ImageIcon("images\\extras\\BO_railroad.jpg");
    public ImageIcon WWorks = new ImageIcon("images\\extras\\waterworks.jpg");
    public ImageIcon GoToJail = new ImageIcon("images\\extras\\go_to_jail.jpg");
    public ImageIcon CommChestEast = new ImageIcon("images\\extras\\com_chest_east.jpg");
	public ImageIcon ShortLine = new ImageIcon("images\\extras\\short_line.jpg");
    public ImageIcon ChanceEast = new ImageIcon("images\\extras\\chance_red.jpg");
    public ImageIcon LuxTax = new ImageIcon("images\\extras\\luxury_tax.jpg");
    	
	public ImageIcon AtlanticAvenue = new ImageIcon("images\\deeds\\atlantic_avenue.jpg");
    public ImageIcon BalticAvenue = new ImageIcon("images\\deeds\\baltic_avenue.jpg");
    public ImageIcon ConnecticutAvenue = new ImageIcon("images\\deeds\\connecticut_avenue.jpg");
    public ImageIcon IllinoisAvenue = new ImageIcon("images\\deeds\\illinois_avenue.jpg");
    public ImageIcon IndianaAvenue = new ImageIcon("images\\deeds\\indiana_avenue.jpg");
    public ImageIcon KentuckyAvenue = new ImageIcon("images\\deeds\\kentucky_avenue.jpg");
    public ImageIcon MarvinGardens = new ImageIcon("images\\deeds\\marvin_gardens.jpg");
    public ImageIcon MedAvenue = new ImageIcon("images\\deeds\\med_avenue.jpg");
    public ImageIcon NorthCarolinaAvenue = new ImageIcon("images\\deeds\\nc_avenue.jpg");
    public ImageIcon NewYorkAvenue = new ImageIcon("images\\deeds\\newyork_avenue.jpg");
    public ImageIcon OrientalAvenue = new ImageIcon("images\\deeds\\oriental_avenue.jpg");
    public ImageIcon PacificAvenue = new ImageIcon("images\\deeds\\pacific_avenue.jpg");
    public ImageIcon ParkPlace1 = new ImageIcon("images\\deeds\\park_place_1.jpg");
    public ImageIcon ParkPlace2 = new ImageIcon("images\\deeds\\park_place_2.jpg");
    public ImageIcon PennsylvaniaAvenue = new ImageIcon("images\\deeds\\penn_avenue.jpg");
    public ImageIcon StCharlesPlace = new ImageIcon("images\\deeds\\st_charles_place.jpg");
    public ImageIcon StJamesPlace = new ImageIcon("images\\deeds\\st_james_place.jpg");
    public ImageIcon StatesAvenue = new ImageIcon("images\\deeds\\states_avenue.jpg");
    public ImageIcon TennesseeAvenue = new ImageIcon("images\\deeds\\tennessee_avenue.jpg");
    public ImageIcon VentorAvenue = new ImageIcon("images\\deeds\\ventor_avenue.jpg");
    public ImageIcon VermontAvenue = new ImageIcon("images\\deeds\\vermont_avenue.jpg");
    public ImageIcon VirginiaAvenue = new ImageIcon("images\\deeds\\virginia_avenue.jpg");
    
    public ImageIcon Center = new ImageIcon("images\\center.jpg");
    
    public BoxPoperties() 
    {    	    	
    	fillArraysDeeds();
    	fillArraysExtras();
    }
    
    public Component getLabel(String ab)
    {
    	name = ab;
    	
    	JLabel a = new JLabel(PennsylvaniaAvenue);
    	    	
    	if(name.equals("Mediterranean Avenue"))    			{   		a=(JLabel)SubObjects.get(0);    	}
    	else if(name.equals("Baltic Avenue"))    			{    		a=(JLabel)SubObjects.get(1);    	}
    	else if(name.equals("Oriental Avenue"))    			{    		a=(JLabel)SubObjects.get(2);		}
    	else if(name.equals("Vermont Avenue"))    			{    		a=(JLabel)SubObjects.get(3);    	}
    	else if(name.equals("Connecticut Avenue")) 			{    		a=(JLabel)SubObjects.get(4);    	}
    	else if(name.equals("St. Charles Place")) 	 		{    		a=(JLabel)SubObjects.get(5);    	}
    	else if(name.equals("States Avenue"))    			{    		a=(JLabel)SubObjects.get(6);    	}
    	else if(name.equals("Virginia Avenue"))    			{    		a=(JLabel)SubObjects.get(7);    	}
    	else if(name.equals("St. James Place"))    			{    		a=(JLabel)SubObjects.get(8);    	}
    	else if(name.equals("Tennessee Avenue"))   	 		{    		a=(JLabel)SubObjects.get(9);    	}
    	else if(name.equals("New York Avenue"))    			{    		a=(JLabel)SubObjects.get(10);    	}
    	else if(name.equals("Kentucky Avenue"))    			{    		a=(JLabel)SubObjects.get(11);    	}
    	else if(name.equals("Indiana Avenue"))    			{    		a=(JLabel)SubObjects.get(12);    	}
    	else if(name.equals("Illinois Avenue"))    			{    		a=(JLabel)SubObjects.get(13);    	}
    	else if(name.equals("Atlantic Avenue"))    			{    		a=(JLabel)SubObjects.get(14);    	}
    	else if(name.equals("Ventor Avenue"))    			{    		a=(JLabel)SubObjects.get(15);    	}
    	else if(name.equals("Marvin Gardens"))    			{    		a=(JLabel)SubObjects.get(16);    	}
    	else if(name.equals("Pacific Avenue"))    			{    		a=(JLabel)SubObjects.get(17);    	}
    	else if(name.equals("North Carolina Avenue"))		{     		a=(JLabel)SubObjects.get(18);    	}
    	else if(name.equals("Pennsylvania Avenue"))			{    		a=(JLabel)SubObjects.get(19);    	}
    	else if(name.equals("Park Place"))	    			{    		a=(JLabel)SubObjects.get(20);    	}
    	else if(name.equals("Boardwalk"))    				{    		a=(JLabel)SubObjects.get(21);    	}
    	else if(name.equals("Go Start"))    				{    		a=(JLabel)ExtrasObjects.get(0);    	}
    	else if(name.equals("Community Chest South"))		{    		a=(JLabel)ExtrasObjects.get(1);    	}
    	else if(name.equals("Income Tax"))    				{    		a=(JLabel)ExtrasObjects.get(2);    	}
    	else if(name.equals("Reading Railroad"))   			{    		a=(JLabel)ExtrasObjects.get(3);    	}		
    	else if(name.equals("Chance South"))    			{    		a=(JLabel)ExtrasObjects.get(4);    	}
    	else if(name.equals("Just Visiting or In Jail"))	{    		a=(JLabel)ExtrasObjects.get(5);    	}
    	else if(name.equals("Electric Company"))    		{    		a=(JLabel)ExtrasObjects.get(6);    	}
    	else if(name.equals("Pennsylvania Railroad"))		{    		a=(JLabel)ExtrasObjects.get(7);    	}
    	else if(name.equals("Community Chest West"))		{    		a=(JLabel)ExtrasObjects.get(8);    	}
    	else if(name.equals("Free Parking"))    			{    		a=(JLabel)ExtrasObjects.get(9);    	}
    	else if(name.equals("Chance North"))    			{    		a=(JLabel)ExtrasObjects.get(10);   	}
    	else if(name.equals("B and O Railroad"))   			{    		a=(JLabel)ExtrasObjects.get(11);   	}
    	else if(name.equals("Waterworks"))    				{    		a=(JLabel)ExtrasObjects.get(12);   	}
    	else if(name.equals("Go To Jail"))    				{    		a=(JLabel)ExtrasObjects.get(13);   	}
    	else if(name.equals("Community Chest East"))		{    		a=(JLabel)ExtrasObjects.get(14);   	}
    	else if(name.equals("Short Line"))    				{    		a=(JLabel)ExtrasObjects.get(15);    }
    	else if(name.equals("Chance East"))    				{    		a=(JLabel)ExtrasObjects.get(16);   	}
    	else if(name.equals("Luxury Tax"))    				{    		a=(JLabel)ExtrasObjects.get(17);   	}
    	else if(name.equals("Center"))    					{    		a=(JLabel)ExtrasObjects.get(18);   	}
        else        										{        	a = a;						        }	
    	
    	return a;
    }       
    public void fillArraysDeeds()
    {
       	JLabel AtlanticAvenueLabel = new JLabel(AtlanticAvenue);
    	JLabel BalticAvenueLabel = new JLabel(BalticAvenue);
    	JLabel ConnecticutAvenueLabel = new JLabel(ConnecticutAvenue);
    	JLabel IllinoisAvenuLabel = new JLabel(IllinoisAvenue);
    	JLabel IndianaAvenueLabel = new JLabel(IndianaAvenue);
    	JLabel KentuckyAvenueLabel = new JLabel(KentuckyAvenue);
    	JLabel MarvinGardensLabel = new JLabel(MarvinGardens);
    	JLabel MedAvenueLabel = new JLabel(MedAvenue); 
    	JLabel NorthCarolinaAvenueLabel = new JLabel(NorthCarolinaAvenue); 	
    	JLabel NewYorkAvenueLabel = new JLabel(NewYorkAvenue);
    	JLabel OrientalAvenueLabel = new JLabel(OrientalAvenue);
    	JLabel PacificAvenueLabel = new JLabel(PacificAvenue);
    	JLabel ParkPlace1Label = new JLabel(ParkPlace1);
    	JLabel ParkPlace2Label = new JLabel(ParkPlace2);
    	JLabel PennsylvaniaAvenueLabel = new JLabel(PennsylvaniaAvenue); 	
    	JLabel StCharlesPlacLabel = new JLabel(StCharlesPlace);
    	JLabel StJamesPlacLabele = new JLabel(StJamesPlace);
    	JLabel StatesAvenueLabel = new JLabel(StatesAvenue);
    	JLabel TennesseeAvenueLabel = new JLabel(TennesseeAvenue);
    	JLabel VentorAvenueLabel = new JLabel(VentorAvenue);
		JLabel VermontAvenueLabel = new JLabel(VermontAvenue);
    	JLabel VirginiaAvenueLabel = new JLabel(VirginiaAvenue);
    	
    	MedAvenueLabel.setName("Mediterranean Avenue");
    	BalticAvenueLabel.setName("Baltic Avenue");
    	OrientalAvenueLabel.setName("Oriental Avenue");    		
    	VermontAvenueLabel.setName("Vermont Avenue");
    	ConnecticutAvenueLabel.setName("Connecticut Avenue");
    	StCharlesPlacLabel.setName("St. Charles Place");
    	StatesAvenueLabel.setName("States Avenue");
    	VirginiaAvenueLabel.setName("Virginia Avenue");
    	StJamesPlacLabele.setName("St. James Place");
    	TennesseeAvenueLabel.setName("Tennessee Avenue"); 
    	NewYorkAvenueLabel.setName("New York Avenue");
    	KentuckyAvenueLabel.setName("Kentucky Avenue");
    	IndianaAvenueLabel.setName("Indiana Avenue");
    	IllinoisAvenuLabel.setName("Illinois Avenue");
    	AtlanticAvenueLabel.setName("Atlantic Avenue");
    	VentorAvenueLabel.setName("Ventor Avenue");
    	MarvinGardensLabel.setName("Marvin Gardens"); 
    	PacificAvenueLabel.setName("Pacific Avenue");	
    	NorthCarolinaAvenueLabel.setName("North Carolina Avenue");
    	PennsylvaniaAvenueLabel.setName("Pennsylvania Avenue");		
    	ParkPlace1Label.setName("Park Place");
    	ParkPlace2Label.setName("Boardwalk");
    	
    	SubObjects.add(MedAvenueLabel);
    	SubObjects.add(BalticAvenueLabel);
    	SubObjects.add(OrientalAvenueLabel);
    	SubObjects.add(VermontAvenueLabel);
    	SubObjects.add(ConnecticutAvenueLabel);
    	SubObjects.add(StCharlesPlacLabel);
    	SubObjects.add(StatesAvenueLabel);
    	SubObjects.add(VirginiaAvenueLabel);
    	SubObjects.add(StJamesPlacLabele);
    	SubObjects.add(TennesseeAvenueLabel);
    	SubObjects.add(NewYorkAvenueLabel);
    	SubObjects.add(KentuckyAvenueLabel);
    	SubObjects.add(IndianaAvenueLabel);
    	SubObjects.add(IllinoisAvenuLabel);
    	SubObjects.add(AtlanticAvenueLabel);
    	SubObjects.add(VentorAvenueLabel);
    	SubObjects.add(MarvinGardensLabel);
    	SubObjects.add(PacificAvenueLabel);
    	SubObjects.add(NorthCarolinaAvenueLabel);
    	SubObjects.add(PennsylvaniaAvenueLabel);
    	SubObjects.add(ParkPlace1Label);
    	SubObjects.add(ParkPlace2Label);
    	
    
    	/*.setName("Go Start");
    	.setName("Community Chest South");
    	.setName("Income Tax");
    	.setName("Reading Railroad");	
    	.setName("Chance South");
    	.setName("Just Visiting or In Jail");
    	.setName("Electric Company");
    	.setName("Pennsylvania Railroad");
    	.setName("Community Chest West");
    	.setName("Free Parking");
    	.setName("Chance North");
    	.setName("B and O Railroad");
    	.setName("Waterworks");
    	.setName("Go To Jail");
    	.setName("Community Chest East");
    	.setName("Short Line");
    	.setName("Chance East");
    	.setName("Luxury Tax");
    	.setName("Center");  					
        else        	*/							
    }
    
    public void fillArraysExtras()
    {
       	JLabel GoStartLabel = new JLabel(GoStart);
    	JLabel CommChestSouthLabel = new JLabel(CommChestSouth);
    	JLabel InTaxLabel = new JLabel(InTax);
    	JLabel ReadRailLabel = new JLabel(ReadRail);
    	JLabel ChanceSouthLabel = new JLabel(ChanceSouth);
    	JLabel JailLabel = new JLabel(Jail);
    	JLabel ELCompanyLabel = new JLabel(ELCompany);
    	JLabel PARailroadLabel = new JLabel(PARailroad); 
    	JLabel CommChestWestLabel = new JLabel(CommChestWest); 	
    	JLabel FreeParkingLabel = new JLabel(FreeParking);
    	JLabel ChanceNorthLabel = new JLabel(ChanceNorth);
    	JLabel BRailLabel = new JLabel(BRail);
    	JLabel WWorksLabel = new JLabel(WWorks);
    	JLabel GoToJailLabel = new JLabel(GoToJail);
    	JLabel CommChestEastLabel = new JLabel(CommChestEast); 	
    	JLabel ShortLineLabel = new JLabel(ShortLine);
    	JLabel ChanceEastLabel = new JLabel(ChanceEast);
    	JLabel LuxTaxLabel = new JLabel(LuxTax);
    	JLabel CenterLabel = new JLabel(Center);
    	
    	ExtrasObjects.add(GoStartLabel);
    	ExtrasObjects.add(CommChestSouthLabel);
    	ExtrasObjects.add(InTaxLabel);
    	ExtrasObjects.add(ReadRailLabel);
    	ExtrasObjects.add(ChanceSouthLabel);
    	ExtrasObjects.add(JailLabel);
    	ExtrasObjects.add(ELCompanyLabel);
    	ExtrasObjects.add(PARailroadLabel);
    	ExtrasObjects.add(CommChestWestLabel);
    	ExtrasObjects.add(FreeParkingLabel);
    	ExtrasObjects.add(ChanceNorthLabel);
    	ExtrasObjects.add(BRailLabel);
    	ExtrasObjects.add(WWorksLabel);
    	ExtrasObjects.add(GoToJailLabel);
    	ExtrasObjects.add(CommChestEastLabel);
    	ExtrasObjects.add(ShortLineLabel);
    	ExtrasObjects.add(ChanceEastLabel);
    	ExtrasObjects.add(LuxTaxLabel);
    	ExtrasObjects.add(CenterLabel);
    }
    
}