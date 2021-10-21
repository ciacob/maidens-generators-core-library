package eu.claudius.iacob.music.knowledge.instruments.interfaces {
	
	/**
	 * Container to store information about a musical instrument.
	 * @author Claudius Iacob
	 */
	public interface IMusicalInstrument {
		
		/**
		 * Internally or externally defined ID that globally identifies this instrument instance.
		 */
		function get uid () : String;
		function set uid (value : String) : void;
		
		/**
		 * Alternative name used to look up individual instrument features in constant classes such as
		 * PartFamilies or PartMidiPatches, e.g., for a Piano, you would return "PIANO".
		 */
		function get internalName () : String;
		
		/**
		 * The name this instrument would use when notated in a score, e.g.,
		 * a Piano would return "Pno.". The value is returned by class PartNames, e.g.:
		 * 
		 * var name : String = PartNames[this.internalName];
		 */
		function get name () : String;
		
		/**
		 * The abbreviated name this instrument would use when notated in a score, e.g.,
		 * a Piano would return "Pno.". The value is returned by class PartAbbreviatedNames, e.g.:
		 * 
		 * var abbreviatedName : String = PartAbbreviatedNames[this.internalName];
		 */
		function get abbreviatedName () : String;

		/**
		 * An integer helping to distinguish about several instances of the same instrument that miht be playing in the
		 * same score, e.g., in a score with two Violins, the first  will have the index "n", and the second will
		 * have "n+1".
		 */
		function get ordinalIndex () : int;
		
		/**
		 * Where applicable, the individual staff names this instrument uses.
		 * These may be displayed in the notated score in certain scenarios. For instance, 
		 * for an Organ this would return: 'Right Hand', 'Left Hand', 'Pedal'. The value is 
		 * provided by the PartVoiceNames class, e.g.:
		 * 
		 * var staffNames : Vector.<String> = new Vector.<String>(PartVoiceNames[this.internalName]);
		 */
		function get staffNames() : Vector.<String>;
		
		/**
		 * Where applicable, the abbreviated individual staff names this instrument uses.
		 * These may be displayed in the notated score in certain scenarios. For instance, 
		 * for an Organ this would return: 'R.H.', 'L.H.', 'Ped.'. The value is 
		 * provided by the PartAbbreviatedVoiceNames class, e.g.:
		 * 
		 * var abbreviatedStaffNames : Vector.<String> = new Vector.<String>(PartAbbreviatedVoiceNames[this.internalName]);
		 */
		function get abbreviatedStaffNames () : Vector.<String>;
		
		/**
		 * The number of staves this instrument implicitly uses when notated in a score. The default value is
		 * provided by the PartDefaultStavesNumber class, e.g.:
		 * 
		 * var numStaves : uint = PartDefaultStavesNumber[this.internalName];
		 * User can alter this value to shrink or expand an intrument's voices on less or more staves.
		 */
		function get stavesNumber () : uint;

		function set stavesNumber(value:uint):void;
		
		/**
		 * The clefs this instrument implicitly uses when notated in a score. The value is provided
		 * provided by the `PartDefaultClefs` class, e.g.:
		 * 
		 * var clefs : Vector.<String> = new Vector.<String>(PartDefaultClefs[this.internalName]);
		 */
		function get clefs () : Vector.<String>;
		
		/**
		 * The bracket this instrument implicitly uses when notated in a score. The value is 
		 * provided by the `PartDefaultBrackets` class.
		 */
		function get bracket () : String;
		
		/**
		 * The instruments taxonomy this instrument is normally part of, e.g., for a Piano
		 * this would return "KEYBOARDS". The value returned is provided by 
		 * the class PartFamilies, e.g.:
		 * 
		 * var myFamilyName : String = PartFamilies.getPartFamily(this.internalName);
		 */
		function get partFamily () : String;
		
		/**
		 * Returns the General MIDI compliant patch number for this instrument, e.g.,
		 * for a Piano this would return `0`, for a solo Violin, `40`, for Clarinet, `71`
		 * and so on. The value returned is provided by the class PartMidiPatches, e.g.:
		 * 
		 * var patchNumber : uint = PartMidiPatches(this.internalName);
		 */
		function get midiPatch () : uint;
		
		/**
		 * The MIDI (thus, "sounding", or "concert pitch") range of this instrument, e.g.,
		 * for a Piano this would return `[21, 108]`. The value returned is provided by 
		 * the class PartRanges, e.g.:
		 * 
		 * var range : Vector.<uint> = new Vector.<uint>(PartRanges(this.internalName));
		 */
		function get midiRange () : Vector.<uint>;
		
		/**
		 * The MIDI (thus, "sounding", or "concert pitch") range this instrument is most
		 * proficient in, when playing simultaneous pitches. This is usually a (portion)
		 * of the instrument's "middle range", because in this area its timbre has the
		 * right ballance of partials: not too many (which would clutter the chord beyond 
		 * recongnition) but not to few either (which would strip any "harmonic resonance"
		 * from the chord).
		 */
		function get idealHarmonicRange():Vector.<uint>;
		
		/**
		 * The maximum number of simultaneous pitches this instrument is able to emit,
		 * by construction. 
		 */
		function get maximumPoliphony() : uint;
		
		/**
		 * The maximum number of polyphonically independent melodic lines this instrument
		 * is able to produce, when operated by a seasoned professional player.
		 */
		function get maximumAutonomousVoices () : uint;
		
		
		/**
		 * The transposition, in semitones, a playback routine should apply to this
		 * instrument's part when notated in the score, e.g., for a French Horn this
		 * would return `-7`. The value is provided by the PartTranspositions class,
		 * e.g.:
		 * 
		 * var transposition : int = PartTranspositions[this.internalName];
		 */
		function get transposition () : int;
	}
	
}