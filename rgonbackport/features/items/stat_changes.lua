local mod = RgonBackport

---@alias ItemStats {Tears: number, Damage: number, Range: number, ShotSpeed: number, Speed: number, Luck: number}

mod.ItemStatChanges = {
    [CollectibleType.COLLECTIBLE_2SPOOKY] = {
        Tears = 0.5,
        ShotSpeed = 0.2,
    }
}

---@type table<TrinketType, ItemStats>
mod.TrinketStatChanges = {
    [TrinketType.TRINKET_LAZY_WORM] = {
        Damage = .5,
    },

}

---@param player EntityPlayer
---@param trinketType TrinketType
function mod:UpdateTrinketCache(player, trinketType)
    ---@type TrinketType
    local maskedTrinketType = trinketType & TrinketType.TRINKET_ID_MASK
    if maskedTrinketType == TrinketType.TRINKET_LAZY_WORM then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE) -- probably should be changed with different approach to not constantly calling AddCacheFlags
    end

    player:EvaluateItems()
end

---@param player EntityPlayer
---@param cacheFlag CacheFlag
function mod:ChangeStats(player, cacheFlag)
    if cacheFlag & CacheFlag.CACHE_DAMAGE > 0 then
        local lazyWormMult = player:GetTrinketMultiplier(TrinketType.TRINKET_LAZY_WORM)
        if lazyWormMult > 0 then
            player.Damage = player.Damage + (mod.TrinketStatChanges[TrinketType.TRINKET_LAZY_WORM].Damage * lazyWormMult)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.UpdateTrinketCache)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.UpdateTrinketCache)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ChangeStats)
