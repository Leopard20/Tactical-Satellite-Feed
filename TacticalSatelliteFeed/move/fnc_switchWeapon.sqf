params ["_unit", "_selectedWpn"];
private ["_weapon", "_timer", "_move", "_counter", "_wpn"];
_ln_STAND_NON_Anim = "amovpercmstpsraswlnrdnon";
_ln_PRONE_NON_Anim = "amovppnemstpsraswrfldnon";
_ln_CROUCH_NON_Anim = "amovpknlmstpsraswlnrdnon";
_ln_UNDEFINED_NON_Anim = "";
_rfl_STAND_NON_Anim = "amovpercmstpsraswrfldnon";
_rfl_PRONE_NON_Anim = "amovppnemstpsraswrfldnon";
_rfl_CROUCH_NON_Anim = "amovpknlmstpsraswrfldnon";
_rfl_UNDEFINED_NON_Anim = "";
_pst_STAND_NON_Anim = "amovpercmstpsraswpstdnon";
_pst_PRONE_NON_Anim = "amovppnemstpsraswpstdnon";
_pst_CROUCH_NON_Anim = "amovpknlmstpsraswpstdnon";
_pst_UNDEFINED_NON_Anim = "";
_stance = stance _unit;
switch (_selectedWpn) do 
{
	case 1:
	{
		_weapon = primaryWeapon _unit;
		_move = call compile format ["_rfl_%1_NON_Anim", _stance];
	};
	case 2:
	{
		_weapon = secondaryWeapon _unit;
		_move = call compile format ["_ln_%1_NON_Anim", _stance];
	};
	case 3:
	{
		_weapon = handgunWeapon _unit;
		_move = call compile format ["_pst_%1_NON_Anim", _stance];
	};
};
if (_weapon == "" || currentWeapon _unit == _weapon) exitWith {};
_unit playMoveNow _move;
_weapons = weaponsItems _unit;
_weaponsNum = [];
{
	_num = 0;
	if ((_x select 0) == primaryWeapon _unit) then {_num = 1};
	if ((_x select 0) == secondaryWeapon _unit) then {_num = 2};
	if ((_x select 0) == handgunWeapon _unit) then {_num = 3};
	_weaponsNum pushBack _num;
} forEach _weapons;

_magazines = (magazinesAmmoFull _unit) apply {[_x select 0, _x select 1]};

removeAllWeapons _unit;

_index = _weaponsNum find _selectedWpn;

{
	_unit addMagazine _x
} forEach _magazines;

_pos = (getPos _unit) vectorAdd (vectorDir _unit);
//_wrench = createVehicle ["Land_Wrench_F", _pos];
//_wrench hideObjectGlobal true;
//_wrench setPos _pos;

_unit reveal _wrench;


_unit addWeaponGlobal _weapon;
_mode = (getArray (configFile >> "CfgWeapons" >> _weapon >> "modes")) select 0;
if (_mode == "this") then {_mode = _weapon};
_unit selectWeapon _weapon;
//_unit doTarget _wrench;
_unit forceWeaponFire [_weapon, _mode];	



_timer = 0;
//waitUntil {_unit switchMove _move;_unit selectWeapon _weapon;_timer = _timer + 1/diag_fps; (currentWeapon _unit != _weapon || _timer > 5)};
waitUntil {_unit playMoveNow _move;_unit selectWeapon _weapon;_timer = _timer + 1/diag_fps; (currentWeapon _unit == _weapon || _timer > 5)};
_counter = 0;
{
	_num = _weaponsNum select _counter;
	_wpn = _x select 0;
	if (_wpn != _weapon) then {_unit addWeaponGlobal _wpn};
	_items = [_x select 1 , _x select 2, _x select 3, _x select 5];
	switch (_num) do {
		case 1:
		{
			{
				_unit addPrimaryWeaponItem _x;
			} forEach _items;
		};
		case 2:
		{
			{
				_unit addSecondaryWeaponItem _x;
			} forEach _items;
		
		};
		case 3:
		{
			{
				_unit addHandgunItem _x;
			} forEach _items;
		};
	};
	_counter = _counter + 1;
} forEach _weapons;