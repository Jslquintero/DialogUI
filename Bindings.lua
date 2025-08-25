BINDING_HEADER_DIALOGUI = "DialogUI"
BINDING_NAME_DIALOGUI_ACCEPT = "Accept"
BINDING_NAME_DIALOGUI_CANCEL = "Cancel/Close"

function DIALOGUI_OnAccept()
    if DQuestFrame and DQuestFrame:IsVisible() then
        if DQuestFrameDetailPanel and DQuestFrameDetailPanel:IsVisible() then
            DQuestDetailAcceptButton_OnClick()
            return
        end
        if DQuestFrameRewardPanel and DQuestFrameRewardPanel:IsVisible() then
            DQuestRewardCompleteButton_OnClick()
            return
        end
        if DQuestFrameProgressPanel and DQuestFrameProgressPanel:IsVisible() then
            DQuestProgressCompleteButton_OnClick()
            return
        end
        local firstButton = getglobal("DQuestTitleButton1")
        if firstButton and firstButton:IsVisible() then
            firstButton:Click()
            return
        end
        return
    end
    if DGossipFrame and DGossipFrame:IsVisible() then
        DGossipSelectOption(1)
        return
    end
end

function DIALOGUI_OnCancel()
    if DQuestFrame and DQuestFrame:IsVisible() then
        HideUIPanel(DQuestFrame)
        return
    end
    if DGossipFrame and DGossipFrame:IsVisible() then
        CloseGossip()
        return
    end
end

