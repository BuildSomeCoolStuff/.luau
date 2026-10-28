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
function v0_1:Destroy()
	for v2_148, v2_149 in ipairs(self._connections) do
		v2_149:Disconnect()
	end
	self._connections = {}
	self._destroyed = true
	if self._hint then pcall(self._hint.HideTip, true) end
	for v2_150, v2_151 in ipairs(table.clone(self._notifs or {})) do pcall(v2_151) end
	for v2_152, v2_153 in pairs(self._cleanups) do pcall(v2_153) end
	self._cleanups = {}
	self._binds = {}
	self._listening = nil
	self.ScreenGui:Destroy()
end
local v0_154, v0_155 = 0.35, 0.2
function v0_1:_cancelAnim()
	if self._anim then
		for v3_156, v3_157 in ipairs(self._anim) do v3_157:Cancel() end
		self._anim = nil
	end
end
function v0_1:Show()
	if self._destroyed then return end
	self._visible = true
	self:_cancelAnim()
	self.Main.Visible = true
	self._anim = {
		v0_10(self.Main, { GroupTransparency = 0 }, v0_154, Enum.EasingStyle.Quint),
		v0_10(self._scale, { Scale = 1 }, v0_154, Enum.EasingStyle.Back),
	}
	self:_updateWatermark()
