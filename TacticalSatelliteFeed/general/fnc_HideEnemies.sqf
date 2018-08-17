TSF_allNearbyEnemies = [];

[] spawn {
	while {!isNull (findDisplay 53620)} do 
	{
		_distantUnits = [player];
		{
			if (_x distance2D player > 100) then {_distantUnits pushBack _x};
			
		} forEach (units group player);
		{
			TSF_allNearbyEnemies pushBackUnique _x;
			_unit = _x;
			_nearbyEnemies = nearestObjects [_unit, ["allVehicles"], 300, true]; 
			_unitTargets = _unit targets [];
			_nearbyEnemies = _nearbyEnemies select {!(_x isEqualTo TSF_camera) && alive _x && !(_x isKindOf "Animal") && ([(side _x), (side player)] call BIS_fnc_sideIsEnemy) && (_x != assignedTarget _unit)};
			{
				_nme = _x;
				if (_nme getVariable ["TSF_EnemyLTS", -1] == -1) then {_nme setVariable ["TSF_EnemyLTS", -20]};
				if !(_nme in TSF_hiddenEnemyUnits) then {
					_kn = [];
					{_kn pushBack (_x knowsAbout _nme)} forEach units group player;
					_kn sort false;
					_targets = (_nme targets []) select {side _x == side player && (_x distance2D _nme < 200) && time-abs((_x targetKnowledge _nme) select 3) > 20};
					_cond = (_kn select 0 <= 2.1) && (count _targets == 0);
					if (time - (_nme getVariable ["TSF_EnemyLTS", 0]) > 20 && _cond) then {
						_x hideObject true;
						TSF_hiddenEnemyUnits pushBack _nme;
					};
				};
			} forEach _nearbyEnemies;
		} forEach _distantUnits;
		uiSleep 5;
	};
};

[] spawn 
{
	while {!isNull (findDisplay 53620)} do 
	{
		{
			_nme = _x;
			_kn = [];
			{_kn pushBack (_x knowsAbout _nme)} forEach units group player;
			_kn sort false;
			_targets = (_nme targets []) select {side _x == side player && (_x distance2D _nme < 200) && time-abs((_x targetKnowledge _nme) select 3) > 20};
			_cond = (_kn select 0 <= 2.1) && (count _targets == 0) && (alive _nme);
			if (time - (_nme getVariable ["TSF_EnemyLTS", 0]) <= 20 OR !_cond) then {
				_x hideObject false;
				TSF_hiddenEnemyUnits =  TSF_hiddenEnemyUnits - [_nme];
			};
		
		} forEach TSF_hiddenEnemyUnits;
		uiSleep 1;
	};
};

[] spawn 
{
	while {!isNull (findDisplay 53620)} do 
	{
		{
			_nme = _x;
			{
				_unit = _x;
				_true = [_unit, _nme] call TSF_fnc_checkLOS;
			} forEach (units group player);
			
		} forEach TSF_allNearbyEnemies;
		
		uiSleep 1;
	};
};