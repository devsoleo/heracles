-- Functions
function AdminPanelFrame_ClearList()
    UI_ClearList("FS_ParticipantsListItem")

    InviteFrame_ToggleSubmitButton()
end

-- Events
function B_StartEvent_OnClick(self)
    print("Button " .. self:GetName() .. " is pressed")

    print(invites["channels"]["GUILD"])
end

function B_PauseEvent_OnClick(self)
    print("Button " .. self:GetName() .. " is pressed")
end

function B_StopEvent_OnClick(self)
    reset_storage()

    AdminPanelFrame_ClearList()

    NOTSVPC["participants"] = {}

    F_AdminPanel:Hide()

    print("[ADMIN] Event annulé !")
end

function B_KeyApply_OnClick(self)
    displayMissions(parseEventKey(EB_EventKey:GetText()))

    --  NOTSVPC["event_key"] = EB_EventKey:GetText()
end

function B_SendAlertToPlayers_OnClick(self)
    print("Button " .. self:GetName() .. " is pressed with input : " .. EB_AlertToPlayers:GetText())
    EB_AlertToPlayers:SetText("")
end

function displayParticipants()
    displayList(SF_ParticipantsList, NOTSVPC["participants"])
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

    local langHeader = str_split(headersList[1], "|")
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
        local mission = str_split(m, "|")

        event["missions"][i] = {}
        event["missions"][i]["args"] = {}
        event["missions"][i]["type"] = mission[1]

        for j, v in ipairs(mission) do
            if (j ~= 1) then
                event["missions"][i]["args"][j - 1] = v
            end
        end
    end

    return event
end

function displayMissions(event)
    if (event == nil) then
        return
    end

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

    displayList(SF_MissionsList, r, mod)
    -- print("[ADMIN] Missions ajoutées !")
end

-- Fonction de base pour afficher une liste de texte dans un scrollframe
function displayList(sf_element, values, modifier)
    if modifier == nil then
        modifier = function(l) return l end
    end

    local scrollChild = sf_element:GetScrollChild()
    scrollChild.contentHeight = 0

    UI_ClearList("FS_" .. SF_MissionsList:GetName():sub(4) .. "Item")

    -- Ajoute les nouvelles lignes
    for i, text in ipairs(values) do
        local line_name = "FS_" .. sf_element:GetName():sub(4) .. "Item" .. i
        local line = _G[line_name]

        if (not line) then
            line = scrollChild:CreateFontString(line_name, "ARTWORK", "GameFontNormal")
        end

        line:SetParent(sf_element)

        -- Crée une nouvelle ligne de texte
        local yPos = -scrollChild.contentHeight - 5
        line:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 5, yPos)

        -- Définit le texte avec le nom du joueur en rose et le reste en couleur standard
        line:SetText("|c00ff00ff" .. text)

        line = modifier(line, i)

        -- Met à jour la hauteur du contenu et du scrolling child
        scrollChild.contentHeight = scrollChild.contentHeight + 18
        scrollChild:SetHeight(scrollChild.contentHeight)

        -- Met à jour la barre de défilement si elle existe
        if sf_element.ScrollBar then
            sf_element.ScrollBar:SetMinMaxValues(1, scrollChild.contentHeight)
        end
    end
end