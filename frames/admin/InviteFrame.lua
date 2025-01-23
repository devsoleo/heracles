-- Functions
function InviteFrame_ClearList()
    UI_ClearList("FS_InvitedPlayerListItem")

    InviteFrame_ToggleSubmitButton()
end

function InviteFrame_ToggleSubmitButton()
    if (isInviteFormEmpty(getInviteForm()) == false) then
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
    if (player == nil or array_search(NOTSVPC["invites"]["players"], player) ~= nil or player == UnitName("PLAYER")) then
        return false
    end

    table.insert(NOTSVPC["invites"]["players"], player)

    displayInviteList()

    InviteFrame_ToggleSubmitButton()

    return true
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
    if (sendInvites(getInviteForm(), EB_InvitedPlayerName:GetText())) then
        NOTSVPC["hasInvited"] = true

        F_Invite:Hide()
        F_AdminPanel:Show()
        -- displayMissions(str_split("T-5-Zgurt le maléfique_C-Soleo_P-1-Chauve", "_"))
    end
end