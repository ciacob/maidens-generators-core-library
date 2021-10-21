package ro.ciacob.maidens.generators.core.constants {
	import ro.ciacob.maidens.generators.constants.duration.DurationFractions;

	/**
	 * Support for static constants to be used across the entire project.
	 * @author Claudius Iacob
	 */
	public final class CoreOperationKeys {
		
		// Acceptable IParameter types
		public static const TYPE_INT : uint = 100;
		public static const TYPE_BOOLEAN : uint = 103;
		public static const TYPE_STRING : uint = 104;
		public static const TYPE_OBJECT : uint = 105;
		public static const TYPE_ARRAY : uint = 106;
		
		// Class names to be used with the class factory
		// public static const MUSICAL_BODY : String = 'MusicalBody';
		// public static const STRUCTURED_INFO : String = 'StructuredInfo';
		
		// Communication helpers (keys in payload objects to be sent through PTT)
		public static const PARAM_UID : String = 'paramUid';
		public static const DOCUMENTATION_URL : String = 'documentationUrl';
		public static const TWEENING_STATUS : String = 'tweeningStatus';
		public static const EDITOR_SERVICE_NOTICE : String = 'editorServiceNotice';
		public static const EDITOR_FOCUS_NOTICE : String = 'editorFocusNotice';
		public static const DOC_REQUESTED_NOTICE : String = 'docRequestedNotice';
		
		// Musical constants
		public static const MIN_NUM_VOICES : int = 1;
		public static const DURATIONS_IN_USE : Array = [
			DurationFractions.WHOLE,
			DurationFractions.HALF,
			DurationFractions.QUARTER,
			DurationFractions.EIGHT,
			DurationFractions.SIXTEENTH
		];
		public static const WHOLE_CHART_VALUES : Array = [[1,1], [50,15], [85,60], [100,100]];
		public static const HALF_CHART_VALUES : Array = [[1,1], [50,30], [75,100], [100,1]];
		public static const QUARTER_CHART_VALUES : Array = [[1,1], [40,58], [50,100], [60,58], [100,1]];
		public static const EIGHT_CHART_VALUES : Array = [[1,1], [25,100], [50,30], [100,1]];
		public static const SIXTEENTH_CHART_VALUES : Array = [[1,100], [15,60], [50,15], [100,1]];
	}
}