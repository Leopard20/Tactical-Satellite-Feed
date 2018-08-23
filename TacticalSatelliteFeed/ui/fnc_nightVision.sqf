if (isNil "TSF_NVG_Active") then {TSF_NVG_Active = false};
if !(TSF_NVG_Active) then {
	["ColorCorrections", 1500, [0.9, 1, 0, [0,0,0,0.1], [0, 1, 0.2, 0], [0.299, 0.587, 0.114, 0]]] spawn 
	{
		params ["_name", "_priority", "_effect"];
		while {
			TSF_nightVision = ppEffectCreate [_name, _priority];
			TSF_nightVision < 0
		} do {
			_priority = _priority + 1;
		};
		TSF_nightVision ppEffectEnable true;
		TSF_nightVision ppEffectAdjust _effect;
		TSF_nightVision ppEffectCommit 0;
		{
			((findDisplay 53620) displayCtrl _x) ctrlSetTextColor [1, 0.2, 0, 1];
			((findDisplay 53620) displayCtrl _x) ctrlSetActiveColor [1, 0.1, 0, 0.9];
		} forEach [1601];
	};
	_aperture = 0.25+moonIntensity/3;
	_hour = date select 3;
	if (sunOrMoon == 1 && _hour <= 18 && _hour >= 5) then {_aperture = _aperture + 10*(sunOrMoon-overcast + 0.15)} else {_aperture = _aperture - overcast/15};
	setAperture _aperture;
	TSF_NVG_Active = true;
} else {
	TSF_nightVision ppEffectEnable false;
	ppEffectDestroy TSF_nightVision;
	TSF_NVG_Active = false;
	{
		((findDisplay 53620) displayCtrl _x) ctrlSetTextColor [1, 1, 1, 1];
		((findDisplay 53620) displayCtrl _x) ctrlSetActiveColor [ 0.5, 1, 0.5, 1];
	} forEach [1601];
	setAperture -1;
};