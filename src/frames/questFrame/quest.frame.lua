---@diagnostic disable: undefined-global
MAX_NUM_QUESTS = 32;
MAX_NUM_ITEMS = 10;
MAX_REQUIRED_ITEMS = 6;
QUEST_DESCRIPTION_GRADIENT_LENGTH = 30;
QUEST_DESCRIPTION_GRADIENT_CPS = 40;
QUESTINFO_FADE_IN = 1;

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

function DQuestFrame_OnLoad()
    this:RegisterEvent("QUEST_GREETING");
    this:RegisterEvent("QUEST_DETAIL");
    this:RegisterEvent("QUEST_PROGRESS");
    this:RegisterEvent("QUEST_COMPLETE");
    this:RegisterEvent("QUEST_FINISHED");
    this:RegisterEvent("QUEST_ITEM_UPDATE");
end

function HideDefaultFrames()
    QuestFrameGreetingPanel:Hide()
    QuestFrameDetailPanel:Hide()
    QuestFrameProgressPanel:Hide()
    QuestFrameRewardPanel:Hide()
    QuestNpcNameFrame:Hide()
    QuestFramePortrait:SetTexture()
end


function DQuestFrame_OnEvent(event)
    if (event == "QUEST_FINISHED") then
        HideUIPanel(DQuestFrame);
        return;
    end
    if ((event == "QUEST_ITEM_UPDATE") and not DQuestFrame:IsVisible()) then
        return;
    end
    
    HideDefaultFrames();
    DQuestFrame_SetPortrait();
    ShowUIPanel(DQuestFrame);
    if (not DQuestFrame:IsVisible()) then
        CloseQuest();
        return;
    end
    if (event == "QUEST_GREETING") then
        DQuestFrameGreetingPanel:Hide();
        DQuestFrameGreetingPanel:Show();
    elseif (event == "QUEST_DETAIL") then
        DQuestFrameDetailPanel:Hide();
        DQuestFrameDetailPanel:Show();
    elseif (event == "QUEST_PROGRESS") then
        DQuestFrameProgressPanel:Hide();
        DQuestFrameProgressPanel:Show();
    elseif (event == "QUEST_COMPLETE") then
        DQuestFrameRewardPanel:Hide();
        DQuestFrameRewardPanel:Show();
    elseif (event == "QUEST_ITEM_UPDATE") then
        if (DQuestFrameDetailPanel:IsVisible()) then
            DQuestFrameItems_Update("DQuestDetail");
            DQuestDetailScrollFrame:UpdateScrollChildRect();
            DQuestDetailScrollFrameScrollBar:SetValue(0);
        elseif (DQuestFrameProgressPanel:IsVisible()) then
            DQuestFrameProgressItems_Update()
            DQuestProgressScrollFrame:UpdateScrollChildRect();
            DQuestProgressScrollFrameScrollBar:SetValue(0);
        elseif (DQuestFrameRewardPanel:IsVisible()) then
            DQuestFrameItems_Update("DQuestReward");
            DQuestRewardScrollFrame:UpdateScrollChildRect();
            DQuestRewardScrollFrameScrollBar:SetValue(0);
        end
    end
end

function DQuestFrame_SetPortrait()
    DQuestFrameNpcNameText:SetText(UnitName("npc"));
    if (UnitExists("npc")) then
        SetPortraitTexture(DQuestFramePortrait, "npc");
    else
        DQuestFramePortrait:SetTexture("Interface\\QuestFrame\\UI-QuestLog-BookIcon");
    end
end

function DQuestFrameRewardPanel_OnShow()
    DQuestFrameDetailPanel:Hide();
    DQuestFrameGreetingPanel:Hide();
    DQuestFrameProgressPanel:Hide();
    HideDefaultFrames();
    local material = QuestFrame_GetMaterial();
    DQuestFrame_SetMaterial(DQuestFrameRewardPanel, material);
    DQuestRewardTitleText:SetText(GetTitleText());
    DQuestFrame_SetTitleTextColor(DQuestRewardTitleText, material);
    QuestRewardText:SetText(GetRewardText());
    DQuestFrame_SetTextColor(DQuestRewardText, material);
    DQuestFrameItems_Update("DQuestReward");
    DQuestRewardScrollFrame:UpdateScrollChildRect();
    DQuestRewardScrollFrameScrollBar:SetValue(0);
    if (QUEST_FADING_DISABLE == "0") then
        DQuestRewardScrollChildFrame:SetAlpha(0);
        UIFrameFadeIn(DQuestRewardScrollChildFrame, QUESTINFO_FADE_IN);
    end
