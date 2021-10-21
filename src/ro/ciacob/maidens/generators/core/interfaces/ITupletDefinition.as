package ro.ciacob.maidens.generators.core.interfaces {
	import ro.ciacob.math.IFraction;
	
	/**
	 * Contains information that helps define a tuplet.
	 */
	public interface ITupletDefinition {
		
		/**
		 * Tuplet NOMINAL beats number, e.g., `3` for a "3 eights instead of 2" tuplet
		 */
		function get tupletBeatsNumber () : int;
		function set tupletBeatsNumber (value : int) : void;
		
		/**
		 * Tuplet NOMINAL beat duration, e.g., `1/8` for a "3 eights instead of 2" tuplet
		 */
		function get tupletBeatDuration () : IFraction;
		function set tupletBeatDuration (value : IFraction) : void;
		
		/**
		 * Regular NOMINAL beats number, e.g., `2` for a "3 eights instead of 2" tuplet 
		 */
		function get regularBeatsNumber () : int;
		function set regularBeatsNumber (value : int) : void; 
		
		/**
		 * Regular NOMINAL beat duration, e.g., `1/8` for a "3 eights instead of 2" tuplet 
		 */
		function get regularBeatDuration () : IFraction;
		function set regularBeatDuration (value : IFraction) : void;
	}
}