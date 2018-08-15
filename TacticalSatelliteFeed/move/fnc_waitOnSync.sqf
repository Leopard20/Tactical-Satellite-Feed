params ["_unit", "_syncUnit"];
_unit setVariable ["TSF_unitState", 0];
while {alive _unit && alive _syncUnit && !(_unit getVariable ["TSF_unitOktoMove", false]) && !(_unit getVariable ["TSF_cancelMove", false]) && !(_syncUnit getVariable ["TSF_cancelMove", false])} do {uiSleep 0.05};
_unit setVariable ["TSF_unitState", 4];	