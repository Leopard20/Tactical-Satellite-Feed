disableSerialization;
private ["_EH"];
if (player getVariable ["TSF_CamDrawDot",-1] == -1) then {
	_EH = addMissionEventHandler ["Draw3D", 
		{
			_var = player getVariable ["TSF_drawAllPath", true];
			if ((isNull (findDisplay 53620)) OR !_var) exitWith {};
			private ["_unit", "_unitNumber", "_path", "_pos", "_alpha", "_TSF_TEAM_COLOR", "_TSF_ASSIGNED_TEAM_COLOR", "_TSF_PATH_MARKER", "_isIn", "_height", "_point"];
			{
				_unit = _x;
				if (_unit getVariable ["TSF_drawPath", true]) then {
					_path = (_unit getVariable ["TSF_allPathMarkers", []]) apply {_x select 0};
					_unit_stanceChangePos = (_unit getVariable ["TSF_stanceChangePos", []]);
					_TSF_ASSIGNED_TEAM_COLOR = _unit getVariable ["TSF_ASSIGNED_TEAM_COLOR", ""];
					{
						_point = _x;
						if (_point isEqualTo 0) exitWith {};
						_alpha = 0.6;	
						_isIn = [_point] call TSF_fnc_renderCheck;
						if (_isIn) then {
							_pos = getMousePosition;
							_H1 = screenToWorld [TSF_safeX,TSF_safeY];
							_H2 = screenToWorld [TSF_safeX,TSF_safeYM];
							_dist = _H1 distance2D _H2;
							_pointPos = worldToScreen _point; 
							if (_point in _unit_stanceChangePos) then {
								_index = _unit_stanceChangePos find _point;
								if (_pos distance2D _pointPos < 1/95*TSF_maxSafeDist) then {_alpha = 0.8; TSF_cursorDot = [_point, _unit]};
								_TSF_TEAM_COLOR = [0.1,0.1,0.1,_alpha];
								_stance = (_unit getVariable ["TSF_allStances", []]) select _index;
								_stanceIcon = [TSF_STAND_ICON, TSF_CROUCH_ICON, TSF_PRONE_ICON] select _stance;
								_height = if (_dist < 29) then {29/_dist} else {1};
								drawIcon3D[_stanceIcon, [1,1,1,1], _point, _height, _height, 0, ""];
								_height = if (_dist < 29) then {29/_dist*0.8} else {0.8};
							} else {						
								if (_pos distance2D _pointPos < 1/95*TSF_maxSafeDist) then {_alpha = 1; TSF_cursorDot = [_point, _unit]};										
								_TSF_TEAM_COLOR = [1,1,1,_alpha];
								if (_TSF_ASSIGNED_TEAM_COLOR == "GREEN") then {_TSF_TEAM_COLOR = [0,0.8,0,_alpha];};
								if (_TSF_ASSIGNED_TEAM_COLOR == "RED") then {_TSF_TEAM_COLOR = [1,0,0,_alpha];};
								if (_TSF_ASSIGNED_TEAM_COLOR == "BLUE") then {_TSF_TEAM_COLOR = [0,0,1,_alpha];};
								if (_TSF_ASSIGNED_TEAM_COLOR == "YELLOW") then {_TSF_TEAM_COLOR = [0.8,0.8,0,_alpha];};
							_height = if (_dist < 29) then {29/_dist*0.25} else {0.25};
							};
							drawIcon3D[TSF_PATH_ICON, _TSF_TEAM_COLOR, _point, _height, _height, 0, ""];
						};
					} forEach _path;
				};
			} forEach TSF_playerTeam;
	}];
	player setVariable ["TSF_CamDrawDot", _EH];
};


