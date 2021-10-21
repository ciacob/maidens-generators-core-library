package ro.ciacob.maidens.generators.core.abstracts {
	import flash.utils.getQualifiedClassName;
	
	import ro.ciacob.maidens.generators.core.interfaces.IAnalysisContext;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicRequest;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicUnit;
	import ro.ciacob.maidens.generators.core.interfaces.IParametersList;
	import ro.ciacob.maidens.generators.core.interfaces.IRawMusicSource;
	import ro.ciacob.utils.Strings;
	
	/**
	 * Generic implementation of a musical primitive source base class.
	 */
	public class AbstractRawMusicSource implements IRawMusicSource {
		
		private var _uid : String;
		
		/**
		 * @constructor
		 * @param	subclass
		 * 			The instance of the subclass that implements this abstract class.
		 */
		public function AbstractRawMusicSource (subclass : AbstractRawMusicSource) {
			if (!subclass) {
				_yeldAbstractClassError();
			}
		}
		
		/**
		 * @see IRawMusicSource.output
		 */
		public function output (targetMusicUnit:IMusicUnit, analysisContext:IAnalysisContext,
							   parameters : IParametersList, request:IMusicRequest):Vector.<IMusicUnit> {
			_yeldAbstractClassError();
			return null;
		}
		
		/**
		 * @see IRawMusicSource.uid
		 */
		public final function get uid():String {
			if (!_uid) {
				_uid = Strings.generateRFC4122GUID();
			}
			return _uid;
		}
		
		/**
		 * @see IRawMusicSource.reset
		 */
		public function reset () : void {
			// Subclasses may override as needed.
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