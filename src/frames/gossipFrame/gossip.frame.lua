---@diagnostic disable: undefined-global
NUMGOSSIPBUTTONS = 32;

local COLORS = {
    -- ColorKey = {r, g, b}
    
    DarkBrown = {0.19, 0.17, 0.13},
    LightBrown = {0.50, 0.36, 0.24},
    Ivory = {0.87, 0.86, 0.75}
};

local totalGossipButtons = 0

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
    
    -- Create simplified key handler frame
    if not DGossipKeyFrame then
        CreateFrame("Frame", "DGossipKeyFrame", UIParent)
        DGossipKeyFrame:SetScript("OnKeyDown", DGossipFrame_OnKeyDown)
        DGossipKeyFrame:EnableKeyboard(false) -- Start disabled
        DGossipKeyFrame:SetToplevel(true)
        DGossipKeyFrame:SetAllPoints(UIParent)
        DGossipKeyFrame:SetFrameStrata("TOOLTIP")
    end
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
        -- Enable key capture when gossip frame is shown
        DGossipKeyFrame:EnableKeyboard(true)
    elseif (event == "GOSSIP_CLOSED") then
        HideUIPanel(DGossipFrame);
        -- Disable key capture when gossip frame is closed
        DGossipKeyFrame:EnableKeyboard(false)
    end
end

-- Simplified key handler - only handles what we need
function DGossipFrame_OnKeyDown()
    local key = arg1
    
    -- Handle ESC key to close gossip
    if key == "ESCAPE" then
        CloseGossip()
        return
    end
    
    -- Handle spacebar to select first option
    if key == "SPACE" then
        DGossipSelectOption(1)
        return
    end
    
    -- Handle number keys 1-9 for gossip options
    if key >= "1" and key <= "9" then
        local buttonIndex = tonumber(key)
        DGossipSelectOption(buttonIndex)
        return
    end
    
    -- For all other keys, let the game handle them normally
    -- We do this by temporarily disabling our keyboard capture
    DGossipKeyFrame:EnableKeyboard(false)
    
    -- Re-enable after a brief moment using a simple timer
    local reEnableTime = GetTime() + 0.05
    DGossipKeyFrame:SetScript("OnUpdate", function()
        if GetTime() >= reEnableTime then
            if DGossipFrame:IsVisible() then
                DGossipKeyFrame:EnableKeyboard(true)
            end
            DGossipKeyFrame:SetScript("OnUpdate", nil)
        end
    end)
end

-- Simplified option selection function
function DGossipSelectOption(buttonIndex)
    -- Only work if gossip frame is visible
    if not DGossipFrame:IsVisible() then
        -- DEFAULT_CHAT_FRAME:AddMessage("Gossip frame not visible")
        return
    end
    
    -- Debug: Print what we're looking for
    -- DEFAULT_CHAT_FRAME:AddMessage("Looking for button " .. buttonIndex .. " (total buttons: " .. totalGossipButtons .. ")")
    
    -- Find the actual button that corresponds to this display number
    for i = 1, NUMGOSSIPBUTTONS do
        local titleButton = getglobal("DGossipTitleButton" .. i)
        if titleButton and titleButton:IsVisible() and titleButton:GetText() and titleButton:GetText() ~= "" then
            local buttonText = titleButton:GetText()
            
            -- Extract the number from the button text using string.find (e.g., "3. Train me" -> 3)
            local _, _, numStr = string.find(buttonText, "^(%d+)%.")
            if numStr then
                local displayNum = tonumber(numStr)
                -- DEFAULT_CHAT_FRAME:AddMessage("Found button " .. i .. " with display number " .. displayNum .. ": " .. buttonText .. " (type: " .. tostring(titleButton.type) .. ", ID: " .. tostring(titleButton:GetID()) .. ")")
                
                if displayNum == buttonIndex then
                    -- DEFAULT_CHAT_FRAME:AddMessage("Triggering button " .. displayNum)
                    
                    -- Debug the function calls
                    if titleButton.type == "Available" then
                        -- DEFAULT_CHAT_FRAME:AddMessage("Calling SelectGossipAvailableQuest(" .. titleButton:GetID() .. ")")
                        SelectGossipAvailableQuest(titleButton:GetID())
                    elseif titleButton.type == "Active" then
                        -- DEFAULT_CHAT_FRAME:AddMessage("Calling SelectGossipActiveQuest(" .. titleButton:GetID() .. ")")
                        SelectGossipActiveQuest(titleButton:GetID())
                    else
                        -- DEFAULT_CHAT_FRAME:AddMessage("Calling SelectGossipOption(" .. titleButton:GetID() .. ")")
                        SelectGossipOption(titleButton:GetID())
                    end
                    
                    -- Also try the direct mouse click approach as backup
                    -- DEFAULT_CHAT_FRAME:AddMessage("Also trying direct button click")
                    DGossipTitleButton_OnClick_Direct(titleButton)
                    return
                end
            end
        end
    end
    
    -- DEFAULT_CHAT_FRAME:AddMessage("No button found for number " .. buttonIndex)
