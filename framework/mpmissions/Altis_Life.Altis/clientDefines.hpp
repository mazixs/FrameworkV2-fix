/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## clientDefines.hpp
*/

#define DEBUG 1

//-- Basic math
#define INFINTE 1e+011
#define SUB(val1,val2) (val1 - val2)
#define ADD(val1,val2) (val1 + val2)
#define EQUAL(condition1,condition2) (condition1 isEqualTo condition2)

//--RemoteExec
#define RE_SERVER 2 //Only server
#define RE_CLIENT -2 //Except server
#define RE_GLOBAL 0 //Global
#define RE_HEADLESS extdb_var_database_headless_client

#ifdef DEBUG
	#undef RE_CLIENT
	#define RE_CLIENT 0
#endif

#ifdef DIK_INCLUDES
	#include "\a3\ui_f\hpp\definedikcodes.inc"
#endif

// Определения DIK кодов клавиш (основные)
#ifndef DIK_INCLUDES
    #define DIK_ESCAPE          0x01
    #define DIK_1               0x02
    #define DIK_2               0x03
    #define DIK_3               0x04
    #define DIK_4               0x05
    #define DIK_5               0x06
    #define DIK_6               0x07
    #define DIK_7               0x08
    #define DIK_8               0x09
    #define DIK_9               0x0A
    #define DIK_0               0x0B
    #define DIK_MINUS           0x0C    /* - on main keyboard */
    #define DIK_EQUALS          0x0D
    #define DIK_BACK            0x0E    /* backspace */
    #define DIK_TAB             0x0F
    #define DIK_Q               0x10
    #define DIK_W               0x11
    #define DIK_E               0x12
    #define DIK_R               0x13
    #define DIK_T               0x14
    #define DIK_Y               0x15
    #define DIK_U               0x16
    #define DIK_I               0x17
    #define DIK_O               0x18
    #define DIK_P               0x19
    #define DIK_LBRACKET        0x1A
    #define DIK_RBRACKET        0x1B
    #define DIK_RETURN          0x1C    /* Enter on main keyboard */
    #define DIK_LCONTROL        0x1D
    #define DIK_A               0x1E
    #define DIK_S               0x1F
    #define DIK_D               0x20
    #define DIK_F               0x21
    #define DIK_G               0x22
    #define DIK_H               0x23
    #define DIK_J               0x24
    #define DIK_K               0x25
    #define DIK_L               0x26
    #define DIK_SEMICOLON       0x27
    #define DIK_APOSTROPHE      0x28
    #define DIK_GRAVE           0x29    /* accent grave */
    #define DIK_LSHIFT          0x2A
    #define DIK_BACKSLASH       0x2B
    #define DIK_Z               0x2C
    #define DIK_X               0x2D
    #define DIK_C               0x2E
    #define DIK_V               0x2F
    #define DIK_B               0x30
    #define DIK_N               0x31
    #define DIK_M               0x32
    #define DIK_COMMA           0x33
    #define DIK_PERIOD          0x34    /* . on main keyboard */
    #define DIK_SLASH           0x35    /* / on main keyboard */
    #define DIK_RSHIFT          0x36
    #define DIK_MULTIPLY        0x37    /* * on numeric keypad */
    #define DIK_LMENU           0x38    /* left Alt */
    #define DIK_SPACE           0x39
    #define DIK_CAPITAL         0x3A
    #define DIK_F1              0x3B
    #define DIK_F2              0x3C
    #define DIK_F3              0x3D
    #define DIK_F4              0x3E
    #define DIK_F5              0x3F
    #define DIK_F6              0x40
    #define DIK_F7              0x41
    #define DIK_F8              0x42
    #define DIK_F9              0x43
    #define DIK_F10             0x44
    #define DIK_NUMLOCK         0x45
    #define DIK_SCROLL          0x46    /* Scroll Lock */
    #define DIK_NUMPAD7         0x47
    #define DIK_NUMPAD8         0x48
    #define DIK_NUMPAD9         0x49
    #define DIK_SUBTRACT        0x4A    /* - on numeric keypad */
    #define DIK_NUMPAD4         0x4B
    #define DIK_NUMPAD5         0x4C
    #define DIK_NUMPAD6         0x4D
    #define DIK_ADD             0x4E    /* + on numeric keypad */
    #define DIK_NUMPAD1         0x4F
    #define DIK_NUMPAD2         0x50
    #define DIK_NUMPAD3         0x51
    #define DIK_NUMPAD0         0x52
    #define DIK_DECIMAL         0x53    /* . on numeric keypad */
    #define DIK_OEM_102         0x56    /* < > | on UK/Germany keyboards */
    #define DIK_F11             0x57
    #define DIK_F12             0x58
