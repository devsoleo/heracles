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

function UI_DisplayList(sf_element, values, modifier)
    if modifier == nil then
        modifier = function(l) return l end
    end

    local scrollChild = sf_element:GetScrollChild()
    scrollChild.contentHeight = 0

    UI_ClearList("FS_" .. sf_element:GetName():sub(4) .. "Item")

    -- Ajout d'un exemple de contenu
    for i, text in ipairs(values) do
        local frame_name = "F_" .. sf_element:GetName():sub(4) .. "Item" .. i
        local frame = _G[frame_name]

        if (not frame) then
            frame = CreateFrame("Frame", frame_name, scrollChild, "UIPanelButtonTemplate")
            frame:SetSize(sf_element:GetWidth() - 20, 20)
            frame:SetPoint("TOP", 0, -((i - 1) * 20) - 10)
        end

        local line_name = "FS_" .. sf_element:GetName():sub(4) .. "Item" .. i
        local line = _G[line_name]

        if (not line) then
            line = frame:CreateFontString(line_name, "OVERLAY", "GameFontNormal")
            line:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, 5)
        end

        -- Définit le texte avec le nom du joueur en rose et le reste en couleur standard
        line:SetText("|c00ff00ff" .. text)

        line = modifier(line, i)

        -- Met à jour la hauteur du contenu et du scrolling child
        scrollChild.contentHeight = scrollChild.contentHeight + 20
        scrollChild:SetHeight(scrollChild.contentHeight)
    end
end