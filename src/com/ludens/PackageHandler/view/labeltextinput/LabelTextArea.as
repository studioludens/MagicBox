package com.ludens.PackageHandler.view.labeltextinput
{
	import flash.events.FocusEvent;
	
	import mx.controls.TextArea;
	import mx.controls.TextInput;

	public class LabelTextArea extends TextArea
	{
		private var cssProps:Object; 
		
		
		
		public function LabelTextArea()
		{
			super();
		}
		
		override protected function createChildren():void {
			
			super.createChildren();
			
			cssProps = catchCSSProps();
			hideChrome();
		}
		
		override protected function focusInHandler(event:FocusEvent):void {
			
			super.focusInHandler( event );
			
			showChrome();
		}
		
		override protected function focusOutHandler(event:FocusEvent):void {
			
			super.focusOutHandler( event );
			
			hideChrome();
		}
		
		private function catchCSSProps():Object {
			
			var props:Object = new Object();
			
			props["borderSkin"] = getStyle( "borderSkin" );
			props["borderStyle"] = getStyle( "borderStyle" );
			props["backgroundAlpha"] = getStyle( "backgroundAlpha" );
					
			return props;
		}
		
		private function hideChrome():void {
			
			setStyle( "borderSkin", BorderlessSkin );
			setStyle( "borderStyle", "none" );
			setStyle( "backgroundAlpha", 0 );	
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