package com.ludens.utils
{
	import com.lorentz.SVG.MatrixTransformer;
	import com.lorentz.SVG.StringUtil;
	
	import flash.geom.Matrix;

	/**
	 * functions specific to the SVG language that can be of use to parse aspects of the language
	 */
	public class MagicBoxXMLUtil
	{
		public function MagicBoxXMLUtil()
		{
		}
		
		/**
		 * get the attribute name converted from  the special magic box format starting with mb_
		 * and CamelCase to a neat SVG attribute notation with -
		 * so mb_fillOpacity becomes fill-opacity
		 */
		public static function simplifyXMLAttributeName(text:String):String {
			
			var name:String = "";
			if(text.substr(0,3) == 'mb_'){
				// remove beginning
				name = text.substr(3);
			} else {
				name = text;
			}
			var ret:String = "";
			var pos:int = 0;
			for(var i:int = 0; i < name.length; i++){
				// is it a caps?
				
				var char:String = name.charAt( i );
				var charCode:int = name.charCodeAt( i );
				
				if( charCode >= 65 && charCode <= 90 ){
					// it's a capital
					ret += "-" + String.fromCharCode(charCode + 32);
					// convert to lowercase
					
				} else {
					ret += char;
				}
				
				
				
				// if so, replace it with a - and the smallcaps variant of the character
			}
			
			return ret;
		}
		
		/**
		 * get the attribute name converted to  the special magic box format starting with mb_
		 * and CamelCase to a neat SVG attribute notation with -
		 * so fill-opacity becomes mb_fillOpacity
		 */
		public static function convertXMLAttributeName(text:String):String {
			
			var name:String = text;
			
			var ret:String = "mb_";
			var pos:int = 0;
			
			var nextIsCapital:Boolean = false;
			
			for(var i:int = 0; i < name.length; i++){
				// is it a - ?
				
				var char:String = name.charAt( i );
				
				if( char == '-' ){
					nextIsCapital = true;
				} else {
					if( nextIsCapital ){
						ret += char.toUpperCase();
						nextIsCapital = false;
					} else {
						ret += char;
					}
				}
			}
			
			return ret;
		}
		
		/**
		 * adapted from lorentz svg parser
		 */
		public static function parseTransformation(m:String):XML {
			if(m.length == 0) {
				return null;
			}
			
			var fix_m:String = StringUtil.rtrim(m, ")");
			var att_array:Array = fix_m.split(")");
			
			var transforms:XML = new XML("<transforms></transforms>");
			
			
			for each(var att:String in att_array){
				var name:String = StringUtil.trim(att.split("(")[0]).toLowerCase();
				
				var args:Array = parseArgsData(att.split("(")[1]);
				
				var transform:XML = new XML("<transform></transform>");
				
				transform["@type"] = name;
				
				if(name=="matrix"){
					
					transform["@a"] = Number(args[0]);
					transform["@b"] = Number(args[1]);
					transform["@c"] = Number(args[2]);
					transform["@d"] = Number(args[3]);
					transform["@tx"] = Number(args[4]);
					transform["@ty"] = Number(args[5]);
					
				}
				
				switch(name){
					case "translate": 
						transform["@x"] = Number(args[0]);
						transform["@y"] = args[1]!=null? Number(args[1]) : Number(args[0]);
						break;
					case "scale" 	: 
						transform["@sx"] = Number(args[0]);
						transform["@sy"] = args[1]!=null? Number(args[1]) : Number(args[0]);
						break;
					case "rotate"	: 
						transform["@angle"] = Number(args[0]);
						transform["@cx"] = args[1]!=null?Number(args[1]):0;
						transform["@cy"] = args[2]!=null?Number(args[2]):0;
						
						break;
					case "skewx" 	: 
						transform["@skewx"] = Number(args[0]);
						break;
					case "skewy" 	: 
						transform["@skewy"] = Number(args[0]);
						break;
				}
				
				transforms.appendChild( transform );
			}
			return transforms;
		}
		
		/**
		 * from lorentz svg parser
		 */
		public static function parseArgsData(input:String):Array { 
			var returnData:Array=new Array();
			
			var last_char:String = null;
			var cur_char:String = null;
			var cur_arg:String = "";
			var i:int = 0;
			while(i<input.length){
				cur_char = input.charAt(i);
				if(cur_char=="-" && last_char!="e"){
					if(cur_arg!="")
						returnData.push(cur_arg);
					cur_arg = cur_char;
				} else if(cur_char=="," || cur_char==" " || cur_char=="\t" || cur_char=="\r" || cur_char=="\n"){
					if(cur_arg!="")
						returnData.push(cur_arg);
					cur_arg = "";
				} else {
					cur_arg+=cur_char;
				}
				last_char = cur_char;
				i++;
			}
			if(cur_arg!=="")
				returnData.push(cur_arg);
			
			return (returnData); 
		}
	}
}