package ro.ciacob.maidens.generators.core.interfaces {
	import ro.ciacob.math.IFraction;
	
	public interface IMusicUnit {
	
		/**
		 * Globally unique, readonly identifier to represent this music unit.
		 */
		function get uid () : String;
		
		/**
		 * The musical duration expressed as a fraction, e.g. 1/4 or 0.25 means a quarter or crotchet.
		 */
		function get duration () : IFraction;
		function set duration (value : IFraction) : void;
		
		/**
		 * If applicable, the identifier of the music unit that starts the tuplet this music unit is part of.
		 * If THIS music unit starts the tuplet, then `tupletRootUid` shall hold the same value as `uid`. 
		 */
		function get tupletRootUid () : String;
		function set tupletRootUid (value : String) : void;
		
		/**
		 * If applicable, contains information about the tuplet this music unit starts as an ITupletDefinition
		 * instance. This information includes:
		 * (1) tuplet nominal beats number, e.g., `3`,
		 * (2) tuplet nominal beat duration, e.g., `1/8`,
		 * (3) regular nominal beats number, e.g., `2` and 
		 * (4) regular nominal beat duration, e.g., `1/8`.
		 */
		function get tupletDefinition () : ITupletDefinition;
		function set tupletDefinition (value : ITupletDefinition) : void;
		
		/**
		 * The pitches this music unit defines, as IMusicPitch instances. Each instance defines a MIDI
		 * note number and whether to tie or not to the next music unit's pitch (provided it has the same
		 * MIDI note number).
		 * 
		 * The container itself is readonly, but its content can be freely set.
		 */
		function get pitches () : Vector.<IMusicPitch>;
		
		/**
		 * The allocation rules for distributing the pitches of this music unit among available instruments.
		 * The `pitchAllocations` and `pitches` lists maintain 1:1 correspondence, so that index `[1]` in
		 * `pitchAllocations` contains the destination for the pitch at index `[1]` in `pitches`. To achieve
		 * doubling (two instruments playing the same pitch, which is common is orchestration) surplus pitches
		 * of same MIDI note number must be provided.
		 * 
		 * The container itself is readonly, but its content can be freely set.
		 */
		function get pitchAllocations () : Vector.<IPitchAllocation>;
		
		/**
		 * Where applicable, performance indications (such as dynamics - pp, mp, p, tempo - Andante, Moderato,
		 * Allegro, etc.) to be added in relation to the pitches of this music unit. The `performanceInstructions`,
		 * `pitchAllocations` and `pitches` lists maintain 1:1 correspondence, so that performance instruction at
		 * index `[1]` inside `performanceInstructions` is to be placed in relation to the instrument and voice
		 * specified at index `[1]` inside `pitchAllocations` and in relation to pitch found at index `[1]` inside
		 * `pitches`.
		 * 
		 * The container itself is readonly, but its content can be freely set. 
		 */
		function get performanceInstructions () : Vector.<IPerformanceInstruction>;
		
		/**
		 * Container to hold the scores obtained by this music unit in regard to various analysis criteria.
		 * The container itself is readonly, but its content can be freely set. 
		 */
		function get analysisScores () : IAnalysisScores;
		
		/**
		 * Returns a new IMusicUnit instance with identical properties to the current one. This will be a SHALLOW
		 * CLONE (all non-primitive properties and Vector elements will be passed by reference rather than recreated).
		 */
		function clone() : IMusicUnit;
		
	}
}