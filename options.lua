local addonName, addonTable = ...

local panel, category

-- Options Panel Generation
local function InitializeOptionsPanel()
    panel = CreateFrame("Frame", "MyCustomViewportOptionsPanel", UIParent)
    panel.name = "Viewport Layout"

    local scrollContainer = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scrollContainer:SetPoint("TOPLEFT", 10, -10)
    scrollContainer:SetPoint("BOTTOMRIGHT", -30, 10)

    local scrollChild = CreateFrame("Frame")
    scrollChild:SetSize(600, 600) 
    scrollContainer:SetScrollChild(scrollChild)

    local title = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOP", scrollChild, "TOP", 0, -16)
    title:SetText("Viewport Layout Configurations")

    local checkBtn = CreateFrame("CheckButton", "MCV_BordersToggle", scrollChild, "InterfaceOptionsCheckButtonTemplate")
    checkBtn:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, -55)
    _G[checkBtn:GetName() .. "Text"]:SetText(" Enable Seam Borders")
    checkBtn:SetChecked(addonTable.GetValue("showBorders", true))
    
    checkBtn:SetScript("OnEvent", function(self)
        MyCustomViewportDB["showBorders"] = self:GetChecked()
        addonTable.UpdateViewport()
    end)

    local resetBtn = CreateFrame("Button", "MCV_ResetButton", scrollChild, "UIPanelButtonTemplate")
    resetBtn:SetSize(140, 22)
    resetBtn:SetPoint("LEFT", checkBtn, "RIGHT", 200, 0)
    resetBtn:SetText("Reset to Defaults")
    resetBtn:SetScript("OnClick", function()
        MyCustomViewportDB = { isVersion24 = true }
        StaticPopup_Show("MCV_RESET_CONFIRM")
    end)

    local mapToggleBtn = CreateFrame("CheckButton", "MCV_MinimapToggle", scrollChild, "InterfaceOptionsCheckButtonTemplate")
    mapToggleBtn:SetPoint("LEFT", resetBtn, "RIGHT", 75, 0)
    _G[mapToggleBtn:GetName() .. "Text"]:SetText(" Minimap Button")
    mapToggleBtn:SetChecked(addonTable.GetValue("showMinimapBtn", true))
    
    mapToggleBtn:SetScript("OnClick", function(self)
        local isChecked = self:GetChecked()
        MyCustomViewportDB["showMinimapBtn"] = isChecked
        if MCV_MinimapButton then
            if isChecked then MCV_MinimapButton:Show() else MCV_MinimapButton:Hide() end
        end
    end)

    local marginHeader = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    marginHeader:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -180, -65) 
    marginHeader:SetText("          Screen Margins")

    local topSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Top Margin (px)", 0, 500, 1, "topMargin", 15, true)
    topSlider:SetPoint("TOPLEFT", marginHeader, "BOTTOMLEFT", 0, -25)

    local bottomSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Bottom Margin (px)", 0, 500, 1, "bottomMargin", 50, true)
    bottomSlider:SetPoint("TOPLEFT", topSlider, "BOTTOMLEFT", 0, -55)

    local leftSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Left Margin (px)", 0, 500, 1, "leftMargin", 0, true)
    leftSlider:SetPoint("TOPLEFT", bottomSlider, "BOTTOMLEFT", 0, -55)

    local rightSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Right Margin (px)", 0, 500, 1, "rightMargin", 0, true)
    rightSlider:SetPoint("TOPLEFT", leftSlider, "BOTTOMLEFT", 0, -55)

    local topBorderHeader = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    topBorderHeader:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 40, -65) 
    topBorderHeader:SetText("Top/Bottom Borders")

    local topThicknessSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Top Thickness (px)", 0, 15, 1, "topBorderThickness", 2, true)
    topThicknessSlider:SetPoint("TOPLEFT", topBorderHeader, "BOTTOMLEFT", 0, -25)

    local topShiftSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Top Line Shift", -50, 50, 1, "topBorderShift", 0, true)
    topShiftSlider:SetPoint("TOPLEFT", topThicknessSlider, "BOTTOMLEFT", 0, -55)

    local bottomThicknessSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Bottom Thickness (px)", 0, 15, 1, "bottomBorderThickness", 2, true)
    bottomThicknessSlider:SetPoint("TOPLEFT", topShiftSlider, "BOTTOMLEFT", 0, -55)

    local bottomShiftSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Bottom Line Shift", -50, 50, 1, "bottomBorderShift", 0, true)
    bottomShiftSlider:SetPoint("TOPLEFT", bottomThicknessSlider, "BOTTOMLEFT", 0, -55)
    local verticalBorderHeader = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    verticalBorderHeader:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 260, -65) 
    verticalBorderHeader:SetText("Left/Right Borders")

    local leftThicknessSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Left Thickness (px)", 0, 15, 1, "leftBorderThickness", 0, true)
    leftThicknessSlider:SetPoint("TOPLEFT", verticalBorderHeader, "BOTTOMLEFT", 0, -25)

    local leftShiftSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Left Line Shift", -50, 50, 1, "leftBorderShift", 0, true)
    leftShiftSlider:SetPoint("TOPLEFT", leftThicknessSlider, "BOTTOMLEFT", 0, -55)

    local rightThicknessSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Right Thickness (px)", 0, 15, 1, "rightBorderThickness", 0, true)
    rightThicknessSlider:SetPoint("TOPLEFT", leftShiftSlider, "BOTTOMLEFT", 0, -55)

    local rightShiftSlider = MyCustomViewportUI.CreateSlider(scrollChild, "Right Line Shift", -50, 50, 1, "rightBorderShift", 0, true)
    rightShiftSlider:SetPoint("TOPLEFT", rightThicknessSlider, "BOTTOMLEFT", 0, -55)

    -- ================= UPDATED: CENTERED COLOR HEADER ALIGNMENT =================
    local barColorHeader = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    -- CHANGED: Anchored via "TOPLEFT" to scrollChild, but shifted X by 210 to perfectly sit in the center of the columns
    barColorHeader:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 210, -410)
    barColorHeader:SetText("Color Customizations")

    local function CreateLocalColorSwatch(labelName, xOff, yOffset, rKey, gKey, bKey, defR, defG, defB)
        local colorLabel = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        -- FIXED: Offsetting the labels directly from a left-flush baseline (-194px from centered header) keeps the grid rigid
        colorLabel:SetPoint("TOPLEFT", barColorHeader, "BOTTOMLEFT", xOff - 194, yOffset)
        colorLabel:SetText(labelName)

        local colorBtn = CreateFrame("Button", nil, scrollChild)
        colorBtn:SetSize(22, 22)
        colorBtn:SetPoint("LEFT", colorLabel, "RIGHT", 10, 0)

        MyCustomViewportDB = MyCustomViewportDB or {}
        local cR = MyCustomViewportDB[rKey] or defR
        local cG = MyCustomViewportDB[gKey] or defG
        local cB = MyCustomViewportDB[bKey] or defB

        local colorSwatch = colorBtn:CreateTexture(nil, "OVERLAY")
        colorSwatch:SetAllPoints(colorBtn)
        colorSwatch:SetColorTexture(cR, cG, cB, 1)

        local colorBg = colorBtn:CreateTexture(nil, "BACKGROUND")
        colorBg:SetSize(26, 26)
        colorBg:SetPoint("CENTER", colorBtn, "CENTER")
        colorBg:SetColorTexture(0.25, 0.25, 0.25, 1)

        colorBtn:SetScript("OnClick", function()
            local originalR = MyCustomViewportDB[rKey] or defR
            local originalG = MyCustomViewportDB[gKey] or defG
            local originalB = MyCustomViewportDB[bKey] or defB

            local info = {
                r = originalR, g = originalG, b = originalB,
                hasOpacity = false,
                swatchFunc = function()
                    local r, g, b = ColorPickerFrame:GetColorRGB()
                    if r and g and b then
                        MyCustomViewportDB[rKey] = r
                        MyCustomViewportDB[gKey] = g
                        MyCustomViewportDB[bKey] = b
                        colorSwatch:SetColorTexture(r, g, b, 1)
                        if addonTable and addonTable.UpdateViewport then addonTable.UpdateViewport() end
                    end
                end,
                cancelFunc = function()
                    MyCustomViewportDB[rKey] = originalR
                    MyCustomViewportDB[gKey] = originalG
                    MyCustomViewportDB[bKey] = originalB
                    colorSwatch:SetColorTexture(originalR, originalG, originalB, 1)
                    if addonTable and addonTable.UpdateViewport then addonTable.UpdateViewport() end
                end
            }
            ColorPickerFrame:SetupColorPickerAndShow(info)
        end)
    end

    -- Stack Column 1: Background Viewport Color Swatches (X-Offset set to 0 relative to left boundary link)
    CreateLocalColorSwatch("Top Bar Color:", 0, -25, "topR", "topG", "topB", 1, 1, 1)
    CreateLocalColorSwatch("Bottom Bar Color:", 0, -55, "bottomR", "bottomG", "bottomB", 1, 1, 1)
    CreateLocalColorSwatch("Left Bar Color:", 0, -85, "leftR", "leftG", "leftB", 1, 1, 1)
    CreateLocalColorSwatch("Right Bar Color:", 0, -115, "rightR", "rightG", "rightB", 1, 1, 1)

    -- Stack Column 2: Viewport Border Seam Color Swatches (X-Offset shifted right by 240 to split columns evenly)
    CreateLocalColorSwatch("Top Border Seam:", 240, -25, "topBorderR", "topBorderG", "topBorderB", 0.08, 0.08, 0.08)
    CreateLocalColorSwatch("Bottom Border Seam:", 240, -55, "bottomBorderR", "bottomBorderG", "bottomBorderB", 0.08, 0.08, 0.08)
    CreateLocalColorSwatch("Left Border Seam:", 240, -85, "leftBorderR", "leftBorderG", "leftBorderB", 0.08, 0.08, 0.08)
    CreateLocalColorSwatch("Right Border Seam:", 240, -115, "rightBorderR", "rightBorderG", "rightBorderB", 0.08, 0.08, 0.08)

    category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    Settings.RegisterAddOnCategory(category)
