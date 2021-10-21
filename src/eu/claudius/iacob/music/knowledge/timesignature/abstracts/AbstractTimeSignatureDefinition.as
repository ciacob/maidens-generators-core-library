package eu.claudius.iacob.music.knowledge.timesignature.abstracts {
	import flash.utils.getQualifiedClassName;
	
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.IMetricAccent;
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.ITimeSignatureDefinition;
	
	import ro.ciacob.math.IFraction;
	
	/**
	 * Container to store information that defines a musical time signature.
	 * @abstract
	 */
	public class AbstractTimeSignatureDefinition implements ITimeSignatureDefinition {
		
		/**
		 * @constructor
		 * @param	subclass
		 * 			The instance of the subclass that implements this abstract class.
		 */
		public function AbstractTimeSignatureDefinition (subclass : AbstractTimeSignatureDefinition) {
			if (!subclass) {
				_yeldAbstractClassError();
			}
		}
		
		/**
		 * @see IMeasureDefinition.fraction
		 */
		public function get fraction():IFraction {
			_yeldAbstractClassError();
			return null;
		}
		
		/**
		 * @see IMeasureDefinition.shownNumerator
		 */
		public function get shownNumerator():uint {
			_yeldAbstractClassError();
			return 0;
		}
		
		/**
		 * @see IMeasureDefinition.shownDenominator
		 */
		public function get shownDenominator():uint {
			_yeldAbstractClassError();
			return 0;
		}
		
		/**
		 * @see IMeasureDefinition.metricAccents
		 */
		public function get metricAccents():Vector.<IMetricAccent> {
			_yeldAbstractClassError();
			return null;
		}
		
		/**
		 * @see IMeasureDefinition.junctions
		 */
		public function get junctions():Vector.<IFraction> {
			_yeldAbstractClassError();
			return null;
		}
		
		/**
		 * Produces a runtime error as a reminder that the class is abstract
		 */
		private function _yeldAbstractClassError () : void {
			throw ('The class `' + getQualifiedClassName(this) + 
				'` is abstract; please remember to extend it and override its methods as needed.');
		}
	}
}