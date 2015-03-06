package com.ludens.PackageHandler.view
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class BoxDrawer extends Sprite
	{
		public var lineThickness:Number = 1;
		
		public var showFill:Boolean = false;
		public var fillAlpha:Number = 0;
		public var fillColor:int = 0xffffff;
		
		public var showLine:Boolean = true;
		public var lineAlpha:Number = 1;
		public var lineColor:int = 0x000000;
		
		
		
		private var pathItems:Array;
		
		private var _data:String;
		
		
		
		public function get data():String {
			return _data;
		}
		public function set data( value:String ):void {
			
			_data = value;
			
			pathItems = explodeToItemArray( _data );
			redraw();
		}
		
		
		public function BoxDrawer()
		{
			super();
		}
		
		
		private function redraw():void {
			
			var lastPoint:Point = new Point( 0,0 );
			
			// reset graphics
			graphics.clear();
			
			// set linestyle
			if( showLine )
				graphics.lineStyle( lineThickness, lineColor, lineAlpha );

			
			if( fillAlpha > 0 && showFill )
				graphics.beginFill( fillColor, fillAlpha );
			
			
			for each( var pathItem:String in pathItems ) {
				
				var item:Array = explodeToItem( pathItem );
				
				// get action
				var action:String = item[0];
				// get parameters
				var parameters:Array = item.slice(1);
				
				// turn strings into numbers
				for( var i:int = 0; i < parameters.length; i++ ) {
					parameters[i] = Number( parameters[i] );
				}
				

				// do drawing action (if amount of parameters is correct for the action)
				switch( action ) {
					
					case( "M" ):
						if( parameters.length == 2 ) {
							graphics.moveTo( parameters[0], parameters[1] );
							lastPoint = new Point( parameters[0], parameters[1] );
						}
						break;
					
					case( "m" ):
						if( parameters.length == 2 ) {
							graphics.moveTo( lastPoint.x + parameters[0], lastPoint.y + parameters[1] );
							lastPoint = new Point( lastPoint.x + parameters[0], lastPoint.y + parameters[1] );
						}
						break;
					
					case( "L" ):
						if( parameters.length == 2  ) {
							graphics.lineTo(  parameters[0],  parameters[1] );
							lastPoint = new Point( parameters[0], parameters[1] );
						}
						break;
					
					case( "l" ):
						if( parameters.length == 2  ) {
							graphics.lineTo( lastPoint.x + parameters[0], lastPoint.y + parameters[1] );
							lastPoint = new Point( lastPoint.x + parameters[0], lastPoint.y + parameters[1] );
						}
						break;
					
					case( "H" ):
						if( parameters.length == 1  ) {
							graphics.lineTo( parameters[0], lastPoint.y );
							lastPoint = new Point( parameters[0], lastPoint.y );
						}
						break;
					
					case( "h" ):
						if( parameters.length == 1  ) {
							graphics.lineTo( lastPoint.x + parameters[0], lastPoint.y );
							lastPoint = new Point( lastPoint.x + parameters[0], lastPoint.y );
						}
						break;
					
					case( "V" ):
						if( parameters.length == 1  ) {
							graphics.lineTo( lastPoint.x, parameters[0] );
							lastPoint = new Point( lastPoint.x, parameters[0] );
						}
						break;
					
					case( "v" ):
						if( parameters.length == 1  ) {
							graphics.lineTo( lastPoint.x, lastPoint.y + parameters[0] );
							lastPoint = new Point( lastPoint.x, lastPoint.y + parameters[0] );
						}
						break;
					
					case( "Q" ):
						if( parameters.length > 3 && parameters.length%4 == 0  ) {
							
							for( var i:int = 0; i < parameters.length/4; i++ ) {
								graphics.curveTo( parameters[i*4], parameters[i*4+1], 
												  parameters[i*4+2], parameters[i*4+3] );
								lastPoint = new Point( parameters[i*4+2], parameters[i*4+3] );
							}
						}
						break;
					
					case( "q" ):
						if( parameters.length > 3 && parameters.length%4 == 0  ) {
							
							for( var i:int = 0; i < parameters.length/4; i++ ) {
								graphics.curveTo( lastPoint.x + parameters[i*4], lastPoint.y + parameters[i*4+1], 
												  lastPoint.x + parameters[i*4+2], lastPoint.y + parameters[i*4+3] );
								lastPoint = new Point( lastPoint.x + parameters[i*4+2], lastPoint.y + parameters[i*4+3] );
							}
						}
						break;
				}	
			}
			
			graphics.endFill();
		}
		
		
		private function explodeToItemArray( path:String ):Array {
			
			var pattern:RegExp = /\w[0-9\.\s-]*/g; 
			return path.match( pattern );
		}
		
		private function explodeToItem( pathItem:String ):Array {
			
			var pattern:RegExp = /[0-9a-zA-Z\.-]+/g; 
			return pathItem.match( pattern );
		}
	}
}