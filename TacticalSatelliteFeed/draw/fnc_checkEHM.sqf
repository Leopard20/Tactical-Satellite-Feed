params ["_point1", "_point2"];
_diff = vectorNormalized (_point2 vectorDiff _point1);
_done = [_point1] call TSF_fnc_createHelper;
if (surfaceIsWater _point1) then {TSF_unit_helper setPosASL _point1} else {TSF_unit_helper setPosATL _point1};
TSF_unit_helper setVectorDir _diff;
_result = TSF_unit_helper call TSF_fnc_detect;
TSF_unit_helper setPosASL [0,0,0];
_result