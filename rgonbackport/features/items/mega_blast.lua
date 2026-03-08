-- This change increases charges Mega Blast gains from batteries from 3 to 6.

local ADDITIONAL_CHARGES = 3

---@param player EntityPlayer
local function addMegaBlastCharges(player)
    local megaBlastSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_MEGA_BLAST)

    if megaBlastSlot ~= -1 then
        player:AddActiveCharge(ADDITIONAL_CHARGES, megaBlastSlot, true)
    end
end

---@param pickup EntityPickup
---@param collider Entity
local function handle_collision(pickup, collider)
    local player = collider:ToPlayer()

    if not player or pickup:IsDead() or player:GetMegaBlastDuration() > 0 then
        return
    end
end

---@param _pillEffect PillEffect
---@param player EntityPlayer
local function use_pill_48_hour_energy(_, _pillEffect, player)
    addMegaBlastCharges(player)
end

---@param _collectibleType CollectibleType
---@param _charge number
---@param _first_time boolean
---@param _slot ActiveSlot
---@param _var_data integer
---@param player EntityPlayer
local function post_add_collectible(_, _collectibleType, _charge, _first_time, _slot, _var_data, player)
    addMegaBlastCharges(player)
end

RgonBackport:AddCallback(ModCallbacks.MC_USE_PILL, use_pill_48_hour_energy, PillEffect.PILLEFFECT_48HOUR_ENERGY)
RgonBackport:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, post_add_collectible, CollectibleType.COLLECTIBLE_9_VOLT)
RgonBackport:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, post_add_collectible, CollectibleType.COLLECTIBLE_BATTERY_PACK)