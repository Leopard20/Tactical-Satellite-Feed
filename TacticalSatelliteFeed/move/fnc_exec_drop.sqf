params ["_pos", "_climber"];
private ["_endPos"];

[ (format ["EH_em_loop%1",([_climber] call TSF_fnc_getUnitNumber)]) , {(_climber getVariable "TSF_unitIsClimbing")}, [], {}, [], false, {}, [], 0] call babe_core_fnc_addEH; //systemchat str _this; player setVelocity [0,0,0]
_endpos = [_pos select 0, _pos select 1, (_pos select 2)-1.9];
_help = "babe_helper" createVehicleLocal [0,0,0];
_climber setVariable ["TSF_EM_helper",_help,false];
_help setposASL _endpos;
_help setdir getdir _climber;
_poswt = _climber worldtomodel (asltoagl _endpos);
_climber setposASL (agltoasl (_climber modeltoworld [_posWT select 0, (_posWT select 1)+0.1, (_posWT select 2) + 0.1]));
