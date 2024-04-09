local COLORS = {
    --ColorKey = {r, g, b}

    DarkBrown = { 0.19, 0.17, 0.13 },
    LightBrown = { 0.50, 0.36, 0.24 },
    Ivory = { 0.87, 0.86, 0.75 },
};

function SetFontColor(fontObject, key)
    local color = COLORS[key];
    fontObject:SetTextColor(color[1], color[2], color[3]);
end

QuestFrame:SetWidth(512)
QuestFrame:SetHeight(512)



QuestFrameCloseButton:Hide()


function ScrollFrameCorrection(frame)
    -- local childFrame = QuestGreetingScrollFrame
    frame:SetPoint("TOPLEFT", QuestFrame, 100, -100)
end

QuestFrame:SetBackdrop({
    bgFile = "Interface\\AddOns\\DialogUI\\UI\\Parchment",
    edgeFile = nil,
    tile = false,
    tileEdge = false,
    tileSize = 0,
    edgeSize = 0,
    insets = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    }
})

function DQuestFrame()
    local frame = QuestFrame;
    for index, value in ipairs({ frame:GetRegions() }) do
        if value:GetDrawLayer() == "ARTWORK" then
            value:SetTexture(nil)
        end
    end

    local dquestFramePortrait = CreateFrame("Frame", nil, QuestFrame)
    QuestFramePortrait:SetParent(dquestFramePortrait)
    dquestFramePortrait:SetFrameLevel(9)
    QuestFramePortrait:SetWidth(50)
    QuestFramePortrait:SetHeight(50)
    QuestFramePortrait:SetPoint("TOPLEFT", QuestFrame, "TOPLEFT", 23 * 3, -3 * 6)
end

function DQuestFrameDetailPanel()
    local frame = QuestFrameDetailPanel;
    local count = 0
    for index, value in ipairs({ frame:GetRegions() }) do
        if value:GetDrawLayer() == "BACKGROUND" then -- Check if the region is a background layer
            count = count + 1
            if count <= 4 then
                value:SetTexture(nil) -- Remove existing texture
            else
                break                 -- Exit the loop after changing the texture of the first four background layers
            end
        end
    end
end

function DQuestFrameGreetingPanel()
    local frame = QuestFrameGreetingPanel;
    local count = 0
    for index, value in ipairs({ frame:GetRegions() }) do
        if value:GetDrawLayer() == "BACKGROUND" then -- Check if the region is a background layer
            count = count + 1
            if count <= 4 then
                value:SetTexture(nil) -- Remove existing texture
            else
                break                 -- Exit the loop after changing the texture of the first four background layers
            end
        end

        if value:GetDrawLayer() == "ARTWORK" then
            value:SetTexture(nil)
        end
    end


    local childFrame = QuestGreetingScrollChildFrame

    for index, value in ipairs({ childFrame:GetRegions() }) do
        if value:GetDrawLayer() == "ARTWORK" then
            if value:GetName() == "QuestGreetingFrameHorizontalBreak" then
                value:SetTexture(nil)
            end
        end
    end


    -- Define other functions like QuestFrameGreetingPanel_OnShow() if needed
end

function DQuestFrameProgressPanel()
    local frame = QuestFrameProgressPanel;
    local count = 0
    for index, value in ipairs({ frame:GetRegions() }) do
        if value:GetDrawLayer() == "BACKGROUND" then -- Check if the region is a background layer
            count = count + 1
            if count <= 4 then
                value:SetTexture(nil) -- Remove existing texture
            else
                break                 -- Exit the loop after changing the texture of the first four background layers
            end
        end
    end
end

function DQuestFrameRewardPanel()
    local frame = QuestFrameRewardPanel;
    local count = 0
    for index, value in ipairs({ frame:GetRegions() }) do
        if value:GetDrawLayer() == "BACKGROUND" then -- Check if the region is a background layer
            count = count + 1
            if count <= 4 then
                value:SetTexture(nil) -- Remove existing texture
            else
                break                 -- Exit the loop after changing the texture of the first four background layers
            end
        end
    end
end

DQuestFrame()
DQuestFrameDetailPanel()
DQuestFrameGreetingPanel()
DQuestFrameProgressPanel()
DQuestFrameRewardPanel()





-----------------------------Buttons--------------------------------

--Accept Button

QuestFrameAcceptButton:SetNormalTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common")
QuestFrameAcceptButton:SetHighlightTexture("Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front")
QuestFrameAcceptButton:SetPushedTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common")
QuestFrameAcceptButton:SetWidth(128)
QuestFrameAcceptButton:SetHeight(32)
QuestFrameAcceptButton:SetPoint("BOTTOMLEFT", QuestFrame, "BOTTOMLEFT", 20, 60)
SetFontColor(QuestFrameAcceptButton:GetFontString(), "Ivory")

--Decline Button

