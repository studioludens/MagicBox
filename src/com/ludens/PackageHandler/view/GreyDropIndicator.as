package com.ludens.PackageHandler.view
{

import flash.display.Graphics;
import mx.skins.ProgrammaticSkin;

/**
 *  The skin for the drop indicator of a list-based control.
 */
public class GreyDropIndicator extends ProgrammaticSkin
{

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 */
	public function GreyDropIndicator()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  direction
	//----------------------------------

	/**
	 *  Should the skin draw a horizontal line or vertical line.
	 *  Default is horizontal.
	 */
	public var direction:String = "horizontal";
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override protected function updateDisplayList(w:Number, h:Number):void
	{	
		super.updateDisplayList(w, h);

		var g:Graphics = graphics;
		
		g.clear();
		g.lineStyle(1, 0x777777);
				
		// Line
		if (direction == "horizontal")
		{
		    g.moveTo(0, 0);
		    g.lineTo(w, 0);
        }
        else
        {
            g.moveTo(0, 0);
            g.lineTo(0, h);
        }		
	}
}

}
