disableSerialization;

_xFinal = 0.04065 * safezoneW + safezoneX;
_display = findDisplay 53620;
_ctrls = [1650, 1651, 1652];

{
	_ctrl = _display displayCtrl _x;
	_ctrl ctrlSetActiveColor [0.1, 0.8, 0.1, 1];
	_ctrl ctrlSetTextColor [1, 1, 1, 1];
	_yp = (ctrlPosition _ctrl) select 1;
	_ctrl ctrlSetPosition [_xFinal, _yp];
	_ctrl ctrlCommit 0.15;
} forEach _ctrls;
	

waitUntil {!(TSF_camActive && TSF_showGoCodeMenu)};

_xp = safezoneX - 0.0525 * safezoneW;

{
	
	_ctrl = _display displayCtrl _x;
	_yp = (ctrlPosition _ctrl) select 1;
	_ctrl ctrlSetPosition [_xp, _yp];
	_ctrl ctrlCommit 0.1;
} forEach _ctrls;