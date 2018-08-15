params ["_point1", "_point2", "_watchDir", "_unitInwater"];
private ["_watchX", "_watchY", "_normal", "_moveDir", "_angle", "_dir"];
if (_unitInwater) exitWith {""};
_moveDir = _point2 vectorDiff _point1;
_normal = [90,_moveDir] call TSF_fnc_vectorRotation;
_watchX = _watchDir vectorDotProduct _moveDir;
_watchY = _watchDir vectorDotProduct _normal;
_angle = _watchY atan2 _watchX;
if (_angle < 0) then {_angle = _angle + 360};
if (_angle <= 22.5 OR _angle >= 337.5) then {_dir = "f"};
if (_angle > 22.5 AND _angle <= 67.5) then {_dir = "fr"};
if (_angle > 292.5 AND _angle < 337.5) then {_dir = "fl"};
if (_angle > 67.5 AND _angle <= 112.5) then {_dir = "r"};
if (_angle > 112.5 AND _angle <= 157.5) then {_dir = "br"};
if (_angle > 157.5 AND _angle <= 202.5) then {_dir = "b"};
if (_angle > 202.5 AND _angle <= 247.5) then {_dir = "bl"};
if (_angle > 247.5 AND _angle <= 292.5) then {_dir = "l"};
_dir