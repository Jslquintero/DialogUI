function NpcPortraitFrame()
    local dquestFramePortrait = CreateFrame("Frame", nil, QuestFrame)
    QuestFramePortrait:SetParent(dquestFramePortrait)
    dquestFramePortrait:SetFrameLevel(9)
    QuestFramePortrait:SetWidth(50)
    QuestFramePortrait:SetHeight(50)
    QuestFramePortrait:SetPoint("TOPLEFT", QuestFrame, "TOPLEFT", 23 * 3, -3 * 6)
end

function ScrollFrameCorrection(frame)
    -- local childFrame = QuestGreetingScrollFrame
    frame:SetPoint("TOPLEFT", QuestFrame, 120, -55)
    frame:SetWidth(512)
end

local function ClearBackgroundTextures(frame, maxCount)
    local count = 0
    for _, value in ipairs({ frame:GetRegions() }) do
        if value:GetDrawLayer() == "BACKGROUND" then
            count = count + 1
            if count <= maxCount then
                value:SetTexture(nil)
            else
                break
            end
        end
    end
end

local function ClearArtworkTextures(frame)
    for _, value in ipairs({ frame:GetRegions() }) do
        if value:GetDrawLayer() == "ARTWORK" then
            value:SetTexture(nil)
        end
    end
end

