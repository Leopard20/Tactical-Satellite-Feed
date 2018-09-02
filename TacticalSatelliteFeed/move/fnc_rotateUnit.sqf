params ["_unit", "_watchDirOrigin", "_selectedStance"];
private ["_vecDir", "_vecDirY", "_vecDirX", "_watchDirX", "_watchDirY", "_turn", "_traversed", "_move", "_angle", "_rotate", "_txt", "_watchDir"];
_vecDir = vectorDir _unit;
_watchDir = vectorNormalized _watchDirOrigin;
if (_watchDir isEqualTo [0,0,0]) then {_watchDir = _vecDir};
_angle = acos(_vecDir vectorCos _watchDir);
if (_angle <= 3) exitWith {_unit setVariable ["TSF_unitIsTurning", false]; _unit setVectorDir _watchDir};
_unit setVariable ["TSF_unitIsTurning", true];
_vecDirX = _vecDir select 0;
_vecDirY = _vecDir select 1;
_watchDirX = _watchDir select 0;
_watchDirY = _watchDir select 1;
if (_watchDirY*_vecDirY >= 0) then {
	if (_watchDirX >= _vecDirX) then {_turn = -1} else {_turn = 1};
} else {
	if (_watchDirX*_vecDirX >= 0) then {if(_vecDirX >= 0) then {_turn = -1} else {_turn = 1}} else {
		if (abs(_watchDirX)<=abs(_vecDirX)) then {_turn = -1} else {_turn = 1};
		if(_vecDirX < 0) then {_turn =-1*_turn};
	};
};
if (_vecDirY < 0) then {_turn =-1*_turn};

_rotate = if (_angle < 8) then {2} else {4};
_txt = format["TSF_unit%1_rotation_EH", ([_unit] call TSF_fnc_getUnitNumber)];
if (_unit getVariable ["TSF_rotation_EH", ""] != "") then {[(_unit getVariable "TSF_rotation_EH"), "onEachFrame"] call BIS_fnc_removeStackedEventHandler};
_unit setVariable ["TSF_rotation_EH", _txt]; 
_unit setVariable ["TSF_rotation_traversed", 0];
_unit setVariable ["TSF_rotation_angle", _angle];
[_txt, "onEachFrame", 
{
	params ["_unit", "_rotate", "_vecDir", "_turn", "_txt", "_watchDir"];
	private _traversed = _unit getVariable ["TSF_rotation_traversed", 1000];
	private _angle = _unit getVariable ["TSF_rotation_angle", 0];
	if (_angle > 180) then {_angle = 180};
	if (_traversed > _angle || !(_unit getVariable ["TSF_unitIsTurning", false])) exitWith {
		if (abs((_unit getVariable "TSF_rotation_traversed")-(_unit getVariable "TSF_rotation_angle")) <= 5) then {_unit setVectorDir _watchDir};
		_unit setVariable ["TSF_unitIsTurning", false];
		_unit setVariable ["TSF_rotation_EH", ""];
		[_txt, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
	};
	_newDir = [((_unit getVariable "TSF_rotation_traversed") + _rotate*(60/diag_fps min 3))*_turn, _vecDir] call TSF_fnc_vectorRotation;
	_unit setVariable ["TSF_rotation_traversed", ((_unit getVariable "TSF_rotation_traversed") + _rotate*(60/diag_fps min 3))];
	_unit setVectorDir _newDir;
}, [_unit, _rotate, _vecDir, _turn, _txt, _watchDir]] call BIS_fnc_addStackedEventHandler;
