local function GetRaidSizeAndDifficulty()
    if not IsInRaid() then
        return nil, "You are not in a raid group."
    end

    local difficulty = GetRaidDifficulty()

    if difficulty == 1 or difficulty == 3 then
        return 10, nil
    elseif difficulty == 2 or difficulty == 4 then
        return 25, nil
    else
        return nil, "Unable to determine raid difficulty."
    end
end

local function AnnounceRaidCount(raidName, additional, channel) 
    if not IsInRaid() then
        local noGroupMessage = string.format("LFM %s need all /w me spec gs %s", tostring(raidName), tostring(additional))
        if channel == "YELL" then
            SendChatMessage(noGroupMessage, channel)
        else
            SendChatMessage(noGroupMessage, "CHANNEL", nil, channel)
        end
        return
    end

    local raidSize, error = GetRaidSizeAndDifficulty()
    if error then
        print(error)
        return
    end
    
    local numPlayers = GetNumGroupMembers()
    local group5Count = 0
    local tankCount = 0
    
    for i = 1, GetNumGroupMembers() do
        local name, rank, subgroup, _, _, _, _, _, _, role = GetRaidRosterInfo(i)
        if role == "MAINTANK" or role == "MAINASSIST" then
            tankCount = tankCount + 1
        end
       
        if subgroup == 5 then
            group5Count = group5Count + 1
        end
    end
        
    local requiredMembers = "Need"
    local reqTanks = 2
    if tankCount < 2 then
        requiredMembers = requiredMembers .. " tank"
    end
    
    local reqHealers = 2
    if raidSize > 20 then
        reqHealers = 5
    end
    if group5Count < reqHealers then
        requiredMembers = requiredMembers .. " heal"
    end
    
    local dpsCount = numPlayers - group5Count - tankCount
    local reqDpses = raidSize - reqHealers - reqTanks - dpsCount
    if reqDpses > 0 then
        requiredMembers = requiredMembers .. " dps"
    end
    
    local message = string.format("LFM %s %s /w me spec gs (%d/%d) %s", tostring(raidName), requiredMembers, numPlayers, raidSize, tostring(additional))
    if channel == nil or channel == "" then
        SendChatMessage(message, "RAID")
        return
    end

    if channel == "YELL" then
        SendChatMessage(message, channel)
        return
    end
end

-- UI Setup
local frame = CreateFrame("Frame", "PuggerFrame", UIParent)
frame:SetSize(300, 360)
frame:SetPoint("CENTER", UIParent, "CENTER")
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
frame:SetBackdropColor(0, 0, 0, 1)

frame.title = frame:CreateFontString(nil, "OVERLAY")
frame.title:SetFontObject("GameFontHighlight")
frame.title:SetPoint("TOP", frame, "TOP", 0, -10)
frame.title:SetText("Pugger Addon")

frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Close Button
local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT")

-- Raid Name Input
local raidNameLabel = frame:CreateFontString(nil, "OVERLAY")
raidNameLabel:SetFontObject("GameFontHighlight")
raidNameLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -40)
raidNameLabel:SetText("Raid Name:")

local raidNameInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
raidNameInput:SetSize(180, 30)
raidNameInput:SetPoint("TOPLEFT", raidNameLabel, "BOTTOMLEFT", 0, -10)
raidNameInput:SetAutoFocus(false)

-- Additional Info Input
local additionalLabel = frame:CreateFontString(nil, "OVERLAY")
additionalLabel:SetFontObject("GameFontHighlight")
additionalLabel:SetPoint("TOPLEFT", raidNameInput, "BOTTOMLEFT", 0, -10)
additionalLabel:SetText("Additional Info:")

local additionalInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
additionalInput:SetSize(180, 30)
additionalInput:SetPoint("TOPLEFT", additionalLabel, "BOTTOMLEFT", 0, -10)
additionalInput:SetAutoFocus(false)

-- Channel Input
local channelLabel = frame:CreateFontString(nil, "OVERLAY")
channelLabel:SetFontObject("GameFontHighlight")
channelLabel:SetPoint("TOPLEFT", additionalInput, "BOTTOMLEFT", 0, -10)
channelLabel:SetText("Channel:")

local channelInput = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
channelInput:SetSize(180, 30)
channelInput:SetPoint("TOPLEFT", channelLabel, "BOTTOMLEFT", 0, -10)
channelInput:SetAutoFocus(false)

-- Announce Button
local announceButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
announceButton:SetSize(100, 30)
announceButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 20)
announceButton:SetText("Announce")
announceButton:SetNormalFontObject("GameFontNormalLarge")
announceButton:SetHighlightFontObject("GameFontHighlightLarge")

announceButton:SetScript("OnClick", function()
    local raidName = raidNameInput:GetText()
    local additional = additionalInput:GetText()
    local channel = channelInput:GetText()
    AnnounceRaidCount(raidName, additional, channel)
end)

-- Slash command to show/hide the frame
SLASH_PUGGERUI1 = "/puggerui"
SlashCmdList["PUGGERUI"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

-- Original slash command setup to handle input via command line
SLASH_PUGGER1 = "/pugger"
SlashCmdList["PUGGER"] = function(input)
    local args = {}
    for word in string.gmatch(input, "%S+") do
        table.insert(args, word)
    end

    local raidName = args[1] or ""
    local additional = args[2] or ""
    local channel = args[3] or ""
    local channel0 = args[4] or ""

    AnnounceRaidCount(raidName, additional, channel, channel0)
end
