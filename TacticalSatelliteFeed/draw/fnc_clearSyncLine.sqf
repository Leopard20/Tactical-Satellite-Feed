private ["_point", "_points", "_countPath", "_count", "_path", "_points1", "_point2", "_skipNext", "_points2", "_delete", "_point1", "_toDelete"];
_count = count TSF_allSyncedDots;
_points = TSF_allSyncedDots;
_points1 = TSF_allSyncedDots apply {_x select 0};
_points2 = TSF_allSyncedDots apply {_x select 1};
_toDelete = [];
for "_i" from 0 to _count-1 do {
	_point = _points select _i;
	if (count _point == 4) then {
		_point1 = _points1 select _i;
		_point2 = _points2 select _i;
		_countPath = count TSF_numberedUnits;
		_skipNext = false;
		if (_point1 isEqualTo 0) then {_toDelete pushBack _i; _skipNext = true;};
		if !(_skipNext) then {
			_delete = true;
			for "_unitNum" from 0 to _countPath-1 do {
				_unit = TSF_numberedUnits select _unitNum;
				_path = (_unit getVariable ["TSF_allPathMarkers", []]) apply {_x select 0};
				if (_point1 in _path OR _point2 in _path) exitWith {
					_delete = false;
				};
			};
			if (_delete) then {_toDelete pushBackUnique _i};
		};
	};
};
{
	TSF_allSyncedDots deleteAt _x;
} forEach _toDelete;