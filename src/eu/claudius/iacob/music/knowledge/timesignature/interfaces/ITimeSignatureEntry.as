package eu.claudius.iacob.music.knowledge.timesignature.interfaces {
	import ro.ciacob.math.IFraction;
	
	/**
	 * Represents one entry in a ITimeSignatureMap instance. Binds a measure number
	 * to a IMeasureDefinition instance, essentially stating that from a given
	 * measure onwards, a certain time signature is to be used. 
	 */
	public interface ITimeSignatureEntry {
		
		/**
		 * The musical duration representing this entry's span (actually the product of
		 * its `signature` and `repetitions`.
		 */
		function get duration() : IFraction;
		
		/**
		 * How many subsequent measures that use the given time signature to employ. 
		 */
		function get repetitions () : uint;
		function set repetitions (value : uint) : void;
		
		/**
		 * The time signature details, as an ITimeSignatureDefinition instance.
		 */
		function get signature () : ITimeSignatureDefinition;
		function set signature (value : ITimeSignatureDefinition) : void;
	}
}