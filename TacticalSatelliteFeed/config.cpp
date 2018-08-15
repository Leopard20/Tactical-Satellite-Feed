class CfgPatches
{
	class TacticalSatelliteFeed
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"CBA_Extended_EventHandlers"};
		name = "Tactical Satellite Feed";
		author = "Leopard20";            
	};
};


class Extended_PreInit_EventHandlers
{

	TSF_PreInit="call compile preProcessFileLineNumbers 'TacticalSatelliteFeed\XEH_preInit.sqf'";

};
class Extended_PostInit_EventHandlers
{
	
	TSF_PostInit="call compile preprocessFileLineNumbers 'TacticalSatelliteFeed\init.sqf'";

};

#include "displayCtrls.hpp"