package eu.claudius.iacob.music.knowledge.timesignature {
	import eu.claudius.iacob.music.knowledge.timesignature.abstracts.AbstractTimeSignatureDefinition;
	import eu.claudius.iacob.music.knowledge.timesignature.helpers.MetricAccent;
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.IMetricAccent;
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.ITimeSignatureDefinition;
	
	import ro.ciacob.math.Fraction;
	import ro.ciacob.math.IFraction;
	
	
	public class CommonTime extends AbstractTimeSignatureDefinition implements ITimeSignatureDefinition {
		
		private var _fraction : IFraction;
		private var _groupings : Vector.<IFraction>;
		private var _metricAccents : Vector.<IMetricAccent>;
		
		public function CommonTime() {
			super(this);
		}
		
		/**
		 * @see ITimeSignatureDefinition.fraction
		 */
		override public function get fraction():IFraction {
			if (!_fraction) {
				_fraction = new Fraction (1);
			}
			return _fraction;
		}
		
		/**
		 * @see ITimeSignatureDefinition.groupings
		 */
		override public function get junctions():Vector.<IFraction> {
			if (!_groupings) {
				_groupings = Vector.<IFraction> ([new Fraction (3, 4)]);
			}
			return _groupings;
		}
		
		/**
		 * @see ITimeSignatureDefinition.metricAccents
		 */
		override public function get metricAccents():Vector.<IMetricAccent> {
			if (!_metricAccents) {
				var primaryAccent : IMetricAccent = new MetricAccent;
				primaryAccent.strength = 1;
				primaryAccent.position = new Fraction (1, 4);
				var secondaryAccent : IMetricAccent = new MetricAccent;
				secondaryAccent.strength = 0.75;
				secondaryAccent.position = new Fraction (3, 4);
				_metricAccents = Vector.<IMetricAccent> ([primaryAccent, secondaryAccent]);
			}
			return _metricAccents;
		}
		
		/**
		 * @see ITimeSignatureDefinition.shownDenominator
		 */
		override public function get shownDenominator():uint {
			return 4;
		}
		
		/**
		 * @see ITimeSignatureDefinition.shownNumerator
		 */
		override public function get shownNumerator():uint {
			return 4;
		}
	}
}