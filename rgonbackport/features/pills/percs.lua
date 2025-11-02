local mod = RgonBackport

---@param player EntityPlayer
---@param pillColor PillColor
---@return boolean?
function mod:HorsePercsUse(_, player, _, pillColor)
    local isHorse = pillColor & PillColor.PILL_GIANT_FLAG > 0

    if isHorse then
        player:SetFullHearts()
    end
end

mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.HorsePercsUse, PillEffect.PILLEFFECT_PERCS)
