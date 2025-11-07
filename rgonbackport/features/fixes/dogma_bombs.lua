local mod = RgonBackport

---@param npc EntityNPC
function mod:DogmaInitBombRemoval(npc)
    if npc.Variant == 1 then
        for _, bomb in ipairs(Isaac.FindByType(EntityType.ENTITY_BOMB)) do
            bomb:Remove()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.DogmaInitBombRemoval, EntityType.ENTITY_DOGMA)
