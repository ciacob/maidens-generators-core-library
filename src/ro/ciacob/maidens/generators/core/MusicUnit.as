package ro.ciacob.maidens.generators.core {
	import ro.ciacob.maidens.generators.core.interfaces.IAnalysisScores;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicPitch;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicUnit;
	import ro.ciacob.maidens.generators.core.interfaces.IPerformanceInstruction;
	import ro.ciacob.maidens.generators.core.interfaces.IPitchAllocation;
	import ro.ciacob.maidens.generators.core.interfaces.ITupletDefinition;
	import ro.ciacob.math.IFraction;
	import ro.ciacob.utils.Strings;
	
	public class MusicUnit implements IMusicUnit {

		private var _uid : String;
		private var _duration : IFraction;
		private var _tupletRootUid : String;
		private var _tupletDefinition : ITupletDefinition;
		private var _pitches : Vector.<IMusicPitch>;
		private var _pitchAllocations : Vector.<IPitchAllocation>;
		private var _performanceInstructions : Vector.<IPerformanceInstruction>;
		private var _analysisScores : IAnalysisScores;
		
		
		
		public function MusicUnit() {
			_pitches = Vector.<IMusicPitch>([]);
			_pitchAllocations = Vector.<IPitchAllocation>([]);
			_performanceInstructions = Vector.<IPerformanceInstruction>([]);
		}
		
		/**
		 * @see IMusicUnit.uid
		 */
		public function get uid():String {
			if (!_uid) {
				_uid = Strings.generateRFC4122GUID();
			}
			return _uid;
		}
		
		/**
		 * @see IMusicUnit.duration
		 */
		public function get duration():IFraction {
			return _duration;
		}
		
		/**
		 * @see IMusicUnit.duration
		 */
		public function set duration(value:IFraction):void {
			_duration = value;			
		}
		
		/**
		 * @see IMusicUnit.tupletRootUid
		 */
		public function get tupletRootUid():String {
			return _tupletRootUid;
		}
		
		/**
		 * @see IMusicUnit.tupletRootUid
		 */
		public function set tupletRootUid(value:String):void {
			_tupletRootUid = value;
		}
		
		/**
		 * @see IMusicUnit.tupletDefinition
		 */
		public function get tupletDefinition():ITupletDefinition {
			return _tupletDefinition;
		}
		
		/**
		 * @see IMusicUnit.tupletDefinition
		 */
		public function set tupletDefinition(value:ITupletDefinition):void {
			_tupletDefinition = value;
		}
		
		/**
		 * @see IMusicUnit.pitches
		 */
		public function get pitches():Vector.<IMusicPitch> {
			return _pitches;
		}
		
		/**
		 * @see IMusicUnit.pitchAllocations
		 */
		public function get pitchAllocations():Vector.<IPitchAllocation> {
			return _pitchAllocations;
		}
		
		/**
		 * @see IMusicUnit.performanceInstructions
		 */
		public function get performanceInstructions():Vector.<IPerformanceInstruction> {
			return _performanceInstructions;
		}
		
		/**
		 * @see IMusicUnit.IAnalysisScores
		 */
		public function get analysisScores():IAnalysisScores {
			if (!_analysisScores) {
				_analysisScores = new AnalysisScores;
			}
			return _analysisScores;
		}
		
		/**
		 * @see IMusicUnit.clone
		 */
		public function clone() : IMusicUnit {
			var target : IMusicUnit = new MusicUnit;
			target.duration = _duration;
			target.tupletDefinition = _tupletDefinition;
			target.tupletRootUid = _tupletRootUid;
			_copyVectorItems (_pitches, target.pitches);
			_copyVectorItems (_pitchAllocations, target.pitchAllocations);
			_copyVectorItems (_performanceInstructions, target.performanceInstructions);
			if (_analysisScores && !_analysisScores.isEmpty()) {
				var targetScores : IAnalysisScores = target.analysisScores;
				_analysisScores.forEach (function (criteria : String, value : Number) : Boolean {
					targetScores.add (criteria, value);
					return true;
				});
			}
			return target;
		}

		/**
		 * Overrides Object.prototype.toString(). Useful for debugging.
		 * @return
		 */
		public function toString () : String {
			var scores : Array = [];
			if (_analysisScores) {
				var scoresIterator : Function = function (criteria : String, score : Number) : void {
					scores.push (criteria + ' -> ' + score);
				}
				_analysisScores.forEach (scoresIterator);
			}
			return [
				'MusicUnit (' + uid + ')',
				'[' + _pitches.join() + ']' + (_duration || '')
			].join(', ');
		}
		
		/**
		 * Copies items from one Vector to another. Items are passed by reference, NOT recreated.
		 */
		private function _copyVectorItems (vectorA : Object, vectorB : Object) : void {
			var numItems: uint = vectorA['length'];
			var i : uint = 0;
			for (i; i < numItems; i++) {
				vectorB[i] = vectorA[i];
			}
		}
	}
}