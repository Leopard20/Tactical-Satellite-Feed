[] spawn {
	private ["_dot", "_unit", "_number", "_lastElement", "_pos", "_height", "_allPos", "_uavPos", "_unitPos", "_uavWatchDir", "_uavProjection", "_proLine", "_cos", "_offset", "_angle", "_posFinal", "_dir"];
	_dot = TSF_cursorDot;
	TSF_selectedUnit = _dot select 1;
	_unit = TSF_selectedUnit;
	_allPos = (_unit getVariable ["TSF_allWatchDirs", []]) apply {_x select 0};
	_height = (_dot select 0) select 2;
	_pos = getMousePosition;
	_pos = screenToWorld _pos;
	_pos set [2,_height];
	_pos = _pos vectorAdd [0,0,0.15];
	if !((_dot select 0) in _allPos) then {
		(_unit getVariable ["TSF_allWatchDirs", []]) pushBack [(_dot select 0),_pos];
		_lastElement = count(_unit getVariable ["TSF_allWatchDirs", []]) -1;
	} else {
		_lastElement = _allPos find (_dot select 0);
		(_unit getVariable ["TSF_allWatchDirs", []]) set [_lastElement,[(_dot select 0),_pos]];
	};
	while {(!TSF_RclickButtonUp && TSF_CamActive)} do {
		_pos = getMousePosition;
		_pos = screenToWorld _pos;
		_pos = _pos vectorAdd [0,0,0.15*(_height+1)/10];
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
		(_unit getVariable ["TSF_allWatchDirs", []]) set [_lastElement, [(_dot select 0),_posFinal]];
		uiSleep 0.001;
	};
};