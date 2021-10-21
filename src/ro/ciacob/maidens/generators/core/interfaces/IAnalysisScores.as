package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	 * Container to hold the scores obtained by a given IMusicUnit instance in regard to various analysis criteria.
	 * Maintains pairs of `criteria -> value` entries, stored as `String` - > `Number` respectivelly. 
	 */
	public interface IAnalysisScores {
		
		/**
		 * Stores a `criteria -> value` entry in this IAnalysisScores instance.
		 * If a value is already stored under given `criteria`, it will be overriden.
		 */
		function add (criteria : String, value : int) : void;
		
		/**
		 * Retrieves the value associated with a given `criteria` name. Returns NaN if
		 * the criteria is not found.
		 */
		function getValueFor (criteria : String) : int;
		
		/**
		 * Remove an entry based on a given `criteria` name, provided it exists.
		 */
		function remove (criteria : String) : void;
		
		/**
		 * Iterates through all added `criteria -> value` entries
		 * in no particular order, using given `iterator` function.
		 * The function signature must be:
		 * 
		 * function myIterator (criteria : String, value : int) : Boolean;
		 * 
		 * If the `iterator` function returns `false`, iterating will stop. 
		 */
		function forEach (iterator : Function) : void;
		
		/**
		 * Removes all stored `criteria -> value` entries from this IAnalysisScores instance.
		 */
		function empty () : void;
		
		/**
		 * Returns `true` if there are no stored `criteria -> value` entries in this IAnalysisScores instance.
		 */
		function isEmpty() : Boolean;
		
	}
}