params ["_unit", "_weapon"];
if (_weapon == "") exitWith {false};
private ["_mags", "_ok", "_hasMag", "_supportedMags"];
_mags = magazines _unit;
_ok = false;
if (_unit ammo _weapon == 0) then {
	_hasMag = false;
	_supportedMags = getArray (configFile >> "CfgWeapons" >> _weapon >> "Magazines");
	{
		if (_x in _supportedMags) exitWith {_hasMag = true};
	} forEach _mags;
	if (_hasMag) then {_ok = true};
} else {_ok = true};
_ok