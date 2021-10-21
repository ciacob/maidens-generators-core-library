package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	   Generic implementation for a MAIDENS music generator module base class.
	   @author Claudius Iacob
	 */
	public interface IGeneratorModule {
		
		/**
		 * Begins the generation process. The process is asynchronous.
		 * @param	request
		 * 			An IMusicRequest instance to describe the music that needs to be created
		 */
		function generate(request:IMusicRequest):void;

		/**
		 * Stops the in-progress generation and discards any (raw) music already created
		 */
		function abort():void;
		
		/**
		 * A Function to receive status information. Required, since generation is an asynchronous
		 * process. It will receive an Object with content resembling to:
		 * 
		 * 		{
		 * 			"state" : "in progress" | "aborted" | "completed" | "error",
		 * 			"percentComplete" : Number (progresses in 0.01 increments),
		 * 			"error" : String (error description or null),
		 * 			"data": Object (general purpose field, may or may be not used based on implementation)
		 * 		}
		 * 
		 * Any change in at least one of the above depicted fields shall trigger a function call.
		 */
		function set callback(value : Function):void;
		
		/**
		 * Retrieves the last music generated. The last result of the generation process
		 * can be acessed from the module instance for as long as it is alive.
		 */
		function get lastResult():IMusicalBody
			
		/**
		 * Returns the readonly, externally defined unique ID that points to this module. Each generator
		 * module implementation must override this method to return a globally unique, descriptive String.
		 * The base class implementation should throw an "unimplemented" error.
		 */
		function get moduleUid():String;
		
		/**
		 * Returns the readonly, internally defined unique GUID that was automatically assigned to this
		 * instance upon creation. 
		 */
		function get instanceUid():String;
		
		/**
		 * Returns readonly information about this module. the default implementation will return an
		 * Object with the moduleUid, e.g.: { moduleUid : <<return value of method get moduleUid()>>}.
		 * 
		 * Subclasses may override this method to add their own keys, e.g.:
		 * 
		 * 		override public function get info() : Object {
		 *		 		var data : Object = super.info;
		 *		 		data.myKey = "myValue";
		 *		 		return data;
		 *		 }
		 * 
		 * The structure of the Object to be returned is not standardized.
		 */
		function get info():Object;
		
		/**
		 * Returns structured information about all the Parameters available for this module. Each generator
		 * module implementation must override this method to return a non-empty IParametersLis instance.
		 * The base class implementation should throw an "unimplemented" error.
		 * @see IParametersList
		 */
		function get parametersList() : IParametersList;
		
		/**
		 * Returns information about all the Musical Traits that define this module.  Each generator
		 * module implementation must override this method to return a non-empty list of IMusicalTrait
		 * instances. The base class implementation should throw an "unimplemented" error.
		 * @see IMusicalTrait
		 */
		function get musicalTraits () : Vector.<IMusicalTrait>;
	}

}