if (player getVariable ["TSF_CamDrawLine",-1] == -1) then {
	if (TSF_useLineOrIcon) then {

		_EH = addMissionEventHandler ["Draw3D", 
		{
			_var = (player getVariable ["TSF_drawAllPath", true]) && (player getVariable ["TSF_drawAllLines", true]);
			if ((isNull (findDisplay 53620)) OR !_var) exitWith {};
			private ["_dupe", "_rightArrow", "_leftArrow", "_addLeft", "_addStraight", "_addRight", "_midPoint", "_midPoint2", "_point5", "_point7", 
			"_point6", "_point8", "_unitNumber", "_count", "_alpha", "_TSF_TEAM_COLOR", "_TSF_ASSIGNED_TEAM_COLOR", "_point1", "_point2", "_isIn1", "_isIn2", 
			"_diff", "_dir", "_half"];
			{
				_unit = _x;
				if (_unit getVariable ["TSF_drawPath", true]) then {
					_path = (_unit getVariable ["TSF_allPathMarkers", []]) apply {_x select 0};
					_count = count _path;
					_TSF_ASSIGNED_TEAM_COLOR = _unit getVariable ["TSF_ASSIGNED_TEAM_COLOR", ""];
					for "_i" from 0 to _count-1 do
					{
						_alpha = 1;					
						_TSF_TEAM_COLOR = [1,1,1,_alpha];
						if (_TSF_ASSIGNED_TEAM_COLOR == "GREEN") then {_TSF_TEAM_COLOR = [0,0.8,0,_alpha];};
						if (_TSF_ASSIGNED_TEAM_COLOR == "RED") then {_TSF_TEAM_COLOR = [1,0,0,_alpha];};
						if (_TSF_ASSIGNED_TEAM_COLOR == "BLUE") then {_TSF_TEAM_COLOR = [0,0,1,_alpha];};
						if (_TSF_ASSIGNED_TEAM_COLOR == "YELLOW") then {_TSF_TEAM_COLOR = [0.8,0.8,0,_alpha];};
						_point1 = _path select _i;
						_point2 = _path select (_i+1);
						if (isNil "_point2") then {_point2 = _point1};
						_isIn1 = [_point1] call TSF_fnc_renderCheck;
						_isIn2 = [_point2] call TSF_fnc_renderCheck;
						if (_isIn1 OR _isIn2) then {
							_diff = _point2 vectorDiff _point1;
							_dir = vectorNormalized _diff;
							_half = _diff apply {_x/2};
							_dupe = [90, _dir] call TSF_fnc_vectorRotation;
							_leftArrow = [-155, _dir] call TSF_fnc_vectorRotation;
							_rightArrow = [155, _dir] call TSF_fnc_vectorRotation;
							_addStraight =  _dupe apply {_x*0.02};
							_addLeft =  _leftArrow apply {_x*0.25};
							_addRight =  _rightArrow apply {_x*0.25};
							_point3 = _point1 vectorAdd _addStraight;
							_point4 = _point2 vectorAdd _addStraight;
							_midPoint = _point1 vectorAdd _half;
							_midPoint2 = _midPoint vectorAdd _addStraight;
							_point5 = _midPoint vectorAdd _addLeft;
							_point6 = _midPoint2 vectorAdd _addRight;
							_point7 = _midPoint2 vectorAdd _addLeft;
							_point8 = _midPoint vectorAdd _addRight;
							drawLine3D[_point1,_point2,_TSF_TEAM_COLOR];
							drawLine3D[_point3,_point4,_TSF_TEAM_COLOR];
							drawLine3D[_midPoint,_point5,_TSF_TEAM_COLOR];
							drawLine3D[_midPoint2,_point6,_TSF_TEAM_COLOR];
							drawLine3D[_midPoint2,_point7,_TSF_TEAM_COLOR];
							drawLine3D[_midPoint,_point8,_TSF_TEAM_COLOR];
						};
					};
				};
			} forEach TSF_playerTeam;
		}];
		player setVariable ["TSF_CamDrawLine", _EH];

	} else {
	_EH = addMissionEventHandler ["Draw3D", 
		{
			_var = (player getVariable ["TSF_drawAllPath", true]) && (player getVariable ["TSF_drawAllLines", true]);
			if ((isNull (findDisplay 53620)) OR !_var) exitWith {};
			private ["_unitNumber", "_count", "_alpha", "_TSF_TEAM_COLOR", "_TSF_ASSIGNED_TEAM_COLOR", "_point1", "_point2", "_isIn1", "_isIn2", 
			"_diff", "_pos", "_half", "_TSF_PATH_MARKER", "_angle", "_H1", "_H2", "_dist", "_height", "_dir", "_UIdist", "_arrowMarker", "_multi"];
			{
				_unit = _x;
				if (_unit getVariable ["TSF_drawPath", true]) then {
					_path = (_unit getVariable ["TSF_allPathMarkers", []]) apply {_x select 0};
					_count = count _path;
					_shifts = (_unit getVariable ["TSF_allPathMarkers", []]) apply {_x select 1};
					_TSF_ASSIGNED_TEAM_COLOR = _unit getVariable ["TSF_ASSIGNED_TEAM_COLOR", ""];
					for "_i" from 0 to _count-1 do
					{
						_alpha = 0.3;
						_TSF_TEAM_COLOR = [1,1,1,_alpha];
						if (_TSF_ASSIGNED_TEAM_COLOR == "GREEN") then {_TSF_TEAM_COLOR = [0,0.8,0,_alpha];};
						if (_TSF_ASSIGNED_TEAM_COLOR == "RED") then {_TSF_TEAM_COLOR = [1,0,0,_alpha];};
						if (_TSF_ASSIGNED_TEAM_COLOR == "BLUE") then {_TSF_TEAM_COLOR = [0,0,1,_alpha];};
						if (_TSF_ASSIGNED_TEAM_COLOR == "YELLOW") then {_TSF_TEAM_COLOR = [0.8,0.8,0,_alpha];};
						//_TSF_PATH_MARKER = MISSION_ROOT + "marker\arrow3.paa";
						_point1 = _path select _i;
						_point2 = _path select (_i+1);
						_shift = _shifts select _i;
						if !(isNil "_point2") then {
							_isIn1 = [_point1] call TSF_fnc_renderCheck;
							_isIn2 = [_point2] call TSF_fnc_renderCheck;
							_isIn1 = true;
							_isIn2 = true;
							if (_isIn1 && _isIn2) then {
								_diff = _point2 vectorDiff _point1;
								_angle = -1*(_diff select 0) atan2 (_diff select 1);
								_half = _diff apply {_x/2};
								_pos = _point1 vectorAdd _half;
								_H1 = screenToWorld [TSF_safeX,TSF_safeY];
								_H2 = screenToWorld [TSF_safeX,TSF_safeYM];
								_dir = getDir TSF_camera;
								_angle = _angle + _dir + TSF_dirOffset;
								_dist = _point1 distance2D _point2;
								_arrowMarker = TSF_SMALL_ARROW_ICON;
								_multi = 1;
								if (_dist >= 1.4 && _dist < 2) then {_arrowMarker = TSF_MEDIUM_ARROW_ICON; _multi = 1.33};
								if (_dist >= 2 && _dist < 4) then {_arrowMarker = TSF_LARGE_ARROW_ICON; _multi = 2};
								if (_dist >= 4) then {_arrowMarker = TSF_veryLARGE_ARROW_ICON; _multi = 4};
								_arrowMarker = if (_shift) then {_arrowMarker select 1} else {_arrowMarker select 0};
								_UIdist = _H1 distance2D _H2;
								_height = 28/_UIdist*_multi*0.95;
								drawIcon3D[_arrowMarker, _TSF_TEAM_COLOR, _pos, _height, _height, _angle, ""];
							};
						};
					};
				};
			} forEach TSF_playerTeam;
		}];
		player setVariable ["TSF_CamDrawLine", _EH];
	};
};

