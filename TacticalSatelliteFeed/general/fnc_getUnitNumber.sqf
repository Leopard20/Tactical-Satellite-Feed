params ["_u"];
private ["_vvn", "_str", "_number"];
_vvn = vehicleVarName _u;
_u setVehicleVarName "";
_str = str _u;
_u setVehicleVarName _vvn;
_number = parseNumber (_str select [(_str find ":") + 1]) ;
_number