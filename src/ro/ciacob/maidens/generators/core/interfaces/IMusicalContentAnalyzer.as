package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	 * Analyzes the given IMusicUnit instance and gives it a score that is specific
	 * to a particular analysis criteria, e.g., the harmonic consonance. Parameter
	 * values and/or previous IMusicUnit instances are available in case contextual
	 * analysis is to be conducted.
	 */
	public interface IMusicalContentAnalyzer {
		

		/**
		 * Conducts the analysis and stores the resulting score inside the given
		 * IMusicUnit instance. No value is returned.
		 */
		function analyze (targetMusicUnit:IMusicUnit, analysisContext:IAnalysisContext,
						  parameters : IParametersList, request:IMusicRequest) : void;

		/**
		 * A globally unique value to identify this IMusicalContentAnalyzer
		 */
		function get uid () : String;

		/**
		 * An intrinsic weight, or importance, of this Analyzer. Ideally, all parties
		 * operating this Analyzer will take into account this weight to make the Analyzer's
		 * influence more or less salient. Weight must be a number between 0 and 1, both
		 * ends included.
		 */
		function get weight () : Number;

		/**
		 * A human-friendly String that identifies this IMusicalContentAnalyzer. It is
		 * preferable that names be unique.
		 */
		function get name () : String;

		/**
		 * The client code operating this Analyzer is assumed to use this field to store the
		 * current acceptable threshold for scores calculated by the method "analyze()".
		 * It is expected that the client code uses this value to make decisions whether a
		 * certain calculated score is to be deemed "acceptable" or not.
		 */
		function get threshold () : Number;
		function set threshold (value : Number) : void;
	}
}