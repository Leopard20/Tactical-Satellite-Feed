params ["_theta", "_dirMatrix"];
private ["_result", "_row", "_add", "_rotMatrix"];
_rotMatrix = [[cos(_theta), -1*sin(_theta), 0], [sin(_theta), cos(_theta), 0], [0,0,1]];
_result = [];
for "_i" from 0 to 2 do 
{
	_row = _rotMatrix select _i;
	_add = 0;
	for "_j" from 0 to 2 do
	{
		_add = _add + (_row select _j)*(_dirMatrix select _j);
	};
	_result pushBack _add;
};
_result