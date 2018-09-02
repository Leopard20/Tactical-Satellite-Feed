private ["_selectedUnits","_vehrole", "_veh", "_vehclass", "_vehname", "_count", "_vehiclePositions", "_allTurrets", "_allCargo", "_allCoPilot",
 "_allDriver", "_allGunner", "_allCommander", "_copilot", "_gunner", "_driver", "_commander", "_turret", "_cargo", "_unitsToMount", "_unassigned", "_cond", "_exit", "_sideF", "_sideX"];
 _selectedUnits = _this select 0;
_veh = _this select 1;
_vehrole = _this select 2;
_exit = false;
{
	_sideF = side player;
	_sideX = side _x;
	_isEnemy = [_sideF, _sideX] call BIS_fnc_sideIsEnemy; //Checks if EAST is enemy to WEST. 
	if (_isEnemy) exitWith {_exit = true};
} forEach (crew _veh);
if (_exit) exitWith {};
_vehclass = typeOf _veh;
_vehname = getText (configFile >>  "CfgVehicles" >> _vehclass >> "displayName");
_getInFnc =
{
	private ["_time", "_unit", "_target", "_getInAs", "_posType", "_targetPos", "_size", "_distance", "_position", "_driver", "_commander", "_cargo", "_lastPos", "_type"];
	_unit = _this select 0;
	_target = _this select 1;
	_getInAs = _this select 2;
	_posType = _this select 3;
	_position = _this select 4;
	if (_target isKindOf "Staticweapon") then {_getInAs = 3};
	
	_type = typeOf _target;
	_bbr = boundingBoxReal _target; 
	_p1 = _bbr select 0; _p2 = _bbr select 1; 
	_maxWidth = abs ((_p2 select 0) - (_p1 select 0));
	_maxLength = abs ((_p2 select 1) - (_p1 select 1));
	_size = sizeOf _type;
	_distance = _maxWidth min _maxLength;
	_distance = _distance + 3;
	//_distance = _size/3+2;
	_unit setVariable ["TSF_Mount_Canceled", 0];
	waitUntil {uiSleep 0.1; _unit getVariable ["TSF_cancelMove", false]};
	_unit setVariable ["TSF_cancelMove", false];
	uiSleep 0.1;
	private _cond = ((vehicle _unit) isKindOf "Air" && (getPos (vehicle _unit)) select 2 > 0);
	if (vehicle _unit == _target OR _cond) exitWith {_unit setVariable ["TSF_Mount_Canceled", 1]};
	doStop _unit;
	if (_unit getVariable ["TSF_AnimChangedEH", -1] == -1) then {
		_EH = _unit addEventHandler ["AnimChanged", {
			_unitA = _this select 0;
			_animA = _this select 1;
			if (_unitA getVariable ["TSF_unitChangingMove", false]) then {
				_move = _unitA getVariable ["TSF_assignedMove", ""];
				if (_move != _animA) then {_unitA playMoveNow _move};
			
			}
		}];
		_unit setVariable ["TSF_AnimChangedEH", _EH];
	};
	uiSleep 0.2;
	_allPos = [];
	_pos = getText (configfile >> "CfgVehicles" >> (typeOf _target) >> "memoryPointsGetInDriver");
	if (_pos == "") then {_targetPos = getPosATLVisual _target} else {
		_targetPos = (_target modelToWorld (_target selectionPosition _pos));
	};
	_allPos pushBackUnique _targetPos;
	_pos = getText (configfile >> "CfgVehicles" >> (typeOf _target) >> "memoryPointsGetInCoDriver");
	if (_pos == "") then {_targetPos = getPosATLVisual _target} else {
		_targetPos = (_target modelToWorld (_target selectionPosition _pos));
	};
	_allPos pushBackUnique _targetPos;
	_pos = getText (configfile >> "CfgVehicles" >> (typeOf _target) >> "memoryPointsGetInCargo");
	if (_pos == "") then {_targetPos = getPosATLVisual _target} else {
		_targetPos = (_target modelToWorld (_target selectionPosition _pos));
	};
	_allPos pushBackUnique _targetPos;
	_allPos = [_allPos,[],{_unit distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
	_weapon = [_unit] call TSF_fnc_getWeaponType;
	_baseMove = call compile format["TSF_Base_%2_%1_Fast_Anim", stance _unit, _weapon];
	_FullMove = _baseMove + "f";
	
	uiSleep 0.2;
	_lastPos = getPosATLVisual _target;
	_unit setVariable ["TSF_assignedMove", _FullMove];
	_unit setVariable ["TSF_unitChangingMove", true];
	_unit doWatch _target;
	_unit disableAI "PATH";
	_time = time;
	while {currentCommand _unit == "STOP" && (_unit distance2D _target > _distance) && (alive _unit) && (alive _target) && !(_unit getVariable ["TSF_cancelMove", false]) && _time-time < 10} do 
	{
		if ((_target distance2D _lastPos) > 2) then {
			_allPos = [];
			_pos = getText (configfile >> "CfgVehicles" >> (typeOf _target) >> "memoryPointsGetInDriver");
			if (_pos == "") then {_targetPos = getPosATLVisual _target} else {
				_targetPos = (_target modelToWorld (_target selectionPosition _pos));
			};
			_allPos pushBackUnique _targetPos;
			_pos = getText (configfile >> "CfgVehicles" >> (typeOf _target) >> "memoryPointsGetInCoDriver");
			if (_pos == "") then {_targetPos = getPosATLVisual _target} else {
				_targetPos = (_target modelToWorld (_target selectionPosition _pos));
			};
			_allPos pushBackUnique _targetPos;
			_pos = getText (configfile >> "CfgVehicles" >> (typeOf _target) >> "memoryPointsGetInCargo");
			if (_pos == "") then {_targetPos = getPosATLVisual _target} else {
				_targetPos = (_target modelToWorld (_target selectionPosition _pos));
			};
			_allPos = [_allPos,[],{_unit distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
		};
		
		_targetPos = _allPos select 0;
		_moveDir = _targetPos vectorDiff (getPosATLVisual _unit);
		
		[_unit,_moveDir, (stance _unit)] spawn TSF_fnc_rotateUnit;
		while {alive _unit && (_unit getVariable ["TSF_unitIsTurning", false])} do {uiSleep 0.02};
		_unit playMove _FullMove;
		_lastPos = getPosATLVisual _target;
		uiSleep 0.1;
	};
	
	private _takenSeats = _target getVariable ["TSF_vehiclePreAssignedSeats", [0,0,0,0,0,0]];
	private _takenTurret = _takenSeats select 4;
	private _takenDriver = _takenSeats select 0;
	private _takenCargo = _takenSeats select 5;
	private _takenCommander = _takenSeats select 1;
	private _takenCoP = _takenSeats select 3;
	private _takenGunner = _takenSeats select 2;
	private _takenArray = [_takenDriver,_takenCommander,_takenGunner,_takenCoP,_takenTurret,_takenCargo];

	if (_getInAs == 1) then {
		_takenDriver = (_takenDriver-1) max 0;
	};
	if (_getInAs == 2) then {
		if (_posType == "Turret") then {
			_takenCoP = (_takenCoP-1) max 0;
		} else {
			_takenCommander = (_takenCommander-1) max 0;
		};
	};
	if (_getInAs == 3) then {
		if (_posType == "Turret") then {
			_takenTurret = (_takenTurret-1) max 0;
		} else {
			_takenGunner = (_takenGunner-1) max 0;
		};
	};
	if (_getInAs == 4) then {
		_takenCargo = (_takenCargo-1) max 0;
	};
	_takenArray = [_takenDriver,_takenCommander,_takenGunner,_takenCoP,_takenTurret,_takenCargo];
	_target setVariable ["TSF_vehiclePreAssignedSeats", _takenArray];
	
	if (_unit distance _target > _distance OR !(alive _unit) OR !(alive _target)) exitWith {_unit setVariable ["TSF_Mount_Canceled", 1];
		_EH = _unit getVariable "TSF_AnimChangedEH";
		_unit removeEventHandler ["AnimChanged", _EH];
		_unit enableAI "PATH";
	};
	_weapon = [_unit] call TSF_fnc_getWeaponType;
	_stopMove = call compile format["TSF_%2_%1_NON_Anim",stance _unit, _weapon];
	_unit switchMove _stopMove;
	_unit doMove (getPosATLVisual _unit);
	uiSleep 0.1;
	if (_getInAs == 1) then {
		_unit assignAsDriver _target;
		_unit action ["getinDriver", _target];
		[_unit] orderGetIn true;
	};
	if (_getInAs == 2) then {
		if (_posType == "Turret") then {
			_unit assignAsTurret [_target, _position];
			_unit action ["getInTurret", _target, _position];
			[_unit] orderGetIn true;
		} else {
			_unit assignAsCommander _target;
			_unit action ["getInCommander", _target];
			[_unit] orderGetIn true;
		};
	};
	if (_getInAs == 3) then {
		if (_posType == "Turret") then {
			_unit assignAsTurret [_target, _position];
			_unit action ["getInTurret", _target, _position];
			[_unit] orderGetIn true;
		} else {
			_unit assignAsGunner _target;
			_unit action ["getInGunner", _target];
			[_unit] orderGetIn true;
		};
	};
	if (_getInAs == 4) then {
		_unit assignAsCargo _target;
		_unit action ["getInCargo", _target, _position];
		[_unit] orderGetIn true;
	};
	_EH = _unit getVariable "TSF_AnimChangedEH";
	_unit removeEventHandler ["AnimChanged", _EH];
	_unit enableAI "PATH";
};


private _roleArray = ["" ,"as Driver","as Commander","as Gunner","as Passenger"];
player groupChat (format ["Get in that %1 %2", _vehname, (_roleArray select _vehrole)]);
_vehiclePositions = fullCrew [_veh, "", true];
_takenSeats = _veh getVariable ["TSF_vehiclePreAssignedSeats", [0,0,0,0,0,0]];
_takenTurret = _takenSeats select 4;
_takenDriver = _takenSeats select 0;
_takenCargo = _takenSeats select 5;
_takenCommander = _takenSeats select 1;
_takenCoP = _takenSeats select 3;
_takenGunner = _takenSeats select 2;
//_takenArray = [_takenDriver,_takenCommander,_takenGunner,_takenCoP,_takenTurret,_takenCargo];
_allTurrets = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Turret" && !(_x select 3 isEqualTo [0])};
_allCargo = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Cargo"};
_allCoPilot = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Turret" && (_x select 3 isEqualTo [0])};
_allDriver = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Driver"};
_allGunner = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Gunner"};
_allCommander = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Commander"};
_copilot = 0; _gunner = 0; _driver = 0; _commander = 0; _turret = 0; _cargo = 0;
_unitsToMount = [];
_cond = ((driver _veh in (units group player)) OR (isNull (driver _veh)));
for "_i" from 0 to (count _selectedUnits - 1) do 
{
	_unassigned = true;
	if (_vehrole == 1 OR _vehrole == 0) then {
		if ((count _allDriver)-_takenDriver > _driver && _unassigned) exitWith {_takenDriver = _takenDriver + 1; _unitsToMount set [_i, [(_selectedUnits select _i), 1, "Driver", -1]]; _driver = _driver + 1; _unassigned = false};
	}; 
	if (_vehrole == 3 OR _vehrole == 0) then {
		if ((count _allGunner)-_takenGunner > _gunner && _unassigned && _cond) exitWith {_takenGunner = _takenGunner + 1 ;_unitsToMount set [_i, [(_selectedUnits select _i), 3, "Gunner", -1]]; _gunner = _gunner + 1; _unassigned = false};
		if ((count _allTurrets)-_takenTurret > _turret && _unassigned) exitWith {
		_takenTurret = _takenTurret + 1;
		_array = (_allTurrets select _turret) select 3;
		_unitsToMount set [_i, [(_selectedUnits select _i), 3, "Turret", _array]]; _turret = _turret + 1; _unassigned = false};
	};
	if (_vehrole == 2 OR _vehrole == 0) then {
		if ((count _allCommander)-_takenCommander > _commander && _unassigned && _cond) exitWith {_takenCommander = _takenCommander + 1;_unitsToMount set [_i, [(_selectedUnits select _i), 2, "Commander", -1]]; _commander = _commander + 1; _unassigned = false};
		if ((count _allCoPilot)-_takenCoP > _copilot && _unassigned) exitWith {_takenCoP = _takenCoP + 1;_unitsToMount set [_i, [(_selectedUnits select _i), 2, "Turret", [0]]]; _copilot = _copilot + 1; _unassigned = false};
	};
	if (_vehrole == 4 OR _vehrole == 0) then {
		if ((count _allCargo)-_takenCargo > _cargo && _unassigned) exitWith {
		_takenCargo = _takenCargo + 1; 
		_array = (_allCargo select _cargo) select 2;
		_unitsToMount set [_i, [(_selectedUnits select _i), 4, "Cargo", _array]]; _cargo = _cargo + 1; _unassigned = false};
	};
	_takenArray = [_takenDriver,_takenCommander,_takenGunner,_takenCoP,_takenTurret,_takenCargo];

	_veh setVariable ["TSF_vehiclePreAssignedSeats", _takenArray];
};

{
	[_x select 0, _veh, _x select 1, _x select 2, _x select 3] spawn _getInFnc; 
} forEach _unitsToMount;
/*
[_unitsToMount, _veh, _exit] spawn {
	params ["_unitsToMount", "_veh", "_exit"];
	if (_exit) exitWith {};
	private "_unit";
	private _driver = driver _veh;
	if !(isNull(_driver) && _driver in (units group player)) then {
	if (_veh isKindOf "Plane") exitWith {};
	if (_veh isKindOf "Helicopter") then {
		_veh flyInHeight 1;
		waitUntil {!(alive _veh) OR !(alive _driver) OR ((getPosATL _veh) select 2) < 7};
	};
	_driver disableAI "MOVE";
	{
		_unit = _x select 0;
		while {(vehicle _driver == _veh) && (alive _veh) && (alive _driver) && (alive _unit) && !(_unit in (crew _veh)) && (_unit getVariable ["TSF_Mount_Canceled", 0] != 1)} do {uiSleep 1};
	} forEach _unitsToMount;
	_driver enableAI "MOVE";
	if ((_veh isKindOf "Helicopter") && (_driver in (units group player))) then {_veh flyInHeight 50; _driver moveTo (getPos _driver)};
	};
};
*/