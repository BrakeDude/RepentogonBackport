local mod = RgonBackport
local json = require("json")
local game = Game()

local shouldRestore = false
local skipSaveLevel = false
local skipSaveRoom = false

local defaults = {
    Game = {
        Run = {},
        Level = {},
        Room = {},
    },
    Hourglass = {
        Run = {},
        Level = {},
        Room = {},
    },
    Settings = {},
    DSS = {},
}

local function deepSearch(tab, parent)
    for i, entry in pairs(tab) do
        if parent[i] == nil and type(entry) == "table" then
            parent[i] = deepSearch(entry, {})
        elseif parent[i] == nil then
            parent[i] = entry
        end
    end

    return parent
end

local function deepCopy(tab)
	if type(tab) ~= "table" then
		return tab
	end

	local final = setmetatable({}, getmetatable(tab))
	for i, v in pairs(tab) do
		final[i] = deepCopy(v)
	end

	return final
end

-- Gets the save data table and loads it if it doesn't exist.
function RgonBackport:GetSaveData()
    if mod.LoadedData then
        return mod.LoadedData
    end

    if mod:HasData() then
        mod.LoadedData = json.decode(mod:LoadData())

        -- For if the data from file returns null
        -- This should never happen normally...
        -- ...but someone ran into the issue, so here we are :P
        if not mod.LoadedData then
            mod.LoadedData = {}
        end
    else
        mod.LoadedData = {}
    end

    mod.LoadedData = deepSearch(defaults, mod.LoadedData)

    return mod.LoadedData
end

function mod:HandlePreExitSave()
    mod:SaveSaveData()
    mod.LoadedData = nil
    shouldRestore = false
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, RgonBackport.HandlePreExitSave)

function mod:HandleLuamodSave(unloadedMod)
    if unloadedMod == mod and Isaac.IsInGame() and Game():GetNumPlayers() > 0 and mod.LoadedData then
        mod:SaveSaveData()
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, mod.HandleLuamodSave)

function mod:HandleHourglassSave()
    if shouldRestore then
        skipSaveRoom = true
        local save = mod:GetSaveData()
        local new = deepCopy(save.Hourglass)
        save.Game = new
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GLOWING_HOURGLASS_LOAD, mod.HandleHourglassSave)

function RgonBackport:HandleGameStartSave()
    skipSaveLevel = true
    skipSaveRoom = true

    mod:GetSaveData()

    if game:GetFrameCount() == 0 and game:GetNumPlayers() == 1 then
        local saveData = mod:GetSaveData()
        saveData.Game.Run = {}
        saveData.Game.Level = {}
        saveData.Game.Room = {}
        saveData.Hourglass.Run = {}
        saveData.Hourglass.Level = {}
        saveData.Hourglass.Room = {}

        RgonBackport:ResetLevelData()
        RgonBackport:ResetRoomData()
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_INIT, CallbackPriority.IMPORTANT-1, RgonBackport.HandleGameStartSave)

function RgonBackport:ResetLevelData()
    if not skipSaveLevel then
        local saveData = mod:GetSaveData()
        saveData.Hourglass.Run = deepCopy(saveData.Game.Run)
        saveData.Hourglass.Level = deepCopy(saveData.Game.Level)
        saveData.Game.Level = {}

        -- Need this here too because this runs after MC_POST_NEW_ROOM
        mod:SaveSaveData()
        shouldRestore = true
    end

    skipSaveLevel = false
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.IMPORTANT-1, RgonBackport.ResetLevelData)

function RgonBackport:ResetRoomData()
    if not skipSaveRoom then
        local saveData = mod:GetSaveData()
        saveData.Hourglass.Run = deepCopy(saveData.Game.Run)
        saveData.Hourglass.Room = deepCopy(saveData.Game.Room)
        saveData.Game.Room = {}

        mod:SaveSaveData()
        shouldRestore = true
    end

    skipSaveRoom = false
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.IMPORTANT-1, RgonBackport.ResetRoomData)

-----------------------------------

function RgonBackport:SaveSaveData()
    local saveString = json.encode(mod.LoadedData)
    mod:SaveData(saveString)
end

function RgonBackport:GetPlayerString(player)
    return (
        "p_" .. player:GetCollectibleRNG(1):GetSeed() ..
        "_" .. player:GetCollectibleRNG(2):GetSeed()
    )
end

function RgonBackport:SetShouldRestore()
    shouldRestore = true
end

function RgonBackport:GetSetting(settingName)
    local saveData = mod:GetSaveData()
    return saveData.Settings[settingName]
end

---@param player EntityPlayer?
function RgonBackport:GetRunData(player)
    local runData = mod:GetSaveData().Game.Run
    if player then
        local playerString = mod:GetPlayerString(player)
        if not runData[playerString] then
            runData[playerString] = {}
        end

        return runData[playerString]
    end

    return runData
end

---@param player EntityPlayer?
function RgonBackport:GetLevelData(player)
    local runData = mod:GetSaveData().Game.Level
    if player then
        local playerString = mod:GetPlayerString(player)
        if not runData[playerString] then
            runData[playerString] = {}
        end

        return runData[playerString]
    end

    return runData
end

---@param player EntityPlayer?
function RgonBackport:GetRoomData(player)
    local runData = mod:GetSaveData().Game.Room
    if player then
        local playerString = mod:GetPlayerString(player)
        if not runData[playerString] then
            runData[playerString] = {}
        end

        return runData[playerString]
    end

    return runData
end

function RgonBackport:GetDeadSeaScrollsSave()
    local saveData = mod:GetSaveData()
    return saveData.DSS
end