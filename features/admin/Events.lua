local onGuildUpdate = CreateFrame("Frame")
onGuildUpdate:RegisterEvent("PLAYER_GUILD_UPDATE")
onGuildUpdate:SetScript("OnEvent", function(self, ...)
    if (isInGuild("PLAYER") == false) then
        CB_GuildPlayers:SetChecked(false)
        CB_GuildPlayers:Disable()
        FS_Guild:SetAlpha(0.5)
        CB_GuildPlayers:SetAlpha(0.5)
    else
        CB_GuildPlayers:Enable()
        FS_Guild:SetAlpha(1)
        CB_GuildPlayers:SetAlpha(1)
    end
end)

local onRaidUpdate = CreateFrame("Frame")
onRaidUpdate:RegisterEvent("RAID_ROSTER_UPDATE")
onRaidUpdate:SetScript("OnEvent", function(self, ...)
    if (UnitInRaid("PLAYER") ~= 1) then
        CB_RaidPlayers:SetChecked(false)
        CB_RaidPlayers:Disable()
        FS_Raid:SetAlpha(0.5)
        CB_RaidPlayers:SetAlpha(0.5)
    else
        CB_RaidPlayers:Enable()
        FS_Raid:SetAlpha(1)
        CB_RaidPlayers:SetAlpha(1)
    end
end)

local onPartyUpdate = CreateFrame("Frame")
onPartyUpdate:RegisterEvent("PARTY_MEMBERS_CHANGED")
onPartyUpdate:SetScript("OnEvent", function(self, ...)
    if (GetNumPartyMembers() == 0) then
        CB_PartyPlayers:SetChecked(false)
        CB_PartyPlayers:Disable()
        CB_PartyPlayers:SetAlpha(0.5)
        FS_Party:SetAlpha(0.5)
    else
        CB_PartyPlayers:Enable()
        FS_Party:SetAlpha(1)
        CB_PartyPlayers:SetAlpha(1)
    end
end)

local onAddonMessage = CreateFrame("Frame")
onAddonMessage:RegisterEvent("CHAT_MSG_ADDON")
onAddonMessage:SetScript("OnEvent", function(self, event, prefix, message, channel, sender)
    if (prefix ~= PREFIX or sender == UnitName("PLAYER")) then
        return
    end

    -- Les messages échangés entre le client et l'admin sont separés par des ^ afin de ne pas
    -- interferer avec les events keys (qui utilisent &&) lors de leur traitement
    local splitedMessage = str_split(message, "^")
    local messageType = splitedMessage[1]

    if (messageType == "accept_invite") then
        -- Si aucun event n'est en cours alors on refuse les "accept_invite" par défaut
        if NOTSVPC["admin"]["eventStatus"] == 0 then
            return
        end

        -- Si le joueur a déjà accepté l'invitation
        if NOTSVPC["admin"]["participants"][sender] ~= nil then
            return
        end

        if checkInvitationAccept(sender) == false then
            print("[ADMIN] " .. sender .. " n'a pas été invité mais essaie de rejoindre !") -- avec /joinevent <admin-player>
            return
        end

        print("[ADMIN] " .. sender .. " a accepté votre invitation !")

        -- Ajout du joueur à la liste des participants, avec commande langue par defaut "enUS"

        local userLocale = "enUS"

        if is_locale_supported(splitedMessage[2]) then
            userLocale = splitedMessage[2]
        end

        NOTSVPC["admin"]["participants"][sender] = {}
        NOTSVPC["admin"]["participants"][sender]["locale"] = userLocale
        NOTSVPC["admin"]["participants"][sender]["status"] = 0

        displayParticipants()
    elseif (messageType == "accept_start") then
        -- Si aucun event n'est en cours alors on refuse les "accept_invite" par défaut
        if NOTSVPC["admin"]["eventStatus"] == 0 then
            return
        end

        if checkInvitationAccept(sender) == false then
            return
        end

        NOTSVPC["admin"]["participants"][sender]["status"] = 1
    end
end)