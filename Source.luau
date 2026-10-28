local v0_1 = {}
v0_1.__index = v0_1
local v0_2 = {}
v0_2.__index = v0_2
local v0_3 = {}
v0_3.__index = v0_3
local v0_4 = game:GetService("UserInputService")
local v0_5 = game:GetService("TweenService")
local v0_6 = game:GetService("RunService")
local v0_7 = {
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
local v0_8 = 50
local v0_9 = 8
local function v0_10(v1_11, v1_12, v1_13, v1_14, v1_15)
	local v1_16 = v0_5:Create(
		v1_11,
		TweenInfo.new(v1_13 or 0.15, v1_14 or Enum.EasingStyle.Quad, v1_15 or Enum.EasingDirection.Out),
		v1_12
	)
	v1_16:Play()
	return v1_16
end
local function v0_17(v1_18)
	return v1_18.UserInputType == Enum.UserInputType.MouseButton1 or v1_18.UserInputType == Enum.UserInputType.Touch
end
local function v0_19(v1_20, v1_21, v1_22, v1_23)
	local v1_24 = Instance.new("UIScale")
	v1_24.Parent = v1_20
	v1_20.MouseEnter:Connect(function()
		if not (v1_23 and v1_23()) then
			v0_10(v1_20, { BackgroundColor3 = v1_22 }, 0.12)
		end
	end)
	v1_20.MouseLeave:Connect(function()
		v0_10(v1_24, { Scale = 1 }, 0.12)
		if not (v1_23 and v1_23()) then
			v0_10(v1_20, { BackgroundColor3 = v1_21 }, 0.15)
		end
	end)
	v1_20.InputBegan:Connect(function(v2_25)
		if v0_17(v2_25) then v0_10(v1_24, { Scale = 0.96 }, 0.08) end
	end)
	v1_20.InputEnded:Connect(function(v2_26)
		if v0_17(v2_26) then v0_10(v1_24, { Scale = 1 }, 0.18, Enum.EasingStyle.Back) end
	end)
end
local function v0_27(v1_28)
	return v1_28:find("^rbx") ~= nil or v1_28:find("^https?://") ~= nil
end
local function v0_29(v1_30, v1_31, v1_32)
	if v1_32 > 3 then return end
	for v2_33, v2_34 in pairs(v1_30) do
		local v2_35 = type(v2_33) == "string" and v2_33:lower() or ""
		local v2_36 = typeof(v2_34)
		if v2_36 == "string" then
			if v0_27(v2_34) then
				v1_31.image = v1_31.image or v2_34
			elseif v2_34:match("^%d+$") then
				v1_31.image = v1_31.image or ("rbxassetid://" .. v2_34)
			end
		elseif v2_36 == "number" then
			if v2_35 == "id" or v2_35 == "image" or v2_35 == "imageid" or v2_35 == "assetid" or v2_33 == 1 then
				if v2_34 > 1000 then v1_31.image = v1_31.image or ("rbxassetid://" .. v2_34) end
			end
		elseif v2_36 == "Vector2" then
			if v2_35:find("size") then
				v1_31.size = v1_31.size or v2_34
			elseif v2_35:find("pos") or v2_35:find("offset") then
				v1_31.offset = v1_31.offset or v2_34
			end
		elseif v2_36 == "table" then
			v0_29(v2_34, v1_31, v1_32 + 1)
		end
	end
end
local function v0_37(v1_38)
	local v1_39 = {}
	local v1_40 = typeof(v1_38)
	if v1_40 == "string" then
		if v0_27(v1_38) then
			v1_39.image = v1_38
		elseif v1_38:match("^%d+$") then
			v1_39.image = "rbxassetid://" .. v1_38
		end
	elseif v1_40 == "number" then
		v1_39.image = "rbxassetid://" .. v1_38
	elseif v1_40 == "table" then
		v0_29(v1_38, v1_39, 0)
	elseif v1_40 == "Instance" then
		local v2_41 = (v1_38:IsA("ImageLabel") or v1_38:IsA("ImageButton")) and v1_38
			or v1_38:FindFirstChildWhichIsA("ImageLabel", true)
		if v2_41 then
			v1_39.image, v1_39.size, v1_39.offset = v2_41.Image, v2_41.ImageRectSize, v2_41.ImageRectOffset
		end
	end
	if v1_39.image == "" then v1_39.image = nil end
	return v1_39
end
local function v0_42(v1_43, v1_44, v1_45, v1_46)
	local v1_47 = v0_37(v1_44)
	if not v1_47.image and typeof(v1_44) == "string" and v1_45 then
		local v2_48 = {
			function() return v1_45.GetIcon(v1_44) end,
			function() return v1_45:GetIcon(v1_44) end,
			function() return v1_45.Icons and v1_45.Icons[v1_44] end,
			function() return v1_45[v1_44] end,
		}
		for v3_49, v3_50 in ipairs(v2_48) do
			local v3_51, v3_52 = pcall(v3_50)
			if v3_51 and v3_52 ~= nil then
				local v4_53 = v0_37(v3_52)
				if v4_53.image then
					v1_47 = v4_53
					break
				end
			end
		end
	end
	if not v1_47.image then
		if not v1_46 then warn("[RobloxUI] icon not recognized:", typeof(v1_44), v1_44) end
		return false
	end
	v1_43.Image = v1_47.image
	v1_43.ImageRectSize = v1_47.size or Vector2.new(0, 0)
	v1_43.ImageRectOffset = v1_47.offset or Vector2.new(0, 0)
	return true
end
local function v0_54(v1_55)
	local v1_56 = pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(v1_55)
			v1_55.Parent = game:GetService("CoreGui")
		elseif gethui then
			v1_55.Parent = gethui()
		else
			v1_55.Parent = game:GetService("CoreGui")
		end
	end)
	if not v1_56 or not v1_55.Parent then
		local v2_57 = game:GetService("Players").LocalPlayer
		v1_55.Parent = v2_57 and v2_57:WaitForChild("PlayerGui")
	end
end
local function v0_58()
	local v1_59, v1_60 = pcall(function()
		return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"))()
	end)
	if v1_59 and v1_60 then return v1_60 end
	warn("[RobloxUI] failed to load icon library:", v1_60)
	return nil
end
local function v0_61(v1_62, v1_63)
	local v1_64 = Instance.new("UICorner")
	v1_64.CornerRadius = UDim.new(0, v1_63 or 6)
	v1_64.Parent = v1_62
	return v1_64
