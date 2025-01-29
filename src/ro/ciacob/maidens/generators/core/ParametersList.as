package ro.ciacob.maidens.generators.core {
	import ro.ciacob.maidens.generators.core.interfaces.IParameter;
	import ro.ciacob.maidens.generators.core.interfaces.IParametersList;

	/**
	 * Dedicated container to store named "Parameter" instances.
	 * @author Claudius Iacob
	 */
	public class ParametersList implements IParametersList {

		private static const NAME : String = 'name';
		private static const UID : String = 'uid';
		
		private var _parameters : Vector.<IParameter> = Vector.<IParameter>([]);
		private var _self : IParametersList;
		
		/**
		 * @constructor
		 * @see IParametersList
		 */
		public function ParametersList() {
			_self = this;
		}
		
		/**
		 * Removes all stored "Parameter" instances.
		 */
		public function empty() : void {
			_parameters.length = 0;
		}
		
		/**
		 * @see IParametersList.every
		 */
		public function every(callback:Function):Boolean {
			return !!_parameters.every (_wrapCallback(callback));
		}
		
		/**
		 * @see IParametersList.forEach
		 */
		public function forEach(callback:Function):void {
			_parameters.forEach (_wrapCallback(callback));
		}
		
		/**
		 * @see IParametersList.getAt
		 */
		public function getAt(index:int):IParameter {
			return _parameters[index];
		}
		
		/**
		 * @see IParametersList.getByName
		 */
		public function getByName(parameterName:String):Vector.<IParameter> {
			return _searchFor(NAME, parameterName);
		}
		
		/**
		 * @see IParametersList.getByUid
		 */
		public function getByUid(parameterUid:String):IParameter {
			var match : Vector.<IParameter> = _searchFor(UID, parameterUid, true);
			var result : IParameter = (match && match.length >= 1)? match[0] : null;
			if (!result) {
				trace ('`ParametersList.getByUid()`: Could not find any parameter in the current set that matches: "' + parameterUid + '".');
			}
			return result;
		}
		
		
		/**
		 * @see IParametersList.indexOf
		 */
		public function indexOf(searchParameter:IParameter, fromIndex:int=0):int {
			return _parameters.indexOf (searchParameter, fromIndex);
		}
		
		/**
		 * @see IParametersList.insertAt
		 */
		public function insertAt(index:int, parameter:IParameter):void {
			_parameters.splice (index, 0, parameter);
		}
		
		/**
		 * @see IParametersList.lastIndexOf
		 */
		public function lastIndexOf(searchParameter:IParameter, fromIndex:int=0x7fffffff):int {
			return _parameters.lastIndexOf (searchParameter, fromIndex);
		}
		
		/**
		 * @see IParametersList.length
		 */
		public function get length():uint {
			return _parameters.length;
		}
		
		/**
		 * @see IParametersList.pop
		 */
		public function pop():IParameter {
			return _parameters.pop();
		}
		
		/**
		 * @see IParametersList.push
		 */
		public function push(...parameters):uint {
			return _parameters.push.apply (null, parameters);
		}
		
		/**
		 * @see IParametersList.removeAt
		 */
		public function removeAt(index:int):IParameter {
			var parameter : IParameter = _parameters[index];
			_parameters.splice (index, 1);
			return parameter;
		}
		
		/**
		 * @see IParametersList.reverse
		 */
		public function reverse():void {
			_parameters.reverse();
		}
		
		/**
		 * @see IParametersList.shift
		 */
		public function shift():IParameter {
			return _parameters.shift();
		}
		
		/**
		 * @see IParametersList.some
		 */
		public function some(callback:Function):Boolean {
			return _parameters.some (_wrapCallback(callback));
		}
		
		/**
		 * @see IParametersList.sort
		 */
		public function sort(...args):void {
			_parameters.sort.apply (null, args);
		}
		
		/**
		 * @see IParametersList.splice
		 */
		public function splice(startIndex:int, deleteCount:uint=4294967295, ...parameters):void {
			_parameters.splice (startIndex, deleteCount, parameters);
		}
		
		/**
		 * @see IParametersList.toString
		 */
		public function toString():String {
			return _parameters.toString();
		}
		
		/**
		 * @see IParametersList.unshift
		 */
		public function unshift(...parameters):uint {
			return _parameters.unshift.apply (null, parameters);
		}
		
		/**
		 * Adapter callback function to replace the internal Vector argument with the IParametersList instance
		 */
		private function _wrapCallback (originalCallback : Function) : Function {
			var wrapper : Function = function (item : IParameter, index : int, notUsed : Object) : Boolean {
				return originalCallback (item, index, _self);
			}
			return wrapper;
		}
		
		/**
		 * Traverses all registered IParameter instances looking for matches.
		 * 
		 * @param	fieldName
		 * 			The name of a String IParameter field to search by.
		 * 
		 * @param	fieldValue
		 * 			The String to search.
		 * 
		 * @param	singleResult
		 * 			Optional, default `false`. Whether to stop after the first match.
		 * 
		 * @return
		 * 			A (possible empty) Vector of IParameter instances.
		 */
		private function _searchFor (fieldName : String, fieldValue : String, singleResult : Boolean = false) : Vector.<IParameter> {
			var buffer : Array = [];
			var bufferCount : uint = 0;
			var i : uint = 0; 
			var numParameters : uint = _parameters.length;
			var parameter : IParameter;
			for (i; i < numParameters; i++) {
				parameter = _parameters[i];
				if (parameter[fieldName] == fieldValue) {
					buffer[bufferCount] = parameter;
					if (singleResult) {
						break;
					}
					bufferCount++;
				}
			}
			return Vector.<IParameter>(buffer);
		}
	}
}