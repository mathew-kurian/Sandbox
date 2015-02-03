/**
 * @(#)InsetBackground.java
 *
 *
 * @Mathew Kurian (Open Source File Used) 
 * @version 1.00 2010/2/15
 */


import java.awt.*;
import java.awt.geom.*;
import java.awt.image.*;
import java.io.*;
import java.net.*;
import javax.imageio.*;
import javax.swing.*;
import javax.swing.border.*;
 
public class InsetBackground implements Border {
    private final BufferedImage image;
 
    public InsetBackground(BufferedImage image) {
        this.image = image;
    }
 
    public void paintBorder(Component c, Graphics g, int x, int y, int width, int height) {
        x += (width-image.getWidth())/2;
        y += (height-image.getHeight())/2;
        ((Graphics2D) g).drawRenderedImage(image, AffineTransform.getTranslateInstance(x,y));
    }
 
    public Insets getBorderInsets(Component c) {
        return new Insets(0,0,0,0);
    }
 
    public boolean isBorderOpaque() {
        return true;
    }
       
    }
