params ["_u"];
private ["_str", "_name"];
_str = name _u;
_name = _str select [(_str find " ") + 1];
_name