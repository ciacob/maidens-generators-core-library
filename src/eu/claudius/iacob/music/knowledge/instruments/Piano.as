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
	
	public class Piano extends AbstractMusicalInstrument implements IMusicalInstrument {
		
		private static const INTERNAL_NAME : String = 'PIANO';
		
		private static var _abbreviatedStaffNames : Vector.<String>;
		private static var _clefs : Vector.<String>;
		private static var _partFamily : String;
		private static var _midiRange : Vector.<uint>;
		
		public function Piano() {
			super(this); 
		}
		
		override public function get internalName () : String {
			return INTERNAL_NAME;
		}
		
		override public function get name () : String {
			return PartNames[INTERNAL_NAME] as String;
		}
		
		override public function get abbreviatedName () : String {
			return PartAbbreviatedNames[INTERNAL_NAME];
		}
		
		override public function get staffNames() : Vector.<String> {
			if (!_abbreviatedStaffNames) {
				_abbreviatedStaffNames = Vector.<String>(PartAbbreviatedVoiceNames[INTERNAL_NAME]);
			}
			return _abbreviatedStaffNames;
		}
		
		override public function get stavesNumber () : uint {
			return PartDefaultStavesNumber[INTERNAL_NAME] as uint;
		}
		
		override public function get clefs () : Vector.<String> {
			if (!_clefs) {
				_clefs = Vector.<String> (PartDefaultClefs[INTERNAL_NAME]);
			}
			return _clefs; 
		}
		
		override public function get bracket () : String {
			return PartDefaultBrackets[INTERNAL_NAME];
		}
		
		override public function get partFamily () : String {
			if (!_partFamily) {
				_partFamily = PartFamilies.getPartFamily(INTERNAL_NAME);
			}
			return _partFamily;
		}
		
		override public function get midiPatch () : uint {
			return PartMidiPatches [INTERNAL_NAME];
		}
		
		override public function get midiRange () : Vector.<uint> {
			if (!_midiRange) {
				_midiRange = Vector.<uint> (PartRanges[INTERNAL_NAME]);
			}
			return _midiRange;
		}
		
		override public function get idealHarmonicRange() : Vector.<uint> {
			return Vector.<uint> (PartIdealHarmonicRange[INTERNAL_NAME]);
		}
		
		override public function get maximumPoliphony() : uint {
			return PartMaxPoliphony[INTERNAL_NAME];
		}
		
		override public function get maximumAutonomousVoices () : uint {
			return PartMaxAutonomousVoices[INTERNAL_NAME];
		}
		
		override public function get transposition () : int {
			return PartTranspositions [INTERNAL_NAME];
		}

	}
}