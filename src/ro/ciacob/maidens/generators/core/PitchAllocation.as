package ro.ciacob.maidens.generators.core {
	import eu.claudius.iacob.music.knowledge.instruments.interfaces.IMusicalInstrument;

	import ro.ciacob.maidens.generators.core.interfaces.IMusicPitch;

	import ro.ciacob.maidens.generators.core.interfaces.IMusicUnit;
	import ro.ciacob.maidens.generators.core.interfaces.IPitchAllocation;

	/**
	 * Defines one rule for allocating one pitch to one instrument and voice of that instrument.
	 * @see IPitchAllocation
	 */
	public class PitchAllocation implements IPitchAllocation {
		
		private var _instrument : IMusicalInstrument;
		private var _voiceIndex : int;
		private var _allocatedPitch : IMusicPitch;
		
		public function PitchAllocation (instrument : IMusicalInstrument, voiceIndex : int, allocatedPitch : IMusicPitch) {
			_instrument = instrument;
			_voiceIndex = voiceIndex;
			_allocatedPitch = allocatedPitch;
		}
		
		/**
		 * @see IPitchAllocation.instrument
		 */
		public function get instrument() : IMusicalInstrument {
			return _instrument;
		}
		
		/**
		 * @see IPitchAllocation.instrument
		 */
		public function set instrument (value : IMusicalInstrument) : void {
			_instrument = value;
		}
		
		/**
		 * @see IPitchAllocation.voiceIndex
		 */
		public function get voiceIndex () : int {
			return _voiceIndex;
		}
		
		/**
		 * @see IPitchAllocation.voiceIndex
		 */
		public function set voiceIndex (value : int) : void {
			_voiceIndex = value;
		}
		
		/**
		 * @see IPitchAllocation.allocatedUnit
		 */
		public function get allocatedPitch () : IMusicPitch {
			return _allocatedPitch;
		}
		
		/**
		 * @see IPitchAllocation.allocatedUnit
		 */
		public function set allocatedPitch (value : IMusicPitch) : void {
			_allocatedPitch = value;
		}
		
		/**
		 * @see Object.prototype.toString()
		 */
		public function toString() : String {
			return '[instrument ' + _instrument.internalName + '(' + _instrument.uid + ')' + ', voice ' +
					_voiceIndex + ', pitch ' + _allocatedPitch + ']';
		}
	}
}