params ["_pos", "_top", "_toppos", "_climber"];
private 
[
	"_st","_stnope","_EM_heightsOn","_EM_weightlimits","_EM_heightsOver","_EM_enable", "_condPars", "_cp1", "_cp2", "_cp3", 
	"_stepa","_stepb","_ona","_onb","_onhera","_onherb","_vaulta","_vaultb","_overa","_overb","_overha","_overhb",
	"_overhera","_overherb","_wl1","_wl2","_wl3","_wlj","_enableover","_enableon","_anm","_stmpn","_h","_over","_anm"
];

_st = stance _climber;
_stnope = ["PRONE", "UNDEFINED"];

if ((damage _climber) > 0.85 or _st in _stnope or vehicle _climber != _climber) exitwith {};  // EM_climbing or  /// or (getStamina _climber) < 0.01 

if (_climber == player) then
{
	EM_busy = true;
};

_EM_heightsOn = [0.25,1,2,2.25,3];
_EM_weightlimits = [1, 1, 1, 1]; 
_EM_heightsOver = [0.25,1.1,1.7,2.25,3];
_EM_enable = [true, true];

_stepa = _EM_heightsOn select 0;
_stepb = _EM_heightsOn select 1;

_ona = _EM_heightsOn select 1;
_onb = _EM_heightsOn select 2;

_onha = _EM_heightsOn select 2;
_onhb = _EM_heightsOn select 3;

_onhera = _EM_heightsOn select 3;
_onherb = _EM_heightsOn select 4;


_vaulta = _EM_heightsOver select 0;
_vaultb = _EM_heightsOver select 1;

_overa = _EM_heightsOver select 1;
_overb = _EM_heightsOver select 2;

_overha = _EM_heightsOver select 2;
_overhb = _EM_heightsOver select 3;

_overhera = _EM_heightsOver select 3;
_overherb = _EM_heightsOver select 4;

_wl1 = _EM_weightlimits select 0;

_wl2 = _EM_weightlimits select 1;

_wl3 = _EM_weightlimits select 2;

_wlj = _EM_weightlimits select 3;


_enableover = _EM_enable select 0;
_enableon = _EM_enable select 1;

_anm = "";

_stmpn = 2;
_stmpn = _stmpn * 0.5 + _stmpn * 0.5 * (load _climber);

if (str _pos == "[0,0,0]") exitwith
{
	if ((_climber getVariable "TSF_unitIsClimbing") && isTouchingGround _climber &&  (getstamina _climber > 8)) then
	{
		[_climber, _wlj] call babe_em_fnc_jump			
	};
	_climber setVariable ["TSF_unitIsClimbing", false];
};
_climber setVariable ["TSF_EM_default_animspeedcoef",(getAnimSpeedCoef _climber),false];
_h = ((_climber worldToModel asltoagl _pos) select 2) max 0;




_over = false;

