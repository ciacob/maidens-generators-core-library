package ro.ciacob.maidens.generators.core {
	import ro.ciacob.maidens.generators.core.interfaces.IMusicUnit;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicalBody;
	import ro.ciacob.math.Fraction;
	import ro.ciacob.math.IFraction;
	

	/**
	A container for MusicalUnit objects, representing the actual musical result of a generation operation, in a meta-musical format.
	@author Claudius Iacob
	*/
	public class MusicalBody implements IMusicalBody {
		
		private var _zeroFraction : IFraction;
		private var _units : Vector.<IMusicUnit> = new Vector.<IMusicUnit>;
		private var _duration : IFraction;
		private var _self : IMusicalBody;
		
		/**
		 * @constructor
		 * @see IMusicalBody
		 */
		public function MusicalBody() {
			_self = this;
		}
		
		/**
		 * @see IMusicalBody.duration
		 */
		public function get duration():IFraction {
			return _duration || ZERO_FRACTION;
		}
		
		/**
		 * @see IMusicalBody.updateDuration
		 */
		public function updateDuration () : void {
			_duration.setValue (0,1);
			var i : int = 0;
			var numUnits : uint = _units.length;
			for (i; i < numUnits; i++) {
				_addDurationOf (_units[i]);
			}
		}
		
		/**
		 * @see Array.length
		 */
		public function get length () : uint {
			return _units.length;
		}

		/**
		 * @see Array.length
		 */
		public function set length (value : uint) : void {
			_units.length = value;
			updateDuration();
		}
		
		
		/**
		 * @see Array.every
		 */
		public function every (callback : Function) : Boolean {
			return !!_units.every (_wrapCallback(callback));
		};
		
		/**
		 * @see Array.forEach
		 */
		public function forEach (callback:Function) : void {
			_units.forEach (_wrapCallback(callback));
		};
		
		/**
		 * Returns IMusicUnit instance at given index.
		 */
		public function getAt (index : int) : IMusicUnit {
			return _units[index];
		}
		
		/**
		 * @see Array.indexOf
		 */
		public function indexOf (searchUnit : IMusicUnit, fromIndex : int = 0) : int {
			return _units.indexOf (searchUnit, fromIndex);
		};
		
		/**
		 * @see Array.insertAt
		 */
		public function insertAt (index : int, unit : IMusicUnit) : void {
			_units.splice (index, 0, unit);
			_addDurationOf (unit);
		};
		
		/**
		 * @see Array.lastIndexOf
		 */
		public function lastIndexOf (searchUnit : IMusicUnit, fromIndex : int = 0x7fffffff) : int {
			return _units.lastIndexOf (searchUnit, fromIndex);
		};
		
		/**
		 * @see Array.pop
		 */
		public function pop() : IMusicUnit {
			var unit : IMusicUnit = _units[_units.length - 1] as IMusicUnit;
			_removeDurationOf(unit);
			return _units.pop();
		};
		
		/**
		 * @see Array.push
		 */
		public function push (... units) : uint {
			var i : int = 0;
			var numUnits : uint = units.length;
			for (i; i < numUnits; i++) {
				_addDurationOf (units[i]);
			}
			return _units.push.apply (null, units);
		};
		
		/**
		 * @see Array.removeAt
		 */
		public function removeAt(index:int):IMusicUnit {
			var unit : IMusicUnit = _units[index] as IMusicUnit;
			_removeDurationOf(unit);
			_units.splice (index, 1);
			return unit;
		};
		
		/**
		 * @see Array.reverse
		 */
		public function reverse() : void {
			_units.reverse();
		};
		
		/**
		 * @see Array.shift
		 */
		public function shift() : IMusicUnit {
			var unit : IMusicUnit = _units[0] as IMusicUnit;
			_removeDurationOf(unit);
			return _units.shift();
		};
		
		/**
		 * @see Array.some
		 */
		public function some(callback:Function) : Boolean {
			return _units.some (_wrapCallback(callback));
		};
		
		/**
		 * @see Array.sort
		 */
		public function sort (... args) : void {
			_units.sort.apply (null, args);
		};
		
		/**
		 * @see Array.splice
		 */
		public function splice (startIndex:int, deleteCount:uint = 4294967295, ... units) : void {
			var i : int;
			var numUnits : uint;
			if (deleteCount > 0) {
				var unitsToDelete : Vector.<IMusicUnit> = _units.slice (startIndex, startIndex + deleteCount);
				i = 0;
				numUnits = unitsToDelete.length;
				for (i; i < numUnits; i++) {
					_removeDurationOf (unitsToDelete[i]);
				}
			}
			if (units.length > 0) {
				i = 0;
				numUnits = units.length;
				for (i; i < numUnits; i++) {
					_addDurationOf (units[i]);
				}
			}
			units.unshift(deleteCount);
			units.unshift(startIndex);
			_units.splice.apply (_units, units);
		}
		
		/**
		 * @see Array.toString
		 */
		public function toString() : String {
			return _units.toString();
		};
		
		/**
		 * @see Array.unshift
		 */
		public function unshift (... units) : uint {
			var i : int = 0;
			var numUnits : uint = units.length;
			for (i; i < numUnits; i++) {
				_addDurationOf (units[i]);
			}
			return _units.unshift.apply (null, units);
		};

		/**
		 * Adapter callback function to replace the internal Vector argument with the IMusicalBody instance
		 */
		private function _wrapCallback (originalCallback : Function) : Function {
			var wrapper : Function = function (item : IMusicUnit, index : int, notUsed : Object) : Boolean {
				return originalCallback (item, index, _self);
			}
			return wrapper;
		}
		
		/**
		 * Updates the total `_duration` to include the duration of given IMusicUnit instance.
		 */
		private function _addDurationOf (unit : IMusicUnit) : void {
			if (_duration == null) {
				_duration = new Fraction;
			}
			_duration = _duration.add (unit.duration);
		}
		
		/**
		 * Updates the total `_duration` to remove the duration of given IMusicUnit instance.
		 */
		private function _removeDurationOf (unit : IMusicUnit) : void {
			if (_duration == null) {
				_duration = new Fraction;
			}
			_duration = _duration.subtract (unit.duration);
		}
		
		/**
		 * Convenience getter for a IFraction instance that equals to "0". We do not want to
		 * couple this class with `Fraction` and therefore will not use `Fraction.ZERO`.
		 */
		private function get ZERO_FRACTION () : IFraction {
			if (!_zeroFraction) {
				_zeroFraction = Fraction.ZERO;
			}
			return _zeroFraction;
		}
	}
}