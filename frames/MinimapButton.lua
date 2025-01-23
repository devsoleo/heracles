-- Test de minimap button

function NOT_MinimapButton_Reposition()
    NOT_MinimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(MinimapPos)),(80*sin(MinimapPos))-52)
end
    
function NOT_MinimapButtonUnbound_Reposition()
    local xpos,ypos = NOT_MinimapButton:GetLeft(), NOT_MinimapButton:GetBottom()

    NOT_MinimapButtonUnbound:ClearAllPoints();
    NOT_MinimapButtonUnbound:SetPoint("BOTTOMLEFT","UIParent","BOTTOMLEFT", MinimapPosUnboundX, MinimapPosUnboundY)
    if (MinimapButtonUnbind == "1") then
        NOT_MinimapButton:Hide();
    end
    if (MinimapPosUnboundY == NIL) then
        NOT_MinimapButtonUnbound:SetPoint("BOTTOMLEFT","UIParent","BOTTOMLEFT", xpos-16, ypos-16)
        MinimapPosUnboundY = ypos-16
        MinimapPosUnboundX = xpos-16
    end
end

function NOT_MinimapButton_DraggingFrame_OnUpdate()
	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70 -- get coordinates as differences from the center of the minimap
	ypos = ypos/UIParent:GetScale()-ymin-70

	MinimapPos = math.deg(math.atan2(ypos,xpos)) -- save the degrees we are relative to the minimap center
	NOT_MinimapButton_Reposition() -- move the button
end

function NOT_MinimapButtonUnbound_DraggingFrame_OnUpdate()

	local xpos,ypos = GetCursorPosition()

	xpos = xpos/UIParent:GetScale()
	ypos = ypos/UIParent:GetScale()

	MinimapPosUnboundY = ypos
	MinimapPosUnboundX = xpos
	NOT_MinimapButtonUnbound_Reposition() -- move the button
end