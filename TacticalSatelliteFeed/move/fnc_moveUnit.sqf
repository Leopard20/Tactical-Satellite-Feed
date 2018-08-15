params ["_unit", "_assignedTarget", "_LOSTarget", "_originalWatchDir", "_point2", "_selectedStance", "_rotation", "_isWater", "_unitInwater", "_time", "_lastTime"];
private ["_target", "_lastTime", "_watchDir", "_fullMove", "_isIn", "_watchPos", "_multi", "_weapon", "_ok2", "_ok1", "_ok3"];
_multi = if (_selectedStance == "PRONE") then {2} else {1};
_target = _LOSTarget;
_isIn = false;
if !(isNull _assignedTarget) then {
	_isIn = [_unit, _assignedTarget] call TSF_fnc_checkLOS;
	_target = _assignedTarget;
	if !(_isIn) then {
		_lastTime = _unit getVariable "TSF_unitTargetLTS";
		if (time - _lastTime > 15) then {
			_unit setVariable ["TSF_unitTarget", objNull];
			_unit setVariable ["TSF_unitCustomWatchDir", -1];
			_target = _LOSTarget
		};
	} else {
		_unit setVariable ["TSF_unitTargetLTS", time];
	};
};
_unitPos = if (_isWater) then {getPosASLVisual _unit} else {getPosATLVisual _unit};
_targetPos = if (_isWater) then {getPosASLVisual _target} else {getPosATLVisual _target};
if (_unitInwater) then {_unit setVariable ["TSF_baseMove", TSF_SWIM_FORWARD_Anim]};

if (!isNull _target && !_unitInwater) then {
	_unit doTarget _target;
	_unit doWatch _target;
	_watchDirTemp = _targetPos vectorDiff _unitPos; 
	_watchDirTemp set [2,0];
	_weapon = "rfl";
	if ((secondaryWeapon _unit) isKindOf ["Launcher", configFile >> "CfgWeapons"] && ((_target isKindOf "HELICOPTER") || (_target isKindOf "PLANE") || (_target isKindOf "TANK") || (_target isKindOf "APC") || (_target isKindOf "CAR"))) then {
		_ok1 = [_unit, primaryWeapon _unit] call TSF_fnc_checkWeapon;
		_ok2 = [_unit, handgunWeapon _unit] call TSF_fnc_checkWeapon;
		_ok3 = [_unit, secondaryWeapon _unit] call TSF_fnc_checkWeapon;
		if (_ok3) then {_weapon = "ln"} else {
			if (!_ok1 && _ok2) then {_weapon = "pst"};
		};
	} else {
		_ok1 = [_unit, primaryWeapon _unit] call TSF_fnc_checkWeapon;
		_ok2 = [_unit, handgunWeapon _unit] call TSF_fnc_checkWeapon;
		if (!_ok1 && _ok2) then {_weapon = "pst"};
	};
	_baseMove = call compile format["TSF_Base_%3_%1_%2_Anim",(_unit getVariable "TSF_unitStance"), "slow", _weapon];
	_unit setVariable ["TSF_baseMove", _baseMove];
	_unit setVariable ["TSF_weaponType" , _weapon];
	if (_watchDirTemp vectorCos _originalWatchDir > 0 OR _target == _assignedTarget) then {
		_watchDir = _watchDirTemp;
		_unit setVariable ["TSF_unitCustomWatchDir", _watchDir];
		[_unit, _watchDir, _selectedStance] spawn TSF_fnc_rotateUnit;
		_unit doFire _target;
		if (_target != _assignedTarget OR _isIn) then {
			if !(_unit getVariable ["TSF_unitEngaging", false]) then {_unit setVariable ["TSF_unitEngaging", true];[_unit, _target, _point2, _isWater, _unitInwater, _weapon] spawn TSF_fnc_unitEngaging};
		};
	} else {
		_watchDir = _originalWatchDir; 
		_unit setVariable ["TSF_unitCustomWatchDir", -1];
		_watchPos = _watchDir vectorAdd (eyePos _unit);
		if !(_isWater) then {_watchPos = ASLToATL _watchPos};
		_unit doWatch _watchPos;
		_unit setVariable ["TSF_weaponType" , ""];
	};
} else {
	_unit setVariable ["TSF_weaponType" , ""];
	if (time - _time > 3*_rotation*_multi || (_rotation > 1 && time - _lastTime > 1)) then {
		_ok1 = [_unit, primaryWeapon _unit] call TSF_fnc_checkWeapon;
		if (_ok1) then {_unit selectWeapon (primaryWeapon _unit)} else {_unit selectWeapon (handgunWeapon _unit)};
		_rotation = _rotation + 1; 
		_watchDir = _point2 vectorDiff _unitPos; 
		if !(_unit getVariable ["TSF_unitIsTurning", false]) then {[_unit, _watchDir, _selectedStance] spawn TSF_fnc_rotateUnit};
		_lastTime = time;
	} else {_watchDir = _originalWatchDir};
	_watchPos = _watchDir vectorAdd (eyePos _unit);
	if !(_isWater) then {_watchPos = ASLToATL _watchPos};
	_unit doWatch _watchPos;
};
_unit setVariable ["TSF_unitWatchDir", _watchDir];
_dir = [_unitPos, _point2, _watchDir, _unitInwater] call TSF_fnc_getWatchMoveDir;
_fullMove = (_unit getVariable "TSF_baseMove") + _dir;
[_fullMove, _rotation, _lastTime]