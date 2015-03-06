package com.ludens.PackageHandler.view
{
	import com.ludens.PackageHandler.events.DescriptorEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.core.UIComponent;
	
	import net.brandonmeyer.containers.SuperPanel;

	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when an item add is requested.
	 *
	 *  @eventType net.brandonmeyer.events.SuperPanelEvent.MAXIMIZE
	 */
	[Event(name="addNew", type="com.ludens.PackageHandler.events.DescriptorEvent")]
	
	
	/**
	 *  The style name for the add item button.
	 */
	[Style(name="addItemButtonStyleName", type="String", inherit="no")]


	public class BoxPanel extends SuperPanel
	{

		//--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
	    //----------------------------------
	    //  allowAddItem
	    //----------------------------------
	    
	    /**
	     *  @private
	     */
	    private var _allowAddItem:Boolean = false;
	    private var _allowAddItemDirty:Boolean = false;
	    
	    /**
	     *  Indicates whether the panel will show the close 
	     * 	button.
	     */
	    [Bindable]
	    public function set allowAddItem(value:Boolean):void
	    {
	    	if (_allowAddItem == value)
	    		return;
	    	
	    	_allowAddItem = value;
	    	_allowAddItemDirty = true;
	    	
	    	invalidateProperties();
	    }
	    
	   
	    
	    // add item button
	    private var addItemButton:Button;
 		
 		private var _addItemButtonSkinDirty:Boolean = true;
 
 		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
 	
		public function BoxPanel()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
	    //
	    //  UIComponent override methods
	    //
	    //--------------------------------------------------------------------------
		
		override protected function createChildren():void {
			
			super.createChildren();
			
			
			if( !addItemButton ) {
				
				addItemButton = new Button();
	    		addItemButton.width = addItemButton.height = 16;
	    		addItemButton.addEventListener(MouseEvent.CLICK, 
	    										addItemButton_clickHandler, 
	    										false, 
	    										0, 
	    										true);	
	    										
	    		addItemButton.toolTip = "add new item";    		
	    		
	    		//addChild( addItemButton );
	    		buttonContainer.addChild(addItemButton);
			}
		}
	
		override protected function commitProperties():void {
			
			super.commitProperties();
			
			if( _allowAddItemDirty ) {
				addItemButton.visible = _allowAddItem;
			}
			if (_addItemButtonSkinDirty)
    	    {
    	        addItemButton.styleName = this.getStyle("addItemButtonStyleName");
    	        _addItemButtonSkinDirty = false;
    	    }
		}
		
		override public function styleChanged(styleProp:String):void {
		
	    	super.styleChanged(styleProp);
	    	
	    	switch (styleProp) {
	    		
	    		case "addItemButtonStyleName": {
	    			_addItemButtonSkinDirty = true;
	    			invalidateProperties();
	    			
	    			break;
	    		}
	    	}
	 	}
		
		
		override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.layoutChrome( unscaledWidth, unscaledHeight );
				
			/*
	
			// position add item button
			
			var padding		:Number = 8;	
    		
			if( addItemButton && contains(addItemButton) )
    			addItemButton.move( padding, (titleBar.height - addItemButton.height) * 0.5);
    		
    		// position title bar
    		
    		var titleText:DisplayObject = DisplayObject( titleTextField );
    		
    		if( titleText && titleBar.contains( titleText ) ) {
    			titleTextField.move( addItemButton.x + addItemButton.width + padding/2,
    								 (titleBar.height - titleText.height) * 0.7 );
	    	}
	    	
	    	*/
	    		
		}
		
		
		private function addItemButton_clickHandler( e:MouseEvent ):void {
			
			var event:DescriptorEvent = new DescriptorEvent( DescriptorEvent.ADD_NEW, true );
			dispatchEvent( event );	
		}
	}
}