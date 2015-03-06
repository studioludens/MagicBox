package com.ludens.magicbox.parser
{
	import com.ludens.PackageHandler.LineGenerator;
	import com.ludens.magicbox.parser.drawingcommands.DCArc;
	import com.ludens.magicbox.parser.drawingcommands.DCGroup;
	import com.ludens.magicbox.parser.drawingcommands.DCLine;
	import com.ludens.magicbox.parser.drawingcommands.DCMove;
	import com.ludens.magicbox.parser.drawingcommands.DrawingCommand;
	import com.ludens.magicbox.parser.drawingcommands.IDrawingCommand;
	
	import flash.geom.Point;
	
	import spark.components.Group;
	
	public class ParserContextBase
	{
		public function ParserContextBase()
		{
			turtle = new Turtle;
		}
		
		/**
		 * turtle graphics object
		 * 
		 * functions that change the location of the cursor should update the turtle object
		 */
		public var turtle:ITurtle;
		
		/** 
		 * Wrapper for Math.pow function
		 */
		public function pow(value1:Number, value2:Number):Number {
			return Math.pow(value1, value2);
		}
		
		/** 
		 * Wrapper for Math.log function
		 */
		public function log(value:Number):Number {
			return Math.log(value);
		}
		
		/** 
		 * Wrapper for Math.atan2 function
		 */
		public function atan2(value1:Number, value2:Number):Number {
			return Math.atan2(value1, value2);
		}
		
		
		/** 
		 * Wrapper for Math.sqrt function
		 */
		public function sqrt(value:Number):Number {
			return Math.sqrt(value);
		}
		
		/** 
		 * Wrapper for Math.sin function
		 * but in degrees
		 */
		public function sin(value:Number):Number {
			return Math.sin(value * TO_RADIANS);
		}
		
		/** 
		 * Wrapper for Math.cos function
		 * but in degrees
		 */
		public function cos(value:Number):Number {
			return Math.cos(value * TO_RADIANS);
		}
		
		/** 
		 * Wrapper for Math.tan function
		 */
		public function tan(value:Number):Number {
			return Math.tan(value);
		}
		
		/** 
		 * Wrapper for Math.asin function
		 */
		public function asin(value:Number):Number {
			return Math.asin(value);
		}
		
		/** 
		 * Wrapper for Math.acos function
		 */
		public function acos(value:Number):Number {
			return Math.acos(value);
		}
		
		/** 
		 * Wrapper for Math.atan function
		 */
		public function atan(value:Number):Number {
			return Math.atan(value);
		}
		
		/** 
		 * Wrapper for Math.abs function
		 */
		public function abs(value:Number):Number {
			return Math.abs(value);
		}
		
		/** 
		 * Wrapper for Math.min function
		 */
		public function min(value1:Number, value2:Number):Number {
			return Math.min(value1, value2);
		}
		
		/** 
		 * Wrapper for Math.max function
		 */
		public function max(value1:Number, value2:Number):Number {
			return Math.max(value1, value2);
		}
		
		/** 
		 * int function
		 */
		public function integer(value:Number):Number {
			return int(value);
		}
		
		/**
		 * is even
		 */
		public function even(value:Number):Boolean {
			return (int(value) % 2 == 0);
		}
		
		public function odd(value:Number):Boolean {
			return (int(value) % 2 == 1);
		}
		
		/**
		 * print function
		 * this prints the value of the variable to the commandline
		 */
		public function print(variable:*):String {
			ParserConsole.traceDebug(variable);
			//trace("[PCB] );
			return "";
		}
		
		/** UTILITY DRAWING FUNCTIONS **/
		
		/** easier names for the drawing functions
		 */
		
		public function move( x:Number, y:Number):IDrawingCommand {
			turtle.move( x, y );
			return new DCMove( x, y );
		}
		
		public function line( x:Number, y:Number):IDrawingCommand {
			turtle.move( x, y );
			return new DCLine( x, y );
		}
		
		public function hline( width:Number):IDrawingCommand {
			turtle.move( width, 0 );
			return new DCLine( width, 0 );
		}
		
		public function vline( height:Number):IDrawingCommand {
			turtle.move( 0, height );
			return new DCLine( 0, height );
		}
		
		/**
		 * TURTLE GRAPHICS FUNCTIONS
		 */
		
		/**
		 * move forward in the turtle's relative coordinate system
		 */
		public function forward( length:Number ):IDrawingCommand {
			turtle.moveForward( length );
			
			if( turtle.penUp ) 	return new DCMove( turtle.positionDelta.x, turtle.positionDelta.y );
			else 				return new DCLine( turtle.positionDelta.x, turtle.positionDelta.y );
		}
		
		/**
		 * shorthand forward
		 */
		public function fd( length:Number ):IDrawingCommand {
			return forward( length );
		}
		
		
		/**
		 * move backwards in the turtle's relative coordinate system
		 */
		public function backward( length:Number ):IDrawingCommand {
			turtle.moveBackward( length );
			
			if( turtle.penUp ) 	return new DCMove( turtle.positionDelta.x, turtle.positionDelta.y );
			else 				return new DCLine( turtle.positionDelta.x, turtle.positionDelta.y );
		}
		
		
		/**
		 * turn the turtle left
		 */
		public function left( angle:Number ):IDrawingCommand {
			turtle.rotateLeft( angle );
			return null;
		}
		
		/**
		 * turn the turtle right
		 */
		public function right( angle:Number ):IDrawingCommand {
			turtle.rotateRight( angle );
			return null;
		}
		
		/**
		 * shorthand turn left
		 */
		public function lt( angle:Number ):IDrawingCommand {
			return left( angle );
		}
		
		/**
		 * shorthand turn right
		 */
		public function tr( angle:Number ):IDrawingCommand {
			return right( angle );
		}
		
		public function goto( x:Number, y:Number ):IDrawingCommand {
			if( turtle.position.x != x || turtle.position.y != y ){
				turtle.moveTo( x, y );
				return new DCMove( x, y, null, true );
			}
			return null;
		}
		
		public function setpos( x:Number, y:Number):IDrawingCommand {
			return goto( x, y );
		}
		
		public function setposition( x:Number, y:Number):IDrawingCommand {
			return goto( x, y );
		}
		
		public function setx( x:Number ):IDrawingCommand {
			return goto( x, turtle.y );
		}
		
		public function sety( y:Number ):IDrawingCommand {
			return goto( turtle.x, y );
		}
		
		public function setheading( angle:Number ):IDrawingCommand {
			turtle.rotateTo( angle );
			return null;
		}
		
		public function seth( angle:Number ):IDrawingCommand {
			return setheading( angle );
		}
		
		/**
		 * pen down functions
		 */
		public function pendown():IDrawingCommand {
			turtle.penUp = false;
			return null;
		}
		
		public function pd():IDrawingCommand {
			return pendown();
		}
		
		public function down():IDrawingCommand {
			return pendown();
		}
		
		/**
		 * pen up functions
		 */
		public function penup():IDrawingCommand {
			turtle.penUp = true;
			return null;
		}
		
		public function pu():IDrawingCommand {
			return penup();
		}
		
		public function up():IDrawingCommand {
			return penup();
		}
		
		
		
		
		
		
		
		
		/**
		 * Horizontal dashed line
		 */ 
		public function h_( 
			length:Number, 
			dashLength:Number = 5, 
			spaceLength:Number = 5 
			
		):IDrawingCommand {
			
			turtle.move( length, 0 );
			
			// divide the line into equal segments
			return LineGenerator.dottedHorizontalLineDC(length, dashLength );
		}
		
		/**
		 * Vertical dashed line
		 */ 
		public function v_( 
			length:Number, 
			dashLength:Number = 5, 
			spaceLength:Number = 5 
			
		):IDrawingCommand {
			
			turtle.move( 0, length );
			
			// divide the line into equal segments
			return LineGenerator.dottedVerticalLineDC(length, dashLength );
		}
		
		/**
		 * dashed line
		 */ 
		public function l_( 
			width:Number,
			height:Number, 
			dashLength:Number = 5, 
			spaceLength:Number = 5 
			
		):IDrawingCommand {
			
			turtle.move( width, height );
			
			// divide the line into equal segments
			return LineGenerator.dottedLineDC(width, height, dashLength );
		}
		
		/**
		 * simple rounded corner
		 */
		public function rc( radius:Number, horizontalOrientation:int = 1, verticalOrientation:int = 1):IDrawingCommand {
			
			turtle.move( radius * horizontalOrientation, radius * verticalOrientation );
			
			return new DCArc( radius, radius, 0, 0, 1, ( -horizontalOrientation * radius ), ( -verticalOrientation * radius ) );
			
		}
		
		/**
		 * circle
		 */
		public function circle( radius:Number, position:int = 1, direction:Boolean = true):IDrawingCommand {
			
			var ret:DCGroup = new DCGroup;
			
			if(position == CENTER) ret.move( 0, -radius );
			
			ret.push( rc( radius, RIGHT, DOWN) )
			   .push( rc( radius, LEFT, DOWN) )
			   .push( rc( radius, LEFT, UP) )
			   .push( rc( radius, RIGHT, UP) );
			
			if(position == CENTER) ret.move( 0, radius );
			
			// this is a closed shape
			ret.close();
			return ret;
		}
		
		/**
		 * rectangle
		 */
		public function rect( width:Number, height:Number, position:int = 0, direction:Boolean = true):IDrawingCommand {
			
			var ret:DCGroup = new DCGroup;
			
			if(position == CENTER) ret.move( -width/2, -height/2 );
			
			if(direction)
				ret.hline( width ).vline( height ).hline( -width ).vline( -height );
			else
				ret.vline( height ).hline( width ).vline( -height ).hline( -width );
			
			if(position == CENTER) ret.move( width/2, height/2 );
			
			// this is a closed shape
			ret.close();
			
			return ret;
		}
		
		/**
		 * cross
		 */
		public function cross( size:Number, angle:Number = 0):IDrawingCommand {
			
			var ret:DCGroup = new DCGroup;
			
			if( angle == 0){
				ret.move( -size*.5, 0 ).hline( size ).move( -size*.5, -size*.5 ).vline( size ).move( 0, -size*.5 );
			} else {
				
				var sinAngle:Number = sin(angle);
				var cosAngle:Number = cos(angle);
				
				var sinAngle45:Number = sin( angle - 45);
				var cosAngle45:Number = cos( angle - 45);
				
				var sinAngle90:Number = sin( angle - 90);
				var cosAngle90:Number = cos( angle - 90);
				
				
				var xpos1:Number = .5 * size * -sinAngle;
				var ypos1:Number = .5 * size * cosAngle;
				
				var xpos2:Number = -size * -sinAngle;
				var ypos2:Number = -size * cosAngle;
				
				var xpos3:Number = .5 * size * Math.SQRT2 * -sinAngle45;
				var ypos3:Number = .5 * size * Math.SQRT2 * cosAngle45;
				
				var xpos4:Number = -size * - sinAngle90;
				var ypos4:Number = -size * cosAngle90;
				
				var xpos5:Number = .5 * size * -sinAngle90;
				var ypos5:Number = .5 * size * cosAngle90;
				
				
				// move to the right spot
				ret.move( xpos1, ypos1 )
					.line( xpos2, ypos2 )
					.move( xpos3, ypos3 )
					.line( xpos4, ypos4 )
					.move( xpos5, ypos5 );
			}
			
			return ret;
			
			
		}
		
		/**
		 * smooth curve
		 * 
		 */
		
		
		
		/**
		 * polar coordinate functions
		 */
		public function Mpolar( radius:Number, angle:Number ):IDrawingCommand {

			var newX:Number = radius * Math.cos( angle * TO_RADIANS );
			var newY:Number = radius * -Math.sin( angle * TO_RADIANS );
			
			turtle.moveTo( newX, newY );
				
			return new DCMove( newX, newY, null, ABSOLUTE );
		}
		
		public function Lpolar( radius:Number, angle:Number ):IDrawingCommand {
			
			var newX:Number = radius * Math.cos( angle * TO_RADIANS );
			var newY:Number = radius * -Math.sin( angle * TO_RADIANS );
			
			turtle.moveTo( newX, newY );
			
			return new DCLine( newX, newY, null, ABSOLUTE );
		}
		
		public function mpolar( radius:Number, angle:Number ):IDrawingCommand {
			
			var newX:Number = radius * Math.cos( angle * TO_RADIANS );
			var newY:Number = radius * -Math.sin( angle * TO_RADIANS );
			
			turtle.move( newX, newY );
			
			return new DCMove( newX, newY );
		}
		
		public function lpolar( radius:Number, angle:Number ):IDrawingCommand {
			
			var newX:Number = radius * Math.cos( angle * TO_RADIANS );
			var newY:Number = radius * -Math.sin( angle * TO_RADIANS );
			
			turtle.move( newX, newY );
			
			return new DCLine( newX, newY );
		}
		
		/** isometric functions
		 */
		
		/**
		 * move the drawing cursor to a specific point in isometric space
		 */
		public function moveiso( x:Number, y:Number, z:Number, absolute:Boolean = false ):IDrawingCommand {
			
			var xPos:Number = -x * _cos30 + y * _cos30;
			var yPos:Number = -x * _sin30 - y * _sin30 - z;
			
			if( absolute ) 	turtle.moveTo( xPos, yPos );
			else			turtle.move( xPos, yPos );
			
			return new DCMove( xPos, yPos, null, absolute );
		}
		
		/**
		 * move the drawing cursor to a specific point in isometric space (relative)
		 */
		public function miso( x:Number, y:Number, z:Number ):IDrawingCommand {
			return moveiso( x, y, z );
		}
		
		/**
		 * move the drawing cursor to a specific point in isometric space (absolute)
		 */
		public function Miso( x:Number, y:Number, z:Number ):IDrawingCommand {
			return moveiso( x, y, z, true );
		}
		
		/**
		 * draw a line in isometric space
		 */
		public function lineiso( x:Number, y:Number, z:Number, absolute:Boolean = false ):IDrawingCommand {
			
			var xPos:Number = -x * _cos30 + y * _cos30;
			var yPos:Number = -x * _sin30 - y * _sin30 - z;
			
			if( absolute ) 	turtle.moveTo( xPos, yPos );
			else			turtle.move( xPos, yPos );
			
			return new DCLine( xPos, yPos, null, absolute );
		}
		
		/**
		 * draw a line in isometric space (relative)
		 */
		public function liso( x:Number, y:Number, z:Number ):IDrawingCommand {
			return lineiso( x, y, z );
		}
		
		
		/**
		 * draw a line in isometric space on the x axis (relative)
		 */
		public function lisox( x:Number ):IDrawingCommand {
			return lineiso( x, 0, 0 );
		}
		
		/**
		 * draw a line in isometric space on the y axis (relative)
		 */
		public function lisoy( y:Number ):IDrawingCommand {
			return lineiso( 0, y, 0 );
		}
		
		/**
		 * draw a line in isometric space on the z axis (relative)
		 */
		public function lisoz( z:Number ):IDrawingCommand {
			return lineiso( 0, 0, z );
		}
		
		/**
		 * draw a dotted line in isometric space (relative)
		 */
		public function lineiso_( x:Number, y:Number, z:Number, dashLength:Number = 5, 
								  spaceLength:Number = 5  ):IDrawingCommand {
			
			var xPos:Number = -x * _cos30 + y * _cos30;
			var yPos:Number = -x * _sin30 - y * _sin30 - z;
			
			turtle.move( xPos, yPos );
			
			// divide the line into equal segments
			return LineGenerator.dottedLineDC(xPos, yPos, dashLength, spaceLength );

		}
		
		/**
		 * draw a dotted line in isometric space (relative)
		 */
		public function liso_( x:Number, y:Number, z:Number, dashLength:Number = 5, 
								  spaceLength:Number = 5  ):IDrawingCommand {
			
			
			
			// divide the line into equal segments
			return lineiso_(x, y, z, dashLength, spaceLength );
			
		}
		
		/**
		 * draw a rectangle in isometric space
		 * 
		 * cutout defines the direction in which the lines will be drawn. Normally lines are drawn counter-clockwise,
		 * with coutout = true they are drawn clockwise.
		 */
		public function rectiso( width:Number, height:Number, orientation:int = 0, cutout:Boolean = false ):IDrawingCommand {
			
			var ret:DCGroup = new DCGroup;
			
			// we have 3 different orientations, ISO_LEFT, ISO_RIGHT and ISO_TOP
			if        ( orientation == ISO_TOP){
				if(cutout){
					ret .push( lineiso( 0, height, 0) )
						.push( lineiso( width, 0, 0) )
						.push( lineiso( 0, -height, 0) )
						.push( lineiso( -width, 0, 0) );
				} else {
					ret .push( lineiso( width, 0, 0) )
						.push( lineiso( 0, height, 0) )
						.push( lineiso( -width, 0, 0) )
						.push( lineiso( 0, -height, 0) );
				}
			} else if ( orientation == ISO_LEFT){
				if(cutout){
					ret .push( lineiso( 0, 0, height) )
						.push( lineiso( width, 0, 0) )
						.push( lineiso( 0, 0, -height) )
						.push( lineiso( -width, 0, 0) );
				} else {
					ret .push( lineiso( width, 0, 0) )
						.push( lineiso( 0, 0, height) )
						.push( lineiso( -width, 0, 0) )
						.push( lineiso( 0, 0, -height) );
				}
				
			} else if ( orientation == ISO_RIGHT){
				if(cutout){
					ret .push( lineiso( 0, width, 0) )
						.push( lineiso( 0, 0, -height) )
						.push( lineiso( 0, -width, 0) )
						.push( lineiso( 0, 0, height) );
				} else {
					ret .push( lineiso( 0, 0, height) )
						.push( lineiso( 0, width, 0) )
						.push( lineiso( 0, 0, -height) )
						.push( lineiso( 0, -width, 0) );
				}
			}
			
			return ret;
		}
		
		/**
		 * draw a box in isometric space
		 */
		public function boxiso( width:Number, depth:Number, height:Number, type:int = 0 ):IDrawingCommand {
			
			var ret:DCGroup = new DCGroup;
			// always draw foremost three pieces
			
			if( type != BACK ){
				ret .push( rectiso(width, height, ISO_LEFT) )
					.push( rectiso(depth, height, ISO_RIGHT) )
					.push( moveiso(0, 0, height) )
					.push( rectiso(width, depth, ISO_TOP) );
			}
			
			
			if	( type == SOLID ){
				ret .push( moveiso( 0, 0, -height) );
			}
			if	( type == FILLED ){
				// draw all three pieces on the back
				ret .push( moveiso(0, 0, -height) )
					.push( rectiso( width, depth, ISO_TOP) )
				
					.push( moveiso( 0, depth, 0) )
					.push( rectiso( width, height, ISO_LEFT) )
				
					.push( moveiso( width, -depth, 0) )
					.push( rectiso( depth, height, ISO_RIGHT) )
				// and back to the beginning
					.push( moveiso( -width, 0, 0) );
				
			} else if	( type == SEETHROUGH ){
				
				// only draw extra lines
				// we have to do move instructions in between otherwise 
				// we get weird drawing artifacts
				ret .push( miso( 0, depth, -height) )
					.push( lisox( width ) )
					.push( miso( 0, -depth, 0) )
					.push( lisoy( depth ) )
					.push( miso( 0, 0, height) )
					.push( lisoz( -height) )
				
					.push( miso( -width, -depth, 0 ) );

			} else if	( type == STRIPED ){
				
				// draw extra striped lines
				
				// only draw extra lines
				// we have to do move instructions in between otherwise 
				// we get weird drawing artifacts
				ret .push( miso( 0, depth, -height) )
					.push( liso_( width, 0, 0 ) )
					.push( miso( 0, -depth, 0) )
					.push( liso_( 0, depth, 0 ) )
					.push( miso( 0, 0, height) )
					.push( liso_( 0, 0, -height) )
				
					.push( miso( -width, -depth, 0 ) );
			} else if( type == BACK ){
				
				
				ret .push( rectiso( width, depth, ISO_TOP) )
				
					.push( moveiso( 0, depth, 0) )
					.push( rectiso( width, height, ISO_LEFT) )
				
					.push( moveiso( width, -depth, 0) )
					.push( rectiso( depth, height, ISO_RIGHT) )
					.push( moveiso( -width, 0, 0) );
			}
			
			return ret;
		}
		
		/**
		 * needs a points array containing arrays describing the points, 3 items, (x, y, z)
		 * is Absolute!
		 */
		public function polyiso( points:Array ):IDrawingCommand {
			
			var ret:DCGroup = new DCGroup;
			
			// loop through all the points and draw the appropritate lines
			for( var i:int = 0; i < points.length; i++){
				if( !(points[i] is Array) ) continue; 
				var loc:Array = points[i];
				// don't draw something when we don't have the right amount of points
				if( loc.length != 3 ) continue;
				
				// add the drawing instructions
				ret.push( lineiso( Number(loc[0]), Number(loc[1]), Number(loc[2]), ABSOLUTE) );
				
			}
			
			return ret;
		}
		
		/**
		 * needs a points array containing arrays describing the points, 2 items, (x, y)
		 * is Absolute!
		 * 
		 * points: array of 2d points describing the 
		 */
		public function polyiso2d( points:Array, orientation:int = 0, pos:Number = 0 ):IDrawingCommand {
			
			var ret:DCGroup = new DCGroup;
			
			// get the first position and move to that
			if(points.length <= 0) return null;
			if(!(points[0] is Array)) return null;
			
			var firstPoint:Array = points[0];
			
			var xStart:Number = 0;
			var yStart:Number = 0;
			if( firstPoint.length == 2){
				xStart = firstPoint[0];
				yStart = firstPoint[1];
			}
			
			// first a move instruction
			if( orientation == ISO_TOP)   ret.push( moveiso( xStart, yStart, pos, ABSOLUTE ) );
			if( orientation == ISO_LEFT)  ret.push( moveiso( xStart, pos, yStart, ABSOLUTE ) );
			if( orientation == ISO_RIGHT) ret.push( moveiso( pos, xStart, yStart, ABSOLUTE ) );
			
			// loop through all the points and draw the appropritate lines
			for( var i:int = 0; i < points.length; i++){
				if( !(points[i] is Array) ) continue; 
				var loc:Array = points[i];
				// don't draw something when we don't have the right amount of points
				if( loc.length != 2 ) continue;
				
				// add the drawing instructions
				
				if ( orientation == ISO_TOP) 
					ret.push( lineiso( Number(loc[0]), Number(loc[1]), pos, ABSOLUTE) );
				if ( orientation == ISO_LEFT) 
					ret.push( lineiso( Number(loc[0]), pos, Number(loc[1]), ABSOLUTE) );
				if ( orientation == ISO_RIGHT) 
					ret.push( lineiso( pos, Number(loc[0]), Number(loc[1]), ABSOLUTE) );
				
			}
			
			return ret;
		}
		
		
		/**
		 * needs a points array containing arrays describing the points, 2 items, (x, y)
		 * is Absolute!
		 * 
		 * points: array of 2d points describing the 
		 */
		public function poly( points:Array ):IDrawingCommand {
			
			var ret:DCGroup = new DCGroup;
			
			// get the first position and move to that
			if(points.length <= 0) return null;
			if(!(points[0] is Array)) return null;
			
			var firstPoint:Array = points[0];
			
			var xStart:Number = 0;
			var yStart:Number = 0;
			if( firstPoint.length == 2){
				xStart = firstPoint[0];
				yStart = firstPoint[1];
			}
			
			// first a move instruction
			ret.move( xStart, yStart, ABSOLUTE );
			
			
			// loop through all the points and draw the appropritate lines
			for( var i:int = 0; i < points.length; i++){
				if( !(points[i] is Array) ) continue; 
				var loc:Array = points[i];
				// don't draw something when we don't have the right amount of points
				if( loc.length != 2 ) continue;
				
				// add the drawing instructions
				
				ret.line( Number( loc[0] ), Number( loc[1] ), ABSOLUTE);
				
			}
			
			return ret;
		}
		
		
		/**
		 * USEFUL VARIABLES
		 * 
		 */
		
		/** 
		 * Wrapper for Math.PI variable
		 */
		public function get PI():Number {
			return Math.PI;
		}
		
		/** 
		 * Wrapper for Math.E variable
		 */
		public function get E():Number {
			return Math.E;
		}
		
		
		
		
		/**
		 * for rectangle & circle
		 */
		
		
		public function get CENTER():int { return 1; }
		public function get CORNER():int { return 0; }
		
		/**
		 * for positioning
		 */
		public function get RELATIVE():Boolean { return false; }
		public function get ABSOLUTE():Boolean { return true; }
		
		/**
		 * for orientation of boxes, rectangles and corners
		 */
		public function get UP():int { return 1; }
		public function get DOWN():int { return -1; }
		
		public function get LEFT():int { return 1; }
		public function get RIGHT():int { return -1; }
		
		public function get TOP():int { return 1; }
		public function get BOTTOM():int { return -1; }
		
		/**
		 * for drawing directions
		 */
		// clockwise (default)
		public function get CW():Boolean { return true; }
		
		// counter-clockwise
		public function get CCW():Boolean { return false; }
		
		/**
		 * for isometric views
		 */
		
		public function get ISO_LEFT():int { return 0; }
		public function get ISO_TOP():int { return 1; }
		public function get ISO_RIGHT():int { return 2; }
		
		public function get CUTOUT():Boolean { return true; }
	
		/**
		 * how should a box be filled?
		 */
		public function get SOLID():int { return 0; }
		public function get FILLED():int { return 1; }
		public function get SEETHROUGH():int { return 2; }
		public function get STRIPED():int { return 3; }
		public function get BACK():int { return 4; }
		
		
		private var _cos30:Number = 0.866025403784439;
		private var _sin30:Number = 0.5;
		
		
		/**
		 * for polar coordinates
		 */
		public function get TO_DEGREES():Number { return 180/Math.PI; }
		public function get TO_RADIANS():Number { return Math.PI/180; }
		
		
		/**
		 * EXPERIMENTAL: Supershape formula
		 * 
		 * from: http://prollcoder.com/index.php?/archives/6-SuperFormula-Shape-Flex-Component.html#extended
		 */
		
		private function EvalSuper(m: Number, n1: Number, n2: Number, n3: Number, phi: Number, a: Number, b: Number):Object
		{
			var r:Number=0;
			var t1:Number=0;
			var t2:Number=0;
			var xres:Number=0;
			var yres:Number=0;
			
			t1 = Math.cos(m * phi / 4) /a;
			t1 = Math.abs(t1);
			t1 = Math.pow(t1, n2);
			
			t2 = Math.sin(m * phi / 4) /b;
			t2 = Math.abs(t2);
			t2 = Math.pow(t2, n3);
			
			r = Math.pow(t1+t2, 1/n1);
			if (Math.abs(r) == 0) {
				xres = 0;
				yres = 0;
			} else {
				r = 1 / r;
				xres = r * Math.cos(phi);
				yres = r * Math.sin(phi);
			}
			return {xres: xres, yres: yres};
		}
		
		/**
		 * Superformula draws a superformula polygon.
		 */
		public function supershape(m:Number, n1:Number, n2:Number, n3:Number, a:Number = 1, b:Number = 1, points:Number = 200):IDrawingCommand
		{
			var x:Number = 100;
			var y:Number = 100;
			
			var centerx:Number = x;
			var centery:Number = y;
			
			var ret:DCGroup = new DCGroup;
			
			if(x>y) {
				x = y;
			}else {
				if(y>x) {
					
					y = x;
				}
			}
			
			var count:int = Math.abs(points);
			if (count>=2)
			{
				
				// calculate distance between points
				var step: Number = (Math.PI*2)/points;
				var halfStep: Number = step/2;
				
				var phi: Number = 0;
				var xvalues: Array = new Array();
				var yvalues: Array = new Array();
				var max:Number = 0;
				var i:uint;
				for (i= 0; i<points; i++) {
					//trace(objects[i]);
					phi += step;
					var res: Object = EvalSuper(m, n1, n2, n3, phi, a, b);
					xvalues.push(res.xres);
					yvalues.push(res.yres);
					
					if(Math.abs(res.xres)>max)max = Math.abs(res.xres);
					if(Math.abs(res.yres)>max)max = Math.abs(res.yres);
					
				}
				
				for (i= 0; i<xvalues.length; i++) {
					//trace(objects[i]);
					if(i==0) {
						
						ret.move( ((xvalues[i]/max)*x+ centerx),((yvalues[i]/max)*y+centery),true);
						//target.graphics.moveTo(, (yvalues[i]/max)*y+centery);
					}else {
						ret.line( ((xvalues[i]/max)*x+centerx), ((yvalues[i]/max)*y+centery), true);
						//target.graphics.lineTo((xvalues[i]/max)*x+centerx, (yvalues[i]/max)*y+centery);
					}
					
				}

			}
			
			// close the shape
			ret.close();0
			
			return ret;
		}
		
		
		
	}
}