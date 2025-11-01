local mod = RgonBackport

local Constants = {
    SOUND = 897,
    BLOOD_DURATION = 30, -- 1 second
    BLOOD_COUNT = 10, -- looks accurate enough

    DAMAGE = 9999999, -- Wowza!

    TIMER_DELIRIUM = 10 * 30,
    TIMER_MOTHER = 11.5 * 30,
    TIMER_NORMAL = 3 * 30,
}

---@param player EntityPlayer
function mod:PlanC(player)
    player:AnimateCollectible(CollectibleType.COLLECTIBLE_PLAN_C, "UseItem")
    mod.SFX:Play(Constants.SOUND)

    -- Do VFX
    mod.Game:ShakeScreen(Constants.TIMER_NORMAL)

    local room = mod.Game:GetRoom()
    room:EmitBloodFromWalls(Constants.BLOOD_DURATION, Constants.BLOOD_COUNT)

    -- Hurt everything
    local ents = Isaac.GetRoomEntities()
    for _, entity in ipairs(ents) do
        if entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
            entity:TakeDamage(Constants.DAMAGE, 0, EntityRef(player), 0)
        end
    end

    -- Kill timer (depends on floor and room)
    local level = mod.Game:GetLevel()
    if level:GetLastBossRoomListIndex() == level:GetCurrentRoomIndex() then
        -- Mother
        if (
            level:GetStage() == LevelStage.STAGE4_2
            and level:GetStageType() == StageType.STAGETYPE_REPENTANCE
        ) then
            mod:Schedule(function ()
                player:BloodExplode()
                player:Kill()
            end, Constants.TIMER_MOTHER)
        -- Delirium
        elseif level:GetStage() == LevelStage.STAGE7 then
            mod:Schedule(function ()
                player:BloodExplode()
                player:Kill()
            end, Constants.TIMER_DELIRIUM)
        else
            mod:Schedule(function ()
                player:BloodExplode()
                player:Kill()
            end, Constants.TIMER_NORMAL)
        end
    else
        mod:Schedule(function ()
            player:BloodExplode()
            player:Kill()
        end, Constants.TIMER_NORMAL)
    end

    player:RemoveCollectible(CollectibleType.COLLECTIBLE_PLAN_C)
end

function mod:PlanCCancel(_, _, player)
    mod:PlanC(player)
    return true
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.PlanCCancel, CollectibleType.COLLECTIBLE_PLAN_C)