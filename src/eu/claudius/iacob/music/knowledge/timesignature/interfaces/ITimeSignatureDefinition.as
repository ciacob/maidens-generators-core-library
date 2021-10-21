package eu.claudius.iacob.music.knowledge.timesignature.interfaces {
	import ro.ciacob.math.IFraction;
	
	/**
	 * Container to store information that defines a musical time signature.
	 */
	public interface ITimeSignatureDefinition {

		/**
		 * The mathematical fraction that represents the duration of a measure using this
		 * TimeSignature definition, e.g., for "common time" (aka 4/4), that would be a 
		 * "(one) whole" fraction, or 1/1.
		 */
		function get fraction() : IFraction;
		
		/**
		 * The numerator to be used for display purposes when notating a measure that uses this
		 * time signature. Frequently enough, this is different from the fraction's numerator,
		 * e.g., in "common time" it would be `4`, whereas the mathematical fraction in simplest form
		 * is `1/1`.
		 */
		function get shownNumerator() : uint;
		
		/**
		 * The denominator to be used for display purposes, when notating a measure that uses this
		 * time signature. Frequently enough, this is different from the fraction's denominator,
		 * e.g., in "common time" it would be `4`, whereas the mathematical fraction in simplest form
		 * is `1/1`.
		 */
		function get shownDenominator() : uint;
		
		/**
		 * A list of IMetricAccent instances that define how a measure of music using this time
		 * signature is to be stressed (if only theoretically) when played, e.g., the "common time"
		 * defines a "strong" metric accent on the first beat (1/4) and a "weak" one on the third
		 * (3/4). 
		 */
		function get metricAccents () : Vector.<IMetricAccent>;
		
		/**
		 * A list of IFraction instances that define the beats were beaming is to be broken
		 * for display purposes, when notating a measure that uses this time signature, e.g.,
		 * the "common time" usually beams eights or lower durations in two groups of two beats
		 * each (so that beats 1 & 2 are beamed together, and so are beats 3 & 4). This 
		 * effectivelly means that there's a "beam break" set at the end of the second beat, so 
		 * `groupings` would contain only one `2/4` (or, in simple form, `1/2`) fraction for common 
		 * time.
		 */
		function get junctions () : Vector.<IFraction>;		
	}
}