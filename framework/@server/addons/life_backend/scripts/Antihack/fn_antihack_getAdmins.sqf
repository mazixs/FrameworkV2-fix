#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## Оптимизировано: сокращено количество SQL запросов
*/

private _admins = [];

if(!isServer)exitwith{_admins};

private _config = (configFile >> "CfgAntiHack");

if(isClass _config)then{
	private _use_debugconadmins = getNumber(_config >> "use_debugconadmins") isEqualTo 1;
	private _use_databaseadmins = getNumber(_config >> "use_databaseadmins") isEqualTo 1;

	//--- Load admins from database - более эффективный запрос
	if(_use_databaseadmins)then{
		// Исправлен оператор сравнения для SQL с использованием правильного формата запроса
		_admins append (["READ", "players", [["adminlevel","pid","BEGuid"],[["adminlevel",">","0"]]],false]call MPServer_fnc_database_request);
		
		// Добавим проверку результата для отладки
		if (count _admins == 0) then {
			["Получен пустой список администраторов. Проверьте логику SQL-запроса."] call MPServer_fnc_log;
		} else {
			[format["Загружено администраторов: %1", count _admins]] call MPServer_fnc_log;
		};
	};

	//--- load developers from description.ext (database level takes priorty)
	if(_use_debugconadmins)then{
		{
			private _BEGuid = GET_BEGUID_S64(_x);
			if ((str _admins) find _BEGuid isEqualTo -1)then{
				_admins pushBackUnique [99,_x,_BEGuid]; 
			};
		}forEach getArray(missionConfigFile >> "enableDebugConsole");
	};
};

_admins