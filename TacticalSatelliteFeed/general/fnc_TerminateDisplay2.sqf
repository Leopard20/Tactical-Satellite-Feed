waitUntil {uiSleep 0.1;isNull(findDisplay 53620) OR (cameraOn != TSF_camera) OR (cameraView != "GUNNER")}; 
(findDisplay 53620) closeDisplay 2;
TSF_CamActive = false; 
switchCamera player; 
showHUD TSF_shownHud;
TSF_hiddenEnemyUnits = [];

{
	_id = player getVariable _x;
	removeMissionEventHandler ["Draw3D", _id];
	player setVariable [_x, -1];
} forEach ["TSF_CamDrawDot", "TSF_CamDrawLine", "TSF_WatchDirLine", "TSF_syncLineDraw", "TSF_actionTargetDraw", "TSF_actionVehDraw", "TSF_actionLineDraw", "TSF_unitDraw"];
setAperture -1;
if (!isNil "TSF_nightVision" OR TSF_NVG_Active) then {
	TSF_nightVision ppEffectEnable false;
	ppEffectDestroy TSF_nightVision;
	TSF_NVG_Active = false;
};