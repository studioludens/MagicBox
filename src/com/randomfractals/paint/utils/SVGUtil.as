/*
Copyright (c) 2009 Random Fractals, Inc. (www.randomfractals.com)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package com.randomfractals.paint.utils
{
	import com.degrafa.GeometryGroup;
	import com.degrafa.IGeometry;
	import com.degrafa.core.IGraphicsStroke;
	import com.degrafa.decorators.IDecorator;
	import com.degrafa.decorators.standard.SVGDashLine;
	import com.degrafa.geometry.Path;
	import com.degrafa.paint.SolidStroke;
	
	public class SVGUtil
	{
		public static function getSVGHeader(width:Number, height:Number):String
		{			
			var header:String = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?> \r' +
				' \r' +
				'<svg width="' + width + '\mm" height="' + height +
				'mm" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"> \r';
			return header;
		}
		
		public static function getSVG(geometry:IGeometry, width:Number, height:Number, unit:String = "mm"):String {
			
			
			if(unit == "px") {
				// output in pixels
				return getSVGHeader(width, height) + 
					getGeometryString(geometry) + 
					"</svg>";
			} else if(unit == "mm") {
				// output in mm
				return getSVGHeader(width, height) + 
					'<g transform="scale(2.83462)">' +
					getGeometryString(geometry) + 
					'</g>' + 
					"</svg>";
			} else {
				return "error";
			}
			
			return "";
				
		}
		
		public static function getGeometryString(geometry:IGeometry, 
			fillColor:int = -1, indent:uint = 2):String
		{
			var indentStr:String = getIndentString(indent);
			var svgText:String = '';
			if (geometry is GeometryGroup)
			{
				var group:GeometryGroup = geometry as GeometryGroup;
				
				svgText += indentStr + '<g id="' + group.id + '\"> \r';
				// doesn't work properly
				/*
				svgText += indentStr + '<g id="' + group.id +
					'" ' + (fillColor != -1 ? 'style="fill: ' + ColorUtil.decColorToHex(fillColor, "#") +  '"' : '') + '> \r';
				
				*/ 	
				if (group.geometryCollection.items.length > 0)
				{
					for each (var node:IGeometry in group.geometryCollection.items)
					{
						svgText += getGeometryString(node, fillColor, indent+2);
					}
				}
				svgText += indentStr + '</g> \r';
			}
			else if (geometry is Path)
			{
				var path:Path = geometry as Path;												
				svgText += indentStr + '<path id="' + path.id + '" \r' +
					indentStr + getStyleString(path.stroke, path.decorators) + 
					indentStr + '  d="' + path.data + '\" /> \r';
			}
			return svgText;
		}
	
		public static function getStyleString(stroke:IGraphicsStroke, decorators:Array = null):String
		{
			var strokeStr:String = '  style="';
			if (stroke is SolidStroke)
			{
				var solidStroke:SolidStroke = stroke as SolidStroke;
				strokeStr += 
					'stroke: ' + '#FF0000' +
					'; stroke-width: ' + '0.001mm' +
					'; stroke-opacity: ' + solidStroke.alpha.toString().substr(0, 4) +						 
					'; stroke-linecap: ' + solidStroke.caps +
					'; stroke-linejoin: ' + solidStroke.joints + 
					'; ' + getDecoratorString(decorators) + 
					' fill: none;"\r';	
			}
			return strokeStr;
		}
		
		public static function getDecoratorString(decorators:Array):String {
			var decoratorStr:String = '';
			
			// loop through all decorators
			for each(var decorator:IDecorator in decorators){
				
				// set the svg line style based on the SVGDashLine parameters
				if(decorator is SVGDashLine){ 
					var dashDecorator:SVGDashLine = decorator as SVGDashLine;
					
					decoratorStr += "stroke-dasharray: " + dashDecorator.dashArray + ";"
				}
			}
			
			
			return decoratorStr;
			
		}
		
		private static function getIndentString(indent:uint):String
		{
			var indentString:String = '';
			for (var i:uint = 0; i<indent; i++)
			{
				indentString += ' ';
			}
			return indentString;
		}
	}
}