package eu.claudius.iacob.music.knowledge.timesignature {
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.ITimeSignatureDefinition;
	
	import ro.ciacob.utils.constants.CommonStrings;
	
	public class TimeSignatureFactory {

		private static var _timeSignatures : Object = {};
		
		public function TimeSignatureFactory() {}

		/**
		 * Convenience way of returning a `TimeSignatureDefinition` instance based on provided numerator and
		 * denominator, while recycling existing instances.
		 * 
		 * @see IMeasureDefinition.shownNumerator
		 * @see IMeasureDefinition.shownDenominator
		 */
		public static function $get (numerator : uint, denominator : uint) : TimeSignatureDefinition {
			var storageName : String = numerator + CommonStrings.SLASH + denominator;
			if (!(storageName in _timeSignatures)) {
				_timeSignatures[storageName] = new TimeSignatureDefinition (numerator, denominator);
			}
			return _timeSignatures[storageName];
		}
		
		/**
		 * Enables manually adding a `TimeSignatureDefinition` instance to the cache, for later retrieval.
		 * The instance is indexed by its `shownNumerator` and `shownDenominator` properties.
		 */
		public static function $cache (timeSignature : ITimeSignatureDefinition) : void {
			var storageName : String = timeSignature.shownNumerator + CommonStrings.SLASH + 
				timeSignature.shownDenominator;
			_timeSignatures[storageName] = timeSignature;
		}
	}
}