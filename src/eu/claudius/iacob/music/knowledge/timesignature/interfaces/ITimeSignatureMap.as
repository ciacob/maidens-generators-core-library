package eu.claudius.iacob.music.knowledge.timesignature.interfaces {
	import ro.ciacob.math.IFraction;
	
	/**
	 * Container to store a number of musical measures with their respective time signatures.
	 * @author Claudius Iacob
	 */
	public interface ITimeSignatureMap {
		
		/**
		 * Returns the total musical duration as an IFraction instance.
		 */
		function get duration () : IFraction;
		
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
		 * Returns ITimeSignatureEntry instance at given index.
		 */
		function getAt (index : int) : ITimeSignatureEntry;
		
		/**
		 * @see Array.indexOf
		 */
		function indexOf (searchEntry : ITimeSignatureEntry, fromIndex : int = 0) : int;
		
		/**
		 * @see Array.insertAt
		 */
		function insertAt (index : int, entry : ITimeSignatureEntry) : void;
		
		/**
		 * @see Array.lastIndexOf
		 */
		function lastIndexOf (searchEntry : ITimeSignatureEntry, fromIndex : int = 0x7fffffff) : int;
		
		/**
		 * @see Array.pop
		 */
		function pop() : ITimeSignatureEntry;
		
		/**
		 * @see Array.push
		 */
		function push (... entries) : uint;
		
		/**
		 * @see Array.removeAt
		 */
		function removeAt(index:int):ITimeSignatureEntry;
		
		/**
		 * @see Array.reverse
		 */
		function reverse() : void;
		
		/**
		 * @see Array.shift
		 */
		function shift() : ITimeSignatureEntry;
		
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