disableSerialization;
private ["_display", "_button"];
(findDisplay 46) createDisplay "TSF_SatelliteHUD";
_display = findDisplay 53620;
_button = "TacticalSatelliteFeed\Pictures\Button_DrawAll.paa";
if !(player getVariable ["TSF_drawAllPath", true]) then {(_display displayCtrl 1619) ctrlSetText _button};
if !(player getVariable ["TSF_drawIndividualPath", true]) then {(_display displayCtrl 1655) ctrlSetText _button};
if !(player getVariable ["TSF_drawAllLines", true]) then {(_display displayCtrl 1656) ctrlSetText _button};
if (_display getVariable ["TSF_MBD_EH", -1] == -1) then 
{
	_EH = _display displayAddEventHandler ["MouseButtonDown",
	{
		private ["_isntTypeDot"];
		_key = _this select 1;
		_mousePos = getMousePosition;
		_pos = screenToWorld _mousePos;
		if (count TSF_cursorDot == 2) then {
			_pointPos = worldToScreen (TSF_cursorDot select 0);
			_isntTypeDot = (_pointPos distance2D _mousePos > 1/95*TSF_maxSafeDist);
		} else {_isntTypeDot = true};
		if (_key == 0) then {
			TSF_LclickButtonUp = false;
			if (TSF_RadialDraw == 1) exitWith {};
			if (TSF_multiDrawMode) exitWith {};
			if (TSF_pathDrawFPS) exitWith {};
			if (TSF_ctrlHeld && !_isntTypeDot) exitWith {
				[] spawn TSF_fnc_drawSync;
			};
			_unitPos = getPosATLVisual TSF_cursorUnit;
			if (surfaceIsWater _unitPos) then {_unitPos = getPosASLVisual TSF_cursorUnit};
			_unitPosScr = worldToScreen _unitPos;
			if (count _unitPosScr == 0) exitWith {};
			_isntTypeUnit = (_unitPosScr distance2D _mousePos > 1/48*TSF_maxSafeDist OR isPlayer TSF_cursorUnit);
			if (TSF_ctrlHeld && _isntTypeDot && _isntTypeUnit) exitWith {
				[] spawn TSF_fnc_drawSelection; TSF_selectedUnit = objNull;
			};
			if (_isntTypeUnit && _isntTypeDot) exitWith {TSF_selectedUnit = objNull};
			if (TSF_ActionSelectMode) exitWith {};
			if !(_isntTypeUnit) exitWith {
				TSF_selectedUnit = TSF_cursorUnit;
				[_unitPos, true, TSF_selectedUnit] spawn TSF_fnc_PathDraw;
				[] spawn TSF_fnc_clearWatchLine;
			};
			
			if !(_isntTypeDot) then {
				[] spawn TSF_fnc_trimPath;
			};
		} else { 
			TSF_RclickButtonUp = false;
			if (TSF_multiDrawMode) exitWith {player setVariable ["TSF_multiDrawCanceled", true];};
			if (_isntTypeDot) exitWith {TSF_selectedUnit = objNull};
			if !(_isntTypeDot) then {
				if (TSF_ctrlHeld) then {
					TSF_RadialDraw = 1 - TSF_RadialDraw;
					[0] spawn TSF_fnc_drawRadial;
				} else {[] spawn TSF_fnc_watchDir_draw}
			};
		};
	}
	];
	_display setVariable ["TSF_MBD_EH", _EH];
};

