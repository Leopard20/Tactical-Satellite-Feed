disableSerialization;
_display = findDisplay 53620;
for "_i" from 1 to 10 do 
{
	_ctrlButton = _display displayCtrl (1602 + _i);
	_ctrlTextUp = _display displayCtrl (1629 + _i);
	_ctrlTextDown = _display displayCtrl (1619 + _i);
	_unitNum = _i + TSF_menuNumber*10;
	if (count TSF_numberedUnits >= _unitNum) then {
		_unit = TSF_numberedUnits select (_unitNum-1);
		if !(isNull _unit) then {
			_assignedTeam = _unit getVariable ["TSF_ASSIGNED_TEAM_COLOR", ""];
			_TSF_TEAM_COLOR = [1,1,1,1];
			if (_assignedTeam == "GREEN") then {_TSF_TEAM_COLOR = [0,0.8,0,1];};
			if (_assignedTeam == "RED") then {_TSF_TEAM_COLOR = [1,0,0,1];};
			if (_assignedTeam == "BLUE") then {_TSF_TEAM_COLOR = [0,0,1,1];};
			if (_assignedTeam == "YELLOW") then {_TSF_TEAM_COLOR = [0.8,0.8,0,1];};
			_unitName = [_unit] call TSF_fnc_getUnitName;
			_ctrlTextDown ctrlSetText _unitName;
			_ctrlTextUp ctrlSetTextColor _TSF_TEAM_COLOR;
			//_TSF_TEAM_COLOR set [3, 0.6];
			_ctrlButton ctrlSetText "";
			_ctrlTextUp ctrlSetText (str _unitNum);
			_ctrlTextDown ctrlSetTextColor _TSF_TEAM_COLOR;
			_ctrlTextDown ctrlSetBackgroundColor [0,0.8,0,0.2];
		} else {
			_ctrlTextDown ctrlSetText "";
			_ctrlTextDown ctrlSetBackgroundColor [0,0,0,0];
			_ctrlButton ctrlSetTextColor [0.4,0.4,0.4,0.6];
			_ctrlTextUp ctrlSetText "";
			_ctrlButton ctrlSetText "N/A";
		};
	} else {
		_ctrlTextDown ctrlSetText "";
		_ctrlTextDown ctrlSetBackgroundColor [0,0,0,0];
		_ctrlButton ctrlSetTextColor [0.4,0.4,0.4,0.6];
		_ctrlTextUp ctrlSetText "";
		_ctrlButton ctrlSetText "N/A";
	};
};