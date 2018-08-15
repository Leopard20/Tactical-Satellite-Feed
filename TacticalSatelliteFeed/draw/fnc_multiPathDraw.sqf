private [
	"_array","_units", "_num", "_unitPos", "_height", "_posFinal", "_dist", "_uavPos", "_pos", "_angle", "_offset", "_dir", 
	"_magnitude", "_cos", "_proLine", "_mouseProjection", "_uavProjection", "_uavWatchDir", "_prevPos", "_finalVec", "_rotate"
	];
_units = TSF_allSelectedUnits;
TSF_multiDrawMode = true;
player setVariable ["TSF_multiDrawCanceled", false];
_units = _units - [player];
TSF_allSelectedUnits = [];
_unitPos = [0,0,0];
_pos = getMousePosition;
_prevPos = screenToWorld _pos;
_isWater = surfaceIsWater _prevPos;
{
	_add = if (_isWater) then {getPosASLVisual _x} else {getPosATLVisual _x};
	_unitPos = _unitPos vectorAdd _add;
	_x setVariable ["TSF_allPathMarkers", [[_add,TSF_ShiftHeld]]];
	_x setVariable ["TSF_cancelMove", true];
	doStop _x;
} forEach _units;
_unitPos = _unitPos apply {_x/(count _units)};


if (_prevPos distance2D _unitPos > 1) then {_height = _unitPos select 2;_prevPos set [2, _height]};
_count = count _units;
while {TSF_camActive && TSF_LclickButtonUp && TSF_RclickButtonUp} do {
	_pos = getMousePosition;
	_pos = screenToWorld _pos;	
	_pos vectorAdd [0,0,0.15];
	_dist = _prevPos distance2D _pos;
	_unitPos = [0,0,0];
	{
		_add = if (_isWater) then {getPosASLVisual _x} else {getPosATLVisual _x};
		_unitPos = _unitPos vectorAdd _add;
	} forEach _units;
	_unitPos = _unitPos apply {_x/_count};
	_height = _unitPos select 2;
	_mouseProjection = _pos select [0,2];
	_mouseProjection set [2, _height];
	if (_unitPos distance2D _mouseProjection > 0.5 OR _isWater) then {
		_uavPos = getPosATLVisual TSF_camera;
		if (_isWater) then {_uavPos = getPosASLVisual TSF_camera};
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
	_unitPos = [0,0,0];
	{
		_add = if (_isWater) then {getPosASLVisual _x} else {getPosATLVisual _x};
		_unitPos = _unitPos vectorAdd _add;
	} forEach _units;
	_unitPos = _unitPos apply {_x/_count};
	_vecDiff = _posFinal vectorDiff _unitPos;
	_vecDiff = vectorNormalized _vecDiff;
	_normal = [90,_vecDiff] call TSF_fnc_vectorRotation;
	_array = [];
	{
		_unitPos = if (_isWater) then {getPosASLVisual _x} else {getPosATLVisual _x};
		_array pushBack [((_posFinal vectorDiff _unitPos) vectorCos _normal),_x];
	} forEach _units;
	_array = [_array,[],{_x select 0},"ASCEND"] call BIS_fnc_sortBy;
	_units = _array apply {_x select 1};
	_multi = if (TSF_ctrlHeld) then {3} else {1};
	if (TSF_AltHeld) then {_finalVec = _vecDiff} else {_finalVec = _normal};
	for "_i" from 0 to _count-1 do
	{
		_unit = _units select _i;
		_diff = _count/2 - _i + 1;
		_offset = _finalVec apply {_x*_diff*_multi};
		_pos =  _posFinal vectorAdd _offset;
		(_unit getVariable ["TSF_allPathMarkers", []]) set [1, [_pos,TSF_ShiftHeld]];
	};
	sleep 0.001;
};

if !(player getVariable ["TSF_multiDrawCanceled", false]) then {
	_unitPos = [0,0,0];
	{
		_add = if (_isWater) then {getPosASLVisual _x} else {getPosATLVisual _x};
		_unitPos = _unitPos vectorAdd _add;
	} forEach _units;
	_unitPos = _unitPos apply {_x/_count};
	_vecDiff = _posFinal vectorDiff _unitPos;
	_vecDiff = vectorNormalized _vecDiff;
	_normal = [90,_vecDiff] call TSF_fnc_vectorRotation;
	_array = [];
	{
		_unitPos = if (_isWater) then {getPosASLVisual _x} else {getPosATLVisual _x};
		_array pushBack [((_posFinal vectorDiff _unitPos) vectorCos _normal),_x];
	} forEach _units;
	_array = [_array,[],{_x select 0},"ASCEND"] call BIS_fnc_sortBy;
	_units = _array apply {_x select 1};
	_multi = if (TSF_ctrlHeld) then {3} else {1};
	_rotate = true;
	if (TSF_AltHeld) then {_finalVec = _vecDiff; _rotate = false} else {_finalVec = _normal};
	for "_i" from 0 to _count-1 do
	{
		_unit = _units select _i;
		_diff = _count/2 - _i + 1;
		(_unit getVariable ["TSF_allPathMarkers", []]) deleteAt 1;
		[_posFinal, false,_unit, _diff*_multi, _finalVec, _rotate] spawn TSF_fnc_PathDraw;
	};
	if (TSF_hideLineInMultiPath) then {player setVariable ["TSF_drawAllLines", false]};
} else {
	{
		(_x getVariable ["TSF_allPathMarkers", []]) deleteAt 1;
		(_x getVariable ["TSF_allPathMarkers", []]) deleteAt 0;
	} forEach _units;
};
TSF_multiDrawMode = false;