params ["_unit", "_point1", "_point2", "_useEM"];
if (isNil "_useEM") then {_useEM = TSF_autoUseEnhancedMovement};
private ["_pos1", "_pos2", "_intersect", "_obj", "_hasTop", "_prevPoint", "_line", "_top"];
if !(surfaceIsWater _point1) then {_point1 = (ATLToASL _point1)};
if !(surfaceIsWater _point2) then {_point2 = (ATLToASL _point2)};
_intersect = [];
{ 

	_pos1 = _point1 vectorAdd [0,0,_x];
	_pos2 = _point2 vectorAdd [0,0,_x];
	_line = lineIntersectsSurfaces [_pos1,_pos2, _unit, objNull, true, -1,"GEOM","FIRE"];
	_intersect append _line;
} forEach [0.7,1.2,1.8];

_intersect = _intersect select {
	_obj = (_x select 3);
	!(isNull _obj) && !(_obj isKindOf "MAN")
};

_hasTop = false;
_top = [0,0,0];
_prevPoint = _point1;

if (count _intersect != 0 && _useEM && TSF_enhancedMovementAvailable) then {
	_unitVec = _point1 vectorFromTo _point2;
	_point = ((_intersect select 0) select 0) vectorAdd (_unitVec apply {_x*0.5});
	_prevPoint = _point vectorDiff _unitVec;
	_mod1 = _point vectorAdd [0,0,20];
	_mod2 = _point vectorAdd [0,0,-20];
	_lineTop = lineIntersectsSurfaces [_mod1, _mod2,_unit,objNull, true, 1, "GEOM", "FIRE"];
	_lineTop = _lineTop select {
		_obj = (_x select 3);
		!(isNull _obj) && !(_obj isKindOf "MAN")
	};
	if (count _lineTop != 0) then {
		_top = (_lineTop select 0) select 0;
		_hasTop = ((_top select 2) - (getTerrainHeightASL _point2)) <= 2.2;
		//_prevPoint set [2,_top select 2];
	};
};

_top = _top vectorAdd [0,0,1];

[_intersect, _hasTop, _top, _prevPoint]