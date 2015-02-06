package org.papervision3d.materials
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.papervision3d.Papervision3D;
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.material.TriangleMaterial;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.render.data.RenderSessionData;
	import org.papervision3d.core.render.draw.ITriangleDrawer;

	/**
	* The BitmapMaterial class creates a texture from a BitmapData object.
	*
	* Materials collect data about how objects appear when rendered.
	*
	*/
	public class BitmapMaterial extends TriangleMaterial implements ITriangleDrawer
	{
		
		private var _precise:Boolean;
		public var focus:Number = 200;
		public var minimumRenderSize:Number = 2;
		public var precision:Number = 8;
		
		protected var _texture :Object;
		
		/**
		 * Indicates if mip mapping is forced.
		 */
		static public var AUTO_MIP_MAPPING :Boolean = false;

		/**
		 * Levels of mip mapping to force.
		 */
		static public var MIP_MAP_DEPTH :Number = 8;

		public var uvMatrices:Dictionary = new Dictionary();
		
		/**
		* @private
		*/
		protected static var _triMatrix:Matrix = new Matrix();
		protected static var _triMap:Matrix;
		
		/**
		* @private
		*/
		protected static var _localMatrix:Matrix = new Matrix();
		// ______________________________________________________________________ NEW

		/**
		* The BitmapMaterial class creates a texture from a BitmapData object.
		*
		* @param	asset				A BitmapData object.
		*/
		public function BitmapMaterial( asset:BitmapData=null, precise:Boolean = false)
		{
			// texture calls createBitmap. That's where all the init happens. This allows to reinit when changing texture. -C4RL05
			// if we have an asset passed in, this means we're the subclass, not the super.  Set the texture, let the fun begin.
			if( asset ) texture = asset;
			this.precise = precise;
		}
		

		/**
		* Resets the mapping coordinates. Use when the texture has been resized.
		*/
		public function resetMapping():void
		{
			uvMatrices = new Dictionary();
		}

		/**
		 *  drawTriangle
		 */
		override public function drawTriangle(face3D:Triangle3D, graphics:Graphics, renderSessionData:RenderSessionData, altBitmap:BitmapData = null, altUV:Matrix = null):void
		{
			if(!_precise){
				//Render the bitmap using linear texturing.
				if( lineAlpha )
					graphics.lineStyle( lineThickness, lineColor, lineAlpha );
				if( bitmap )
				{
					_triMap = altUV ? altUV : (uvMatrices[face3D] || transformUV(face3D));
					
					var x0:Number = face3D.v0.vertex3DInstance.x,
					y0:Number = face3D.v0.vertex3DInstance.y,
					x1:Number = face3D.v1.vertex3DInstance.x,
					y1:Number = face3D.v1.vertex3DInstance.y,
					x2:Number = face3D.v2.vertex3DInstance.x,
					y2:Number = face3D.v2.vertex3DInstance.y;
	
					_triMatrix.a = x1 - x0;
					_triMatrix.b = y1 - y0;
					_triMatrix.c = x2 - x0;
					_triMatrix.d = y2 - y0;
					_triMatrix.tx = x0;
					_triMatrix.ty = y0;
						
					_localMatrix.a = _triMap.a;
					_localMatrix.b = _triMap.b;
					_localMatrix.c = _triMap.c;
					_localMatrix.d = _triMap.d;
					_localMatrix.tx = _triMap.tx;
					_localMatrix.ty = _triMap.ty;
					_localMatrix.concat(_triMatrix);
					
					graphics.beginBitmapFill( altBitmap ? altBitmap : bitmap, _localMatrix, tiled, smooth);
				}
				graphics.moveTo( x0, y0 );
				graphics.lineTo( x1, y1 );
				graphics.lineTo( x2, y2 );
				graphics.lineTo( x0, y0 );
				if( bitmap )
					graphics.endFill();
				if( lineAlpha )
					graphics.lineStyle();
				renderSessionData.renderStatistics.triangles++;
			}else{
				_triMap = altUV ? altUV : (uvMatrices[face3D] || transformUV(face3D));
				focus = renderSessionData.camera.focus;
				renderRec(graphics, _triMap.a, _triMap.b, _triMap.c, _triMap.d, _triMap.tx, _triMap.ty, face3D.v0.vertex3DInstance.x, face3D.v0.vertex3DInstance.y, face3D.v0.vertex3DInstance.z, face3D.v1.vertex3DInstance.x, face3D.v1.vertex3DInstance.y, face3D.v1.vertex3DInstance.z, face3D.v2.vertex3DInstance.x, face3D.v2.vertex3DInstance.y, face3D.v2.vertex3DInstance.z,0, renderSessionData, altBitmap ? altBitmap : bitmap);	 
			}
		}
		
		/**
		* Applies the updated UV texture mapping values to the triangle. This is required to speed up rendering.
		*
		*/
		public function transformUV(face3D:Triangle3D):Matrix
		{			
			if( ! face3D.uv )
			{
				Papervision3D.log( "MaterialObject3D: transformUV() uv not found!" );
			}
			else if( bitmap )
			{
				var uv :Array  = face3D.uv;
				
				var w  :Number = bitmap.width * maxU;
				var h  :Number = bitmap.height * maxV;
				
				
				
				var u0 :Number = w * face3D.uv0.u;
				var v0 :Number = h * ( 1 - face3D.uv0.v );
				var u1 :Number = w * face3D.uv1.u;
				var v1 :Number = h * ( 1 - face3D.uv1.v);
				var u2 :Number = w * face3D.uv2.u;
				var v2 :Number = h * ( 1 - face3D.uv2.v );
				
				// Fix perpendicular projections
				if( (u0 == u1 && v0 == v1) || (u0 == u2 && v0 == v2) )
				{
					u0 -= (u0 > 0.05)? 0.05 : -0.05;
					v0 -= (v0 > 0.07)? 0.07 : -0.07;
				}
				
				if( u2 == u1 && v2 == v1 )
				{
					u2 -= (u2 > 0.05)? 0.04 : -0.04;
					v2 -= (v2 > 0.06)? 0.06 : -0.06;
				}
				
				// Precalculate matrix & correct for mip mapping
				var at :Number = ( u1 - u0 );
				var bt :Number = ( v1 - v0 );
				var ct :Number = ( u2 - u0 );
				var dt :Number = ( v2 - v0 );
				
				var m :Matrix = new Matrix( at, bt, ct, dt, u0, v0 );
				m.invert();
				var mapping:Matrix = uvMatrices[face3D] || (uvMatrices[face3D] = m.clone() );
				mapping.a  = m.a;
				mapping.b  = m.b;
				mapping.c  = m.c;
				mapping.d  = m.d;
				mapping.tx = m.tx;
				mapping.ty = m.ty;
			}
			else Papervision3D.log( "MaterialObject3D: transformUV() material.bitmap not found!" );

			return mapping;
		}
		
		 public function renderRec(graphics:Graphics, ta:Number, tb:Number, tc:Number, td:Number, tx:Number, ty:Number, 
		 ax:Number, ay:Number, az:Number, bx:Number, by:Number, bz:Number, cx:Number, cy:Number, cz:Number, index:Number, renderSessionData:RenderSessionData, bitmap:BitmapData):void
        {
    	
            if ((az <= 0) && (bz <= 0) && (cz <= 0))
                return;
			
           
            if (index >= 100 || (focus == Infinity) || (Math.max(Math.max(ax, bx), cx) - Math.min(Math.min(ax, bx), cx) < minimumRenderSize) || (Math.max(Math.max(ay, by), cy) - Math.min(Math.min(ay, by), cy) < minimumRenderSize))
            {
                renderTriangleBitmap(graphics, ta, tb, tc, td, tx, ty, ax, ay, bx, by, cx, cy, smooth, tiled, bitmap);
                renderSessionData.renderStatistics.triangles++;
                return;
            }
			
            var faz:Number = focus + az;
            var fbz:Number = focus + bz;
            var fcz:Number = focus + cz;
			
			
			
			var mabz:Number = 2 / (faz + fbz);
            var mbcz:Number = 2 / (fbz + fcz);
            var mcaz:Number = 2 / (fcz + faz);

            var mabx:Number = (ax*faz + bx*fbz)*mabz;
            var maby:Number = (ay*faz + by*fbz)*mabz;
            var mbcx:Number = (bx*fbz + cx*fcz)*mbcz;
            var mbcy:Number = (by*fbz + cy*fcz)*mbcz;
            var mcax:Number = (cx*fcz + ax*faz)*mcaz;
            var mcay:Number = (cy*fcz + ay*faz)*mcaz;

            var dabx:Number = ax + bx - mabx;
            var daby:Number = ay + by - maby;
            var dbcx:Number = bx + cx - mbcx;
            var dbcy:Number = by + cy - mbcy;
            var dcax:Number = cx + ax - mcax;
            var dcay:Number = cy + ay - mcay;
            
            var dsab:Number = (dabx*dabx + daby*daby);
            var dsbc:Number = (dbcx*dbcx + dbcy*dbcy);
            var dsca:Number = (dcax*dcax + dcay*dcay);

            if ((dsab <= precision) && (dsca <= precision) && (dsbc <= precision))
            {
               renderTriangleBitmap(graphics, ta, tb, tc, td, tx, ty, ax, ay, bx, by, cx, cy, smooth, tiled,bitmap);
               renderSessionData.renderStatistics.triangles++;
               return;
            }

            if ((dsab > precision) && (dsca > precision) && (dsbc > precision))
            {
                renderRec(graphics, ta*2, tb*2, tc*2, td*2, tx*2, ty*2,
                    ax, ay, az, mabx * 0.5, maby * 0.5, (az+bz) * 0.5, mcax * 0.5, mcay * 0.5, (cz+az) * 0.5, index+1, renderSessionData, bitmap);

                renderRec(graphics, ta*2, tb*2, tc*2, td*2, tx*2-1, ty*2,
                    mabx * 0.5, maby * 0.5, (az+bz) * 0.5, bx, by, bz, mbcx * 0.5, mbcy * 0.5, (bz+cz) * 0.5, index+1, renderSessionData, bitmap);

                renderRec(graphics, ta*2, tb*2, tc*2, td*2, tx*2, ty*2-1,
                    mcax * 0.5, mcay * 0.5, (cz+az) * 0.5, mbcx * 0.5, mbcy * 0.5, (bz+cz) * 0.5, cx, cy, cz, index+1, renderSessionData, bitmap);

                renderRec(graphics, -ta*2, -tb*2, -tc*2, -td*2, -tx*2+1, -ty*2+1,
                    mbcx * 0.5, mbcy * 0.5, (bz+cz) * 0.5, mcax * 0.5, mcay * 0.5, (cz+az) * 0.5, mabx * 0.5, maby * 0.5, (az+bz) * 0.5, index+1, renderSessionData, bitmap);

                return;
            }

            var dmax:Number = Math.max(dsab, Math.max(dsca, dsbc));
            if (dsab == dmax)
            {
                renderRec(graphics, ta*2, tb*1, tc*2, td*1, tx*2, ty*1,
                    ax, ay, az, mabx * 0.5, maby * 0.5, (az+bz) * 0.5, cx, cy, cz, index+1, renderSessionData, bitmap);

                renderRec(graphics, ta*2+tb, tb*1, 2*tc+td, td*1, tx*2+ty-1, ty*1,
                    mabx * 0.5, maby * 0.5, (az+bz) * 0.5, bx, by, bz, cx, cy, cz, index+1, renderSessionData, bitmap);
            
                return;
            }

            if (dsca == dmax)
            {
                renderRec(graphics, ta*1, tb*2, tc*1, td*2, tx*1, ty*2,
                    ax, ay, az, bx, by, bz, mcax * 0.5, mcay * 0.5, (cz+az) * 0.5, index+1, renderSessionData, bitmap);

                renderRec(graphics, ta*1, tb*2 + ta, tc*1, td*2 + tc, tx, ty*2+tx-1,
                    mcax * 0.5, mcay * 0.5, (cz+az) * 0.5, bx, by, bz, cx, cy, cz, index+1, renderSessionData, bitmap);
            
                return;
            }


            renderRec(graphics, ta-tb, tb*2, tc-td, td*2, tx-ty, ty*2,
                ax, ay, az, bx, by, bz, mbcx * 0.5, mbcy * 0.5, (bz+cz) * 0.5, index+1, renderSessionData, bitmap);

            renderRec(graphics, 2*ta, tb-ta, tc*2, td-tc, 2*tx, ty-tx,
                ax, ay, az, mbcx * 0.5, mbcy * 0.5, (bz+cz) * 0.5, cx, cy, cz, index+1, renderSessionData, bitmap);
        }
		
		/**
		*	Used to avoid new in renderTriangleBitmap
		*/
		protected var tempTriangleMatrix:Matrix = new Matrix();
		
		public function renderTriangleBitmap(graphics:Graphics,a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number, 
            v0x:Number, v0y:Number, v1x:Number, v1y:Number, v2x:Number, v2y:Number, smooth:Boolean, repeat:Boolean, bitmapData:BitmapData):void
        {
            var a2:Number = v1x - v0x;
            var b2:Number = v1y - v0y;
            var c2:Number = v2x - v0x;
            var d2:Number = v2y - v0y;

          	
            tempTriangleMatrix.a = a*a2 + b*c2;
            tempTriangleMatrix.b = a*b2 + b*d2;
            tempTriangleMatrix.c = c*a2 + d*c2;
            tempTriangleMatrix.d = c*b2 + d*d2;
            tempTriangleMatrix.tx = tx*a2 + ty*c2 + v0x;   
            tempTriangleMatrix.ty = tx*b2 + ty*d2 + v0y;       
                    
			graphics.beginBitmapFill(bitmapData, tempTriangleMatrix, repeat, smooth);

            graphics.moveTo(v0x, v0y);
            graphics.lineTo(v1x, v1y);
            graphics.lineTo(v2x, v2y);
            graphics.endFill();
        }
		
		// ______________________________________________________________________ TO STRING

		/**
		* Returns a string value representing the material properties in the specified BitmapMaterial object.
		*
		* @return	A string.
		*/
		public override function toString(): String
		{
			return 'Texture:' + this.texture + ' lineColor:' + this.lineColor + ' lineAlpha:' + this.lineAlpha;
		}


		// ______________________________________________________________________ CREATE BITMAP

		protected function createBitmap( asset:BitmapData ):BitmapData
		{		
			resetMapping();

			if( AUTO_MIP_MAPPING )
			{
				return correctBitmap( asset );
			}
			else
			{
				this.maxU = this.maxV = 1;

				return ( asset );
			}
		}


		// ______________________________________________________________________ CORRECT BITMAP FOR MIP MAPPING

		protected function correctBitmap( bitmap :BitmapData ):BitmapData
		{
			var okBitmap :BitmapData;

			var levels :Number = 1 << MIP_MAP_DEPTH;
			// this is faster than Math.ceil
			var bWidth :Number = bitmap.width  / levels;
			bWidth = bWidth == uint(bWidth) ? bWidth : uint(bWidth)+1;
			var bHeight :Number = bitmap.height  / levels;
			bHeight = bHeight == uint(bHeight) ? bHeight : uint(bHeight)+1;
			
			var width  :Number = levels * bWidth;
			var height :Number = levels * bHeight;

			// Check for BitmapData maximum size
			var ok:Boolean = true;

			if( width  > 2880 )
			{
				width  = bitmap.width;
				ok = false;
			}

			if( height > 2880 )
			{
				height = bitmap.height;
				ok = false;
			}
			
			if( ! ok ) Papervision3D.log( "Material " + this.name + ": Texture too big for mip mapping. Resizing recommended for better performance and quality." );

			// Create new bitmap?
			if( bitmap && ( bitmap.width % levels !=0  ||  bitmap.height % levels != 0 ) )
			{
				okBitmap = new BitmapData( width, height, bitmap.transparent, 0x00000000 );

					
				// this is for ISM and offsetting bitmaps that have been resized
				widthOffset = bitmap.width;
				heightOffset = bitmap.height;
				
				this.maxU = bitmap.width / width;
				this.maxV = bitmap.height / height;

				okBitmap.draw( bitmap );

				// PLEASE DO NOT REMOVE
				extendBitmapEdges( okBitmap, bitmap.width, bitmap.height );
			}
			else
			{
				this.maxU = this.maxV = 1;

				okBitmap = bitmap;
			}

			return okBitmap;
		}

		protected function extendBitmapEdges( bmp:BitmapData, originalWidth:Number, originalHeight:Number ):void
		{
			var srcRect  :Rectangle = new Rectangle();
			var dstPoint :Point = new Point();
			//trace(dstPoint + "BitmapMaterialPOINT?");
			var i        :int;

			// Check width
			if( bmp.width > originalWidth )
			{
				// Extend width
				srcRect.x      = originalWidth-1;
				srcRect.y      = 0;
				srcRect.width  = 1;
				srcRect.height = originalHeight;
				dstPoint.y     = 0;
				
				for( i = originalWidth; i < bmp.width; i++ )
				{
					dstPoint.x = i;
					bmp.copyPixels( bmp, srcRect, dstPoint );
				}
			}

			// Check height
			if( bmp.height > originalHeight )
			{
				// Extend height
				srcRect.x      = 0;
				srcRect.y      = originalHeight-1;
				srcRect.width  = bmp.width;
				srcRect.height = 1;
				dstPoint.x     = 0;

				for( i = originalHeight; i < bmp.height; i++ )
				{
					dstPoint.y = i;
					bmp.copyPixels( bmp, srcRect, dstPoint );
				}
			}
		}

		// ______________________________________________________________________
		
		
		/**
		 * resetUVMatrices();
		 * 
		 * Resets the precalculated uvmatrices, so they can be recalculated
		 */
		 public function resetUVS():void
		 {
		 	uvMatrices = new Dictionary(false);
		 }
		
		/**
		* Copies the properties of a material.
		*
		* @param	material	Material to copy from.
		*/
		override public function copy( material :MaterialObject3D ):void
		{
			super.copy( material );

			this.maxU = material.maxU;
			this.maxV = material.maxV;
		}

		/**
		* Creates a copy of the material.
		*
		* @return	A newly created material that contains the same properties.
		*/
		override public function clone():MaterialObject3D
		{
			var cloned:MaterialObject3D = super.clone();

			cloned.maxU = this.maxU;
			cloned.maxV = this.maxV;

			return cloned;
		}

		public function set precise(boolean:Boolean):void
		{
			_precise = boolean;
		}
		
		public function get precise():Boolean
		{
			return _precise;
		}
		
		/**
		* A texture object.
		*/		
		public function get texture():Object
		{
			return this._texture;
		}
		
		/**
		* @private
		*/
		public function set texture( asset:Object ):void
		{
			if( asset is BitmapData == false )
			{
				Papervision3D.log("Error: BitmapMaterial.texture requires a BitmapData object for the texture");
				return;
			}
			
			bitmap   = createBitmap( BitmapData(asset) );
			_texture = asset;
		}
		
		override public function destroy():void
		{
			super.destroy();
			if(uvMatrices){
				uvMatrices = null;
			}
			if(bitmap){
				bitmap.dispose();
			}
		}
			
	}
}