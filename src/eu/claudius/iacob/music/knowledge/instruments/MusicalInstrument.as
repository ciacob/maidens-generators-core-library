package eu.claudius.iacob.music.knowledge.instruments {
	import eu.claudius.iacob.music.knowledge.instruments.abstracts.AbstractMusicalInstrument;
	import eu.claudius.iacob.music.knowledge.instruments.interfaces.IMusicalInstrument;
	
	import ro.ciacob.maidens.generators.constants.parts.PartAbbreviatedNames;
	import ro.ciacob.maidens.generators.constants.parts.PartAbbreviatedVoiceNames;
	import ro.ciacob.maidens.generators.constants.parts.PartDefaultBrackets;
	import ro.ciacob.maidens.generators.constants.parts.PartDefaultClefs;
	import ro.ciacob.maidens.generators.constants.parts.PartDefaultStavesNumber;
	import ro.ciacob.maidens.generators.constants.parts.PartFamilies;
	import ro.ciacob.maidens.generators.constants.parts.PartIdealHarmonicRange;
	import ro.ciacob.maidens.generators.constants.parts.PartMaxAutonomousVoices;
	import ro.ciacob.maidens.generators.constants.parts.PartMaxPoliphony;
	import ro.ciacob.maidens.generators.constants.parts.PartMidiPatches;
	import ro.ciacob.maidens.generators.constants.parts.PartNames;
	import ro.ciacob.maidens.generators.constants.parts.PartRanges;
	import ro.ciacob.maidens.generators.constants.parts.PartTranspositions;
	import ro.ciacob.utils.Strings;
	
	/**
	 * Represents a musical instrument. Its properties are compiled from the dedicated music knowledge
	 * classes in the "ro.ciacob.maidens.generators.constants.parts" package.
	 */
	public class MusicalInstrument extends AbstractMusicalInstrument implements IMusicalInstrument {
		
		private var _internalName : String;
		private var _ordinalIndex : int;
		private var _abbreviatedStaffNames : Vector.<String>;
		private var _clefs : Vector.<String>;
		private var _partFamily : String;
		private var _midiRange : Vector.<uint>;
		private var _idealHarmonicRange : Vector.<uint>;
		private var _name : String;
		private var _abbreviatedName : String;
		private var _bracket : String;
		private var _stavesNumber : uint;
		private var _midiPatch : uint;
		private var _maximumPoliphony : uint;
		private var _maximumAutonomousVoices : uint;
		private var _transposition : int = int.MAX_VALUE;
		
		/**
		 * @constructor
		 * @param	instrumentName
		 * 			One of the names defined in the constants class 
		 * 			"ro.ciacob.maidens.generators.constants.parts.PartNames", e.g., "Piano" or 
		 * 			"Acoustic bass guitar". They will be converted internally to "PIANO" or
		 * 			"ACOUSTIC_BASS_GUITAR".
		 */
		public function MusicalInstrument (instrumentName : String, ordinalIndex : int) {
			super (this);
			_internalName = Strings.toAS3ConstantCase (instrumentName);
			_ordinalIndex = ordinalIndex;
		}
		
		/**
		 * @see IMusicalInstrument.internalName
		 */
		override public function get internalName () : String {
			return _internalName;
		}
		
		/**
		 * @see IMusicalInstrument.name
		 */
		override public function get name () : String {
			if (_name == null) {
				_name = PartNames[_internalName] as String;
			}
			return _name;
		}
		
		/**
		 * @see IMusicalInstrument.abbreviatedName
		 */
		override public function get abbreviatedName () : String {
			if (_abbreviatedName == null) {
				_abbreviatedName = PartAbbreviatedNames[_internalName];
			}
			return _abbreviatedName;
		}

		/**
		 * @see IMusicalInstrument.ordinalIndex
		 */
		override public function get ordinalIndex () : int {
			return _ordinalIndex;
		}
		
		/**
		 * @see IMusicalInstrument.staffNames
		 */
		override public function get staffNames() : Vector.<String> {
			if (_abbreviatedStaffNames == null) {
				_abbreviatedStaffNames = Vector.<String>(PartAbbreviatedVoiceNames[_internalName]);
			}
			return _abbreviatedStaffNames;
		}
		
		/**
		 * @see IMusicalInstrument.stavesNumber
		 */
		override public function get stavesNumber () : uint {
			if (_stavesNumber == 0) {
				_stavesNumber = (PartDefaultStavesNumber[_internalName] as uint);
			}
			return _stavesNumber;
		}
		override public function set stavesNumber (value : uint) : void {
			_stavesNumber = value;
		}
		
		/**
		 * @see IMusicalInstrument.clefs
		 */
		override public function get clefs () : Vector.<String> {
			if (_clefs == null) {
				_clefs = Vector.<String> (PartDefaultClefs[_internalName]);
			}
			return _clefs; 
		}
		
		/**
		 * @see IMusicalInstrument.bracket
		 */
		override public function get bracket () : String {
			if (_bracket == null) {
				_bracket = PartDefaultBrackets[_internalName];
			}
			return _bracket;
		}
		
		/**
		 * @see IMusicalInstrument.partFamily
		 */
		override public function get partFamily () : String {
			if (_partFamily == null) {
				_partFamily = PartFamilies.getPartFamily(_internalName);
			}
			return _partFamily;
		}
		
		/**
		 * @see IMusicalInstrument.midiPatch
		 */
		override public function get midiPatch () : uint {
			if (_midiPatch == 0) {
				_midiPatch = PartMidiPatches [_internalName];
			}
			return _midiPatch;
		}
		
		/**
		 * @see IMusicalInstrument.midiRange
		 */
		override public function get midiRange () : Vector.<uint> {
			if (_midiRange == null) {
				_midiRange = Vector.<uint> (PartRanges[_internalName]);
			}
			return _midiRange;
		}
		
		/**
		 * @see IMusicalInstrument.idealHarmonicRange
		 */
		override public function get idealHarmonicRange() : Vector.<uint> {
			if (_idealHarmonicRange == null) {
				_idealHarmonicRange = Vector.<uint> (PartIdealHarmonicRange[_internalName]);
			}
			return _idealHarmonicRange;
		}
		
		/**
		 * @see IMusicalInstrument.maximumPoliphony
		 */
		override public function get maximumPoliphony() : uint {
			if (_maximumPoliphony == 0) {
				_maximumPoliphony = PartMaxPoliphony[_internalName];
			}
			return _maximumPoliphony;
		}
		
		/**
		 * @see IMusicalInstrument.maximumAutonomousVoices
		 */
		override public function get maximumAutonomousVoices () : uint {
			if (_maximumAutonomousVoices == 0) {
				_maximumAutonomousVoices = PartMaxAutonomousVoices[_internalName];
			}
			return _maximumAutonomousVoices;
		}
		
		/**
		 * @see IMusicalInstrument.transposition
		 */
		override public function get transposition () : int {
			if (_transposition == int.MAX_VALUE) {
				_transposition = PartTranspositions [_internalName];
			}
			return _transposition;
		}

		/**
		 * Useful for debugging purposes.
		 * @return
		 */
		public function toString () : String {
			return ('Musical Instrument: ' +  name + ' (' + midiRange.join(', ') + ')');
		}
	}
}