end

local function OpenMenuShortcut()
    if category and Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(category:GetID())
    elseif panel then
        InterfaceOptionsFrame_OpenToCategory(panel)
    end
end

local loadFrame = CreateFrame("Frame")
loadFrame:RegisterEvent("PLAYER_LOGIN")
loadFrame:SetScript("OnEvent", function(self, event)
    InitializeOptionsPanel()
    if MyCustomViewportDB and MyCustomViewportDB.showMinimapBtn then
        MyCustomViewportUI.InitializeMinimapButton(OpenMenuShortcut)
    end
    self:UnregisterEvent("PLAYER_LOGIN")
end)

SLASH_MYCUSTOMVIEWPORT1 = "/viewport"
SLASH_MYCUSTOMVIEWPORT2 = "/vp"

StaticPopupDialogs["MCV_RESET_CONFIRM"] = {
    text = "Database modified! A UI Reload is required. Reload now?",
    button1 = "Reload UI",
    button2 = "Cancel",
    OnAccept = function() ReloadUI() end,
    timeout = 0,
    whileDead = true,
    hideOnCancel = true,
}

SlashCmdList["MYCUSTOMVIEWPORT"] = function(msg)
    local command = string.lower(string.trim(msg or ""))
    if command == "reset" then
        MyCustomViewportDB = { isVersion24 = true }
        StaticPopup_Show("MCV_RESET_CONFIRM")
    else
        OpenMenuShortcut()
    end
end
