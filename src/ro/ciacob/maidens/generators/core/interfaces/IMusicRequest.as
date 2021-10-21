package ro.ciacob.maidens.generators.core.interfaces
{
	import eu.claudius.iacob.music.knowledge.instruments.interfaces.IMusicalInstrument;
	import eu.claudius.iacob.music.knowledge.timesignature.interfaces.ITimeSignatureMap;
	
	/**
	 * Container for information related to a music generation task.
	 * @author Claudius Iacob
	 */
	public interface IMusicRequest {
		
		/**
		 * Represents the musical time span that is to be filled by this music generation task.
		 * @see ITimeSignatureMap.
		 */
		function get timeMap () : ITimeSignatureMap;
		function set timeMap (value : ITimeSignatureMap) : void;
		
		/**
		 * Represents the list of musical instruments music is to be generated for.
		 * @see IMusicalInstrument
		 */
		function get instruments () : Vector.<IMusicalInstrument>;
		function set instruments (value : Vector.<IMusicalInstrument>) : void;
		
		/**
		 * Contains the values/settings user has provided for various parameters.
		 * @see ISettingsList
		 */
		function get userSettings () : ISettingsList;
		function set userSettings (value : ISettingsList) : void;
	}

}