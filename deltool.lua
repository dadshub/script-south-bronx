local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- TOOL
local tool = Instance.new("Tool")
tool.Name = "Delete Tool"
tool.RequiresHandle = false
tool.Parent = player.Backpack

local clickConnection
local selectedPart = nil
local highlight = nil

-- FUNCTION BUAT HIGHLIGHT
local function createHighlight(part)
    if highlight then
        highlight:Destroy()
    end

    highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = part
end

-- EQUIP
tool.Equipped:Connect(function()
    clickConnection = mouse.Button1Down:Connect(function()
        local target = mouse.Target
        if not target or not target.Parent then return end
        if target:IsDescendantOf(player.Character) then return end

        -- KLIK PERTAMA (SELECT)
        if selectedPart ~= target then
            selectedPart = target
            createHighlight(target)

        -- KLIK KEDUA (DELETE)
        else
            if highlight then
                highlight:Destroy()
                highlight = nil
            end

            target:Destroy()
            selectedPart = nil
        end
    end)
end)

-- UNEQUIP (biar ga bug)
tool.Unequipped:Connect(function()
    if clickConnection then
        clickConnection:Disconnect()
        clickConnection = nil
    end

    if highlight then
        highlight:Destroy()
        highlight = nil
    end

    selectedPart = nil
end)
