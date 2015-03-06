package com.ludens.magicbox.model
{
	import com.ludens.magicbox.model.layer.BooleanLayer;
	import com.ludens.magicbox.model.layer.GroupLayer;
	import com.ludens.magicbox.model.layer.Layer;
	import com.ludens.magicbox.model.layer.PathLayer;
	import com.ludens.magicbox.model.layer.RectLayer;
	import com.ludens.magicbox.model.layer.TextLayer;
	import com.ludens.magicbox.model.layer.transform.LayerTransform;
	
	import mx.controls.Label;

	/**
	 * this class provides helper functions for creating layers
	 * - from xml
	 * - from svg
	 */
	public class LayerFactory
	{
		/**
		 * icons
		 */
		[Embed (source="assets/icons/vector.png")]
		[Bindable]
		public static var PathIcon:Class;
		
		[Embed (source="assets/icons/font.png")]
		[Bindable]
		public static var TextIcon:Class;
		
		[Embed (source="assets/icons/application.png")]
		[Bindable]
		public static var GeneralIcon:Class;
		
		[Embed (source="assets/icons/shape_square.png")]
		[Bindable]
		public static var RectIcon:Class;
		
		[Embed (source="assets/icons/shape_group.png")]
		[Bindable]
		public static var GroupIcon:Class;
		
		/**
		 * default layers
		 */
		[Embed (source="assets/xml/defaultGroupLayer.xml", mimeType="text/xml")]
		[Bindable]
		public static var DefaultGroupLayer:Class;
		
		[Embed (source="assets/xml/defaultTextLayer.xml", mimeType="text/xml")]
		[Bindable]
		public static var DefaultTextLayer:Class;
		
		[Embed (source="assets/xml/defaultRectLayer.xml", mimeType="text/xml")]
		[Bindable]
		public static var DefaultRectLayer:Class;
		
		[Embed (source="assets/xml/defaultPathLayer.xml", mimeType="text/xml")]
		[Bindable]
		public static var DefaultPathLayer:Class;
		
		[Embed (source="assets/xml/defaultTransformLayer.xml", mimeType="text/xml")]
		[Bindable]
		public static var DefaultTransformLayer:Class;
		
		[Embed (source="assets/xml/defaultBooleanLayer.xml", mimeType="text/xml")]
		[Bindable]
		public static var DefaultBooleanLayer:Class;
		
		/*
		public static var defaultLayers:Object = {
			g: DefaultGroupLayer,
			text: DefaultTextLayer,
			rect: DefaultRectLayer,
			transform: DefaultTransformLayer,
			path: DefaultPathLayer,
			boolean: DefaultBooleanLayer
		};
		
		public static var layerTypes:Object = {
			g: GroupLayer,
			text: TextLayer,
			rect: RectLayer,
			transform: LayerTransform,
			path: PathLayer,
			boolean: BooleanLayer
			
		};*/
			
		
		public function LayerFactory()
		{
		}
		
		
		/**
		 * create a magic box layer from a type indicator
		 * - only default layers are allowed
		 */
		public static function createFromType( type:String = null ):Layer {
			// TODO: implement function
			
			var newLayer:Layer;
			
			switch( type ){
				case "g":
				case "group":
					return new GroupLayer(LayerFactory.DefaultGroupLayer.data as XML );
					break;
				case "path":
					return new PathLayer(LayerFactory.DefaultPathLayer.data as XML );
					break;
				case "rect":
					return new RectLayer(LayerFactory.DefaultRectLayer.data as XML );
					break;
				case "text":
					return new TextLayer(LayerFactory.DefaultTextLayer.data as XML );
					break;
				case "transform":
					return new LayerTransform( LayerFactory.DefaultTransformLayer.data as XML );
					break;
				case "boolean":
					return new BooleanLayer( LayerFactory.DefaultBooleanLayer.data as XML );
					break;
				default:
					// we should probably give some kind of warning
					return new PathLayer(LayerFactory.DefaultPathLayer.data as XML );
			}
			
		}
		
		public static function createFromXML( xml:XML ):Layer {
			
			var type:String = xml.localName();
			
			switch( type ){
				case "g":
					return new GroupLayer( xml );
					break;
				case "path":
					return new PathLayer( xml );
					break;
				case "rect":
					return new RectLayer( xml );
					break;
				case "text":
					return new TextLayer( xml );
					break;
				case "transform":
					return new LayerTransform( xml );
					break;
				case "boolean":
					return new BooleanLayer( xml );
					break;
				default:
					return new PathLayer( xml );
			}
		}
		
		public static function createFromClass( theClass:Class ):Layer {
			// TODO: implement function
			return new Layer();
		}
		
		public static function createFromSVG( svg:XML ):Layer {
			// TODO: implement function
			return new Layer();
		}
		
		public static function getAttributeDefaultValue(attributeName:String):String
		{
			switch( attributeName ){
				case "mb__staticData":
					return "true";
					break;
				default:
					return "0";
					
			}
			// TODO Auto Generated method stub
			return null;
		}
	}
}