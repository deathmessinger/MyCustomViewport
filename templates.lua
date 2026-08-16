local addonName, addonTable = ...

MyCustomViewportUI = MyCustomViewportUI or {}

local sliderCount = 0

function MyCustomViewportUI.CreateSlider(parent, text, low, high, step, key, fallback, hasInputBox)
    sliderCount = sliderCount + 1
    local uniqueName = "MCV_Slider_" .. sliderCount
    
    local slider = CreateFrame("Slider", uniqueName, parent, "OptionsSliderTemplate")
    slider:SetMinMaxValues(low, high)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)
    
    MyCustomViewportDB = MyCustomViewportDB or {}
    local currentVal = MyCustomViewportDB[key]
    if currentVal == nil then currentVal = fallback end
    slider:SetValue(currentVal)

    _G[uniqueName .. "Text"]:SetText(text .. ": " .. currentVal)
    _G[uniqueName .. "Low"]:SetText(tostring(low))
    _G[uniqueName .. "High"]:SetText(tostring(high))

    local editBox
    if hasInputBox then
        editBox = CreateFrame("EditBox", uniqueName .. "EditBox", parent, "InputBoxTemplate")
        editBox:SetSize(45, 20)
        editBox:SetPoint("TOP", slider, "BOTTOM", 0, -6)
        editBox:SetAutoFocus(false)
        editBox:SetFontObject("GameFontHighlightSmall")
        editBox:SetText(tostring(currentVal))
        
        if low < 0 then
            editBox:SetNumeric(false)
        else
            editBox:SetNumeric(true)
        end
        
        editBox:SetScript("OnEnterPressed", function(self)
            local val = tonumber(self:GetText()) or fallback
            val = math.max(low, math.min(high, val))
            self:SetText(tostring(val))
            slider:SetValue(val)
            self:ClearFocus()
        end)
    end

    slider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value / step + 0.5) * step
        _G[self:GetName() .. "Text"]:SetText(text .. ": " .. value)
        MyCustomViewportDB[key] = value
        if editBox then editBox:SetText(tostring(value)) end
        if addonTable and addonTable.UpdateViewport then addonTable.UpdateViewport() end
    end)
    return slider
end

function MyCustomViewportUI.InitializeMinimapButton(openMenuCallback)
    local mBtn = CreateFrame("Button", "MCV_MinimapButton", Minimap)
    mBtn:SetSize(31, 31)
    mBtn:SetFrameStrata("MEDIUM")
    mBtn:SetFrameLevel(8)
    mBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local bg = mBtn:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(21, 21)
    bg:SetPoint("CENTER", 0, 0)
    bg:SetTexture("Interface\\Icons\\INV_Misc_Book_11") 

    local border = mBtn:CreateTexture(nil, "OVERLAY")
    border:SetSize(54, 54)
    border:SetPoint("TOPLEFT", 0, 0)
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    local function UpdatePosition()
        local angle = MyCustomViewportDB and MyCustomViewportDB["minimapAngle"] or 45
        local x = math.cos(math.rad(angle)) * 80
        local y = math.sin(math.rad(angle)) * 80
        mBtn:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end

    mBtn:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local mx, my = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            local cx, cy = Minimap:GetCenter()
            local angle = math.deg(math.atan2((my/scale) - cy, (mx/scale) - cx))
            MyCustomViewportDB["minimapAngle"] = angle
            UpdatePosition()
        end)
    end)

    mBtn:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
    end)

    mBtn:RegisterForDrag("LeftButton")
    mBtn:SetScript("OnClick", openMenuCallback)

    mBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("MyCustomViewport", 1, 1, 1)
        GameTooltip:AddLine("|cFF00FF00Left-Click:|r Open menu.", 0.8, 0.8, 0.8)
        GameTooltip:AddLine("|cFF00FF00Drag:|r Move shortcut.", 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    mBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

    UpdatePosition()
end
