package com.ludens.magicbox.parser
{
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * The Turtle class implements a simple 2D Turtle that can react to a number of commands
	 * 
	 * 
	 */
	public class Turtle implements ITurtle
	{
		
		
		/**
		 * PUBLIC variables
		 */
		
		private var _position:Point;
		
		/**
		 * is the pen in the up state?
		 */
		private var _penUp:Boolean = false;
		
		/**
		 * the change in position from the last instruction
		 */
		private var _positionDelta:Point;
		
		
		private var _lineLength:Number = 100;
		
		
		/**
		 * PRIVATE varables
		 */
		
		private var _angle:Number;
		
		private var angle_dX:Number;
		private var angle_dY:Number;
		
		/* this stack can save the positions and other values of the turtle in 
		case of a pushState() command
		
		instance values can later be retreived with the popState() command
		*/
		
		private var _instanceStack:Array;
		
		private var _instanceCount:int = 0;
		
		/**
		 *  STATIC variables
		 */
		
		static public var toDEGREES :Number = 180/Math.PI;
		static public var toRADIANS :Number = Math.PI/180;
		
		public function Turtle():void {
			
			_angle = 0.0;
			_position = new Point(0,0);
			
			_positionDelta = new Point(0,0);
			
			
			_instanceStack = new Array();
			
			calculateAngle();
			
			
			
		}
		
		
		
		/*
		public function clone():ITurtle {
		var t:Turtle = new Turtle();
		t.x = position.x;
		t.y = position.y;
		t.angle = _angle;
		return t;
		}
		*/
		
		public function copy(turtle:Object):void{
			this.x = turtle.x;
			this.y = turtle.y;
			this.angle = turtle.angle;
			
		}
		
		
		
		public function pushState():void {
			
			//trace("[Turtle] pushState() called");
			
			// save all the values and push it onto the array
			var prevTurtle:Object = {
				x: position.x,
					y: position.y,
					angle: _angle,
					
					lineLength: _lineLength
			};
			
			
			var i:int = _instanceStack.push( prevTurtle );
			
			//trace("[Turtle] pushState() called 2");
			
			_instanceCount++;
		}
		
		public function popState():void {
			
			// TODO: do some checking here
			
			//trace("[Turtle] popState() called");
			var newTurtle:Object = _instanceStack.pop();
			
			this.copy(newTurtle);
			
			
			
			_instanceCount--;
			
			calculateAngle();
		}
		
		/**
		 * absolute movement
		 */
		public function moveTo( x:Number, y:Number ):void {
			_position.x = x;
			_position.y = y;
		}
		
		/**
		 * relative movement
		 * - not related to the rotation angle
		 */
		public function move( dx:Number, dy:Number ):void {
			_position.x += dx;
			_position.y += dy;
		}
		
		public function moveForward(length:Number = NaN):void{
			if(length){
				
				_positionDelta.x = length * angle_dX;
				_positionDelta.y = length * angle_dY;
			} else {
				_positionDelta.x = _lineLength * angle_dX;
				_positionDelta.y = _lineLength * angle_dY;
			}
			
			_position.x += _positionDelta.x;
			_position.y += _positionDelta.y;
		}
		
		public function moveBackward(length:Number = NaN):void{
			if(length){
				_positionDelta.x = -length * angle_dX;
				_positionDelta.y = -length * angle_dY;
			} else {
				_positionDelta.x = -_lineLength * angle_dX;
				_positionDelta.y = -_lineLength * angle_dY;
			}
			
			_position.x += _positionDelta.x;
			_position.y += _positionDelta.y;
		}
		
		
		
		public function rotateLeft(angle:Number):void{
			_angle -= angle;
			calculateAngle();
		}
		
		
		
		public function rotateRight(angle:Number):void{
			_angle += angle;
			calculateAngle();
		}
		
		public function resetRotation():void {
			_angle = 0;
			calculateAngle();
		}
		
		public function rotateTo( angle:Number ):void {
			_angle = angle;
			calculateAngle();
		}
		
		/**
		 * set the angle in degrees
		 */
		public function set angle(value:Number):void {
			_angle = value;
			calculateAngle();
		}
		
		public function get angle():Number {
			return _angle;
		}
		
		public function set x(value:Number):void {
			_position.x = value;
		}
		
		public function get x():Number {
			return _position.x;
		}
		
		public function set y(value:Number):void {
			_position.y = value;
		}
		
		public function get y():Number {
			return _position.y;
		}
		
		public function get position():Point {
			return _position;
		}
		
		public function get positionDelta():Point {
			return _positionDelta;
		}
		
		public function get lineLength():Number {
			return _lineLength;
		}
		
		public function set lineLength(value:Number):void {
			_lineLength = value;
		}
		
		
		
		public function set penUp(value:Boolean):void {
			_penUp = value;
			
		}
		
		public function get penUp():Boolean {
			return _penUp;
		}
		
		
		
		public function get transformationMatrix():Matrix {
			var m:Matrix = new Matrix;
			m.translate( _position.x, _position.y );
			m.rotate( _angle * toRADIANS );
			return m;
		}
		
		private function calculateAngle():void {
			angle_dX = Math.sin(_angle * toRADIANS);
			angle_dY = -Math.cos(_angle * toRADIANS);
		}
	}
}