package com.ludens.PackageHandler.view.layeroptions
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Bindable]
	public class LayerDisplaySettings extends EventDispatcher
	{
		public var showTransforms:Boolean 		= false;
		public var showStroke:Boolean 			= false;
		public var showFill:Boolean 			= false;
		public var showData:Boolean 			= false;
		public var showPosition:Boolean 		= false;
		public var showSize:Boolean 			= false;
		public var showText:Boolean 			= false;
		public var showTextEditor:Boolean 		= false;
		
		// extensions
		public var showBoolean:Boolean			= false;

		public function LayerDisplaySettings(defaults:Object, target:IEventDispatcher=null)
		{
			this.showTransforms 		= defaults.hasOwnProperty('showTransforms') 	? defaults.showTransforms 	: false;
			this.showStroke 			= defaults.hasOwnProperty('showStroke')			? defaults.showStroke		: false;
			this.showFill 				= defaults.hasOwnProperty('showFill')			? defaults.showFill			: false;
			this.showData 				= defaults.hasOwnProperty('showData')			? defaults.showData			: false;
			this.showPosition 			= defaults.hasOwnProperty('showPosition')		? defaults.showPosition		: false;
			this.showSize 				= defaults.hasOwnProperty('showSize')			? defaults.showSize			: false;
			this.showText 				= defaults.hasOwnProperty('showText')			? defaults.showText			: false;
			this.showTextEditor 		= defaults.hasOwnProperty('showTextEditor')		? defaults.showTextEditor	: false;
			
			this.showBoolean			= defaults.hasOwnProperty('showBoolean')		? defaults.showBoolean		: false;
			
			super(target);
		}
	}
}