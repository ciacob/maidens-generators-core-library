package eu.claudius.iacob.music.knowledge.harmony {
	
	/**
	 * Groups musical knowledge related to harmonic intervals.
	 */
	public final class Intervals {
		
		
		public function Intervals() {}
		
		/**
		 * Returns the intrinsic consonance score for a given `simple` harmonic interval
		 * (an interval which is smaller than an octave).
		 * 
		 * @param	interval
		 * 			A simple harmonic interval (i.e., an interval containing less than
		 * 			or equal to 12 semitones) to obtain a consonance score of.
		 * 
		 * @return	The associated score, or `0` if the interval is compound (has 12
		 * 			or more semitones).
		 */
		public static function getConsonance (interval : int) : int {
			switch (interval) {
				case  7: return  5; // 5p
				case  4: return  4; // 3M
				case  3: return  3; // 3m
				case  9: return  2; // 6M
				case  8: return  1; // 6m
				case  6: return -1; // 4+
				case 10: return -2; // 7m
				case  2: return -3; // 2M
				case 11: return -4; // 7M
				case  1: return -5; // 2m

				// `1p`, `4p` and `8p` and are neither consonant nor disonant "per se"
				case  0:
				case  5:
				case 12:
					return 0;
			}
			return 0;
		}
		
		/**
		 * Returns the decay, or atenuation factor for compound intervals. This
		 * attenuation is proportional to the number of octaves added to a simple
		 * interval, and brings it closer to harmonical neutrality with each octave
		 * added.
		 * 
		 * @param	octavesAdded
		 * 			The number of octaves to be added to a simple interval to make
		 * 			it a compond interval.
		 * 
		 * @return	The atenuation that will result from this operation, as a factor
		 * 			from the interval's intrinsic consonance score.
		 */
		public static function decayFactor (octavesAdded : int) : Number {
			switch (octavesAdded) {
				case 0: return 1;
				case 1: return 0.8;
				case 2: return 0.4;
				case 3: return 0.1;
				case 4: return 0;
			}
			return 0;
		}
	}
}