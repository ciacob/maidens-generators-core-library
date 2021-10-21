package eu.claudius.iacob.music.knowledge.timesignature.helpers {
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.IMetricAccent;
	
	import ro.ciacob.math.IFraction;
	
	public class MetricAccent implements IMetricAccent {
		
		private var _strength : Number;
		private var _position : IFraction;
		
		public function MetricAccent() {}
		
		/**
		 * @see IMetricAccent.strength
		 */
		public function get strength():Number {
			return _strength;
		}

		/**
		 * @see IMetricAccent.strength
		 */
		public function set strength(value:Number):void {
			_strength = value;
		}
		
		/**
		 * @see IMetricAccent.position
		 */
		public function get position():IFraction {
			return _position;
		}
		
		/**
		 * @see IMetricAccent.position
		 */
		public function set position(value:IFraction):void {
			_position = value;
		}
		
		/**
		 * @see Object.prototype.toString()
		 */
		public function toString () : String {
			return '[MetricAccent: ' + _strength + ' @' + _position + ']';
		}
	}
}