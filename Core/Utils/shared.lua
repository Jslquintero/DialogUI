local DUIShared = {}

local COLORS = {
    DarkBrown = {0.19, 0.17, 0.13},
    LightBrown = {0.50, 0.36, 0.24},
    Ivory = {0.87, 0.86, 0.75}
}

function DUIShared.SetFontColor(fontObject, key)
    local color = COLORS[key]
    if not color or not fontObject or not fontObject.SetTextColor then return end
    fontObject:SetTextColor(color[1], color[2], color[3])
end

function DUIShared.SafeSetPortraitTexture(texture, unit)
    if UnitExists(unit) then
        SetPortraitTexture(texture, unit)
    else
        texture:SetTexture("Interface\\QuestFrame\\UI-QuestLog-BookIcon")
    end
end

DIALOG_UI_SHARED = DUIShared


