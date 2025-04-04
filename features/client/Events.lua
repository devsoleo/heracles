local lastInvite = 0

local onAddonMessage = CreateFrame("Frame")
onAddonMessage:RegisterEvent("CHAT_MSG_ADDON")
onAddonMessage:SetScript("OnEvent", function(self, event, prefix, message, channel, sender)
    -- On vérifie si le message est adressé à notre addon
    if (prefix ~= PREFIX or sender == UnitName("PLAYER")) then
        return
    end

    local splitedMessage = str_split(message, "^")
    local messageType = splitedMessage[1]

    -- Same invite
    if (messageType == "invite") then
        if (lastInvite <= time() - 2) then
            StaticPopupDialogs["NEW_INVITE"] = {
                text = sender .. " vous invite à participer à son event !",
                button1 = "Accepter",
                button2 = "Refuser",
                OnAccept = function()
                    SendAddonMessage(PREFIX, "accept_invite^" .. GetLocale(), "WHISPER", sender)
                    print("[CLIENT] Invitation acceptée !", PREFIX)
                end,
                timeout = 60,
                whileDead = true,
                hideOnEscape = true,
                preferredIndex = 3,
            }

            StaticPopup_Show("NEW_INVITE")
        end
    elseif (messageType == "close_invite") then
        StaticPopup_Hide("NEW_INVITE")
    elseif (messageType == "alert") then
        StaticPopupDialogs["ALERT"] = {
            text = splitedMessage[2],
            button1 = "Fermer",
            timeout = 60,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }

        StaticPopup_Show("ALERT")
    elseif (messageType == "start") then
        local mission = splitedMessage[2]

        -- TODO : ajouter au journal

        SendAddonMessage(PREFIX, "accept_start", "WHISPER", sender)
    end

    lastInvite = time()
end)