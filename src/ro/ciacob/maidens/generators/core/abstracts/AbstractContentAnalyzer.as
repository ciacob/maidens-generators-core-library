package ro.ciacob.maidens.generators.core.abstracts {
	import flash.utils.getQualifiedClassName;
	
	import ro.ciacob.maidens.generators.core.interfaces.IAnalysisContext;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicRequest;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicUnit;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicalContentAnalyzer;
	import ro.ciacob.maidens.generators.core.interfaces.IParametersList;
	import ro.ciacob.utils.Strings;
	
	/**
	 * Generic implementation of a musical musical content analyser base class.
	 */
	public class AbstractContentAnalyzer implements IMusicalContentAnalyzer {
		
		private var _uid:String;
		private var _threshold:Number;

		public static const DEFAULT_WEIGHT : Number = 1;

        /**
         * @constructor
         * @param    subclass
         *            The instance of the subclass that implements this abstract class.
		 */
		public function AbstractContentAnalyzer (subclass : AbstractContentAnalyzer) {
			if (!subclass) {
				_yeldAbstractClassError();
			}
		}
		
		/**
		 * @see IMusicalContentAnalyzer.analyze
		 */
		public function analyze (targetMusicUnit:IMusicUnit, analysisContext:IAnalysisContext,
								 parameters:IParametersList, request:IMusicRequest) : void {
			_yeldAbstractClassError();
		}

		/**
		 * @see IMusicalContentAnalyzer.weight
		 */
		public function get weight () : Number {
			return DEFAULT_WEIGHT;
		}

		/**
		 * @see IMusicalContentAnalyzer.name
		 */
		public function get name () : String {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalContentAnalyzer.threshold
		 */
		public function get threshold () : Number {
			return _threshold;
		};
		public function set threshold (value : Number) : void {
			_threshold = value;
		};

		/**
		 * @see IMusicalContentAnalyzer.uid
		 */
		public function get uid():String {
			if (!_uid) {
				_uid = Strings.generateRFC4122GUID();
			}
			return _uid;
		}

		/**
		 * Returns a String representation of the current instance. Useful for debugging.
		 */
		public function toString() : String {
			return ('[ANALYZER: ' + name + ']');
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