disableSerialization;
params ["_radial"];
private ["_ctrls", "_display"];
if (TSF_RadialDraw == 1) then {
	_display = findDisplay 53620;
	switch (_radial) do
	{
		case 0:
		{
			TSF_selectedRadialDot = TSF_cursorDot;
			_mount = _display displayCtrl 1640;
			_attack = _display displayCtrl 1641;
			_fire = _display displayCtrl 1642;
			_goCodeAdd = _display displayCtrl 1643;
			_ctrls = [_mount,_attack,_fire,_goCodeAdd];
			_xPos = getMousePosition select 0;
			_yPos = getMousePosition select 1;
			for "_i" from 0 to 3 do
			{
				_ctrl = _ctrls select _i;
				_ctrl ctrlSetActiveColor [1, 1, 1, 1];
				_ctrl ctrlSetTextColor [1, 1, 1, 0.6];
				_angl = 90*_i;
				_multi = abs((_i mod 2)-1)*1/3 + 1;
				_dir = [[0.075/_multi, 0, 0], _angl] call BIS_fnc_rotateVector2D;
				_NewPos = [_xPos,_yPos,0] vectorAdd _dir;
				_NewPos = _NewPos select [0,2];
				_ctrl ctrlSetPosition _NewPos;
				_ctrl ctrlCommit 0;
				
			};
			_extra = _display displayCtrl 1657;
			_extra ctrlSetActiveColor [1, 1, 1, 1];
			_extra ctrlSetTextColor [1, 1, 1, 0.6];
			_extra ctrlSetPosition [_xPos, _yPos];
			_extra ctrlCommit 0;
		};
		case 1:
		{
			_A = _display displayCtrl 1644;
			_B = _display displayCtrl 1645;
			_C = _display displayCtrl 1646;
			_ctrls = [_C,_B,_A];
			_angls = [-60,0,60];
			_ctrlPos = ctrlPosition (_display displayCtrl 1641);
			_xPos = _ctrlPos select 0;
			_yPos = _ctrlPos select 1;
			for "_i" from 0 to 2 do
			{
				_ctrl = _ctrls select _i;
				_ctrl ctrlSetActiveColor [1, 1, 1, 1];
				_ctrl ctrlSetTextColor [1, 1, 1, 0.6];
				_angl = _angls select _i;
				_multi = abs((_i mod 2)-1)*1/3 + 1;
				_dir = [[0, 0.085/_multi, 0], _angl] call BIS_fnc_rotateVector2D;
				_NewPos = [_xPos,_yPos,0] vectorAdd _dir;
				_NewPos = _NewPos select [0,2];
				_ctrl ctrlSetPosition _NewPos;
				_ctrl ctrlCommit 0;
				
			};
		};
		case 2:
		{
			_open = _display displayCtrl 1647;
			_hold = _display displayCtrl 1648;
			_ctrls = [_open,_hold];
			_ctrlPos = ctrlPosition (_display displayCtrl 1642);
			_xPos = _ctrlPos select 0;
			_yPos = _ctrlPos select 1;
			for "_i" from 0 to 1 do
			{
				_ctrl = _ctrls select _i;
				_ctrl ctrlSetActiveColor [1, 1, 1, 1];
				_ctrl ctrlSetTextColor [1, 1, 1, 0.6];
				_angl = -90*_i + 135;
				//_multi = abs((_i mod 2)-1)*1/3 + 1;
				_dir = [[0, 0.075, 0], _angl] call BIS_fnc_rotateVector2D;
				_NewPos = [_xPos,_yPos,0] vectorAdd _dir;
				_NewPos = _NewPos select [0,2];
				_ctrl ctrlSetPosition _NewPos;
				_ctrl ctrlCommit 0;
				
			};
		};
		case 3:
		{
			_ctrlPos = ctrlPosition (_display displayCtrl 1657);
			_xPos = _ctrlPos select 0;
			_yPos = _ctrlPos select 1;
			_ctrls = [1640,1641,1642,1643,1644,1645,1646,1647,1648,1657,1658,1659,1660];
			{
				_ctrl = _display displayCtrl _x;
				_ctrl ctrlSetActiveColor [1, 1, 1, 0];
				_ctrl ctrlSetTextColor [1, 1, 1, 0];
				_ctrl ctrlSetPosition [TSF_safeX, TSF_safeY];
				_ctrl ctrlCommit 0;
			} forEach _ctrls;
			_EHM = _display displayCtrl 1658;
			_Gren = _display displayCtrl 1659;
			_ctrls = [_EHM,_Gren];
			
			for "_i" from 0 to 1 do
			{
				_ctrl = _ctrls select _i;
				_ctrl ctrlSetActiveColor [1, 1, 1, 1];
				_ctrl ctrlSetTextColor [1, 1, 1, 0.6];
				_angl = _i*180;
				_multi = 1/3 + 1;
				_dir = [[0.075/_multi, 0, 0], _angl] call BIS_fnc_rotateVector2D;
				_NewPos = [_xPos,_yPos,0] vectorAdd _dir;
				_NewPos = _NewPos select [0,2];
				_ctrl ctrlSetPosition _NewPos;
				_ctrl ctrlCommit 0;
				
			};
			_extra = _display displayCtrl 1660;
			_extra ctrlSetActiveColor [1, 1, 1, 1];
			_extra ctrlSetTextColor [1, 1, 1, 0.6];
			_extra ctrlSetPosition [_xPos, _yPos];
			_extra ctrlCommit 0;
		};
		case 4:
		{
			_ctrlPos = ctrlPosition (_display displayCtrl 1660);
			_xPos = _ctrlPos select 0;
			_yPos = _ctrlPos select 1;
			_ctrls = [1640,1641,1642,1643,1644,1645,1646,1647,1648,1657,1658,1659,1660];
			{
				_ctrl = _display displayCtrl _x;
				_ctrl ctrlSetActiveColor [1, 1, 1, 0];
				_ctrl ctrlSetTextColor [1, 1, 1, 0];
				_ctrl ctrlSetPosition [TSF_safeX, TSF_safeY];
				_ctrl ctrlCommit 0;
			} forEach _ctrls;
			_mount = _display displayCtrl 1640;
			_attack = _display displayCtrl 1641;
			_fire = _display displayCtrl 1642;
			_goCodeAdd = _display displayCtrl 1643;
			_ctrls = [_mount,_attack,_fire,_goCodeAdd];
			for "_i" from 0 to 3 do
			{
				_ctrl = _ctrls select _i;
				_ctrl ctrlSetActiveColor [1, 1, 1, 1];
				_ctrl ctrlSetTextColor [1, 1, 1, 0.6];
				_angl = 90*_i;
				_multi = abs((_i mod 2)-1)*1/3 + 1;
				_dir = [[0.075/_multi, 0, 0], _angl] call BIS_fnc_rotateVector2D;
				_NewPos = [_xPos,_yPos,0] vectorAdd _dir;
				_NewPos = _NewPos select [0,2];
				_ctrl ctrlSetPosition _NewPos;
				_ctrl ctrlCommit 0;
				
			};
			_extra = _display displayCtrl 1657;
			_extra ctrlSetActiveColor [1, 1, 1, 1];
			_extra ctrlSetTextColor [1, 1, 1, 0.6];
			_extra ctrlSetPosition [_xPos, _yPos];
			_extra ctrlCommit 0;
		};
	};
	waitUntil {uiSleep 0.001;TSF_RclickButtonUp};
	_ctrls = [1640,1641,1642,1643,1644,1645,1646,1647,1648,1657,1658,1659,1660];
	while {(TSF_camActive && TSF_RclickButtonUp && !TSF_ActionSelectMode && TSF_RadialDraw == 1)} do {uiSleep 0.001};
	{
		_ctrl = _display displayCtrl _x;
		_ctrl ctrlSetActiveColor [1, 1, 1, 0];
		_ctrl ctrlSetTextColor [1, 1, 1, 0];
		_ctrl ctrlSetPosition [TSF_safeX, TSF_safeY];
		_ctrl ctrlCommit 0;
	} forEach _ctrls;
	TSF_RadialDraw = 0;
};