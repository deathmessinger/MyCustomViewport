local addonName, addonTable = ...

function addonTable.UpdateViewport()
    if not addonTable.topBar or not addonTable.topBorder then return end

    local top = addonTable.GetValue("topMargin", 15)
    local bottom = addonTable.GetValue("bottomMargin", 50)
    local left = addonTable.GetValue("leftMargin", 0)
    local right = addonTable.GetValue("rightMargin", 0)
    local showBorders = addonTable.GetValue("showBorders", true)
    
    local tR, tG, tB = addonTable.GetValue("topR", 1), addonTable.GetValue("topG", 1), addonTable.GetValue("topB", 1)
    local bR, bG, bB = addonTable.GetValue("bottomR", 1), addonTable.GetValue("bottomG", 1), addonTable.GetValue("bottomB", 1)
    local lR, lG, lB = addonTable.GetValue("leftR", 1), addonTable.GetValue("leftG", 1), addonTable.GetValue("leftB", 1)
    local rR, rG, rB = addonTable.GetValue("rightR", 1), addonTable.GetValue("rightG", 1), addonTable.GetValue("rightB", 1)
    
    local tBordR, tBordG, tBordB = addonTable.GetValue("topBorderR", 0.08), addonTable.GetValue("topBorderG", 0.08), addonTable.GetValue("topBorderB", 0.08)
    local bBordR, bBordG, bBordB = addonTable.GetValue("bottomBorderR", 0.08), addonTable.GetValue("bottomBorderG", 0.08), addonTable.GetValue("bottomBorderB", 0.08)
    local lBordR, lBordG, lBordB = addonTable.GetValue("leftBorderR", 0.08), addonTable.GetValue("leftBorderG", 0.08), addonTable.GetValue("leftBorderB", 0.08)
    local rBordR, rBordG, rBordB = addonTable.GetValue("rightBorderR", 0.08), addonTable.GetValue("rightBorderG", 0.08), addonTable.GetValue("rightBorderB", 0.08)
    
    local topThickness = addonTable.GetValue("topBorderThickness", 2)
    local topShift = addonTable.GetValue("topBorderShift", 0)
    local bottomThickness = addonTable.GetValue("bottomBorderThickness", 2)
    local bottomShift = addonTable.GetValue("bottomBorderShift", 0)
    local leftThickness = addonTable.GetValue("leftBorderThickness", 0)
    local leftShift = addonTable.GetValue("leftBorderShift", 0)
    local rightThickness = addonTable.GetValue("rightBorderThickness", 0)
    local rightShift = addonTable.GetValue("rightBorderShift", 0)

    local uiScale = UIParent:GetEffectiveScale()
    local screenWidth = UIParent:GetWidth()
    local screenHeight = UIParent:GetHeight()

    WorldFrame:ClearAllPoints()
    WorldFrame:SetPoint("TOPLEFT", left, -top)
    WorldFrame:SetPoint("BOTTOMRIGHT", -right, bottom)

    addonTable.topBar:ClearAllPoints()
    addonTable.topBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
    addonTable.topBar:SetPoint("BOTTOMRIGHT", UIParent, "TOPRIGHT", 0, -(top / uiScale))
    -- FIXED: Removed the internal alpha variable pointer, replacing it with a solid 1
    addonTable.topBar:SetColorTexture(tR, tG, tB, 1)

    addonTable.bottomBar:ClearAllPoints()
    addonTable.bottomBar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT")
    addonTable.bottomBar:SetPoint("TOPRIGHT", UIParent, "BOTTOMRIGHT", 0, (bottom / uiScale))
    -- FIXED: Removed the internal alpha variable pointer, replacing it with a solid 1
    addonTable.bottomBar:SetColorTexture(bR, bG, bB, 1)

    local dynamicHeight = screenHeight - (top / uiScale) - (bottom / uiScale)

    addonTable.leftBar:ClearAllPoints()
    addonTable.leftBar:SetSize((left / uiScale), dynamicHeight)
    addonTable.leftBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -(top / uiScale))
    -- FIXED: Removed the internal alpha variable pointer, replacing it with a solid 1
    addonTable.leftBar:SetColorTexture(lR, lG, lB, 1)

    addonTable.rightBar:ClearAllPoints()
    addonTable.rightBar:SetSize((right / uiScale), dynamicHeight)
    addonTable.rightBar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, -(top / uiScale))
    -- FIXED: Removed the internal alpha variable pointer, replacing it with a solid 1
    addonTable.rightBar:SetColorTexture(rR, rG, rB, 1)

    if showBorders then
        addonTable.topBorder:Show(); addonTable.bottomBorder:Show()
        addonTable.leftBorder:Show(); addonTable.rightBorder:Show()

        local dynamicWidth = screenWidth - (left / uiScale) - (right / uiScale)

        addonTable.topBorder:ClearAllPoints()
        addonTable.topBorder:SetSize(dynamicWidth, topThickness / uiScale)
        addonTable.topBorder:SetPoint("TOPLEFT", UIParent, "TOPLEFT", (left / uiScale), -((top - topShift) / uiScale))
        addonTable.topBorder:SetColorTexture(tBordR, tBordG, tBordB, 1)
        
        addonTable.bottomBorder:ClearAllPoints()
        addonTable.bottomBorder:SetSize(dynamicWidth, bottomThickness / uiScale)
        addonTable.bottomBorder:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", (left / uiScale), ((bottom + bottomShift) / uiScale))
        addonTable.bottomBorder:SetColorTexture(bBordR, bBordG, bBordB, 1)

        addonTable.leftBorder:ClearAllPoints()
        addonTable.leftBorder:SetSize(leftThickness / uiScale, dynamicHeight)
        addonTable.leftBorder:SetPoint("TOPLEFT", UIParent, "TOPLEFT", ((left - leftShift) / uiScale), -(top / uiScale))
        addonTable.leftBorder:SetColorTexture(lBordR, lBordG, lBordB, 1)

        addonTable.rightBorder:ClearAllPoints()
        addonTable.rightBorder:SetSize(rightThickness / uiScale, dynamicHeight)
        addonTable.rightBorder:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -((right - rightShift) / uiScale), -(top / uiScale))
        addonTable.rightBorder:SetColorTexture(rBordR, rBordG, rBordB, 1)
    else
        addonTable.topBorder:Hide(); addonTable.bottomBorder:Hide()
        addonTable.leftBorder:Hide(); addonTable.rightBorder:Hide()
    end
end

local engineFrame = CreateFrame("Frame")
engineFrame:RegisterEvent("PLAYER_LOGIN") 
engineFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        addonTable.UpdateViewport()
    end
end)
