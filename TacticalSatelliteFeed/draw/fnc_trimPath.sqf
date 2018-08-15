_dot = TSF_cursorDot;
_unit = _dot select 1;
_point = _dot select 0;
_paths = (_unit getVariable ["TSF_allPathMarkers", []]);
//if ([0,0] in _paths) then {_unit call TSF_fnc_clearInvalidPath};
_path = _paths apply {_x select 0};
_shift = _paths apply {_x select 1};
_index = _path find _point;
_path = _path select [0, _index];
_newPath = _path apply {[_x, (_shift select (_path find _x))]};
_unit setVariable ["TSF_allPathMarkers", _newPath];
TSF_selectedUnit = _unit;
[] spawn TSF_fnc_clearSyncLine;
[] spawn TSF_fnc_clearActionLine;
[] spawn TSF_fnc_clearWatchLine;
[_point, false, _unit] spawn TSF_fnc_PathDraw