end

-- Direct button click function for debugging
function DGossipTitleButton_OnClick_Direct(button)
    if not button then return end
    
    -- DEFAULT_CHAT_FRAME:AddMessage("Direct click: type=" .. tostring(button.type) .. ", ID=" .. tostring(button:GetID()))
    
    if (button.type == "Available") then
        SelectGossipAvailableQuest(button:GetID());
    elseif (button.type == "Active") then
        SelectGossipActiveQuest(button:GetID());
    else
        SelectGossipOption(button:GetID());
    end
end

-- Function to close the gossip UI (can be called from anywhere)
function DGossipFrame_CloseUI()
    if DGossipFrame:IsVisible() then
        CloseGossip()
    end
end

-- Keep original click handler for mouse clicks (unchanged)
function DGossipTitleButton_OnClick()
    if (this.type == "Available") then
        SelectGossipAvailableQuest(this:GetID());
    elseif (this.type == "Active") then
        SelectGossipActiveQuest(this:GetID());
    else
        SelectGossipOption(this:GetID());
    end
end

function DGossipFrameUpdate()
    ClearAllGossipIcons();
    DGossipFrame.buttonIndex = 1;
    totalGossipButtons = 0; -- Reset counter
    
    DGossipGreetingText:SetText(GetGossipText());
    DGossipFrameAvailableQuestsUpdate(GetGossipAvailableQuests());
    DGossipFrameActiveQuestsUpdate(GetGossipActiveQuests());
    DGossipFrameOptionsUpdate(GetGossipOptions());

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
    
    -- Debug: Count actual visible numbered buttons
    local actualCount = 0
    for i = 1, NUMGOSSIPBUTTONS do
        local titleButton = getglobal("DGossipTitleButton" .. i)
        if titleButton and titleButton:IsVisible() and titleButton:GetText() and titleButton:GetText() ~= "" then
            local _, _, numStr = string.find(titleButton:GetText(), "^(%d+)%.")
            if numStr then
                actualCount = actualCount + 1
            end
        end
    end
    totalGossipButtons = actualCount
    -- DEFAULT_CHAT_FRAME:AddMessage("Total gossip buttons: " .. totalGossipButtons)
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
        
        -- Add numbering to the text
        local numberedText = DGossipFrame.buttonIndex .. ". " .. arg[i]
        titleButton:SetText(numberedText)
        totalGossipButtons = totalGossipButtons + 1

        titleButton:SetID(titleIndex)
        titleButton.type = "Available"

        -- CLEAR ANY EXISTING GOSSIP ICON FIRST
        local gossipIcon = getglobal(titleButton:GetName() .. "GossipIcon")
        if gossipIcon then
            gossipIcon:Hide()
        end

        if not gossipIcon then
            gossipIcon = titleButton:CreateTexture(titleButton:GetName() .. "GossipIcon", "OVERLAY")
            gossipIcon:SetWidth(16)
            gossipIcon:SetHeight(16)
            gossipIcon:SetPoint("TOPLEFT", titleButton, "TOPLEFT", 3, -5)
        end
        
        gossipIcon:SetTexture("Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\availableQuestIcon")
        gossipIcon:Show()

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
        
        -- Add numbering to the text
        local numberedText = DGossipFrame.buttonIndex .. ". " .. arg[i]
        titleButton:SetText(numberedText);
        totalGossipButtons = totalGossipButtons + 1

        titleButton:SetID(titleIndex);
        titleButton.type = "Active";
        
        local gossipIconName = titleButton:GetName() .. "GossipIcon"
        local gossipIcon = getglobal(gossipIconName)
        
        if gossipIcon then
            gossipIcon:Hide()
        end
        
        if not gossipIcon then
            gossipIcon = titleButton:CreateTexture(gossipIconName, "OVERLAY")
            gossipIcon:SetWidth(16)
            gossipIcon:SetHeight(16)
            gossipIcon:SetPoint("TOPLEFT", titleButton, "TOPLEFT", 3, -5)
        end

        gossipIcon:SetTexture("Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\activeQuestIcon");
        gossipIcon:Show()

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

        -- Add numbering to the text
        local numberedText = DGossipFrame.buttonIndex .. ". " .. arg[i]
        titleButton:SetText(numberedText);
        totalGossipButtons = totalGossipButtons + 1
        
        titleButton:SetID(titleIndex);
        titleButton.type = "Gossip";

        local gossipIconName = titleButton:GetName() .. "GossipIcon"
        local gossipIcon = getglobal(gossipIconName)
        
        if gossipIcon then
            gossipIcon:Hide()
        end
        
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

        local iconType = arg[i + 1]
        local texturePath
        
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
            local specificType = DetermineGossipIconType(arg[i])
            texturePath = "Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\" .. specificType .. "GossipIcon"
        elseif iconMap[iconType] then
            texturePath = "Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\" .. iconMap[iconType]
        else
            DEFAULT_CHAT_FRAME:AddMessage("Unknown icon type, report it to the author: " .. tostring(iconType))
            texturePath = "Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\petitionGossipIcon"
        end
        
        gossipIcon:SetTexture(texturePath);
        gossipIcon:Show()
        
        if not gossipIcon:GetTexture() then
            DEFAULT_CHAT_FRAME:AddMessage("Texture failed to load: " .. texturePath .. ", using fallback")
            gossipIcon:SetTexture("Interface\\AddOns\\DialogUI\\src\\assets\\art\\icons\\petitionGossipIcon");
        end
        
        DGossipFrame.buttonIndex = DGossipFrame.buttonIndex + 1;
        titleIndex = titleIndex + 1;
        titleButton:Show();
    end