if (player getVariable ["TSF_watchDirLine",-1] == -1) then {
	_EH = addMissionEventHandler ["Draw3D", 
		{
			_var = player getVariable ["TSF_drawAllPath", true];
			if ((isNull (findDisplay 53620)) OR !_var) exitWith {};
			private ["_dupe", "_rightArrow", "_leftArrow", "_addLeft", "_addStraight", "_addRight", "_point5", "_point7", "_point6", 
			"_point8", "_unitNumber", "_alpha", "_TSF_TEAM_COLOR", "_TSF_ASSIGNED_TEAM_COLOR", "_point1", "_point2", "_isIn1", "_dir"];
			{
				_unit = _x;
				_watchDirs = _unit getVariable ["TSF_allWatchDirs", []];
				_TSF_ASSIGNED_TEAM_COLOR = _unit getVariable ["TSF_ASSIGNED_TEAM_COLOR", ""];
				{
					if (_x isEqualTo -1) exitWith {};
					_alpha = 1;	
					_TSF_TEAM_COLOR = [1,1,1,_alpha];
					if (_TSF_ASSIGNED_TEAM_COLOR == "GREEN") then {_TSF_TEAM_COLOR = [0,0.8,0,_alpha];};
					if (_TSF_ASSIGNED_TEAM_COLOR == "RED") then {_TSF_TEAM_COLOR = [1,0,0,_alpha];};
					if (_TSF_ASSIGNED_TEAM_COLOR == "BLUE") then {_TSF_TEAM_COLOR = [0,0,1,_alpha];};
					if (_TSF_ASSIGNED_TEAM_COLOR == "YELLOW") then {_TSF_TEAM_COLOR = [0.8,0.8,0,_alpha];};
					_point1 = _x select 0;
					_point2 = _x select 1;
					_isIn1 = [_point1] call TSF_fnc_renderCheck;
					if (_isIn1) then {
						_dir = vectorNormalized (_point2 vectorDiff _point1);
						_dupe = [90, _dir] call TSF_fnc_vectorRotation;
						_leftArrow = [-155, _dir] call TSF_fnc_vectorRotation;
						_rightArrow = [155, _dir] call TSF_fnc_vectorRotation;
						_addStraight =  _dupe apply {_x*0.02};
						_addLeft =  _leftArrow apply {_x*0.5};
						_addRight =  _rightArrow apply {_x*0.5};
						_point3 = _point1 vectorAdd _addStraight;
						_point4 = _point2 vectorAdd _addStraight;
						_point5 = _point2 vectorAdd _addLeft;
						_point6 = _point4 vectorAdd _addRight;
						_point7 = _point4 vectorAdd _addLeft;
						_point8 = _point2 vectorAdd _addRight;
						drawLine3D[_point1,_point2,_TSF_TEAM_COLOR];
						drawLine3D[_point3,_point4,_TSF_TEAM_COLOR];
						drawLine3D[_point2,_point5,_TSF_TEAM_COLOR];
						drawLine3D[_point4,_point6,_TSF_TEAM_COLOR];
						drawLine3D[_point4,_point7,_TSF_TEAM_COLOR];
						drawLine3D[_point2,_point8,_TSF_TEAM_COLOR];
					};
				} forEach _watchDirs;
			} forEach TSF_playerTeam;
	}];
	player setVariable ["TSF_watchDirLine", _EH];
};