end

function DQuestRewardCancelButton_OnClick()
    DeclineQuest();
    PlaySound("igQuestCancel");
end

function DQuestRewardCompleteButton_OnClick()
    if (DQuestFrameRewardPanel.itemChoice == 0 and GetNumQuestChoices() > 0) then
        QuestChooseRewardError();
    else
        GetQuestReward(DQuestFrameRewardPanel.itemChoice);
        PlaySound("igQuestListComplete");
    end
end

function DQuestProgressCompleteButton_OnClick()
    CompleteQuest();
    -- PlaySound("igQuestListComplete");
end

function DQuestGoodbyeButton_OnClick()
    DeclineQuest();
    PlaySound("igQuestCancel");
end

function DQuestItem_OnClick()
    if (IsControlKeyDown()) then
        if (this.rewardType ~= "spell") then
            DressUpItemLink(GetQuestItemLink(this.type, this:GetID()));
        end
    elseif (IsShiftKeyDown()) then
        if (ChatFrameEditBox:IsVisible() and this.rewardType ~= "spell") then
            ChatFrameEditBox:Insert(GetQuestItemLink(this.type, this:GetID()));
        end
    end
end

function DQuestRewardItem_OnClick()
    if (IsControlKeyDown()) then
        if (this.rewardType ~= "spell") then
            DressUpItemLink(GetQuestItemLink(this.type, this:GetID()));
        end
    elseif (IsShiftKeyDown()) then
        if (ChatFrameEditBox:IsVisible()) then
            ChatFrameEditBox:Insert(GetQuestItemLink(this.type, this:GetID()));
        end
    elseif (this.type == "choice") then
        QuestRewardItemHighlight:SetPoint("TOPLEFT", this, "TOPLEFT", -8, 7);
        QuestRewardItemHighlight:Show();
        DQuestFrameRewardPanel.itemChoice = this:GetID();
    end
end

function DQuestFrameProgressPanel_OnShow()
    DQuestFrameRewardPanel:Hide();
    DQuestFrameDetailPanel:Hide();
    DQuestFrameGreetingPanel:Hide();
    HideDefaultFrames();
    message("DQuestFrameProgressPanel_OnShow");
    local material = QuestFrame_GetMaterial();
    DQuestFrame_SetMaterial(DQuestFrameProgressPanel, material);
    DQuestProgressTitleText:SetText(GetTitleText());
    DQuestFrame_SetTitleTextColor(DQuestProgressTitleText, material);
    QuestProgressText:SetText(GetProgressText());
    DQuestFrame_SetTextColor(DQuestProgressText, material);
    if (IsQuestCompletable()) then
        QuestFrameCompleteButton:Enable();
    else
        QuestFrameCompleteButton:Disable();
    end
    QuestFrameProgressItems_Update();
    if (QUEST_FADING_DISABLE == "0") then
        QuestProgressScrollChildFrame:SetAlpha(0);
        UIFrameFadeIn(DQuestProgressScrollChildFrame, QUESTINFO_FADE_IN);
    end
end

function QuestFrameProgressItems_Update()
    local numRequiredItems = GetNumQuestItems();
    local questItemName = "QuestProgressItem";
    if (numRequiredItems > 0 or GetQuestMoneyToGet() > 0) then
        QuestProgressRequiredItemsText:Show();

        -- If there's money required then anchor and display it
        if (GetQuestMoneyToGet() > 0) then
            MoneyFrame_Update("QuestProgressRequiredMoneyFrame", GetQuestMoneyToGet());

            if (GetQuestMoneyToGet() > GetMoney()) then
                -- Not enough money
                QuestProgressRequiredMoneyText:SetTextColor(0, 0, 0);
                SetMoneyFrameColor("QuestProgressRequiredMoneyFrame", 1.0, 0.1, 0.1);
            else
                QuestProgressRequiredMoneyText:SetTextColor(0.2, 0.2, 0.2);
                SetMoneyFrameColor("QuestProgressRequiredMoneyFrame", 1.0, 1.0, 1.0);
            end
            QuestProgressRequiredMoneyText:Show();
            QuestProgressRequiredMoneyFrame:Show();

            -- Reanchor required item
            getglobal(questItemName .. 1):SetPoint("TOPLEFT", "QuestProgressRequiredMoneyText", "BOTTOMLEFT", 0, -10);
        else
            QuestProgressRequiredMoneyText:Hide();
            QuestProgressRequiredMoneyFrame:Hide();

            getglobal(questItemName .. 1):SetPoint("TOPLEFT", "QuestProgressRequiredItemsText", "BOTTOMLEFT", -3, -5);
        end

        for i = 1, numRequiredItems, 1 do
            local requiredItem = getglobal(questItemName .. i);
            requiredItem.type = "required";
            local name, texture, numItems = GetQuestItemInfo(requiredItem.type, i);
            SetItemButtonCount(requiredItem, numItems);
            SetItemButtonTexture(requiredItem, texture);
            requiredItem:Show();
            getglobal(questItemName .. i .. "Name"):SetText(name);

        end
    else
        QuestProgressRequiredMoneyText:Hide();
        QuestProgressRequiredMoneyFrame:Hide();
        QuestProgressRequiredItemsText:Hide();
    end
    for i = numRequiredItems + 1, MAX_REQUIRED_ITEMS, 1 do
        getglobal(questItemName .. i):Hide();
    end
    QuestProgressScrollFrame:UpdateScrollChildRect();
    QuestProgressScrollFrameScrollBar:SetValue(0);
