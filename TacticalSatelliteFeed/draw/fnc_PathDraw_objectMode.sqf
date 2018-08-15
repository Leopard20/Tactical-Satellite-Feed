params ["_startPos", "_resetPos", "_unit", "_pathOffset", "_initDir"];
private ["_turn", "_posFinal", "_prevPosFinal", "_stopMove", "_number", "_unitPos", "_height", "_pos", "_prevPos", "_dist", "_uavPos", "_uavWatchDir", "_uavProjection", "_mouseProjection", "_proLine", "_cos", "_angle", "_offset", "_magnitude", "_dir"];
if !(alive _unit) exitWith {};
if (vehicle _unit == _unit) then {
	_weapon = [_unit] call TSF_fnc_getWeaponType;
	_stopMove = call compile format["TSF_%2_%1_NON_Anim",stance _unit, _weapon];
	_unit switchMove _stopMove;
};
doStop _unit;
_unit setVariable ["TSF_cancelMove", true];
_unit setVariable ["TSF_unitCustomWatchDir", -1];
if (!(player getVariable ["TSF_drawIndividualPath", true]) && (_unit != player getVariable ["TSF_lastDrawUnit", player])) then {
	(player getVariable ["TSF_lastDrawUnit", player]) setVariable ["TSF_drawPath", false];
	_unit setVariable ["TSF_drawPath", true];
	player setVariable ["TSF_lastDrawUnit", _unit];
};

_prevPosFinal = _startPos;
if !(isNil "_pathOffset") then {
	_normal = [90,(vectorNormalized _initDir)] call TSF_fnc_vectorRotation;
	_vecOffset = _normal apply {_x*_pathOffset};
	_startPos =  _startPos vectorAdd _vecOffset;
};
_path = (_unit getVariable ["TSF_allPathMarkers", []]);
//if ([0,0] in _path) then {_unit call TSF_fnc_clearInvalidPath};
if (_resetPos) then {
	_unit setVariable ["TSF_allPathMarkers", [[_startPos,TSF_ShiftHeld]]];
} else {
	(_unit getVariable ["TSF_allPathMarkers", []]) pushBack [_startPos,TSF_ShiftHeld];
};

//_pos = getMousePosition;
//_prevPos = screenToWorld _pos;
_pos = ATLToASL _startPos;
_uavPos = getPosASLVisual TSF_camera;
_line = lineIntersectsSurfaces [_uavPos,_pos, _unit, objNull, true, 1,"GEOM","FIRE", true];
_prevPos = if (count _line != 0) then {(_line select 0) select 0} else {_pos};

while {(!TSF_LclickButtonUp && TSF_CamActive)} do {
	_pos = getMousePosition;
	_pos = screenToWorld _pos;
	_pos = ATLToASL _pos;
	_uav = getPosASLVisual TSF_camera;
	_height = (_uav select 2) - (getTerrainHeightASL _uav);
	_isWater = surfaceIsWater _pos;
	_uavPos = getPosASLVisual TSF_camera;
	_line = lineIntersectsSurfaces [_uavPos,_pos, _unit, objNull, true, 1,"GEOM","FIRE", true];
	_pos = if (count _line != 0) then {(_line select 0) select 0} else {_pos};
	if (_prevPos distance2D _pos > _height/70+1) then {
		_posFinal = _pos;
		if !(surfaceIsWater _posFinal) then {_posFinal = ASLToATL _posFinal};
		_posFinal = _posFinal vectorAdd [0,0,0.15];
		if !(isNil "_pathOffset") then {
			_newDir = _posFinal vectorDiff _prevPosFinal;
			_prevPosFinal = _posFinal;
			_normal = [90,(vectorNormalized _newDir)] call TSF_fnc_vectorRotation;
			_vecOffset = _normal apply {_x*_pathOffset};
			_posFinal =  _posFinal vectorAdd _vecOffset;
		};
		(_unit getVariable ["TSF_allPathMarkers", []]) pushBack [_posFinal,TSF_ShiftHeld];
		_prevPos = _pos;
	};
	uiSleep 0.001;
	
};
if (!(isNil "_pathOffset") && TSF_hideLineInMultiPath) then {
	player setVariable ["TSF_drawAllLines", true];
};