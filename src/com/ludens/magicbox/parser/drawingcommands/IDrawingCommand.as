package com.ludens.magicbox.parser.drawingcommands
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public interface IDrawingCommand
	{
		/** 
		 * parse the instruction to a string
		 */
		function toString():String;
		
		/**
		 * get the bounds of this instruction
		 */
		function getBounds():Rectangle;
		
		/**
		 * get an array of polygon points
		 */
		function get poly():Array;
		
		function get startPoint():Point;
		function get endPoint():Point;
		
		/**
		 * get the previous command
		 */
		function get previous():IDrawingCommand;
		function set previous( value:IDrawingCommand ):void;
		
	}
}