package org.papervision3d.core.math.util
{
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	
	public class Intersection
	{
		public static const NONE:int = 0;
		public static const INTERSECTION:int=1;
		public static const PARALLEL:int = 2;
		
		public var point:Number3D = new Number3D();
		public var vert:Vertex3D = new Vertex3D();
		public var alpha:Number = 0;
		public var status:int;
		
		public function Intersection()
		{
			
		}

		public static function linePlane(pA:Vertex3D, pB:Vertex3D, plane:Plane3D, e:Number=0.001):Intersection
		{
			var intersection:Intersection = new Intersection();
			var a:Number = plane.normal.x;
			var b:Number = plane.normal.y;
			var c:Number = plane.normal.z;
			var d:Number = plane.d;
			var x1:Number = pA.x;
			var y1:Number = pA.y;
			var z1:Number = pA.z;
			var x2:Number = pB.x;
			var y2:Number = pB.y;
			var z2:Number = pB.z;
			
			var r0:Number = (a * x1) + (b * y1) + (c * z1) + d;
			var r1:Number = a*(x1-x2) + b*(y1-y2) + c*(z1-z2);
			var u:Number = r0 / r1;
			
			if( Math.abs(u) < e ) {
				intersection.status = Intersection.PARALLEL;
			} else if( (u > 0 && u < 1 ) ) {
				intersection.status = Intersection.INTERSECTION;
				var pt:Number3D = intersection.point;
				pt.x = x2 - x1;
				pt.y = y2 - y1;
				pt.z = z2 - z1;
				pt.x *= u;
				pt.y *= u;
				pt.z *= u;
				pt.x += x1;
				pt.y += y1;
				pt.z += z1;
				
				intersection.alpha = u;
				
				intersection.vert.x = pt.x;
				intersection.vert.y = pt.y;
				intersection.vert.z = pt.z;
			}else{
				intersection.status = Intersection.NONE;
			}
			
			return intersection;
		}

	}
}