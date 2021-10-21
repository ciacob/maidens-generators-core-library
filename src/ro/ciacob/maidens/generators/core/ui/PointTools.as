package ro.ciacob.maidens.generators.core.ui {
	
	/**
	 * Class with static methods for handling the "point" values inside a parameter envelope
	 */
	public class PointTools {
		public static const INDEX_MIN : int = 1;
		public static const INDEX_MAX : int = 100;
		public static const VALUE_MIN : int = 1;
		public static const VALUE_MAX : int = 100;
		public static const MIN_ACTUAL_POINTS_PER_ENVELOPE : int = 2;
		
		/**
		 * Ensures that given `points` Array contains properly formatted parameters values, so that the
		 * envelopes editor can display and manipulate them safely. Operates any changes in-place, on the existing
		 * Array.
		 * 
		 * Proofing rules are:
		 * - the Array must not be empty;
		 * - the Array must contain at least two points;
		 * - the Array's first non-empty index must be `1` and the last non-empty index must be `100`.
		 * - all non-empty indices must contain integers in the `1` to `100` range includding both ends.
		 * 
		 * Returns the provided `points` Array, with any needed corrections applied.
		 */
		public static function sanitizeEnvelopePoints (rawPoints : Array) : Array {
			if (!rawPoints) {
				return [];
			}
			var points : Array = rawPoints.concat();
			var haveCorrections : Boolean = false;
			
			// Build a list with all non-empty indices (fit the correct range while doing so)
			var actualData : Array = [];
			for (var i : int = 0; i < points.length; i++) {
				if (points[i] !== undefined) {
					actualData.push ({
						index: i,
						value : Math.min (VALUE_MAX, Math.max (VALUE_MIN, points[i]))
					});
				}
			}
			
			// Ensure minimum required points
			if (actualData.length == 0) {
				haveCorrections = true;
				actualData.push ({index: INDEX_MIN, value : VALUE_MIN});
			}
			if (actualData.length == 1) {
				haveCorrections = true;
				actualData[0].index = INDEX_MIN;
				actualData.push ({index: INDEX_MAX, value : actualData[0].value});
			}
			
			// Ensure that the first and last points are stored under the first and last indices respectivelly
			if (actualData.length >= 2) {
				var firstPoint : Object = actualData[0];
				if (firstPoint.index > INDEX_MIN) {
					haveCorrections = true;
					firstPoint.index = INDEX_MIN
				}
				var lastPoint : Object = actualData[actualData.length - 1];
				if (lastPoint.index < INDEX_MAX) {
					haveCorrections = true;
					lastPoint.index = INDEX_MAX;
				}
			}
			
			// Recreate the `points` Array based on applied corrections (if any)
			if (haveCorrections) {
				points.length = 0;
				for (var j : int = 0; j < actualData.length; j++) {
					var data : Object = actualData[j] as Object;
					points[data.index] = data.value;
				}
			}
			return points;
		}
		
		/**
		 * Counts the values that are not `undefined` within the given `rawPoints` list.
		 */
		public static function countActualPoints (rawPoints : Array) : int {
			var numPoints : int = 0;
			if (rawPoints) {
				for (var i : int = 0; i < rawPoints.length; i++) {
					if (rawPoints[i] !== undefined) {
						numPoints++;
					}
				}
			}
			return numPoints;
		}
		
		/**
		 * Scans the given `rawPoints` and returns an Array with all the values that are not
		 * undefined.
		 */
		public static function getActualValues (rawPoints : Array) : Array {
			var actualValues : Array = [];
			if (rawPoints) {
				for (var i : int = 0; i < rawPoints.length; i++) {
					if (rawPoints[i] !== undefined) {
						actualValues.push (rawPoints[i]);
					}
				}
			}
			return actualValues;
		}
		
		/**
		 * Evaluates whether the given `points` actually describe any tweening at all,
		 * i.e., there are at least two actual points and they hold at least two different
		 * values.
		 */
		public static function pointsIncurTweening (points : Array) : Boolean {
			if (points) {
				var numActualPoints : int = countActualPoints (points);
				if (countActualPoints(points) >= MIN_ACTUAL_POINTS_PER_ENVELOPE) {
					var lastValue : int = -1;
					for (var i : int = 0; i < points.length; i++) {
						if (points[i] !== undefined) {
							if (lastValue != -1 && lastValue != points[i]) {
								return true;
							}
							lastValue = (points[i] as int);
						}
					}
				}
			}
			return false;
		}
		
		/**
		 * Returns the rounded average of all actual points in the given `points` list.
		 * Returns `VALUE_MIN` if an average cannot be computed.
		 */
		public static function getRoundedAverage (points : Array) : int {
			if (!points) {
				return VALUE_MIN;
			}
			var actualValues : Array = getActualValues (points);
			var numValues : int = actualValues.length;
			if (!numValues) {
				return VALUE_MIN;
			}
			var sum : int = 0;
			for (var i:int = 0; i < actualValues.length; i++) {
				sum += (actualValues[i] as int);
				
			}
			return Math.round (sum / numValues);
		}
		
		/**
		 * Modifies in place (and returns) the given `points` list, so that it only contains two
		 * points, placed at `INDEX_MIN` and `INDEX_MAX` respectivelly, each point holding the 
		 * provided value.
		 */
		public static function toBareList (points: Array, value : int) : Array {
			if (!points) {
				points = [];
			}
			points.length = 0;
			points[INDEX_MIN] = value;
			points[INDEX_MAX] = value;
			return points;
		}
		
		/**
		 * Returns a copy of given `points` list with all tweening information removed,
		 * i.e., the returned version will contain only two points, placed at `INDEX_MIN`
		 * and `INDEX_MAX` respectivelly, and each point will hold the rounded average value
		 * of all the points in the original version of `points`.
		 */
		public static function removeTweening (points : Array) : Array {
			if (!points) {
				return [];
			}
			var average : int = getRoundedAverage (points);
			return toBareList (points, average);
		}		
	}
}