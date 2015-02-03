/**
 * @(#)HideFrameTask.java
 *
 *
 * @author 
 * @version 1.00 2010/3/1
 */

import javax.swing.*;
import java.util.TimerTask;

class HideFrame extends TimerTask 
{
   JFrame frame;
   public HideFrame ( JFrame a) 
   {
    	this.frame = a;
   }
   public void run() 
   {
     frame.setVisible(false);
     frame = null;
     Runtime r = Runtime.getRuntime();
   }
}