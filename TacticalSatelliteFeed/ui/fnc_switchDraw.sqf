disableSerialization;
params ["_mode"];
private ["_display","_ctrl"];
_display = findDisplay 53620;
switch (_mode) do 
{
	case 1:
	{
		_ctrl = _display displayCtrl 1619;
		if (player getVariable ["TSF_drawAllPath", true]) then {
			_ctrl ctrlSetText "TacticalSatelliteFeed\Pictures\Button_DrawAll.paa";
			player setVariable ["TSF_drawAllPath", false];
			hintSilent "All paths hidden.";
		} else {
			_ctrl ctrlSetText "TacticalSatelliteFeed\Pictures\Button_noDraw.paa";
			player setVariable ["TSF_drawAllPath", true];
			hintSilent "All paths shown.";
		};
	};
	case 2:
	{
		_ctrl = _display displayCtrl 1655;
		if (player getVariable ["TSF_drawIndividualPath", true]) then {
			_ctrl ctrlSetText "TacticalSatelliteFeed\Pictures\Button_DrawAll.paa";
			player setVariable ["TSF_drawIndividualPath", false];
			hintSilent "Only last drawn path is shown.";
			{
				_x setVariable ["TSF_drawPath", false];
			} forEach (units group player);
		} else {
			_ctrl ctrlSetText "TacticalSatelliteFeed\Pictures\Button_singleDraw.paa";
			player setVariable ["TSF_drawIndividualPath", true];
			hintSilent "All paths shown.";
			{
				_x setVariable ["TSF_drawPath", true];
			} forEach (units group player);
		};
	};
	case 3:
	{
		_ctrl = _display displayCtrl 1656;
		if (player getVariable ["TSF_drawAllLines", true]) then {
			_ctrl ctrlSetText "TacticalSatelliteFeed\Pictures\Button_DrawAll.paa";
			player setVariable ["TSF_drawAllLines", false];
			hintSilent "All lines hidden.";
		} else {
			_ctrl ctrlSetText "TacticalSatelliteFeed\Pictures\Button_hidePath.paa";
			player setVariable ["TSF_drawAllLines", true];
			hintSilent "All lines shown.";
		};
	};
}
