package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	 * Entity that binds together INFORMATION and LOGIC that are only relevant to a
	 * particular music aspect (and, most likely, to a particular generator).
	 * A set of MUSICAL TRAITS, together with a set of PARAMETERS essentially define a
	 * generator, because they encapsulate that generator's entire specificity.
	 */
	public interface IMusicalTrait {
		
		/**
		 * A list of IMusicalPostProcessor instances to be run against generated material 
		 * once raw generation is complete. Their purpose is to refine the generated material
		 */
		function get musicalPostProcessors () : Vector.<IMusicalPostProcessor>;
		
		/**
		 * The main routine of this IMusicalTrait instance. It affects the generated
		 * musical material by setting, changing or deleting one or more of the given
		 * IMusicUnit instance' property.
		 * 
		 * @param	targetMusicUnit
		 * 			The IMusicUnit instance whose properties are to be altered.
		 * 
		 * @param	analysisContext
		 * 			An IAnalysisContext instance, containing relevant context information,
		 * 			such as the latest "n" IMusicUnit instances. The routine can use this
		 * 			information to compute values for those IMusicUnit properties that are
		 * 			dependent on musical context.
		 * 
		 * @param	parameters
		 * 			The parameters list, as defined by the generator which owns
		 * 			this IMusicalTrait instance.
		 * 
		 * @param	request
		 * 			The musical request the generator has been invoked with.
		 * 			It contains essential bits of information, such as the values 
		 * 			user provided for each parameter.
		 * 
		 * @param	sources
		 * 			A (possibly empty) map of IMusicalPrimitiveSource instances that can
		 * 			be of help during execution.
		 */
		function execute (targetMusicUnit : IMusicUnit,
						  analysisContext:IAnalysisContext,
						  parameters: IParametersList,
						  request: IMusicRequest) : void;
	}
}