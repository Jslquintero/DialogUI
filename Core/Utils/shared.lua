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

function DUIShared.SetHeader(nameFontObject, portraitTexture, unit, nameText)
    if nameFontObject and nameFontObject.SetText then
        if nameText then
            nameFontObject:SetText(nameText)
        else
            nameFontObject:SetText(UnitName(unit or "npc"))
        end
    end
    DUIShared.SafeSetPortraitTexture(portraitTexture, unit or "npc")
end

function DUIShared.HideDefaultGossipFrames()
    GossipFrameGreetingPanel:Hide()
    GossipNpcNameFrame:Hide()
    GossipFrameCloseButton:Hide()
    GossipFramePortrait:Hide()
    GossipFramePortrait:SetTexture()
end

function DUIShared.HideDefaultQuestFrames()
    QuestFrameGreetingPanel:Hide()
    QuestFrameDetailPanel:Hide()
    QuestFrameProgressPanel:Hide()
    QuestFrameRewardPanel:Hide()
    QuestNpcNameFrame:Hide()
    QuestFramePortrait:SetTexture()
end

DIALOG_UI_SHARED = DUIShared


