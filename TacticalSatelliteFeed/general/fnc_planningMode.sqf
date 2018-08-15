if !(TSF_planningMode) then {
	TSF_planningMode = true;
	hintSilent "Planning Mode";
	if (TSF_cam_lockOn == 1) then {call TSF_fnc_UI_lockCam};
} else {
	hintSilent "Quick Draw Mode";
	TSF_planningMode = false;
};