if (_display getVariable ["TSF_MBU_EH", -1] == -1) then 
{
	_EH = _display displayAddEventHandler ["MouseButtonUp",
	{
		_key = _this select 1;
		if (_key == 0) then {
			TSF_LclickButtonUp = true;
			if (TSF_pathDrawFPS) exitWith {};
			if (TSF_ActionSelectMode) then {
				TSF_ActionSelectMode = false;
				_action = TSF_currentActionIndex select 2;
				if (_action != 7) then {
					_veh = TSF_cursorActionTarget;
					_vehPos = getPosATLVisual _veh;
					if (surfaceIsWater _vehPos) then {_vehPos = getPosASLVisual _veh};
					_posScreen = worldToScreen _vehPos;
					_MPos = getMousePosition;
					if (_MPos distance2D _posScreen < 1/48*TSF_maxSafeDist) then {
						(((TSF_currentActionIndex select 0) getVariable ["TSF_allActions", []]) select (TSF_currentActionIndex select 1)) set [1, _veh];
						(((TSF_currentActionIndex select 0) getVariable ["TSF_allActions", []]) select (TSF_currentActionIndex select 1)) set [3, true];
					} else {
						((TSF_currentActionIndex select 0) getVariable ["TSF_allActions", []]) deleteAt (TSF_currentActionIndex select 1);
					};
				};
			};
			
			if (TSF_SyncingMode) then {
				TSF_SyncingMode = false;
				_dot = TSF_cursorDot;
				_dotP = _dot select 0;
				_unit2 = _dot select 1;
				_posScreen = worldToScreen _dotP;
				_MPos = getMousePosition;
				_unit1 = (TSF_allSyncedDots select TSF_currentActionIndex) select 2;
				if ((_MPos distance2D _posScreen < 1/48*TSF_maxSafeDist) && _unit2 != _unit1) then {
					(TSF_allSyncedDots select TSF_currentActionIndex) set [1, _dotP];
					(TSF_allSyncedDots select TSF_currentActionIndex) set [2, _unit1];
					(TSF_allSyncedDots select TSF_currentActionIndex) set [3, _unit2];
				} else {
					TSF_allSyncedDots set [TSF_currentActionIndex, [0,0]];
				};
			};
			if (count TSF_allSelectedUnits != 0) exitWith {[] spawn TSF_fnc_multiPathDraw};
			if (!TSF_planningMode && !(isNull TSF_selectedUnit)) then {
					[TSF_selectedUnit] spawn TSF_fnc_startMove;
			};
			
		} else {
			if (TSF_ActionSelectMode) then {
				TSF_ActionSelectMode = false; 
				((TSF_currentActionIndex select 0) getVariable ["TSF_allActions", []]) deleteAt (TSF_currentActionIndex select 1);
			};
			TSF_RclickButtonUp = true;
		}
	}
	];
	_display setVariable ["TSF_MBU_EH", _EH];
};

if (_display getVariable ["TSF_MZC_EH", -1] == -1) then 
{
	_EH = _display displayAddEventHandler ["MouseZChanged",
	{
		private ["_scroll","_dot","_pos","_unit","_unitNum","_stance","_newStance", "_index", "_unit_stanceChangePos","_unit_allStances", "_stanceArray"];
		_scroll = _this select 1;
		if (TSF_ctrlHeld) then {
			if (count TSF_cursorDot == 1) exitWith {};
			_pos = getMousePosition;
			_pointPos = worldToScreen (TSF_cursorDot select 0);
			if (_pointPos distance2D _pos > 1/95*TSF_maxSafeDist) exitWith {};
			_dot = TSF_cursorDot;
			_pos = _dot select 0;
			_unit = _dot select 1;
			if (isNull _unit OR !alive _unit) exitWith {};
			_unit_stanceChangePos = _unit getVariable ["TSF_stanceChangePos", []];
			_unit_allStances = _unit getVariable ["TSF_allStances", []];
			_index = _unit_stanceChangePos find _pos;
			if (_index != -1) then {
				_stance = _unit_allStances select _index;
			} else {
				_stance = 0;
				_index = count _unit_allStances;
			};
			if (_scroll > 0) then {
				_newStance = _stance - 1;
				if (_newStance < 0) then {_newStance = 0};
			} else {
				_newStance = _stance + 1;
				if (_newStance > 2) then {_newStance = 2};
			};
			(_unit getVariable ["TSF_stanceChangePos", []]) pushBackUnique _pos;
			(_unit getVariable ["TSF_allStances", []]) set [_index, _newStance];
		} else {
			if (_scroll > 0) then {
				[-10] call TSF_fnc_cam_Zoom;
			} else {
				[10] call TSF_fnc_cam_Zoom;
			};
		};
	}
	];
	_display setVariable ["TSF_MZC_EH", _EH];
};


