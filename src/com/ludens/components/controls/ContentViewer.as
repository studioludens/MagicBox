package com.ludens.components.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.layouts.HorizontalLayout;
	
	
	public class ContentViewer extends Group
	{
		
		// Content
		private var _content		:UIComponent;
		private var _contentDirty	:Boolean = false;

		/**
		 * Content to be displayed
		 */
		public function get content():UIComponent {
			return _content;
		}

		/**
		 * @private
		 */
		public function set content(value:UIComponent):void {
			
			if( _content == value ) return;
			
			// remove old content from content box if necessary
			if( _content )
				_contentBox.removeElement( _content );
			
			// update content
			_content = value;
			
			// add new content to content box
			_contentBox.addElement( _content );
			// add event listeners to new content
			_content.addEventListener( ResizeEvent.RESIZE, contentResizeHandler, false, 0, true );
			
			updateNavigatorPreview();
			
			_contentDirty = true;
			invalidateProperties();
		}
		

		// Content X position
		private var _contentX		:Number  = 0;
		private var _contentXDirty	:Boolean = false;

		/**
		 * X position of the content (box)
		 */
		public function get contentX():Number {
			return _contentX;
		}

		/**
		 * @private
		 */
		[Bindable(event="contentXChanged")]
		public function set contentX(value:Number):void {
			_contentX = value;
			
			_contentXDirty = true;
			invalidateProperties();
			
			var event:Event = new Event( "contentXChanged" );
			dispatchEvent( event );
		}
		
		
		// Content Y position
		private var _contentY		:Number  = 0;
		private var _contentYDirty	:Boolean = false;
		
		/**
		 * Y position of the content (box)
		 */
		public function get contentY():Number {
			return _contentY;
		}
		
		/**
		 * @private
		 */
		[Bindable(event="contentYChanged")]
		public function set contentY(value:Number):void {
			_contentY = value;
			
			_contentYDirty = true;
			invalidateProperties();
			
			var event:Event = new Event( "contentYChanged" );
			dispatchEvent( event );
		}
		
		
		// Content Y position
		private var _contentScale		:Number  = 1;
		private var _contentScaleDirty	:Boolean = false;
		
		private var _scaleRefPoint		:Point = null;
		
		/**
		 * Y position of the content (box)
		 */
		public function get contentScale():Number {
			return _contentScale;
		}
		
		/**
		 * @private
		 */
		[Bindable(event="contentScaleChanged")]
		public function set contentScale(value:Number):void {
			_contentScale = value;
			
			_contentScaleDirty = true;
			invalidateProperties();
			
			var event:Event = new Event( "contentScaleChanged" );
			dispatchEvent( event );
		}
		
		
		
		
		
		
		// Auto-fit on update
		private var _autoFitOnUpdate:Boolean = true;

		/**
		 * Auto-fit on update
		 */
		public function get autoFitOnUpdate():Boolean {
			return _autoFitOnUpdate;
		}

		/**
		 * @private
		 */
		[Bindable(event="autoFitOnUpdateChanged")]
		public function set autoFitOnUpdate(value:Boolean):void {
			_autoFitOnUpdate = value;
			if( _autoFitOnUpdate ) scaleToFit();
			
			var event:Event = new Event( "autoFitOnUpdateChanged" );
			dispatchEvent( event );
		}
		
		
		
		
		
		// Box that contains the content
		// This allows scaling (and rotation) without affecting the original values of the content 
		private var _contentBox								:Group;
		
		// Navigator
		private var _navigatorBox							:BorderContainer;
		private var _navigator								:BorderContainer;
		private var _navigatorPreview						:Image;
		private var _navigatorIndicator						:BorderContainer;
		private var _navigatorMaxDimension					:Number = 125; 
		
		//private var _minScale								:Number = 0.1;
		//private var _maxScale								:Number = 5;
		
		
		
		public function ContentViewer() {
			super();
			
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
			addEventListener( MouseEvent.MOUSE_WHEEL, mouseWheelHandler );
		}
		
		
		
		/****************************************************************
		 * 
		 *  UICOMPONENT METHOD OVERRIDES
		 * 
		 ***************************************************************/

		
		override protected function createChildren():void {
			
			_contentBox = new Group();
			
			// clipping layout
			var clipLayout:HorizontalLayout = new HorizontalLayout();
			clipLayout.clipAndEnableScrolling = true;
			
			// box for navigator (with border and clipping)
			_navigatorBox = new BorderContainer();
			_navigatorBox.layout = clipLayout;
			_navigatorBox.visible = false;
			
			// navigator (contains preview & indicator)
			_navigator = new BorderContainer();
			_navigator.minWidth = 10;
			_navigator.minHeight = 10;
			
			// navigator preview (image)
			_navigatorPreview = new Image();
			
			// navigator indicator (box)
			_navigatorIndicator = new BorderContainer();
			_navigatorIndicator.setStyle( "backgroundAlpha", 0.3 );
			
			// add elements to display list
			addElement( _contentBox );
			addElement( _navigatorBox );
			_navigatorBox.addElement( _navigator );
			_navigator.addElement( _navigatorPreview );
			_navigator.addElement( _navigatorIndicator );
		}
		
		
		override protected function commitProperties():void {
			
			trace( "[ContentViewer] commitProperties" );
			
			super.commitProperties();

			
			// if the content should scale
			if( _contentScaleDirty ) {
				scaleContent( _contentScale, _scaleRefPoint );
				updateNavigator();	
			}
				
			// if the content should move
			if( _contentXDirty || _contentYDirty )	
				moveContent( contentX, contentY );
				
			// if the content has changed
			if( _contentDirty )
				scaleToFit();	
			
			
			// update navigator indicator if necessary
			if( _navigator.visible && 
				(_contentScaleDirty || _contentXDirty || _contentYDirty) )
				updateNavigatorIndicator();
			
			
			// reset flags 
			_contentScaleDirty = 
				_contentXDirty = 
				_contentYDirty = 
				 _contentDirty = false;
			_scaleRefPoint = null;
		}
		
		
		/****************************************************************
		 * 
		 *  MOUSE EVENT HANDLERS
		 * 
		 ***************************************************************/
		
	
		private var _oldMouseX:Number = 0, _oldMouseY:Number = 0;

		/**
		 * MouseDown handler
		 */
		private function mouseDownHandler( event:MouseEvent ):void {
			
			_oldMouseX = mouseX;
			_oldMouseY = mouseY;
			
			stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			stage.addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		}
		
		/**
		 * MouseMove handler
		 */
		private function mouseMoveHandler( event:MouseEvent ):void {
			
			var mouseDifX:Number = mouseX - _oldMouseX;
			var mouseDifY:Number = mouseY - _oldMouseY;
			
			_oldMouseX = mouseX;
			_oldMouseY = mouseY;
			
			contentX = contentX + mouseDifX;
			contentY = contentY + mouseDifY;
		}
		
		/**
		 * MouseUp handler
		 */
		private function mouseUpHandler( event:MouseEvent ):void {
			
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		}
		
		
		private var _scrollRatio	:Number = 0.02;
		
		/**
		 * MouseWheel handler
		 */
		private function mouseWheelHandler( event:MouseEvent ):void {
			
			trace( "[ContentViewer] mouseWheelHandler => event.delta = " + event.delta );
			
			/* calculate new scale */
			
			// get scroll delta from mouse
			var scrollDif	:int = event.delta;
			
			// calculate new scale from old scale of contentBox
			var oldScale	:Number = _contentBox.scaleX;
			var newScale	:Number = oldScale * (1 + scrollDif*_scrollRatio);
						
			// don't go on if we move outside the accepted scale boundaries
			if( newScale < 0.01 ) return;
			
			// get reference point (mouse position)
			var referencePoint:Point = new Point( mouseX, mouseY );

			
			contentScale = newScale;
			_scaleRefPoint = referencePoint;
		}
		
		
		/****************************************************************
		 * 
		 *  CONTENT UPDATE METHODS
		 * 
		 ***************************************************************/
		
		
		/**
		 * Update the visibility of the navigator.
		 * If the content is larger than the viewport, the navigator is visible. Otherwise, not.
		 */
		private function updateNavigator():void {
		
			var contentBoxScaleWidth	:Number = _contentBox.measuredWidth  * _contentBox.scaleX;
			var contentBoxScaleHeight	:Number = _contentBox.measuredHeight * _contentBox.scaleY;
			
			// *1.01 = hack to avoid navigator from showing when scaled to fit (rounding problem?)
			if( contentBoxScaleWidth >= width*1.01 || contentBoxScaleHeight >= height*1.01 )
				_navigatorBox.visible = true;
			else
				_navigatorBox.visible = false;
			
			updateNavigatorPreview();
		}
		
		
		
		/**
		 * Updates the image of the navigator preview.
		 */
		private function updateNavigatorPreview( ):void {
			
			trace( "[ContentViewer] updateNavigatorPreview" );
			
			// validate so the size of the content is updated
			// (in case of Image that has just loaded, for example)
			content.validateNow();
			
			// return if we have content with no dimensions
			if( content.width <= 0 || content.height <= 0 ) {
				trace( "  ERROR => content width and/or height <= 0" );
				return;
			}
			
			// determine width, height and scale (based on set max dimension)
			var navPreviewWidth		:Number;
			var navPreviewHeight	:Number;
			var navPreviewScale		:Number;
			
			if( content.width > content.height ) {
				navPreviewWidth = _navigatorMaxDimension;
				navPreviewHeight = content.height * (_navigatorMaxDimension/content.width); 
			} else {
				navPreviewHeight = _navigatorMaxDimension;
				navPreviewWidth = content.width * (_navigatorMaxDimension/content.height); 
			}
			
			// get scale and create matrix with scale
			navPreviewScale = navPreviewWidth / content.width;
			var matrix		:Matrix = new Matrix();
			matrix.scale( navPreviewScale, navPreviewScale );
			
			// create preview image
			var previewBD	:BitmapData = new BitmapData(navPreviewWidth, navPreviewHeight, true, 0);
			previewBD.draw( content, matrix );	
			var preview		:Bitmap = new Bitmap( previewBD );
			
			// set navigator preview and size
			_navigatorPreview.source = preview;
			_navigatorBox.width = navPreviewWidth;
			_navigatorBox.height = navPreviewHeight;
			
			trace( "  new preview => " + preview.width + "x" + preview.height + " (WxH)" );
		}
		
		/**
		 * Updates the view indicator in the navigator.
		 */
		private function updateNavigatorIndicator():void {
						
			var viewerRatio			:Number = width / height;
			var viewerToBoxRatio	:Number = width / (_contentBox.measuredWidth * _contentBox.scaleX);
			var viewerToNavRatio	:Number = _navigatorMaxDimension / width;
			var indicatorWidth		:Number = width * viewerToBoxRatio * viewerToNavRatio;
			var indicatorHeight		:Number = height * viewerToBoxRatio * viewerToNavRatio;
			
			var indicatorX	:Number = -_contentBox.x * viewerToBoxRatio * viewerToNavRatio;
			var indicatorY	:Number = -_contentBox.y * viewerToBoxRatio * viewerToNavRatio;
			
			_navigatorIndicator.setActualSize( 	indicatorWidth,
												indicatorHeight );
			_navigatorIndicator.move( 	indicatorX,
										indicatorY );
		}
		
		
		
		
		private function contentResizeHandler( event:ResizeEvent ):void {
			
			updateNavigatorPreview();
			
			if( _autoFitOnUpdate )
				scaleToFit();
		}
		
		
		
		/**
		 * Move the content (box).
		 * 
		 * TODO : include checks
		 */
		private function moveContent( moveX:Number, moveY:Number, 
									  moveRelative:Boolean = false ):void {
						
			if( moveRelative ) {
				contentX = _contentBox.x += moveX;
				contentY = _contentBox.y += moveY;
			}
			else {
				_contentBox.x = moveX;
				if( contentX != moveX )
					contentX = moveX;
				
				_contentBox.y = moveY;
				if( contentY != moveY )
					contentY = moveY;
			}
		}
		
		/**
		 * Scale the content (box).
		 * 
		 * TODO : include checks
		 */
		private function scaleContent( newScale:Number, referencePoint:Point = null ):void {
			
			if( !referencePoint ) {
				var contentBoxCenterX:Number = _contentBox.x + (_contentBox.measuredWidth * _contentBox.scaleX / 2);
				var contentBoxCenterY:Number = _contentBox.y + (_contentBox.measuredHeight * _contentBox.scaleY / 2);
				referencePoint = new Point( contentBoxCenterX, contentBoxCenterY );	
			}
			
			/* calculate displacement due to scaling (based on mouse position compared to content) */
			
			// actual content box dimensions
			var _contentBoxScaleWidth	:Number = _contentBox.measuredWidth * _contentBox.scaleX;
			var _contentBoxScaleHeight	:Number = _contentBox.measuredHeight * _contentBox.scaleY;
			
			// difference between new and old dimensions
			var widthDif	:Number = (_contentBox.measuredWidth * newScale)  - _contentBoxScaleWidth;	
			var heightDif	:Number = (_contentBox.measuredHeight * newScale) - _contentBoxScaleHeight;	
			
			// calculate move ratio
			// reference: 0 = don't move, 0.5 = move from center, 1 = move from bottom right corner of object
			var moveRatioX	:Number = (referencePoint.x - _contentBox.x) / _contentBoxScaleWidth;
			var moveRatioY	:Number = (referencePoint.y - _contentBox.y) / _contentBoxScaleHeight;
			
			// calc move values
			var moveX		:Number = -widthDif * moveRatioX;
			var moveY		:Number = -heightDif * moveRatioY;
			
			// scale
			_contentBox.scaleX = _contentBox.scaleY = newScale;
			// move
			if( moveX != 0 && moveY != 0 )
				moveContent( moveX, moveY, true );
		}
	
		
		
		public function scaleToFit():void {
			
			trace( "[ContentViewer] scaleToFit" );
						
			// calculate new scale
			var newScaleX	:Number = width  / _contentBox.measuredWidth;
			var newScaleY	:Number = height / _contentBox.measuredHeight;	
			var newScale	:Number = Math.min( newScaleX, newScaleY );
			
			
			// calculate new x,y,width,height
			var newWidth	:Number = _contentBox.measuredWidth * newScale;
			var newHeight	:Number = _contentBox.measuredHeight * newScale;
			var newX		:Number = (width - newWidth) / 2;
			var newY		:Number = (height - newHeight) / 2;
			
			// update values
			_contentX 		= newX;
			_contentY 		= newY;
			_contentScale 	= newScale;
			_scaleRefPoint 	= new Point( _contentBox.x, _contentBox.y );
			
			// set flags
			_contentXDirty 		= true;
			_contentYDirty 		= true;
			_contentScaleDirty 	= true;
			
			invalidateProperties();
		}
		
	}
}