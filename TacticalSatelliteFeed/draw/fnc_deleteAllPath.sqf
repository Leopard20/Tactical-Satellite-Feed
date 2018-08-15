{
	_x setVariable ["TSF_allPathMarkers", []];
} forEach TSF_numberedUnits;
[] spawn TSF_fnc_clearSyncLine;
[] spawn TSF_fnc_clearActionLine;
[] spawn TSF_fnc_clearWatchLine;