disableSerialization;
[] spawn {
	_xFinal = 0.04065 * safezoneW + safezoneX;
	_display = findDisplay 53620;
	_ctrls = [1650, 1651, 1652];
	_xInitial = safezoneX - 0.0525 * safezoneW;
	_xp = _xInitial;
	{
		_ctrl = _display displayCtrl _x;
		_ctrl ctrlSetActiveColor [0.1, 0.8, 0.1, 1];
		_ctrl ctrlSetTextColor [1, 1, 1, 1];
		_yp = (ctrlPosition _ctrl) select 1;
		_ctrl ctrlSetPosition [_xp, _yp];
		_ctrl ctrlCommit 0;
	} forEach _ctrls;
	["TSF_showGoCodes_EH", "onEachFrame",
	{
		params ["_ctrls", "_xFinal", "_display"];
		_ctrl = _display displayCtrl 1650;
		_xp = (ctrlPosition _ctrl) select 0;
		_xp = _xp + 0.015 * safezoneW;
		if !(TSF_camActive && TSF_showGoCodeMenu && _xFinal>=_xp) exitWith {
			["TSF_showGoCodes_EH", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
			{
				_ctrl = _display displayCtrl _x;
				_yp = (ctrlPosition _ctrl) select 1;
				_ctrl ctrlSetPosition [_xFinal, _yp];
				_ctrl ctrlCommit 0;
			} forEach _ctrls;
		};
		{
			_ctrl = _display displayCtrl _x;
			_yp = (ctrlPosition _ctrl) select 1;
			_ctrl ctrlSetPosition [_xp, _yp];
			_ctrl ctrlCommit 0;
		} forEach _ctrls;
	}, [_ctrls, _xFinal, _display]] call BIS_fnc_addStackedEventHandler;
};

waitUntil {!(TSF_camActive && TSF_showGoCodeMenu)};

_xp = safezoneX - 0.0525 * safezoneW;
_display = findDisplay 53620;
_ctrls = [1650, 1651, 1652];	
{
	
	_ctrl = _display displayCtrl _x;
	_ctrl ctrlSetActiveColor [0.1, 1, 0.1, 0];
	_ctrl ctrlSetTextColor [1, 1, 1, 0];
	_yp = (ctrlPosition _ctrl) select 1;
	_ctrl ctrlSetPosition [_xp, _yp];
	_ctrl ctrlCommit 0;
} forEach _ctrls;