QuestFrameDeclineButton:SetNormalTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
QuestFrameDeclineButton:SetHighlightTexture("Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front")
QuestFrameDeclineButton:SetPushedTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
QuestFrameDeclineButton:SetWidth(128)
QuestFrameDeclineButton:SetHeight(32)
QuestFrameDeclineButton:SetPoint("BOTTOMRIGHT", QuestFrame, "BOTTOMRIGHT", -30, 60)
SetFontColor(QuestFrameDeclineButton:GetFontString(), "Ivory")

--Complete Button
QuestFrameCompleteQuestButton:SetNormalTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
QuestFrameCompleteQuestButton:SetHighlightTexture("Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front")
QuestFrameCompleteQuestButton:SetPushedTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
QuestFrameCompleteQuestButton:SetWidth(128)
QuestFrameCompleteQuestButton:SetHeight(32)
QuestFrameCompleteQuestButton:SetPoint("BOTTOMRIGHT", QuestFrame, "BOTTOMRIGHT", -30, 60)
SetFontColor(QuestFrameCompleteQuestButton:GetFontString(), "Ivory")

--Cancel Button
QuestFrameCancelButton:SetNormalTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
QuestFrameCancelButton:SetHighlightTexture("Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front")
QuestFrameCancelButton:SetPushedTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
QuestFrameCancelButton:SetWidth(128)
QuestFrameCancelButton:SetHeight(32)
QuestFrameCancelButton:SetPoint("BOTTOMRIGHT", QuestFrame, "BOTTOMRIGHT", -30, 60)
SetFontColor(QuestFrameCancelButton:GetFontString(), "Ivory")

--Goodbye Button

QuestFrameGoodbyeButton:SetNormalTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common")
QuestFrameGoodbyeButton:SetHighlightTexture("Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front")
QuestFrameGoodbyeButton:SetPushedTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common")
QuestFrameGoodbyeButton:SetWidth(128)
QuestFrameGoodbyeButton:SetHeight(32)
QuestFrameGoodbyeButton:SetPoint("BOTTOMRIGHT", QuestFrame, "BOTTOMRIGHT", -20, 60)
SetFontColor(QuestFrameGoodbyeButton:GetFontString(), "Ivory")

--GreetingGoodbye Button

QuestFrameGreetingGoodbyeButton:SetNormalTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common")
QuestFrameGreetingGoodbyeButton:SetHighlightTexture("Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front")
QuestFrameGreetingGoodbyeButton:SetPushedTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common")
QuestFrameGreetingGoodbyeButton:SetWidth(128)
QuestFrameGreetingGoodbyeButton:SetHeight(32)
QuestFrameGreetingGoodbyeButton:SetPoint("BOTTOMRIGHT", QuestFrame, "BOTTOMRIGHT", -20, 60)
SetFontColor(QuestFrameGreetingGoodbyeButton:GetFontString(), "Ivory")

--Continue Button

QuestFrameCompleteButton:SetDisabledTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
QuestFrameCompleteButton:SetHighlightTexture("Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front")
QuestFrameCompleteButton:SetPushedTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common")
QuestFrameCompleteButton:SetWidth(128)
QuestFrameCompleteButton:SetHeight(32)
QuestFrameCompleteButton:SetPoint("BOTTOMLEFT", QuestFrame, "BOTTOMLEFT", 20, 60)
SetFontColor(QuestFrameCompleteButton:GetFontString(), "DarkBrown")

--Fonts


CurrentQuestsText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18)      -- Current quest text  "Current Quests"
AvailableQuestsText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18)    -- Available quest text "Available Quests"
GreetingText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18)           --Quest Greeting Text
QuestTitleFont:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18)         --Quest Title Text in the detail panel
QuestDescription:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18)       --Quest Description Text in the detail panel
QuestObjectiveText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18)     --Quest Objective Text in the detail panel
QuestProgressTitleText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18) --Quest Progress Title Text in the progress panel
QuestProgressText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18)      --Quest Progress Text in the progress panel
QuestFrameNpcNameText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18)  --Quest NPC Name Text (it's been replaced with the title of the quest)
SetFontColor(QuestFrameNpcNameText, "DarkBrown")
SetFontColor(GreetingText, "DarkBrown")

QuestNpcNameFrame:SetScript("OnShow",
    function(self)
        QuestFrameNpcNameText:SetText(GetTitleText())
        QuestTitleText:Hide()
        QuestProgressTitleText:Hide()
    end)






--ScrollBars
QuestGreetingScrollFrameScrollBar:Hide()
QuestProgressScrollFrameScrollBar:Hide()

QuestDetailScrollFrameScrollBarScrollUpButton:SetNormalTexture(nil)
QuestDetailScrollFrameScrollBarScrollUpButton:SetPushedTexture(nil)
QuestDetailScrollFrameScrollBarScrollUpButton:SetDisabledTexture(nil)

QuestDetailScrollFrameScrollBarScrollDownButton:SetNormalTexture(nil)
QuestDetailScrollFrameScrollBarScrollDownButton:SetDisabledTexture(nil)
QuestDetailScrollFrameScrollBarThumbTexture:SetTexture(nil)


-- QuestTitleButton1:SetFont("Interface\\addons\\DialogUI\\Font\\frizqt___cyr.ttf", 14) -- solo los botones de cada mision, faltna hacer 31 mas
