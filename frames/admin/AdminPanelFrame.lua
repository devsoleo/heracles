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

                -- TODO : make it work

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

    local decodedKey = json_decode(url_decode(base64_decode(eventKey)))

    NOTSVPC["admin"]["event"]["missions"] = decodedKey["missions"]
    NOTSVPC["admin"]["event"]["headers"] = decodedKey["headers"]

    return decodedKey
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

        local mission = event["missions"][i]
        local category = mission["category"]

        if (category == "kill") then
            text = "Kill |c000fff00x" .. mission["creature"][GetLocale()]
        elseif (category == "target") then
            local entity = mission["entity"]

            if (entity == "player") then -- Si c'est un player name
                text = "Target |c000fff00" .. mission["name"]
            else
                text = "Target |c000fff00" .. mission["name"][GetLocale()]
            end
        elseif (category == "goto") then
            text = "Go to |c000fff00" .. mission["zone"][GetLocale()]

            if (mission["subzone"] ~= nil) then
                text = text .. ", " .. mission["subzone"][GetLocale()]
            end
        end

        l:SetText(text .. "|r")
    end

    local r = {}

    for i = 1, sizeof(event["missions"]) do r[i] = "" end

    UI_DisplayList(SF_MissionsList, r, mod)
end