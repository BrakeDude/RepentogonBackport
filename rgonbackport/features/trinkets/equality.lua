local mod = RgonBackport

if Isaac.ReworkTrinket ~= nil then
    Isaac.ReworkTrinket(TrinketType.TRINKET_EQUALITY)
end

local oldCoins = 0
local oldKeys = 0
local oldBombs = 0

local Constants = {
    FIRE_RATE = 2
}

---@param player EntityPlayer
function mod:EqualityUpdate(player)
    local coins = player:GetNumCoins()
    local bombs = player:GetNumBombs()
    local keys = player:GetNumKeys()
    local updateHappened = false

    if coins ~= oldCoins then
        oldCoins = coins
        updateHappened = true
    end

    if bombs ~= oldBombs then
        oldBombs = bombs
        updateHappened = true
    end

    if keys ~= oldKeys then
        oldKeys = keys
        updateHappened = true
    end

    if updateHappened then
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.EqualityUpdate, PlayerVariant.PLAYER)

---@param player EntityPlayer
function mod:EqualityEvaluateStat(player)
    local trinketMult = player:GetTrinketMultiplier(TrinketType.TRINKET_EQUALITY)
    if trinketMult > 0 then
        local coins = player:GetNumCoins()
        local bombs = player:GetNumBombs()
        local keys = player:GetNumKeys()

        if (
            coins == oldCoins
            and keys == oldKeys
            and bombs == oldBombs
        ) then
            local tears = mod:ToTPS(player.MaxFireDelay)
            tears = tears + (Constants.FIRE_RATE * trinketMult)
            player.MaxFireDelay = mod:ToMFD(tears)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EqualityEvaluateStat, CacheFlag.CACHE_FIREDELAY)