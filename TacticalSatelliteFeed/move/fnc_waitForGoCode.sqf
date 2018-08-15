params ["_unit", "_action"];
_unit setVariable ["TSF_unitState", 0];
if (_action == 2) then {while {!(player getVariable ["TSF_goCodeTriggeredA", false]) && alive _unit && !(_unit getVariable ["TSF_cancelMove", false])} do {uiSleep 0.05}};
if (_action == 3) then {while {!(player getVariable ["TSF_goCodeTriggeredB", false]) && alive _unit && !(_unit getVariable ["TSF_cancelMove", false])} do {uiSleep 0.05}};
if (_action == 4) then {while {!(player getVariable ["TSF_goCodeTriggeredC", false]) && alive _unit && !(_unit getVariable ["TSF_cancelMove", false])} do {uiSleep 0.05}};
_unit setVariable ["TSF_unitState", 3];