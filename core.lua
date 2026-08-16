-- 1. Create a parent frame behind everything to hold the UI panels
local bgParent = CreateFrame("Frame", nil, UIParent)
bgParent:SetFrameStrata("BACKGROUND")
bgParent:SetFrameLevel(0)

-- Function to generate the solid white background bars
local function CreateWhiteBar(points)
    local texture = bgParent:CreateTexture(nil, "BACKGROUND")
    texture:SetColorTexture(0.13, 0.05, 0.05, 1) -- Pure White
    for _, point in ipairs(points) do
        texture:SetPoint(unpack(point))
    end
    return texture
end

-- Build the top and bottom solid white panels
local topBar = CreateWhiteBar({ {"TOPLEFT", UIParent, "TOPLEFT"}, {"BOTTOMRIGHT", UIParent, "TOPRIGHT", 0, -19} })
local bottomBar = CreateWhiteBar({ {"BOTTOMLEFT", UIParent, "BOTTOMLEFT"}, {"TOPRIGHT", UIParent, "BOTTOMRIGHT", 0, 177} })

-- 2. Create the thin dark borders (Fixed to prevent anchor family errors)
local function CreateThinBorder(yOffset)
    local border = bgParent:CreateTexture(nil, "BACKGROUND")
    border:SetColorTexture(0, 0., 1, 1) -- Dark Charcoal Gray color
    border:SetHeight(5) -- Border thickness in pixels
    
    -- Using 'nil' as the relativeTo target anchors it strictly to the screen, 
    -- bypassing the WorldFrame security lock completely.
    border:SetPoint("LEFT", nil, "LEFT")
    border:SetPoint("RIGHT", nil, "RIGHT")
    
    if yOffset < 0 then
        border:SetPoint("TOP", nil, "TOP", 0, yOffset)
    else
        border:SetPoint("BOTTOM", nil, "BOTTOM", 0, yOffset)
    end
    
    return border
end

-- 3. Physically shrink and compress the 3D game engine resolution
local renderFrame = CreateFrame("Frame")
renderFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
renderFrame:SetScript("OnEvent", function()
    WorldFrame:ClearAllPoints()
    WorldFrame:SetPoint("TOPLEFT", 0, -15)      -- Top edge margin
    WorldFrame:SetPoint("BOTTOMRIGHT", 0, 126)  -- Bottom edge margin
    
    -- Create the border lines and attach them perfectly to the WorldFrame edges
    if not WorldFrame.topBorder then
        WorldFrame.topBorder = CreateThinBorder(-20)
        WorldFrame.bottomBorder = CreateThinBorder(177)
    end
end)
