package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	 * Represents one of the pitches inside a music unit.
	 */
	public interface IMusicPitch {
		
		/**
		 * The MIDI number representing the pitch, e.g., `60` is `middle C`.
		 */
		function get midiNote () : int;
		function set midiNote (value : int) : void;
		
		/**
		 * Whether or not to tie to the next music unit's corresponding pitch
		 * (provided it has the same MIDI note number).
		 */
		function get tieNext () : Boolean;
		function set tieNext (value : Boolean) : void;
		
		/**
		 * Returns a string representation of this IMusicPitch instance
		 */
		function toString() : String;
	}
}