if (_display getVariable ["TSF_KeyDown_EH", -1] == -1) then 
{
	_EH = _display displayAddEventHandler ["KeyDown",
	{
		params ["_control", "_key", "_shift", "_ctrl", "_alt"];
		private ["_pressedArray", "_userKeybindPlan", "_userArray", "_userKeybindLock", "_userArrayLock", "_userArrayPlan", "_userKeybindSet", "_userArraySet"];
		_pressedArray = _this select [1,4];
		_userKeybindPlan = call compile TSF_planningModeKey;
		_userKeybindPlan params [
			["_userKey", 44, [0]],
			["_userShift", false, [false]],
			["_userCtrl", false, [false]],
			["_userAlt", false, [false]]
		];
		_userArrayPlan = [_userKey, _userShift, _userCtrl, _userAlt];
		_userKeybindlock = call compile TSF_unlockKey;
		_userKeybindLock params [
			["_userKey", 19, [0]],
			["_userShift", false, [false]],
			["_userCtrl", false, [false]],
			["_userAlt", false, [false]]
		];
		_userArrayLock = [_userKey, _userShift, _userCtrl, _userAlt];
		
		/*
		_userKeybindSet = call compile TSF_settingsKey;
		_userKeybindSet params [
			["_userKey", 19, [0]],
			["_userShift", false, [false]],
			["_userCtrl", false, [false]],
			["_userAlt", false, [false]]
		];
		_userArraySet = [_userKey, _userShift, _userCtrl, _userAlt];
		*/
		switch (true) do
		{
			case (_key == 18): //e
			{
			   _dir = (getdir player) + 2;
			   player setdir (_dir mod 360)
			};	
			case (_key == 16): //q
			{
			   _dir = (getdir player) - 2;
			   player setdir (_dir mod 360);
			};
			case (_ctrl): //ctrl
			{
			   TSF_ctrlHeld = true;
			};
			case (_alt): //alt
			{
			   TSF_AltHeld = true;
			};
			case (_key == 57): //space
			{
			   [0] spawn TSF_fnc_moveCommit;
			};
			case (_shift): //shift
			{
			   TSF_ShiftHeld = true;
			};
			case (_key == 15): //tab
			{
				if !(TSF_showGoCodeMenu) then {
					TSF_showGoCodeMenu = true;
					[] spawn TSF_fnc_showGoCodeMenu;
				};
			};
			case (_userArrayPlan isEqualTo _pressedArray):
			{
				[] spawn TSF_fnc_planningMode;
			};
			case (_userArrayLock isEqualTo _pressedArray):
			{
				[] call TSF_fnc_UI_lockCam;
			};
			case (_key == 20): //T
			{
				if !(TSF_showSettingsMenu) then {
					TSF_showSettingsMenu = true;
					[] spawn TSF_fnc_showSettingsMenu;
				};
			};
		};
		false
		}
	];
	_display setVariable ["TSF_KeyDown_EH", _EH]
};


if (_display getVariable ["TSF_KeyUp_EH", -1] == -1) then 
{
	_EH = _display displayAddEventHandler ["KeyUp",
	{
		switch (_this select 1) do
		{
			case 29:
			{
				TSF_ctrlHeld = false;
			};
			case 56:
			{
				TSF_AltHeld = false;
			};
			case 42:
			{
				TSF_ShiftHeld = false;
			};
			case 15:
			{
				TSF_showGoCodeMenu = false;
			};
			case 20:
			{
				TSF_showSettingsMenu = false;
			};
		};
	}
	];
	_display setVariable ["TSF_KeyUp_EH", _EH];
};
