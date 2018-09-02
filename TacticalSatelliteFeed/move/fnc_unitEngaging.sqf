params ["_unit", "_target", "_point2", "_isWater", "_unitInwater", "_weapon"];
private ["_unitPos", "_targetPos", "_watchDir", "_dir", "_nextMove", "_sleepTime", "_time", "_stopMove", "_wpnNum"];
if (_unit getVariable ["TSF_unitEngaging", false] || _unitInwater) exitWith {};
_unitPos = if (_isWater) then {getPosASLVisual _unit} else {getPosATLVisual _unit};
_targetPos = if (_isWater) then {getPosASLVisual _target} else {getPosATLVisual _target};
_watchDir = _targetPos vectorDiff _unitPos;
_dir = [_unitPos, _point2, _watchDir, _unitInwater] call TSF_fnc_getWatchMoveDir;

_wpn = primaryWeapon _unit;
_wpnNum = 1;
if (_weapon == "ln") then {_wpn = secondaryWeapon _unit; _wpnNum = 2};
if (_weapon == "pst") then {_wpn = handgunWeapon _unit; _wpnNum = 3};


_stopMove = call compile format["TSF_%2_%1_NON_Anim",(stance _unit), _weapon];
_unit setVariable ["TSF_unitEngaging", true];
_unit setVariable ["TSF_unitChangingMove", true];
_unit setVariable ["TSF_assignedMove", _stopMove];
_unit playMoveNow _stopMove;

_mode = (getArray (configFile >> "CfgWeapons" >> _wpn >> "modes")) select 0;
if (_mode == "this") then {_mode = _wpn};
_sleepTime = 20/(_unit distance2D _target)+1;
if (_sleepTime > 5) then {_sleepTime = 5}; 
_time = 0;
if (needReload _unit > 0.95 && !(_unit getVariable ["TSF_unitReloading", false])) then {
	_unit setVariable ["TSF_unitReloading", true]; 
	reload _unit;
	[_unit, _wpn] spawn {
		params ["_unit", "_wpn"];
		_rld = getNumber (configfile >> "CfgWeapons" >> _wpn >> "magazineReloadTime");
		sleep _rld;
		_unit setVariable ["TSF_unitReloading", false];
	};
};
_unit reveal _target;
if !(_unit getVariable ["TSF_unitReloading", false]) then {
	_unit forceWeaponFire [_wpn, _mode];	
} else {_sleepTime = getNumber (configfile >> "CfgWeapons" >> _wpn >> "magazineReloadTime")};

_unit doFire _target;


waitUntil {
	_time = _time + 1/diag_fps;
	!(_time <= _sleepTime && alive _unit && alive _target && (count (crew _target) != 0) && (_unit getVariable "TSF_unitState" == 0) && !(_unit getVariable "TSF_cancelMove")&& (_unit getVariable "TSF_unitEngaging"))
};

if (_unit getVariable "TSF_unitState" == 0 && !(_unit getVariable ["TSF_unitIsTurning", false]) && !(_unit getVariable "TSF_cancelMove") && (_unit getVariable "TSF_unitEngaging")) then {
	_nextMove = (_unit getVariable "TSF_baseMove") + _dir;
	_true = if (TSF_createMoveEH) then {true} else {false};
	_unit setVariable ["TSF_unitChangingMove", _true];
	_unit setVariable ["TSF_assignedMove", _nextMove];
	_unit playMoveNow _nextMove;
};
_unit setVariable ["TSF_unitEngaging", false];
_unit setVariable ["TSF_unitChangingMove", false];