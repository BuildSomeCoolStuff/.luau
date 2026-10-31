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
function v0_1.CreateWindow(v1_170, v1_171)
	return v0_1.new(v1_170 == v0_1 and v1_171 or v1_170)
end
function v0_1:Destroy()
	for v2_172, v2_173 in ipairs(self._connections) do
		v2_173:Disconnect()
	end
	self._connections = {}
	self._destroyed = true
	if self._hint then pcall(self._hint.HideTip, true) end
	if self._clock then pcall(task.cancel, self._clock) end
	for v2_174, v2_175 in ipairs(table.clone(self._notifs or {})) do pcall(v2_175) end
	for v2_176, v2_177 in pairs(self._cleanups) do pcall(v2_177) end
	self._cleanups = {}
	self._binds = {}
	self._listening = nil
	self.ScreenGui:Destroy()
end
local v0_178, v0_179 = 0.35, 0.2
function v0_1:_cancelAnim()
	if self._anim then
		for v3_180, v3_181 in ipairs(self._anim) do v3_181:Cancel() end
		self._anim = nil
	end
end
function v0_1:Show()
	if self._destroyed then return end
	self._visible = true
	self:_cancelAnim()
	self.Main.Visible = true
	self._anim = {
		v0_12(self.Main, { GroupTransparency = 0 }, v0_178, Enum.EasingStyle.Quint),
		v0_12(self._scale, { Scale = 1 }, v0_178, Enum.EasingStyle.Back),
	}
	self:_updateWatermark()
