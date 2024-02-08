package ro.ciacob.maidens.generators.core.helpers {
import eu.claudius.iacob.music.knowledge.instruments.interfaces.IMusicalInstrument;

import ro.ciacob.maidens.generators.constants.pitch.IntervalsSize;
import ro.ciacob.maidens.generators.core.MusicPitch;
import ro.ciacob.maidens.generators.core.MusicUnit;
import ro.ciacob.maidens.generators.core.interfaces.IMusicPitch;
import ro.ciacob.maidens.generators.core.interfaces.IMusicUnit;
import ro.ciacob.utils.Arrays;

/**
 * This class is a portmanteau of public static methods that perform helpful operations against various musical
 * structures. Methods included in this class are agnostic to MAIDENS internal model data structure.
 */
public class CommonMusicUtils {

    public static const TRIADS_WITH_ROOT_IN_BASS_SCORE:Number = 100;
    public static const TRIADS_WITH_ROOT_UPPER_SCORE:Number = 90;
    public static const ADDED_NOTES_CHORDS_ROOT_IN_BASS_SCORE:Number = 80;
    public static const ADDED_NOTES_CHORDS_ROOT_UPPER_SCORE:Number = 70;
    public static const AUGMENTED_OR_QUARTAL_SCORE:Number = 60;
    public static const DIMINISHED_SCORE:Number = 55;
    public static const DOMINANT_TRIAD_SCORE:Number = 50;
    public static const DOMINANT_INVERSIONS_ROOT_IN_BASS_SCORE:Number = 40;
    public static const DOMINANT_INVERSIONS_ROOT_UPPER_SCORE:Number = 30;
    public static const DOMINANT_NINTH_SCORE:Number = 20;
    public static const CLUSTERS_ROOT_IN_BASS_SCORE:Number = 10;
    public static const CLUSTERS_ROOT_UPPER_SCORE:Number = 1;

    public static const ALL_INTERVALS_REGISTRY : String = 'allIntervalsRegistry';
    public static const SIMPLE_INTERVALS : String = 'simpleIntervals';
    public static const ADJACENT_INTERVALS : String = 'adjacentIntervals';
    public static const LOWEST_PITCH_IN_CHORD : String = 'lowestPitchInChord';
    public static const PITCHES : String = 'pitches';
    public static const NUM_PITCHES : String = 'numPitches';

    private static var _allIntervalsCache:Array = [];

    public function CommonMusicUtils() {
    }

    /**
     * Returns a shallow clone of the given instruments collection, where each instrument has been
     * ordered by its middle/center pitch (the pitch roughly found at the middle of its range). Also sorts the
     * instances of the same instrument by their ordinal index (so that "Violin 1" is reported to be "before"
     * "Violin 2".
     */
    public static function cloneAndReorderInstruments(
            instruments:Vector.<IMusicalInstrument>):Vector.<IMusicalInstrument> {
        var clone:Vector.<IMusicalInstrument> = instruments.concat();
        clone.sort(_compareInstruments);
        return clone;
    }

    /**
     * Scrutinizes given `chord`, and returns details about its harmonic structure.
     *
     * @param   chord
     *          An `IMusicUnit` implementor instance that describes a chord.
     *
     * @param   withRegistry
     *          Optional, default true. Whether to also compute and return ALL_INTERVALS_REGISTRY information, as
     *          doing so is somewhat expensive.
     *
     * @return  An Object with keys named by these constants:
     *          - CommonMusicUtils.ALL_INTERVALS_REGISTRY: Vector.<IntervalRegistryEntry>, contains detailed information
     *              about every interval in the chord. See IntervalRegistryEntry class for details.
     *
     *          - CommonMusicUtils.SIMPLE_INTERVALS: Vector.<int>, contains the number of semitones for every "simple"
     *            (i.e., "not composed", "2nd" instead of "9th") interval in the chord. Each chord note is paired to
     *            each other in order to produce this list.
     *
     *          - CommonMusicUtils.ADJACENT_INTERVALS: Vector.<int>, contains the number of semitones for every adjacent,
     *            interval in the chord. Only neighbour chord notes are used to produce this list.
     *
     *          - CommonMusicUtils.LOWEST_PITCH_IN_CHORD: int, the bass of the chord, as a MIDI value.
     *
     *          - CommonMusicUtils.PITCHES: Vector.<IMusicPitch>, contains detailed information about every pitch in the
     *            chord. See IMusicPitch for details.
     *
     *          - CommonMusicUtils.NUM_PITCHES: int, the number of distinct pitches the chord has.
     */
    public static function getChordDetails(chord:IMusicUnit, withRegistry : Boolean = true):Object {
        // Collect and sort all intervals found in the current chord (IMusicUnit instance)
        if (withRegistry) {
            var _allIntervalsRegistry:Vector.<IntervalRegistryEntry> = new Vector.<IntervalRegistryEntry>;
        }
        var _simpleIntervals:Vector.<int> = new Vector.<int>;
        var _adjacentIntervals:Vector.<int> = new Vector.<int>;
        var _lowestPitchInChord:int = int.MAX_VALUE;
        var _pitches:Vector.<IMusicPitch> = chord.pitches;
        var _numPitches:int = _pitches.length;
        var currentPitch:IMusicPitch;
        var currMidiNote:int;
        var remainderPitches:Vector.<IMusicPitch>;
        var numRemainderPitches:int;
        var otherPitch:IMusicPitch;
        var interval:int;
        var simpleInterval:int;
        var i:int;
        var j:int;
        for (i = 0; i < _numPitches; i++) {
            currentPitch = _pitches[i];
            currMidiNote = currentPitch.midiNote;
            if (currMidiNote < _lowestPitchInChord) {
                _lowestPitchInChord = currMidiNote;
            }
            remainderPitches = _pitches.slice(i + 1);
            numRemainderPitches = remainderPitches.length;
            for (j = 0; j < numRemainderPitches; j++) {
                otherPitch = remainderPitches[j];
                interval = Math.abs(currMidiNote - otherPitch.midiNote);
                simpleInterval = interval % IntervalsSize.PERFECT_OCTAVE;
                if (simpleInterval != 0) {
                    _simpleIntervals.push(simpleInterval);
                    if (withRegistry) {
                        _allIntervalsRegistry.push(new IntervalRegistryEntry(currMidiNote, simpleInterval));
                    }
                    if (j == 0) {
                        _adjacentIntervals.push(simpleInterval);
                    }
                }
            }
        }
        var out : Object = {};
        if (withRegistry) {
            out[ALL_INTERVALS_REGISTRY] = _allIntervalsRegistry;
        }
        out[SIMPLE_INTERVALS] = _simpleIntervals;
        out[ADJACENT_INTERVALS] = _adjacentIntervals;
        out[LOWEST_PITCH_IN_CHORD] = _lowestPitchInChord;
        out[PITCHES] = _pitches;
        out[NUM_PITCHES] = _numPitches;
        return out;
    }

    /**
     * Scrutinizes given `chord` and decides if it is acceptable by means of given `referenceConsonance`. Note that this
     * only performs a very basic validation, e.g., a chord that should be "100%" consonant should not contain any
     * seconds or tritones.
     *
     * @param   chord
     *          An `IMusicUnit` implementor instance that describes a chord.
     *
     * @param   referenceConsonance
     *          An uint within `0` and `100` describing a consonance setting the chord is to be evaluated by, where
     *          `100` means "fully consonant".
     *
     * @return
     */
    public static function isConsonanceAcceptable (chord:IMusicUnit, referenceConsonance : uint) : Boolean {
        clearIntervalsCache();
        var chordDetails : Object = getChordDetails(chord, false);
        return validateConsonanceScore(referenceConsonance, chordDetails[CommonMusicUtils.SIMPLE_INTERVALS]);
    }

    /**
     * Given a `pool` of possible pitches to choose from (an Array containing `int` elements), a `stub` of the chord
     * being build (a Vector of IMusicPitch elements containing notes that were already deemed appropriate in regard of
     * their pitch, and won't be touched) and a `score` describing the desired consonance (an `int`, with, e.g., `100`
     * denoting perfect triadic consonance) - given all that, finds and returns a MID pitch (an `int`) from the `pool`
     * that would not offend neither the existing chord stub, nor the expected consonance score.
     *
     * Building a chord one pitch at a time is overall more economical in terms of CPU that randomly gathering it, and
     * then deciding whether it is suitable or not.
     *
     * @param   pool
     *          Array of pitches (`int` values) to choose from.
     *
     * @param   stub
     *          Vector of IMusicPitch implementors that describe the part "already built" of the chord.
     *
     * @param   score
     *          The harmonical score the chord must produce when/if analyzed.
     *
     * @return  The MIDI pitch that would abide by all the conditions laid out before.
     *          NOTE: can return `0` if none of the notes in the pool were acceptable; `0` is actually a valid special
     *          value, as it will translate to a rest in the score (i.e., a "voice" that does not play/sing).
     */
    public static function findSuitablePitch (pool : Array, stub : Vector.<IMusicPitch>,
                                              score : uint) : int {

        if (stub.length == 0) {
            var midiPitch : int = (Arrays.getRandomItem(pool, true) as int);
            return midiPitch;
        }
        var highestInStub : int = stub[stub.length - 1].midiNote;
        while (pool.length > 0) {
            var pitchCandidate : int = (Arrays.getRandomItem(pool, true) as int);
            if (pitchCandidate <= highestInStub) {
                continue;
            }
            var intervalsToTest : Vector.<int> = new Vector.<int>;
            for (var j : int = 0; j < stub.length; j++) {
                var stubNote  : IMusicPitch = stub[j];
                var stubPitch : int = stubNote.midiNote;
                var simpleInterval : int = ((pitchCandidate - stubPitch) % 12);
                intervalsToTest.push (simpleInterval);
            }
            clearIntervalsCache();
            if (validateConsonanceScore(score, intervalsToTest)) {
                return pitchCandidate;
            } else {
                // Used for debugging.
            }
        }
        return 0;
    }

    /**
     * Counts and returns the number of occurrences of a given integer value within a given set.
     *
     * @param    $int
     *            The numeric (integer) value to look for.
     *
     * @param    $arr
     *            The set to look into.
     *
     * @param    $cache
     *            Optional. An Array to store counted occurrences in, so that recounting them on each
     *            function invocation is not needed.
     */
    public static function countIntOccurrences($int:int, $arr:Vector.<int>, $cache:Array = null):int {
        var counter:Array = $cache || [];
        if (counter.length == 0) {
            for (var i:int = 0; i < $arr.length; i++) {
                var interval:int = $arr[i];
                if (counter[interval] === undefined) {
                    counter[interval] = 0;
                }
                counter[interval]++;
            }
        }
        return counter[$int] || 0;
    }

    /**
     * Resets the internal cache used by "countIntOccurrences()".
     */
    public static function clearIntervalsCache () : void {
        _allIntervalsCache.length = 0;
    }

    /**
     * Returns `true` if given intervals set contains at least one tritone.
     */
    public static function hasAnyTritone(intervals:Vector.<int>):Boolean {
        var answer:Boolean = (countIntOccurrences(IntervalsSize.AUGMENTED_FOURTH, intervals, _allIntervalsCache) > 0);
        return answer;
    }

    /**
     * Returns `true` if given intervals set contains at least two tritones.
     */
    public static function hasMultipleTritones(intervals:Vector.<int>):Boolean {
        var answer:Boolean = (countIntOccurrences(IntervalsSize.AUGMENTED_FOURTH, intervals, _allIntervalsCache) >= 2);
        return answer;
    }

    /**
     * Returns `true` if given intervals set contains a minor second.
     */
    public static function hasAnyMinorSecond (intervals:Vector.<int>):Boolean {
        var answer:Boolean = (countIntOccurrences(IntervalsSize.MINOR_SECOND, intervals, _allIntervalsCache) > 0);
        return answer;
    }

    public static function hasAnyMajorSecond (intervals:Vector.<int>):Boolean {
        var answer:Boolean = (countIntOccurrences(IntervalsSize.MAJOR_SECOND, intervals, _allIntervalsCache) > 0);
        return answer;
    }

    /**
     * Returns `true` if given intervals set contains a minor seventh.
     */
    public static function hasAnyMinorSeventh(intervals:Vector.<int>):Boolean {
        var answer:Boolean = (countIntOccurrences(IntervalsSize.MINOR_SEVENTH, intervals, _allIntervalsCache) > 0);
        return answer;
    }

    /**
     * Returns `true` if given intervals set contains a major seventh.
     */
    public static function hasAnyMajorSeventh(intervals:Vector.<int>):Boolean {
        var answer:Boolean = (countIntOccurrences(IntervalsSize.MAJOR_SEVENTH, intervals, _allIntervalsCache) > 0);
        return answer;
    }


    /**
     * By convention any pitch of `0` reported in a chord is a rest (if a specific voice does not play in a chord, we
     * represent it by the MIDI value of `0`, which we sacrificed based on the fact that is is too low to be of real
     * use anyway).
     *
     * This method returns a copy of the received `rawPitches` Vector of IMusicPitch implementors, with all `0`s removed.
     * In other words, if this receives a chord of [0,67,72,79], i.e., the Bass voice not playing, it will return a
     * chord of merely [67,72,79], i.e., a chord of only three voices, and with the MIDI `67` being the new Bass voice.
     */
    public static function getRealPitches(rawPitches:Vector.<IMusicPitch>):Vector.<IMusicPitch> {
        var filteredPitches : Vector.<IMusicPitch> = new Vector.<IMusicPitch>;
        var numPitches:int = rawPitches.length;
        for (var i:int = 0; i < numPitches; i++) {
            var currentPitch:IMusicPitch = rawPitches[i];
            var currMidiNote:int = currentPitch.midiNote;
            if (currMidiNote != 0) {
                filteredPitches.push(currentPitch);
            }
        }
        return filteredPitches;
    }

    /**
     * Makes a clone of given `musicUnit`, whith given `withPitches` replacing the original ones. The original is left
     * untouched.
     * @param   musicUnit
     *          A music unit to clone with changed pitched.
     *
     * @param   withPitches
     *          Pitches to be used for replacing the original ones, in the clone.
     *
     * @return  The clone with substituted pitches.
     */
    public static function substitutePitchesOf (musicUnit : IMusicUnit, withPitches : Vector.<IMusicPitch>) : IMusicUnit {
        var newMusicUnit : IMusicUnit = musicUnit.clone();
        var newPitches : Vector.<IMusicPitch> = newMusicUnit.pitches;
        newPitches.length = 0;
        var i : uint = 0;
        var pitch : IMusicPitch;
        var numPitches : uint = withPitches.length;
        for (i; i < numPitches; i++) {
            pitch = withPitches[i];
            newPitches.push (pitch);
        }
        return newMusicUnit;
    }

    /**
     *         // Effectively remove non-pitch IMusicPitch instances from all IMusicUnits to be found in the `previousContent`
     *         // stored inside the received `analysisContext`. Also trims the content, the way that leading and trailing empty
     *         // IMusicUnits get removed.
     * @param analysisContext
     */
    public static function cleanupContent (content : Vector.<IMusicUnit>, trim : Boolean) : Vector.<IMusicUnit> {
        // TODO: iplement
        return content;
    }


    /**
     * Performs biased, binary, raw validation of given `intervals` set based on given consonance `score`. Essentially,
     * given intervals must construct a chord that is at least as "good" (aka, consonant) as the score that it is
     * validated against. This gives consonant chords an advantage over dissonant chords (because very consonant chords
     * will, thus, validate against virtually any score) in order to counterbalance a natural tendency of the program
     * of picking dissonant chords.
     *
     * @param   score
     *          The consonance score to account for, as an uint between `0` (fully dissonant) and `100` (fully
     *          consonant).
     *
     * @param   intervals
     *          Intervals to check for incompatible values as a set of integers depicting all simple intervals present
     *          in the chord.
     *
     * @return  Boolean `true` if raw check pass (e.g., there are no `6`, aka tritone values in given `intervals` when
     *          consonance `score` is above `90`), `false` otherwise.
     */
    public static function validateConsonanceScore (score : uint, intervals:Vector.<int>) : Boolean {

        // We skip checking the specific score range that deals with diminished, augmented or
        // quartal chords.
        if (score >= DIMINISHED_SCORE && score <= AUGMENTED_OR_QUARTAL_SCORE) {
            return true;
        }

        var hasMinorSeconds : Boolean = hasAnyMinorSecond(intervals);
        var hasMajorSeconds : Boolean = hasAnyMajorSecond(intervals);
        var hasAnySeconds : Boolean = (hasMinorSeconds || hasMajorSeconds);
        var hasMinorSevenths : Boolean = hasAnyMinorSeventh(intervals);
        var hasMajorSevenths : Boolean = hasAnyMajorSeventh(intervals);
        var hasAnySevenths : Boolean = (hasMinorSevenths || hasMajorSevenths);
        var hasAnyTritones : Boolean = hasAnyTritone(intervals);
        var hasSeveralTritones : Boolean = hasMultipleTritones (intervals);

        // Triads must not have seconds, sevenths or tritones.
        if (score >= TRIADS_WITH_ROOT_UPPER_SCORE) {
            if (hasAnySeconds || hasAnySevenths || hasAnyTritones) {
                return false;
            }
            return true;
        }

        // "Added-note" chords must not have tritones.
        if (score >= CommonMusicUtils.ADDED_NOTES_CHORDS_ROOT_UPPER_SCORE) {
            if (hasAnyTritones) {
                return false;
            }
            return true;
        }

        // Dominant chord in root position must not have seconds or multiple tritones.
        if (score >= CommonMusicUtils.DOMINANT_TRIAD_SCORE) {
            if (hasAnySeconds || hasSeveralTritones) {
                return false;
            }
            return true;
        }

        // Dominant chord inversions must not have multiple tritones, minor seconds or
        // major sevenths.
        if (score >= CommonMusicUtils.DOMINANT_INVERSIONS_ROOT_UPPER_SCORE) {
            if (hasMinorSeconds || hasMajorSevenths || hasSeveralTritones) {
                return false;
            }
            return true;
        }

        // Dominant ninths must not have minor seconds or major sevenths.
        if (score >= CommonMusicUtils.DOMINANT_NINTH_SCORE) {
            if (hasMinorSeconds || hasMajorSevenths) {
                return false;
            }
            return true;
        }

        // If down here, we have clusters, whom we do not forbid any interval.
        return true;
    }

    public static function midiPitchesToMusicUnit(pitches:Array):IMusicUnit {
        var unit:IMusicUnit = new MusicUnit();
        var tmpPitches:Vector.<IMusicPitch> = unit.pitches;
        pitches.forEach(function forEachMidiNote (midiNote:int, ...etc):void {
            var pitch:IMusicPitch = new MusicPitch();
            pitch.midiNote = midiNote;
            tmpPitches.push(pitch);
        });
        return unit;
    }

    /**
     * Sorting function to be used by `cloneAndReorderInstruments()`.
     */
    private static function _compareInstruments(
            instrumentA:IMusicalInstrument, instrumentB:IMusicalInstrument):int {
        var aLow:int = instrumentA.idealHarmonicRange[0];
        var aHigh:int = instrumentA.idealHarmonicRange[1];
        var bLow:int = instrumentB.idealHarmonicRange[0];
        var bHigh:int = instrumentB.idealHarmonicRange[1];
        var aMidPitch:int = aLow + Math.round((aHigh - aLow) * 0.5);
        var bMidPitch:int = bLow + Math.round((bHigh - bLow) * 0.5);
        var score:int = (bMidPitch - aMidPitch);
        if (score == 0 && (instrumentA.internalName == instrumentB.internalName)) {
            score = (instrumentA.ordinalIndex - instrumentB.ordinalIndex);
        }
        return score;
    }
}
}
