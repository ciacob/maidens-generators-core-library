package ro.ciacob.maidens.generators.core.interfaces {
	import eu.claudius.iacob.music.knowledge.instruments.interfaces.IMusicalInstrument;
	
	/**
	 * Defines one rule for allocating one pitch to one instrument and voice of that instrument.
	 */
	public interface IPitchAllocation {
		
		/**
		 * The instance of the instrument to allocate the current pitch to.
		 */
		function get instrument () : IMusicalInstrument;
		function set instrument (value : IMusicalInstrument) : void;
		
		/**
		 * The index of the voice among the ones played by the current instrument were the current
		 * pitch is to be allocated. The value is `1` based (not `0` based).
		 */
		function get voiceIndex () : int;
		function set voiceIndex (value : int) : void;

		/**
		 * The pitch being allocated.
		 */
		function get allocatedPitch () : IMusicPitch;
		function set allocatedPitch (value : IMusicPitch) : void;
	}
}