end

function DQuestFrameGreetingPanel_OnShow()
    DQuestFrameRewardPanel:Hide();
    DQuestFrameProgressPanel:Hide();
    DQuestFrameDetailPanel:Hide();
    if (QUEST_FADING_DISABLE == "0") then
        DQuestGreetingScrollChildFrame:SetAlpha(0);
        UIFrameFadeIn(DQuestGreetingScrollChildFrame, QUESTINFO_FADE_IN);
    end

    local material = QuestFrame_GetMaterial();
    DQuestFrame_SetMaterial(DQuestFrameGreetingPanel, material);
    DGreetingText:SetText(GetGreetingText());
    SetFontColor(DGreetingText, "Ivory");
    SetFontColor(DCurrentQuestsText, "Ivory");
    SetFontColor(DAvailableQuestsText, "Ivory");
    local numActiveQuests = GetNumActiveQuests();
    local numAvailableQuests = GetNumAvailableQuests();
    if (numActiveQuests == 0) then
        DCurrentQuestsText:Hide();
        
    else
        DCurrentQuestsText:SetPoint("TOPLEFT", "DGreetingText", "BOTTOMLEFT", 0, -10);
        DCurrentQuestsText:Show();
        DQuestTitleButton1:SetPoint("TOPLEFT", "DCurrentQuestsText", "BOTTOMLEFT", -10, -5);
        for i = 1, numActiveQuests, 1 do
            local questTitleButton = getglobal("QuestTitleButton" .. i);
            questTitleButton:SetText(GetActiveTitle(i));
            questTitleButton:SetHeight(questTitleButton:GetTextHeight() + 2);
            questTitleButton:SetID(i);
            questTitleButton.isActive = 1;
            questTitleButton:Show();
            if (i > 1) then
                questTitleButton:SetPoint("TOPLEFT", "QuestTitleButton" .. (i - 1), "BOTTOMLEFT", 0, 0)
            end
        end
    end
    if (numAvailableQuests == 0) then
        DAvailableQuestsText:Hide();
        
    else
        if (numActiveQuests > 0) then
            QuestGreetingFrameHorizontalBreak:SetPoint("TOPLEFT", "QuestTitleButton" .. numActiveQuests, "BOTTOMLEFT",
                22, -10);
            
            DAvailableQuestsText:SetPoint("TOPLEFT", "QuestGreetingFrameHorizontalBreak", "BOTTOMLEFT", -12, -10);
        else
            DAvailableQuestsText:SetPoint("TOPLEFT", "DGreetingText", "BOTTOMLEFT", 0, -10);
        end
        DAvailableQuestsText:Show();
        getglobal("QuestTitleButton" .. (numActiveQuests + 1)):SetPoint("TOPLEFT", "DAvailableQuestsText", "BOTTOMLEFT",
            -10, -5);
        for i = (numActiveQuests + 1), (numActiveQuests + numAvailableQuests), 1 do
            local questTitleButton = getglobal("QuestTitleButton" .. i);
            questTitleButton:SetText(GetAvailableTitle(i - numActiveQuests));
            questTitleButton:SetHeight(questTitleButton:GetTextHeight() + 2);
            questTitleButton:SetID(i - numActiveQuests);
            questTitleButton.isActive = 0;
            questTitleButton:Show();
            if (i > numActiveQuests + 1) then
                questTitleButton:SetPoint("TOPLEFT", "QuestTitleButton" .. (i - 1), "BOTTOMLEFT", 0, 0)
            end
        end
    end
    for i = (numActiveQuests + numAvailableQuests + 1), MAX_NUM_QUESTS, 1 do
        getglobal("QuestTitleButton" .. i):Hide();
    end