if (player getVariable ["TSF_unitDraw",-1] == -1) then {
	_EH = addMissionEventHandler ["Draw3D", 
		{
			if (isNull (findDisplay 53620)) exitWith {};
			{
				_TSF_UNITPOS = getPosASLVisual _x;
				if !(surfaceIsWater _TSF_UNITPOS) then {_TSF_UNITPOS = getPosATLVisual _x};
				//_scanPos = [(_TSF_UNITPOS select 0), (_TSF_UNITPOS select 1),(_TSF_UNITPOS select 2)+5];
				//_isIn = [_scanPos] call TSF_fnc_renderCheck;
				//if !(_isIn) exitWith {};
				_TSF_UNITPOS_SC = worldToScreen _TSF_UNITPOS;
				if (count _TSF_UNITPOS_SC == 0) then {_TSF_UNITPOS_SC = [0.5,0.5]};
				_pos = getMousePosition;
				_TSF_ASSIGNED_TEAM_COLOR = _x getVariable ["TSF_ASSIGNED_TEAM_COLOR", ""];
				_alpha = 0.5;
				_number = [_x] call TSF_fnc_getUnitNumber;
				if (_pos distance2D _TSF_UNITPOS_SC < 1/48*TSF_maxSafeDist && !(isPlayer _x)) then {_alpha = 0.9; TSF_cursorUnit = _x};
				_TSF_TEAM_COLOR = [1,1,1,_alpha];
				if (_TSF_ASSIGNED_TEAM_COLOR == "GREEN") then {_TSF_TEAM_COLOR = [0,0.8,0,_alpha];};
				if (_TSF_ASSIGNED_TEAM_COLOR == "RED") then {_TSF_TEAM_COLOR = [1,0,0,_alpha];};
				if (_TSF_ASSIGNED_TEAM_COLOR == "BLUE") then {_TSF_TEAM_COLOR = [0,0,1,_alpha];};
				if (_TSF_ASSIGNED_TEAM_COLOR == "YELLOW") then {_TSF_TEAM_COLOR = [0.8,0.8,0,_alpha];};
				drawIcon3D[TSF_UNIT_ICON, _TSF_TEAM_COLOR, _TSF_UNITPOS, 1, 1, 0, "", 0, 0.0315, "TahomaB", "center", true];
				drawIcon3D["",_TSF_TEAM_COLOR, _TSF_UNITPOS, 1, 1, 0, format["%1 - %2", _number, name _x]];
			} forEach TSF_playerTeam;
	}];
	player setVariable ["TSF_unitDraw", _EH];
};


