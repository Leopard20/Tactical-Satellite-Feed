/*
Author: HallyG

Parameter(s):
0: [OBJECT] - Object who is 'looking'
1: [OBJECT] - Object to look for
2: [NUMBER] - Looker's FOV (OPTIONAL) DEFAULT (70)

Returns:
[BOOLEAN]
*/

params [
	["_looker",objNull,[objNull]],
	["_target",objNull,[objNull]],
	["_FOV",75,[0]]
];
private ["_l", "_averagePos", "_eyepos"];

if ([position _looker, getdir _looker, _FOV, position _target] call BIS_fnc_inAngleSector) then {
	_eyepos = AGLtoASL (_looker modelToWorldVisual (_looker selectionPosition "pilot"));
	_averagePos = (AGLtoASL (_target modelToWorldVisual (_target selectionPosition "pilot")) apply {_x*0.7}) vectorAdd ((getPosASL _target) apply {_x*0.3});
	_l = lineIntersectsSurfaces [_eyepos, _averagePos, _target, _looker, true, 1,"GEOM","FIRE"];
	if (count _l > 0) exitWith {false};
	_target setVariable ["TSF_EnemyLTS", time];
	true
} else {
	false
};