package ro.ciacob.maidens.generators.core {
	import ro.ciacob.maidens.generators.core.interfaces.IAnalysisScores;
	import ro.ciacob.utils.Strings;
	import ro.ciacob.utils.constants.CommonStrings;
	
	/**
	 * Default implementation for IAnalysisScores
	 */
	public class AnalysisScores implements IAnalysisScores {
		
		private static const MIN_SCORE : uint = 0;
		private static const MAX_SCORE : uint = 100;
		
		private static const CRITERIA_ERR_HEADER : String = 'Invalid [criteria] used to record analysis score. Details:';
		private static const NULL_VALUE_ERR : String = 'Value is NULL.';
		private static const EMPTY_VALUE_ERR : String = 'Value is an empty string.';
		private static const WHITESPACE_VALUE_ERR : String = 'Value only contains whitespace.';
		private static const LEADING_WHITESPACE_VALUE_ERR : String = 'Value [%s] contains leading whitespace.';
		private static const TRAILING_WHITESPACE_VALUE_ERR : String = 'Value [%s] contains trailing whitespace.';
		
		private static const SCORE_ERR_HEADER : String = 'Invalid analysis score [%s] recorded for criteria [%s]. Details:';
		private static const NAN_SCORE_ERR : String = 'Score is not a number (NaN)';
		private static const TOO_SMALL_SCORE_ERR : String = 'Score is too small: [%s] is less than minimum allowed [%s].';
		private static const TOO_LARGE_SCORE_ERR : String = 'Score is too large: [%s] is greater than maximum allowed [%s].';
		
		private var _criteriaList : Array;
		private var _values : Object;

		/**
		 * @see IAnalysisScores
		 */
		public function AnalysisScores() {
			_criteriaList = [];
			_values = {};
		}
		
		/**
		 * @see IAnalysisScores.add
		 */
		public function add (criteria : String, value : int) : void {

			// Change in 1.5.0: we would rather gracefully recover from out-of-range errors rather than halt
			// execution, especially given that most of our analyzers are still in the making.
			if (value < MIN_SCORE) {
				value = MIN_SCORE;
			}
			if (value > MAX_SCORE) {
				value = MAX_SCORE;
			}

			if (_assertProperCriteria (criteria) && _assertProperValue (criteria, value)) {
				if (_criteriaList.indexOf(criteria) == -1) {
					_criteriaList.push (criteria);
				}
				_values[criteria] = value;
			}
		}
		
		/**
		 * @see IAnalysisScores.getValueFor
		 */
		public function getValueFor (criteria:String) : int {
			if (!(criteria in _values)) {
				return NaN;
			}
			return _values[criteria] as Number;
		}
		
		/**
		 * @see IAnalysisScores.remove
		 */
		public function remove(criteria:String):void {
			var criteriaIndex : int = _criteriaList.indexOf (criteria);
			if (criteriaIndex != -1) {
				_criteriaList.splice (criteriaIndex, 1);
				delete _values[criteria];
			}
			
		}
		
		/**
		 * @see IAnalysisScores.forEach
		 */
		public function forEach (iterator : Function) : void {
			for (var i : int = 0; i < _criteriaList.length; i++) {
				var criteria : String = _criteriaList[i] as String;
				var value : Number = _values[criteria] as Number;
				var mustContinue : * = iterator (criteria, value);
				if (mustContinue === false) {
					break;
				}
			}
		}
		
		/**
		 * @see IAnalysisScores.empty
		 */
		public function empty():void {
			_criteriaList.length = 0;
			_values = {};
		}
		
		/**
		 * @see IAnalysisScores.isEmpty
		 */
		public function isEmpty():Boolean {
			return _criteriaList.length == 0;
		}
		
		/**
		 * Throws if provided `criteria` is inappropriate. Effectivelly enforces client code to store
		 * semantically acurate data in each assignment.
		 * 
		 * The validation rules are:
		 * 
		 * (1) The value of `criteria` must not be `null`, an empty string, or only
		 * contain whitespace characters;
		 * 
		 * (2) The value of `criteria` musht not contain any leading or trailing white spaces.
		 * 
		 * @return	`True` if assertion passes, `false` otherwise. The return value is a back-up for the case where
		 * 			RTEs are globally suppressed. The `value` should NOT be set if this function returns `false`.
		 */
		private static function _assertProperCriteria (criteria : String) : Boolean {
			var assertMessage : String;
			var assertTokens : Array = [];
			if (criteria === null) {
				assertTokens.push (NULL_VALUE_ERR);
			}
			else if (criteria.length == 0) {
				assertTokens.push (EMPTY_VALUE_ERR);
			}
			else if (Strings.trim (criteria).length == 0) {
				assertTokens.push (Strings.sprintf (WHITESPACE_VALUE_ERR, criteria));
			}
			else if (Strings.trimLeft(criteria).length != criteria.length) {
				assertTokens.push (Strings.sprintf (LEADING_WHITESPACE_VALUE_ERR, criteria));
			}
			else if (Strings.trimRight(criteria).length != criteria.length) {
				assertTokens.push (Strings.sprintf(TRAILING_WHITESPACE_VALUE_ERR, criteria));
			}
			if (assertTokens.length > 0) {
				assertTokens.unshift (Strings.sprintf (CRITERIA_ERR_HEADER, criteria));
				assertMessage = assertTokens.join (CommonStrings.NEW_LINE);
				throw (new ArgumentError (assertMessage));
				return false;
			}
			return true;
		}
		
		/**
		 * Throws is provided `value` is inappropriate. Effectivelly enforces client code to store
		 * semantically acurate data in each assignment.
		 * 
		 * The validation rules are:
		 * 
		 * (1) `value` must NOT be a `NaN`;
		 * 
		 * (2) `value` must always be in the range of `1` to `100`, includding both ends.
		 */
		private function _assertProperValue (criteria : String, value : int) : Boolean {
			var assertTokens : Array = [];
			var assertMessage : String; 
			if (_isNaN (value)) {
				assertTokens.push (NAN_SCORE_ERR);
			}
			else if (value < MIN_SCORE) {
				assertTokens.push (Strings.sprintf (TOO_SMALL_SCORE_ERR, value, MIN_SCORE));
			}
			else if (value > MAX_SCORE) {
				assertTokens.push (Strings.sprintf (TOO_LARGE_SCORE_ERR, value, MAX_SCORE));
			}
			if (assertTokens.length > 0) {
				assertTokens.unshift (Strings.sprintf (SCORE_ERR_HEADER, value, criteria));
				assertMessage = assertTokens.join (CommonStrings.NEW_LINE);
				throw (new ArgumentError (assertMessage));
				return false;
			}
			return true;
		}
		
		/**
		 * Universally reliable way of determining whether a value is the reserved type `NaN` or not.
		 */
		private static function _isNaN (value : Object) : Boolean {
			return !(value === value);
		}
	}
}