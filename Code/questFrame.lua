local dquestFrame = CreateFrame("Frame", nil);
dquestFrame.Background = CreateFrame("Frame", "dquestFrame", UIParent);
dquestFrame.QuestDetail = CreateFrame("Frame", nil, dquestFrame.Background);
dquestFrame.QuestGreeting = CreateFrame("Frame", nil, dquestFrame.Background);
dquestFrame.QuestProgress = CreateFrame("Frame", nil, dquestFrame.Background);
dquestFrame.QuestComplete = CreateFrame("Frame", nil, dquestFrame.Background);

function SetSize(frame, width, height)
    frame:SetWidth(width)
    frame:SetHeight(height)
end

local COLORS = {
    --ColorKey = {r, g, b}

    DarkBrown = { 0.19, 0.17, 0.13 },
    LightBrown = { 0.50, 0.36, 0.24 },
    Ivory = { 0.87, 0.86, 0.75 },

    DarkModeGrey90 = { 0.9, 0.9, 0.9 },
    DarkModeGrey70 = { 0.7, 0.7, 0.7 },
    DarkModeGrey50 = { 0.5, 0.5, 0.5 },
    DarkModeGold = { 1, 0.98, 0.8 },
    DarkModeGoldDim = { 0.796, 0.784, 0.584 },
};

local function SetFontColor(fontObject, key)
    local color = COLORS[key];
    fontObject:SetTextColor(color[1], color[2], color[3]);
end


function CreateQuestFrame()
    SetSize(dquestFrame, 512, 512)
    dquestFrame:SetPoint("RIGHT", 0, 0)
    dquestFrame:SetBackdrop({
        bgFile = "Interface\\addons\\DialogUI\\UI\\Parchment.png",
        edgeSize = 5,
        insets = { left = 8, right = 6, top = 8, bottom = 8 }
    })
    dquestFrame:SetMovable(true)
    dquestFrame:EnableMouse(true)
end

-- Create a quest title
function QuestFrameDetailPanel_OnShow()
    QuestFrame:Hide()
    CreateQuestFrame()
    dquestFrame.QuestDetail.questTitle = dquestFrame:CreateFontString("dquestTitle", "OVERLAY", "GameFontNormal")
    dquestFrame.QuestDetail.questTitle:SetPoint("TOP", -80, -50)
    dquestFrame.QuestDetail.questTitle:SetText(GetTitleText())
end

function QuestFrameGreetingPanel_OnShow()
    QuestFrameRewardPanel:Hide();
    QuestFrameProgressPanel:Hide();
    QuestFrameDetailPanel:Hide();
    QuestFrameGreetingPanel:Hide();

    CreateQuestFrame()

    GreetingText = dquestFrame:CreateFontString("greetingText", nil, nil)
    CurrentQuestsText = dquestFrame:CreateFontString("currentQuestsText", nil, nil)
    AvailableQuestsText = dquestFrame:CreateFontString("availableQuestsText", nil, nil)
    QuestTitleText = dquestFrame:CreateFontString("questTitleText", nil, nil)


    QuestFrameFontString_OnLoad(
        GreetingText,
        18,
        {
            "TOPLEFT",
            90,
            -50
        },
        GetGreetingText(),
        350,
        "LEFT",
        "TOP",
        4,
        "DarkBrown"
    )

    local numActiveQuests = GetNumActiveQuests();
    local numAvailableQuests = GetNumAvailableQuests();

    if (numActiveQuests == 0) then
        CurrentQuestsText:Hide();
    else
        QuestFrameFontString_OnLoad(
            CurrentQuestsText,
            18,
            {
                "TOPLEFT",
                "greetingText",
                "BOTTOMLEFT",
                0,
                -10
            },
            "Current Quests",
            350,
            "LEFT",
            "TOP",
            4,
            "DarkBrown"
        )
        CurrentQuestsText:Show();

        for i = 1, numActiveQuests do
            CreateButtonWithText(
                QuestTitleText,
                GetActiveTitle(i),
                0,
                -10 * i
            )
        end
    end

    if (numAvailableQuests == 0) then
        AvailableQuestsText:Hide();
    else
        if (numActiveQuests > 0) then
            QuestFrameFontString_OnLoad(
                AvailableQuestsText,
                18,
                {
                    "TOPLEFT",
                    "currentQuestsText",
                    "BOTTOMLEFT",
                    0,
                    -10
                },
                "Available Quests",
                350,
                "LEFT",
                "TOP",
                4,
                "DarkBrown"
            )
        else
            AvailableQuestsText:SetPoint("TOPLEFT", "greetingText", "BOTTOMLEFT", 0, -10)
        end
        AvailableQuestsText:Show();

        for i=(numActiveQuests+1), (numActiveQuests + numAvailableQuests) do
            CreateButtonWithText(
                QuestTitleText,
                GetAvailableTitle(i - numActiveQuests),
                0,
                -10 * i
            )
        end

    end

    button:Show() -- Show the button
end

function QuestFrameFontString_OnLoad(fontString, fontSize, fontPoint, text, width, justifyH, justifyV, spacing,
                                     fontColor)
    fontString:SetFont("Interface\\addons\\DialogUI\\Font\\frizqt___cyr.ttf", fontSize)
    fontString:SetPoint(fontPoint[1], fontPoint[2], fontPoint[3], fontPoint[4], fontPoint[5])
    fontString:SetText(text)
    fontString:SetWidth(width)
    fontString:SetJustifyH(justifyH)
    fontString:SetJustifyV(justifyV)
    fontString:SetSpacing(4)
    SetFontColor(fontString, fontColor)

    return fontString
end

function CreateButtonWithText(parentFrame, questTitleText, buttonOffsetX, buttonOffsetY)
    local button = CreateFrame("Button", "ButtonFrame", dquestFrame, nil)
    ButtonTitle = button:CreateFontString("buttonTitle", button, nil)
    ButtonTitle:SetFont("Interface\\addons\\DialogUI\\Font\\frizqt___cyr.ttf", 15)
    ButtonTitle:SetPoint("CENTER", 0, 0)
    SetSize(button, string.len(questTitleText)*10, 40)

    button:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", buttonOffsetX, buttonOffsetY)
    button:SetBackdrop({
        bgFile = "Interface\\addons\\DialogUI\\UI\\OptionBackground-Common.png",
        edgeSize = 5,
        insets = { left = 8, right = 6, top = 8, bottom = 8 }
    })

    ButtonTitle:SetText(questTitleText)
    SetFontColor(ButtonTitle, "Ivory")
    button:Show()

    button:SetScript("OnClick", function()
        print("Button Clicked")
    end)

end
