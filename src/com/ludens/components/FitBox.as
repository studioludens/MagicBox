package com.ludens.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	public class FitBox extends Group
	{
		private var _container:Group;
		
		public function FitBox()
		{
			super();
			
			_container = new Group();
			_container.includeInLayout = false;
			
			BindingUtils.bindProperty( _container, "width", this, "width" );
			BindingUtils.bindProperty( _container, "height", this, "height" );
			
			addElement( _container );
			
			addEventListener( Event.RESIZE, updateElementScale );
			addEventListener( Event.RENDER, updateElementScale );
		}
		
		
		private var childrenDirty:Boolean = false;
		
		
		override public function addChild(child:DisplayObject):DisplayObject {
			
			_container.addChild( child );
			childrenDirty = true;		
			return child;
		}
		
		override public function set mxmlContent(value:Array):void {
			
			_container.mxmlContent = value;			
			updateElementScale();
			
			childrenDirty= true;
			invalidateProperties();
		}
		
		
		override protected function commitProperties():void {
			
			if( childrenDirty ) {	
				for( var i:uint = 0; i < _container.numChildren; i++ )	{
					var element:UIComponent = _container.getChildAt( i ) as UIComponent;
					element.addEventListener( Event.RESIZE, updateElementScale, false, 0, true );
					element.addEventListener( Event.RENDER, updateElementScale, false, 0, true );
				}
					
				childrenDirty = false;
			}
		}
		
		
		
		protected function updateElementScale( e:Event = null ):void {
						
			for( var i:uint = 0; i < _container.numElements; i++ ) {
				
				var element:UIComponent = _container.getElementAt( i ) as UIComponent;
				
				//trace( "fit box dimensions: " + width + " " + height );
				//trace( "child dimensions: " + element.width + " " + element.height );
				
				var targetScaleX:Number = _container.width/element.width;
				var targetScaleY:Number = _container.height/element.height;
				
				var targetScale:Number = Math.min( targetScaleX, targetScaleY );
				
				//trace( "[FitBox] updateelementScale => targetScale: " + targetScale );
				
				element.scaleX = element.scaleY = targetScale;				
			}
		}
	}
}