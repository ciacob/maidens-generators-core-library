package ro.ciacob.maidens.generators.core {
	import flash.display.DisplayObject;
	
	import ro.ciacob.maidens.generators.core.interfaces.IParameter;
	import ro.ciacob.utils.Strings;
	
	public final class Parameter implements IParameter {
		public function Parameter() {
			_self = this;
		}
		
		private var _self : IParameter;
		private var _uid : String;
		private var _name : String;
		private var _description : String;
		private var _documentationUrl : String;
		private var _color : uint;
		private var _icon : DisplayObject;
		private var _type : uint;
		private var _value : Object;
		private var _minValue : Object;
		private var _maxValue : Object;
		private var _isTweenable : Boolean;
		private var _isOptional : Boolean;
		private var _isContextual : Boolean;
		
		/**
		 * @see IParameter.uid
		 */
		public function get uid():String {
			if (!_uid) {
				_uid = Strings.generateRFC4122GUID();
			}
			return _uid;
		}
		public function set uid(value : String) : void {
			_uid = value;
		}

		/**
		 * @see IParameter.type
		 */
		public function get type():uint {
			return _type;
		}
		public function set type(value:uint):void {
			_type = value;
		}
		
		/**
		 * @see IParameter.name
		 */
		public function get name():String {
			return _name;
		}
		public function set name(value:String):void {
			_name = value;
		}
		
		/**
		 * @see IParameter.value
		 */
		public function get payload():Object {
			return _value;
		}
		public function set payload(val:Object):void {
			_value = val;
		}
		
		/**
		 * @see IParameter.isTweenable
		 */
		public function get isTweenable():Boolean {
			return _isTweenable;
		}
		public function set isTweenable(value:Boolean):void {
			_isTweenable = value;
		}

		/**
		 * @see IParameter.isOptional
		 */
		public function get isOptional() : Boolean {
			return _isOptional;
		}
		public function set isOptional (value : Boolean) : void {
			_isOptional = value;
		}

		/**
		 * @see IParameter.isContextual
		 */
		public function get isContextual() : Boolean {
			return _isContextual;
		}
		public function set isContextual(value : Boolean) : void {
			_isContextual = value;
		}

		/**
		 * @see IParameter.minValue
		 */
		public function get minValue() : Object {
			return _minValue;
		}
		public function set minValue (value : Object) : void {
			_minValue = value;
		}

		/**
		 * @see IParameter.maxValue
		 */
		public function get maxValue() : Object {
			return _maxValue;
		}
		public function set maxValue (value : Object) : void {
			_maxValue = value;
		}

		/**
		 * @see IParameter.description
		 */
		public function get description() : String {
			return _description;
		}
		public function set description (value : String) : void {
			_description = value;
		}

		/**
		 * @see IParameter.documentationUrl
		 */
		public function get documentationUrl() : String {
			return _documentationUrl;
		}
		public function set documentationUrl (value : String) : void {
			_documentationUrl = value;
		}

		/**
		 * @see IParameter.color
		 */
		public function get color() : uint {
			return _color;
		}
		public function set color (value : uint) : void {
			_color = value;
		}

		/**
		 * @see IParameter.icon
		 */
		public function get icon() : DisplayObject {
			return _icon;
		}
		public function set icon (value : DisplayObject) : void {
			_icon = value;
		}
	}
}