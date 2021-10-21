package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	 * Factory to be sent to each class via dependency injection (as an interface-typed constructor parameter).
	 * We try to achieve lowest possible coupling to aid with testing each class in isolation.
	 * @author Claudius Iacob
	 */
	public interface IClassFactory {
		
		/**
		 * Returns an instance matching the given Interface type, optionally configuring it using provided
		 * configuration Object.
		 * 
		 * @param	Interface
		 * 			A Class Object pointing to an Interface the returned instance must be an implementor of.
		 * 			The actual implementation must setup one to one relationships between different interfaces
		 * 			and their concrete implementors.
		 * 
		 * @param	configuration
		 * 			An optional Object containing parameters to configure the newly created instance with.
		 * 
		 * @param	recycleWhenAvailable
		 * 			An optional flag to tell the implementor to use existing matching instances that were
		 * 			previously readied for recycling
		 */
		function getInstanceOf (Interface : Class, configuration : Object = null, recycleWhenAvailable : Boolean = true) : Object;
	}
}