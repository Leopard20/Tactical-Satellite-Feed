params ["_unit"];

private [
	"_isWater","_assignedTeam", "_LOSTarget", "_nearbyEnemies","_engage", "_actionPos","_actionType", "_actionTarget","_target", "_action","_unitConfused",
	"_skipNext", "_sprint1", "_syncPoints1", "_syncPoints2", "_syncedUnit1", "_syncedUnit2" ,"_dist","_customStance","_stanceNum","_dir", "_FullMove", 
	"_unitNumber","_path","_unit_stanceChangePos","_match","_point1","_point2","_stance","_index","_moveDir","_dir2","_watchDir", "_selectedStance", 
	"_stanceUnit", "_unitInwater", "_baseMove", "_EH", "_watchPos", "_timer", "_unitSetPos", "_playerGrp", "_tempGrp", "_initCount", "_multi", "_weapon", 
	"_lastTime", "_depth", "_hasNade", "_grenade", "_mode"
	];
	
if !(alive _unit) exitWith {};
if (vehicle _unit != _unit) then {doGetOut _unit};
waitUntil {vehicle _unit == _unit}; 
_unit setVariable ["TSF_cancelMove", false];
[_unit] spawn TSF_fnc_correctPath;
_path = _unit getVariable ["TSF_allPathMarkers", []];
if (count _path == 0) exitWith {_unit setVariable ["TSF_cancelMove", true]};

_unit disableAI "MOVE";
_unit disableAI "AUTOTARGET";
_unit disableAI "AUTOCOMBAT";
_unit setVariable ["TSF_unitChangingMove", false];
if (_unit getVariable ["TSF_AnimChangedEH", -1] == -1) then {
	_EH = _unit addEventHandler ["AnimChanged", {
		_unitA = _this select 0;
		_animA = _this select 1;
		if (_unitA getVariable ["TSF_unitChangingMove", false]) then {
			_move = _unitA getVariable ["TSF_assignedMove", ""];
			if (_move != _animA && _move != "") then {_unitA playMoveNow _move};
		};
	}];
	_unit setVariable ["TSF_AnimChangedEH", _EH];
};
_unitConfused = false;
_unit setVariable ["TSF_unitState", 1];
_unit setVariable ["TSF_unitTarget", objNull];
_unit setVariable ["TSF_unitCustomWatchDir", -1];
_unit setVariable ["TSF_unitCustomStance", ""];
_unit setVariable ["TSF_weaponType" , ""];
_initCount = count _path;
_unit setVariable ["TSF_unitHoldFire", 0];
_unit setVariable ["TSF_unitIsTurning", false];
_unit setVariable ["TSF_unitEngaging", false];
_unit doTarget objNull;
_unit doFire objNull;

if (behaviour _unit == "COMBAT") then 
{
	_assignedTeam = _unit getVariable ["TSF_ASSIGNED_TEAM_COLOR", "MAIN"];
	_playerGrp = group _unit;
	_tempGrp = createGroup (side _unit);
	[_unit] joinSilent _tempGrp;
	_tempGrp setBehaviour "AWARE";
	[_unit] joinSilent _playerGrp;
	deleteGroup _tempGrp;
	_unit assignTeam _assignedTeam;
};

_action = -1;

