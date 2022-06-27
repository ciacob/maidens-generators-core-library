package eu.claudius.iacob.music.knowledge.harmony {
import ro.ciacob.maidens.generators.constants.pitch.IntervalsSize;

/**
 * Groups musical knowledge related to harmonic intervals.
 */
public final class Intervals {

    /*
     Internal reference of Hindemith's "2nd series", or harmonic intervals'
     "significance" order.
      */
    private static const _hindemith2ndSeries:Array = [
        IntervalsSize.PERFECT_FIFTH,
        IntervalsSize.PERFECT_FOURTH,
        IntervalsSize.MAJOR_THIRD,
        IntervalsSize.MINOR_SIXTH,
        IntervalsSize.MINOR_THIRD,
        IntervalsSize.MAJOR_SIXTH,
        IntervalsSize.MAJOR_SECOND,
        IntervalsSize.MINOR_SEVENTH,
        IntervalsSize.MINOR_SECOND,
        IntervalsSize.MAJOR_SEVENTH,
        IntervalsSize.AUGMENTED_FOURTH
    ];

    public function Intervals() {
    }

    /**
     * Returns a (red-only) copy of an ordered Array that reflects Hindemith's view on
     * harmonic intervals' "significance". The intervals are here represented by their
     * number of semitones, e.g., "5" is the "perfect fourth".
     * @return
     */
    public static function getHindemiths2ndSeries():Array {
        return _hindemith2ndSeries.concat();
    }

    /**
     * Returns Hindemiths "root" of a given harmonic interval, based on its size in
     * semitones. Returns one of the constants in class IntervalRootPositions.
     */
    public static function getHindemithsIntervalRoot(intervalSize:uint):int {
        intervalSize = (intervalSize % IntervalsSize.PERFECT_OCTAVE);
        switch (intervalSize) {
            case IntervalsSize.PERFECT_FIFTH:
                return IntervalRootPositions.BOTTOM;
            case IntervalsSize.PERFECT_FOURTH:
                return IntervalRootPositions.TOP;
            case IntervalsSize.MAJOR_THIRD:
                return IntervalRootPositions.BOTTOM;
            case IntervalsSize.MINOR_SIXTH:
                return IntervalRootPositions.TOP;
            case IntervalsSize.MINOR_THIRD:
                return IntervalRootPositions.BOTTOM;
            case IntervalsSize.MAJOR_SIXTH:
                return IntervalRootPositions.TOP;
            case IntervalsSize.MAJOR_SECOND:
                return IntervalRootPositions.TOP;
            case IntervalsSize.MINOR_SEVENTH:
                return IntervalRootPositions.BOTTOM;
            case IntervalsSize.MINOR_SECOND:
                return IntervalRootPositions.TOP;
            case IntervalsSize.MAJOR_SEVENTH:
                return IntervalRootPositions.BOTTOM;
            default:
                return IntervalRootPositions.UNKNOWN;
        }
    }

    /**
     * Convenience method to be used with Array.sort(). Expects its arguments to represent simple
     * (i.e., not "compound") intervals, and be Objects that contain (1) a "size" property, which
     * refers to the interval's number of semitones (e.g., "5" would denote a perfect fourth); and
     * (2) a "low" property, which represents the "bass" MIDI pitch of the interval.
     *
     * The intervals are first sorted by "significance", i.e., perfect fifths first, and then by
     * base pitch, e.g., should two perfect fifths be found in the same chord, the lowest of them
     * would be listed first.
     *
     * @see Array.sort
     */
    public static function orderByHindemith2ndSeries(intervalA:Object, intervalB:Object):int {
        var significanceDelta:int = 0;
        if (intervalA.size != intervalB.size) {
            significanceDelta = (_hindemith2ndSeries.indexOf(intervalA.size) - _hindemith2ndSeries.indexOf(intervalB.size));
        }
        return (significanceDelta || (intervalA.low - intervalB.low));
    }

    /**
     * Returns the intrinsic consonance score for a given `simple` harmonic interval
     * (an interval which is smaller than an octave).
     *
     * @param    interval
     *            A simple harmonic interval (i.e., an interval containing less than
     *            or equal to 12 semitones) to obtain a consonance score of.
     *
     * @return    The associated score, or `0` if the interval is compound (has 12
     *            or more semitones).
     */
    public static function getConsonance(interval:int):int {
        switch (interval) {
            case  7:
                return 5; // 5p
            case  4:
                return 4; // 3M
            case  3:
                return 3; // 3m
            case  9:
                return 2; // 6M
            case  8:
                return 1; // 6m
            case  6:
                return -1; // 4+
            case 10:
                return -2; // 7m
            case  2:
                return -3; // 2M
            case 11:
                return -4; // 7M
            case  1:
                return -5; // 2m

                // `1p`, `4p` and `8p` and are neither consonant nor dissonant "per se"
            case  0:
            case  5:
            case 12:
                return 0;
        }
        return 0;
    }

    /**
     * Returns the decay, or attenuation factor for compound intervals. This
     * attenuation is proportional to the number of octaves added to a simple
     * interval, and brings it closer to harmonical neutrality with each octave
     * added.
     *
     * @param    octavesAdded
     *            The number of octaves to be added to a simple interval to make
     *            it a compound interval.
     *
     * @return    The attenuation that will result from this operation, as a factor
     *            from the interval's intrinsic consonance score.
     */
    public static function decayFactor(octavesAdded:int):Number {
        switch (octavesAdded) {
            case 0:
                return 1;
            case 1:
                return 0.8;
            case 2:
                return 0.4;
            case 3:
                return 0.1;
            case 4:
                return 0;
        }
        return 0;
    }
}
}