if (player getVariable ["TSF_actionLineDraw",-1] == -1) then {
	_EH = addMissionEventHandler ["Draw3D", 
		{
			_var = player getVariable ["TSF_drawAllPath", true];
			if ((isNull (findDisplay 53620)) OR !_var) exitWith {};
			private ["_dupe", "_addStraight", "_unitNumber", "_alpha", "_color", "_point1", "_point2", "_isIn1", "_dir", "_point3", "_point4", "_isFinal"];
			{
				_ACTIONS = _x getVariable ["TSF_allActions", []];
				{
					if (_x isEqualTo -1) exitWith {};	
					_color = [0.9,0,1,1];
					_point1 = _x select 0;
					_point2 = _x select 1;
					_action = _x select 2;
					if (_point2 isEqualTo []) exitWith {};
					_isFinal = _x select 3;
					if (_isFinal && (_action == 1 OR _action == 0)) then {_point2 = getPosATLVisual _point2; if (surfaceIsWater _point2) then {_point2 = getPosASLVisual _x}};
					_isIn1 = [_point1] call TSF_fnc_renderCheck;
					_isIn2 = [_point2] call TSF_fnc_renderCheck;
					if (_isIn1 OR _isIn2) then {
						
						_text = ["Mount", "Attack", "Go-code A", "Go-code B", "Go-code C", "Open Fire", "Hold Fire"] select _action;
						if (_action == 0 OR _action == 1) then {
							_dir = vectorNormalized (_point2 vectorDiff _point1);
							_dupe = [90, _dir] call TSF_fnc_vectorRotation;
							_addStraight =  _dupe apply {_x*0.02};
							_point3 = _point1 vectorAdd _addStraight;
							_point4 = _point2 vectorAdd _addStraight;
							drawLine3D[_point1,_point2,_color];
							drawLine3D[_point3,_point4,_color];
						};
						_point1 = _point1 vectorAdd (vectorDir TSF_camera);
						_color = [0.9,0,1,0.6];
						drawIcon3D["", _color, _point1, 1, 1, 0, _text];
					};
				} forEach _ACTIONS;
			} forEach TSF_playerTeam;
	}];
	player setVariable ["TSF_actionLineDraw", _EH];
};



