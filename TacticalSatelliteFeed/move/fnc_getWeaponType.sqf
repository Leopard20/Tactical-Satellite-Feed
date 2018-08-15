params ["_unit"];
private _weapon = "rfl";
if ((currentWeapon _unit) isKindOf ["Launcher", configFile >> "CfgWeapons"]) then {_weapon = "ln"};
if ((currentWeapon _unit) isKindOf ["Pistol", configFile >> "CfgWeapons"]) then {_weapon = "pst"};
_weapon