#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

life_var_serverRequest = false;

MPServer_fnc_vehicle_generateVIN_TEMP = {
 
	params [
		["_side",""],
		["_type",""]
	];

	_type = toLower _type;
	_side = toLower _side;

	if !(_side in ["civ","reb","cop","med"])exitWith{"__ERROR__"};
	if !(_type in ["car","air","ship"])exitWith{"__ERROR__"};

	private _VIN = "";
	private _generateNew = true;
	private _numbers = "9876543210";
	private _lettersUpper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	private _lettersLower = toLower _lettersUpper;
	private _prefix = [(toArray _side) joinString "",(toArray _type) joinString ""] joinString "-";

	while {_generateNew} do
	{  
		_VIN = format ["%1-",_prefix];
		
		for "_i" from 1 to 9 do 
		{
			_VIN = _VIN + selectRandom [
				selectRandom(_numbers splitString  ""),
				selectRandom(_lettersUpper splitString  "")
			];
		};

		private _results = ["READ", "vehicles_new",
			[
				["BEGuid"],
				[
					["VIN", ["DB","STRING", _VIN] call MPServer_fnc_database_parse],
					["serverID", ["DB","INT", call life_var_serverID] call MPServer_fnc_database_parse]
				]
			]
		] call MPServer_fnc_database_request;

		if (count _results isEqualTo 0) exitWith {
			_generateNew = false;
		};
	};

	_VIN
};

MPServer_fnc_vehicle_getVinInfo = {
	params [
		["_vin","",[""]]
	];

	(_vin splitString "-") params [
		["_sideID",""],
		["_typeID",""],
		["_uniqueID",""]
	];

	private _sideReb = [east,true] call MPServer_fnc_util_getSideString;
	private _sideCop = [west,true] call MPServer_fnc_util_getSideString;
	private _sideMed = [independent,true] call MPServer_fnc_util_getSideString;
	private _sideCiv = [civilian,true] call MPServer_fnc_util_getSideString;

	private _side = toUpper(switch _sideID do {
		case (toArray _sideCiv joinString ""): {_sideCiv};
		case (toArray _sideCop joinString ""): {_sideCop};
		case (toArray _sideReb joinString ""): {_sideReb};
		case (toArray _sideMed joinString ""): {_sideMed};
		default {[sideUnknown,true] call MPServer_fnc_util_getSideString};
	});

	private _type = toUpper(switch _typeID do {
		case (toArray "car" joinString ""):  {"Car"};
		case (toArray "air" joinString ""):  {"Air"};
		case (toArray "ship" joinString ""): {"Ship"};
		default {"Undefined"};
	});

	[_side,_type,_uniqueID]
};

