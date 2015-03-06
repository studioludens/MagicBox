package com.ludens.PackageHandler.svg
{
	import com.ludens.magicbox.model.layer.LayerCollection;
	
	import mx.collections.CursorBookmark;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.collections.XMLListCollection;
	import mx.controls.treeClasses.DefaultDataDescriptor;
	import mx.controls.treeClasses.ITreeDataDescriptor;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	public class LayerTreeDescriptor extends DefaultDataDescriptor implements ITreeDataDescriptor
	{
		public function LayerTreeDescriptor()
		{
		}
		/*
		override public function getChildren(node:Object, model:Object = null):ICollectionView {
			
			var newChildren:XMLList = new XMLList();
			//var newChildren:LayerCollection = new LayerCollection;
			
			
			for( var i:int = 0; i < XML(node).children().length(); i++){
				if( XML(XML(node).children()[i]).name() != 'transforms')
					newChildren += ( XML(node).children()[i] );
			}
			return new XMLListCollection( newChildren );
		}*/
		
		/*
		override public function hasChildren(node:Object, model:Object = null):Boolean {
			// an svg element can only have children when it's a group
			if( XML(node).localName() != 'g' ) 
				return false;
			else
				return getChildren(node,model) && getChildren(node,model).length > 0;
		}*/
		
		/*
		override public function isBranch(node:Object, model:Object = null):Boolean {
			return hasChildren(node, model);
		}*/
		
		
	}
}