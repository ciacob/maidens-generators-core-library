package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	 * Entity that provides refining mechanisms for generated musical bodies (IMusicalBody) instances. 
	 */
	public interface IMusicalPostProcessor {
		
		/**
		 * Globally unique, readonly identifier to represent this post-processor.
		 */
		function get uid () : String;

		/**
		 * Operates discretionary changes on the provided IMusicalBody instance.
		 * Changes are performed DIRECTLY on the instance and are PERMANENT.
		 * 
		 * @param	rawMusicalBody
		 * 			The IMusicalBody instance to alter. Each IMusicalPostProcessor
		 * 			instance will define and implement its own filtering and
		 * 			altering techniques; they are not standardized.
		 * 
		 * @param	request
		 * 			The musical request the parent generator has been invoked with.
		 * 			IT contains essential bits of information, such as the values 
		 * 			user provided for each parameter.
		 */
		function execute (rawMusicalBody : IMusicalBody, request : IMusicRequest) : void;
	}
}