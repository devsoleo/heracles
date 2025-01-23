function reset_storage()
    NOTSVPC = {}

    NOTSVPC["hasInvited"] = false

    NOTSVPC["participants"] = {}

    NOTSVPC["invites"] = {}
    NOTSVPC["invites"]["channels"] = {}
    NOTSVPC["invites"]["players"] = {}

    NOTSVPC["invites"]["channels"]["GUILD"] = false
    NOTSVPC["invites"]["channels"]["RAID"] = false
    NOTSVPC["invites"]["channels"]["PARTY"] = false
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
  if event == "ADDON_LOADED" then
    if (NOTSVPC == nil) then
        reset_storage()
    end
  end
end)

frame:RegisterEvent("ADDON_LOADED")