end

-- Rest of your functions remain the same
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
    
    if string.find(text, "profession") and string.find(text, "trainer") then
        return "professionTrainer"
    elseif string.find(text, "class") and string.find(text, "trainer") then
        return "classTrainer"
    elseif string.find(text, "stable") then
        return "stablemaster"
    elseif string.find(text, "inn") then
        return "innkeeper"
    elseif string.find(text, "mailbox") then
        return "mailbox"
    elseif string.find(text, "guild master") then
        return "guildMaster"
    elseif string.find(text, "trainer") and string.find(text, "pet") then
        return "pettrainer"
    elseif string.find(text, "auction") then
        return "auctionHouse"
    elseif string.find(text, "weapon") and string.find(text, "trainer") then
        return "weaponsTrainer"
    elseif string.find(text, "deeprun") then
        return "deeprunTram"
    elseif string.find(text, "bat handler") or 
           string.find(text, "wind rider master") or 
           string.find(text, "gryphon master") or 
           string.find(text, "hippogryph master") or 
           string.find(text, "flight master") then
        return "flight"
    elseif string.find(text, "bank") then
        return "banker"
    else
        return "gossip"
    end
end

function ClearAllGossipIcons()
    for i = 1, NUMGOSSIPBUTTONS do
        local titleButton = getglobal("DGossipTitleButton" .. i)
        if titleButton then
            local gossipIcon = getglobal(titleButton:GetName() .. "GossipIcon")
            if gossipIcon then
                gossipIcon:Hide()
            end
        end
    end
end