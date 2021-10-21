package eu.claudius.iacob.music.knowledge.timesignature.helpers {
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.ITimeSignatureDefinition;
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.ITimeSignatureEntry;
	
	import ro.ciacob.math.Fraction;
	import ro.ciacob.math.IFraction;
	
	/**
	 * @see ITimeSignatureEntry
	 */
	public class TimeSignatureEntry implements ITimeSignatureEntry {
		
		private var _zeroFraction : IFraction;
		private var _isDurationDirty : Boolean;
		private var _repetitions : uint;
		private var _signature : ITimeSignatureDefinition;
		private var _duration : IFraction;
		
		public function TimeSignatureEntry() {}
		
		/**
		 * @see ITimeSignatureEntry.duration
		 */
		public function get duration():IFraction {
			if (!_signature) {
				return ZERO_FRACTION;
			}
			if (!_repetitions) {
				return ZERO_FRACTION;
			}
			if (!_duration || _isDurationDirty) {
				var repetitionsAsFraction : Fraction = new Fraction (_repetitions, 1);
				_duration = _signature.fraction.multiply(repetitionsAsFraction);
				_isDurationDirty = false;
			}
			return _duration;
		}
		
		/**
		 * @see ITimeSignatureEntry.repetitions
		 */
		public function get repetitions():uint {
			return _repetitions;
		}
		
		/**
		 * @see ITimeSignatureEntry.repetitions
		 */
		public function set repetitions(value:uint):void {
			_repetitions = value;
			_isDurationDirty = true;
		}
		
		/**
		 * @see ITimeSignatureEntry.signature
		 */		
		public function get signature():ITimeSignatureDefinition {
			return _signature;
		}
		
		/**
		 * @see ITimeSignatureEntry.signature
		 */
		public function set signature(value:ITimeSignatureDefinition):void {
			_signature = value;
			_isDurationDirty = true;
		}
		
		/**
		 * Convenience getter for a IFraction instance that equals to "0". We do not want to
		 * couple this class with `Fraction` and therefore will not use `Fraction.ZERO`.
		 */
		private function get ZERO_FRACTION () : IFraction {
			if (!_zeroFraction) {
				_zeroFraction = Fraction.ZERO;
			}
			return _zeroFraction;
		}
	
		/**
		 * @see Object.prototype.toString()
		 */
		public function toString () : String {
			return (_repetitions + ' measures of ' + _signature.shownNumerator + '/' + _signature.shownDenominator + ' acounting for ' + _duration);
		}
	}
}