#endif

#ifdef CONFIG_INCLUDES
	#define true 1
    #define false 0

	#define ST_LEFT           0x00
	#define ST_MULTI          0x10
	#define GUI_GRID_CENTER_WAbs     ((safezoneW / safezoneH) min 1.2)
	#define GUI_GRID_CENTER_HAbs     (GUI_GRID_CENTER_WAbs / 1.2)
	#define GUI_GRID_CENTER_W        (GUI_GRID_CENTER_WAbs / 40)
	#define GUI_GRID_CENTER_H        (GUI_GRID_CENTER_HAbs / 25)
	#define GUI_GRID_CENTER_X        (safezoneX + (safezoneW - GUI_GRID_CENTER_WAbs)/2)
	#define GUI_GRID_CENTER_Y        (safezoneY + (safezoneH - GUI_GRID_CENTER_HAbs)/2)

	#undef RE_CLIENT
	#define RE_CLIENT 1
	
    #define REWhitelist(NAME,TARGET) class NAME { \
        allowedTargets = TARGET; \
    };
    #define REWhitelistJIP(NAME,TARGET) class NAME { \
        allowedTargets = TARGET; \
        jip = 1; \
    };
    
#else
	//--- Databse related helpers
	#define MAX_SECS_TOO_WAIT_FOR_SERVER 30
	#define MAX_ATTEMPTS_TOO_QUERY_DATA 3

	//Display Macros
	#define GETDisplayNumber(var) getNumber(([missionConfigFile,missionConfigFile >> "RscTitles"] select isClass (missionConfigFile >> "RscTitles" >> var)) >> var >> "idd")
	#define GETControlNumber(var, var2) getNumber(([missionConfigFile,missionConfigFile >> "RscTitles"] select isClass (missionConfigFile >> "RscTitles" >> var)) >> var >> "controls" >> var2 >> "idc")
	#define GETControlBGNumber(var, var2) getNumber(([missionConfigFile,missionConfigFile >> "RscTitles"] select isClass (missionConfigFile >> "RscTitles" >> var)) >> var >> "controlsBackground" >> var2 >> "idc")
	#define GETControlGroupNumber(var, var2, var3) getNumber(([missionConfigFile,missionConfigFile >> "RscTitles"] select isClass (missionConfigFile >> "RscTitles" >> var)) >> var >> var2 >> "controls" >> var3 >> "idc")
	#define GETControlGroupBGNumber(var, var2, var3) getNumber(([missionConfigFile,missionConfigFile >> "RscTitles"] select isClass (missionConfigFile >> "RscTitles" >> var)) >> var >> var2 >> "controlsBackground" >> var3 >> "idc")

	#define GETDisplay(var) (uiNamespace getVariable [var, findDisplay (GETDisplayNumber(var))])
	#define GETControl(var, var2) GETDisplay(var) displayCtrl GETControlNumber(var, var2)
	#define GETControlBG(var, var2) GETDisplay(var) displayCtrl GETControlBGNumber(var, var2)
	#define GETControlGroup(var, var2, var3) GETDisplay(var) displayCtrl GETControlGroupNumber(var, var2, var3)
	#define GETControlGroupBG(var, var2, var3) GETDisplay(var) displayCtrl GETControlGroupBGNumber(var, var2, var3)

	#define CONTROL(disp,ctrl) ((findDisplay ##disp) displayCtrl ##ctrl)
	#define CONTROL_DATA(ctrl) (lbData[ctrl,lbCurSel ctrl])
	#define CONTROL_DATAI(ctrl,index) ctrl lbData index

	//System Macros
	#define LICENSE_VARNAME(varName,flag) format ["license_%1_%2",flag,M_CONFIG(getText,"cfgLicenses",varName,"variable")]
	#define LICENSE_VALUE(varName,flag) (missionNamespace getVariable [LICENSE_VARNAME(varName,flag),false])
	#define LICENSE_DISPLAYNAME(varName) (M_CONFIG(getText,"cfgLicenses",varName,"displayName") call bis_fnc_localize)
	#define LICENSE_PRICE(varName) M_CONFIG(getNumber,"cfgLicenses",varName,"price")
	#define LICENSE_SIDE(varName) M_CONFIG(getText,"cfgLicenses",varName,"side")
	#define LICENSE_ICON(varName) M_CONFIG(getText,"cfgLicenses",varName,"icon")
	#define ITEM_VARNAME(varName) format ["life_inv_%1",M_CONFIG(getText,"cfgVirtualItems",varName,"variable")]
	#define ITEM_DISPLAYNAME(varName) (M_CONFIG(getText,"cfgVirtualItems",varName,"displayName")) call bis_fnc_localize
	#define ITEM_ICON(varName) M_CONFIG(getText,"cfgVirtualItems",varName,"icon")
	#define ITEM_VALUE(varName) missionNamespace getVariable [ITEM_VARNAME(varName),0]
	#define ITEM_ILLEGAL(varName) M_CONFIG(getNumber,"cfgVirtualItems",varName,"illegal")
	#define ITEM_SELLPRICE(varName) M_CONFIG(getNumber,"cfgVirtualItems",varName,"sellPrice")
	#define ITEM_BUYPRICE(varName) M_CONFIG(getNumber,"cfgVirtualItems",varName,"buyPrice")
	#define ITEM_OBJECT(varName) M_CONFIG(getText,"cfgVirtualItems",varName,"object")
	#define TEXT_LOCALIZE(textStr) (textStr call bis_fnc_localize)
	
	//Config related
	#define FETCH_CONFIG(TYPE,CFG,SECTION,CLASS,ENTRY) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY)
	#define FETCH_CONFIG2(TYPE,CFG,CLASS,ENTRY) TYPE(configFile >> CFG >> CLASS >> ENTRY)
	#define FETCH_CONFIG3(TYPE,CFG,SECTION,CLASS,ENTRY,SUB) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY >> SUB)
	#define FETCH_CONFIG4(TYPE,CFG,SECTION,CLASS,ENTRY,SUB,SUB2) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY >> SUB >> SUB2)
	#define M_CONFIG(TYPE,CFG,CLASS,ENTRY) TYPE(missionConfigFile >> CFG >> CLASS >> ENTRY)
	#define BASE_CONFIG(CFG,CLASS) inheritsFrom(configFile >> CFG >> CLASS)
	#define CFG_MASTER(TYPE,SETTING) TYPE(missionConfigFile >> "cfgMaster" >> SETTING)

	//--- Reveal Objects
	#define CACHE_VAR "Life_var_revealObjectsCache"
	#define CACHE2_VAR format["%1%2",CACHE_VAR,"2"]
	#define CACHE_POS_VAR format["%1_pos",CACHE_VAR]

	//-- Money related
	#define GET_CASH_VAR "money_cash"
	#define GET_GANG_MONEY_VAR "money_gang"
	#define GET_BANK_VAR(target) format["money_bank_%1", getPlayerUID target]
	#define GET_DEBT_VAR(target) format["money_debt_%1", getPlayerUID target]
	#define GET_MONEY_CASH(target) (target getVariable [GET_CASH_VAR,0])
	#define GET_MONEY_DEBT(target) (target getVariable [GET_DEBT_VAR(target),0])
	#define GET_MONEY_BANK(target) (missionNamespace getVariable [GET_BANK_VAR(target),0])
	#define GET_MONEY_GANG(target) ((group target) getVariable [GET_GANG_MONEY_VAR,0])
	#define GET_MONEY_CASH_FORMATTED(target) [GET_MONEY_CASH(target)] call MPClient_fnc_numberText
	#define GET_MONEY_DEBT_FORMATTED(target) [GET_MONEY_DEBT(target)] call MPClient_fnc_numberText
	#define GET_MONEY_BANK_FORMATTED(target) [GET_MONEY_BANK(target)] call MPClient_fnc_numberText
	#define GET_MONEY_GANG_FORMATTED(target) [GET_MONEY_GANG(target)] call MPClient_fnc_numberText
	#define SET_MONEY_CASH(target, value) target setVariable [GET_CASH_VAR,##value,true]
	#define SET_MONEY_DEBT(target, value) target setVariable [GET_DEBT_VAR(target),##value,true]
	#define SET_MONEY_BANK(target, value) missionNamespace setVariable [GET_BANK_VAR(target),##value,true]
	#define SET_MONEY_GANG(target, value) (group target) setVariable [GET_GANG_MONEY_VAR,##value,true]
	#define ADD_MONEY_CASH(target, value) SET_MONEY_CASH(target, GET_MONEY_CASH(target) + value)
	#define ADD_MONEY_DEBT(target, value) SET_MONEY_DEBT(target, GET_MONEY_DEBT(target) + value)
	#define ADD_MONEY_BANK(target, value) SET_MONEY_BANK(target, GET_MONEY_BANK(target) + value)
	#define ADD_MONEY_GANG(target, value) SET_MONEY_GANG(target, GET_MONEY_GANG(target) + value)
	#define SUB_MONEY_CASH(target, value) SET_MONEY_CASH(target, GET_MONEY_CASH(target) - value)
	#define SUB_MONEY_DEBT(target, value) SET_MONEY_DEBT(target, GET_MONEY_DEBT(target) - value)
	#define SUB_MONEY_BANK(target, value) SET_MONEY_BANK(target, GET_MONEY_BANK(target) - value)
	#define SUB_MONEY_GANG(target, value) SET_MONEY_GANG(target, GET_MONEY_GANG(target) - value)
	#define MONEY_CASH GET_MONEY_CASH(player)
	#define MONEY_DEBT GET_MONEY_DEBT(player)
	#define MONEY_BANK GET_MONEY_BANK(player)
	#define MONEY_GANG GET_MONEY_GANG(player)
	#define MONEY_CASH_FORMATTED GET_MONEY_CASH_FORMATTED(player)
	#define MONEY_DEBT_FORMATTED GET_MONEY_DEBT_FORMATTED(player)
	#define MONEY_BANK_FORMATTED GET_MONEY_BANK_FORMATTED(player)
	#define MONEY_GANG_FORMATTED GET_MONEY_GANG_FORMATTED(player)

	//-- Engine conditions
	#define FORCE_SUSPEND(fnc) if !canSuspend exitWith{_this spawn (missionNamespace getVariable [fnc,{}]); true}
	#define RUN_SERVER_ONLY (if (hasInterface OR not(isServer))exitWith{false})
	#define RUN_DEDI_SERVER_ONLY (if (hasInterface OR not(isServer) OR not(isDedicated))exitWith{false})
	#define RUN_CLIENT_ONLY (if not(hasInterface)exitWith{false})
	#define KIND_OF_ARRAY(a,b) ([##a,##b] call {params ["_veh","_types"];{_veh isKindOf _x} count _types > 0})
	#define IS_CAR(a) (a isKindOf "Car")
	#define IS_AIR(a) (a isKindOf "Air")
	#define IS_SHIP(a) (a isKindOf "Ship")
	#define IS_TANK(a) (a isKindOf "Tank")
	
	//-- Antihack conditions
	#define AH_CHECK(var) (if (missionNamespace getVariable [var,false])exitWith{["Hack Detected", format["`%1` already set, Client looping or hacker detected",var], "Antihack"] call MPClient_fnc_endMission; false})
	#define AH_CHECK_FINAL(var) (if (isFinal var)exitWith{["Hack Detected", format["`%1` already final, Client looping or hacker detected",var], "Antihack"] call MPClient_fnc_endMission;false})
	#define AH_BAN_REMOTE_EXECUTED(var) (if(isRemoteExecuted AND (missionNamespace getVariable ["life_var_rcon_passwordOK",false]))exitwith{[remoteExecutedOwner,format["RemoteExecuted `%1`",var]] call MPServer_fnc_rcon_ban;})

	//-- Player
	#define ALIVE_OBJECT(obj) ((obj getVariable ["lifeState","Unknown"]) isEqualTo "HEALTHY")
	#define ALIVE ALIVE_OBJECT(player)
	#define HAS_GANG (not(isNil {(group player getVariable "gang_id")}))

	//-- Variable boradcast
	#define PVAR_GLOBAL(var) publicVariable var
	#define PVAR_SERVER(var) publicVariableServer var
	#define PVAR_CLIENT(var,id) id publicVariableClient var

	//-- Debug
	#define RPT_FILE_LB(a) diag_log (format["%1 %2" + endl + "%3",__FILE__,__LINE__, ##a])
	
	#define PLAYER_EVENT_TYPES  [ \
		"AnimChanged","AnimDone","AnimStateChanged","ContainerOpened","ContainerClosed", \
		"Dammaged","Deleted","EpeContactStart","EpeContact","EpeContactEnd", \
		"Explosion","Fired","FiredMan","FiredNear","GestureChanged","GestureDone", \
		"HandleDamage","HandleHeal","HandleRating","HandleScore","Hit","HitPart","IncomingMissile", \
		"InventoryOpened","InventoryClosed","Killed","Local","OpticsModeChanged","OpticsSwitch", \
		"Put","Reloaded","Respawn","SeatSwitchedMan","SoundPlayed","Take","TaskSetAsCurrent", \
		"VisionModeChanged","WeaponDeployed","WeaponRested" \
	]

	#define MISSION_EVENT_TYPES [ \
		"Map", \
		"MapSingleClick" \
	]

