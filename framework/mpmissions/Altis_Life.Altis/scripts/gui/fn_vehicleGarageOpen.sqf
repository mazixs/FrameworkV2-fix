#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_vehicleGarageOpen.sqf
*/

params [
	["_type","Car",[""]],
	["_spawnpoint", [], ["",[]]]
];

life_garage_type = _type;
life_garage_sp = _spawnpoint;

if !(dialog) then {createDialog "RscDisplayGarage"};

disableSerialization;

private _display = uiNamespace getVariable ["RscDisplayGarage",findDisplay 2800];
private _controlTitle = (_display displayCtrl 2802);

_controlTitle ctrlSetText (localize "STR_ANOTF_QueryGarage");

[(localize "STR_ANOTF_QueryGarage")] call MPClient_fnc_notifications;

[player,_type] remoteExec ["MPServer_fnc_getVehicles",RE_SERVER];

_display