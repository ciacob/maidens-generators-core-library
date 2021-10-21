package ro.ciacob.maidens.generators.core {
	import ro.ciacob.maidens.generators.core.interfaces.IAnalysisContext;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicUnit;
	
	/**
	 * Default implementation for IAnalysisContext
	 */
	public class AnalysisContext implements IAnalysisContext {
		
		private var _previousContent : Vector.<IMusicUnit>;
		private var _percentTime : Number;
		private var _proposedContent : Array;
		
		/**
		 * @see IAnalysisContext
		 */
		public function AnalysisContext() {}
		
		/**
		 * @see IAnalysisContext.previousContent
		 */
		public function get previousContent() : Vector.<IMusicUnit> {
			return _previousContent;
		}

		/**
		 * @see IAnalysisContext.previousContent
		 */
		public function set previousContent (value : Vector.<IMusicUnit>) : void {
			_previousContent = value;
		}
		
		/**
		 * @see IAnalysisContext.proposedContent
		 */
		public function get proposedContent():Array {
			return _proposedContent;
		}
		
		/**
		 * @see IAnalysisContext.proposedContent
		 */
		public function set proposedContent(value:Array):void {
			_proposedContent = value;
		}
		
		/**
		 * @see IAnalysisContext.percentTime
		 */
		public function get percentTime() : Number {
			return _percentTime;
		}
		
		/**
		 * @see IAnalysisContext.percentTime
		 */
		public function set percentTime (value : Number) : void {
			_percentTime = value;
		}

		/**
		 * Produces a String rendition of current instance. Useful for debugging.
		 */
		public function toString () : String {
			return '[AnalysisContext: percentTime: ' + _percentTime +
					' | previousContent: ' + _previousContent.join (', ') +
					']';
		}
	}
}