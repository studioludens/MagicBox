package com.ludens.controllers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	
	import mx.core.IUIComponent;
	import mx.printing.FlexPrintJob;
	import mx.printing.FlexPrintJobScaleType;

	/**
	 * controls printing, on any device that has a printing interface.
	 * - inkjet & laser printers
	 * - laser cutters
	 * - CNC ?
	 */
	public class PrintController extends EventDispatcher
	{
		
		//private var _printJob:FlexPrintJob = new FlexPrintJob();
		private var _printJob:PrintJob = new PrintJob();
		
		public function print( layer:DisplayObject ):void {
			
			var options:PrintJobOptions = new PrintJobOptions(false);
			
			// show the print dialog, if the user clicks cancel, don't do anything else
			if(! _printJob.start()) return;
			
			//_printJob.addEventListener( Event.ACTIVATE, printActivateListener );
			//_printJob.addEventListener( Event.DEACTIVATE, printDeactivateListener );
			//_printJob.addObject( layer, FlexPrintJobScaleType.NONE);
			
			_printJob.addPage( Sprite(layer), new Rectangle( 0, 0, layer.width, layer.height), options );
			//_printJob.paperWidth = layer.width;
			//_printJob.pageHeight = layer.height;
			
			// do it!
			_printJob.send();
			
			
		}
		
		private var _ready:Boolean = true;
		
		public function get ready():Boolean {
			return _ready;
		}
		
		private function printActivateListener( e:Event ):void {
			
		}
		
		private function printDeactivateListener( e:Event ):void {
			
		}
		
		/**
		 * Singleton Class INFO
		 */
		private static var instance:PrintController = new PrintController();
		
		
		public function PrintController() {
			if( instance ) throw new Error( "Singleton and can only be accessed through Singleton.getInstance()" );
		}
		
		public static function getInstance():PrintController {
			return instance;
		}
		
	}
}