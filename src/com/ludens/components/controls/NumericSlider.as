package com.ludens.components.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.HSlider;
	import mx.controls.TextInput;
	import mx.events.SliderEvent;


	public class NumericSlider extends Canvas
	{
		[Embed(source="../../../../assets/images/arrow_down.png")]
		private var ButtonIcon:Class;

		
		
		private var textInput:TextInput;
		private var button:Button;
		
		private var slider:HSlider;
		
		
		private var _inputHeight:Number = 25;
		private var inputHeightDirty:Boolean = true;
		
		public function get inputHeight():Number {
			return _inputHeight;
		}
		public function set inputHeight( value:Number ):void {
			_inputHeight = value;
			inputHeightDirty = true;
			invalidateDisplayList();
		}
		
		
		
		private var _minimum:Number = 0;
		private var minimumDirty:Boolean = true;
		
		public function get minimum():Number {
			return _minimum;
		}
		public function set minimum( value:Number ):void {
			_minimum = value;
			minimumDirty = true;
			invalidateProperties();
		}
		
		
		
		private var _maximum:Number = 1;
		private var maximumDirty:Boolean = true;
		
		public function get maximum():Number {
			return _maximum;
		}
		public function set maximum( value:Number ):void {
			_maximum = value;
			maximumDirty = true;
			invalidateProperties();
		}
		
		
		
		private var _sliderInterval:Number = 0.01;
		private var sliderIntervalDirty:Boolean = true;
		
		public function get sliderInterval():Number {
			return _sliderInterval;
		}
		public function set sliderInterval( value:Number ):void {
			_sliderInterval = value;
			sliderIntervalDirty = true;
		}
		
		public function NumericSlider()
		{
			super();
			
			addEventListener( Event.ADDED_TO_STAGE, onATS );
			
			clipContent = false;
		}
		
		override protected function createChildren():void {
			
			super.createChildren();
			
			textInput = new TextInput();
			textInput.restrict = "0-9 .";
			textInput.addEventListener( Event.CHANGE, textInputChangeHandler );
			addChild( textInput );
			
			button = new Button();
			button.toggle = true;
			button.setStyle( "icon", ButtonIcon );
			button.addEventListener( MouseEvent.CLICK, buttonClickHandler );
			addChild( button );
			
			slider = new HSlider();
			slider.addEventListener( SliderEvent.CHANGE, sliderChangeHandler );
			slider.liveDragging = true;
			hideSlider();
			addChild( slider );
			
		}
		
		override protected function commitProperties():void {
			
			super.commitProperties();
			
			if( minimumDirty ) {		
				slider.minimum = _minimum;
				minimumDirty = false;
			}
			if( maximumDirty ) {		
				slider.maximum = _maximum;
				maximumDirty = false;
			}
			if( sliderIntervalDirty ) {		
				slider.snapInterval = _sliderInterval
				sliderIntervalDirty = false;
			}
				
			
		}
		


		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			button.width = _inputHeight;
			button.height = _inputHeight;
			button.x = unscaledWidth - button.width;
			
			textInput.width = unscaledWidth - button.width;
			textInput.height = _inputHeight;
			
			slider.width = unscaledWidth;
			slider.y = _inputHeight;
		}
		
		
		
		private function onATS( e:Event ):void {
			
			stage.addEventListener( MouseEvent.CLICK, stageClickHandler );
		}
		
		private function stageClickHandler( e:MouseEvent ):void {
			
			if( mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height )
				return; 
			
			button.selected = false;
			hideSlider();
		}
		
		private function buttonClickHandler( e:MouseEvent ):void {
			
			if( button.selected == true )
				showSlider();
			else
				hideSlider();
		}
		
		private function textInputChangeHandler( e:Event ):void {
			
			slider.value = Number(textInput.text);
		}
		
		private function sliderChangeHandler( e:SliderEvent ):void {
			
			textInput.text = e.value.toString();
		}
		
		
		
		
		
		private function hideSlider():void {
			slider.visible = false;
			slider.includeInLayout = false;
		}
		
		private function showSlider():void {
			slider.visible = true;
			slider.includeInLayout = true;
		}
		
	}
}