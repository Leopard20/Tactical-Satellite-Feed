params ["_startPos", "_resetPos", "_unit", "_pathOffset", "_normal", "_rotate"];
private [
	"_turn", "_posFinal", "_prevPosFinal", "_stopMove", "_number", "_unitPos", "_height", "_pos", "_prevPos", "_dist", "_uavPos", "_uavWatchDir",
	"_uavProjection", "_mouseProjection", "_proLine", "_cos", "_angle", "_offset", "_magnitude", "_dir", "_vecOffset" ,"_newDir"];
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

_pos = getMousePosition;
_prevPos = screenToWorld _pos;
_isWater = surfaceIsWater _prevPos;
_unitPos = getPosATLVisual _unit;
if (_isWater) then {_unitPos = getPosASLVisual _unit};

_height = _unitPos select 2;
if (_prevPos distance2D _unitPos > 1) then {_height = _unitPos select 2;_prevPos set [2, _height]};

while {(!TSF_LclickButtonUp && TSF_CamActive)} do {
	_pos = getMousePosition;
	_pos = screenToWorld _pos;
	_isWater = surfaceIsWater _pos;
	_unitPos = if (_isWater) then {getPosASLVisual _unit} else {getPosATLVisual _unit};
	_pos vectorAdd [0,0,0.15];
	_dist = _prevPos distance2D _pos;
	_height = _unitPos select 2;
	_mouseProjection = _pos select [0,2];
	_mouseProjection set [2,_height];
	_unitHeight = (getPosASLVisual _unit) select 2;
	_terrainHeight = getTerrainHeightASL _unitPos;
	_delH = abs (_unitHeight - _terrainHeight);
	if (_dist > _height/22+1) then {
		if (_delH > 1 OR _isWater) then {
			_uavPos = if (_isWater) then {getPosASLVisual TSF_camera} else {getPosATLVisual TSF_camera};
			_uavWatchDir = _pos vectorDiff _uavPos;
			_uavProjection = [(_uavPos select 0), (_uavPos select 1), _height];
			_proLine = _mouseProjection vectorDiff _uavProjection;
			_cos = _proLine vectorCos _uavWatchDir;
			_angle = acos(_cos);
			_offset = (_uavPos select 2)-_height;
			_magnitude = _offset/tan(_angle);
			_dir = vectorNormalized _proLine;
			_dir = _dir apply {_x*_magnitude};
			_posFinal = _uavProjection vectorAdd _dir;
		} else {
			_posFinal = _pos vectorAdd [0,0,0.15];
		};
		
		if !(isNil "_pathOffset") then {
			_newDir = _posFinal vectorDiff _prevPosFinal;
			_prevPosFinal = _posFinal;
			_normal = vectorNormalized _newDir;
			if (_rotate) then {_normal = [90,_normal] call TSF_fnc_vectorRotation};
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