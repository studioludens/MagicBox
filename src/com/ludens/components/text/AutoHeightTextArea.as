package com.ludens.components.text
{
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	
	import mx.controls.TextArea;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	/**
	 * this class is a plain TextArea which height resizes vertically to fit
	 * all the text in its container.
	 */
	public class AutoHeightTextArea extends TextArea
	{
		
		private var numOfLines:uint = 0;
		private var _defaultText:String = "type text here";
		
		private var _defaultTextColor	:int = 0x555555;
		private var _activeTextColor 	:int = 0x222222;
		
		/**
		 * activeTextColor get/set
		 */
		public function set defaultTextColor(value:int):void {
			
			_defaultTextColor = value;
			validateCurrentTextColor();
		}
		
		public function get defaultTextColor():int {
			
			return _defaultTextColor;
		}
		
		/**
		 * activeTextColor get/set
		 */
		public function set activeTextColor(value:int):void {
			
			_activeTextColor = value;
			validateCurrentTextColor();
		}
		
		public function get activeTextColor():int {
			
			return _activeTextColor;
		}
		
		
		
		
				
		override public function set text( value:String ):void {
			
			super.text = value;
			validateCurrentTextColor();
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
				
		public function AutoHeightTextArea()
		{
			super();
			
			this.wordWrap = true;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			
			addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  UIComponent override methods
	  	//
		//--------------------------------------------------------------------------
		
				
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		
			var newNumOfLines:int = this.mx_internal::getTextField().numLines;
			
			var newHeight:Number = 7;
			for(var i:int=0; i < newNumOfLines; i++) {
				newHeight += this.mx_internal::getTextField().getLineMetrics(i).height;
			}
			
			newHeight += getStyle( "paddingTop" ) + getStyle( "paddingBottom" );
			
			this.maxHeight = newHeight;
			this.minHeight = newHeight;
			
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Private methods
	  	//
		//--------------------------------------------------------------------------
		
		private function creationCompleteHandler(event:FlexEvent):void {
			
			if( this.text == "" ) {
				this.text = _defaultText;
				this.setStyle("color", _defaultTextColor);
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
			
			super.focusInHandler( event );
			
			if( this.textField.text == _defaultText ) {
				this.textField.text = "";
				validateCurrentTextColor();
				this.validateNow();
			}
		}
		
		/**
		 * sets text string to default text if text is currently empty,
		 * when TextArea loses focus
		 */
		override protected function focusOutHandler(event:FocusEvent):void {
			
			super.focusOutHandler( event );
			
			if( this.textField.text == "" ) {
				this.textField.text = _defaultText;
				validateCurrentTextColor();
				//this.setStyle("color", _defaultTextColor.toString() );
			}
		}
		
		
		private function validateCurrentTextColor():void {
			
			if( !this.textField )
				return;
				
			if( this.textField.text == _defaultText )
				this.setStyle("color", _defaultTextColor.toString() );
			else
				this.setStyle("color", _activeTextColor.toString() );
		}
	}
}