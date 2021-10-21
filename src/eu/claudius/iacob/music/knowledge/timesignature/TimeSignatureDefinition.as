package eu.claudius.iacob.music.knowledge.timesignature {
	import eu.claudius.iacob.music.knowledge.timesignature.abstracts.AbstractTimeSignatureDefinition;
	import eu.claudius.iacob.music.knowledge.timesignature.helpers.MetricAccent;
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.IMetricAccent;
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.ITimeSignatureDefinition;
	
	import ro.ciacob.math.Fraction;
	import ro.ciacob.math.IFraction;
	import ro.ciacob.utils.NumberUtil;
	
	/**
	 * Represents a musical time signature, both with regard to its visual materialization (i.e., the fraction
	 * displayed at the beginning of a measure) and to its implicit properties, such as distribution of metrical
	 * accents and junctions (beat grouping boundaries). 
	 */
	public class TimeSignatureDefinition extends AbstractTimeSignatureDefinition implements ITimeSignatureDefinition {
		
		public static const MAX_ACCENT_STRENGTH : Number = 2;
		public static const MIN_ACCENT_STRENGTH : Number = 1.2;
		public static const ACCENT_DECAY : Number = 0.75;
		
		
		private var _shownNumerator : uint;
		private var _shownDenominator : uint;
		private var _fraction : IFraction;
		private var _junctions : Vector.<IFraction>;
		private var _metricAccents : Vector.<IMetricAccent>;
		
		/**
		 * @constructor
		 * 
		 * @param	shownNumerator -
		 * 			The numerator of the fraction representing this time signature, in its traditional form (which,
		 * 			usually, is NOT the fraction's mathematical simple form, e.g., one writes `4/4` instead of `1`);
		 * 
		 * @param	shownDenominator -
		 * 			The denominator of the fraction representing this time signature, in its traditional form (which,
		 * 			usually, is NOT the fraction's mathematical simple form, e.g., one writes `4/4` instead of `1`);
		 * 
		 * @param	junctions -
		 * 			Optional, default null. For most common time signature, junctions can be determined by calculus,
		 * 			but for irregular time signatures (e.g., 7/8, 5/4) there are multiple grouping solutions (e.g.,
		 * 			"3/8 + 2/8 + 2/8" or "2/8 + 3/8 + 2/8") which cannot be accounted for. If given, the `junctions`
		 * 			parameter must contain a list of IFraction instances that define the beats were beaming is to be
		 * 			broken.
		 * 
		 * @param	metricAccents -
		 * 			Optional, default null. Only needed if the metric accents distribution for this time signature 
		 * 			cannot be infered from its `junctions` (either given, or calculated). If given, the `metricAccents`
		 * 			parameter must contain a list of IMetricAccent instances that define how a measure of music using
		 * 			this time signature is to be stressed.
		 * 
		 * @throws	ArgumentError if any of the following is true:
		 * 			(a) `shownNumerator` is `0`;
		 * 			(b) `shownDenominator` is `0`;
		 * 			(c) `shownDenominator` is not a power of `2`;
		 * 
		 * @see ITimeSignatureDefinition.junctions
		 * @see ITimeSignatureDefinition.metricAccents
		 */
		public function TimeSignatureDefinition (shownNumerator : uint,
												 shownDenominator : uint,
												 junctions : Vector.<IFraction> = null,
												 metricAccents : Vector.<IMetricAccent> = null) {
			
			super (this);
			if (_assertPropertNumerator (shownNumerator) && _assertProperDenominator (shownDenominator)) {
				_shownNumerator = shownNumerator;
				_shownDenominator = shownDenominator;
				_fraction = new Fraction (_shownNumerator, _shownDenominator);
				_junctions = junctions || _inferJunctions();
				_metricAccents = metricAccents || _inferMetricAccents();
			}
		}
		
		/**
		 * @see ITimeSignatureDefinition.fraction()
		 */
		override public function get fraction() : IFraction {
			return _fraction;
		}
		
		/**
		 * @see ITimeSignatureDefinition.shownNumerator()
		 */
		override public function get shownNumerator() : uint {
			return _shownNumerator;
		}
		
		/**
		 * @see ITimeSignatureDefinition.shownDenominator()
		 */
		override public function get shownDenominator() : uint {
			return _shownDenominator;
		}
		
		/**
		 * @see ITimeSignatureDefinition.metricAccents()
		 */
		override public function get metricAccents () : Vector.<IMetricAccent> {
			return _metricAccents;
		}
		
		/**
		 * @see ITimeSignatureDefinition.junctions()
		 */
		override public function get junctions () : Vector.<IFraction> {
			return _junctions;
		}
		
		/**
		 * @see Object.prototype.toString()
		 */
		public function toString () : String {
			return 'TimeSignatureDefinition:\n-numerator:' +
				_shownNumerator + '\n-denominator: ' +
				_shownDenominator + '\n-fraction: ' +
				_fraction + '\n-junctions: ' +
				_junctions.join (', ') + '\n-metricAccents: ' +
				_metricAccents.join (', ') + '\n';
		}
		
		/**
		 * Asserts that given `value` is greater than zero. On failure, returns `false`
		 * and throws an ArgumentError.
		 */
		private function _assertPropertNumerator (value : uint) : Boolean {
			if (value == 0) {
				throw (new ArgumentError ('Argument "shownNumerator" cannot be 0.'));
				return false;
			}
			return true;
		}

		/**
		 * Asserts that given `value` is greater than zero and a power of `2`. On failure,
		 * returns `false` and throws an ArgumentError.
		 */
		private function _assertProperDenominator (value : uint) : Boolean {
			if (value == 0) {
				throw (new ArgumentError ('Argument "shownDenominator" cannot be 0.'));
				return false;
			}
			if (!NumberUtil.isPowerOfTwo (value)) {
				throw (new ArgumentError ('Argument "shownDenominator" must be a power of `2` (1, 2, 4, 8, 16, 32, etc.)'));
				return false;
			}
			return true;
		}
		
		/**
		 * Uses best efforts to determine grouping of beats in a measure using this time signature
		 * by running calculus against the time signature's fraction.
		 */
		private function _inferJunctions () : Vector.<IFraction> {
			var junctions : Vector.<IFraction> = new Vector.<IFraction>;
			junctions.push.apply (junctions, _getHalfJunction (_fraction) ||
				_getThirdsJunction (_fraction) ||
				_getBeatJunction());
			return junctions;
		}
		
		/**
		 * Derivates metric accents in a measure using this time signature by observing its 
		 * grouping of beats.
		 * @see _inferJunctions()
		 */
		private function _inferMetricAccents () : Vector.<IMetricAccent> {
			var ret : Vector.<IMetricAccent> = new Vector.<IMetricAccent>;
			
			// The first beat of the measure will always be stressed
			var beatFraction : IFraction = new Fraction (1, _shownDenominator);
			var primaryAccent : IMetricAccent = new MetricAccent;
			primaryAccent.strength = MAX_ACCENT_STRENGTH;
			primaryAccent.position = beatFraction;
			ret.push (primaryAccent);
			
			// Determine the remaining accents based on grouping rules
			var accentOffset : Number = (MAX_ACCENT_STRENGTH - MIN_ACCENT_STRENGTH);
			var i : int;
			var fraction : IFraction;
			var secondaryAccent : IMetricAccent;
			for (i = 0; i < _junctions.length; i++) {
				fraction = _junctions[i];
				//if (!fraction.equals (beatFraction)) {
					accentOffset *= ACCENT_DECAY;
					secondaryAccent = new MetricAccent;
					secondaryAccent.strength = (MIN_ACCENT_STRENGTH + accentOffset);
					secondaryAccent.position = fraction.add (beatFraction);
					ret.push (secondaryAccent);
				//}
			}
			return ret;
		}
		
		/**
		 * Lists beat level grouping rules (there is one group, containing all durations smaller
		 * than or equal to the beat duration).
		 */
		private function _getBeatJunction () : Array {
			var ret : Array = [];
			var beatFraction : IFraction = new Fraction (1, _shownDenominator);
			for (var i : int = 1; i < _shownNumerator; i++) {
				ret.push (beatFraction.multiply (new Fraction (i)));
			}
			return ret;
		}
		
		/**
		 * Lists measure level grouping rules (half of the measure: there are two groups, each
		 * one containing all durations in one half of the measure).
		 */
		private function _getHalfJunction (fraction : IFraction) : Array {
			var halfFraction : IFraction = fraction.multiply (new Fraction (1, 2));
			if (halfFraction.denominator <= _shownDenominator) {
				return [halfFraction];
			}
			return null;
		}
		
		/**
		 * Lists measure level grouping rules (third of the measure: there are three groups, each
		 * one containing all durations in one third of the measure).
		 */
		private function _getThirdsJunction (fraction : IFraction) : Array {
			var firstThirdFraction : IFraction = fraction.multiply (new Fraction (1, 3));
			if (firstThirdFraction.denominator <= _shownDenominator) {
				var secondThirdFraction : IFraction = fraction.multiply (new Fraction (2, 3));
				return [firstThirdFraction, secondThirdFraction];
			}
			return null;
		}
	}
}