params ["_point1"];
private ["_create", "_grp"];
_create = false;
if (isNil "TSF_unit_helper") then {
	_create = true;
} else {
	if (isNull TSF_unit_helper || getDammage TSF_unit_helper != 0) then {_create = true};
};
if (_create) then {
	_grp = createGroup civilian;
	TSF_unit_helper = _grp createUnit ["C_man_polo_1_F", _point1, [] , 0, "NONE"];
	TSF_unit_helper setPosASL [0,0,0];
	TSF_unit_helper hideObject true;
	TSF_unit_helper allowDamage false;
	TSF_unit_helper enableSimulation false;
	TSF_unit_helper setCaptive true;
	TSF_unit_helper disableAI "MOVE";
};
_create