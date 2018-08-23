TSF_cam_lockOn = 1 - TSF_cam_lockOn;
if (TSF_cam_lockOn == 0) then {
	if (TSF_planningMode) then {hintSilent "Planning Mode"} else {hintSilent "Free Movement Mode"};
	[] spawn 
	{
		private ["_height","_camWatchDir", "_pos", "_lockPos"];
		detach TSF_camera;
		TSF_UI_topM = 0.20*safeZoneH+TSF_safeY;
		TSF_UI_rightM = 0.75*safeZoneW+TSF_safeX;
		TSF_UI_bottomM = 0.80*safeZoneH+TSF_safeY;
		TSF_UI_leftM = 0.25*safeZoneW+TSF_safeX;
		_camWatchDir = vectorDirVisual TSF_camera;
		_camWatchDir set [2,0];
		_pos = getPosATLVisual TSF_AttachedTarget;
		_camPos = getPosATLVisual TSF_camera;
		_isWater = surfaceIsWater _camPos;
		if (_isWater) then {_camPos = getPosASLVisual TSF_camera};
		if (_isWater) then {_pos = getPosASLVisual TSF_AttachedTarget};
		_height = _pos select 2;
		_lockPos = if (surfaceIsWater _pos) then {_pos} else {ATLToASL _pos};
		TSF_camera lockCameraTo [_lockPos, [0]];
		TSF_camera setVariable ["TSF_FMM_pos", _pos];
		TSF_camera setVariable ["TSF_FMM_camWatchDir", _camWatchDir];
		waitUntil {!(TSF_cam_lockOn == 0 && TSF_camActive && !(isNull (findDisplay 53620)) && (getMousePosition select 0)>TSF_UI_rightM)};
		["TSF_camFreeMovement_EH", "onEachFrame", 
		{
			params ["_height"];
			private ["_lat", "_par", "_true", "_camWatchDir", "_pos", "_mouseX", "_mouseY", "_top", "_right", "_bottom", "_left", "_diffY", "_add", "_diffY", "_diff", "_angle"];
			if (TSF_cam_lockOn != 0 || !TSF_camActive || (isNull (findDisplay 53620))) exitWith {["TSF_camFreeMovement_EH", "onEachFrame"] call BIS_fnc_removeStackedEventHandler};
			if (TSF_ctrlHeld) exitWith {};
			_pos = TSF_camera getVariable "TSF_FMM_pos";
			_camWatchDir = TSF_camera getVariable "TSF_FMM_camWatchDir";
			_isWater = surfaceIsWater _pos;
			_camPos = getPosATLVisual TSF_camera;
			_isWater = surfaceIsWater _camPos;
			if (_isWater) then {_camPos = getPosASLVisual TSF_camera};
			
			
			_mouseX = getMousePosition select 0;
			_mouseY = getMousePosition select 1;
			
			_top = _mouseY <= TSF_UI_topM;
			
			_right = _mouseX >= TSF_UI_rightM;
			
			_bottom = _mouseY >= TSF_UI_bottomM;
			
			_left = _mouseX <= TSF_UI_leftM;
			_true = false;
			_par = false;
			_lat = false;
			if (_top && !_right && !_left) then {
				_diffY = TSF_UI_topM - _mouseY;
				if (TSF_AltHeld) then {
					_add = _camWatchDir;
					_par = true;
				} else {
					_add = _camWatchDir apply {_x*_diffY*3};
				};
				_true = true;
			};
			if (_top && _right) then {
				_diffX = _mouseX - TSF_UI_rightM;
				_diffY = TSF_UI_topM - _mouseY;
				_diff = sqrt (_diffY^2 + _diffX^2);
				_angle = _diffX atan2 _diffY;
				_dir = [-1*_angle, _camWatchDir] call TSF_fnc_vectorRotation;
				_add = _dir apply {_x*_diff*2};
				_true = true;
			};
			if (!_top && !_bottom && _left) then {
				_diffX = TSF_UI_leftM - _mouseX;
				if (TSF_AltHeld) then {
					_dist = _pos distance2D _camPos;
					_pos = _camPos;
					_pos set [2,_height];
					_camWatchDir = [2*_diffX, _camWatchDir] call TSF_fnc_vectorRotation;
					TSF_dirOffset = TSF_dirOffset - 2*_diffX;
					_add = _camWatchDir apply {_x*_dist};
					_lat = true;
				} else {
					_dir = [90, _camWatchDir] call TSF_fnc_vectorRotation;
					_add = _dir apply {_x*_diffX*2};
				};
				_true = true;
			};
			if (_top && _left) then {
				_diffX = TSF_UI_leftM - _mouseX;
				_diffY = TSF_UI_topM - _mouseY;
				_diff = sqrt (_diffY^2 + _diffX^2);
				_angle = _diffX atan2 _diffY;
				_dir = [_angle, _camWatchDir] call TSF_fnc_vectorRotation;
				_add = _dir apply {_x*_diff*2};
				_true = true;
			};
			if (!_top && !_bottom && _right) then {
				_diffX = _mouseX - TSF_UI_rightM;
				if (TSF_AltHeld) then {
					_dist = _pos distance2D _camPos;
					_pos = _camPos;
					_pos set [2,_height];
					_camWatchDir = [-2*_diffX, _camWatchDir] call TSF_fnc_vectorRotation;
					TSF_dirOffset = TSF_dirOffset + 2*_diffX;
					_add = _camWatchDir apply {_x*_dist};
					_lat = true;
				} else {
					_dir = [-90, _camWatchDir] call TSF_fnc_vectorRotation;
					_add = _dir apply {_x*_diffX*2};
				};
				_true = true;
			};
			if (_bottom && !_right && !_left) then {
				_diffY = TSF_UI_bottomM - _mouseY;
				if (TSF_AltHeld) then {
					_add = _camWatchDir apply {_x*-1};
					_par = true;
				} else {
					_add = _camWatchDir apply {_x*_diffY*3};
				};
				_true = true;
			};
			if (_bottom && _right) then {
				_diffX = _mouseX - TSF_UI_rightM;
				_diffY = _mouseY - TSF_UI_bottomM;
				_diff = sqrt (_diffY^2 + _diffX^2);
				_angle = _diffY atan2 _diffX;
				_dir = [(-1*_angle-90), _camWatchDir] call TSF_fnc_vectorRotation;
				_add = _dir apply {_x*_diff*2};
				_true = true;
			};
			if (_bottom && _left) then {
				_diffX = TSF_UI_leftM - _mouseX;
				_diffY = _mouseY - TSF_UI_bottomM;
				_diff = sqrt (_diffY^2 + _diffX^2);
				_angle = _diffY atan2 _diffX;
				_dir = [(_angle+90), _camWatchDir] call TSF_fnc_vectorRotation;
				_add = _dir apply {_x*_diff*2};
				_true = true;
			};
			if (_true) then {
				if (TSF_AltHeld) then {
					if (_par) then {
						_tempPos = _pos vectorAdd _add;
						_dist = _tempPos distance2D _camPos;
						if (_dist >= 7 && _dist <= 50) then {_pos = _tempPos};
					};
					if (_lat) then {
						_pos = _pos vectorAdd _add;
					};
					_lockPos = if (surfaceIsWater _pos) then {_pos} else {ATLToASL _pos};
					TSF_camera lockCameraTo [_lockPos, [0]];
				} else {
					_newPos = _camPos vectorAdd _add;
					_dists = [];
					{
						_dists pushBack (_x distance2D _newPos);
					} forEach (units group player);
					_dists sort true;
					_dist = _dists select 0;
					if ((_dist <= TSF_lockCamDistLimit) OR (TSF_lockCamDistLimit == 0)) then {
						_pos = _pos vectorAdd _add;
						if (_isWater) then {TSF_camera setPosASL _newPos} else {TSF_camera setPosATL _newPos};
						_lockPos = if (surfaceIsWater _pos) then {_pos} else {ATLToASL _pos};
						TSF_camera lockCameraTo [_lockPos, [0]];
					};
				};
			};
			TSF_camera setVariable ["TSF_FMM_pos", _pos];
			TSF_camera setVariable ["TSF_FMM_camWatchDir", _camWatchDir];
		}, [_height]] call BIS_fnc_addStackedEventHandler;
	};
} else {
	hintSilent "Locked Mode";
	TSF_camera attachTo [(vehicle TSF_AttachedTarget), [0, TSF_cam_YOffset, TSF_cam_ZOffset]]; 
	TSF_camera lockCameraTo [(vehicle TSF_AttachedTarget) , [0]];
	TSF_dirOffset = 0;
};