end

function DQuestFrame_OnShow()
    PlaySound("igQuestListOpen");
end

function DQuestFrame_OnHide()
    DQuestFrameGreetingPanel:Hide();
    DQuestFrameDetailPanel:Hide();
    DQuestFrameRewardPanel:Hide();
    DQuestFrameProgressPanel:Hide();
    CloseQuest();
    PlaySound("igQuestListClose");
end

function DQuestTitleButton_OnClick()
    if (this.isActive == 1) then
        SelectActiveQuest(this:GetID());
    else
        SelectAvailableQuest(this:GetID());
    end
    PlaySound("igQuestListSelect");
end

function QuestMoneyFrame_OnLoad()
    MoneyFrame_OnLoad();
    MoneyFrame_SetType("STATIC");
end

function DQuestFrameItems_Update(questState)
    local isQuestLog = 0;
    if (questState == "QuestLog") then
        isQuestLog = 1;
    end
    local numQuestRewards;
    local numQuestChoices;
    local numQuestSpellRewards = 0;
    local money;
    local spacerFrame;
    if (isQuestLog == 1) then
        numQuestRewards = GetNumQuestLogRewards();
        numQuestChoices = GetNumQuestLogChoices();
        if (GetQuestLogRewardSpell()) then
            numQuestSpellRewards = 1;
        end
        money = GetQuestLogRewardMoney();
        spacerFrame = QuestLogSpacerFrame;
    else
        numQuestRewards = GetNumQuestRewards();
        numQuestChoices = GetNumQuestChoices();
        if (GetRewardSpell()) then
            numQuestSpellRewards = 1;
        end
        money = GetRewardMoney();
        spacerFrame = QuestSpacerFrame;
    end

    local totalRewards = numQuestRewards + numQuestChoices + numQuestSpellRewards;
    local questItemName = questState .. "Item";
    local material = QuestFrame_GetMaterial();
    local questItemReceiveText = getglobal(questState .. "ItemReceiveText")
    if (totalRewards == 0 and money == 0) then
        getglobal(questState .. "RewardTitleText"):Hide();
    else
        getglobal(questState .. "RewardTitleText"):Show();
        DQuestFrame_SetTitleTextColor(getglobal(questState .. "RewardTitleText"), material);
        DQuestFrame_SetAsLastShown(getglobal(questState .. "RewardTitleText"), spacerFrame);
    end
    if (money == 0) then
        getglobal(questState .. "MoneyFrame"):Hide();
    else
        getglobal(questState .. "MoneyFrame"):Show();
        DQuestFrame_SetAsLastShown(getglobal(questState .. "MoneyFrame"), spacerFrame);
        MoneyFrame_Update(questState .. "MoneyFrame", money);
    end

    -- Hide unused rewards
    for i = totalRewards + 1, MAX_NUM_ITEMS, 1 do
        getglobal(questItemName .. i):Hide();
    end

    local questItem, name, texture, isTradeskillSpell, quality, isUsable, numItems = 1;
    local rewardsCount = 0;

    -- Setup choosable rewards
    if (numQuestChoices > 0) then
        local itemChooseText = getglobal(questState .. "ItemChooseText");
        itemChooseText:Show();
        DQuestFrame_SetTextColor(itemChooseText, material);
        DQuestFrame_SetAsLastShown(itemChooseText, spacerFrame);

        local index;
        local baseIndex = rewardsCount;
        for i = 1, numQuestChoices, 1 do
            index = i + baseIndex;
            questItem = getglobal(questItemName .. index);
            questItem.type = "choice";
            numItems = 1;
            if (isQuestLog == 1) then
                name, texture, numItems, quality, isUsable = GetQuestLogChoiceInfo(i);
            else
                name, texture, numItems, quality, isUsable = GetQuestItemInfo(questItem.type, i);
            end
            questItem:SetID(i)
            questItem:Show();
            -- For the tooltip
            questItem.rewardType = "item"
            DQuestFrame_SetAsLastShown(questItem, spacerFrame);
            getglobal(questItemName .. index .. "Name"):SetText(name);
            SetItemButtonCount(questItem, numItems);
            SetItemButtonTexture(questItem, texture);
            if (isUsable) then
                SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0);
                SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0);
            else
                SetItemButtonTextureVertexColor(questItem, 0.9, 0, 0);
                SetItemButtonNameFrameVertexColor(questItem, 0.9, 0, 0);
            end
            if (i > 1) then
                if (mod(i, 2) == 1) then
                    questItem:SetPoint("TOPLEFT", questItemName .. (index - 2), "BOTTOMLEFT", 0, -2);
                else
                    questItem:SetPoint("TOPLEFT", questItemName .. (index - 1), "TOPRIGHT", 1, 0);
                end
            else
                questItem:SetPoint("TOPLEFT", itemChooseText, "BOTTOMLEFT", -3, -5);
            end
            rewardsCount = rewardsCount + 1;
        end
    else
        getglobal(questState .. "ItemChooseText"):Hide();
    end

    -- Setup spell rewards
    if (numQuestSpellRewards > 0) then
        local learnSpellText = getglobal(questState .. "SpellLearnText");
        learnSpellText:Show();
        DQuestFrame_SetTextColor(learnSpellText, material);
        DQuestFrame_SetAsLastShown(learnSpellText, spacerFrame);

        -- Anchor learnSpellText if there were choosable rewards
        if (rewardsCount > 0) then
            learnSpellText:SetPoint("TOPLEFT", questItemName .. rewardsCount, "BOTTOMLEFT", 3, -5);
        else
            learnSpellText:SetPoint("TOPLEFT", questState .. "RewardTitleText", "BOTTOMLEFT", 0, -5);
        end

        if (isQuestLog == 1) then
            texture, name, isTradeskillSpell = GetQuestLogRewardSpell();
        else
            texture, name, isTradeskillSpell = GetRewardSpell();
        end

        if (isTradeskillSpell) then
            learnSpellText:SetText(REWARD_TRADESKILL_SPELL);
        else
            learnSpellText:SetText(REWARD_SPELL);
        end

        rewardsCount = rewardsCount + 1;
        questItem = getglobal(questItemName .. rewardsCount);
        questItem:Show();
        -- For the tooltip
        questItem.rewardType = "spell";
        SetItemButtonCount(questItem, 0);
        SetItemButtonTexture(questItem, texture);
        getglobal(questItemName .. rewardsCount .. "Name"):SetText(name);
        questItem:SetPoint("TOPLEFT", learnSpellText, "BOTTOMLEFT", -3, -5);
    else
        getglobal(questState .. "SpellLearnText"):Hide();
    end

    -- Setup mandatory rewards
    if (numQuestRewards > 0 or money > 0) then
        DQuestFrame_SetTextColor(questItemReceiveText, material);
        -- Anchor the reward text differently if there are choosable rewards
        if (numQuestSpellRewards > 0) then
            questItemReceiveText:SetText(TEXT(REWARD_ITEMS));
            questItemReceiveText:SetPoint("TOPLEFT", questItemName .. rewardsCount, "BOTTOMLEFT", 3, -5);
        elseif (numQuestChoices > 0) then
            questItemReceiveText:SetText(TEXT(REWARD_ITEMS));
            local index = numQuestChoices;
            if (mod(index, 2) == 0) then
                index = index - 1;
            end
            questItemReceiveText:SetPoint("TOPLEFT", questItemName .. index, "BOTTOMLEFT", 3, -5);
        else
            questItemReceiveText:SetText(TEXT(REWARD_ITEMS_ONLY));
            questItemReceiveText:SetPoint("TOPLEFT", questState .. "RewardTitleText", "BOTTOMLEFT", 3, -5);
        end
        questItemReceiveText:Show();
        DQuestFrame_SetAsLastShown(questItemReceiveText, spacerFrame);
        -- Setup mandatory rewards
        local index;
        local baseIndex = rewardsCount;
        for i = 1, numQuestRewards, 1 do
            index = i + baseIndex;
            questItem = getglobal(questItemName .. index);
            questItem.type = "reward";
            numItems = 1;
            if (isQuestLog == 1) then
                name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(i);
            else
                name, texture, numItems, quality, isUsable = GetQuestItemInfo(questItem.type, i);
            end
            questItem:SetID(i)
            questItem:Show();
            -- For the tooltip
            questItem.rewardType = "item";
            DQuestFrame_SetAsLastShown(questItem, spacerFrame);
            getglobal(questItemName .. index .. "Name"):SetText(name);
            SetItemButtonCount(questItem, numItems);
            SetItemButtonTexture(questItem, texture);
            if (isUsable) then
                SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0);
                SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0);
            else
                SetItemButtonTextureVertexColor(questItem, 0.5, 0, 0);
                SetItemButtonNameFrameVertexColor(questItem, 1.0, 0, 0);
            end

            if (i > 1) then
                if (mod(i, 2) == 1) then
                    questItem:SetPoint("TOPLEFT", questItemName .. (index - 2), "BOTTOMLEFT", 0, -2);
                else
                    questItem:SetPoint("TOPLEFT", questItemName .. (index - 1), "TOPRIGHT", 1, 0);
                end
            else
                questItem:SetPoint("TOPLEFT", questState .. "ItemReceiveText", "BOTTOMLEFT", -3, -5);
            end
            rewardsCount = rewardsCount + 1;
        end
    else
        questItemReceiveText:Hide();
    end
    if (questState == "QuestReward") then
        QuestFrameCompleteQuestButton:Enable();
        DQuestFrameRewardPanel.itemChoice = 0;
        QuestRewardItemHighlight:Hide();
    end
