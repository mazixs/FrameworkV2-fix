#include "..\..\clientDefines.hpp"
/*
    File: fn_storeVehicle.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Stores the vehicle in the garage.
*/
private ["_nearVehicles","_vehicle"];
if !(isNull objectParent player) then {
    _vehicle = vehicle player;
} else {
    _nearVehicles = nearestObjects[getPos (_this select 0),["Car","Air","Ship"],30]; //Fetch vehicles within 30m.
    if (count _nearVehicles > 0) then {
        {
            if (!isNil "_vehicle") exitWith {}; //Kill the loop.
            _vehData = _x getVariable ["vehicle_info_owners",[]];
            if (count _vehData  > 0) then {
                _vehOwner = ((_vehData select 0) select 0);
                if ((getPlayerUID player) == _vehOwner) exitWith {
                    _vehicle = _x;
                };
            };
        } forEach _nearVehicles;
    };
};

// Отладка: проверяем информацию о транспорте и владении
if (isNil "_vehicle") then {
    systemChat "Не найден транспорт, который принадлежит вам.";
} else {
    private _playerUID = getPlayerUID player;
    private _inVehicleList = _vehicle in life_var_vehicles;
    private _vehData = _vehicle getVariable ["vehicle_info_owners",[]];
    private _dbInfo = _vehicle getVariable ["dbInfo",[]];
    private _vin = _vehicle getVariable ["vin",""];
    
    systemChat format["Транспорт: %1, в списке life_var_vehicles: %2", typeOf _vehicle, _inVehicleList];
    systemChat format["Данные владения: %1", _vehData];
    systemChat format["Данные dbInfo: %1, VIN: %2", _dbInfo, _vin];
    
    // Если транспорт не находится в списке life_var_vehicles, добавим его
    if (!_inVehicleList) then {
        private _isOwner = false;
        
        // Проверка владения по vehicle_info_owners
        if (count _vehData > 0) then {
            {
                if ((_x select 0) == _playerUID) then {
                    _isOwner = true;
                };
            } forEach _vehData;
        };
        
        // Проверка владения по dbInfo
        if (count _dbInfo > 0 && !_isOwner) then {
            if (_dbInfo select 0 == _playerUID) then {
                _isOwner = true;
            };
        };
        
        // Если игрок владелец, добавляем транспорт в список
        if (_isOwner) then {
            systemChat "Добавление транспорта в список life_var_vehicles...";
            life_var_vehicles pushBack _vehicle;
            
            // Добавляем ключи на сервере
            [_playerUID, playerSide, _vehicle] remoteExec ["MPServer_fnc_keyManagement", 2];
        };
    };
};

if (isNil "_vehicle") exitWith {hint localize "STR_Garage_NoNPC"};
if (isNull _vehicle) exitWith {};
if (!alive _vehicle) exitWith {hint localize "STR_Garage_SQLError_Destroyed"};

_storetext = localize "STR_Garage_Store_Success";

if (count extdb_var_database_headless_clients > 0) then {
    [_vehicle,false,(_this select 1),_storetext] remoteExec ["HC_fnc_vehicleStore",extdb_var_database_headless_client];
} else {
    [_vehicle,false,(_this select 1),_storetext] remoteExec ["MPServer_fnc_vehicleStore",RE_SERVER];
};

hint localize "STR_Garage_Store_Server";
life_var_sessionGarageRequest = true;
