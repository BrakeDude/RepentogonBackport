local mod = RgonBackport

function mod:LouseSpawnSpider()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        if player:HasTrinket(TrinketType.TRINKET_LOUSE) then
            player:AddBlueSpider(player.Position)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_START_AMBUSH_WAVE, mod.LouseSpawnSpider)
mod:AddCallback(ModCallbacks.MC_POST_START_GREED_WAVE, mod.LouseSpawnSpider)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_ROOM_CLEAR, mod.LouseSpawnSpider)