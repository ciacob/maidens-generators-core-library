package ro.ciacob.maidens.generators.core.interfaces {
	import flash.display.DisplayObject;
	
	public interface IParameter {
		
		/**
		 * Internally or externally defined ID that globally identifies this parameter instance.
		 */
		function get uid () : String;
		function set uid (value : String) : void;
		
		/**
		 * This parameter's data type. Acceptable type constants are:
		 * - Constants.TYPE_INT;
		 * - Constants.TYPE_UINT;
		 * - Constants.TYPE_NUMBER;
		 * - Constants.TYPE_BOOLEAN;
		 * - Constants.TYPE_STRING;
		 * - Constants.TYPE_OBJECT;
		 * - Constants.TYPE_ARRAY;
		 */
		function get type () : uint;
		function set type (value : uint) : void;
		
		/**
		 * The name of this parameter; parameter names should be locally unique, i.e., no two
		 * parameters by the same name should exist in any given generator module.
		 */
		function get name () : String;
		function set name (value : String) : void;
		
		/**
		 * The value or values for this parameter, depending on its `type`.
		 */
		function get payload () : Object;
		function set payload (value : Object) : void;
		
		/**
		 * Only applicable if this parameter's `type` is Constants.TYPE_INT or Constants.TYPE_UINT.
		 * 
		 * Parameters having the type `Constants.TYPE_NUMBER` are assumed to express percents, so they
		 * have an implicit minimum value (`0`).
		 * 
		 * Parameters having the type `Constants.TYPE_ARRAY` are assumed to contain unsigned integers with
		 * values ranging from `1` to `100`.
		 * 
		 * The minimum numeric value this parameter is allowed to take.
		 */
		function get minValue () : Object;
		function set minValue (value : Object) : void;
		
		/**
		 * Only applicable if this parameter's `type` is Constants.TYPE_INT or Constants.TYPE_UINT.
		 * 
		 * Parameters having the type `Constants.TYPE_NUMBER` are assumed to express percents, so they
		 * have an implicit maximum value (`1`).
		 * 
		 * Parameters having the type `Constants.TYPE_ARRAY` are assumed to contain unsigned integers with
		 * values ranging from `1` to `100`.
		 * 
		 * The maximum numeric value this parameter is allowed to take.
		 */
		function get maxValue () : Object;
		function set maxValue (value : Object) : void;
		
		/**
		 * Whether this parameter accepts multiple values, so that it can be "animated" or
		 * "tweened" as generation progresses. For instance, a "tweenable" parameter called
		 * `consonance` could be used for producing generated music that "morphs" or gradually
		 * evolves from "consonant" to "disonant".
		 */
		function get isTweenable () : Boolean;
		function set isTweenable  (value : Boolean) : void;
		
		/**
		 * Whether this parameter can be bypassed during the generation process. Usually, core
		 * parameters are expected not to be optional, whereas generator specific parameters
		 * could, in theory, all be optional.
		 */
		function get isOptional () : Boolean;
		function set isOptional (value : Boolean) : void;

		/**
		 * Whether this parameter only has meaning in a musical context, i.e., it does not point to an intrinsic
		 * musical feature, such as pitch.
		 */
		function get isContextual () : Boolean;
		function set isContextual (value : Boolean) : void;
		
		/**
		 * A short description (max. 256 chars) of this parameter's role in the generation process.
		 * It is expected that the user interface providing a control for the parameter also provide
		 * a mean to display this description, in place.
		 */
		function get description () : String;
		function set description (value : String) : void;
		
		/**
		 * An URI segment pointing to a dedicated documentation page for this parameter. 
		 * It is expected that it opens in a dedicated UI, such as the system's default browser. 
		 */
		function get documentationUrl () : String;
		function set documentationUrl (value : String) : void;
		
		/**
		 * A color code to be associated with this parameter. Useful in the event that the user
		 * interface providing a control for the parameter also employs color coding.
		 */
		function get color () : uint;
		function set color (value : uint) : void;
		
		/**
		 * A class representing a graphical asset to be associated with this parameter. Useful
		 * for seggregation and aesthetic purposes, if the interface providing a control for
		 * the parameter also has a place for displaying an image.
		 */
		function get icon () : DisplayObject;
		function set icon (value : DisplayObject) : void;
	}
}