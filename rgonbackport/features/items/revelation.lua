local mod = RgonBackport

local Constants = {
    SOUL_HEARTS = 4
}

function mod:RevelationCollect(_, _, _, _, _, player)
    player:AddSoulHearts(-Constants.SOUL_HEARTS)
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.RevelationCollect, CollectibleType.COLLECTIBLE_REVELATION)
