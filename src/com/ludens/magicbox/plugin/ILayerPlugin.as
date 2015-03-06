package com.ludens.magicbox.plugin
{
	import flash.display.DisplayObject;

	public interface ILayerPlugin
	{
		
		/**
		 * a descriptive, 16x16px icon for this layer
		 */
		function getIcon():Class;
		
		/**
		 * an SVG compatible xml string to draw the layer
		 */
		function getSVG():XML;
		
		/**
		 * the plugin class
		 */
		function getPluginClass():String;
		
		/**
		 * communicates the design parameters to the layer plugin, so it can do something with it
		 */
		function setParameters( parameters:XMLList ):void;
		
		/**
		 * the interface shown in the magic box editor
		 */
		function getInterface():DisplayObject;
		
	}
}