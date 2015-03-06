package com.ludens.controllers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class UndoRedoController extends EventDispatcher
	{
		private var undoArray:Array;
		private var redoArray:Array;
		
		private var _currentState:Object;
		
		public function get currentState():Object {
			return _currentState;
		}
		
		
		[Bindable(event="hasUndoChanged")]
		public function get canUndo():Boolean {
			return ( undoArray.length > 0 );
		}
		[Bindable(event="hasRedoChanged")]
		public function get canRedo():Boolean {
			return ( redoArray.length > 0 );
		}
		
		
		
		public function UndoRedoController()
		{
			undoArray = new Array();
			redoArray = new Array();
		}
		
		
		
		public function saveState( state:Object ):void {
			
			// add state to undo array
			if( _currentState )
				undoArray.push( _currentState );
			// clear redo array
			redoArray = [];
			
			_currentState = state;
			
			updateHasUndoRedo();
		}
		
		
		
		public function undo( state:Object ):Object {
			
			// is there anything that can be undone?
			if( !canUndo ) {
				trace( "ERROR: failed attempt to undo state" );
				return state;
			}
			
			// add current state to redo array
			redoArray.push( state );
			
			_currentState = undoArray.pop();
			
			updateHasUndoRedo();
			
			// pop last change from undo array & return it
			return _currentState;
		}
		
		
		
		public function redo( state:Object ):Object {
			
			// is there anything that can be redone?
			if( !canRedo ) {
				trace( "ERROR: failed attempt to redo state" );
				return state;
			}
			
			// add current state to undo array
			undoArray.push( state );
			
			_currentState = redoArray.pop();
			
			updateHasUndoRedo();
			
			// pop last change from redo array & return it
			return _currentState;
		}
		
		
		private function updateHasUndoRedo():void {
			
			dispatchEvent( new Event("hasUndoChanged") );
			dispatchEvent( new Event("hasRedoChanged") );
		}
	}
}