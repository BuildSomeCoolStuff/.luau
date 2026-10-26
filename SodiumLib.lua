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
	for v2_134, v2_135 in pairs(self._cleanups) do pcall(v2_135) end
	self._cleanups = {}
	self._binds = {}
	self._listening = nil
	self.ScreenGui:Destroy()
end
local v0_136, v0_137 = 0.35, 0.2
function v0_1:_cancelAnim()
	if self._anim then
		for v3_138, v3_139 in ipairs(self._anim) do v3_139:Cancel() end
		self._anim = nil
	end
end
function v0_1:Show()
	if self._destroyed then return end
	self._visible = true
	self:_cancelAnim()
	self.Main.Visible = true
	self._anim = {
		v0_10(self.Main, { GroupTransparency = 0 }, v0_136, Enum.EasingStyle.Quint),
		v0_10(self._scale, { Scale = 1 }, v0_136, Enum.EasingStyle.Back),
	}
	self:_updateWatermark()
end
function v0_1:Hide()
	if self._destroyed or not self._visible then return end
	self._visible = false
	self:_cancelAnim()
	local v1_140 = v0_4:GetFocusedTextBox()
	if v1_140 and v1_140:IsDescendantOf(self.Main) then v1_140:ReleaseFocus() end
	local v1_141 = v0_10(self.Main, { GroupTransparency = 1 }, v0_137, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local v1_142 = v0_10(self._scale, { Scale = 0.92 }, v0_137, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	self._anim = { v1_141, v1_142 }
	v1_141.Completed:Connect(function(v2_143)
		if v2_143 == Enum.PlaybackState.Completed and not self._visible and not self._destroyed then
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
	local v1_144 = self._hint
	if not v1_144 or self._destroyed then return end
	local v1_145 = self.ActiveTab and self.ActiveTab.Page
	local v1_146 = false
	if v1_145 and v1_145.Visible then
		local v2_147 = v1_145.AbsoluteCanvasSize.Y - (v1_145.CanvasPosition.Y + v1_145.AbsoluteWindowSize.Y)
		v1_146 = v2_147 > 4
	end
	if v1_146 == v1_144.Shown then return end
	v1_144.Shown = v1_146
	if v1_144.Fade then v1_144.Fade:Cancel() end
	if v1_146 then
		v1_144.Frame.Visible = true
		v1_144.Icon.Position = UDim2.new(0.5, 0, 0.5, -3)
		v1_144.Bounce:Play()
		v1_144.Fade = v0_10(v1_144.Frame, { GroupTransparency = 0.15 }, 0.2)
	else
		local v2_148 = v0_10(v1_144.Frame, { GroupTransparency = 1 }, 0.2)
		v1_144.Fade = v2_148
		v2_148.Completed:Connect(function(v3_149)
			if v3_149 == Enum.PlaybackState.Completed and not v1_144.Shown then
				v1_144.Bounce:Cancel()
				v1_144.Frame.Visible = false
			end
		end)
	end
end
function v0_1:_keyTaken(v1_150, v1_151)
	if not v1_150 then return false end
	if v1_150 == self._toggleKey then return true end
	for v2_152, v2_153 in ipairs(self._binds) do
		if v2_153 ~= v1_151 and v2_153._key == v1_150 then return true end
	end
	return false
end
local v0_154, v0_155 = 280, 5
function v0_1:_getNotifyContainer()
	if self._notifyContainer and self._notifyContainer.Parent then
		return self._notifyContainer
	end
	local v1_156 = self.ScreenGui.AbsoluteSize
	local v1_157 = v1_156.X > 0 and math.min(v0_154, v1_156.X - 20) or v0_154
	local v1_158 = Instance.new("Frame")
	v1_158.Name = "Notifications"
	v1_158.AnchorPoint = Vector2.new(0.5, 0)
	v1_158.Position = UDim2.new(0.5, 0, 0, self._wm and 48 or 10)
	v1_158.Size = UDim2.new(0, v1_157, 0, 0)
	v1_158.AutomaticSize = Enum.AutomaticSize.Y
	v1_158.BackgroundTransparency = 1
	v1_158.BorderSizePixel = 0
	v1_158.Parent = self.ScreenGui
	local v1_159 = Instance.new("UIListLayout")
	v1_159.Padding = UDim.new(0, 6)
	v1_159.SortOrder = Enum.SortOrder.LayoutOrder
	v1_159.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_159.Parent = v1_158
	self._notifyContainer = v1_158
	return v1_158
end
function v0_1:Notify(v1_160)
	if self._destroyed then return end
	if type(v1_160) == "string" then v1_160 = { Content = v1_160 } end
	v1_160 = v1_160 or {}
	local v1_161 = tonumber(v1_160.Duration) or 4
	local v1_162 = self:_getNotifyContainer()
	self._notifyCount = (self._notifyCount or 0) + 1
	self._notifs = self._notifs or {}
	local v1_163 = false
	local v1_164 = Instance.new("Frame")
	v1_164.Name = "Notification"
	v1_164.Size = UDim2.new(1, 0, 0, 0)
	v1_164.BackgroundTransparency = 1
	v1_164.BorderSizePixel = 0
	v1_164.LayoutOrder = self._notifyCount
	v1_164.Parent = v1_162
	local v1_165 = Instance.new("CanvasGroup")
	v1_165.Name = "Card"
	v1_165.Size = UDim2.new(1, 0, 0, 0)
	v1_165.AutomaticSize = Enum.AutomaticSize.Y
	v1_165.BackgroundColor3 = v0_7.Sidebar
	v1_165.BorderSizePixel = 0
	v1_165.GroupTransparency = 1
	v1_165.Parent = v1_164
	v0_61(v1_165, 8)
	local v1_166 = Instance.new("UIStroke")
	v1_166.Color = v0_7.Element
	v1_166.Thickness = 1
	v1_166.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_166.Parent = v1_165
	local v1_167 = Instance.new("Frame")
	v1_167.Name = "Body"
	v1_167.Size = UDim2.new(1, 0, 0, 0)
	v1_167.AutomaticSize = Enum.AutomaticSize.Y
	v1_167.BackgroundTransparency = 1
	v1_167.BorderSizePixel = 0
	v1_167.Parent = v1_165
	local v1_168 = Instance.new("UIPadding")
	v1_168.PaddingTop = UDim.new(0, 8)
	v1_168.PaddingBottom = UDim.new(0, 8)
	v1_168.PaddingLeft = UDim.new(0, 12)
	v1_168.PaddingRight = UDim.new(0, 12)
	v1_168.Parent = v1_167
	local v1_169 = Instance.new("UISizeConstraint")
	v1_169.MinSize = Vector2.new(0, 30)
	v1_169.Parent = v1_167
	local v1_170 = Instance.new("Frame")
	v1_170.Name = "Texts"
	v1_170.Position = UDim2.new(0, 0, 0, 0)
	v1_170.Size = UDim2.new(1, 0, 0, 0)
	v1_170.AutomaticSize = Enum.AutomaticSize.Y
	v1_170.BackgroundTransparency = 1
	v1_170.BorderSizePixel = 0
	v1_170.Parent = v1_167
	local v1_171 = Instance.new("UIListLayout")
	v1_171.Padding = UDim.new(0, 2)
	v1_171.SortOrder = Enum.SortOrder.LayoutOrder
	v1_171.Parent = v1_170
	local function v1_172(v2_173, v2_174, v2_175, v2_176, v2_177)
		local v2_178 = Instance.new("TextLabel")
		v2_178.Size = UDim2.new(1, 0, 0, 0)
		v2_178.AutomaticSize = Enum.AutomaticSize.Y
		v2_178.BackgroundTransparency = 1
		v2_178.BorderSizePixel = 0
		v2_178.Text = v2_173
		v2_178.TextColor3 = v2_176
		v2_178.Font = v2_174
		v2_178.TextSize = v2_175
		v2_178.TextWrapped = true
		v2_178.TextXAlignment = Enum.TextXAlignment.Left
		v2_178.TextYAlignment = Enum.TextYAlignment.Top
		v2_178.LayoutOrder = v2_177
		v2_178.Parent = v1_170
		return v2_178
	end
	if v1_160.Title and v1_160.Title ~= "" then
		v1_172(tostring(v1_160.Title), Enum.Font.GothamBold, 13, v0_7.Text, 1).Name = "Title"
	end
	if v1_160.Content and v1_160.Content ~= "" then
		v1_172(tostring(v1_160.Content), Enum.Font.Gotham, 12, v0_7.SubText, 2).Name = "Content"
	end
	local v1_179 = Instance.new("Frame")
	v1_179.Name = "Timer"
	v1_179.AnchorPoint = Vector2.new(0, 1)
	v1_179.Position = UDim2.new(0, 0, 1, 0)
	v1_179.Size = UDim2.new(1, 0, 0, 2)
	v1_179.BackgroundColor3 = v0_7.Accent
	v1_179.BorderSizePixel = 0
	v1_179.Visible = v1_161 > 0
	v1_179.Parent = v1_165
	local v1_180 = Instance.new("TextButton")
	v1_180.Name = "Click"
	v1_180.Size = UDim2.new(1, 0, 1, 0)
	v1_180.BackgroundTransparency = 1
	v1_180.BorderSizePixel = 0
	v1_180.Text = ""
	v1_180.AutoButtonColor = false
	v1_180.Parent = v1_165
	local function v1_181()
		if v1_163 then return end
		v1_163 = true
		local v2_182 = table.find(self._notifs, v1_181)
		if v2_182 then table.remove(self._notifs, v2_182) end
		if self._destroyed then return end
		local v2_183 = v0_10(v1_165, {
			Position = UDim2.new(0, 0, 0, -20),
			GroupTransparency = 1,
		}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_183.Completed:Connect(function()
			local v3_184 = v0_10(v1_164, { Size = UDim2.new(1, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quint)
			v3_184.Completed:Connect(function()
				v1_164:Destroy()
			end)
		end)
	end
	v1_180.MouseButton1Click:Connect(v1_181)
	table.insert(self._notifs, v1_181)
	while #self._notifs > v0_155 do
		self._notifs[1]()
	end
	task.spawn(function()
		v0_6.Heartbeat:Wait()
		v0_6.Heartbeat:Wait()
		local v2_185 = v1_165.AbsoluteSize.Y
		for v3_186 = 1, 10 do
			if v2_185 > 0 then break end
			v0_6.Heartbeat:Wait()
			v2_185 = v1_165.AbsoluteSize.Y
		end
		if v2_185 <= 0 then v2_185 = 50 end
		if v1_163 or self._destroyed or not v1_164.Parent then return end
		v1_165.Position = UDim2.new(0, 0, 0, -(v1_164.AbsolutePosition.Y + v2_185 + 10))
		v0_10(v1_164, { Size = UDim2.new(1, 0, 0, v2_185) }, 0.3, Enum.EasingStyle.Quint)
		v0_10(v1_165, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back)
		v0_10(v1_165, { GroupTransparency = 0 }, 0.25)
		v1_165:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if not v1_163 and v1_165.AbsoluteSize.Y > 0 then
				v1_164.Size = UDim2.new(1, 0, 0, v1_165.AbsoluteSize.Y)
			end
		end)
		if v1_161 > 0 then
			local v3_187 = v0_10(v1_179, { Size = UDim2.new(0, 0, 0, 2) }, v1_161, Enum.EasingStyle.Linear)
			v3_187.Completed:Connect(function(v4_188)
				if v4_188 == Enum.PlaybackState.Completed then v1_181() end
			end)
		end
	end)
	return { Dismiss = v1_181 }
end
function v0_1:_buildWatermark(v1_189)
	local v1_190 = Instance.new("Frame")
	v1_190.Name = "Watermark"
	v1_190.AnchorPoint = Vector2.new(0.5, 0)
	v1_190.Position = UDim2.new(0.5, 0, 0, -40)
	v1_190.Size = UDim2.new(0, 0, 0, 30)
	v1_190.AutomaticSize = Enum.AutomaticSize.X
	v1_190.BackgroundColor3 = v0_7.Sidebar
	v1_190.BorderSizePixel = 0
	v1_190.Parent = self.ScreenGui
	v0_61(v1_190, 8)
	local v1_191 = Instance.new("UIStroke")
	v1_191.Color = v0_7.Element
	v1_191.Thickness = 1
	v1_191.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_191.Parent = v1_190
	local v1_192 = Instance.new("UIPadding")
	v1_192.PaddingLeft = UDim.new(0, 10)
	v1_192.PaddingRight = UDim.new(0, 4)
	v1_192.Parent = v1_190
	local v1_193 = Instance.new("UIListLayout")
	v1_193.FillDirection = Enum.FillDirection.Horizontal
	v1_193.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_193.Padding = UDim.new(0, 8)
	v1_193.SortOrder = Enum.SortOrder.LayoutOrder
	v1_193.Parent = v1_190
	local v1_194 = Instance.new("TextLabel")
	v1_194.Name = "Title"
	v1_194.Size = UDim2.new(0, 0, 1, 0)
	v1_194.AutomaticSize = Enum.AutomaticSize.X
	v1_194.BackgroundTransparency = 1
	v1_194.BorderSizePixel = 0
	v1_194.Text = v1_189
	v1_194.TextColor3 = v0_7.SubText
	v1_194.Font = Enum.Font.GothamBold
	v1_194.TextSize = 13
	v1_194.LayoutOrder = 1
	v1_194.Parent = v1_190
	local v1_195 = Instance.new("TextButton")
	v1_195.Name = "ToggleButton"
	v1_195.Size = UDim2.new(0, 22, 0, 22)
	v1_195.BackgroundColor3 = v0_7.Element
	v1_195.BorderSizePixel = 0
	v1_195.Text = ""
	v1_195.AutoButtonColor = false
	v1_195.LayoutOrder = 2
	v1_195.Parent = v1_190
	v0_61(v1_195, 6)
	local v1_196 = Instance.new("ImageLabel")
	v1_196.Name = "Icon"
	v1_196.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_196.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_196.Size = UDim2.new(0, 14, 0, 14)
	v1_196.BackgroundTransparency = 1
	v1_196.BorderSizePixel = 0
	v1_196.ImageColor3 = v0_7.IconOn
	v1_196.ScaleType = Enum.ScaleType.Fit
	v1_196.Parent = v1_195
	local v1_197 = Instance.new("TextLabel")
	v1_197.Name = "IconFallback"
	v1_197.Size = UDim2.new(1, 0, 1, 0)
	v1_197.BackgroundTransparency = 1
	v1_197.TextColor3 = v0_7.IconOn
	v1_197.Font = Enum.Font.GothamBold
	v1_197.TextSize = 12
	v1_197.Visible = false
	v1_197.Parent = v1_196
	local v1_198 = Instance.new("UIScale")
	v1_198.Parent = v1_195
	v1_195.MouseEnter:Connect(function() v0_10(v1_198, { Scale = 1.1 }, 0.12) end)
	v1_195.MouseLeave:Connect(function() v0_10(v1_198, { Scale = 1 }, 0.12) end)
	v1_195.InputBegan:Connect(function(v2_199)
		if v0_17(v2_199) then v0_10(v1_198, { Scale = 0.9 }, 0.08) end
	end)
	v1_195.InputEnded:Connect(function(v2_200)
		if v0_17(v2_200) then v0_10(v1_198, { Scale = 1.1 }, 0.15, Enum.EasingStyle.Back) end
	end)
	v1_195.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	local v1_201, v1_202, v1_203 = false, nil, nil
	v1_194.InputBegan:Connect(function(v2_204)
		if v0_17(v2_204) then
			v1_201 = true
			v1_202 = v2_204.Position
			v1_203 = v1_190.AbsolutePosition + Vector2.new(v1_190.AbsoluteSize.X / 2, 0)
			v2_204.Changed:Connect(function()
				if v2_204.UserInputState == Enum.UserInputState.End then v1_201 = false end
			end)
		end
	end)
	table.insert(self._connections, v0_4.InputChanged:Connect(function(v2_205)
		if not v1_201 then return end
		if v2_205.UserInputType ~= Enum.UserInputType.MouseMovement and v2_205.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local v2_206 = v2_205.Position - v1_202
		local v2_207 = self.ScreenGui.AbsoluteSize
		local v2_208 = v1_190.AbsoluteSize.X / 2
		local v2_209 = math.clamp(v1_203.X + v2_206.X, v2_208, math.max(v2_207.X - v2_208, v2_208))
		local v2_210 = math.clamp(v1_203.Y + v2_206.Y, 0, math.max(v2_207.Y - v1_190.AbsoluteSize.Y, 0))
		v1_190.Position = UDim2.fromOffset(v2_209, v2_210)
	end))
	self._wm = { Frame = v1_190, Button = v1_195, Icon = v1_196, Fallback = v1_197 }
	v0_10(v1_190, { Position = UDim2.new(0.5, 0, 0, 10) }, 0.5, Enum.EasingStyle.Back)
end
function v0_1:_updateWatermark()
	local v1_211 = self._wm
	if not v1_211 then return end
	local v1_212 = self._visible == true
	v0_10(v1_211.Button, { BackgroundColor3 = v1_212 and v0_7.Accent or v0_7.Element }, 0.2)
	local v1_213 = v0_42(v1_211.Icon, v1_212 and "eye" or "eye-off", self.Icons)
	if not v1_213 then v1_211.Icon.Image = "" end
	v1_211.Fallback.Visible = not v1_213
	v1_211.Fallback.Text = v1_212 and "●" or "○"
	v1_211.Icon.ImageTransparency = 1
	v0_10(v1_211.Icon, { ImageTransparency = 0 }, 0.2)
end
local function v0_214(v1_215, v1_216)
	v0_10(v1_215.Icon, { ImageColor3 = v1_216 }, 0.2)
	if v1_215.Fallback then
		v0_10(v1_215.Fallback, { TextColor3 = v1_216 }, 0.2)
	end
end
function v0_1:AddTab(v1_217)
	v1_217 = v1_217 or {}
	local v1_218 = Instance.new("TextButton")
	v1_218.Name = "TabButton"
	v1_218.Size = UDim2.new(0, 36, 0, 36)
	v1_218.BackgroundColor3 = v0_7.Card
	v1_218.BorderSizePixel = 0
	v1_218.Text = ""
	v1_218.AutoButtonColor = false
	v1_218.LayoutOrder = #self.Tabs + 1
	v1_218.Parent = self.Sidebar
	v0_61(v1_218, 6)
	local v1_219 = Instance.new("ImageLabel")
	v1_219.Name = "Icon"
	v1_219.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_219.Size = UDim2.new(0, 20, 0, 20)
	v1_219.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_219.BackgroundTransparency = 1
	v1_219.BorderSizePixel = 0
	v1_219.ImageColor3 = v0_7.IconOff
	v1_219.ScaleType = Enum.ScaleType.Fit
	v1_219.Parent = v1_218
	local v1_220
	if not v0_42(v1_219, v1_217.Icon, self.Icons) then
		v1_220 = Instance.new("TextLabel")
		v1_220.Name = "IconFallback"
		v1_220.Size = UDim2.new(1, 0, 1, 0)
		v1_220.BackgroundTransparency = 1
		v1_220.Text = string.upper(string.sub(tostring(v1_217.Name or v1_217.Icon or "?"), 1, 1))
		v1_220.TextColor3 = v0_7.IconOff
		v1_220.Font = Enum.Font.GothamBold
		v1_220.TextSize = 16
		v1_220.Parent = v1_219
	end
	local v1_221 = Instance.new("ScrollingFrame")
	v1_221.Name = "Page"
	v1_221.Size = UDim2.new(1, 0, 1, 0)
	v1_221.BackgroundTransparency = 1
	v1_221.BorderSizePixel = 0
	v1_221.ScrollBarThickness = 3
	v1_221.ScrollBarImageColor3 = v0_7.IconOff
	v1_221.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_221.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_221.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_221.Visible = false
	v1_221.Parent = self.Content
	local v1_222 = Instance.new("Frame")
	v1_222.Name = "Inner"
	v1_222.Size = UDim2.new(1, 0, 0, 0)
	v1_222.AutomaticSize = Enum.AutomaticSize.Y
	v1_222.BackgroundTransparency = 1
	v1_222.BorderSizePixel = 0
	v1_222.Parent = v1_221
	local v1_223 = Instance.new("UIPadding")
	v1_223.PaddingTop = UDim.new(0, 12)
	v1_223.PaddingBottom = UDim.new(0, 12)
	v1_223.Parent = v1_222
	local v1_224 = Instance.new("Frame")
	v1_224.Name = "Split"
	v1_224.Position = UDim2.new(0, 12, 0, 0)
	v1_224.Size = UDim2.new(1, -26, 0, 0)
	v1_224.AutomaticSize = Enum.AutomaticSize.Y
	v1_224.BackgroundTransparency = 1
	v1_224.BorderSizePixel = 0
	v1_224.Parent = v1_222
	local v1_225 = Instance.new("UIListLayout")
	v1_225.FillDirection = Enum.FillDirection.Horizontal
	v1_225.Padding = UDim.new(0, 8)
	v1_225.SortOrder = Enum.SortOrder.LayoutOrder
	v1_225.Parent = v1_224
	local function v1_226(v2_227)
		local v2_228 = Instance.new("Frame")
		v2_228.Name = v2_227 == 1 and "Left" or "Right"
		v2_228.Size = UDim2.new(0.5, -4, 0, 0)
		v2_228.AutomaticSize = Enum.AutomaticSize.Y
		v2_228.BackgroundTransparency = 1
		v2_228.BorderSizePixel = 0
		v2_228.LayoutOrder = v2_227
		v2_228.Parent = v1_224
		local v2_229 = Instance.new("UIListLayout")
		v2_229.Padding = UDim.new(0, 8)
		v2_229.SortOrder = Enum.SortOrder.LayoutOrder
		v2_229.Parent = v2_228
		return v2_228
	end
	local v1_230 = setmetatable({
		Page = v1_221,
		Button = v1_218,
		Icon = v1_219,
		Fallback = v1_220,
		Inner = v1_222,
		_icons = self.Icons,
		_lib = self,
		Left = v1_226(1),
		Right = v1_226(2),
		_sectionCount = 0,
	}, v0_2)
	table.insert(self.Tabs, v1_230)
	for v2_231, v2_232 in ipairs({ "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" }) do
		table.insert(self._connections, v1_221:GetPropertyChangedSignal(v2_232):Connect(function()
			if self.ActiveTab == v1_230 then self:_updateScrollHint() end
		end))
	end
	v0_19(v1_218, v0_7.Card, v0_7.Element, function()
		return self.ActiveTab == v1_230
	end)
	v1_218.MouseButton1Click:Connect(function()
		self:SelectTab(v1_230)
	end)
	if not self.ActiveTab then self:SelectTab(v1_230) end
	return v1_230
end
function v0_1:SelectTab(v1_233)
	if self.ActiveTab == v1_233 then return end
	local v1_234 = self.ActiveTab
	self.ActiveTab = v1_233
	if v1_234 then
		v1_234.Page.Visible = false
		v0_10(v1_234.Button, { BackgroundColor3 = v0_7.Card }, 0.2)
		v0_214(v1_234, v0_7.IconOff)
	end
	v1_233.Inner.Position = UDim2.new(0, 0, 0, 14)
	v1_233.Page.Visible = true
	v0_10(v1_233.Inner, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)
	v0_10(v1_233.Button, { BackgroundColor3 = v0_7.Accent }, 0.2)
	v0_214(v1_233, v0_7.IconOn)
	self:_updateScrollHint()
end
function v0_2:AddSection(v1_235, v1_236, v1_237)
	local v1_238 = (v1_236 == "right") and self.Right or self.Left
	local v1_239 = self._lib
	self._sectionCount += 1
	local v1_240 = Instance.new("Frame")
	v1_240.Name = "Section"
	v1_240.Size = UDim2.new(1, 0, 0, 0)
	v1_240.AutomaticSize = Enum.AutomaticSize.Y
	v1_240.BackgroundColor3 = v0_7.Card
	v1_240.BorderSizePixel = 0
	v1_240.LayoutOrder = self._sectionCount
	v1_240.Parent = v1_238
	v0_61(v1_240, 6)
	local v1_241 = Instance.new("UIPadding")
	v1_241.PaddingTop = UDim.new(0, 8)
	v1_241.PaddingBottom = UDim.new(0, 8)
	v1_241.PaddingLeft = UDim.new(0, 8)
	v1_241.PaddingRight = UDim.new(0, 8)
	v1_241.Parent = v1_240
	local v1_242 = Instance.new("UIListLayout")
	v1_242.Padding = UDim.new(0, 6)
	v1_242.SortOrder = Enum.SortOrder.LayoutOrder
	v1_242.Parent = v1_240
	local v1_243 = Instance.new("Frame")
	v1_243.Name = "Body"
	v1_243.Size = UDim2.new(1, 0, 0, 0)
	v1_243.AutomaticSize = Enum.AutomaticSize.Y
	v1_243.BackgroundTransparency = 1
	v1_243.BorderSizePixel = 0
	v1_243.LayoutOrder = 1
	v1_243.Parent = v1_240
	local v1_244 = Instance.new("UIListLayout")
	v1_244.Padding = UDim.new(0, 6)
	v1_244.SortOrder = Enum.SortOrder.LayoutOrder
	v1_244.Parent = v1_243
	local v1_245 = false
	local v1_246 = {}
	local v1_247, v1_248
	local function v1_249()
		local v2_250 = v1_239._scale and v1_239._scale.Scale or 1
		return math.max(v1_244.AbsoluteContentSize.Y / (v2_250 > 0 and v2_250 or 1), 0)
	end
	local function v1_251()
		v1_243.AutomaticSize = Enum.AutomaticSize.Y
		v1_243.Size = UDim2.new(1, 0, 0, 0)
		v1_243.ClipsDescendants = false
	end
	local function v1_252(v2_253, v2_254)
		if v2_253 == v1_245 and not v2_254 then return end
		v1_245 = v2_253
		for v3_255, v3_256 in ipairs(v1_246) do v3_256:Cancel() end
		v1_246 = {}
		if v1_247 then
			if v2_254 then
				v1_247.Rotation = v2_253 and -90 or 0
			else
				v0_10(v1_247, { Rotation = v2_253 and -90 or 0 }, 0.22, Enum.EasingStyle.Quint)
			end
		end
		if v2_254 then
			v1_243.Visible = not v2_253
			v1_242.Padding = UDim.new(0, v2_253 and 0 or 6)
			v1_251()
			return
		end
		v1_243.ClipsDescendants = true
		if v2_253 then
			if v1_243.AutomaticSize ~= Enum.AutomaticSize.None then
				local v4_257 = v1_249()
				v1_243.AutomaticSize = Enum.AutomaticSize.None
				v1_243.Size = UDim2.new(1, 0, 0, v4_257)
			end
			local v3_258 = v0_10(v1_243, { Size = UDim2.new(1, 0, 0, 0) }, 0.25, Enum.EasingStyle.Quint)
			v1_246 = { v3_258, v0_10(v1_242, { Padding = UDim.new(0, 0) }, 0.25, Enum.EasingStyle.Quint) }
			v3_258.Completed:Connect(function(v4_259)
				if v4_259 == Enum.PlaybackState.Completed and v1_245 then
					v1_243.Visible = false
					v1_243.ClipsDescendants = false
				end
			end)
		else
			v1_243.Visible = true
			local v3_260 = v1_249()
			if v3_260 <= 0 then
				v1_242.Padding = UDim.new(0, 6)
				v1_251()
				return
			end
			if v1_243.AutomaticSize ~= Enum.AutomaticSize.None then
				v1_243.AutomaticSize = Enum.AutomaticSize.None
				v1_243.Size = UDim2.new(1, 0, 0, 0)
			end
			local v3_261 = v0_10(v1_243, { Size = UDim2.new(1, 0, 0, v3_260) }, 0.28, Enum.EasingStyle.Quint)
			v1_246 = { v3_261, v0_10(v1_242, { Padding = UDim.new(0, 6) }, 0.28, Enum.EasingStyle.Quint) }
			v3_261.Completed:Connect(function(v4_262)
				if v4_262 == Enum.PlaybackState.Completed and not v1_245 then
					v1_251()
				end
			end)
		end
	end
	if v1_235 then
		local v2_263 = Instance.new("TextButton")
		v2_263.Name = "Header"
		v2_263.Size = UDim2.new(1, 0, 0, 16)
		v2_263.BackgroundTransparency = 1
		v2_263.BorderSizePixel = 0
		v2_263.Text = ""
		v2_263.AutoButtonColor = false
		v2_263.LayoutOrder = 0
		v2_263.Parent = v1_240
		local v2_264 = Instance.new("TextLabel")
		v2_264.Name = "Title"
		v2_264.Size = UDim2.new(1, -22, 1, 0)
		v2_264.BackgroundTransparency = 1
		v2_264.BorderSizePixel = 0
		v2_264.Text = v1_235
		v2_264.TextColor3 = v0_7.SubText
		v2_264.Font = Enum.Font.GothamBold
		v2_264.TextSize = 13
		v2_264.TextXAlignment = Enum.TextXAlignment.Left
		v2_264.TextTruncate = Enum.TextTruncate.AtEnd
		v2_264.Parent = v2_263
		v1_247 = Instance.new("ImageLabel")
		v1_247.Name = "Chevron"
		v1_247.AnchorPoint = Vector2.new(1, 0.5)
		v1_247.Position = UDim2.new(1, 0, 0.5, 0)
		v1_247.Size = UDim2.new(0, 14, 0, 14)
		v1_247.BackgroundTransparency = 1
		v1_247.BorderSizePixel = 0
		v1_247.ImageColor3 = v0_7.SubText
		v1_247.ScaleType = Enum.ScaleType.Fit
		v1_247.Parent = v2_263
		v1_248 = Instance.new("TextLabel")
		v1_248.Name = "ChevronFallback"
		v1_248.Size = UDim2.new(1, 0, 1, 0)
		v1_248.BackgroundTransparency = 1
		v1_248.Text = "▼"
		v1_248.TextColor3 = v0_7.SubText
		v1_248.Font = Enum.Font.Gotham
		v1_248.TextSize = 9
		v1_248.Parent = v1_247
		v1_248.Visible = not v0_42(v1_247, "chevron-down", self._icons)
		v2_263.MouseEnter:Connect(function()
			v0_10(v2_264, { TextColor3 = v0_7.Text }, 0.12)
			v0_10(v1_247, { ImageColor3 = v0_7.Text }, 0.12)
			v0_10(v1_248, { TextColor3 = v0_7.Text }, 0.12)
		end)
		v2_263.MouseLeave:Connect(function()
			v0_10(v2_264, { TextColor3 = v0_7.SubText }, 0.15)
			v0_10(v1_247, { ImageColor3 = v0_7.SubText }, 0.15)
			v0_10(v1_248, { TextColor3 = v0_7.SubText }, 0.15)
		end)
		v2_263.MouseButton1Click:Connect(function()
			v1_252(not v1_245)
		end)
	end
	local v1_265 = setmetatable({
		Holder = v1_243,
		Card = v1_240,
		_count = 0,
		_icons = self._icons,
		_lib = self._lib,
		_setCollapsed = v1_252,
		_isCollapsed = function() return v1_245 end,
	}, v0_3)
	if v1_235 and v1_237 == true then
		v1_252(true, true)
	end
	return v1_265
end
function v0_3:SetCollapsed(v1_266)
	self._setCollapsed(v1_266 == true)
end
function v0_3:ToggleCollapsed()
	self._setCollapsed(not self._isCollapsed())
end
function v0_3:IsCollapsed()
	return self._isCollapsed()
end
local function v0_267(v1_268)
	if typeof(v1_268) == "EnumItem" and v1_268.EnumType == Enum.KeyCode then return v1_268 end
	if type(v1_268) == "string" then
		local v2_269, v2_270 = pcall(function() return Enum.KeyCode[v1_268] end)
		if v2_269 then return v2_270 end
	end
	return nil
end
local function v0_271(v1_272, v1_273, v1_274, v1_275, v1_276)
	v1_274 = v1_274 or {}
	local v1_277 = v1_274.CanBeChanged ~= false
	local v1_278 = {}
	local v1_279 = { _key = nil, _onPress = v1_276, _isListening = false, _destroyed = false }
	local v1_280 = Instance.new("TextButton")
	v1_280.Name = "Keybind"
	v1_280.AnchorPoint = Vector2.new(1, 0.5)
	v1_280.Position = v1_275
	v1_280.Size = UDim2.new(0, 0, 0, 20)
	v1_280.AutomaticSize = Enum.AutomaticSize.X
	v1_280.BackgroundColor3 = v0_7.Card
	v1_280.BorderSizePixel = 0
	v1_280.Text = "None"
	v1_280.TextColor3 = v0_7.SubText
	v1_280.Font = Enum.Font.Gotham
	v1_280.TextSize = 12
	v1_280.TextTruncate = Enum.TextTruncate.AtEnd
	v1_280.AutoButtonColor = false
	v1_280.Parent = v1_273
	v0_61(v1_280, 5)
	v1_279.Instance = v1_280
	local v1_281 = Instance.new("UIPadding")
	v1_281.PaddingLeft = UDim.new(0, 7)
	v1_281.PaddingRight = UDim.new(0, 7)
	v1_281.Parent = v1_280
	local v1_282 = Instance.new("UISizeConstraint")
	v1_282.MinSize = Vector2.new(30, 20)
	v1_282.MaxSize = Vector2.new(96, 20)
	v1_282.Parent = v1_280
	local function v1_283()
		if v1_279._isListening then
			v1_280.Text = "..."
		else
			v1_280.Text = v1_279._key and v1_279._key.Name or "None"
		end
	end
	local function v1_284()
		v1_280.BackgroundColor3 = v0_7.Danger
		v0_10(v1_280, { BackgroundColor3 = v0_7.Card }, 0.45)
	end
	function v1_279:Set(v2_285, v2_286)
		v2_285 = v0_267(v2_285)
		if v2_285 and v1_272:_keyTaken(v2_285, v1_279) then
			warn("[RobloxUI] key already in use:", v2_285.Name)
			v1_284()
			return false
		end
		v1_279._key = v2_285
		v1_283()
		if not v2_286 and v1_274.Callback then v1_274.Callback(v2_285) end
		return true
	end
	function v1_279:Get()
		return v1_279._key
	end
	function v1_279:_startListening()
		if v1_272._listening and v1_272._listening ~= v1_279 then
			v1_272._listening:_stopListening()
		end
		v1_272._listening = v1_279
		v1_279._isListening = true
		v0_10(v1_280, { BackgroundColor3 = v0_7.Accent }, 0.15)
		v1_283()
	end
	function v1_279:_stopListening()
		if v1_272._listening == v1_279 then v1_272._listening = nil end
		v1_279._isListening = false
		v0_10(v1_280, { BackgroundColor3 = v0_7.Card }, 0.15)
		v1_283()
	end
	function v1_279:_capture(v2_287)
		if v2_287 == Enum.KeyCode.Unknown then return end
		v1_279:_stopListening()
		if v2_287 == Enum.KeyCode.Escape then return end
		if v2_287 == Enum.KeyCode.Backspace or v2_287 == Enum.KeyCode.Delete then
			v1_279:Set(nil)
		else
			v1_279:Set(v2_287)
		end
	end
	function v1_279:Destroy()
		if v1_279._destroyed then return end
		v1_279._destroyed = true
		if v1_272._listening == v1_279 then v1_272._listening = nil end
		local v2_288 = table.find(v1_272._binds, v1_279)
		if v2_288 then table.remove(v1_272._binds, v2_288) end
		v1_272._cleanups[v1_279] = nil
		for v3_289, v3_290 in ipairs(v1_278) do v3_290:Disconnect() end
		v1_278 = {}
		v1_280:Destroy()
	end
	if v1_277 then
		v0_19(v1_280, v0_7.Card, v0_7.Sidebar, function() return v1_279._isListening end)
		table.insert(v1_278, v1_280.MouseButton1Click:Connect(function()
			if v1_279._isListening then v1_279:_stopListening() else v1_279:_startListening() end
		end))
		table.insert(v1_278, v1_280.MouseButton2Click:Connect(function()
			if v1_279._isListening then v1_279:_stopListening() end
			v1_279:Set(nil)
		end))
	end
	if v1_274.Key ~= nil then
		v1_279:Set(v1_274.Key, true)
	end
	table.insert(v1_272._binds, v1_279)
	v1_272._cleanups[v1_279] = function() v1_279:Destroy() end
	return v1_279
end
local function v0_291(v1_292, v1_293, v1_294)
	local v1_295 = v1_293.Instance
	local function v1_296()
		local v2_297 = math.clamp(v1_295.TextBounds.X + 14, 30, 96)
		v1_292.Size = UDim2.new(1, -(v1_294 + v2_297 + 6), 1, 0)
	end
	v1_296()
	v1_295:GetPropertyChangedSignal("TextBounds"):Connect(v1_296)
end
function v0_3:AddButton(v1_298)
	v1_298 = v1_298 or {}
	self._count += 1
	local v1_299 = Instance.new("TextButton")
	v1_299.Name = "Button"
	v1_299.Size = UDim2.new(1, 0, 0, 32)
	v1_299.BackgroundColor3 = v0_7.Element
	v1_299.BorderSizePixel = 0
	v1_299.Text = v1_298.Name or "Button"
	v1_299.TextColor3 = v0_7.Text
	v1_299.Font = Enum.Font.Gotham
	v1_299.TextSize = 14
	v1_299.TextTruncate = Enum.TextTruncate.AtEnd
	v1_299.AutoButtonColor = false
	v1_299.LayoutOrder = self._count
	v1_299.Parent = self.Holder
	v0_61(v1_299, 6)
	local v1_300 = Instance.new("UIPadding")
	v1_300.PaddingLeft = UDim.new(0, 8)
	v1_300.PaddingRight = UDim.new(0, 8)
	v1_300.Parent = v1_299
	v0_19(v1_299, v0_7.Element, v0_7.Hover)
	v1_299.MouseButton1Click:Connect(function()
		v1_299.BackgroundColor3 = v0_7.Accent
		v0_10(v1_299, { BackgroundColor3 = v0_7.Hover }, 0.3)
		if v1_298.Callback then v1_298.Callback() end
	end)
	return v1_299
end
function v0_3:AddToggle(v1_301)
	v1_301 = v1_301 or {}
	self._count += 1
	local v1_302 = v1_301.Default == true
	local v1_303 = self
	local v1_304 = Instance.new("TextButton")
	v1_304.Name = "Toggle"
	v1_304.Size = UDim2.new(1, 0, 0, 32)
	v1_304.BackgroundColor3 = v0_7.Element
	v1_304.BorderSizePixel = 0
	v1_304.Text = ""
	v1_304.AutoButtonColor = false
	v1_304.LayoutOrder = self._count
	v1_304.Parent = self.Holder
	v0_61(v1_304, 6)
	v0_19(v1_304, v0_7.Element, v0_7.Hover)
	local v1_305 = Instance.new("TextLabel")
	v1_305.Name = "Label"
	v1_305.Position = UDim2.new(0, 8, 0, 0)
	v1_305.Size = UDim2.new(1, -60, 1, 0)
	v1_305.BackgroundTransparency = 1
	v1_305.BorderSizePixel = 0
	v1_305.Text = v1_301.Name or "Toggle"
	v1_305.TextColor3 = v0_7.Text
	v1_305.Font = Enum.Font.Gotham
	v1_305.TextSize = 14
	v1_305.TextXAlignment = Enum.TextXAlignment.Left
	v1_305.TextTruncate = Enum.TextTruncate.AtEnd
	v1_305.Parent = v1_304
	local v1_306 = Instance.new("Frame")
	v1_306.Name = "Track"
	v1_306.AnchorPoint = Vector2.new(1, 0.5)
	v1_306.Position = UDim2.new(1, -8, 0.5, 0)
	v1_306.Size = UDim2.new(0, 34, 0, 18)
	v1_306.BackgroundColor3 = v0_7.Off
	v1_306.BorderSizePixel = 0
	v1_306.Parent = v1_304
	v0_61(v1_306, 9)
	local v1_307 = Instance.new("Frame")
	v1_307.Name = "Knob"
	v1_307.AnchorPoint = Vector2.new(0, 0.5)
	v1_307.Position = UDim2.new(0, 2, 0.5, 0)
	v1_307.Size = UDim2.new(0, 14, 0, 14)
	v1_307.BackgroundColor3 = v0_7.Text
	v1_307.BorderSizePixel = 0
	v1_307.Parent = v1_306
	v0_61(v1_307, 7)
	local function v1_308(v2_309)
		local v2_310 = TweenInfo.new(v2_309 and 0.15 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		v0_5:Create(v1_306, v2_310, { BackgroundColor3 = v1_302 and v0_7.Accent or v0_7.Off }):Play()
		v0_5:Create(v1_307, v2_310, {
			Position = v1_302 and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}):Play()
	end
	v1_308(false)
	local v1_311 = { Instance = v1_304 }
	function v1_311:Set(v2_312, v2_313)
		v1_302 = v2_312 and true or false
		v1_308(true)
		if not v2_313 and v1_301.Callback then v1_301.Callback(v1_302) end
	end
	function v1_311:Get()
		return v1_302
	end
	v1_304.MouseButton1Click:Connect(function()
		v1_311:Set(not v1_302)
	end)
	function v1_311:AddKeybind(v2_314)
		if v1_311.Keybind then
			warn("[RobloxUI] this toggle already has a keybind")
			return v1_311.Keybind
		end
		local v2_315 = v0_271(v1_303._lib, v1_304, v2_314, UDim2.new(1, -48, 0.5, 0), function()
			v1_311:Set(not v1_302)
		end)
		v0_291(v1_305, v2_315, 60)
		local v2_316 = v2_315.Destroy
		function v2_315:Destroy()
			v2_316(v2_315)
			v1_311.Keybind = nil
			v1_305.Size = UDim2.new(1, -60, 1, 0)
		end
		v1_311.Keybind = v2_315
		return v2_315
	end
	function v1_311:Destroy()
		if v1_311._destroyed then return end
		v1_311._destroyed = true
		if v1_311.Keybind then v1_311.Keybind:Destroy() end
		v1_304:Destroy()
	end
	return v1_311
end
function v0_3:AddParagraph(v1_317)
	v1_317 = v1_317 or {}
	self._count += 1
	local v1_318 = v1_317.Title and tostring(v1_317.Title) or ""
	local v1_319 = v1_317.Content and tostring(v1_317.Content) or ""
	local v1_320 = Instance.new("Frame")
	v1_320.Name = "Paragraph"
	v1_320.Size = UDim2.new(1, 0, 0, 0)
	v1_320.AutomaticSize = Enum.AutomaticSize.Y
	v1_320.BackgroundColor3 = v0_7.Element
	v1_320.BorderSizePixel = 0
	v1_320.LayoutOrder = self._count
	v1_320.Parent = self.Holder
	v0_61(v1_320, 6)
	local v1_321 = Instance.new("UIPadding")
	v1_321.PaddingTop = UDim.new(0, 8)
	v1_321.PaddingBottom = UDim.new(0, 8)
	v1_321.PaddingLeft = UDim.new(0, 8)
	v1_321.PaddingRight = UDim.new(0, 8)
	v1_321.Parent = v1_320
	local v1_322 = Instance.new("UIListLayout")
	v1_322.Padding = UDim.new(0, 3)
	v1_322.SortOrder = Enum.SortOrder.LayoutOrder
	v1_322.Parent = v1_320
	local function v1_323(v2_324, v2_325, v2_326, v2_327, v2_328)
		local v2_329 = Instance.new("TextLabel")
		v2_329.Name = v2_324
		v2_329.Size = UDim2.new(1, 0, 0, 0)
		v2_329.AutomaticSize = Enum.AutomaticSize.Y
		v2_329.BackgroundTransparency = 1
		v2_329.BorderSizePixel = 0
		v2_329.TextColor3 = v2_327
		v2_329.Font = v2_325
		v2_329.TextSize = v2_326
		v2_329.TextWrapped = true
		v2_329.RichText = v1_317.RichText == true
		v2_329.TextXAlignment = Enum.TextXAlignment.Left
		v2_329.TextYAlignment = Enum.TextYAlignment.Top
		v2_329.LayoutOrder = v2_328
		v2_329.Parent = v1_320
		return v2_329
	end
	local v1_330 = v1_323("Title", Enum.Font.GothamBold, 14, v0_7.Text, 1)
	local v1_331 = v1_323("Content", Enum.Font.Gotham, 13, v0_7.SubText, 2)
	local function v1_332(v2_333)
		v1_330.Text = v1_318
		v1_330.Visible = v1_318 ~= ""
		v1_331.Text = v1_319
		v1_331.Visible = v1_319 ~= ""
		if v2_333 then
			v1_330.TextTransparency = 1
			v1_331.TextTransparency = 1
			v0_10(v1_330, { TextTransparency = 0 }, 0.2)
			v0_10(v1_331, { TextTransparency = 0 }, 0.2)
		end
	end
	v1_332(false)
	local v1_334 = { Instance = v1_320 }
	function v1_334:SetTitle(v2_335)
		v1_318 = v2_335 and tostring(v2_335) or ""
		v1_332(true)
	end
	function v1_334:SetContent(v2_336)
		v1_319 = v2_336 and tostring(v2_336) or ""
		v1_332(true)
	end
	function v1_334:Set(v2_337)
		v2_337 = v2_337 or {}
		if v2_337.Title ~= nil then v1_318 = tostring(v2_337.Title) end
		if v2_337.Content ~= nil then v1_319 = tostring(v2_337.Content) end
		v1_332(true)
	end
	function v1_334:Get()
		return v1_318, v1_319
	end
	function v1_334:Destroy()
		v1_320:Destroy()
	end
	return v1_334
end
function v0_3:AddTextbox(v1_338)
	v1_338 = v1_338 or {}
	self._count += 1
	local v1_339 = v1_338.Numeric == true
	local v1_340 = tonumber(v1_338.MaxLength)
	local v1_341 = v1_338.Name ~= nil and v1_338.Name ~= ""
	local v1_342, v1_343, v1_344 = false, false, false
	local function v1_345(v2_346)
		if v1_338.Min then v2_346 = math.max(v2_346, v1_338.Min) end
		if v1_338.Max then v2_346 = math.min(v2_346, v1_338.Max) end
		return v2_346
	end
	local v1_347
	if v1_339 then
		v1_347 = tonumber(v1_338.Default)
		if v1_347 then v1_347 = v1_345(v1_347) end
	else
		v1_347 = tostring(v1_338.Default or "")
	end
	local function v1_348(v2_349)
		return v2_349 == nil and "" or tostring(v2_349)
	end
	local function v1_350(v2_351)
		local v2_352 = v2_351:sub(1, 1) == "-"
		v2_351 = v2_351:gsub("[^%d%.]", "")
		local v2_353 = v2_351:find(".", 1, true)
		if v2_353 then
			local v3_354 = v2_351:sub(v2_353 + 1):gsub("%.", "")
			v2_351 = v2_351:sub(1, v2_353) .. v3_354
		end
		return (v2_352 and "-" or "") .. v2_351
	end
	local v1_355 = Instance.new("Frame")
	v1_355.Name = "Textbox"
	v1_355.Size = UDim2.new(1, 0, 0, 32)
	v1_355.BackgroundColor3 = v0_7.Element
	v1_355.BorderSizePixel = 0
	v1_355.LayoutOrder = self._count
	v1_355.Parent = self.Holder
	v0_61(v1_355, 6)
	if v1_341 then
		local v2_356 = Instance.new("TextLabel")
		v2_356.Name = "Label"
		v2_356.Position = UDim2.new(0, 8, 0, 0)
		v2_356.Size = UDim2.new(0.4, -8, 1, 0)
		v2_356.BackgroundTransparency = 1
		v2_356.BorderSizePixel = 0
		v2_356.Text = v1_338.Name
		v2_356.TextColor3 = v0_7.Text
		v2_356.Font = Enum.Font.Gotham
		v2_356.TextSize = 14
		v2_356.TextXAlignment = Enum.TextXAlignment.Left
		v2_356.TextTruncate = Enum.TextTruncate.AtEnd
		v2_356.Parent = v1_355
	end
	local v1_357 = Instance.new("Frame")
	v1_357.Name = "BoxHolder"
	v1_357.AnchorPoint = Vector2.new(1, 0.5)
	v1_357.Position = UDim2.new(1, -6, 0.5, 0)
	v1_357.Size = v1_341 and UDim2.new(0.6, -10, 0, 22) or UDim2.new(1, -12, 0, 22)
	v1_357.BackgroundColor3 = v0_7.Card
	v1_357.BorderSizePixel = 0
	v1_357.Parent = v1_355
	v0_61(v1_357, 5)
	local v1_358 = Instance.new("UIStroke")
	v1_358.Color = v0_7.Accent
	v1_358.Thickness = 1
	v1_358.Transparency = 1
	v1_358.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_358.Parent = v1_357
	local v1_359 = Instance.new("TextBox")
	v1_359.Name = "Input"
	v1_359.Size = UDim2.new(1, 0, 1, 0)
	v1_359.BackgroundTransparency = 1
	v1_359.BorderSizePixel = 0
	v1_359.Text = v1_348(v1_347)
	v1_359.PlaceholderText = v1_338.Placeholder or ""
	v1_359.PlaceholderColor3 = v0_7.IconOff
	v1_359.TextColor3 = v0_7.Text
	v1_359.Font = Enum.Font.Gotham
	v1_359.TextSize = 13
	v1_359.TextXAlignment = Enum.TextXAlignment.Left
	v1_359.ClearTextOnFocus = v1_338.ClearTextOnFocus == true
	v1_359.ClipsDescendants = true
	v1_359.Parent = v1_357
	local v1_360 = Instance.new("UIPadding")
	v1_360.PaddingLeft = UDim.new(0, 6)
	v1_360.PaddingRight = UDim.new(0, 6)
	v1_360.Parent = v1_359
	local function v1_361()
		v0_10(v1_357, { BackgroundColor3 = (v1_343 and not v1_342) and v0_7.Sidebar or v0_7.Card }, 0.12)
		v0_10(v1_358, { Transparency = v1_342 and 0 or 1 }, 0.15)
	end
	v1_359:GetPropertyChangedSignal("Text"):Connect(function()
		if v1_344 then return end
		local v2_362 = v1_359.Text
		if v1_339 then v2_362 = v1_350(v2_362) end
		if v1_340 and #v2_362 > v1_340 then v2_362 = v2_362:sub(1, v1_340) end
		if v2_362 ~= v1_359.Text then
			v1_344 = true
			v1_359.Text = v2_362
			v1_344 = false
		end
	end)
	v1_359.Focused:Connect(function()
		v1_342 = true
		v1_361()
	end)
	v1_359.FocusLost:Connect(function(v2_363)
		v1_342 = false
		v1_361()
		if v1_339 then
			local v3_364 = tonumber(v1_359.Text)
			if v3_364 == nil then
				v1_359.Text = v1_348(v1_347)
				return
			end
			v3_364 = v1_345(v3_364)
			v1_347 = v3_364
			v1_359.Text = v1_348(v3_364)
		else
			v1_347 = v1_359.Text
		end
		if v1_338.Callback then v1_338.Callback(v1_347, v2_363) end
	end)
	v1_357.MouseEnter:Connect(function()
		v1_343 = true
		v1_361()
	end)
	v1_357.MouseLeave:Connect(function()
		v1_343 = false
		v1_361()
	end)
	local v1_365 = { Instance = v1_355 }
	function v1_365:Set(v2_366, v2_367)
		if v1_339 then
			local v3_368 = tonumber(v2_366)
			if v3_368 == nil then return end
			v1_347 = v1_345(v3_368)
		else
			v1_347 = tostring(v2_366 == nil and "" or v2_366)
			if v1_340 then v1_347 = v1_347:sub(1, v1_340) end
		end
		v1_359.Text = v1_348(v1_347)
		if not v2_367 and v1_338.Callback then v1_338.Callback(v1_347, false) end
	end
	function v1_365:Get()
		return v1_347
	end
	function v1_365:Focus()
		v1_359:CaptureFocus()
	end
	function v1_365:Destroy()
		if v1_359:IsFocused() then v1_359:ReleaseFocus() end
		v1_355:Destroy()
	end
	return v1_365
end
function v0_3:AddKeybind(v1_369)
	v1_369 = v1_369 or {}
	self._count += 1
	local v1_370 = Instance.new("Frame")
	v1_370.Name = "KeybindRow"
	v1_370.Size = UDim2.new(1, 0, 0, 32)
	v1_370.BackgroundColor3 = v0_7.Element
	v1_370.BorderSizePixel = 0
	v1_370.LayoutOrder = self._count
	v1_370.Parent = self.Holder
	v0_61(v1_370, 6)
	local v1_371 = Instance.new("TextLabel")
	v1_371.Name = "Label"
	v1_371.Position = UDim2.new(0, 8, 0, 0)
	v1_371.Size = UDim2.new(1, -60, 1, 0)
	v1_371.BackgroundTransparency = 1
	v1_371.BorderSizePixel = 0
	v1_371.Text = v1_369.Name or "Keybind"
	v1_371.TextColor3 = v0_7.Text
	v1_371.Font = Enum.Font.Gotham
	v1_371.TextSize = 14
	v1_371.TextXAlignment = Enum.TextXAlignment.Left
	v1_371.TextTruncate = Enum.TextTruncate.AtEnd
	v1_371.Parent = v1_370
	local v1_372 = v0_271(self._lib, v1_370, v1_369, UDim2.new(1, -8, 0.5, 0), function()
		if v1_369.OnPress then v1_369.OnPress() end
	end)
	v0_291(v1_371, v1_372, 16)
	v1_372.Row = v1_370
	local v1_373 = v1_372.Destroy
	function v1_372:Destroy()
		v1_373(v1_372)
		v1_370:Destroy()
	end
	return v1_372
end
function v0_3:AddSlider(v1_374)
	v1_374 = v1_374 or {}
	self._count += 1
	local v1_375 = self._lib
	local function v1_376(v2_377)
		return #(tostring(v2_377):match("%.(%d+)") or "")
	end
	local v1_378 = tonumber(v1_374.Min) or 0
	local v1_379 = tonumber(v1_374.Max) or 100
	if v1_379 < v1_378 then v1_378, v1_379 = v1_379, v1_378 end
	local v1_380 = tonumber(v1_374.Increment) or 1
	if v1_380 <= 0 then v1_380 = 1 end
	local v1_381 = math.max(v1_376(v1_380), v1_376(v1_378))
	local v1_382 = v1_374.ValueName
	local function v1_383(v2_384)
		v2_384 = math.clamp(v2_384, v1_378, v1_379)
		v2_384 = v1_378 + math.floor((v2_384 - v1_378) / v1_380 + 0.5) * v1_380
		v2_384 = math.clamp(v2_384, v1_378, v1_379)
		local v2_385 = 10 ^ v1_381
		return math.floor(v2_384 * v2_385 + 0.5) / v2_385
	end
	local function v1_386(v2_387)
		return v1_379 > v1_378 and (v2_387 - v1_378) / (v1_379 - v1_378) or 0
	end
	local function v1_388(v2_389)
		local v2_390 = v1_381 > 0 and string.format("%." .. v1_381 .. "f", v2_389) or tostring(v2_389)
		if v1_382 and v1_382 ~= "" then v2_390 = v2_390 .. " " .. tostring(v1_382) end
		return v2_390
	end
	local v1_391 = v1_383(tonumber(v1_374.Default) or v1_378)
	local v1_392, v1_393 = false, false
	local v1_394 = nil
	local v1_395 = Instance.new("Frame")
	v1_395.Name = "Slider"
	v1_395.Size = UDim2.new(1, 0, 0, 46)
	v1_395.BackgroundColor3 = v0_7.Element
	v1_395.BorderSizePixel = 0
	v1_395.LayoutOrder = self._count
	v1_395.Parent = self.Holder
	v0_61(v1_395, 6)
	local v1_396 = Instance.new("TextLabel")
	v1_396.Name = "Name"
	v1_396.Position = UDim2.new(0, 8, 0, 6)
	v1_396.Size = UDim2.new(0.6, -8, 0, 16)
	v1_396.BackgroundTransparency = 1
	v1_396.BorderSizePixel = 0
	v1_396.Text = v1_374.Name or "Slider"
	v1_396.TextColor3 = v0_7.Text
	v1_396.Font = Enum.Font.Gotham
	v1_396.TextSize = 14
	v1_396.TextXAlignment = Enum.TextXAlignment.Left
	v1_396.TextTruncate = Enum.TextTruncate.AtEnd
	v1_396.Parent = v1_395
	local v1_397 = Instance.new("TextLabel")
	v1_397.Name = "Value"
	v1_397.Position = UDim2.new(0.6, 0, 0, 6)
	v1_397.Size = UDim2.new(0.4, -8, 0, 16)
	v1_397.BackgroundTransparency = 1
	v1_397.BorderSizePixel = 0
	v1_397.Text = v1_388(v1_391)
	v1_397.TextColor3 = v0_7.SubText
	v1_397.Font = Enum.Font.GothamBold
	v1_397.TextSize = 13
	v1_397.TextXAlignment = Enum.TextXAlignment.Right
	v1_397.TextTruncate = Enum.TextTruncate.AtEnd
	v1_397.Parent = v1_395
	local v1_398 = Instance.new("Frame")
	v1_398.Name = "Track"
	v1_398.Position = UDim2.new(0, 15, 0, 31)
	v1_398.Size = UDim2.new(1, -30, 0, 6)
	v1_398.BackgroundColor3 = v0_7.Off
	v1_398.BorderSizePixel = 0
	v1_398.Parent = v1_395
	v0_61(v1_398, 3)
	local v1_399 = Instance.new("Frame")
	v1_399.Name = "Fill"
	v1_399.Size = UDim2.new(v1_386(v1_391), 0, 1, 0)
	v1_399.BackgroundColor3 = v0_7.Accent
	v1_399.BorderSizePixel = 0
	v1_399.Parent = v1_398
	v0_61(v1_399, 3)
	local v1_400 = Instance.new("Frame")
	v1_400.Name = "Knob"
	v1_400.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_400.Position = UDim2.new(v1_386(v1_391), 0, 0.5, 0)
	v1_400.Size = UDim2.new(0, 14, 0, 14)
	v1_400.BackgroundColor3 = v0_7.Text
	v1_400.BorderSizePixel = 0
	v1_400.Parent = v1_398
	local v1_401 = Instance.new("UICorner")
	v1_401.CornerRadius = UDim.new(1, 0)
	v1_401.Parent = v1_400
	local v1_402 = Instance.new("TextButton")
	v1_402.Name = "Hit"
	v1_402.Size = UDim2.new(1, 0, 1, 0)
	v1_402.BackgroundTransparency = 1
	v1_402.BorderSizePixel = 0
	v1_402.Text = ""
	v1_402.AutoButtonColor = false
	v1_402.Parent = v1_395
	local function v1_403()
		local v2_404 = v1_392 or v1_393
		v0_10(v1_395, { BackgroundColor3 = v2_404 and v0_7.Hover or v0_7.Element }, 0.12)
		local v2_405 = v1_393 and 18 or (v1_392 and 16 or 14)
		v0_10(v1_400, { Size = UDim2.new(0, v2_405, 0, v2_405) }, 0.12, Enum.EasingStyle.Back)
	end
	local function v1_406(v2_407)
		local v2_408 = v1_386(v1_391)
		v0_10(v1_399, { Size = UDim2.new(v2_408, 0, 1, 0) }, v2_407)
		v0_10(v1_400, { Position = UDim2.new(v2_408, 0, 0.5, 0) }, v2_407)
		v1_397.Text = v1_388(v1_391)
	end
	local function v1_409(v2_410, v2_411, v2_412)
		v2_410 = v1_383(v2_410)
		local v2_413 = v2_410 ~= v1_391
		v1_391 = v2_410
		v1_406(v2_412)
		if v2_413 then
			v1_397.TextColor3 = v0_7.Text
			v0_10(v1_397, { TextColor3 = v0_7.SubText }, 0.3)
			if not v2_411 and v1_374.Callback then v1_374.Callback(v1_391) end
		end
	end
	local function v1_414(v2_415)
		local v2_416 = v1_398.AbsoluteSize.X
		if v2_416 <= 0 then return end
		v1_409(v1_378 + ((v2_415 - v1_398.AbsolutePosition.X) / v2_416) * (v1_379 - v1_378), false, 0.08)
	end
	local function v1_417()
		if v1_394 then
			for v4_418, v4_419 in ipairs(v1_394) do v4_419:Disconnect() end
			v1_394 = nil
		end
		if v1_393 then
			v1_393 = false
			v1_403()
		end
	end
	local function v1_420(v2_421)
		v1_417()
		v1_393 = true
		v1_403()
		v1_414(v2_421.Position.X)
		v1_394 = {
			v0_4.InputChanged:Connect(function(v3_422)
				if v3_422.UserInputType == Enum.UserInputType.MouseMovement or v3_422 == v2_421 then
					v1_414(v3_422.Position.X)
				end
			end),
			v0_4.InputEnded:Connect(function(v3_423)
				if v3_423 == v2_421 or v3_423.UserInputType == Enum.UserInputType.MouseButton1 then
					v1_417()
				end
			end),
		}
	end
	v1_402.InputBegan:Connect(function(v2_424)
		if v0_17(v2_424) then v1_420(v2_424) end
	end)
	v1_402.MouseEnter:Connect(function()
		v1_392 = true
		v1_403()
	end)
	v1_402.MouseLeave:Connect(function()
		v1_392 = false
		v1_403()
	end)
	local v1_425 = { Instance = v1_395 }
	function v1_425:Set(v2_426, v2_427)
		v1_409(tonumber(v2_426) or v1_391, v2_427, 0.2)
	end
	function v1_425:Get()
		return v1_391
	end
	function v1_425:Destroy()
		v1_417()
		v1_375._cleanups[v1_425] = nil
		v1_395:Destroy()
	end
	v1_375._cleanups[v1_425] = v1_417
	return v1_425
end
function v0_3:AddDropdown(v1_428)
	v1_428 = v1_428 or {}
	self._count += 1
	local v1_429 = v1_428.Options or {}
	local v1_430 = v1_428.Multi == true
	local v1_431 = 130
	local v1_432, v1_433 = 26, 4
	local v1_434 = nil
	local v1_435 = {}
	local v1_436 = {}
	local v1_437 = false
	local v1_438 = 0
	local v1_439 = nil
	local v1_440 = Instance.new("Frame")
	v1_440.Name = "Dropdown"
	v1_440.Size = UDim2.new(1, 0, 0, 32)
	v1_440.AutomaticSize = Enum.AutomaticSize.Y
	v1_440.BackgroundTransparency = 1
	v1_440.BorderSizePixel = 0
	v1_440.LayoutOrder = self._count
	v1_440.Parent = self.Holder
	local v1_441 = Instance.new("UIListLayout")
	v1_441.Padding = UDim.new(0, 4)
	v1_441.SortOrder = Enum.SortOrder.LayoutOrder
	v1_441.Parent = v1_440
	local v1_442 = Instance.new("TextButton")
	v1_442.Name = "Header"
	v1_442.Size = UDim2.new(1, 0, 0, 32)
	v1_442.BackgroundColor3 = v0_7.Element
	v1_442.BorderSizePixel = 0
	v1_442.Text = ""
	v1_442.AutoButtonColor = false
	v1_442.LayoutOrder = 1
	v1_442.Parent = v1_440
	v0_61(v1_442, 6)
	v0_19(v1_442, v0_7.Element, v0_7.Hover)
	local v1_443 = Instance.new("TextLabel")
	v1_443.Name = "Name"
	v1_443.Position = UDim2.new(0, 8, 0, 0)
	v1_443.Size = UDim2.new(0.5, -8, 1, 0)
	v1_443.BackgroundTransparency = 1
	v1_443.BorderSizePixel = 0
	v1_443.Text = v1_428.Name or "Dropdown"
	v1_443.TextColor3 = v0_7.Text
	v1_443.Font = Enum.Font.Gotham
	v1_443.TextSize = 14
	v1_443.TextXAlignment = Enum.TextXAlignment.Left
	v1_443.TextTruncate = Enum.TextTruncate.AtEnd
	v1_443.Parent = v1_442
	local v1_444 = Instance.new("TextLabel")
	v1_444.Name = "Value"
	v1_444.Position = UDim2.new(0.5, 0, 0, 0)
	v1_444.Size = UDim2.new(0.5, -28, 1, 0)
	v1_444.BackgroundTransparency = 1
	v1_444.BorderSizePixel = 0
	v1_444.Text = "None"
	v1_444.TextColor3 = v0_7.SubText
	v1_444.Font = Enum.Font.Gotham
	v1_444.TextSize = 13
	v1_444.TextXAlignment = Enum.TextXAlignment.Right
	v1_444.TextTruncate = Enum.TextTruncate.AtEnd
	v1_444.Parent = v1_442
	local v1_445 = Instance.new("ImageLabel")
	v1_445.Name = "Arrow"
	v1_445.AnchorPoint = Vector2.new(1, 0.5)
	v1_445.Position = UDim2.new(1, -8, 0.5, 0)
	v1_445.Size = UDim2.new(0, 16, 0, 16)
	v1_445.BackgroundTransparency = 1
	v1_445.BorderSizePixel = 0
	v1_445.ImageColor3 = v0_7.SubText
	v1_445.ScaleType = Enum.ScaleType.Fit
	v1_445.Parent = v1_442
	local v1_446 = Instance.new("TextLabel")
	v1_446.Name = "ArrowFallback"
	v1_446.Size = UDim2.new(1, 0, 1, 0)
	v1_446.BackgroundTransparency = 1
	v1_446.Text = "▼"
	v1_446.TextColor3 = v0_7.SubText
	v1_446.Font = Enum.Font.Gotham
	v1_446.TextSize = 9
	v1_446.Visible = false
	v1_446.Parent = v1_445
	local function v1_447(v2_448)
		local v2_449 = v0_42(v1_445, v2_448 and "chevron-up" or "chevron-down", self._icons)
		if not v2_449 then v1_445.Image = "" end
		v1_446.Visible = not v2_449
		v1_446.Text = v2_448 and "▲" or "▼"
		v1_445.ImageTransparency = 1
		v1_446.TextTransparency = 1
		v0_10(v1_445, { ImageTransparency = 0 }, 0.18)
		v0_10(v1_446, { TextTransparency = 0 }, 0.18)
	end
	v1_447(false)
	local v1_450 = Instance.new("ScrollingFrame")
	v1_450.Name = "List"
	v1_450.Size = UDim2.new(1, 0, 0, 0)
	v1_450.BackgroundColor3 = v0_7.Sidebar
	v1_450.BorderSizePixel = 0
	v1_450.ScrollBarThickness = 3
	v1_450.ScrollBarImageColor3 = v0_7.IconOff
	v1_450.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_450.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_450.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_450.Visible = false
	v1_450.LayoutOrder = 2
	v1_450.Parent = v1_440
	v0_61(v1_450, 6)
	local v1_451 = Instance.new("UIPadding")
	v1_451.PaddingTop = UDim.new(0, 4)
	v1_451.PaddingBottom = UDim.new(0, 4)
	v1_451.Parent = v1_450
	local v1_452 = Instance.new("UIListLayout")
	v1_452.Padding = UDim.new(0, v1_433)
	v1_452.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_452.SortOrder = Enum.SortOrder.LayoutOrder
	v1_452.Parent = v1_450
	local function v1_453(v2_454)
		if v1_430 then return v1_435[v2_454] == true end
		return v1_434 == v2_454
	end
	local function v1_455()
		local v2_456 = {}
		for v3_457, v3_458 in ipairs(v1_429) do
			if v1_435[v3_458] then table.insert(v2_456, v3_458) end
		end
		return v2_456
	end
	local function v1_459()
		for v3_460, v3_461 in pairs(v1_436) do
			local v3_462 = v1_453(v3_460)
			v3_461.BackgroundColor3 = v3_462 and v0_7.Accent or v0_7.Element
			v3_461.TextColor3 = v3_462 and v0_7.IconOn or v0_7.SubText
		end
		if v1_430 then
			local v3_463 = {}
			for v4_464, v4_465 in ipairs(v1_455()) do table.insert(v3_463, tostring(v4_465)) end
			v1_444.Text = #v3_463 > 0 and table.concat(v3_463, ", ") or "None"
		else
			v1_444.Text = v1_434 ~= nil and tostring(v1_434) or "None"
		end
	end
	local function v1_466(v2_467)
		if v1_437 == v2_467 then return end
		v1_437 = v2_467
		if v1_439 then v1_439:Cancel() end
		v1_447(v2_467)
		if v2_467 then
			v1_450.Visible = true
			v1_439 = v0_10(v1_450, { Size = UDim2.new(1, 0, 0, v1_438) }, 0.22, Enum.EasingStyle.Quint)
		else
			local v3_468 = v0_10(v1_450, { Size = UDim2.new(1, 0, 0, 0) }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v1_439 = v3_468
			v3_468.Completed:Connect(function(v4_469)
				if v4_469 == Enum.PlaybackState.Completed and not v1_437 then
					v1_450.Visible = false
				end
			end)
		end
	end
	local v1_470 = { Instance = v1_440 }
	local function v1_471()
		if v1_428.Callback then
			v1_428.Callback(v1_430 and v1_455() or v1_434)
		end
	end
	local function v1_472()
		for v3_473, v3_474 in pairs(v1_436) do v3_474:Destroy() end
		v1_436 = {}
		for v3_475, v3_476 in ipairs(v1_429) do
			local v3_477 = Instance.new("TextButton")
			v3_477.Name = "Option"
			v3_477.Size = UDim2.new(1, -8, 0, v1_432)
			v3_477.BackgroundColor3 = v0_7.Element
			v3_477.BorderSizePixel = 0
			v3_477.Text = tostring(v3_476)
			v3_477.TextColor3 = v0_7.SubText
			v3_477.Font = Enum.Font.Gotham
			v3_477.TextSize = 13
			v3_477.TextTruncate = Enum.TextTruncate.AtEnd
			v3_477.AutoButtonColor = true
			v3_477.LayoutOrder = v3_475
			v3_477.Parent = v1_450
			v0_61(v3_477, 5)
			v3_477.MouseButton1Click:Connect(function()
				if v1_430 then
					v1_435[v3_476] = not v1_435[v3_476] or nil
					v1_459()
					v1_471()
				else
					v1_434 = v3_476
					v1_459()
					v1_466(false)
					v1_471()
				end
			end)
			v1_436[v3_476] = v3_477
		end
		local v2_478 = #v1_429
		local v2_479 = v2_478 > 0 and (v2_478 * v1_432 + (v2_478 - 1) * v1_433 + 8) or 0
		v1_438 = math.min(v2_479, v1_431)
		v1_450.Size = UDim2.new(1, 0, 0, v1_437 and v1_438 or 0)
		v1_459()
	end
	function v1_470:Set(v2_480, v2_481)
		if v1_430 then
			v1_435 = {}
			for v4_482, v4_483 in ipairs(typeof(v2_480) == "table" and v2_480 or { v2_480 }) do
				v1_435[v4_483] = true
			end
		else
			v1_434 = v2_480
		end
		v1_459()
		if not v2_481 then v1_471() end
	end
	function v1_470:Get()
		return v1_430 and v1_455() or v1_434
	end
	function v1_470:Refresh(v2_484, v2_485)
		v1_429 = v2_484 or {}
		if v2_485 then
			local v3_486 = {}
			for v4_487, v4_488 in ipairs(v1_429) do v3_486[v4_488] = true end
			if v1_430 then
				for v5_489 in pairs(v1_435) do
					if not v3_486[v5_489] then v1_435[v5_489] = nil end
				end
			elseif not v3_486[v1_434] then
				v1_434 = nil
			end
		else
			v1_435, v1_434 = {}, nil
		end
		v1_472()
	end
	function v1_470:Open() v1_466(true) end
	function v1_470:Close() v1_466(false) end
	v1_442.MouseButton1Click:Connect(function()
		v1_466(not v1_437)
	end)
	v1_472()
	if v1_428.Default ~= nil then
		v1_470:Set(v1_428.Default, true)
	end
	return v1_470
end
return v0_1
