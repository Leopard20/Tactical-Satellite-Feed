disableSerialization;
hintSilent "";
_xFinal = 0.92 * safezoneW + safezoneX;
_display = findDisplay 53620;
_ctrls = [1619, 1655, 1656];
_xInitial = 1.0525 * safezoneW + safezoneX;
{
	_ctrl = _display displayCtrl _x;
	_ctrl ctrlSetActiveColor [0.9, 1, 0.9, 1];
	_ctrl ctrlSetTextColor [0.85, 0.85, 0.85, 1];
	_yp = (ctrlPosition _ctrl) select 1;
	_ctrl ctrlSetPosition [_xFinal, _yp];
	_ctrl ctrlCommit 0.15;
} forEach _ctrls;

waitUntil {!TSF_camActive || !TSF_showSettingsMenu};

_xp = 1.0525 * safezoneW + safezoneX;
{
	
	_ctrl = _display displayCtrl _x;
	_yp = (ctrlPosition _ctrl) select 1;
	_ctrl ctrlSetPosition [_xp, _yp];
	_ctrl ctrlCommit 0.1;
} forEach _ctrls;