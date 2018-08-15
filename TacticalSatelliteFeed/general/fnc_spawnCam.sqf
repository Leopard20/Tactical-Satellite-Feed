private ["_createCam", "_cnt", "_lastNum", "_number", "_diff", "_done", "_time", "_grp"];
if (isNil "TSF_player") then {TSF_player = player};
if (isNil "TSF_CamActive") then {TSF_CamActive = false};
if (isNil "TSF_NVG_Active") then {TSF_NVG_Active = false};
if (isNil "TSF_multiDrawMode") then {TSF_multiDrawMode = false};
if (isNil "TSF_cam_YOffset") then {TSF_cam_YOffset = -10};
if (isNil "TSF_cam_ZOffset") then {TSF_cam_ZOffset = 35};
if (isNil "TSF_allSyncedDots") then {TSF_allSyncedDots = [[0,0]]};

{
	if (_x getVariable ["TSF_allPathMarkers", []] isEqualTo []) then {_x setVariable ["TSF_allPathMarkers", []]};
	if (_x getVariable ["TSF_allWatchDirs", []] isEqualTo []) then {_x setVariable ["TSF_allWatchDirs", []]};
	if (_x getVariable ["TSF_allActions", []] isEqualTo []) then {_x setVariable ["TSF_allActions", []]};

	if (_x getVariable ["TSF_stanceChangePos", []] isEqualTo []) then {_x setVariable ["TSF_stanceChangePos", []]};
	if (_x getVariable ["TSF_allStances", []] isEqualTo []) then {_x setVariable ["TSF_allStances", []]};
} forEach (units group player);

TSF_allSelectedUnits = [];
TSF_hiddenEnemyUnits = [];
TSF_nearestVehicles = [];
TSF_ctrlHeld = false;
TSF_ShiftHeld = false;
TSF_AltHeld = false;
TSF_RclickButtonUp = true;
TSF_LclickButtonUp = true;
TSF_planningMode = false;
TSF_showGoCodeMenu = false;
TSF_showSettingsMenu = false;
TSF_multiDrawMode = false;
TSF_ActionSelectMode = false;
TSF_pathDrawFPS = false;
hintSilent "";
_createCam = false;
if (isNil "TSF_camera") then {_createCam = true} else {if (getDammage TSF_camera != 0 || isNull TSF_camera) then {_createCam = true}};
if (_createCam) then {
	TSF_camera = createVehicle ["B_UAV_01_F", [(getPosATL player) select 0, (getPosATL player) select 1, ((getPosATL player) select 2)+30]];
	createVehicleCrew TSF_camera;
	_grp = createGroup civilian;
	{
		[_x] joinSilent _grp;
		_x setCaptive true;
		_x disableAI "AUTOTARGET";
		_x disableAI "TARGET";
		_x disableAI "MOVE";
		_x disableAI "AUTOCOMBAT";
	} forEach ((crew TSF_camera) + [TSF_camera]);
	TSF_camera allowDamage false;
};

TSF_numberedUnits = [];
_lastNum = -1;
{
	_number = ([_x] call TSF_fnc_getUnitNumber) - 1; 
	_diff = _number - _lastNum;
	if (_diff != 1) then {for "_i" from 0 to (_diff-2) do {TSF_numberedUnits pushBack objNull}};
	if (cameraOn == player OR cameraOn == vehicle player) then {_x setVariable ["TSF_ASSIGNED_TEAM_COLOR", (assignedTeam _x)]};
	TSF_numberedUnits pushBack _x;
	_lastNum = _number;
} forEach (units group player);

TSF_AttachedTarget = player;
TSF_camera attachTo [(vehicle TSF_AttachedTarget), [0, TSF_cam_YOffset, TSF_cam_ZOffset]]; 
TSF_camera lockCameraTo [(vehicle TSF_AttachedTarget) , [0]];
TSF_nearestVehicles = [];
TSF_allSelectedUnits = [];
TSF_playerTeam = units group player;
TSF_menuNumber = 0;
TSF_RadialDraw = 0;
TSF_dirOffset = 0;

if (cameraOn == player || cameraOn == vehicle player) then {TSF_shownHud = shownHUD};


[] call TSF_fnc_createDisplay;

TSF_cursorUnit = player;
TSF_cursorActionTarget = objNull;
TSF_cursorDot = [objNull];

[] spawn TSF_fnc_TerminateCam;

if (TSF_simulateFOW) then {[] spawn TSF_fnc_HideEnemies};

TSF_CamActive = true;
TSF_cam_lockOn = 1;
TSF_RadialDraw = 0;
TSF_ActionSelectMode = false;

[] spawn TSF_fnc_startDraw;
[] spawn TSF_fnc_UI_unitButtons;

(gunner TSF_camera) switchCamera "Gunner";
TSF_camera hideObject true;

//showHUD [hud, info, radar, compass, direction, menu, group, cursors, panels]
showHUD [true, true, false, false, false, false, false, false, false];
_time = date select 3;

if (_time >= 20 OR _time <= 4) then {
	 TSF_NVG_Active = false; 
	 [] spawn TSF_fnc_nightVision;		
};
