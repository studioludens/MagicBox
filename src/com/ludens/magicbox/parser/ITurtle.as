package com.ludens.magicbox.parser
{
	import flash.geom.Matrix;
	import flash.geom.Point;

	public interface ITurtle
	{
		function get x():Number
		function get y():Number;
		function set x(value:Number):void;
		function set y(value:Number):void;
		function get angle():Number;
		
		function get position():Point;
		function get positionDelta():Point;
		
		function get transformationMatrix():Matrix;
		

		function set lineLength(value:Number):void;
		function get lineLength():Number;
		
		/**
		 * pen commands
		 */
		function set penUp( value:Boolean ):void;
		function get penUp():Boolean;
		
		/**
		 * relative movement
		 */
		function move( dx:Number, dy:Number ):void;
		
		/**
		 * absolute movement to position (x, y)
		 */
		function moveTo( x:Number, y:Number ):void;
		
		function moveForward(length:Number = NaN):void;
		function moveBackward(length:Number = NaN):void;
		
		
		function rotateLeft(angle:Number):void;
		function rotateRight(angle:Number):void;
		function rotateTo(angle:Number):void;
		
		function resetRotation():void;
		
		
		// state changing functions
		
		function pushState():void;
		
		function popState():void;
	}
}