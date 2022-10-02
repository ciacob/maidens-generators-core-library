package ro.ciacob.maidens.generators.core.abstracts {
	import eu.claudius.iacob.maidens.Colors;

	import flash.utils.getQualifiedClassName;
	
	import air.update.utils.Constants;
	
	import ro.ciacob.maidens.generators.core.AnalysisContext;
	import ro.ciacob.maidens.generators.core.MusicUnit;
	import ro.ciacob.maidens.generators.core.MusicalBody;
	import ro.ciacob.maidens.generators.core.Parameter;
	import ro.ciacob.maidens.generators.core.ParametersList;
	import ro.ciacob.maidens.generators.core.constants.CoreOperationKeys;
	import ro.ciacob.maidens.generators.core.constants.CoreParameterNames;
	import ro.ciacob.maidens.generators.core.interfaces.IAnalysisContext;
	import ro.ciacob.maidens.generators.core.interfaces.IAnalysisScores;
	import ro.ciacob.maidens.generators.core.interfaces.IGeneratorModule;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicRequest;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicUnit;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicalBody;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicalPostProcessor;
	import ro.ciacob.maidens.generators.core.interfaces.IMusicalTrait;
	import ro.ciacob.maidens.generators.core.interfaces.IParameter;
	import ro.ciacob.maidens.generators.core.interfaces.IParametersList;
	import ro.ciacob.maidens.generators.core.interfaces.ISettingsList;
	import ro.ciacob.math.Fraction;
	import ro.ciacob.math.IFraction;
	import ro.ciacob.utils.ColorUtils;
	import ro.ciacob.utils.ConstantUtils;
	import ro.ciacob.utils.Strings;
	import ro.ciacob.utils.Time;
	import ro.ciacob.utils.constants.CommonStrings;
	
	/**
	 * Generic implementation for a MAIDENS music generator module base class.
	 * @abstract
	 */
	public class AbstractGeneratorModule implements IGeneratorModule {
		
		public static const STATUS_IN_PROGRESS : String = "in progress";
		public static const STATUS_ABORTED : String = "aborted";
		public static const STATUS_COMPLETED : String = "completed";
		public static  const STATUS_POST_PROCESSING : String = "processing";
		public static const STATUS_ERROR : String = "error";
		public static const NO_DURATION_MUSIC_UNIT : String = 'An IMusicUnit instance was produced that has no musical duration. Check the relevant IMusicTrait instance in your generator.';
		public static const NO_TRAITS_DEFINED : String = 'No IMusicalTrait instances are defined by this generator.';
		
		private var _instanceUid : String;
		private var _zeroFraction : IFraction;
		private var _request : IMusicRequest;
		private var _callback : Function;
		private var _abortFlag : Boolean;
		private var _errorFlag : Boolean;
		private var _errorMessages : Vector.<String> = Vector.<String>([]);
		private var _refinedMusicalBody : IMusicalBody;
		private var _rawMusicalBody : IMusicalBody;
		private var _currentMusicUnit : IMusicUnit;
		private var _percentCompleted : Number;
		private var _musicalPostProcessors : Vector.<IMusicalPostProcessor>;
		private var _musicalPostProcessorsIds : Array;
		private var _parameters : IParametersList;
		
		/**
		 * @constructor
		 * @param	subclass
		 * 			The instance of the subclass that implements this abstract class.
		 */
		public function AbstractGeneratorModule (subclass : AbstractGeneratorModule) {
			if (!subclass) {
				_yeldAbstractClassError();
			}
		}
		
		/**
		 * @see IGeneratorModule.generate
		 */
		public function generate (request:IMusicRequest) : void {
			
			// Reset/revert session variables
			_abortFlag = false;
			_errorFlag = false;
			_percentCompleted = 0;
			_errorMessages.length = 0;

			
			if (_musicalPostProcessors) {
			 	_musicalPostProcessors.length = 0;
			}
			if (_musicalPostProcessorsIds) {
				_musicalPostProcessorsIds.length = 0;
			}
			_refinedMusicalBody = null;
			
			// Prepare
			_request = request;
			_rawMusicalBody = new MusicalBody;
			
			// MAIN LOOP
			// It will run until the "expected" and "actual" generated music durations
			// match as close as possible (subject to the available musical durations' granularity).
			_executeAsyncWhile (_provideMusicUnit, _isContentNeeded, _onRawGenerationDone, ASYNCH_DELAY);
		}
		
		/**
		 * @see IGeneratorModule.abort
		 */
		public function abort():void {
			_abortFlag = true;
		}
		
		/**
		 * @see IGeneratorModule.callback
		 */
		public function set callback (value : Function) : void {
			_callback = value;
		}
		
		/**
		 * @see IGeneratorModule.lastResult
		 */
		public function get lastResult():IMusicalBody {
			return _refinedMusicalBody;
		}
		
		/**
		 * @see IGeneratorModule.moduleUid
		 */
		public function get moduleUid():String {
			_yeldAbstractClassError();
			return null;
		}
		
		/**
		 * @see IGeneratorModule.instanceUid
		 */
		public final function get instanceUid():String {
			if (!_instanceUid) {
				_instanceUid = Strings.generateRFC4122GUID();
			}
			return _instanceUid;
		}
		
		/**
		 * @see IGeneratorModule.info
		 */
		public function get info():Object {
			var data : Object = {};
			data.moduleUid = this.moduleUid;
			
			// Provide chart data
			const BASELINE : Object = {
				"label": '',
				"borderColor": '#ffffff',
				"backgroundColor": '#ffffff',
				"data": [0]
			};
			
			var settings : ISettingsList = _request.userSettings;
			var coreParamNames : Array = ConstantUtils.getAllValues(CoreParameterNames);
			var datasets : Array = [ BASELINE ];
			var labels : Array = [];
			var values : Array ;
			var dataset : Object;
			data.chartSource = {
				"labels": labels,
				"datasets" : datasets
			};
			
			// Provide a 1/100 reference grid
			for (var i:int = 0; i <= 100; i += 1) {
				labels.push (i);
			}
			
			// Create one dataset for each custom parameter
			for (var j:int = 0; j < parametersList.length; j++) {
				var param : IParameter = parametersList.getAt(j);
				
				// We will not render core parameters
				var args : Array = [param.name].concat(coreParamNames);
				if (Strings.isAny.apply (null, args)) {
					continue;
				}
				
				// There is no point to render single-value parameters in the chart
				if (param.type != CoreOperationKeys.TYPE_ARRAY) {
					continue;
				}
				
				// Rendering each parameter. Array typed parameters hold unsigned integers 
				// (e.g., 1 to 100) instead of Numbers (e.g., 0.01 to 1), so a conversion is needed. 
				values = [];
				for (var k:int = 0; k < labels.length; k++) {
					var pointInTime : int = labels[k] as int;
					var value : Number = settings.getValueAt(param, pointInTime) as Number;
					values.push (value);
				}
				
				dataset = {
					"label": param.name,
					"borderColor": '#' + ColorUtils.generateRandomColor().toString(16),
					"data": values
				};
				datasets.push (dataset);
			}
			
			// Create one dataset for each analysis criteria
			if (lastResult) {
				var due : IFraction = _request.timeMap.duration;
				var criteriaDatasets : Object = {};
				lastResult.forEach (function (unit : IMusicUnit, index : int, body : IMusicalBody) : void {
					var scores : IAnalysisScores = unit.analysisScores;
					if (!scores.isEmpty()) {
						scores.forEach (function (criteria : String, value : Number) : Boolean {
							if (!(criteria in criteriaDatasets)) {
								criteriaDatasets[criteria] = {
									"label": 'CRITERIA: ' + criteria,
									"borderColor": '#' + ColorUtils.generateRandomColor().toString(16),
									"data": []
								};
							}
							var criteriaDataSet : Object = criteriaDatasets[criteria];
							
							// Approximate each IMusicUnit span with respect to the reference grid
							var unitSpan : int = Math.round (unit.duration.getPercentageOf(due) * labels.length);
							while (unitSpan > 0) {
								criteriaDataSet.data.push (value);
								unitSpan--;
							}
							return true;
						});
					}
				});
				for (var datasetName : String in criteriaDatasets) {
					var someDataset : Object = criteriaDatasets[datasetName];
					datasets.push (someDataset);
				}
			}
			
			return data;
		}
		
		/**
		 * @see IGeneratorModule.parametersList
		 * Note subclasses must ADD to this list rather than replace it, e.g.:
		 * 
		 * override public function get parametersList():IParametersList {
		 * 		super.parametersList.push (
		 * 			// subclass parameters must be defined here
		 * 		);
		 * 		return super.parametersList;
		 * }
		 */
		public function get parametersList():IParametersList {
			if (!_parameters) {
				_parameters = new ParametersList;
			}
			_parameters.push (
				// Analysis Window: how many previously generated music units to observe when
				// deciding what music unit to add next; by default `7`.
				
				(function () : IParameter {
					var parameter : IParameter = new Parameter;
					parameter.type = CoreOperationKeys.TYPE_INT;
					parameter.name = CoreParameterNames.ANALYSIS_WINDOW;
					parameter.uid = 'd4a81aa1-f9a2-4c92-be0a-5f7911747be0';
					parameter.color = Colors.CHROME_COLOR_DARKER;
					parameter.payload = 7;
					parameter.minValue = 5;
					parameter.maxValue = 50;
					parameter.description = 'How many of the previously generated structures to observe when deciding what structure to add next.';
					// parameter.documentationUrl = 'analysis_window_parameter'
					return parameter;
				}()),
				
				// Heterogeneity: how much diversity to incur in the raw material
				// (the more diversity, the more chances to find suitable material in there).
				// Expressed as a factor of the `Analysis window`; by default `40`.
				(function () : IParameter {
					var parameter : IParameter = new Parameter;
					parameter.type = CoreOperationKeys.TYPE_INT,
					parameter.name = CoreParameterNames.HETEROGENEITY,
					parameter.uid = '0165fdda-c082-4f09-b101-0c1b3a35cb92';
					parameter.color = Colors.CHROME_COLOR_DARKER,
					parameter.payload = 40,
					parameter.minValue = 1,
					parameter.description = 'How much diversity to incur in the raw generated material. The more diversity, the more chances to find suitable choices in there. Value is a factor of the "Analysis window" parameter.';
					// parameter.documentationUrl = 'heterogeneity_parameter'
					return parameter;
				}()),
				
				// Hazard: a way to balance deterministics and chance. The smaller the
				// value, the more the generated music will sound orderly and more "thought out".
				// Defaults to `0`.
				(function () : IParameter {
					var parameter : IParameter = new Parameter;
					parameter.type = CoreOperationKeys.TYPE_INT;
					parameter.name = CoreParameterNames.HAZARD;
					parameter.uid = '03268056-d977-4c62-a33d-268d445a3bb7';
					parameter.color = Colors.CHROME_COLOR_DARKER;
					parameter.payload = 0;
					parameter.minValue = 0;
					parameter.maxValue = 25;
					parameter.description = 'A way to balance deterministics and chance. The smaller the value, the higher the odds that the generated music will sound more "orderly". Value is a factor of the full range of the generated structures.';
					// parameter.documentationUrl = 'hazard_parameter'
					return parameter;
				}()),

				(function () : IParameter {
					var parameter : IParameter = new Parameter;
					parameter.type = CoreOperationKeys.TYPE_INT;
					parameter.name = CoreParameterNames.ERROR_MARGIN;
					parameter.uid = '1ce62acd-4fb6-4d3d-94d0-862a776d5997';
					parameter.color = Colors.CHROME_COLOR_DARKER;
					parameter.payload = 45;
					parameter.minValue = 1;
					parameter.maxValue = 100;
					parameter.description = 'Controls a preliminary validation device, which only accepts those structures whose calculated fit score is within certain margin to the expected value. The smaller the value, the more CPU time is invested to closely match every parameter value.';
					// parameter.documentationUrl = 'error_margin_parameter';
					return parameter;
				}())
			);
			return _parameters;
		}
		
		/**
		 * @see IGeneratorModule.musicalTraitsList
		 */
		public function get musicalTraits():Vector.<IMusicalTrait> {
			_yeldAbstractClassError();
			return null;
		}
		
		/**
		 * The number of milliseconds to wait between asynchronous iterations. Default is `10`.
		 * Subclasses can override to return another value.
		 */
		protected function get ASYNCH_DELAY () : uint {
			return 10;
		}
		
		/**
		 * Determines whether available musical durations can fit the remaining musical body
		 * duration or not.
		 */
		private function _canFill (duration : IFraction) : Boolean {
			// TODO: implement
			return true;
		}
		
		/**
		 * Produces one IMusicUnit instance and adds it to the (raw) IMusicalBody instance. Operates inside of an
		 * asynchronous loop (see `_executeAsyncWhile` for details).
		 */
		private function _provideMusicUnit (iterationCounter : uint, next : Function, exit : Function) : void {
			
			// Initialize an empty IMusicUnit to populate
			_currentMusicUnit = new MusicUnit;
			
			// Cycle through all available IMusicalTraits and have them populate/set up the current IMusicUnit.
			// When all the IMusicalTraits have finished setting up the current IMusicUnit, we
			// clone it, add it to the IMusicalBody and repeat the process for another IMusicUnit.
			var onMusicalTraitsDone : Function = function () : void {
				
				// We exit if the resulting music unit has no duration (as, under normal operation 
				// circumstances this should never happen)
				if (!_currentMusicUnit.duration || _currentMusicUnit.duration.equals(ZERO_FRACTION)) {
					_errorMessages.push (NO_DURATION_MUSIC_UNIT);
					_errorFlag = true;
					exit();
					return;
				}
				
				// Add a clone of the just populated IMusicUnit instance to the raw musical body
				_rawMusicalBody.push (_currentMusicUnit.clone());
				
				// Report progress to outside world
				_callback ( { state : STATUS_IN_PROGRESS, percentComplete : _percentCompleted } );
				
				// Move to next iteration
				next();
			}
			_executeAsyncWhile (_doMusicalTrait, _trueCondition, onMusicalTraitsDone, ASYNCH_DELAY);			
		}
		
		/**
		 * Runs the execution routine inside the current IMusicalTrait instance, which results in (partially)
		 * setting / overriding the properties of the current IMusicUnit. Operates inside of an asynchronous
		 * loop (see `_executeAsyncWhile` for details).
		 */
		private function _doMusicalTrait (iterationCounter : uint, next : Function, exit : Function) : void {
			if (musicalTraits.length == 0) {
				_errorMessages.push (NO_TRAITS_DEFINED);
				_errorFlag = true;
				exit();
				return;
			}
			
			// There is a trait at given index; process it and move the the next one.
			if (iterationCounter in musicalTraits) {
				var trait : IMusicalTrait = musicalTraits[iterationCounter];

				// Collect any post processors the trait might carry
				if (trait.musicalPostProcessors && trait.musicalPostProcessors.length > 0) {
					if (!_musicalPostProcessors) {
						_musicalPostProcessors = Vector.<IMusicalPostProcessor>([]);
					}
					if (!_musicalPostProcessorsIds) {
						_musicalPostProcessorsIds = [];
					}

					trait.musicalPostProcessors.forEach (function (processor : IMusicalPostProcessor, ...etc) : void {
						var pId : String = processor.uid;
						if (_musicalPostProcessorsIds.indexOf (pId) == -1) {
							_musicalPostProcessorsIds.push (pId);
							_musicalPostProcessors.push(processor);
						}
					});
				}
				
				// Apply the trait to the current music unit
				trait.execute (_currentMusicUnit, _getUpdatedContext(), parametersList, _request);
				next();
			}
			
			// We are at the end of the list; exit to parent loop.
			else {
				exit();
				return;
			}
		}
		
		/**
		 * Runs each of the available musical post-processors against the generated raw material in order to refine it.
		 * Changes are destructive and permanent (later processors receive the material in the form earlier processors
		 * left it). Operates inside of an asynchronous loop (see `_executeAsyncWhile` for details).
		 */
		private function _doMusicalPostProcessor (iterationCounter : uint, next : Function, exit : Function) : void {
			if (_musicalPostProcessors.length == 0) {
				exit();
				return;
			}
			
			// There is a musical post-processor at given index; run it and move to the next one
			// TODO: report post-processor progress as part of the global progress
			if (iterationCounter in _musicalPostProcessors) {
				var postProcessor : IMusicalPostProcessor = _musicalPostProcessors[iterationCounter];
				postProcessor.execute (_rawMusicalBody, _request);
				next();
			}
			
			// We are at the end of the list; exit to parent loop
			else {
				exit();
				return;
			}
		}
		
		/**
		 * Returns an IAnalysisContext instance that holds information, which is potentially useful to
		 * IMusicalContentAnalyzer instances, such as the last `n` IMusicUnit instances that were added
		 * to the raw musical body, or the current `_percentCompleted`.
		 */
		private function _getUpdatedContext () : IAnalysisContext {
			// Produce a slice of the last `n` IMusicUnit instances added to the raw musical body,
			// where `n` is given by the `Analysis Window` parameter (provided it was defined)
			var contentSlice : Vector.<IMusicUnit> = null;
			var match : Vector.<IParameter> = parametersList.getByName(CoreParameterNames.ANALYSIS_WINDOW);
			if (match.length) {
				var windowParam : IParameter = match[0];
				var windowSize : uint = _request.userSettings.getValueAt(windowParam, 0) as uint;
				windowSize = Math.min (_rawMusicalBody.length, windowSize);
				contentSlice = Vector.<IMusicUnit>([]);
				for (var i:int = 0, c:int = _rawMusicalBody.length - 1; i < windowSize; i++) {
					contentSlice.unshift (_rawMusicalBody.getAt(c--));
				}
			}
			var context : IAnalysisContext = new AnalysisContext;
			context.previousContent = contentSlice;
			context.percentTime = _percentCompleted;
			return context;
		}
		
		/**
		 * Determines whether a new IMusicUnit instance needs to be added to the IMusicalBody
		 * instance currently being filled.  
		 */
		private function _isContentNeeded () : Boolean {
			var due : IFraction = _request.timeMap.duration;
			var actual : IFraction = _rawMusicalBody.duration;
			_percentCompleted = Math.min (1, actual.getPercentageOf(due));
			var leftToDo : IFraction = due.subtract(actual);
			var answer : Boolean = leftToDo.greaterThan(ZERO_FRACTION) && _canFill (leftToDo);			
			return answer;
		}
		
		/**
		 * Called when the IMusicalBody instance has been (roughly) filled with musical units. This is a signal that
		 * post-processors can kick in.
		 */
		private function _onRawGenerationDone () : void {

			// Exit routine: safeguard the final form of the generated music, prepare the generator for a new run
			// and execute the top-level `callback` to let the outer world know that the process is complete.
			var onPostProcessingDone : Function = function () : void {
				if (!_refinedMusicalBody) {
					_refinedMusicalBody = new MusicalBody;
				}
				while (_rawMusicalBody.length > 0) {
					_refinedMusicalBody.insertAt (_refinedMusicalBody.length, _rawMusicalBody.removeAt (_rawMusicalBody.length - 1));
				}
				_refinedMusicalBody.reverse();
				_rawMusicalBody = null;
				_currentMusicUnit = null;
				_musicalPostProcessors = null;
				_musicalPostProcessorsIds = null;
				_callback ( { state : STATUS_COMPLETED, percentComplete : 1 } );
			}
			
			// If there were any post-processors defined, asynchronously run them, then exit
			if (_musicalPostProcessors) {
				_executeAsyncWhile (_doMusicalPostProcessor, _trueCondition, onPostProcessingDone, ASYNCH_DELAY);
			}
			
			// Otherwise, simply exit
			else {
				onPostProcessingDone();
			}
		}
		
		/**
		 * Called when the generation process has been externally aborted.
		 */
		private function _onAbort () : void {
			_callback({ state : STATUS_ABORTED, percentComplete : 0 });
		} 
		
		/**
		 * Called when the generation process halts because of an error.
		 */
		private function _onError () : void {
			var errorDetails : String = _errorMessages.join(CommonStrings.NEW_LINE);
			_callback({ state : STATUS_ERROR, percentComplete : 0, error: errorDetails });
		}
		
		/**
		 * Asynchronously and repeatedly executes a given `iteration` function for as long as a given `condition` function
		 * returns true. Iterations are separated by the given `delay` (milliseconds value expected).
		 * 
		 * @param	iteration
		 * 			A function to call if `condition()` returns `true`. The expected function signature is:
		 * 
		 * 			function myFunction (iterationCounter : uint, next : Function, exit : Function) : void;
		 * 
		 * 			where:
		 * 			- "iterationCounter" is a positive integer starting at `0` and incrementing with each call of
		 * 			  `iteration()`;
		 * 			- "next" is a clossure that checks given `condition()`, increments the counter and
		 * 			  calls again `myFunction()` after the set `delay`;
		 * 			- and "exit" is a clossure that calls the given `onComplete()` function and releases associated
		 * 			  memory.
		 * 
		 * 			Note that `myFunction()` must explicitly call `next()` to move to the next iteration. It can
		 * 			also use it to simmulate the <<continue>> language construct:
		 * 
		 * 			// ...
		 * 			next();
		 * 			return;
		 * 
		 * 			By contrast, `myFunction()` does not need to call `exit()` explicitly; it will be called 
		 * 			automatically when `condition()` returns `false`. However, `myFunction()` can explicitly
		 * 			call `exit()` to simmulate the <<break>> language construct:
		 * 
		 * 			// ...
		 * 			exit();
		 * 			return;
		 * 
		 * @param	condition
		 * 			A function to call before every iteration. If the function returns `false`, `iteration()` will not run,
		 * 			and `onComplete()` will be called instead;
		 * 
		 * @param	onComplete
		 * 			A function to be called when either `condition()` returns false or when `iteration()` decides to
		 * 			prematurely end the loop (similar to using the <<break>> language construct, see above).
		 * 
		 * @param	delay
		 * 			The number of milliseconds to wait before running the next iteration.
		 * 
		 * Notes:
		 * - NO INTERNAL STATE THAT THE `iteration()` FUNCTION DEPENDS ON SHOULD BE ALTERED BETWEEN ITERATIONS;
		 * - CALLING `exit()` FROM THE `iteration` FUNCTION EFFECTIVELLY VOIDS THE ITERATOR CONTEXT. SUBSEQUENT CALLS TO
		 *   EITHER `next()` OR `exit()` WILL PRODUCE AN ERROR.
		 */
		private function _executeAsyncWhile (iteration : Function, condition : Function, onComplete : Function, delay : uint) : void {
			var context : Object = {
				counter: 0
			};
			
			// Closure to be run when `exit()` is called from  within the iteration function.
			// Also runs when the global `_abortFlag` is raised.
			context.exit = function() : void {
				delete context.counter;
				delete context.next;
				delete context.exit;
				context = null;
				if (_abortFlag) { 
					_onAbort();
					return;
				}
				if (_errorFlag) {
					_onError();
					return;
				}
				onComplete();
			};
			
			// Closure to be run when `next()` is called from  within the iteration function.
			context.next = function () : void {
				if (_abortFlag || _errorFlag) {
					context.exit();
					return;
				}
				if (condition ()) {
					if (context.counter == 0) {
						iteration (context.counter++, context.next, context.exit);
					} else {
						Time.advancedDelay(iteration, null, delay, context.counter++, context.next, context.exit);
					}
				} else {
					context.exit();
				}
			}
				
			// Automatically proceed with the first iteration. We check for `context` presence because, if `exit()`
			// was called from within the iteration function, then `context` would be `null`.
			if (context) {
				context.next();
			}
		}
		
		/**
		 * Convenience getter for a IFraction instance that equals to "0". We do not want to
		 * couple this class with `Fraction` and therefore will not use `Fraction.ZERO`.
		 */
		private function get ZERO_FRACTION () : IFraction {
			if (!_zeroFraction) {
				_zeroFraction = Fraction.ZERO;
			}
			return _zeroFraction;
		}
		
		/**
		 * Convenience function to pass as the second parameter to `_executeAsyncWhile()` in order to obtain an infinite
		 * (asynchronous) loop. The `iteration` function can then break the loop as needed by using the `exit()` closure
		 * it receives as an argument.
		 */
		private function _trueCondition () : Boolean {
			return true;
		}
		
		/**
		 * Produces a runtime error as a reminder that the class is abstract
		 */
		private function _yeldAbstractClassError () : void {
			throw ('The class `' + getQualifiedClassName(this) + 
				'` is abstract; please remember to extend it and override its methods as needed.');
		}
	}

}