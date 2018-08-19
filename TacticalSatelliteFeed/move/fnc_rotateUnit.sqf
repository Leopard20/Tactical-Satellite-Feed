params ["_unit", "_watchDir", "_selectedStance"];
private ["_vecDir", "_vecDirY", "_vecDirX", "_watchDirX", "_watchDirY", "_turn", "_traversed", "_move", "_angle", "_rotate"];
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
_traversed = 0;

_rotate = if (_angle < 5) then {1} else {2.5};

while {_traversed <= _angle} do {
	_traversed = _traversed + _rotate*60/diag_fps;
	_newDir = [_traversed*_turn, _vecDir] call TSF_fnc_vectorRotation;
	_unit setVectorDir _newDir;
	uiSleep 0.001;
};
_unit setVariable ["TSF_unitIsTurning", false];
_unit setVectorDir _watchDir;