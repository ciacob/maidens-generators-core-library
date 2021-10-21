package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	 * Container to hold information that is to be consummed
	 * by IMusicalContentAnalyzer instances. 
	 */
	public interface IAnalysisContext {
		
		/**
		 * The last `n` IMusicUnit instances that were generated (based on the
		 * "analysis window" parameter).
		 */
		function get previousContent () : Vector.<IMusicUnit>;
		function set previousContent (value : Vector.<IMusicUnit>) : void;
		
		/**
		 * Untyped musical data (e.g., MIDI pitches) that could potentially be included
		 * in the generated output. This information is likely to be used by
		 * IMusicalPrimitiveSource instances when producing music rudiments.
		 */
		function get proposedContent () : Array;
		function set proposedContent (value : Array) : void;
		
		/**
		 * A point in time (as an unsigned integer between `0` and `100` inclusive)
		 * refering to the remaining musical duration to be "filled".
		 */
		function get percentTime () : Number;
		function set percentTime (value : Number) : void;
	}
}