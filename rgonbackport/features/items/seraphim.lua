local mod = RgonBackport

function mod:SeraphimCollect(_, _, _, _, _, player)
    player:IncrementPlayerFormCounter(PlayerForm.PLAYERFORM_ANGEL, 1)
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.SeraphimCollect, CollectibleType.COLLECTIBLE_SERAPHIM)

function mod:SeraphimRemove(player)
    player:IncrementPlayerFormCounter(PlayerForm.PLAYERFORM_ANGEL, -1)
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.SeraphimRemove, CollectibleType.COLLECTIBLE_SERAPHIM)

--[[
-- Not needed
function mod:SeraphimModsLoaded()
    if EID then
       EID.CustomTransformAssignments["5.100." .. CollectibleType.COLLECTIBLE_SERAPHIM] = tostring(PlayerForm.PLAYERFORM_ANGEL)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.SeraphimModsLoaded)
]]