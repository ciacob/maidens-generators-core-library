package ro.ciacob.maidens.generators.core {
	import ro.ciacob.maidens.generators.core.interfaces.IMusicPitch;
	import ro.ciacob.utils.constants.CommonStrings;
	
	/**
	 * IMusicPitch default implementation.
	 * @see IMusicPitch.
	 */
	public class MusicPitch implements IMusicPitch {
		
		private var _midiNote : int;
		private var _tieNext : Boolean;
		
		public function MusicPitch() {}
		
		/**
		 * @see IMusicPitch.midiNote
		 */
		public function get midiNote():int {
			return _midiNote;
		}
		
		/**
		 * @see IMusicPitch.midiNote
		 */
		public function set midiNote(value:int):void {
			_midiNote = value;
		}
		
		/**
		 * @see IMusicPitch.tieNext
		 */
		public function get tieNext():Boolean {
			return _tieNext;
		}
		
		/**
		 * @see IMusicPitch.tieNext
		 */
		public function set tieNext(value:Boolean):void {
			_tieNext = value;
		}
		
		/**
		 * @see IMusicPitch.toString
		 */
		public function toString() : String {
			return [_midiNote, (_tieNext? CommonStrings.EQUAL : CommonStrings.EMPTY)].join (CommonStrings.EMPTY);
		}
	}
}