params ["_unit"];
private [
	"_unitPath", "_count", "_line", "_lastElement", "_point2", "_sprint", "_pos1", "_pos2", "_line1", "_skipNext", 
	"_lastTop", "_allPoints", "_originalSegments", "_surf"
	];
_unit setVariable ["TSF_pathSegments", []];
_unitPath = _unit getVariable ["TSF_allPathMarkers", []];
_count = count _unitPath;
if (_count <= 1) exitWith {};
_allPoints = [[]];
_originalSegments = [[]];
_lastElement = 0;
_skipNext = false;
//_lastObj = objNull;
_surf = [0,0,-1000];
_lastTop = _surf;
for "_i" from 0 to _count-2 do {
	_path1 = _unitPath select _i;
	_path2 = _unitPath select _i+1;
	_point1 = _path1 select 0;
	_point2 = _path2 select 0;
	_points = _allPoints select _lastElement;
	_segment = _originalSegments select _lastElement;
	_line1 = [_unit, _point1, _point2] call TSF_fnc_checkSurface;
	_line = _line1 select 0;
	_surf = if (count _line > 0) then {_line1 select 2} else {[0,0,-1000]};
	if (_skipNext && abs((_surf select 2) - (_lastTop select 2)) > 0.8) then {_skipNext = false} else {
	_hasTop = _line1 select 1;
	_top = _line1 select 2;
	_pos = _line1 select 3;
		if (count _line > 0 && count _path1 < 3) then {
			if (count _points == 0) then {_segment pushBack _path1; _points pushBack [_point1,_i, (_line select 0), _hasTop, _top, _pos]};
		} else {
			if (count _path1 >= 3) then {_segment pushBack _path1; _skipNext = true; _lastTop = _top} else {
				_pathToAdd = if (_i == _count-2 && !(isNil "_path2")) then {_path2} else {_path1};
				if (count _points == 1) then {_points pushBack [_point1,_path1 select 1]} else {_segment pushBack _pathToAdd}
			};		
		};
		_allPoints set [_lastElement, _points];
		_originalSegments set [_lastElement, _segment];
		if (_i == _count-2) exitWith {};
		if (count _points == 2) then {_lastElement = _lastElement + 1; _allPoints pushBack []; _originalSegments pushBack []};
	};
};

if (count (_allPoints select 0) == 0) exitWith {};
_segments = [];
{
	_segments pushBack [];
} forEach _originalSegments;

_unit setVariable ["TSF_pathSegments", _segments];


