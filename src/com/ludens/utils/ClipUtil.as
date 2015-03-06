package com.ludens.utils
{
	import com.ludens.magicbox.parser.drawingcommands.DCGroup;
	import com.ludens.magicbox.parser.drawingcommands.DCLine;
	import com.ludens.magicbox.parser.drawingcommands.DCMove;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	import pl.bmnet.gpcas.geometry.Clip;
	import pl.bmnet.gpcas.geometry.OperationType;
	import pl.bmnet.gpcas.geometry.Poly;
	import pl.bmnet.gpcas.geometry.PolyDefault;
	import pl.bmnet.gpcas.geometry.PolySimple;
	import pl.bmnet.gpcas.geometry.Polygon;
	
	public class ClipUtil
	{
		/**
		 * GENERIC MAGIC BOX FUNCTIONS
		 */
		
		/**
		 * polys should be an array of PolyDefault objects
		 */
		public static function clip( type:String, polys:Array ):Array {
			
			
			// do the clipping operation
			
			// get the first polygon, this is the base of the boolean operation
			var first:PolyDefault = polys[0] as PolyDefault;
			
			// get clip type
			
			var clipType:OperationType;
			
			switch ( type ){
				case "union":
					clipType = OperationType.GPC_UNION;
					break;
				case "difference":
					clipType = OperationType.GPC_DIFF;
					break;
				case "intersection":
					clipType = OperationType.GPC_INT;
					break;
				case "xor":
					clipType = OperationType.GPC_XOR;
					break;
				default:
					// ERROR
					
					Debug.print("[ClipUtil.clip] No valid boolean operation!!: " + type );
					return polys;
			}
			
			
			for each( var polygon:PolyDefault in polys.slice(1) ){
				
				first = Clip.clip( clipType, first, polygon, "PolyDefault" ) as PolyDefault;
				
			}
			
			// convert polygon to array
			
			return ClipUtil.polyToArray(first);
			
			// convert to an array
		}
		
		/**
		 * this returns an array of Polydefault objects
		 */
		public static function arrayToPolys( array:Array ):Array {
			if( !array ) return null;
			
			var ret:Array = new Array;
			
			
			//var p:PolyDefault = new PolyDefault();
			//p.getArea();
			
			for( var i:int = 0; i < array.length; i++){
				var poly:Array = array[i];
				
				var p:PolyDefault = new PolyDefault;
				
				// loop through the array and add each array of 2 elements as the x and y coordinates of a new point
				for( var j:int = 0; j < poly.length; j++){
					
					p.addPointXY( poly[j][0], poly[j][1] );
				}
				
				// add the polygon to the return array
				ret.push( p );
			}
			
			Debug.print( "arrayToPolys(" + array.length + ")");
			
			return ret;
		}
		
		public static function polyToArray( poly:Poly ):Array {
			
			if( !poly ) return null;
			
			var ret:Array = new Array;
			
			for( var i:int = 0; i < poly.getNumInnerPoly(); i++){
				// get each polygon
				var p:Poly = poly.getInnerPoly( i );
				
				var pArray:Array = new Array;
				
				// all polygons here are simple
				
				// if not, throw an error
				
				// add all the points to the array
				for( var j:int = 0; j < p.getNumPoints(); j++){
					var point:Point = p.getPoint( j );
					pArray.push( [ point.x, point.y ] );
				}
				
				ret.push( pArray );
			}
			
			return ret;
		}
		
		public static function arrayToDC( polys:Array ):IDrawingCommand {
			
			// loop through all polygons
			
			if( !polys ) return null;
			
			var ret:DCGroup = new DCGroup;
			
			// add the coordinates to the string, use shorthand svg notation
			for( var i:int = 0; i < polys.length; i++){
				// this is a polygon
				var poly:Array = polys[i];
				// get all points in a polygon
				
				// move to the first position
				ret.push( new DCMove(poly[0][0], poly[0][1] ) );
				
				for( var j:int = 1; j < poly.length; j++){
					ret.push( new DCLine( poly[j][0],  poly[j][1] ) );
				}
				// close polygon
				ret.close();
				
			}
			
			return ret;
		}
		
		/**
		 * FUNCTIONS USED IN BOX_O_RAMA and other Tal-based tools
		 */
		
		public static function mergePolygons( polygons:Array ):PolyDefault {
			
			var outline:PolyDefault = polygons[0] as PolyDefault;
			
			for each( var polygon:PolyDefault in polygons.slice(1) )
			outline = Clip.union( outline, polygon, "PolyDefault" ) as PolyDefault;
			
			return outline;
		}
		
		
		public static function convertRectanglesToPoly( rects:Array ):Array {
			
			var polygons:Array = [];
			
			for each( var rect:Rectangle in rects ) {
				
				var polyRect:PolyDefault = new PolyDefault();
				polyRect.add( [ [rect.x, rect.y],
					[rect.x + rect.width, rect.y],
					[rect.x + rect.width, rect.y + rect.height],
					[rect.x, rect.y + rect.height] ] );
				
				polygons.push( polyRect );
			}
			
			return polygons;
		}
		
		
		
		public static function inflateRects( rects:Array, margins:Array ):Array {
			
			var inflatedRects:Array = [];
			
			for( var i:uint=0; i<rects.length; i++ ) {
				var inflatedRect:Rectangle = rects[i].clone();
				var margin:Number = margins[i];
				inflatedRect.inflate( margin, margin );
				inflatedRects.push( inflatedRect );
			}
			
			return inflatedRects;
		}
		
		
		
		public static function getMarginSideRect( rect:Rectangle, margin:Number, side:String, withMargin:Boolean ):Rectangle {
			
			var marginSideRect:Rectangle;
			
			if( side == "left" ) {
				
				if( withMargin )
					marginSideRect = new Rectangle( rect.x - margin,
						rect.y - margin,
						margin, 
						rect.height + 2*margin );
				else
					marginSideRect = new Rectangle( rect.x - margin,
						rect.y,
						margin, 
						rect.height );
			}
			else if( side == "right" ) {
				
				if( withMargin )
					marginSideRect = new Rectangle( rect.right, 
						rect.y - margin,
						margin, 
						rect.height + 2*margin );
				else
					marginSideRect = new Rectangle( rect.right, 
						rect.y,
						margin, 
						rect.height );
			}
			else if( side == "top" ) {	
				
				if( withMargin )
					marginSideRect = new Rectangle( rect.x - margin, 
						rect.y - margin,
						rect.width + 2*margin, 
						margin );
				else
					marginSideRect = new Rectangle( rect.x, 
						rect.y - margin,
						rect.width, 
						margin );
			}
			else if( side == "bottom" ) {	
				
				if( withMargin )
					marginSideRect = new Rectangle( rect.x - margin, 
						rect.bottom,
						rect.width + 2*margin, 
						margin );
				else
					marginSideRect = new Rectangle( rect.x, 
						rect.bottom,
						rect.width, 
						margin );
			}
			
			return marginSideRect;
		}
	
	
	}
}