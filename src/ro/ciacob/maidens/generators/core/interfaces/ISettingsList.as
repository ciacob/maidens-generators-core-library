package ro.ciacob.maidens.generators.core.interfaces {
	
	/**
	 * Dedicated container to store and retrieve `parameter–time–value` triplets.
	 * @author Claudius Iacob
	 */
	public interface ISettingsList {
		
		/**
		 * Stores a given value in relation to a given IParameter instance and a given
		 * point in time (expressed as a percent of the available musical time the generation
		 * process has to "fill"). If two calls to `setValueAt` use the same `percentTime`,
		 * the later overwrites the former.
		 * 
		 * @param	parameter
		 * 			Related IParameter instance (the parameter the value refers to).
		 * 
		 * @param	percentTime
		 * 			A point in time (as an unsigned integer between `0` and `100` inclusive)
		 * 			refering to the available musical duration the generation process has to
		 * 			"fill". For instance, `50` would point to the start of the third measure
		 * 			in a four measures long fragment.
		 * 
		 * @param	value
		 * 			The value to record. Its exact type is dependent on the related IParameter
		 * 			instance. 
		 */
		function setValueAt (parameter : IParameter, percentTime : uint, value : Object) : void;
		
		/**
		 * Retrieves a given value in relation to a given IParameter instance and a given
		 * point in time. If no value was ever recorded for that specific point in time,
		 * based on the `isTweenable` setting of the related IParameter instance, a new value
		 * shall be calculated using linear interpolation (`isTweenable=true`) or the most
		 * recent value shall be used (`isTweenable=false`). If no value was ever recorded
		 * for that specific IParameter, `null` shall be returned.
		 * 
		 * @param	parameter
		 * 			Related IParameter instance (the parameter the value refers to).
		 * 
		 * @param	percentTime
		 * 			A point in time (as an unsigned integer between `0` and `100` inclusive)
		 * 			of the available musical duration the generation process has to "fill".
		 * 			For instance, `50` would point to the start of the third measure in a four
		 * 			measures long fragment.
		 * 
		 * @return	A matching, possibly interpolated value. Its exact type is dependent on the
		 * 			related IParameter instance. 
		 */
		function getValueAt (parameter : IParameter, percentTime : uint) : Object;
	}
}