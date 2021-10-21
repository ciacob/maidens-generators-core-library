package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	 * Dedicated container to store named "Parameter" instances.
	 * @author Claudius Iacob
	 */
	public interface IParametersList {
		
		/**
		 * @see Array.length
		 */
		function get length () : uint;
		
		/**
		 * @see Array.every
		 */
		function every (callback : Function) : Boolean;
		
		/**
		 * @see Array.forEach
		 */
		function forEach (callback:Function) : void;
		
		/**
		 * Returns IParameter instance at given index.
		 */
		function getAt (index : int) : IParameter;
		
		/**
		 * Returns all IParameter instance that share the given name, in the order they have been added.
		 */
		function getByName (parameterName : String) : Vector.<IParameter>;
		
		/**
		 * Returns the IParameter matching the given unique ID, or null if there is no match.
		 */
		function getByUid (parameterUid : String) : IParameter;
		
		/**
		 * @see Array.indexOf
		 */
		function indexOf (searchParameter : IParameter, fromIndex : int = 0) : int;
		
		/**
		 * @see Array.insertAt
		 */
		function insertAt (index : int, parameter : IParameter) : void;
		
		/**
		 * @see Array.lastIndexOf
		 */
		function lastIndexOf (searchParameter : IParameter, fromIndex : int = 0x7fffffff) : int;
		
		/**
		 * @see Array.pop
		 */
		function pop() : IParameter;
		
		/**
		 * @see Array.push
		 */
		function push (... parameters) : uint;
		
		/**
		 * @see Array.removeAt
		 */
		function removeAt(index:int):IParameter;
		
		/**
		 * @see Array.reverse
		 */
		function reverse() : void;
		
		/**
		 * @see Array.shift
		 */
		function shift() : IParameter;
		
		/**
		 * @see Array.some
		 */
		function some(callback:Function) : Boolean;
		
		/**
		 * @see Array.sort
		 */
		function sort (... args) : void;
		
		/**
		 * @see Array.splice
		 */
		function splice (startIndex:int, deleteCount:uint = 4294967295, ... parameters) : void;
		
		/**
		 * @see Array.toString
		 */
		function toString() : String;
		
		/**
		 * @see Array.unshift
		 */
		function unshift (... parameters) : uint;
		
	}
}