_correctSegment =
{
	params ["_unit", "_points", "_element"];
	private ["_lineSurf","_point1", "_scrDone", "_index", "_line1", "_point2", "_sprint", "_normal", "_arr"];
	if (count _points < 2) exitWith {};
	_point1 = (_points select 0) select 0;
	_index = (_points select 0) select 1;
	_hasTop = (_points select 0) select 3;
	_top = (_points select 0) select 4;
	_pos = (_points select 0) select 5;
	_line1 = (_points select 0) select 2;
	_point2 = (_points select 1) select 0;
	_sprint = (_points select 1) select 1;
	_arr = [];
	if (_hasTop) then {
		_factor = (_top select 2) - (getTerrainHeightASL _top);
		_topATL = ASLToATL _top;
		_height = if (surfaceIsWater _point1) then {_top select 2} else {_topATL select 2};
		_newPos = _pos;
		_newPos set [2,_height];
		
		_straight =  _newPos vectorFromTo _point2;
		_dist = floor(_newPos distance2D _point2);
		_newPos = _newPos vectorAdd _straight;
		_arr = [[[[_newPos, _sprint, _top]],_factor]];
		for "_i" from 2 to _dist do
		{
			_newPos = _newPos vectorAdd _straight;
			((_arr select 0) select 0) pushBack [_newPos, _sprint];
			//_line = [_unit, _newPos, _testPos] call TSF_fnc_checkSurface;
			//_hasTop = _line select 2;
			//if (_hasTop) then {
			//	_top = 
			//	_height = if (surfaceIsWater _point1) then {_top select 2} else {(ATLToASL _top) select 2};
			//};
		};	
	
	};
	_normal = _line1 select 1;
	_normal set [2,0];
	_textR = format ["TSF_unitPathRight%1", _element];
	_textL = format ["TSF_unitPathLeft%1", _element];
	_unit setVariable [_textR, []];
	_unit setVariable [_textL, []];
	_l = [_unit, _point1, _point2, _normal, _sprint, _textL] spawn {
		params ["_unit", "_point1", "_point2", "_normal", "_sprint", "_textL"];
		private ["_skip", "_newPos", "_straight", "_left", "_right", "_pos", "_testPos", "_lineSurf", "_lineObj", "_prevPos", "_time"];
		_skip = false;
		_newPos = _point1;
		_straight = _normal;
		_left = [];
		_time = time;
		_dist = _point1 distance2D _point2;
		_prevPos = _newPos;
		while {true} do 
		{
			_error = false;
			if (_skip) then {
				_newPos = _straight vectorAdd _newPos;
			} else {
				_pos = [90,_normal] call TSF_fnc_vectorRotation;
				_pos = _pos apply {_x*1.5};
				_testPos = _pos vectorAdd _newPos;
				_line = [_unit, _newPos, _testPos] call TSF_fnc_checkSurface;
				_lineSurf = _line select 0;
				if (count _lineSurf > 0) then {_error = true} else {_newPos = _testPos};
			};
			if (!_error && _newPos distance2D _prevPos >= 1) then {
				_straight = _newPos vectorFromTo _point2;
				_testPos1 = _newPos vectorDiff _straight;
				_testPos2 = (_straight vectorAdd _newPos) vectorAdd _straight;
				_left pushBack [_newPos, _sprint];
				_prevPos = _newPos;
				_line = [_unit, _testPos1, _testPos2] call TSF_fnc_checkSurface;
				_lineSurf = _line select 0;
			};
			if (count _lineSurf > 0) then {
				_normal = (_lineSurf select 0) select 1;
				_normal set [2,0];
				_skip = false;
			} else {
				_straight = _straight apply {_x*1.5};
				_skip = true;
			};
			if ((_newPos distance2D _point2 <= 1.5) OR (time-_time>2) OR (count _left > 10*_dist)) exitWith {_unit setVariable [_textL, _left]};
		};
		
	};
	
	_r = [_unit, _point1, _point2, _normal, _sprint, _textR] spawn {
		params ["_unit", "_point1", "_point2", "_normal", "_sprint", "_textR"];
		private ["_skip", "_newPos", "_straight", "_left", "_right", "_pos", "_testPos", "_lineSurf", "_lineObj", "_prevPos", "_time"];
		_right = [];
		_newPos = _point1;
		_skip = false;
		_straight = _normal;
		//_normal = _line1 select 1;
		_time = time;
		_dist = _point1 distance2D _point2;
		_prevPos = _point1;
		while {true} do 
		{
			_error = false;
			if (_skip) then {
				_newPos = _straight vectorAdd _newPos;
			} else {
				_pos = [-90,_normal] call TSF_fnc_vectorRotation;
				_pos = _pos apply {_x*1.5};
				_testPos = _pos vectorAdd _newPos;
				_line = [_unit, _newPos, _testPos] call TSF_fnc_checkSurface;
				_lineSurf = _line select 0;
				if (count _lineSurf > 0) then {_error = true} else {_newPos = _testPos};
			};
			if (!_error && _newPos distance2D _prevPos >= 1) then {
				_straight = _newPos vectorFromTo _point2;
				_testPos1 = _newPos vectorDiff _straight;
				_testPos2 = (_straight vectorAdd _newPos) vectorAdd _straight;
				_right pushBack [_newPos, _sprint];
				_prevPos = _newPos;
				_line = [_unit, _testPos1, _testPos2] call TSF_fnc_checkSurface;
				_lineSurf = _line select 0;
			};
			if (count _lineSurf > 0) then {
				_normal = (_lineSurf select 0) select 1;
				_normal set [2,0];
				_skip = false;
			} else {
				_straight = _straight apply {_x*1.5};
				_skip = true;
			};
			if ((_newPos distance2D _point2 <= 2) OR (time-_time>2) OR (count _right > 10*_dist)) exitWith {_unit setVariable [_textR, _right]};
		};
		
	};
	waitUntil {scriptDone _r OR scriptDone _l};
	_right = _unit getVariable _textR;
	_left = _unit getVariable _textL;
	_arr append [[_left,1], [_right,1]];
	_arr = _arr select {(count (_x select 0)) != 0};
	_arr = [_arr,[],{(count (_x select 0))*(_x select 1)},"ASCEND"] call BIS_fnc_sortBy;
	(_unit getVariable "TSF_pathSegments") set [_element, ((_arr select 0) select 0)];
	
};


_element = 0;
_scripts = [];
{
	_sc = [_unit, _x, _element] spawn _correctSegment;
	_scripts pushBack _sc;
	_element = _element + 1;
} forEach _allPoints;
{	
	waitUntil {(scriptDone _x) OR (_unit getVariable ["TSF_cancelMove", false])};
} forEach _scripts;


_path = [];
_unitPath = _unit getVariable ["TSF_allPathMarkers", []];
_segments = _unit getVariable ["TSF_pathSegments", []];
_element = 0;
{
	_seg = _x;
	_temp = [];
	{
		if (_x in _seg) then {_temp pushBack _x};
	} forEach _unitPath;
	if (count _temp != 0) then {_temp append (_segments select _element)};
	_originalSegments set [_element, _temp];
	_element = _element + 1;
} forEach _originalSegments;

{
	_path = _path + _x;
} forEach _originalSegments;
_unit setVariable ["TSF_allPathMarkers", _path];