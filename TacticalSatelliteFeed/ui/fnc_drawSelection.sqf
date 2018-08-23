TSF_InitMouseX = getMousePosition select 0;
TSF_InitMouseY = getMousePosition select 1;
_display = findDisplay 53620;
_ctrl = _display displayCtrl 1649;
if (TSF_NVG_Active) then {_ctrl ctrlSetTextColor [1,0,0,1]} else {_ctrl ctrlSetTextColor [0,1,0,1]};
["TSF_drawSelection_EH", "onEachFrame", 
{
	params ["_ctrl"];
	if (TSF_LclickButtonUp || !TSF_camActive) exitWith {
		_ctrl ctrlSetPosition [0, 0, 0, 0];
		_ctrl ctrlCommit 0;
		_ctrl ctrlSetTextColor [1,0,0,0];
		[] spawn {["TSF_drawSelection_EH", "onEachFrame"] call BIS_fnc_removeStackedEventHandler};
	};
	//disableSerialization;
	_mouseX = getMousePosition select 0;
	_mouseY = getMousePosition select 1;
	_xp = _mouseX min TSF_InitMouseX;
	_yp = _mouseY min TSF_InitMouseY;
	_maxX = _mouseX max TSF_InitMouseX;
	_maxY = _mouseY max TSF_InitMouseY;
	_h = abs(_mouseY - TSF_InitMouseY);
	_w = abs(_mouseX - TSF_InitMouseX);
	if (_h/safeZoneH < 0.15 OR _w/safeZoneW < 0.10) then {_ctrl ctrlSetText "TacticalSatelliteFeed\Pictures\selection_small.paa"} else {_ctrl ctrlSetText "TacticalSatelliteFeed\Pictures\selection.paa"};
	_ctrl ctrlSetPosition [_xp, _yp, _w, _h];
	_ctrl ctrlCommit 0;

	{
		_unit = _x;
		_pos = getPosATLVisual _unit;
		if (surfaceIsWater _pos) then {_pos = getPosASLVisual _unit};
		_screen = worldToScreen _pos;
		if (count _screen == 2) then {
			_scrX = (_screen select 0);
			_scrY = (_screen select 1);
			_xIn = _scrX > _xp && _scrX < _maxX;
			_yIn = _scrY > _yp && _scrY < _maxY;
			if (_xIn && _yIn) then {
				TSF_allSelectedUnits pushBackUnique _unit;
			} else {
				TSF_allSelectedUnits = TSF_allSelectedUnits - [_unit];
			};
		};
	} forEach (units group player);
}, [_ctrl]] call BIS_fnc_addStackedEventHandler;