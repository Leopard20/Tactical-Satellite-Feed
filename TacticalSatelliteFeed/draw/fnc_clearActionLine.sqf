private ["_cnt", "_paths", "_watchArray", "_unitNum", "_allWatchPos", "_watchPoint", "_delete", "_paths"];
_cnt = count TSF_numberedUnits;
for "_unitNum" from 0 to _cnt-1 do {
	_unit = TSF_numberedUnits select _unitNum;
	_path = (_unit getVariable ["TSF_allPathMarkers", []]);
	//if ([0,0] in _path) then {_unit call TSF_fnc_clearInvalidPath};
	_paths = (_unit getVariable ["TSF_allPathMarkers", []]) apply {_x select 0};
	_actionArray = _unit getVariable ["TSF_allActions", []];
	_allActionPos = _actionArray apply {_x select 0};
	for "_i" from 0 to (count _actionArray)-1 do
	{
		_actionPoint = _allActionPos select _i;
		_delete = true;
		for "_j" from 0 to (count _paths)-1 do {
			_path = _paths select _j;
			if (_actionPoint isEqualTo _path) then {_delete = false};
		};
		if (_delete) then {_actionArray deleteAt _i};
	}; 
	//_unit setVariable ["TSF_allActions", _actionArray];
};