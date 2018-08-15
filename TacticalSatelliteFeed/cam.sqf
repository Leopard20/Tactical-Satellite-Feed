call compile preprocessFileLineNumbers "TacticalSatelliteFeed\key.sqf";
call compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\constants.sqf";

///_-_-_-_-_ Functions _-_-_-_-_\\\


TSF_enhancedMovementAvailable = if (isClass(configFile/"CfgPatches"/"BaBe_core")) then {true} else {false};

TSF_fnc_planningMode = compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\fnc_planningMode.sqf";
TSF_fnc_moveCommit = compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\fnc_moveCommit.sqf";
TSF_fnc_getUnitNumber = compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\fnc_getUnitNumber.sqf";
TSF_fnc_getUnitName = compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\fnc_getUnitName.sqf";
TSF_fnc_vectorRotation = compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\fnc_vectorRotation.sqf";
TSF_fnc_createDisplay = compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\fnc_createDisplay.sqf";
TSF_fnc_TerminateCam = compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\fnc_TerminateDisplay.sqf";
TSF_fnc_spawnCam = compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\fnc_spawnCam.sqf";
TSF_fnc_keyDown = compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\fnc_keyDown.sqf";
TSF_fnc_HideEnemies = compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\fnc_HideEnemies.sqf";
TSF_fnc_createHelper = compile preprocessFileLineNumbers "TacticalSatelliteFeed\general\fnc_createHelper.sqf";

TSF_fnc_showGoCodeMenu = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_showGoCodeMenu.sqf";
TSF_fnc_drawRadial = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_drawRadial.sqf";
TSF_fnc_UI_lockCam = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_UI_lockCam.sqf";
TSF_fnc_drawSelection = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_drawSelection.sqf";
TSF_fnc_nightVision = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_nightVision.sqf";
TSF_fnc_Cam_Zoom = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_Cam_Zoom.sqf";
TSF_fnc_UI_nextUnits = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_UI_nextUnits.sqf";
TSF_fnc_UI_unitButtons = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_UI_unitButtons.sqf";
TSF_fnc_UI_watchUnit = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_UI_watchUnit.sqf";
TSF_fnc_switchDraw = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_switchDraw.sqf";
TSF_fnc_showSettingsMenu = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_showSettingsMenu.sqf";
TSF_fnc_refresh = compile preprocessFileLineNumbers "TacticalSatelliteFeed\ui\fnc_refresh.sqf";

TSF_fnc_getWatchMoveDir = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_getWatchMoveDir.sqf";
TSF_fnc_checkLOS =  compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_checkLOS.sqf";
TSF_fnc_rotateUnit = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_rotateUnit.sqf";
TSF_fnc_waitForGoCode = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_waitForGoCode.sqf";
TSF_fnc_waitOnSync = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_waitOnSync.sqf";
TSF_fnc_unitEngaging = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_unitEngaging.sqf";
TSF_fnc_moveUnit = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_moveUnit.sqf";
TSF_fnc_startMove = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_startMove.sqf";
TSF_fnc_correctPath = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_correctPath.sqf";
TSF_fnc_checkSurface = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_checkSurface.sqf";
TSF_fnc_mountVehicle = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_mount.sqf";
TSF_fnc_detect = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_detect.sqf";
TSF_fnc_em = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_em.sqf";
TSF_fnc_exec_drop = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_exec_drop.sqf";
TSF_fnc_exec_em = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_exec_em.sqf";
TSF_fnc_finish_drop = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_finish_drop.sqf";
TSF_fnc_finish_em = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_finish_em.sqf";
TSF_fnc_getWeaponType = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_getWeaponType.sqf";
TSF_fnc_checkWeapon = compile preprocessFileLineNumbers "TacticalSatelliteFeed\move\fnc_checkWeapon.sqf";

TSF_fnc_startDraw = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_3dDraw.sqf";
TSF_fnc_renderCheck = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_renderCheck.sqf";
TSF_fnc_multiPathDraw = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_multiPathDraw.sqf";
TSF_fnc_PathDraw = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_PathDraw.sqf";
TSF_fnc_watchDir_draw = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_watchDir_draw.sqf";
TSF_fnc_drawSync = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_drawSync.sqf";
TSF_fnc_addAction = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_addAction.sqf";
TSF_fnc_trimPath = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_trimPath.sqf";
TSF_fnc_clearSyncLine = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_clearSyncLine.sqf";
TSF_fnc_clearWatchLine = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_clearWatchLine.sqf";
TSF_fnc_clearActionLine = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_clearActionLine.sqf";
TSF_fnc_clearInvalidPath = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_clearInvalidPath.sqf";
TSF_fnc_deleteAllPath = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_deleteAllPath.sqf";
TSF_fnc_drawPathFPS = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_drawPathFPS.sqf";
TSF_fnc_checkEHM = compile preprocessFileLineNumbers "TacticalSatelliteFeed\draw\fnc_checkEHM.sqf";

[] execVM "TacticalSatelliteFeed\reloadCam.sqf";

if (TSF_Init_Message) then {player sideChat "Tactical Satellite Feed Initialized."};