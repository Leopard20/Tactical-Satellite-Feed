params ["_climber"];

[ (format ["EH_em_drop%1",([_climber] call TSF_fnc_getUnitNumber)]) ] call babe_core_fnc_removeEH;	
[ (format ["EH_em_loop%1",([_climber] call TSF_fnc_getUnitNumber)])] call babe_core_fnc_removeEH;
deletevehicle (_climber getVariable "TSF_EM_helper");
if (_climber == player)then
{
	EM_busy = false;
	EM_climbing = false;
} else {
	_climber setVariable ["TSF_unitIsClimbing",false,false];
};
