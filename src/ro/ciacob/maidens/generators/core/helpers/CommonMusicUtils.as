package ro.ciacob.maidens.generators.core.helpers {
	import eu.claudius.iacob.music.knowledge.instruments.interfaces.IMusicalInstrument;

	/**
	 * This class is a portmanteau of public static methods that perform helpful operations against various musical
	 * structures. Methods includded in this class are agnostic to MAIDENS internal model data structure.
	 */
	public class CommonMusicUtils {
		public function CommonMusicUtils() {
		}

		/**
		 * Returns a shallow clone of the given instruments collection, where each instrument has been
		 * ordered by its middle/center pitch (the pitch roughly found at the middle of its range). Also sorts the
		 * instances of the same instrument by their ordinal index (so that "Violin 1" is reported to be "before"
		 * "Violin 2".
		 */
		public static function cloneAndReorderInstruments(
				instruments:Vector.<IMusicalInstrument>):Vector.<IMusicalInstrument> {
			var clone:Vector.<IMusicalInstrument> = instruments.concat();
			clone.sort(_compareInstruments);
			return clone;
		}


		/**
		 * Sorting function to be used by `cloneAndReorderInstruments()`.
		 */
		private static function _compareInstruments(
				instrumentA:IMusicalInstrument, instrumentB:IMusicalInstrument):int {
			var aLow:int = instrumentA.idealHarmonicRange[0];
			var aHigh:int = instrumentA.idealHarmonicRange[1];
			var bLow:int = instrumentB.idealHarmonicRange[0];
			var bHigh:int = instrumentB.idealHarmonicRange[1];
			var aMidPitch:int = aLow + Math.round((aHigh - aLow) * 0.5);
			var bMidPitch:int = bLow + Math.round((bHigh - bLow) * 0.5);
			var score : int = (bMidPitch - aMidPitch);
			if (score == 0 && (instrumentA.internalName == instrumentB.internalName)) {
				score = (instrumentA.ordinalIndex - instrumentB.ordinalIndex);
			}
			return score;
		}
	}
}
