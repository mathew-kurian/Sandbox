/**
 * @(#)quitListener.java
 *
 *
 * @Mathew Kurian
 * @version 1.00 2010/2/13
 */
 
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class QuitListener implements ActionListener {
    
    boolean toggle = true;

    public void actionPerformed(ActionEvent e) {  System.exit(0); }
  
  }