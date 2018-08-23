waitUntil {isNull(findDisplay 53620) OR (cameraOn != TSF_camera) OR (cameraView != "GUNNER")}; 
(findDisplay 53620) closeDisplay 2;
TSF_CamActive = false; 
hintSilent "";
player switchCamera "INTERNAL";
{
	_x hideObject false;
} forEach TSF_hiddenEnemyUnits;
TSF_hiddenEnemyUnits = [];
{
	[_x, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
} forEach ["TSF_CamDrawDot", "TSF_CamDrawLine", "TSF_WatchDirLine", "TSF_syncLineDraw", "TSF_actionTargetDraw", "TSF_actionVehDraw", "TSF_actionLineDraw", "TSF_unitDraw"];
setAperture -1;
if (!isNil "TSF_nightVision" OR TSF_NVG_Active) then {
	TSF_nightVision ppEffectEnable false;
	ppEffectDestroy TSF_nightVision;
	TSF_NVG_Active = false;
};
waitUntil {cameraOn == vehicle player || cameraOn == player};
showHUD TSF_shownHud;
_hr = date select 3;
if (_hr > 18 || _hr < 7) then {
	detach TSF_camera;
	_pos = getPosATL TSF_camera;
	_h = (_pos select 2) + 2000;
	_pos set [2, _h];
	TSF_camera setPosATL _pos
};