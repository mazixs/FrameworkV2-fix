/*
    File: fn_lockVehicle.sqf
    Author: Bryan "Tonic" Boardwine
    Modified by: Claude AI

    Description:
    Locks/unlocks the vehicle with sound effects and visual feedback.
*/
params [
    ["_vehicle", objNull, [objNull]],
    ["_state", 2, [0, false]]
];

if (isNull _vehicle) exitWith {};

// Отладочные сообщения
private _uid = getPlayerUID player;
private _side = playerSide;
private _keyVariableName = format["%1_KEYS_%2", _uid, _side];
private _hasServerKeys = false;

// Проверяем наличие ключей
private _keys = player getVariable [_keyVariableName, []];
if (!isNil "_keys") then {
    systemChat format["Локальные ключи: найдено %1 транспортов", count _keys];
} else {
    systemChat "Локальные ключи не найдены";
};

// Проверка на oUUID для новой покупки
private _oUUID = _vehicle getVariable ["oUUID", ""];
if (_oUUID == "SHOP_BOUGHT") then {
    systemChat "Обнаружен недавно купленный транспорт";
    _hasServerKeys = true;
} else {
    systemChat format["oUUID транспорта: %1", _oUUID];
};

// Отправляем запрос на сервер для проверки ключей (только для отладки)
[player, _vehicle, false, ""] remoteExec ["MPServer_fnc_vehicle_lockingRequest", 2];

// Проверка наличия в списке личного транспорта
if (_vehicle in life_var_vehicles) then {
    systemChat "Транспорт найден в вашем личном списке";
    _hasServerKeys = true;
} else {
    systemChat "Транспорт отсутствует в вашем личном списке";
}; 

// Если у игрока нет ключей, выдаем сообщение и прерываем
if (!_hasServerKeys) exitWith {
    hint "У вас нет ключей от этого транспорта. Попробуйте войти и выйти из него.";
};

// Текущее состояние блокировки
private _locked = locked _vehicle > 0;

// Определяем тип действия
private _lockType = if (_state == 0) then {"unlock"} else {"lock"};

// Применяем блокировку
_vehicle lock _state;

// Звуковые и визуальные эффекты
[_vehicle, _lockType, true] call MPClient_fnc_disableAlarm;

// Сообщение о статусе
private _message = if (_state == 0) then {
    format["%1 разблокирован", getText(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName")]
} else {
    format["%1 заблокирован", getText(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName")]
};

hint _message;

// Логирование
systemChat format ["Транспорт %1: %2", [if (_locked) then {"разблокирован"} else {"заблокирован"}], typeOf _vehicle];