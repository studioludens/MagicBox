package com.ludens.components.text
{
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextLineMetrics;
	
	import mx.controls.TextArea;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	/**
	 * this class is a plain TextArea which height resizes vertically to fit
	 * all the text in its container.
	 */
	public class AutoWidthTextArea extends TextArea
	{
		
		private var numOfLines:uint = 0;
		private var _defaultText:String = "type text here";
		
		private var _defaultTextColor	:int = 0x555555;
		private var _activeTextColor 	:int = 0x000000;
		
		/**
		 * activeTextColor get/set
		 */
		public function set activeTextColor(value:int):void {
			
			_activeTextColor = value;
			
			if( text != "" )
				this.setStyle( "color", value );
		}
		
		public function get activeTextColor():int {
			
			return _activeTextColor;
		}
		
		override public function get text():String {
			
			if( this.textField.text == _defaultText )
				return "";
			else
				return this.textField.text;
		}
		
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------	    
				
		public function AutoWidthTextArea()
		{
			super();
			
			this.wordWrap = false;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			
			addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  UIComponent override methods
	  	//
		//--------------------------------------------------------------------------
		
		override public function styleChanged(styleProp:String):void {
			
			super.styleChanged( styleProp );
			
			if( styleProp == "fontFamily" )
				invalidateDisplayList();
		}
				
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		
			textField.validateNow();
			
			setStyle("textIndent", getStyle("fontSize") * 0.25 );
		
			var newNumOfLines:int = this.mx_internal::getTextField().numLines;
			var maxWidth:Number = 0;
			
			for( var i:int = 0; i < newNumOfLines; i++ ) {
				
				var metrics:TextLineMetrics = this.getLineMetrics( i );
				if( metrics.width > maxWidth )
					maxWidth = metrics.width;
			}
			
			var extraSpace:Number = this.getStyle("fontSize") * 0.25;
			//this.setStyle( "textIndent", extraSpace );
			extraSpace *= 2.5;
			
			//width = 
			this.maxWidth = maxWidth + extraSpace;
			this.minWidth = maxWidth + extraSpace;
			
			//var newHeight:Number = this.getStyle("fontSize") / 3;
			var newHeight:Number = 5;
			for(var j:int=0; j < newNumOfLines; j++) {
				newHeight += this.mx_internal::getTextField().getLineMetrics(j).height;
			}
			
			this.maxHeight = newHeight;
			this.minHeight = newHeight;
			
			horizontalScrollPosition = 0;
			verticalScrollPosition  = 0;
			
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Private methods
	  	//
		//--------------------------------------------------------------------------
		
		private function creationCompleteHandler(event:FlexEvent):void {
			
			if( this.text == "" ) {
				this.text = _defaultText;
				this.setStyle("color", _defaultTextColor );
			}
		}
		
		/**
		 * Overridden keyDownHandler to remove default text if
		 * anything is being typed
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void {
			
			super.keyDownHandler(event);
			
			invalidateDisplayList();		
		}
		
		/**
		 * sets text string to empty if text is currently the default text,
		 * when TextArea gets focus
		 */
		override protected function focusInHandler(event:FocusEvent):void {
			
			if( this.textField.text == _defaultText ) {
				this.textField.text = "";
				this.minWidth = 10;
				
				// change the color to the active color
				this.setStyle("color", _activeTextColor.toString() );
			}
			
			super.focusInHandler( event );
		}
		
		/**
		 * sets text string to default text if text is currently empty,
		 * when TextArea loses focus
		 */
		override protected function focusOutHandler(event:FocusEvent):void {
			
			if( this.textField.text == "" ) {
				this.textField.text = _defaultText;
				this.minWidth = 160;
				this.setStyle("color", _defaultTextColor.toString() );
			}
				
			super.focusOutHandler( event );
		}
	}
}