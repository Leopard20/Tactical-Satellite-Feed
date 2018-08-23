
/*
[
    TSF_Zeus_Enabled, // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    "Create Zeus Module", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    "All-In-One Command Menu", // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting
    1, // "global" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
    } // function that will be executed once on mission start and every time the setting is changed.
] call CBA_Settings_fnc_init;
*/

/*
Function: CBA_fnc_addKeybind

Description:
 Adds or updates the keybind handler for a specified mod action, and associates
 a function with that keybind being pressed.

Parameters:
 _modName           Name of the registering mod [String]
 _actionId  	    Id of the key action. [String]
 _displayName       Pretty name, or an array of strings for the pretty name and a tool tip [String]
 _downCode          Code for down event, empty string for no code. [Code]
 _upCode            Code for up event, empty string for no code. [Code]

 Optional:
 _defaultKeybind    The keybinding data in the format [DIK, [shift, ctrl, alt]] [Array]
 _holdKey           Will the key fire every frame while down [Bool]
 _holdDelay         How long after keydown will the key event fire, in seconds. [Float]
 _overwrite         Overwrite any previously stored default keybind [Bool]

Returns:
 Returns the current keybind for the action [Array]
 
The keybind you specify here will be the default, and calling this function later will not overwrite user changes. A keybind is an array in the format: [DIK code, [Shift?, Ctrl?, Alt?]] where DIK code is a number representing the key.

If you add the line

#include "\a3\editor_f\Data\Scripts\dikCodes.h"

to your script, you can use names for the keys rather than numbers.

Example: Shift-M would be [DIK_M, [true, false, false]]

Finally, to bind your function to a key, call CBA_fnc_addKeybind:
["My Awesome Mod","show_breathing_key", "Show Breathing", {_this call mymod_fnc_showGameHint}, "", [DIK_B, [true, true, false]]] call CBA_fnc_addKeybind;
*/


["TSF_modActivated", "CHECKBOX", "Activate Tactical Satellite Feed", "Tactical Satellite Feed" ,true, 1] call CBA_Settings_fnc_init;
["TSF_showFeedKey", "EDITBOX", "Show Camera Feed Key", "Tactical Satellite Feed" ,"[38, false, false, false]", 0] call CBA_Settings_fnc_init;
["TSF_Init_Message", "CHECKBOX", "Show Initialization Message", "Tactical Satellite Feed" ,true, 0] call CBA_Settings_fnc_init;
["TSF_autoUseEnhancedMovement", "CHECKBOX", "Auto-use Enhanced Movement During Quick Draw", "Tactical Satellite Feed" ,true, 0] call CBA_Settings_fnc_init;
["TSF_planningModeKey", "EDITBOX", "Planning Mode Toggle Key", "Tactical Satellite Feed" ,"[44, false, false, false]", 0] call CBA_Settings_fnc_init;
["TSF_unlockKey", "EDITBOX", "Lock/Unlock Camera Key", "Tactical Satellite Feed" ,"[19, false, false, false]", 0] call CBA_Settings_fnc_init;
["TSF_hideLineInMultiPath", "CHECKBOX", "Hide lines during multi path draw", "Tactical Satellite Feed" ,false, 0] call CBA_Settings_fnc_init;
["TSF_lockCamDistLimit", "SLIDER", "Restrict Cam Distance From Group (0 = No Limit)", "Tactical Satellite Feed" ,[0, 300, 100, 0], 1] call CBA_Settings_fnc_init;
["TSF_useLineOrIcon", "LIST", "Connecting Line Style", "Tactical Satellite Feed" ,[[false, true], ["Use 3D Icons", "Use 3D Lines"], 0], 0] call CBA_Settings_fnc_init;
["TSF_simulateFOW", "CHECKBOX", "Simulate Fog of War", "Tactical Satellite Feed" ,true, 1] call CBA_Settings_fnc_init;
["TSF_createMoveEH", "CHECKBOX", "Create AnimChanged EH", "Tactical Satellite Feed" ,false, 1] call CBA_Settings_fnc_init;