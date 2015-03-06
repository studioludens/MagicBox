package com.ludens.PackageHandler.view
{
	import com.ludens.PackageHandler.view.itemrenderers.IActiveDragItem;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.List;
	import mx.controls.Tree;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.mx_internal;
	import mx.events.DragEvent;

	use namespace mx_internal;
	
	
	[Event(name="requestSave", type="com.ludens.PackageHandler.events.StateEvent")]
	
	public class SmartTree extends Tree
	{
		public function SmartTree()
		{
			super(); 
			
			variableRowHeight = true;
			
			// add functionality to drop something inside an item
			this.addEventListener( DragEvent.DRAG_OVER, dragOverHandler );
			//this.addEventListener(DragEvent.DRAG_DROP, dropHandler );
		}
		
		
		
		private var hasDragClearance:Boolean = true;
		
		
		/**
		 *  Extended the dragging functionality with a check whether the
		 *  item that is attempted to be dragged, is allowed to do so.
		 * 
		 *  It passes the mouse position to the dragItem to see if some
		 *  region of the item renderer is grabbed where dragging from is allowed.
		 *
		 *  @param event The MouseEvent object.
		 */
		override protected function mouseDownHandler(event:MouseEvent):void {
			
			if (!enabled || !selectable)
				return;
			
			var pt:Point = new Point(event.localX, event.localY);
			pt = DisplayObject(event.target).localToGlobal(pt);
			pt = globalToLocal(pt);
			
			
			var item:IListItemRenderer = mouseEventToItemRenderer(event);
			
			if( item is IActiveDragItem ) 
				hasDragClearance = IActiveDragItem( item ).requestDragClearance( localToGlobal( pt ) );
			else
				hasDragClearance = true;
			
			
			super.mouseDownHandler( event );
		}
		
		
		/**
		 *  Extended the dragging functionality with a check whether the
		 *  item that is attempted to be dragged, is allowed to do so.
		 * 
		 *  It passes the mouse position to the dragItem to see if some
		 *  region of the item renderer is grabbed where dragging from is allowed.
		 *
		 *  @param event The MouseEvent object.
		 */
		override protected function mouseMoveHandler(event:MouseEvent):void
		{
			if (!enabled || !selectable)
				return;
			
			var pt:Point = new Point(event.localX, event.localY);
			pt = DisplayObject(event.target).localToGlobal(pt);
			pt = globalToLocal(pt);
			
			
			var item:IListItemRenderer = mouseEventToItemRenderer(event);
			
			if( hasDragClearance )
				super.mouseMoveHandler( event );
			else {
				
				// we used to put shields into each of the renderers so leftover space was hittable
				// but that's makes too many shields at startup and scrolling.  The gamble is that we
				// can run the code even on a large grid very quickly compared to mouse move intervals.
				if (item && highlightItemRenderer)
				{
					var rowData:BaseListData = rowMap[item.name];
					if (highlightItemRenderer && highlightUID && rowData.uid != highlightUID)
					{
						if (!isPressed)
						{
							if (getStyle("useRollOver") && highlightItemRenderer.data != null)
							{
								clearHighlight(highlightItemRenderer)
							}
						}
					}
				}
				else if (!item && highlightItemRenderer)
				{
					if (!isPressed)
					{
						if (getStyle("useRollOver") && highlightItemRenderer.data)
						{
							clearHighlight(highlightItemRenderer)
						}
					}
				}
				
				if (item && !highlightItemRenderer)
				{
					mouseOverHandler(event);
				}
			}
		}
		
		
		
	}
}