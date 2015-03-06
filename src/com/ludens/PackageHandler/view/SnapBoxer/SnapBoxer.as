package com.ludens.PackageHandler.view.SnapBoxer
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Box;
	import mx.containers.Canvas;
	import mx.core.Container;
	import mx.core.UIComponent;


	[Style(name="boxBackgroundColor", type="int", inherit="no")]
	
	
	[Style(name="boxBackgroundAlpha", type="Number", inherit="no")]
	

	public class SnapBoxer extends Canvas
	{
		private var snapComponents		:ArrayCollection;
		public var mainContainer		:Container;
		
		private var componentHasMoved	:Boolean = false;
		
		private var componentToSnap		:UIComponent;
		private var targetSnapBox		:Box;
		
		public function SnapBoxer()
		{
			super();
			
			snapComponents = new ArrayCollection();
		}
		
		public function addSnapComponent( component:UIComponent ):void {
			
			// add component to the list of snap components
			snapComponents.addItem( component );
			
			// listen for mouse downs on the component to trace drags / moves
			component.addEventListener( MouseEvent.MOUSE_DOWN, componentMouseDownHandler, true );
		}
		
		private function componentMouseDownHandler( e:MouseEvent ):void {
			
			// get component
			var component:UIComponent = UIComponent( e.currentTarget );
			
			component.parent.removeChild( component );
			mainContainer.addChild( component );
			
			// listen for mouse move
			component.addEventListener( MouseEvent.MOUSE_MOVE, componentMouseMoveHandler );
			// listen for mouse up
			component.addEventListener( MouseEvent.MOUSE_UP, componentMouseUpHandler );
		}
		
		private function componentMouseMoveHandler( e:MouseEvent ):void {
			
			// get component
			var component		:UIComponent = UIComponent( e.currentTarget );
			
			// the component should be able to be dragged around, so we return it to the main container
			var oldPos		:Point = new Point( component.x, component.y );
			var globalPos	:Point = component.parent.localToGlobal( oldPos );
			var newPos		:Point = mainContainer.globalToLocal( globalPos );
			
			
			component.move( newPos.x, newPos.y );
			
			var box				:Box;
			var children		:Array = getChildren();
			
		
			// set flag (for the mouse up)
			componentHasMoved = true;

			// check for each snap box in SnapBoxer...
			for each( box in children ) {
				
				// .. whether it touches the dragged component
				if( box.hitTestObject( component ) )
					// if so, make it light up
					box.setStyle( "backgroundAlpha", 0.3 );
				else
					// otherwise, make it less prominent
					box.setStyle( "backgroundAlpha", 0.1 );
					
			}
		}
		
		private function componentMouseUpHandler( e:MouseEvent ):void {
			
			// get component
			var component		:UIComponent = UIComponent( e.currentTarget );
			
			var box				:Box;
			var children		:Array = getChildren();
			
			// remove mouse_move and mouse_up listeners 
			component.removeEventListener( MouseEvent.MOUSE_MOVE, componentMouseMoveHandler );
			component.removeEventListener( MouseEvent.MOUSE_UP, componentMouseUpHandler );
			
			// do nothing if the object hasn't moved
			if( !componentHasMoved )
				return;
			
			componentHasMoved = false;	
			
			// for each box in SnapBoxer...
			for each( box in children ) {
				
				// ... check whether it touches the dragged component
				if( box.hitTestObject( component ) ) {
					
					// if so
					
					// save component and box
					componentToSnap = component;
					targetSnapBox = box;
			
					// call inv. display list, to update the parent of the component
					invalidateDisplayList();
				}
				
				// reset box style in any case
				box.setStyle( "backgroundAlpha", 0 );
			}
		}
		
		
		
		override protected function createChildren():void {
			
			super.createChildren();
			
			var box				:Box;
			var children		:Array = getChildren();
			
			for each( box in children ) {
				
				box.setStyle( "backgroundColor", getStyle("boxBackgroundColor") );
				box.setStyle( "backgroundAlpha", getStyle("boxBackgroundAlpha") );
			}
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if( componentToSnap != null ) {
				
				componentToSnap.parent.removeChild( componentToSnap );
				targetSnapBox.addChild( componentToSnap );
				
				componentToSnap.width = targetSnapBox.width;
				
				componentToSnap = null;
				targetSnapBox = null;
			}
		}
		
	}
}