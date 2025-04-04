-- Author      : Soleo, Aniwen
-- PC          : Heroes Place - 9
-- Create Date : 12/22/2023 12:29:27 PM

-- Fonction pour afficher la zone actuelle
local function PrintZoneInfo()
  local zone = GetZoneText()
  local subZone = GetSubZoneText()
  print("Vous êtes actuellement dans : " .. zone .. " - " .. subZone)
end

-- Fonction de gestion des événements
local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
  if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" then
      PrintZoneInfo()
  elseif event == "PLAYER_ENTERING_WORLD" then
      PrintZoneInfo()
  end
end)

-- Enregistrement des événements
frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("ZONE_CHANGED_INDOORS")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")