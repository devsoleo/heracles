-- UI Functions
function InviteFrame_ClearList()
    UI_ClearList("FS_InvitedPlayerListItem")

    InviteFrame_ToggleSubmitButton()
end

function InviteFrame_ToggleSubmitButton()
    if (isInviteFormEmpty() == false) then
        B_SubmitInvites:Enable()
    else
        B_SubmitInvites:Disable()
    end
end

function InviteFrame_AddPlayerToInviteList(player)
    player = normalizePlayerName(player)

    -- On vérifie que le joueur n'est pas déjà dans la liste
    -- On vérifie que le joueur n'est pas le joueur lui-même
    -- On vérifie que le joueur n'est pas vide
    if (player == nil or array_search(NOTSVPC["admin"]["invites"]["players"], player) ~= nil or player == UnitName("PLAYER")) then
        return false
    end

    table.insert(NOTSVPC["admin"]["invites"]["players"], player)

    InviteFrame_DisplayInviteList()

    InviteFrame_ToggleSubmitButton()

    return true
end

function InviteFrame_DisplayInviteList()
    if not NOTSVPC["admin"]["invites"] or not NOTSVPC["admin"]["invites"]["players"] then
        return
    end

    UI_DisplayList(SF_InvitedPlayerList, NOTSVPC["admin"]["invites"]["players"])
end

-- Data Functions
function getInviteForm()
    -- Récupération du formulaire
    NOTSVPC["admin"]["invites"]["channels"]["GUILD"] = (CB_GuildPlayers:GetChecked() == 1)
    NOTSVPC["admin"]["invites"]["channels"]["RAID"] = (CB_RaidPlayers:GetChecked() == 1)
    NOTSVPC["admin"]["invites"]["channels"]["PARTY"] = ( CB_PartyPlayers:GetChecked() == 1)
end

-- Fonction qui lit le formulaire afin de déterminer si au moins 1 case à été cochée ou si un joueur à été ajouté
-- TL;DR : fonction qui vérifie si on peut valider le formulaire
function isInviteFormEmpty()
    getInviteForm()

    local isEmpty = true

    if (NOTSVPC["admin"]["invites"]["channels"]["GUILD"] == true) then
        isEmpty = false
    end

    -- Envoie le message d'invitation approprié
    if UnitInRaid("PLAYER") == 1 and NOTSVPC["admin"]["invites"]["channels"]["RAID"] then
        isEmpty = false
    elseif NOTSVPC["admin"]["invites"]["channels"]["PARTY"] then
        isEmpty = false
    end

    if (sizeof(NOTSVPC["admin"]["invites"]["players"]) > 0) then
        isEmpty = false
    end

    print("isInviteFormEmpty : " .. tostring(isEmpty))

    return isEmpty
end

function sendInvites()
    local inviteSend = false

    if (NOTSVPC["admin"]["invites"]["channels"]["GUILD"] == true) then
        SendAddonMessage(PREFIX, "invite", "GUILD")
        inviteSend = true
    end

    -- Envoie le message d'invitation approprié
    if UnitInRaid("PLAYER") == 1 and NOTSVPC["admin"]["invites"]["channels"]["RAID"] then
        SendAddonMessage(PREFIX, "invite", "RAID")
        inviteSend = true
    elseif NOTSVPC["admin"]["invites"]["channels"]["PARTY"] then
        SendAddonMessage(PREFIX, "invite", "PARTY")
        inviteSend = true
    end

    for i, player in ipairs(NOTSVPC["admin"]["invites"]["players"]) do
        SendAddonMessage(PREFIX, "invite", "WHISPER", player)
        inviteSend = true
    end

    return inviteSend
end

function checkInvitationAccept(player)
    local valid = false

    player = normalizePlayerName(player)

    -- Has been invited
    if (array_search(NOTSVPC["admin"]["invites"]["players"], player) ~= nil) then
        valid = true
    end

    if NOTSVPC["admin"]["invites"]["channels"]["GUILD"] == true and GetGuildInfo(player) == GetGuildInfo("player") then
        valid = true
    end

    if UnitInRaid("player") == 1 and NOTSVPC["admin"]["invites"]["channels"]["RAID"] == true then
        valid = true
    end

    if NOTSVPC["admin"]["invites"]["channels"]["PARTY"] == true and UnitInParty(player) == 1 then
        valid = true
    end

    -- Already participating
    for i, p in pairs(NOTSVPC["admin"]["participants"]) do
        if (p == player) then
            valid = true
        end
    end

    return valid
end

-- Events
function CB_GuildPlayers_OnClick(self)
    InviteFrame_ToggleSubmitButton()
end

function CB_RaidPlayers_OnClick(self)
    CB_PartyPlayers:SetChecked(true)

    if (self:GetChecked()) then
        CB_PartyPlayers:Disable()
    else
        CB_PartyPlayers:Enable()
    end

    InviteFrame_ToggleSubmitButton()
end

function CB_PartyPlayers_OnClick(self)
    InviteFrame_ToggleSubmitButton()
end

function B_PlayerNameToInviteList_OnClick(self)
    if (InviteFrame_AddPlayerToInviteList(EB_InvitedPlayerName:GetText())) then
        EB_InvitedPlayerName:SetText("")
        EB_InvitedPlayerName:ClearFocus()
    end
end

function B_TargetToInviteList_OnClick(self)
    if (UnitName("target") ~= nil and UnitIsPlayer("target") == 1) then
        InviteFrame_AddPlayerToInviteList(UnitName("target"))
    end
end

function B_BackToEventKeyFrame_OnClick(self)
    F_Invite:Hide()
end

function B_SubmitInvites_OnClick(self)
    if (sendInvites()) then
        NOTSVPC["admin"]["eventStatus"] = 1

        F_Invite:Hide()
        F_AdminPanel:Show()
    end
end