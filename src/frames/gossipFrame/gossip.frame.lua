GossipFrame:Hide()

GossipFrame:SetScript("OnShow", function(self)
    -- Aquí defines tu condición
    local condition = true -- Cambia esto a tu lógica específica

    DGossipFrame:Show()

end)
