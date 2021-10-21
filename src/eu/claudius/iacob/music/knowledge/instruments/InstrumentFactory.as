package eu.claudius.iacob.music.knowledge.instruments {
	import ro.ciacob.maidens.generators.constants.parts.PartNames;
	import ro.ciacob.utils.Strings;

	public class InstrumentFactory {
		
		private static var _instrumentsCache : Object = {};
		
		public function InstrumentFactory() {}
		
		/**
		 * Compiles and returns an instance of MusicalInstrument, provided that
		 * given `instrumentName` matches one of the constants defined in the
		 * `ro.ciacob.maidens.generators.constants.parts.PartNames` class.
		 * 
		 * Returns `null` if no match is found. Created instruments are cached,
		 * so that only a single instance of every requested instrument is ever 
		 * returned (also observing their ordinal index, so that, if there are two Violins
		 * in a score, two separate instances of Violin are maintained in the cache).
		 * 
		 * @param	instrumentName
		 * 			The instrument name. Accepted values are one of the constants
		 * 			defined in the `ro.ciacob.maidens.generators.constants.parts.PartNames`
		 * 			class.
		 * 
		 * @param	ordinalIndex
		 * 			The ordinal number of this `instrument instance` in the score,
		 * 			e.g., if this is the first Violin playing, it will be `0`; if it
		 * 			is the second Violin, it will be `1`.
		 * 
		 * @see MusicalInstrument
		 * @see AbstractMusicalInstrument
		 * @see IMusicalInstrument
		 */
		public static function $get (instrumentName : String, ordinalIndex : int) : MusicalInstrument {
			var cacheKey : String = (instrumentName + ordinalIndex);
			if (!(cacheKey in _instrumentsCache)) {
				var canonicalName : String = Strings.toAS3ConstantCase (instrumentName);
				if (canonicalName in PartNames) {
					_instrumentsCache[cacheKey] = new MusicalInstrument (instrumentName, ordinalIndex);
				}
			}
			return _instrumentsCache[cacheKey];
		}
	}
}