#endif

//
#define GROUP_COLOR_BLACK "GroupColor1"
#define GROUP_COLOR_RED "GroupColor2"
#define GROUP_COLOR_GREEN "GroupColor3"
#define GROUP_COLOR_BLUE "GroupColor4"
#define GROUP_COLOR_YELLOW "GroupColor5"
#define GROUP_COLOR_ORANGE "GroupColor6"
#define GROUP_COLOR_PINK "GroupColor7"

//--- RscDisplay macros
#define INVENTORY_IDD 602
#define INVENTORY_IDC_WALLET 77700
#define INVENTORY_IDC_VIRTUALITEMS 77701
#define INVENTORY_IDC_KEYS 77702
#define INVENTORY_IDC_BACKGROUND 77703
#define INVENTORY_IDC_TITLE 77704
#define INVENTORY_IDC_WEIGHT 77705
#define INVENTORY_IDC_LIST 77706
#define INVENTORY_IDC_USE 77707
#define INVENTORY_IDC_DROP 77708
#define INVENTORY_IDC_EDIT 77709
#define INVENTORY_IDC_COMBOPLAYERS 77710
#define INVENTORY_IDC_GIVE 77711
#define INVENTORY_IDC_COMBOPAGE 77712
#define INVENTORY_IDC_STORE 77713


