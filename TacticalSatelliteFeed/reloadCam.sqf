_loaded = [] spawn {disableSerialization; waitUntil {false};};
waitUntil {scriptDone _loaded};
[] execVM "TacticalSatelliteFeed\cam.sqf";