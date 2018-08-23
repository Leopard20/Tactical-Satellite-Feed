private ["_tempGrp","_playerGrp","_grp","_units","_teams","_quo", "_num" , "_assignedTeam"];
_tempGrp = createGroup (side player);
_tempGrp setBehaviour "AWARE";
_playerGrp = createGroup (side player);
_grp = [player];
_units = (units group player)-[player];
_units = _units select {alive _x};
_grp append _units;
TSF_numberedUnits = [];
{
	[_x] joinSilent _tempGrp;
} forEach (units group player);

{
	[_x] joinSilent _playerGrp;
	TSF_numberedUnits pushBack _x;
} forEach _grp;
_teams = ["RED", "GREEN", "BLUE", "YELLOW", "MAIN"];
_count = count _units;
_quo = ceil(_count/5);
_num = 0;
{
	_assignedTeam = _teams select floor(_num/_quo);
	_x setVariable ["TSF_ASSIGNED_TEAM_COLOR", _assignedTeam];
	_num = _num + 1;
} forEach _units;

[] spawn TSF_fnc_UI_unitButtons;

TSF_playerTeam = _grp;
[] spawn {
	waitUntil {cameraOn == player || cameraOn == vehicle player};
	{
		_x assignTeam (_x getVariable ["TSF_ASSIGNED_TEAM_COLOR", "MAIN"]);
	} forEach TSF_playerTeam;
};