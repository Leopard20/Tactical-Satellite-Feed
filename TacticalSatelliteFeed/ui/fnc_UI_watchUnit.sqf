private _unitNum = _this + 10*TSF_menuNumber;
if (count TSF_numberedUnits >= _unitNum) then {
	private _unit = TSF_numberedUnits select (_unitNum-1);
	if !(isNull _unit) then {
		if (TSF_pathDrawFPS) then {
			TSF_allSelectedUnits pushBackUnique _unit;
			_unit setVariable ["TSF_cancelMove", true];
			if (count (_unit getVariable ["TSF_allPathMarkers", []]) == 0) then {
				_pos = getPosATLVisual _unit;
				if (surfaceIsWater _pos) then {_pos = getPosASLVisual _unit};
				_unit setVariable ["TSF_allPathMarkers", [[_pos, false]]];
			};
		} else {
			TSF_cam_lockOn = 1;
			TSF_AttachedTarget = _unit;
			TSF_camera attachTo [(vehicle TSF_AttachedTarget), [0, TSF_cam_YOffset, TSF_cam_ZOffset]]; 
			TSF_camera lockCameraTo [(vehicle TSF_AttachedTarget) , [0]];
			TSF_dirOffset = 0;
		};
	};
};