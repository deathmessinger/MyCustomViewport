local addonName, addonTable = ...

if MyCustomViewportDB and not MyCustomViewportDB.isVersion26 then
    MyCustomViewportDB = nil
end

MyCustomViewportDB = MyCustomViewportDB or {}

local bgParent = CreateFrame("Frame", nil, UIParent)
bgParent:SetFrameStrata("BACKGROUND")
bgParent:SetFrameLevel(1) 

addonTable.topBar = nil; addonTable.bottomBar = nil
addonTable.leftBar = nil; addonTable.rightBar = nil
addonTable.topBorder = nil; addonTable.bottomBorder = nil
addonTable.leftBorder = nil; addonTable.rightBorder = nil

function addonTable.GetValue(key, fallback)
    if MyCustomViewportDB[key] == nil then
        MyCustomViewportDB[key] = fallback
    end
    return MyCustomViewportDB[key]
end

local function CreateViewportBar()
    local texture = bgParent:CreateTexture(nil, "BACKGROUND")
    return texture
end

local function CreateThinBorder(r, g, b, sublevel)
    local border = bgParent:CreateTexture(nil, "OVERLAY", nil, sublevel)
    border:SetColorTexture(r, g, b, 1)
    return border
end

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == addonName then
        MyCustomViewportDB = MyCustomViewportDB or {}
        MyCustomViewportDB.isVersion26 = true 
        
        addonTable.leftBar = CreateViewportBar()
        addonTable.rightBar = CreateViewportBar()
        addonTable.topBar = CreateViewportBar()
        addonTable.bottomBar = CreateViewportBar()
        
        addonTable.topBorder = CreateThinBorder(addonTable.GetValue("topBorderR", 0.08), addonTable.GetValue("topBorderG", 0.08), addonTable.GetValue("topBorderB", 0.08), 5)
        addonTable.bottomBorder = CreateThinBorder(addonTable.GetValue("bottomBorderR", 0.08), addonTable.GetValue("bottomBorderG", 0.08), addonTable.GetValue("bottomBorderB", 0.08), 5)
        addonTable.leftBorder = CreateThinBorder(addonTable.GetValue("leftBorderR", 0.08), addonTable.GetValue("leftBorderG", 0.08), addonTable.GetValue("leftBorderB", 0.08), 7)
        addonTable.rightBorder = CreateThinBorder(addonTable.GetValue("rightBorderR", 0.08), addonTable.GetValue("rightBorderG", 0.08), addonTable.GetValue("rightBorderB", 0.08), 7)
        
        self:UnregisterEvent("ADDON_LOADED")
    end
end)
