function displayInviteList()
    if not NOTSVPC["invites"] or not NOTSVPC["invites"]["players"] then
        return
    end

    displayList(SF_InvitedPlayerList, NOTSVPC["invites"]["players"])
end

function getInviteForm()
    -- On récupère le channels sélectionnés
    NOTSVPC["invites"]["channels"]["GUILD"] = (CB_GuildPlayers:GetChecked() == 1)
    NOTSVPC["invites"]["channels"]["RAID"] = (CB_RaidPlayers:GetChecked() == 1)
    NOTSVPC["invites"]["channels"]["PARTY"] = ( CB_PartyPlayers:GetChecked() == 1)

    return invites
end

-- Fonction qui lit le formulaire afin de déterminer si au moins 1 case à été cochée ou si un joueur à été ajouté
-- TL;DR : fonction qui vérifie si on peut valider le formulaire
function isInviteFormEmpty()
    local isEmpty = true

    if (NOTSVPC["invites"]["channels"]["GUILD"] == true) then
        isEmpty = false
    end

    -- Envoie le message d'invitation approprié
    if UnitInRaid("PLAYER") == 1 and NOTSVPC["invites"]["channels"]["RAID"] then
        isEmpty = false
    elseif NOTSVPC["invites"]["channels"]["PARTY"] then
        isEmpty = false
    end

    if (sizeof(NOTSVPC["invites"]["players"]) > 0) then
        isEmpty = false
    end

    print("isInviteFormEmpty : " .. tostring(isEmpty))

    return isEmpty
end

function sendInvites(invites, gamekey)
    local inviteSend = false

    if (NOTSVPC["invites"]["channels"]["GUILD"] == true) then
        SendAddonMessage(PREFIX, "invite", "GUILD")
        inviteSend = true
    end

    -- Envoie le message d'invitation approprié
    if UnitInRaid("PLAYER") == 1 and NOTSVPC["invites"]["channels"]["RAID"] then
        SendAddonMessage(PREFIX, "invite", "RAID")
        inviteSend = true
    elseif NOTSVPC["invites"]["channels"]["PARTY"] then
        SendAddonMessage(PREFIX, "invite", "PARTY")
        inviteSend = true
    end

    for i, player in ipairs(NOTSVPC["invites"]["players"]) do
        SendAddonMessage(PREFIX, "invite", "WHISPER", player)
        inviteSend = true
    end

    return inviteSend
end

function checkInvitationAccept(player)
    player = normalizePlayerName(player)
    local valid = false

    -- Has been invited
    if (array_search(NOTSVPC["invites"]["players"], player) ~= nil) then
        valid = true
    end

    if NOTSVPC["invites"]["channels"]["GUILD"] == true and GetGuildInfo(player) == GetGuildInfo("player") then
        valid = true
    end

    if UnitInRaid("player") == 1 and NOTSVPC["invites"]["channels"]["RAID"] == true then
        valid = true
    end

    if NOTSVPC["invites"]["channels"]["PARTY"] == true and UnitInParty(player) == 1 then
        valid = true
    end

    -- Already participating
    if (array_search(NOTSVPC["participants"], player) ~= nil) then
        valid = false
    end

    return valid
end