end
function v0_1:Hide()
	if self._destroyed or not self._visible then return end
	self._visible = false
	self:_cancelAnim()
	local v1_158 = v0_4:GetFocusedTextBox()
	if v1_158 and v1_158:IsDescendantOf(self.Main) then v1_158:ReleaseFocus() end
	local v1_159 = v0_10(self.Main, { GroupTransparency = 1 }, v0_155, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local v1_160 = v0_10(self._scale, { Scale = 0.92 }, v0_155, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	self._anim = { v1_159, v1_160 }
	v1_159.Completed:Connect(function(v2_161)
		if v2_161 == Enum.PlaybackState.Completed and not self._visible and not self._destroyed then
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
	local v1_162 = self._hint
	if not v1_162 or self._destroyed then return end
	local v1_163 = self.ActiveTab and self.ActiveTab.Page
	local v1_164 = false
	if v1_163 and v1_163.Visible then
		local v2_165 = v1_163.AbsoluteCanvasSize.Y - (v1_163.CanvasPosition.Y + v1_163.AbsoluteWindowSize.Y)
		v1_164 = v2_165 > 4
	end
	if v1_164 == v1_162.Shown then return end
	v1_162.Shown = v1_164
	if v1_162.Fade then v1_162.Fade:Cancel() end
	if v1_164 then
		v1_162.Frame.Visible = true
		v1_162.Icon.Position = UDim2.new(0.5, 0, 0.5, -3)
		v1_162.Bounce:Play()
		v1_162.Fade = v0_10(v1_162.Frame, { GroupTransparency = 0.15 }, 0.2)
	else
		v1_162.HideTip()
		local v2_166 = v0_10(v1_162.Frame, { GroupTransparency = 1 }, 0.2)
		v1_162.Fade = v2_166
		v2_166.Completed:Connect(function(v3_167)
			if v3_167 == Enum.PlaybackState.Completed and not v1_162.Shown then
				v1_162.Bounce:Cancel()
				v1_162.Frame.Visible = false
			end
		end)
	end
end
function v0_1:_keyTaken(v1_168, v1_169)
	if not v1_168 then return false end
	if v1_168 == self._toggleKey then return true end
	for v2_170, v2_171 in ipairs(self._binds) do
		if v2_171 ~= v1_169 and v2_171._key == v1_168 then return true end
	end
	return false
end
local v0_172, v0_173 = 280, 5
function v0_1:_getNotifyContainer()
	if self._notifyContainer and self._notifyContainer.Parent then
		return self._notifyContainer
	end
	local v1_174 = self.ScreenGui.AbsoluteSize
	local v1_175 = v1_174.X > 0 and math.min(v0_172, v1_174.X - 20) or v0_172
	local v1_176 = Instance.new("Frame")
	v1_176.Name = "Notifications"
	v1_176.AnchorPoint = Vector2.new(0.5, 0)
	v1_176.Position = UDim2.new(0.5, 0, 0, self._wm and 48 or 10)
	v1_176.Size = UDim2.new(0, v1_175, 0, 0)
	v1_176.AutomaticSize = Enum.AutomaticSize.Y
	v1_176.BackgroundTransparency = 1
	v1_176.BorderSizePixel = 0
	v1_176.Parent = self.ScreenGui
	local v1_177 = Instance.new("UIListLayout")
	v1_177.Padding = UDim.new(0, 6)
	v1_177.SortOrder = Enum.SortOrder.LayoutOrder
	v1_177.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_177.Parent = v1_176
	self._notifyContainer = v1_176
	return v1_176
end
function v0_1:Notify(v1_178)
	if self._destroyed then return end
	if type(v1_178) == "string" then v1_178 = { Content = v1_178 } end
	v1_178 = v1_178 or {}
	local v1_179 = tonumber(v1_178.Duration) or 4
	local v1_180 = self:_getNotifyContainer()
	self._notifyCount = (self._notifyCount or 0) + 1
	self._notifs = self._notifs or {}
	local v1_181 = false
	local v1_182 = Instance.new("Frame")
	v1_182.Name = "Notification"
	v1_182.Size = UDim2.new(1, 0, 0, 0)
	v1_182.BackgroundTransparency = 1
	v1_182.BorderSizePixel = 0
	v1_182.LayoutOrder = self._notifyCount
	v1_182.Parent = v1_180
	local v1_183 = Instance.new("CanvasGroup")
	v1_183.Name = "Card"
	v1_183.Size = UDim2.new(1, 0, 0, 0)
	v1_183.AutomaticSize = Enum.AutomaticSize.Y
	v1_183.BackgroundColor3 = v0_7.Sidebar
	v1_183.BorderSizePixel = 0
	v1_183.GroupTransparency = 1
	v1_183.Parent = v1_182
	v0_61(v1_183, 8)
	local v1_184 = Instance.new("UIStroke")
	v1_184.Color = v0_7.Element
	v1_184.Thickness = 1
	v1_184.Transparency = 1
	v1_184.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_184.Parent = v1_183
	local v1_185 = Instance.new("Frame")
	v1_185.Name = "Body"
	v1_185.Size = UDim2.new(1, 0, 0, 0)
	v1_185.AutomaticSize = Enum.AutomaticSize.Y
	v1_185.BackgroundTransparency = 1
	v1_185.BorderSizePixel = 0
	v1_185.Parent = v1_183
	local v1_186 = Instance.new("UIPadding")
	v1_186.PaddingTop = UDim.new(0, 8)
	v1_186.PaddingBottom = UDim.new(0, 8)
	v1_186.PaddingLeft = UDim.new(0, 12)
	v1_186.PaddingRight = UDim.new(0, 12)
	v1_186.Parent = v1_185
	local v1_187 = Instance.new("UISizeConstraint")
	v1_187.MinSize = Vector2.new(0, 30)
	v1_187.Parent = v1_185
	local v1_188 = Instance.new("Frame")
	v1_188.Name = "Texts"
	v1_188.Position = UDim2.new(0, 0, 0, 0)
	v1_188.Size = UDim2.new(1, 0, 0, 0)
	v1_188.AutomaticSize = Enum.AutomaticSize.Y
	v1_188.BackgroundTransparency = 1
	v1_188.BorderSizePixel = 0
	v1_188.Parent = v1_185
	local v1_189 = Instance.new("UIListLayout")
	v1_189.Padding = UDim.new(0, 2)
	v1_189.SortOrder = Enum.SortOrder.LayoutOrder
	v1_189.Parent = v1_188
	local function v1_190(v2_191, v2_192, v2_193, v2_194, v2_195)
		local v2_196 = Instance.new("TextLabel")
		v2_196.Size = UDim2.new(1, 0, 0, 0)
		v2_196.AutomaticSize = Enum.AutomaticSize.Y
		v2_196.BackgroundTransparency = 1
		v2_196.BorderSizePixel = 0
		v2_196.Text = v2_191
		v2_196.TextColor3 = v2_194
		v2_196.Font = v2_192
		v2_196.TextSize = v2_193
		v2_196.TextWrapped = true
		v2_196.TextXAlignment = Enum.TextXAlignment.Left
		v2_196.TextYAlignment = Enum.TextYAlignment.Top
		v2_196.LayoutOrder = v2_195
		v2_196.Parent = v1_188
		return v2_196
	end
	if v1_178.Title and v1_178.Title ~= "" then
		v1_190(tostring(v1_178.Title), Enum.Font.GothamBold, 13, v0_7.Text, 1).Name = "Title"
	end
	if v1_178.Content and v1_178.Content ~= "" then
		v1_190(tostring(v1_178.Content), Enum.Font.Gotham, 12, v0_7.SubText, 2).Name = "Content"
	end
	local v1_197 = Instance.new("TextLabel")
	v1_197.Name = "Countdown"
	v1_197.AnchorPoint = Vector2.new(1, 0.5)
	v1_197.Position = UDim2.new(1, 0, 0.5, 0)
	v1_197.Size = UDim2.new(0, 18, 0, 18)
	v1_197.BackgroundTransparency = 1
	v1_197.BorderSizePixel = 0
	v1_197.Text = tostring(math.ceil(v1_179))
	v1_197.TextColor3 = v0_7.SubText
	v1_197.Font = Enum.Font.GothamBold
	v1_197.TextSize = 13
	v1_197.TextXAlignment = Enum.TextXAlignment.Right
	v1_197.Visible = v1_179 > 0
	v1_197.Parent = v1_185
	if v1_179 > 0 then
		v1_188.Size = UDim2.new(1, -24, 0, 0)
	end
	local v1_198 = Instance.new("TextButton")
	v1_198.Name = "Click"
	v1_198.Size = UDim2.new(1, 0, 1, 0)
	v1_198.BackgroundTransparency = 1
	v1_198.BorderSizePixel = 0
	v1_198.Text = ""
	v1_198.AutoButtonColor = false
	v1_198.Parent = v1_183
	local v1_199, v1_200 = nil, nil
	local v1_201 = {}
	local function v1_202()
		if v1_181 then return end
		v1_181 = true
		local v2_203 = table.find(self._notifs, v1_202)
		if v2_203 then table.remove(self._notifs, v2_203) end
		if v1_199 and v1_199 ~= coroutine.running() then
			pcall(task.cancel, v1_199)
		end
		v1_199 = nil
		if v1_200 then
			v1_200:Disconnect()
			v1_200 = nil
		end
		for v3_204, v3_205 in ipairs(v1_201) do v3_205:Cancel() end
		v1_201 = {}
		if self._destroyed then return end
		v0_10(v1_184, { Transparency = 1 }, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v2_206 = v0_10(v1_183, {
			Position = UDim2.new(0, 0, 0, -20),
			GroupTransparency = 1,
		}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_206.Completed:Connect(function()
			local v3_207 = v0_10(v1_182, { Size = UDim2.new(1, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quint)
			v3_207.Completed:Connect(function()
				v1_182:Destroy()
			end)
		end)
	end
	v1_198.MouseButton1Click:Connect(v1_202)
	table.insert(self._notifs, v1_202)
	while #self._notifs > v0_173 do
		self._notifs[1]()
	end
	local v1_208 = false
	v1_200 = v1_183:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if v1_181 then return end
		local v2_209 = v1_183.AbsoluteSize.Y
		if v2_209 <= 0 then return end
		if not v1_208 then
			v1_208 = true
			table.insert(v1_201, v0_10(v1_182, { Size = UDim2.new(1, 0, 0, v2_209) }, 0.3, Enum.EasingStyle.Quint))
		else
			v1_182.Size = UDim2.new(1, 0, 0, v2_209)
		end
	end)
	v1_183.Position = UDim2.new(0, 0, 0, -(v1_180.AbsolutePosition.Y + v1_180.AbsoluteSize.Y + 90))
	v1_201 = {
		v0_10(v1_183, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back),
		v0_10(v1_183, { GroupTransparency = 0 }, 0.25),
		v0_10(v1_184, { Transparency = 0 }, 0.25),
	}
	if v1_179 > 0 then
		v1_199 = task.spawn(function()
			local v3_210 = os.clock()
			local v3_211 = math.ceil(v1_179)
			while not v1_181 and not self._destroyed do
				local v4_212 = v1_179 - (os.clock() - v3_210)
				local v4_213 = math.max(math.ceil(v4_212), 0)
				if v4_213 ~= v3_211 then
					v3_211 = v4_213
					v1_197.Text = tostring(v4_213)
					v1_197.TextTransparency = 0.6
					v0_10(v1_197, { TextTransparency = 0 }, 0.2)
				end
				if v4_212 <= 0 then
					v1_199 = nil
					v1_202()
					return
				end
				task.wait(v4_212 - (v4_213 - 1))
			end
		end)
	end
	return { Dismiss = v1_202 }
end
function v0_1:Dialog(v1_214)
	if self._destroyed then return end
	v1_214 = v1_214 or {}
	local v1_215 = v1_214.Buttons
	if type(v1_215) ~= "table" or #v1_215 == 0 then
		v1_215 = { { Title = "OK", Primary = true } }
	end
	local v1_216 = false
	local v1_217 = {}
	local v1_218 = { Dismissable = v1_214.Dismissable ~= false }
	local v1_219 = Instance.new("Frame")
	v1_219.Name = "DialogOverlay"
	v1_219.Size = UDim2.new(1, 0, 1, 0)
	v1_219.BackgroundTransparency = 1
	v1_219.BorderSizePixel = 0
	v1_219.ZIndex = 100 + #self._dialogs
	v1_219.Parent = self.ScreenGui
	local v1_220 = Instance.new("TextButton")
	v1_220.Name = "Backdrop"
	v1_220.Size = UDim2.new(1, 0, 1, 0)
	v1_220.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	v1_220.BackgroundTransparency = 1
	v1_220.BorderSizePixel = 0
	v1_220.Text = ""
	v1_220.AutoButtonColor = false
	v1_220.Parent = v1_219
	local v1_221 = Instance.new("CanvasGroup")
	v1_221.Name = "Dialog"
	v1_221.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_221.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_221.Size = UDim2.new(0.9, 0, 0, 0)
	v1_221.AutomaticSize = Enum.AutomaticSize.Y
	v1_221.BackgroundColor3 = v0_7.Sidebar
	v1_221.BorderSizePixel = 0
	v1_221.GroupTransparency = 1
	v1_221.Active = true
	v1_221.ZIndex = 2
	v1_221.Parent = v1_219
	v0_61(v1_221, 8)
	local v1_222 = Instance.new("UISizeConstraint")
	v1_222.MinSize = Vector2.new(200, 0)
	v1_222.MaxSize = Vector2.new(320, math.huge)
	v1_222.Parent = v1_221
	local v1_223 = Instance.new("UIScale")
	v1_223.Scale = 0.92
	v1_223.Parent = v1_221
	local v1_224 = Instance.new("UIStroke")
	v1_224.Color = v0_7.Element
	v1_224.Thickness = 1
	v1_224.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_224.Parent = v1_221
	local v1_225 = Instance.new("Frame")
	v1_225.Name = "Body"
	v1_225.Size = UDim2.new(1, 0, 0, 0)
	v1_225.AutomaticSize = Enum.AutomaticSize.Y
	v1_225.BackgroundTransparency = 1
	v1_225.BorderSizePixel = 0
	v1_225.Parent = v1_221
	local v1_226 = Instance.new("UIPadding")
	v1_226.PaddingTop = UDim.new(0, 14)
	v1_226.PaddingBottom = UDim.new(0, 14)
	v1_226.PaddingLeft = UDim.new(0, 14)
	v1_226.PaddingRight = UDim.new(0, 14)
	v1_226.Parent = v1_225
	local v1_227 = Instance.new("UIListLayout")
	v1_227.Padding = UDim.new(0, 8)
	v1_227.SortOrder = Enum.SortOrder.LayoutOrder
	v1_227.Parent = v1_225
	local function v1_228(v2_229, v2_230, v2_231, v2_232, v2_233, v2_234)
		local v2_235 = Instance.new("TextLabel")
		v2_235.Name = v2_229
		v2_235.Size = UDim2.new(1, 0, 0, 0)
		v2_235.AutomaticSize = Enum.AutomaticSize.Y
		v2_235.BackgroundTransparency = 1
		v2_235.BorderSizePixel = 0
		v2_235.Text = v2_230
		v2_235.TextColor3 = v2_233
		v2_235.Font = v2_231
		v2_235.TextSize = v2_232
		v2_235.TextWrapped = true
		v2_235.TextXAlignment = Enum.TextXAlignment.Left
		v2_235.TextYAlignment = Enum.TextYAlignment.Top
		v2_235.LayoutOrder = v2_234
		v2_235.Parent = v1_225
		return v2_235
	end
	if v1_214.Title and v1_214.Title ~= "" then
		v1_228("Title", tostring(v1_214.Title), Enum.Font.GothamBold, 15, v0_7.Text, 1)
	end
	if v1_214.Content and v1_214.Content ~= "" then
		v1_228("Content", tostring(v1_214.Content), Enum.Font.Gotham, 13, v0_7.SubText, 2)
	end
	local v1_236 = Instance.new("Frame")
	v1_236.Name = "Buttons"
	v1_236.Size = UDim2.new(1, 0, 0, 30)
	v1_236.BackgroundTransparency = 1
	v1_236.BorderSizePixel = 0
	v1_236.LayoutOrder = 3
	v1_236.Parent = v1_225
	local v1_237 = Instance.new("UIListLayout")
	v1_237.FillDirection = Enum.FillDirection.Horizontal
	v1_237.HorizontalAlignment = Enum.HorizontalAlignment.Right
	v1_237.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_237.Padding = UDim.new(0, 8)
	v1_237.SortOrder = Enum.SortOrder.LayoutOrder
	v1_237.Parent = v1_236
	local function v1_238()
		if v1_216 then return end
		v1_216 = true
		local v2_239 = table.find(self._dialogs, v1_218)
		if v2_239 then table.remove(self._dialogs, v2_239) end
		for v3_240, v3_241 in ipairs(v1_217) do v3_241:Cancel() end
		v1_217 = {}
		if self._destroyed or not v1_219.Parent then return end
		v0_10(v1_220, { BackgroundTransparency = 1 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v0_10(v1_223, { Scale = 0.94 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v2_242 = v0_10(v1_221, { GroupTransparency = 1 }, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_242.Completed:Connect(function()
			v1_219:Destroy()
		end)
	end
	v1_218.Close = v1_238
	for v2_243, v2_244 in ipairs(v1_215) do
		local v2_245 = v2_244.Primary == true
		local v2_246 = v2_245 and v0_7.Accent or v0_7.Element
		local v2_247 = v2_245 and v0_7.Accent:Lerp(v0_7.Text, 0.15) or v0_7.Hover
		local v2_248 = Instance.new("TextButton")
		v2_248.Name = "Button"
		v2_248.Size = UDim2.new(0, 0, 0, 30)
		v2_248.AutomaticSize = Enum.AutomaticSize.X
		v2_248.BackgroundColor3 = v2_246
		v2_248.BorderSizePixel = 0
		v2_248.Text = tostring(v2_244.Title or "OK")
		v2_248.TextColor3 = v0_7.Text
		v2_248.Font = Enum.Font.Gotham
		v2_248.TextSize = 13
		v2_248.AutoButtonColor = false
		v2_248.LayoutOrder = v2_243
		v2_248.Parent = v1_236
		v0_61(v2_248, 6)
		local v2_249 = Instance.new("UIPadding")
		v2_249.PaddingLeft = UDim.new(0, 14)
		v2_249.PaddingRight = UDim.new(0, 14)
		v2_249.Parent = v2_248
		v0_19(v2_248, v2_246, v2_247)
		v2_248.MouseButton1Click:Connect(function()
			if v1_216 then return end
			v1_238()
			if v2_244.Callback then v2_244.Callback() end
		end)
	end
	v1_220.MouseButton1Click:Connect(function()
		if v1_218.Dismissable then v1_238() end
	end)
	table.insert(self._dialogs, v1_218)
	v1_217 = {
		v0_10(v1_220, { BackgroundTransparency = 0.45 }, 0.2),
		v0_10(v1_221, { GroupTransparency = 0 }, 0.22),
		v0_10(v1_223, { Scale = 1 }, 0.3, Enum.EasingStyle.Back),
	}
	return { Close = v1_238 }
end
function v0_1:_buildWatermark(v1_250)
	local v1_251 = Instance.new("Frame")
	v1_251.Name = "Watermark"
	v1_251.AnchorPoint = Vector2.new(0.5, 0)
	v1_251.Position = UDim2.new(0.5, 0, 0, -40)
	v1_251.Size = UDim2.new(0, 0, 0, 30)
	v1_251.AutomaticSize = Enum.AutomaticSize.X
	v1_251.BackgroundColor3 = v0_7.Sidebar
	v1_251.BorderSizePixel = 0
	v1_251.Parent = self.ScreenGui
	v0_61(v1_251, 8)
	local v1_252 = Instance.new("UIStroke")
	v1_252.Color = v0_7.Element
	v1_252.Thickness = 1
	v1_252.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_252.Parent = v1_251
	local v1_253 = Instance.new("UIPadding")
	v1_253.PaddingLeft = UDim.new(0, 10)
	v1_253.PaddingRight = UDim.new(0, 4)
	v1_253.Parent = v1_251
	local v1_254 = Instance.new("UIListLayout")
	v1_254.FillDirection = Enum.FillDirection.Horizontal
	v1_254.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_254.Padding = UDim.new(0, 8)
	v1_254.SortOrder = Enum.SortOrder.LayoutOrder
	v1_254.Parent = v1_251
	local v1_255 = Instance.new("TextLabel")
	v1_255.Name = "Title"
	v1_255.Size = UDim2.new(0, 0, 1, 0)
	v1_255.AutomaticSize = Enum.AutomaticSize.X
	v1_255.BackgroundTransparency = 1
	v1_255.BorderSizePixel = 0
	v1_255.Text = v1_250
	v1_255.TextColor3 = v0_7.SubText
	v1_255.Font = Enum.Font.GothamBold
	v1_255.TextSize = 13
	v1_255.LayoutOrder = 1
	v1_255.Parent = v1_251
	local v1_256 = Instance.new("TextButton")
	v1_256.Name = "ToggleButton"
	v1_256.Size = UDim2.new(0, 22, 0, 22)
	v1_256.BackgroundColor3 = v0_7.Element
	v1_256.BorderSizePixel = 0
	v1_256.Text = ""
	v1_256.AutoButtonColor = false
	v1_256.LayoutOrder = 2
	v1_256.Parent = v1_251
	v0_61(v1_256, 6)
	local v1_257 = Instance.new("ImageLabel")
	v1_257.Name = "Icon"
	v1_257.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_257.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_257.Size = UDim2.new(0, 14, 0, 14)
	v1_257.BackgroundTransparency = 1
	v1_257.BorderSizePixel = 0
	v1_257.ImageColor3 = v0_7.IconOn
	v1_257.ScaleType = Enum.ScaleType.Fit
	v1_257.Parent = v1_256
	local v1_258 = Instance.new("TextLabel")
	v1_258.Name = "IconFallback"
	v1_258.Size = UDim2.new(1, 0, 1, 0)
	v1_258.BackgroundTransparency = 1
	v1_258.TextColor3 = v0_7.IconOn
	v1_258.Font = Enum.Font.GothamBold
	v1_258.TextSize = 12
	v1_258.Visible = false
	v1_258.Parent = v1_257
	local v1_259 = Instance.new("UIScale")
	v1_259.Parent = v1_256
	v1_256.MouseEnter:Connect(function() v0_10(v1_259, { Scale = 1.1 }, 0.12) end)
	v1_256.MouseLeave:Connect(function() v0_10(v1_259, { Scale = 1 }, 0.12) end)
	v1_256.InputBegan:Connect(function(v2_260)
		if v0_17(v2_260) then v0_10(v1_259, { Scale = 0.9 }, 0.08) end
	end)
	v1_256.InputEnded:Connect(function(v2_261)
		if v0_17(v2_261) then v0_10(v1_259, { Scale = 1.1 }, 0.15, Enum.EasingStyle.Back) end
	end)
	v1_256.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	local v1_262, v1_263, v1_264 = false, nil, nil
	v1_255.InputBegan:Connect(function(v2_265)
		if v0_17(v2_265) then
			v1_262 = true
			v1_263 = v2_265.Position
			v1_264 = v1_251.AbsolutePosition + Vector2.new(v1_251.AbsoluteSize.X / 2, 0)
			v2_265.Changed:Connect(function()
				if v2_265.UserInputState == Enum.UserInputState.End then v1_262 = false end
			end)
		end
	end)
	table.insert(self._connections, v0_4.InputChanged:Connect(function(v2_266)
		if not v1_262 then return end
		if v2_266.UserInputType ~= Enum.UserInputType.MouseMovement and v2_266.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local v2_267 = v2_266.Position - v1_263
		local v2_268 = self.ScreenGui.AbsoluteSize
		local v2_269 = v1_251.AbsoluteSize.X / 2
		local v2_270 = math.clamp(v1_264.X + v2_267.X, v2_269, math.max(v2_268.X - v2_269, v2_269))
		local v2_271 = math.clamp(v1_264.Y + v2_267.Y, 0, math.max(v2_268.Y - v1_251.AbsoluteSize.Y, 0))
		v1_251.Position = UDim2.fromOffset(v2_270, v2_271)
	end))
	self._wm = { Frame = v1_251, Button = v1_256, Icon = v1_257, Fallback = v1_258 }
	v0_10(v1_251, { Position = UDim2.new(0.5, 0, 0, 10) }, 0.5, Enum.EasingStyle.Back)
end
function v0_1:_updateWatermark()
	local v1_272 = self._wm
	if not v1_272 then return end
	local v1_273 = self._visible == true
	v0_10(v1_272.Button, { BackgroundColor3 = v1_273 and v0_7.Accent or v0_7.Element }, 0.2)
	local v1_274 = v0_42(v1_272.Icon, v1_273 and "eye" or "eye-off", self.Icons)
	if not v1_274 then v1_272.Icon.Image = "" end
	v1_272.Fallback.Visible = not v1_274
	v1_272.Fallback.Text = v1_273 and "●" or "○"
	v1_272.Icon.ImageTransparency = 1
	v0_10(v1_272.Icon, { ImageTransparency = 0 }, 0.2)
end
local function v0_275(v1_276, v1_277)
	v0_10(v1_276.Icon, { ImageColor3 = v1_277 }, 0.2)
	if v1_276.Fallback then
		v0_10(v1_276.Fallback, { TextColor3 = v1_277 }, 0.2)
	end
end
function v0_1:AddTab(v1_278)
	v1_278 = v1_278 or {}
	local v1_279 = Instance.new("TextButton")
	v1_279.Name = "TabButton"
	v1_279.Size = UDim2.new(0, 36, 0, 36)
	v1_279.BackgroundColor3 = v0_7.Card
	v1_279.BorderSizePixel = 0
	v1_279.Text = ""
	v1_279.AutoButtonColor = false
	v1_279.LayoutOrder = #self.Tabs + 1
	v1_279.Parent = self.Sidebar
	v0_61(v1_279, 6)
	local v1_280 = Instance.new("ImageLabel")
	v1_280.Name = "Icon"
	v1_280.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_280.Size = UDim2.new(0, 20, 0, 20)
	v1_280.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_280.BackgroundTransparency = 1
	v1_280.BorderSizePixel = 0
	v1_280.ImageColor3 = v0_7.IconOff
	v1_280.ScaleType = Enum.ScaleType.Fit
	v1_280.Parent = v1_279
	local v1_281
	if not v0_42(v1_280, v1_278.Icon, self.Icons) then
		v1_281 = Instance.new("TextLabel")
		v1_281.Name = "IconFallback"
		v1_281.Size = UDim2.new(1, 0, 1, 0)
		v1_281.BackgroundTransparency = 1
		v1_281.Text = string.upper(string.sub(tostring(v1_278.Name or v1_278.Icon or "?"), 1, 1))
		v1_281.TextColor3 = v0_7.IconOff
		v1_281.Font = Enum.Font.GothamBold
		v1_281.TextSize = 16
		v1_281.Parent = v1_280
	end
	local v1_282 = Instance.new("ScrollingFrame")
	v1_282.Name = "Page"
	v1_282.Size = UDim2.new(1, 0, 1, 0)
	v1_282.BackgroundTransparency = 1
	v1_282.BorderSizePixel = 0
	v1_282.ScrollBarThickness = 3
	v1_282.ScrollBarImageColor3 = v0_7.IconOff
	v1_282.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_282.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_282.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_282.Visible = false
	v1_282.Parent = self.Content
	local v1_283 = Instance.new("Frame")
	v1_283.Name = "Inner"
	v1_283.Size = UDim2.new(1, 0, 0, 0)
	v1_283.AutomaticSize = Enum.AutomaticSize.Y
	v1_283.BackgroundTransparency = 1
	v1_283.BorderSizePixel = 0
	v1_283.Parent = v1_282
	local v1_284 = Instance.new("UIPadding")
	v1_284.PaddingTop = UDim.new(0, 12)
	v1_284.PaddingBottom = UDim.new(0, 12)
	v1_284.Parent = v1_283
	local v1_285 = Instance.new("Frame")
	v1_285.Name = "Split"
	v1_285.Position = UDim2.new(0, 12, 0, 0)
	v1_285.Size = UDim2.new(1, -26, 0, 0)
	v1_285.AutomaticSize = Enum.AutomaticSize.Y
	v1_285.BackgroundTransparency = 1
	v1_285.BorderSizePixel = 0
	v1_285.Parent = v1_283
	local v1_286 = Instance.new("UIListLayout")
	v1_286.FillDirection = Enum.FillDirection.Horizontal
	v1_286.Padding = UDim.new(0, 8)
	v1_286.SortOrder = Enum.SortOrder.LayoutOrder
	v1_286.Parent = v1_285
	local function v1_287(v2_288)
		local v2_289 = Instance.new("Frame")
		v2_289.Name = v2_288 == 1 and "Left" or "Right"
		v2_289.Size = UDim2.new(0.5, -4, 0, 0)
		v2_289.AutomaticSize = Enum.AutomaticSize.Y
		v2_289.BackgroundTransparency = 1
		v2_289.BorderSizePixel = 0
		v2_289.LayoutOrder = v2_288
		v2_289.Parent = v1_285
		local v2_290 = Instance.new("UIListLayout")
		v2_290.Padding = UDim.new(0, 8)
		v2_290.SortOrder = Enum.SortOrder.LayoutOrder
		v2_290.Parent = v2_289
		return v2_289
	end
	local v1_291 = setmetatable({
		Page = v1_282,
		Button = v1_279,
		Icon = v1_280,
		Fallback = v1_281,
		Inner = v1_283,
		_icons = self.Icons,
		_lib = self,
		Left = v1_287(1),
		Right = v1_287(2),
		_sectionCount = 0,
	}, v0_2)
	table.insert(self.Tabs, v1_291)
	for v2_292, v2_293 in ipairs({ "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" }) do
		table.insert(self._connections, v1_282:GetPropertyChangedSignal(v2_293):Connect(function()
			if self.ActiveTab == v1_291 then self:_updateScrollHint() end
		end))
	end
	v0_19(v1_279, v0_7.Card, v0_7.Element, function()
		return self.ActiveTab == v1_291
	end)
	v1_279.MouseButton1Click:Connect(function()
		self:SelectTab(v1_291)
	end)
	if not self.ActiveTab then self:SelectTab(v1_291) end
	return v1_291
end
function v0_1:SelectTab(v1_294)
	if self.ActiveTab == v1_294 then return end
	local v1_295 = self.ActiveTab
	self.ActiveTab = v1_294
	if v1_295 then
		v1_295.Page.Visible = false
		v0_10(v1_295.Button, { BackgroundColor3 = v0_7.Card }, 0.2)
		v0_275(v1_295, v0_7.IconOff)
	end
	v1_294.Inner.Position = UDim2.new(0, 0, 0, 14)
	v1_294.Page.Visible = true
	v0_10(v1_294.Inner, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)
	v0_10(v1_294.Button, { BackgroundColor3 = v0_7.Accent }, 0.2)
	v0_275(v1_294, v0_7.IconOn)
	self:_updateScrollHint()
end
function v0_2:AddSection(v1_296, v1_297, v1_298)
	local v1_299 = (v1_297 == "right") and self.Right or self.Left
	local v1_300 = self._lib
	self._sectionCount += 1
	local v1_301 = Instance.new("Frame")
	v1_301.Name = "Section"
	v1_301.Size = UDim2.new(1, 0, 0, 0)
	v1_301.AutomaticSize = Enum.AutomaticSize.Y
	v1_301.BackgroundColor3 = v0_7.Card
	v1_301.BorderSizePixel = 0
	v1_301.LayoutOrder = self._sectionCount
	v1_301.Parent = v1_299
	v0_61(v1_301, 6)
	local v1_302 = Instance.new("UIPadding")
	v1_302.PaddingTop = UDim.new(0, 8)
	v1_302.PaddingBottom = UDim.new(0, 8)
	v1_302.PaddingLeft = UDim.new(0, 8)
	v1_302.PaddingRight = UDim.new(0, 8)
	v1_302.Parent = v1_301
	local v1_303 = Instance.new("UIListLayout")
	v1_303.Padding = UDim.new(0, 6)
	v1_303.SortOrder = Enum.SortOrder.LayoutOrder
	v1_303.Parent = v1_301
	local v1_304 = Instance.new("Frame")
	v1_304.Name = "Body"
	v1_304.Size = UDim2.new(1, 0, 0, 0)
	v1_304.AutomaticSize = Enum.AutomaticSize.Y
	v1_304.BackgroundTransparency = 1
	v1_304.BorderSizePixel = 0
	v1_304.LayoutOrder = 1
	v1_304.Parent = v1_301
	local v1_305 = Instance.new("UIListLayout")
	v1_305.Padding = UDim.new(0, 6)
	v1_305.SortOrder = Enum.SortOrder.LayoutOrder
	v1_305.Parent = v1_304
	local v1_306 = false
	local v1_307 = {}
	local v1_308, v1_309
	local function v1_310()
		local v2_311 = v1_300._scale and v1_300._scale.Scale or 1
		return math.max(v1_305.AbsoluteContentSize.Y / (v2_311 > 0 and v2_311 or 1), 0)
	end
	local function v1_312()
		v1_304.AutomaticSize = Enum.AutomaticSize.Y
		v1_304.Size = UDim2.new(1, 0, 0, 0)
		v1_304.ClipsDescendants = false
	end
	local function v1_313(v2_314, v2_315)
		if v2_314 == v1_306 and not v2_315 then return end
		v1_306 = v2_314
		for v3_316, v3_317 in ipairs(v1_307) do v3_317:Cancel() end
		v1_307 = {}
		if v1_308 then
			if v2_315 then
				v1_308.Rotation = v2_314 and -90 or 0
			else
				v0_10(v1_308, { Rotation = v2_314 and -90 or 0 }, 0.22, Enum.EasingStyle.Quint)
			end
		end
		if v2_315 then
			v1_304.Visible = not v2_314
			v1_303.Padding = UDim.new(0, v2_314 and 0 or 6)
			v1_312()
			return
		end
		v1_304.ClipsDescendants = true
		if v2_314 then
			if v1_304.AutomaticSize ~= Enum.AutomaticSize.None then
				local v4_318 = v1_310()
				v1_304.AutomaticSize = Enum.AutomaticSize.None
				v1_304.Size = UDim2.new(1, 0, 0, v4_318)
			end
			local v3_319 = v0_10(v1_304, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Quint)
			v1_307 = { v3_319, v0_10(v1_303, { Padding = UDim.new(0, 0) }, 0.25, Enum.EasingStyle.Quint) }
			v3_319.Completed:Connect(function(v4_320)
				if v4_320 == Enum.PlaybackState.Completed and v1_306 then
					v1_304.Visible = false
					v1_304.ClipsDescendants = false
				end
			end)
		else
			v1_304.Visible = true
			local v3_321 = v1_310()
			if v3_321 <= 0 then
				v1_303.Padding = UDim.new(0, 6)
				v1_312()
				return
			end
			if v1_304.AutomaticSize ~= Enum.AutomaticSize.None then
				v1_304.AutomaticSize = Enum.AutomaticSize.None
				v1_304.Size = UDim2.new(1, 0, 0, 0)
			end
			local v3_322 = v0_10(v1_304, { Size = UDim2.new(1, 0, 0, v3_321) }, 0.28, Enum.EasingStyle.Quint)
			v1_307 = { v3_322, v0_10(v1_303, { Padding = UDim.new(0, 6) }, 0.28, Enum.EasingStyle.Quint) }
			v3_322.Completed:Connect(function(v4_323)
				if v4_323 == Enum.PlaybackState.Completed and not v1_306 then
					v1_312()
				end
			end)
		end
	end
	if v1_296 then
		local v2_324 = Instance.new("TextButton")
		v2_324.Name = "Header"
		v2_324.Size = UDim2.new(1, 0, 0, 16)
		v2_324.BackgroundTransparency = 1
		v2_324.BorderSizePixel = 0
		v2_324.Text = ""
		v2_324.AutoButtonColor = false
		v2_324.LayoutOrder = 0
		v2_324.Parent = v1_301
		local v2_325 = Instance.new("TextLabel")
		v2_325.Name = "Title"
		v2_325.Size = UDim2.new(1, -22, 1, 0)
		v2_325.BackgroundTransparency = 1
		v2_325.BorderSizePixel = 0
		v2_325.Text = v1_296
		v2_325.TextColor3 = v0_7.SubText
		v2_325.Font = Enum.Font.GothamBold
		v2_325.TextSize = 13
		v2_325.TextXAlignment = Enum.TextXAlignment.Left
		v2_325.TextTruncate = Enum.TextTruncate.AtEnd
		v2_325.Parent = v2_324
		v1_308 = Instance.new("ImageLabel")
		v1_308.Name = "Chevron"
		v1_308.AnchorPoint = Vector2.new(1, 0.5)
		v1_308.Position = UDim2.new(1, 0, 0.5, 0)
		v1_308.Size = UDim2.new(0, 14, 0, 14)
		v1_308.BackgroundTransparency = 1
		v1_308.BorderSizePixel = 0
		v1_308.ImageColor3 = v0_7.SubText
		v1_308.ScaleType = Enum.ScaleType.Fit
		v1_308.Parent = v2_324
		v1_309 = Instance.new("TextLabel")
		v1_309.Name = "ChevronFallback"
		v1_309.Size = UDim2.new(1, 0, 1, 0)
		v1_309.BackgroundTransparency = 1
		v1_309.Text = "▼"
		v1_309.TextColor3 = v0_7.SubText
		v1_309.Font = Enum.Font.Gotham
		v1_309.TextSize = 9
		v1_309.Parent = v1_308
		v1_309.Visible = not v0_42(v1_308, "chevron-down", self._icons)
		v2_324.MouseEnter:Connect(function()
			v0_10(v2_325, { TextColor3 = v0_7.Text }, 0.12)
			v0_10(v1_308, { ImageColor3 = v0_7.Text }, 0.12)
			v0_10(v1_309, { TextColor3 = v0_7.Text }, 0.12)
		end)
		v2_324.MouseLeave:Connect(function()
			v0_10(v2_325, { TextColor3 = v0_7.SubText }, 0.15)
			v0_10(v1_308, { ImageColor3 = v0_7.SubText }, 0.15)
			v0_10(v1_309, { TextColor3 = v0_7.SubText }, 0.15)
		end)
		v2_324.MouseButton1Click:Connect(function()
			v1_313(not v1_306)
		end)
	end
	local v1_326 = setmetatable({
		Holder = v1_304,
		Card = v1_301,
		_count = 0,
		_icons = self._icons,
		_lib = self._lib,
		_setCollapsed = v1_313,
		_isCollapsed = function() return v1_306 end,
	}, v0_3)
	if v1_296 and v1_298 == true then
		v1_313(true, true)
	end
	return v1_326
end
function v0_3:SetCollapsed(v1_327)
	self._setCollapsed(v1_327 == true)
end
function v0_3:ToggleCollapsed()
	self._setCollapsed(not self._isCollapsed())
end
function v0_3:IsCollapsed()
	return self._isCollapsed()
end
local function v0_328(v1_329)
	if typeof(v1_329) == "EnumItem" and v1_329.EnumType == Enum.KeyCode then return v1_329 end
	if type(v1_329) == "string" then
		local v2_330, v2_331 = pcall(function() return Enum.KeyCode[v1_329] end)
		if v2_330 then return v2_331 end
	end
	return nil
end
local function v0_332(v1_333, v1_334, v1_335, v1_336, v1_337)
	v1_335 = v1_335 or {}
	local v1_338 = v1_335.CanBeChanged ~= false
	local v1_339 = {}
	local v1_340 = { _key = nil, _onPress = v1_337, _isListening = false, _destroyed = false }
	local v1_341 = Instance.new("TextButton")
	v1_341.Name = "Keybind"
	v1_341.AnchorPoint = Vector2.new(1, 0.5)
	v1_341.Position = v1_336
	v1_341.Size = UDim2.new(0, 0, 0, 20)
	v1_341.AutomaticSize = Enum.AutomaticSize.X
	v1_341.BackgroundColor3 = v0_7.Card
	v1_341.BorderSizePixel = 0
	v1_341.Text = "None"
	v1_341.TextColor3 = v0_7.SubText
	v1_341.Font = Enum.Font.Gotham
	v1_341.TextSize = 12
	v1_341.TextTruncate = Enum.TextTruncate.AtEnd
	v1_341.AutoButtonColor = false
	v1_341.Parent = v1_334
	v0_61(v1_341, 5)
	v1_340.Instance = v1_341
	local v1_342 = Instance.new("UIPadding")
	v1_342.PaddingLeft = UDim.new(0, 7)
	v1_342.PaddingRight = UDim.new(0, 7)
	v1_342.Parent = v1_341
	local v1_343 = Instance.new("UISizeConstraint")
	v1_343.MinSize = Vector2.new(30, 20)
	v1_343.MaxSize = Vector2.new(96, 20)
	v1_343.Parent = v1_341
	local function v1_344()
		if v1_340._isListening then
			v1_341.Text = "..."
		else
			v1_341.Text = v1_340._key and v1_340._key.Name or "None"
		end
	end
	local function v1_345()
		v1_341.BackgroundColor3 = v0_7.Danger
		v0_10(v1_341, { BackgroundColor3 = v0_7.Card }, 0.45)
	end
	function v1_340:Set(v2_346, v2_347)
		v2_346 = v0_328(v2_346)
		if v2_346 and v1_333:_keyTaken(v2_346, v1_340) then
			warn("[RobloxUI] key already in use:", v2_346.Name)
			v1_345()
			return false
		end
		v1_340._key = v2_346
		v1_344()
		if not v2_347 and v1_335.Callback then v1_335.Callback(v2_346) end
		return true
	end
	function v1_340:Get()
		return v1_340._key
	end
	function v1_340:_startListening()
		if v1_333._listening and v1_333._listening ~= v1_340 then
			v1_333._listening:_stopListening()
		end
		v1_333._listening = v1_340
		v1_340._isListening = true
		v0_10(v1_341, { BackgroundColor3 = v0_7.Accent }, 0.15)
		v1_344()
	end
	function v1_340:_stopListening()
		if v1_333._listening == v1_340 then v1_333._listening = nil end
		v1_340._isListening = false
		v0_10(v1_341, { BackgroundColor3 = v0_7.Card }, 0.15)
		v1_344()
	end
	function v1_340:_capture(v2_348)
		if v2_348 == Enum.KeyCode.Unknown then return end
		v1_340:_stopListening()
		if v2_348 == Enum.KeyCode.Escape then return end
		if v2_348 == Enum.KeyCode.Backspace or v2_348 == Enum.KeyCode.Delete then
			v1_340:Set(nil)
		else
			v1_340:Set(v2_348)
		end
	end
	function v1_340:Destroy()
		if v1_340._destroyed then return end
		v1_340._destroyed = true
		if v1_333._listening == v1_340 then v1_333._listening = nil end
		local v2_349 = table.find(v1_333._binds, v1_340)
		if v2_349 then table.remove(v1_333._binds, v2_349) end
		v1_333._cleanups[v1_340] = nil
		for v3_350, v3_351 in ipairs(v1_339) do v3_351:Disconnect() end
		v1_339 = {}
		v1_341:Destroy()
	end
	if v1_338 then
		v0_19(v1_341, v0_7.Card, v0_7.Sidebar, function() return v1_340._isListening end)
		table.insert(v1_339, v1_341.MouseButton1Click:Connect(function()
			if v1_340._isListening then v1_340:_stopListening() else v1_340:_startListening() end
		end))
		table.insert(v1_339, v1_341.MouseButton2Click:Connect(function()
			if v1_340._isListening then v1_340:_stopListening() end
			v1_340:Set(nil)
		end))
	end
	if v1_335.Key ~= nil then
		v1_340:Set(v1_335.Key, true)
	end
	table.insert(v1_333._binds, v1_340)
	v1_333._cleanups[v1_340] = function() v1_340:Destroy() end
	return v1_340
end
local function v0_352(v1_353, v1_354, v1_355)
	local v1_356 = v1_354.Instance
	local function v1_357()
		local v2_358 = math.clamp(v1_356.TextBounds.X + 14, 30, 96)
		v1_353.Size = UDim2.new(1, -(v1_355 + v2_358 + 6), 1, 0)
	end
	v1_357()
	v1_356:GetPropertyChangedSignal("TextBounds"):Connect(v1_357)
end
function v0_3:AddButton(v1_359)
	v1_359 = v1_359 or {}
	self._count += 1
	local v1_360 = Instance.new("TextButton")
	v1_360.Name = "Button"
	v1_360.Size = UDim2.new(1, 0, 0, 32)
	v1_360.BackgroundColor3 = v0_7.Element
	v1_360.BorderSizePixel = 0
	v1_360.Text = v1_359.Name or "Button"
	v1_360.TextColor3 = v0_7.Text
	v1_360.Font = Enum.Font.Gotham
	v1_360.TextSize = 14
	v1_360.TextTruncate = Enum.TextTruncate.AtEnd
	v1_360.AutoButtonColor = false
	v1_360.LayoutOrder = self._count
	v1_360.Parent = self.Holder
	v0_61(v1_360, 6)
	local v1_361 = Instance.new("UIPadding")
	v1_361.PaddingLeft = UDim.new(0, 8)
	v1_361.PaddingRight = UDim.new(0, 8)
	v1_361.Parent = v1_360
	v0_19(v1_360, v0_7.Element, v0_7.Hover)
	v1_360.MouseButton1Click:Connect(function()
		v1_360.BackgroundColor3 = v0_7.Accent
		v0_10(v1_360, { BackgroundColor3 = v0_7.Hover }, 0.3)
		if v1_359.Callback then v1_359.Callback() end
	end)
	return v1_360
end
function v0_3:AddToggle(v1_362)
	v1_362 = v1_362 or {}
	self._count += 1
	local v1_363 = v1_362.Default == true
	local v1_364 = self
	local v1_365 = Instance.new("TextButton")
	v1_365.Name = "Toggle"
	v1_365.Size = UDim2.new(1, 0, 0, 32)
	v1_365.BackgroundColor3 = v0_7.Element
	v1_365.BorderSizePixel = 0
	v1_365.Text = ""
	v1_365.AutoButtonColor = false
	v1_365.LayoutOrder = self._count
	v1_365.Parent = self.Holder
	v0_61(v1_365, 6)
	v0_19(v1_365, v0_7.Element, v0_7.Hover)
	local v1_366 = Instance.new("TextLabel")
	v1_366.Name = "Label"
	v1_366.Position = UDim2.new(0, 8, 0, 0)
	v1_366.Size = UDim2.new(1, -60, 1, 0)
	v1_366.BackgroundTransparency = 1
	v1_366.BorderSizePixel = 0
	v1_366.Text = v1_362.Name or "Toggle"
	v1_366.TextColor3 = v0_7.Text
	v1_366.Font = Enum.Font.Gotham
	v1_366.TextSize = 14
	v1_366.TextXAlignment = Enum.TextXAlignment.Left
	v1_366.TextTruncate = Enum.TextTruncate.AtEnd
	v1_366.Parent = v1_365
	local v1_367 = Instance.new("Frame")
	v1_367.Name = "Track"
	v1_367.AnchorPoint = Vector2.new(1, 0.5)
	v1_367.Position = UDim2.new(1, -8, 0.5, 0)
	v1_367.Size = UDim2.new(0, 34, 0, 18)
	v1_367.BackgroundColor3 = v0_7.Off
	v1_367.BorderSizePixel = 0
	v1_367.Parent = v1_365
	v0_61(v1_367, 9)
	local v1_368 = Instance.new("Frame")
	v1_368.Name = "Knob"
	v1_368.AnchorPoint = Vector2.new(0, 0.5)
	v1_368.Position = UDim2.new(0, 2, 0.5, 0)
	v1_368.Size = UDim2.new(0, 14, 0, 14)
	v1_368.BackgroundColor3 = v0_7.Text
	v1_368.BorderSizePixel = 0
	v1_368.Parent = v1_367
	v0_61(v1_368, 7)
	local function v1_369(v2_370)
		local v2_371 = TweenInfo.new(v2_370 and 0.15 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		v0_5:Create(v1_367, v2_371, { BackgroundColor3 = v1_363 and v0_7.Accent or v0_7.Off }):Play()
		v0_5:Create(v1_368, v2_371, {
			Position = v1_363 and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}):Play()
	end
	v1_369(false)
	local v1_372 = { Instance = v1_365 }
	function v1_372:Set(v2_373, v2_374)
		v1_363 = v2_373 and true or false
		v1_369(true)
		if not v2_374 and v1_362.Callback then v1_362.Callback(v1_363) end
	end
	function v1_372:Get()
		return v1_363
	end
	v1_365.MouseButton1Click:Connect(function()
		v1_372:Set(not v1_363)
	end)
	function v1_372:AddKeybind(v2_375)
		if v1_372.Keybind then
			warn("[RobloxUI] this toggle already has a keybind")
			return v1_372.Keybind
		end
		local v2_376 = v0_332(v1_364._lib, v1_365, v2_375, UDim2.new(1, -48, 0.5, 0), function()
			v1_372:Set(not v1_363)
		end)
		v0_352(v1_366, v2_376, 60)
		local v2_377 = v2_376.Destroy
		function v2_376:Destroy()
			v2_377(v2_376)
			v1_372.Keybind = nil
			v1_366.Size = UDim2.new(1, -60, 1, 0)
		end
		v1_372.Keybind = v2_376
		return v2_376
	end
	function v1_372:Destroy()
		if v1_372._destroyed then return end
		v1_372._destroyed = true
		if v1_372.Keybind then v1_372.Keybind:Destroy() end
		v1_365:Destroy()
	end
	return v1_372
end
function v0_3:AddParagraph(v1_378)
	v1_378 = v1_378 or {}
	self._count += 1
	local v1_379 = v1_378.Title and tostring(v1_378.Title) or ""
	local v1_380 = v1_378.Content and tostring(v1_378.Content) or ""
	local v1_381 = Instance.new("Frame")
	v1_381.Name = "Paragraph"
	v1_381.Size = UDim2.new(1, 0, 0, 0)
	v1_381.AutomaticSize = Enum.AutomaticSize.Y
	v1_381.BackgroundColor3 = v0_7.Element
	v1_381.BorderSizePixel = 0
	v1_381.LayoutOrder = self._count
	v1_381.Parent = self.Holder
	v0_61(v1_381, 6)
	local v1_382 = Instance.new("UIPadding")
	v1_382.PaddingTop = UDim.new(0, 8)
	v1_382.PaddingBottom = UDim.new(0, 8)
	v1_382.PaddingLeft = UDim.new(0, 8)
	v1_382.PaddingRight = UDim.new(0, 8)
	v1_382.Parent = v1_381
	local v1_383 = Instance.new("UIListLayout")
	v1_383.Padding = UDim.new(0, 3)
	v1_383.SortOrder = Enum.SortOrder.LayoutOrder
	v1_383.Parent = v1_381
	local function v1_384(v2_385, v2_386, v2_387, v2_388, v2_389)
		local v2_390 = Instance.new("TextLabel")
		v2_390.Name = v2_385
		v2_390.Size = UDim2.new(1, 0, 0, 0)
		v2_390.AutomaticSize = Enum.AutomaticSize.Y
		v2_390.BackgroundTransparency = 1
		v2_390.BorderSizePixel = 0
		v2_390.TextColor3 = v2_388
		v2_390.Font = v2_386
		v2_390.TextSize = v2_387
		v2_390.TextWrapped = true
		v2_390.RichText = v1_378.RichText == true
		v2_390.TextXAlignment = Enum.TextXAlignment.Left
		v2_390.TextYAlignment = Enum.TextYAlignment.Top
		v2_390.LayoutOrder = v2_389
		v2_390.Parent = v1_381
		return v2_390
	end
	local v1_391 = v1_384("Title", Enum.Font.GothamBold, 14, v0_7.Text, 1)
	local v1_392 = v1_384("Content", Enum.Font.Gotham, 13, v0_7.SubText, 2)
	local function v1_393(v2_394)
		v1_391.Text = v1_379
		v1_391.Visible = v1_379 ~= ""
		v1_392.Text = v1_380
		v1_392.Visible = v1_380 ~= ""
		if v2_394 then
			v1_391.TextTransparency = 1
			v1_392.TextTransparency = 1
			v0_10(v1_391, { TextTransparency = 0 }, 0.2)
			v0_10(v1_392, { TextTransparency = 0 }, 0.2)
		end
	end
	v1_393(false)
	local v1_395 = { Instance = v1_381 }
	function v1_395:SetTitle(v2_396)
		v1_379 = v2_396 and tostring(v2_396) or ""
		v1_393(true)
	end
	function v1_395:SetContent(v2_397)
		v1_380 = v2_397 and tostring(v2_397) or ""
		v1_393(true)
	end
	function v1_395:Set(v2_398)
		v2_398 = v2_398 or {}
		if v2_398.Title ~= nil then v1_379 = tostring(v2_398.Title) end
		if v2_398.Content ~= nil then v1_380 = tostring(v2_398.Content) end
		v1_393(true)
	end
	function v1_395:Get()
		return v1_379, v1_380
	end
	function v1_395:Destroy()
		v1_381:Destroy()
	end
	return v1_395
end
function v0_3:AddTextbox(v1_399)
	v1_399 = v1_399 or {}
	self._count += 1
	local v1_400 = v1_399.Numeric == true
	local v1_401 = tonumber(v1_399.MaxLength)
	local v1_402 = v1_399.Name ~= nil and v1_399.Name ~= ""
	local v1_403, v1_404, v1_405 = false, false, false
	local function v1_406(v2_407)
		if v1_399.Min then v2_407 = math.max(v2_407, v1_399.Min) end
		if v1_399.Max then v2_407 = math.min(v2_407, v1_399.Max) end
		return v2_407
	end
	local v1_408
	if v1_400 then
		v1_408 = tonumber(v1_399.Default)
		if v1_408 then v1_408 = v1_406(v1_408) end
	else
		v1_408 = tostring(v1_399.Default or "")
	end
	local function v1_409(v2_410)
		return v2_410 == nil and "" or tostring(v2_410)
	end
	local function v1_411(v2_412)
		local v2_413 = v2_412:sub(1, 1) == "-"
		v2_412 = v2_412:gsub("[^%d%.]", "")
		local v2_414 = v2_412:find(".", 1, true)
		if v2_414 then
			local v3_415 = v2_412:sub(v2_414 + 1):gsub("%.", "")
			v2_412 = v2_412:sub(1, v2_414) .. v3_415
		end
		return (v2_413 and "-" or "") .. v2_412
	end
	local v1_416 = Instance.new("Frame")
	v1_416.Name = "Textbox"
	v1_416.Size = UDim2.new(1, 0, 0, 32)
	v1_416.BackgroundColor3 = v0_7.Element
	v1_416.BorderSizePixel = 0
	v1_416.LayoutOrder = self._count
	v1_416.Parent = self.Holder
	v0_61(v1_416, 6)
	if v1_402 then
		local v2_417 = Instance.new("TextLabel")
		v2_417.Name = "Label"
		v2_417.Position = UDim2.new(0, 8, 0, 0)
		v2_417.Size = UDim2.new(0.4, -8, 1, 0)
		v2_417.BackgroundTransparency = 1
		v2_417.BorderSizePixel = 0
		v2_417.Text = v1_399.Name
		v2_417.TextColor3 = v0_7.Text
		v2_417.Font = Enum.Font.Gotham
		v2_417.TextSize = 14
		v2_417.TextXAlignment = Enum.TextXAlignment.Left
		v2_417.TextTruncate = Enum.TextTruncate.AtEnd
		v2_417.Parent = v1_416
	end
	local v1_418 = Instance.new("Frame")
	v1_418.Name = "BoxHolder"
	v1_418.AnchorPoint = Vector2.new(1, 0.5)
	v1_418.Position = UDim2.new(1, -6, 0.5, 0)
	v1_418.Size = v1_402 and UDim2.new(0.6, -10, 0, 22) or UDim2.new(1, -12, 0, 22)
	v1_418.BackgroundColor3 = v0_7.Card
	v1_418.BorderSizePixel = 0
	v1_418.Parent = v1_416
	v0_61(v1_418, 5)
	local v1_419 = Instance.new("UIStroke")
	v1_419.Color = v0_7.Accent
	v1_419.Thickness = 1
	v1_419.Transparency = 1
	v1_419.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_419.Parent = v1_418
	local v1_420 = Instance.new("TextBox")
	v1_420.Name = "Input"
	v1_420.Size = UDim2.new(1, 0, 1, 0)
	v1_420.BackgroundTransparency = 1
	v1_420.BorderSizePixel = 0
	v1_420.Text = v1_409(v1_408)
	v1_420.PlaceholderText = v1_399.Placeholder or ""
	v1_420.PlaceholderColor3 = v0_7.IconOff
	v1_420.TextColor3 = v0_7.Text
	v1_420.Font = Enum.Font.Gotham
	v1_420.TextSize = 13
	v1_420.TextXAlignment = Enum.TextXAlignment.Left
	v1_420.ClearTextOnFocus = v1_399.ClearTextOnFocus == true
	v1_420.ClipsDescendants = true
	v1_420.Parent = v1_418
	local v1_421 = Instance.new("UIPadding")
	v1_421.PaddingLeft = UDim.new(0, 6)
	v1_421.PaddingRight = UDim.new(0, 6)
	v1_421.Parent = v1_420
	local function v1_422()
		v0_10(v1_418, { BackgroundColor3 = (v1_404 and not v1_403) and v0_7.Sidebar or v0_7.Card }, 0.12)
		v0_10(v1_419, { Transparency = v1_403 and 0 or 1 }, 0.15)
	end
	v1_420:GetPropertyChangedSignal("Text"):Connect(function()
		if v1_405 then return end
		local v2_423 = v1_420.Text
		if v1_400 then v2_423 = v1_411(v2_423) end
		if v1_401 and #v2_423 > v1_401 then v2_423 = v2_423:sub(1, v1_401) end
		if v2_423 ~= v1_420.Text then
			v1_405 = true
			v1_420.Text = v2_423
			v1_405 = false
		end
	end)
	v1_420.Focused:Connect(function()
		v1_403 = true
		v1_422()
	end)
	v1_420.FocusLost:Connect(function(v2_424)
		v1_403 = false
		v1_422()
		if v1_400 then
			local v3_425 = tonumber(v1_420.Text)
			if v3_425 == nil then
				v1_420.Text = v1_409(v1_408)
				return
			end
			v3_425 = v1_406(v3_425)
			v1_408 = v3_425
			v1_420.Text = v1_409(v3_425)
		else
			v1_408 = v1_420.Text
		end
		if v1_399.Callback then v1_399.Callback(v1_408, v2_424) end
	end)
	v1_418.MouseEnter:Connect(function()
		v1_404 = true
		v1_422()
	end)
	v1_418.MouseLeave:Connect(function()
		v1_404 = false
		v1_422()
	end)
	local v1_426 = { Instance = v1_416 }
	function v1_426:Set(v2_427, v2_428)
		if v1_400 then
			local v3_429 = tonumber(v2_427)
			if v3_429 == nil then return end
			v1_408 = v1_406(v3_429)
		else
			v1_408 = tostring(v2_427 == nil and "" or v2_427)
			if v1_401 then v1_408 = v1_408:sub(1, v1_401) end
		end
		v1_420.Text = v1_409(v1_408)
		if not v2_428 and v1_399.Callback then v1_399.Callback(v1_408, false) end
	end
	function v1_426:Get()
		return v1_408
	end
	function v1_426:Focus()
		v1_420:CaptureFocus()
	end
	function v1_426:Destroy()
		if v1_420:IsFocused() then v1_420:ReleaseFocus() end
		v1_416:Destroy()
	end
	return v1_426
end
function v0_3:AddKeybind(v1_430)
	v1_430 = v1_430 or {}
	self._count += 1
	local v1_431 = Instance.new("Frame")
	v1_431.Name = "KeybindRow"
	v1_431.Size = UDim2.new(1, 0, 0, 32)
	v1_431.BackgroundColor3 = v0_7.Element
	v1_431.BorderSizePixel = 0
	v1_431.LayoutOrder = self._count
	v1_431.Parent = self.Holder
	v0_61(v1_431, 6)
	local v1_432 = Instance.new("TextLabel")
	v1_432.Name = "Label"
	v1_432.Position = UDim2.new(0, 8, 0, 0)
	v1_432.Size = UDim2.new(1, -60, 1, 0)
	v1_432.BackgroundTransparency = 1
	v1_432.BorderSizePixel = 0
	v1_432.Text = v1_430.Name or "Keybind"
	v1_432.TextColor3 = v0_7.Text
	v1_432.Font = Enum.Font.Gotham
	v1_432.TextSize = 14
	v1_432.TextXAlignment = Enum.TextXAlignment.Left
	v1_432.TextTruncate = Enum.TextTruncate.AtEnd
	v1_432.Parent = v1_431
	local v1_433 = v0_332(self._lib, v1_431, v1_430, UDim2.new(1, -8, 0.5, 0), function()
		if v1_430.OnPress then v1_430.OnPress() end
	end)
	v0_352(v1_432, v1_433, 16)
	v1_433.Row = v1_431
	local v1_434 = v1_433.Destroy
	function v1_433:Destroy()
		v1_434(v1_433)
		v1_431:Destroy()
	end
	return v1_433
end
function v0_3:AddSlider(v1_435)
	v1_435 = v1_435 or {}
	self._count += 1
	local v1_436 = self._lib
	local function v1_437(v2_438)
		return #(tostring(v2_438):match("%.(%d+)") or "")
	end
	local v1_439 = tonumber(v1_435.Min) or 0
	local v1_440 = tonumber(v1_435.Max) or 100
	if v1_440 < v1_439 then v1_439, v1_440 = v1_440, v1_439 end
	local v1_441 = tonumber(v1_435.Increment) or 1
	if v1_441 <= 0 then v1_441 = 1 end
	local v1_442 = math.max(v1_437(v1_441), v1_437(v1_439))
	local v1_443 = v1_435.ValueName
	local function v1_444(v2_445)
		v2_445 = math.clamp(v2_445, v1_439, v1_440)
		v2_445 = v1_439 + math.floor((v2_445 - v1_439) / v1_441 + 0.5) * v1_441
		v2_445 = math.clamp(v2_445, v1_439, v1_440)
		local v2_446 = 10 ^ v1_442
		return math.floor(v2_445 * v2_446 + 0.5) / v2_446
	end
	local function v1_447(v2_448)
		return v1_440 > v1_439 and (v2_448 - v1_439) / (v1_440 - v1_439) or 0
	end
	local function v1_449(v2_450)
		local v2_451 = v1_442 > 0 and string.format("%." .. v1_442 .. "f", v2_450) or tostring(v2_450)
		if v1_443 and v1_443 ~= "" then v2_451 = v2_451 .. " " .. tostring(v1_443) end
		return v2_451
	end
	local v1_452 = v1_444(tonumber(v1_435.Default) or v1_439)
	local v1_453, v1_454 = false, false
	local v1_455 = nil
	local v1_456 = Instance.new("Frame")
	v1_456.Name = "Slider"
	v1_456.Size = UDim2.new(1, 0, 0, 46)
	v1_456.BackgroundColor3 = v0_7.Element
	v1_456.BorderSizePixel = 0
	v1_456.LayoutOrder = self._count
	v1_456.Parent = self.Holder
	v0_61(v1_456, 6)
	local v1_457 = Instance.new("TextLabel")
	v1_457.Name = "Name"
	v1_457.Position = UDim2.new(0, 8, 0, 6)
	v1_457.Size = UDim2.new(0.6, -8, 0, 16)
	v1_457.BackgroundTransparency = 1
	v1_457.BorderSizePixel = 0
	v1_457.Text = v1_435.Name or "Slider"
	v1_457.TextColor3 = v0_7.Text
	v1_457.Font = Enum.Font.Gotham
	v1_457.TextSize = 14
	v1_457.TextXAlignment = Enum.TextXAlignment.Left
	v1_457.TextTruncate = Enum.TextTruncate.AtEnd
	v1_457.Parent = v1_456
	local v1_458 = Instance.new("TextLabel")
	v1_458.Name = "Value"
	v1_458.Position = UDim2.new(0.6, 0, 0, 6)
	v1_458.Size = UDim2.new(0.4, -8, 0, 16)
	v1_458.BackgroundTransparency = 1
	v1_458.BorderSizePixel = 0
	v1_458.Text = v1_449(v1_452)
	v1_458.TextColor3 = v0_7.SubText
	v1_458.Font = Enum.Font.GothamBold
	v1_458.TextSize = 13
	v1_458.TextXAlignment = Enum.TextXAlignment.Right
	v1_458.TextTruncate = Enum.TextTruncate.AtEnd
	v1_458.Parent = v1_456
	local v1_459 = Instance.new("Frame")
	v1_459.Name = "Track"
	v1_459.Position = UDim2.new(0, 8, 0, 31)
	v1_459.Size = UDim2.new(1, -16, 0, 6)
	v1_459.BackgroundColor3 = v0_7.Off
	v1_459.BorderSizePixel = 0
	v1_459.Parent = v1_456
	local v1_460 = Instance.new("Frame")
	v1_460.Name = "Fill"
	v1_460.Size = UDim2.new(v1_447(v1_452), 0, 1, 0)
	v1_460.BackgroundColor3 = v0_7.Accent
	v1_460.BorderSizePixel = 0
	v1_460.Parent = v1_459
	local v1_461 = v0_7.Accent
	local v1_462 = v0_7.Accent:Lerp(v0_7.Text, 0.25)
	local v1_463 = Instance.new("TextButton")
	v1_463.Name = "Hit"
	v1_463.Size = UDim2.new(1, 0, 1, 0)
	v1_463.BackgroundTransparency = 1
	v1_463.BorderSizePixel = 0
	v1_463.Text = ""
	v1_463.AutoButtonColor = false
	v1_463.Parent = v1_456
	local function v1_464()
		local v2_465 = v1_453 or v1_454
		v0_10(v1_456, { BackgroundColor3 = v2_465 and v0_7.Hover or v0_7.Element }, 0.12)
		v0_10(v1_460, { BackgroundColor3 = v2_465 and v1_462 or v1_461 }, 0.12)
	end
	local function v1_466(v2_467)
		local v2_468 = v1_447(v1_452)
		v0_10(v1_460, { Size = UDim2.new(v2_468, 0, 1, 0) }, v2_467)
		v1_458.Text = v1_449(v1_452)
	end
	local function v1_469(v2_470, v2_471, v2_472)
		v2_470 = v1_444(v2_470)
		local v2_473 = v2_470 ~= v1_452
		v1_452 = v2_470
		v1_466(v2_472)
		if v2_473 then
			v1_458.TextColor3 = v0_7.Text
			v0_10(v1_458, { TextColor3 = v0_7.SubText }, 0.3)
			if not v2_471 and v1_435.Callback then v1_435.Callback(v1_452) end
		end
	end
	local function v1_474(v2_475)
		local v2_476 = v1_459.AbsoluteSize.X
		if v2_476 <= 0 then return end
		v1_469(v1_439 + ((v2_475 - v1_459.AbsolutePosition.X) / v2_476) * (v1_440 - v1_439), false, 0.08)
	end
	local function v1_477()
		if v1_455 then
			for v4_478, v4_479 in ipairs(v1_455) do v4_479:Disconnect() end
			v1_455 = nil
		end
		if v1_454 then
			v1_454 = false
			v1_464()
		end
	end
	local function v1_480(v2_481)
		v1_477()
		v1_454 = true
		v1_464()
		v1_474(v2_481.Position.X)
		v1_455 = {
			v0_4.InputChanged:Connect(function(v3_482)
				if v3_482.UserInputType == Enum.UserInputType.MouseMovement or v3_482 == v2_481 then
					v1_474(v3_482.Position.X)
				end
			end),
			v0_4.InputEnded:Connect(function(v3_483)
				if v3_483 == v2_481 or v3_483.UserInputType == Enum.UserInputType.MouseButton1 then
					v1_477()
				end
			end),
		}
	end
	v1_463.InputBegan:Connect(function(v2_484)
		if v0_17(v2_484) then v1_480(v2_484) end
	end)
	v1_463.MouseEnter:Connect(function()
		v1_453 = true
		v1_464()
	end)
	v1_463.MouseLeave:Connect(function()
		v1_453 = false
		v1_464()
	end)
	local v1_485 = { Instance = v1_456 }
	function v1_485:Set(v2_486, v2_487)
		v1_469(tonumber(v2_486) or v1_452, v2_487, 0.2)
	end
	function v1_485:Get()
		return v1_452
	end
	function v1_485:Destroy()
		v1_477()
		v1_436._cleanups[v1_485] = nil
		v1_456:Destroy()
	end
	v1_436._cleanups[v1_485] = v1_477
	return v1_485
end
function v0_3:AddDropdown(v1_488)
	v1_488 = v1_488 or {}
	self._count += 1
	local v1_489 = v1_488.Options or {}
	local v1_490 = v1_488.Multi == true
	local v1_491 = 130
	local v1_492, v1_493 = 26, 4
	local v1_494 = nil
	local v1_495 = {}
	local v1_496 = {}
	local v1_497 = false
	local v1_498 = 0
	local v1_499 = nil
	local v1_500 = Instance.new("Frame")
	v1_500.Name = "Dropdown"
	v1_500.Size = UDim2.new(1, 0, 0, 32)
	v1_500.AutomaticSize = Enum.AutomaticSize.Y
	v1_500.BackgroundTransparency = 1
	v1_500.BorderSizePixel = 0
	v1_500.LayoutOrder = self._count
	v1_500.Parent = self.Holder
	local v1_501 = Instance.new("UIListLayout")
	v1_501.Padding = UDim.new(0, 4)
	v1_501.SortOrder = Enum.SortOrder.LayoutOrder
	v1_501.Parent = v1_500
	local v1_502 = Instance.new("TextButton")
	v1_502.Name = "Header"
	v1_502.Size = UDim2.new(1, 0, 0, 32)
	v1_502.BackgroundColor3 = v0_7.Element
	v1_502.BorderSizePixel = 0
	v1_502.Text = ""
	v1_502.AutoButtonColor = false
	v1_502.LayoutOrder = 1
	v1_502.Parent = v1_500
	v0_61(v1_502, 6)
	v0_19(v1_502, v0_7.Element, v0_7.Hover)
	local v1_503 = Instance.new("TextLabel")
	v1_503.Name = "Name"
	v1_503.Position = UDim2.new(0, 8, 0, 0)
	v1_503.Size = UDim2.new(0.5, -8, 1, 0)
	v1_503.BackgroundTransparency = 1
	v1_503.BorderSizePixel = 0
	v1_503.Text = v1_488.Name or "Dropdown"
	v1_503.TextColor3 = v0_7.Text
	v1_503.Font = Enum.Font.Gotham
	v1_503.TextSize = 14
	v1_503.TextXAlignment = Enum.TextXAlignment.Left
	v1_503.TextTruncate = Enum.TextTruncate.AtEnd
	v1_503.Parent = v1_502
	local v1_504 = Instance.new("TextLabel")
	v1_504.Name = "Value"
	v1_504.Position = UDim2.new(0.5, 0, 0, 0)
	v1_504.Size = UDim2.new(0.5, -28, 1, 0)
	v1_504.BackgroundTransparency = 1
	v1_504.BorderSizePixel = 0
	v1_504.Text = "None"
	v1_504.TextColor3 = v0_7.SubText
	v1_504.Font = Enum.Font.Gotham
	v1_504.TextSize = 13
	v1_504.TextXAlignment = Enum.TextXAlignment.Right
	v1_504.TextTruncate = Enum.TextTruncate.AtEnd
	v1_504.Parent = v1_502
	local v1_505 = Instance.new("ImageLabel")
	v1_505.Name = "Arrow"
	v1_505.AnchorPoint = Vector2.new(1, 0.5)
	v1_505.Position = UDim2.new(1, -8, 0.5, 0)
	v1_505.Size = UDim2.new(0, 16, 0, 16)
	v1_505.BackgroundTransparency = 1
	v1_505.BorderSizePixel = 0
	v1_505.ImageColor3 = v0_7.SubText
	v1_505.ScaleType = Enum.ScaleType.Fit
	v1_505.Parent = v1_502
	local v1_506 = Instance.new("TextLabel")
	v1_506.Name = "ArrowFallback"
	v1_506.Size = UDim2.new(1, 0, 1, 0)
	v1_506.BackgroundTransparency = 1
	v1_506.Text = "▼"
	v1_506.TextColor3 = v0_7.SubText
	v1_506.Font = Enum.Font.Gotham
	v1_506.TextSize = 9
	v1_506.Visible = false
	v1_506.Parent = v1_505
	local function v1_507(v2_508)
		local v2_509 = v0_42(v1_505, v2_508 and "chevron-up" or "chevron-down", self._icons)
		if not v2_509 then v1_505.Image = "" end
		v1_506.Visible = not v2_509
		v1_506.Text = v2_508 and "▲" or "▼"
		v1_505.ImageTransparency = 1
		v1_506.TextTransparency = 1
		v0_10(v1_505, { ImageTransparency = 0 }, 0.18)
		v0_10(v1_506, { TextTransparency = 0 }, 0.18)
	end
	v1_507(false)
	local v1_510 = Instance.new("ScrollingFrame")
	v1_510.Name = "List"
	v1_510.Size = UDim2.new(1, 0, 0, 0)
	v1_510.BackgroundColor3 = v0_7.Sidebar
	v1_510.BorderSizePixel = 0
	v1_510.ScrollBarThickness = 3
	v1_510.ScrollBarImageColor3 = v0_7.IconOff
	v1_510.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_510.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_510.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_510.Visible = false
	v1_510.LayoutOrder = 2
	v1_510.Parent = v1_500
	v0_61(v1_510, 6)
	local v1_511 = Instance.new("UIPadding")
	v1_511.PaddingTop = UDim.new(0, 4)
	v1_511.PaddingBottom = UDim.new(0, 4)
	v1_511.Parent = v1_510
	local v1_512 = Instance.new("UIListLayout")
	v1_512.Padding = UDim.new(0, v1_493)
	v1_512.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_512.SortOrder = Enum.SortOrder.LayoutOrder
	v1_512.Parent = v1_510
	local function v1_513(v2_514)
		if v1_490 then return v1_495[v2_514] == true end
		return v1_494 == v2_514
	end
	local function v1_515()
		local v2_516 = {}
		for v3_517, v3_518 in ipairs(v1_489) do
			if v1_495[v3_518] then table.insert(v2_516, v3_518) end
		end
		return v2_516
	end
	local function v1_519()
		for v3_520, v3_521 in pairs(v1_496) do
			local v3_522 = v1_513(v3_520)
			v3_521.BackgroundColor3 = v3_522 and v0_7.Accent or v0_7.Element
			v3_521.TextColor3 = v3_522 and v0_7.IconOn or v0_7.SubText
		end
		if v1_490 then
			local v3_523 = {}
			for v4_524, v4_525 in ipairs(v1_515()) do table.insert(v3_523, tostring(v4_525)) end
			v1_504.Text = #v3_523 > 0 and table.concat(v3_523, ", ") or "None"
		else
			v1_504.Text = v1_494 ~= nil and tostring(v1_494) or "None"
		end
	end
	local function v1_526(v2_527)
		if v1_497 == v2_527 then return end
		v1_497 = v2_527
		if v1_499 then v1_499:Cancel() end
		v1_507(v2_527)
		if v2_527 then
			v1_510.Visible = true
			v1_499 = v0_10(v1_510, { Size = UDim2.new(1, 0, 0, v1_498) }, 0.22, Enum.EasingStyle.Quint)
		else
			local v3_528 = v0_10(v1_510, { Size = UDim2.new(1, 0, 0, 0) }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v1_499 = v3_528
			v3_528.Completed:Connect(function(v4_529)
				if v4_529 == Enum.PlaybackState.Completed and not v1_497 then
					v1_510.Visible = false
				end
			end)
		end
	end
	local v1_530 = { Instance = v1_500 }
	local function v1_531()
		if v1_488.Callback then
			v1_488.Callback(v1_490 and v1_515() or v1_494)
		end
	end
	local function v1_532()
		for v3_533, v3_534 in pairs(v1_496) do v3_534:Destroy() end
		v1_496 = {}
		for v3_535, v3_536 in ipairs(v1_489) do
			local v3_537 = Instance.new("TextButton")
			v3_537.Name = "Option"
			v3_537.Size = UDim2.new(1, -8, 0, v1_492)
			v3_537.BackgroundColor3 = v0_7.Element
			v3_537.BorderSizePixel = 0
			v3_537.Text = tostring(v3_536)
			v3_537.TextColor3 = v0_7.SubText
			v3_537.Font = Enum.Font.Gotham
			v3_537.TextSize = 13
			v3_537.TextTruncate = Enum.TextTruncate.AtEnd
			v3_537.AutoButtonColor = true
			v3_537.LayoutOrder = v3_535
			v3_537.Parent = v1_510
			v0_61(v3_537, 5)
			v3_537.MouseButton1Click:Connect(function()
				if v1_490 then
					v1_495[v3_536] = not v1_495[v3_536] or nil
					v1_519()
					v1_531()
				else
					v1_494 = v3_536
					v1_519()
					v1_526(false)
					v1_531()
				end
			end)
			v1_496[v3_536] = v3_537
		end
		local v2_538 = #v1_489
		local v2_539 = v2_538 > 0 and (v2_538 * v1_492 + (v2_538 - 1) * v1_493 + 8) or 0
		v1_498 = math.min(v2_539, v1_491)
		v1_510.Size = UDim2.new(1, 0, 0, v1_497 and v1_498 or 0)
		v1_519()
	end
	function v1_530:Set(v2_540, v2_541)
		if v1_490 then
			v1_495 = {}
			for v4_542, v4_543 in ipairs(typeof(v2_540) == "table" and v2_540 or { v2_540 }) do
				v1_495[v4_543] = true
			end
		else
			v1_494 = v2_540
		end
		v1_519()
		if not v2_541 then v1_531() end
	end
	function v1_530:Get()
		return v1_490 and v1_515() or v1_494
	end
	function v1_530:Refresh(v2_544, v2_545)
		v1_489 = v2_544 or {}
		if v2_545 then
			local v3_546 = {}
			for v4_547, v4_548 in ipairs(v1_489) do v3_546[v4_548] = true end
			if v1_490 then
				for v5_549 in pairs(v1_495) do
					if not v3_546[v5_549] then v1_495[v5_549] = nil end
				end
			elseif not v3_546[v1_494] then
				v1_494 = nil
			end
		else
			v1_495, v1_494 = {}, nil
		end
		v1_532()
	end
	function v1_530:Open() v1_526(true) end
	function v1_530:Close() v1_526(false) end
	v1_502.MouseButton1Click:Connect(function()
		v1_526(not v1_497)
	end)
	v1_532()
	if v1_488.Default ~= nil then
		v1_530:Set(v1_488.Default, true)
	end
	return v1_530
end
return v0_1