end
function v0_1.new(v1_65)
	v1_65 = v1_65 or {}
	local v1_66 = setmetatable({}, v0_1)
	v1_66.Tabs = {}
	v1_66.ActiveTab = nil
	v1_66.Icons = v1_65.Icons or v0_58()
	v1_66._binds = {}
	v1_66._cleanups = {}
	v1_66._listening = nil
	v1_66._toggleKey = v1_65.ToggleKey
	v1_66._connections = {}
	local v1_67 = Instance.new("ScreenGui")
	v1_67.Name = "Interface"
	v1_67.ResetOnSpawn = false
	v1_67.IgnoreGuiInset = true
	v1_67.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	v0_54(v1_67)
	local v1_68 = v1_65.Size or UDim2.new(0, 600, 0, 400)
	local v1_69 = Instance.new("CanvasGroup")
	v1_69.Name = "Main"
	v1_69.Size = v1_68
	v1_69.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_69.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_69.BackgroundColor3 = v0_7.Main
	v1_69.BorderSizePixel = 0
	v1_69.ClipsDescendants = true
	v1_69.GroupTransparency = 1
	v1_69.Parent = v1_67
	v0_61(v1_69, v0_9)
	local v1_70 = Instance.new("UIScale")
	v1_70.Scale = 0.9
	v1_70.Parent = v1_69
	local function v1_71()
		local v2_72 = v1_67.AbsoluteSize
		if v2_72.X <= 0 or v2_72.Y <= 0 then
			local v3_73 = workspace.CurrentCamera
			v2_72 = v3_73 and v3_73.ViewportSize or Vector2.new(1280, 720)
		end
		local v2_74, v2_75 = v1_68.X.Offset, v1_68.Y.Offset
		if v1_68.X.Scale == 0 then v2_74 = math.min(v2_74, math.max(v2_72.X - 20, 120)) end
		if v1_68.Y.Scale == 0 then v2_75 = math.min(v2_75, math.max(v2_72.Y - 20, 120)) end
		v1_69.Size = UDim2.new(v1_68.X.Scale, v2_74, v1_68.Y.Scale, v2_75)
		v1_69.Position = UDim2.new(0.5, 0, 0.5, 0)
	end
	v1_71()
	table.insert(v1_66._connections, v1_67:GetPropertyChangedSignal("AbsoluteSize"):Connect(v1_71))
	do
		local v2_76, v2_77, v2_78 = false, nil, nil
		local v2_79 = 50
		table.insert(v1_66._connections, v1_69.InputBegan:Connect(function(v3_80)
			if v3_80.UserInputType == Enum.UserInputType.MouseButton1 or v3_80.UserInputType == Enum.UserInputType.Touch then
				v2_76 = true
				v2_77 = v3_80.Position
				v2_78 = v1_69.AbsolutePosition + v1_69.AbsoluteSize / 2
				v3_80.Changed:Connect(function()
					if v3_80.UserInputState == Enum.UserInputState.End then v2_76 = false end
				end)
			end
		end))
		table.insert(v1_66._connections, v0_4.InputChanged:Connect(function(v3_81)
			if not v2_76 then return end
			if v3_81.UserInputType ~= Enum.UserInputType.MouseMovement and v3_81.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			local v3_82 = v3_81.Position - v2_77
			local v3_83 = v1_67.AbsoluteSize
			local v3_84 = v1_69.AbsoluteSize / 2
			local v3_85 = math.clamp(v2_78.X + v3_82.X, -v3_84.X + v2_79, v3_83.X + v3_84.X - v2_79)
			local v3_86 = math.clamp(v2_78.Y + v3_82.Y, v3_84.Y, math.max(v3_83.Y + v3_84.Y - v2_79, v3_84.Y))
			v1_69.Position = UDim2.fromOffset(v3_85, v3_86)
		end))
	end
	local v1_87 = Instance.new("Frame")
	v1_87.Name = "Sidebar"
	v1_87.Size = UDim2.new(0, v0_8, 1, 0)
	v1_87.BackgroundColor3 = v0_7.Sidebar
	v1_87.BorderSizePixel = 0
	v1_87.Parent = v1_69
	v0_61(v1_87, v0_9)
	local v1_88 = Instance.new("Frame")
	v1_88.Name = "SidebarFix"
	v1_88.Size = UDim2.new(0, v0_9, 1, 0)
	v1_88.Position = UDim2.new(0, v0_8 - v0_9, 0, 0)
	v1_88.BackgroundColor3 = v0_7.Sidebar
	v1_88.BorderSizePixel = 0
	v1_88.Parent = v1_69
	local v1_89 = Instance.new("UIPadding")
	v1_89.PaddingTop = UDim.new(0, 12)
	v1_89.Parent = v1_87
	local v1_90 = Instance.new("UIListLayout")
	v1_90.Padding = UDim.new(0, 8)
	v1_90.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_90.SortOrder = Enum.SortOrder.LayoutOrder
	v1_90.Parent = v1_87
	local v1_91 = Instance.new("Frame")
	v1_91.Name = "Content"
	v1_91.Size = UDim2.new(1, -v0_8, 1, 0)
	v1_91.Position = UDim2.new(0, v0_8, 0, 0)
	v1_91.BackgroundTransparency = 1
	v1_91.BorderSizePixel = 0
	v1_91.ClipsDescendants = true
	v1_91.Parent = v1_69
	do
		local v2_92 = Instance.new("CanvasGroup")
		v2_92.Name = "ScrollHint"
		v2_92.AnchorPoint = Vector2.new(0.5, 1)
		v2_92.Position = UDim2.new(0.5, -1, 1, -6)
		v2_92.Size = UDim2.new(0, 22, 0, 22)
		v2_92.BackgroundTransparency = 1
		v2_92.BorderSizePixel = 0
		v2_92.GroupTransparency = 1
		v2_92.Visible = false
		v2_92.Active = false
		v2_92.ZIndex = 10
		v2_92.Parent = v1_91
		local v2_93 = Instance.new("ImageLabel")
		v2_93.Name = "Icon"
		v2_93.AnchorPoint = Vector2.new(0.5, 0.5)
		v2_93.Position = UDim2.new(0.5, 0, 0.5, -3)
		v2_93.Size = UDim2.new(0, 16, 0, 16)
		v2_93.BackgroundTransparency = 1
		v2_93.BorderSizePixel = 0
		v2_93.ImageColor3 = v0_7.SubText
		v2_93.ScaleType = Enum.ScaleType.Fit
		v2_93.Active = false
		v2_93.Parent = v2_92
		local v2_94 = Instance.new("TextLabel")
		v2_94.Name = "IconFallback"
		v2_94.Size = UDim2.new(1, 0, 1, 0)
		v2_94.BackgroundTransparency = 1
		v2_94.Text = "▼"
		v2_94.TextColor3 = v0_7.SubText
		v2_94.Font = Enum.Font.Gotham
		v2_94.TextSize = 11
		v2_94.Parent = v2_93
		v2_94.Visible = not v0_42(v2_93, "chevron-down", v1_66.Icons)
		local v2_95 = v0_5:Create(
			v2_93,
			TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ Position = UDim2.new(0.5, 0, 0.5, 3) }
		)
		local v2_96 = Instance.new("TextButton")
		v2_96.Name = "Click"
		v2_96.Size = UDim2.new(1, 0, 1, 0)
		v2_96.BackgroundTransparency = 1
		v2_96.BorderSizePixel = 0
		v2_96.Text = ""
		v2_96.AutoButtonColor = false
		v2_96.ZIndex = 2
		v2_96.Parent = v2_92
		local v2_97 = UDim2.new(0.5, -1, 1, -34)
		local v2_98 = UDim2.new(0.5, -1, 1, -27)
		local v2_99 = Instance.new("CanvasGroup")
		v2_99.Name = "ScrollHintText"
		v2_99.AnchorPoint = Vector2.new(0.5, 1)
		v2_99.Position = v2_98
		v2_99.Size = UDim2.new(0, 0, 0, 0)
		v2_99.AutomaticSize = Enum.AutomaticSize.XY
		v2_99.BackgroundColor3 = v0_7.Sidebar
		v2_99.BorderSizePixel = 0
		v2_99.GroupTransparency = 1
		v2_99.Visible = false
		v2_99.Active = false
		v2_99.ZIndex = 10
		v2_99.Parent = v1_91
		v0_61(v2_99, 6)
		local v2_100 = Instance.new("UIStroke")
		v2_100.Color = v0_7.Element
		v2_100.Thickness = 1
		v2_100.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		v2_100.Parent = v2_99
		local v2_101 = Instance.new("UIPadding")
		v2_101.PaddingTop = UDim.new(0, 6)
		v2_101.PaddingBottom = UDim.new(0, 6)
		v2_101.PaddingLeft = UDim.new(0, 10)
		v2_101.PaddingRight = UDim.new(0, 10)
		v2_101.Parent = v2_99
		local v2_102 = Instance.new("TextLabel")
		v2_102.Name = "Text"
		v2_102.Size = UDim2.new(0, 0, 0, 0)
		v2_102.AutomaticSize = Enum.AutomaticSize.XY
		v2_102.BackgroundTransparency = 1
		v2_102.BorderSizePixel = 0
		v2_102.Text = "Scroll To See More Features."
		v2_102.TextColor3 = v0_7.Text
		v2_102.Font = Enum.Font.Gotham
		v2_102.TextSize = 12
		v2_102.Parent = v2_99
		local v2_103, v2_104, v2_105 = false, nil, nil
		local function v2_106(v3_107)
			if v2_104 and v2_104 ~= coroutine.running() then
				pcall(task.cancel, v2_104)
			end
			v2_104 = nil
			if not v2_103 then return end
			v2_103 = false
			if v2_105 then v2_105:Cancel() end
			if v3_107 then
				v2_99.GroupTransparency = 1
				v2_99.Visible = false
				return
			end
			local v3_108 = v0_10(v2_99, { GroupTransparency = 1, Position = v2_98 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v2_105 = v3_108
			v3_108.Completed:Connect(function(v4_109)
				if v4_109 == Enum.PlaybackState.Completed and not v2_103 then
					v2_99.Visible = false
				end
			end)
		end
		local function v2_110()
			if v2_103 then return end
			v2_103 = true
			if v2_105 then v2_105:Cancel() end
			if not v2_99.Visible then
				v2_99.Position = v2_98
				v2_99.Visible = true
			end
			v2_105 = v0_10(v2_99, { GroupTransparency = 0, Position = v2_97 }, 0.25, Enum.EasingStyle.Quint)
			v2_104 = task.spawn(function()
				task.wait(3.5)
				v2_104 = nil
				v2_106()
			end)
		end
		v2_96.MouseButton1Click:Connect(function()
			if v2_103 then v2_106() else v2_110() end
		end)
		v1_66._hint = { Frame = v2_92, Icon = v2_93, Bounce = v2_95, Shown = false, HideTip = v2_106 }
	end
	if v1_65.Resizable ~= false then
		local v2_111 = v1_65.MinSize or Vector2.new(380, 260)
		local v2_112 = v1_65.MaxSize
		local v2_113 = Instance.new("TextButton")
		v2_113.Name = "ResizeGrip"
		v2_113.AnchorPoint = Vector2.new(1, 1)
		v2_113.Position = UDim2.new(1, -6, 1, -6)
		v2_113.Size = UDim2.new(0, 22, 0, 22)
		v2_113.BackgroundColor3 = v0_7.Main
		v2_113.BackgroundTransparency = 0.25
		v2_113.BorderSizePixel = 0
		v2_113.Text = ""
		v2_113.AutoButtonColor = false
		v2_113.Parent = v1_69
		v0_61(v2_113, 6)
		local v2_114 = Instance.new("ImageLabel")
		v2_114.Name = "Icon"
		v2_114.AnchorPoint = Vector2.new(0.5, 0.5)
		v2_114.Position = UDim2.new(0.5, 0, 0.5, 0)
		v2_114.Size = UDim2.new(0, 14, 0, 14)
		v2_114.BackgroundTransparency = 1
		v2_114.BorderSizePixel = 0
		v2_114.ImageColor3 = v0_7.IconOff
		v2_114.ScaleType = Enum.ScaleType.Fit
		v2_114.Parent = v2_113
		local v2_115 = Instance.new("TextLabel")
		v2_115.Name = "IconFallback"
		v2_115.Size = UDim2.new(1, 0, 1, 0)
		v2_115.BackgroundTransparency = 1
		v2_115.Text = "⤢"
		v2_115.TextColor3 = v0_7.IconOff
		v2_115.Font = Enum.Font.GothamBold
		v2_115.TextSize = 14
		v2_115.Parent = v2_114
		v2_115.Visible = not v0_42(v2_114, "expand", v1_66.Icons)
		local v2_116 = Instance.new("UIScale")
		v2_116.Parent = v2_113
		local v2_117, v2_118, v2_119 = false, false, nil
		local function v2_120()
			local v3_121 = v2_117 or v2_118
			local v3_122 = v3_121 and v0_7.IconOn or v0_7.IconOff
			v0_10(v2_114, { ImageColor3 = v3_122 }, 0.15)
			v0_10(v2_115, { TextColor3 = v3_122 }, 0.15)
			v0_10(v2_113, { BackgroundColor3 = v3_121 and v0_7.Hover or v0_7.Main }, 0.15)
		end
		local function v2_123()
			if v2_119 then
				for v5_124, v5_125 in ipairs(v2_119) do v5_125:Disconnect() end
				v2_119 = nil
			end
			if v2_118 then
				v2_118 = false
				v2_120()
				v0_10(v2_116, { Scale = v2_117 and 1.1 or 1 }, 0.18, Enum.EasingStyle.Back)
			end
		end
		local function v2_126(v3_127)
			v2_123()
			v2_118 = true
			v2_120()
			v0_10(v2_116, { Scale = 0.9 }, 0.08)
			local v3_128 = v1_70.Scale
			local v3_129 = v3_127.Position
			local v3_130 = v1_69.AbsoluteSize / v3_128
			local v3_131 = v1_69.AbsolutePosition
			v2_119 = {
				v0_4.InputChanged:Connect(function(v4_132)
					if v4_132.UserInputType ~= Enum.UserInputType.MouseMovement and v4_132 ~= v3_127 then return end
					local v4_133 = v4_132.Position - v3_129
					local v4_134 = v1_67.AbsoluteSize
					local v4_135 = math.max(v2_111.X, v4_134.X - v3_131.X - 4)
					local v4_136 = math.max(v2_111.Y, v4_134.Y - v3_131.Y - 4)
					if v2_112 then
						v4_135 = math.max(v2_111.X, math.min(v4_135, v2_112.X))
						v4_136 = math.max(v2_111.Y, math.min(v4_136, v2_112.Y))
					end
					local v4_137 = math.clamp(v3_130.X + v4_133.X / v3_128, v2_111.X, v4_135)
					local v4_138 = math.clamp(v3_130.Y + v4_133.Y / v3_128, v2_111.Y, v4_136)
					v1_68 = UDim2.fromOffset(v4_137, v4_138)
					v1_69.Size = v1_68
					v1_69.Position = UDim2.fromOffset(v3_131.X + v4_137 * v3_128 / 2, v3_131.Y + v4_138 * v3_128 / 2)
				end),
				v0_4.InputEnded:Connect(function(v4_139)
					if v4_139 == v3_127 or v4_139.UserInputType == Enum.UserInputType.MouseButton1 then
						v2_123()
					end
				end),
			}
		end
		v2_113.InputBegan:Connect(function(v3_140)
			if v0_17(v3_140) then v2_126(v3_140) end
		end)
		v2_113.MouseEnter:Connect(function()
			v2_117 = true
			v2_120()
			if not v2_118 then v0_10(v2_116, { Scale = 1.1 }, 0.12) end
		end)
		v2_113.MouseLeave:Connect(function()
			v2_117 = false
			v2_120()
			if not v2_118 then v0_10(v2_116, { Scale = 1 }, 0.12) end
		end)
		v1_66._cleanups[v2_113] = v2_123
	end
	v1_66.ScreenGui, v1_66.Main, v1_66.Sidebar, v1_66.Content = v1_67, v1_69, v1_87, v1_91
	v1_66._scale = v1_70
	v1_66._visible = false
	if v1_65.Watermark ~= false then
		v1_66:_buildWatermark(v1_65.Title or "RobloxUI")
	end
	table.insert(v1_66._connections, v0_4.InputBegan:Connect(function(v2_141, v2_142)
		local v2_143 = v1_66._listening
		if v2_143 then
			if v2_141.UserInputType == Enum.UserInputType.Keyboard then
				if not v0_4:GetFocusedTextBox() then
					v2_143:_capture(v2_141.KeyCode)
				end
			elseif v0_17(v2_141) and not v2_142 then
				v2_143:_stopListening()
			end
			return
		end
		if v2_142 or v2_141.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local v2_144 = v2_141.KeyCode
		if v1_66._toggleKey and v2_144 == v1_66._toggleKey then
			v1_66:Toggle()
			return
		end
		for v3_145, v3_146 in ipairs(table.clone(v1_66._binds)) do
			if v3_146._key == v2_144 and not v3_146._destroyed then
				v3_146._onPress()
			end
		end
	end))
	if v1_65.StartHidden then
		v1_69.Visible = false
		v1_66:_updateWatermark()
	else
		v1_66:Show()
	end
	return v1_66
end
function v0_1:Destroy()
	for v2_147, v2_148 in ipairs(self._connections) do
		v2_148:Disconnect()
	end
	self._connections = {}
	self._destroyed = true
	if self._hint then pcall(self._hint.HideTip, true) end
	for v2_149, v2_150 in ipairs(table.clone(self._notifs or {})) do pcall(v2_150) end
	for v2_151, v2_152 in pairs(self._cleanups) do pcall(v2_152) end
	self._cleanups = {}
	self._binds = {}
	self._listening = nil
	self.ScreenGui:Destroy()
end
local v0_153, v0_154 = 0.35, 0.2
function v0_1:_cancelAnim()
	if self._anim then
		for v3_155, v3_156 in ipairs(self._anim) do v3_156:Cancel() end
		self._anim = nil
	end
end
function v0_1:Show()
	if self._destroyed then return end
	self._visible = true
	self:_cancelAnim()
	self.Main.Visible = true
	self._anim = {
		v0_10(self.Main, { GroupTransparency = 0 }, v0_153, Enum.EasingStyle.Quint),
		v0_10(self._scale, { Scale = 1 }, v0_153, Enum.EasingStyle.Back),
	}
	self:_updateWatermark()
end
function v0_1:Hide()
	if self._destroyed or not self._visible then return end
	self._visible = false
	self:_cancelAnim()
	local v1_157 = v0_4:GetFocusedTextBox()
	if v1_157 and v1_157:IsDescendantOf(self.Main) then v1_157:ReleaseFocus() end
	local v1_158 = v0_10(self.Main, { GroupTransparency = 1 }, v0_154, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local v1_159 = v0_10(self._scale, { Scale = 0.92 }, v0_154, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	self._anim = { v1_158, v1_159 }
	v1_158.Completed:Connect(function(v2_160)
		if v2_160 == Enum.PlaybackState.Completed and not self._visible and not self._destroyed then
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
	local v1_161 = self._hint
	if not v1_161 or self._destroyed then return end
	local v1_162 = self.ActiveTab and self.ActiveTab.Page
	local v1_163 = false
	if v1_162 and v1_162.Visible then
		local v2_164 = v1_162.AbsoluteCanvasSize.Y - (v1_162.CanvasPosition.Y + v1_162.AbsoluteWindowSize.Y)
		v1_163 = v2_164 > 4
	end
	if v1_163 == v1_161.Shown then return end
	v1_161.Shown = v1_163
	if v1_161.Fade then v1_161.Fade:Cancel() end
	if v1_163 then
		v1_161.Frame.Visible = true
		v1_161.Icon.Position = UDim2.new(0.5, 0, 0.5, -3)
		v1_161.Bounce:Play()
		v1_161.Fade = v0_10(v1_161.Frame, { GroupTransparency = 0.15 }, 0.2)
	else
		v1_161.HideTip()
		local v2_165 = v0_10(v1_161.Frame, { GroupTransparency = 1 }, 0.2)
		v1_161.Fade = v2_165
		v2_165.Completed:Connect(function(v3_166)
			if v3_166 == Enum.PlaybackState.Completed and not v1_161.Shown then
				v1_161.Bounce:Cancel()
				v1_161.Frame.Visible = false
			end
		end)
	end
end
function v0_1:_keyTaken(v1_167, v1_168)
	if not v1_167 then return false end
	if v1_167 == self._toggleKey then return true end
	for v2_169, v2_170 in ipairs(self._binds) do
		if v2_170 ~= v1_168 and v2_170._key == v1_167 then return true end
	end
	return false
end
local v0_171, v0_172 = 280, 5
function v0_1:_getNotifyContainer()
	if self._notifyContainer and self._notifyContainer.Parent then
		return self._notifyContainer
	end
	local v1_173 = self.ScreenGui.AbsoluteSize
	local v1_174 = v1_173.X > 0 and math.min(v0_171, v1_173.X - 20) or v0_171
	local v1_175 = Instance.new("Frame")
	v1_175.Name = "Notifications"
	v1_175.AnchorPoint = Vector2.new(0.5, 0)
	v1_175.Position = UDim2.new(0.5, 0, 0, self._wm and 48 or 10)
	v1_175.Size = UDim2.new(0, v1_174, 0, 0)
	v1_175.AutomaticSize = Enum.AutomaticSize.Y
	v1_175.BackgroundTransparency = 1
	v1_175.BorderSizePixel = 0
	v1_175.Parent = self.ScreenGui
	local v1_176 = Instance.new("UIListLayout")
	v1_176.Padding = UDim.new(0, 6)
	v1_176.SortOrder = Enum.SortOrder.LayoutOrder
	v1_176.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_176.Parent = v1_175
	self._notifyContainer = v1_175
	return v1_175
end
function v0_1:Notify(v1_177)
	if self._destroyed then return end
	if type(v1_177) == "string" then v1_177 = { Content = v1_177 } end
	v1_177 = v1_177 or {}
	local v1_178 = tonumber(v1_177.Duration) or 4
	local v1_179 = self:_getNotifyContainer()
	self._notifyCount = (self._notifyCount or 0) + 1
	self._notifs = self._notifs or {}
	local v1_180 = false
	local v1_181 = Instance.new("Frame")
	v1_181.Name = "Notification"
	v1_181.Size = UDim2.new(1, 0, 0, 0)
	v1_181.BackgroundTransparency = 1
	v1_181.BorderSizePixel = 0
	v1_181.LayoutOrder = self._notifyCount
	v1_181.Parent = v1_179
	local v1_182 = Instance.new("CanvasGroup")
	v1_182.Name = "Card"
	v1_182.Size = UDim2.new(1, 0, 0, 0)
	v1_182.AutomaticSize = Enum.AutomaticSize.Y
	v1_182.BackgroundColor3 = v0_7.Sidebar
	v1_182.BorderSizePixel = 0
	v1_182.GroupTransparency = 1
	v1_182.Parent = v1_181
	v0_61(v1_182, 8)
	local v1_183 = Instance.new("UIStroke")
	v1_183.Color = v0_7.Element
	v1_183.Thickness = 1
	v1_183.Transparency = 1
	v1_183.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_183.Parent = v1_182
	local v1_184 = Instance.new("Frame")
	v1_184.Name = "Body"
	v1_184.Size = UDim2.new(1, 0, 0, 0)
	v1_184.AutomaticSize = Enum.AutomaticSize.Y
	v1_184.BackgroundTransparency = 1
	v1_184.BorderSizePixel = 0
	v1_184.Parent = v1_182
	local v1_185 = Instance.new("UIPadding")
	v1_185.PaddingTop = UDim.new(0, 8)
	v1_185.PaddingBottom = UDim.new(0, 8)
	v1_185.PaddingLeft = UDim.new(0, 12)
	v1_185.PaddingRight = UDim.new(0, 12)
	v1_185.Parent = v1_184
	local v1_186 = Instance.new("UISizeConstraint")
	v1_186.MinSize = Vector2.new(0, 30)
	v1_186.Parent = v1_184
	local v1_187 = Instance.new("Frame")
	v1_187.Name = "Texts"
	v1_187.Position = UDim2.new(0, 0, 0, 0)
	v1_187.Size = UDim2.new(1, 0, 0, 0)
	v1_187.AutomaticSize = Enum.AutomaticSize.Y
	v1_187.BackgroundTransparency = 1
	v1_187.BorderSizePixel = 0
	v1_187.Parent = v1_184
	local v1_188 = Instance.new("UIListLayout")
	v1_188.Padding = UDim.new(0, 2)
	v1_188.SortOrder = Enum.SortOrder.LayoutOrder
	v1_188.Parent = v1_187
	local function v1_189(v2_190, v2_191, v2_192, v2_193, v2_194)
		local v2_195 = Instance.new("TextLabel")
		v2_195.Size = UDim2.new(1, 0, 0, 0)
		v2_195.AutomaticSize = Enum.AutomaticSize.Y
		v2_195.BackgroundTransparency = 1
		v2_195.BorderSizePixel = 0
		v2_195.Text = v2_190
		v2_195.TextColor3 = v2_193
		v2_195.Font = v2_191
		v2_195.TextSize = v2_192
		v2_195.TextWrapped = true
		v2_195.TextXAlignment = Enum.TextXAlignment.Left
		v2_195.TextYAlignment = Enum.TextYAlignment.Top
		v2_195.LayoutOrder = v2_194
		v2_195.Parent = v1_187
		return v2_195
	end
	if v1_177.Title and v1_177.Title ~= "" then
		v1_189(tostring(v1_177.Title), Enum.Font.GothamBold, 13, v0_7.Text, 1).Name = "Title"
	end
	if v1_177.Content and v1_177.Content ~= "" then
		v1_189(tostring(v1_177.Content), Enum.Font.Gotham, 12, v0_7.SubText, 2).Name = "Content"
	end
	local v1_196 = Instance.new("TextLabel")
	v1_196.Name = "Countdown"
	v1_196.AnchorPoint = Vector2.new(1, 0.5)
	v1_196.Position = UDim2.new(1, 0, 0.5, 0)
	v1_196.Size = UDim2.new(0, 18, 0, 18)
	v1_196.BackgroundTransparency = 1
	v1_196.BorderSizePixel = 0
	v1_196.Text = tostring(math.ceil(v1_178))
	v1_196.TextColor3 = v0_7.SubText
	v1_196.Font = Enum.Font.GothamBold
	v1_196.TextSize = 13
	v1_196.TextXAlignment = Enum.TextXAlignment.Right
	v1_196.Visible = v1_178 > 0
	v1_196.Parent = v1_184
	if v1_178 > 0 then
		v1_187.Size = UDim2.new(1, -24, 0, 0)
	end
	local v1_197 = Instance.new("TextButton")
	v1_197.Name = "Click"
	v1_197.Size = UDim2.new(1, 0, 1, 0)
	v1_197.BackgroundTransparency = 1
	v1_197.BorderSizePixel = 0
	v1_197.Text = ""
	v1_197.AutoButtonColor = false
	v1_197.Parent = v1_182
	local v1_198, v1_199 = nil, nil
	local v1_200 = {}
	local function v1_201()
		if v1_180 then return end
		v1_180 = true
		local v2_202 = table.find(self._notifs, v1_201)
		if v2_202 then table.remove(self._notifs, v2_202) end
		if v1_198 and v1_198 ~= coroutine.running() then
			pcall(task.cancel, v1_198)
		end
		v1_198 = nil
		if v1_199 then
			v1_199:Disconnect()
			v1_199 = nil
		end
		for v3_203, v3_204 in ipairs(v1_200) do v3_204:Cancel() end
		v1_200 = {}
		if self._destroyed then return end
		v0_10(v1_183, { Transparency = 1 }, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v2_205 = v0_10(v1_182, {
			Position = UDim2.new(0, 0, 0, -20),
			GroupTransparency = 1,
		}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_205.Completed:Connect(function()
			local v3_206 = v0_10(v1_181, { Size = UDim2.new(1, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quint)
			v3_206.Completed:Connect(function()
				v1_181:Destroy()
			end)
		end)
	end
	v1_197.MouseButton1Click:Connect(v1_201)
	table.insert(self._notifs, v1_201)
	while #self._notifs > v0_172 do
		self._notifs[1]()
	end
	local v1_207 = false
	v1_199 = v1_182:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if v1_180 then return end
		local v2_208 = v1_182.AbsoluteSize.Y
		if v2_208 <= 0 then return end
		if not v1_207 then
			v1_207 = true
			table.insert(v1_200, v0_10(v1_181, { Size = UDim2.new(1, 0, 0, v2_208) }, 0.3, Enum.EasingStyle.Quint))
		else
			v1_181.Size = UDim2.new(1, 0, 0, v2_208)
		end
	end)
	v1_182.Position = UDim2.new(0, 0, 0, -(v1_179.AbsolutePosition.Y + v1_179.AbsoluteSize.Y + 90))
	v1_200 = {
		v0_10(v1_182, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back),
		v0_10(v1_182, { GroupTransparency = 0 }, 0.25),
		v0_10(v1_183, { Transparency = 0 }, 0.25),
	}
	if v1_178 > 0 then
		v1_198 = task.spawn(function()
			local v3_209 = os.clock()
			local v3_210 = math.ceil(v1_178)
			while not v1_180 and not self._destroyed do
				local v4_211 = v1_178 - (os.clock() - v3_209)
				local v4_212 = math.max(math.ceil(v4_211), 0)
				if v4_212 ~= v3_210 then
					v3_210 = v4_212
					v1_196.Text = tostring(v4_212)
					v1_196.TextTransparency = 0.6
					v0_10(v1_196, { TextTransparency = 0 }, 0.2)
				end
				if v4_211 <= 0 then
					v1_198 = nil
					v1_201()
					return
				end
				task.wait(v4_211 - (v4_212 - 1))
			end
		end)
	end
	return { Dismiss = v1_201 }
end
function v0_1:_buildWatermark(v1_213)
	local v1_214 = Instance.new("Frame")
	v1_214.Name = "Watermark"
	v1_214.AnchorPoint = Vector2.new(0.5, 0)
	v1_214.Position = UDim2.new(0.5, 0, 0, -40)
	v1_214.Size = UDim2.new(0, 0, 0, 30)
	v1_214.AutomaticSize = Enum.AutomaticSize.X
	v1_214.BackgroundColor3 = v0_7.Sidebar
	v1_214.BorderSizePixel = 0
	v1_214.Parent = self.ScreenGui
	v0_61(v1_214, 8)
	local v1_215 = Instance.new("UIStroke")
	v1_215.Color = v0_7.Element
	v1_215.Thickness = 1
	v1_215.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_215.Parent = v1_214
	local v1_216 = Instance.new("UIPadding")
	v1_216.PaddingLeft = UDim.new(0, 10)
	v1_216.PaddingRight = UDim.new(0, 4)
	v1_216.Parent = v1_214
	local v1_217 = Instance.new("UIListLayout")
	v1_217.FillDirection = Enum.FillDirection.Horizontal
	v1_217.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_217.Padding = UDim.new(0, 8)
	v1_217.SortOrder = Enum.SortOrder.LayoutOrder
	v1_217.Parent = v1_214
	local v1_218 = Instance.new("TextLabel")
	v1_218.Name = "Title"
	v1_218.Size = UDim2.new(0, 0, 1, 0)
	v1_218.AutomaticSize = Enum.AutomaticSize.X
	v1_218.BackgroundTransparency = 1
	v1_218.BorderSizePixel = 0
	v1_218.Text = v1_213
	v1_218.TextColor3 = v0_7.SubText
	v1_218.Font = Enum.Font.GothamBold
	v1_218.TextSize = 13
	v1_218.LayoutOrder = 1
	v1_218.Parent = v1_214
	local v1_219 = Instance.new("TextButton")
	v1_219.Name = "ToggleButton"
	v1_219.Size = UDim2.new(0, 22, 0, 22)
	v1_219.BackgroundColor3 = v0_7.Element
	v1_219.BorderSizePixel = 0
	v1_219.Text = ""
	v1_219.AutoButtonColor = false
	v1_219.LayoutOrder = 2
	v1_219.Parent = v1_214
	v0_61(v1_219, 6)
	local v1_220 = Instance.new("ImageLabel")
	v1_220.Name = "Icon"
	v1_220.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_220.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_220.Size = UDim2.new(0, 14, 0, 14)
	v1_220.BackgroundTransparency = 1
	v1_220.BorderSizePixel = 0
	v1_220.ImageColor3 = v0_7.IconOn
	v1_220.ScaleType = Enum.ScaleType.Fit
	v1_220.Parent = v1_219
	local v1_221 = Instance.new("TextLabel")
	v1_221.Name = "IconFallback"
	v1_221.Size = UDim2.new(1, 0, 1, 0)
	v1_221.BackgroundTransparency = 1
	v1_221.TextColor3 = v0_7.IconOn
	v1_221.Font = Enum.Font.GothamBold
	v1_221.TextSize = 12
	v1_221.Visible = false
	v1_221.Parent = v1_220
	local v1_222 = Instance.new("UIScale")
	v1_222.Parent = v1_219
	v1_219.MouseEnter:Connect(function() v0_10(v1_222, { Scale = 1.1 }, 0.12) end)
	v1_219.MouseLeave:Connect(function() v0_10(v1_222, { Scale = 1 }, 0.12) end)
	v1_219.InputBegan:Connect(function(v2_223)
		if v0_17(v2_223) then v0_10(v1_222, { Scale = 0.9 }, 0.08) end
	end)
	v1_219.InputEnded:Connect(function(v2_224)
		if v0_17(v2_224) then v0_10(v1_222, { Scale = 1.1 }, 0.15, Enum.EasingStyle.Back) end
	end)
	v1_219.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	local v1_225, v1_226, v1_227 = false, nil, nil
	v1_218.InputBegan:Connect(function(v2_228)
		if v0_17(v2_228) then
			v1_225 = true
			v1_226 = v2_228.Position
			v1_227 = v1_214.AbsolutePosition + Vector2.new(v1_214.AbsoluteSize.X / 2, 0)
			v2_228.Changed:Connect(function()
				if v2_228.UserInputState == Enum.UserInputState.End then v1_225 = false end
			end)
		end
	end)
	table.insert(self._connections, v0_4.InputChanged:Connect(function(v2_229)
		if not v1_225 then return end
		if v2_229.UserInputType ~= Enum.UserInputType.MouseMovement and v2_229.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local v2_230 = v2_229.Position - v1_226
		local v2_231 = self.ScreenGui.AbsoluteSize
		local v2_232 = v1_214.AbsoluteSize.X / 2
		local v2_233 = math.clamp(v1_227.X + v2_230.X, v2_232, math.max(v2_231.X - v2_232, v2_232))
		local v2_234 = math.clamp(v1_227.Y + v2_230.Y, 0, math.max(v2_231.Y - v1_214.AbsoluteSize.Y, 0))
		v1_214.Position = UDim2.fromOffset(v2_233, v2_234)
	end))
	self._wm = { Frame = v1_214, Button = v1_219, Icon = v1_220, Fallback = v1_221 }
	v0_10(v1_214, { Position = UDim2.new(0.5, 0, 0, 10) }, 0.5, Enum.EasingStyle.Back)
end
function v0_1:_updateWatermark()
	local v1_235 = self._wm
	if not v1_235 then return end
	local v1_236 = self._visible == true
	v0_10(v1_235.Button, { BackgroundColor3 = v1_236 and v0_7.Accent or v0_7.Element }, 0.2)
	local v1_237 = v0_42(v1_235.Icon, v1_236 and "eye" or "eye-off", self.Icons)
	if not v1_237 then v1_235.Icon.Image = "" end
	v1_235.Fallback.Visible = not v1_237
	v1_235.Fallback.Text = v1_236 and "●" or "○"
	v1_235.Icon.ImageTransparency = 1
	v0_10(v1_235.Icon, { ImageTransparency = 0 }, 0.2)
end
local function v0_238(v1_239, v1_240)
	v0_10(v1_239.Icon, { ImageColor3 = v1_240 }, 0.2)
	if v1_239.Fallback then
		v0_10(v1_239.Fallback, { TextColor3 = v1_240 }, 0.2)
	end
end
function v0_1:AddTab(v1_241)
	v1_241 = v1_241 or {}
	local v1_242 = Instance.new("TextButton")
	v1_242.Name = "TabButton"
	v1_242.Size = UDim2.new(0, 36, 0, 36)
	v1_242.BackgroundColor3 = v0_7.Card
	v1_242.BorderSizePixel = 0
	v1_242.Text = ""
	v1_242.AutoButtonColor = false
	v1_242.LayoutOrder = #self.Tabs + 1
	v1_242.Parent = self.Sidebar
	v0_61(v1_242, 6)
	local v1_243 = Instance.new("ImageLabel")
	v1_243.Name = "Icon"
	v1_243.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_243.Size = UDim2.new(0, 20, 0, 20)
	v1_243.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_243.BackgroundTransparency = 1
	v1_243.BorderSizePixel = 0
	v1_243.ImageColor3 = v0_7.IconOff
	v1_243.ScaleType = Enum.ScaleType.Fit
	v1_243.Parent = v1_242
	local v1_244
	if not v0_42(v1_243, v1_241.Icon, self.Icons) then
		v1_244 = Instance.new("TextLabel")
		v1_244.Name = "IconFallback"
		v1_244.Size = UDim2.new(1, 0, 1, 0)
		v1_244.BackgroundTransparency = 1
		v1_244.Text = string.upper(string.sub(tostring(v1_241.Name or v1_241.Icon or "?"), 1, 1))
		v1_244.TextColor3 = v0_7.IconOff
		v1_244.Font = Enum.Font.GothamBold
		v1_244.TextSize = 16
		v1_244.Parent = v1_243
	end
	local v1_245 = Instance.new("ScrollingFrame")
	v1_245.Name = "Page"
	v1_245.Size = UDim2.new(1, 0, 1, 0)
	v1_245.BackgroundTransparency = 1
	v1_245.BorderSizePixel = 0
	v1_245.ScrollBarThickness = 3
	v1_245.ScrollBarImageColor3 = v0_7.IconOff
	v1_245.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_245.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_245.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_245.Visible = false
	v1_245.Parent = self.Content
	local v1_246 = Instance.new("Frame")
	v1_246.Name = "Inner"
	v1_246.Size = UDim2.new(1, 0, 0, 0)
	v1_246.AutomaticSize = Enum.AutomaticSize.Y
	v1_246.BackgroundTransparency = 1
	v1_246.BorderSizePixel = 0
	v1_246.Parent = v1_245
	local v1_247 = Instance.new("UIPadding")
	v1_247.PaddingTop = UDim.new(0, 12)
	v1_247.PaddingBottom = UDim.new(0, 12)
	v1_247.Parent = v1_246
	local v1_248 = Instance.new("Frame")
	v1_248.Name = "Split"
	v1_248.Position = UDim2.new(0, 12, 0, 0)
	v1_248.Size = UDim2.new(1, -26, 0, 0)
	v1_248.AutomaticSize = Enum.AutomaticSize.Y
	v1_248.BackgroundTransparency = 1
	v1_248.BorderSizePixel = 0
	v1_248.Parent = v1_246
	local v1_249 = Instance.new("UIListLayout")
	v1_249.FillDirection = Enum.FillDirection.Horizontal
	v1_249.Padding = UDim.new(0, 8)
	v1_249.SortOrder = Enum.SortOrder.LayoutOrder
	v1_249.Parent = v1_248
	local function v1_250(v2_251)
		local v2_252 = Instance.new("Frame")
		v2_252.Name = v2_251 == 1 and "Left" or "Right"
		v2_252.Size = UDim2.new(0.5, -4, 0, 0)
		v2_252.AutomaticSize = Enum.AutomaticSize.Y
		v2_252.BackgroundTransparency = 1
		v2_252.BorderSizePixel = 0
		v2_252.LayoutOrder = v2_251
		v2_252.Parent = v1_248
		local v2_253 = Instance.new("UIListLayout")
		v2_253.Padding = UDim.new(0, 8)
		v2_253.SortOrder = Enum.SortOrder.LayoutOrder
		v2_253.Parent = v2_252
		return v2_252
	end
	local v1_254 = setmetatable({
		Page = v1_245,
		Button = v1_242,
		Icon = v1_243,
		Fallback = v1_244,
		Inner = v1_246,
		_icons = self.Icons,
		_lib = self,
		Left = v1_250(1),
		Right = v1_250(2),
		_sectionCount = 0,
	}, v0_2)
	table.insert(self.Tabs, v1_254)
	for v2_255, v2_256 in ipairs({ "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" }) do
		table.insert(self._connections, v1_245:GetPropertyChangedSignal(v2_256):Connect(function()
			if self.ActiveTab == v1_254 then self:_updateScrollHint() end
		end))
	end
	v0_19(v1_242, v0_7.Card, v0_7.Element, function()
		return self.ActiveTab == v1_254
	end)
	v1_242.MouseButton1Click:Connect(function()
		self:SelectTab(v1_254)
	end)
	if not self.ActiveTab then self:SelectTab(v1_254) end
	return v1_254
end
function v0_1:SelectTab(v1_257)
	if self.ActiveTab == v1_257 then return end
	local v1_258 = self.ActiveTab
	self.ActiveTab = v1_257
	if v1_258 then
		v1_258.Page.Visible = false
		v0_10(v1_258.Button, { BackgroundColor3 = v0_7.Card }, 0.2)
		v0_238(v1_258, v0_7.IconOff)
	end
	v1_257.Inner.Position = UDim2.new(0, 0, 0, 14)
	v1_257.Page.Visible = true
	v0_10(v1_257.Inner, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)
	v0_10(v1_257.Button, { BackgroundColor3 = v0_7.Accent }, 0.2)
	v0_238(v1_257, v0_7.IconOn)
	self:_updateScrollHint()
end
function v0_2:AddSection(v1_259, v1_260, v1_261)
	local v1_262 = (v1_260 == "right") and self.Right or self.Left
	local v1_263 = self._lib
	self._sectionCount += 1
	local v1_264 = Instance.new("Frame")
	v1_264.Name = "Section"
	v1_264.Size = UDim2.new(1, 0, 0, 0)
	v1_264.AutomaticSize = Enum.AutomaticSize.Y
	v1_264.BackgroundColor3 = v0_7.Card
	v1_264.BorderSizePixel = 0
	v1_264.LayoutOrder = self._sectionCount
	v1_264.Parent = v1_262
	v0_61(v1_264, 6)
	local v1_265 = Instance.new("UIPadding")
	v1_265.PaddingTop = UDim.new(0, 8)
	v1_265.PaddingBottom = UDim.new(0, 8)
	v1_265.PaddingLeft = UDim.new(0, 8)
	v1_265.PaddingRight = UDim.new(0, 8)
	v1_265.Parent = v1_264
	local v1_266 = Instance.new("UIListLayout")
	v1_266.Padding = UDim.new(0, 6)
	v1_266.SortOrder = Enum.SortOrder.LayoutOrder
	v1_266.Parent = v1_264
	local v1_267 = Instance.new("Frame")
	v1_267.Name = "Body"
	v1_267.Size = UDim2.new(1, 0, 0, 0)
	v1_267.AutomaticSize = Enum.AutomaticSize.Y
	v1_267.BackgroundTransparency = 1
	v1_267.BorderSizePixel = 0
	v1_267.LayoutOrder = 1
	v1_267.Parent = v1_264
	local v1_268 = Instance.new("UIListLayout")
	v1_268.Padding = UDim.new(0, 6)
	v1_268.SortOrder = Enum.SortOrder.LayoutOrder
	v1_268.Parent = v1_267
	local v1_269 = false
	local v1_270 = {}
	local v1_271, v1_272
	local function v1_273()
		local v2_274 = v1_263._scale and v1_263._scale.Scale or 1
		return math.max(v1_268.AbsoluteContentSize.Y / (v2_274 > 0 and v2_274 or 1), 0)
	end
	local function v1_275()
		v1_267.AutomaticSize = Enum.AutomaticSize.Y
		v1_267.Size = UDim2.new(1, 0, 0, 0)
		v1_267.ClipsDescendants = false
	end
	local function v1_276(v2_277, v2_278)
		if v2_277 == v1_269 and not v2_278 then return end
		v1_269 = v2_277
		for v3_279, v3_280 in ipairs(v1_270) do v3_280:Cancel() end
		v1_270 = {}
		if v1_271 then
			if v2_278 then
				v1_271.Rotation = v2_277 and -90 or 0
			else
				v0_10(v1_271, { Rotation = v2_277 and -90 or 0 }, 0.22, Enum.EasingStyle.Quint)
			end
		end
		if v2_278 then
			v1_267.Visible = not v2_277
			v1_266.Padding = UDim.new(0, v2_277 and 0 or 6)
			v1_275()
			return
		end
		v1_267.ClipsDescendants = true
		if v2_277 then
			if v1_267.AutomaticSize ~= Enum.AutomaticSize.None then
				local v4_281 = v1_273()
				v1_267.AutomaticSize = Enum.AutomaticSize.None
				v1_267.Size = UDim2.new(1, 0, 0, v4_281)
			end
			local v3_282 = v0_10(v1_267, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Quint)
			v1_270 = { v3_282, v0_10(v1_266, { Padding = UDim.new(0, 0) }, 0.25, Enum.EasingStyle.Quint) }
			v3_282.Completed:Connect(function(v4_283)
				if v4_283 == Enum.PlaybackState.Completed and v1_269 then
					v1_267.Visible = false
					v1_267.ClipsDescendants = false
				end
			end)
		else
			v1_267.Visible = true
			local v3_284 = v1_273()
			if v3_284 <= 0 then
				v1_266.Padding = UDim.new(0, 6)
				v1_275()
				return
			end
			if v1_267.AutomaticSize ~= Enum.AutomaticSize.None then
				v1_267.AutomaticSize = Enum.AutomaticSize.None
				v1_267.Size = UDim2.new(1, 0, 0, 0)
			end
			local v3_285 = v0_10(v1_267, { Size = UDim2.new(1, 0, 0, v3_284) }, 0.28, Enum.EasingStyle.Quint)
			v1_270 = { v3_285, v0_10(v1_266, { Padding = UDim.new(0, 6) }, 0.28, Enum.EasingStyle.Quint) }
			v3_285.Completed:Connect(function(v4_286)
				if v4_286 == Enum.PlaybackState.Completed and not v1_269 then
					v1_275()
				end
			end)
		end
	end
	if v1_259 then
		local v2_287 = Instance.new("TextButton")
		v2_287.Name = "Header"
		v2_287.Size = UDim2.new(1, 0, 0, 16)
		v2_287.BackgroundTransparency = 1
		v2_287.BorderSizePixel = 0
		v2_287.Text = ""
		v2_287.AutoButtonColor = false
		v2_287.LayoutOrder = 0
		v2_287.Parent = v1_264
		local v2_288 = Instance.new("TextLabel")
		v2_288.Name = "Title"
		v2_288.Size = UDim2.new(1, -22, 1, 0)
		v2_288.BackgroundTransparency = 1
		v2_288.BorderSizePixel = 0
		v2_288.Text = v1_259
		v2_288.TextColor3 = v0_7.SubText
		v2_288.Font = Enum.Font.GothamBold
		v2_288.TextSize = 13
		v2_288.TextXAlignment = Enum.TextXAlignment.Left
		v2_288.TextTruncate = Enum.TextTruncate.AtEnd
		v2_288.Parent = v2_287
		v1_271 = Instance.new("ImageLabel")
		v1_271.Name = "Chevron"
		v1_271.AnchorPoint = Vector2.new(1, 0.5)
		v1_271.Position = UDim2.new(1, 0, 0.5, 0)
		v1_271.Size = UDim2.new(0, 14, 0, 14)
		v1_271.BackgroundTransparency = 1
		v1_271.BorderSizePixel = 0
		v1_271.ImageColor3 = v0_7.SubText
		v1_271.ScaleType = Enum.ScaleType.Fit
		v1_271.Parent = v2_287
		v1_272 = Instance.new("TextLabel")
		v1_272.Name = "ChevronFallback"
		v1_272.Size = UDim2.new(1, 0, 1, 0)
		v1_272.BackgroundTransparency = 1
		v1_272.Text = "▼"
		v1_272.TextColor3 = v0_7.SubText
		v1_272.Font = Enum.Font.Gotham
		v1_272.TextSize = 9
		v1_272.Parent = v1_271
		v1_272.Visible = not v0_42(v1_271, "chevron-down", self._icons)
		v2_287.MouseEnter:Connect(function()
			v0_10(v2_288, { TextColor3 = v0_7.Text }, 0.12)
			v0_10(v1_271, { ImageColor3 = v0_7.Text }, 0.12)
			v0_10(v1_272, { TextColor3 = v0_7.Text }, 0.12)
		end)
		v2_287.MouseLeave:Connect(function()
			v0_10(v2_288, { TextColor3 = v0_7.SubText }, 0.15)
			v0_10(v1_271, { ImageColor3 = v0_7.SubText }, 0.15)
			v0_10(v1_272, { TextColor3 = v0_7.SubText }, 0.15)
		end)
		v2_287.MouseButton1Click:Connect(function()
			v1_276(not v1_269)
		end)
	end
	local v1_289 = setmetatable({
		Holder = v1_267,
		Card = v1_264,
		_count = 0,
		_icons = self._icons,
		_lib = self._lib,
		_setCollapsed = v1_276,
		_isCollapsed = function() return v1_269 end,
	}, v0_3)
	if v1_259 and v1_261 == true then
		v1_276(true, true)
	end
	return v1_289
end
function v0_3:SetCollapsed(v1_290)
	self._setCollapsed(v1_290 == true)
end
function v0_3:ToggleCollapsed()
	self._setCollapsed(not self._isCollapsed())
end
function v0_3:IsCollapsed()
	return self._isCollapsed()
end
local function v0_291(v1_292)
	if typeof(v1_292) == "EnumItem" and v1_292.EnumType == Enum.KeyCode then return v1_292 end
	if type(v1_292) == "string" then
		local v2_293, v2_294 = pcall(function() return Enum.KeyCode[v1_292] end)
		if v2_293 then return v2_294 end
	end
	return nil
end
local function v0_295(v1_296, v1_297, v1_298, v1_299, v1_300)
	v1_298 = v1_298 or {}
	local v1_301 = v1_298.CanBeChanged ~= false
	local v1_302 = {}
	local v1_303 = { _key = nil, _onPress = v1_300, _isListening = false, _destroyed = false }
	local v1_304 = Instance.new("TextButton")
	v1_304.Name = "Keybind"
	v1_304.AnchorPoint = Vector2.new(1, 0.5)
	v1_304.Position = v1_299
	v1_304.Size = UDim2.new(0, 0, 0, 20)
	v1_304.AutomaticSize = Enum.AutomaticSize.X
	v1_304.BackgroundColor3 = v0_7.Card
	v1_304.BorderSizePixel = 0
	v1_304.Text = "None"
	v1_304.TextColor3 = v0_7.SubText
	v1_304.Font = Enum.Font.Gotham
	v1_304.TextSize = 12
	v1_304.TextTruncate = Enum.TextTruncate.AtEnd
	v1_304.AutoButtonColor = false
	v1_304.Parent = v1_297
	v0_61(v1_304, 5)
	v1_303.Instance = v1_304
	local v1_305 = Instance.new("UIPadding")
	v1_305.PaddingLeft = UDim.new(0, 7)
	v1_305.PaddingRight = UDim.new(0, 7)
	v1_305.Parent = v1_304
	local v1_306 = Instance.new("UISizeConstraint")
	v1_306.MinSize = Vector2.new(30, 20)
	v1_306.MaxSize = Vector2.new(96, 20)
	v1_306.Parent = v1_304
	local function v1_307()
		if v1_303._isListening then
			v1_304.Text = "..."
		else
			v1_304.Text = v1_303._key and v1_303._key.Name or "None"
		end
	end
	local function v1_308()
		v1_304.BackgroundColor3 = v0_7.Danger
		v0_10(v1_304, { BackgroundColor3 = v0_7.Card }, 0.45)
	end
	function v1_303:Set(v2_309, v2_310)
		v2_309 = v0_291(v2_309)
		if v2_309 and v1_296:_keyTaken(v2_309, v1_303) then
			warn("[RobloxUI] key already in use:", v2_309.Name)
			v1_308()
			return false
		end
		v1_303._key = v2_309
		v1_307()
		if not v2_310 and v1_298.Callback then v1_298.Callback(v2_309) end
		return true
	end
	function v1_303:Get()
		return v1_303._key
	end
	function v1_303:_startListening()
		if v1_296._listening and v1_296._listening ~= v1_303 then
			v1_296._listening:_stopListening()
		end
		v1_296._listening = v1_303
		v1_303._isListening = true
		v0_10(v1_304, { BackgroundColor3 = v0_7.Accent }, 0.15)
		v1_307()
	end
	function v1_303:_stopListening()
		if v1_296._listening == v1_303 then v1_296._listening = nil end
		v1_303._isListening = false
		v0_10(v1_304, { BackgroundColor3 = v0_7.Card }, 0.15)
		v1_307()
	end
	function v1_303:_capture(v2_311)
		if v2_311 == Enum.KeyCode.Unknown then return end
		v1_303:_stopListening()
		if v2_311 == Enum.KeyCode.Escape then return end
		if v2_311 == Enum.KeyCode.Backspace or v2_311 == Enum.KeyCode.Delete then
			v1_303:Set(nil)
		else
			v1_303:Set(v2_311)
		end
	end
	function v1_303:Destroy()
		if v1_303._destroyed then return end
		v1_303._destroyed = true
		if v1_296._listening == v1_303 then v1_296._listening = nil end
		local v2_312 = table.find(v1_296._binds, v1_303)
		if v2_312 then table.remove(v1_296._binds, v2_312) end
		v1_296._cleanups[v1_303] = nil
		for v3_313, v3_314 in ipairs(v1_302) do v3_314:Disconnect() end
		v1_302 = {}
		v1_304:Destroy()
	end
	if v1_301 then
		v0_19(v1_304, v0_7.Card, v0_7.Sidebar, function() return v1_303._isListening end)
		table.insert(v1_302, v1_304.MouseButton1Click:Connect(function()
			if v1_303._isListening then v1_303:_stopListening() else v1_303:_startListening() end
		end))
		table.insert(v1_302, v1_304.MouseButton2Click:Connect(function()
			if v1_303._isListening then v1_303:_stopListening() end
			v1_303:Set(nil)
		end))
	end
	if v1_298.Key ~= nil then
		v1_303:Set(v1_298.Key, true)
	end
	table.insert(v1_296._binds, v1_303)
	v1_296._cleanups[v1_303] = function() v1_303:Destroy() end
	return v1_303
end
local function v0_315(v1_316, v1_317, v1_318)
	local v1_319 = v1_317.Instance
	local function v1_320()
		local v2_321 = math.clamp(v1_319.TextBounds.X + 14, 30, 96)
		v1_316.Size = UDim2.new(1, -(v1_318 + v2_321 + 6), 1, 0)
	end
	v1_320()
	v1_319:GetPropertyChangedSignal("TextBounds"):Connect(v1_320)
end
function v0_3:AddButton(v1_322)
	v1_322 = v1_322 or {}
	self._count += 1
	local v1_323 = Instance.new("TextButton")
	v1_323.Name = "Button"
	v1_323.Size = UDim2.new(1, 0, 0, 32)
	v1_323.BackgroundColor3 = v0_7.Element
	v1_323.BorderSizePixel = 0
	v1_323.Text = v1_322.Name or "Button"
	v1_323.TextColor3 = v0_7.Text
	v1_323.Font = Enum.Font.Gotham
	v1_323.TextSize = 14
	v1_323.TextTruncate = Enum.TextTruncate.AtEnd
	v1_323.AutoButtonColor = false
	v1_323.LayoutOrder = self._count
	v1_323.Parent = self.Holder
	v0_61(v1_323, 6)
	local v1_324 = Instance.new("UIPadding")
	v1_324.PaddingLeft = UDim.new(0, 8)
	v1_324.PaddingRight = UDim.new(0, 8)
	v1_324.Parent = v1_323
	v0_19(v1_323, v0_7.Element, v0_7.Hover)
	v1_323.MouseButton1Click:Connect(function()
		v1_323.BackgroundColor3 = v0_7.Accent
		v0_10(v1_323, { BackgroundColor3 = v0_7.Hover }, 0.3)
		if v1_322.Callback then v1_322.Callback() end
	end)
	return v1_323
end
function v0_3:AddToggle(v1_325)
	v1_325 = v1_325 or {}
	self._count += 1
	local v1_326 = v1_325.Default == true
	local v1_327 = self
	local v1_328 = Instance.new("TextButton")
	v1_328.Name = "Toggle"
	v1_328.Size = UDim2.new(1, 0, 0, 32)
	v1_328.BackgroundColor3 = v0_7.Element
	v1_328.BorderSizePixel = 0
	v1_328.Text = ""
	v1_328.AutoButtonColor = false
	v1_328.LayoutOrder = self._count
	v1_328.Parent = self.Holder
	v0_61(v1_328, 6)
	v0_19(v1_328, v0_7.Element, v0_7.Hover)
	local v1_329 = Instance.new("TextLabel")
	v1_329.Name = "Label"
	v1_329.Position = UDim2.new(0, 8, 0, 0)
	v1_329.Size = UDim2.new(1, -60, 1, 0)
	v1_329.BackgroundTransparency = 1
	v1_329.BorderSizePixel = 0
	v1_329.Text = v1_325.Name or "Toggle"
	v1_329.TextColor3 = v0_7.Text
	v1_329.Font = Enum.Font.Gotham
	v1_329.TextSize = 14
	v1_329.TextXAlignment = Enum.TextXAlignment.Left
	v1_329.TextTruncate = Enum.TextTruncate.AtEnd
	v1_329.Parent = v1_328
	local v1_330 = Instance.new("Frame")
	v1_330.Name = "Track"
	v1_330.AnchorPoint = Vector2.new(1, 0.5)
	v1_330.Position = UDim2.new(1, -8, 0.5, 0)
	v1_330.Size = UDim2.new(0, 34, 0, 18)
	v1_330.BackgroundColor3 = v0_7.Off
	v1_330.BorderSizePixel = 0
	v1_330.Parent = v1_328
	v0_61(v1_330, 9)
	local v1_331 = Instance.new("Frame")
	v1_331.Name = "Knob"
	v1_331.AnchorPoint = Vector2.new(0, 0.5)
	v1_331.Position = UDim2.new(0, 2, 0.5, 0)
	v1_331.Size = UDim2.new(0, 14, 0, 14)
	v1_331.BackgroundColor3 = v0_7.Text
	v1_331.BorderSizePixel = 0
	v1_331.Parent = v1_330
	v0_61(v1_331, 7)
	local function v1_332(v2_333)
		local v2_334 = TweenInfo.new(v2_333 and 0.15 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		v0_5:Create(v1_330, v2_334, { BackgroundColor3 = v1_326 and v0_7.Accent or v0_7.Off }):Play()
		v0_5:Create(v1_331, v2_334, {
			Position = v1_326 and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}):Play()
	end
	v1_332(false)
	local v1_335 = { Instance = v1_328 }
	function v1_335:Set(v2_336, v2_337)
		v1_326 = v2_336 and true or false
		v1_332(true)
		if not v2_337 and v1_325.Callback then v1_325.Callback(v1_326) end
	end
	function v1_335:Get()
		return v1_326
	end
	v1_328.MouseButton1Click:Connect(function()
		v1_335:Set(not v1_326)
	end)
	function v1_335:AddKeybind(v2_338)
		if v1_335.Keybind then
			warn("[RobloxUI] this toggle already has a keybind")
			return v1_335.Keybind
		end
		local v2_339 = v0_295(v1_327._lib, v1_328, v2_338, UDim2.new(1, -48, 0.5, 0), function()
			v1_335:Set(not v1_326)
		end)
		v0_315(v1_329, v2_339, 60)
		local v2_340 = v2_339.Destroy
		function v2_339:Destroy()
			v2_340(v2_339)
			v1_335.Keybind = nil
			v1_329.Size = UDim2.new(1, -60, 1, 0)
		end
		v1_335.Keybind = v2_339
		return v2_339
	end
	function v1_335:Destroy()
		if v1_335._destroyed then return end
		v1_335._destroyed = true
		if v1_335.Keybind then v1_335.Keybind:Destroy() end
		v1_328:Destroy()
	end
	return v1_335
end
function v0_3:AddParagraph(v1_341)
	v1_341 = v1_341 or {}
	self._count += 1
	local v1_342 = v1_341.Title and tostring(v1_341.Title) or ""
	local v1_343 = v1_341.Content and tostring(v1_341.Content) or ""
	local v1_344 = Instance.new("Frame")
	v1_344.Name = "Paragraph"
	v1_344.Size = UDim2.new(1, 0, 0, 0)
	v1_344.AutomaticSize = Enum.AutomaticSize.Y
	v1_344.BackgroundColor3 = v0_7.Element
	v1_344.BorderSizePixel = 0
	v1_344.LayoutOrder = self._count
	v1_344.Parent = self.Holder
	v0_61(v1_344, 6)
	local v1_345 = Instance.new("UIPadding")
	v1_345.PaddingTop = UDim.new(0, 8)
	v1_345.PaddingBottom = UDim.new(0, 8)
	v1_345.PaddingLeft = UDim.new(0, 8)
	v1_345.PaddingRight = UDim.new(0, 8)
	v1_345.Parent = v1_344
	local v1_346 = Instance.new("UIListLayout")
	v1_346.Padding = UDim.new(0, 3)
	v1_346.SortOrder = Enum.SortOrder.LayoutOrder
	v1_346.Parent = v1_344
	local function v1_347(v2_348, v2_349, v2_350, v2_351, v2_352)
		local v2_353 = Instance.new("TextLabel")
		v2_353.Name = v2_348
		v2_353.Size = UDim2.new(1, 0, 0, 0)
		v2_353.AutomaticSize = Enum.AutomaticSize.Y
		v2_353.BackgroundTransparency = 1
		v2_353.BorderSizePixel = 0
		v2_353.TextColor3 = v2_351
		v2_353.Font = v2_349
		v2_353.TextSize = v2_350
		v2_353.TextWrapped = true
		v2_353.RichText = v1_341.RichText == true
		v2_353.TextXAlignment = Enum.TextXAlignment.Left
		v2_353.TextYAlignment = Enum.TextYAlignment.Top
		v2_353.LayoutOrder = v2_352
		v2_353.Parent = v1_344
		return v2_353
	end
	local v1_354 = v1_347("Title", Enum.Font.GothamBold, 14, v0_7.Text, 1)
	local v1_355 = v1_347("Content", Enum.Font.Gotham, 13, v0_7.SubText, 2)
	local function v1_356(v2_357)
		v1_354.Text = v1_342
		v1_354.Visible = v1_342 ~= ""
		v1_355.Text = v1_343
		v1_355.Visible = v1_343 ~= ""
		if v2_357 then
			v1_354.TextTransparency = 1
			v1_355.TextTransparency = 1
			v0_10(v1_354, { TextTransparency = 0 }, 0.2)
			v0_10(v1_355, { TextTransparency = 0 }, 0.2)
		end
	end
	v1_356(false)
	local v1_358 = { Instance = v1_344 }
	function v1_358:SetTitle(v2_359)
		v1_342 = v2_359 and tostring(v2_359) or ""
		v1_356(true)
	end
	function v1_358:SetContent(v2_360)
		v1_343 = v2_360 and tostring(v2_360) or ""
		v1_356(true)
	end
	function v1_358:Set(v2_361)
		v2_361 = v2_361 or {}
		if v2_361.Title ~= nil then v1_342 = tostring(v2_361.Title) end
		if v2_361.Content ~= nil then v1_343 = tostring(v2_361.Content) end
		v1_356(true)
	end
	function v1_358:Get()
		return v1_342, v1_343
	end
	function v1_358:Destroy()
		v1_344:Destroy()
	end
	return v1_358
end
function v0_3:AddTextbox(v1_362)
	v1_362 = v1_362 or {}
	self._count += 1
	local v1_363 = v1_362.Numeric == true
	local v1_364 = tonumber(v1_362.MaxLength)
	local v1_365 = v1_362.Name ~= nil and v1_362.Name ~= ""
	local v1_366, v1_367, v1_368 = false, false, false
	local function v1_369(v2_370)
		if v1_362.Min then v2_370 = math.max(v2_370, v1_362.Min) end
		if v1_362.Max then v2_370 = math.min(v2_370, v1_362.Max) end
		return v2_370
	end
	local v1_371
	if v1_363 then
		v1_371 = tonumber(v1_362.Default)
		if v1_371 then v1_371 = v1_369(v1_371) end
	else
		v1_371 = tostring(v1_362.Default or "")
	end
	local function v1_372(v2_373)
		return v2_373 == nil and "" or tostring(v2_373)
	end
	local function v1_374(v2_375)
		local v2_376 = v2_375:sub(1, 1) == "-"
		v2_375 = v2_375:gsub("[^%d%.]", "")
		local v2_377 = v2_375:find(".", 1, true)
		if v2_377 then
			local v3_378 = v2_375:sub(v2_377 + 1):gsub("%.", "")
			v2_375 = v2_375:sub(1, v2_377) .. v3_378
		end
		return (v2_376 and "-" or "") .. v2_375
	end
	local v1_379 = Instance.new("Frame")
	v1_379.Name = "Textbox"
	v1_379.Size = UDim2.new(1, 0, 0, 32)
	v1_379.BackgroundColor3 = v0_7.Element
	v1_379.BorderSizePixel = 0
	v1_379.LayoutOrder = self._count
	v1_379.Parent = self.Holder
	v0_61(v1_379, 6)
	if v1_365 then
		local v2_380 = Instance.new("TextLabel")
		v2_380.Name = "Label"
		v2_380.Position = UDim2.new(0, 8, 0, 0)
		v2_380.Size = UDim2.new(0.4, -8, 1, 0)
		v2_380.BackgroundTransparency = 1
		v2_380.BorderSizePixel = 0
		v2_380.Text = v1_362.Name
		v2_380.TextColor3 = v0_7.Text
		v2_380.Font = Enum.Font.Gotham
		v2_380.TextSize = 14
		v2_380.TextXAlignment = Enum.TextXAlignment.Left
		v2_380.TextTruncate = Enum.TextTruncate.AtEnd
		v2_380.Parent = v1_379
	end
	local v1_381 = Instance.new("Frame")
	v1_381.Name = "BoxHolder"
	v1_381.AnchorPoint = Vector2.new(1, 0.5)
	v1_381.Position = UDim2.new(1, -6, 0.5, 0)
	v1_381.Size = v1_365 and UDim2.new(0.6, -10, 0, 22) or UDim2.new(1, -12, 0, 22)
	v1_381.BackgroundColor3 = v0_7.Card
	v1_381.BorderSizePixel = 0
	v1_381.Parent = v1_379
	v0_61(v1_381, 5)
	local v1_382 = Instance.new("UIStroke")
	v1_382.Color = v0_7.Accent
	v1_382.Thickness = 1
	v1_382.Transparency = 1
	v1_382.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_382.Parent = v1_381
	local v1_383 = Instance.new("TextBox")
	v1_383.Name = "Input"
	v1_383.Size = UDim2.new(1, 0, 1, 0)
	v1_383.BackgroundTransparency = 1
	v1_383.BorderSizePixel = 0
	v1_383.Text = v1_372(v1_371)
	v1_383.PlaceholderText = v1_362.Placeholder or ""
	v1_383.PlaceholderColor3 = v0_7.IconOff
	v1_383.TextColor3 = v0_7.Text
	v1_383.Font = Enum.Font.Gotham
	v1_383.TextSize = 13
	v1_383.TextXAlignment = Enum.TextXAlignment.Left
	v1_383.ClearTextOnFocus = v1_362.ClearTextOnFocus == true
	v1_383.ClipsDescendants = true
	v1_383.Parent = v1_381
	local v1_384 = Instance.new("UIPadding")
	v1_384.PaddingLeft = UDim.new(0, 6)
	v1_384.PaddingRight = UDim.new(0, 6)
	v1_384.Parent = v1_383
	local function v1_385()
		v0_10(v1_381, { BackgroundColor3 = (v1_367 and not v1_366) and v0_7.Sidebar or v0_7.Card }, 0.12)
		v0_10(v1_382, { Transparency = v1_366 and 0 or 1 }, 0.15)
	end
	v1_383:GetPropertyChangedSignal("Text"):Connect(function()
		if v1_368 then return end
		local v2_386 = v1_383.Text
		if v1_363 then v2_386 = v1_374(v2_386) end
		if v1_364 and #v2_386 > v1_364 then v2_386 = v2_386:sub(1, v1_364) end
		if v2_386 ~= v1_383.Text then
			v1_368 = true
			v1_383.Text = v2_386
			v1_368 = false
		end
	end)
	v1_383.Focused:Connect(function()
		v1_366 = true
		v1_385()
	end)
	v1_383.FocusLost:Connect(function(v2_387)
		v1_366 = false
		v1_385()
		if v1_363 then
			local v3_388 = tonumber(v1_383.Text)
			if v3_388 == nil then
				v1_383.Text = v1_372(v1_371)
				return
			end
			v3_388 = v1_369(v3_388)
			v1_371 = v3_388
			v1_383.Text = v1_372(v3_388)
		else
			v1_371 = v1_383.Text
		end
		if v1_362.Callback then v1_362.Callback(v1_371, v2_387) end
	end)
	v1_381.MouseEnter:Connect(function()
		v1_367 = true
		v1_385()
	end)
	v1_381.MouseLeave:Connect(function()
		v1_367 = false
		v1_385()
	end)
	local v1_389 = { Instance = v1_379 }
	function v1_389:Set(v2_390, v2_391)
		if v1_363 then
			local v3_392 = tonumber(v2_390)
			if v3_392 == nil then return end
			v1_371 = v1_369(v3_392)
		else
			v1_371 = tostring(v2_390 == nil and "" or v2_390)
			if v1_364 then v1_371 = v1_371:sub(1, v1_364) end
		end
		v1_383.Text = v1_372(v1_371)
		if not v2_391 and v1_362.Callback then v1_362.Callback(v1_371, false) end
	end
	function v1_389:Get()
		return v1_371
	end
	function v1_389:Focus()
		v1_383:CaptureFocus()
	end
	function v1_389:Destroy()
		if v1_383:IsFocused() then v1_383:ReleaseFocus() end
		v1_379:Destroy()
	end
	return v1_389
end
function v0_3:AddKeybind(v1_393)
	v1_393 = v1_393 or {}
	self._count += 1
	local v1_394 = Instance.new("Frame")
	v1_394.Name = "KeybindRow"
	v1_394.Size = UDim2.new(1, 0, 0, 32)
	v1_394.BackgroundColor3 = v0_7.Element
	v1_394.BorderSizePixel = 0
	v1_394.LayoutOrder = self._count
	v1_394.Parent = self.Holder
	v0_61(v1_394, 6)
	local v1_395 = Instance.new("TextLabel")
	v1_395.Name = "Label"
	v1_395.Position = UDim2.new(0, 8, 0, 0)
	v1_395.Size = UDim2.new(1, -60, 1, 0)
	v1_395.BackgroundTransparency = 1
	v1_395.BorderSizePixel = 0
	v1_395.Text = v1_393.Name or "Keybind"
	v1_395.TextColor3 = v0_7.Text
	v1_395.Font = Enum.Font.Gotham
	v1_395.TextSize = 14
	v1_395.TextXAlignment = Enum.TextXAlignment.Left
	v1_395.TextTruncate = Enum.TextTruncate.AtEnd
	v1_395.Parent = v1_394
	local v1_396 = v0_295(self._lib, v1_394, v1_393, UDim2.new(1, -8, 0.5, 0), function()
		if v1_393.OnPress then v1_393.OnPress() end
	end)
	v0_315(v1_395, v1_396, 16)
	v1_396.Row = v1_394
	local v1_397 = v1_396.Destroy
	function v1_396:Destroy()
		v1_397(v1_396)
		v1_394:Destroy()
	end
	return v1_396
end
function v0_3:AddSlider(v1_398)
	v1_398 = v1_398 or {}
	self._count += 1
	local v1_399 = self._lib
	local function v1_400(v2_401)
		return #(tostring(v2_401):match("%.(%d+)") or "")
	end
	local v1_402 = tonumber(v1_398.Min) or 0
	local v1_403 = tonumber(v1_398.Max) or 100
	if v1_403 < v1_402 then v1_402, v1_403 = v1_403, v1_402 end
	local v1_404 = tonumber(v1_398.Increment) or 1
	if v1_404 <= 0 then v1_404 = 1 end
	local v1_405 = math.max(v1_400(v1_404), v1_400(v1_402))
	local v1_406 = v1_398.ValueName
	local function v1_407(v2_408)
		v2_408 = math.clamp(v2_408, v1_402, v1_403)
		v2_408 = v1_402 + math.floor((v2_408 - v1_402) / v1_404 + 0.5) * v1_404
		v2_408 = math.clamp(v2_408, v1_402, v1_403)
		local v2_409 = 10 ^ v1_405
		return math.floor(v2_408 * v2_409 + 0.5) / v2_409
	end
	local function v1_410(v2_411)
		return v1_403 > v1_402 and (v2_411 - v1_402) / (v1_403 - v1_402) or 0
	end
	local function v1_412(v2_413)
		local v2_414 = v1_405 > 0 and string.format("%." .. v1_405 .. "f", v2_413) or tostring(v2_413)
		if v1_406 and v1_406 ~= "" then v2_414 = v2_414 .. " " .. tostring(v1_406) end
		return v2_414
	end
	local v1_415 = v1_407(tonumber(v1_398.Default) or v1_402)
	local v1_416, v1_417 = false, false
	local v1_418 = nil
	local v1_419 = Instance.new("Frame")
	v1_419.Name = "Slider"
	v1_419.Size = UDim2.new(1, 0, 0, 46)
	v1_419.BackgroundColor3 = v0_7.Element
	v1_419.BorderSizePixel = 0
	v1_419.LayoutOrder = self._count
	v1_419.Parent = self.Holder
	v0_61(v1_419, 6)
	local v1_420 = Instance.new("TextLabel")
	v1_420.Name = "Name"
	v1_420.Position = UDim2.new(0, 8, 0, 6)
	v1_420.Size = UDim2.new(0.6, -8, 0, 16)
	v1_420.BackgroundTransparency = 1
	v1_420.BorderSizePixel = 0
	v1_420.Text = v1_398.Name or "Slider"
	v1_420.TextColor3 = v0_7.Text
	v1_420.Font = Enum.Font.Gotham
	v1_420.TextSize = 14
	v1_420.TextXAlignment = Enum.TextXAlignment.Left
	v1_420.TextTruncate = Enum.TextTruncate.AtEnd
	v1_420.Parent = v1_419
	local v1_421 = Instance.new("TextLabel")
	v1_421.Name = "Value"
	v1_421.Position = UDim2.new(0.6, 0, 0, 6)
	v1_421.Size = UDim2.new(0.4, -8, 0, 16)
	v1_421.BackgroundTransparency = 1
	v1_421.BorderSizePixel = 0
	v1_421.Text = v1_412(v1_415)
	v1_421.TextColor3 = v0_7.SubText
	v1_421.Font = Enum.Font.GothamBold
	v1_421.TextSize = 13
	v1_421.TextXAlignment = Enum.TextXAlignment.Right
	v1_421.TextTruncate = Enum.TextTruncate.AtEnd
	v1_421.Parent = v1_419
	local v1_422 = Instance.new("Frame")
	v1_422.Name = "Track"
	v1_422.Position = UDim2.new(0, 8, 0, 31)
	v1_422.Size = UDim2.new(1, -16, 0, 6)
	v1_422.BackgroundColor3 = v0_7.Off
	v1_422.BorderSizePixel = 0
	v1_422.Parent = v1_419
	local v1_423 = Instance.new("Frame")
	v1_423.Name = "Fill"
	v1_423.Size = UDim2.new(v1_410(v1_415), 0, 1, 0)
	v1_423.BackgroundColor3 = v0_7.Accent
	v1_423.BorderSizePixel = 0
	v1_423.Parent = v1_422
	local v1_424 = v0_7.Accent
	local v1_425 = v0_7.Accent:Lerp(v0_7.Text, 0.25)
	local v1_426 = Instance.new("TextButton")
	v1_426.Name = "Hit"
	v1_426.Size = UDim2.new(1, 0, 1, 0)
	v1_426.BackgroundTransparency = 1
	v1_426.BorderSizePixel = 0
	v1_426.Text = ""
	v1_426.AutoButtonColor = false
	v1_426.Parent = v1_419
	local function v1_427()
		local v2_428 = v1_416 or v1_417
		v0_10(v1_419, { BackgroundColor3 = v2_428 and v0_7.Hover or v0_7.Element }, 0.12)
		v0_10(v1_423, { BackgroundColor3 = v2_428 and v1_425 or v1_424 }, 0.12)
	end
	local function v1_429(v2_430)
		local v2_431 = v1_410(v1_415)
		v0_10(v1_423, { Size = UDim2.new(v2_431, 0, 1, 0) }, v2_430)
		v1_421.Text = v1_412(v1_415)
	end
	local function v1_432(v2_433, v2_434, v2_435)
		v2_433 = v1_407(v2_433)
		local v2_436 = v2_433 ~= v1_415
		v1_415 = v2_433
		v1_429(v2_435)
		if v2_436 then
			v1_421.TextColor3 = v0_7.Text
			v0_10(v1_421, { TextColor3 = v0_7.SubText }, 0.3)
			if not v2_434 and v1_398.Callback then v1_398.Callback(v1_415) end
		end
	end
	local function v1_437(v2_438)
		local v2_439 = v1_422.AbsoluteSize.X
		if v2_439 <= 0 then return end
		v1_432(v1_402 + ((v2_438 - v1_422.AbsolutePosition.X) / v2_439) * (v1_403 - v1_402), false, 0.08)
	end
	local function v1_440()
		if v1_418 then
			for v4_441, v4_442 in ipairs(v1_418) do v4_442:Disconnect() end
			v1_418 = nil
		end
		if v1_417 then
			v1_417 = false
			v1_427()
		end
	end
	local function v1_443(v2_444)
		v1_440()
		v1_417 = true
		v1_427()
		v1_437(v2_444.Position.X)
		v1_418 = {
			v0_4.InputChanged:Connect(function(v3_445)
				if v3_445.UserInputType == Enum.UserInputType.MouseMovement or v3_445 == v2_444 then
					v1_437(v3_445.Position.X)
				end
			end),
			v0_4.InputEnded:Connect(function(v3_446)
				if v3_446 == v2_444 or v3_446.UserInputType == Enum.UserInputType.MouseButton1 then
					v1_440()
				end
			end),
		}
	end
	v1_426.InputBegan:Connect(function(v2_447)
		if v0_17(v2_447) then v1_443(v2_447) end
	end)
	v1_426.MouseEnter:Connect(function()
		v1_416 = true
		v1_427()
	end)
	v1_426.MouseLeave:Connect(function()
		v1_416 = false
		v1_427()
	end)
	local v1_448 = { Instance = v1_419 }
	function v1_448:Set(v2_449, v2_450)
		v1_432(tonumber(v2_449) or v1_415, v2_450, 0.2)
	end
	function v1_448:Get()
		return v1_415
	end
	function v1_448:Destroy()
		v1_440()
		v1_399._cleanups[v1_448] = nil
		v1_419:Destroy()
	end
	v1_399._cleanups[v1_448] = v1_440
	return v1_448
end
function v0_3:AddDropdown(v1_451)
	v1_451 = v1_451 or {}
	self._count += 1
	local v1_452 = v1_451.Options or {}
	local v1_453 = v1_451.Multi == true
	local v1_454 = 130
	local v1_455, v1_456 = 26, 4
	local v1_457 = nil
	local v1_458 = {}
	local v1_459 = {}
	local v1_460 = false
	local v1_461 = 0
	local v1_462 = nil
	local v1_463 = Instance.new("Frame")
	v1_463.Name = "Dropdown"
	v1_463.Size = UDim2.new(1, 0, 0, 32)
	v1_463.AutomaticSize = Enum.AutomaticSize.Y
	v1_463.BackgroundTransparency = 1
	v1_463.BorderSizePixel = 0
	v1_463.LayoutOrder = self._count
	v1_463.Parent = self.Holder
	local v1_464 = Instance.new("UIListLayout")
	v1_464.Padding = UDim.new(0, 4)
	v1_464.SortOrder = Enum.SortOrder.LayoutOrder
	v1_464.Parent = v1_463
	local v1_465 = Instance.new("TextButton")
	v1_465.Name = "Header"
	v1_465.Size = UDim2.new(1, 0, 0, 32)
	v1_465.BackgroundColor3 = v0_7.Element
	v1_465.BorderSizePixel = 0
	v1_465.Text = ""
	v1_465.AutoButtonColor = false
	v1_465.LayoutOrder = 1
	v1_465.Parent = v1_463
	v0_61(v1_465, 6)
	v0_19(v1_465, v0_7.Element, v0_7.Hover)
	local v1_466 = Instance.new("TextLabel")
	v1_466.Name = "Name"
	v1_466.Position = UDim2.new(0, 8, 0, 0)
	v1_466.Size = UDim2.new(0.5, -8, 1, 0)
	v1_466.BackgroundTransparency = 1
	v1_466.BorderSizePixel = 0
	v1_466.Text = v1_451.Name or "Dropdown"
	v1_466.TextColor3 = v0_7.Text
	v1_466.Font = Enum.Font.Gotham
	v1_466.TextSize = 14
	v1_466.TextXAlignment = Enum.TextXAlignment.Left
	v1_466.TextTruncate = Enum.TextTruncate.AtEnd
	v1_466.Parent = v1_465
	local v1_467 = Instance.new("TextLabel")
	v1_467.Name = "Value"
	v1_467.Position = UDim2.new(0.5, 0, 0, 0)
	v1_467.Size = UDim2.new(0.5, -28, 1, 0)
	v1_467.BackgroundTransparency = 1
	v1_467.BorderSizePixel = 0
	v1_467.Text = "None"
	v1_467.TextColor3 = v0_7.SubText
	v1_467.Font = Enum.Font.Gotham
	v1_467.TextSize = 13
	v1_467.TextXAlignment = Enum.TextXAlignment.Right
	v1_467.TextTruncate = Enum.TextTruncate.AtEnd
	v1_467.Parent = v1_465
	local v1_468 = Instance.new("ImageLabel")
	v1_468.Name = "Arrow"
	v1_468.AnchorPoint = Vector2.new(1, 0.5)
	v1_468.Position = UDim2.new(1, -8, 0.5, 0)
	v1_468.Size = UDim2.new(0, 16, 0, 16)
	v1_468.BackgroundTransparency = 1
	v1_468.BorderSizePixel = 0
	v1_468.ImageColor3 = v0_7.SubText
	v1_468.ScaleType = Enum.ScaleType.Fit
	v1_468.Parent = v1_465
	local v1_469 = Instance.new("TextLabel")
	v1_469.Name = "ArrowFallback"
	v1_469.Size = UDim2.new(1, 0, 1, 0)
	v1_469.BackgroundTransparency = 1
	v1_469.Text = "▼"
	v1_469.TextColor3 = v0_7.SubText
	v1_469.Font = Enum.Font.Gotham
	v1_469.TextSize = 9
	v1_469.Visible = false
	v1_469.Parent = v1_468
	local function v1_470(v2_471)
		local v2_472 = v0_42(v1_468, v2_471 and "chevron-up" or "chevron-down", self._icons)
		if not v2_472 then v1_468.Image = "" end
		v1_469.Visible = not v2_472
		v1_469.Text = v2_471 and "▲" or "▼"
		v1_468.ImageTransparency = 1
		v1_469.TextTransparency = 1
		v0_10(v1_468, { ImageTransparency = 0 }, 0.18)
		v0_10(v1_469, { TextTransparency = 0 }, 0.18)
	end
	v1_470(false)
	local v1_473 = Instance.new("ScrollingFrame")
	v1_473.Name = "List"
	v1_473.Size = UDim2.new(1, 0, 0, 0)
	v1_473.BackgroundColor3 = v0_7.Sidebar
	v1_473.BorderSizePixel = 0
	v1_473.ScrollBarThickness = 3
	v1_473.ScrollBarImageColor3 = v0_7.IconOff
	v1_473.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_473.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_473.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_473.Visible = false
	v1_473.LayoutOrder = 2
	v1_473.Parent = v1_463
	v0_61(v1_473, 6)
	local v1_474 = Instance.new("UIPadding")
	v1_474.PaddingTop = UDim.new(0, 4)
	v1_474.PaddingBottom = UDim.new(0, 4)
	v1_474.Parent = v1_473
	local v1_475 = Instance.new("UIListLayout")
	v1_475.Padding = UDim.new(0, v1_456)
	v1_475.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_475.SortOrder = Enum.SortOrder.LayoutOrder
	v1_475.Parent = v1_473
	local function v1_476(v2_477)
		if v1_453 then return v1_458[v2_477] == true end
		return v1_457 == v2_477
	end
	local function v1_478()
		local v2_479 = {}
		for v3_480, v3_481 in ipairs(v1_452) do
			if v1_458[v3_481] then table.insert(v2_479, v3_481) end
		end
		return v2_479
	end
	local function v1_482()
		for v3_483, v3_484 in pairs(v1_459) do
			local v3_485 = v1_476(v3_483)
			v3_484.BackgroundColor3 = v3_485 and v0_7.Accent or v0_7.Element
			v3_484.TextColor3 = v3_485 and v0_7.IconOn or v0_7.SubText
		end
		if v1_453 then
			local v3_486 = {}
			for v4_487, v4_488 in ipairs(v1_478()) do table.insert(v3_486, tostring(v4_488)) end
			v1_467.Text = #v3_486 > 0 and table.concat(v3_486, ", ") or "None"
		else
			v1_467.Text = v1_457 ~= nil and tostring(v1_457) or "None"
		end
	end
	local function v1_489(v2_490)
		if v1_460 == v2_490 then return end
		v1_460 = v2_490
		if v1_462 then v1_462:Cancel() end
		v1_470(v2_490)
		if v2_490 then
			v1_473.Visible = true
			v1_462 = v0_10(v1_473, { Size = UDim2.new(1, 0, 0, v1_461) }, 0.22, Enum.EasingStyle.Quint)
		else
			local v3_491 = v0_10(v1_473, { Size = UDim2.new(1, 0, 0, 0) }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v1_462 = v3_491
			v3_491.Completed:Connect(function(v4_492)
				if v4_492 == Enum.PlaybackState.Completed and not v1_460 then
					v1_473.Visible = false
				end
			end)
		end
	end
	local v1_493 = { Instance = v1_463 }
	local function v1_494()
		if v1_451.Callback then
			v1_451.Callback(v1_453 and v1_478() or v1_457)
		end
	end
	local function v1_495()
		for v3_496, v3_497 in pairs(v1_459) do v3_497:Destroy() end
		v1_459 = {}
		for v3_498, v3_499 in ipairs(v1_452) do
			local v3_500 = Instance.new("TextButton")
			v3_500.Name = "Option"
			v3_500.Size = UDim2.new(1, -8, 0, v1_455)
			v3_500.BackgroundColor3 = v0_7.Element
			v3_500.BorderSizePixel = 0
			v3_500.Text = tostring(v3_499)
			v3_500.TextColor3 = v0_7.SubText
			v3_500.Font = Enum.Font.Gotham
			v3_500.TextSize = 13
			v3_500.TextTruncate = Enum.TextTruncate.AtEnd
			v3_500.AutoButtonColor = true
			v3_500.LayoutOrder = v3_498
			v3_500.Parent = v1_473
			v0_61(v3_500, 5)
			v3_500.MouseButton1Click:Connect(function()
				if v1_453 then
					v1_458[v3_499] = not v1_458[v3_499] or nil
					v1_482()
					v1_494()
				else
					v1_457 = v3_499
					v1_482()
					v1_489(false)
					v1_494()
				end
			end)
			v1_459[v3_499] = v3_500
		end
		local v2_501 = #v1_452
		local v2_502 = v2_501 > 0 and (v2_501 * v1_455 + (v2_501 - 1) * v1_456 + 8) or 0
		v1_461 = math.min(v2_502, v1_454)
		v1_473.Size = UDim2.new(1, 0, 0, v1_460 and v1_461 or 0)
		v1_482()
	end
	function v1_493:Set(v2_503, v2_504)
		if v1_453 then
			v1_458 = {}
			for v4_505, v4_506 in ipairs(typeof(v2_503) == "table" and v2_503 or { v2_503 }) do
				v1_458[v4_506] = true
			end
		else
			v1_457 = v2_503
		end
		v1_482()
		if not v2_504 then v1_494() end
	end
	function v1_493:Get()
		return v1_453 and v1_478() or v1_457
	end
	function v1_493:Refresh(v2_507, v2_508)
		v1_452 = v2_507 or {}
		if v2_508 then
			local v3_509 = {}
			for v4_510, v4_511 in ipairs(v1_452) do v3_509[v4_511] = true end
			if v1_453 then
				for v5_512 in pairs(v1_458) do
					if not v3_509[v5_512] then v1_458[v5_512] = nil end
				end
			elseif not v3_509[v1_457] then
				v1_457 = nil
			end
		else
			v1_458, v1_457 = {}, nil
		end
		v1_495()
	end
	function v1_493:Open() v1_489(true) end
	function v1_493:Close() v1_489(false) end
	v1_465.MouseButton1Click:Connect(function()
		v1_489(not v1_460)
	end)
	v1_495()
	if v1_451.Default ~= nil then
		v1_493:Set(v1_451.Default, true)
	end
	return v1_493
end
return v0_1
