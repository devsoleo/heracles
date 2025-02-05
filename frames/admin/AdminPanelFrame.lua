-- Functions
function AdminPanelFrame_ClearList()
    UI_ClearList("FS_ParticipantsListItem")

    InviteFrame_ToggleSubmitButton()
end

-- Events
function B_StartEvent_OnClick(self)
    print("Button " .. self:GetName() .. " is pressed")

    setInterval(5, 0.5, function()
        for p, status in pairs(NOTSVPC["admin"]["participants"]) do
            if (status == false) then
                SendAddonMessage(PREFIX, "start^key", "WHISPER", p)
            end
        end
    end)
end

function B_PauseEvent_OnClick(self)
    print("Button " .. self:GetName() .. " is pressed")
end

function B_StopEvent_OnClick(self)
    format_storage()

    AdminPanelFrame_ClearList()

    NOTSVPC["admin"]["participants"] = {}

    F_AdminPanel:Hide()

    print("[ADMIN] Event annulé !")
end

function B_KeyApply_OnClick(self)
    NOTSVPC["admin"]["event"]["key"] = EB_EventKey:GetText()

    displayMissions(NOTSVPC["admin"]["event"]["key"])
end

function B_SendAlertToPlayers_OnClick(self)
    print("Button " .. self:GetName() .. " is pressed with input : " .. EB_AlertToPlayers:GetText())

    if (EB_AlertToPlayers:GetText() == "") then
        -- No message
        return
    end

    for p, status in pairs(NOTSVPC["admin"]["participants"]) do
        SendAddonMessage(PREFIX, "alert^" .. EB_AlertToPlayers:GetText(), "WHISPER", p) -- TODO : Verifier cooldown
    end

    EB_AlertToPlayers:SetText("")
end

function displayParticipants()
    local pa = {}

    for i, p in pairs(NOTSVPC["admin"]["participants"]) do
        table.insert(pa, i)
    end

    UI_DisplayList(SF_ParticipantsList, pa)
end

function parseEventKey(eventKey)
    if eventKey == nil or eventKey == "" then
        print("[ADMIN] Clé vide !")

        return
    end

    eventKey = url_decode(base64_decode(eventKey))

    local event = {}

    local splitedEventKey = str_split_brackets(eventKey)

    local headers = splitedEventKey[1]
    local missions = splitedEventKey[2]

    local headersList = str_split(headers, ";")
    local missionsList = str_split(missions, ";")

    -- Traitement des headers
    event["headers"] = {}

    local langHeader = str_split(headersList[1], "&&")
    local langId = 1 -- enUS en langue par défaut

    for i, text in ipairs(langHeader) do
        if text == GetLocale() then
            langId = i
        end
    end

    event["headers"]["lang"] = langId
    event["headers"]["version"] = headersList[2]

    -- Traitement des headers
    event["missions"] = {}

    for i, m in ipairs(missionsList) do
        local mission = str_split(m, "&&")

        event["missions"][i] = {}
        event["missions"][i]["args"] = {}
        event["missions"][i]["type"] = mission[1]

        for j, v in ipairs(mission) do
            if (j ~= 1) then
                event["missions"][i]["args"][j - 1] = v
            end
        end
    end

    NOTSVPC["admin"]["event"]["missions"] = event["missions"]
    NOTSVPC["admin"]["event"]["headers"] = event["headers"]

    return event
end

function displayMissions(event)
    if (event == nil or event == "") then
        return
    end

    event = parseEventKey(event)

    -- Traitement des missions
    local mod = function(l, i)
        -- Définit le texte avec le nom du joueur en rose et le reste en couleur standard
        local text = ""
        local langId = event["headers"]["lang"]
        local m_type = event["missions"][i]["type"]
        local splited_key = event["missions"][i]["args"]

        -- 1 + arg_id + lang_id
        if (m_type == "K") then
            text = "Kill |c000fff00x" .. splited_key[1] .. " " .. splited_key[1 + langId] .. "|r"
        elseif (m_type == "T") then
            if (array_size(splited_key) == 2) then -- Si c'est un player name
                text = "Target |c000fff00" .. splited_key[1]
            else
                text = "Target |c000fff00" .. splited_key[langId]
            end
        elseif (m_type == "G") then
            text = "Go to |c000fff00" .. splited_key[langId]
        end

        l:SetText(text)
    end

    local r = {}

    for i = 1, sizeof(event["missions"]) do r[i] = "" end

    UI_DisplayList(SF_MissionsList, r, mod)
    -- print("[ADMIN] Missions ajoutées !")
end