//--- RscTitle macros
#define NAMETAG_IDC_BASE 78000

//-- Misc
#define OWNER_STEAMID "76561199109931625"

//--- Virtual Inventory types
#define INVENTORY_INDEX_VIRTUALITEMS_PLAYER 0
#define INVENTORY_INDEX_VIRTUALITEMS_GROUND 1
#define INVENTORY_INDEX_VIRTUALITEMS_VEHICLE 2
#define INVENTORY_INDEX_VIRTUALITEMS_HOUSE 3
#define INVENTORY_INDEX_VIRTUALITEMS_TENT 4
#define INVENTORY_INDEX_VIRTUALITEMS_0 "Player"
#define INVENTORY_INDEX_VIRTUALITEMS_1 "Ground"
#define INVENTORY_INDEX_VIRTUALITEMS_2 "Vehicle"
#define INVENTORY_INDEX_VIRTUALITEMS_3 "House"
#define INVENTORY_INDEX_VIRTUALITEMS_4 "Tent"

//--- Virtual Items
#define VITEM_MISC_MONEY "money"
#define VITEM_MISC_PICKAXE "pickaxe"
#define VITEM_MISC_DEFIBILLATOR "defibrillator"
#define VITEM_MISC_TOOLKIT "toolkit"
#define VITEM_MISC_TENTKIT "tentKit"
#define VITEM_MISC_FUELCAN_EMPTY "fuelEmpty"
#define VITEM_MISC_FUELCAN_FULL "fuelFull"
#define VITEM_MISC_SPIKESTRIP "spikeStrip"
#define VITEM_MISC_LOCKPICK "lockpick"
#define VITEM_MISC_GOLDBAR "goldbar"
#define VITEM_MISC_BLASTINGCHARGE "blastingcharge"
#define VITEM_MISC_BOLTCUTTERS "boltcutter"
#define VITEM_MISC_DEFUSEKIT "defusekit"
#define VITEM_MISC_STORAGEBOX_S "storagesmall"
#define VITEM_MISC_STORAGEBOX_L "storagebig"
#define VITEM_MINED_CRUDE_OIL "oilUnprocessed" 
#define VITEM_MINED_OIL "oilProcessed"
#define VITEM_MINED_COPPER_SULFIDE_ORES "copperUnrefined"
#define VITEM_MINED_COPPER "copperRefined"
#define VITEM_MINED_IRON_ORE "ironUnrefined"
#define VITEM_MINED_IRON "ironRefined" 
#define VITEM_MINED_SALT_BRINE "saltUnrefined"
#define VITEM_MINED_SALT "saltRefined"
#define VITEM_MINED_SAND "sand"
#define VITEM_MINED_GLASS "glass"
#define VITEM_MINED_DIAMOND_ORE "diamondUncut" 
#define VITEM_MINED_DIAMOND "diamondCut"
#define VITEM_MINED_ROCK "rock"
#define VITEM_MINED_CEMENT "cement"
#define VITEM_DRUG_OPIUM_POPPY "opiumpoppy"
#define VITEM_DRUG_HEROIN "heroinProcessed"
#define VITEM_DRUG_CANNABIS_MEDICAL "marijuanaMedical"
#define VITEM_DRUG_CANNABIS_WET "marijuanaWet"
#define VITEM_DRUG_CANNABIS "marijuana"
#define VITEM_DRUG_COCA_LEAFS "cocaineUnprocessed"
#define VITEM_DRUG_COCAINE "cocaineProcessed"
#define VITEM_DRUG_MORPHINE "morphineProcessed"
#define VITEM_DRUG_CODEINE "codeineProcessed"
#define VITEM_DRINK_REDGULL "redgull"
#define VITEM_DRINK_COFFEE "coffee"
#define VITEM_DRINK_WATER "waterBottle"
#define VITEM_FOOD_APPLE "apple"
#define VITEM_FOOD_PEACH "peach"
#define VITEM_FOOD_BACON "tbacon"
#define VITEM_FOOD_DONUTS "donuts"
#define VITEM_FOOD_RAW_RABBIT "rabbitRaw"
#define VITEM_FOOD_RABBIT "rabbit"
#define VITEM_FOOD_RAW_SALEMA "salemaRaw"
#define VITEM_FOOD_SALEMA "salema"
#define VITEM_FOOD_RAW_ORNATE "ornateRaw"
#define VITEM_FOOD_ORNATE "ornate"
#define VITEM_FOOD_RAW_MACKREL "mackerelRaw"
#define VITEM_FOOD_MACKREL "mackerel"
#define VITEM_FOOD_RAW_TUNA "tunaRaw"
#define VITEM_FOOD_TUNA "tuna"
#define VITEM_FOOD_RAW_MULLET "mulletRaw"
#define VITEM_FOOD_MULLET "mullet"
#define VITEM_FOOD_RAW_CATSHARK "catsharkRaw"
#define VITEM_FOOD_CATSHARK "catshark"
#define VITEM_FOOD_RAW_TURTLE "turtleRaw"
#define VITEM_FOOD_TURTLESOUP "turtleSoup"
#define VITEM_FOOD_RAW_HEN "henRaw"
#define VITEM_FOOD_HEN "hen"
#define VITEM_FOOD_RAW_ROOSTER "roosterRaw"
#define VITEM_FOOD_ROOSTER "rooster"
#define VITEM_FOOD_RAW_SHEEP "sheepRaw"
#define VITEM_FOOD_SHEEP "sheep"
#define VITEM_FOOD_RAW_GOAT "goatRaw"
#define VITEM_FOOD_GOAT "goat"
