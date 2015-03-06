package com.ludens.PackageHandler
{
	import com.ludens.PackageHandler.packages.PackageViewer;
	
	import mx.binding.utils.*;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.HSlider;
	import mx.controls.Label;
	import mx.controls.NumericStepper;
	
	/**
	 * PackageInterfaceCreator helps you to create interface objects for a packageViewer object
	 * 
	 */
	public class PackageInterfaceCreator
	{
		public function PackageInterfaceCreator()
		{
			//TODO: implement function
		}
		
		public static function createInterface(xml:XML, pv:PackageViewer):Canvas {
			// make a panel
			
			// fill the panel with the interface elements
			/*var panel:Panel = new Panel();
			panel.width = 212;
			panel.layout = "vertical";
			panel.title = "Properties";
			*/
			var canvas:Canvas = new Canvas();
			
			var vBox:VBox = new VBox();
			
			
			
			
			// loop through the xml and parse each element
			for each(var variable:XML in xml.variable){
				
				var hBox:HBox = new HBox();
				//hBox.width = "100%";
				
				
				// add items to HBox
				
				var textLabel:Label = new Label();
				textLabel.text = variable.@title;
				textLabel.width = 60;
				hBox.addChild(textLabel);
				
				// check parameter "display"
				if(variable.@display == "slider"){
					// make a slider and bind it to the object
					var hSlider:HSlider = new HSlider();
					hSlider.width = 130;
					hSlider.liveDragging = true;
					
					trace("[PIC] creating interface for: " + variable.@name);
					// check if the variable exists in the PackageViewer. Should! otherwise throw an error
					if(pv[variable.@name]){
						// set default value
						hSlider.value = pv[variable.@name.toString()];
					} else {
						throw new Error("Package not implemented properly!");
					}
					
					// minimum
					if(variable.@min)
						hSlider.minimum = variable.@min.toString();
					else
						hSlider.minimum = 0; // default value
						
					// maximum
					if(variable.@max)
						hSlider.maximum = variable.@max.toString();
					else
						hSlider.maximum = 100; // default value
					
					// default value
					/*
					if(variable.@value)
						hSlider.value = variable.@value.toString();
					else
						hSlider.value = 100; // default value
					*/
					// add it to the hbox
					hBox.addChild(hSlider);
					
					// bind it!
					BindingUtils.bindProperty(pv, variable.@name.toString(), hSlider, "value");
					
				}
				
				if(variable.@display == "text"){
					// make a slider and bind it to the object
					var text:NumericStepper = new NumericStepper();
					text.width = 60;
					
					
					trace("[PIC] creating interface for: " + variable.@name);//trace(variable.@name);
					// check if the variable exists in the PackageViewer. Should! otherwise throw an error
					if(pv[variable.@name]){
						// set default value
						text.value = pv[variable.@name.toString()];
					} else {
						throw new Error("Package not implemented properly!");
					}
					
					// minimum
					if(variable.@min)
						text.minimum = variable.@min.toString();
					else
						text.minimum = 0; // default value
						
					// maximum
					if(variable.@max)
						text.maximum = variable.@max.toString();
					else
						text.maximum = 100; // default value
					
					// default value
					/*
					if(variable.@value)
						hSlider.value = variable.@value.toString();
					else
						hSlider.value = 100; // default value
					*/
					// add it to the hbox
					hBox.addChild(text);
					
					// make a 'mm' label
					var mmLabel:Label = new Label();
					mmLabel.text = "mm";
					
					hBox.addChild(mmLabel);
					// bind it!
					BindingUtils.bindProperty(pv, variable.@name.toString(), text, "value");
					
				}
				
				vBox.addChild(hBox);
			}
			
			// all children added, put it in a canvas and let's go!
			
			canvas.addChild(vBox);
			return canvas;
		}

	}
}