end

function DQuestFrameDetailPanel_OnShow()
    DQuestFrameRewardPanel:Hide();
    DQuestFrameProgressPanel:Hide();
    DQuestFrameGreetingPanel:Hide();
    HideDefaultFrames();

    local material = QuestFrame_GetMaterial();
    DQuestFrame_SetMaterial(DQuestFrameDetailPanel, material);
    DQuestFrameNpcNameText:SetText(GetTitleText());
    DQuestDescription:SetText(GetQuestText());
    DQuestObjectiveText:SetText(GetObjectiveText());
    SetFontColor(DQuestFrameNpcNameText, "DarkBrown");
    SetFontColor(DQuestDescription, "DarkBrown");
    SetFontColor(DQuestObjectiveText, "DarkBrown");
    DQuestFrame_SetAsLastShown(DQuestObjectiveText, QuestSpacerFrame);
    DQuestFrameItems_Update("DQuestDetail");
    DQuestDetailScrollFrame:UpdateScrollChildRect();
    DQuestDetailScrollFrameScrollBar:SetValue(0);

    -- Hide Objectives and rewards until the text is completely displayed
    TextAlphaDependentFrame:SetAlpha(0);
    QuestFrameAcceptButton:Disable();

    DQuestFrameDetailPanel.fading = 1;
    DQuestFrameDetailPanel.fadingProgress = 0;
    DQuestDescription:SetAlphaGradient(0, QUEST_DESCRIPTION_GRADIENT_LENGTH);
    if (QUEST_FADING_DISABLE == "1") then
        DQuestFrameDetailPanel.fadingProgress = 1024;
    end
