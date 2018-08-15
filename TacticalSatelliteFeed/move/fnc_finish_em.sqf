params ["_toppos", "_over", "_stmpn", "_climber"];
private ["_dest"];
[ (format ["EH_em%1",([_climber] call TSF_fnc_getUnitNumber)]) ] call babe_core_fnc_removeEH;
[ (format ["EH_em_loop%1",([_climber] call TSF_fnc_getUnitNumber)]) ] call babe_core_fnc_removeEH;

_climber setStamina (getStamina _climber)-_stmpn;
_help = _climber getVariable "TSF_EM_helper";

if (_over) then
{ 
	_climber setposASL _toppos;
};
deletevehicle _help;
_dest = expectedDestination _climber;
_dest set [0, ASLtoAGL _topPos];
_climber setDestination _dest; 
if (_climber == player)then
{
	EM_busy = false;
	EM_climbing = false;
} else {
	//_climber setVariable ["TSF_unitIsClimbing",false,false];
};
_climber setVariable ["TSF_unitIsClimbing",false,false];
_climber setAnimSpeedCoef (_climber getVariable "TSF_EM_default_animspeedcoef");
