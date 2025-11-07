local mod = RgonBackport

---@param player EntityPlayer
---@param cacheFlag integer
---@param current number
---@return number?
function mod:BloodRightsTearsStat(player, cacheFlag, current)
    if cacheFlag == EvaluateStatStage.FLAT_TEARS then
        local bloodRightEffects = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BLOOD_RIGHTS)

        if bloodRightEffects > 0 then
            return bloodRightEffects * 0.15 + 0.35 + current
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, mod.BloodRightsTearsStat)
