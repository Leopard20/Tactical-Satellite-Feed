params ["_control", "_key", "_shift", "_ctrl", "_alt"];
private ["_pressedArray", "_userInput", "_userArray"];
_pressedArray = [_key, _shift, _ctrl, _alt];
_userInput = call compile TSF_showFeedKey;
_userInput params [
	["_userKey", 38, [0]],
	["_userShift", false, [false]],
	["_userCtrl", false, [false]],
	["_userAlt", false, [false]]
];
_userArray = [_userKey, _userShift, _userCtrl, _userAlt];
if (_pressedArray isEqualTo _userArray) then {
	[] call TSF_fnc_spawnCam;
};
false
