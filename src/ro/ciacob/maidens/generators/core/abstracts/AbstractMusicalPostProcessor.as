package ro.ciacob.maidens.generators.core.abstracts {
	
	import flash.utils.getQualifiedClassName;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicalBody;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicRequest;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicalPostProcessor;
	import ro.ciacob.utils.Strings;

	public class AbstractMusicalPostProcessor implements IMusicalPostProcessor {

		private var _uid : String;

		/**
		 * @constructor
		 * @param	subclass
		 * 			The instance of the subclass that implements this abstract class.
		 */
		public function AbstractMusicalPostProcessor (subclass : AbstractMusicalPostProcessor) {
			if (!subclass) {
				_yeldAbstractClassError();
			}
		}

		/**
		 * @see IMusicalPostProcessor.uid
		 */
		public function get uid():String {
			if (!_uid) {
				_uid = Strings.generateRFC4122GUID();
			}
			return _uid;
		}

		/**
		 * @see IMusicalPostProcessor.execute
		 */
		public function execute (rawMusicalBody : IMusicalBody, request : IMusicRequest) : void {
			_yeldAbstractClassError();
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