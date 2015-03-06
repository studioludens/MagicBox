package com.ludens.magicbox.parser
{
	

	/**
	 * code gets executed in this context. We can give it some initial functions, settings to make it easier to
	 * create useful designs
	 */
	public dynamic class ParserContext extends ParserContextBase
	{
		private var __depth:int = 0;
		
		
		
		/**
		 * a transformation matrix defining the current 
		*/
		public function ParserContext()
		{
		}
		
		/**
		 * clone method for creating an exact copy of all dynamic properties
		 * 
		 * this is not actually a deep clone for all the object properties in the context
		 * 
		 * TODO: determine if this should be the case
		 * for now there is one object: the Turtle
		 */
		
		public function clone():ParserContext {
			
			var ret:ParserContext = new ParserContext();
			
			// loop through all properties of this object
			for( var prop:* in this){
				//trace(prop);
				ret[prop] = this[prop];
				
			}
			
			// save turtle state
			ret.turtle = this.turtle;
			
			return ret;
			
		}
		
		public function increaseDepth():int {
			/* parse all context variables */
			/* this is a fast implementation, but it is a bit long. maybe solve this
				iteratively
			*/
			/* maximum level of depth is 9 levels.
			*/
			if( this.hasOwnProperty( "________") ) 	this['_________'] 	= this['________'];
			if( this.hasOwnProperty( "_______") ) 	this['________'] 	= this['_______'];
			if( this.hasOwnProperty( "______") ) 	this['_______'] 	= this['______'];
			if( this.hasOwnProperty( "_____") ) 	this['______'] 		= this['_____'];
			if( this.hasOwnProperty( "____") ) 		this['_____'] 		= this['____'];
			if( this.hasOwnProperty( "___") ) 		this['____'] 		= this['___'];
			if( this.hasOwnProperty( "__") ) 		this['___'] 		= this['__'];
			if( this.hasOwnProperty( "_") ) 		this['__'] 		  	= this['_'];
			
			return ++__depth;
		}
		
		public function decreaseDepth():int {
			return --__depth;
		}
		
	}
}