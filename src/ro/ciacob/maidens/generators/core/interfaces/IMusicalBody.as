package ro.ciacob.maidens.generators.core.interfaces {
	
	import ro.ciacob.math.IFraction;
	
	/**
	 * A container for IMusicUnit objects, representing the actual musical result of a generation
	 * operation, in a meta-musical format.
	 * @author Claudius Iacob
	 */
	public interface IMusicalBody {

		/**
		 * Returns the total musical duration of the contained IMusicUnit objects, as a IFraction
		 * instance. This is automatically calculated whenever IMusicUnits are added to or removed
		 * from the IMusicalBody.
		 * 
		 * HOWEVER, individual changes to the "duration" property of already added IMusicUnits are not
		 * tracked. If you alter the "duration" of already added IMusicUnits, you must call 
		 * `updateDuration()` to update the value returned by `duration`.
		 */
		function get duration () : IFraction;
		
		/**
		 * Recalculate the total musical duration of the contained IMusicUnit objects. Note that this is
		 * a time consumming process. Make sure you call this function as seldom as possible - e.g., call
		 * it at the end of a loop, not with every iteration.
		 */
		function updateDuration () : void;
		
		/**
		 * @see Array.length
		 */
		function get length () : uint;
		
		/**
		 * @see Array.length
		 */
		function set length (value : uint) : void;
		
		/**
		 * @see Array.every
		 */
		function every (callback : Function) : Boolean;
		
		/**
		 * @see Array.forEach
		 */
		function forEach (callback:Function) : void;
		
		/**
		 * Returns IMusicUnit instance at given index.
		 */
		function getAt (index : int) : IMusicUnit;
		
		/**
		 * @see Array.indexOf
		 */
		function indexOf (searchUnit : IMusicUnit, fromIndex : int = 0) : int;
		
		/**
		 * @see Array.insertAt
		 */
		function insertAt (index : int, unit : IMusicUnit) : void;
		
		/**
		 * @see Array.lastIndexOf
		 */
		function lastIndexOf (searchUnit : IMusicUnit, fromIndex : int = 0x7fffffff) : int;
		
		/**
		 * @see Array.pop
		 */
		function pop() : IMusicUnit;
		
		/**
		 * @see Array.push
		 */
		function push (... units) : uint;
		
		/**
		 * @see Array.removeAt
		 */
		function removeAt(index:int):IMusicUnit;
		
		/**
		 * @see Array.reverse
		 */
		function reverse() : void;
		
		/**
		 * @see Array.shift
		 */
		function shift() : IMusicUnit;
		
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
		function splice (startIndex:int, deleteCount:uint = 4294967295, ... units) : void;
		
		/**
		 * @see Array.toString
		 */
		function toString() : String;
		
		/**
		 * @see Array.unshift
		 */
		function unshift (... units) : uint;
	}
}