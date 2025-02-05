PREFIX = "not-a-prefix"

SLASH_EVENT1, SLASH_EVENT2 = '/event', '/not'
function SlashCmdList.EVENT(msg, editBox)
    if F_AdminPanel:IsVisible() == 1 or F_Invite:IsVisible() == 1 then
        F_AdminPanel:Hide()
        F_Invite:Hide()
    else
        if (NOTSVPC["admin"]["eventStatus"] == 0) then
            F_Invite:Show()
        else
            F_AdminPanel:Show()
        end
    end
end