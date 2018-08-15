params ["_pos", "_over", "_climber"];
private ["_posWT","_help"];

[(format ["EH_em_loop%1",([_climber] call TSF_fnc_getUnitNumber)]) , {((_this select 0) getVariable ["TSF_unitIsClimbing",false])}, [_climber], compile format ["%1 setvelocity [0,0,0]",_climber] , [], false, {}, [], 0] call babe_core_fnc_addEH; // systemchat "yo"; _climber setVelocity [0,0,0]

_help = "babe_helper" createVehicleLocal [0,0,0];
_climber setVariable ["TSF_EM_helper",_help,false];
_help setposASL _pos;
_help setdir getdir _climber;
_poswt = _climber worldtomodel (asltoagl _pos);

if (_over) then
{ 
	_climber setposASL (agltoasl (_climber modeltoworld [_posWT select 0, _posWT select 1, (_posWT select 2) + 0.1]));
} else
{
	_climber setposASL (agltoasl (_climber modeltoworld [_posWT select 0, (_posWT select 1)+0.1, (_posWT select 2) + 0.1]));
};