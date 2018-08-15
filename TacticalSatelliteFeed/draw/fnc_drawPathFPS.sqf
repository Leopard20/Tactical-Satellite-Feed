private ["_prevPos", "_baseText", "_timer" ,"_lastStance" ,"_stanceArray", "_lastDir", "_text", "_pos", "_vecDir", "_index", "_endPoint", "_typeStance", "_typeDir", "_allSelectedUnits"];
hintSilent "Select units for path draw. \n Close the cam to start recording.";
TSF_allSelectedUnits = [];
TSF_pathDrawFPS = true;
waitUntil {isNull (findDisplay 53620)};
player switchCamera "INTERNAL";
uiSleep 0.1;
TSF_allSelectedUnits = TSF_allSelectedUnits - [player];
if (count TSF_allSelectedUnits == 0) exitWith {};
_allSelectedUnits = TSF_allSelectedUnits;
_prevPos = getPosATLVisual player;
{
	if (_x in _allSelectedUnits) then {player groupSelectUnit [_x, true]} else {player groupSelectUnit [_x, false]};
} forEach (units group player);
{
	doStop _x;
	_x setVariable ["TSF_cancelMove", true];

} forEach _allSelectedUnits;
if (surfaceIsWater _prevPos) then {_prevPos = getPosASLVisual player};
_baseText = "Recording Path ";
_timer = 0;
_lastStance = stance player;
_stanceArray = ["STAND", "CROUCH", "PRONE"];
_lastDir = vectorDir player;
while {isNull (findDisplay 53620)} do {
	_text = [".", "..", "..."] select (floor (_timer mod 3));
	_text = _baseText + _text + "\n \n \n Reopen the cam to stop recording";
	hintSilent _text;
	_pos = getPosATLVisual player;
	if (surfaceIsWater _pos) then {_pos = getPosASLVisual player};
	_typeDir = false;
	_typeStance = false;
	if (_pos distance _prevPos >= 1 || ((_pos select 2) - (_prevPos select 2)) >= 0.5) then {
		_vecDir = vectorDir player;
		if (_vecDir vectorCos _lastDir < 0.866) then {
			_typeDir = true;
			_endPoint = (_vecDir apply {_x*5}) vectorAdd _pos;
			_lastDir = _vecDir
		};
		if (stance player != _lastStance) then {
			_lastStance = stance player;
			_index = _stanceArray find _lastStance;
			_typeStance = true;
		};
		{
			if (_x in _allSelectedUnits) then {
				_add = [_pos,false];
				if (((_pos select 2) - (_prevPos select 2)) >= 0.5) then {
					_result = [_prevPos, (_prevPos vectorAdd _vecDir)] call TSF_fnc_checkEHM;
					_add append _result;
				};
				(_x getVariable ["TSF_allPathMarkers", []]) pushBack _add; 
				if (_typeDir) then {(_x getVariable ["TSF_allWatchDirs", []]) pushBack [_pos,_endPoint]};
				if (_typeStance) then {
					(_x getVariable ["TSF_stanceChangePos", []]) pushBack _pos;
					(_x getVariable ["TSF_allStances", []]) pushBack _index;
				};
			};
		} forEach (groupSelectedUnits player);
		_prevPos = _pos;
	};
	uiSleep 0.2;
	_timer = _timer + 0.2;
};
TSF_pathDrawFPS = false;