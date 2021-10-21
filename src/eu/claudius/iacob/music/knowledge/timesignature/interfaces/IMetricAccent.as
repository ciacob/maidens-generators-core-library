package eu.claudius.iacob.music.knowledge.timesignature.interfaces {
	import ro.ciacob.math.IFraction;

	public interface IMetricAccent {
		
		/**
		 * The ammount of stress, expressed as a Number between 0 and 1
		 * inclussive, a playback routine should add with respect to this
		 * metric accent, e.g., `1` means maximum of the available MIDI velocity,
		 * whereas `0.5` means about half of it.
		 * 
		 * To express the secondary metric accent of "common time" (4/4), you would
		 * probably set this to something like `0.75`. 
		 */
		function get strength () : Number;
		function set strength (value : Number) : void;
		
		/**
		 * An IFraction instance that represents the beat of a measure this
		 * metric accent refers to, e.g., to express the secondary metric
		 * accent of "common time" (4/4), you would set this to `3/4`.
		 */
		function get position () : IFraction;
		function set position (value : IFraction) : void;
		
	}
}