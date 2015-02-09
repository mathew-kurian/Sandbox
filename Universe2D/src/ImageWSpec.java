import java.awt.Image;


public class ImageWSpec{

	
	int x = 0;
	int y = 0;
	int width = 0;
	int height = 0;
	
	Image img;
	
	public ImageWSpec(Image img, int x, int y, int width, int height)
	{
		this.img = img;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
}
