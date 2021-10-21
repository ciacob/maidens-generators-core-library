package ro.ciacob.maidens.generators.core 
{
	import flash.utils.getQualifiedClassName;
	
	import ro.ciacob.maidens.generators.core.constants.CoreOperationKeys;
	import ro.ciacob.maidens.generators.core.interfaces.IParameter;
	import ro.ciacob.maidens.generators.core.interfaces.ISettingsList;
	import ro.ciacob.utils.Strings;
	import ro.ciacob.utils.constants.CommonStrings;
	
	/**
	 * Dedicated container to store named "SettingCluster" instances.
	 * @author Claudius Iacob
	 */
	public class SettingsList implements ISettingsList {
		
		public static const ERROR_CODE : uint = 404;
		
		private static const FULL_STACK : uint = 100;
		private static const LAST_SLOT : uint = 100;
		private static const MIN_TIME : uint = 1;
		private static const MAX_TIME : uint = 100;
		
		private static const TIME_ERR_HEADER : String = 'Invalid percent time [%s] set for parameter [%s]. Details:';
		private static const TOO_SMALL_TIME_ERR : String = 'Percent time is too small: [%s] is less than minimum allowed [%s].';
		private static const TOO_LARGE_TIME_ERR : String = 'Percent time is too large: [%s] is greater than maximum allowed [%s].';
		private static const NOT_ARRAY_TIME_ERR : String = 'Type of parameter [%s] is not Array, therefore percent time cannot be [%s]. It must always be [%s].';
		
		private static const VALUE_ERR_HEADER : String = 'Invalid value [%s] set for parameter [%s] at percent time [%s]. Details:';
		private static const NULL_VALUE_ERR : String = 'Value is NULL.';
		private static const BAD_TYPE_VALUE_ERR : String = 'Expected type [%s] but encountered [%s].'
		private static const NAN_VALUE_ERR : String = 'Value is not a number (NaN)';
		private static const TOO_SMALL_VALUE_ERR : String = 'Value is too small: [%s] is less than minimum allowed [%s].';
		private static const TOO_LARGE_VALUE_ERR : String = 'Value is too large: [%s] is greater than maximum allowed [%s].';
		
		
		
		private var _values : Object;
		
		public function SettingsList() {}
		
		/**
		 * @see ISettingsList.addValueAt
		 */
		public function setValueAt(parameter:IParameter, percentTime:uint, value:Object):void {
			if (!_values) {
				_values = {};
			}
			var uid : String = parameter.uid;
			if (!(uid in _values)) {
				_values[uid] = new Array(FULL_STACK);
			}
			if (_assertProperValue (parameter, percentTime, value) && _assertProperTime (parameter, percentTime)) {
				_values[uid][percentTime] = value;
			}
		}
		
		/**
		 * @see ISettingsList.getValueAt
		 */
		public function getValueAt (parameter:IParameter, percentTime:uint):Object {
			if (!_values) {
				return null;
			}
			var uid : String = parameter.uid;
			if (!(uid in _values)) {
				return null;
			}
			if ((_values[uid] as Array).length == 0) {
				return null;
			}
			var type : uint = parameter.type;
			var canInterpolate : Boolean = parameter.isTweenable && 
				(type == CoreOperationKeys.TYPE_INT || type == CoreOperationKeys.TYPE_ARRAY);
			
			// If interpolation is an option, return interpolated value; otherwise, return last known
			// (given) value
			var timeAtOrBefore : uint = _recordedTimeAtOrBefore (parameter, percentTime);
			if (timeAtOrBefore != ERROR_CODE) {
				var valueAtOrBefore : Object = _values[uid][timeAtOrBefore];
				if (canInterpolate) {
					var timeAtOrAfter : uint = _recordedTimeAtOrAfter (parameter, percentTime);
					var valueAtOrAfter : Object = _values[uid][timeAtOrAfter];
					var interpolatedValue : Number = _computeLinearInterpolation (timeAtOrBefore, valueAtOrBefore as Number,
						timeAtOrAfter, valueAtOrAfter as Number, percentTime);
					
					// Round the interpolation value if to an integer
					interpolatedValue = Math.round (interpolatedValue);
					
					return interpolatedValue;
				} else {
					return valueAtOrBefore;
				}
			}
			
			// If we reached here, this dataset is corrupt or malformed
			return null;
		}

		/**
		 * Returns the recorded time that is closest to given `percentTime` argument, searching
		 * backward if no entry is found to match the `percentTime` argument given. In case searching
		 * backward yelds no result, falls back to a forward search. 
		 * 
		 * @param	parameter
		 * 			The parameter to filter matching records by.
		 * 
		 * @param	percentTime
		 * 			The point in time to start searching from.
		 * 
		 * @param	useFallback
		 * 			Whether to search in the opposite direction as a fallback, default `true`.
		 * 			Internally set to `false` from fallback calls, to prevent infinite loops.
		 * 
		 * @return	A percent time, as an unsigned integer between `0` and `100` inclusive. May return the
		 * 			special value `404` meaning that this ISettingsList is malformed and/or contains
		 * 			garbage data.
		 */
		private function _recordedTimeAtOrBefore (parameter : IParameter, percentTime : uint, useFallback : Boolean = true) : uint {
			var uid : String = parameter.uid;
			var searchIndex : int = percentTime;
			while (searchIndex >= MIN_TIME && _values[uid][searchIndex] === undefined) {
				searchIndex--;
			}
			
			// Nothing found backwards, try moving forward
			if (searchIndex < MIN_TIME) {
				searchIndex = ERROR_CODE;
				if (useFallback) {
					return _recordedTimeAtOrAfter(parameter, percentTime, false);
				}
			}
			
			// Something found at given position or before it
			return searchIndex;
		}
		
		/**
		 * Returns the recorded time that is closest to given `percentTime` argument, searching
		 * forward if no entry is found to match the `percentTime` argument given. In case searching
		 * forward yelds no result, falls back to a backward search. 
		 * 
		 * @param	parameter
		 * 			The parameter to filter matching records by.
		 * 
		 * @param	percentTime
		 * 			The point in time to start searching from.
		 * 
		 * @param	useFallback
		 * 			Whether to search in the opposite direction as a fallback, default `true`.
		 * 			Internally set to `false` from fallback calls, to prevent infinite loops.
		 * 
		 * @return	A percent time, as an unsigned integer between `0` and `100` inclusive.  May return the
		 * 			special value `404` meaning that this ISettingsList is malformed and/or contains
		 * 			garbage data.
		 */
		private function _recordedTimeAtOrAfter (parameter : IParameter, percentTime : uint, useFallback : Boolean = true) : uint {
			var uid : String = parameter.uid;
			var searchIndex : int = percentTime;
			while (searchIndex <= LAST_SLOT && _values[uid][searchIndex] === undefined) {
				searchIndex++;
			}
			
			// Nothing found backwards, try moving forward
			if (searchIndex > LAST_SLOT) {
				searchIndex = ERROR_CODE;
				if (useFallback) {
					return _recordedTimeAtOrBefore (parameter, percentTime, false);
				}
			}
			
			// Something found at given position or before it
			return searchIndex;
		}
		
		/**
		 * Helper function to compute linear interpolation. All numeric arguments are 
		 * expected to be floats.
		 * 
		 * @param	x1
		 * 			The start point. 
		 * 
		 * @param	y1
		 * 			The start value (known value at the starting point). 
		 * 
		 * @param	x3
		 * 			The end point.
		 * 
		 * @param	y3
		 * 			The end value (known value at the ending point).
		 * 
		 * @param	x2
		 * 			The "interpolation" point, the point we need a calculated value for.
		 * 
		 * @return	The calculated (interpolated) value for `x2` (aka `y2`). Returns `NaN`
		 * 			if any of the arguments is `NaN`.
		 */
		private function _computeLinearInterpolation (x1 : Number, y1 : Number, x3 : Number, y3 : Number, x2 : Number) : Number {
			var displacement : Number = ((x2 - x1) * (y3 - y1) / (x3 - x1));
			return (isNaN(displacement)? 0 : displacement) + y1;
		}
		
		/**
		 * Throws if provided `value` does not match given parameter's type and minimum and maximum thresholds.
		 * Effectivelly enforces client code to store semantically acurate data in each triplet.
		 * 
		 * The validation rules are:
		 * 
		 * (1) Parameters having the type `Constants.TYPE_ARRAY` are assumed to contain unsigned integers with
		 * values ranging from `1` to `100`. The value must be of type `uint`, and must NOT be a `NaN`.
		 * 
		 * (2) Parameters having the type `Constants.TYPE_INT` must respect their respective `minValue` and 
		 * `maxValue` if given, and the value must be of type `int`. The minimum and maximum thresholds must be,
		 * themselves, of type `int`.
		 * 
		 * (3) For all the remaining parameter types (`Constants.TYPE_BOOLEAN`, `Constants.TYPE_STRING` and 
		 * `Constants.TYPE_OBJECT`)  the value must be of the appropriate type.
		 * 
		 * @return	`True` if assertion passes, `false` otherwise. The return value is a back-up for the case where
		 * 			RTEs are globally suppressed. The `value` should NOT be set if this function returns `false`.
		 */
		private function _assertProperValue (parameter:IParameter, percentTime:uint, value:Object) : Boolean {
			var assertTokens : Array;
			var assertMessage : String; 
			var type : uint = parameter.type;
			var haveMinThreshold : Boolean = (parameter.minValue !== null && !_isNaN (parameter.minValue));
			var haveMaxThreshold : Boolean = (parameter.maxValue !== null && !_isNaN (parameter.maxValue));
			switch (type) {
				case CoreOperationKeys.TYPE_ARRAY:
					var minUint : uint = 1;
					var maxUint : uint = 100;
					assertTokens = [];
					if (value === null) {
						assertTokens.push (NULL_VALUE_ERR);
					}
					if (_isNaN (value)) {
						assertTokens.push (NAN_VALUE_ERR);
					}
					if (!(value is uint)) {
						assertTokens.push (Strings.sprintf (BAD_TYPE_VALUE_ERR, 'uint', getQualifiedClassName (value)));
					}
					if ((value as uint) < minUint) {
						assertTokens.push (Strings.sprintf (TOO_SMALL_VALUE_ERR, value, minUint));
					}
					if ((value as uint) > maxUint) {
						assertTokens.push (Strings.sprintf (TOO_LARGE_VALUE_ERR, value, maxUint));
					}
					break;
				case CoreOperationKeys.TYPE_INT:
					var minInt : int = int.MIN_VALUE;
					var maxInt : int = int.MAX_VALUE;
					assertTokens = [];
					if (haveMinThreshold) {
						if (!(parameter.minValue is int)) {
							assertTokens.push (Strings.sprintf (BAD_TYPE_VALUE_ERR, 'int', getQualifiedClassName (parameter.minValue)));
						} else {
							minInt = (parameter.minValue as int);
						}
					}
					if (haveMaxThreshold) {
						if (!(parameter.maxValue is int)) {
							assertTokens.push (Strings.sprintf (BAD_TYPE_VALUE_ERR, 'int', getQualifiedClassName (parameter.maxValue)));
						} else {
							maxInt = (parameter.maxValue as int);
						}
					}
					if (value === null) {
						assertTokens.push (NULL_VALUE_ERR);
					}
					if (_isNaN (value)) {
						assertTokens.push (NAN_VALUE_ERR);
					}
					if (!(value is int)) {
						assertTokens.push (Strings.sprintf (BAD_TYPE_VALUE_ERR, 'int', getQualifiedClassName (value)));
					}
					if (haveMinThreshold) {
						if ((value as int) < minInt) {
							assertTokens.push (Strings.sprintf (TOO_SMALL_VALUE_ERR, value, minInt));	
						}
					}
					if (haveMaxThreshold) {
						if ((value as int) > maxInt) {
							assertTokens.push (Strings.sprintf (TOO_LARGE_VALUE_ERR, value, maxInt));
						}
					}
					break;
				case CoreOperationKeys.TYPE_BOOLEAN:
				case CoreOperationKeys.TYPE_STRING:
				case CoreOperationKeys.TYPE_OBJECT:
					// TODO: implement when actually needed.
					break;
			}
			if (assertTokens && assertTokens.length > 0) {
				assertTokens.unshift (Strings.sprintf (VALUE_ERR_HEADER, value, parameter.name, percentTime));
				assertMessage = assertTokens.join (CommonStrings.NEW_LINE);
				throw (new ArgumentError (assertMessage));
				return false;
			}
			return true;
		}
		
		/**
		 * Throws if provided `percentTime` is out of range, or inappropriate for given parameter's type.
		 * Effectivelly enforces client code to store semantically acurate data in each triplet.
		 * 
		 * The validation rules are:
		 * 
		 * (1) The value of `percentTime` must always be in the range of `1` to `100`, includding both ends.
		 * 
		 * (2) If the parameter's `type` is NOT `Constants.TYPE_ARRAY`, then `percentTime` must ALWAYS be the
		 * minimum allowed value.
		 * 
		 * @return	`True` if assertion passes, `false` otherwise. The return value is a back-up for the case where
		 * 			RTEs are globally suppressed. The `value` should NOT be set if this function returns `false`.
		 */
		private function _assertProperTime (parameter : IParameter, percentTime : uint) : Boolean {
			var assertMessage : String;
			var assertTokens : Array = [];
			if (percentTime < MIN_TIME) {
				assertTokens.push (Strings.sprintf (TOO_SMALL_TIME_ERR, percentTime, MIN_TIME));
			}
			if (percentTime > MAX_TIME) {
				assertTokens.push (Strings.sprintf (TOO_LARGE_TIME_ERR, percentTime, MAX_TIME));
			}
			if (parameter.type != CoreOperationKeys.TYPE_ARRAY && percentTime != MIN_TIME) {
				assertTokens.push (Strings.sprintf (NOT_ARRAY_TIME_ERR, parameter.name, percentTime, MIN_TIME));
			}
			if (assertTokens && assertTokens.length > 0) {
				assertTokens.unshift (Strings.sprintf (TIME_ERR_HEADER, percentTime, parameter.name));
				assertMessage = assertTokens.join (CommonStrings.NEW_LINE);
				throw (new ArgumentError (assertMessage));
				return false;
			}
			return true;
		}
		
		/**
		 * Universally reliable way of determining whether a value is the reserved type `NaN` or not.
		 */
		private function _isNaN (value : Object) : Boolean {
			return !(value === value);
		}
	}
}