if (player getVariable ["TSF_syncLineDraw",-1] == -1) then {
	_EH = addMissionEventHandler ["Draw3D", 
		{
			_var = player getVariable ["TSF_drawAllPath", true];
			if ((isNull (findDisplay 53620)) OR !_var) exitWith {};
			private ["_dupe", "_rightArrow", "_leftArrow", "_addLeft", "_addStraight", "_addRight", "_point5", "_point7", "_point6", 
			"_point8", "_unitNumber", "_alpha", "_color", "_TSF_ASSIGNED_TEAM_COLOR", "_point1", "_point2", "_isIn1", "_dir"];
			{
				if (_x isEqualTo -1 OR _x isEqualTo [0,0]) exitWith {};	
				_color = [0,0.2,0.8,1];
				_point1 = _x select 0;
				_point2 = _x select 1;
				_isIn1 = [_point1] call TSF_fnc_renderCheck;
				_isIn2 = [_point2] call TSF_fnc_renderCheck;
				if (_isIn1 OR _isIn2) then {
					_dir = vectorNormalized (_point2 vectorDiff _point1);
					_dupe = [90, _dir] call TSF_fnc_vectorRotation;
					_addStraight =  _dupe apply {_x*0.02};
					_point3 = _point1 vectorAdd _addStraight;
					_point4 = _point2 vectorAdd _addStraight;
					drawLine3D[_point1,_point2,_color];
					drawLine3D[_point3,_point4,_color];
				};
			} forEach TSF_allSyncedDots;
	}];
	player setVariable ["TSF_syncLineDraw", _EH];
};




if (player getVariable ["TSF_actionVehDraw",-1] == -1) then {
	_EH = addMissionEventHandler ["Draw3D", 
		{
			_var = player getVariable ["TSF_drawAllPath", true];
			if ((isNull (findDisplay 53620)) OR !_var OR !TSF_ActionSelectMode) exitWith {};
			{
				_veh = _x select 0;
				_icon = _x select 1;
				_side = _x select 2;
				_VehPos = getPosATLVisual _veh;
				if (surfaceIsWater _VehPos) then {_VehPos = getPosASLVisual _veh};
				_isIn1 = [_VehPos] call TSF_fnc_renderCheck;
				//_isIn1 = true;
				if (_isIn1) then {
					_name = getText (configFile >>  "CfgVehicles" >> (typeOf _veh) >> "displayName");
					_posScreen = worldToScreen _VehPos;
					_pos = getMousePosition;
					_alpha = 0.5;
					if (_pos distance2D _posScreen < 1/48*TSF_maxSafeDist) then {_alpha = 0.9; TSF_cursorActionTarget = _veh};
					_color = [1,1,1,_alpha];
					if (_side == 1) then {_color = [0,0,0.9,_alpha];}; //west
					if (_side == 0) then {_color = [0.9,0,0,_alpha];}; //east
					if (_side == 2) then {_color = [0.9,0,1,_alpha];}; //civ
					if (_side == 3) then {_color = [0,0.9,0,_alpha];}; //res
					drawIcon3D[_icon, _color, _VehPos, 1, 1, 0, _name];
				};
			} forEach TSF_nearestVehicles;
	}];
	player setVariable ["TSF_actionVehDraw", _EH];
};



if (player getVariable ["TSF_actionTargetDraw",-1] == -1) then {
	_EH = addMissionEventHandler ["Draw3D", 
		{
			_var = player getVariable ["TSF_drawAllPath", true];
			if ((isNull (findDisplay 53620)) OR !_var OR !TSF_ActionSelectMode) exitWith {};
			{
				_target = _x;
				_targetPos = getPosATLVisual _target;
				if (surfaceIsWater _targetPos) then {_targetPos = getPosASLVisual _target};
				_isIn1 = [_targetPos] call TSF_fnc_renderCheck;
				//_isIn1 = true;
				if (_isIn1) then {
					_name = getText (configFile >>  "CfgVehicles" >> (typeOf _target) >> "displayName");
					_posScreen = worldToScreen _targetPos;
					_pos = getMousePosition;
					_alpha = 0.5;
					if (_pos distance2D _posScreen < 1/48*TSF_maxSafeDist) then {_alpha = 0.9; TSF_cursorActionTarget = _target};
					_color = [1,1,1,_alpha];
					drawIcon3D[TSF_TARGET_ICON, _color, _targetPos, 1.5, 1.5, 0, _name];
				};
			} forEach TSF_nearestEnemies;
	}];
	player setVariable ["TSF_actionTargetDraw", _EH];
};
true