package com.ludens.components.text
{
	import mx.controls.TextArea;
	
	public class CaretTextArea extends TextArea
	{
		public function CaretTextArea()
		{
			super();
		}
		
		public function get caretIndex():int {
			
			return textField.caretIndex;
		}
	}
}