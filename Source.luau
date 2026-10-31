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
	v1_66.IconGlow = v1_65.IconGlow == true
	v1_66._dialogs = {}
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
		v1_66:_buildWatermark(v1_65.Title or v1_65.Name or "RobloxUI")
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
		if #v1_66._dialogs > 0 then
			if v2_144 == Enum.KeyCode.Escape then
				local v4_145 = v1_66._dialogs[#v1_66._dialogs]
				if v4_145.Dismissable then v4_145.Close() end
			end
			return
		end
		if v1_66._toggleKey and v2_144 == v1_66._toggleKey then
			v1_66:Toggle()
			return
		end
		for v3_146, v3_147 in ipairs(table.clone(v1_66._binds)) do
			if v3_147._key == v2_144 and not v3_147._destroyed then
				v3_147._onPress()
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
function v0_1.CreateWindow(v1_148, v1_149)
	return v0_1.new(v1_148 == v0_1 and v1_149 or v1_148)
end
function v0_1:Destroy()
	for v2_150, v2_151 in ipairs(self._connections) do
		v2_151:Disconnect()
	end
	self._connections = {}
	self._destroyed = true
	if self._hint then pcall(self._hint.HideTip, true) end
	for v2_152, v2_153 in ipairs(table.clone(self._notifs or {})) do pcall(v2_153) end
	for v2_154, v2_155 in pairs(self._cleanups) do pcall(v2_155) end
	self._cleanups = {}
	self._binds = {}
	self._listening = nil
	self.ScreenGui:Destroy()
end
local v0_156, v0_157 = 0.35, 0.2
function v0_1:_cancelAnim()
	if self._anim then
		for v3_158, v3_159 in ipairs(self._anim) do v3_159:Cancel() end
		self._anim = nil
	end
end
function v0_1:Show()
	if self._destroyed then return end
	self._visible = true
	self:_cancelAnim()
	self.Main.Visible = true
	self._anim = {
		v0_10(self.Main, { GroupTransparency = 0 }, v0_156, Enum.EasingStyle.Quint),
		v0_10(self._scale, { Scale = 1 }, v0_156, Enum.EasingStyle.Back),
	}
	self:_updateWatermark()
end
function v0_1:Hide()
	if self._destroyed or not self._visible then return end
	self._visible = false
	self:_cancelAnim()
	local v1_160 = v0_4:GetFocusedTextBox()
	if v1_160 and v1_160:IsDescendantOf(self.Main) then v1_160:ReleaseFocus() end
	local v1_161 = v0_10(self.Main, { GroupTransparency = 1 }, v0_157, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local v1_162 = v0_10(self._scale, { Scale = 0.92 }, v0_157, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	self._anim = { v1_161, v1_162 }
	v1_161.Completed:Connect(function(v2_163)
		if v2_163 == Enum.PlaybackState.Completed and not self._visible and not self._destroyed then
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
	local v1_164 = self._hint
	if not v1_164 or self._destroyed then return end
	local v1_165 = self.ActiveTab and self.ActiveTab.Page
	local v1_166 = false
	if v1_165 and v1_165.Visible then
		local v2_167 = v1_165.AbsoluteCanvasSize.Y - (v1_165.CanvasPosition.Y + v1_165.AbsoluteWindowSize.Y)
		v1_166 = v2_167 > 4
	end
	if v1_166 == v1_164.Shown then return end
	v1_164.Shown = v1_166
	if v1_164.Fade then v1_164.Fade:Cancel() end
	if v1_166 then
		v1_164.Frame.Visible = true
		v1_164.Icon.Position = UDim2.new(0.5, 0, 0.5, -3)
		v1_164.Bounce:Play()
		v1_164.Fade = v0_10(v1_164.Frame, { GroupTransparency = 0.15 }, 0.2)
	else
		v1_164.HideTip()
		local v2_168 = v0_10(v1_164.Frame, { GroupTransparency = 1 }, 0.2)
		v1_164.Fade = v2_168
		v2_168.Completed:Connect(function(v3_169)
			if v3_169 == Enum.PlaybackState.Completed and not v1_164.Shown then
				v1_164.Bounce:Cancel()
				v1_164.Frame.Visible = false
			end
		end)
	end
end
function v0_1:_keyTaken(v1_170, v1_171)
	if not v1_170 then return false end
	if v1_170 == self._toggleKey then return true end
	for v2_172, v2_173 in ipairs(self._binds) do
		if v2_173 ~= v1_171 and v2_173._key == v1_170 then return true end
	end
	return false
end
local v0_174, v0_175 = 280, 5
function v0_1:_getNotifyContainer()
	if self._notifyContainer and self._notifyContainer.Parent then
		return self._notifyContainer
	end
	local v1_176 = self.ScreenGui.AbsoluteSize
	local v1_177 = v1_176.X > 0 and math.min(v0_174, v1_176.X - 20) or v0_174
	local v1_178 = Instance.new("Frame")
	v1_178.Name = "Notifications"
	v1_178.AnchorPoint = Vector2.new(0.5, 0)
	v1_178.Position = UDim2.new(0.5, 0, 0, self._wm and 48 or 10)
	v1_178.Size = UDim2.new(0, v1_177, 0, 0)
	v1_178.AutomaticSize = Enum.AutomaticSize.Y
	v1_178.BackgroundTransparency = 1
	v1_178.BorderSizePixel = 0
	v1_178.Parent = self.ScreenGui
	local v1_179 = Instance.new("UIListLayout")
	v1_179.Padding = UDim.new(0, 6)
	v1_179.SortOrder = Enum.SortOrder.LayoutOrder
	v1_179.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_179.Parent = v1_178
	self._notifyContainer = v1_178
	return v1_178
end
function v0_1:Notify(v1_180)
	if self._destroyed then return end
	if type(v1_180) == "string" then v1_180 = { Content = v1_180 } end
	v1_180 = v1_180 or {}
	local v1_181 = tonumber(v1_180.Duration) or 4
	local v1_182 = self:_getNotifyContainer()
	self._notifyCount = (self._notifyCount or 0) + 1
	self._notifs = self._notifs or {}
	local v1_183 = false
	local v1_184 = Instance.new("Frame")
	v1_184.Name = "Notification"
	v1_184.Size = UDim2.new(1, 0, 0, 0)
	v1_184.BackgroundTransparency = 1
	v1_184.BorderSizePixel = 0
	v1_184.LayoutOrder = self._notifyCount
	v1_184.Parent = v1_182
	local v1_185 = Instance.new("CanvasGroup")
	v1_185.Name = "Card"
	v1_185.Size = UDim2.new(1, 0, 0, 0)
	v1_185.AutomaticSize = Enum.AutomaticSize.Y
	v1_185.BackgroundColor3 = v0_7.Sidebar
	v1_185.BorderSizePixel = 0
	v1_185.GroupTransparency = 1
	v1_185.Parent = v1_184
	v0_61(v1_185, 8)
	local v1_186 = Instance.new("UIStroke")
	v1_186.Color = v0_7.Element
	v1_186.Thickness = 1
	v1_186.Transparency = 1
	v1_186.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_186.Parent = v1_185
	local v1_187 = Instance.new("Frame")
	v1_187.Name = "Body"
	v1_187.Size = UDim2.new(1, 0, 0, 0)
	v1_187.AutomaticSize = Enum.AutomaticSize.Y
	v1_187.BackgroundTransparency = 1
	v1_187.BorderSizePixel = 0
	v1_187.Parent = v1_185
	local v1_188 = Instance.new("UIPadding")
	v1_188.PaddingTop = UDim.new(0, 8)
	v1_188.PaddingBottom = UDim.new(0, 8)
	v1_188.PaddingLeft = UDim.new(0, 12)
	v1_188.PaddingRight = UDim.new(0, 12)
	v1_188.Parent = v1_187
	local v1_189 = Instance.new("UISizeConstraint")
	v1_189.MinSize = Vector2.new(0, 30)
	v1_189.Parent = v1_187
	local v1_190 = Instance.new("Frame")
	v1_190.Name = "Texts"
	v1_190.Position = UDim2.new(0, 0, 0, 0)
	v1_190.Size = UDim2.new(1, 0, 0, 0)
	v1_190.AutomaticSize = Enum.AutomaticSize.Y
	v1_190.BackgroundTransparency = 1
	v1_190.BorderSizePixel = 0
	v1_190.Parent = v1_187
	local v1_191 = Instance.new("UIListLayout")
	v1_191.Padding = UDim.new(0, 2)
	v1_191.SortOrder = Enum.SortOrder.LayoutOrder
	v1_191.Parent = v1_190
	local function v1_192(v2_193, v2_194, v2_195, v2_196, v2_197)
		local v2_198 = Instance.new("TextLabel")
		v2_198.Size = UDim2.new(1, 0, 0, 0)
		v2_198.AutomaticSize = Enum.AutomaticSize.Y
		v2_198.BackgroundTransparency = 1
		v2_198.BorderSizePixel = 0
		v2_198.Text = v2_193
		v2_198.TextColor3 = v2_196
		v2_198.Font = v2_194
		v2_198.TextSize = v2_195
		v2_198.TextWrapped = true
		v2_198.TextXAlignment = Enum.TextXAlignment.Left
		v2_198.TextYAlignment = Enum.TextYAlignment.Top
		v2_198.LayoutOrder = v2_197
		v2_198.Parent = v1_190
		return v2_198
	end
	if v1_180.Title and v1_180.Title ~= "" then
		v1_192(tostring(v1_180.Title), Enum.Font.GothamBold, 13, v0_7.Text, 1).Name = "Title"
	end
	if v1_180.Content and v1_180.Content ~= "" then
		v1_192(tostring(v1_180.Content), Enum.Font.Gotham, 12, v0_7.SubText, 2).Name = "Content"
	end
	local v1_199 = Instance.new("TextLabel")
	v1_199.Name = "Countdown"
	v1_199.AnchorPoint = Vector2.new(1, 0.5)
	v1_199.Position = UDim2.new(1, 0, 0.5, 0)
	v1_199.Size = UDim2.new(0, 18, 0, 18)
	v1_199.BackgroundTransparency = 1
	v1_199.BorderSizePixel = 0
	v1_199.Text = tostring(math.ceil(v1_181))
	v1_199.TextColor3 = v0_7.SubText
	v1_199.Font = Enum.Font.GothamBold
	v1_199.TextSize = 13
	v1_199.TextXAlignment = Enum.TextXAlignment.Right
	v1_199.Visible = v1_181 > 0
	v1_199.Parent = v1_187
	if v1_181 > 0 then
		v1_190.Size = UDim2.new(1, -24, 0, 0)
	end
	local v1_200 = Instance.new("TextButton")
	v1_200.Name = "Click"
	v1_200.Size = UDim2.new(1, 0, 1, 0)
	v1_200.BackgroundTransparency = 1
	v1_200.BorderSizePixel = 0
	v1_200.Text = ""
	v1_200.AutoButtonColor = false
	v1_200.Parent = v1_185
	local v1_201, v1_202 = nil, nil
	local v1_203 = {}
	local function v1_204()
		if v1_183 then return end
		v1_183 = true
		local v2_205 = table.find(self._notifs, v1_204)
		if v2_205 then table.remove(self._notifs, v2_205) end
		if v1_201 and v1_201 ~= coroutine.running() then
			pcall(task.cancel, v1_201)
		end
		v1_201 = nil
		if v1_202 then
			v1_202:Disconnect()
			v1_202 = nil
		end
		for v3_206, v3_207 in ipairs(v1_203) do v3_207:Cancel() end
		v1_203 = {}
		if self._destroyed then return end
		v0_10(v1_186, { Transparency = 1 }, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v2_208 = v0_10(v1_185, {
			Position = UDim2.new(0, 0, 0, -20),
			GroupTransparency = 1,
		}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_208.Completed:Connect(function()
			local v3_209 = v0_10(v1_184, { Size = UDim2.new(1, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quint)
			v3_209.Completed:Connect(function()
				v1_184:Destroy()
			end)
		end)
	end
	v1_200.MouseButton1Click:Connect(v1_204)
	table.insert(self._notifs, v1_204)
	while #self._notifs > v0_175 do
		self._notifs[1]()
	end
	local v1_210 = false
	v1_202 = v1_185:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if v1_183 then return end
		local v2_211 = v1_185.AbsoluteSize.Y
		if v2_211 <= 0 then return end
		if not v1_210 then
			v1_210 = true
			table.insert(v1_203, v0_10(v1_184, { Size = UDim2.new(1, 0, 0, v2_211) }, 0.3, Enum.EasingStyle.Quint))
		else
			v1_184.Size = UDim2.new(1, 0, 0, v2_211)
		end
	end)
	v1_185.Position = UDim2.new(0, 0, 0, -(v1_182.AbsolutePosition.Y + v1_182.AbsoluteSize.Y + 90))
	v1_203 = {
		v0_10(v1_185, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back),
		v0_10(v1_185, { GroupTransparency = 0 }, 0.25),
		v0_10(v1_186, { Transparency = 0 }, 0.25),
	}
	if v1_181 > 0 then
		v1_201 = task.spawn(function()
			local v3_212 = os.clock()
			local v3_213 = math.ceil(v1_181)
			while not v1_183 and not self._destroyed do
				local v4_214 = v1_181 - (os.clock() - v3_212)
				local v4_215 = math.max(math.ceil(v4_214), 0)
				if v4_215 ~= v3_213 then
					v3_213 = v4_215
					v1_199.Text = tostring(v4_215)
					v1_199.TextTransparency = 0.6
					v0_10(v1_199, { TextTransparency = 0 }, 0.2)
				end
				if v4_214 <= 0 then
					v1_201 = nil
					v1_204()
					return
				end
				task.wait(v4_214 - (v4_215 - 1))
			end
		end)
	end
	return { Dismiss = v1_204 }
end
function v0_1:Dialog(v1_216)
	if self._destroyed then return end
	v1_216 = v1_216 or {}
	local v1_217 = v1_216.Buttons
	if type(v1_217) ~= "table" or #v1_217 == 0 then
		v1_217 = { { Title = "OK", Primary = true } }
	end
	local v1_218 = false
	local v1_219 = {}
	local v1_220 = { Dismissable = v1_216.Dismissable ~= false }
	local v1_221 = Instance.new("Frame")
	v1_221.Name = "DialogOverlay"
	v1_221.Size = UDim2.new(1, 0, 1, 0)
	v1_221.BackgroundTransparency = 1
	v1_221.BorderSizePixel = 0
	v1_221.ZIndex = 100 + #self._dialogs
	v1_221.Parent = self.ScreenGui
	local v1_222 = Instance.new("TextButton")
	v1_222.Name = "Backdrop"
	v1_222.Size = UDim2.new(1, 0, 1, 0)
	v1_222.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	v1_222.BackgroundTransparency = 1
	v1_222.BorderSizePixel = 0
	v1_222.Text = ""
	v1_222.AutoButtonColor = false
	v1_222.Parent = v1_221
	local v1_223 = Instance.new("CanvasGroup")
	v1_223.Name = "Dialog"
	v1_223.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_223.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_223.Size = UDim2.new(0.9, 0, 0, 0)
	v1_223.AutomaticSize = Enum.AutomaticSize.Y
	v1_223.BackgroundColor3 = v0_7.Sidebar
	v1_223.BorderSizePixel = 0
	v1_223.GroupTransparency = 1
	v1_223.Active = true
	v1_223.ZIndex = 2
	v1_223.Parent = v1_221
	v0_61(v1_223, 8)
	local v1_224 = Instance.new("UISizeConstraint")
	v1_224.MinSize = Vector2.new(200, 0)
	v1_224.MaxSize = Vector2.new(320, math.huge)
	v1_224.Parent = v1_223
	local v1_225 = Instance.new("UIScale")
	v1_225.Scale = 0.92
	v1_225.Parent = v1_223
	local v1_226 = Instance.new("UIStroke")
	v1_226.Color = v0_7.Element
	v1_226.Thickness = 1
	v1_226.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_226.Parent = v1_223
	local v1_227 = Instance.new("Frame")
	v1_227.Name = "Body"
	v1_227.Size = UDim2.new(1, 0, 0, 0)
	v1_227.AutomaticSize = Enum.AutomaticSize.Y
	v1_227.BackgroundTransparency = 1
	v1_227.BorderSizePixel = 0
	v1_227.Parent = v1_223
	local v1_228 = Instance.new("UIPadding")
	v1_228.PaddingTop = UDim.new(0, 14)
	v1_228.PaddingBottom = UDim.new(0, 14)
	v1_228.PaddingLeft = UDim.new(0, 14)
	v1_228.PaddingRight = UDim.new(0, 14)
	v1_228.Parent = v1_227
	local v1_229 = Instance.new("UIListLayout")
	v1_229.Padding = UDim.new(0, 8)
	v1_229.SortOrder = Enum.SortOrder.LayoutOrder
	v1_229.Parent = v1_227
	local function v1_230(v2_231, v2_232, v2_233, v2_234, v2_235, v2_236)
		local v2_237 = Instance.new("TextLabel")
		v2_237.Name = v2_231
		v2_237.Size = UDim2.new(1, 0, 0, 0)
		v2_237.AutomaticSize = Enum.AutomaticSize.Y
		v2_237.BackgroundTransparency = 1
		v2_237.BorderSizePixel = 0
		v2_237.Text = v2_232
		v2_237.TextColor3 = v2_235
		v2_237.Font = v2_233
		v2_237.TextSize = v2_234
		v2_237.TextWrapped = true
		v2_237.TextXAlignment = Enum.TextXAlignment.Left
		v2_237.TextYAlignment = Enum.TextYAlignment.Top
		v2_237.LayoutOrder = v2_236
		v2_237.Parent = v1_227
		return v2_237
	end
	if v1_216.Title and v1_216.Title ~= "" then
		v1_230("Title", tostring(v1_216.Title), Enum.Font.GothamBold, 15, v0_7.Text, 1)
	end
	if v1_216.Content and v1_216.Content ~= "" then
		v1_230("Content", tostring(v1_216.Content), Enum.Font.Gotham, 13, v0_7.SubText, 2)
	end
	local v1_238 = Instance.new("Frame")
	v1_238.Name = "Buttons"
	v1_238.Size = UDim2.new(1, 0, 0, 30)
	v1_238.BackgroundTransparency = 1
	v1_238.BorderSizePixel = 0
	v1_238.LayoutOrder = 3
	v1_238.Parent = v1_227
	local v1_239 = Instance.new("UIListLayout")
	v1_239.FillDirection = Enum.FillDirection.Horizontal
	v1_239.HorizontalAlignment = Enum.HorizontalAlignment.Right
	v1_239.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_239.Padding = UDim.new(0, 8)
	v1_239.SortOrder = Enum.SortOrder.LayoutOrder
	v1_239.Parent = v1_238
	local function v1_240()
		if v1_218 then return end
		v1_218 = true
		local v2_241 = table.find(self._dialogs, v1_220)
		if v2_241 then table.remove(self._dialogs, v2_241) end
		for v3_242, v3_243 in ipairs(v1_219) do v3_243:Cancel() end
		v1_219 = {}
		if self._destroyed or not v1_221.Parent then return end
		v0_10(v1_222, { BackgroundTransparency = 1 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v0_10(v1_225, { Scale = 0.94 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v2_244 = v0_10(v1_223, { GroupTransparency = 1 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_244.Completed:Connect(function()
			v1_221:Destroy()
		end)
	end
	v1_220.Close = v1_240
	for v2_245, v2_246 in ipairs(v1_217) do
		local v2_247 = v2_246.Primary == true
		local v2_248 = v2_247 and v0_7.Accent or v0_7.Element
		local v2_249 = v2_247 and v0_7.Accent:Lerp(v0_7.Text, 0.15) or v0_7.Hover
		local v2_250 = Instance.new("TextButton")
		v2_250.Name = "Button"
		v2_250.Size = UDim2.new(0, 0, 0, 30)
		v2_250.AutomaticSize = Enum.AutomaticSize.X
		v2_250.BackgroundColor3 = v2_248
		v2_250.BorderSizePixel = 0
		v2_250.Text = tostring(v2_246.Title or "OK")
		v2_250.TextColor3 = v0_7.Text
		v2_250.Font = Enum.Font.Gotham
		v2_250.TextSize = 13
		v2_250.AutoButtonColor = false
		v2_250.LayoutOrder = v2_245
		v2_250.Parent = v1_238
		v0_61(v2_250, 6)
		local v2_251 = Instance.new("UIPadding")
		v2_251.PaddingLeft = UDim.new(0, 14)
		v2_251.PaddingRight = UDim.new(0, 14)
		v2_251.Parent = v2_250
		v0_19(v2_250, v2_248, v2_249)
		v2_250.MouseButton1Click:Connect(function()
			if v1_218 then return end
			v1_240()
			if v2_246.Callback then v2_246.Callback() end
		end)
	end
	v1_222.MouseButton1Click:Connect(function()
		if v1_220.Dismissable then v1_240() end
	end)
	table.insert(self._dialogs, v1_220)
	v1_219 = {
		v0_10(v1_222, { BackgroundTransparency = 0.45 }, 0.2),
		v0_10(v1_223, { GroupTransparency = 0 }, 0.22),
		v0_10(v1_225, { Scale = 1 }, 0.3, Enum.EasingStyle.Back),
	}
	return { Close = v1_240 }
end
function v0_1:_buildWatermark(v1_252)
	local v1_253 = Instance.new("Frame")
	v1_253.Name = "Watermark"
	v1_253.AnchorPoint = Vector2.new(0.5, 0)
	v1_253.Position = UDim2.new(0.5, 0, 0, -40)
	v1_253.Size = UDim2.new(0, 0, 0, 30)
	v1_253.AutomaticSize = Enum.AutomaticSize.X
	v1_253.BackgroundColor3 = v0_7.Sidebar
	v1_253.BorderSizePixel = 0
	v1_253.Parent = self.ScreenGui
	v0_61(v1_253, 8)
	local v1_254 = Instance.new("UIStroke")
	v1_254.Color = v0_7.Element
	v1_254.Thickness = 1
	v1_254.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_254.Parent = v1_253
	local v1_255 = Instance.new("UIPadding")
	v1_255.PaddingLeft = UDim.new(0, 10)
	v1_255.PaddingRight = UDim.new(0, 4)
	v1_255.Parent = v1_253
	local v1_256 = Instance.new("UIListLayout")
	v1_256.FillDirection = Enum.FillDirection.Horizontal
	v1_256.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_256.Padding = UDim.new(0, 8)
	v1_256.SortOrder = Enum.SortOrder.LayoutOrder
	v1_256.Parent = v1_253
	local v1_257 = Instance.new("TextLabel")
	v1_257.Name = "Title"
	v1_257.Size = UDim2.new(0, 0, 1, 0)
	v1_257.AutomaticSize = Enum.AutomaticSize.X
	v1_257.BackgroundTransparency = 1
	v1_257.BorderSizePixel = 0
	v1_257.Text = v1_252
	v1_257.TextColor3 = v0_7.SubText
	v1_257.Font = Enum.Font.GothamBold
	v1_257.TextSize = 13
	v1_257.LayoutOrder = 1
	v1_257.Parent = v1_253
	local v1_258 = Instance.new("TextButton")
	v1_258.Name = "ToggleButton"
	v1_258.Size = UDim2.new(0, 22, 0, 22)
	v1_258.BackgroundColor3 = v0_7.Element
	v1_258.BorderSizePixel = 0
	v1_258.Text = ""
	v1_258.AutoButtonColor = false
	v1_258.LayoutOrder = 2
	v1_258.Parent = v1_253
	v0_61(v1_258, 6)
	local v1_259 = Instance.new("ImageLabel")
	v1_259.Name = "Icon"
	v1_259.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_259.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_259.Size = UDim2.new(0, 14, 0, 14)
	v1_259.BackgroundTransparency = 1
	v1_259.BorderSizePixel = 0
	v1_259.ImageColor3 = v0_7.IconOn
	v1_259.ScaleType = Enum.ScaleType.Fit
	v1_259.Parent = v1_258
	local v1_260 = Instance.new("TextLabel")
	v1_260.Name = "IconFallback"
	v1_260.Size = UDim2.new(1, 0, 1, 0)
	v1_260.BackgroundTransparency = 1
	v1_260.TextColor3 = v0_7.IconOn
	v1_260.Font = Enum.Font.GothamBold
	v1_260.TextSize = 12
	v1_260.Visible = false
	v1_260.Parent = v1_259
	local v1_261 = Instance.new("UIScale")
	v1_261.Parent = v1_258
	v1_258.MouseEnter:Connect(function() v0_10(v1_261, { Scale = 1.1 }, 0.12) end)
	v1_258.MouseLeave:Connect(function() v0_10(v1_261, { Scale = 1 }, 0.12) end)
	v1_258.InputBegan:Connect(function(v2_262)
		if v0_17(v2_262) then v0_10(v1_261, { Scale = 0.9 }, 0.08) end
	end)
	v1_258.InputEnded:Connect(function(v2_263)
		if v0_17(v2_263) then v0_10(v1_261, { Scale = 1.1 }, 0.15, Enum.EasingStyle.Back) end
	end)
	v1_258.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	local v1_264, v1_265, v1_266 = false, nil, nil
	v1_257.InputBegan:Connect(function(v2_267)
		if v0_17(v2_267) then
			v1_264 = true
			v1_265 = v2_267.Position
			v1_266 = v1_253.AbsolutePosition + Vector2.new(v1_253.AbsoluteSize.X / 2, 0)
			v2_267.Changed:Connect(function()
				if v2_267.UserInputState == Enum.UserInputState.End then v1_264 = false end
			end)
		end
	end)
	table.insert(self._connections, v0_4.InputChanged:Connect(function(v2_268)
		if not v1_264 then return end
		if v2_268.UserInputType ~= Enum.UserInputType.MouseMovement and v2_268.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local v2_269 = v2_268.Position - v1_265
		local v2_270 = self.ScreenGui.AbsoluteSize
		local v2_271 = v1_253.AbsoluteSize.X / 2
		local v2_272 = math.clamp(v1_266.X + v2_269.X, v2_271, math.max(v2_270.X - v2_271, v2_271))
		local v2_273 = math.clamp(v1_266.Y + v2_269.Y, 0, math.max(v2_270.Y - v1_253.AbsoluteSize.Y, 0))
		v1_253.Position = UDim2.fromOffset(v2_272, v2_273)
	end))
	self._wm = { Frame = v1_253, Button = v1_258, Icon = v1_259, Fallback = v1_260 }
	v0_10(v1_253, { Position = UDim2.new(0.5, 0, 0, 10) }, 0.5, Enum.EasingStyle.Back)
end
function v0_1:_updateWatermark()
	local v1_274 = self._wm
	if not v1_274 then return end
	local v1_275 = self._visible == true
	v0_10(v1_274.Button, { BackgroundColor3 = v1_275 and v0_7.Accent or v0_7.Element }, 0.2)
	local v1_276 = v0_42(v1_274.Icon, v1_275 and "eye" or "eye-off", self.Icons)
	if not v1_276 then v1_274.Icon.Image = "" end
	v1_274.Fallback.Visible = not v1_276
	v1_274.Fallback.Text = v1_275 and "●" or "○"
	v1_274.Icon.ImageTransparency = 1
	v0_10(v1_274.Icon, { ImageTransparency = 0 }, 0.2)
end
local function v0_277(v1_278, v1_279)
	local v1_280 = v1_278.Glow
	if not v1_280 then return end
	for v2_281, v2_282 in ipairs(v1_280.Layers) do
		v0_10(v2_282.Obj, { [v2_282.Prop] = v1_279 and v2_282.On or 1 }, 0.25, Enum.EasingStyle.Quad)
	end
end
local function v0_283(v1_284, v1_285)
	v0_10(v1_284.Icon, { ImageColor3 = v1_285 }, 0.2)
	if v1_284.Fallback then
		v0_10(v1_284.Fallback, { TextColor3 = v1_285 }, 0.2)
	end
end
function v0_1:AddTab(v1_286)
	v1_286 = v1_286 or {}
	local v1_287 = Instance.new("TextButton")
	v1_287.Name = "TabButton"
	v1_287.Size = UDim2.new(0, 36, 0, 36)
	v1_287.BackgroundColor3 = v0_7.Card
	v1_287.BorderSizePixel = 0
	v1_287.Text = ""
	v1_287.AutoButtonColor = false
	v1_287.LayoutOrder = #self.Tabs + 1
	v1_287.Parent = self.Sidebar
	v0_61(v1_287, 6)
	local v1_288 = Instance.new("ImageLabel")
	v1_288.Name = "Icon"
	v1_288.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_288.Size = UDim2.new(0, 20, 0, 20)
	v1_288.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_288.BackgroundTransparency = 1
	v1_288.BorderSizePixel = 0
	v1_288.ImageColor3 = v0_7.IconOff
	v1_288.ScaleType = Enum.ScaleType.Fit
	v1_288.Parent = v1_287
	local v1_289
	if not v0_42(v1_288, v1_286.Icon, self.Icons) then
		v1_289 = Instance.new("TextLabel")
		v1_289.Name = "IconFallback"
		v1_289.Size = UDim2.new(1, 0, 1, 0)
		v1_289.BackgroundTransparency = 1
		v1_289.Text = string.upper(string.sub(tostring(v1_286.Name or v1_286.Icon or "?"), 1, 1))
		v1_289.TextColor3 = v0_7.IconOff
		v1_289.Font = Enum.Font.GothamBold
		v1_289.TextSize = 16
		v1_289.Parent = v1_288
	end
	local v1_290
	if self.IconGlow then
		v1_287.BackgroundTransparency = 1
		v1_288.ZIndex = 2
		v1_290 = { Layers = {} }
		if v1_288.Image ~= "" then
			for v4_291, v4_292 in ipairs({ { 26, 0.55 }, { 33, 0.82 } }) do
				local v4_293 = Instance.new("ImageLabel")
				v4_293.Name = "Glow"
				v4_293.AnchorPoint = Vector2.new(0.5, 0.5)
				v4_293.Position = UDim2.new(0.5, 0, 0.5, 0)
				v4_293.Size = UDim2.new(0, v4_292[1], 0, v4_292[1])
				v4_293.BackgroundTransparency = 1
				v4_293.BorderSizePixel = 0
				v4_293.Image = v1_288.Image
				v4_293.ImageRectSize = v1_288.ImageRectSize
				v4_293.ImageRectOffset = v1_288.ImageRectOffset
				v4_293.ImageColor3 = v0_7.Accent
				v4_293.ImageTransparency = 1
				v4_293.ScaleType = Enum.ScaleType.Fit
				v4_293.ZIndex = 1
				v4_293.Parent = v1_287
				table.insert(v1_290.Layers, { Obj = v4_293, Prop = "ImageTransparency", On = v4_292[2] })
			end
		elseif v1_289 then
			local v3_294 = Instance.new("UIStroke")
			v3_294.Color = v0_7.Accent
			v3_294.Thickness = 1
			v3_294.Transparency = 1
			v3_294.Parent = v1_289
			table.insert(v1_290.Layers, { Obj = v3_294, Prop = "Transparency", On = 0.45 })
		end
	end
	local v1_295 = Instance.new("ScrollingFrame")
	v1_295.Name = "Page"
	v1_295.Size = UDim2.new(1, 0, 1, 0)
	v1_295.BackgroundTransparency = 1
	v1_295.BorderSizePixel = 0
	v1_295.ScrollBarThickness = 3
	v1_295.ScrollBarImageColor3 = v0_7.IconOff
	v1_295.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_295.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_295.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_295.Visible = false
	v1_295.Parent = self.Content
	local v1_296 = Instance.new("Frame")
	v1_296.Name = "Inner"
	v1_296.Size = UDim2.new(1, 0, 0, 0)
	v1_296.AutomaticSize = Enum.AutomaticSize.Y
	v1_296.BackgroundTransparency = 1
	v1_296.BorderSizePixel = 0
	v1_296.Parent = v1_295
	local v1_297 = Instance.new("UIPadding")
	v1_297.PaddingTop = UDim.new(0, 12)
	v1_297.PaddingBottom = UDim.new(0, 12)
	v1_297.Parent = v1_296
	local v1_298 = Instance.new("Frame")
	v1_298.Name = "Split"
	v1_298.Position = UDim2.new(0, 12, 0, 0)
	v1_298.Size = UDim2.new(1, -26, 0, 0)
	v1_298.AutomaticSize = Enum.AutomaticSize.Y
	v1_298.BackgroundTransparency = 1
	v1_298.BorderSizePixel = 0
	v1_298.Parent = v1_296
	local v1_299 = Instance.new("UIListLayout")
	v1_299.FillDirection = Enum.FillDirection.Horizontal
	v1_299.Padding = UDim.new(0, 8)
	v1_299.SortOrder = Enum.SortOrder.LayoutOrder
	v1_299.Parent = v1_298
	local function v1_300(v2_301)
		local v2_302 = Instance.new("Frame")
		v2_302.Name = v2_301 == 1 and "Left" or "Right"
		v2_302.Size = UDim2.new(0.5, -4, 0, 0)
		v2_302.AutomaticSize = Enum.AutomaticSize.Y
		v2_302.BackgroundTransparency = 1
		v2_302.BorderSizePixel = 0
		v2_302.LayoutOrder = v2_301
		v2_302.Parent = v1_298
		local v2_303 = Instance.new("UIListLayout")
		v2_303.Padding = UDim.new(0, 8)
		v2_303.SortOrder = Enum.SortOrder.LayoutOrder
		v2_303.Parent = v2_302
		return v2_302
	end
	local v1_304 = setmetatable({
		Page = v1_295,
		Button = v1_287,
		Icon = v1_288,
		Fallback = v1_289,
		Glow = v1_290,
		Inner = v1_296,
		_icons = self.Icons,
		_lib = self,
		Left = v1_300(1),
		Right = v1_300(2),
		_sectionCount = 0,
	}, v0_2)
	table.insert(self.Tabs, v1_304)
	for v2_305, v2_306 in ipairs({ "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" }) do
		table.insert(self._connections, v1_295:GetPropertyChangedSignal(v2_306):Connect(function()
			if self.ActiveTab == v1_304 then self:_updateScrollHint() end
		end))
	end
	if self.IconGlow then
		v1_287.MouseEnter:Connect(function()
			if self.ActiveTab ~= v1_304 then v0_283(v1_304, v0_7.SubText) end
		end)
		v1_287.MouseLeave:Connect(function()
			if self.ActiveTab ~= v1_304 then v0_283(v1_304, v0_7.IconOff) end
		end)
	end
	v0_19(v1_287, v0_7.Card, v0_7.Element, function()
		return self.ActiveTab == v1_304
	end)
	v1_287.MouseButton1Click:Connect(function()
		self:SelectTab(v1_304)
	end)
	if not self.ActiveTab then self:SelectTab(v1_304) end
	return v1_304
end
function v0_1:SelectTab(v1_307)
	if self.ActiveTab == v1_307 then return end
	local v1_308 = self.ActiveTab
	self.ActiveTab = v1_307
	if v1_308 then
		v1_308.Page.Visible = false
		if self.IconGlow then
			v0_277(v1_308, false)
		else
			v0_10(v1_308.Button, { BackgroundColor3 = v0_7.Card }, 0.2)
		end
		v0_283(v1_308, v0_7.IconOff)
	end
	v1_307.Inner.Position = UDim2.new(0, 0, 0, 14)
	v1_307.Page.Visible = true
	v0_10(v1_307.Inner, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)
	if self.IconGlow then
		v0_277(v1_307, true)
	else
		v0_10(v1_307.Button, { BackgroundColor3 = v0_7.Accent }, 0.2)
	end
	v0_283(v1_307, v0_7.IconOn)
	self:_updateScrollHint()
end
function v0_2:AddSection(v1_309, v1_310, v1_311)
	local v1_312 = (v1_310 == "right") and self.Right or self.Left
	local v1_313 = self._lib
	self._sectionCount += 1
	local v1_314 = Instance.new("Frame")
	v1_314.Name = "Section"
	v1_314.Size = UDim2.new(1, 0, 0, 0)
	v1_314.AutomaticSize = Enum.AutomaticSize.Y
	v1_314.BackgroundColor3 = v0_7.Card
	v1_314.BorderSizePixel = 0
	v1_314.LayoutOrder = self._sectionCount
	v1_314.Parent = v1_312
	v0_61(v1_314, 6)
	local v1_315 = Instance.new("UIPadding")
	v1_315.PaddingTop = UDim.new(0, 8)
	v1_315.PaddingBottom = UDim.new(0, 8)
	v1_315.PaddingLeft = UDim.new(0, 8)
	v1_315.PaddingRight = UDim.new(0, 8)
	v1_315.Parent = v1_314
	local v1_316 = Instance.new("UIListLayout")
	v1_316.Padding = UDim.new(0, 6)
	v1_316.SortOrder = Enum.SortOrder.LayoutOrder
	v1_316.Parent = v1_314
	local v1_317 = Instance.new("Frame")
	v1_317.Name = "Body"
	v1_317.Size = UDim2.new(1, 0, 0, 0)
	v1_317.AutomaticSize = Enum.AutomaticSize.Y
	v1_317.BackgroundTransparency = 1
	v1_317.BorderSizePixel = 0
	v1_317.LayoutOrder = 1
	v1_317.Parent = v1_314
	local v1_318 = Instance.new("UIListLayout")
	v1_318.Padding = UDim.new(0, 6)
	v1_318.SortOrder = Enum.SortOrder.LayoutOrder
	v1_318.Parent = v1_317
	local v1_319 = false
	local v1_320 = {}
	local v1_321, v1_322
	local function v1_323()
		local v2_324 = v1_313._scale and v1_313._scale.Scale or 1
		return math.max(v1_318.AbsoluteContentSize.Y / (v2_324 > 0 and v2_324 or 1), 0)
	end
	local function v1_325()
		v1_317.AutomaticSize = Enum.AutomaticSize.Y
		v1_317.Size = UDim2.new(1, 0, 0, 0)
		v1_317.ClipsDescendants = false
	end
	local function v1_326(v2_327, v2_328)
		if v2_327 == v1_319 and not v2_328 then return end
		v1_319 = v2_327
		for v3_329, v3_330 in ipairs(v1_320) do v3_330:Cancel() end
		v1_320 = {}
		if v1_321 then
			if v2_328 then
				v1_321.Rotation = v2_327 and -90 or 0
			else
				v0_10(v1_321, { Rotation = v2_327 and -90 or 0 }, 0.22, Enum.EasingStyle.Quint)
			end
		end
		if v2_328 then
			v1_317.Visible = not v2_327
			v1_316.Padding = UDim.new(0, v2_327 and 0 or 6)
			v1_325()
			return
		end
		v1_317.ClipsDescendants = true
		if v2_327 then
			if v1_317.AutomaticSize ~= Enum.AutomaticSize.None then
				local v4_331 = v1_323()
				v1_317.AutomaticSize = Enum.AutomaticSize.None
				v1_317.Size = UDim2.new(1, 0, 0, v4_331)
			end
			local v3_332 = v0_10(v1_317, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Quint)
			v1_320 = { v3_332, v0_10(v1_316, { Padding = UDim.new(0, 0) }, 0.25, Enum.EasingStyle.Quint) }
			v3_332.Completed:Connect(function(v4_333)
				if v4_333 == Enum.PlaybackState.Completed and v1_319 then
					v1_317.Visible = false
					v1_317.ClipsDescendants = false
				end
			end)
		else
			v1_317.Visible = true
			local v3_334 = v1_323()
			if v3_334 <= 0 then
				v1_316.Padding = UDim.new(0, 6)
				v1_325()
				return
			end
			if v1_317.AutomaticSize ~= Enum.AutomaticSize.None then
				v1_317.AutomaticSize = Enum.AutomaticSize.None
				v1_317.Size = UDim2.new(1, 0, 0, 0)
			end
			local v3_335 = v0_10(v1_317, { Size = UDim2.new(1, 0, 0, v3_334) }, 0.28, Enum.EasingStyle.Quint)
			v1_320 = { v3_335, v0_10(v1_316, { Padding = UDim.new(0, 6) }, 0.28, Enum.EasingStyle.Quint) }
			v3_335.Completed:Connect(function(v4_336)
				if v4_336 == Enum.PlaybackState.Completed and not v1_319 then
					v1_325()
				end
			end)
		end
	end
	if v1_309 then
		local v2_337 = Instance.new("TextButton")
		v2_337.Name = "Header"
		v2_337.Size = UDim2.new(1, 0, 0, 16)
		v2_337.BackgroundTransparency = 1
		v2_337.BorderSizePixel = 0
		v2_337.Text = ""
		v2_337.AutoButtonColor = false
		v2_337.LayoutOrder = 0
		v2_337.Parent = v1_314
		local v2_338 = Instance.new("TextLabel")
		v2_338.Name = "Title"
		v2_338.Size = UDim2.new(1, -22, 1, 0)
		v2_338.BackgroundTransparency = 1
		v2_338.BorderSizePixel = 0
		v2_338.Text = v1_309
		v2_338.TextColor3 = v0_7.SubText
		v2_338.Font = Enum.Font.GothamBold
		v2_338.TextSize = 13
		v2_338.TextXAlignment = Enum.TextXAlignment.Left
		v2_338.TextTruncate = Enum.TextTruncate.AtEnd
		v2_338.Parent = v2_337
		v1_321 = Instance.new("ImageLabel")
		v1_321.Name = "Chevron"
		v1_321.AnchorPoint = Vector2.new(1, 0.5)
		v1_321.Position = UDim2.new(1, 0, 0.5, 0)
		v1_321.Size = UDim2.new(0, 14, 0, 14)
		v1_321.BackgroundTransparency = 1
		v1_321.BorderSizePixel = 0
		v1_321.ImageColor3 = v0_7.SubText
		v1_321.ScaleType = Enum.ScaleType.Fit
		v1_321.Parent = v2_337
		v1_322 = Instance.new("TextLabel")
		v1_322.Name = "ChevronFallback"
		v1_322.Size = UDim2.new(1, 0, 1, 0)
		v1_322.BackgroundTransparency = 1
		v1_322.Text = "▼"
		v1_322.TextColor3 = v0_7.SubText
		v1_322.Font = Enum.Font.Gotham
		v1_322.TextSize = 9
		v1_322.Parent = v1_321
		v1_322.Visible = not v0_42(v1_321, "chevron-down", self._icons)
		v2_337.MouseEnter:Connect(function()
			v0_10(v2_338, { TextColor3 = v0_7.Text }, 0.12)
			v0_10(v1_321, { ImageColor3 = v0_7.Text }, 0.12)
			v0_10(v1_322, { TextColor3 = v0_7.Text }, 0.12)
		end)
		v2_337.MouseLeave:Connect(function()
			v0_10(v2_338, { TextColor3 = v0_7.SubText }, 0.15)
			v0_10(v1_321, { ImageColor3 = v0_7.SubText }, 0.15)
			v0_10(v1_322, { TextColor3 = v0_7.SubText }, 0.15)
		end)
		v2_337.MouseButton1Click:Connect(function()
			v1_326(not v1_319)
		end)
	end
	local v1_339 = setmetatable({
		Holder = v1_317,
		Card = v1_314,
		_count = 0,
		_icons = self._icons,
		_lib = self._lib,
		_setCollapsed = v1_326,
		_isCollapsed = function() return v1_319 end,
	}, v0_3)
	if v1_309 and v1_311 == true then
		v1_326(true, true)
	end
	return v1_339
end
function v0_3:SetCollapsed(v1_340)
	self._setCollapsed(v1_340 == true)
end
function v0_3:ToggleCollapsed()
	self._setCollapsed(not self._isCollapsed())
end
function v0_3:IsCollapsed()
	return self._isCollapsed()
end
local function v0_341(v1_342)
	if typeof(v1_342) == "EnumItem" and v1_342.EnumType == Enum.KeyCode then return v1_342 end
	if type(v1_342) == "string" then
		local v2_343, v2_344 = pcall(function() return Enum.KeyCode[v1_342] end)
		if v2_343 then return v2_344 end
	end
	return nil
end
local function v0_345(v1_346, v1_347, v1_348, v1_349, v1_350)
	v1_348 = v1_348 or {}
	local v1_351 = v1_348.CanBeChanged ~= false
	local v1_352 = {}
	local v1_353 = { _key = nil, _onPress = v1_350, _isListening = false, _destroyed = false }
	local v1_354 = Instance.new("TextButton")
	v1_354.Name = "Keybind"
	v1_354.AnchorPoint = Vector2.new(1, 0.5)
	v1_354.Position = v1_349
	v1_354.Size = UDim2.new(0, 0, 0, 20)
	v1_354.AutomaticSize = Enum.AutomaticSize.X
	v1_354.BackgroundColor3 = v0_7.Card
	v1_354.BorderSizePixel = 0
	v1_354.Text = "None"
	v1_354.TextColor3 = v0_7.SubText
	v1_354.Font = Enum.Font.Gotham
	v1_354.TextSize = 12
	v1_354.TextTruncate = Enum.TextTruncate.AtEnd
	v1_354.AutoButtonColor = false
	v1_354.Parent = v1_347
	v0_61(v1_354, 5)
	v1_353.Instance = v1_354
	local v1_355 = Instance.new("UIPadding")
	v1_355.PaddingLeft = UDim.new(0, 7)
	v1_355.PaddingRight = UDim.new(0, 7)
	v1_355.Parent = v1_354
	local v1_356 = Instance.new("UISizeConstraint")
	v1_356.MinSize = Vector2.new(30, 20)
	v1_356.MaxSize = Vector2.new(96, 20)
	v1_356.Parent = v1_354
	local function v1_357()
		if v1_353._isListening then
			v1_354.Text = "..."
		else
			v1_354.Text = v1_353._key and v1_353._key.Name or "None"
		end
	end
	local function v1_358()
		v1_354.BackgroundColor3 = v0_7.Danger
		v0_10(v1_354, { BackgroundColor3 = v0_7.Card }, 0.45)
	end
	function v1_353:Set(v2_359, v2_360)
		v2_359 = v0_341(v2_359)
		if v2_359 and v1_346:_keyTaken(v2_359, v1_353) then
			warn("[RobloxUI] key already in use:", v2_359.Name)
			v1_358()
			return false
		end
		v1_353._key = v2_359
		v1_357()
		if not v2_360 and v1_348.Callback then v1_348.Callback(v2_359) end
		return true
	end
	function v1_353:Get()
		return v1_353._key
	end
	function v1_353:_startListening()
		if v1_346._listening and v1_346._listening ~= v1_353 then
			v1_346._listening:_stopListening()
		end
		v1_346._listening = v1_353
		v1_353._isListening = true
		v0_10(v1_354, { BackgroundColor3 = v0_7.Accent }, 0.15)
		v1_357()
	end
	function v1_353:_stopListening()
		if v1_346._listening == v1_353 then v1_346._listening = nil end
		v1_353._isListening = false
		v0_10(v1_354, { BackgroundColor3 = v0_7.Card }, 0.15)
		v1_357()
	end
	function v1_353:_capture(v2_361)
		if v2_361 == Enum.KeyCode.Unknown then return end
		v1_353:_stopListening()
		if v2_361 == Enum.KeyCode.Escape then return end
		if v2_361 == Enum.KeyCode.Backspace or v2_361 == Enum.KeyCode.Delete then
			v1_353:Set(nil)
		else
			v1_353:Set(v2_361)
		end
	end
	function v1_353:Destroy()
		if v1_353._destroyed then return end
		v1_353._destroyed = true
		if v1_346._listening == v1_353 then v1_346._listening = nil end
		local v2_362 = table.find(v1_346._binds, v1_353)
		if v2_362 then table.remove(v1_346._binds, v2_362) end
		v1_346._cleanups[v1_353] = nil
		for v3_363, v3_364 in ipairs(v1_352) do v3_364:Disconnect() end
		v1_352 = {}
		v1_354:Destroy()
	end
	if v1_351 then
		v0_19(v1_354, v0_7.Card, v0_7.Sidebar, function() return v1_353._isListening end)
		table.insert(v1_352, v1_354.MouseButton1Click:Connect(function()
			if v1_353._isListening then v1_353:_stopListening() else v1_353:_startListening() end
		end))
		table.insert(v1_352, v1_354.MouseButton2Click:Connect(function()
			if v1_353._isListening then v1_353:_stopListening() end
			v1_353:Set(nil)
		end))
	end
	if v1_348.Key ~= nil then
		v1_353:Set(v1_348.Key, true)
	end
	table.insert(v1_346._binds, v1_353)
	v1_346._cleanups[v1_353] = function() v1_353:Destroy() end
	return v1_353
end
local function v0_365(v1_366, v1_367, v1_368)
	local v1_369 = v1_367.Instance
	local function v1_370()
		local v2_371 = math.clamp(v1_369.TextBounds.X + 14, 30, 96)
		v1_366.Size = UDim2.new(1, -(v1_368 + v2_371 + 6), 1, 0)
	end
	v1_370()
	v1_369:GetPropertyChangedSignal("TextBounds"):Connect(v1_370)
end
function v0_3:AddButton(v1_372)
	v1_372 = v1_372 or {}
	self._count += 1
	local v1_373 = Instance.new("TextButton")
	v1_373.Name = "Button"
	v1_373.Size = UDim2.new(1, 0, 0, 32)
	v1_373.BackgroundColor3 = v0_7.Element
	v1_373.BorderSizePixel = 0
	v1_373.Text = v1_372.Name or "Button"
	v1_373.TextColor3 = v0_7.Text
	v1_373.Font = Enum.Font.Gotham
	v1_373.TextSize = 14
	v1_373.TextTruncate = Enum.TextTruncate.AtEnd
	v1_373.AutoButtonColor = false
	v1_373.LayoutOrder = self._count
	v1_373.Parent = self.Holder
	v0_61(v1_373, 6)
	local v1_374 = Instance.new("UIPadding")
	v1_374.PaddingLeft = UDim.new(0, 8)
	v1_374.PaddingRight = UDim.new(0, 8)
	v1_374.Parent = v1_373
	v0_19(v1_373, v0_7.Element, v0_7.Hover)
	v1_373.MouseButton1Click:Connect(function()
		v1_373.BackgroundColor3 = v0_7.Accent
		v0_10(v1_373, { BackgroundColor3 = v0_7.Hover }, 0.3)
		if v1_372.Callback then v1_372.Callback() end
	end)
	return v1_373
end
function v0_3:AddToggle(v1_375)
	v1_375 = v1_375 or {}
	self._count += 1
	local v1_376 = v1_375.Default == true
	local v1_377 = self
	local v1_378 = Instance.new("TextButton")
	v1_378.Name = "Toggle"
	v1_378.Size = UDim2.new(1, 0, 0, 32)
	v1_378.BackgroundColor3 = v0_7.Element
	v1_378.BorderSizePixel = 0
	v1_378.Text = ""
	v1_378.AutoButtonColor = false
	v1_378.LayoutOrder = self._count
	v1_378.Parent = self.Holder
	v0_61(v1_378, 6)
	v0_19(v1_378, v0_7.Element, v0_7.Hover)
	local v1_379 = Instance.new("TextLabel")
	v1_379.Name = "Label"
	v1_379.Position = UDim2.new(0, 8, 0, 0)
	v1_379.Size = UDim2.new(1, -60, 1, 0)
	v1_379.BackgroundTransparency = 1
	v1_379.BorderSizePixel = 0
	v1_379.Text = v1_375.Name or "Toggle"
	v1_379.TextColor3 = v0_7.Text
	v1_379.Font = Enum.Font.Gotham
	v1_379.TextSize = 14
	v1_379.TextXAlignment = Enum.TextXAlignment.Left
	v1_379.TextTruncate = Enum.TextTruncate.AtEnd
	v1_379.Parent = v1_378
	local v1_380 = Instance.new("Frame")
	v1_380.Name = "Track"
	v1_380.AnchorPoint = Vector2.new(1, 0.5)
	v1_380.Position = UDim2.new(1, -8, 0.5, 0)
	v1_380.Size = UDim2.new(0, 34, 0, 18)
	v1_380.BackgroundColor3 = v0_7.Off
	v1_380.BorderSizePixel = 0
	v1_380.Parent = v1_378
	v0_61(v1_380, 9)
	local v1_381 = Instance.new("Frame")
	v1_381.Name = "Knob"
	v1_381.AnchorPoint = Vector2.new(0, 0.5)
	v1_381.Position = UDim2.new(0, 2, 0.5, 0)
	v1_381.Size = UDim2.new(0, 14, 0, 14)
	v1_381.BackgroundColor3 = v0_7.Text
	v1_381.BorderSizePixel = 0
	v1_381.Parent = v1_380
	v0_61(v1_381, 7)
	local function v1_382(v2_383)
		local v2_384 = TweenInfo.new(v2_383 and 0.15 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		v0_5:Create(v1_380, v2_384, { BackgroundColor3 = v1_376 and v0_7.Accent or v0_7.Off }):Play()
		v0_5:Create(v1_381, v2_384, {
			Position = v1_376 and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}):Play()
	end
	v1_382(false)
	local v1_385 = { Instance = v1_378 }
	function v1_385:Set(v2_386, v2_387)
		v1_376 = v2_386 and true or false
		v1_382(true)
		if not v2_387 and v1_375.Callback then v1_375.Callback(v1_376) end
	end
	function v1_385:Get()
		return v1_376
	end
	v1_378.MouseButton1Click:Connect(function()
		v1_385:Set(not v1_376)
	end)
	function v1_385:AddKeybind(v2_388)
		if v1_385.Keybind then
			warn("[RobloxUI] this toggle already has a keybind")
			return v1_385.Keybind
		end
		local v2_389 = v0_345(v1_377._lib, v1_378, v2_388, UDim2.new(1, -48, 0.5, 0), function()
			v1_385:Set(not v1_376)
		end)
		v0_365(v1_379, v2_389, 60)
		local v2_390 = v2_389.Destroy
		function v2_389:Destroy()
			v2_390(v2_389)
			v1_385.Keybind = nil
			v1_379.Size = UDim2.new(1, -60, 1, 0)
		end
		v1_385.Keybind = v2_389
		return v2_389
	end
	function v1_385:Destroy()
		if v1_385._destroyed then return end
		v1_385._destroyed = true
		if v1_385.Keybind then v1_385.Keybind:Destroy() end
		v1_378:Destroy()
	end
	return v1_385
end
function v0_3:AddParagraph(v1_391)
	v1_391 = v1_391 or {}
	self._count += 1
	local v1_392 = v1_391.Title and tostring(v1_391.Title) or ""
	local v1_393 = v1_391.Content and tostring(v1_391.Content) or ""
	local v1_394 = Instance.new("Frame")
	v1_394.Name = "Paragraph"
	v1_394.Size = UDim2.new(1, 0, 0, 0)
	v1_394.AutomaticSize = Enum.AutomaticSize.Y
	v1_394.BackgroundColor3 = v0_7.Element
	v1_394.BorderSizePixel = 0
	v1_394.LayoutOrder = self._count
	v1_394.Parent = self.Holder
	v0_61(v1_394, 6)
	local v1_395 = Instance.new("UIPadding")
	v1_395.PaddingTop = UDim.new(0, 8)
	v1_395.PaddingBottom = UDim.new(0, 8)
	v1_395.PaddingLeft = UDim.new(0, 8)
	v1_395.PaddingRight = UDim.new(0, 8)
	v1_395.Parent = v1_394
	local v1_396 = Instance.new("UIListLayout")
	v1_396.Padding = UDim.new(0, 3)
	v1_396.SortOrder = Enum.SortOrder.LayoutOrder
	v1_396.Parent = v1_394
	local function v1_397(v2_398, v2_399, v2_400, v2_401, v2_402)
		local v2_403 = Instance.new("TextLabel")
		v2_403.Name = v2_398
		v2_403.Size = UDim2.new(1, 0, 0, 0)
		v2_403.AutomaticSize = Enum.AutomaticSize.Y
		v2_403.BackgroundTransparency = 1
		v2_403.BorderSizePixel = 0
		v2_403.TextColor3 = v2_401
		v2_403.Font = v2_399
		v2_403.TextSize = v2_400
		v2_403.TextWrapped = true
		v2_403.RichText = v1_391.RichText == true
		v2_403.TextXAlignment = Enum.TextXAlignment.Left
		v2_403.TextYAlignment = Enum.TextYAlignment.Top
		v2_403.LayoutOrder = v2_402
		v2_403.Parent = v1_394
		return v2_403
	end
	local v1_404 = v1_397("Title", Enum.Font.GothamBold, 14, v0_7.Text, 1)
	local v1_405 = v1_397("Content", Enum.Font.Gotham, 13, v0_7.SubText, 2)
	local function v1_406(v2_407)
		v1_404.Text = v1_392
		v1_404.Visible = v1_392 ~= ""
		v1_405.Text = v1_393
		v1_405.Visible = v1_393 ~= ""
		if v2_407 then
			v1_404.TextTransparency = 1
			v1_405.TextTransparency = 1
			v0_10(v1_404, { TextTransparency = 0 }, 0.2)
			v0_10(v1_405, { TextTransparency = 0 }, 0.2)
		end
	end
	v1_406(false)
	local v1_408 = { Instance = v1_394 }
	function v1_408:SetTitle(v2_409)
		v1_392 = v2_409 and tostring(v2_409) or ""
		v1_406(true)
	end
	function v1_408:SetContent(v2_410)
		v1_393 = v2_410 and tostring(v2_410) or ""
		v1_406(true)
	end
	function v1_408:Set(v2_411)
		v2_411 = v2_411 or {}
		if v2_411.Title ~= nil then v1_392 = tostring(v2_411.Title) end
		if v2_411.Content ~= nil then v1_393 = tostring(v2_411.Content) end
		v1_406(true)
	end
	function v1_408:Get()
		return v1_392, v1_393
	end
	function v1_408:Destroy()
		v1_394:Destroy()
	end
	return v1_408
end
function v0_3:AddTextbox(v1_412)
	v1_412 = v1_412 or {}
	self._count += 1
	local v1_413 = v1_412.Numeric == true
	local v1_414 = tonumber(v1_412.MaxLength)
	local v1_415 = v1_412.Name ~= nil and v1_412.Name ~= ""
	local v1_416, v1_417, v1_418 = false, false, false
	local function v1_419(v2_420)
		if v1_412.Min then v2_420 = math.max(v2_420, v1_412.Min) end
		if v1_412.Max then v2_420 = math.min(v2_420, v1_412.Max) end
		return v2_420
	end
	local v1_421
	if v1_413 then
		v1_421 = tonumber(v1_412.Default)
		if v1_421 then v1_421 = v1_419(v1_421) end
	else
		v1_421 = tostring(v1_412.Default or "")
	end
	local function v1_422(v2_423)
		return v2_423 == nil and "" or tostring(v2_423)
	end
	local function v1_424(v2_425)
		local v2_426 = v2_425:sub(1, 1) == "-"
		v2_425 = v2_425:gsub("[^%d%.]", "")
		local v2_427 = v2_425:find(".", 1, true)
		if v2_427 then
			local v3_428 = v2_425:sub(v2_427 + 1):gsub("%.", "")
			v2_425 = v2_425:sub(1, v2_427) .. v3_428
		end
		return (v2_426 and "-" or "") .. v2_425
	end
	local v1_429 = Instance.new("Frame")
	v1_429.Name = "Textbox"
	v1_429.Size = UDim2.new(1, 0, 0, 32)
	v1_429.BackgroundColor3 = v0_7.Element
	v1_429.BorderSizePixel = 0
	v1_429.LayoutOrder = self._count
	v1_429.Parent = self.Holder
	v0_61(v1_429, 6)
	if v1_415 then
		local v2_430 = Instance.new("TextLabel")
		v2_430.Name = "Label"
		v2_430.Position = UDim2.new(0, 8, 0, 0)
		v2_430.Size = UDim2.new(0.4, -8, 1, 0)
		v2_430.BackgroundTransparency = 1
		v2_430.BorderSizePixel = 0
		v2_430.Text = v1_412.Name
		v2_430.TextColor3 = v0_7.Text
		v2_430.Font = Enum.Font.Gotham
		v2_430.TextSize = 14
		v2_430.TextXAlignment = Enum.TextXAlignment.Left
		v2_430.TextTruncate = Enum.TextTruncate.AtEnd
		v2_430.Parent = v1_429
	end
	local v1_431 = Instance.new("Frame")
	v1_431.Name = "BoxHolder"
	v1_431.AnchorPoint = Vector2.new(1, 0.5)
	v1_431.Position = UDim2.new(1, -6, 0.5, 0)
	v1_431.Size = v1_415 and UDim2.new(0.6, -10, 0, 22) or UDim2.new(1, -12, 0, 22)
	v1_431.BackgroundColor3 = v0_7.Card
	v1_431.BorderSizePixel = 0
	v1_431.Parent = v1_429
	v0_61(v1_431, 5)
	local v1_432 = Instance.new("UIStroke")
	v1_432.Color = v0_7.Accent
	v1_432.Thickness = 1
	v1_432.Transparency = 1
	v1_432.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_432.Parent = v1_431
	local v1_433 = Instance.new("TextBox")
	v1_433.Name = "Input"
	v1_433.Size = UDim2.new(1, 0, 1, 0)
	v1_433.BackgroundTransparency = 1
	v1_433.BorderSizePixel = 0
	v1_433.Text = v1_422(v1_421)
	v1_433.PlaceholderText = v1_412.Placeholder or ""
	v1_433.PlaceholderColor3 = v0_7.IconOff
	v1_433.TextColor3 = v0_7.Text
	v1_433.Font = Enum.Font.Gotham
	v1_433.TextSize = 13
	v1_433.TextXAlignment = Enum.TextXAlignment.Left
	v1_433.ClearTextOnFocus = v1_412.ClearTextOnFocus == true
	v1_433.ClipsDescendants = true
	v1_433.Parent = v1_431
	local v1_434 = Instance.new("UIPadding")
	v1_434.PaddingLeft = UDim.new(0, 6)
	v1_434.PaddingRight = UDim.new(0, 6)
	v1_434.Parent = v1_433
	local function v1_435()
		v0_10(v1_431, { BackgroundColor3 = (v1_417 and not v1_416) and v0_7.Sidebar or v0_7.Card }, 0.12)
		v0_10(v1_432, { Transparency = v1_416 and 0 or 1 }, 0.15)
	end
	v1_433:GetPropertyChangedSignal("Text"):Connect(function()
		if v1_418 then return end
		local v2_436 = v1_433.Text
		if v1_413 then v2_436 = v1_424(v2_436) end
		if v1_414 and #v2_436 > v1_414 then v2_436 = v2_436:sub(1, v1_414) end
		if v2_436 ~= v1_433.Text then
			v1_418 = true
			v1_433.Text = v2_436
			v1_418 = false
		end
	end)
	v1_433.Focused:Connect(function()
		v1_416 = true
		v1_435()
	end)
	v1_433.FocusLost:Connect(function(v2_437)
		v1_416 = false
		v1_435()
		if v1_413 then
			local v3_438 = tonumber(v1_433.Text)
			if v3_438 == nil then
				v1_433.Text = v1_422(v1_421)
				return
			end
			v3_438 = v1_419(v3_438)
			v1_421 = v3_438
			v1_433.Text = v1_422(v3_438)
		else
			v1_421 = v1_433.Text
		end
		if v1_412.Callback then v1_412.Callback(v1_421, v2_437) end
	end)
	v1_431.MouseEnter:Connect(function()
		v1_417 = true
		v1_435()
	end)
	v1_431.MouseLeave:Connect(function()
		v1_417 = false
		v1_435()
	end)
	local v1_439 = { Instance = v1_429 }
	function v1_439:Set(v2_440, v2_441)
		if v1_413 then
			local v3_442 = tonumber(v2_440)
			if v3_442 == nil then return end
			v1_421 = v1_419(v3_442)
		else
			v1_421 = tostring(v2_440 == nil and "" or v2_440)
			if v1_414 then v1_421 = v1_421:sub(1, v1_414) end
		end
		v1_433.Text = v1_422(v1_421)
		if not v2_441 and v1_412.Callback then v1_412.Callback(v1_421, false) end
	end
	function v1_439:Get()
		return v1_421
	end
	function v1_439:Focus()
		v1_433:CaptureFocus()
	end
	function v1_439:Destroy()
		if v1_433:IsFocused() then v1_433:ReleaseFocus() end
		v1_429:Destroy()
	end
	return v1_439
end
function v0_3:AddKeybind(v1_443)
	v1_443 = v1_443 or {}
	self._count += 1
	local v1_444 = Instance.new("Frame")
	v1_444.Name = "KeybindRow"
	v1_444.Size = UDim2.new(1, 0, 0, 32)
	v1_444.BackgroundColor3 = v0_7.Element
	v1_444.BorderSizePixel = 0
	v1_444.LayoutOrder = self._count
	v1_444.Parent = self.Holder
	v0_61(v1_444, 6)
	local v1_445 = Instance.new("TextLabel")
	v1_445.Name = "Label"
	v1_445.Position = UDim2.new(0, 8, 0, 0)
	v1_445.Size = UDim2.new(1, -60, 1, 0)
	v1_445.BackgroundTransparency = 1
	v1_445.BorderSizePixel = 0
	v1_445.Text = v1_443.Name or "Keybind"
	v1_445.TextColor3 = v0_7.Text
	v1_445.Font = Enum.Font.Gotham
	v1_445.TextSize = 14
	v1_445.TextXAlignment = Enum.TextXAlignment.Left
	v1_445.TextTruncate = Enum.TextTruncate.AtEnd
	v1_445.Parent = v1_444
	local v1_446 = v0_345(self._lib, v1_444, v1_443, UDim2.new(1, -8, 0.5, 0), function()
		if v1_443.OnPress then v1_443.OnPress() end
	end)
	v0_365(v1_445, v1_446, 16)
	v1_446.Row = v1_444
	local v1_447 = v1_446.Destroy
	function v1_446:Destroy()
		v1_447(v1_446)
		v1_444:Destroy()
	end
	return v1_446
end
function v0_3:AddSlider(v1_448)
	v1_448 = v1_448 or {}
	self._count += 1
	local v1_449 = self._lib
	local function v1_450(v2_451)
		return #(tostring(v2_451):match("%.(%d+)") or "")
	end
	local v1_452 = tonumber(v1_448.Min) or 0
	local v1_453 = tonumber(v1_448.Max) or 100
	if v1_453 < v1_452 then v1_452, v1_453 = v1_453, v1_452 end
	local v1_454 = tonumber(v1_448.Increment) or 1
	if v1_454 <= 0 then v1_454 = 1 end
	local v1_455 = math.max(v1_450(v1_454), v1_450(v1_452))
	local v1_456 = v1_448.ValueName
	local function v1_457(v2_458)
		v2_458 = math.clamp(v2_458, v1_452, v1_453)
		v2_458 = v1_452 + math.floor((v2_458 - v1_452) / v1_454 + 0.5) * v1_454
		v2_458 = math.clamp(v2_458, v1_452, v1_453)
		local v2_459 = 10 ^ v1_455
		return math.floor(v2_458 * v2_459 + 0.5) / v2_459
	end
	local function v1_460(v2_461)
		return v1_453 > v1_452 and (v2_461 - v1_452) / (v1_453 - v1_452) or 0
	end
	local function v1_462(v2_463)
		local v2_464 = v1_455 > 0 and string.format("%." .. v1_455 .. "f", v2_463) or tostring(v2_463)
		if v1_456 and v1_456 ~= "" then v2_464 = v2_464 .. " " .. tostring(v1_456) end
		return v2_464
	end
	local v1_465 = v1_457(tonumber(v1_448.Default) or v1_452)
	local v1_466, v1_467 = false, false
	local v1_468 = nil
	local v1_469 = Instance.new("Frame")
	v1_469.Name = "Slider"
	v1_469.Size = UDim2.new(1, 0, 0, 46)
	v1_469.BackgroundColor3 = v0_7.Element
	v1_469.BorderSizePixel = 0
	v1_469.LayoutOrder = self._count
	v1_469.Parent = self.Holder
	v0_61(v1_469, 6)
	local v1_470 = Instance.new("TextLabel")
	v1_470.Name = "Name"
	v1_470.Position = UDim2.new(0, 8, 0, 6)
	v1_470.Size = UDim2.new(0.6, -8, 0, 16)
	v1_470.BackgroundTransparency = 1
	v1_470.BorderSizePixel = 0
	v1_470.Text = v1_448.Name or "Slider"
	v1_470.TextColor3 = v0_7.Text
	v1_470.Font = Enum.Font.Gotham
	v1_470.TextSize = 14
	v1_470.TextXAlignment = Enum.TextXAlignment.Left
	v1_470.TextTruncate = Enum.TextTruncate.AtEnd
	v1_470.Parent = v1_469
	local v1_471 = Instance.new("TextLabel")
	v1_471.Name = "Value"
	v1_471.Position = UDim2.new(0.6, 0, 0, 6)
	v1_471.Size = UDim2.new(0.4, -8, 0, 16)
	v1_471.BackgroundTransparency = 1
	v1_471.BorderSizePixel = 0
	v1_471.Text = v1_462(v1_465)
	v1_471.TextColor3 = v0_7.SubText
	v1_471.Font = Enum.Font.GothamBold
	v1_471.TextSize = 13
	v1_471.TextXAlignment = Enum.TextXAlignment.Right
	v1_471.TextTruncate = Enum.TextTruncate.AtEnd
	v1_471.Parent = v1_469
	local v1_472 = Instance.new("Frame")
	v1_472.Name = "Track"
	v1_472.Position = UDim2.new(0, 8, 0, 31)
	v1_472.Size = UDim2.new(1, -16, 0, 6)
	v1_472.BackgroundColor3 = v0_7.Off
	v1_472.BorderSizePixel = 0
	v1_472.Parent = v1_469
	local v1_473 = Instance.new("Frame")
	v1_473.Name = "Fill"
	v1_473.Size = UDim2.new(v1_460(v1_465), 0, 1, 0)
	v1_473.BackgroundColor3 = v0_7.Accent
	v1_473.BorderSizePixel = 0
	v1_473.Parent = v1_472
	local v1_474 = v0_7.Accent
	local v1_475 = v0_7.Accent:Lerp(v0_7.Text, 0.25)
	local v1_476 = Instance.new("TextButton")
	v1_476.Name = "Hit"
	v1_476.Size = UDim2.new(1, 0, 1, 0)
	v1_476.BackgroundTransparency = 1
	v1_476.BorderSizePixel = 0
	v1_476.Text = ""
	v1_476.AutoButtonColor = false
	v1_476.Parent = v1_469
	local function v1_477()
		local v2_478 = v1_466 or v1_467
		v0_10(v1_469, { BackgroundColor3 = v2_478 and v0_7.Hover or v0_7.Element }, 0.12)
		v0_10(v1_473, { BackgroundColor3 = v2_478 and v1_475 or v1_474 }, 0.12)
	end
	local function v1_479(v2_480)
		local v2_481 = v1_460(v1_465)
		v0_10(v1_473, { Size = UDim2.new(v2_481, 0, 1, 0) }, v2_480)
		v1_471.Text = v1_462(v1_465)
	end
	local function v1_482(v2_483, v2_484, v2_485)
		v2_483 = v1_457(v2_483)
		local v2_486 = v2_483 ~= v1_465
		v1_465 = v2_483
		v1_479(v2_485)
		if v2_486 then
			v1_471.TextColor3 = v0_7.Text
			v0_10(v1_471, { TextColor3 = v0_7.SubText }, 0.3)
			if not v2_484 and v1_448.Callback then v1_448.Callback(v1_465) end
		end
	end
	local function v1_487(v2_488)
		local v2_489 = v1_472.AbsoluteSize.X
		if v2_489 <= 0 then return end
		v1_482(v1_452 + ((v2_488 - v1_472.AbsolutePosition.X) / v2_489) * (v1_453 - v1_452), false, 0.08)
	end
	local function v1_490()
		if v1_468 then
			for v4_491, v4_492 in ipairs(v1_468) do v4_492:Disconnect() end
			v1_468 = nil
		end
		if v1_467 then
			v1_467 = false
			v1_477()
		end
	end
	local function v1_493(v2_494)
		v1_490()
		v1_467 = true
		v1_477()
		v1_487(v2_494.Position.X)
		v1_468 = {
			v0_4.InputChanged:Connect(function(v3_495)
				if v3_495.UserInputType == Enum.UserInputType.MouseMovement or v3_495 == v2_494 then
					v1_487(v3_495.Position.X)
				end
			end),
			v0_4.InputEnded:Connect(function(v3_496)
				if v3_496 == v2_494 or v3_496.UserInputType == Enum.UserInputType.MouseButton1 then
					v1_490()
				end
			end),
		}
	end
	v1_476.InputBegan:Connect(function(v2_497)
		if v0_17(v2_497) then v1_493(v2_497) end
	end)
	v1_476.MouseEnter:Connect(function()
		v1_466 = true
		v1_477()
	end)
	v1_476.MouseLeave:Connect(function()
		v1_466 = false
		v1_477()
	end)
	local v1_498 = { Instance = v1_469 }
	function v1_498:Set(v2_499, v2_500)
		v1_482(tonumber(v2_499) or v1_465, v2_500, 0.2)
	end
	function v1_498:Get()
		return v1_465
	end
	function v1_498:Destroy()
		v1_490()
		v1_449._cleanups[v1_498] = nil
		v1_469:Destroy()
	end
	v1_449._cleanups[v1_498] = v1_490
	return v1_498
end
function v0_3:AddDropdown(v1_501)
	v1_501 = v1_501 or {}
	self._count += 1
	local v1_502 = v1_501.Options or {}
	local v1_503 = v1_501.Multi == true
	local v1_504 = 130
	local v1_505, v1_506 = 26, 4
	local v1_507 = nil
	local v1_508 = {}
	local v1_509 = {}
	local v1_510 = false
	local v1_511 = 0
	local v1_512 = nil
	local v1_513 = Instance.new("Frame")
	v1_513.Name = "Dropdown"
	v1_513.Size = UDim2.new(1, 0, 0, 32)
	v1_513.AutomaticSize = Enum.AutomaticSize.Y
	v1_513.BackgroundTransparency = 1
	v1_513.BorderSizePixel = 0
	v1_513.LayoutOrder = self._count
	v1_513.Parent = self.Holder
	local v1_514 = Instance.new("UIListLayout")
	v1_514.Padding = UDim.new(0, 4)
	v1_514.SortOrder = Enum.SortOrder.LayoutOrder
	v1_514.Parent = v1_513
	local v1_515 = Instance.new("TextButton")
	v1_515.Name = "Header"
	v1_515.Size = UDim2.new(1, 0, 0, 32)
	v1_515.BackgroundColor3 = v0_7.Element
	v1_515.BorderSizePixel = 0
	v1_515.Text = ""
	v1_515.AutoButtonColor = false
	v1_515.LayoutOrder = 1
	v1_515.Parent = v1_513
	v0_61(v1_515, 6)
	v0_19(v1_515, v0_7.Element, v0_7.Hover)
	local v1_516 = Instance.new("TextLabel")
	v1_516.Name = "Name"
	v1_516.Position = UDim2.new(0, 8, 0, 0)
	v1_516.Size = UDim2.new(0.5, -8, 1, 0)
	v1_516.BackgroundTransparency = 1
	v1_516.BorderSizePixel = 0
	v1_516.Text = v1_501.Name or "Dropdown"
	v1_516.TextColor3 = v0_7.Text
	v1_516.Font = Enum.Font.Gotham
	v1_516.TextSize = 14
	v1_516.TextXAlignment = Enum.TextXAlignment.Left
	v1_516.TextTruncate = Enum.TextTruncate.AtEnd
	v1_516.Parent = v1_515
	local v1_517 = Instance.new("TextLabel")
	v1_517.Name = "Value"
	v1_517.Position = UDim2.new(0.5, 0, 0, 0)
	v1_517.Size = UDim2.new(0.5, -28, 1, 0)
	v1_517.BackgroundTransparency = 1
	v1_517.BorderSizePixel = 0
	v1_517.Text = "None"
	v1_517.TextColor3 = v0_7.SubText
	v1_517.Font = Enum.Font.Gotham
	v1_517.TextSize = 13
	v1_517.TextXAlignment = Enum.TextXAlignment.Right
	v1_517.TextTruncate = Enum.TextTruncate.AtEnd
	v1_517.Parent = v1_515
	local v1_518 = Instance.new("ImageLabel")
	v1_518.Name = "Arrow"
	v1_518.AnchorPoint = Vector2.new(1, 0.5)
	v1_518.Position = UDim2.new(1, -8, 0.5, 0)
	v1_518.Size = UDim2.new(0, 16, 0, 16)
	v1_518.BackgroundTransparency = 1
	v1_518.BorderSizePixel = 0
	v1_518.ImageColor3 = v0_7.SubText
	v1_518.ScaleType = Enum.ScaleType.Fit
	v1_518.Parent = v1_515
	local v1_519 = Instance.new("TextLabel")
	v1_519.Name = "ArrowFallback"
	v1_519.Size = UDim2.new(1, 0, 1, 0)
	v1_519.BackgroundTransparency = 1
	v1_519.Text = "▼"
	v1_519.TextColor3 = v0_7.SubText
	v1_519.Font = Enum.Font.Gotham
	v1_519.TextSize = 9
	v1_519.Visible = false
	v1_519.Parent = v1_518
	local function v1_520(v2_521)
		local v2_522 = v0_42(v1_518, v2_521 and "chevron-up" or "chevron-down", self._icons)
		if not v2_522 then v1_518.Image = "" end
		v1_519.Visible = not v2_522
		v1_519.Text = v2_521 and "▲" or "▼"
		v1_518.ImageTransparency = 1
		v1_519.TextTransparency = 1
		v0_10(v1_518, { ImageTransparency = 0 }, 0.18)
		v0_10(v1_519, { TextTransparency = 0 }, 0.18)
	end
	v1_520(false)
	local v1_523 = Instance.new("ScrollingFrame")
	v1_523.Name = "List"
	v1_523.Size = UDim2.new(1, 0, 0, 0)
	v1_523.BackgroundColor3 = v0_7.Sidebar
	v1_523.BorderSizePixel = 0
	v1_523.ScrollBarThickness = 3
	v1_523.ScrollBarImageColor3 = v0_7.IconOff
	v1_523.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_523.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_523.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_523.Visible = false
	v1_523.LayoutOrder = 2
	v1_523.Parent = v1_513
	v0_61(v1_523, 6)
	local v1_524 = Instance.new("UIPadding")
	v1_524.PaddingTop = UDim.new(0, 4)
	v1_524.PaddingBottom = UDim.new(0, 4)
	v1_524.Parent = v1_523
	local v1_525 = Instance.new("UIListLayout")
	v1_525.Padding = UDim.new(0, v1_506)
	v1_525.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_525.SortOrder = Enum.SortOrder.LayoutOrder
	v1_525.Parent = v1_523
	local function v1_526(v2_527)
		if v1_503 then return v1_508[v2_527] == true end
		return v1_507 == v2_527
	end
	local function v1_528()
		local v2_529 = {}
		for v3_530, v3_531 in ipairs(v1_502) do
			if v1_508[v3_531] then table.insert(v2_529, v3_531) end
		end
		return v2_529
	end
	local function v1_532()
		for v3_533, v3_534 in pairs(v1_509) do
			local v3_535 = v1_526(v3_533)
			v3_534.BackgroundColor3 = v3_535 and v0_7.Accent or v0_7.Element
			v3_534.TextColor3 = v3_535 and v0_7.IconOn or v0_7.SubText
		end
		if v1_503 then
			local v3_536 = {}
			for v4_537, v4_538 in ipairs(v1_528()) do table.insert(v3_536, tostring(v4_538)) end
			v1_517.Text = #v3_536 > 0 and table.concat(v3_536, ", ") or "None"
		else
			v1_517.Text = v1_507 ~= nil and tostring(v1_507) or "None"
		end
	end
	local function v1_539(v2_540)
		if v1_510 == v2_540 then return end
		v1_510 = v2_540
		if v1_512 then v1_512:Cancel() end
		v1_520(v2_540)
		if v2_540 then
			v1_523.Visible = true
			v1_512 = v0_10(v1_523, { Size = UDim2.new(1, 0, 0, v1_511) }, 0.22, Enum.EasingStyle.Quint)
		else
			local v3_541 = v0_10(v1_523, { Size = UDim2.new(1, 0, 0, 0) }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v1_512 = v3_541
			v3_541.Completed:Connect(function(v4_542)
				if v4_542 == Enum.PlaybackState.Completed and not v1_510 then
					v1_523.Visible = false
				end
			end)
		end
	end
	local v1_543 = { Instance = v1_513 }
	local function v1_544()
		if v1_501.Callback then
			v1_501.Callback(v1_503 and v1_528() or v1_507)
		end
	end
	local function v1_545()
		for v3_546, v3_547 in pairs(v1_509) do v3_547:Destroy() end
		v1_509 = {}
		for v3_548, v3_549 in ipairs(v1_502) do
			local v3_550 = Instance.new("TextButton")
			v3_550.Name = "Option"
			v3_550.Size = UDim2.new(1, -8, 0, v1_505)
			v3_550.BackgroundColor3 = v0_7.Element
			v3_550.BorderSizePixel = 0
			v3_550.Text = tostring(v3_549)
			v3_550.TextColor3 = v0_7.SubText
			v3_550.Font = Enum.Font.Gotham
			v3_550.TextSize = 13
			v3_550.TextTruncate = Enum.TextTruncate.AtEnd
			v3_550.AutoButtonColor = true
			v3_550.LayoutOrder = v3_548
			v3_550.Parent = v1_523
			v0_61(v3_550, 5)
			v3_550.MouseButton1Click:Connect(function()
				if v1_503 then
					v1_508[v3_549] = not v1_508[v3_549] or nil
					v1_532()
					v1_544()
				else
					v1_507 = v3_549
					v1_532()
					v1_539(false)
					v1_544()
				end
			end)
			v1_509[v3_549] = v3_550
		end
		local v2_551 = #v1_502
		local v2_552 = v2_551 > 0 and (v2_551 * v1_505 + (v2_551 - 1) * v1_506 + 8) or 0
		v1_511 = math.min(v2_552, v1_504)
		v1_523.Size = UDim2.new(1, 0, 0, v1_510 and v1_511 or 0)
		v1_532()
	end
	function v1_543:Set(v2_553, v2_554)
		if v1_503 then
			v1_508 = {}
			for v4_555, v4_556 in ipairs(typeof(v2_553) == "table" and v2_553 or { v2_553 }) do
				v1_508[v4_556] = true
			end
		else
			v1_507 = v2_553
		end
		v1_532()
		if not v2_554 then v1_544() end
	end
	function v1_543:Get()
		return v1_503 and v1_528() or v1_507
	end
	function v1_543:Refresh(v2_557, v2_558)
		v1_502 = v2_557 or {}
		if v2_558 then
			local v3_559 = {}
			for v4_560, v4_561 in ipairs(v1_502) do v3_559[v4_561] = true end
			if v1_503 then
				for v5_562 in pairs(v1_508) do
					if not v3_559[v5_562] then v1_508[v5_562] = nil end
				end
			elseif not v3_559[v1_507] then
				v1_507 = nil
			end
		else
			v1_508, v1_507 = {}, nil
		end
		v1_545()
	end
	function v1_543:Open() v1_539(true) end
	function v1_543:Close() v1_539(false) end
	v1_515.MouseButton1Click:Connect(function()
		v1_539(not v1_510)
	end)
	v1_545()
	if v1_501.Default ~= nil then
		v1_543:Set(v1_501.Default, true)
	end
	return v1_543
end
return v0_1
