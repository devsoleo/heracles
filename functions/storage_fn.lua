function format_storage()
    NOTSVPC = {}
    NOTSVPC["admin"] = {}

    NOTSVPC["admin"]["hasInvited"] = false

    NOTSVPC["admin"]["participants"] = {}
    NOTSVPC["admin"]["event"] = {}
    NOTSVPC["admin"]["event"]["key"] = ""

    NOTSVPC["admin"]["invites"] = {}
    NOTSVPC["admin"]["invites"]["channels"] = {}
    NOTSVPC["admin"]["invites"]["players"] = {}

    NOTSVPC["admin"]["invites"]["channels"]["GUILD"] = false
    NOTSVPC["admin"]["invites"]["channels"]["RAID"] = false
    NOTSVPC["admin"]["invites"]["channels"]["PARTY"] = false
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
  if event == "ADDON_LOADED" then
    if (NOTSVPC == nil) then
        format_storage()
    end
  end
end)

frame:RegisterEvent("ADDON_LOADED")