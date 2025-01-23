function UI_ClearList(fsItemName) -- ex : FS_ParticipantsListItem
  local i = 1

  while true do
      local line = _G[fsItemName .. i]

      if (line == nil) then
          break
      else
          line:SetText("")
      end

      i = i + 1
  end
end