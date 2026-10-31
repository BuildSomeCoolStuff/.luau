local v0_1 = {}
v0_1.__index = v0_1
local v0_2 = {}
v0_2.__index = v0_2
local v0_3 = {}
v0_3.__index = v0_3
local v0_4 = game:GetService("UserInputService")
local v0_5 = game:GetService("TweenService")
local v0_6 = game:GetService("RunService")
local v0_7 = game:GetService("MarketplaceService")
local v0_8 = {
	Main = Color3.fromRGB(24, 24, 28),
	Sidebar = Color3.fromRGB(18, 18, 22),
	Card = Color3.fromRGB(30, 30, 35),
	Element = Color3.fromRGB(40, 40, 46),
	Hover = Color3.fromRGB(50, 50, 58),
	Danger = Color3.fromRGB(200, 60, 60),	Off = Color3.fromRGB(65, 65, 74),
	IconOff = Color3.fromRGB(160, 160, 170),
	IconOn = Color3.fromRGB(255, 255, 255),
	Accent = Color3.fromRGB(50, 90, 220),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(200, 200, 210),
}
local v0_9 = 50
local v0_10 = 26
local v0_11 = 8
local function v0_12(v1_13, v1_14, v1_15, v1_16, v1_17)
	local v1_18 = v0_5:Create(
		v1_13,
		TweenInfo.new(v1_15 or 0.15, v1_16 or Enum.EasingStyle.Quad, v1_17 or Enum.EasingDirection.Out),
		v1_14
	)
	v1_18:Play()
	return v1_18
end
local function v0_19(v1_20)
	return v1_20.UserInputType == Enum.UserInputType.MouseButton1 or v1_20.UserInputType == Enum.UserInputType.Touch
end
local function v0_21(v1_22, v1_23, v1_24, v1_25)
	local v1_26 = Instance.new("UIScale")
	v1_26.Parent = v1_22
	v1_22.MouseEnter:Connect(function()
		if not (v1_25 and v1_25()) then
			v0_12(v1_22, { BackgroundColor3 = v1_24 }, 0.12)
		end
	end)
	v1_22.MouseLeave:Connect(function()
		v0_12(v1_26, { Scale = 1 }, 0.12)
		if not (v1_25 and v1_25()) then
			v0_12(v1_22, { BackgroundColor3 = v1_23 }, 0.15)
		end
	end)
	v1_22.InputBegan:Connect(function(v2_27)
		if v0_19(v2_27) then v0_12(v1_26, { Scale = 0.96 }, 0.08) end
	end)
	v1_22.InputEnded:Connect(function(v2_28)
		if v0_19(v2_28) then v0_12(v1_26, { Scale = 1 }, 0.18, Enum.EasingStyle.Back) end
	end)
end
local function v0_29(v1_30)
	return v1_30:find("^rbx") ~= nil or v1_30:find("^https?://") ~= nil
end
local function v0_31(v1_32, v1_33, v1_34)
	if v1_34 > 3 then return end
	for v2_35, v2_36 in pairs(v1_32) do
		local v2_37 = type(v2_35) == "string" and v2_35:lower() or ""
		local v2_38 = typeof(v2_36)
		if v2_38 == "string" then
			if v0_29(v2_36) then
				v1_33.image = v1_33.image or v2_36
			elseif v2_36:match("^%d+$") then
				v1_33.image = v1_33.image or ("rbxassetid://" .. v2_36)
			end
		elseif v2_38 == "number" then
			if v2_37 == "id" or v2_37 == "image" or v2_37 == "imageid" or v2_37 == "assetid" or v2_35 == 1 then
				if v2_36 > 1000 then v1_33.image = v1_33.image or ("rbxassetid://" .. v2_36) end
			end
		elseif v2_38 == "Vector2" then
			if v2_37:find("size") then
				v1_33.size = v1_33.size or v2_36
			elseif v2_37:find("pos") or v2_37:find("offset") then
				v1_33.offset = v1_33.offset or v2_36
			end
		elseif v2_38 == "table" then
			v0_31(v2_36, v1_33, v1_34 + 1)
		end
	end
end
local function v0_39(v1_40)
	local v1_41 = {}
	local v1_42 = typeof(v1_40)
	if v1_42 == "string" then
		if v0_29(v1_40) then
			v1_41.image = v1_40
		elseif v1_40:match("^%d+$") then
			v1_41.image = "rbxassetid://" .. v1_40
		end
	elseif v1_42 == "number" then
		v1_41.image = "rbxassetid://" .. v1_40
	elseif v1_42 == "table" then
		v0_31(v1_40, v1_41, 0)
	elseif v1_42 == "Instance" then
		local v2_43 = (v1_40:IsA("ImageLabel") or v1_40:IsA("ImageButton")) and v1_40
			or v1_40:FindFirstChildWhichIsA("ImageLabel", true)
		if v2_43 then
			v1_41.image, v1_41.size, v1_41.offset = v2_43.Image, v2_43.ImageRectSize, v2_43.ImageRectOffset
		end
	end
	if v1_41.image == "" then v1_41.image = nil end
	return v1_41
end
local function v0_44(v1_45, v1_46, v1_47, v1_48)
	local v1_49 = v0_39(v1_46)
	if not v1_49.image and typeof(v1_46) == "string" and v1_47 then
		local v2_50 = {
			function() return v1_47.GetIcon(v1_46) end,
			function() return v1_47:GetIcon(v1_46) end,
			function() return v1_47.Icons and v1_47.Icons[v1_46] end,
			function() return v1_47[v1_46] end,
		}
		for v3_51, v3_52 in ipairs(v2_50) do
			local v3_53, v3_54 = pcall(v3_52)
			if v3_53 and v3_54 ~= nil then
				local v4_55 = v0_39(v3_54)
				if v4_55.image then
					v1_49 = v4_55
					break
				end
			end
		end
	end
	if not v1_49.image then
		if not v1_48 then warn("[RobloxUI] icon not recognized:", typeof(v1_46), v1_46) end
		return false
	end
	v1_45.Image = v1_49.image
	v1_45.ImageRectSize = v1_49.size or Vector2.new(0, 0)
	v1_45.ImageRectOffset = v1_49.offset or Vector2.new(0, 0)
	return true
end
local function v0_56(v1_57)
	local v1_58 = pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(v1_57)
			v1_57.Parent = game:GetService("CoreGui")
		elseif gethui then
			v1_57.Parent = gethui()
		else
			v1_57.Parent = game:GetService("CoreGui")
		end
	end)
	if not v1_58 or not v1_57.Parent then
		local v2_59 = game:GetService("Players").LocalPlayer
		v1_57.Parent = v2_59 and v2_59:WaitForChild("PlayerGui")
	end
end
local function v0_60()
	local v1_61, v1_62 = pcall(function()
		return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
	end)
	if v1_61 and v1_62 then return v1_62 end
	warn("[RobloxUI] failed to load icon library:", v1_62)
	return nil
end
local function v0_63(v1_64, v1_65)
	local v1_66 = Instance.new("UICorner")
	v1_66.CornerRadius = UDim.new(0, v1_65 or 6)
	v1_66.Parent = v1_64
	return v1_66
