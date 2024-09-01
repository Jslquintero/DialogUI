---@diagnostic disable: undefined-global
NUMGOSSIPBUTTONS = 32;

local COLORS = {
    -- ColorKey = {r, g, b}

    DarkBrown = {0.19, 0.17, 0.13},
    LightBrown = {0.50, 0.36, 0.24},
    Ivory = {0.87, 0.86, 0.75}
};

function SetFontColor(fontObject, key)
    local color = COLORS[key];
    fontObject:SetTextColor(color[1], color[2], color[3]);
end

function hideDefaultFrames()
    GossipFrameGreetingPanel:Hide()
    GossipNpcNameFrame:Hide()
    GossipFrameCloseButton:Hide()
    GossipFramePortrait:SetTexture()
end

function DGossipFrame_OnLoad()
    this:RegisterEvent("GOSSIP_SHOW");
    this:RegisterEvent("GOSSIP_CLOSED");
end

function DGossipFrame_OnEvent()
    if (event == "GOSSIP_SHOW") then
        hideDefaultFrames()
        if (not DGossipFrame:IsVisible()) then
            ShowUIPanel(DGossipFrame);
            if (not DGossipFrame:IsVisible()) then
                CloseGossip();
                return;
            end
        end
        DGossipFrameUpdate();
    elseif (event == "GOSSIP_CLOSED") then
        HideUIPanel(DGossipFrame);
    end
end

function DGossipFrameUpdate()
    DGossipFrame.buttonIndex = 1;
    DGossipGreetingText:SetText(GetGossipText());
    DGossipFrameAvailableQuestsUpdate(GetGossipAvailableQuests());
    DGossipFrameActiveQuestsUpdate(GetGossipActiveQuests());
    DGossipFrameOptionsUpdate(GetGossipOptions());

    for i = DGossipFrame.buttonIndex, NUMGOSSIPBUTTONS do
        getglobal("DGossipTitleButton" .. i):Hide();
    end
    DGossipFrameNpcNameText:SetText(UnitName("npc"));
    if (UnitExists("npc")) then
        SetPortraitTexture(DGossipFramePortrait, "player");
    else
        DGossipFramePortrait:SetTexture("Interface\\QuestFrame\\UI-QuestLog-BookIcon");

    end

    -- Set Spacer
    if (DGossipFrame.buttonIndex > 1) then
        DGossipSpacerFrame:SetPoint("TOP", "DGossipTitleButton" .. DGossipFrame.buttonIndex - 1, "BOTTOM", 0, 0);
        DGossipSpacerFrame:Show();
    else
        GossipSpacerFrame:Hide();
    end

    -- Update scrollframe
    GossipGreetingScrollFrame:SetVerticalScroll(0);
    GossipGreetingScrollFrame:UpdateScrollChildRect();
end

function DGossipTitleButton_OnClick()

    if (this.type == "Available") then
        SelectGossipAvailableQuest(this:GetID());
    elseif (this.type == "Active") then
        SelectGossipActiveQuest(this:GetID());
    else
        SelectGossipOption(this:GetID());
    end
end

function DGossipFrameAvailableQuestsUpdate(...)
    local titleButton
    local titleIndex = 1

    for i = 1, arg.n, 2 do
        if (DGossipFrame.buttonIndex > NUMGOSSIPBUTTONS) then
            message("This NPC has too many quests and/or gossip options.")
            break
        end

        titleButton = getglobal("DGossipTitleButton" .. DGossipFrame.buttonIndex)
        titleButton:SetText(arg[i])

        titleButton:SetID(titleIndex)
        titleButton.type = "Available" -- Set quest type

        -- Access the existing gossip icon texture and update it
        local gossipIcon = getglobal(titleButton:GetName() .. "GossipIcon")
        if not gossipIcon then
            -- If the texture doesn't exist, create it (should only happen the first time)
            gossipIcon = titleButton:CreateTexture(titleButton:GetName() .. "GossipIcon", "OVERLAY")
            gossipIcon:SetWidth(16)
            gossipIcon:SetHeight(16)
            gossipIcon:SetPoint("TOPLEFT", titleButton, "TOPLEFT", 3, -5)
        end
        gossipIcon:SetTexture("Interface\\AddOns\\DialogUI\\src\\assets\\art\\gossipIcons\\AvailableQuestIcon")

        -- Apply normal texture only for available quests
        titleButton:SetNormalTexture(
            "Interface\\AddOns\\DialogUI\\src\\assets\\art\\background\\OptionBackground-common")
        SetFontColor(titleButton, "Ivory")

        titleButton:SetHeight(titleButton:GetTextHeight() + 20)
        gossipIcon:SetWidth(20)
        gossipIcon:SetHeight(20)

        DGossipFrame.buttonIndex = DGossipFrame.buttonIndex + 1
        titleIndex = titleIndex + 1
        titleButton:Show()
    end

    -- Hide the extra button if there are no more quests
    if (DGossipFrame.buttonIndex > 1) then
        titleButton = getglobal("DGossipTitleButton" .. DGossipFrame.buttonIndex)
        titleButton:Hide()
        DGossipFrame.buttonIndex = DGossipFrame.buttonIndex + 1
    end
