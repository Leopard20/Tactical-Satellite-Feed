[] spawn {
	private ["_dot", "_point", "_unit", "_number", "_lastElement", "_pos", "_height", "_allPos1", "_allPos2"];
	_dot = TSF_cursorDot;
	_point = _dot select 0;
	_unit = _dot select 1;
	{
		if ([0,0] in TSF_allSyncedDots) then {_ind = TSF_allSyncedDots find [0,0]; TSF_allSyncedDots deleteAt _ind};
	} forEach TSF_allSyncedDots;
	_allPos1 = TSF_allSyncedDots apply {_x select 0};
	_allPos2 = TSF_allSyncedDots apply {_x select 1};
	_height = _point select 2;
	_pos = getMousePosition;
	_pos = screenToWorld _pos;
	_pos set [2,_height];
	_pos = _pos vectorAdd [0,0,0.15];
	
	
	
	if !(_point in _allPos1 OR _point in _allPos2) then {
		TSF_allSyncedDots pushBack [_point,_pos, _unit];
		_lastElement = count(TSF_allSyncedDots)-1;
	} else {
		_lastElement = _allPos1 find _point;
		if (_lastElement == -1) then {_lastElement = _allPos2 find _point};
		TSF_allSyncedDots set [_lastElement,[_point,_pos, _unit]];
	};
	TSF_syncingMode = true;
	TSF_currentActionIndex = _lastElement;
	["TSF_mouseDraw_EH", "onEachFrame", {
		if (TSF_LclickButtonUp || !TSF_CamActive) exitWith {["TSF_mouseDraw_EH", "onEachFrame"] call BIS_fnc_removeStackedEventHandler};
		params ["_unit", "_height", "_lastElement", "_point"];
		private ["_lastElement", "_pos", "_uavPos", "_uavWatchDir", "_uavProjection", "_proLine", "_cos", "_offset", "_angle", "_posFinal", "_dir"];
		_pos = getMousePosition;
		_pos = screenToWorld _pos;
		_isWater = surfaceIsWater _pos;
		_pos = _pos vectorAdd [0,0,0.15];
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
		TSF_allSyncedDots set [_lastElement, [_point,_posFinal, _unit]];
	}, [_unit, _height, _lastElement, _point]] call BIS_fnc_addStackedEventHandler;
};