end

function DQuestFrameDetailPanel_OnUpdate(elapsed)
    if (this.fading) then
        this.fadingProgress = this.fadingProgress + (elapsed * QUEST_DESCRIPTION_GRADIENT_CPS);
        PlaySound("WriteQuest");
        if (not QuestDescription:SetAlphaGradient(this.fadingProgress, QUEST_DESCRIPTION_GRADIENT_LENGTH)) then
            this.fading = nil;
            -- Show Quest Objectives and Rewards
            if (QUEST_FADING_DISABLE == "0") then
                UIFrameFadeIn(TextAlphaDependentFrame, QUESTINFO_FADE_IN);
            else
                TextAlphaDependentFrame:SetAlpha(1);
            end
            QuestFrameAcceptButton:Enable();
        end
    end
end

function DQuestDetailAcceptButton_OnClick()
    AcceptQuest();
end

function DQuestDetailDeclineButton_OnClick()
    DeclineQuest();
    PlaySound("igQuestCancel");
end

function DQuestFrame_SetMaterial(frame, material)

end

function QuestFrame_GetMaterial()
    local material = GetQuestBackgroundMaterial();
    if (not material) then
        material = "Parchment";
    end
    return material;
end

function DQuestFrame_SetTitleTextColor(fontString, material)
    local temp, materialTitleTextColor = GetMaterialTextColors(material);
    fontString:SetTextColor(materialTitleTextColor[1], materialTitleTextColor[2], materialTitleTextColor[3]);
end

function DQuestFrame_SetTextColor(fontString, material)
    local materialTextColor = GetMaterialTextColors(material);
    fontString:SetTextColor(materialTextColor[1], materialTextColor[2], materialTextColor[3]);
end