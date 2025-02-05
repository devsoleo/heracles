SLASH_JOINEVENT1 = '/joinevent'
function SlashCmdList.JOINEVENT(msg, editBox)
  if UnitExists(msg) then
    SendAddonMessage(PREFIX, "accept_invite^" .. GetLocale(), "WHISPER", msg)
  else
    print("Joueur inconnu")
  end
end