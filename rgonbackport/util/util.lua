local mod = RgonBackport

local scheduled = {}
function mod:Schedule(func, frames)
    scheduled[#scheduled+1] = {
        Count = mod.Game:GetFrameCount() + frames,
        Func = func
    }
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function ()
    local current = mod.Game:GetFrameCount()
    for i = #scheduled, 1, -1 do
        local v = scheduled[i]
        if current >= v.Count then
            v.Func()
            scheduled[i] = nil
        end
    end
end)