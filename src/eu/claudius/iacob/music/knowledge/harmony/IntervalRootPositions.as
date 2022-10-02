package eu.claudius.iacob.music.knowledge.harmony {

/**
 * Stores convenience constants related to placement of the "root"
 * (in Hindemith's definition) within a harmonic interval. Three placements are
 * available, TOP (integer 1), BOTTOM (integer 0) or UNKNOWN (integer -1),
 * the last actually being reserved for the tritone alone.
 */
public class IntervalRootPositions {
    public function IntervalRootPositions() {
    }

    public static const TOP:int = 1;
    public static const BOTTOM:int = 0;
    public static const UNKNOWN:int = -1;
}
}
