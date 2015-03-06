package com.ludens.PackageHandler.view.labeltextinput
{
	
	import com.ludens.PackageHandler.events.ValueChangeEvent;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import spark.components.TextInput;

	[Event(name="changeValue", type="com.ludens.PackageHandler.events.ValueChangeEvent")]
	
	public class LabelTextInput extends TextInput
	{
		
		public var hasFocus:Boolean = false;
		private var cssProps:Object;
		
		private var nameChangedSinceFocus:Boolean = false;
		private var originalText:String = "";
		
		private var nameChangeTimer:Timer;
		private var nameChangeTimerDelay:Number = 500;
		
		public function LabelTextInput()
		{
			super();
		}
		
		override protected function createChildren():void {
			
			super.createChildren();
			
			cssProps = catchCSSProps();
			hideChrome();
			
			// add events
			
			var changeTimeoutStyle:* = getStyle("changeTimeout");
			if( changeTimeoutStyle != undefined ){
				// set the timeout value
				nameChangeTimerDelay = Number( changeTimeoutStyle );
			}
			nameChangeTimer = new Timer( nameChangeTimerDelay );
			nameChangeTimer.addEventListener(TimerEvent.TIMER, timerTimerHandler );

			
		}
		
		override protected function focusInHandler(event:FocusEvent):void {
			
			hasFocus = true;
			
			super.focusInHandler( event );
			
			originalText = this.text;
			
			
			
			showChrome();
		}
		
		override protected function focusOutHandler(event:FocusEvent):void {
			
			hasFocus = false;
			
			super.focusOutHandler( event );
			
			if (originalText != text ){
				nameChangedSinceFocus = true;
				fireChangeEvent();
			}
			
			
			
			hideChrome();
		}
		
		/**
		 * handlers for more subtle handling of changing values
		 * 
		 * -- we fire a ValueChangeEvent when:
		 * - the contents of the text field have changed AND either
		 * -- the mouse exists the text field
		 * -- the user pressed enter
		 * -- a timeout happens
		 */
		private function timerTimerHandler( e:TimerEvent ):void {
			
			nameChangeTimer.stop();
			
			if( originalText != text ){
				// the value has changed
				fireChangeEvent();
			}
		}
		
		override protected function keyUpHandler( e:KeyboardEvent ):void {
			
			super.keyUpHandler( e );
			
			// if enter is pressed
			if(e.keyCode == 13 && originalText != text){
				fireChangeEvent();
			} 
			if( originalText != text ){
				nameChangeTimer.reset();
				nameChangeTimer.start();
			}
			
			
		}
		
		/**
		 * fire a valueChangeEvent telling everybody the value has really changed
		 */
		
		private function fireChangeEvent():void {
			
			// stop the timer so we don't accidentally fire two events
			nameChangeTimer.stop();
			
			originalText = text;
			
			nameChangedSinceFocus = false;
			var evt:ValueChangeEvent = new ValueChangeEvent( ValueChangeEvent.CHANGE_VALUE );
			dispatchEvent( evt );
		}
		
		
		private function catchCSSProps():Object {
			
			var props:Object = new Object();
			
			props["borderAlpha"] = getStyle( "borderAlpha" );
			//props["borderStyle"] = getStyle( "borderStyle" );
			props["contentBackgroundAlpha"] = getStyle( "contentBackgroundAlpha" );
					
			return props;
		}
		
		private function hideChrome():void {
			
			setStyle( "borderAlpha", 0 );
			//setStyle( "borderStyle", "none" );
			setStyle( "contentBackgroundAlpha", 0 );	
		}
		
		private function showChrome():void {
			
			// only show chrome if it is editable
			if(this.editable){
			
				for( var propName:String in cssProps ) {
					setStyle( propName, cssProps[propName] );
				}
			}
		}
		
	}
}