if (_top) then
{
	switch (true) do
	{
		case (_h > _onhera && _h <= _onherb && load _climber < _wl3 && _enableon):
		{
			_stmpn = 10;
			_stmpn = _stmpn * 0.5 + _stmpn * 0.5 * (load _climber);
			switch (currentWeapon _climber) do
			{
				case (""):
				{
					_anm = "babe_climbonHer_ua";
				};
				case (primaryWeapon _climber):
				{
					_anm = "babe_climbonHer_rfl";
				};
				case (handgunWeapon _climber):
				{
					_anm = "babe_climbonHer_pst";
				};
			};
		};
		case (_h > _onha && _h < _onhb && load _climber < _wl2 && _enableon):
		{
			_stmpn = 8;
			_stmpn = _stmpn * 0.5 + _stmpn * 0.5 * (load _climber);
			switch (currentWeapon _climber) do
			{
				case (""):
				{
					_anm = "babe_climbonH_ua";
				};
				case (primaryWeapon _climber):
				{
					_anm = "babe_climbonH_rfl";
				};
				case (handgunWeapon _climber):
				{
					_anm = "babe_climbonH_pst";
				};
			};
		};
		case (_h > _ona && _h <= _onb && load _climber < _wl1 && _enableon):
		{
			_stmpn = 6;
			_stmpn = _stmpn * 0.5 + _stmpn * 0.5 * (load _climber);
			switch (currentWeapon _climber) do
			{
				case (""):
				{
					_anm = "babe_climbon_ua";
				};
				case (primaryWeapon _climber):
				{
					_anm = "babe_climbon_rfl";
				};
				case (handgunWeapon _climber):
				{
					_anm = "babe_climbon_pst";
				};
			};
		};
		case (_h > _stepa && _h <= _stepb):
		{
			_stmpn = 2;
			_stmpn = _stmpn * 0.5 + _stmpn * 0.5 * (load _climber);
			switch (currentWeapon _climber) do
			{
				case (""):
				{
					_anm = "babe_stepon_ua";
				};
				case (primaryWeapon _climber):
				{
					_anm = "babe_stepon_rfl";
				};
				case (handgunWeapon _climber):
				{
					_anm = "babe_stepon_pst";
				};
			};
		};
	};
} else
{
	switch (true) do
	{
		case (_h > _overhera && _h <= _overherb && load _climber < _wl3 && _enableover):
		{
			_stmpn = 10;
			_stmpn = _stmpn * 0.5 + _stmpn * 0.5 * (load _climber);
			switch (currentWeapon _climber) do
			{
				case (""):
				{
					_anm = "babe_climboverHer_ua";
				};
				case (primaryWeapon _climber):
				{
					_anm = "babe_climboverHer_rfl";
				};
				case (handgunWeapon _climber):
				{
					_anm = "babe_climboverHer_pst";
				};
			};
		};
		case (_h > _overha && _h <= _overhb && load _climber < _wl2 && _enableover):
		{
			_stmpn = 8;
			_stmpn = _stmpn * 0.5 + _stmpn * 0.5 * (load _climber);
			switch (currentWeapon _climber) do
			{
				case (""):
				{
					_anm = "babe_climboverH_ua";
				};
				case (primaryWeapon _climber):
				{
					_anm = "babe_climboverH_rfl";
				};
				case (handgunWeapon _climber):
				{
					_anm = "babe_climboverH_pst";
				};
			};
		};
		case (_h > _overa && _h < _overb && load _climber < _wl1 && _enableover):
		{
			_stmpn = 6;
			_stmpn = _stmpn * 0.5 + _stmpn * 0.5 * (load _climber);
			switch (currentWeapon _climber) do
			{
				case (""):
				{
					_anm = "babe_climbover_ua";
				};
				case (primaryWeapon _climber):
				{
					_anm = "babe_climbover_rfl";
				};
				case (handgunWeapon _climber):
				{
					_anm = "babe_climbover_pst";
				};
			};
		};
		case (_h > _vaulta && _h <= _vaultb):
		{
			_stmpn = 4;
			_stmpn = _stmpn * 0.5 + _stmpn * 0.5 * (load _climber);
			switch (currentWeapon _climber) do
			{
				case (""):
				{
					_anm = "babe_vaultover_ua";
				};
				case (primaryWeapon _climber):
				{
					_anm = "babe_vaultover_rfl";
				};
				case (handgunWeapon _climber):
				{
					_anm = "babe_vaultover_pst";
				};
			};
		};
	};
_over = true;	
};
if (_anm == "") exitwith 
{
	if ( (_climber getVariable "TSF_unitIsClimbing") && isTouchingGround _climber &&  (getstamina _climber > 8)) then
	{
		[_climber, _wlj] call babe_em_fnc_jump			
	};
	_climber setVariable ["TSF_unitIsClimbing", false];
	
	//!EM_climbing &&
};

_cp1 = [_climber, _anm];
_cp2 = [_pos, _over, _climber];
_cp3 = [_toppos, _over, _stmpn, _climber];
[ (format ["EH_em%1",([_climber] call TSF_fnc_getUnitNumber)]) ,{animationState (_condpars select 0) == (_condpars select 1)}, _cp1, "TSF_fnc_exec_em", _cp2, true, "TSF_fnc_finish_em", _cp3, 0] call babe_core_fnc_addEH;
_climber setAnimSpeedCoef 1-(load _climber)*0.3;
_climber playMove _anm;