MPServer_fnc_vehicle_create = { 
	params [
		["_className","",[""]],
		["_position",[]],
		["_direction",random 360],
		["_usePositionATL",true]
	];
	
	private _vehicle = createVehicle [_className, [(_position#0) - 250 + (random 500),(_position#1) - 250 + (random 500),1000 + (random 1000)], [], 0, "CAN_COLLIDE"];

	//-- Prevent damage
	_vehicle allowDamage false;
	_vehicle removeAllEventHandlers "HandleDamage";
	_vehicle addEventHandler["HandleDamage", {false}];
	_vehicle setVelocity [0, 0, 0];

	//-- Set direction
	if ((typeName _direction) isEqualTo "ARRAY") then {
		_vehicle setVectorDirAndUp _direction;
	} else {
		_vehicle setDir _direction;
	};

	//-- Set Position
	if _usePositionATL then{
		_vehicle setPosATL _position;
	} else {
		_vehicle setPosASL _position;
	};

	//-- Allow damage
	_vehicle setVelocity [0, 0, 0];
	_vehicle allowDamage true;
	_vehicle removeAllEventHandlers "HandleDamage";
	_vehicle setDamage 0;

	//-- Empty vehicle storage
	clearBackpackCargoGlobal _vehicle;
	clearItemCargoGlobal _vehicle;
	clearMagazineCargoGlobal _vehicle;
	clearWeaponCargoGlobal _vehicle;

	//-- Create vehicle crew
	if (_className isKindOf "I_UGV_01_F") then {
		createVehicleCrew _vehicle;
	};

	//-- Disable vehicle nightVision
	if (getNumber (missionConfigFile >> "CfgVehicles" >> "nightVision") isEqualTo 0) then {
		_vehicle disableNVGEquipment true;
	};

	//-- Disable vehicle thermalVision
	if (getNumber (missionConfigFile >> "CfgVehicles" >> "thermalVision") isEqualTo 0) then {
		_vehicle disableTIEquipment true;
	};

	//-- Enable simulation
	if !(simulationEnabled _vehicle) then {
		_vehicle enableSimulationGlobal true;
	};

	//--
	_vehicle setVariable ["trunk_in_use",false,true];

	//-- Return
	_vehicle
};

MPServer_fnc_vehicle_insertRequest = {
	params [
		["_player",objNull,[objNull]], 
		["_vehicle",objNull,[objNull]]
	];

	private _class = typeOf _vehicle;
	private _pos = getPosATL _vehicle;
	private _dir = [vectorDir _vehicle, vectorUp _vehicle];
	private _side = [side _player,true] call MPServer_fnc_util_getSideString;
	private _type = [_vehicle] call MPServer_fnc_util_getTypeString;
	private _vin = [_side,_type] call MPServer_fnc_vehicle_generateVIN_TEMP;
	private _BEGuid = ('BEGuid' callExtension ("get:"+(getPlayerUID _player)));
	private _hitpoints = ((getAllHitPointsDamage _vehicle)#0) apply {[_x ,_vehicle getHitPointDamage _x]};
	private _textures = getObjectTextures _vehicle;
	private _materials = getObjectMaterials _vehicle;
	private _plate = getPlateNumber _vehicle;
	private _emptyArray = ["DB","ARRAY", []] call MPServer_fnc_database_parse;

	["CREATE", "vehicles_new", 
		[//What 
			["VIN", 			["DB","STRING", _vin] call MPServer_fnc_database_parse],
			["BEGuid", 			["DB","STRING", _BEGuid] call MPServer_fnc_database_parse],
			["serverID", 		["DB","INT", call life_var_serverID] call MPServer_fnc_database_parse],
			["faction", 		["DB","STRING", _side] call MPServer_fnc_database_parse],
			["class", 			["DB","STRING", _class] call MPServer_fnc_database_parse],
			["numberPlate", 	["DB","STRING", _plate] call MPServer_fnc_database_parse],
			["textures", 		["DB","ARRAY", _textures] call MPServer_fnc_database_parse],
			["materials", 		["DB","ARRAY", _materials] call MPServer_fnc_database_parse],
			["containerCargo", 	_emptyArray],
			["weaponsCargo", 	_emptyArray],
			["magazinesCargo", 	_emptyArray],
			["itemsCargo", 		_emptyArray],
			["vitemsCargo", 	_emptyArray],
			["hitpoints", 		["DB","ARRAY", _hitpoints] call MPServer_fnc_database_parse],
			["position", 		["DB","ARRAY", _pos] call MPServer_fnc_database_parse],
			["direction", 		["DB","ARRAY", _dir] call MPServer_fnc_database_parse]
		]
	] call MPServer_fnc_database_request;

	_vin
};

MPServer_fnc_vehicle_buyRequest = {
	params [
		["_player",objNull,[objNull]],
		["_class","",[""]],
		["_pos",[],[[]]],
		["_useATL",false,[false]],
		["_purchased",false,[false]],
		["_price",0,[0]],
		["_textures",[],[[]]],
		["_materials",[],[[]]],
		["_numberPlate","",[""]],
		["_lockcode","",[""]]
	];

	private _vin = "";
	private _steamID = getPlayerUID _player;
	
	// Отладочное сообщение о транспорте, который пытаются купить
	format ["Попытка покупки транспорта: %1", _class] remoteExec ["systemChat", owner _player];
	
	private _vehicle = [_class,_pos,random 360,_useATL] call MPServer_fnc_vehicle_create;
	private _rentals = getArray(missionConfigFile >> "cfgMaster" >> "vehicleShop_rentalOnly");

	if(isNull _vehicle) exitWith {
		"ERROR: Vehicle could not be created" remoteExec ["systemChat",owner _player];
	};

	if(count _textures > 0)then{ 
		{_vehicle setObjectTextureGlobal [_forEachIndex, _x]}forEach _textures;
	};

	if(count _materials > 0)then{
		{_vehicle setObjectMaterialGlobal [_forEachIndex, _x]}forEach _materials;
	};

	if(count _numberPlate > 0)then{
		_vehicle setPlateNumber _numberPlate;
	};

	// Добавляем идентификатор для антихака
	_vehicle setVariable ["oUUID", "SHOP_BOUGHT", true];
	format ["Установлен идентификатор oUUID: %1", _vehicle getVariable ["oUUID",""]] remoteExec ["systemChat", owner _player];

	if _purchased then {
		if !(_class in _rentals) then {
			_vin = [_player,_vehicle] call MPServer_fnc_vehicle_insertRequest;
		};
	};
	
	_vehicle setVariable ["vin",_vin,true];
	_vehicle setVariable ["persistent",_purchased,true];
	_vehicle setVariable ["vehicle_info_owners",[[_steamID,name _player]],true];
	_vehicle setVariable ["lockcode",_lockcode,true];

	//-- Give them keys
	[_steamID,side _player,_vehicle] call MPServer_fnc_keyManagement;
	
	// Отладка для владельца
	format ["Транспорт %1 добавлен в ключи", typeOf _vehicle] remoteExec ["systemChat", owner _player];
	
	// Отправляем ключи клиенту напрямую (как верный объект)
	[_vehicle,{
	    life_var_vehicles pushBackUnique _this;
	    systemChat format ["Получены ключи от транспорта: %1", typeOf _this];
	}] remoteExecCall ["call",owner _player];

	//-- Lock the vehicle (code or keys required)
	[_player, _vehicle, false, _lockcode] call MPServer_fnc_vehicle_lockingRequest;
	
	[
		[_vehicle,_price,_purchased],
		{
			params [
				["_vehicle",objNull,[objNull]],
				["_price",0,[0]],
				["_purchased",false,[false]]
			];

			private _class = typeOf _vehicle;

			//-- Killed before it was created
			if(alive player)then{
				player moveInDriver _vehicle;
			};

			//-- No free shit
			[_vehicle] call MPClient_fnc_clearVehicleAmmo;

			//-- Yep you own it.
			life_var_vehicles pushBack _vehicle;

			//-- I want paid...
			["SUB","CASH",_price] call MPClient_fnc_handleMoney;
			
			//-- Update cash in db
			[0] call MPClient_fnc_updatePlayerDataPartial;
			
			//-- Let them know they bought or rented it.
			hint format [localize(if(_purchased)then{"STR_Shop_Veh_Bought"}else{"STR_Shop_Veh_Rented"}),getText(configFile >> "CfgVehicles" >> _class >> "displayName"),[_price] call MPClient_fnc_numberText];
			  
			//Side Specific actions.
			switch (playerSide) do 
			{
				case west: {[_vehicle,"cop_offroad",true] spawn MPClient_fnc_vehicleAnimate};
				//case east: {};
				case independent: {[_vehicle,"med_offroad",true] spawn MPClient_fnc_vehicleAnimate};
				case civilian:
				{
					if ((life_var_vehicleTraderData select 2) isEqualTo "civ" && {_class == "B_Heli_Light_01_F"}) then {
						[_vehicle,"civ_littlebird",true] spawn MPClient_fnc_vehicleAnimate;
					};
				};
			};
			
			life_var_serverRequest = false;
		}
	] remoteExec ["spawn",owner _player];

	true
};

MPServer_fnc_vehicle_lockingRequest = {
	params [
		["_player",objNull,[objNull]],
		["_vehicle",objNull,[objNull]],
		["_animate",false,[false]],
		["_code","",[""]]
	];
	
	private _steamID = getPlayerUID _player;
	private _faction = side _player;
	private _keys = missionNamespace getVariable [format ["%1_KEYS_%2",_steamID,_faction],[]];
	private _locked = locked _vehicle > 0;
	private _persistent = _vehicle getVariable ["persistent",false];
	private _isNewPurchase = [_vehicle] call {
		params ["_veh"];
		private _result = false;
		// Проверяем, является ли это новой покупкой (если вызов из MPServer_fnc_vehicle_buyRequest)
		if (!isNil {_veh getVariable "vehicle_info_owners"}) then {
			private _owners = _veh getVariable "vehicle_info_owners";
			if (count _owners == 1) then {
				_result = true;
			};
		};
		_result
	};
    
    // Отладочные сообщения
    format ["Запрос на блокировку/разблокировку: %1, SteamID: %2, Фракция: %3", typeOf _vehicle, _steamID, _faction] remoteExec ["systemChat", owner _player];
    format ["Наличие ключей: %1, Блокировка: %2, Постоянное: %3, Новый: %4", (_vehicle in _keys), _locked, _persistent, _isNewPurchase] remoteExec ["systemChat", owner _player];

	// Проверка на владение транспортом
	private _hasOwnership = false;

	// Проверка наличия ключей на сервере
	if (_vehicle in _keys) then {
		_hasOwnership = true;
	};

	// Проверка кода блокировки
	if (_persistent AND count _code > 0) then {
		private _dbCode = _vehicle getVariable ["lockcode",""];
        format ["Код блокировки: %1", [_dbCode, "Не указан"] select (count _dbCode isEqualTo 0)] remoteExec ["systemChat", owner _player];

		//-- Код верный - даем ключи
		if(count _dbCode > 0 && _code isEqualTo _dbCode)then{
			_hasOwnership = true;
			_keys pushBackUnique _vehicle;
			missionNamespace setVariable [format ["%1_KEYS_%2",_steamID,_faction],_keys];
			[_vehicle,{life_var_vehicles pushBackUnique _this;}] remoteExecCall ["call",owner _player];
            "Код принят. Ключи добавлены." remoteExec ["systemChat", owner _player];
		};
	};

	// Проверка владения транспортом (VIN совпадает с PlayerUID)
	if (!_hasOwnership && _persistent) then {
		private _owners = _vehicle getVariable ["vehicle_info_owners",[]];
		{
			_x params ["_uid", "_name"];
			if (_uid isEqualTo _steamID) exitWith {
				_hasOwnership = true;
				// Если владелец, но нет ключей - добавляем их
				_keys pushBackUnique _vehicle;
				missionNamespace setVariable [format ["%1_KEYS_%2",_steamID,_faction],_keys];
				[_vehicle,{
					life_var_vehicles pushBackUnique _this;
					systemChat "Вы владелец этого транспорта. Ключи добавлены.";
				}] remoteExecCall ["call",owner _player];
			};
		} forEach _owners;
	};

	// Если новая покупка - принудительно разблокируем для возможности выхода
	if (_isNewPurchase && _locked) then {
		_hasOwnership = true;
		_vehicle lock 0;
		[_vehicle, "unlock", true] remoteExec ["MPClient_fnc_disableAlarm",owner _player];
		"Новый транспорт разблокирован для возможности выхода" remoteExec ["systemChat",owner _player];
		_locked = false;
	};

	// Выход если нет прав
	if (!_hasOwnership) exitWith {
		"У вас нет ключей или прав владения этим транспортом" remoteExec ["systemChat",owner _player];
		-1
	};
	
	//-- Toggle lock system
	if (_locked) then {
		_vehicle lock 0;
		[_vehicle, "unlock", true] remoteExec ["MPClient_fnc_disableAlarm",owner _player];
		if (_animate) then 
		{ 
			_vehicle animateDoor ["door_back_R",1];
			_vehicle animateDoor ["door_back_L",1];
			_vehicle animateDoor ['door_R',1];
			_vehicle animateDoor ['door_L',1];
			_vehicle animateDoor ['Door_L_source',1];
			_vehicle animateDoor ['Door_rear',1];
			_vehicle animateDoor ['Door_rear_source',1];
			_vehicle animateDoor ['Door_1_source',1];
			_vehicle animateDoor ['Door_2_source',1];
			_vehicle animateDoor ['Door_3_source',1];
			_vehicle animateDoor ['Door_LM',1];
			_vehicle animateDoor ['Door_RM',1];
			_vehicle animateDoor ['Door_LF',1];
			_vehicle animateDoor ['Door_RF',1];
			_vehicle animateDoor ['Door_LB',1];
			_vehicle animateDoor ['Door_RB',1];
			_vehicle animateDoor ['DoorL_Front_Open',1];
			_vehicle animateDoor ['DoorR_Front_Open',1];
			_vehicle animateDoor ['DoorL_Back_Open',1];
			_vehicle animateDoor ['DoorR_Back_Open ',1]; 
		};
		(localize "STR_MISC_VehUnlock") remoteExec ["systemChat",owner _player];
		_locked = false;
	} else {
		_vehicle lock 2;
		[_vehicle, "lock", true] remoteExec ["MPClient_fnc_disableAlarm",owner _player];
		if (_animate) then 
		{
			_vehicle animateDoor ["door_back_R",0];
			_vehicle animateDoor ["door_back_L",0];
			_vehicle animateDoor ['door_R',0];
			_vehicle animateDoor ['door_L',0];
			_vehicle animateDoor ['Door_L_source',0];
			_vehicle animateDoor ['Door_rear',0];
			_vehicle animateDoor ['Door_rear_source',0];
			_vehicle animateDoor ['Door_1_source',0];
			_vehicle animateDoor ['Door_2_source',0];
			_vehicle animateDoor ['Door_3_source',0];
			_vehicle animateDoor ['Door_LM',0];
			_vehicle animateDoor ['Door_RM',0];
			_vehicle animateDoor ['Door_LF',0];
			_vehicle animateDoor ['Door_RF',0];
			_vehicle animateDoor ['Door_LB',0];
			_vehicle animateDoor ['Door_RB',0];
			_vehicle animateDoor ['DoorL_Front_Open',0];
			_vehicle animateDoor ['DoorR_Front_Open',0];
			_vehicle animateDoor ['DoorL_Back_Open',0];
			_vehicle animateDoor ['DoorR_Back_Open ',0];
		};
		(localize "STR_MISC_VehLock") remoteExec ["systemChat",owner _player];
		_locked = true;
	};

	// Обновление в списке транспорта клиента
	[_vehicle, {
        if !(_this in life_var_vehicles) then {
            life_var_vehicles pushBackUnique _this;
            systemChat "Транспорт добавлен в ваш список";
        };
    }] remoteExecCall ["call", owner _player];
		
	//-- Return
	["UNLOCKED","LOCKED"] select _locked
};

MPServer_fnc_vehicle_loadRequest = {
	
	private _vin = "99105118-9997114-6VO997SCR";
	private _vinInfo = [_vin] call MPServer_fnc_vehicle_getVinInfo;

	_vinInfo params [
		["_side",""],
		["_type",""],
		["_uniqueID",""]
	];
	
};

//impounded_vehicles
private _formatQuery_impounded_vehicles = {
  
	private _limit = 5; 
	private _query = format [("SELECT" + toString [32] + (([
		["impounded_vehicles", "impound_id"],
		["impounded_vehicles", "vehicle_id"],
		["impounded_vehicles", "impound_fee"],
		["vehicles_new", 		"BEGuid"],
		["impounded_vehicles", 	"impound_by_guid"]
	] apply {_x joinString "."}) joinString ", ") + toString [32] + (
		"FROM impounded_vehicles INNER JOIN vehicles_new WHERE"
	) + toString [32] + (([
		["vehicles_new.spawned", "'0'"],
		["vehicles_new.destroyed", "'0'"],
		["impounded_vehicles.vehicle_id", "vehicles_new.ID"]
	] apply {_x joinString " = "}) joinString " AND ") + toString [32] + (
		"LIMIT %1,10"
	)),_limit];
 
}; 
 
