-- Events
function B_StartEvent_OnClick(self)
    print("Button " .. self:GetName() .. " is pressed")

    setInterval(5, 0.5, function()
        for name, args in pairs(NOTSVPC["admin"]["participants"]) do
            if (args["status"] == 0) then
                local mission_id = 1
                local missions = NOTSVPC["admin"]["event"]["missions"]
                local localeId = get_locale_id(GetLocale())
                local text = ""
                local m_type = missions[mission_id]["type"]
                local splited_key = missions[mission_id]["args"]

                -- 1 + arg_id + lang_id
                if (m_type == "K") then
                    text = m_type .. "&&" .. splited_key[1] .. "&&" .. splited_key[1 + localeId]
                elseif (m_type == "T") then
                    if (array_size(splited_key) == 1) then -- Si c'est un player name
                        text = m_type .. "&&" .. splited_key[1]
                    else
                        text = m_type .. "&&" .. splited_key[localeId]
                    end
                elseif (m_type == "G") then
                    text = m_type .. "&&" .. splited_key[localeId]

                    if (array_size(splited_key) > 4) then
                        text = text .. "&&" .. splited_key[5 + localeId]
                    end
                end

                SendAddonMessage(PREFIX, "start^" .. text, "WHISPER", name)
            end
        end
    end)
end

function B_PauseEvent_OnClick(self)
    print("Button " .. self:GetName() .. " is pressed")
end

function B_StopEvent_OnClick(self)
    format_storage()

    UI_ClearList("FS_ParticipantsListItem")
    UI_ClearList("FS_MissionsListItem")

    InviteFrame_ToggleSubmitButton()

    F_AdminPanel:Hide()

    print("[ADMIN] Event annulé !")
end

function B_KeyApply_OnClick(self)
    NOTSVPC["admin"]["event"]["key"] = EB_EventKey:GetText()

    displayMissions(NOTSVPC["admin"]["event"]["key"])

    B_StartEvent:Enable()
end

function B_SendAlertToPlayers_OnClick(self)
    print("Button " .. self:GetName() .. " is pressed with input : " .. EB_AlertToPlayers:GetText())

    if (EB_AlertToPlayers:GetText() == "") then
        -- No message
        return
    end

    for name, args in pairs(NOTSVPC["admin"]["participants"]) do
        SendAddonMessage(PREFIX, "alert^" .. EB_AlertToPlayers:GetText(), "WHISPER", name) -- TODO : Verifier cooldown
    end

    EB_AlertToPlayers:SetText("")
end

function displayParticipants()
    local pa = {}

    for name, args in pairs(NOTSVPC["admin"]["participants"]) do
        table.insert(pa, name .. " |c00ffd100 [" .. args["locale"] .. "]|r")
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

    event["headers"]["version"] = headersList[1]

    -- Traitement des missions
    event["missions"] = {}

    for i, m in ipairs(missionsList) do
        local mission = str_split(m, "&&")

        event["missions"][i] = {}
        event["missions"][i]["type"] = mission[1]
        event["missions"][i]["args"] = {}

        -- Traitement des arguments
        if (mission[1] == "K") then
            event["missions"][i]["args"]["count"] = mission[2]

            event["missions"][i]["args"]["entity"] = {}

            for j = 1, 4 do
                event["missions"][i]["args"]["entity"][get_locale_by_id(j)] = mission[2 + j]
            end
        elseif (mission[1] == "T") then
            if (array_size(mission) == 2) then
                event["missions"][i]["args"]["category"] = "player"
                event["missions"][i]["args"]["entity"] = mission[2]
            else
                event["missions"][i]["args"]["category"] = "monster"
                for j = 1, 4 do
                    event["missions"][i]["args"]["entity"][get_locale_by_id(j)] = mission[1 + j]
                end
            end
        elseif (mission[1] == "G") then

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
        local localeId = get_locale_id(GetLocale())

        local text = ""
        local m_type = event["missions"][i]["type"]
        local splited_key = event["missions"][i]["args"]

        -- 1 + arg_id + lang_id
        if (m_type == "K") then
            text = "Kill |c000fff00x" .. splited_key[1] .. " " .. splited_key[1 + localeId]
        elseif (m_type == "T") then
            if (array_size(splited_key) == 1) then -- Si c'est un player name
                text = "Target |c000fff00" .. splited_key[1]
            else
                text = "Target |c000fff00" .. splited_key[localeId]
            end
        elseif (m_type == "G") then
            text = "Go to |c000fff00" .. splited_key[localeId]
        end

        l:SetText(text .. "|r")
    end

    local r = {}

    for i = 1, sizeof(event["missions"]) do r[i] = "" end

    UI_DisplayList(SF_MissionsList, r, mod)
    -- print("[ADMIN] Missions ajoutées !")
end