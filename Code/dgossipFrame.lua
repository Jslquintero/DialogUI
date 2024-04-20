function NpcPortraitFrame()
    local dgossipFramePortrait = CreateFrame("Frame", nil, GossipFrame)
    GossipFramePortrait:SetParent(dgossipFramePortrait)
    dgossipFramePortrait:SetFrameLevel(9)
    GossipFramePortrait:SetWidth(50)
    GossipFramePortrait:SetHeight(50)
    GossipFramePortrait:SetPoint("TOPLEFT", GossipFrame, "TOPLEFT", 23 * 3, -3 * 6)
end

function ScrollFrameCorrection(frame)
    frame:SetPoint("TOPLEFT", GossipFrame, 120, -55)
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

function DGossipFrame()
    local frame = GossipFrame

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
    GossipFrameCloseButton:Hide()

    ClearArtworkTextures(frame)
    ClearBackgroundTextures(GossipFrameGreetingPanel, 4)
end

function DGossipFrameGreetingPanel()
    ClearBackgroundTextures(GossipFrameGreetingPanel, 4)
    ClearArtworkTextures(GossipFrameGreetingPanel)
    ScrollFrameCorrection(GossipGreetingScrollFrame)
    GossipGreetingScrollFrameScrollBar:Hide()
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
    button:SetPoint(pointA, GossipFrame, pointB, pointX, pointY)
    SetFontColor(button:GetFontString(), fontColor)

    if button == GossipFrameCompleteButton then
        button:SetDisabledTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
    end

    if button == GossipFrameAcceptButton then
        button:SetDisabledTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
    end
end

-- Goodbye Button
SetButtonProperties(GossipFrameGreetingGoodbyeButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common",
    "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Front", "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common",
    128, 32, "BOTTOMRIGHT", "BOTTOMRIGHT", -80, 50, "Ivory")


---------------------------------Fonts & Buttons--------------------------------
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

GossipFrameNpcNameText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18) --Gossip NPC Name Text (it's been replaced with the title of the Gossip)
GossipGreetingText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)     --Gossip Greeting Text

SetFontColor(GossipFrameNpcNameText, "DarkBrown")
SetFontColor(GossipGreetingText, "DarkBrown")


function SetGossipTitleButtonProperties()
    for i = 1, 32 do
        local button = getglobal("GossipTitleButton" .. i)
        if button then
            button:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)
            button:SetHighlightTexture("Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Gossip")
            SetFontColor(button, "DarkBrown")
        end
    end
end

-----------------------------Load on Startup-------------------------
NpcPortraitFrame()
---------------Event Handlers-------------------
GossipNpcNameFrame:SetScript("OnShow",
    function(self)
        GossipFrameNpcNameText:Hide()
    end)

GossipFrame:SetScript("OnShow",
    function(self)
        DGossipFrame()
        DGossipFrameGreetingPanel()
        SetGossipTitleButtonProperties()
    end
)
