/**
 * @(#)ClearBackground.java
 *
 *
 * @author 
 * @version 1.00 2010/2/28
 */

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;

public class ClearBackground extends JComponent { 
    private JFrame frame; 
    private Image background;

public ClearBackground(JFrame frame) {
    this.frame = frame;
    updateBackground( );
}

public void updateBackground( ) {
    try {
        Robot rbt = new Robot( );
        Toolkit tk = Toolkit.getDefaultToolkit( );
        Dimension dim = tk.getScreenSize( );
        background = rbt.createScreenCapture(
        new Rectangle(0,0,(int)dim.getWidth( ),
                          (int)dim.getHeight( )));
    } catch (Exception ex) {
        
    }
}
public void paintComponent(Graphics g) {
    Point pos = this.getLocationOnScreen( );
    Point offset = new Point(-pos.x,-pos.y);
    g.drawImage(background,offset.x,offset.y,null);
}
}