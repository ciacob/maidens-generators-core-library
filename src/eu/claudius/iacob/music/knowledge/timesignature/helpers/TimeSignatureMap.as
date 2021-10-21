package eu.claudius.iacob.music.knowledge.timesignature.helpers {
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.ITimeSignatureEntry;
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.ITimeSignatureMap;
	
	import ro.ciacob.math.Fraction;
	import ro.ciacob.math.IFraction;
	
	/**
	 * Container to store a number of musical measures with their respective time signatures.
	 * @author Claudius Iacob
	 */
	public class TimeSignatureMap implements ITimeSignatureMap {
		
		private var _zeroFraction : IFraction;
		private var _self : ITimeSignatureMap;
		private var _entries : Vector.<ITimeSignatureEntry> = new Vector.<ITimeSignatureEntry>;
		private var _duration : IFraction;
		
		/**
		 * @constructor
		 * @see ITimeSignatureMap
		 */
		public function TimeSignatureMap() {
			_self = this;
		}
		
		/**
		 * @see ITimeSignatureMap.duration
		 */
		public function get duration():IFraction {
			return _duration || ZERO_FRACTION;
		}

		/**
		 * @see ITimeSignatureMap.every
		 */
		public function every(callback:Function):Boolean {
			return _entries.every (_wrapCallback(callback));
		}
		
		/**
		 * @see ITimeSignatureMap.forEach
		 */
		public function forEach(callback:Function):void {
			_entries.forEach (_wrapCallback(callback));
		}
		
		/**
		 * @see ITimeSignatureMap.getAt
		 */
		public function getAt(index:int):ITimeSignatureEntry {
			return _entries[index];
		}
		
		/**
		 * @see ITimeSignatureMap.indexOf
		 */
		public function indexOf(searchEntry:ITimeSignatureEntry, fromIndex:int=0):int {
			return _entries.indexOf (searchEntry, fromIndex);
		}
		
		/**
		 * @see ITimeSignatureMap.insertAt
		 */
		public function insertAt(index:int, entry:ITimeSignatureEntry):void {
			_entries.splice (index, 0, entry);
			_addDurationOf (entry);
			
		}
		
		/**
		 * @see ITimeSignatureMap.lastIndexOf
		 */
		public function lastIndexOf (searchEntry : ITimeSignatureEntry, fromIndex:int=0x7fffffff):int {
			return _entries.lastIndexOf (searchEntry, fromIndex);
		}
		
		/**
		 * @see ITimeSignatureMap.length
		 */
		public function get length():uint {
			return _entries.length;
		}
		
		/**
		 * @see ITimeSignatureMap.pop
		 */
		public function pop():ITimeSignatureEntry {
			var entry : ITimeSignatureEntry = _entries[_entries.length - 1] as ITimeSignatureEntry;
			_removeDurationOf(entry);
			return _entries.pop();
		}
		
		/**
		 * @see ITimeSignatureMap.push
		 */
		public function push(...entries):uint {
			var i : int = 0;
			var numEntries : uint = entries.length;
			for (i; i < numEntries; i++) {
				_addDurationOf (entries[i]);
			}
			return _entries.push.apply (null, entries);
		}
		
		/**
		 * @see ITimeSignatureMap.removeAt
		 */
		public function removeAt(index:int):ITimeSignatureEntry {
			var entry : ITimeSignatureEntry = _entries[index] as ITimeSignatureEntry;
			_removeDurationOf(entry);
			_entries.splice (index, 1);
			return entry;
		}
		
		/**
		 * @see ITimeSignatureMap.reverse
		 */
		public function reverse():void {
			_entries.reverse();
		}
		
		/**
		 * @see ITimeSignatureMap.shift
		 */
		public function shift():ITimeSignatureEntry {
			var entry : ITimeSignatureEntry = _entries[0] as ITimeSignatureEntry;
			_removeDurationOf(entry);
			return _entries.shift();
		}
		
		/**
		 * @see ITimeSignatureMap.some
		 */
		public function some(callback:Function):Boolean {
			return _entries.some (_wrapCallback(callback));
		}
		
		/**
		 * @see ITimeSignatureMap.sort
		 */
		public function sort(...args):void {
			_entries.sort.apply (null, args);
		}
		
		/**
		 * @see ITimeSignatureMap.splice
		 */
		public function splice (startIndex:int, deleteCount:uint=4294967295, ...entries):void {
			var i : int;
			var numEntries : uint;
			if (deleteCount > 0) {
				var entriesToDelete : Vector.<ITimeSignatureEntry> = _entries.slice (startIndex, startIndex + deleteCount);
				i = 0;
				numEntries = entriesToDelete.length;
				for (i; i < numEntries; i++) {
					_removeDurationOf (entriesToDelete[i]);
				}
			}
			if (entries.length > 0) {
				i = 0;
				numEntries = entries.length;
				for (i; i < numEntries; i++) {
					_addDurationOf (entries[i]);
				}
			}
			_entries.splice (startIndex, deleteCount, entries);
		}
		
		/**
		 * @see ITimeSignatureMap.toString
		 */
		public function toString():String {
			return _entries.toString();
		}
		
		/**
		 * @see ITimeSignatureMap.unshift
		 */
		public function unshift(...entries):uint {
			var i : int = 0;
			var numEntries : uint = entries.length;
			for (i; i < numEntries; i++) {
				_addDurationOf (entries[i]);
			}
			return _entries.unshift.apply (null, entries);
		}
		
		/**
		 * Adapter callback function to replace the internal Vector argument with the ITimeSignatureMap instance
		 */
		private function _wrapCallback (originalCallback : Function) : Function {
			var wrapper : Function = function (entry : ITimeSignatureEntry, index : int, notUsed : Object) : Boolean {
				return originalCallback (entry, index, _self);
			}
			return wrapper;
		}
		
		/**
		 * Updates the total `_duration` to include the duration of given ITimeSignatureEntry instance.
		 */
		private function _addDurationOf (entry : ITimeSignatureEntry) : void {
			if (_duration == null) {
				_duration = new Fraction;
			}
			_duration = _duration.add (entry.duration);
		}
		
		/**
		 * Updates the total `_duration` to remove the duration of given ITimeSignatureEntry instance.
		 */
		private function _removeDurationOf (entry : ITimeSignatureEntry) : void {
			if (_duration == null) {
				_duration = new Fraction;
			}
			_duration = _duration.subtract (entry.duration);
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