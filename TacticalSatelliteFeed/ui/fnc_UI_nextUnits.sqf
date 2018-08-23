if (_this > 0) then {
	if (count TSF_numberedUnits >= (TSF_menuNumber+1)*10) then {TSF_menuNumber = TSF_menuNumber + _this;};
} else {
	TSF_menuNumber = TSF_menuNumber + _this;
	if (TSF_menuNumber < 0) then {TSF_menuNumber = 0};
};
[] spawn TSF_fnc_UI_unitButtons;