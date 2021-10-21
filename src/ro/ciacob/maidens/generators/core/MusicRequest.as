package ro.ciacob.maidens.generators.core {
	import eu.claudius.iacob.music.knowledge.instruments.interfaces.IMusicalInstrument;
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.ITimeSignatureMap;
	
	import ro.ciacob.maidens.generators.core.interfaces.IMusicRequest;
	import ro.ciacob.maidens.generators.core.interfaces.ISettingsList;
	
	/**
	 * Container for information related to a music generation task
	 * @author Claudius Iacob
	 */
	public class MusicRequest implements IMusicRequest {

		public function MusicRequest () {}
		
		private var _instruments : Vector.<IMusicalInstrument>;
		private var _timeMap : ITimeSignatureMap;
		private var _userSettings : ISettingsList;
		
		/**
		 * @see IMusicRequest.instruments
		 */
		public function get instruments():Vector.<IMusicalInstrument> {
			return _instruments;
		}
		
		/**
		 * @see IMusicRequest.instruments
		 */
		public function set instruments(value:Vector.<IMusicalInstrument>):void {
			_instruments = value;
		}
		
		/**
		 * @see IMusicRequest.timeMap
		 */
		public function get timeMap():ITimeSignatureMap {
			return _timeMap;
		}
		
		/**
		 * @see IMusicRequest.timeMap
		 */
		public function set timeMap(value:ITimeSignatureMap):void {
			_timeMap = value;
		}
		
		/**
		 * @see IMusicRequest._userSettings
		 */
		public function get userSettings():ISettingsList {
			return _userSettings;
		}
		
		/**
		 * @see IMusicRequest._userSettings
		 */
		public function set userSettings(value:ISettingsList):void {
			_userSettings = value;
		}
	}
}