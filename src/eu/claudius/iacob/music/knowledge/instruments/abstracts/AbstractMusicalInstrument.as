package eu.claudius.iacob.music.knowledge.instruments.abstracts {
	import flash.utils.getQualifiedClassName;

	import eu.claudius.iacob.music.knowledge.instruments.interfaces.IMusicalInstrument;

	import ro.ciacob.utils.Strings;

	/**
	 * Container to store information about a musical instrument.
	 * @abstract
	 */
	public class AbstractMusicalInstrument implements IMusicalInstrument {

		private var _uid:String;

		/**
		 * @constructor
		 * @param	subclass
		 * 			The instance of the subclass that implements this abstract class.
		 */
		public function AbstractMusicalInstrument(subclass:AbstractMusicalInstrument) {
			if (!subclass) {
				_yeldAbstractClassError();
			}
		}

		/**
		 * @see IMusicalInstrument.abbreviatedName
		 */
		public function get abbreviatedName():String {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalInstrument.ordinalIndex
		 */
		public function get ordinalIndex () : int {
			_yeldAbstractClassError();
			return -1;
		}

		/**
		 * @see IMusicalInstrument.abbreviatedStaffNames
		 */
		public function get abbreviatedStaffNames():Vector.<String> {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalInstrument.bracket
		 */
		public function get bracket():String {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalInstrument.clefs
		 */
		public function get clefs():Vector.<String> {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalInstrument.internalName
		 */
		public function get internalName():String {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalInstrument.midiPatch
		 */
		public function get midiPatch():uint {
			_yeldAbstractClassError();
			return 0;
		}

		/**
		 * @see IMusicalInstrument.midiRange
		 */
		public function get midiRange():Vector.<uint> {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalInstrument.idealHarmonicRange
		 */
		public function get idealHarmonicRange():Vector.<uint> {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalInstrument.maximumPoliphony
		 */
		public function get maximumPoliphony():uint {
			_yeldAbstractClassError();
			return 0;
		}

		/**
		 * @see IMusicalInstrument.maximumAutonomousVoices
		 */
		public function get maximumAutonomousVoices():uint {
			_yeldAbstractClassError();
			return 0;
		}

		/**
		 * @see IMusicalInstrument.name
		 */
		public function get name():String {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalInstrument.partFamily
		 */
		public function get partFamily():String {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalInstrument.staffNames
		 */
		public function get staffNames():Vector.<String> {
			_yeldAbstractClassError();
			return null;
		}

		/**
		 * @see IMusicalInstrument.stavesNumber
		 */
		public function get stavesNumber():uint {
			_yeldAbstractClassError();
			return 0;
		}

		public function set stavesNumber(value:uint):void {
			_yeldAbstractClassError();
		}

		/**
		 * @see IMusicalInstrument.transposition
		 */
		public function get transposition():int {
			_yeldAbstractClassError();
			return 0;
		}

		/**
		 * @see IMusicalInstrument.uid
		 */
		public final function get uid():String {
			if (!_uid) {
				_uid = Strings.generateRFC4122GUID();
			}
			return _uid;
		}

		public function set uid(value:String):void {
			_uid = value;
		}

		/**
		 * Produces a runtime error as a reminder that the class is abstract
		 */
		private function _yeldAbstractClassError():void {
			throw ('The class `' + getQualifiedClassName(this) +
					'` is abstract; please remember to extend it and override its methods as needed.');
		}
	}
}