while {count (_unit getVariable ["TSF_allPathMarkers", []]) != 0 && !(_unit getVariable ["TSF_cancelMove", false]) && alive _unit} do
{
	//is unit busy?
	if (_unit getVariable ["TSF_unitState", 1] != 0) then {
		_path = _unit getVariable ["TSF_allPathMarkers", []];
		_count = count (_unit getVariable ["TSF_allPathMarkers", []]);
		_unit setVariable ["TSF_unitEngaging", false];
		_point1 = (_path select 0) select 0;
		_isWater = surfaceIsWater _point1;
		if (isNil "_point1") exitWith {};
		
		
		_syncPoints = TSF_allSyncedDots select {count _x == 4};
		_syncPoints1 = [];
		_syncPoints2 = [];
		if (count _syncPoints != 0) then {
			_syncPoints1 = _syncPoints apply {_x select 0};
			_syncPoints2 = _syncPoints apply {_x select 1};
			_syncedUnit1 = _syncPoints apply {_x select 2};
			_syncedUnit2 = _syncPoints apply {_x select 3};
		
		};
		
		
		_sprint1 = (_path select 0) select 1;
		_point2 = (_path select 1) select 0;
		if (isNil "_point2") then {_point2 = _point1};
		

		_allActions = (_unit getVariable ["TSF_allActions", []]) select {(_x select 3)};
		_actionPos = [];
		if (count _allActions != 0) then {
			_actionPos = _allActions apply {_x select 0};
			_actionTarget = _allActions apply {_x select 1};
			_actionType = _allActions apply {_x select 2};
		};
		
		
		_nearbyEnemies = nearestObjects [_unit, ["allVehicles"], 300, true]; 
		if !((secondaryWeapon _unit) isKindOf ["Launcher", configFile >> "CfgWeapons"]) then {_nearbyEnemies = _nearbyEnemies select {!(_x isKindOf "HELICOPTER") && !(_x isKindOf "PLANE") && !(_x isKindOf "TANK") && !(_x isKindOf "APC") && !(_x isKindOf "CAR")}};
		_nearbyEnemies = _nearbyEnemies select {alive _x && !(_x isKindOf "Animal") && ([(side _x), (side player)] call BIS_fnc_sideIsEnemy) && (count (crew vehicle _x)) != 0};
		
		_unitInwater = false;
		_unitPos = if (_isWater) then {getPosASLVisual _unit} else {getPosATLVisual _unit};
		_depth = getTerrainHeightASL _unitPos;
		if (_isWater && (_unitPos select 2) <= 0 && _depth <= -1.8) then {_unitInwater = true};
		
		
		if (count (_path select 0) >= 3 && TSF_enhancedMovementAvailable) then {
			_unit setVariable ["TSF_unitState", 5];
		};
		_weapon = _unit getVariable ["TSF_weaponType" , ""];
		if (_weapon == "") then {_weapon = [_unit] call TSF_fnc_getWeaponType};
		switch (_unit getVariable ["TSF_unitState", 1]) do 
		{
		
		
		
		
		
		
			//rotate unit
			case 1:				
			{
				_unit setVariable ["TSF_unitState", 0];
				_unit_watchPos = (_unit getVariable ["TSF_allWatchDirs", []]) apply {_x select 0};
				_unit setVariable ["TSF_unitChangingMove", false];
				_unit_stanceChangePos = (_unit getVariable ["TSF_stanceChangePos", []]);
				_customStance = false;
				_moveDir = _point2 vectorDiff _unitPos;
				if !(_unitInwater) then {
					if (_point1 in _unit_stanceChangePos) then {
						_index = _unit_stanceChangePos find _point1;
						_stanceNum = (_unit getVariable ["TSF_allStances", []]) select _index;
						_selectedStance = ["STAND", "CROUCH", "PRONE"] select _stanceNum;
						_unit setVariable ["TSF_unitCustomStance", _selectedStance];
						if (_selectedStance != stance _unit) then {
							_customStance = true;
						};
					} else {
						if ((_unit getVariable ["TSF_unitCustomStance", ""]) == "") then {_selectedStance = stance _unit} else {_selectedStance = _unit getVariable "TSF_unitCustomStance"}
					};
					_unit setVariable ["TSF_unitStance", _selectedStance];
					if ((_point1 in _unit_watchPos) && !_sprint1) then {
						_index = _unit_watchPos find _point1;
						_endPoint = (_unit getVariable ["TSF_allWatchDirs", []]) select _index;
						_endPoint = _endPoint select 1;
						_watchDir = _endPoint vectorDiff _point1;
						_unit setVariable ["TSF_unitCustomWatchDir", _watchDir];
					} else {
						if (((_unit getVariable ["TSF_unitCustomWatchDir", -1]) isEqualTo -1) OR _sprint1) then {
							_watchDir = _moveDir;
						};
						if !((_unit getVariable ["TSF_unitCustomWatchDir", -1]) isEqualTo -1)  then {
							_watchDir = _unit getVariable "TSF_unitCustomWatchDir";
						};
					};
					_dir = [_unitPos, _point2, _watchDir, _unitInwater] call TSF_fnc_getWatchMoveDir;
					doStop _unit;
					if (_unit getVariable ["TSF_cancelMove", false]) exitWith {};
					_unit setVariable ["TSF_unitIsTurning", false];
					[_unit,_watchDir, _selectedStance] spawn TSF_fnc_rotateUnit;
					_unit setVariable ["TSF_unitWatchDir", _watchDir];
					//while {alive _unit && (_unit getVariable ["TSF_unitIsTurning", false])} do {uiSleep 0.02};
					_sprText = ["slow", "Fast"] select ([false, true] find _sprint1);
					_baseMove = call compile format["TSF_Base_%3_%1_%2_Anim",_selectedStance, _sprText, _weapon];

				} else {
					_baseMove = TSF_SWIM_FORWARD_Anim;
					_dir = "";
					_watchDir = _moveDir;
					_selectedStance = "UNDEFINED";
					_unit setVariable ["TSF_unitCustomWatchDir", -1];
					_unit setVariable ["TSF_unitStance", _selectedStance];
					_unit setVariable ["TSF_unitCustomStance", ""];
					_unit setVariable ["TSF_unitWatchDir", _watchDir];
					_unit setPosASLW [_unitPos select 0, _unitPos select 1, -2];
				};
				_unitSetPos = ["UP", "MIDDLE", "DOWN", "AUTO"] select (["STAND", "CROUCH", "PRONE", "UNDEFINED"] find _selectedStance);
				_FullMove = _baseMove + _dir;
				_unit setVariable ["TSF_assignedMove", _FullMove];
				_unit setVariable ["TSF_baseMove", _baseMove];
				if (_unitConfused && !_customStance) then {_unit switchMove _FullMove; _unitConfused = false};
				_unit setVariable ["TSF_unitState", 2];
			};
			
			
			
			
			
			
			//select action
			case 2:				
			{
				_unit setVariable ["TSF_unitState", 0];
				_action = -1;
				_unit setVariable ["TSF_unitChangingMove", false];
				_selectedStance = _unit getVariable "TSF_unitStance";
				if (_point1 in _actionPos) then {
					_index = _actionPos find _point1;
					_action = _actionType select _index;
					_target = _actionTarget select _index;
				};

				if (_count != 1 && _action == 0) then {hintSilent "You can only perform a mount action at the end of the unit path."};
				if (_action == 5 OR _action == 6) then {
					_tempGrp = createGroup (side _unit);
					_assignedTeam = _unit getVariable ["TSF_ASSIGNED_TEAM_COLOR", "MAIN"];
					_playerGrp = group _unit;
					[_unit] joinSilent _tempGrp;
					_mode = ["RED", "GREEN"] select (_action-5);
					_unit setVariable ["TSF_unitHoldFire", (_action-5)];
					_tempGrp setCombatMode _mode;
					[_unit] joinSilent _playerGrp;
					_unit assignTeam _assignedTeam;
					deleteGroup _tempGrp;
					doStop _unit;
					_unit doWatch objNull;
					_unit doTarget objNull;
					_unit doFire objNull;
				};
				if (_action == 1) then {
					_unit setVariable ["TSF_unitTarget", _target];
					_unit setVariable ["TSF_unitTargetLTS", time];
				};
				if (_action == 7) then {
					_unit setVariable ["TSF_grenadeTarget" , _target];
				};
				if ((_unit getVariable ["TSF_unitAction", -1]) == 7) then {
				
					//throw grenade
					_target = _unit getVariable "TSF_grenadeTarget";
					_hasNade = false;
					_grenade = objNull;
					{
						_isThrowable = _x call BIS_fnc_isThrowable;
						if (_isThrowable) exitWith {_hasNade = true; _grenade = _x};
					} forEach (magazines _unit);
					if (_hasNade) then {
						_stopMove = call compile format["TSF_%2_%1_NON_Anim",_selectedStance, _weapon];
						_unit setVariable ["TSF_unitChangingMove", false];
						_unit switchMove _StopMove;
						[_unit,(_target vectorDiff _unitPos), _selectedStance] spawn TSF_fnc_rotateUnit;
						while {alive _unit && (_unit getVariable ["TSF_unitIsTurning", false])} do {uiSleep 0.02};
						_unit doWatch _target;
						_EH = _unit addEventHandler ["fired", 
						{
							params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
							_muzzles = getArray (configfile >> "CfgWeapons" >> "Throw" >> "muzzles");
							if (_muzzle in _muzzles) then {
								_target = _unit getVariable "TSF_grenadeTarget";
								_v = (_target) vectorDiff (getPosATLVisual _unit);
								_v set [2,0];
								_range = ((vectorMagnitude _v) max 5) min 40;
								_v = vectorNormalized _v;
								_speed = sqrt(_range*6);
								_v set [2,1/sqrt(2)];
								_v = _v apply {_x * _speed};
								_projectile setVelocity _v;
							};
							_unit removeEventHandler ["Fired", (_unit getVariable ["TSF_unitFiredEH", -1])];
							_unit setVariable ["TSF_unitFiredEH", -1];
						}];
						_unit setVariable ["TSF_unitFiredEH", _EH];
						_unit forceWeaponFire ["HandGrenadeMuzzle","HandGrenadeMuzzle"];
						_unit forceWeaponFire ["MiniGrenadeMuzzle","MiniGrenadeMuzzle"];
						_muzzles = getArray (configfile >> "CfgWeapons" >> "Throw" >> "muzzles");
						{
							_mags = getArray (configfile >> "CfgWeapons" >> "Throw" >> _x >> "magazines");
							if (_grenade in _mags) then {_unit forceWeaponFire [_x,_x]};
						} forEach _muzzles;
						uiSleep 1;
						[_unit,(_unit getVariable "TSF_unitWatchDir"), _selectedStance] spawn TSF_fnc_rotateUnit;
					};
				};
				
				
				_unit setVariable ["TSF_unitAction", _action];
				if (_action == 2 OR _action == 3 OR _action == 4) then {
					
					_stopMove = call compile format["TSF_%2_%1_NON_Anim",stance _unit, _weapon];
					_unit switchMove _stopMove;
					[_unit, _action] spawn TSF_fnc_waitForGoCode;
				} else {
					_unit setVariable ["TSF_unitState", 3];
				}
				
			};
			
			
			
			
			
			
			
			
			//wait for sync
			case 3:				
			{
				_unit setVariable ["TSF_unitState", 0];
				_unit setVariable ["TSF_unitChangingMove", false];
				_skipNext = false;
				_clearSync = false;
				_goNext = true;
				
				_stopMove = call compile format["TSF_%2_%1_NON_Anim",stance _unit, _weapon];
				if (_point1 in _syncPoints1) then {
					_skipNext = true;
					_index = (_syncPoints1 find _point1);
					_syncUnit = _syncedUnit2 select _index; 
					if !(_unit getVariable ["TSF_waitingUnit", objNull] isEqualTo _syncUnit) then {
						_goNext = false;
						_syncUnit setVariable ["TSF_waitingUnit", _unit];
						_unit setVariable ["TSF_unitOktoMove", false];
						[_unit, _syncUnit] spawn TSF_fnc_waitOnSync;
						_unit switchMove _stopMove;
					} else {
						_unit setVariable ["TSF_waitingUnit", objNull];
						_syncUnit setVariable ["TSF_unitOktoMove", true];
					};
				};
				if (_point1 in _syncPoints2 && !_skipNext) then {
					_index = (_syncPoints2 find _point1);
					_syncUnit = _syncedUnit1 select _index; 
					if !(_unit getVariable ["TSF_waitingUnit", objNull] isEqualTo _syncUnit) then {
						_goNext = false;
						_syncUnit setVariable ["TSF_waitingUnit", _unit];
						_unit setVariable ["TSF_unitOktoMove", false];
						[_unit, _syncUnit] spawn TSF_fnc_waitOnSync;
						_unit switchMove _stopMove;
					} else {
						_unit setVariable ["TSF_waitingUnit", objNull];
						_syncUnit setVariable ["TSF_unitOktoMove", true];
					};
				};
				if (_goNext) then {_unit setVariable ["TSF_unitState", 4]};
			};
			
			
			
			
			
			
			//_move unit
			case 4:				
			{
				_unit setVariable ["TSF_unitState", 0];
				_unit playMoveNow (_unit getVariable "TSF_assignedMove");
				_unit setVariable ["TSF_unitChangingMove", true];
				_unit setUnitPos _unitSetPos;
				_firstDot = false;
				if (_count == _initCount) then {_firstDot = true};
				if (_count == 1) then {
					_unit setVariable ["TSF_allPathMarkers", []];
					_count = count (_unit getVariable ["TSF_allPathMarkers", []]);
				} else {
					//if ([0,0] in (_unit getVariable ["TSF_allPathMarkers", []])) then {_unit call TSF_fnc_clearInvalidPath}; 
					(_unit getVariable ["TSF_allPathMarkers", []]) deleteAt 0;
				};
				_time = time;
				_rotation = 1;
				_baseMove = _unit getVariable "TSF_baseMove";
				_watchDir = _unit getVariable "TSF_unitWatchDir";
				_engage = [true, false] select (_unit getVariable ["TSF_unitHoldFire", 0]);
				if (behaviour _unit == "STEALTH" && isNull(_unit getVariable ["TSF_unitTarget", objNull])) then {_engage = false};
				if (_unitInwater) then {_engage = false};
				_inLOS = _nearbyEnemies select {[_unit, _x] call TSF_fnc_checkLOS}; 
				_men = _inLOS select {_x isKindOf "MAN"};
				_veh = _inLOS - _men;
				_men = [_men,[],{_unit distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
				_veh = [_veh,[],{_unit distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
				_inLOS = _men + _veh;
				if (count _inLOS == 0) then {_LOSTarget = objNull} else {_LOSTarget = _inLOS select 0};
				
				_selectedStance = _unit getVariable "TSF_unitStance";
				_walkBase  = call compile format["TSF_Base_%2_%1_WALK_Anim",_selectedStance,_weapon];
				_prevMove = "";
				_lastTime = _time;
				_timer = 0;
				_moveDir = _point2 vectorDiff _point1;
				_assignedTarget = _unit getVariable ["TSF_unitTarget", objNull];
				_originalWatchDir = _watchDir;
				_watchPos = (_unit getVariable "TSF_unitWatchDir") vectorAdd (eyePos _unit);
				if !(_isWater) then {_watchPos = ASLToATL _watchPos};
				_unit doWatch _watchPos;
				_multi = if (_selectedStance == "PRONE") then {2} else {1};
				while {(_unit distance2D _point2 > 1.1) && !(_unit getVariable ["TSF_cancelMove", false]) && alive _unit} do {
					if (currentCommand _unit != "STOP" OR !alive _unit) exitWith {(_unit setVariable ["TSF_cancelMove", true])};
					if !(_unit getVariable ["TSF_unitEngaging", false]) then {
						_unitPos = if (_isWater) then {getPosASLVisual _unit} else {getPosATLVisual _unit};
						if (_engage && !_firstDot && _timer < 8) then {
							_assignedTarget = _unit getVariable ["TSF_unitTarget", objNull];
							_result = [_unit, _assignedTarget, _LOSTarget, _originalWatchDir, _point2, _selectedStance, _rotation, _isWater, _unitInwater, _time, _lastTime] call TSF_fnc_moveUnit;
							_FullMove = _result select 0;
							_rotation = _result select 1;
							_lastTime = _result select 2;
							_unit setVariable ["TSF_unitChangingMove", true];
							_unit setVariable ["TSF_assignedMove", _FullMove];
							_unit disableAI "MOVE";
						} else {
							if (time - _time > 3*_rotation*_multi || (_rotation > 1 && time - _lastTime > 1)) then {
								_rotation = _rotation + 1; 
								_ok1 = [_unit, primaryWeapon _unit] call TSF_fnc_checkWeapon;
								if (_ok1) then {_unit selectWeapon (primaryWeapon _unit)} else {_unit selectWeapon (handgunWeapon _unit)};
								_watchDir = _point2 vectorDiff _unitPos; 
								if !(_unit getVariable ["TSF_unitIsTurning", false]) then {[_unit, _watchDir, _selectedStance] spawn TSF_fnc_rotateUnit};
								_unitConfused = true;
								_lastTime = time;
							}  else {_watchDir = _originalWatchDir};
							_unit setVariable ["TSF_unitWatchDir", _watchDir];
							_dir = [_unitPos, _point2, _watchDir, _unitInwater] call TSF_fnc_getWatchMoveDir;
							_FullMove = _baseMove + _dir;
							_unit setVariable ["TSF_assignedMove", _FullMove];
							_unit setVariable ["TSF_unitChangingMove", true];
							_unit doFire objNull;
							_watchPos = _watchDir vectorAdd (eyePos _unit);
							if !(_isWater) then {_watchPos = ASLToATL _watchPos};
							_unit doWatch _watchPos;
							_unit setVariable ["TSF_weaponType" , ""];
						};
						
					};
					_unit playMoveNow (_unit getVariable "TSF_assignedMove");
					_unit setUnitPos _unitSetPos;
					uiSleep 0.1; 
					_timer = _timer + 0.1;
				};
				if (_unit getVariable ["TSF_unitEngaging", false]) then {
					_unitPos = if (_isWater) then {getPosASLVisual _unit} else {getPosATLVisual _unit};
					_dir = [_unitPos, _point2, (_unit getVariable "TSF_unitWatchDir"), _unitInwater] call TSF_fnc_getWatchMoveDir;
					_FullMove = _walkBase + _dir;
					_unit setVariable ["TSF_unitChangingMove", true];
					_unit setVariable ["TSF_assignedMove", _FullMove];
					_unit playMoveNow _FullMove;
					_unit setVariable ["TSF_unitEngaging", false];
				};
				_unit setVariable ["TSF_unitState", 6];
			};
			
			
			
			
			// Enhanced Movement
			case 5:	
			{
				_unit setVariable ["TSF_unitState", 0];
				_selectedStance = _unit getVariable "TSF_unitStance";
				if (_selectedStance == "PRONE") then {
					_move = TSF_PRONE_To_STAND_Anim;
					_unit setVariable ["TSF_assignedMove", _move];
					_unit playMoveNow _move;
					_unit setUnitPos "UP";
					_selectedStance = "STAND";
					uiSleep 1.5;
				};
				_stopMove = call compile format["TSF_%2_%1_NON_Anim",_selectedStance, _weapon];
				_unit setVariable ["TSF_unitChangingMove", false];
				_unit switchMove _StopMove;
				_unit setVariable ["TSF_unitIsClimbing", true];
				uiSleep 0.05;
				[_unit,_moveDir, _selectedStance] spawn TSF_fnc_rotateUnit;
				while {alive _unit && (_unit getVariable ["TSF_unitIsTurning", false])} do {uiSleep 0.001};
				switch (count (_path select 0)) do {
					case 5:
					{
						//_unit setVariable ["TSF_unitIsClimbing",true,false];
						_call = (_path select 0) select [2,3];
						_call pushBack _unit;
						_call call TSF_fnc_EM;
					};
					
					case 4:
					{
						//_unit setVariable ["TSF_unitIsClimbing",true,false];
						_anm = (_path select 0) select 3;
						_dpos = (_path select 0) select 2;
						[ (format ["EH_em_drop%1",([_unit] call TSF_fnc_getUnitNumber)]) , {animationState (_condpars select 0) == (_condpars select 1)}, [_unit, _anm], "TSF_fnc_exec_drop", [_dpos, _unit], true, "TSF_fnc_finish_drop", [_unit], 0] call babe_core_fnc_addEH;
						_result = [_dpos,_anm];
						_unit playMoveNow _anm;
					};
					
					case 3:
					{
						_top = (_path select 0) select 2;
						
						_pos = if (_isWater) then {_point1} else {ATLToASL _point1};
						[_pos, true, _top, _unit] call TSF_fnc_EM;
					};
				};
				if (_count == 1) then {
					_unit setVariable ["TSF_allPathMarkers", []];
					_count = count (_unit getVariable ["TSF_allPathMarkers", []]);
				 } else {
					//if ([0,0] in (_unit getVariable ["TSF_allPathMarkers", []])) then {_unit call TSF_fnc_clearInvalidPath}; 
					(_unit getVariable ["TSF_allPathMarkers", []]) deleteAt 0;
				 };
				_timer = 0;
				_limit = if (_selectedStance == "CROUCH") then {4} else {2.5};
				_initLimit = _limit;
				while {(_unit getVariable ["TSF_unitIsClimbing", false]) && alive _unit && !(_unit getVariable ["TSF_cancelMove", false])} do
				{
					uiSleep 0.05;
					if (((animationState _unit) select [12, 1]) == "h") then {_limit = _initLimit*2};
					_timer = _timer + 0.05;
					if (_timer >= _limit) exitWith {};
				};
	
				waitUntil {(animationState _unit) select [0,4] != "babe"};
				_unit setVariable ["TSF_unitState", 6];
			};
			case 6:
			{
				[] spawn TSF_fnc_clearSyncLine;
				[] spawn TSF_fnc_clearActionLine;
				[] spawn TSF_fnc_clearWatchLine;
				_unit setVariable ["TSF_unitState", 1];
			};
		};
	};
	uiSleep 0.02;
};

[] spawn TSF_fnc_clearSyncLine;
[] spawn TSF_fnc_clearActionLine;
[] spawn TSF_fnc_clearWatchLine;


_unit enableAI "MOVE";
_unit enableAI "AUTOTARGET";
_unit enableAI "AUTOCOMBAT";


_unit setVariable ["TSF_unitCustomWatchDir", -1];
_unit setVariable ["TSF_unitChangingMove", false];
_unit setVariable ["TSF_assignedMove", ""];
_weapon = [_unit] call TSF_fnc_getWeaponType;
_stopMove = call compile format["TSF_%2_%1_NON_Anim",stance _unit, _weapon];
_unit playMoveNow _stopMove;
_EH = _unit getVariable "TSF_AnimChangedEH";
_unit removeEventHandler ["AnimChanged", _EH];
_unitPos = if (_isWater) then {getPosASLVisual _unit} else {getPosATLVisual _unit};
_unit doMove _unitPos;
if (player != leader group _unit) then {_unit doFollow (leader group _unit); _unit setUnitPos "AUTO"} else {doStop _unit};

if (_action == 0) then {[[_unit], _target, 0] spawn TSF_fnc_mountVehicle};
_unit setVariable ["TSF_cancelMove", true];
_target = _unit getVariable ["TSF_unitTarget", objNull];
_unit doTarget _target;
if ((_unit getVariable ["TSF_unitWatchDir", [0,0,0]]) isEqualTo [0,0,0]) then {_unit doWatch _target} else {
	_watchPos = ((_unit getVariable "TSF_unitWatchDir") apply {_x*10}) vectorAdd (eyePos _unit);
	if !(_isWater) then {_watchPos = ASLToATL _watchPos};
	_unit doWatch _watchPos;
};