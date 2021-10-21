package ro.ciacob.maidens.generators.core.abstracts {
	import flash.utils.getQualifiedClassName;
	
	import ro.ciacob.maidens.generators.core.interfaces.IAnalysisContext;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicRequest;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicUnit;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicalPostProcessor;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicalTrait;
	import ro.ciacob.maidens.generators.core.interfaces.IParametersList;
	
	/**
	 * Generic implementation of a musical trait base class.
	 * @abstract
	 */
	public class AbstractMusicalTrait implements IMusicalTrait {
		
		/**
		 * @constructor
		 * @param	subclass
		 * 			The instance of the subclass that implements this abstract class.
		 */
		public function AbstractMusicalTrait (subclass : AbstractMusicalTrait) {
			if (!subclass) {
				_yeldAbstractClassError();
			}
		}
		
		/**
		 * @see IMusicalTrait.musicalPostProcessors
		 * Subclass must override.
		 */
		public function get musicalPostProcessors():Vector.<IMusicalPostProcessor> {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalTrait.execute
		 * Subclass must override.
		 */
		public function execute (targetMusicUnit:IMusicUnit, analysisContext:IAnalysisContext, 
								parameters: IParametersList, request:IMusicRequest) : void {
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