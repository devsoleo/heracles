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

    local splitedMessage = str_split(message, "&&")
    local messageType = splitedMessage[1]

    -- VERIFIER SI LE JOUEUR A ETE INVITE EN VERIFIANT SI IL CORRESPOND AU FILTRES
    if (messageType == "accept_invite") then
        if checkInvitationAccept(sender) == false then
            -- Ce joueur n'a pas été invité
            print("[ADMIN] " .. sender .. " n'a pas été invité mais essaie de rejoindre !")
            return
        end

        print("[ADMIN] " .. sender .. " a accepté votre invitation !")

        -- Add player to the event player list
        -- table.insert(NOTSVPC["admin"]["participants"], sender)
        NOTSVPC["admin"]["participants"][sender] = false

        displayParticipants()
    elseif (messageType == "accept_start") then
        if checkInvitationAccept(sender) == false then
            -- Ce joueur n'a pas été invité
            print("[ADMIN] " .. sender .. " n'a pas été invité mais essaie de rejoindre !")
            return
        end

        NOTSVPC["admin"]["participants"][sender] = true
    end
end)