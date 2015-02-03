/**
 * @(#)PropertyReader.java
 *
 *
 * @Mathew Kurian 
 * @version 1.00 2010/2/17
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
import javax.swing.JTextArea;
import javax.swing.JMenuItem;
import javax.swing.JMenu;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.BoxLayout;
import javax.swing.SwingUtilities;
import javax.swing.SwingConstants;
import javax.swing.JOptionPane;

import java.io.PrintWriter;
import java.io.IOException;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.*;

import java.util.Scanner;
import java.util.ArrayList;

import java.lang.Object;

public class PropertyReader {
	
    /*public FileInputStream readInput = null;
    public FileReader readMe = null;
    public BufferedReader readIn = null;*/
	public Scanner kb = null;
	
	ArrayList <String> nameList = new ArrayList <String>();
	ArrayList <Integer> positionList = new ArrayList <Integer>();
	ArrayList <Integer> rentList = new ArrayList <Integer>();
	ArrayList <Integer>  priceList = new ArrayList <Integer>();
	ArrayList <String> groupList = new ArrayList <String>();
	
    public PropertyReader() 
    {        
    		String read = "Formed";
    }
    public void populateAll()
    {
    	populateGroup();
    	populateName();
    	populatePosition();
    	populatePrice();
    	populateRent();
    }
    public void populateName()
    {
    	try{
    			kb = new Scanner (new File("PropertiesData.MKONE"));
    		}
    	catch(IOException e)
    		{
    			JOptionPane.showMessageDialog(null,"File Reader Error (Source: PropertyReader.java [PropertyReader()])", "Warning", JOptionPane.WARNING_MESSAGE);
    		}	
    	while (kb.hasNext())
            {
                nameList.add(kb.nextLine());
                kb.nextLine();                 
                kb.nextLine();
                kb.nextLine();
                kb.nextLine();                        
            }
        kb.close();
    }
    public void populatePosition()
    {
    	try{
    			kb = new Scanner (new File("PropertiesData.MKONE"));
    		}
    	catch(IOException e)
    		{
    			JOptionPane.showMessageDialog(null,"File Reader Error (Source: PropertyReader.java [PropertyReader()])", "Warning", JOptionPane.WARNING_MESSAGE);
    		}
    	while (kb.hasNext())
            {
                kb.nextLine(); 
                positionList.add(Integer.parseInt(kb.nextLine()));
                kb.nextLine();                
                kb.nextLine();
                kb.nextLine();                        
            }
            kb.close();
    }
    public void populatePrice()
    {
    	try{
    			kb = new Scanner (new File("PropertiesData.MKONE"));
    		}
    	catch(IOException e)
    		{
    			JOptionPane.showMessageDialog(null,"File Reader Error (Source: PropertyReader.java [PropertyReader()])", "Warning", JOptionPane.WARNING_MESSAGE);
    		}
    	while (kb.hasNext())
            {
                kb.nextLine(); 
                kb.nextLine();
                priceList.add(Integer.parseInt(kb.nextLine()));
                kb.nextLine();
                kb.nextLine();                        
            }
            kb.close();
    }
    public void populateRent()
    {
    	try{
    			kb = new Scanner (new File("PropertiesData.MKONE"));
    		}
    	catch(IOException e)
    		{
    			JOptionPane.showMessageDialog(null,"File Reader Error (Source: PropertyReader.java [PropertyReader()])", "Warning", JOptionPane.WARNING_MESSAGE);
    		}
    	while (kb.hasNext())
            {
                kb.nextLine(); 
                kb.nextLine();
                kb.nextLine();
                rentList.add(Integer.parseInt(kb.nextLine()));
                kb.nextLine();                        
            }
            kb.close();
    }
    public void populateGroup()
    {
    	try{
    			kb = new Scanner (new File("PropertiesData.MKONE"));
    		}
    	catch(IOException e)
    		{
    			JOptionPane.showMessageDialog(null,"File Reader Error (Source: PropertyReader.java [PropertyReader()])", "Warning", JOptionPane.WARNING_MESSAGE);
    		}
    	while (kb.hasNext())
            {
                kb.nextLine(); 
                kb.nextLine();
                kb.nextLine();
                kb.nextLine();
                groupList.add(kb.nextLine());                        
            }
            kb.close();
    }
    	public ArrayList<String> getNameArrayList()
    {
    	return nameList;
    }
        public ArrayList<Integer> getPositonArrayList()
    {
    	return positionList;
    }
        public ArrayList<Integer> getPriceArrayList()
    {
    	return priceList;
    }
        public ArrayList<Integer> getRentArrayList()
    {
    	return rentList;
    }
        public ArrayList<String> getGroupArrayList()
    {
    	return groupList;
    }
    
}