function DQuestFrame()
    local frame = QuestFrame

    frame:SetBackdrop({
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

    frame:SetWidth(512)
    frame:SetHeight(512)
    QuestFrameCloseButton:Hide()

    ClearArtworkTextures(frame)
end

function DQuestFrameDetailPanel()
    ClearBackgroundTextures(QuestFrameDetailPanel, 4)
    ScrollFrameCorrection(QuestDetailScrollFrame)


    QuestDetailScrollFrameScrollBarScrollUpButton:SetNormalTexture(nil)
    QuestDetailScrollFrameScrollBarScrollUpButton:SetPushedTexture(nil)
    QuestDetailScrollFrameScrollBarScrollUpButton:SetDisabledTexture(nil)
    QuestDetailScrollFrameScrollBarScrollDownButton:SetNormalTexture(nil)
    QuestDetailScrollFrameScrollBarScrollDownButton:SetDisabledTexture(nil)
    QuestDetailScrollFrameScrollBarThumbTexture:SetTexture(nil)
end

function DQuestFrameGreetingPanel()
    ClearBackgroundTextures(QuestFrameGreetingPanel, 4)
    ClearArtworkTextures(QuestFrameGreetingPanel)
    ScrollFrameCorrection(QuestGreetingScrollFrame)
    QuestGreetingScrollFrameScrollBar:Hide()

    for index, value in ipairs({ QuestGreetingScrollChildFrame:GetRegions() }) do
        if value:GetDrawLayer() == "ARTWORK" then
            if value:GetName() == "QuestGreetingFrameHorizontalBreak" then
                value:SetTexture(nil)
            end
        end
    end
end

function DQuestFrameProgressPanel()
    ClearBackgroundTextures(QuestFrameProgressPanel, 4)
    ScrollFrameCorrection(QuestProgressScrollFrame)
    QuestProgressScrollFrameScrollBar:Hide()
end

function DQuestFrameRewardPanel()
    ClearBackgroundTextures(QuestFrameRewardPanel, 4)
    ScrollFrameCorrection(QuestRewardScrollFrame)
end

-----------------------------Buttons--------------------------------

local function SetButtonProperties(button, normalTexture, highlightTexture, pushedTexture, width, height, pointA, pointB,
                                   pointX, pointY,
                                   fontColor)
    button:SetNormalTexture(normalTexture)
    button:SetHighlightTexture(highlightTexture)
    button:SetPushedTexture(pushedTexture)
    button:SetWidth(width)
    button:SetHeight(height)
    button:SetPoint(pointA, QuestFrame, pointB, pointX, pointY)
    SetFontColor(button:GetFontString(), fontColor)

    if button == QuestFrameCompleteButton then
        button:SetDisabledTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
    end

    if button == QuestFrameAcceptButton then
        button:SetDisabledTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
    end
end

function QuestFrameButtons()
    -- Accept Button
    SetButtonProperties(QuestFrameAcceptButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common",
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front",
        "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common",
        128, 32, "BOTTOMLEFT", "BOTTOMLEFT", 80, 50, "Ivory")

    -- -- Decline Button
    SetButtonProperties(QuestFrameDeclineButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front",
        "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
        128, 32, "BOTTOMRIGHT", "BOTTOMRIGHT", -80, 50, "Ivory")

    -- Complete Button
    SetButtonProperties(QuestFrameCompleteQuestButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-common",
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front",
        "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-common",
        128, 32, "BOTTOMLEFT", "BOTTOMLEFT", 80, 50, "Ivory")

    -- Cancel Button
    SetButtonProperties(QuestFrameCancelButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front",
        "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
        128, 32, "BOTTOMRIGHT", "BOTTOMRIGHT", -80, 50, "Ivory")

    -- Goodbye Button
    SetButtonProperties(QuestFrameGoodbyeButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common",
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front",
        "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common",
        128, 32, "BOTTOMRIGHT", "BOTTOMRIGHT", -80, 50, "Ivory")

    -- GreetingGoodbye Button
    SetButtonProperties(QuestFrameGreetingGoodbyeButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common",
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front",
        "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common",
        128, 32, "BOTTOMRIGHT", "BOTTOMRIGHT", -80, 50, "Ivory")

    -- Continue Button
    SetButtonProperties(QuestFrameCompleteButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front",
        "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common",
        128, 32, "BOTTOMLEFT", "BOTTOMLEFT", 80, 50, "DarkBrown")
end

-----------------------------Fonts--------------------------------
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

SetFontColor(QuestFrameNpcNameText, "DarkBrown")
SetFontColor(GreetingText, "DarkBrown")

function FontColorAndSize()
    CurrentQuestsText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 16)      -- Current quest text  "Current Quests"
    AvailableQuestsText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 16)    -- Available quest text "Available Quests"
    GreetingText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)           --Quest Greeting Text
    QuestTitleFont:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 16)         --Quest Title Text in the detail panel
    QuestDescription:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)       --Quest Description Text in the detail panel
    QuestObjectiveText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)     --Quest Objective Text in the detail panel
    QuestProgressTitleText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 16) --Quest Progress Title Text in the progress panel
    QuestProgressText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)      --Quest Progress Text in the progress panel
    QuestFrameNpcNameText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18)  --Quest NPC Name Text (it's been replaced with the title of the quest)
end

-----------------------------Load on Startup-------------------------
NpcPortraitFrame()
QuestFrameButtons()
FontColorAndSize()

---------------Event Handlers-------------------

QuestNpcNameFrame:SetScript("OnShow",
    function(self)
        QuestFrameNpcNameText:SetText(GetTitleText())
        QuestFrameNpcNameText:SetFontObject(GameFontNormal)
        QuestFrameNpcNameText:SetShadowColor(0, 0, 0, 1)
        QuestFrameNpcNameText:SetShadowOffset(-1, -1)
        QuestFrameNpcNameText:SetPoint("TOP", QuestNpcNameFrame, "TOPLEFT", 120, -10)
        QuestTitleText:Hide()
        QuestProgressTitleText:Hide()
        NpcPortraitFrame()
    end)

QuestFrame:SetScript("OnShow",
    function(self)
        DQuestFrame()
        DQuestFrameDetailPanel()
        DQuestFrameGreetingPanel()
        DQuestFrameProgressPanel()
        DQuestFrameRewardPanel()
    end
)

-- local oldOnShow = QuestFrameGreetingPanel_OnShow;
-- QuestFrameGreetingPanel_OnShow = function()
--     oldOnShow();

--     for i = 1, MAX_NUM_QUESTS do
--         local titleLine = getglobal("QuestTitleButton" .. i);
--         if (titleLine:IsVisible()) then
--             local bulletPointTexture = titleLine:GetRegions();
--             if (titleLine.isActive == 1) then
--                 -- bulletPointTexture:SetTexture("Interface\\GossipFrame\\ActiveQuestIcon");
--                 titleLine:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)
--                 SetFontColor(titleLine, "Ivory")

--                 titleLine:SetNormalTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common")
--                 titleLine:SetHighlightTexture("Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Gossip")
--                 titleLine:SetPushedTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common")
--                 local ActiveQuestIcon = titleLine:CreateTexture(nil, "ARTWORK")
--                 ActiveQuestIcon:SetTexture("Interface\\GossipFrame\\ActiveQuestIcon")
--                 ActiveQuestIcon:SetWidth(16)
--                 ActiveQuestIcon:SetHeight(16)
--                 ActiveQuestIcon:SetPoint("LEFT", titleLine, "LEFT", 0, 0)
--             else
--                 bulletPointTexture:SetTexture("Interface\\GossipFrame\\AvailableQuestIcon");
--                 titleLine:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)
--             end
--         end
--     end
-- end