end

function DGossipFrameActiveQuestsUpdate(...)
    local titleButton;
    local titleIndex = 1;
    local isCompleteIndex = 1;

    for i = 1, arg.n, 2 do
        if (DGossipFrame.buttonIndex > NUMGOSSIPBUTTONS) then
            message("This NPC has too many quests and/or gossip options.");
        end
        titleButton = getglobal("DGossipTitleButton" .. DGossipFrame.buttonIndex);
        titleButton:SetText(arg[i]);

        titleButton:SetID(titleIndex);
        titleButton.type = "Active";
        local gossipIcon = titleButton:CreateTexture("$parentGossipIcon", "OVERLAY")
        gossipIcon:SetWidth(16)
        gossipIcon:SetHeight(16)
        gossipIcon:SetPoint("TOPLEFT", titleButton, "TOPLEFT", 3, -5)

        gossipIcon:SetTexture("Interface\\AddOns\\DialogUI\\src\\assets\\art\\gossipIcons\\ActiveQuestIcon");

        DGossipFrame.buttonIndex = DGossipFrame.buttonIndex + 1;
        titleIndex = titleIndex + 1;
        titleButton:Show();

        titleButton:SetNormalTexture(
            "Interface\\AddOns\\DialogUI\\src\\assets\\art\\background\\OptionBackground-common")
        titleButton:SetHeight(titleButton:GetTextHeight() + 20)
        gossipIcon:SetHeight(20)
        gossipIcon:SetWidth(20)
        SetFontColor(titleButton, "Ivory")
    end

    if (titleIndex > 1) then
        titleButton = getglobal("DGossipTitleButton" .. DGossipFrame.buttonIndex);
        titleButton:Hide();
        DGossipFrame.buttonIndex = DGossipFrame.buttonIndex + 1;
    end
end

function DGossipFrameOptionsUpdate(...)
    local titleButton;
    local titleIndex = 1;
    for i = 1, arg.n, 2 do
        if (DGossipFrame.buttonIndex > NUMGOSSIPBUTTONS) then
            message("This NPC has too many quests and/or gossip options.");
        end
        titleButton = getglobal("DGossipTitleButton" .. DGossipFrame.buttonIndex);
        titleButton:SetText(arg[i]);
        titleButton:SetID(titleIndex);
        titleButton.type = "Gossip";

        -- makes the texture layer for the gossip options
        local gossipIcon = titleButton:CreateTexture("$parentGossipIcon", "OVERLAY")
        gossipIcon:SetWidth(16)
        gossipIcon:SetHeight(16)
        gossipIcon:SetPoint("TOPLEFT", titleButton, "TOPLEFT", 5, -6)

        if titleButton.type == "Gossip" then
            titleButton:SetNormalTexture(nil) -- no texture (gossip icons only (bank, trainer, etc.))
            titleButton:SetHeight(titleButton:GetTextHeight() + 20)
            getglobal(titleButton:GetName() .. "GossipIcon"):SetHeight(20)
            getglobal(titleButton:GetName() .. "GossipIcon"):SetWidth(20)
            SetFontColor(titleButton, "DarkBrown")
        end

        getglobal(titleButton:GetName() .. "GossipIcon"):SetTexture(
            "Interface\\AddOns\\DialogUI\\src\\assets\\art\\gossipIcons\\" .. arg[i + 1] .. "GossipIcon");
        DGossipFrame.buttonIndex = DGossipFrame.buttonIndex + 1;
        titleIndex = titleIndex + 1;
        titleButton:Show();
    end
end
