package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	 * Blueprint for an entity that is able to provide music rudiments to use as
	 * foundation for musical generation. For example, in a harmonic generator,
	 * an IMusicalPrimitiveSource instance could be used to produce a number of
	 * random chords; they would be evaluated and filtered by higher-level
	 * entities, in later stages of the process.
	 */
	public interface IRawMusicSource {
		
		/**
		 * Actually produces and returns one or more music rudiments.
		 * 
		 * @param	targetMusicUnit
		 * 			The IMusicUnit instance that is currently being altered – in case needed.
		 * 
		 * @param	analysisContext
		 * 			An IAnalysisContext instance, containing relevant context information,
		 * 			such as the latest "n" IMusicUnit instances – in case needed.
		 * @param	parameters
		 * 			The parameters list, as defined by the generator which uses
		 * 			this IMusicalPrimitiveSource instance – in case needed.
		 * 
		 * @param	request
		 * 			The musical request the generator has been invoked with – in case needed.
		 */
		function output (targetMusicUnit:IMusicUnit, analysisContext:IAnalysisContext,
						 parameters : IParametersList, request:IMusicRequest) : Vector.<IMusicUnit>;
		
		/**
		 * A globally unique value to identify this IMusicalPrimitiveSource
		 */
		function get uid () : String;
		
		/**
		 * Discards any cached computed parameter values, if any, causing a new computation
		 * round to take place.
		 */
		function reset () : void;
		
	}
}