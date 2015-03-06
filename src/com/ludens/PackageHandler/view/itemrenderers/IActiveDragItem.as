package com.ludens.PackageHandler.view.itemrenderers
{
	import flash.geom.Point;
	
	public interface IActiveDragItem
	{
		function requestDragClearance( globalMousePos:Point ):Boolean;
	}

}