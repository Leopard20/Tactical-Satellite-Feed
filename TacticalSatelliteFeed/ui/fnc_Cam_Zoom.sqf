params ["_zoom"];
if (_zoom > 0) then {
	TSF_cam_ZOffset = (TSF_cam_ZOffset + _zoom) min 95;
};
if (_zoom < 0) then {
	TSF_cam_ZOffset = (TSF_cam_ZOffset + _zoom) max 20;
};
if (_zoom == 0) then {
	TSF_cam_ZOffset = 35;
};
if (TSF_cam_lockOn == 1) then {
TSF_camera attachTo [(vehicle TSF_AttachedTarget), [0, TSF_cam_YOffset, TSF_cam_ZOffset]]; 
TSF_camera lockCameraTo [(vehicle TSF_AttachedTarget) , [0]];
TSF_dirOffset = 0;
} else {
	_pos = getPosATLVisual TSF_camera;
	if (surfaceIsWater _pos) then {
		_pos = getPosASLVisual TSF_camera;
		TSF_camera setPosASL [(_pos select 0),(_pos select 1),TSF_cam_ZOffset];
	} else {
		TSF_camera setPosATL [(_pos select 0),(_pos select 1),TSF_cam_ZOffset];
	};
};