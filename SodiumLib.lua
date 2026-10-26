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
		v1_66._hint = { Frame = v2_92, Icon = v2_93, Bounce = v2_95, Shown = false }
	end
	if v1_65.Resizable ~= false then
		local v2_96 = v1_65.MinSize or Vector2.new(380, 260)
		local v2_97 = v1_65.MaxSize
		local v2_98 = Instance.new("TextButton")
		v2_98.Name = "ResizeGrip"
		v2_98.AnchorPoint = Vector2.new(1, 1)
		v2_98.Position = UDim2.new(1, -6, 1, -6)
		v2_98.Size = UDim2.new(0, 22, 0, 22)
		v2_98.BackgroundColor3 = v0_7.Main
		v2_98.BackgroundTransparency = 0.25
		v2_98.BorderSizePixel = 0
		v2_98.Text = ""
		v2_98.AutoButtonColor = false
		v2_98.Parent = v1_69
		v0_61(v2_98, 6)
		local v2_99 = Instance.new("ImageLabel")
		v2_99.Name = "Icon"
		v2_99.AnchorPoint = Vector2.new(0.5, 0.5)
		v2_99.Position = UDim2.new(0.5, 0, 0.5, 0)
		v2_99.Size = UDim2.new(0, 14, 0, 14)
		v2_99.BackgroundTransparency = 1
		v2_99.BorderSizePixel = 0
		v2_99.ImageColor3 = v0_7.IconOff
		v2_99.ScaleType = Enum.ScaleType.Fit
		v2_99.Parent = v2_98
		local v2_100 = Instance.new("TextLabel")
		v2_100.Name = "IconFallback"
		v2_100.Size = UDim2.new(1, 0, 1, 0)
		v2_100.BackgroundTransparency = 1
		v2_100.Text = "⤢"
		v2_100.TextColor3 = v0_7.IconOff
		v2_100.Font = Enum.Font.GothamBold
		v2_100.TextSize = 14
		v2_100.Parent = v2_99
		v2_100.Visible = not v0_42(v2_99, "expand", v1_66.Icons)
		local v2_101 = Instance.new("UIScale")
		v2_101.Parent = v2_98
		local v2_102, v2_103, v2_104 = false, false, nil
		local function v2_105()
			local v3_106 = v2_102 or v2_103
			local v3_107 = v3_106 and v0_7.IconOn or v0_7.IconOff
			v0_10(v2_99, { ImageColor3 = v3_107 }, 0.15)
			v0_10(v2_100, { TextColor3 = v3_107 }, 0.15)
			v0_10(v2_98, { BackgroundColor3 = v3_106 and v0_7.Hover or v0_7.Main }, 0.15)
		end
		local function v2_108()
			if v2_104 then
				for v5_109, v5_110 in ipairs(v2_104) do v5_110:Disconnect() end
				v2_104 = nil
			end
			if v2_103 then
				v2_103 = false
				v2_105()
				v0_10(v2_101, { Scale = v2_102 and 1.1 or 1 }, 0.18, Enum.EasingStyle.Back)
			end
		end
		local function v2_111(v3_112)
			v2_108()
			v2_103 = true
			v2_105()
			v0_10(v2_101, { Scale = 0.9 }, 0.08)
			local v3_113 = v1_70.Scale
			local v3_114 = v3_112.Position
			local v3_115 = v1_69.AbsoluteSize / v3_113
			local v3_116 = v1_69.AbsolutePosition
			v2_104 = {
				v0_4.InputChanged:Connect(function(v4_117)
					if v4_117.UserInputType ~= Enum.UserInputType.MouseMovement and v4_117 ~= v3_112 then return end
					local v4_118 = v4_117.Position - v3_114
					local v4_119 = v1_67.AbsoluteSize
					local v4_120 = math.max(v2_96.X, v4_119.X - v3_116.X - 4)
					local v4_121 = math.max(v2_96.Y, v4_119.Y - v3_116.Y - 4)
					if v2_97 then
						v4_120 = math.max(v2_96.X, math.min(v4_120, v2_97.X))
						v4_121 = math.max(v2_96.Y, math.min(v4_121, v2_97.Y))
					end
					local v4_122 = math.clamp(v3_115.X + v4_118.X / v3_113, v2_96.X, v4_120)
					local v4_123 = math.clamp(v3_115.Y + v4_118.Y / v3_113, v2_96.Y, v4_121)
					v1_68 = UDim2.fromOffset(v4_122, v4_123)
					v1_69.Size = v1_68
					v1_69.Position = UDim2.fromOffset(v3_116.X + v4_122 * v3_113 / 2, v3_116.Y + v4_123 * v3_113 / 2)
				end),
				v0_4.InputEnded:Connect(function(v4_124)
					if v4_124 == v3_112 or v4_124.UserInputType == Enum.UserInputType.MouseButton1 then
						v2_108()
					end
				end),
			}
		end
		v2_98.InputBegan:Connect(function(v3_125)
			if v0_17(v3_125) then v2_111(v3_125) end
		end)
		v2_98.MouseEnter:Connect(function()
			v2_102 = true
			v2_105()
			if not v2_103 then v0_10(v2_101, { Scale = 1.1 }, 0.12) end
		end)
		v2_98.MouseLeave:Connect(function()
			v2_102 = false
			v2_105()
			if not v2_103 then v0_10(v2_101, { Scale = 1 }, 0.12) end
		end)
		v1_66._cleanups[v2_98] = v2_108
	end
	v1_66.ScreenGui, v1_66.Main, v1_66.Sidebar, v1_66.Content = v1_67, v1_69, v1_87, v1_91
	v1_66._scale = v1_70
	v1_66._visible = false
	if v1_65.Watermark ~= false then
		v1_66:_buildWatermark(v1_65.Title or "RobloxUI")
	end
	table.insert(v1_66._connections, v0_4.InputBegan:Connect(function(v2_126, v2_127)
		local v2_128 = v1_66._listening
		if v2_128 then
			if v2_126.UserInputType == Enum.UserInputType.Keyboard then
				if not v0_4:GetFocusedTextBox() then
					v2_128:_capture(v2_126.KeyCode)
				end
			elseif v0_17(v2_126) and not v2_127 then
				v2_128:_stopListening()
			end
			return
		end
		if v2_127 or v2_126.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local v2_129 = v2_126.KeyCode
		if v1_66._toggleKey and v2_129 == v1_66._toggleKey then
			v1_66:Toggle()
			return
		end
		for v3_130, v3_131 in ipairs(table.clone(v1_66._binds)) do
			if v3_131._key == v2_129 and not v3_131._destroyed then
				v3_131._onPress()
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
	for v2_132, v2_133 in ipairs(self._connections) do
		v2_133:Disconnect()
	end
	self._connections = {}
	self._destroyed = true
	for v2_134, v2_135 in ipairs(table.clone(self._notifs or {})) do pcall(v2_135) end
	for v2_136, v2_137 in pairs(self._cleanups) do pcall(v2_137) end
	self._cleanups = {}
	self._binds = {}
	self._listening = nil
	self.ScreenGui:Destroy()
end
local v0_138, v0_139 = 0.35, 0.2
function v0_1:_cancelAnim()
	if self._anim then
		for v3_140, v3_141 in ipairs(self._anim) do v3_141:Cancel() end
		self._anim = nil
	end
end
function v0_1:Show()
	if self._destroyed then return end
	self._visible = true
	self:_cancelAnim()
	self.Main.Visible = true
	self._anim = {
		v0_10(self.Main, { GroupTransparency = 0 }, v0_138, Enum.EasingStyle.Quint),
		v0_10(self._scale, { Scale = 1 }, v0_138, Enum.EasingStyle.Back),
	}
	self:_updateWatermark()
end
function v0_1:Hide()
	if self._destroyed or not self._visible then return end
	self._visible = false
	self:_cancelAnim()
	local v1_142 = v0_4:GetFocusedTextBox()
	if v1_142 and v1_142:IsDescendantOf(self.Main) then v1_142:ReleaseFocus() end
	local v1_143 = v0_10(self.Main, { GroupTransparency = 1 }, v0_139, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local v1_144 = v0_10(self._scale, { Scale = 0.92 }, v0_139, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	self._anim = { v1_143, v1_144 }
	v1_143.Completed:Connect(function(v2_145)
		if v2_145 == Enum.PlaybackState.Completed and not self._visible and not self._destroyed then
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
	local v1_146 = self._hint
	if not v1_146 or self._destroyed then return end
	local v1_147 = self.ActiveTab and self.ActiveTab.Page
	local v1_148 = false
	if v1_147 and v1_147.Visible then
		local v2_149 = v1_147.AbsoluteCanvasSize.Y - (v1_147.CanvasPosition.Y + v1_147.AbsoluteWindowSize.Y)
		v1_148 = v2_149 > 4
	end
	if v1_148 == v1_146.Shown then return end
	v1_146.Shown = v1_148
	if v1_146.Fade then v1_146.Fade:Cancel() end
	if v1_148 then
		v1_146.Frame.Visible = true
		v1_146.Icon.Position = UDim2.new(0.5, 0, 0.5, -3)
		v1_146.Bounce:Play()
		v1_146.Fade = v0_10(v1_146.Frame, { GroupTransparency = 0.15 }, 0.2)
	else
		local v2_150 = v0_10(v1_146.Frame, { GroupTransparency = 1 }, 0.2)
		v1_146.Fade = v2_150
		v2_150.Completed:Connect(function(v3_151)
			if v3_151 == Enum.PlaybackState.Completed and not v1_146.Shown then
				v1_146.Bounce:Cancel()
				v1_146.Frame.Visible = false
			end
		end)
	end
end
function v0_1:_keyTaken(v1_152, v1_153)
	if not v1_152 then return false end
	if v1_152 == self._toggleKey then return true end
	for v2_154, v2_155 in ipairs(self._binds) do
		if v2_155 ~= v1_153 and v2_155._key == v1_152 then return true end
	end
	return false
end
local v0_156, v0_157 = 280, 5
function v0_1:_getNotifyContainer()
	if self._notifyContainer and self._notifyContainer.Parent then
		return self._notifyContainer
	end
	local v1_158 = self.ScreenGui.AbsoluteSize
	local v1_159 = v1_158.X > 0 and math.min(v0_156, v1_158.X - 20) or v0_156
	local v1_160 = Instance.new("Frame")
	v1_160.Name = "Notifications"
	v1_160.AnchorPoint = Vector2.new(0.5, 0)
	v1_160.Position = UDim2.new(0.5, 0, 0, self._wm and 48 or 10)
	v1_160.Size = UDim2.new(0, v1_159, 0, 0)
	v1_160.AutomaticSize = Enum.AutomaticSize.Y
	v1_160.BackgroundTransparency = 1
	v1_160.BorderSizePixel = 0
	v1_160.Parent = self.ScreenGui
	local v1_161 = Instance.new("UIListLayout")
	v1_161.Padding = UDim.new(0, 6)
	v1_161.SortOrder = Enum.SortOrder.LayoutOrder
	v1_161.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_161.Parent = v1_160
	self._notifyContainer = v1_160
	return v1_160
end
function v0_1:Notify(v1_162)
	if self._destroyed then return end
	if type(v1_162) == "string" then v1_162 = { Content = v1_162 } end
	v1_162 = v1_162 or {}
	local v1_163 = tonumber(v1_162.Duration) or 4
	local v1_164 = self:_getNotifyContainer()
	self._notifyCount = (self._notifyCount or 0) + 1
	self._notifs = self._notifs or {}
	local v1_165 = false
	local v1_166 = Instance.new("Frame")
	v1_166.Name = "Notification"
	v1_166.Size = UDim2.new(1, 0, 0, 0)
	v1_166.BackgroundTransparency = 1
	v1_166.BorderSizePixel = 0
	v1_166.LayoutOrder = self._notifyCount
	v1_166.Parent = v1_164
	local v1_167 = Instance.new("CanvasGroup")
	v1_167.Name = "Card"
	v1_167.Size = UDim2.new(1, 0, 0, 0)
	v1_167.AutomaticSize = Enum.AutomaticSize.Y
	v1_167.BackgroundColor3 = v0_7.Sidebar
	v1_167.BorderSizePixel = 0
	v1_167.GroupTransparency = 1
	v1_167.Parent = v1_166
	v0_61(v1_167, 8)
	local v1_168 = Instance.new("UIStroke")
	v1_168.Color = v0_7.Element
	v1_168.Thickness = 1
	v1_168.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_168.Parent = v1_167
	local v1_169 = Instance.new("Frame")
	v1_169.Name = "Body"
	v1_169.Size = UDim2.new(1, 0, 0, 0)
	v1_169.AutomaticSize = Enum.AutomaticSize.Y
	v1_169.BackgroundTransparency = 1
	v1_169.BorderSizePixel = 0
	v1_169.Parent = v1_167
	local v1_170 = Instance.new("UIPadding")
	v1_170.PaddingTop = UDim.new(0, 8)
	v1_170.PaddingBottom = UDim.new(0, 8)
	v1_170.PaddingLeft = UDim.new(0, 12)
	v1_170.PaddingRight = UDim.new(0, 12)
	v1_170.Parent = v1_169
	local v1_171 = Instance.new("UISizeConstraint")
	v1_171.MinSize = Vector2.new(0, 30)
	v1_171.Parent = v1_169
	local v1_172 = Instance.new("Frame")
	v1_172.Name = "Texts"
	v1_172.Position = UDim2.new(0, 0, 0, 0)
	v1_172.Size = UDim2.new(1, 0, 0, 0)
	v1_172.AutomaticSize = Enum.AutomaticSize.Y
	v1_172.BackgroundTransparency = 1
	v1_172.BorderSizePixel = 0
	v1_172.Parent = v1_169
	local v1_173 = Instance.new("UIListLayout")
	v1_173.Padding = UDim.new(0, 2)
	v1_173.SortOrder = Enum.SortOrder.LayoutOrder
	v1_173.Parent = v1_172
	local function v1_174(v2_175, v2_176, v2_177, v2_178, v2_179)
		local v2_180 = Instance.new("TextLabel")
		v2_180.Size = UDim2.new(1, 0, 0, 0)
		v2_180.AutomaticSize = Enum.AutomaticSize.Y
		v2_180.BackgroundTransparency = 1
		v2_180.BorderSizePixel = 0
		v2_180.Text = v2_175
		v2_180.TextColor3 = v2_178
		v2_180.Font = v2_176
		v2_180.TextSize = v2_177
		v2_180.TextWrapped = true
		v2_180.TextXAlignment = Enum.TextXAlignment.Left
		v2_180.TextYAlignment = Enum.TextYAlignment.Top
		v2_180.LayoutOrder = v2_179
		v2_180.Parent = v1_172
		return v2_180
	end
	if v1_162.Title and v1_162.Title ~= "" then
		v1_174(tostring(v1_162.Title), Enum.Font.GothamBold, 13, v0_7.Text, 1).Name = "Title"
	end
	if v1_162.Content and v1_162.Content ~= "" then
		v1_174(tostring(v1_162.Content), Enum.Font.Gotham, 12, v0_7.SubText, 2).Name = "Content"
	end
	local v1_181 = Instance.new("TextLabel")
	v1_181.Name = "Countdown"
	v1_181.AnchorPoint = Vector2.new(1, 0.5)
	v1_181.Position = UDim2.new(1, 0, 0.5, 0)
	v1_181.Size = UDim2.new(0, 18, 0, 18)
	v1_181.BackgroundTransparency = 1
	v1_181.BorderSizePixel = 0
	v1_181.Text = tostring(math.ceil(v1_163))
	v1_181.TextColor3 = v0_7.SubText
	v1_181.Font = Enum.Font.GothamBold
	v1_181.TextSize = 13
	v1_181.TextXAlignment = Enum.TextXAlignment.Right
	v1_181.Visible = v1_163 > 0
	v1_181.Parent = v1_169
	if v1_163 > 0 then
		v1_172.Size = UDim2.new(1, -24, 0, 0)
	end
	local v1_182 = Instance.new("TextButton")
	v1_182.Name = "Click"
	v1_182.Size = UDim2.new(1, 0, 1, 0)
	v1_182.BackgroundTransparency = 1
	v1_182.BorderSizePixel = 0
	v1_182.Text = ""
	v1_182.AutoButtonColor = false
	v1_182.Parent = v1_167
	local v1_183, v1_184 = nil, nil
	local v1_185 = {}
	local function v1_186()
		if v1_165 then return end
		v1_165 = true
		local v2_187 = table.find(self._notifs, v1_186)
		if v2_187 then table.remove(self._notifs, v2_187) end
		if v1_183 and v1_183 ~= coroutine.running() then
			pcall(task.cancel, v1_183)
		end
		v1_183 = nil
		if v1_184 then
			v1_184:Disconnect()
			v1_184 = nil
		end
		for v3_188, v3_189 in ipairs(v1_185) do v3_189:Cancel() end
		v1_185 = {}
		if self._destroyed then return end
		local v2_190 = v0_10(v1_167, {
			Position = UDim2.new(0, 0, 0, -20),
			GroupTransparency = 1,
		}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_190.Completed:Connect(function()
			local v3_191 = v0_10(v1_166, { Size = UDim2.new(1, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quint)
			v3_191.Completed:Connect(function()
				v1_166:Destroy()
			end)
		end)
	end
	v1_182.MouseButton1Click:Connect(v1_186)
	table.insert(self._notifs, v1_186)
	while #self._notifs > v0_157 do
		self._notifs[1]()
	end
	task.spawn(function()
		v0_6.Heartbeat:Wait()
		v0_6.Heartbeat:Wait()
		local v2_192 = v1_167.AbsoluteSize.Y
		for v3_193 = 1, 10 do
			if v2_192 > 0 then break end
			v0_6.Heartbeat:Wait()
			v2_192 = v1_167.AbsoluteSize.Y
		end
		if v2_192 <= 0 then v2_192 = 50 end
		if v1_165 or self._destroyed or not v1_166.Parent then return end
		v1_167.Position = UDim2.new(0, 0, 0, -(v1_166.AbsolutePosition.Y + v2_192 + 10))
		v1_185 = {
			v0_10(v1_166, { Size = UDim2.new(1, 0, 0, v2_192) }, 0.3, Enum.EasingStyle.Quint),
			v0_10(v1_167, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back),
			v0_10(v1_167, { GroupTransparency = 0 }, 0.25),
		}
		v1_184 = v1_167:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if not v1_165 and v1_167.AbsoluteSize.Y > 0 then
				v1_166.Size = UDim2.new(1, 0, 0, v1_167.AbsoluteSize.Y)
			end
		end)
		if v1_163 > 0 then
			v1_183 = task.spawn(function()
				local v4_194 = os.clock()
				local v4_195 = math.ceil(v1_163)
				while not v1_165 and not self._destroyed do
					local v5_196 = v1_163 - (os.clock() - v4_194)
					local v5_197 = math.max(math.ceil(v5_196), 0)
					if v5_197 ~= v4_195 then
						v4_195 = v5_197
						v1_181.Text = tostring(v5_197)
						v1_181.TextTransparency = 0.6
						v0_10(v1_181, { TextTransparency = 0 }, 0.2)
					end
					if v5_196 <= 0 then
						v1_183 = nil
						v1_186()
						return
					end
					task.wait(v5_196 - (v5_197 - 1))
				end
			end)
		end
	end)
	return { Dismiss = v1_186 }
end
function v0_1:_buildWatermark(v1_198)
	local v1_199 = Instance.new("Frame")
	v1_199.Name = "Watermark"
	v1_199.AnchorPoint = Vector2.new(0.5, 0)
	v1_199.Position = UDim2.new(0.5, 0, 0, -40)
	v1_199.Size = UDim2.new(0, 0, 0, 30)
	v1_199.AutomaticSize = Enum.AutomaticSize.X
	v1_199.BackgroundColor3 = v0_7.Sidebar
	v1_199.BorderSizePixel = 0
	v1_199.Parent = self.ScreenGui
	v0_61(v1_199, 8)
	local v1_200 = Instance.new("UIStroke")
	v1_200.Color = v0_7.Element
	v1_200.Thickness = 1
	v1_200.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_200.Parent = v1_199
	local v1_201 = Instance.new("UIPadding")
	v1_201.PaddingLeft = UDim.new(0, 10)
	v1_201.PaddingRight = UDim.new(0, 4)
	v1_201.Parent = v1_199
	local v1_202 = Instance.new("UIListLayout")
	v1_202.FillDirection = Enum.FillDirection.Horizontal
	v1_202.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_202.Padding = UDim.new(0, 8)
	v1_202.SortOrder = Enum.SortOrder.LayoutOrder
	v1_202.Parent = v1_199
	local v1_203 = Instance.new("TextLabel")
	v1_203.Name = "Title"
	v1_203.Size = UDim2.new(0, 0, 1, 0)
	v1_203.AutomaticSize = Enum.AutomaticSize.X
	v1_203.BackgroundTransparency = 1
	v1_203.BorderSizePixel = 0
	v1_203.Text = v1_198
	v1_203.TextColor3 = v0_7.SubText
	v1_203.Font = Enum.Font.GothamBold
	v1_203.TextSize = 13
	v1_203.LayoutOrder = 1
	v1_203.Parent = v1_199
	local v1_204 = Instance.new("TextButton")
	v1_204.Name = "ToggleButton"
	v1_204.Size = UDim2.new(0, 22, 0, 22)
	v1_204.BackgroundColor3 = v0_7.Element
	v1_204.BorderSizePixel = 0
	v1_204.Text = ""
	v1_204.AutoButtonColor = false
	v1_204.LayoutOrder = 2
	v1_204.Parent = v1_199
	v0_61(v1_204, 6)
	local v1_205 = Instance.new("ImageLabel")
	v1_205.Name = "Icon"
	v1_205.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_205.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_205.Size = UDim2.new(0, 14, 0, 14)
	v1_205.BackgroundTransparency = 1
	v1_205.BorderSizePixel = 0
	v1_205.ImageColor3 = v0_7.IconOn
	v1_205.ScaleType = Enum.ScaleType.Fit
	v1_205.Parent = v1_204
	local v1_206 = Instance.new("TextLabel")
	v1_206.Name = "IconFallback"
	v1_206.Size = UDim2.new(1, 0, 1, 0)
	v1_206.BackgroundTransparency = 1
	v1_206.TextColor3 = v0_7.IconOn
	v1_206.Font = Enum.Font.GothamBold
	v1_206.TextSize = 12
	v1_206.Visible = false
	v1_206.Parent = v1_205
	local v1_207 = Instance.new("UIScale")
	v1_207.Parent = v1_204
	v1_204.MouseEnter:Connect(function() v0_10(v1_207, { Scale = 1.1 }, 0.12) end)
	v1_204.MouseLeave:Connect(function() v0_10(v1_207, { Scale = 1 }, 0.12) end)
	v1_204.InputBegan:Connect(function(v2_208)
		if v0_17(v2_208) then v0_10(v1_207, { Scale = 0.9 }, 0.08) end
	end)
	v1_204.InputEnded:Connect(function(v2_209)
		if v0_17(v2_209) then v0_10(v1_207, { Scale = 1.1 }, 0.15, Enum.EasingStyle.Back) end
	end)
	v1_204.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	local v1_210, v1_211, v1_212 = false, nil, nil
	v1_203.InputBegan:Connect(function(v2_213)
		if v0_17(v2_213) then
			v1_210 = true
			v1_211 = v2_213.Position
			v1_212 = v1_199.AbsolutePosition + Vector2.new(v1_199.AbsoluteSize.X / 2, 0)
			v2_213.Changed:Connect(function()
				if v2_213.UserInputState == Enum.UserInputState.End then v1_210 = false end
			end)
		end
	end)
	table.insert(self._connections, v0_4.InputChanged:Connect(function(v2_214)
		if not v1_210 then return end
		if v2_214.UserInputType ~= Enum.UserInputType.MouseMovement and v2_214.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local v2_215 = v2_214.Position - v1_211
		local v2_216 = self.ScreenGui.AbsoluteSize
		local v2_217 = v1_199.AbsoluteSize.X / 2
		local v2_218 = math.clamp(v1_212.X + v2_215.X, v2_217, math.max(v2_216.X - v2_217, v2_217))
		local v2_219 = math.clamp(v1_212.Y + v2_215.Y, 0, math.max(v2_216.Y - v1_199.AbsoluteSize.Y, 0))
		v1_199.Position = UDim2.fromOffset(v2_218, v2_219)
	end))
	self._wm = { Frame = v1_199, Button = v1_204, Icon = v1_205, Fallback = v1_206 }
	v0_10(v1_199, { Position = UDim2.new(0.5, 0, 0, 10) }, 0.5, Enum.EasingStyle.Back)
end
function v0_1:_updateWatermark()
	local v1_220 = self._wm
	if not v1_220 then return end
	local v1_221 = self._visible == true
	v0_10(v1_220.Button, { BackgroundColor3 = v1_221 and v0_7.Accent or v0_7.Element }, 0.2)
	local v1_222 = v0_42(v1_220.Icon, v1_221 and "eye" or "eye-off", self.Icons)
	if not v1_222 then v1_220.Icon.Image = "" end
	v1_220.Fallback.Visible = not v1_222
	v1_220.Fallback.Text = v1_221 and "●" or "○"
	v1_220.Icon.ImageTransparency = 1
	v0_10(v1_220.Icon, { ImageTransparency = 0 }, 0.2)
end
local function v0_223(v1_224, v1_225)
	v0_10(v1_224.Icon, { ImageColor3 = v1_225 }, 0.2)
	if v1_224.Fallback then
		v0_10(v1_224.Fallback, { TextColor3 = v1_225 }, 0.2)
	end
end
function v0_1:AddTab(v1_226)
	v1_226 = v1_226 or {}
	local v1_227 = Instance.new("TextButton")
	v1_227.Name = "TabButton"
	v1_227.Size = UDim2.new(0, 36, 0, 36)
	v1_227.BackgroundColor3 = v0_7.Card
	v1_227.BorderSizePixel = 0
	v1_227.Text = ""
	v1_227.AutoButtonColor = false
	v1_227.LayoutOrder = #self.Tabs + 1
	v1_227.Parent = self.Sidebar
	v0_61(v1_227, 6)
	local v1_228 = Instance.new("ImageLabel")
	v1_228.Name = "Icon"
	v1_228.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_228.Size = UDim2.new(0, 20, 0, 20)
	v1_228.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_228.BackgroundTransparency = 1
	v1_228.BorderSizePixel = 0
	v1_228.ImageColor3 = v0_7.IconOff
	v1_228.ScaleType = Enum.ScaleType.Fit
	v1_228.Parent = v1_227
	local v1_229
	if not v0_42(v1_228, v1_226.Icon, self.Icons) then
		v1_229 = Instance.new("TextLabel")
		v1_229.Name = "IconFallback"
		v1_229.Size = UDim2.new(1, 0, 1, 0)
		v1_229.BackgroundTransparency = 1
		v1_229.Text = string.upper(string.sub(tostring(v1_226.Name or v1_226.Icon or "?"), 1, 1))
		v1_229.TextColor3 = v0_7.IconOff
		v1_229.Font = Enum.Font.GothamBold
		v1_229.TextSize = 16
		v1_229.Parent = v1_228
	end
	local v1_230 = Instance.new("ScrollingFrame")
	v1_230.Name = "Page"
	v1_230.Size = UDim2.new(1, 0, 1, 0)
	v1_230.BackgroundTransparency = 1
	v1_230.BorderSizePixel = 0
	v1_230.ScrollBarThickness = 3
	v1_230.ScrollBarImageColor3 = v0_7.IconOff
	v1_230.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_230.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_230.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_230.Visible = false
	v1_230.Parent = self.Content
	local v1_231 = Instance.new("Frame")
	v1_231.Name = "Inner"
	v1_231.Size = UDim2.new(1, 0, 0, 0)
	v1_231.AutomaticSize = Enum.AutomaticSize.Y
	v1_231.BackgroundTransparency = 1
	v1_231.BorderSizePixel = 0
	v1_231.Parent = v1_230
	local v1_232 = Instance.new("UIPadding")
	v1_232.PaddingTop = UDim.new(0, 12)
	v1_232.PaddingBottom = UDim.new(0, 12)
	v1_232.Parent = v1_231
	local v1_233 = Instance.new("Frame")
	v1_233.Name = "Split"
	v1_233.Position = UDim2.new(0, 12, 0, 0)
	v1_233.Size = UDim2.new(1, -26, 0, 0)
	v1_233.AutomaticSize = Enum.AutomaticSize.Y
	v1_233.BackgroundTransparency = 1
	v1_233.BorderSizePixel = 0
	v1_233.Parent = v1_231
	local v1_234 = Instance.new("UIListLayout")
	v1_234.FillDirection = Enum.FillDirection.Horizontal
	v1_234.Padding = UDim.new(0, 8)
	v1_234.SortOrder = Enum.SortOrder.LayoutOrder
	v1_234.Parent = v1_233
	local function v1_235(v2_236)
		local v2_237 = Instance.new("Frame")
		v2_237.Name = v2_236 == 1 and "Left" or "Right"
		v2_237.Size = UDim2.new(0.5, -4, 0, 0)
		v2_237.AutomaticSize = Enum.AutomaticSize.Y
		v2_237.BackgroundTransparency = 1
		v2_237.BorderSizePixel = 0
		v2_237.LayoutOrder = v2_236
		v2_237.Parent = v1_233
		local v2_238 = Instance.new("UIListLayout")
		v2_238.Padding = UDim.new(0, 8)
		v2_238.SortOrder = Enum.SortOrder.LayoutOrder
		v2_238.Parent = v2_237
		return v2_237
	end
	local v1_239 = setmetatable({
		Page = v1_230,
		Button = v1_227,
		Icon = v1_228,
		Fallback = v1_229,
		Inner = v1_231,
		_icons = self.Icons,
		_lib = self,
		Left = v1_235(1),
		Right = v1_235(2),
		_sectionCount = 0,
	}, v0_2)
	table.insert(self.Tabs, v1_239)
	for v2_240, v2_241 in ipairs({ "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" }) do
		table.insert(self._connections, v1_230:GetPropertyChangedSignal(v2_241):Connect(function()
			if self.ActiveTab == v1_239 then self:_updateScrollHint() end
		end))
	end
	v0_19(v1_227, v0_7.Card, v0_7.Element, function()
		return self.ActiveTab == v1_239
	end)
	v1_227.MouseButton1Click:Connect(function()
		self:SelectTab(v1_239)
	end)
	if not self.ActiveTab then self:SelectTab(v1_239) end
	return v1_239
end
function v0_1:SelectTab(v1_242)
	if self.ActiveTab == v1_242 then return end
	local v1_243 = self.ActiveTab
	self.ActiveTab = v1_242
	if v1_243 then
		v1_243.Page.Visible = false
		v0_10(v1_243.Button, { BackgroundColor3 = v0_7.Card }, 0.2)
		v0_223(v1_243, v0_7.IconOff)
	end
	v1_242.Inner.Position = UDim2.new(0, 0, 0, 14)
	v1_242.Page.Visible = true
	v0_10(v1_242.Inner, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)
	v0_10(v1_242.Button, { BackgroundColor3 = v0_7.Accent }, 0.2)
	v0_223(v1_242, v0_7.IconOn)
	self:_updateScrollHint()
end
function v0_2:AddSection(v1_244, v1_245, v1_246)
	local v1_247 = (v1_245 == "right") and self.Right or self.Left
	local v1_248 = self._lib
	self._sectionCount += 1
	local v1_249 = Instance.new("Frame")
	v1_249.Name = "Section"
	v1_249.Size = UDim2.new(1, 0, 0, 0)
	v1_249.AutomaticSize = Enum.AutomaticSize.Y
	v1_249.BackgroundColor3 = v0_7.Card
	v1_249.BorderSizePixel = 0
	v1_249.LayoutOrder = self._sectionCount
	v1_249.Parent = v1_247
	v0_61(v1_249, 6)
	local v1_250 = Instance.new("UIPadding")
	v1_250.PaddingTop = UDim.new(0, 8)
	v1_250.PaddingBottom = UDim.new(0, 8)
	v1_250.PaddingLeft = UDim.new(0, 8)
	v1_250.PaddingRight = UDim.new(0, 8)
	v1_250.Parent = v1_249
	local v1_251 = Instance.new("UIListLayout")
	v1_251.Padding = UDim.new(0, 6)
	v1_251.SortOrder = Enum.SortOrder.LayoutOrder
	v1_251.Parent = v1_249
	local v1_252 = Instance.new("Frame")
	v1_252.Name = "Body"
	v1_252.Size = UDim2.new(1, 0, 0, 0)
	v1_252.AutomaticSize = Enum.AutomaticSize.Y
	v1_252.BackgroundTransparency = 1
	v1_252.BorderSizePixel = 0
	v1_252.LayoutOrder = 1
	v1_252.Parent = v1_249
	local v1_253 = Instance.new("UIListLayout")
	v1_253.Padding = UDim.new(0, 6)
	v1_253.SortOrder = Enum.SortOrder.LayoutOrder
	v1_253.Parent = v1_252
	local v1_254 = false
	local v1_255 = {}
	local v1_256, v1_257
	local function v1_258()
		local v2_259 = v1_248._scale and v1_248._scale.Scale or 1
		return math.max(v1_253.AbsoluteContentSize.Y / (v2_259 > 0 and v2_259 or 1), 0)
	end
	local function v1_260()
		v1_252.AutomaticSize = Enum.AutomaticSize.Y
		v1_252.Size = UDim2.new(1, 0, 0, 0)
		v1_252.ClipsDescendants = false
	end
	local function v1_261(v2_262, v2_263)
		if v2_262 == v1_254 and not v2_263 then return end
		v1_254 = v2_262
		for v3_264, v3_265 in ipairs(v1_255) do v3_265:Cancel() end
		v1_255 = {}
		if v1_256 then
			if v2_263 then
				v1_256.Rotation = v2_262 and -90 or 0
			else
				v0_10(v1_256, { Rotation = v2_262 and -90 or 0 }, 0.22, Enum.EasingStyle.Quint)
			end
		end
		if v2_263 then
			v1_252.Visible = not v2_262
			v1_251.Padding = UDim.new(0, v2_262 and 0 or 6)
			v1_260()
			return
		end
		v1_252.ClipsDescendants = true
		if v2_262 then
			if v1_252.AutomaticSize ~= Enum.AutomaticSize.None then
				local v4_266 = v1_258()
				v1_252.AutomaticSize = Enum.AutomaticSize.None
				v1_252.Size = UDim2.new(1, 0, 0, v4_266)
			end
			local v3_267 = v0_10(v1_252, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Quint)
			v1_255 = { v3_267, v0_10(v1_251, { Padding = UDim.new(0, 0) }, 0.25, Enum.EasingStyle.Quint) }
			v3_267.Completed:Connect(function(v4_268)
				if v4_268 == Enum.PlaybackState.Completed and v1_254 then
					v1_252.Visible = false
					v1_252.ClipsDescendants = false
				end
			end)
		else
			v1_252.Visible = true
			local v3_269 = v1_258()
			if v3_269 <= 0 then
				v1_251.Padding = UDim.new(0, 6)
				v1_260()
				return
			end
			if v1_252.AutomaticSize ~= Enum.AutomaticSize.None then
				v1_252.AutomaticSize = Enum.AutomaticSize.None
				v1_252.Size = UDim2.new(1, 0, 0, 0)
			end
			local v3_270 = v0_10(v1_252, { Size = UDim2.new(1, 0, 0, v3_269) }, 0.28, Enum.EasingStyle.Quint)
			v1_255 = { v3_270, v0_10(v1_251, { Padding = UDim.new(0, 6) }, 0.28, Enum.EasingStyle.Quint) }
			v3_270.Completed:Connect(function(v4_271)
				if v4_271 == Enum.PlaybackState.Completed and not v1_254 then
					v1_260()
				end
			end)
		end
	end
	if v1_244 then
		local v2_272 = Instance.new("TextButton")
		v2_272.Name = "Header"
		v2_272.Size = UDim2.new(1, 0, 0, 16)
		v2_272.BackgroundTransparency = 1
		v2_272.BorderSizePixel = 0
		v2_272.Text = ""
		v2_272.AutoButtonColor = false
		v2_272.LayoutOrder = 0
		v2_272.Parent = v1_249
		local v2_273 = Instance.new("TextLabel")
		v2_273.Name = "Title"
		v2_273.Size = UDim2.new(1, -22, 1, 0)
		v2_273.BackgroundTransparency = 1
		v2_273.BorderSizePixel = 0
		v2_273.Text = v1_244
		v2_273.TextColor3 = v0_7.SubText
		v2_273.Font = Enum.Font.GothamBold
		v2_273.TextSize = 13
		v2_273.TextXAlignment = Enum.TextXAlignment.Left
		v2_273.TextTruncate = Enum.TextTruncate.AtEnd
		v2_273.Parent = v2_272
		v1_256 = Instance.new("ImageLabel")
		v1_256.Name = "Chevron"
		v1_256.AnchorPoint = Vector2.new(1, 0.5)
		v1_256.Position = UDim2.new(1, 0, 0.5, 0)
		v1_256.Size = UDim2.new(0, 14, 0, 14)
		v1_256.BackgroundTransparency = 1
		v1_256.BorderSizePixel = 0
		v1_256.ImageColor3 = v0_7.SubText
		v1_256.ScaleType = Enum.ScaleType.Fit
		v1_256.Parent = v2_272
		v1_257 = Instance.new("TextLabel")
		v1_257.Name = "ChevronFallback"
		v1_257.Size = UDim2.new(1, 0, 1, 0)
		v1_257.BackgroundTransparency = 1
		v1_257.Text = "▼"
		v1_257.TextColor3 = v0_7.SubText
		v1_257.Font = Enum.Font.Gotham
		v1_257.TextSize = 9
		v1_257.Parent = v1_256
		v1_257.Visible = not v0_42(v1_256, "chevron-down", self._icons)
		v2_272.MouseEnter:Connect(function()
			v0_10(v2_273, { TextColor3 = v0_7.Text }, 0.12)
			v0_10(v1_256, { ImageColor3 = v0_7.Text }, 0.12)
			v0_10(v1_257, { TextColor3 = v0_7.Text }, 0.12)
		end)
		v2_272.MouseLeave:Connect(function()
			v0_10(v2_273, { TextColor3 = v0_7.SubText }, 0.15)
			v0_10(v1_256, { ImageColor3 = v0_7.SubText }, 0.15)
			v0_10(v1_257, { TextColor3 = v0_7.SubText }, 0.15)
		end)
		v2_272.MouseButton1Click:Connect(function()
			v1_261(not v1_254)
		end)
	end
	local v1_274 = setmetatable({
		Holder = v1_252,
		Card = v1_249,
		_count = 0,
		_icons = self._icons,
		_lib = self._lib,
		_setCollapsed = v1_261,
		_isCollapsed = function() return v1_254 end,
	}, v0_3)
	if v1_244 and v1_246 == true then
		v1_261(true, true)
	end
	return v1_274
end
function v0_3:SetCollapsed(v1_275)
	self._setCollapsed(v1_275 == true)
end
function v0_3:ToggleCollapsed()
	self._setCollapsed(not self._isCollapsed())
end
function v0_3:IsCollapsed()
	return self._isCollapsed()
end
local function v0_276(v1_277)
	if typeof(v1_277) == "EnumItem" and v1_277.EnumType == Enum.KeyCode then return v1_277 end
	if type(v1_277) == "string" then
		local v2_278, v2_279 = pcall(function() return Enum.KeyCode[v1_277] end)
		if v2_278 then return v2_279 end
	end
	return nil
end
local function v0_280(v1_281, v1_282, v1_283, v1_284, v1_285)
	v1_283 = v1_283 or {}
	local v1_286 = v1_283.CanBeChanged ~= false
	local v1_287 = {}
	local v1_288 = { _key = nil, _onPress = v1_285, _isListening = false, _destroyed = false }
	local v1_289 = Instance.new("TextButton")
	v1_289.Name = "Keybind"
	v1_289.AnchorPoint = Vector2.new(1, 0.5)
	v1_289.Position = v1_284
	v1_289.Size = UDim2.new(0, 0, 0, 20)
	v1_289.AutomaticSize = Enum.AutomaticSize.X
	v1_289.BackgroundColor3 = v0_7.Card
	v1_289.BorderSizePixel = 0
	v1_289.Text = "None"
	v1_289.TextColor3 = v0_7.SubText
	v1_289.Font = Enum.Font.Gotham
	v1_289.TextSize = 12
	v1_289.TextTruncate = Enum.TextTruncate.AtEnd
	v1_289.AutoButtonColor = false
	v1_289.Parent = v1_282
	v0_61(v1_289, 5)
	v1_288.Instance = v1_289
	local v1_290 = Instance.new("UIPadding")
	v1_290.PaddingLeft = UDim.new(0, 7)
	v1_290.PaddingRight = UDim.new(0, 7)
	v1_290.Parent = v1_289
	local v1_291 = Instance.new("UISizeConstraint")
	v1_291.MinSize = Vector2.new(30, 20)
	v1_291.MaxSize = Vector2.new(96, 20)
	v1_291.Parent = v1_289
	local function v1_292()
		if v1_288._isListening then
			v1_289.Text = "..."
		else
			v1_289.Text = v1_288._key and v1_288._key.Name or "None"
		end
	end
	local function v1_293()
		v1_289.BackgroundColor3 = v0_7.Danger
		v0_10(v1_289, { BackgroundColor3 = v0_7.Card }, 0.45)
	end
	function v1_288:Set(v2_294, v2_295)
		v2_294 = v0_276(v2_294)
		if v2_294 and v1_281:_keyTaken(v2_294, v1_288) then
			warn("[RobloxUI] key already in use:", v2_294.Name)
			v1_293()
			return false
		end
		v1_288._key = v2_294
		v1_292()
		if not v2_295 and v1_283.Callback then v1_283.Callback(v2_294) end
		return true
	end
	function v1_288:Get()
		return v1_288._key
	end
	function v1_288:_startListening()
		if v1_281._listening and v1_281._listening ~= v1_288 then
			v1_281._listening:_stopListening()
		end
		v1_281._listening = v1_288
		v1_288._isListening = true
		v0_10(v1_289, { BackgroundColor3 = v0_7.Accent }, 0.15)
		v1_292()
	end
	function v1_288:_stopListening()
		if v1_281._listening == v1_288 then v1_281._listening = nil end
		v1_288._isListening = false
		v0_10(v1_289, { BackgroundColor3 = v0_7.Card }, 0.15)
		v1_292()
	end
	function v1_288:_capture(v2_296)
		if v2_296 == Enum.KeyCode.Unknown then return end
		v1_288:_stopListening()
		if v2_296 == Enum.KeyCode.Escape then return end
		if v2_296 == Enum.KeyCode.Backspace or v2_296 == Enum.KeyCode.Delete then
			v1_288:Set(nil)
		else
			v1_288:Set(v2_296)
		end
	end
	function v1_288:Destroy()
		if v1_288._destroyed then return end
		v1_288._destroyed = true
		if v1_281._listening == v1_288 then v1_281._listening = nil end
		local v2_297 = table.find(v1_281._binds, v1_288)
		if v2_297 then table.remove(v1_281._binds, v2_297) end
		v1_281._cleanups[v1_288] = nil
		for v3_298, v3_299 in ipairs(v1_287) do v3_299:Disconnect() end
		v1_287 = {}
		v1_289:Destroy()
	end
	if v1_286 then
		v0_19(v1_289, v0_7.Card, v0_7.Sidebar, function() return v1_288._isListening end)
		table.insert(v1_287, v1_289.MouseButton1Click:Connect(function()
			if v1_288._isListening then v1_288:_stopListening() else v1_288:_startListening() end
		end))
		table.insert(v1_287, v1_289.MouseButton2Click:Connect(function()
			if v1_288._isListening then v1_288:_stopListening() end
			v1_288:Set(nil)
		end))
	end
	if v1_283.Key ~= nil then
		v1_288:Set(v1_283.Key, true)
	end
	table.insert(v1_281._binds, v1_288)
	v1_281._cleanups[v1_288] = function() v1_288:Destroy() end
	return v1_288
end
local function v0_300(v1_301, v1_302, v1_303)
	local v1_304 = v1_302.Instance
	local function v1_305()
		local v2_306 = math.clamp(v1_304.TextBounds.X + 14, 30, 96)
		v1_301.Size = UDim2.new(1, -(v1_303 + v2_306 + 6), 1, 0)
	end
	v1_305()
	v1_304:GetPropertyChangedSignal("TextBounds"):Connect(v1_305)
end
function v0_3:AddButton(v1_307)
	v1_307 = v1_307 or {}
	self._count += 1
	local v1_308 = Instance.new("TextButton")
	v1_308.Name = "Button"
	v1_308.Size = UDim2.new(1, 0, 0, 32)
	v1_308.BackgroundColor3 = v0_7.Element
	v1_308.BorderSizePixel = 0
	v1_308.Text = v1_307.Name or "Button"
	v1_308.TextColor3 = v0_7.Text
	v1_308.Font = Enum.Font.Gotham
	v1_308.TextSize = 14
	v1_308.TextTruncate = Enum.TextTruncate.AtEnd
	v1_308.AutoButtonColor = false
	v1_308.LayoutOrder = self._count
	v1_308.Parent = self.Holder
	v0_61(v1_308, 6)
	local v1_309 = Instance.new("UIPadding")
	v1_309.PaddingLeft = UDim.new(0, 8)
	v1_309.PaddingRight = UDim.new(0, 8)
	v1_309.Parent = v1_308
	v0_19(v1_308, v0_7.Element, v0_7.Hover)
	v1_308.MouseButton1Click:Connect(function()
		v1_308.BackgroundColor3 = v0_7.Accent
		v0_10(v1_308, { BackgroundColor3 = v0_7.Hover }, 0.3)
		if v1_307.Callback then v1_307.Callback() end
	end)
	return v1_308
end
function v0_3:AddToggle(v1_310)
	v1_310 = v1_310 or {}
	self._count += 1
	local v1_311 = v1_310.Default == true
	local v1_312 = self
	local v1_313 = Instance.new("TextButton")
	v1_313.Name = "Toggle"
	v1_313.Size = UDim2.new(1, 0, 0, 32)
	v1_313.BackgroundColor3 = v0_7.Element
	v1_313.BorderSizePixel = 0
	v1_313.Text = ""
	v1_313.AutoButtonColor = false
	v1_313.LayoutOrder = self._count
	v1_313.Parent = self.Holder
	v0_61(v1_313, 6)
	v0_19(v1_313, v0_7.Element, v0_7.Hover)
	local v1_314 = Instance.new("TextLabel")
	v1_314.Name = "Label"
	v1_314.Position = UDim2.new(0, 8, 0, 0)
	v1_314.Size = UDim2.new(1, -60, 1, 0)
	v1_314.BackgroundTransparency = 1
	v1_314.BorderSizePixel = 0
	v1_314.Text = v1_310.Name or "Toggle"
	v1_314.TextColor3 = v0_7.Text
	v1_314.Font = Enum.Font.Gotham
	v1_314.TextSize = 14
	v1_314.TextXAlignment = Enum.TextXAlignment.Left
	v1_314.TextTruncate = Enum.TextTruncate.AtEnd
	v1_314.Parent = v1_313
	local v1_315 = Instance.new("Frame")
	v1_315.Name = "Track"
	v1_315.AnchorPoint = Vector2.new(1, 0.5)
	v1_315.Position = UDim2.new(1, -8, 0.5, 0)
	v1_315.Size = UDim2.new(0, 34, 0, 18)
	v1_315.BackgroundColor3 = v0_7.Off
	v1_315.BorderSizePixel = 0
	v1_315.Parent = v1_313
	v0_61(v1_315, 9)
	local v1_316 = Instance.new("Frame")
	v1_316.Name = "Knob"
	v1_316.AnchorPoint = Vector2.new(0, 0.5)
	v1_316.Position = UDim2.new(0, 2, 0.5, 0)
	v1_316.Size = UDim2.new(0, 14, 0, 14)
	v1_316.BackgroundColor3 = v0_7.Text
	v1_316.BorderSizePixel = 0
	v1_316.Parent = v1_315
	v0_61(v1_316, 7)
	local function v1_317(v2_318)
		local v2_319 = TweenInfo.new(v2_318 and 0.15 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		v0_5:Create(v1_315, v2_319, { BackgroundColor3 = v1_311 and v0_7.Accent or v0_7.Off }):Play()
		v0_5:Create(v1_316, v2_319, {
			Position = v1_311 and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}):Play()
	end
	v1_317(false)
	local v1_320 = { Instance = v1_313 }
	function v1_320:Set(v2_321, v2_322)
		v1_311 = v2_321 and true or false
		v1_317(true)
		if not v2_322 and v1_310.Callback then v1_310.Callback(v1_311) end
	end
	function v1_320:Get()
		return v1_311
	end
	v1_313.MouseButton1Click:Connect(function()
		v1_320:Set(not v1_311)
	end)
	function v1_320:AddKeybind(v2_323)
		if v1_320.Keybind then
			warn("[RobloxUI] this toggle already has a keybind")
			return v1_320.Keybind
		end
		local v2_324 = v0_280(v1_312._lib, v1_313, v2_323, UDim2.new(1, -48, 0.5, 0), function()
			v1_320:Set(not v1_311)
		end)
		v0_300(v1_314, v2_324, 60)
		local v2_325 = v2_324.Destroy
		function v2_324:Destroy()
			v2_325(v2_324)
			v1_320.Keybind = nil
			v1_314.Size = UDim2.new(1, -60, 1, 0)
		end
		v1_320.Keybind = v2_324
		return v2_324
	end
	function v1_320:Destroy()
		if v1_320._destroyed then return end
		v1_320._destroyed = true
		if v1_320.Keybind then v1_320.Keybind:Destroy() end
		v1_313:Destroy()
	end
	return v1_320
end
function v0_3:AddParagraph(v1_326)
	v1_326 = v1_326 or {}
	self._count += 1
	local v1_327 = v1_326.Title and tostring(v1_326.Title) or ""
	local v1_328 = v1_326.Content and tostring(v1_326.Content) or ""
	local v1_329 = Instance.new("Frame")
	v1_329.Name = "Paragraph"
	v1_329.Size = UDim2.new(1, 0, 0, 0)
	v1_329.AutomaticSize = Enum.AutomaticSize.Y
	v1_329.BackgroundColor3 = v0_7.Element
	v1_329.BorderSizePixel = 0
	v1_329.LayoutOrder = self._count
	v1_329.Parent = self.Holder
	v0_61(v1_329, 6)
	local v1_330 = Instance.new("UIPadding")
	v1_330.PaddingTop = UDim.new(0, 8)
	v1_330.PaddingBottom = UDim.new(0, 8)
	v1_330.PaddingLeft = UDim.new(0, 8)
	v1_330.PaddingRight = UDim.new(0, 8)
	v1_330.Parent = v1_329
	local v1_331 = Instance.new("UIListLayout")
	v1_331.Padding = UDim.new(0, 3)
	v1_331.SortOrder = Enum.SortOrder.LayoutOrder
	v1_331.Parent = v1_329
	local function v1_332(v2_333, v2_334, v2_335, v2_336, v2_337)
		local v2_338 = Instance.new("TextLabel")
		v2_338.Name = v2_333
		v2_338.Size = UDim2.new(1, 0, 0, 0)
		v2_338.AutomaticSize = Enum.AutomaticSize.Y
		v2_338.BackgroundTransparency = 1
		v2_338.BorderSizePixel = 0
		v2_338.TextColor3 = v2_336
		v2_338.Font = v2_334
		v2_338.TextSize = v2_335
		v2_338.TextWrapped = true
		v2_338.RichText = v1_326.RichText == true
		v2_338.TextXAlignment = Enum.TextXAlignment.Left
		v2_338.TextYAlignment = Enum.TextYAlignment.Top
		v2_338.LayoutOrder = v2_337
		v2_338.Parent = v1_329
		return v2_338
	end
	local v1_339 = v1_332("Title", Enum.Font.GothamBold, 14, v0_7.Text, 1)
	local v1_340 = v1_332("Content", Enum.Font.Gotham, 13, v0_7.SubText, 2)
	local function v1_341(v2_342)
		v1_339.Text = v1_327
		v1_339.Visible = v1_327 ~= ""
		v1_340.Text = v1_328
		v1_340.Visible = v1_328 ~= ""
		if v2_342 then
			v1_339.TextTransparency = 1
			v1_340.TextTransparency = 1
			v0_10(v1_339, { TextTransparency = 0 }, 0.2)
			v0_10(v1_340, { TextTransparency = 0 }, 0.2)
		end
	end
	v1_341(false)
	local v1_343 = { Instance = v1_329 }
	function v1_343:SetTitle(v2_344)
		v1_327 = v2_344 and tostring(v2_344) or ""
		v1_341(true)
	end
	function v1_343:SetContent(v2_345)
		v1_328 = v2_345 and tostring(v2_345) or ""
		v1_341(true)
	end
	function v1_343:Set(v2_346)
		v2_346 = v2_346 or {}
		if v2_346.Title ~= nil then v1_327 = tostring(v2_346.Title) end
		if v2_346.Content ~= nil then v1_328 = tostring(v2_346.Content) end
		v1_341(true)
	end
	function v1_343:Get()
		return v1_327, v1_328
	end
	function v1_343:Destroy()
		v1_329:Destroy()
	end
	return v1_343
end
function v0_3:AddTextbox(v1_347)
	v1_347 = v1_347 or {}
	self._count += 1
	local v1_348 = v1_347.Numeric == true
	local v1_349 = tonumber(v1_347.MaxLength)
	local v1_350 = v1_347.Name ~= nil and v1_347.Name ~= ""
	local v1_351, v1_352, v1_353 = false, false, false
	local function v1_354(v2_355)
		if v1_347.Min then v2_355 = math.max(v2_355, v1_347.Min) end
		if v1_347.Max then v2_355 = math.min(v2_355, v1_347.Max) end
		return v2_355
	end
	local v1_356
	if v1_348 then
		v1_356 = tonumber(v1_347.Default)
		if v1_356 then v1_356 = v1_354(v1_356) end
	else
		v1_356 = tostring(v1_347.Default or "")
	end
	local function v1_357(v2_358)
		return v2_358 == nil and "" or tostring(v2_358)
	end
	local function v1_359(v2_360)
		local v2_361 = v2_360:sub(1, 1) == "-"
		v2_360 = v2_360:gsub("[^%d%.]", "")
		local v2_362 = v2_360:find(".", 1, true)
		if v2_362 then
			local v3_363 = v2_360:sub(v2_362 + 1):gsub("%.", "")
			v2_360 = v2_360:sub(1, v2_362) .. v3_363
		end
		return (v2_361 and "-" or "") .. v2_360
	end
	local v1_364 = Instance.new("Frame")
	v1_364.Name = "Textbox"
	v1_364.Size = UDim2.new(1, 0, 0, 32)
	v1_364.BackgroundColor3 = v0_7.Element
	v1_364.BorderSizePixel = 0
	v1_364.LayoutOrder = self._count
	v1_364.Parent = self.Holder
	v0_61(v1_364, 6)
	if v1_350 then
		local v2_365 = Instance.new("TextLabel")
		v2_365.Name = "Label"
		v2_365.Position = UDim2.new(0, 8, 0, 0)
		v2_365.Size = UDim2.new(0.4, -8, 1, 0)
		v2_365.BackgroundTransparency = 1
		v2_365.BorderSizePixel = 0
		v2_365.Text = v1_347.Name
		v2_365.TextColor3 = v0_7.Text
		v2_365.Font = Enum.Font.Gotham
		v2_365.TextSize = 14
		v2_365.TextXAlignment = Enum.TextXAlignment.Left
		v2_365.TextTruncate = Enum.TextTruncate.AtEnd
		v2_365.Parent = v1_364
	end
	local v1_366 = Instance.new("Frame")
	v1_366.Name = "BoxHolder"
	v1_366.AnchorPoint = Vector2.new(1, 0.5)
	v1_366.Position = UDim2.new(1, -6, 0.5, 0)
	v1_366.Size = v1_350 and UDim2.new(0.6, -10, 0, 22) or UDim2.new(1, -12, 0, 22)
	v1_366.BackgroundColor3 = v0_7.Card
	v1_366.BorderSizePixel = 0
	v1_366.Parent = v1_364
	v0_61(v1_366, 5)
	local v1_367 = Instance.new("UIStroke")
	v1_367.Color = v0_7.Accent
	v1_367.Thickness = 1
	v1_367.Transparency = 1
	v1_367.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_367.Parent = v1_366
	local v1_368 = Instance.new("TextBox")
	v1_368.Name = "Input"
	v1_368.Size = UDim2.new(1, 0, 1, 0)
	v1_368.BackgroundTransparency = 1
	v1_368.BorderSizePixel = 0
	v1_368.Text = v1_357(v1_356)
	v1_368.PlaceholderText = v1_347.Placeholder or ""
	v1_368.PlaceholderColor3 = v0_7.IconOff
	v1_368.TextColor3 = v0_7.Text
	v1_368.Font = Enum.Font.Gotham
	v1_368.TextSize = 13
	v1_368.TextXAlignment = Enum.TextXAlignment.Left
	v1_368.ClearTextOnFocus = v1_347.ClearTextOnFocus == true
	v1_368.ClipsDescendants = true
	v1_368.Parent = v1_366
	local v1_369 = Instance.new("UIPadding")
	v1_369.PaddingLeft = UDim.new(0, 6)
	v1_369.PaddingRight = UDim.new(0, 6)
	v1_369.Parent = v1_368
	local function v1_370()
		v0_10(v1_366, { BackgroundColor3 = (v1_352 and not v1_351) and v0_7.Sidebar or v0_7.Card }, 0.12)
		v0_10(v1_367, { Transparency = v1_351 and 0 or 1 }, 0.15)
	end
	v1_368:GetPropertyChangedSignal("Text"):Connect(function()
		if v1_353 then return end
		local v2_371 = v1_368.Text
		if v1_348 then v2_371 = v1_359(v2_371) end
		if v1_349 and #v2_371 > v1_349 then v2_371 = v2_371:sub(1, v1_349) end
		if v2_371 ~= v1_368.Text then
			v1_353 = true
			v1_368.Text = v2_371
			v1_353 = false
		end
	end)
	v1_368.Focused:Connect(function()
		v1_351 = true
		v1_370()
	end)
	v1_368.FocusLost:Connect(function(v2_372)
		v1_351 = false
		v1_370()
		if v1_348 then
			local v3_373 = tonumber(v1_368.Text)
			if v3_373 == nil then
				v1_368.Text = v1_357(v1_356)
				return
			end
			v3_373 = v1_354(v3_373)
			v1_356 = v3_373
			v1_368.Text = v1_357(v3_373)
		else
			v1_356 = v1_368.Text
		end
		if v1_347.Callback then v1_347.Callback(v1_356, v2_372) end
	end)
	v1_366.MouseEnter:Connect(function()
		v1_352 = true
		v1_370()
	end)
	v1_366.MouseLeave:Connect(function()
		v1_352 = false
		v1_370()
	end)
	local v1_374 = { Instance = v1_364 }
	function v1_374:Set(v2_375, v2_376)
		if v1_348 then
			local v3_377 = tonumber(v2_375)
			if v3_377 == nil then return end
			v1_356 = v1_354(v3_377)
		else
			v1_356 = tostring(v2_375 == nil and "" or v2_375)
			if v1_349 then v1_356 = v1_356:sub(1, v1_349) end
		end
		v1_368.Text = v1_357(v1_356)
		if not v2_376 and v1_347.Callback then v1_347.Callback(v1_356, false) end
	end
	function v1_374:Get()
		return v1_356
	end
	function v1_374:Focus()
		v1_368:CaptureFocus()
	end
	function v1_374:Destroy()
		if v1_368:IsFocused() then v1_368:ReleaseFocus() end
		v1_364:Destroy()
	end
	return v1_374
end
function v0_3:AddKeybind(v1_378)
	v1_378 = v1_378 or {}
	self._count += 1
	local v1_379 = Instance.new("Frame")
	v1_379.Name = "KeybindRow"
	v1_379.Size = UDim2.new(1, 0, 0, 32)
	v1_379.BackgroundColor3 = v0_7.Element
	v1_379.BorderSizePixel = 0
	v1_379.LayoutOrder = self._count
	v1_379.Parent = self.Holder
	v0_61(v1_379, 6)
	local v1_380 = Instance.new("TextLabel")
	v1_380.Name = "Label"
	v1_380.Position = UDim2.new(0, 8, 0, 0)
	v1_380.Size = UDim2.new(1, -60, 1, 0)
	v1_380.BackgroundTransparency = 1
	v1_380.BorderSizePixel = 0
	v1_380.Text = v1_378.Name or "Keybind"
	v1_380.TextColor3 = v0_7.Text
	v1_380.Font = Enum.Font.Gotham
	v1_380.TextSize = 14
	v1_380.TextXAlignment = Enum.TextXAlignment.Left
	v1_380.TextTruncate = Enum.TextTruncate.AtEnd
	v1_380.Parent = v1_379
	local v1_381 = v0_280(self._lib, v1_379, v1_378, UDim2.new(1, -8, 0.5, 0), function()
		if v1_378.OnPress then v1_378.OnPress() end
	end)
	v0_300(v1_380, v1_381, 16)
	v1_381.Row = v1_379
	local v1_382 = v1_381.Destroy
	function v1_381:Destroy()
		v1_382(v1_381)
		v1_379:Destroy()
	end
	return v1_381
end
function v0_3:AddSlider(v1_383)
	v1_383 = v1_383 or {}
	self._count += 1
	local v1_384 = self._lib
	local function v1_385(v2_386)
		return #(tostring(v2_386):match("%.(%d+)") or "")
	end
	local v1_387 = tonumber(v1_383.Min) or 0
	local v1_388 = tonumber(v1_383.Max) or 100
	if v1_388 < v1_387 then v1_387, v1_388 = v1_388, v1_387 end
	local v1_389 = tonumber(v1_383.Increment) or 1
	if v1_389 <= 0 then v1_389 = 1 end
	local v1_390 = math.max(v1_385(v1_389), v1_385(v1_387))
	local v1_391 = v1_383.ValueName
	local function v1_392(v2_393)
		v2_393 = math.clamp(v2_393, v1_387, v1_388)
		v2_393 = v1_387 + math.floor((v2_393 - v1_387) / v1_389 + 0.5) * v1_389
		v2_393 = math.clamp(v2_393, v1_387, v1_388)
		local v2_394 = 10 ^ v1_390
		return math.floor(v2_393 * v2_394 + 0.5) / v2_394
	end
	local function v1_395(v2_396)
		return v1_388 > v1_387 and (v2_396 - v1_387) / (v1_388 - v1_387) or 0
	end
	local function v1_397(v2_398)
		local v2_399 = v1_390 > 0 and string.format("%." .. v1_390 .. "f", v2_398) or tostring(v2_398)
		if v1_391 and v1_391 ~= "" then v2_399 = v2_399 .. " " .. tostring(v1_391) end
		return v2_399
	end
	local v1_400 = v1_392(tonumber(v1_383.Default) or v1_387)
	local v1_401, v1_402 = false, false
	local v1_403 = nil
	local v1_404 = Instance.new("Frame")
	v1_404.Name = "Slider"
	v1_404.Size = UDim2.new(1, 0, 0, 46)
	v1_404.BackgroundColor3 = v0_7.Element
	v1_404.BorderSizePixel = 0
	v1_404.LayoutOrder = self._count
	v1_404.Parent = self.Holder
	v0_61(v1_404, 6)
	local v1_405 = Instance.new("TextLabel")
	v1_405.Name = "Name"
	v1_405.Position = UDim2.new(0, 8, 0, 6)
	v1_405.Size = UDim2.new(0.6, -8, 0, 16)
	v1_405.BackgroundTransparency = 1
	v1_405.BorderSizePixel = 0
	v1_405.Text = v1_383.Name or "Slider"
	v1_405.TextColor3 = v0_7.Text
	v1_405.Font = Enum.Font.Gotham
	v1_405.TextSize = 14
	v1_405.TextXAlignment = Enum.TextXAlignment.Left
	v1_405.TextTruncate = Enum.TextTruncate.AtEnd
	v1_405.Parent = v1_404
	local v1_406 = Instance.new("TextLabel")
	v1_406.Name = "Value"
	v1_406.Position = UDim2.new(0.6, 0, 0, 6)
	v1_406.Size = UDim2.new(0.4, -8, 0, 16)
	v1_406.BackgroundTransparency = 1
	v1_406.BorderSizePixel = 0
	v1_406.Text = v1_397(v1_400)
	v1_406.TextColor3 = v0_7.SubText
	v1_406.Font = Enum.Font.GothamBold
	v1_406.TextSize = 13
	v1_406.TextXAlignment = Enum.TextXAlignment.Right
	v1_406.TextTruncate = Enum.TextTruncate.AtEnd
	v1_406.Parent = v1_404
	local v1_407 = Instance.new("Frame")
	v1_407.Name = "Track"
	v1_407.Position = UDim2.new(0, 8, 0, 31)
	v1_407.Size = UDim2.new(1, -16, 0, 6)
	v1_407.BackgroundColor3 = v0_7.Off
	v1_407.BorderSizePixel = 0
	v1_407.Parent = v1_404
	local v1_408 = Instance.new("Frame")
	v1_408.Name = "Fill"
	v1_408.Size = UDim2.new(v1_395(v1_400), 0, 1, 0)
	v1_408.BackgroundColor3 = v0_7.Accent
	v1_408.BorderSizePixel = 0
	v1_408.Parent = v1_407
	local v1_409 = v0_7.Accent
	local v1_410 = v0_7.Accent:Lerp(v0_7.Text, 0.25)
	local v1_411 = Instance.new("TextButton")
	v1_411.Name = "Hit"
	v1_411.Size = UDim2.new(1, 0, 1, 0)
	v1_411.BackgroundTransparency = 1
	v1_411.BorderSizePixel = 0
	v1_411.Text = ""
	v1_411.AutoButtonColor = false
	v1_411.Parent = v1_404
	local function v1_412()
		local v2_413 = v1_401 or v1_402
		v0_10(v1_404, { BackgroundColor3 = v2_413 and v0_7.Hover or v0_7.Element }, 0.12)
		v0_10(v1_408, { BackgroundColor3 = v2_413 and v1_410 or v1_409 }, 0.12)
	end
	local function v1_414(v2_415)
		local v2_416 = v1_395(v1_400)
		v0_10(v1_408, { Size = UDim2.new(v2_416, 0, 1, 0) }, v2_415)
		v1_406.Text = v1_397(v1_400)
	end
	local function v1_417(v2_418, v2_419, v2_420)
		v2_418 = v1_392(v2_418)
		local v2_421 = v2_418 ~= v1_400
		v1_400 = v2_418
		v1_414(v2_420)
		if v2_421 then
			v1_406.TextColor3 = v0_7.Text
			v0_10(v1_406, { TextColor3 = v0_7.SubText }, 0.3)
			if not v2_419 and v1_383.Callback then v1_383.Callback(v1_400) end
		end
	end
	local function v1_422(v2_423)
		local v2_424 = v1_407.AbsoluteSize.X
		if v2_424 <= 0 then return end
		v1_417(v1_387 + ((v2_423 - v1_407.AbsolutePosition.X) / v2_424) * (v1_388 - v1_387), false, 0.08)
	end
	local function v1_425()
		if v1_403 then
			for v4_426, v4_427 in ipairs(v1_403) do v4_427:Disconnect() end
			v1_403 = nil
		end
		if v1_402 then
			v1_402 = false
			v1_412()
		end
	end
	local function v1_428(v2_429)
		v1_425()
		v1_402 = true
		v1_412()
		v1_422(v2_429.Position.X)
		v1_403 = {
			v0_4.InputChanged:Connect(function(v3_430)
				if v3_430.UserInputType == Enum.UserInputType.MouseMovement or v3_430 == v2_429 then
					v1_422(v3_430.Position.X)
				end
			end),
			v0_4.InputEnded:Connect(function(v3_431)
				if v3_431 == v2_429 or v3_431.UserInputType == Enum.UserInputType.MouseButton1 then
					v1_425()
				end
			end),
		}
	end
	v1_411.InputBegan:Connect(function(v2_432)
		if v0_17(v2_432) then v1_428(v2_432) end
	end)
	v1_411.MouseEnter:Connect(function()
		v1_401 = true
		v1_412()
	end)
	v1_411.MouseLeave:Connect(function()
		v1_401 = false
		v1_412()
	end)
	local v1_433 = { Instance = v1_404 }
	function v1_433:Set(v2_434, v2_435)
		v1_417(tonumber(v2_434) or v1_400, v2_435, 0.2)
	end
	function v1_433:Get()
		return v1_400
	end
	function v1_433:Destroy()
		v1_425()
		v1_384._cleanups[v1_433] = nil
		v1_404:Destroy()
	end
	v1_384._cleanups[v1_433] = v1_425
	return v1_433
end
function v0_3:AddDropdown(v1_436)
	v1_436 = v1_436 or {}
	self._count += 1
	local v1_437 = v1_436.Options or {}
	local v1_438 = v1_436.Multi == true
	local v1_439 = 130
	local v1_440, v1_441 = 26, 4
	local v1_442 = nil
	local v1_443 = {}
	local v1_444 = {}
	local v1_445 = false
	local v1_446 = 0
	local v1_447 = nil
	local v1_448 = Instance.new("Frame")
	v1_448.Name = "Dropdown"
	v1_448.Size = UDim2.new(1, 0, 0, 32)
	v1_448.AutomaticSize = Enum.AutomaticSize.Y
	v1_448.BackgroundTransparency = 1
	v1_448.BorderSizePixel = 0
	v1_448.LayoutOrder = self._count
	v1_448.Parent = self.Holder
	local v1_449 = Instance.new("UIListLayout")
	v1_449.Padding = UDim.new(0, 4)
	v1_449.SortOrder = Enum.SortOrder.LayoutOrder
	v1_449.Parent = v1_448
	local v1_450 = Instance.new("TextButton")
	v1_450.Name = "Header"
	v1_450.Size = UDim2.new(1, 0, 0, 32)
	v1_450.BackgroundColor3 = v0_7.Element
	v1_450.BorderSizePixel = 0
	v1_450.Text = ""
	v1_450.AutoButtonColor = false
	v1_450.LayoutOrder = 1
	v1_450.Parent = v1_448
	v0_61(v1_450, 6)
	v0_19(v1_450, v0_7.Element, v0_7.Hover)
	local v1_451 = Instance.new("TextLabel")
	v1_451.Name = "Name"
	v1_451.Position = UDim2.new(0, 8, 0, 0)
	v1_451.Size = UDim2.new(0.5, -8, 1, 0)
	v1_451.BackgroundTransparency = 1
	v1_451.BorderSizePixel = 0
	v1_451.Text = v1_436.Name or "Dropdown"
	v1_451.TextColor3 = v0_7.Text
	v1_451.Font = Enum.Font.Gotham
	v1_451.TextSize = 14
	v1_451.TextXAlignment = Enum.TextXAlignment.Left
	v1_451.TextTruncate = Enum.TextTruncate.AtEnd
	v1_451.Parent = v1_450
	local v1_452 = Instance.new("TextLabel")
	v1_452.Name = "Value"
	v1_452.Position = UDim2.new(0.5, 0, 0, 0)
	v1_452.Size = UDim2.new(0.5, -28, 1, 0)
	v1_452.BackgroundTransparency = 1
	v1_452.BorderSizePixel = 0
	v1_452.Text = "None"
	v1_452.TextColor3 = v0_7.SubText
	v1_452.Font = Enum.Font.Gotham
	v1_452.TextSize = 13
	v1_452.TextXAlignment = Enum.TextXAlignment.Right
	v1_452.TextTruncate = Enum.TextTruncate.AtEnd
	v1_452.Parent = v1_450
	local v1_453 = Instance.new("ImageLabel")
	v1_453.Name = "Arrow"
	v1_453.AnchorPoint = Vector2.new(1, 0.5)
	v1_453.Position = UDim2.new(1, -8, 0.5, 0)
	v1_453.Size = UDim2.new(0, 16, 0, 16)
	v1_453.BackgroundTransparency = 1
	v1_453.BorderSizePixel = 0
	v1_453.ImageColor3 = v0_7.SubText
	v1_453.ScaleType = Enum.ScaleType.Fit
	v1_453.Parent = v1_450
	local v1_454 = Instance.new("TextLabel")
	v1_454.Name = "ArrowFallback"
	v1_454.Size = UDim2.new(1, 0, 1, 0)
	v1_454.BackgroundTransparency = 1
	v1_454.Text = "▼"
	v1_454.TextColor3 = v0_7.SubText
	v1_454.Font = Enum.Font.Gotham
	v1_454.TextSize = 9
	v1_454.Visible = false
	v1_454.Parent = v1_453
	local function v1_455(v2_456)
		local v2_457 = v0_42(v1_453, v2_456 and "chevron-up" or "chevron-down", self._icons)
		if not v2_457 then v1_453.Image = "" end
		v1_454.Visible = not v2_457
		v1_454.Text = v2_456 and "▲" or "▼"
		v1_453.ImageTransparency = 1
		v1_454.TextTransparency = 1
		v0_10(v1_453, { ImageTransparency = 0 }, 0.18)
		v0_10(v1_454, { TextTransparency = 0 }, 0.18)
	end
	v1_455(false)
	local v1_458 = Instance.new("ScrollingFrame")
	v1_458.Name = "List"
	v1_458.Size = UDim2.new(1, 0, 0, 0)
	v1_458.BackgroundColor3 = v0_7.Sidebar
	v1_458.BorderSizePixel = 0
	v1_458.ScrollBarThickness = 3
	v1_458.ScrollBarImageColor3 = v0_7.IconOff
	v1_458.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_458.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_458.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_458.Visible = false
	v1_458.LayoutOrder = 2
	v1_458.Parent = v1_448
	v0_61(v1_458, 6)
	local v1_459 = Instance.new("UIPadding")
	v1_459.PaddingTop = UDim.new(0, 4)
	v1_459.PaddingBottom = UDim.new(0, 4)
	v1_459.Parent = v1_458
	local v1_460 = Instance.new("UIListLayout")
	v1_460.Padding = UDim.new(0, v1_441)
	v1_460.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_460.SortOrder = Enum.SortOrder.LayoutOrder
	v1_460.Parent = v1_458
	local function v1_461(v2_462)
		if v1_438 then return v1_443[v2_462] == true end
		return v1_442 == v2_462
	end
	local function v1_463()
		local v2_464 = {}
		for v3_465, v3_466 in ipairs(v1_437) do
			if v1_443[v3_466] then table.insert(v2_464, v3_466) end
		end
		return v2_464
	end
	local function v1_467()
		for v3_468, v3_469 in pairs(v1_444) do
			local v3_470 = v1_461(v3_468)
			v3_469.BackgroundColor3 = v3_470 and v0_7.Accent or v0_7.Element
			v3_469.TextColor3 = v3_470 and v0_7.IconOn or v0_7.SubText
		end
		if v1_438 then
			local v3_471 = {}
			for v4_472, v4_473 in ipairs(v1_463()) do table.insert(v3_471, tostring(v4_473)) end
			v1_452.Text = #v3_471 > 0 and table.concat(v3_471, ", ") or "None"
		else
			v1_452.Text = v1_442 ~= nil and tostring(v1_442) or "None"
		end
	end
	local function v1_474(v2_475)
		if v1_445 == v2_475 then return end
		v1_445 = v2_475
		if v1_447 then v1_447:Cancel() end
		v1_455(v2_475)
		if v2_475 then
			v1_458.Visible = true
			v1_447 = v0_10(v1_458, { Size = UDim2.new(1, 0, 0, v1_446) }, 0.22, Enum.EasingStyle.Quint)
		else
			local v3_476 = v0_10(v1_458, { Size = UDim2.new(1, 0, 0, 0) }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v1_447 = v3_476
			v3_476.Completed:Connect(function(v4_477)
				if v4_477 == Enum.PlaybackState.Completed and not v1_445 then
					v1_458.Visible = false
				end
			end)
		end
	end
	local v1_478 = { Instance = v1_448 }
	local function v1_479()
		if v1_436.Callback then
			v1_436.Callback(v1_438 and v1_463() or v1_442)
		end
	end
	local function v1_480()
		for v3_481, v3_482 in pairs(v1_444) do v3_482:Destroy() end
		v1_444 = {}
		for v3_483, v3_484 in ipairs(v1_437) do
			local v3_485 = Instance.new("TextButton")
			v3_485.Name = "Option"
			v3_485.Size = UDim2.new(1, -8, 0, v1_440)
			v3_485.BackgroundColor3 = v0_7.Element
			v3_485.BorderSizePixel = 0
			v3_485.Text = tostring(v3_484)
			v3_485.TextColor3 = v0_7.SubText
			v3_485.Font = Enum.Font.Gotham
			v3_485.TextSize = 13
			v3_485.TextTruncate = Enum.TextTruncate.AtEnd
			v3_485.AutoButtonColor = true
			v3_485.LayoutOrder = v3_483
			v3_485.Parent = v1_458
			v0_61(v3_485, 5)
			v3_485.MouseButton1Click:Connect(function()
				if v1_438 then
					v1_443[v3_484] = not v1_443[v3_484] or nil
					v1_467()
					v1_479()
				else
					v1_442 = v3_484
					v1_467()
					v1_474(false)
					v1_479()
				end
			end)
			v1_444[v3_484] = v3_485
		end
		local v2_486 = #v1_437
		local v2_487 = v2_486 > 0 and (v2_486 * v1_440 + (v2_486 - 1) * v1_441 + 8) or 0
		v1_446 = math.min(v2_487, v1_439)
		v1_458.Size = UDim2.new(1, 0, 0, v1_445 and v1_446 or 0)
		v1_467()
	end
	function v1_478:Set(v2_488, v2_489)
		if v1_438 then
			v1_443 = {}
			for v4_490, v4_491 in ipairs(typeof(v2_488) == "table" and v2_488 or { v2_488 }) do
				v1_443[v4_491] = true
			end
		else
			v1_442 = v2_488
		end
		v1_467()
		if not v2_489 then v1_479() end
	end
	function v1_478:Get()
		return v1_438 and v1_463() or v1_442
	end
	function v1_478:Refresh(v2_492, v2_493)
		v1_437 = v2_492 or {}
		if v2_493 then
			local v3_494 = {}
			for v4_495, v4_496 in ipairs(v1_437) do v3_494[v4_496] = true end
			if v1_438 then
				for v5_497 in pairs(v1_443) do
					if not v3_494[v5_497] then v1_443[v5_497] = nil end
				end
			elseif not v3_494[v1_442] then
				v1_442 = nil
			end
		else
			v1_443, v1_442 = {}, nil
		end
		v1_480()
	end
	function v1_478:Open() v1_474(true) end
	function v1_478:Close() v1_474(false) end
	v1_450.MouseButton1Click:Connect(function()
		v1_474(not v1_445)
	end)
	v1_480()
	if v1_436.Default ~= nil then
		v1_478:Set(v1_436.Default, true)
	end
	return v1_478
end
return v0_1
