params ["_point"];
private ["_pos","_posY","_posX", "_render"];
_pos = worldToScreen _point;
if (count _pos == 0) exitWith {false};
_posX = _pos select 0;
_posY= _pos select 1;
_render = false;
if (_posX >= TSF_safeX && _posY >= TSF_safeY && _posX <= TSF_safeXM && _posY <= TSF_safeYM) then {_render = true};
_render