params ["_action"];
if (_action == 0) then {
	[] spawn {
		TSF_nearestVehicles = [];
		_dot = TSF_selectedRadialDot;
		_unit = _dot select 1;
		_sideArray = [east, west, resistance, civilian];
		_cfgVehicles = configFile >> "CfgVehicles";
		waitUntil {TSF_ActionSelectMode};
		waitUntil {
			_objs = nearestObjects [_unit, ["SHIP", "STATICWEAPON","CAR","TANK", "HELICOPTER", "PLANE"], 50]; 
			_objs = _objs select {([(_sideArray select (getNumber(_cfgVehicles >> typeOf _x >> "side"))), (side player)] call BIS_fnc_sideIsFriendly) && ((count (fullCrew [_x, "", true]))!=(count (fullCrew [_x, "", false])))};
			{
				_cfg = _cfgVehicles >> typeOf _x;
				_icon = getText (_cfg >> "icon");
				_side = getNumber(_cfgVehicles >> (typeOf _x) >> "side");
				TSF_nearestVehicles pushBackUnique [_x, _icon, _side];
			} forEach _objs;
			uiSleep 1;
			!(TSF_ActionSelectMode && TSF_CamActive)
		};
	};
};
if (_action == 1) then {
	[] spawn {
		TSF_nearestEnemies = [];
		_dot = TSF_selectedRadialDot;
		_unit = _dot select 1;
		waitUntil {TSF_ActionSelectMode};
		waitUntil {
			_objs = nearestObjects [_unit, ["allVehicles"], 300, true]; 
			TSF_nearestEnemies = _objs select {!(_x isKindOf "Animal") && alive _x && ([(side _x), (side player)] call BIS_fnc_sideIsEnemy) && !(_x in TSF_hiddenEnemyUnits)};
			uiSleep 1;
			!(TSF_ActionSelectMode && TSF_CamActive)
		};
	};
};

[_action] spawn {
	params ["_action"];
	private [
		"_dot", "_unit", "_lastElement", "_pos", "_height", "_allPos", "_point1", "_point2", "_diff", "_path", "_shifts", "_index", "_cnt", 
		"_result", "_hasTop", "_top","_paths", "_shift", "_selectedDot"
		];
	_dot = TSF_selectedRadialDot;
	TSF_selectedUnit = _dot select 1;
	_selectedDot = _dot select 0;
	_unit = TSF_selectedUnit;
	_allActions = _unit getVariable ["TSF_allActions", []];
	_allPos = _allActions apply {_x select 0};
	_height = _selectedDot select 2;
	_pos = getMousePosition;
	_pos = screenToWorld _pos;
	_pos set [2,_height];
	_pos = _pos vectorAdd [0,0,0.15];
	_isFinal = true;
	if (_action == 2) then {player setVariable ["TSF_goCodeTriggeredA", false]};
	if (_action == 3) then {player setVariable ["TSF_goCodeTriggeredB", false]};
	if (_action == 4) then {player setVariable ["TSF_goCodeTriggeredC", false]};
	if (_action == 8) then {
		_paths = _unit getVariable ["TSF_allPathMarkers", []];
		_path = _paths apply {_x select 0};
		_shifts = _paths apply {_x select 1};
		_index = _path find _selectedDot;
		_shift = _shifts select _index;
		_cnt = count _path;
		if (_cnt >= 2 && _index < _cnt-1) then {
			_point1 = _path select _index;
			_point2 = _path select _index+1;
			_diff = vectorNormalized (_point2 vectorDiff _point1);
			_result = [_point1, _point2] call TSF_fnc_checkEHM;
			_line = [_unit, _point1, (_point2 vectorAdd _diff), true] call TSF_fnc_checkSurface;
			_hasTop = _line select 1;
			_top = _line select 2;
			_pos = _line select 3;
			if (count _result > 0) then {
				if (_hasTop) then {
					_height = if (surfaceIsWater _pos) then {_top select 2} else {(ASLToATL _top) select 2};
					_height = _height - 0.7;
					_pos set [2, _height];
					_point2 set [2, _height];
				} else {
					_pos = _point1;
				};
				//_pos = _point1;
				//if (count _result == 3) then {_pos = _result select 2};
				//if (count _result == 2) then {_pos = _result select 0};
				((_unit getVariable "TSF_allPathMarkers") select _index) set [0, _pos];
				((_unit getVariable "TSF_allPathMarkers") select _index) append _result;
				(_unit getVariable "TSF_allPathMarkers") set [_index+1, [_point2, _shift]];
			};
			
		};
	};
	if (_action == 0 OR _action == 1) then {_isFinal = false};
	if !(_selectedDot in _allPos) then {
		(_unit getVariable ["TSF_allActions", []]) pushBack [_selectedDot,_pos, _action, _isFinal];
		_lastElement = count(_allActions) -1;
	} else {
		_lastElement = _allPos find _selectedDot;
		(_unit getVariable ["TSF_allActions", []]) set [_lastElement,[_selectedDot,_pos, _action, _isFinal]];
	};
	if (_action == 0 OR _action == 1 OR _action == 7) then {
		TSF_currentActionIndex = [_unit,_lastElement, _action];
		TSF_ActionSelectMode = true;
		["TSF_mouseDraw_EH", "onEachFrame", {
			params ["_unit", "_lastElement", "_height", "_selectedDot", "_action", "_isFinal"];
			private ["_uavPos", "_uavWatchDir", "_uavProjection", "_proLine", "_cos", "_offset", "_angle", "_posFinal", "_dir"];
			if !(TSF_ActionSelectMode && TSF_CamActive) exitWith {["TSF_mouseDraw_EH", "onEachFrame"] call BIS_fnc_removeStackedEventHandler};
			_pos = getMousePosition;
			_pos = screenToWorld _pos;
			_pos = _pos vectorAdd [0,0,0.15];
			_isWater = surfaceIsWater _pos;
			_uavPos = getPosATLVisual TSF_camera;
			if (_isWater) then {_uavPos = getPosASLVisual TSF_camera};
			_uavWatchDir = _pos vectorDiff _uavPos;
			_uavProjection = [(_uavPos select 0), (_uavPos select 1), _height];
			_mouseProjection = _pos;
			_mouseProjection set [2, _height];
			_proLine = _mouseProjection vectorDiff _uavProjection;
			_cos = _proLine vectorCos _uavWatchDir;
			_angle = acos(_cos);
			_offset = (_uavPos select 2)-_height;
			_magnitude = _offset/tan(_angle);
			_dir = vectorNormalized _proLine;
			_dir = _dir apply {_x*_magnitude};
			_posFinal = _uavProjection vectorAdd _dir;
		//	};
			(_unit getVariable ["TSF_allActions", []]) set [_lastElement, [_selectedDot,_posFinal, _action, _isFinal]];
		}, [_unit, _lastElement, _height, _selectedDot, _action, _isFinal]] call BIS_fnc_addStackedEventHandler
	};
};