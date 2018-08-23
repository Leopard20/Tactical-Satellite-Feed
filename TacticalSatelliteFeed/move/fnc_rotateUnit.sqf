params ["_unit", "_watchDir", "_selectedStance"];
private ["_vecDir", "_vecDirY", "_vecDirX", "_watchDirX", "_watchDirY", "_turn", "_traversed", "_move", "_angle", "_rotate", "_txt"];
_unit setVariable ["TSF_unitIsTurning", true];
_vecDir = vectorDir _unit;
_watchDir = vectorNormalized _watchDir;
_angle = acos(_vecDir vectorCos _watchDir);
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
_unit setVariable ["TSF_rotation_traversed", 0];

_rotate = if (_angle < 5) then {2} else {4};
_txt = format["TSF_unit%1_rotation_EH", ([_unit] call TSF_fnc_getUnitNumber)];
if (_unit getVariable ["TSF_rotation_EH", ""] != "") then {[(_unit getVariable "TSF_rotation_EH"), "onEachFrame"] call BIS_fnc_removeStackedEventHandler};
_unit setVariable ["TSF_rotation_EH", _txt]; 
[_txt, "onEachFrame", 
{
	params ["_unit", "_angle", "_rotate", "_vecDir", "_turn", "_txt", "_watchDir"];
	_traversed = _unit getVariable "TSF_rotation_traversed";
	if (_traversed > _angle || !(_unit getVariable ["TSF_unitIsTurning", false])) exitWith {
		[_txt, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
		_unit setVectorDir _watchDir;
		_unit setVariable ["TSF_rotation_EH", ""];
		_unit setVariable ["TSF_unitIsTurning", false];
	};
	_traversed = _traversed + _rotate*60/diag_fps;
	_unit setVariable ["TSF_rotation_traversed", _traversed];
	_newDir = [_traversed*_turn, _vecDir] call TSF_fnc_vectorRotation;
	_unit setVectorDir _newDir;
}, [_unit, _angle, _rotate, _vecDir, _turn, _txt, _watchDir]] call BIS_fnc_addStackedEventHandler;
