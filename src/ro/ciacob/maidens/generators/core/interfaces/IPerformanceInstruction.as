package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	 * Defines performance indications (such as dynamics - pp, mp, p, tempo - Andante, Moderato,
	 * Allegro, etc.) that are to be added in relation to the pitches of a music unit. 
	 */
	public interface IPerformanceInstruction {
		
		/**
		 * A globally unique value that identifies this processing instruction.
		 */
		function get uid () : String; 
		
		/**
		 * A name identifying this performance instruction.
		 */
		function get name () : String;
		function set name (value : String) : void;
		
		/**
		 * A taxonomy name this performance instruction fits in. Expected names are:
		 * "dynamics", "dynamic changes", "tempo", "tempo changes", "articulations", "text".
		 */
		function get category () : String;
		function set category (value : String) : void;
		
		/**
		 * The "content" or "payload" of this performance instruction, in a format that the
		 * client code expects.
		 */
		function get value () : Object;
		function set (value : Object) : void;
	}
}