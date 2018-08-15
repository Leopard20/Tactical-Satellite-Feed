params ["_unit"];
private _path = (_unit getVariable ["TSF_allPathMarkers", []]);
{
	if ([0,0] in _path) then {_ind = _path find [0,0]; _path deleteAt _ind};
} forEach _path;
_unit setVariable ["TSF_allPathMarkers", _path];