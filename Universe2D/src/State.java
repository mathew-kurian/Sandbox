import java.awt.Image;
import java.awt.Toolkit;

public class State {
	int spX = 0;
	int spY = 0;
	int astX = 0;
	int astY = 150;
	int frame = 0;
	
	int scale = 10;
	
	int deg = 0;
	
	Toolkit tool = Toolkit.getDefaultToolkit();
	
	Image bg = tool.getImage("res/test/bg.jpg");
	Image ast = tool.getImage("res/test/ast.png");
	Image ship = tool.getImage("res/test/ship.png");
	
	boolean direcX = false;
	boolean direcY = false;
	boolean scaleB = false;
	boolean pause = false;
}