end
function v0_1.new(v1_67)
	v1_67 = v1_67 or {}
	local v1_68 = setmetatable({}, v0_1)
	v1_68.Tabs = {}
	v1_68.ActiveTab = nil
	v1_68.Icons = v1_67.Icons or v0_60()
	v1_68.IconGlow = v1_67.IconGlow == true
	v1_68._dialogs = {}
	v1_68._binds = {}
	v1_68._cleanups = {}
	v1_68._listening = nil
	v1_68._toggleKey = v1_67.ToggleKey
	v1_68._connections = {}
	local v1_69 = Instance.new("ScreenGui")
	v1_69.Name = "Interface"
	v1_69.ResetOnSpawn = false
	v1_69.IgnoreGuiInset = true
	v1_69.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	v0_56(v1_69)
	local v1_70 = v1_67.Size or UDim2.new(0, 600, 0, 400)
	local v1_71 = Instance.new("CanvasGroup")
	v1_71.Name = "Main"
	v1_71.Size = v1_70
	v1_71.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_71.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_71.BackgroundColor3 = v0_8.Main
	v1_71.BorderSizePixel = 0
	v1_71.ClipsDescendants = true
	v1_71.GroupTransparency = 1
	v1_71.Parent = v1_69
	v0_63(v1_71, v0_11)
	local v1_72 = Instance.new("UIScale")
	v1_72.Scale = 0.9
	v1_72.Parent = v1_71
	local function v1_73()
		local v2_74 = v1_69.AbsoluteSize
		if v2_74.X <= 0 or v2_74.Y <= 0 then
			local v3_75 = workspace.CurrentCamera
			v2_74 = v3_75 and v3_75.ViewportSize or Vector2.new(1280, 720)
		end
		local v2_76, v2_77 = v1_70.X.Offset, v1_70.Y.Offset
		if v1_70.X.Scale == 0 then v2_76 = math.min(v2_76, math.max(v2_74.X - 20, 120)) end
		if v1_70.Y.Scale == 0 then v2_77 = math.min(v2_77, math.max(v2_74.Y - 20, 120)) end
		v1_71.Size = UDim2.new(v1_70.X.Scale, v2_76, v1_70.Y.Scale, v2_77)
		v1_71.Position = UDim2.new(0.5, 0, 0.5, 0)
	end
	v1_73()
	table.insert(v1_68._connections, v1_69:GetPropertyChangedSignal("AbsoluteSize"):Connect(v1_73))
	do
		local v2_78, v2_79, v2_80 = false, nil, nil
		local v2_81 = 50
		table.insert(v1_68._connections, v1_71.InputBegan:Connect(function(v3_82)
			if v3_82.UserInputType == Enum.UserInputType.MouseButton1 or v3_82.UserInputType == Enum.UserInputType.Touch then
				v2_78 = true
				v2_79 = v3_82.Position
				v2_80 = v1_71.AbsolutePosition + v1_71.AbsoluteSize / 2
				v3_82.Changed:Connect(function()
					if v3_82.UserInputState == Enum.UserInputState.End then v2_78 = false end
				end)
			end
		end))
		table.insert(v1_68._connections, v0_4.InputChanged:Connect(function(v3_83)
			if not v2_78 then return end
			if v3_83.UserInputType ~= Enum.UserInputType.MouseMovement and v3_83.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			local v3_84 = v3_83.Position - v2_79
			local v3_85 = v1_69.AbsoluteSize
			local v3_86 = v1_71.AbsoluteSize / 2
			local v3_87 = math.clamp(v2_80.X + v3_84.X, -v3_86.X + v2_81, v3_85.X + v3_86.X - v2_81)
			local v3_88 = math.clamp(v2_80.Y + v3_84.Y, v3_86.Y, math.max(v3_85.Y + v3_86.Y - v2_81, v3_86.Y))
			v1_71.Position = UDim2.fromOffset(v3_87, v3_88)
		end))
	end
	local v1_89 = Instance.new("Frame")
	v1_89.Name = "Sidebar"
	v1_89.Size = UDim2.new(0, v0_9, 1, 0)
	v1_89.BackgroundColor3 = v0_8.Sidebar
	v1_89.BorderSizePixel = 0
	v1_89.Parent = v1_71
	v0_63(v1_89, v0_11)
	local v1_90 = Instance.new("Frame")
	v1_90.Name = "SidebarFix"
	v1_90.Size = UDim2.new(0, v0_11, 1, 0)
	v1_90.Position = UDim2.new(0, v0_9 - v0_11, 0, 0)
	v1_90.BackgroundColor3 = v0_8.Sidebar
	v1_90.BorderSizePixel = 0
	v1_90.Parent = v1_71
	local v1_91 = Instance.new("UIPadding")
	v1_91.PaddingTop = UDim.new(0, 12)
	v1_91.Parent = v1_89
	local v1_92 = Instance.new("UIListLayout")
	v1_92.Padding = UDim.new(0, 8)
	v1_92.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_92.SortOrder = Enum.SortOrder.LayoutOrder
	v1_92.Parent = v1_89
	local v1_93 = v1_67.Footer ~= false and v0_10 or 0
	local v1_94 = Instance.new("Frame")
	v1_94.Name = "Content"
	v1_94.Size = UDim2.new(1, -v0_9, 1, -v1_93)
	v1_94.Position = UDim2.new(0, v0_9, 0, 0)
	v1_94.BackgroundTransparency = 1
	v1_94.BorderSizePixel = 0
	v1_94.ClipsDescendants = true
	v1_94.Parent = v1_71
	do
		local v2_95 = Instance.new("CanvasGroup")
		v2_95.Name = "ScrollHint"
		v2_95.AnchorPoint = Vector2.new(0.5, 1)
		v2_95.Position = UDim2.new(0.5, -1, 1, -6)
		v2_95.Size = UDim2.new(0, 22, 0, 22)
		v2_95.BackgroundTransparency = 1
		v2_95.BorderSizePixel = 0
		v2_95.GroupTransparency = 1
		v2_95.Visible = false
		v2_95.Active = false
		v2_95.ZIndex = 10
		v2_95.Parent = v1_94
		local v2_96 = Instance.new("ImageLabel")
		v2_96.Name = "Icon"
		v2_96.AnchorPoint = Vector2.new(0.5, 0.5)
		v2_96.Position = UDim2.new(0.5, 0, 0.5, -3)
		v2_96.Size = UDim2.new(0, 16, 0, 16)
		v2_96.BackgroundTransparency = 1
		v2_96.BorderSizePixel = 0
		v2_96.ImageColor3 = v0_8.SubText
		v2_96.ScaleType = Enum.ScaleType.Fit
		v2_96.Active = false
		v2_96.Parent = v2_95
		local v2_97 = Instance.new("TextLabel")
		v2_97.Name = "IconFallback"
		v2_97.Size = UDim2.new(1, 0, 1, 0)
		v2_97.BackgroundTransparency = 1
		v2_97.Text = "▼"
		v2_97.TextColor3 = v0_8.SubText
		v2_97.Font = Enum.Font.Gotham
		v2_97.TextSize = 11
		v2_97.Parent = v2_96
		v2_97.Visible = not v0_44(v2_96, "chevron-down", v1_68.Icons)
		local v2_98 = v0_5:Create(
			v2_96,
			TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ Position = UDim2.new(0.5, 0, 0.5, 3) }
		)
		local v2_99 = Instance.new("TextButton")
		v2_99.Name = "Click"
		v2_99.Size = UDim2.new(1, 0, 1, 0)
		v2_99.BackgroundTransparency = 1
		v2_99.BorderSizePixel = 0
		v2_99.Text = ""
		v2_99.AutoButtonColor = false
		v2_99.ZIndex = 2
		v2_99.Parent = v2_95
		local v2_100 = UDim2.new(0.5, -1, 1, -34)
		local v2_101 = UDim2.new(0.5, -1, 1, -27)
		local v2_102 = Instance.new("CanvasGroup")
		v2_102.Name = "ScrollHintText"
		v2_102.AnchorPoint = Vector2.new(0.5, 1)
		v2_102.Position = v2_101
		v2_102.Size = UDim2.new(0, 0, 0, 0)
		v2_102.AutomaticSize = Enum.AutomaticSize.XY
		v2_102.BackgroundColor3 = v0_8.Sidebar
		v2_102.BorderSizePixel = 0
		v2_102.GroupTransparency = 1
		v2_102.Visible = false
		v2_102.Active = false
		v2_102.ZIndex = 10
		v2_102.Parent = v1_94
		v0_63(v2_102, 6)
		local v2_103 = Instance.new("UIStroke")
		v2_103.Color = v0_8.Element
		v2_103.Thickness = 1
		v2_103.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		v2_103.Parent = v2_102
		local v2_104 = Instance.new("UIPadding")
		v2_104.PaddingTop = UDim.new(0, 6)
		v2_104.PaddingBottom = UDim.new(0, 6)
		v2_104.PaddingLeft = UDim.new(0, 10)
		v2_104.PaddingRight = UDim.new(0, 10)
		v2_104.Parent = v2_102
		local v2_105 = Instance.new("TextLabel")
		v2_105.Name = "Text"
		v2_105.Size = UDim2.new(0, 0, 0, 0)
		v2_105.AutomaticSize = Enum.AutomaticSize.XY
		v2_105.BackgroundTransparency = 1
		v2_105.BorderSizePixel = 0
		v2_105.Text = "Scroll To See More Features."
		v2_105.TextColor3 = v0_8.Text
		v2_105.Font = Enum.Font.Gotham
		v2_105.TextSize = 12
		v2_105.Parent = v2_102
		local v2_106, v2_107, v2_108 = false, nil, nil
		local function v2_109(v3_110)
			if v2_107 and v2_107 ~= coroutine.running() then
				pcall(task.cancel, v2_107)
			end
			v2_107 = nil
			if not v2_106 then return end
			v2_106 = false
			if v2_108 then v2_108:Cancel() end
			if v3_110 then
				v2_102.GroupTransparency = 1
				v2_102.Visible = false
				return
			end
			local v3_111 = v0_12(v2_102, { GroupTransparency = 1, Position = v2_101 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v2_108 = v3_111
			v3_111.Completed:Connect(function(v4_112)
				if v4_112 == Enum.PlaybackState.Completed and not v2_106 then
					v2_102.Visible = false
				end
			end)
		end
		local function v2_113()
			if v2_106 then return end
			v2_106 = true
			if v2_108 then v2_108:Cancel() end
			if not v2_102.Visible then
				v2_102.Position = v2_101
				v2_102.Visible = true
			end
			v2_108 = v0_12(v2_102, { GroupTransparency = 0, Position = v2_100 }, 0.25, Enum.EasingStyle.Quint)
			v2_107 = task.spawn(function()
				task.wait(3.5)
				v2_107 = nil
				v2_109()
			end)
		end
		v2_99.MouseButton1Click:Connect(function()
			if v2_106 then v2_109() else v2_113() end
		end)
		v1_68._hint = { Frame = v2_95, Icon = v2_96, Bounce = v2_98, Shown = false, HideTip = v2_109 }
	end
	if v1_93 > 0 then
		local v2_114 = Instance.new("Frame")
		v2_114.Name = "Footer"
		v2_114.AnchorPoint = Vector2.new(0, 1)
		v2_114.Position = UDim2.new(0, 0, 1, 0)
		v2_114.Size = UDim2.new(1, 0, 0, v1_93)
		v2_114.BackgroundColor3 = v0_8.Sidebar
		v2_114.BorderSizePixel = 0
		v2_114.Parent = v1_71
		local v2_115 = Instance.new("Frame")
		v2_115.Name = "Divider"
		v2_115.Size = UDim2.new(1, 0, 0, 1)
		v2_115.BackgroundColor3 = v0_8.Element
		v2_115.BorderSizePixel = 0
		v2_115.Parent = v2_114
		local function v2_116(v3_117, v3_118, v3_119, v3_120, v3_121)
			local v3_122 = Instance.new("TextLabel")
			v3_122.Name = v3_117
			v3_122.AnchorPoint = v3_121
			v3_122.Position = v3_119
			v3_122.Size = v3_120
			v3_122.BackgroundTransparency = 1
			v3_122.BorderSizePixel = 0
			v3_122.Text = ""
			v3_122.TextColor3 = v0_8.SubText
			v3_122.Font = Enum.Font.Gotham
			v3_122.TextSize = 12
			v3_122.TextXAlignment = v3_118
			v3_122.TextTruncate = Enum.TextTruncate.AtEnd
			v3_122.Parent = v2_114
			return v3_122
		end
		local v2_123 = v2_116("Time", Enum.TextXAlignment.Left, UDim2.new(0, 12, 0, 0), UDim2.new(0, 100, 1, 0), Vector2.new(0, 0))
		local v2_124 = v2_116("Game", Enum.TextXAlignment.Center, UDim2.new(0, 112, 0, 0), UDim2.new(1, -224, 1, 0), Vector2.new(0, 0))
		local v2_125 = v2_116("Executor", Enum.TextXAlignment.Right, UDim2.new(1, -12, 0, 0), UDim2.new(0, 100, 1, 0), Vector2.new(1, 0))
		if type(v1_67.FooterLeft) == "string" then
			v2_123.Text = v1_67.FooterLeft
		else
			local function v3_126()
				local v4_127 = os.date("%I:%M %p")
				if v2_123.Text ~= v4_127 then v2_123.Text = v4_127 end
			end
			v3_126()
			v1_68._clock = task.spawn(function()
				while not v1_68._destroyed do
					task.wait(60 - (os.time() % 60) + 0.1)
					v3_126()
				end
			end)
		end
		if type(v1_67.FooterCenter) == "string" then
			v2_124.Text = v1_67.FooterCenter
		else
			v2_124.Text = "Loading..."
			task.spawn(function()
				local v4_128, v4_129 = pcall(function()
					return v0_7:GetProductInfo(game.PlaceId)
				end)
				if v1_68._destroyed then return end
				v2_124.Text = (v4_128 and v4_129 and v4_129.Name) or tostring(game.Name)
			end)
		end
		if type(v1_67.FooterRight) == "string" then
			v2_125.Text = v1_67.FooterRight
		else
			local v3_130
			if type(identifyexecutor) == "function" then
				local v4_131, v4_132 = pcall(identifyexecutor)
				if v4_131 and v4_132 then v3_130 = tostring(v4_132) end
			end
			v2_125.Text = v3_130 or "Roblox"
		end
	end
	if v1_67.Resizable ~= false then
		local v2_133 = v1_67.MinSize or Vector2.new(380, 260)
		local v2_134 = v1_67.MaxSize
		local v2_135 = Instance.new("TextButton")
		v2_135.Name = "ResizeGrip"
		v2_135.AnchorPoint = Vector2.new(1, 1)
		v2_135.Position = UDim2.new(1, -6, 1, -6 - v1_93)
		v2_135.Size = UDim2.new(0, 22, 0, 22)
		v2_135.BackgroundColor3 = v0_8.Main
		v2_135.BackgroundTransparency = 0.25
		v2_135.BorderSizePixel = 0
		v2_135.Text = ""
		v2_135.AutoButtonColor = false
		v2_135.Parent = v1_71
		v0_63(v2_135, 6)
		local v2_136 = Instance.new("ImageLabel")
		v2_136.Name = "Icon"
		v2_136.AnchorPoint = Vector2.new(0.5, 0.5)
		v2_136.Position = UDim2.new(0.5, 0, 0.5, 0)
		v2_136.Size = UDim2.new(0, 14, 0, 14)
		v2_136.BackgroundTransparency = 1
		v2_136.BorderSizePixel = 0
		v2_136.ImageColor3 = v0_8.IconOff
		v2_136.ScaleType = Enum.ScaleType.Fit
		v2_136.Parent = v2_135
		local v2_137 = Instance.new("TextLabel")
		v2_137.Name = "IconFallback"
		v2_137.Size = UDim2.new(1, 0, 1, 0)
		v2_137.BackgroundTransparency = 1
		v2_137.Text = "⤢"
		v2_137.TextColor3 = v0_8.IconOff
		v2_137.Font = Enum.Font.GothamBold
		v2_137.TextSize = 14
		v2_137.Parent = v2_136
		v2_137.Visible = not v0_44(v2_136, "expand", v1_68.Icons)
		local v2_138 = Instance.new("UIScale")
		v2_138.Parent = v2_135
		local v2_139, v2_140, v2_141 = false, false, nil
		local function v2_142()
			local v3_143 = v2_139 or v2_140
			local v3_144 = v3_143 and v0_8.IconOn or v0_8.IconOff
			v0_12(v2_136, { ImageColor3 = v3_144 }, 0.15)
			v0_12(v2_137, { TextColor3 = v3_144 }, 0.15)
			v0_12(v2_135, { BackgroundColor3 = v3_143 and v0_8.Hover or v0_8.Main }, 0.15)
		end
		local function v2_145()
			if v2_141 then
				for v5_146, v5_147 in ipairs(v2_141) do v5_147:Disconnect() end
				v2_141 = nil
			end
			if v2_140 then
				v2_140 = false
				v2_142()
				v0_12(v2_138, { Scale = v2_139 and 1.1 or 1 }, 0.18, Enum.EasingStyle.Back)
			end
		end
		local function v2_148(v3_149)
			v2_145()
			v2_140 = true
			v2_142()
			v0_12(v2_138, { Scale = 0.9 }, 0.08)
			local v3_150 = v1_72.Scale
			local v3_151 = v3_149.Position
			local v3_152 = v1_71.AbsoluteSize / v3_150
			local v3_153 = v1_71.AbsolutePosition
			v2_141 = {
				v0_4.InputChanged:Connect(function(v4_154)
					if v4_154.UserInputType ~= Enum.UserInputType.MouseMovement and v4_154 ~= v3_149 then return end
					local v4_155 = v4_154.Position - v3_151
					local v4_156 = v1_69.AbsoluteSize
					local v4_157 = math.max(v2_133.X, v4_156.X - v3_153.X - 4)
					local v4_158 = math.max(v2_133.Y, v4_156.Y - v3_153.Y - 4)
					if v2_134 then
						v4_157 = math.max(v2_133.X, math.min(v4_157, v2_134.X))
						v4_158 = math.max(v2_133.Y, math.min(v4_158, v2_134.Y))
					end
					local v4_159 = math.clamp(v3_152.X + v4_155.X / v3_150, v2_133.X, v4_157)
					local v4_160 = math.clamp(v3_152.Y + v4_155.Y / v3_150, v2_133.Y, v4_158)
					v1_70 = UDim2.fromOffset(v4_159, v4_160)
					v1_71.Size = v1_70
					v1_71.Position = UDim2.fromOffset(v3_153.X + v4_159 * v3_150 / 2, v3_153.Y + v4_160 * v3_150 / 2)
				end),
				v0_4.InputEnded:Connect(function(v4_161)
					if v4_161 == v3_149 or v4_161.UserInputType == Enum.UserInputType.MouseButton1 then
						v2_145()
					end
				end),
			}
		end
		v2_135.InputBegan:Connect(function(v3_162)
			if v0_19(v3_162) then v2_148(v3_162) end
		end)
		v2_135.MouseEnter:Connect(function()
			v2_139 = true
			v2_142()
			if not v2_140 then v0_12(v2_138, { Scale = 1.1 }, 0.12) end
		end)
		v2_135.MouseLeave:Connect(function()
			v2_139 = false
			v2_142()
			if not v2_140 then v0_12(v2_138, { Scale = 1 }, 0.12) end
		end)
		v1_68._cleanups[v2_135] = v2_145
	end
	v1_68.ScreenGui, v1_68.Main, v1_68.Sidebar, v1_68.Content = v1_69, v1_71, v1_89, v1_94
	if v1_67.Icon ~= nil then
		v1_68:SetIcon(v1_67.Icon, v1_67.IconColor)
	end
	v1_68._scale = v1_72
	v1_68._visible = false
	if v1_67.Watermark ~= false then
		v1_68:_buildWatermark(v1_67.Title or v1_67.Name or "RobloxUI")
	end
	table.insert(v1_68._connections, v0_4.InputBegan:Connect(function(v2_163, v2_164)
		local v2_165 = v1_68._listening
		if v2_165 then
			if v2_163.UserInputType == Enum.UserInputType.Keyboard then
				if not v0_4:GetFocusedTextBox() then
					v2_165:_capture(v2_163.KeyCode)
				end
			elseif v0_19(v2_163) and not v2_164 then
				v2_165:_stopListening()
			end
			return
		end
		if v2_164 or v2_163.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local v2_166 = v2_163.KeyCode
		if #v1_68._dialogs > 0 then
			if v2_166 == Enum.KeyCode.Escape then
				local v4_167 = v1_68._dialogs[#v1_68._dialogs]
				if v4_167.Dismissable then v4_167.Close() end
			end
			return
		end
		if v1_68._toggleKey and v2_166 == v1_68._toggleKey then
			v1_68:Toggle()
			return
		end
		for v3_168, v3_169 in ipairs(table.clone(v1_68._binds)) do
			if v3_169._key == v2_166 and not v3_169._destroyed then
				v3_169._onPress()
			end
		end
	end))
	if v1_67.StartHidden then
		v1_71.Visible = false
		v1_68:_updateWatermark()
	else
		v1_68:Show()
	end
	return v1_68
end
function v0_1:SetIcon(v1_170, v1_171)
	local v1_172 = self._logo
	if not v1_172 then
		local v2_173 = Instance.new("Frame")
		v2_173.Name = "Logo"
		v2_173.Size = UDim2.new(0, 36, 0, 36)
		v2_173.BackgroundTransparency = 1
		v2_173.BorderSizePixel = 0
		v2_173.LayoutOrder = 0
		v2_173.Visible = false
		v2_173.Parent = self.Sidebar
		local v2_174 = Instance.new("ImageLabel")
		v2_174.Name = "Icon"
		v2_174.AnchorPoint = Vector2.new(0.5, 0.5)
		v2_174.Position = UDim2.new(0.5, 0, 0.5, 0)
		v2_174.Size = UDim2.new(0, 26, 0, 26)
		v2_174.BackgroundTransparency = 1
		v2_174.BorderSizePixel = 0
		v2_174.ScaleType = Enum.ScaleType.Fit
		v2_174.Parent = v2_173
		v1_172 = { Holder = v2_173, Img = v2_174 }
		self._logo = v1_172
	end
	if v1_170 == nil then
		v1_172.Holder.Visible = false
		return false
	end
	local v1_175 = v0_44(v1_172.Img, v1_170, self.Icons)
	v1_172.Holder.Visible = v1_175
	if v1_175 then
		local v2_176 = type(v1_170) == "string" and not v1_170:find("^rbx") and not v1_170:find("^https?://") and not v1_170:match("^%d+$")
		v1_172.Img.ImageColor3 = v1_171 or (v2_176 and v0_8.Accent or Color3.new(1, 1, 1))
	end
	return v1_175
end
function v0_1.CreateWindow(v1_177, v1_178)
	return v0_1.new(v1_177 == v0_1 and v1_178 or v1_177)
end
function v0_1:Destroy()
	for v2_179, v2_180 in ipairs(self._connections) do
		v2_180:Disconnect()
	end
	self._connections = {}
	self._destroyed = true
	if self._hint then pcall(self._hint.HideTip, true) end
	if self._clock then pcall(task.cancel, self._clock) end
	for v2_181, v2_182 in ipairs(table.clone(self._notifs or {})) do pcall(v2_182) end
	for v2_183, v2_184 in pairs(self._cleanups) do pcall(v2_184) end
	self._cleanups = {}
	self._binds = {}
	self._listening = nil
	self.ScreenGui:Destroy()
end
local v0_185, v0_186 = 0.35, 0.2
function v0_1:_cancelAnim()
	if self._anim then
		for v3_187, v3_188 in ipairs(self._anim) do v3_188:Cancel() end
		self._anim = nil
	end
end
function v0_1:Show()
	if self._destroyed then return end
	self._visible = true
	self:_cancelAnim()
	self.Main.Visible = true
	self._anim = {
		v0_12(self.Main, { GroupTransparency = 0 }, v0_185, Enum.EasingStyle.Quint),
		v0_12(self._scale, { Scale = 1 }, v0_185, Enum.EasingStyle.Back),
	}
	self:_updateWatermark()
end
function v0_1:Hide()
	if self._destroyed or not self._visible then return end
	self._visible = false
	self:_cancelAnim()
	local v1_189 = v0_4:GetFocusedTextBox()
	if v1_189 and v1_189:IsDescendantOf(self.Main) then v1_189:ReleaseFocus() end
	local v1_190 = v0_12(self.Main, { GroupTransparency = 1 }, v0_186, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local v1_191 = v0_12(self._scale, { Scale = 0.92 }, v0_186, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	self._anim = { v1_190, v1_191 }
	v1_190.Completed:Connect(function(v2_192)
		if v2_192 == Enum.PlaybackState.Completed and not self._visible and not self._destroyed then
			self.Main.Visible = false
		end
	end)
	self:_updateWatermark()
end
function v0_1:Toggle()
	if self._visible then self:Hide() else self:Show() end
end
function v0_1:IsVisible()
	return self._visible == true
end
function v0_1:_updateScrollHint()
	local v1_193 = self._hint
	if not v1_193 or self._destroyed then return end
	local v1_194 = self.ActiveTab and self.ActiveTab.Page
	local v1_195 = false
	if v1_194 and v1_194.Visible then
		local v2_196 = v1_194.AbsoluteCanvasSize.Y - (v1_194.CanvasPosition.Y + v1_194.AbsoluteWindowSize.Y)
		v1_195 = v2_196 > 4
	end
	if v1_195 == v1_193.Shown then return end
	v1_193.Shown = v1_195
	if v1_193.Fade then v1_193.Fade:Cancel() end
	if v1_195 then
		v1_193.Frame.Visible = true
		v1_193.Icon.Position = UDim2.new(0.5, 0, 0.5, -3)
		v1_193.Bounce:Play()
		v1_193.Fade = v0_12(v1_193.Frame, { GroupTransparency = 0.15 }, 0.2)
	else
		v1_193.HideTip()
		local v2_197 = v0_12(v1_193.Frame, { GroupTransparency = 1 }, 0.2)
		v1_193.Fade = v2_197
		v2_197.Completed:Connect(function(v3_198)
			if v3_198 == Enum.PlaybackState.Completed and not v1_193.Shown then
				v1_193.Bounce:Cancel()
				v1_193.Frame.Visible = false
			end
		end)
	end
end
function v0_1:_keyTaken(v1_199, v1_200)
	if not v1_199 then return false end
	if v1_199 == self._toggleKey then return true end
	for v2_201, v2_202 in ipairs(self._binds) do
		if v2_202 ~= v1_200 and v2_202._key == v1_199 then return true end
	end
	return false
end
local v0_203, v0_204 = 280, 5
function v0_1:_getNotifyContainer()
	if self._notifyContainer and self._notifyContainer.Parent then
		return self._notifyContainer
	end
	local v1_205 = self.ScreenGui.AbsoluteSize
	local v1_206 = v1_205.X > 0 and math.min(v0_203, v1_205.X - 20) or v0_203
	local v1_207 = Instance.new("Frame")
	v1_207.Name = "Notifications"
	v1_207.AnchorPoint = Vector2.new(0.5, 0)
	v1_207.Position = UDim2.new(0.5, 0, 0, self._wm and 48 or 10)
	v1_207.Size = UDim2.new(0, v1_206, 0, 0)
	v1_207.AutomaticSize = Enum.AutomaticSize.Y
	v1_207.BackgroundTransparency = 1
	v1_207.BorderSizePixel = 0
	v1_207.Parent = self.ScreenGui
	local v1_208 = Instance.new("UIListLayout")
	v1_208.Padding = UDim.new(0, 6)
	v1_208.SortOrder = Enum.SortOrder.LayoutOrder
	v1_208.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_208.Parent = v1_207
	self._notifyContainer = v1_207
	return v1_207
end
function v0_1:Notify(v1_209)
	if self._destroyed then return end
	if type(v1_209) == "string" then v1_209 = { Content = v1_209 } end
	v1_209 = v1_209 or {}
	local v1_210 = tonumber(v1_209.Duration) or 4
	local v1_211 = self:_getNotifyContainer()
	self._notifyCount = (self._notifyCount or 0) + 1
	self._notifs = self._notifs or {}
	local v1_212 = false
	local v1_213 = Instance.new("Frame")
	v1_213.Name = "Notification"
	v1_213.Size = UDim2.new(1, 0, 0, 0)
	v1_213.BackgroundTransparency = 1
	v1_213.BorderSizePixel = 0
	v1_213.LayoutOrder = self._notifyCount
	v1_213.Parent = v1_211
	local v1_214 = Instance.new("CanvasGroup")
	v1_214.Name = "Card"
	v1_214.Size = UDim2.new(1, 0, 0, 0)
	v1_214.AutomaticSize = Enum.AutomaticSize.Y
	v1_214.BackgroundColor3 = v0_8.Sidebar
	v1_214.BorderSizePixel = 0
	v1_214.GroupTransparency = 1
	v1_214.Parent = v1_213
	v0_63(v1_214, 8)
	local v1_215 = Instance.new("UIStroke")
	v1_215.Color = v0_8.Element
	v1_215.Thickness = 1
	v1_215.Transparency = 1
	v1_215.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_215.Parent = v1_214
	local v1_216 = Instance.new("Frame")
	v1_216.Name = "Body"
	v1_216.Size = UDim2.new(1, 0, 0, 0)
	v1_216.AutomaticSize = Enum.AutomaticSize.Y
	v1_216.BackgroundTransparency = 1
	v1_216.BorderSizePixel = 0
	v1_216.Parent = v1_214
	local v1_217 = Instance.new("UIPadding")
	v1_217.PaddingTop = UDim.new(0, 8)
	v1_217.PaddingBottom = UDim.new(0, 8)
	v1_217.PaddingLeft = UDim.new(0, 12)
	v1_217.PaddingRight = UDim.new(0, 12)
	v1_217.Parent = v1_216
	local v1_218 = Instance.new("UISizeConstraint")
	v1_218.MinSize = Vector2.new(0, 30)
	v1_218.Parent = v1_216
	local v1_219 = Instance.new("Frame")
	v1_219.Name = "Texts"
	v1_219.Position = UDim2.new(0, 0, 0, 0)
	v1_219.Size = UDim2.new(1, 0, 0, 0)
	v1_219.AutomaticSize = Enum.AutomaticSize.Y
	v1_219.BackgroundTransparency = 1
	v1_219.BorderSizePixel = 0
	v1_219.Parent = v1_216
	local v1_220 = Instance.new("UIListLayout")
	v1_220.Padding = UDim.new(0, 2)
	v1_220.SortOrder = Enum.SortOrder.LayoutOrder
	v1_220.Parent = v1_219
	local function v1_221(v2_222, v2_223, v2_224, v2_225, v2_226)
		local v2_227 = Instance.new("TextLabel")
		v2_227.Size = UDim2.new(1, 0, 0, 0)
		v2_227.AutomaticSize = Enum.AutomaticSize.Y
		v2_227.BackgroundTransparency = 1
		v2_227.BorderSizePixel = 0
		v2_227.Text = v2_222
		v2_227.TextColor3 = v2_225
		v2_227.Font = v2_223
		v2_227.TextSize = v2_224
		v2_227.TextWrapped = true
		v2_227.TextXAlignment = Enum.TextXAlignment.Left
		v2_227.TextYAlignment = Enum.TextYAlignment.Top
		v2_227.LayoutOrder = v2_226
		v2_227.Parent = v1_219
		return v2_227
	end
	if v1_209.Title and v1_209.Title ~= "" then
		v1_221(tostring(v1_209.Title), Enum.Font.GothamBold, 13, v0_8.Text, 1).Name = "Title"
	end
	if v1_209.Content and v1_209.Content ~= "" then
		v1_221(tostring(v1_209.Content), Enum.Font.Gotham, 12, v0_8.SubText, 2).Name = "Content"
	end
	local v1_228 = Instance.new("TextLabel")
	v1_228.Name = "Countdown"
	v1_228.AnchorPoint = Vector2.new(1, 0.5)
	v1_228.Position = UDim2.new(1, 0, 0.5, 0)
	v1_228.Size = UDim2.new(0, 18, 0, 18)
	v1_228.BackgroundTransparency = 1
	v1_228.BorderSizePixel = 0
	v1_228.Text = tostring(math.ceil(v1_210))
	v1_228.TextColor3 = v0_8.SubText
	v1_228.Font = Enum.Font.GothamBold
	v1_228.TextSize = 13
	v1_228.TextXAlignment = Enum.TextXAlignment.Right
	v1_228.Visible = v1_210 > 0
	v1_228.Parent = v1_216
	if v1_210 > 0 then
		v1_219.Size = UDim2.new(1, -24, 0, 0)
	end
	local v1_229 = Instance.new("TextButton")
	v1_229.Name = "Click"
	v1_229.Size = UDim2.new(1, 0, 1, 0)
	v1_229.BackgroundTransparency = 1
	v1_229.BorderSizePixel = 0
	v1_229.Text = ""
	v1_229.AutoButtonColor = false
	v1_229.Parent = v1_214
	local v1_230, v1_231 = nil, nil
	local v1_232 = {}
	local function v1_233()
		if v1_212 then return end
		v1_212 = true
		local v2_234 = table.find(self._notifs, v1_233)
		if v2_234 then table.remove(self._notifs, v2_234) end
		if v1_230 and v1_230 ~= coroutine.running() then
			pcall(task.cancel, v1_230)
		end
		v1_230 = nil
		if v1_231 then
			v1_231:Disconnect()
			v1_231 = nil
		end
		for v3_235, v3_236 in ipairs(v1_232) do v3_236:Cancel() end
		v1_232 = {}
		if self._destroyed then return end
		v0_12(v1_215, { Transparency = 1 }, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v2_237 = v0_12(v1_214, {
			Position = UDim2.new(0, 0, 0, -20),
			GroupTransparency = 1,
		}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_237.Completed:Connect(function()
			local v3_238 = v0_12(v1_213, { Size = UDim2.new(1, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quint)
			v3_238.Completed:Connect(function()
				v1_213:Destroy()
			end)
		end)
	end
	v1_229.MouseButton1Click:Connect(v1_233)
	table.insert(self._notifs, v1_233)
	while #self._notifs > v0_204 do
		self._notifs[1]()
	end
	local v1_239 = false
	v1_231 = v1_214:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if v1_212 then return end
		local v2_240 = v1_214.AbsoluteSize.Y
		if v2_240 <= 0 then return end
		if not v1_239 then
			v1_239 = true
			table.insert(v1_232, v0_12(v1_213, { Size = UDim2.new(1, 0, 0, v2_240) }, 0.3, Enum.EasingStyle.Quint))
		else
			v1_213.Size = UDim2.new(1, 0, 0, v2_240)
		end
	end)
	v1_214.Position = UDim2.new(0, 0, 0, -(v1_211.AbsolutePosition.Y + v1_211.AbsoluteSize.Y + 90))
	v1_232 = {
		v0_12(v1_214, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back),
		v0_12(v1_214, { GroupTransparency = 0 }, 0.25),
		v0_12(v1_215, { Transparency = 0 }, 0.25),
	}
	if v1_210 > 0 then
		v1_230 = task.spawn(function()
			local v3_241 = os.clock()
			local v3_242 = math.ceil(v1_210)
			while not v1_212 and not self._destroyed do
				local v4_243 = v1_210 - (os.clock() - v3_241)
				local v4_244 = math.max(math.ceil(v4_243), 0)
				if v4_244 ~= v3_242 then
					v3_242 = v4_244
					v1_228.Text = tostring(v4_244)
					v1_228.TextTransparency = 0.6
					v0_12(v1_228, { TextTransparency = 0 }, 0.2)
				end
				if v4_243 <= 0 then
					v1_230 = nil
					v1_233()
					return
				end
				task.wait(v4_243 - (v4_244 - 1))
			end
		end)
	end
	return { Dismiss = v1_233 }
end
function v0_1:Dialog(v1_245)
	if self._destroyed then return end
	v1_245 = v1_245 or {}
	local v1_246 = v1_245.Buttons
	if type(v1_246) ~= "table" or #v1_246 == 0 then
		v1_246 = { { Title = "OK", Primary = true } }
	end
	local v1_247 = false
	local v1_248 = {}
	local v1_249 = { Dismissable = v1_245.Dismissable ~= false }
	local v1_250 = Instance.new("Frame")
	v1_250.Name = "DialogOverlay"
	v1_250.Size = UDim2.new(1, 0, 1, 0)
	v1_250.BackgroundTransparency = 1
	v1_250.BorderSizePixel = 0
	v1_250.ZIndex = 100 + #self._dialogs
	v1_250.Parent = self.ScreenGui
	local v1_251 = Instance.new("TextButton")
	v1_251.Name = "Backdrop"
	v1_251.Size = UDim2.new(1, 0, 1, 0)
	v1_251.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	v1_251.BackgroundTransparency = 1
	v1_251.BorderSizePixel = 0
	v1_251.Text = ""
	v1_251.AutoButtonColor = false
	v1_251.Parent = v1_250
	local v1_252 = Instance.new("CanvasGroup")
	v1_252.Name = "Dialog"
	v1_252.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_252.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_252.Size = UDim2.new(0.9, 0, 0, 0)
	v1_252.AutomaticSize = Enum.AutomaticSize.Y
	v1_252.BackgroundColor3 = v0_8.Sidebar
	v1_252.BorderSizePixel = 0
	v1_252.GroupTransparency = 1
	v1_252.Active = true
	v1_252.ZIndex = 2
	v1_252.Parent = v1_250
	v0_63(v1_252, 8)
	local v1_253 = Instance.new("UISizeConstraint")
	v1_253.MinSize = Vector2.new(200, 0)
	v1_253.MaxSize = Vector2.new(320, math.huge)
	v1_253.Parent = v1_252
	local v1_254 = Instance.new("UIScale")
	v1_254.Scale = 0.92
	v1_254.Parent = v1_252
	local v1_255 = Instance.new("UIStroke")
	v1_255.Color = v0_8.Element
	v1_255.Thickness = 1
	v1_255.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_255.Parent = v1_252
	local v1_256 = Instance.new("Frame")
	v1_256.Name = "Body"
	v1_256.Size = UDim2.new(1, 0, 0, 0)
	v1_256.AutomaticSize = Enum.AutomaticSize.Y
	v1_256.BackgroundTransparency = 1
	v1_256.BorderSizePixel = 0
	v1_256.Parent = v1_252
	local v1_257 = Instance.new("UIPadding")
	v1_257.PaddingTop = UDim.new(0, 14)
	v1_257.PaddingBottom = UDim.new(0, 14)
	v1_257.PaddingLeft = UDim.new(0, 14)
	v1_257.PaddingRight = UDim.new(0, 14)
	v1_257.Parent = v1_256
	local v1_258 = Instance.new("UIListLayout")
	v1_258.Padding = UDim.new(0, 8)
	v1_258.SortOrder = Enum.SortOrder.LayoutOrder
	v1_258.Parent = v1_256
	local function v1_259(v2_260, v2_261, v2_262, v2_263, v2_264, v2_265)
		local v2_266 = Instance.new("TextLabel")
		v2_266.Name = v2_260
		v2_266.Size = UDim2.new(1, 0, 0, 0)
		v2_266.AutomaticSize = Enum.AutomaticSize.Y
		v2_266.BackgroundTransparency = 1
		v2_266.BorderSizePixel = 0
		v2_266.Text = v2_261
		v2_266.TextColor3 = v2_264
		v2_266.Font = v2_262
		v2_266.TextSize = v2_263
		v2_266.TextWrapped = true
		v2_266.TextXAlignment = Enum.TextXAlignment.Left
		v2_266.TextYAlignment = Enum.TextYAlignment.Top
		v2_266.LayoutOrder = v2_265
		v2_266.Parent = v1_256
		return v2_266
	end
	if v1_245.Title and v1_245.Title ~= "" then
		v1_259("Title", tostring(v1_245.Title), Enum.Font.GothamBold, 15, v0_8.Text, 1)
	end
	if v1_245.Content and v1_245.Content ~= "" then
		v1_259("Content", tostring(v1_245.Content), Enum.Font.Gotham, 13, v0_8.SubText, 2)
	end
	local v1_267 = Instance.new("Frame")
	v1_267.Name = "Buttons"
	v1_267.Size = UDim2.new(1, 0, 0, 30)
	v1_267.BackgroundTransparency = 1
	v1_267.BorderSizePixel = 0
	v1_267.LayoutOrder = 3
	v1_267.Parent = v1_256
	local v1_268 = Instance.new("UIListLayout")
	v1_268.FillDirection = Enum.FillDirection.Horizontal
	v1_268.HorizontalAlignment = Enum.HorizontalAlignment.Right
	v1_268.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_268.Padding = UDim.new(0, 8)
	v1_268.SortOrder = Enum.SortOrder.LayoutOrder
	v1_268.Parent = v1_267
	local function v1_269()
		if v1_247 then return end
		v1_247 = true
		local v2_270 = table.find(self._dialogs, v1_249)
		if v2_270 then table.remove(self._dialogs, v2_270) end
		for v3_271, v3_272 in ipairs(v1_248) do v3_272:Cancel() end
		v1_248 = {}
		if self._destroyed or not v1_250.Parent then return end
		v0_12(v1_251, { BackgroundTransparency = 1 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v0_12(v1_254, { Scale = 0.94 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v2_273 = v0_12(v1_252, { GroupTransparency = 1 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_273.Completed:Connect(function()
			v1_250:Destroy()
		end)
	end
	v1_249.Close = v1_269
	for v2_274, v2_275 in ipairs(v1_246) do
		local v2_276 = v2_275.Primary == true
		local v2_277 = v2_276 and v0_8.Accent or v0_8.Element
		local v2_278 = v2_276 and v0_8.Accent:Lerp(v0_8.Text, 0.15) or v0_8.Hover
		local v2_279 = Instance.new("TextButton")
		v2_279.Name = "Button"
		v2_279.Size = UDim2.new(0, 0, 0, 30)
		v2_279.AutomaticSize = Enum.AutomaticSize.X
		v2_279.BackgroundColor3 = v2_277
		v2_279.BorderSizePixel = 0
		v2_279.Text = tostring(v2_275.Title or "OK")
		v2_279.TextColor3 = v0_8.Text
		v2_279.Font = Enum.Font.Gotham
		v2_279.TextSize = 13
		v2_279.AutoButtonColor = false
		v2_279.LayoutOrder = v2_274
		v2_279.Parent = v1_267
		v0_63(v2_279, 6)
		local v2_280 = Instance.new("UIPadding")
		v2_280.PaddingLeft = UDim.new(0, 14)
		v2_280.PaddingRight = UDim.new(0, 14)
		v2_280.Parent = v2_279
		v0_21(v2_279, v2_277, v2_278)
		v2_279.MouseButton1Click:Connect(function()
			if v1_247 then return end
			v1_269()
			if v2_275.Callback then v2_275.Callback() end
		end)
	end
	v1_251.MouseButton1Click:Connect(function()
		if v1_249.Dismissable then v1_269() end
	end)
	table.insert(self._dialogs, v1_249)
	v1_248 = {
		v0_12(v1_251, { BackgroundTransparency = 0.45 }, 0.2),
		v0_12(v1_252, { GroupTransparency = 0 }, 0.22),
		v0_12(v1_254, { Scale = 1 }, 0.3, Enum.EasingStyle.Back),
	}
	return { Close = v1_269 }
end
function v0_1:_buildWatermark(v1_281)
	local v1_282 = Instance.new("Frame")
	v1_282.Name = "Watermark"
	v1_282.AnchorPoint = Vector2.new(0.5, 0)
	v1_282.Position = UDim2.new(0.5, 0, 0, -40)
	v1_282.Size = UDim2.new(0, 0, 0, 30)
	v1_282.AutomaticSize = Enum.AutomaticSize.X
	v1_282.BackgroundColor3 = v0_8.Sidebar
	v1_282.BorderSizePixel = 0
	v1_282.Parent = self.ScreenGui
	v0_63(v1_282, 8)
	local v1_283 = Instance.new("UIStroke")
	v1_283.Color = v0_8.Element
	v1_283.Thickness = 1
	v1_283.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_283.Parent = v1_282
	local v1_284 = Instance.new("UIPadding")
	v1_284.PaddingLeft = UDim.new(0, 10)
	v1_284.PaddingRight = UDim.new(0, 4)
	v1_284.Parent = v1_282
	local v1_285 = Instance.new("UIListLayout")
	v1_285.FillDirection = Enum.FillDirection.Horizontal
	v1_285.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_285.Padding = UDim.new(0, 8)
	v1_285.SortOrder = Enum.SortOrder.LayoutOrder
	v1_285.Parent = v1_282
	local v1_286 = Instance.new("TextLabel")
	v1_286.Name = "Title"
	v1_286.Size = UDim2.new(0, 0, 1, 0)
	v1_286.AutomaticSize = Enum.AutomaticSize.X
	v1_286.BackgroundTransparency = 1
	v1_286.BorderSizePixel = 0
	v1_286.Text = v1_281
	v1_286.TextColor3 = v0_8.SubText
	v1_286.Font = Enum.Font.GothamBold
	v1_286.TextSize = 13
	v1_286.LayoutOrder = 1
	v1_286.Parent = v1_282
	local v1_287 = Instance.new("TextButton")
	v1_287.Name = "ToggleButton"
	v1_287.Size = UDim2.new(0, 22, 0, 22)
	v1_287.BackgroundColor3 = v0_8.Element
	v1_287.BorderSizePixel = 0
	v1_287.Text = ""
	v1_287.AutoButtonColor = false
	v1_287.LayoutOrder = 2
	v1_287.Parent = v1_282
	v0_63(v1_287, 6)
	local v1_288 = Instance.new("ImageLabel")
	v1_288.Name = "Icon"
	v1_288.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_288.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_288.Size = UDim2.new(0, 14, 0, 14)
	v1_288.BackgroundTransparency = 1
	v1_288.BorderSizePixel = 0
	v1_288.ImageColor3 = v0_8.IconOn
	v1_288.ScaleType = Enum.ScaleType.Fit
	v1_288.Parent = v1_287
	local v1_289 = Instance.new("TextLabel")
	v1_289.Name = "IconFallback"
	v1_289.Size = UDim2.new(1, 0, 1, 0)
	v1_289.BackgroundTransparency = 1
	v1_289.TextColor3 = v0_8.IconOn
	v1_289.Font = Enum.Font.GothamBold
	v1_289.TextSize = 12
	v1_289.Visible = false
	v1_289.Parent = v1_288
	local v1_290 = Instance.new("UIScale")
	v1_290.Parent = v1_287
	v1_287.MouseEnter:Connect(function() v0_12(v1_290, { Scale = 1.1 }, 0.12) end)
	v1_287.MouseLeave:Connect(function() v0_12(v1_290, { Scale = 1 }, 0.12) end)
	v1_287.InputBegan:Connect(function(v2_291)
		if v0_19(v2_291) then v0_12(v1_290, { Scale = 0.9 }, 0.08) end
	end)
	v1_287.InputEnded:Connect(function(v2_292)
		if v0_19(v2_292) then v0_12(v1_290, { Scale = 1.1 }, 0.15, Enum.EasingStyle.Back) end
	end)
	v1_287.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	local v1_293, v1_294, v1_295 = false, nil, nil
	v1_286.InputBegan:Connect(function(v2_296)
		if v0_19(v2_296) then
			v1_293 = true
			v1_294 = v2_296.Position
			v1_295 = v1_282.AbsolutePosition + Vector2.new(v1_282.AbsoluteSize.X / 2, 0)
			v2_296.Changed:Connect(function()
				if v2_296.UserInputState == Enum.UserInputState.End then v1_293 = false end
			end)
		end
	end)
	table.insert(self._connections, v0_4.InputChanged:Connect(function(v2_297)
		if not v1_293 then return end
		if v2_297.UserInputType ~= Enum.UserInputType.MouseMovement and v2_297.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local v2_298 = v2_297.Position - v1_294
		local v2_299 = self.ScreenGui.AbsoluteSize
		local v2_300 = v1_282.AbsoluteSize.X / 2
		local v2_301 = math.clamp(v1_295.X + v2_298.X, v2_300, math.max(v2_299.X - v2_300, v2_300))
		local v2_302 = math.clamp(v1_295.Y + v2_298.Y, 0, math.max(v2_299.Y - v1_282.AbsoluteSize.Y, 0))
		v1_282.Position = UDim2.fromOffset(v2_301, v2_302)
	end))
	self._wm = { Frame = v1_282, Button = v1_287, Icon = v1_288, Fallback = v1_289 }
	v0_12(v1_282, { Position = UDim2.new(0.5, 0, 0, 10) }, 0.5, Enum.EasingStyle.Back)
end
function v0_1:_updateWatermark()
	local v1_303 = self._wm
	if not v1_303 then return end
	local v1_304 = self._visible == true
	v0_12(v1_303.Button, { BackgroundColor3 = v1_304 and v0_8.Accent or v0_8.Element }, 0.2)
	local v1_305 = v0_44(v1_303.Icon, v1_304 and "eye" or "eye-off", self.Icons)
	if not v1_305 then v1_303.Icon.Image = "" end
	v1_303.Fallback.Visible = not v1_305
	v1_303.Fallback.Text = v1_304 and "●" or "○"
	v1_303.Icon.ImageTransparency = 1
	v0_12(v1_303.Icon, { ImageTransparency = 0 }, 0.2)
end
local function v0_306(v1_307, v1_308)
	local v1_309 = v1_307.Glow
	if not v1_309 then return end
	for v2_310, v2_311 in ipairs(v1_309.Layers) do
		v0_12(v2_311.Obj, { [v2_311.Prop] = v1_308 and v2_311.On or 1 }, 0.25, Enum.EasingStyle.Quad)
	end
end
local function v0_312(v1_313, v1_314)
	v0_12(v1_313.Icon, { ImageColor3 = v1_314 }, 0.2)
	if v1_313.Fallback then
		v0_12(v1_313.Fallback, { TextColor3 = v1_314 }, 0.2)
	end
end
function v0_1:AddTab(v1_315)
	v1_315 = v1_315 or {}
	local v1_316 = Instance.new("TextButton")
	v1_316.Name = "TabButton"
	v1_316.Size = UDim2.new(0, 36, 0, 36)
	v1_316.BackgroundColor3 = v0_8.Card
	v1_316.BorderSizePixel = 0
	v1_316.Text = ""
	v1_316.AutoButtonColor = false
	v1_316.LayoutOrder = #self.Tabs + 1
	v1_316.Parent = self.Sidebar
	v0_63(v1_316, 6)
	local v1_317 = Instance.new("ImageLabel")
	v1_317.Name = "Icon"
	v1_317.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_317.Size = UDim2.new(0, 20, 0, 20)
	v1_317.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_317.BackgroundTransparency = 1
	v1_317.BorderSizePixel = 0
	v1_317.ImageColor3 = v0_8.IconOff
	v1_317.ScaleType = Enum.ScaleType.Fit
	v1_317.Parent = v1_316
	local v1_318
	if not v0_44(v1_317, v1_315.Icon, self.Icons) then
		v1_318 = Instance.new("TextLabel")
		v1_318.Name = "IconFallback"
		v1_318.Size = UDim2.new(1, 0, 1, 0)
		v1_318.BackgroundTransparency = 1
		v1_318.Text = string.upper(string.sub(tostring(v1_315.Name or v1_315.Icon or "?"), 1, 1))
		v1_318.TextColor3 = v0_8.IconOff
		v1_318.Font = Enum.Font.GothamBold
		v1_318.TextSize = 16
		v1_318.Parent = v1_317
	end
	local v1_319
	if self.IconGlow then
		v1_316.BackgroundTransparency = 1
		v1_317.ZIndex = 2
		v1_319 = { Layers = {} }
		if v1_317.Image ~= "" then
			for v4_320, v4_321 in ipairs({ { 26, 0.55 }, { 33, 0.82 } }) do
				local v4_322 = Instance.new("ImageLabel")
				v4_322.Name = "Glow"
				v4_322.AnchorPoint = Vector2.new(0.5, 0.5)
				v4_322.Position = UDim2.new(0.5, 0, 0.5, 0)
				v4_322.Size = UDim2.new(0, v4_321[1], 0, v4_321[1])
				v4_322.BackgroundTransparency = 1
				v4_322.BorderSizePixel = 0
				v4_322.Image = v1_317.Image
				v4_322.ImageRectSize = v1_317.ImageRectSize
				v4_322.ImageRectOffset = v1_317.ImageRectOffset
				v4_322.ImageColor3 = v0_8.Accent
				v4_322.ImageTransparency = 1
				v4_322.ScaleType = Enum.ScaleType.Fit
				v4_322.ZIndex = 1
				v4_322.Parent = v1_316
				table.insert(v1_319.Layers, { Obj = v4_322, Prop = "ImageTransparency", On = v4_321[2] })
			end
		elseif v1_318 then
			local v3_323 = Instance.new("UIStroke")
			v3_323.Color = v0_8.Accent
			v3_323.Thickness = 1
			v3_323.Transparency = 1
			v3_323.Parent = v1_318
			table.insert(v1_319.Layers, { Obj = v3_323, Prop = "Transparency", On = 0.45 })
		end
	end
	local v1_324 = Instance.new("ScrollingFrame")
	v1_324.Name = "Page"
	v1_324.Size = UDim2.new(1, 0, 1, 0)
	v1_324.BackgroundTransparency = 1
	v1_324.BorderSizePixel = 0
	v1_324.ScrollBarThickness = 3
	v1_324.ScrollBarImageColor3 = v0_8.IconOff
	v1_324.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_324.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_324.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_324.Visible = false
	v1_324.Parent = self.Content
	local v1_325 = Instance.new("Frame")
	v1_325.Name = "Inner"
	v1_325.Size = UDim2.new(1, 0, 0, 0)
	v1_325.AutomaticSize = Enum.AutomaticSize.Y
	v1_325.BackgroundTransparency = 1
	v1_325.BorderSizePixel = 0
	v1_325.Parent = v1_324
	local v1_326 = Instance.new("UIPadding")
	v1_326.PaddingTop = UDim.new(0, 12)
	v1_326.PaddingBottom = UDim.new(0, 12)
	v1_326.Parent = v1_325
	local v1_327 = Instance.new("Frame")
	v1_327.Name = "Split"
	v1_327.Position = UDim2.new(0, 12, 0, 0)
	v1_327.Size = UDim2.new(1, -26, 0, 0)
	v1_327.AutomaticSize = Enum.AutomaticSize.Y
	v1_327.BackgroundTransparency = 1
	v1_327.BorderSizePixel = 0
	v1_327.Parent = v1_325
	local v1_328 = Instance.new("UIListLayout")
	v1_328.FillDirection = Enum.FillDirection.Horizontal
	v1_328.Padding = UDim.new(0, 8)
	v1_328.SortOrder = Enum.SortOrder.LayoutOrder
	v1_328.Parent = v1_327
	local function v1_329(v2_330)
		local v2_331 = Instance.new("Frame")
		v2_331.Name = v2_330 == 1 and "Left" or "Right"
		v2_331.Size = UDim2.new(0.5, -4, 0, 0)
		v2_331.AutomaticSize = Enum.AutomaticSize.Y
		v2_331.BackgroundTransparency = 1
		v2_331.BorderSizePixel = 0
		v2_331.LayoutOrder = v2_330
		v2_331.Parent = v1_327
		local v2_332 = Instance.new("UIListLayout")
		v2_332.Padding = UDim.new(0, 8)
		v2_332.SortOrder = Enum.SortOrder.LayoutOrder
		v2_332.Parent = v2_331
		return v2_331
	end
	local v1_333 = setmetatable({
		Page = v1_324,
		Button = v1_316,
		Icon = v1_317,
		Fallback = v1_318,
		Glow = v1_319,
		Inner = v1_325,
		_icons = self.Icons,
		_lib = self,
		Left = v1_329(1),
		Right = v1_329(2),
		_sectionCount = 0,
	}, v0_2)
	table.insert(self.Tabs, v1_333)
	for v2_334, v2_335 in ipairs({ "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" }) do
		table.insert(self._connections, v1_324:GetPropertyChangedSignal(v2_335):Connect(function()
			if self.ActiveTab == v1_333 then self:_updateScrollHint() end
		end))
	end
	if self.IconGlow then
		v1_316.MouseEnter:Connect(function()
			if self.ActiveTab ~= v1_333 then v0_312(v1_333, v0_8.SubText) end
		end)
		v1_316.MouseLeave:Connect(function()
			if self.ActiveTab ~= v1_333 then v0_312(v1_333, v0_8.IconOff) end
		end)
	end
	v0_21(v1_316, v0_8.Card, v0_8.Element, function()
		return self.ActiveTab == v1_333
	end)
	v1_316.MouseButton1Click:Connect(function()
		self:SelectTab(v1_333)
	end)
	if not self.ActiveTab then self:SelectTab(v1_333) end
	return v1_333
end
function v0_1:SelectTab(v1_336)
	if self.ActiveTab == v1_336 then return end
	local v1_337 = self.ActiveTab
	self.ActiveTab = v1_336
	if v1_337 then
		v1_337.Page.Visible = false
		if self.IconGlow then
			v0_306(v1_337, false)
		else
			v0_12(v1_337.Button, { BackgroundColor3 = v0_8.Card }, 0.2)
		end
		v0_312(v1_337, v0_8.IconOff)
	end
	v1_336.Inner.Position = UDim2.new(0, 0, 0, 14)
	v1_336.Page.Visible = true
	v0_12(v1_336.Inner, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)
	if self.IconGlow then
		v0_306(v1_336, true)
	else
		v0_12(v1_336.Button, { BackgroundColor3 = v0_8.Accent }, 0.2)
	end
	v0_312(v1_336, v0_8.IconOn)
	self:_updateScrollHint()
end
function v0_2:AddSection(v1_338, v1_339, v1_340)
	local v1_341 = (v1_339 == "right") and self.Right or self.Left
	local v1_342 = self._lib
	self._sectionCount += 1
	local v1_343 = Instance.new("Frame")
	v1_343.Name = "Section"
	v1_343.Size = UDim2.new(1, 0, 0, 0)
	v1_343.AutomaticSize = Enum.AutomaticSize.Y
	v1_343.BackgroundColor3 = v0_8.Card
	v1_343.BorderSizePixel = 0
	v1_343.LayoutOrder = self._sectionCount
	v1_343.Parent = v1_341
	v0_63(v1_343, 6)
	local v1_344 = Instance.new("UIPadding")
	v1_344.PaddingTop = UDim.new(0, 8)
	v1_344.PaddingBottom = UDim.new(0, 8)
	v1_344.PaddingLeft = UDim.new(0, 8)
	v1_344.PaddingRight = UDim.new(0, 8)
	v1_344.Parent = v1_343
	local v1_345 = Instance.new("UIListLayout")
	v1_345.Padding = UDim.new(0, 6)
	v1_345.SortOrder = Enum.SortOrder.LayoutOrder
	v1_345.Parent = v1_343
	local v1_346 = Instance.new("Frame")
	v1_346.Name = "Body"
	v1_346.Size = UDim2.new(1, 0, 0, 0)
	v1_346.AutomaticSize = Enum.AutomaticSize.Y
	v1_346.BackgroundTransparency = 1
	v1_346.BorderSizePixel = 0
	v1_346.LayoutOrder = 1
	v1_346.Parent = v1_343
	local v1_347 = Instance.new("UIListLayout")
	v1_347.Padding = UDim.new(0, 6)
	v1_347.SortOrder = Enum.SortOrder.LayoutOrder
	v1_347.Parent = v1_346
	local v1_348 = false
	local v1_349 = {}
	local v1_350, v1_351
	local function v1_352()
		local v2_353 = v1_342._scale and v1_342._scale.Scale or 1
		return math.max(v1_347.AbsoluteContentSize.Y / (v2_353 > 0 and v2_353 or 1), 0)
	end
	local function v1_354()
		v1_346.AutomaticSize = Enum.AutomaticSize.Y
		v1_346.Size = UDim2.new(1, 0, 0, 0)
		v1_346.ClipsDescendants = false
	end
	local function v1_355(v2_356, v2_357)
		if v2_356 == v1_348 and not v2_357 then return end
		v1_348 = v2_356
		for v3_358, v3_359 in ipairs(v1_349) do v3_359:Cancel() end
		v1_349 = {}
		if v1_350 then
			if v2_357 then
				v1_350.Rotation = v2_356 and -90 or 0
			else
				v0_12(v1_350, { Rotation = v2_356 and -90 or 0 }, 0.22, Enum.EasingStyle.Quint)
			end
		end
		if v2_357 then
			v1_346.Visible = not v2_356
			v1_345.Padding = UDim.new(0, v2_356 and 0 or 6)
			v1_354()
			return
		end
		v1_346.ClipsDescendants = true
		if v2_356 then
			if v1_346.AutomaticSize ~= Enum.AutomaticSize.None then
				local v4_360 = v1_352()
				v1_346.AutomaticSize = Enum.AutomaticSize.None
				v1_346.Size = UDim2.new(1, 0, 0, v4_360)
			end
			local v3_361 = v0_12(v1_346, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Quint)
			v1_349 = { v3_361, v0_12(v1_345, { Padding = UDim.new(0, 0) }, 0.25, Enum.EasingStyle.Quint) }
			v3_361.Completed:Connect(function(v4_362)
				if v4_362 == Enum.PlaybackState.Completed and v1_348 then
					v1_346.Visible = false
					v1_346.ClipsDescendants = false
				end
			end)
		else
			v1_346.Visible = true
			local v3_363 = v1_352()
			if v3_363 <= 0 then
				v1_345.Padding = UDim.new(0, 6)
				v1_354()
				return
			end
			if v1_346.AutomaticSize ~= Enum.AutomaticSize.None then
				v1_346.AutomaticSize = Enum.AutomaticSize.None
				v1_346.Size = UDim2.new(1, 0, 0, 0)
			end
			local v3_364 = v0_12(v1_346, { Size = UDim2.new(1, 0, 0, v3_363) }, 0.28, Enum.EasingStyle.Quint)
			v1_349 = { v3_364, v0_12(v1_345, { Padding = UDim.new(0, 6) }, 0.28, Enum.EasingStyle.Quint) }
			v3_364.Completed:Connect(function(v4_365)
				if v4_365 == Enum.PlaybackState.Completed and not v1_348 then
					v1_354()
				end
			end)
		end
	end
	if v1_338 then
		local v2_366 = Instance.new("TextButton")
		v2_366.Name = "Header"
		v2_366.Size = UDim2.new(1, 0, 0, 16)
		v2_366.BackgroundTransparency = 1
		v2_366.BorderSizePixel = 0
		v2_366.Text = ""
		v2_366.AutoButtonColor = false
		v2_366.LayoutOrder = 0
		v2_366.Parent = v1_343
		local v2_367 = Instance.new("TextLabel")
		v2_367.Name = "Title"
		v2_367.Size = UDim2.new(1, -22, 1, 0)
		v2_367.BackgroundTransparency = 1
		v2_367.BorderSizePixel = 0
		v2_367.Text = v1_338
		v2_367.TextColor3 = v0_8.SubText
		v2_367.Font = Enum.Font.GothamBold
		v2_367.TextSize = 13
		v2_367.TextXAlignment = Enum.TextXAlignment.Left
		v2_367.TextTruncate = Enum.TextTruncate.AtEnd
		v2_367.Parent = v2_366
		v1_350 = Instance.new("ImageLabel")
		v1_350.Name = "Chevron"
		v1_350.AnchorPoint = Vector2.new(1, 0.5)
		v1_350.Position = UDim2.new(1, 0, 0.5, 0)
		v1_350.Size = UDim2.new(0, 14, 0, 14)
		v1_350.BackgroundTransparency = 1
		v1_350.BorderSizePixel = 0
		v1_350.ImageColor3 = v0_8.SubText
		v1_350.ScaleType = Enum.ScaleType.Fit
		v1_350.Parent = v2_366
		v1_351 = Instance.new("TextLabel")
		v1_351.Name = "ChevronFallback"
		v1_351.Size = UDim2.new(1, 0, 1, 0)
		v1_351.BackgroundTransparency = 1
		v1_351.Text = "▼"
		v1_351.TextColor3 = v0_8.SubText
		v1_351.Font = Enum.Font.Gotham
		v1_351.TextSize = 9
		v1_351.Parent = v1_350
		v1_351.Visible = not v0_44(v1_350, "chevron-down", self._icons)
		v2_366.MouseEnter:Connect(function()
			v0_12(v2_367, { TextColor3 = v0_8.Text }, 0.12)
			v0_12(v1_350, { ImageColor3 = v0_8.Text }, 0.12)
			v0_12(v1_351, { TextColor3 = v0_8.Text }, 0.12)
		end)
		v2_366.MouseLeave:Connect(function()
			v0_12(v2_367, { TextColor3 = v0_8.SubText }, 0.15)
			v0_12(v1_350, { ImageColor3 = v0_8.SubText }, 0.15)
			v0_12(v1_351, { TextColor3 = v0_8.SubText }, 0.15)
		end)
		v2_366.MouseButton1Click:Connect(function()
			v1_355(not v1_348)
		end)
	end
	local v1_368 = setmetatable({
		Holder = v1_346,
		Card = v1_343,
		_count = 0,
		_icons = self._icons,
		_lib = self._lib,
		_setCollapsed = v1_355,
		_isCollapsed = function() return v1_348 end,
	}, v0_3)
	if v1_338 and v1_340 == true then
		v1_355(true, true)
	end
	return v1_368
end
function v0_3:SetCollapsed(v1_369)
	self._setCollapsed(v1_369 == true)
end
function v0_3:ToggleCollapsed()
	self._setCollapsed(not self._isCollapsed())
end
function v0_3:IsCollapsed()
	return self._isCollapsed()
end
local function v0_370(v1_371)
	if typeof(v1_371) == "EnumItem" and v1_371.EnumType == Enum.KeyCode then return v1_371 end
	if type(v1_371) == "string" then
		local v2_372, v2_373 = pcall(function() return Enum.KeyCode[v1_371] end)
		if v2_372 then return v2_373 end
	end
	return nil
end
local function v0_374(v1_375, v1_376, v1_377, v1_378, v1_379)
	v1_377 = v1_377 or {}
	local v1_380 = v1_377.CanBeChanged ~= false
	local v1_381 = {}
	local v1_382 = { _key = nil, _onPress = v1_379, _isListening = false, _destroyed = false }
	local v1_383 = Instance.new("TextButton")
	v1_383.Name = "Keybind"
	v1_383.AnchorPoint = Vector2.new(1, 0.5)
	v1_383.Position = v1_378
	v1_383.Size = UDim2.new(0, 0, 0, 20)
	v1_383.AutomaticSize = Enum.AutomaticSize.X
	v1_383.BackgroundColor3 = v0_8.Card
	v1_383.BorderSizePixel = 0
	v1_383.Text = "None"
	v1_383.TextColor3 = v0_8.SubText
	v1_383.Font = Enum.Font.Gotham
	v1_383.TextSize = 12
	v1_383.TextTruncate = Enum.TextTruncate.AtEnd
	v1_383.AutoButtonColor = false
	v1_383.Parent = v1_376
	v0_63(v1_383, 5)
	v1_382.Instance = v1_383
	local v1_384 = Instance.new("UIPadding")
	v1_384.PaddingLeft = UDim.new(0, 7)
	v1_384.PaddingRight = UDim.new(0, 7)
	v1_384.Parent = v1_383
	local v1_385 = Instance.new("UISizeConstraint")
	v1_385.MinSize = Vector2.new(30, 20)
	v1_385.MaxSize = Vector2.new(96, 20)
	v1_385.Parent = v1_383
	local function v1_386()
		if v1_382._isListening then
			v1_383.Text = "..."
		else
			v1_383.Text = v1_382._key and v1_382._key.Name or "None"
		end
	end
	local function v1_387()
		v1_383.BackgroundColor3 = v0_8.Danger
		v0_12(v1_383, { BackgroundColor3 = v0_8.Card }, 0.45)
	end
	function v1_382:Set(v2_388, v2_389)
		v2_388 = v0_370(v2_388)
		if v2_388 and v1_375:_keyTaken(v2_388, v1_382) then
			warn("[RobloxUI] key already in use:", v2_388.Name)
			v1_387()
			return false
		end
		v1_382._key = v2_388
		v1_386()
		if not v2_389 and v1_377.Callback then v1_377.Callback(v2_388) end
		return true
	end
	function v1_382:Get()
		return v1_382._key
	end
	function v1_382:_startListening()
		if v1_375._listening and v1_375._listening ~= v1_382 then
			v1_375._listening:_stopListening()
		end
		v1_375._listening = v1_382
		v1_382._isListening = true
		v0_12(v1_383, { BackgroundColor3 = v0_8.Accent }, 0.15)
		v1_386()
	end
	function v1_382:_stopListening()
		if v1_375._listening == v1_382 then v1_375._listening = nil end
		v1_382._isListening = false
		v0_12(v1_383, { BackgroundColor3 = v0_8.Card }, 0.15)
		v1_386()
	end
	function v1_382:_capture(v2_390)
		if v2_390 == Enum.KeyCode.Unknown then return end
		v1_382:_stopListening()
		if v2_390 == Enum.KeyCode.Escape then return end
		if v2_390 == Enum.KeyCode.Backspace or v2_390 == Enum.KeyCode.Delete then
			v1_382:Set(nil)
		else
			v1_382:Set(v2_390)
		end
	end
	function v1_382:Destroy()
		if v1_382._destroyed then return end
		v1_382._destroyed = true
		if v1_375._listening == v1_382 then v1_375._listening = nil end
		local v2_391 = table.find(v1_375._binds, v1_382)
		if v2_391 then table.remove(v1_375._binds, v2_391) end
		v1_375._cleanups[v1_382] = nil
		for v3_392, v3_393 in ipairs(v1_381) do v3_393:Disconnect() end
		v1_381 = {}
		v1_383:Destroy()
	end
	if v1_380 then
		v0_21(v1_383, v0_8.Card, v0_8.Sidebar, function() return v1_382._isListening end)
		table.insert(v1_381, v1_383.MouseButton1Click:Connect(function()
			if v1_382._isListening then v1_382:_stopListening() else v1_382:_startListening() end
		end))
		table.insert(v1_381, v1_383.MouseButton2Click:Connect(function()
			if v1_382._isListening then v1_382:_stopListening() end
			v1_382:Set(nil)
		end))
	end
	if v1_377.Key ~= nil then
		v1_382:Set(v1_377.Key, true)
	end
	table.insert(v1_375._binds, v1_382)
	v1_375._cleanups[v1_382] = function() v1_382:Destroy() end
	return v1_382
end
local function v0_394(v1_395, v1_396, v1_397)
	local v1_398 = v1_396.Instance
	local function v1_399()
		local v2_400 = math.clamp(v1_398.TextBounds.X + 14, 30, 96)
		v1_395.Size = UDim2.new(1, -(v1_397 + v2_400 + 6), 1, 0)
	end
	v1_399()
	v1_398:GetPropertyChangedSignal("TextBounds"):Connect(v1_399)
end
function v0_3:AddButton(v1_401)
	v1_401 = v1_401 or {}
	self._count += 1
	local v1_402 = Instance.new("TextButton")
	v1_402.Name = "Button"
	v1_402.Size = UDim2.new(1, 0, 0, 32)
	v1_402.BackgroundColor3 = v0_8.Element
	v1_402.BorderSizePixel = 0
	v1_402.Text = v1_401.Name or "Button"
	v1_402.TextColor3 = v0_8.Text
	v1_402.Font = Enum.Font.Gotham
	v1_402.TextSize = 14
	v1_402.TextTruncate = Enum.TextTruncate.AtEnd
	v1_402.AutoButtonColor = false
	v1_402.LayoutOrder = self._count
	v1_402.Parent = self.Holder
	v0_63(v1_402, 6)
	local v1_403 = Instance.new("UIPadding")
	v1_403.PaddingLeft = UDim.new(0, 8)
	v1_403.PaddingRight = UDim.new(0, 8)
	v1_403.Parent = v1_402
	v0_21(v1_402, v0_8.Element, v0_8.Hover)
	v1_402.MouseButton1Click:Connect(function()
		v1_402.BackgroundColor3 = v0_8.Accent
		v0_12(v1_402, { BackgroundColor3 = v0_8.Hover }, 0.3)
		if v1_401.Callback then v1_401.Callback() end
	end)
	return v1_402
end
function v0_3:AddToggle(v1_404)
	v1_404 = v1_404 or {}
	self._count += 1
	local v1_405 = v1_404.Default == true
	local v1_406 = self
	local v1_407 = Instance.new("TextButton")
	v1_407.Name = "Toggle"
	v1_407.Size = UDim2.new(1, 0, 0, 32)
	v1_407.BackgroundColor3 = v0_8.Element
	v1_407.BorderSizePixel = 0
	v1_407.Text = ""
	v1_407.AutoButtonColor = false
	v1_407.LayoutOrder = self._count
	v1_407.Parent = self.Holder
	v0_63(v1_407, 6)
	v0_21(v1_407, v0_8.Element, v0_8.Hover)
	local v1_408 = Instance.new("TextLabel")
	v1_408.Name = "Label"
	v1_408.Position = UDim2.new(0, 8, 0, 0)
	v1_408.Size = UDim2.new(1, -60, 1, 0)
	v1_408.BackgroundTransparency = 1
	v1_408.BorderSizePixel = 0
	v1_408.Text = v1_404.Name or "Toggle"
	v1_408.TextColor3 = v0_8.Text
	v1_408.Font = Enum.Font.Gotham
	v1_408.TextSize = 14
	v1_408.TextXAlignment = Enum.TextXAlignment.Left
	v1_408.TextTruncate = Enum.TextTruncate.AtEnd
	v1_408.Parent = v1_407
	local v1_409 = Instance.new("Frame")
	v1_409.Name = "Track"
	v1_409.AnchorPoint = Vector2.new(1, 0.5)
	v1_409.Position = UDim2.new(1, -8, 0.5, 0)
	v1_409.Size = UDim2.new(0, 34, 0, 18)
	v1_409.BackgroundColor3 = v0_8.Off
	v1_409.BorderSizePixel = 0
	v1_409.Parent = v1_407
	v0_63(v1_409, 9)
	local v1_410 = Instance.new("Frame")
	v1_410.Name = "Knob"
	v1_410.AnchorPoint = Vector2.new(0, 0.5)
	v1_410.Position = UDim2.new(0, 2, 0.5, 0)
	v1_410.Size = UDim2.new(0, 14, 0, 14)
	v1_410.BackgroundColor3 = v0_8.Text
	v1_410.BorderSizePixel = 0
	v1_410.Parent = v1_409
	v0_63(v1_410, 7)
	local function v1_411(v2_412)
		local v2_413 = TweenInfo.new(v2_412 and 0.15 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		v0_5:Create(v1_409, v2_413, { BackgroundColor3 = v1_405 and v0_8.Accent or v0_8.Off }):Play()
		v0_5:Create(v1_410, v2_413, {
			Position = v1_405 and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}):Play()
	end
	v1_411(false)
	local v1_414 = { Instance = v1_407 }
	function v1_414:Set(v2_415, v2_416)
		v1_405 = v2_415 and true or false
		v1_411(true)
		if not v2_416 and v1_404.Callback then v1_404.Callback(v1_405) end
	end
	function v1_414:Get()
		return v1_405
	end
	v1_407.MouseButton1Click:Connect(function()
		v1_414:Set(not v1_405)
	end)
	function v1_414:AddKeybind(v2_417)
		if v1_414.Keybind then
			warn("[RobloxUI] this toggle already has a keybind")
			return v1_414.Keybind
		end
		local v2_418 = v0_374(v1_406._lib, v1_407, v2_417, UDim2.new(1, -48, 0.5, 0), function()
			v1_414:Set(not v1_405)
		end)
		v0_394(v1_408, v2_418, 60)
		local v2_419 = v2_418.Destroy
		function v2_418:Destroy()
			v2_419(v2_418)
			v1_414.Keybind = nil
			v1_408.Size = UDim2.new(1, -60, 1, 0)
		end
		v1_414.Keybind = v2_418
		return v2_418
	end
	function v1_414:Destroy()
		if v1_414._destroyed then return end
		v1_414._destroyed = true
		if v1_414.Keybind then v1_414.Keybind:Destroy() end
		v1_407:Destroy()
	end
	return v1_414
end
function v0_3:AddParagraph(v1_420)
	v1_420 = v1_420 or {}
	self._count += 1
	local v1_421 = v1_420.Title and tostring(v1_420.Title) or ""
	local v1_422 = v1_420.Content and tostring(v1_420.Content) or ""
	local v1_423 = Instance.new("Frame")
	v1_423.Name = "Paragraph"
	v1_423.Size = UDim2.new(1, 0, 0, 0)
	v1_423.AutomaticSize = Enum.AutomaticSize.Y
	v1_423.BackgroundColor3 = v0_8.Element
	v1_423.BorderSizePixel = 0
	v1_423.LayoutOrder = self._count
	v1_423.Parent = self.Holder
	v0_63(v1_423, 6)
	local v1_424 = Instance.new("UIPadding")
	v1_424.PaddingTop = UDim.new(0, 8)
	v1_424.PaddingBottom = UDim.new(0, 8)
	v1_424.PaddingLeft = UDim.new(0, 8)
	v1_424.PaddingRight = UDim.new(0, 8)
	v1_424.Parent = v1_423
	local v1_425 = Instance.new("UIListLayout")
	v1_425.Padding = UDim.new(0, 3)
	v1_425.SortOrder = Enum.SortOrder.LayoutOrder
	v1_425.Parent = v1_423
	local function v1_426(v2_427, v2_428, v2_429, v2_430, v2_431)
		local v2_432 = Instance.new("TextLabel")
		v2_432.Name = v2_427
		v2_432.Size = UDim2.new(1, 0, 0, 0)
		v2_432.AutomaticSize = Enum.AutomaticSize.Y
		v2_432.BackgroundTransparency = 1
		v2_432.BorderSizePixel = 0
		v2_432.TextColor3 = v2_430
		v2_432.Font = v2_428
		v2_432.TextSize = v2_429
		v2_432.TextWrapped = true
		v2_432.RichText = v1_420.RichText == true
		v2_432.TextXAlignment = Enum.TextXAlignment.Left
		v2_432.TextYAlignment = Enum.TextYAlignment.Top
		v2_432.LayoutOrder = v2_431
		v2_432.Parent = v1_423
		return v2_432
	end
	local v1_433 = v1_426("Title", Enum.Font.GothamBold, 14, v0_8.Text, 1)
	local v1_434 = v1_426("Content", Enum.Font.Gotham, 13, v0_8.SubText, 2)
	local function v1_435(v2_436)
		v1_433.Text = v1_421
		v1_433.Visible = v1_421 ~= ""
		v1_434.Text = v1_422
		v1_434.Visible = v1_422 ~= ""
		if v2_436 then
			v1_433.TextTransparency = 1
			v1_434.TextTransparency = 1
			v0_12(v1_433, { TextTransparency = 0 }, 0.2)
			v0_12(v1_434, { TextTransparency = 0 }, 0.2)
		end
	end
	v1_435(false)
	local v1_437 = { Instance = v1_423 }
	function v1_437:SetTitle(v2_438)
		v1_421 = v2_438 and tostring(v2_438) or ""
		v1_435(true)
	end
	function v1_437:SetContent(v2_439)
		v1_422 = v2_439 and tostring(v2_439) or ""
		v1_435(true)
	end
	function v1_437:Set(v2_440)
		v2_440 = v2_440 or {}
		if v2_440.Title ~= nil then v1_421 = tostring(v2_440.Title) end
		if v2_440.Content ~= nil then v1_422 = tostring(v2_440.Content) end
		v1_435(true)
	end
	function v1_437:Get()
		return v1_421, v1_422
	end
	function v1_437:Destroy()
		v1_423:Destroy()
	end
	return v1_437
end
function v0_3:AddTextbox(v1_441)
	v1_441 = v1_441 or {}
	self._count += 1
	local v1_442 = v1_441.Numeric == true
	local v1_443 = tonumber(v1_441.MaxLength)
	local v1_444 = v1_441.Name ~= nil and v1_441.Name ~= ""
	local v1_445, v1_446, v1_447 = false, false, false
	local function v1_448(v2_449)
		if v1_441.Min then v2_449 = math.max(v2_449, v1_441.Min) end
		if v1_441.Max then v2_449 = math.min(v2_449, v1_441.Max) end
		return v2_449
	end
	local v1_450
	if v1_442 then
		v1_450 = tonumber(v1_441.Default)
		if v1_450 then v1_450 = v1_448(v1_450) end
	else
		v1_450 = tostring(v1_441.Default or "")
	end
	local function v1_451(v2_452)
		return v2_452 == nil and "" or tostring(v2_452)
	end
	local function v1_453(v2_454)
		local v2_455 = v2_454:sub(1, 1) == "-"
		v2_454 = v2_454:gsub("[^%d%.]", "")
		local v2_456 = v2_454:find(".", 1, true)
		if v2_456 then
			local v3_457 = v2_454:sub(v2_456 + 1):gsub("%.", "")
			v2_454 = v2_454:sub(1, v2_456) .. v3_457
		end
		return (v2_455 and "-" or "") .. v2_454
	end
	local v1_458 = Instance.new("Frame")
	v1_458.Name = "Textbox"
	v1_458.Size = UDim2.new(1, 0, 0, 32)
	v1_458.BackgroundColor3 = v0_8.Element
	v1_458.BorderSizePixel = 0
	v1_458.LayoutOrder = self._count
	v1_458.Parent = self.Holder
	v0_63(v1_458, 6)
	if v1_444 then
		local v2_459 = Instance.new("TextLabel")
		v2_459.Name = "Label"
		v2_459.Position = UDim2.new(0, 8, 0, 0)
		v2_459.Size = UDim2.new(0.4, -8, 1, 0)
		v2_459.BackgroundTransparency = 1
		v2_459.BorderSizePixel = 0
		v2_459.Text = v1_441.Name
		v2_459.TextColor3 = v0_8.Text
		v2_459.Font = Enum.Font.Gotham
		v2_459.TextSize = 14
		v2_459.TextXAlignment = Enum.TextXAlignment.Left
		v2_459.TextTruncate = Enum.TextTruncate.AtEnd
		v2_459.Parent = v1_458
	end
	local v1_460 = Instance.new("Frame")
	v1_460.Name = "BoxHolder"
	v1_460.AnchorPoint = Vector2.new(1, 0.5)
	v1_460.Position = UDim2.new(1, -6, 0.5, 0)
	v1_460.Size = v1_444 and UDim2.new(0.6, -10, 0, 22) or UDim2.new(1, -12, 0, 22)
	v1_460.BackgroundColor3 = v0_8.Card
	v1_460.BorderSizePixel = 0
	v1_460.Parent = v1_458
	v0_63(v1_460, 5)
	local v1_461 = Instance.new("UIStroke")
	v1_461.Color = v0_8.Accent
	v1_461.Thickness = 1
	v1_461.Transparency = 1
	v1_461.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_461.Parent = v1_460
	local v1_462 = Instance.new("TextBox")
	v1_462.Name = "Input"
	v1_462.Size = UDim2.new(1, 0, 1, 0)
	v1_462.BackgroundTransparency = 1
	v1_462.BorderSizePixel = 0
	v1_462.Text = v1_451(v1_450)
	v1_462.PlaceholderText = v1_441.Placeholder or ""
	v1_462.PlaceholderColor3 = v0_8.IconOff
	v1_462.TextColor3 = v0_8.Text
	v1_462.Font = Enum.Font.Gotham
	v1_462.TextSize = 13
	v1_462.TextXAlignment = Enum.TextXAlignment.Left
	v1_462.ClearTextOnFocus = v1_441.ClearTextOnFocus == true
	v1_462.ClipsDescendants = true
	v1_462.Parent = v1_460
	local v1_463 = Instance.new("UIPadding")
	v1_463.PaddingLeft = UDim.new(0, 6)
	v1_463.PaddingRight = UDim.new(0, 6)
	v1_463.Parent = v1_462
	local function v1_464()
		v0_12(v1_460, { BackgroundColor3 = (v1_446 and not v1_445) and v0_8.Sidebar or v0_8.Card }, 0.12)
		v0_12(v1_461, { Transparency = v1_445 and 0 or 1 }, 0.15)
	end
	v1_462:GetPropertyChangedSignal("Text"):Connect(function()
		if v1_447 then return end
		local v2_465 = v1_462.Text
		if v1_442 then v2_465 = v1_453(v2_465) end
		if v1_443 and #v2_465 > v1_443 then v2_465 = v2_465:sub(1, v1_443) end
		if v2_465 ~= v1_462.Text then
			v1_447 = true
			v1_462.Text = v2_465
			v1_447 = false
		end
	end)
	v1_462.Focused:Connect(function()
		v1_445 = true
		v1_464()
	end)
	v1_462.FocusLost:Connect(function(v2_466)
		v1_445 = false
		v1_464()
		if v1_442 then
			local v3_467 = tonumber(v1_462.Text)
			if v3_467 == nil then
				v1_462.Text = v1_451(v1_450)
				return
			end
			v3_467 = v1_448(v3_467)
			v1_450 = v3_467
			v1_462.Text = v1_451(v3_467)
		else
			v1_450 = v1_462.Text
		end
		if v1_441.Callback then v1_441.Callback(v1_450, v2_466) end
	end)
	v1_460.MouseEnter:Connect(function()
		v1_446 = true
		v1_464()
	end)
	v1_460.MouseLeave:Connect(function()
		v1_446 = false
		v1_464()
	end)
	local v1_468 = { Instance = v1_458 }
	function v1_468:Set(v2_469, v2_470)
		if v1_442 then
			local v3_471 = tonumber(v2_469)
			if v3_471 == nil then return end
			v1_450 = v1_448(v3_471)
		else
			v1_450 = tostring(v2_469 == nil and "" or v2_469)
			if v1_443 then v1_450 = v1_450:sub(1, v1_443) end
		end
		v1_462.Text = v1_451(v1_450)
		if not v2_470 and v1_441.Callback then v1_441.Callback(v1_450, false) end
	end
	function v1_468:Get()
		return v1_450
	end
	function v1_468:Focus()
		v1_462:CaptureFocus()
	end
	function v1_468:Destroy()
		if v1_462:IsFocused() then v1_462:ReleaseFocus() end
		v1_458:Destroy()
	end
	return v1_468
end
function v0_3:AddKeybind(v1_472)
	v1_472 = v1_472 or {}
	self._count += 1
	local v1_473 = Instance.new("Frame")
	v1_473.Name = "KeybindRow"
	v1_473.Size = UDim2.new(1, 0, 0, 32)
	v1_473.BackgroundColor3 = v0_8.Element
	v1_473.BorderSizePixel = 0
	v1_473.LayoutOrder = self._count
	v1_473.Parent = self.Holder
	v0_63(v1_473, 6)
	local v1_474 = Instance.new("TextLabel")
	v1_474.Name = "Label"
	v1_474.Position = UDim2.new(0, 8, 0, 0)
	v1_474.Size = UDim2.new(1, -60, 1, 0)
	v1_474.BackgroundTransparency = 1
	v1_474.BorderSizePixel = 0
	v1_474.Text = v1_472.Name or "Keybind"
	v1_474.TextColor3 = v0_8.Text
	v1_474.Font = Enum.Font.Gotham
	v1_474.TextSize = 14
	v1_474.TextXAlignment = Enum.TextXAlignment.Left
	v1_474.TextTruncate = Enum.TextTruncate.AtEnd
	v1_474.Parent = v1_473
	local v1_475 = v0_374(self._lib, v1_473, v1_472, UDim2.new(1, -8, 0.5, 0), function()
		if v1_472.OnPress then v1_472.OnPress() end
	end)
	v0_394(v1_474, v1_475, 16)
	v1_475.Row = v1_473
	local v1_476 = v1_475.Destroy
	function v1_475:Destroy()
		v1_476(v1_475)
		v1_473:Destroy()
	end
	return v1_475
end
function v0_3:AddSlider(v1_477)
	v1_477 = v1_477 or {}
	self._count += 1
	local v1_478 = self._lib
	local function v1_479(v2_480)
		return #(tostring(v2_480):match("%.(%d+)") or "")
	end
	local v1_481 = tonumber(v1_477.Min) or 0
	local v1_482 = tonumber(v1_477.Max) or 100
	if v1_482 < v1_481 then v1_481, v1_482 = v1_482, v1_481 end
	local v1_483 = tonumber(v1_477.Increment) or 1
	if v1_483 <= 0 then v1_483 = 1 end
	local v1_484 = math.max(v1_479(v1_483), v1_479(v1_481))
	local v1_485 = v1_477.ValueName
	local function v1_486(v2_487)
		v2_487 = math.clamp(v2_487, v1_481, v1_482)
		v2_487 = v1_481 + math.floor((v2_487 - v1_481) / v1_483 + 0.5) * v1_483
		v2_487 = math.clamp(v2_487, v1_481, v1_482)
		local v2_488 = 10 ^ v1_484
		return math.floor(v2_487 * v2_488 + 0.5) / v2_488
	end
	local function v1_489(v2_490)
		return v1_482 > v1_481 and (v2_490 - v1_481) / (v1_482 - v1_481) or 0
	end
	local function v1_491(v2_492)
		local v2_493 = v1_484 > 0 and string.format("%." .. v1_484 .. "f", v2_492) or tostring(v2_492)
		if v1_485 and v1_485 ~= "" then v2_493 = v2_493 .. " " .. tostring(v1_485) end
		return v2_493
	end
	local v1_494 = v1_486(tonumber(v1_477.Default) or v1_481)
	local v1_495, v1_496 = false, false
	local v1_497 = nil
	local v1_498 = Instance.new("Frame")
	v1_498.Name = "Slider"
	v1_498.Size = UDim2.new(1, 0, 0, 46)
	v1_498.BackgroundColor3 = v0_8.Element
	v1_498.BorderSizePixel = 0
	v1_498.LayoutOrder = self._count
	v1_498.Parent = self.Holder
	v0_63(v1_498, 6)
	local v1_499 = Instance.new("TextLabel")
	v1_499.Name = "Name"
	v1_499.Position = UDim2.new(0, 8, 0, 6)
	v1_499.Size = UDim2.new(0.6, -8, 0, 16)
	v1_499.BackgroundTransparency = 1
	v1_499.BorderSizePixel = 0
	v1_499.Text = v1_477.Name or "Slider"
	v1_499.TextColor3 = v0_8.Text
	v1_499.Font = Enum.Font.Gotham
	v1_499.TextSize = 14
	v1_499.TextXAlignment = Enum.TextXAlignment.Left
	v1_499.TextTruncate = Enum.TextTruncate.AtEnd
	v1_499.Parent = v1_498
	local v1_500 = Instance.new("TextLabel")
	v1_500.Name = "Value"
	v1_500.Position = UDim2.new(0.6, 0, 0, 6)
	v1_500.Size = UDim2.new(0.4, -8, 0, 16)
	v1_500.BackgroundTransparency = 1
	v1_500.BorderSizePixel = 0
	v1_500.Text = v1_491(v1_494)
	v1_500.TextColor3 = v0_8.SubText
	v1_500.Font = Enum.Font.GothamBold
	v1_500.TextSize = 13
	v1_500.TextXAlignment = Enum.TextXAlignment.Right
	v1_500.TextTruncate = Enum.TextTruncate.AtEnd
	v1_500.Parent = v1_498
	local v1_501 = Instance.new("Frame")
	v1_501.Name = "Track"
	v1_501.Position = UDim2.new(0, 8, 0, 31)
	v1_501.Size = UDim2.new(1, -16, 0, 6)
	v1_501.BackgroundColor3 = v0_8.Off
	v1_501.BorderSizePixel = 0
	v1_501.Parent = v1_498
	local v1_502 = Instance.new("Frame")
	v1_502.Name = "Fill"
	v1_502.Size = UDim2.new(v1_489(v1_494), 0, 1, 0)
	v1_502.BackgroundColor3 = v0_8.Accent
	v1_502.BorderSizePixel = 0
	v1_502.Parent = v1_501
	local v1_503 = v0_8.Accent
	local v1_504 = v0_8.Accent:Lerp(v0_8.Text, 0.25)
	local v1_505 = Instance.new("TextButton")
	v1_505.Name = "Hit"
	v1_505.Size = UDim2.new(1, 0, 1, 0)
	v1_505.BackgroundTransparency = 1
	v1_505.BorderSizePixel = 0
	v1_505.Text = ""
	v1_505.AutoButtonColor = false
	v1_505.Parent = v1_498
	local function v1_506()
		local v2_507 = v1_495 or v1_496
		v0_12(v1_498, { BackgroundColor3 = v2_507 and v0_8.Hover or v0_8.Element }, 0.12)
		v0_12(v1_502, { BackgroundColor3 = v2_507 and v1_504 or v1_503 }, 0.12)
	end
	local function v1_508(v2_509)
		local v2_510 = v1_489(v1_494)
		v0_12(v1_502, { Size = UDim2.new(v2_510, 0, 1, 0) }, v2_509)
		v1_500.Text = v1_491(v1_494)
	end
	local function v1_511(v2_512, v2_513, v2_514)
		v2_512 = v1_486(v2_512)
		local v2_515 = v2_512 ~= v1_494
		v1_494 = v2_512
		v1_508(v2_514)
		if v2_515 then
			v1_500.TextColor3 = v0_8.Text
			v0_12(v1_500, { TextColor3 = v0_8.SubText }, 0.3)
			if not v2_513 and v1_477.Callback then v1_477.Callback(v1_494) end
		end
	end
	local function v1_516(v2_517)
		local v2_518 = v1_501.AbsoluteSize.X
		if v2_518 <= 0 then return end
		v1_511(v1_481 + ((v2_517 - v1_501.AbsolutePosition.X) / v2_518) * (v1_482 - v1_481), false, 0.08)
	end
	local function v1_519()
		if v1_497 then
			for v4_520, v4_521 in ipairs(v1_497) do v4_521:Disconnect() end
			v1_497 = nil
		end
		if v1_496 then
			v1_496 = false
			v1_506()
		end
	end
	local function v1_522(v2_523)
		v1_519()
		v1_496 = true
		v1_506()
		v1_516(v2_523.Position.X)
		v1_497 = {
			v0_4.InputChanged:Connect(function(v3_524)
				if v3_524.UserInputType == Enum.UserInputType.MouseMovement or v3_524 == v2_523 then
					v1_516(v3_524.Position.X)
				end
			end),
			v0_4.InputEnded:Connect(function(v3_525)
				if v3_525 == v2_523 or v3_525.UserInputType == Enum.UserInputType.MouseButton1 then
					v1_519()
				end
			end),
		}
	end
	v1_505.InputBegan:Connect(function(v2_526)
		if v0_19(v2_526) then v1_522(v2_526) end
	end)
	v1_505.MouseEnter:Connect(function()
		v1_495 = true
		v1_506()
	end)
	v1_505.MouseLeave:Connect(function()
		v1_495 = false
		v1_506()
	end)
	local v1_527 = { Instance = v1_498 }
	function v1_527:Set(v2_528, v2_529)
		v1_511(tonumber(v2_528) or v1_494, v2_529, 0.2)
	end
	function v1_527:Get()
		return v1_494
	end
	function v1_527:Destroy()
		v1_519()
		v1_478._cleanups[v1_527] = nil
		v1_498:Destroy()
	end
	v1_478._cleanups[v1_527] = v1_519
	return v1_527
end
function v0_3:AddDropdown(v1_530)
	v1_530 = v1_530 or {}
	self._count += 1
	local v1_531 = v1_530.Options or {}
	local v1_532 = v1_530.Multi == true
	local v1_533 = 130
	local v1_534, v1_535 = 26, 4
	local v1_536 = nil
	local v1_537 = {}
	local v1_538 = {}
	local v1_539 = false
	local v1_540 = 0
	local v1_541 = nil
	local v1_542 = Instance.new("Frame")
	v1_542.Name = "Dropdown"
	v1_542.Size = UDim2.new(1, 0, 0, 32)
	v1_542.AutomaticSize = Enum.AutomaticSize.Y
	v1_542.BackgroundTransparency = 1
	v1_542.BorderSizePixel = 0
	v1_542.LayoutOrder = self._count
	v1_542.Parent = self.Holder
	local v1_543 = Instance.new("UIListLayout")
	v1_543.Padding = UDim.new(0, 4)
	v1_543.SortOrder = Enum.SortOrder.LayoutOrder
	v1_543.Parent = v1_542
	local v1_544 = Instance.new("TextButton")
	v1_544.Name = "Header"
	v1_544.Size = UDim2.new(1, 0, 0, 32)
	v1_544.BackgroundColor3 = v0_8.Element
	v1_544.BorderSizePixel = 0
	v1_544.Text = ""
	v1_544.AutoButtonColor = false
	v1_544.LayoutOrder = 1
	v1_544.Parent = v1_542
	v0_63(v1_544, 6)
	v0_21(v1_544, v0_8.Element, v0_8.Hover)
	local v1_545 = Instance.new("TextLabel")
	v1_545.Name = "Name"
	v1_545.Position = UDim2.new(0, 8, 0, 0)
	v1_545.Size = UDim2.new(0.5, -8, 1, 0)
	v1_545.BackgroundTransparency = 1
	v1_545.BorderSizePixel = 0
	v1_545.Text = v1_530.Name or "Dropdown"
	v1_545.TextColor3 = v0_8.Text
	v1_545.Font = Enum.Font.Gotham
	v1_545.TextSize = 14
	v1_545.TextXAlignment = Enum.TextXAlignment.Left
	v1_545.TextTruncate = Enum.TextTruncate.AtEnd
	v1_545.Parent = v1_544
	local v1_546 = Instance.new("TextLabel")
	v1_546.Name = "Value"
	v1_546.Position = UDim2.new(0.5, 0, 0, 0)
	v1_546.Size = UDim2.new(0.5, -28, 1, 0)
	v1_546.BackgroundTransparency = 1
	v1_546.BorderSizePixel = 0
	v1_546.Text = "None"
	v1_546.TextColor3 = v0_8.SubText
	v1_546.Font = Enum.Font.Gotham
	v1_546.TextSize = 13
	v1_546.TextXAlignment = Enum.TextXAlignment.Right
	v1_546.TextTruncate = Enum.TextTruncate.AtEnd
	v1_546.Parent = v1_544
	local v1_547 = Instance.new("ImageLabel")
	v1_547.Name = "Arrow"
	v1_547.AnchorPoint = Vector2.new(1, 0.5)
	v1_547.Position = UDim2.new(1, -8, 0.5, 0)
	v1_547.Size = UDim2.new(0, 16, 0, 16)
	v1_547.BackgroundTransparency = 1
	v1_547.BorderSizePixel = 0
	v1_547.ImageColor3 = v0_8.SubText
	v1_547.ScaleType = Enum.ScaleType.Fit
	v1_547.Parent = v1_544
	local v1_548 = Instance.new("TextLabel")
	v1_548.Name = "ArrowFallback"
	v1_548.Size = UDim2.new(1, 0, 1, 0)
	v1_548.BackgroundTransparency = 1
	v1_548.Text = "▼"
	v1_548.TextColor3 = v0_8.SubText
	v1_548.Font = Enum.Font.Gotham
	v1_548.TextSize = 9
	v1_548.Visible = false
	v1_548.Parent = v1_547
	local function v1_549(v2_550)
		local v2_551 = v0_44(v1_547, v2_550 and "chevron-up" or "chevron-down", self._icons)
		if not v2_551 then v1_547.Image = "" end
		v1_548.Visible = not v2_551
		v1_548.Text = v2_550 and "▲" or "▼"
		v1_547.ImageTransparency = 1
		v1_548.TextTransparency = 1
		v0_12(v1_547, { ImageTransparency = 0 }, 0.18)
		v0_12(v1_548, { TextTransparency = 0 }, 0.18)
	end
	v1_549(false)
	local v1_552 = Instance.new("ScrollingFrame")
	v1_552.Name = "List"
	v1_552.Size = UDim2.new(1, 0, 0, 0)
	v1_552.BackgroundColor3 = v0_8.Sidebar
	v1_552.BorderSizePixel = 0
	v1_552.ScrollBarThickness = 3
	v1_552.ScrollBarImageColor3 = v0_8.IconOff
	v1_552.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_552.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_552.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_552.Visible = false
	v1_552.LayoutOrder = 2
	v1_552.Parent = v1_542
	v0_63(v1_552, 6)
	local v1_553 = Instance.new("UIPadding")
	v1_553.PaddingTop = UDim.new(0, 4)
	v1_553.PaddingBottom = UDim.new(0, 4)
	v1_553.Parent = v1_552
	local v1_554 = Instance.new("UIListLayout")
	v1_554.Padding = UDim.new(0, v1_535)
	v1_554.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_554.SortOrder = Enum.SortOrder.LayoutOrder
	v1_554.Parent = v1_552
	local function v1_555(v2_556)
		if v1_532 then return v1_537[v2_556] == true end
		return v1_536 == v2_556
	end
	local function v1_557()
		local v2_558 = {}
		for v3_559, v3_560 in ipairs(v1_531) do
			if v1_537[v3_560] then table.insert(v2_558, v3_560) end
		end
		return v2_558
	end
	local function v1_561()
		for v3_562, v3_563 in pairs(v1_538) do
			local v3_564 = v1_555(v3_562)
			v3_563.BackgroundColor3 = v3_564 and v0_8.Accent or v0_8.Element
			v3_563.TextColor3 = v3_564 and v0_8.IconOn or v0_8.SubText
		end
		if v1_532 then
			local v3_565 = {}
			for v4_566, v4_567 in ipairs(v1_557()) do table.insert(v3_565, tostring(v4_567)) end
			v1_546.Text = #v3_565 > 0 and table.concat(v3_565, ", ") or "None"
		else
			v1_546.Text = v1_536 ~= nil and tostring(v1_536) or "None"
		end
	end
	local function v1_568(v2_569)
		if v1_539 == v2_569 then return end
		v1_539 = v2_569
		if v1_541 then v1_541:Cancel() end
		v1_549(v2_569)
		if v2_569 then
			v1_552.Visible = true
			v1_541 = v0_12(v1_552, { Size = UDim2.new(1, 0, 0, v1_540) }, 0.22, Enum.EasingStyle.Quint)
		else
			local v3_570 = v0_12(v1_552, { Size = UDim2.new(1, 0, 0, 0) }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v1_541 = v3_570
			v3_570.Completed:Connect(function(v4_571)
				if v4_571 == Enum.PlaybackState.Completed and not v1_539 then
					v1_552.Visible = false
				end
			end)
		end
	end
	local v1_572 = { Instance = v1_542 }
	local function v1_573()
		if v1_530.Callback then
			v1_530.Callback(v1_532 and v1_557() or v1_536)
		end
	end
	local function v1_574()
		for v3_575, v3_576 in pairs(v1_538) do v3_576:Destroy() end
		v1_538 = {}
		for v3_577, v3_578 in ipairs(v1_531) do
			local v3_579 = Instance.new("TextButton")
			v3_579.Name = "Option"
			v3_579.Size = UDim2.new(1, -8, 0, v1_534)
			v3_579.BackgroundColor3 = v0_8.Element
			v3_579.BorderSizePixel = 0
			v3_579.Text = tostring(v3_578)
			v3_579.TextColor3 = v0_8.SubText
			v3_579.Font = Enum.Font.Gotham
			v3_579.TextSize = 13
			v3_579.TextTruncate = Enum.TextTruncate.AtEnd
			v3_579.AutoButtonColor = true
			v3_579.LayoutOrder = v3_577
			v3_579.Parent = v1_552
			v0_63(v3_579, 5)
			v3_579.MouseButton1Click:Connect(function()
				if v1_532 then
					v1_537[v3_578] = not v1_537[v3_578] or nil
					v1_561()
					v1_573()
				else
					v1_536 = v3_578
					v1_561()
					v1_568(false)
					v1_573()
				end
			end)
			v1_538[v3_578] = v3_579
		end
		local v2_580 = #v1_531
		local v2_581 = v2_580 > 0 and (v2_580 * v1_534 + (v2_580 - 1) * v1_535 + 8) or 0
		v1_540 = math.min(v2_581, v1_533)
		v1_552.Size = UDim2.new(1, 0, 0, v1_539 and v1_540 or 0)
		v1_561()
	end
	function v1_572:Set(v2_582, v2_583)
		if v1_532 then
			v1_537 = {}
			for v4_584, v4_585 in ipairs(typeof(v2_582) == "table" and v2_582 or { v2_582 }) do
				v1_537[v4_585] = true
			end
		else
			v1_536 = v2_582
		end
		v1_561()
		if not v2_583 then v1_573() end
	end
	function v1_572:Get()
		return v1_532 and v1_557() or v1_536
	end
	function v1_572:Refresh(v2_586, v2_587)
		v1_531 = v2_586 or {}
		if v2_587 then
			local v3_588 = {}
			for v4_589, v4_590 in ipairs(v1_531) do v3_588[v4_590] = true end
			if v1_532 then
				for v5_591 in pairs(v1_537) do
					if not v3_588[v5_591] then v1_537[v5_591] = nil end
				end
			elseif not v3_588[v1_536] then
				v1_536 = nil
			end
		else
			v1_537, v1_536 = {}, nil
		end
		v1_574()
	end
	function v1_572:Open() v1_568(true) end
	function v1_572:Close() v1_568(false) end
	v1_544.MouseButton1Click:Connect(function()
		v1_568(not v1_539)
	end)
	v1_574()
	if v1_530.Default ~= nil then
		v1_572:Set(v1_530.Default, true)
	end
	return v1_572
end
return v0_1
