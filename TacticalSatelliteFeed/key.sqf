disableSerialization;
waitUntil {!isNull(findDisplay 46)};  
_display = findDisplay 46;

if (_display getVariable ["TSF_KeyDownMain_EH", -1] == -1) then {
	_EH = _display displayAddEventHandler ["KeyDown","_this call TSF_fnc_keyDown"];
	_display setVariable ["TSF_KeyDownMain_EH", _EH];
};