end
function v0_1:Hide()
	if self._destroyed or not self._visible then return end
	self._visible = false
	self:_cancelAnim()
	local v1_182 = v0_4:GetFocusedTextBox()
	if v1_182 and v1_182:IsDescendantOf(self.Main) then v1_182:ReleaseFocus() end
	local v1_183 = v0_12(self.Main, { GroupTransparency = 1 }, v0_179, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local v1_184 = v0_12(self._scale, { Scale = 0.92 }, v0_179, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	self._anim = { v1_183, v1_184 }
	v1_183.Completed:Connect(function(v2_185)
		if v2_185 == Enum.PlaybackState.Completed and not self._visible and not self._destroyed then
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
	local v1_186 = self._hint
	if not v1_186 or self._destroyed then return end
	local v1_187 = self.ActiveTab and self.ActiveTab.Page
	local v1_188 = false
	if v1_187 and v1_187.Visible then
		local v2_189 = v1_187.AbsoluteCanvasSize.Y - (v1_187.CanvasPosition.Y + v1_187.AbsoluteWindowSize.Y)
		v1_188 = v2_189 > 4
	end
	if v1_188 == v1_186.Shown then return end
	v1_186.Shown = v1_188
	if v1_186.Fade then v1_186.Fade:Cancel() end
	if v1_188 then
		v1_186.Frame.Visible = true
		v1_186.Icon.Position = UDim2.new(0.5, 0, 0.5, -3)
		v1_186.Bounce:Play()
		v1_186.Fade = v0_12(v1_186.Frame, { GroupTransparency = 0.15 }, 0.2)
	else
		v1_186.HideTip()
		local v2_190 = v0_12(v1_186.Frame, { GroupTransparency = 1 }, 0.2)
		v1_186.Fade = v2_190
		v2_190.Completed:Connect(function(v3_191)
			if v3_191 == Enum.PlaybackState.Completed and not v1_186.Shown then
				v1_186.Bounce:Cancel()
				v1_186.Frame.Visible = false
			end
		end)
	end
end
function v0_1:_keyTaken(v1_192, v1_193)
	if not v1_192 then return false end
	if v1_192 == self._toggleKey then return true end
	for v2_194, v2_195 in ipairs(self._binds) do
		if v2_195 ~= v1_193 and v2_195._key == v1_192 then return true end
	end
	return false
end
local v0_196, v0_197 = 280, 5
function v0_1:_getNotifyContainer()
	if self._notifyContainer and self._notifyContainer.Parent then
		return self._notifyContainer
	end
	local v1_198 = self.ScreenGui.AbsoluteSize
	local v1_199 = v1_198.X > 0 and math.min(v0_196, v1_198.X - 20) or v0_196
	local v1_200 = Instance.new("Frame")
	v1_200.Name = "Notifications"
	v1_200.AnchorPoint = Vector2.new(0.5, 0)
	v1_200.Position = UDim2.new(0.5, 0, 0, self._wm and 48 or 10)
	v1_200.Size = UDim2.new(0, v1_199, 0, 0)
	v1_200.AutomaticSize = Enum.AutomaticSize.Y
	v1_200.BackgroundTransparency = 1
	v1_200.BorderSizePixel = 0
	v1_200.Parent = self.ScreenGui
	local v1_201 = Instance.new("UIListLayout")
	v1_201.Padding = UDim.new(0, 6)
	v1_201.SortOrder = Enum.SortOrder.LayoutOrder
	v1_201.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_201.Parent = v1_200
	self._notifyContainer = v1_200
	return v1_200
end
function v0_1:Notify(v1_202)
	if self._destroyed then return end
	if type(v1_202) == "string" then v1_202 = { Content = v1_202 } end
	v1_202 = v1_202 or {}
	local v1_203 = tonumber(v1_202.Duration) or 4
	local v1_204 = self:_getNotifyContainer()
	self._notifyCount = (self._notifyCount or 0) + 1
	self._notifs = self._notifs or {}
	local v1_205 = false
	local v1_206 = Instance.new("Frame")
	v1_206.Name = "Notification"
	v1_206.Size = UDim2.new(1, 0, 0, 0)
	v1_206.BackgroundTransparency = 1
	v1_206.BorderSizePixel = 0
	v1_206.LayoutOrder = self._notifyCount
	v1_206.Parent = v1_204
	local v1_207 = Instance.new("CanvasGroup")
	v1_207.Name = "Card"
	v1_207.Size = UDim2.new(1, 0, 0, 0)
	v1_207.AutomaticSize = Enum.AutomaticSize.Y
	v1_207.BackgroundColor3 = v0_8.Sidebar
	v1_207.BorderSizePixel = 0
	v1_207.GroupTransparency = 1
	v1_207.Parent = v1_206
	v0_63(v1_207, 8)
	local v1_208 = Instance.new("UIStroke")
	v1_208.Color = v0_8.Element
	v1_208.Thickness = 1
	v1_208.Transparency = 1
	v1_208.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_208.Parent = v1_207
	local v1_209 = Instance.new("Frame")
	v1_209.Name = "Body"
	v1_209.Size = UDim2.new(1, 0, 0, 0)
	v1_209.AutomaticSize = Enum.AutomaticSize.Y
	v1_209.BackgroundTransparency = 1
	v1_209.BorderSizePixel = 0
	v1_209.Parent = v1_207
	local v1_210 = Instance.new("UIPadding")
	v1_210.PaddingTop = UDim.new(0, 8)
	v1_210.PaddingBottom = UDim.new(0, 8)
	v1_210.PaddingLeft = UDim.new(0, 12)
	v1_210.PaddingRight = UDim.new(0, 12)
	v1_210.Parent = v1_209
	local v1_211 = Instance.new("UISizeConstraint")
	v1_211.MinSize = Vector2.new(0, 30)
	v1_211.Parent = v1_209
	local v1_212 = Instance.new("Frame")
	v1_212.Name = "Texts"
	v1_212.Position = UDim2.new(0, 0, 0, 0)
	v1_212.Size = UDim2.new(1, 0, 0, 0)
	v1_212.AutomaticSize = Enum.AutomaticSize.Y
	v1_212.BackgroundTransparency = 1
	v1_212.BorderSizePixel = 0
	v1_212.Parent = v1_209
	local v1_213 = Instance.new("UIListLayout")
	v1_213.Padding = UDim.new(0, 2)
	v1_213.SortOrder = Enum.SortOrder.LayoutOrder
	v1_213.Parent = v1_212
	local function v1_214(v2_215, v2_216, v2_217, v2_218, v2_219)
		local v2_220 = Instance.new("TextLabel")
		v2_220.Size = UDim2.new(1, 0, 0, 0)
		v2_220.AutomaticSize = Enum.AutomaticSize.Y
		v2_220.BackgroundTransparency = 1
		v2_220.BorderSizePixel = 0
		v2_220.Text = v2_215
		v2_220.TextColor3 = v2_218
		v2_220.Font = v2_216
		v2_220.TextSize = v2_217
		v2_220.TextWrapped = true
		v2_220.TextXAlignment = Enum.TextXAlignment.Left
		v2_220.TextYAlignment = Enum.TextYAlignment.Top
		v2_220.LayoutOrder = v2_219
		v2_220.Parent = v1_212
		return v2_220
	end
	if v1_202.Title and v1_202.Title ~= "" then
		v1_214(tostring(v1_202.Title), Enum.Font.GothamBold, 13, v0_8.Text, 1).Name = "Title"
	end
	if v1_202.Content and v1_202.Content ~= "" then
		v1_214(tostring(v1_202.Content), Enum.Font.Gotham, 12, v0_8.SubText, 2).Name = "Content"
	end
	local v1_221 = Instance.new("TextLabel")
	v1_221.Name = "Countdown"
	v1_221.AnchorPoint = Vector2.new(1, 0.5)
	v1_221.Position = UDim2.new(1, 0, 0.5, 0)
	v1_221.Size = UDim2.new(0, 18, 0, 18)
	v1_221.BackgroundTransparency = 1
	v1_221.BorderSizePixel = 0
	v1_221.Text = tostring(math.ceil(v1_203))
	v1_221.TextColor3 = v0_8.SubText
	v1_221.Font = Enum.Font.GothamBold
	v1_221.TextSize = 13
	v1_221.TextXAlignment = Enum.TextXAlignment.Right
	v1_221.Visible = v1_203 > 0
	v1_221.Parent = v1_209
	if v1_203 > 0 then
		v1_212.Size = UDim2.new(1, -24, 0, 0)
	end
	local v1_222 = Instance.new("TextButton")
	v1_222.Name = "Click"
	v1_222.Size = UDim2.new(1, 0, 1, 0)
	v1_222.BackgroundTransparency = 1
	v1_222.BorderSizePixel = 0
	v1_222.Text = ""
	v1_222.AutoButtonColor = false
	v1_222.Parent = v1_207
	local v1_223, v1_224 = nil, nil
	local v1_225 = {}
	local function v1_226()
		if v1_205 then return end
		v1_205 = true
		local v2_227 = table.find(self._notifs, v1_226)
		if v2_227 then table.remove(self._notifs, v2_227) end
		if v1_223 and v1_223 ~= coroutine.running() then
			pcall(task.cancel, v1_223)
		end
		v1_223 = nil
		if v1_224 then
			v1_224:Disconnect()
			v1_224 = nil
		end
		for v3_228, v3_229 in ipairs(v1_225) do v3_229:Cancel() end
		v1_225 = {}
		if self._destroyed then return end
		v0_12(v1_208, { Transparency = 1 }, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v2_230 = v0_12(v1_207, {
			Position = UDim2.new(0, 0, 0, -20),
			GroupTransparency = 1,
		}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_230.Completed:Connect(function()
			local v3_231 = v0_12(v1_206, { Size = UDim2.new(1, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quint)
			v3_231.Completed:Connect(function()
				v1_206:Destroy()
			end)
		end)
	end
	v1_222.MouseButton1Click:Connect(v1_226)
	table.insert(self._notifs, v1_226)
	while #self._notifs > v0_197 do
		self._notifs[1]()
	end
	local v1_232 = false
	v1_224 = v1_207:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if v1_205 then return end
		local v2_233 = v1_207.AbsoluteSize.Y
		if v2_233 <= 0 then return end
		if not v1_232 then
			v1_232 = true
			table.insert(v1_225, v0_12(v1_206, { Size = UDim2.new(1, 0, 0, v2_233) }, 0.3, Enum.EasingStyle.Quint))
		else
			v1_206.Size = UDim2.new(1, 0, 0, v2_233)
		end
	end)
	v1_207.Position = UDim2.new(0, 0, 0, -(v1_204.AbsolutePosition.Y + v1_204.AbsoluteSize.Y + 90))
	v1_225 = {
		v0_12(v1_207, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back),
		v0_12(v1_207, { GroupTransparency = 0 }, 0.25),
		v0_12(v1_208, { Transparency = 0 }, 0.25),
	}
	if v1_203 > 0 then
		v1_223 = task.spawn(function()
			local v3_234 = os.clock()
			local v3_235 = math.ceil(v1_203)
			while not v1_205 and not self._destroyed do
				local v4_236 = v1_203 - (os.clock() - v3_234)
				local v4_237 = math.max(math.ceil(v4_236), 0)
				if v4_237 ~= v3_235 then
					v3_235 = v4_237
					v1_221.Text = tostring(v4_237)
					v1_221.TextTransparency = 0.6
					v0_12(v1_221, { TextTransparency = 0 }, 0.2)
				end
				if v4_236 <= 0 then
					v1_223 = nil
					v1_226()
					return
				end
				task.wait(v4_236 - (v4_237 - 1))
			end
		end)
	end
	return { Dismiss = v1_226 }
end
function v0_1:Dialog(v1_238)
	if self._destroyed then return end
	v1_238 = v1_238 or {}
	local v1_239 = v1_238.Buttons
	if type(v1_239) ~= "table" or #v1_239 == 0 then
		v1_239 = { { Title = "OK", Primary = true } }
	end
	local v1_240 = false
	local v1_241 = {}
	local v1_242 = { Dismissable = v1_238.Dismissable ~= false }
	local v1_243 = Instance.new("Frame")
	v1_243.Name = "DialogOverlay"
	v1_243.Size = UDim2.new(1, 0, 1, 0)
	v1_243.BackgroundTransparency = 1
	v1_243.BorderSizePixel = 0
	v1_243.ZIndex = 100 + #self._dialogs
	v1_243.Parent = self.ScreenGui
	local v1_244 = Instance.new("TextButton")
	v1_244.Name = "Backdrop"
	v1_244.Size = UDim2.new(1, 0, 1, 0)
	v1_244.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	v1_244.BackgroundTransparency = 1
	v1_244.BorderSizePixel = 0
	v1_244.Text = ""
	v1_244.AutoButtonColor = false
	v1_244.Parent = v1_243
	local v1_245 = Instance.new("CanvasGroup")
	v1_245.Name = "Dialog"
	v1_245.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_245.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_245.Size = UDim2.new(0.9, 0, 0, 0)
	v1_245.AutomaticSize = Enum.AutomaticSize.Y
	v1_245.BackgroundColor3 = v0_8.Sidebar
	v1_245.BorderSizePixel = 0
	v1_245.GroupTransparency = 1
	v1_245.Active = true
	v1_245.ZIndex = 2
	v1_245.Parent = v1_243
	v0_63(v1_245, 8)
	local v1_246 = Instance.new("UISizeConstraint")
	v1_246.MinSize = Vector2.new(200, 0)
	v1_246.MaxSize = Vector2.new(320, math.huge)
	v1_246.Parent = v1_245
	local v1_247 = Instance.new("UIScale")
	v1_247.Scale = 0.92
	v1_247.Parent = v1_245
	local v1_248 = Instance.new("UIStroke")
	v1_248.Color = v0_8.Element
	v1_248.Thickness = 1
	v1_248.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_248.Parent = v1_245
	local v1_249 = Instance.new("Frame")
	v1_249.Name = "Body"
	v1_249.Size = UDim2.new(1, 0, 0, 0)
	v1_249.AutomaticSize = Enum.AutomaticSize.Y
	v1_249.BackgroundTransparency = 1
	v1_249.BorderSizePixel = 0
	v1_249.Parent = v1_245
	local v1_250 = Instance.new("UIPadding")
	v1_250.PaddingTop = UDim.new(0, 14)
	v1_250.PaddingBottom = UDim.new(0, 14)
	v1_250.PaddingLeft = UDim.new(0, 14)
	v1_250.PaddingRight = UDim.new(0, 14)
	v1_250.Parent = v1_249
	local v1_251 = Instance.new("UIListLayout")
	v1_251.Padding = UDim.new(0, 8)
	v1_251.SortOrder = Enum.SortOrder.LayoutOrder
	v1_251.Parent = v1_249
	local function v1_252(v2_253, v2_254, v2_255, v2_256, v2_257, v2_258)
		local v2_259 = Instance.new("TextLabel")
		v2_259.Name = v2_253
		v2_259.Size = UDim2.new(1, 0, 0, 0)
		v2_259.AutomaticSize = Enum.AutomaticSize.Y
		v2_259.BackgroundTransparency = 1
		v2_259.BorderSizePixel = 0
		v2_259.Text = v2_254
		v2_259.TextColor3 = v2_257
		v2_259.Font = v2_255
		v2_259.TextSize = v2_256
		v2_259.TextWrapped = true
		v2_259.TextXAlignment = Enum.TextXAlignment.Left
		v2_259.TextYAlignment = Enum.TextYAlignment.Top
		v2_259.LayoutOrder = v2_258
		v2_259.Parent = v1_249
		return v2_259
	end
	if v1_238.Title and v1_238.Title ~= "" then
		v1_252("Title", tostring(v1_238.Title), Enum.Font.GothamBold, 15, v0_8.Text, 1)
	end
	if v1_238.Content and v1_238.Content ~= "" then
		v1_252("Content", tostring(v1_238.Content), Enum.Font.Gotham, 13, v0_8.SubText, 2)
	end
	local v1_260 = Instance.new("Frame")
	v1_260.Name = "Buttons"
	v1_260.Size = UDim2.new(1, 0, 0, 30)
	v1_260.BackgroundTransparency = 1
	v1_260.BorderSizePixel = 0
	v1_260.LayoutOrder = 3
	v1_260.Parent = v1_249
	local v1_261 = Instance.new("UIListLayout")
	v1_261.FillDirection = Enum.FillDirection.Horizontal
	v1_261.HorizontalAlignment = Enum.HorizontalAlignment.Right
	v1_261.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_261.Padding = UDim.new(0, 8)
	v1_261.SortOrder = Enum.SortOrder.LayoutOrder
	v1_261.Parent = v1_260
	local function v1_262()
		if v1_240 then return end
		v1_240 = true
		local v2_263 = table.find(self._dialogs, v1_242)
		if v2_263 then table.remove(self._dialogs, v2_263) end
		for v3_264, v3_265 in ipairs(v1_241) do v3_265:Cancel() end
		v1_241 = {}
		if self._destroyed or not v1_243.Parent then return end
		v0_12(v1_244, { BackgroundTransparency = 1 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v0_12(v1_247, { Scale = 0.94 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v2_266 = v0_12(v1_245, { GroupTransparency = 1 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_266.Completed:Connect(function()
			v1_243:Destroy()
		end)
	end
	v1_242.Close = v1_262
	for v2_267, v2_268 in ipairs(v1_239) do
		local v2_269 = v2_268.Primary == true
		local v2_270 = v2_269 and v0_8.Accent or v0_8.Element
		local v2_271 = v2_269 and v0_8.Accent:Lerp(v0_8.Text, 0.15) or v0_8.Hover
		local v2_272 = Instance.new("TextButton")
		v2_272.Name = "Button"
		v2_272.Size = UDim2.new(0, 0, 0, 30)
		v2_272.AutomaticSize = Enum.AutomaticSize.X
		v2_272.BackgroundColor3 = v2_270
		v2_272.BorderSizePixel = 0
		v2_272.Text = tostring(v2_268.Title or "OK")
		v2_272.TextColor3 = v0_8.Text
		v2_272.Font = Enum.Font.Gotham
		v2_272.TextSize = 13
		v2_272.AutoButtonColor = false
		v2_272.LayoutOrder = v2_267
		v2_272.Parent = v1_260
		v0_63(v2_272, 6)
		local v2_273 = Instance.new("UIPadding")
		v2_273.PaddingLeft = UDim.new(0, 14)
		v2_273.PaddingRight = UDim.new(0, 14)
		v2_273.Parent = v2_272
		v0_21(v2_272, v2_270, v2_271)
		v2_272.MouseButton1Click:Connect(function()
			if v1_240 then return end
			v1_262()
			if v2_268.Callback then v2_268.Callback() end
		end)
	end
	v1_244.MouseButton1Click:Connect(function()
		if v1_242.Dismissable then v1_262() end
	end)
	table.insert(self._dialogs, v1_242)
	v1_241 = {
		v0_12(v1_244, { BackgroundTransparency = 0.45 }, 0.2),
		v0_12(v1_245, { GroupTransparency = 0 }, 0.22),
		v0_12(v1_247, { Scale = 1 }, 0.3, Enum.EasingStyle.Back),
	}
	return { Close = v1_262 }
end
function v0_1:_buildWatermark(v1_274)
	local v1_275 = Instance.new("Frame")
	v1_275.Name = "Watermark"
	v1_275.AnchorPoint = Vector2.new(0.5, 0)
	v1_275.Position = UDim2.new(0.5, 0, 0, -40)
	v1_275.Size = UDim2.new(0, 0, 0, 30)
	v1_275.AutomaticSize = Enum.AutomaticSize.X
	v1_275.BackgroundColor3 = v0_8.Sidebar
	v1_275.BorderSizePixel = 0
	v1_275.Parent = self.ScreenGui
	v0_63(v1_275, 8)
	local v1_276 = Instance.new("UIStroke")
	v1_276.Color = v0_8.Element
	v1_276.Thickness = 1
	v1_276.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_276.Parent = v1_275
	local v1_277 = Instance.new("UIPadding")
	v1_277.PaddingLeft = UDim.new(0, 10)
	v1_277.PaddingRight = UDim.new(0, 4)
	v1_277.Parent = v1_275
	local v1_278 = Instance.new("UIListLayout")
	v1_278.FillDirection = Enum.FillDirection.Horizontal
	v1_278.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_278.Padding = UDim.new(0, 8)
	v1_278.SortOrder = Enum.SortOrder.LayoutOrder
	v1_278.Parent = v1_275
	local v1_279 = Instance.new("TextLabel")
	v1_279.Name = "Title"
	v1_279.Size = UDim2.new(0, 0, 1, 0)
	v1_279.AutomaticSize = Enum.AutomaticSize.X
	v1_279.BackgroundTransparency = 1
	v1_279.BorderSizePixel = 0
	v1_279.Text = v1_274
	v1_279.TextColor3 = v0_8.SubText
	v1_279.Font = Enum.Font.GothamBold
	v1_279.TextSize = 13
	v1_279.LayoutOrder = 1
	v1_279.Parent = v1_275
	local v1_280 = Instance.new("TextButton")
	v1_280.Name = "ToggleButton"
	v1_280.Size = UDim2.new(0, 22, 0, 22)
	v1_280.BackgroundColor3 = v0_8.Element
	v1_280.BorderSizePixel = 0
	v1_280.Text = ""
	v1_280.AutoButtonColor = false
	v1_280.LayoutOrder = 2
	v1_280.Parent = v1_275
	v0_63(v1_280, 6)
	local v1_281 = Instance.new("ImageLabel")
	v1_281.Name = "Icon"
	v1_281.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_281.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_281.Size = UDim2.new(0, 14, 0, 14)
	v1_281.BackgroundTransparency = 1
	v1_281.BorderSizePixel = 0
	v1_281.ImageColor3 = v0_8.IconOn
	v1_281.ScaleType = Enum.ScaleType.Fit
	v1_281.Parent = v1_280
	local v1_282 = Instance.new("TextLabel")
	v1_282.Name = "IconFallback"
	v1_282.Size = UDim2.new(1, 0, 1, 0)
	v1_282.BackgroundTransparency = 1
	v1_282.TextColor3 = v0_8.IconOn
	v1_282.Font = Enum.Font.GothamBold
	v1_282.TextSize = 12
	v1_282.Visible = false
	v1_282.Parent = v1_281
	local v1_283 = Instance.new("UIScale")
	v1_283.Parent = v1_280
	v1_280.MouseEnter:Connect(function() v0_12(v1_283, { Scale = 1.1 }, 0.12) end)
	v1_280.MouseLeave:Connect(function() v0_12(v1_283, { Scale = 1 }, 0.12) end)
	v1_280.InputBegan:Connect(function(v2_284)
		if v0_19(v2_284) then v0_12(v1_283, { Scale = 0.9 }, 0.08) end
	end)
	v1_280.InputEnded:Connect(function(v2_285)
		if v0_19(v2_285) then v0_12(v1_283, { Scale = 1.1 }, 0.15, Enum.EasingStyle.Back) end
	end)
	v1_280.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	local v1_286, v1_287, v1_288 = false, nil, nil
	v1_279.InputBegan:Connect(function(v2_289)
		if v0_19(v2_289) then
			v1_286 = true
			v1_287 = v2_289.Position
			v1_288 = v1_275.AbsolutePosition + Vector2.new(v1_275.AbsoluteSize.X / 2, 0)
			v2_289.Changed:Connect(function()
				if v2_289.UserInputState == Enum.UserInputState.End then v1_286 = false end
			end)
		end
	end)
	table.insert(self._connections, v0_4.InputChanged:Connect(function(v2_290)
		if not v1_286 then return end
		if v2_290.UserInputType ~= Enum.UserInputType.MouseMovement and v2_290.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local v2_291 = v2_290.Position - v1_287
		local v2_292 = self.ScreenGui.AbsoluteSize
		local v2_293 = v1_275.AbsoluteSize.X / 2
		local v2_294 = math.clamp(v1_288.X + v2_291.X, v2_293, math.max(v2_292.X - v2_293, v2_293))
		local v2_295 = math.clamp(v1_288.Y + v2_291.Y, 0, math.max(v2_292.Y - v1_275.AbsoluteSize.Y, 0))
		v1_275.Position = UDim2.fromOffset(v2_294, v2_295)
	end))
	self._wm = { Frame = v1_275, Button = v1_280, Icon = v1_281, Fallback = v1_282 }
	v0_12(v1_275, { Position = UDim2.new(0.5, 0, 0, 10) }, 0.5, Enum.EasingStyle.Back)
end
function v0_1:_updateWatermark()
	local v1_296 = self._wm
	if not v1_296 then return end
	local v1_297 = self._visible == true
	v0_12(v1_296.Button, { BackgroundColor3 = v1_297 and v0_8.Accent or v0_8.Element }, 0.2)
	local v1_298 = v0_44(v1_296.Icon, v1_297 and "eye" or "eye-off", self.Icons)
	if not v1_298 then v1_296.Icon.Image = "" end
	v1_296.Fallback.Visible = not v1_298
	v1_296.Fallback.Text = v1_297 and "●" or "○"
	v1_296.Icon.ImageTransparency = 1
	v0_12(v1_296.Icon, { ImageTransparency = 0 }, 0.2)
end
local function v0_299(v1_300, v1_301)
	local v1_302 = v1_300.Glow
	if not v1_302 then return end
	for v2_303, v2_304 in ipairs(v1_302.Layers) do
		v0_12(v2_304.Obj, { [v2_304.Prop] = v1_301 and v2_304.On or 1 }, 0.25, Enum.EasingStyle.Quad)
	end
end
local function v0_305(v1_306, v1_307)
	v0_12(v1_306.Icon, { ImageColor3 = v1_307 }, 0.2)
	if v1_306.Fallback then
		v0_12(v1_306.Fallback, { TextColor3 = v1_307 }, 0.2)
	end
end
function v0_1:AddTab(v1_308)
	v1_308 = v1_308 or {}
	local v1_309 = Instance.new("TextButton")
	v1_309.Name = "TabButton"
	v1_309.Size = UDim2.new(0, 36, 0, 36)
	v1_309.BackgroundColor3 = v0_8.Card
	v1_309.BorderSizePixel = 0
	v1_309.Text = ""
	v1_309.AutoButtonColor = false
	v1_309.LayoutOrder = #self.Tabs + 1
	v1_309.Parent = self.Sidebar
	v0_63(v1_309, 6)
	local v1_310 = Instance.new("ImageLabel")
	v1_310.Name = "Icon"
	v1_310.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_310.Size = UDim2.new(0, 20, 0, 20)
	v1_310.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_310.BackgroundTransparency = 1
	v1_310.BorderSizePixel = 0
	v1_310.ImageColor3 = v0_8.IconOff
	v1_310.ScaleType = Enum.ScaleType.Fit
	v1_310.Parent = v1_309
	local v1_311
	if not v0_44(v1_310, v1_308.Icon, self.Icons) then
		v1_311 = Instance.new("TextLabel")
		v1_311.Name = "IconFallback"
		v1_311.Size = UDim2.new(1, 0, 1, 0)
		v1_311.BackgroundTransparency = 1
		v1_311.Text = string.upper(string.sub(tostring(v1_308.Name or v1_308.Icon or "?"), 1, 1))
		v1_311.TextColor3 = v0_8.IconOff
		v1_311.Font = Enum.Font.GothamBold
		v1_311.TextSize = 16
		v1_311.Parent = v1_310
	end
	local v1_312
	if self.IconGlow then
		v1_309.BackgroundTransparency = 1
		v1_310.ZIndex = 2
		v1_312 = { Layers = {} }
		if v1_310.Image ~= "" then
			for v4_313, v4_314 in ipairs({ { 26, 0.55 }, { 33, 0.82 } }) do
				local v4_315 = Instance.new("ImageLabel")
				v4_315.Name = "Glow"
				v4_315.AnchorPoint = Vector2.new(0.5, 0.5)
				v4_315.Position = UDim2.new(0.5, 0, 0.5, 0)
				v4_315.Size = UDim2.new(0, v4_314[1], 0, v4_314[1])
				v4_315.BackgroundTransparency = 1
				v4_315.BorderSizePixel = 0
				v4_315.Image = v1_310.Image
				v4_315.ImageRectSize = v1_310.ImageRectSize
				v4_315.ImageRectOffset = v1_310.ImageRectOffset
				v4_315.ImageColor3 = v0_8.Accent
				v4_315.ImageTransparency = 1
				v4_315.ScaleType = Enum.ScaleType.Fit
				v4_315.ZIndex = 1
				v4_315.Parent = v1_309
				table.insert(v1_312.Layers, { Obj = v4_315, Prop = "ImageTransparency", On = v4_314[2] })
			end
		elseif v1_311 then
			local v3_316 = Instance.new("UIStroke")
			v3_316.Color = v0_8.Accent
			v3_316.Thickness = 1
			v3_316.Transparency = 1
			v3_316.Parent = v1_311
			table.insert(v1_312.Layers, { Obj = v3_316, Prop = "Transparency", On = 0.45 })
		end
	end
	local v1_317 = Instance.new("ScrollingFrame")
	v1_317.Name = "Page"
	v1_317.Size = UDim2.new(1, 0, 1, 0)
	v1_317.BackgroundTransparency = 1
	v1_317.BorderSizePixel = 0
	v1_317.ScrollBarThickness = 3
	v1_317.ScrollBarImageColor3 = v0_8.IconOff
	v1_317.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_317.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_317.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_317.Visible = false
	v1_317.Parent = self.Content
	local v1_318 = Instance.new("Frame")
	v1_318.Name = "Inner"
	v1_318.Size = UDim2.new(1, 0, 0, 0)
	v1_318.AutomaticSize = Enum.AutomaticSize.Y
	v1_318.BackgroundTransparency = 1
	v1_318.BorderSizePixel = 0
	v1_318.Parent = v1_317
	local v1_319 = Instance.new("UIPadding")
	v1_319.PaddingTop = UDim.new(0, 12)
	v1_319.PaddingBottom = UDim.new(0, 12)
	v1_319.Parent = v1_318
	local v1_320 = Instance.new("Frame")
	v1_320.Name = "Split"
	v1_320.Position = UDim2.new(0, 12, 0, 0)
	v1_320.Size = UDim2.new(1, -26, 0, 0)
	v1_320.AutomaticSize = Enum.AutomaticSize.Y
	v1_320.BackgroundTransparency = 1
	v1_320.BorderSizePixel = 0
	v1_320.Parent = v1_318
	local v1_321 = Instance.new("UIListLayout")
	v1_321.FillDirection = Enum.FillDirection.Horizontal
	v1_321.Padding = UDim.new(0, 8)
	v1_321.SortOrder = Enum.SortOrder.LayoutOrder
	v1_321.Parent = v1_320
	local function v1_322(v2_323)
		local v2_324 = Instance.new("Frame")
		v2_324.Name = v2_323 == 1 and "Left" or "Right"
		v2_324.Size = UDim2.new(0.5, -4, 0, 0)
		v2_324.AutomaticSize = Enum.AutomaticSize.Y
		v2_324.BackgroundTransparency = 1
		v2_324.BorderSizePixel = 0
		v2_324.LayoutOrder = v2_323
		v2_324.Parent = v1_320
		local v2_325 = Instance.new("UIListLayout")
		v2_325.Padding = UDim.new(0, 8)
		v2_325.SortOrder = Enum.SortOrder.LayoutOrder
		v2_325.Parent = v2_324
		return v2_324
	end
	local v1_326 = setmetatable({
		Page = v1_317,
		Button = v1_309,
		Icon = v1_310,
		Fallback = v1_311,
		Glow = v1_312,
		Inner = v1_318,
		_icons = self.Icons,
		_lib = self,
		Left = v1_322(1),
		Right = v1_322(2),
		_sectionCount = 0,
	}, v0_2)
	table.insert(self.Tabs, v1_326)
	for v2_327, v2_328 in ipairs({ "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" }) do
		table.insert(self._connections, v1_317:GetPropertyChangedSignal(v2_328):Connect(function()
			if self.ActiveTab == v1_326 then self:_updateScrollHint() end
		end))
	end
	if self.IconGlow then
		v1_309.MouseEnter:Connect(function()
			if self.ActiveTab ~= v1_326 then v0_305(v1_326, v0_8.SubText) end
		end)
		v1_309.MouseLeave:Connect(function()
			if self.ActiveTab ~= v1_326 then v0_305(v1_326, v0_8.IconOff) end
		end)
	end
	v0_21(v1_309, v0_8.Card, v0_8.Element, function()
		return self.ActiveTab == v1_326
	end)
	v1_309.MouseButton1Click:Connect(function()
		self:SelectTab(v1_326)
	end)
	if not self.ActiveTab then self:SelectTab(v1_326) end
	return v1_326
end
function v0_1:SelectTab(v1_329)
	if self.ActiveTab == v1_329 then return end
	local v1_330 = self.ActiveTab
	self.ActiveTab = v1_329
	if v1_330 then
		v1_330.Page.Visible = false
		if self.IconGlow then
			v0_299(v1_330, false)
		else
			v0_12(v1_330.Button, { BackgroundColor3 = v0_8.Card }, 0.2)
		end
		v0_305(v1_330, v0_8.IconOff)
	end
	v1_329.Inner.Position = UDim2.new(0, 0, 0, 14)
	v1_329.Page.Visible = true
	v0_12(v1_329.Inner, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)
	if self.IconGlow then
		v0_299(v1_329, true)
	else
		v0_12(v1_329.Button, { BackgroundColor3 = v0_8.Accent }, 0.2)
	end
	v0_305(v1_329, v0_8.IconOn)
	self:_updateScrollHint()
end
function v0_2:AddSection(v1_331, v1_332, v1_333)
	local v1_334 = (v1_332 == "right") and self.Right or self.Left
	local v1_335 = self._lib
	self._sectionCount += 1
	local v1_336 = Instance.new("Frame")
	v1_336.Name = "Section"
	v1_336.Size = UDim2.new(1, 0, 0, 0)
	v1_336.AutomaticSize = Enum.AutomaticSize.Y
	v1_336.BackgroundColor3 = v0_8.Card
	v1_336.BorderSizePixel = 0
	v1_336.LayoutOrder = self._sectionCount
	v1_336.Parent = v1_334
	v0_63(v1_336, 6)
	local v1_337 = Instance.new("UIPadding")
	v1_337.PaddingTop = UDim.new(0, 8)
	v1_337.PaddingBottom = UDim.new(0, 8)
	v1_337.PaddingLeft = UDim.new(0, 8)
	v1_337.PaddingRight = UDim.new(0, 8)
	v1_337.Parent = v1_336
	local v1_338 = Instance.new("UIListLayout")
	v1_338.Padding = UDim.new(0, 6)
	v1_338.SortOrder = Enum.SortOrder.LayoutOrder
	v1_338.Parent = v1_336
	local v1_339 = Instance.new("Frame")
	v1_339.Name = "Body"
	v1_339.Size = UDim2.new(1, 0, 0, 0)
	v1_339.AutomaticSize = Enum.AutomaticSize.Y
	v1_339.BackgroundTransparency = 1
	v1_339.BorderSizePixel = 0
	v1_339.LayoutOrder = 1
	v1_339.Parent = v1_336
	local v1_340 = Instance.new("UIListLayout")
	v1_340.Padding = UDim.new(0, 6)
	v1_340.SortOrder = Enum.SortOrder.LayoutOrder
	v1_340.Parent = v1_339
	local v1_341 = false
	local v1_342 = {}
	local v1_343, v1_344
	local function v1_345()
		local v2_346 = v1_335._scale and v1_335._scale.Scale or 1
		return math.max(v1_340.AbsoluteContentSize.Y / (v2_346 > 0 and v2_346 or 1), 0)
	end
	local function v1_347()
		v1_339.AutomaticSize = Enum.AutomaticSize.Y
		v1_339.Size = UDim2.new(1, 0, 0, 0)
		v1_339.ClipsDescendants = false
	end
	local function v1_348(v2_349, v2_350)
		if v2_349 == v1_341 and not v2_350 then return end
		v1_341 = v2_349
		for v3_351, v3_352 in ipairs(v1_342) do v3_352:Cancel() end
		v1_342 = {}
		if v1_343 then
			if v2_350 then
				v1_343.Rotation = v2_349 and -90 or 0
			else
				v0_12(v1_343, { Rotation = v2_349 and -90 or 0 }, 0.22, Enum.EasingStyle.Quint)
			end
		end
		if v2_350 then
			v1_339.Visible = not v2_349
			v1_338.Padding = UDim.new(0, v2_349 and 0 or 6)
			v1_347()
			return
		end
		v1_339.ClipsDescendants = true
		if v2_349 then
			if v1_339.AutomaticSize ~= Enum.AutomaticSize.None then
				local v4_353 = v1_345()
				v1_339.AutomaticSize = Enum.AutomaticSize.None
				v1_339.Size = UDim2.new(1, 0, 0, v4_353)
			end
			local v3_354 = v0_12(v1_339, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Quint)
			v1_342 = { v3_354, v0_12(v1_338, { Padding = UDim.new(0, 0) }, 0.25, Enum.EasingStyle.Quint) }
			v3_354.Completed:Connect(function(v4_355)
				if v4_355 == Enum.PlaybackState.Completed and v1_341 then
					v1_339.Visible = false
					v1_339.ClipsDescendants = false
				end
			end)
		else
			v1_339.Visible = true
			local v3_356 = v1_345()
			if v3_356 <= 0 then
				v1_338.Padding = UDim.new(0, 6)
				v1_347()
				return
			end
			if v1_339.AutomaticSize ~= Enum.AutomaticSize.None then
				v1_339.AutomaticSize = Enum.AutomaticSize.None
				v1_339.Size = UDim2.new(1, 0, 0, 0)
			end
			local v3_357 = v0_12(v1_339, { Size = UDim2.new(1, 0, 0, v3_356) }, 0.28, Enum.EasingStyle.Quint)
			v1_342 = { v3_357, v0_12(v1_338, { Padding = UDim.new(0, 6) }, 0.28, Enum.EasingStyle.Quint) }
			v3_357.Completed:Connect(function(v4_358)
				if v4_358 == Enum.PlaybackState.Completed and not v1_341 then
					v1_347()
				end
			end)
		end
	end
	if v1_331 then
		local v2_359 = Instance.new("TextButton")
		v2_359.Name = "Header"
		v2_359.Size = UDim2.new(1, 0, 0, 16)
		v2_359.BackgroundTransparency = 1
		v2_359.BorderSizePixel = 0
		v2_359.Text = ""
		v2_359.AutoButtonColor = false
		v2_359.LayoutOrder = 0
		v2_359.Parent = v1_336
		local v2_360 = Instance.new("TextLabel")
		v2_360.Name = "Title"
		v2_360.Size = UDim2.new(1, -22, 1, 0)
		v2_360.BackgroundTransparency = 1
		v2_360.BorderSizePixel = 0
		v2_360.Text = v1_331
		v2_360.TextColor3 = v0_8.SubText
		v2_360.Font = Enum.Font.GothamBold
		v2_360.TextSize = 13
		v2_360.TextXAlignment = Enum.TextXAlignment.Left
		v2_360.TextTruncate = Enum.TextTruncate.AtEnd
		v2_360.Parent = v2_359
		v1_343 = Instance.new("ImageLabel")
		v1_343.Name = "Chevron"
		v1_343.AnchorPoint = Vector2.new(1, 0.5)
		v1_343.Position = UDim2.new(1, 0, 0.5, 0)
		v1_343.Size = UDim2.new(0, 14, 0, 14)
		v1_343.BackgroundTransparency = 1
		v1_343.BorderSizePixel = 0
		v1_343.ImageColor3 = v0_8.SubText
		v1_343.ScaleType = Enum.ScaleType.Fit
		v1_343.Parent = v2_359
		v1_344 = Instance.new("TextLabel")
		v1_344.Name = "ChevronFallback"
		v1_344.Size = UDim2.new(1, 0, 1, 0)
		v1_344.BackgroundTransparency = 1
		v1_344.Text = "▼"
		v1_344.TextColor3 = v0_8.SubText
		v1_344.Font = Enum.Font.Gotham
		v1_344.TextSize = 9
		v1_344.Parent = v1_343
		v1_344.Visible = not v0_44(v1_343, "chevron-down", self._icons)
		v2_359.MouseEnter:Connect(function()
			v0_12(v2_360, { TextColor3 = v0_8.Text }, 0.12)
			v0_12(v1_343, { ImageColor3 = v0_8.Text }, 0.12)
			v0_12(v1_344, { TextColor3 = v0_8.Text }, 0.12)
		end)
		v2_359.MouseLeave:Connect(function()
			v0_12(v2_360, { TextColor3 = v0_8.SubText }, 0.15)
			v0_12(v1_343, { ImageColor3 = v0_8.SubText }, 0.15)
			v0_12(v1_344, { TextColor3 = v0_8.SubText }, 0.15)
		end)
		v2_359.MouseButton1Click:Connect(function()
			v1_348(not v1_341)
		end)
	end
	local v1_361 = setmetatable({
		Holder = v1_339,
		Card = v1_336,
		_count = 0,
		_icons = self._icons,
		_lib = self._lib,
		_setCollapsed = v1_348,
		_isCollapsed = function() return v1_341 end,
	}, v0_3)
	if v1_331 and v1_333 == true then
		v1_348(true, true)
	end
	return v1_361
end
function v0_3:SetCollapsed(v1_362)
	self._setCollapsed(v1_362 == true)
end
function v0_3:ToggleCollapsed()
	self._setCollapsed(not self._isCollapsed())
end
function v0_3:IsCollapsed()
	return self._isCollapsed()
end
local function v0_363(v1_364)
	if typeof(v1_364) == "EnumItem" and v1_364.EnumType == Enum.KeyCode then return v1_364 end
	if type(v1_364) == "string" then
		local v2_365, v2_366 = pcall(function() return Enum.KeyCode[v1_364] end)
		if v2_365 then return v2_366 end
	end
	return nil
end
local function v0_367(v1_368, v1_369, v1_370, v1_371, v1_372)
	v1_370 = v1_370 or {}
	local v1_373 = v1_370.CanBeChanged ~= false
	local v1_374 = {}
	local v1_375 = { _key = nil, _onPress = v1_372, _isListening = false, _destroyed = false }
	local v1_376 = Instance.new("TextButton")
	v1_376.Name = "Keybind"
	v1_376.AnchorPoint = Vector2.new(1, 0.5)
	v1_376.Position = v1_371
	v1_376.Size = UDim2.new(0, 0, 0, 20)
	v1_376.AutomaticSize = Enum.AutomaticSize.X
	v1_376.BackgroundColor3 = v0_8.Card
	v1_376.BorderSizePixel = 0
	v1_376.Text = "None"
	v1_376.TextColor3 = v0_8.SubText
	v1_376.Font = Enum.Font.Gotham
	v1_376.TextSize = 12
	v1_376.TextTruncate = Enum.TextTruncate.AtEnd
	v1_376.AutoButtonColor = false
	v1_376.Parent = v1_369
	v0_63(v1_376, 5)
	v1_375.Instance = v1_376
	local v1_377 = Instance.new("UIPadding")
	v1_377.PaddingLeft = UDim.new(0, 7)
	v1_377.PaddingRight = UDim.new(0, 7)
	v1_377.Parent = v1_376
	local v1_378 = Instance.new("UISizeConstraint")
	v1_378.MinSize = Vector2.new(30, 20)
	v1_378.MaxSize = Vector2.new(96, 20)
	v1_378.Parent = v1_376
	local function v1_379()
		if v1_375._isListening then
			v1_376.Text = "..."
		else
			v1_376.Text = v1_375._key and v1_375._key.Name or "None"
		end
	end
	local function v1_380()
		v1_376.BackgroundColor3 = v0_8.Danger
		v0_12(v1_376, { BackgroundColor3 = v0_8.Card }, 0.45)
	end
	function v1_375:Set(v2_381, v2_382)
		v2_381 = v0_363(v2_381)
		if v2_381 and v1_368:_keyTaken(v2_381, v1_375) then
			warn("[RobloxUI] key already in use:", v2_381.Name)
			v1_380()
			return false
		end
		v1_375._key = v2_381
		v1_379()
		if not v2_382 and v1_370.Callback then v1_370.Callback(v2_381) end
		return true
	end
	function v1_375:Get()
		return v1_375._key
	end
	function v1_375:_startListening()
		if v1_368._listening and v1_368._listening ~= v1_375 then
			v1_368._listening:_stopListening()
		end
		v1_368._listening = v1_375
		v1_375._isListening = true
		v0_12(v1_376, { BackgroundColor3 = v0_8.Accent }, 0.15)
		v1_379()
	end
	function v1_375:_stopListening()
		if v1_368._listening == v1_375 then v1_368._listening = nil end
		v1_375._isListening = false
		v0_12(v1_376, { BackgroundColor3 = v0_8.Card }, 0.15)
		v1_379()
	end
	function v1_375:_capture(v2_383)
		if v2_383 == Enum.KeyCode.Unknown then return end
		v1_375:_stopListening()
		if v2_383 == Enum.KeyCode.Escape then return end
		if v2_383 == Enum.KeyCode.Backspace or v2_383 == Enum.KeyCode.Delete then
			v1_375:Set(nil)
		else
			v1_375:Set(v2_383)
		end
	end
	function v1_375:Destroy()
		if v1_375._destroyed then return end
		v1_375._destroyed = true
		if v1_368._listening == v1_375 then v1_368._listening = nil end
		local v2_384 = table.find(v1_368._binds, v1_375)
		if v2_384 then table.remove(v1_368._binds, v2_384) end
		v1_368._cleanups[v1_375] = nil
		for v3_385, v3_386 in ipairs(v1_374) do v3_386:Disconnect() end
		v1_374 = {}
		v1_376:Destroy()
	end
	if v1_373 then
		v0_21(v1_376, v0_8.Card, v0_8.Sidebar, function() return v1_375._isListening end)
		table.insert(v1_374, v1_376.MouseButton1Click:Connect(function()
			if v1_375._isListening then v1_375:_stopListening() else v1_375:_startListening() end
		end))
		table.insert(v1_374, v1_376.MouseButton2Click:Connect(function()
			if v1_375._isListening then v1_375:_stopListening() end
			v1_375:Set(nil)
		end))
	end
	if v1_370.Key ~= nil then
		v1_375:Set(v1_370.Key, true)
	end
	table.insert(v1_368._binds, v1_375)
	v1_368._cleanups[v1_375] = function() v1_375:Destroy() end
	return v1_375
end
local function v0_387(v1_388, v1_389, v1_390)
	local v1_391 = v1_389.Instance
	local function v1_392()
		local v2_393 = math.clamp(v1_391.TextBounds.X + 14, 30, 96)
		v1_388.Size = UDim2.new(1, -(v1_390 + v2_393 + 6), 1, 0)
	end
	v1_392()
	v1_391:GetPropertyChangedSignal("TextBounds"):Connect(v1_392)
end
function v0_3:AddButton(v1_394)
	v1_394 = v1_394 or {}
	self._count += 1
	local v1_395 = Instance.new("TextButton")
	v1_395.Name = "Button"
	v1_395.Size = UDim2.new(1, 0, 0, 32)
	v1_395.BackgroundColor3 = v0_8.Element
	v1_395.BorderSizePixel = 0
	v1_395.Text = v1_394.Name or "Button"
	v1_395.TextColor3 = v0_8.Text
	v1_395.Font = Enum.Font.Gotham
	v1_395.TextSize = 14
	v1_395.TextTruncate = Enum.TextTruncate.AtEnd
	v1_395.AutoButtonColor = false
	v1_395.LayoutOrder = self._count
	v1_395.Parent = self.Holder
	v0_63(v1_395, 6)
	local v1_396 = Instance.new("UIPadding")
	v1_396.PaddingLeft = UDim.new(0, 8)
	v1_396.PaddingRight = UDim.new(0, 8)
	v1_396.Parent = v1_395
	v0_21(v1_395, v0_8.Element, v0_8.Hover)
	v1_395.MouseButton1Click:Connect(function()
		v1_395.BackgroundColor3 = v0_8.Accent
		v0_12(v1_395, { BackgroundColor3 = v0_8.Hover }, 0.3)
		if v1_394.Callback then v1_394.Callback() end
	end)
	return v1_395
end
function v0_3:AddToggle(v1_397)
	v1_397 = v1_397 or {}
	self._count += 1
	local v1_398 = v1_397.Default == true
	local v1_399 = self
	local v1_400 = Instance.new("TextButton")
	v1_400.Name = "Toggle"
	v1_400.Size = UDim2.new(1, 0, 0, 32)
	v1_400.BackgroundColor3 = v0_8.Element
	v1_400.BorderSizePixel = 0
	v1_400.Text = ""
	v1_400.AutoButtonColor = false
	v1_400.LayoutOrder = self._count
	v1_400.Parent = self.Holder
	v0_63(v1_400, 6)
	v0_21(v1_400, v0_8.Element, v0_8.Hover)
	local v1_401 = Instance.new("TextLabel")
	v1_401.Name = "Label"
	v1_401.Position = UDim2.new(0, 8, 0, 0)
	v1_401.Size = UDim2.new(1, -60, 1, 0)
	v1_401.BackgroundTransparency = 1
	v1_401.BorderSizePixel = 0
	v1_401.Text = v1_397.Name or "Toggle"
	v1_401.TextColor3 = v0_8.Text
	v1_401.Font = Enum.Font.Gotham
	v1_401.TextSize = 14
	v1_401.TextXAlignment = Enum.TextXAlignment.Left
	v1_401.TextTruncate = Enum.TextTruncate.AtEnd
	v1_401.Parent = v1_400
	local v1_402 = Instance.new("Frame")
	v1_402.Name = "Track"
	v1_402.AnchorPoint = Vector2.new(1, 0.5)
	v1_402.Position = UDim2.new(1, -8, 0.5, 0)
	v1_402.Size = UDim2.new(0, 34, 0, 18)
	v1_402.BackgroundColor3 = v0_8.Off
	v1_402.BorderSizePixel = 0
	v1_402.Parent = v1_400
	v0_63(v1_402, 9)
	local v1_403 = Instance.new("Frame")
	v1_403.Name = "Knob"
	v1_403.AnchorPoint = Vector2.new(0, 0.5)
	v1_403.Position = UDim2.new(0, 2, 0.5, 0)
	v1_403.Size = UDim2.new(0, 14, 0, 14)
	v1_403.BackgroundColor3 = v0_8.Text
	v1_403.BorderSizePixel = 0
	v1_403.Parent = v1_402
	v0_63(v1_403, 7)
	local function v1_404(v2_405)
		local v2_406 = TweenInfo.new(v2_405 and 0.15 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		v0_5:Create(v1_402, v2_406, { BackgroundColor3 = v1_398 and v0_8.Accent or v0_8.Off }):Play()
		v0_5:Create(v1_403, v2_406, {
			Position = v1_398 and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}):Play()
	end
	v1_404(false)
	local v1_407 = { Instance = v1_400 }
	function v1_407:Set(v2_408, v2_409)
		v1_398 = v2_408 and true or false
		v1_404(true)
		if not v2_409 and v1_397.Callback then v1_397.Callback(v1_398) end
	end
	function v1_407:Get()
		return v1_398
	end
	v1_400.MouseButton1Click:Connect(function()
		v1_407:Set(not v1_398)
	end)
	function v1_407:AddKeybind(v2_410)
		if v1_407.Keybind then
			warn("[RobloxUI] this toggle already has a keybind")
			return v1_407.Keybind
		end
		local v2_411 = v0_367(v1_399._lib, v1_400, v2_410, UDim2.new(1, -48, 0.5, 0), function()
			v1_407:Set(not v1_398)
		end)
		v0_387(v1_401, v2_411, 60)
		local v2_412 = v2_411.Destroy
		function v2_411:Destroy()
			v2_412(v2_411)
			v1_407.Keybind = nil
			v1_401.Size = UDim2.new(1, -60, 1, 0)
		end
		v1_407.Keybind = v2_411
		return v2_411
	end
	function v1_407:Destroy()
		if v1_407._destroyed then return end
		v1_407._destroyed = true
		if v1_407.Keybind then v1_407.Keybind:Destroy() end
		v1_400:Destroy()
	end
	return v1_407
end
function v0_3:AddParagraph(v1_413)
	v1_413 = v1_413 or {}
	self._count += 1
	local v1_414 = v1_413.Title and tostring(v1_413.Title) or ""
	local v1_415 = v1_413.Content and tostring(v1_413.Content) or ""
	local v1_416 = Instance.new("Frame")
	v1_416.Name = "Paragraph"
	v1_416.Size = UDim2.new(1, 0, 0, 0)
	v1_416.AutomaticSize = Enum.AutomaticSize.Y
	v1_416.BackgroundColor3 = v0_8.Element
	v1_416.BorderSizePixel = 0
	v1_416.LayoutOrder = self._count
	v1_416.Parent = self.Holder
	v0_63(v1_416, 6)
	local v1_417 = Instance.new("UIPadding")
	v1_417.PaddingTop = UDim.new(0, 8)
	v1_417.PaddingBottom = UDim.new(0, 8)
	v1_417.PaddingLeft = UDim.new(0, 8)
	v1_417.PaddingRight = UDim.new(0, 8)
	v1_417.Parent = v1_416
	local v1_418 = Instance.new("UIListLayout")
	v1_418.Padding = UDim.new(0, 3)
	v1_418.SortOrder = Enum.SortOrder.LayoutOrder
	v1_418.Parent = v1_416
	local function v1_419(v2_420, v2_421, v2_422, v2_423, v2_424)
		local v2_425 = Instance.new("TextLabel")
		v2_425.Name = v2_420
		v2_425.Size = UDim2.new(1, 0, 0, 0)
		v2_425.AutomaticSize = Enum.AutomaticSize.Y
		v2_425.BackgroundTransparency = 1
		v2_425.BorderSizePixel = 0
		v2_425.TextColor3 = v2_423
		v2_425.Font = v2_421
		v2_425.TextSize = v2_422
		v2_425.TextWrapped = true
		v2_425.RichText = v1_413.RichText == true
		v2_425.TextXAlignment = Enum.TextXAlignment.Left
		v2_425.TextYAlignment = Enum.TextYAlignment.Top
		v2_425.LayoutOrder = v2_424
		v2_425.Parent = v1_416
		return v2_425
	end
	local v1_426 = v1_419("Title", Enum.Font.GothamBold, 14, v0_8.Text, 1)
	local v1_427 = v1_419("Content", Enum.Font.Gotham, 13, v0_8.SubText, 2)
	local function v1_428(v2_429)
		v1_426.Text = v1_414
		v1_426.Visible = v1_414 ~= ""
		v1_427.Text = v1_415
		v1_427.Visible = v1_415 ~= ""
		if v2_429 then
			v1_426.TextTransparency = 1
			v1_427.TextTransparency = 1
			v0_12(v1_426, { TextTransparency = 0 }, 0.2)
			v0_12(v1_427, { TextTransparency = 0 }, 0.2)
		end
	end
	v1_428(false)
	local v1_430 = { Instance = v1_416 }
	function v1_430:SetTitle(v2_431)
		v1_414 = v2_431 and tostring(v2_431) or ""
		v1_428(true)
	end
	function v1_430:SetContent(v2_432)
		v1_415 = v2_432 and tostring(v2_432) or ""
		v1_428(true)
	end
	function v1_430:Set(v2_433)
		v2_433 = v2_433 or {}
		if v2_433.Title ~= nil then v1_414 = tostring(v2_433.Title) end
		if v2_433.Content ~= nil then v1_415 = tostring(v2_433.Content) end
		v1_428(true)
	end
	function v1_430:Get()
		return v1_414, v1_415
	end
	function v1_430:Destroy()
		v1_416:Destroy()
	end
	return v1_430
end
function v0_3:AddTextbox(v1_434)
	v1_434 = v1_434 or {}
	self._count += 1
	local v1_435 = v1_434.Numeric == true
	local v1_436 = tonumber(v1_434.MaxLength)
	local v1_437 = v1_434.Name ~= nil and v1_434.Name ~= ""
	local v1_438, v1_439, v1_440 = false, false, false
	local function v1_441(v2_442)
		if v1_434.Min then v2_442 = math.max(v2_442, v1_434.Min) end
		if v1_434.Max then v2_442 = math.min(v2_442, v1_434.Max) end
		return v2_442
	end
	local v1_443
	if v1_435 then
		v1_443 = tonumber(v1_434.Default)
		if v1_443 then v1_443 = v1_441(v1_443) end
	else
		v1_443 = tostring(v1_434.Default or "")
	end
	local function v1_444(v2_445)
		return v2_445 == nil and "" or tostring(v2_445)
	end
	local function v1_446(v2_447)
		local v2_448 = v2_447:sub(1, 1) == "-"
		v2_447 = v2_447:gsub("[^%d%.]", "")
		local v2_449 = v2_447:find(".", 1, true)
		if v2_449 then
			local v3_450 = v2_447:sub(v2_449 + 1):gsub("%.", "")
			v2_447 = v2_447:sub(1, v2_449) .. v3_450
		end
		return (v2_448 and "-" or "") .. v2_447
	end
	local v1_451 = Instance.new("Frame")
	v1_451.Name = "Textbox"
	v1_451.Size = UDim2.new(1, 0, 0, 32)
	v1_451.BackgroundColor3 = v0_8.Element
	v1_451.BorderSizePixel = 0
	v1_451.LayoutOrder = self._count
	v1_451.Parent = self.Holder
	v0_63(v1_451, 6)
	if v1_437 then
		local v2_452 = Instance.new("TextLabel")
		v2_452.Name = "Label"
		v2_452.Position = UDim2.new(0, 8, 0, 0)
		v2_452.Size = UDim2.new(0.4, -8, 1, 0)
		v2_452.BackgroundTransparency = 1
		v2_452.BorderSizePixel = 0
		v2_452.Text = v1_434.Name
		v2_452.TextColor3 = v0_8.Text
		v2_452.Font = Enum.Font.Gotham
		v2_452.TextSize = 14
		v2_452.TextXAlignment = Enum.TextXAlignment.Left
		v2_452.TextTruncate = Enum.TextTruncate.AtEnd
		v2_452.Parent = v1_451
	end
	local v1_453 = Instance.new("Frame")
	v1_453.Name = "BoxHolder"
	v1_453.AnchorPoint = Vector2.new(1, 0.5)
	v1_453.Position = UDim2.new(1, -6, 0.5, 0)
	v1_453.Size = v1_437 and UDim2.new(0.6, -10, 0, 22) or UDim2.new(1, -12, 0, 22)
	v1_453.BackgroundColor3 = v0_8.Card
	v1_453.BorderSizePixel = 0
	v1_453.Parent = v1_451
	v0_63(v1_453, 5)
	local v1_454 = Instance.new("UIStroke")
	v1_454.Color = v0_8.Accent
	v1_454.Thickness = 1
	v1_454.Transparency = 1
	v1_454.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_454.Parent = v1_453
	local v1_455 = Instance.new("TextBox")
	v1_455.Name = "Input"
	v1_455.Size = UDim2.new(1, 0, 1, 0)
	v1_455.BackgroundTransparency = 1
	v1_455.BorderSizePixel = 0
	v1_455.Text = v1_444(v1_443)
	v1_455.PlaceholderText = v1_434.Placeholder or ""
	v1_455.PlaceholderColor3 = v0_8.IconOff
	v1_455.TextColor3 = v0_8.Text
	v1_455.Font = Enum.Font.Gotham
	v1_455.TextSize = 13
	v1_455.TextXAlignment = Enum.TextXAlignment.Left
	v1_455.ClearTextOnFocus = v1_434.ClearTextOnFocus == true
	v1_455.ClipsDescendants = true
	v1_455.Parent = v1_453
	local v1_456 = Instance.new("UIPadding")
	v1_456.PaddingLeft = UDim.new(0, 6)
	v1_456.PaddingRight = UDim.new(0, 6)
	v1_456.Parent = v1_455
	local function v1_457()
		v0_12(v1_453, { BackgroundColor3 = (v1_439 and not v1_438) and v0_8.Sidebar or v0_8.Card }, 0.12)
		v0_12(v1_454, { Transparency = v1_438 and 0 or 1 }, 0.15)
	end
	v1_455:GetPropertyChangedSignal("Text"):Connect(function()
		if v1_440 then return end
		local v2_458 = v1_455.Text
		if v1_435 then v2_458 = v1_446(v2_458) end
		if v1_436 and #v2_458 > v1_436 then v2_458 = v2_458:sub(1, v1_436) end
		if v2_458 ~= v1_455.Text then
			v1_440 = true
			v1_455.Text = v2_458
			v1_440 = false
		end
	end)
	v1_455.Focused:Connect(function()
		v1_438 = true
		v1_457()
	end)
	v1_455.FocusLost:Connect(function(v2_459)
		v1_438 = false
		v1_457()
		if v1_435 then
			local v3_460 = tonumber(v1_455.Text)
			if v3_460 == nil then
				v1_455.Text = v1_444(v1_443)
				return
			end
			v3_460 = v1_441(v3_460)
			v1_443 = v3_460
			v1_455.Text = v1_444(v3_460)
		else
			v1_443 = v1_455.Text
		end
		if v1_434.Callback then v1_434.Callback(v1_443, v2_459) end
	end)
	v1_453.MouseEnter:Connect(function()
		v1_439 = true
		v1_457()
	end)
	v1_453.MouseLeave:Connect(function()
		v1_439 = false
		v1_457()
	end)
	local v1_461 = { Instance = v1_451 }
	function v1_461:Set(v2_462, v2_463)
		if v1_435 then
			local v3_464 = tonumber(v2_462)
			if v3_464 == nil then return end
			v1_443 = v1_441(v3_464)
		else
			v1_443 = tostring(v2_462 == nil and "" or v2_462)
			if v1_436 then v1_443 = v1_443:sub(1, v1_436) end
		end
		v1_455.Text = v1_444(v1_443)
		if not v2_463 and v1_434.Callback then v1_434.Callback(v1_443, false) end
	end
	function v1_461:Get()
		return v1_443
	end
	function v1_461:Focus()
		v1_455:CaptureFocus()
	end
	function v1_461:Destroy()
		if v1_455:IsFocused() then v1_455:ReleaseFocus() end
		v1_451:Destroy()
	end
	return v1_461
end
function v0_3:AddKeybind(v1_465)
	v1_465 = v1_465 or {}
	self._count += 1
	local v1_466 = Instance.new("Frame")
	v1_466.Name = "KeybindRow"
	v1_466.Size = UDim2.new(1, 0, 0, 32)
	v1_466.BackgroundColor3 = v0_8.Element
	v1_466.BorderSizePixel = 0
	v1_466.LayoutOrder = self._count
	v1_466.Parent = self.Holder
	v0_63(v1_466, 6)
	local v1_467 = Instance.new("TextLabel")
	v1_467.Name = "Label"
	v1_467.Position = UDim2.new(0, 8, 0, 0)
	v1_467.Size = UDim2.new(1, -60, 1, 0)
	v1_467.BackgroundTransparency = 1
	v1_467.BorderSizePixel = 0
	v1_467.Text = v1_465.Name or "Keybind"
	v1_467.TextColor3 = v0_8.Text
	v1_467.Font = Enum.Font.Gotham
	v1_467.TextSize = 14
	v1_467.TextXAlignment = Enum.TextXAlignment.Left
	v1_467.TextTruncate = Enum.TextTruncate.AtEnd
	v1_467.Parent = v1_466
	local v1_468 = v0_367(self._lib, v1_466, v1_465, UDim2.new(1, -8, 0.5, 0), function()
		if v1_465.OnPress then v1_465.OnPress() end
	end)
	v0_387(v1_467, v1_468, 16)
	v1_468.Row = v1_466
	local v1_469 = v1_468.Destroy
	function v1_468:Destroy()
		v1_469(v1_468)
		v1_466:Destroy()
	end
	return v1_468
end
function v0_3:AddSlider(v1_470)
	v1_470 = v1_470 or {}
	self._count += 1
	local v1_471 = self._lib
	local function v1_472(v2_473)
		return #(tostring(v2_473):match("%.(%d+)") or "")
	end
	local v1_474 = tonumber(v1_470.Min) or 0
	local v1_475 = tonumber(v1_470.Max) or 100
	if v1_475 < v1_474 then v1_474, v1_475 = v1_475, v1_474 end
	local v1_476 = tonumber(v1_470.Increment) or 1
	if v1_476 <= 0 then v1_476 = 1 end
	local v1_477 = math.max(v1_472(v1_476), v1_472(v1_474))
	local v1_478 = v1_470.ValueName
	local function v1_479(v2_480)
		v2_480 = math.clamp(v2_480, v1_474, v1_475)
		v2_480 = v1_474 + math.floor((v2_480 - v1_474) / v1_476 + 0.5) * v1_476
		v2_480 = math.clamp(v2_480, v1_474, v1_475)
		local v2_481 = 10 ^ v1_477
		return math.floor(v2_480 * v2_481 + 0.5) / v2_481
	end
	local function v1_482(v2_483)
		return v1_475 > v1_474 and (v2_483 - v1_474) / (v1_475 - v1_474) or 0
	end
	local function v1_484(v2_485)
		local v2_486 = v1_477 > 0 and string.format("%." .. v1_477 .. "f", v2_485) or tostring(v2_485)
		if v1_478 and v1_478 ~= "" then v2_486 = v2_486 .. " " .. tostring(v1_478) end
		return v2_486
	end
	local v1_487 = v1_479(tonumber(v1_470.Default) or v1_474)
	local v1_488, v1_489 = false, false
	local v1_490 = nil
	local v1_491 = Instance.new("Frame")
	v1_491.Name = "Slider"
	v1_491.Size = UDim2.new(1, 0, 0, 46)
	v1_491.BackgroundColor3 = v0_8.Element
	v1_491.BorderSizePixel = 0
	v1_491.LayoutOrder = self._count
	v1_491.Parent = self.Holder
	v0_63(v1_491, 6)
	local v1_492 = Instance.new("TextLabel")
	v1_492.Name = "Name"
	v1_492.Position = UDim2.new(0, 8, 0, 6)
	v1_492.Size = UDim2.new(0.6, -8, 0, 16)
	v1_492.BackgroundTransparency = 1
	v1_492.BorderSizePixel = 0
	v1_492.Text = v1_470.Name or "Slider"
	v1_492.TextColor3 = v0_8.Text
	v1_492.Font = Enum.Font.Gotham
	v1_492.TextSize = 14
	v1_492.TextXAlignment = Enum.TextXAlignment.Left
	v1_492.TextTruncate = Enum.TextTruncate.AtEnd
	v1_492.Parent = v1_491
	local v1_493 = Instance.new("TextLabel")
	v1_493.Name = "Value"
	v1_493.Position = UDim2.new(0.6, 0, 0, 6)
	v1_493.Size = UDim2.new(0.4, -8, 0, 16)
	v1_493.BackgroundTransparency = 1
	v1_493.BorderSizePixel = 0
	v1_493.Text = v1_484(v1_487)
	v1_493.TextColor3 = v0_8.SubText
	v1_493.Font = Enum.Font.GothamBold
	v1_493.TextSize = 13
	v1_493.TextXAlignment = Enum.TextXAlignment.Right
	v1_493.TextTruncate = Enum.TextTruncate.AtEnd
	v1_493.Parent = v1_491
	local v1_494 = Instance.new("Frame")
	v1_494.Name = "Track"
	v1_494.Position = UDim2.new(0, 8, 0, 31)
	v1_494.Size = UDim2.new(1, -16, 0, 6)
	v1_494.BackgroundColor3 = v0_8.Off
	v1_494.BorderSizePixel = 0
	v1_494.Parent = v1_491
	local v1_495 = Instance.new("Frame")
	v1_495.Name = "Fill"
	v1_495.Size = UDim2.new(v1_482(v1_487), 0, 1, 0)
	v1_495.BackgroundColor3 = v0_8.Accent
	v1_495.BorderSizePixel = 0
	v1_495.Parent = v1_494
	local v1_496 = v0_8.Accent
	local v1_497 = v0_8.Accent:Lerp(v0_8.Text, 0.25)
	local v1_498 = Instance.new("TextButton")
	v1_498.Name = "Hit"
	v1_498.Size = UDim2.new(1, 0, 1, 0)
	v1_498.BackgroundTransparency = 1
	v1_498.BorderSizePixel = 0
	v1_498.Text = ""
	v1_498.AutoButtonColor = false
	v1_498.Parent = v1_491
	local function v1_499()
		local v2_500 = v1_488 or v1_489
		v0_12(v1_491, { BackgroundColor3 = v2_500 and v0_8.Hover or v0_8.Element }, 0.12)
		v0_12(v1_495, { BackgroundColor3 = v2_500 and v1_497 or v1_496 }, 0.12)
	end
	local function v1_501(v2_502)
		local v2_503 = v1_482(v1_487)
		v0_12(v1_495, { Size = UDim2.new(v2_503, 0, 1, 0) }, v2_502)
		v1_493.Text = v1_484(v1_487)
	end
	local function v1_504(v2_505, v2_506, v2_507)
		v2_505 = v1_479(v2_505)
		local v2_508 = v2_505 ~= v1_487
		v1_487 = v2_505
		v1_501(v2_507)
		if v2_508 then
			v1_493.TextColor3 = v0_8.Text
			v0_12(v1_493, { TextColor3 = v0_8.SubText }, 0.3)
			if not v2_506 and v1_470.Callback then v1_470.Callback(v1_487) end
		end
	end
	local function v1_509(v2_510)
		local v2_511 = v1_494.AbsoluteSize.X
		if v2_511 <= 0 then return end
		v1_504(v1_474 + ((v2_510 - v1_494.AbsolutePosition.X) / v2_511) * (v1_475 - v1_474), false, 0.08)
	end
	local function v1_512()
		if v1_490 then
			for v4_513, v4_514 in ipairs(v1_490) do v4_514:Disconnect() end
			v1_490 = nil
		end
		if v1_489 then
			v1_489 = false
			v1_499()
		end
	end
	local function v1_515(v2_516)
		v1_512()
		v1_489 = true
		v1_499()
		v1_509(v2_516.Position.X)
		v1_490 = {
			v0_4.InputChanged:Connect(function(v3_517)
				if v3_517.UserInputType == Enum.UserInputType.MouseMovement or v3_517 == v2_516 then
					v1_509(v3_517.Position.X)
				end
			end),
			v0_4.InputEnded:Connect(function(v3_518)
				if v3_518 == v2_516 or v3_518.UserInputType == Enum.UserInputType.MouseButton1 then
					v1_512()
				end
			end),
		}
	end
	v1_498.InputBegan:Connect(function(v2_519)
		if v0_19(v2_519) then v1_515(v2_519) end
	end)
	v1_498.MouseEnter:Connect(function()
		v1_488 = true
		v1_499()
	end)
	v1_498.MouseLeave:Connect(function()
		v1_488 = false
		v1_499()
	end)
	local v1_520 = { Instance = v1_491 }
	function v1_520:Set(v2_521, v2_522)
		v1_504(tonumber(v2_521) or v1_487, v2_522, 0.2)
	end
	function v1_520:Get()
		return v1_487
	end
	function v1_520:Destroy()
		v1_512()
		v1_471._cleanups[v1_520] = nil
		v1_491:Destroy()
	end
	v1_471._cleanups[v1_520] = v1_512
	return v1_520
end
function v0_3:AddDropdown(v1_523)
	v1_523 = v1_523 or {}
	self._count += 1
	local v1_524 = v1_523.Options or {}
	local v1_525 = v1_523.Multi == true
	local v1_526 = 130
	local v1_527, v1_528 = 26, 4
	local v1_529 = nil
	local v1_530 = {}
	local v1_531 = {}
	local v1_532 = false
	local v1_533 = 0
	local v1_534 = nil
	local v1_535 = Instance.new("Frame")
	v1_535.Name = "Dropdown"
	v1_535.Size = UDim2.new(1, 0, 0, 32)
	v1_535.AutomaticSize = Enum.AutomaticSize.Y
	v1_535.BackgroundTransparency = 1
	v1_535.BorderSizePixel = 0
	v1_535.LayoutOrder = self._count
	v1_535.Parent = self.Holder
	local v1_536 = Instance.new("UIListLayout")
	v1_536.Padding = UDim.new(0, 4)
	v1_536.SortOrder = Enum.SortOrder.LayoutOrder
	v1_536.Parent = v1_535
	local v1_537 = Instance.new("TextButton")
	v1_537.Name = "Header"
	v1_537.Size = UDim2.new(1, 0, 0, 32)
	v1_537.BackgroundColor3 = v0_8.Element
	v1_537.BorderSizePixel = 0
	v1_537.Text = ""
	v1_537.AutoButtonColor = false
	v1_537.LayoutOrder = 1
	v1_537.Parent = v1_535
	v0_63(v1_537, 6)
	v0_21(v1_537, v0_8.Element, v0_8.Hover)
	local v1_538 = Instance.new("TextLabel")
	v1_538.Name = "Name"
	v1_538.Position = UDim2.new(0, 8, 0, 0)
	v1_538.Size = UDim2.new(0.5, -8, 1, 0)
	v1_538.BackgroundTransparency = 1
	v1_538.BorderSizePixel = 0
	v1_538.Text = v1_523.Name or "Dropdown"
	v1_538.TextColor3 = v0_8.Text
	v1_538.Font = Enum.Font.Gotham
	v1_538.TextSize = 14
	v1_538.TextXAlignment = Enum.TextXAlignment.Left
	v1_538.TextTruncate = Enum.TextTruncate.AtEnd
	v1_538.Parent = v1_537
	local v1_539 = Instance.new("TextLabel")
	v1_539.Name = "Value"
	v1_539.Position = UDim2.new(0.5, 0, 0, 0)
	v1_539.Size = UDim2.new(0.5, -28, 1, 0)
	v1_539.BackgroundTransparency = 1
	v1_539.BorderSizePixel = 0
	v1_539.Text = "None"
	v1_539.TextColor3 = v0_8.SubText
	v1_539.Font = Enum.Font.Gotham
	v1_539.TextSize = 13
	v1_539.TextXAlignment = Enum.TextXAlignment.Right
	v1_539.TextTruncate = Enum.TextTruncate.AtEnd
	v1_539.Parent = v1_537
	local v1_540 = Instance.new("ImageLabel")
	v1_540.Name = "Arrow"
	v1_540.AnchorPoint = Vector2.new(1, 0.5)
	v1_540.Position = UDim2.new(1, -8, 0.5, 0)
	v1_540.Size = UDim2.new(0, 16, 0, 16)
	v1_540.BackgroundTransparency = 1
	v1_540.BorderSizePixel = 0
	v1_540.ImageColor3 = v0_8.SubText
	v1_540.ScaleType = Enum.ScaleType.Fit
	v1_540.Parent = v1_537
	local v1_541 = Instance.new("TextLabel")
	v1_541.Name = "ArrowFallback"
	v1_541.Size = UDim2.new(1, 0, 1, 0)
	v1_541.BackgroundTransparency = 1
	v1_541.Text = "▼"
	v1_541.TextColor3 = v0_8.SubText
	v1_541.Font = Enum.Font.Gotham
	v1_541.TextSize = 9
	v1_541.Visible = false
	v1_541.Parent = v1_540
	local function v1_542(v2_543)
		local v2_544 = v0_44(v1_540, v2_543 and "chevron-up" or "chevron-down", self._icons)
		if not v2_544 then v1_540.Image = "" end
		v1_541.Visible = not v2_544
		v1_541.Text = v2_543 and "▲" or "▼"
		v1_540.ImageTransparency = 1
		v1_541.TextTransparency = 1
		v0_12(v1_540, { ImageTransparency = 0 }, 0.18)
		v0_12(v1_541, { TextTransparency = 0 }, 0.18)
	end
	v1_542(false)
	local v1_545 = Instance.new("ScrollingFrame")
	v1_545.Name = "List"
	v1_545.Size = UDim2.new(1, 0, 0, 0)
	v1_545.BackgroundColor3 = v0_8.Sidebar
	v1_545.BorderSizePixel = 0
	v1_545.ScrollBarThickness = 3
	v1_545.ScrollBarImageColor3 = v0_8.IconOff
	v1_545.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_545.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_545.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_545.Visible = false
	v1_545.LayoutOrder = 2
	v1_545.Parent = v1_535
	v0_63(v1_545, 6)
	local v1_546 = Instance.new("UIPadding")
	v1_546.PaddingTop = UDim.new(0, 4)
	v1_546.PaddingBottom = UDim.new(0, 4)
	v1_546.Parent = v1_545
	local v1_547 = Instance.new("UIListLayout")
	v1_547.Padding = UDim.new(0, v1_528)
	v1_547.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_547.SortOrder = Enum.SortOrder.LayoutOrder
	v1_547.Parent = v1_545
	local function v1_548(v2_549)
		if v1_525 then return v1_530[v2_549] == true end
		return v1_529 == v2_549
	end
	local function v1_550()
		local v2_551 = {}
		for v3_552, v3_553 in ipairs(v1_524) do
			if v1_530[v3_553] then table.insert(v2_551, v3_553) end
		end
		return v2_551
	end
	local function v1_554()
		for v3_555, v3_556 in pairs(v1_531) do
			local v3_557 = v1_548(v3_555)
			v3_556.BackgroundColor3 = v3_557 and v0_8.Accent or v0_8.Element
			v3_556.TextColor3 = v3_557 and v0_8.IconOn or v0_8.SubText
		end
		if v1_525 then
			local v3_558 = {}
			for v4_559, v4_560 in ipairs(v1_550()) do table.insert(v3_558, tostring(v4_560)) end
			v1_539.Text = #v3_558 > 0 and table.concat(v3_558, ", ") or "None"
		else
			v1_539.Text = v1_529 ~= nil and tostring(v1_529) or "None"
		end
	end
	local function v1_561(v2_562)
		if v1_532 == v2_562 then return end
		v1_532 = v2_562
		if v1_534 then v1_534:Cancel() end
		v1_542(v2_562)
		if v2_562 then
			v1_545.Visible = true
			v1_534 = v0_12(v1_545, { Size = UDim2.new(1, 0, 0, v1_533) }, 0.22, Enum.EasingStyle.Quint)
		else
			local v3_563 = v0_12(v1_545, { Size = UDim2.new(1, 0, 0, 0) }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v1_534 = v3_563
			v3_563.Completed:Connect(function(v4_564)
				if v4_564 == Enum.PlaybackState.Completed and not v1_532 then
					v1_545.Visible = false
				end
			end)
		end
	end
	local v1_565 = { Instance = v1_535 }
	local function v1_566()
		if v1_523.Callback then
			v1_523.Callback(v1_525 and v1_550() or v1_529)
		end
	end
	local function v1_567()
		for v3_568, v3_569 in pairs(v1_531) do v3_569:Destroy() end
		v1_531 = {}
		for v3_570, v3_571 in ipairs(v1_524) do
			local v3_572 = Instance.new("TextButton")
			v3_572.Name = "Option"
			v3_572.Size = UDim2.new(1, -8, 0, v1_527)
			v3_572.BackgroundColor3 = v0_8.Element
			v3_572.BorderSizePixel = 0
			v3_572.Text = tostring(v3_571)
			v3_572.TextColor3 = v0_8.SubText
			v3_572.Font = Enum.Font.Gotham
			v3_572.TextSize = 13
			v3_572.TextTruncate = Enum.TextTruncate.AtEnd
			v3_572.AutoButtonColor = true
			v3_572.LayoutOrder = v3_570
			v3_572.Parent = v1_545
			v0_63(v3_572, 5)
			v3_572.MouseButton1Click:Connect(function()
				if v1_525 then
					v1_530[v3_571] = not v1_530[v3_571] or nil
					v1_554()
					v1_566()
				else
					v1_529 = v3_571
					v1_554()
					v1_561(false)
					v1_566()
				end
			end)
			v1_531[v3_571] = v3_572
		end
		local v2_573 = #v1_524
		local v2_574 = v2_573 > 0 and (v2_573 * v1_527 + (v2_573 - 1) * v1_528 + 8) or 0
		v1_533 = math.min(v2_574, v1_526)
		v1_545.Size = UDim2.new(1, 0, 0, v1_532 and v1_533 or 0)
		v1_554()
	end
	function v1_565:Set(v2_575, v2_576)
		if v1_525 then
			v1_530 = {}
			for v4_577, v4_578 in ipairs(typeof(v2_575) == "table" and v2_575 or { v2_575 }) do
				v1_530[v4_578] = true
			end
		else
			v1_529 = v2_575
		end
		v1_554()
		if not v2_576 then v1_566() end
	end
	function v1_565:Get()
		return v1_525 and v1_550() or v1_529
	end
	function v1_565:Refresh(v2_579, v2_580)
		v1_524 = v2_579 or {}
		if v2_580 then
			local v3_581 = {}
			for v4_582, v4_583 in ipairs(v1_524) do v3_581[v4_583] = true end
			if v1_525 then
				for v5_584 in pairs(v1_530) do
					if not v3_581[v5_584] then v1_530[v5_584] = nil end
				end
			elseif not v3_581[v1_529] then
				v1_529 = nil
			end
		else
			v1_530, v1_529 = {}, nil
		end
		v1_567()
	end
	function v1_565:Open() v1_561(true) end
	function v1_565:Close() v1_561(false) end
	v1_537.MouseButton1Click:Connect(function()
		v1_561(not v1_532)
	end)
	v1_567()
	if v1_523.Default ~= nil then
		v1_565:Set(v1_523.Default, true)
	end
	return v1_565
end
return v0_1
