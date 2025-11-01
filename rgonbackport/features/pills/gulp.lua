local mod = RgonBackport
local game = mod.Game
local itemConfig = mod.ItemConfig

---@param pillColor PillColor
---@param player EntityPlayer
---@param useFlags UseFlag
---@return boolean?
function mod:Gulp(pillColor, player, useFlags)
    local isHorse = pillColor & PillColor.PILL_GIANT_FLAG > 0
    local pillConfig = itemConfig:GetPillEffect(PillEffect.PILLEFFECT_GULP)

    local goldenMask = isHorse and TrinketType.TRINKET_GOLDEN_FLAG or 0

    for i = 1, 0, -1 do
        local heldTrinket = player:GetTrinket(i)
        if heldTrinket ~= TrinketType.TRINKET_NULL then
            player:TryRemoveTrinket(heldTrinket)
            player:AddSmeltedTrinket(heldTrinket | goldenMask)
        end
    end


    local muteAnnouncer = Options.AnnouncerVoiceMode == AnnouncerVoiceMode.OFF
        or (useFlags & UseFlag.USE_NOANNOUNCER > 0)
    local announcerSfx = isHorse and pillConfig.AnnouncerVoiceSuper or pillConfig.AnnouncerVoice
    local announcerDelay = pillConfig.AnnouncerDelay
    local announcerFrameDelay = Options.AnnouncerVoiceMode == AnnouncerVoiceMode.RANDOM and 900 or 2

    if not muteAnnouncer then
        player:PlayDelayedSFX(announcerSfx, announcerDelay, announcerFrameDelay)
    end

    local pillName = Isaac.GetLocalizedString("PocketItems", pillConfig.Name, Options.Language)
    local ignoreStreak = useFlags & UseFlag.USE_NOHUD > 0

    if not ignoreStreak then
        game:GetHUD():ShowItemText(pillName)
    end

    game:SetBloom(30, 1)
    player:AnimatePill(pillColor, "UseItem")
end

function mod:GulpCancel(_, pillColor, player, useFlags)
    mod:Gulp(pillColor, player, useFlags)
    return true
end

mod:AddCallback(ModCallbacks.MC_PRE_USE_PILL, mod.GulpCancel, PillEffect.PILLEFFECT_GULP)
