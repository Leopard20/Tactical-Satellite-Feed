params ["_mode"];
private ["_count", "_path", "_unit", "_unitNumber"];
_count = count TSF_numberedUnits;
for "_unitNumber" from 0 to _count-1 do
{
	_unit = TSF_numberedUnits select _unitNumber;
	if (_mode == 0) then {
		_path = _unit getVariable ["TSF_allPathMarkers", []];
		if (count _path != 0) then {
			_unit setVariable ["TSF_cancelMove", true];
			[_unit] spawn {
				params ["_unit"];
				uiSleep 0.1;
				[_unit] spawn TSF_fnc_startMove;
			};
		};
	} else {
		_unit setVariable ["TSF_cancelMove", true];
	
	};
};