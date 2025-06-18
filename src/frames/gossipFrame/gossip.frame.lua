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

function HideDefaultFrames()
    GossipFrameGreetingPanel:Hide()
    GossipNpcNameFrame:Hide()
    GossipFrameCloseButton:Hide()
    GossipFramePortrait:Hide()
    GossipFramePortrait:SetTexture()
end

function DGossipFrame_OnLoad()
    HideDefaultFrames()
    this:RegisterEvent("GOSSIP_SHOW");
    this:RegisterEvent("GOSSIP_CLOSED");
end

function DGossipFrame_OnEvent()
    if (event == "GOSSIP_SHOW") then
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


     -- Debug GetGossipOptions()
    --  local options = {GetGossipOptions()}
    --  DEFAULT_CHAT_FRAME:AddMessage("GetGossipOptions() returned " .. table.getn(options) .. " items:")
    --  for i = 1, table.getn(options) do
    --     DEFAULT_CHAT_FRAME:AddMessage("Option " .. i .. ": " .. tostring(options[i]))
    --  end
     

    for i = DGossipFrame.buttonIndex, NUMGOSSIPBUTTONS do
        getglobal("DGossipTitleButton" .. i):Hide();
    end
    DGossipFrameNpcNameText:SetText(UnitName("npc"));
    if (UnitExists("npc")) then
        SetPortraitTexture(DGossipFramePortrait, "npc");
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
    DGossipGreetingScrollFrame:SetVerticalScroll(0);
    DGossipGreetingScrollFrame:UpdateScrollChildRect();
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
        gossipIcon:SetTexture("Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\AvailableQuestIcon")

        -- Apply normal texture only for available quests
        titleButton:SetNormalTexture(
            "Interface\\AddOns\\DialogUI\\src\\assets\\art\\parchment\\OptionBackground-common")
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

        gossipIcon:SetTexture("Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\ActiveQuestIcon");

        DGossipFrame.buttonIndex = DGossipFrame.buttonIndex + 1;
        titleIndex = titleIndex + 1;
        titleButton:Show();

        titleButton:SetNormalTexture(
            "Interface\\AddOns\\DialogUI\\src\\assets\\art\\parchment\\OptionBackground-common")
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

        local gossipIconName = titleButton:GetName() .. "GossipIcon"
        local gossipIcon = getglobal(gossipIconName)
        
        if not gossipIcon then
            gossipIcon = titleButton:CreateTexture(gossipIconName, "OVERLAY")
            gossipIcon:SetWidth(20)
            gossipIcon:SetHeight(20)
            gossipIcon:SetPoint("TOPLEFT", titleButton, "TOPLEFT", 5, -6)
        end

        if titleButton.type == "Gossip" then
            titleButton:SetNormalTexture(nil)
            titleButton:SetHeight(titleButton:GetTextHeight() + 20)
            SetFontColor(titleButton, "DarkBrown")
        end

        -- Get the icon type from the second argument
        local iconType = arg[i + 1]
        local texturePath
        
        -- Define the mapping for all supported icon types
        local iconMap = {
            ["banker"] = "bankerGossipIcon",
            ["battlemaster"] = "battlemasterGossipIcon", 
            ["binder"] = "binderGossipIcon",
            ["gossip"] = nil,
            ["healer"] = nil,
            ["tabard"] = "guild masterGossipIcon",
            ["taxi"] = "flightGossipIcon",
            ["trainer"] = "trainerGossipIcon",
            ["unlearn"] = "unlearnGossipIcon",
            ["vendor"] = "vendorGossipIcon",
        }
        
        if iconType == "gossip" then
            -- For generic "gossip" type, determine icon from text
            local specificType = DetermineGossipIconType(arg[i])
            texturePath = "Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\" .. specificType .. "GossipIcon"
        elseif iconMap[iconType] then
            -- Use the mapped icon name
            texturePath = "Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\" .. iconMap[iconType]
        else
            -- Unknown icon type
            DEFAULT_CHAT_FRAME:AddMessage("Unknown icon type, report it to the author: " .. tostring(iconType))
            texturePath = "Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\petitionGossipIcon" -- fallback
        end
        
        -- Set the texture
        gossipIcon:SetTexture(texturePath);
        
        -- Check if it loaded successfully and use fallback if needed
        if not gossipIcon:GetTexture() then
            DEFAULT_CHAT_FRAME:AddMessage("Texture failed to load: " .. texturePath .. ", using fallback")
            gossipIcon:SetTexture("Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\petitionGossipIcon");
        end
        
        DGossipFrame.buttonIndex = DGossipFrame.buttonIndex + 1;
        titleIndex = titleIndex + 1;
        titleButton:Show();
    end
end

function DetermineGossipIconType(gossipText)
    local text = string.lower(gossipText)
    
    local professions = {
        "alchemy", "blacksmithing", "enchanting", "engineering", 
        "herbalism", "leatherworking", "mining", "skinning", 
        "tailoring", "jewelcrafting", "inscription", "cooking", "fishing", "first aid"
    }
    
    for _, profession in pairs(professions) do
        if string.find(text, profession) then
            return profession
        end
    end
    
    local classes = {
        "warrior", "paladin", "hunter", "rogue", "priest", 
        "shaman", "mage", "warlock", "druid", "death knight"
    }
    
    for _, class in pairs(classes) do
        if string.find(text, class) then
            return class
        end
    end
    
    -- Main menu service types
    if string.find(text, "profession") and string.find(text, "trainer") then
        return "trainer"
    elseif string.find(text, "class") and string.find(text, "trainer") then
        return "class trainer"
    elseif string.find(text, "stable") then
        return "stablemaster"
    elseif string.find(text, "inn") then
        return "innkeeper"
    elseif string.find(text, "mailbox") then
        return "mailbox"
    elseif string.find(text, "guild master") then
        return "guild master"
    elseif string.find(text, "trainer") and string.find(text, "pet") then
        return "pet trainer"
    elseif string.find(text, "auction") then
        return "auction house"
    elseif string.find(text, "weapon") and string.find(text, "trainer") then
        return "weapons trainer"
    elseif string.find(text, "deeprun") then
        return "deeprun tram"
    elseif string.find(text, "bat handler") or 
           string.find(text, "wind rider master") or 
           string.find(text, "gryphon master") or 
           string.find(text, "hippogryph master") or 
           string.find(text, "flight master") then
        return "flight"
    elseif string.find(text, "bank") then
        return "banker"
    else
        return "gossip"  -- fallback
    end
end