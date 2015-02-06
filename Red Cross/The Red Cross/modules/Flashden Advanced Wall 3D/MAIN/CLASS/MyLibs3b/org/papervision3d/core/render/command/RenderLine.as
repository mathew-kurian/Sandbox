package org.papervision3d.core.render.command
{
	
	/**
	 * @Author Ralph Hauwert
	 */
	 
	import flash.geom.Point;
	
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.math.Number2D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.render.data.RenderHitData;
	import org.papervision3d.core.render.data.RenderSessionData;
	import org.papervision3d.materials.special.LineMaterial;	
	public class RenderLine extends RenderableListItem implements IRenderListItem
	{
		
		public var line:Line3D;
		public var renderer:LineMaterial;
		
		// rather that create and clean up vector objects, we'll store all our temp working vectors as statics
		private static var lineVector:Number3D = Number3D.ZERO; 
		private static var mouseVector:Number3D = Number3D.ZERO; 
		
		public function RenderLine(line:Line3D)
		{
			super();
			this.renderable = Line3D;
			this.renderableInstance = line;
			this.line = line;
		}
		
		override public function render(renderSessionData:RenderSessionData):void
		{

			renderer.drawLine(line, renderSessionData.container.graphics, renderSessionData);
			
		}
		
		override public function hitTestPoint2D(point:Point, rhd:RenderHitData):RenderHitData
		{
			if(renderer.interactive)
			{
				var linewidth:Number = line.size; 
				
				var p:Number2D = new Number2D(point.x, point.y); 
				
				var l1:Number2D = new Number2D(line.v0.vertex3DInstance.x, line.v0.vertex3DInstance.y);
				var l2:Number2D = new Number2D(line.v1.vertex3DInstance.x, line.v1.vertex3DInstance.y);
		
				// get the vector for the line
				var v:Number2D = Number2D.subtract(l2, l1); 
				
				// magic formula for calculating how how far along the line a perpendicular 
				// coming from the line to the point would hit. If this number is between 0 and 1 
				// the point is closest to a part of the line that exists.
				var u:Number = (((p.x - l1.x)*(l2.x - l1.x)) + ((p.y-l1.y)*(l2.y - l1.y)))/((v.x*v.x)+(v.y*v.y)); 
				
				if((u>0)&&(u<1)) 
				{
				
					// so then to work out that collision point multiply v by u and add it to l1
					var cp:Number2D = Number2D.multiplyScalar(v, u); 
					cp = Number2D.add(cp, l1); 
					
					// then get the vector between the collision point and the mousepoint
					var dist:Number2D = Number2D.subtract(cp, p); 
					
					// and get the magnitude of that distance vector, squared
					var d:Number =  (dist.x*dist.x)+(dist.y*dist.y);
					
					// and if it's less than the linewidth squared we have a hit
					if(d<(linewidth*linewidth))
					{
						rhd.displayObject3D = line.instance; 
						rhd.material = renderer;
						rhd.renderable = line; 
						rhd.hasHit = true;
						
						//TODO UPDATE 3D hit point and UV
						// currently we're just moving u along the 3D line, but this isn't accurate.
						var cp3d:Number3D = new Number3D(line.v1.x-line.v0.x, line.v1.y-line.v0.y, line.v1.x-line.v0.x);
						cp3d.x*=u; 
						cp3d.y*=u; 
						cp3d.z*=u; 
						cp3d.x+=line.v0.x; 
						cp3d.y+=line.v0.y; 
						cp3d.z+=line.v0.z; 
						
						rhd.x = cp3d.x; 
						rhd.y = cp3d.y; 
						rhd.z = cp3d.z; 
						rhd.u = 0;
						rhd.v = 0; 
						return rhd; 
					}
					
				}
			}
			return rhd;
		}
		
		
		
	}
}