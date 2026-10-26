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
	if v1_65.Resizable ~= false then
		local v2_92 = v1_65.MinSize or Vector2.new(380, 260)
		local v2_93 = v1_65.MaxSize
		local v2_94 = Instance.new("TextButton")
		v2_94.Name = "ResizeGrip"
		v2_94.AnchorPoint = Vector2.new(1, 1)
		v2_94.Position = UDim2.new(1, -6, 1, -6)
		v2_94.Size = UDim2.new(0, 22, 0, 22)
		v2_94.BackgroundColor3 = v0_7.Main
		v2_94.BackgroundTransparency = 0.25
		v2_94.BorderSizePixel = 0
		v2_94.Text = ""
		v2_94.AutoButtonColor = false
		v2_94.Parent = v1_69
		v0_61(v2_94, 6)
		local v2_95 = Instance.new("ImageLabel")
		v2_95.Name = "Icon"
		v2_95.AnchorPoint = Vector2.new(0.5, 0.5)
		v2_95.Position = UDim2.new(0.5, 0, 0.5, 0)
		v2_95.Size = UDim2.new(0, 14, 0, 14)
		v2_95.BackgroundTransparency = 1
		v2_95.BorderSizePixel = 0
		v2_95.ImageColor3 = v0_7.IconOff
		v2_95.ScaleType = Enum.ScaleType.Fit
		v2_95.Parent = v2_94
		local v2_96 = Instance.new("TextLabel")
		v2_96.Name = "IconFallback"
		v2_96.Size = UDim2.new(1, 0, 1, 0)
		v2_96.BackgroundTransparency = 1
		v2_96.Text = "⤢"
		v2_96.TextColor3 = v0_7.IconOff
		v2_96.Font = Enum.Font.GothamBold
		v2_96.TextSize = 14
		v2_96.Parent = v2_95
		v2_96.Visible = not v0_42(v2_95, "expand", v1_66.Icons)
		local v2_97 = Instance.new("UIScale")
		v2_97.Parent = v2_94
		local v2_98, v2_99, v2_100 = false, false, nil
		local function v2_101()
			local v3_102 = v2_98 or v2_99
			local v3_103 = v3_102 and v0_7.IconOn or v0_7.IconOff
			v0_10(v2_95, { ImageColor3 = v3_103 }, 0.15)
			v0_10(v2_96, { TextColor3 = v3_103 }, 0.15)
			v0_10(v2_94, { BackgroundColor3 = v3_102 and v0_7.Hover or v0_7.Main }, 0.15)
		end
		local function v2_104()
			if v2_100 then
				for v5_105, v5_106 in ipairs(v2_100) do v5_106:Disconnect() end
				v2_100 = nil
			end
			if v2_99 then
				v2_99 = false
				v2_101()
				v0_10(v2_97, { Scale = v2_98 and 1.1 or 1 }, 0.18, Enum.EasingStyle.Back)
			end
		end
		local function v2_107(v3_108)
			v2_104()
			v2_99 = true
			v2_101()
			v0_10(v2_97, { Scale = 0.9 }, 0.08)
			local v3_109 = v1_70.Scale
			local v3_110 = v3_108.Position
			local v3_111 = v1_69.AbsoluteSize / v3_109
			local v3_112 = v1_69.AbsolutePosition
			v2_100 = {
				v0_4.InputChanged:Connect(function(v4_113)
					if v4_113.UserInputType ~= Enum.UserInputType.MouseMovement and v4_113 ~= v3_108 then return end
					local v4_114 = v4_113.Position - v3_110
					local v4_115 = v1_67.AbsoluteSize
					local v4_116 = math.max(v2_92.X, v4_115.X - v3_112.X - 4)
					local v4_117 = math.max(v2_92.Y, v4_115.Y - v3_112.Y - 4)
					if v2_93 then
						v4_116 = math.max(v2_92.X, math.min(v4_116, v2_93.X))
						v4_117 = math.max(v2_92.Y, math.min(v4_117, v2_93.Y))
					end
					local v4_118 = math.clamp(v3_111.X + v4_114.X / v3_109, v2_92.X, v4_116)
					local v4_119 = math.clamp(v3_111.Y + v4_114.Y / v3_109, v2_92.Y, v4_117)
					v1_68 = UDim2.fromOffset(v4_118, v4_119)
					v1_69.Size = v1_68
					v1_69.Position = UDim2.fromOffset(v3_112.X + v4_118 * v3_109 / 2, v3_112.Y + v4_119 * v3_109 / 2)
				end),
				v0_4.InputEnded:Connect(function(v4_120)
					if v4_120 == v3_108 or v4_120.UserInputType == Enum.UserInputType.MouseButton1 then
						v2_104()
					end
				end),
			}
		end
		v2_94.InputBegan:Connect(function(v3_121)
			if v0_17(v3_121) then v2_107(v3_121) end
		end)
		v2_94.MouseEnter:Connect(function()
			v2_98 = true
			v2_101()
			if not v2_99 then v0_10(v2_97, { Scale = 1.1 }, 0.12) end
		end)
		v2_94.MouseLeave:Connect(function()
			v2_98 = false
			v2_101()
			if not v2_99 then v0_10(v2_97, { Scale = 1 }, 0.12) end
		end)
		v1_66._cleanups[v2_94] = v2_104
	end
	v1_66.ScreenGui, v1_66.Main, v1_66.Sidebar, v1_66.Content = v1_67, v1_69, v1_87, v1_91
	v1_66._scale = v1_70
	v1_66._visible = false
	if v1_65.Watermark ~= false then
		v1_66:_buildWatermark(v1_65.Title or "RobloxUI")
	end
	table.insert(v1_66._connections, v0_4.InputBegan:Connect(function(v2_122, v2_123)
		local v2_124 = v1_66._listening
		if v2_124 then
			if v2_122.UserInputType == Enum.UserInputType.Keyboard then
				if not v0_4:GetFocusedTextBox() then
					v2_124:_capture(v2_122.KeyCode)
				end
			elseif v0_17(v2_122) and not v2_123 then
				v2_124:_stopListening()
			end
			return
		end
		if v2_123 or v2_122.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local v2_125 = v2_122.KeyCode
		if v1_66._toggleKey and v2_125 == v1_66._toggleKey then
			v1_66:Toggle()
			return
		end
		for v3_126, v3_127 in ipairs(table.clone(v1_66._binds)) do
			if v3_127._key == v2_125 and not v3_127._destroyed then
				v3_127._onPress()
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
	for v2_128, v2_129 in ipairs(self._connections) do
		v2_129:Disconnect()
	end
	self._connections = {}
	self._destroyed = true
	for v2_130, v2_131 in pairs(self._cleanups) do pcall(v2_131) end
	self._cleanups = {}
	self._binds = {}
	self._listening = nil
	self.ScreenGui:Destroy()
end
local v0_132, v0_133 = 0.35, 0.2
function v0_1:_cancelAnim()
	if self._anim then
		for v3_134, v3_135 in ipairs(self._anim) do v3_135:Cancel() end
		self._anim = nil
	end
end
function v0_1:Show()
	if self._destroyed then return end
	self._visible = true
	self:_cancelAnim()
	self.Main.Visible = true
	self._anim = {
		v0_10(self.Main, { GroupTransparency = 0 }, v0_132, Enum.EasingStyle.Quint),
		v0_10(self._scale, { Scale = 1 }, v0_132, Enum.EasingStyle.Back),
	}
	self:_updateWatermark()
end
function v0_1:Hide()
	if self._destroyed or not self._visible then return end
	self._visible = false
	self:_cancelAnim()
	local v1_136 = v0_4:GetFocusedTextBox()
	if v1_136 and v1_136:IsDescendantOf(self.Main) then v1_136:ReleaseFocus() end
	local v1_137 = v0_10(self.Main, { GroupTransparency = 1 }, v0_133, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local v1_138 = v0_10(self._scale, { Scale = 0.92 }, v0_133, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	self._anim = { v1_137, v1_138 }
	v1_137.Completed:Connect(function(v2_139)
		if v2_139 == Enum.PlaybackState.Completed and not self._visible and not self._destroyed then
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
function v0_1:_keyTaken(v1_140, v1_141)
	if not v1_140 then return false end
	if v1_140 == self._toggleKey then return true end
	for v2_142, v2_143 in ipairs(self._binds) do
		if v2_143 ~= v1_141 and v2_143._key == v1_140 then return true end
	end
	return false
end
local v0_144, v0_145 = 280, 5
function v0_1:_getNotifyContainer()
	if self._notifyContainer and self._notifyContainer.Parent then
		return self._notifyContainer
	end
	local v1_146 = self.ScreenGui.AbsoluteSize
	local v1_147 = v1_146.X > 0 and math.min(v0_144, v1_146.X - 20) or v0_144
	local v1_148 = Instance.new("Frame")
	v1_148.Name = "Notifications"
	v1_148.AnchorPoint = Vector2.new(0.5, 0)
	v1_148.Position = UDim2.new(0.5, 0, 0, self._wm and 48 or 10)
	v1_148.Size = UDim2.new(0, v1_147, 0, 0)
	v1_148.AutomaticSize = Enum.AutomaticSize.Y
	v1_148.BackgroundTransparency = 1
	v1_148.BorderSizePixel = 0
	v1_148.Parent = self.ScreenGui
	local v1_149 = Instance.new("UIListLayout")
	v1_149.Padding = UDim.new(0, 6)
	v1_149.SortOrder = Enum.SortOrder.LayoutOrder
	v1_149.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_149.Parent = v1_148
	self._notifyContainer = v1_148
	return v1_148
end
function v0_1:Notify(v1_150)
	if self._destroyed then return end
	if type(v1_150) == "string" then v1_150 = { Content = v1_150 } end
	v1_150 = v1_150 or {}
	local v1_151 = tonumber(v1_150.Duration) or 4
	local v1_152 = self:_getNotifyContainer()
	self._notifyCount = (self._notifyCount or 0) + 1
	self._notifs = self._notifs or {}
	local v1_153 = false
	local v1_154 = Instance.new("Frame")
	v1_154.Name = "Notification"
	v1_154.Size = UDim2.new(1, 0, 0, 0)
	v1_154.BackgroundTransparency = 1
	v1_154.BorderSizePixel = 0
	v1_154.LayoutOrder = self._notifyCount
	v1_154.Parent = v1_152
	local v1_155 = Instance.new("CanvasGroup")
	v1_155.Name = "Card"
	v1_155.Size = UDim2.new(1, 0, 0, 0)
	v1_155.AutomaticSize = Enum.AutomaticSize.Y
	v1_155.BackgroundColor3 = v0_7.Sidebar
	v1_155.BorderSizePixel = 0
	v1_155.GroupTransparency = 1
	v1_155.Parent = v1_154
	v0_61(v1_155, 8)
	local v1_156 = Instance.new("UIStroke")
	v1_156.Color = v0_7.Element
	v1_156.Thickness = 1
	v1_156.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_156.Parent = v1_155
	local v1_157 = Instance.new("Frame")
	v1_157.Name = "Body"
	v1_157.Size = UDim2.new(1, 0, 0, 0)
	v1_157.AutomaticSize = Enum.AutomaticSize.Y
	v1_157.BackgroundTransparency = 1
	v1_157.BorderSizePixel = 0
	v1_157.Parent = v1_155
	local v1_158 = Instance.new("UIPadding")
	v1_158.PaddingTop = UDim.new(0, 8)
	v1_158.PaddingBottom = UDim.new(0, 8)
	v1_158.PaddingLeft = UDim.new(0, 12)
	v1_158.PaddingRight = UDim.new(0, 12)
	v1_158.Parent = v1_157
	local v1_159 = Instance.new("UISizeConstraint")
	v1_159.MinSize = Vector2.new(0, 30)
	v1_159.Parent = v1_157
	local v1_160 = Instance.new("Frame")
	v1_160.Name = "Texts"
	v1_160.Position = UDim2.new(0, 0, 0, 0)
	v1_160.Size = UDim2.new(1, 0, 0, 0)
	v1_160.AutomaticSize = Enum.AutomaticSize.Y
	v1_160.BackgroundTransparency = 1
	v1_160.BorderSizePixel = 0
	v1_160.Parent = v1_157
	local v1_161 = Instance.new("UIListLayout")
	v1_161.Padding = UDim.new(0, 2)
	v1_161.SortOrder = Enum.SortOrder.LayoutOrder
	v1_161.Parent = v1_160
	local function v1_162(v2_163, v2_164, v2_165, v2_166, v2_167)
		local v2_168 = Instance.new("TextLabel")
		v2_168.Size = UDim2.new(1, 0, 0, 0)
		v2_168.AutomaticSize = Enum.AutomaticSize.Y
		v2_168.BackgroundTransparency = 1
		v2_168.BorderSizePixel = 0
		v2_168.Text = v2_163
		v2_168.TextColor3 = v2_166
		v2_168.Font = v2_164
		v2_168.TextSize = v2_165
		v2_168.TextWrapped = true
		v2_168.TextXAlignment = Enum.TextXAlignment.Left
		v2_168.TextYAlignment = Enum.TextYAlignment.Top
		v2_168.LayoutOrder = v2_167
		v2_168.Parent = v1_160
		return v2_168
	end
	if v1_150.Title and v1_150.Title ~= "" then
		v1_162(tostring(v1_150.Title), Enum.Font.GothamBold, 13, v0_7.Text, 1).Name = "Title"
	end
	if v1_150.Content and v1_150.Content ~= "" then
		v1_162(tostring(v1_150.Content), Enum.Font.Gotham, 12, v0_7.SubText, 2).Name = "Content"
	end
	local v1_169 = Instance.new("Frame")
	v1_169.Name = "Timer"
	v1_169.AnchorPoint = Vector2.new(0, 1)
	v1_169.Position = UDim2.new(0, 0, 1, 0)
	v1_169.Size = UDim2.new(1, 0, 0, 2)
	v1_169.BackgroundColor3 = v0_7.Accent
	v1_169.BorderSizePixel = 0
	v1_169.Visible = v1_151 > 0
	v1_169.Parent = v1_155
	local v1_170 = Instance.new("TextButton")
	v1_170.Name = "Click"
	v1_170.Size = UDim2.new(1, 0, 1, 0)
	v1_170.BackgroundTransparency = 1
	v1_170.BorderSizePixel = 0
	v1_170.Text = ""
	v1_170.AutoButtonColor = false
	v1_170.Parent = v1_155
	local function v1_171()
		if v1_153 then return end
		v1_153 = true
		local v2_172 = table.find(self._notifs, v1_171)
		if v2_172 then table.remove(self._notifs, v2_172) end
		if self._destroyed then return end
		local v2_173 = v0_10(v1_155, {
			Position = UDim2.new(0, 0, 0, -20),
			GroupTransparency = 1,
		}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		v2_173.Completed:Connect(function()
			local v3_174 = v0_10(v1_154, { Size = UDim2.new(1, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quint)
			v3_174.Completed:Connect(function()
				v1_154:Destroy()
			end)
		end)
	end
	v1_170.MouseButton1Click:Connect(v1_171)
	table.insert(self._notifs, v1_171)
	while #self._notifs > v0_145 do
		self._notifs[1]()
	end
	task.spawn(function()
		v0_6.Heartbeat:Wait()
		v0_6.Heartbeat:Wait()
		local v2_175 = v1_155.AbsoluteSize.Y
		for v3_176 = 1, 10 do
			if v2_175 > 0 then break end
			v0_6.Heartbeat:Wait()
			v2_175 = v1_155.AbsoluteSize.Y
		end
		if v2_175 <= 0 then v2_175 = 50 end
		if v1_153 or self._destroyed or not v1_154.Parent then return end
		v1_155.Position = UDim2.new(0, 0, 0, -(v1_154.AbsolutePosition.Y + v2_175 + 10))
		v0_10(v1_154, { Size = UDim2.new(1, 0, 0, v2_175) }, 0.3, Enum.EasingStyle.Quint)
		v0_10(v1_155, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back)
		v0_10(v1_155, { GroupTransparency = 0 }, 0.25)
		v1_155:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if not v1_153 and v1_155.AbsoluteSize.Y > 0 then
				v1_154.Size = UDim2.new(1, 0, 0, v1_155.AbsoluteSize.Y)
			end
		end)
		if v1_151 > 0 then
			local v3_177 = v0_10(v1_169, { Size = UDim2.new(0, 0, 0, 2) }, v1_151, Enum.EasingStyle.Linear)
			v3_177.Completed:Connect(function(v4_178)
				if v4_178 == Enum.PlaybackState.Completed then v1_171() end
			end)
		end
	end)
	return { Dismiss = v1_171 }
end
function v0_1:_buildWatermark(v1_179)
	local v1_180 = Instance.new("Frame")
	v1_180.Name = "Watermark"
	v1_180.AnchorPoint = Vector2.new(0.5, 0)
	v1_180.Position = UDim2.new(0.5, 0, 0, -40)
	v1_180.Size = UDim2.new(0, 0, 0, 30)
	v1_180.AutomaticSize = Enum.AutomaticSize.X
	v1_180.BackgroundColor3 = v0_7.Sidebar
	v1_180.BorderSizePixel = 0
	v1_180.Parent = self.ScreenGui
	v0_61(v1_180, 8)
	local v1_181 = Instance.new("UIStroke")
	v1_181.Color = v0_7.Element
	v1_181.Thickness = 1
	v1_181.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_181.Parent = v1_180
	local v1_182 = Instance.new("UIPadding")
	v1_182.PaddingLeft = UDim.new(0, 10)
	v1_182.PaddingRight = UDim.new(0, 4)
	v1_182.Parent = v1_180
	local v1_183 = Instance.new("UIListLayout")
	v1_183.FillDirection = Enum.FillDirection.Horizontal
	v1_183.VerticalAlignment = Enum.VerticalAlignment.Center
	v1_183.Padding = UDim.new(0, 8)
	v1_183.SortOrder = Enum.SortOrder.LayoutOrder
	v1_183.Parent = v1_180
	local v1_184 = Instance.new("TextLabel")
	v1_184.Name = "Title"
	v1_184.Size = UDim2.new(0, 0, 1, 0)
	v1_184.AutomaticSize = Enum.AutomaticSize.X
	v1_184.BackgroundTransparency = 1
	v1_184.BorderSizePixel = 0
	v1_184.Text = v1_179
	v1_184.TextColor3 = v0_7.SubText
	v1_184.Font = Enum.Font.GothamBold
	v1_184.TextSize = 13
	v1_184.LayoutOrder = 1
	v1_184.Parent = v1_180
	local v1_185 = Instance.new("TextButton")
	v1_185.Name = "ToggleButton"
	v1_185.Size = UDim2.new(0, 22, 0, 22)
	v1_185.BackgroundColor3 = v0_7.Element
	v1_185.BorderSizePixel = 0
	v1_185.Text = ""
	v1_185.AutoButtonColor = false
	v1_185.LayoutOrder = 2
	v1_185.Parent = v1_180
	v0_61(v1_185, 6)
	local v1_186 = Instance.new("ImageLabel")
	v1_186.Name = "Icon"
	v1_186.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_186.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_186.Size = UDim2.new(0, 14, 0, 14)
	v1_186.BackgroundTransparency = 1
	v1_186.BorderSizePixel = 0
	v1_186.ImageColor3 = v0_7.IconOn
	v1_186.ScaleType = Enum.ScaleType.Fit
	v1_186.Parent = v1_185
	local v1_187 = Instance.new("TextLabel")
	v1_187.Name = "IconFallback"
	v1_187.Size = UDim2.new(1, 0, 1, 0)
	v1_187.BackgroundTransparency = 1
	v1_187.TextColor3 = v0_7.IconOn
	v1_187.Font = Enum.Font.GothamBold
	v1_187.TextSize = 12
	v1_187.Visible = false
	v1_187.Parent = v1_186
	local v1_188 = Instance.new("UIScale")
	v1_188.Parent = v1_185
	v1_185.MouseEnter:Connect(function() v0_10(v1_188, { Scale = 1.1 }, 0.12) end)
	v1_185.MouseLeave:Connect(function() v0_10(v1_188, { Scale = 1 }, 0.12) end)
	v1_185.InputBegan:Connect(function(v2_189)
		if v0_17(v2_189) then v0_10(v1_188, { Scale = 0.9 }, 0.08) end
	end)
	v1_185.InputEnded:Connect(function(v2_190)
		if v0_17(v2_190) then v0_10(v1_188, { Scale = 1.1 }, 0.15, Enum.EasingStyle.Back) end
	end)
	v1_185.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	local v1_191, v1_192, v1_193 = false, nil, nil
	v1_184.InputBegan:Connect(function(v2_194)
		if v0_17(v2_194) then
			v1_191 = true
			v1_192 = v2_194.Position
			v1_193 = v1_180.AbsolutePosition + Vector2.new(v1_180.AbsoluteSize.X / 2, 0)
			v2_194.Changed:Connect(function()
				if v2_194.UserInputState == Enum.UserInputState.End then v1_191 = false end
			end)
		end
	end)
	table.insert(self._connections, v0_4.InputChanged:Connect(function(v2_195)
		if not v1_191 then return end
		if v2_195.UserInputType ~= Enum.UserInputType.MouseMovement and v2_195.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local v2_196 = v2_195.Position - v1_192
		local v2_197 = self.ScreenGui.AbsoluteSize
		local v2_198 = v1_180.AbsoluteSize.X / 2
		local v2_199 = math.clamp(v1_193.X + v2_196.X, v2_198, math.max(v2_197.X - v2_198, v2_198))
		local v2_200 = math.clamp(v1_193.Y + v2_196.Y, 0, math.max(v2_197.Y - v1_180.AbsoluteSize.Y, 0))
		v1_180.Position = UDim2.fromOffset(v2_199, v2_200)
	end))
	self._wm = { Frame = v1_180, Button = v1_185, Icon = v1_186, Fallback = v1_187 }
	v0_10(v1_180, { Position = UDim2.new(0.5, 0, 0, 10) }, 0.5, Enum.EasingStyle.Back)
end
function v0_1:_updateWatermark()
	local v1_201 = self._wm
	if not v1_201 then return end
	local v1_202 = self._visible == true
	v0_10(v1_201.Button, { BackgroundColor3 = v1_202 and v0_7.Accent or v0_7.Element }, 0.2)
	local v1_203 = v0_42(v1_201.Icon, v1_202 and "eye" or "eye-off", self.Icons)
	if not v1_203 then v1_201.Icon.Image = "" end
	v1_201.Fallback.Visible = not v1_203
	v1_201.Fallback.Text = v1_202 and "●" or "○"
	v1_201.Icon.ImageTransparency = 1
	v0_10(v1_201.Icon, { ImageTransparency = 0 }, 0.2)
end
local function v0_204(v1_205, v1_206)
	v0_10(v1_205.Icon, { ImageColor3 = v1_206 }, 0.2)
	if v1_205.Fallback then
		v0_10(v1_205.Fallback, { TextColor3 = v1_206 }, 0.2)
	end
end
function v0_1:AddTab(v1_207)
	v1_207 = v1_207 or {}
	local v1_208 = Instance.new("TextButton")
	v1_208.Name = "TabButton"
	v1_208.Size = UDim2.new(0, 36, 0, 36)
	v1_208.BackgroundColor3 = v0_7.Card
	v1_208.BorderSizePixel = 0
	v1_208.Text = ""
	v1_208.AutoButtonColor = false
	v1_208.LayoutOrder = #self.Tabs + 1
	v1_208.Parent = self.Sidebar
	v0_61(v1_208, 6)
	local v1_209 = Instance.new("ImageLabel")
	v1_209.Name = "Icon"
	v1_209.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_209.Size = UDim2.new(0, 20, 0, 20)
	v1_209.Position = UDim2.new(0.5, 0, 0.5, 0)
	v1_209.BackgroundTransparency = 1
	v1_209.BorderSizePixel = 0
	v1_209.ImageColor3 = v0_7.IconOff
	v1_209.ScaleType = Enum.ScaleType.Fit
	v1_209.Parent = v1_208
	local v1_210
	if not v0_42(v1_209, v1_207.Icon, self.Icons) then
		v1_210 = Instance.new("TextLabel")
		v1_210.Name = "IconFallback"
		v1_210.Size = UDim2.new(1, 0, 1, 0)
		v1_210.BackgroundTransparency = 1
		v1_210.Text = string.upper(string.sub(tostring(v1_207.Name or v1_207.Icon or "?"), 1, 1))
		v1_210.TextColor3 = v0_7.IconOff
		v1_210.Font = Enum.Font.GothamBold
		v1_210.TextSize = 16
		v1_210.Parent = v1_209
	end
	local v1_211 = Instance.new("ScrollingFrame")
	v1_211.Name = "Page"
	v1_211.Size = UDim2.new(1, 0, 1, 0)
	v1_211.BackgroundTransparency = 1
	v1_211.BorderSizePixel = 0
	v1_211.ScrollBarThickness = 3
	v1_211.ScrollBarImageColor3 = v0_7.IconOff
	v1_211.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_211.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_211.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_211.Visible = false
	v1_211.Parent = self.Content
	local v1_212 = Instance.new("Frame")
	v1_212.Name = "Inner"
	v1_212.Size = UDim2.new(1, 0, 0, 0)
	v1_212.AutomaticSize = Enum.AutomaticSize.Y
	v1_212.BackgroundTransparency = 1
	v1_212.BorderSizePixel = 0
	v1_212.Parent = v1_211
	local v1_213 = Instance.new("UIPadding")
	v1_213.PaddingTop = UDim.new(0, 12)
	v1_213.PaddingBottom = UDim.new(0, 12)
	v1_213.Parent = v1_212
	local v1_214 = Instance.new("Frame")
	v1_214.Name = "Split"
	v1_214.Position = UDim2.new(0, 12, 0, 0)
	v1_214.Size = UDim2.new(1, -26, 0, 0)
	v1_214.AutomaticSize = Enum.AutomaticSize.Y
	v1_214.BackgroundTransparency = 1
	v1_214.BorderSizePixel = 0
	v1_214.Parent = v1_212
	local v1_215 = Instance.new("UIListLayout")
	v1_215.FillDirection = Enum.FillDirection.Horizontal
	v1_215.Padding = UDim.new(0, 8)
	v1_215.SortOrder = Enum.SortOrder.LayoutOrder
	v1_215.Parent = v1_214
	local function v1_216(v2_217)
		local v2_218 = Instance.new("Frame")
		v2_218.Name = v2_217 == 1 and "Left" or "Right"
		v2_218.Size = UDim2.new(0.5, -4, 0, 0)
		v2_218.AutomaticSize = Enum.AutomaticSize.Y
		v2_218.BackgroundTransparency = 1
		v2_218.BorderSizePixel = 0
		v2_218.LayoutOrder = v2_217
		v2_218.Parent = v1_214
		local v2_219 = Instance.new("UIListLayout")
		v2_219.Padding = UDim.new(0, 8)
		v2_219.SortOrder = Enum.SortOrder.LayoutOrder
		v2_219.Parent = v2_218
		return v2_218
	end
	local v1_220 = setmetatable({
		Page = v1_211,
		Button = v1_208,
		Icon = v1_209,
		Fallback = v1_210,
		Inner = v1_212,
		_icons = self.Icons,
		_lib = self,
		Left = v1_216(1),
		Right = v1_216(2),
		_sectionCount = 0,
	}, v0_2)
	table.insert(self.Tabs, v1_220)
	v0_19(v1_208, v0_7.Card, v0_7.Element, function()
		return self.ActiveTab == v1_220
	end)
	v1_208.MouseButton1Click:Connect(function()
		self:SelectTab(v1_220)
	end)
	if not self.ActiveTab then self:SelectTab(v1_220) end
	return v1_220
end
function v0_1:SelectTab(v1_221)
	if self.ActiveTab == v1_221 then return end
	local v1_222 = self.ActiveTab
	self.ActiveTab = v1_221
	if v1_222 then
		v1_222.Page.Visible = false
		v0_10(v1_222.Button, { BackgroundColor3 = v0_7.Card }, 0.2)
		v0_204(v1_222, v0_7.IconOff)
	end
	v1_221.Inner.Position = UDim2.new(0, 0, 0, 14)
	v1_221.Page.Visible = true
	v0_10(v1_221.Inner, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quint)
	v0_10(v1_221.Button, { BackgroundColor3 = v0_7.Accent }, 0.2)
	v0_204(v1_221, v0_7.IconOn)
end
function v0_2:AddSection(v1_223, v1_224)
	local v1_225 = (v1_224 == "right") and self.Right or self.Left
	self._sectionCount += 1
	local v1_226 = Instance.new("Frame")
	v1_226.Name = "Section"
	v1_226.Size = UDim2.new(1, 0, 0, 0)
	v1_226.AutomaticSize = Enum.AutomaticSize.Y
	v1_226.BackgroundColor3 = v0_7.Card
	v1_226.BorderSizePixel = 0
	v1_226.LayoutOrder = self._sectionCount
	v1_226.Parent = v1_225
	v0_61(v1_226, 6)
	local v1_227 = Instance.new("UIPadding")
	v1_227.PaddingTop = UDim.new(0, 8)
	v1_227.PaddingBottom = UDim.new(0, 8)
	v1_227.PaddingLeft = UDim.new(0, 8)
	v1_227.PaddingRight = UDim.new(0, 8)
	v1_227.Parent = v1_226
	local v1_228 = Instance.new("UIListLayout")
	v1_228.Padding = UDim.new(0, 6)
	v1_228.SortOrder = Enum.SortOrder.LayoutOrder
	v1_228.Parent = v1_226
	if v1_223 then
		local v2_229 = Instance.new("TextLabel")
		v2_229.Name = "Title"
		v2_229.Size = UDim2.new(1, 0, 0, 16)
		v2_229.BackgroundTransparency = 1
		v2_229.BorderSizePixel = 0
		v2_229.Text = v1_223
		v2_229.TextColor3 = v0_7.SubText
		v2_229.Font = Enum.Font.GothamBold
		v2_229.TextSize = 13
		v2_229.TextXAlignment = Enum.TextXAlignment.Left
		v2_229.TextTruncate = Enum.TextTruncate.AtEnd
		v2_229.LayoutOrder = 0
		v2_229.Parent = v1_226
	end
	return setmetatable({ Holder = v1_226, _count = 0, _icons = self._icons, _lib = self._lib }, v0_3)
end
local function v0_230(v1_231)
	if typeof(v1_231) == "EnumItem" and v1_231.EnumType == Enum.KeyCode then return v1_231 end
	if type(v1_231) == "string" then
		local v2_232, v2_233 = pcall(function() return Enum.KeyCode[v1_231] end)
		if v2_232 then return v2_233 end
	end
	return nil
end
local function v0_234(v1_235, v1_236, v1_237, v1_238, v1_239)
	v1_237 = v1_237 or {}
	local v1_240 = v1_237.CanBeChanged ~= false
	local v1_241 = {}
	local v1_242 = { _key = nil, _onPress = v1_239, _isListening = false, _destroyed = false }
	local v1_243 = Instance.new("TextButton")
	v1_243.Name = "Keybind"
	v1_243.AnchorPoint = Vector2.new(1, 0.5)
	v1_243.Position = v1_238
	v1_243.Size = UDim2.new(0, 0, 0, 20)
	v1_243.AutomaticSize = Enum.AutomaticSize.X
	v1_243.BackgroundColor3 = v0_7.Card
	v1_243.BorderSizePixel = 0
	v1_243.Text = "None"
	v1_243.TextColor3 = v0_7.SubText
	v1_243.Font = Enum.Font.Gotham
	v1_243.TextSize = 12
	v1_243.TextTruncate = Enum.TextTruncate.AtEnd
	v1_243.AutoButtonColor = false
	v1_243.Parent = v1_236
	v0_61(v1_243, 5)
	v1_242.Instance = v1_243
	local v1_244 = Instance.new("UIPadding")
	v1_244.PaddingLeft = UDim.new(0, 7)
	v1_244.PaddingRight = UDim.new(0, 7)
	v1_244.Parent = v1_243
	local v1_245 = Instance.new("UISizeConstraint")
	v1_245.MinSize = Vector2.new(30, 20)
	v1_245.MaxSize = Vector2.new(96, 20)
	v1_245.Parent = v1_243
	local function v1_246()
		if v1_242._isListening then
			v1_243.Text = "..."
		else
			v1_243.Text = v1_242._key and v1_242._key.Name or "None"
		end
	end
	local function v1_247()
		v1_243.BackgroundColor3 = v0_7.Danger
		v0_10(v1_243, { BackgroundColor3 = v0_7.Card }, 0.45)
	end
	function v1_242:Set(v2_248, v2_249)
		v2_248 = v0_230(v2_248)
		if v2_248 and v1_235:_keyTaken(v2_248, v1_242) then
			warn("[RobloxUI] key already in use:", v2_248.Name)
			v1_247()
			return false
		end
		v1_242._key = v2_248
		v1_246()
		if not v2_249 and v1_237.Callback then v1_237.Callback(v2_248) end
		return true
	end
	function v1_242:Get()
		return v1_242._key
	end
	function v1_242:_startListening()
		if v1_235._listening and v1_235._listening ~= v1_242 then
			v1_235._listening:_stopListening()
		end
		v1_235._listening = v1_242
		v1_242._isListening = true
		v0_10(v1_243, { BackgroundColor3 = v0_7.Accent }, 0.15)
		v1_246()
	end
	function v1_242:_stopListening()
		if v1_235._listening == v1_242 then v1_235._listening = nil end
		v1_242._isListening = false
		v0_10(v1_243, { BackgroundColor3 = v0_7.Card }, 0.15)
		v1_246()
	end
	function v1_242:_capture(v2_250)
		if v2_250 == Enum.KeyCode.Unknown then return end
		v1_242:_stopListening()
		if v2_250 == Enum.KeyCode.Escape then return end
		if v2_250 == Enum.KeyCode.Backspace or v2_250 == Enum.KeyCode.Delete then
			v1_242:Set(nil)
		else
			v1_242:Set(v2_250)
		end
	end
	function v1_242:Destroy()
		if v1_242._destroyed then return end
		v1_242._destroyed = true
		if v1_235._listening == v1_242 then v1_235._listening = nil end
		local v2_251 = table.find(v1_235._binds, v1_242)
		if v2_251 then table.remove(v1_235._binds, v2_251) end
		v1_235._cleanups[v1_242] = nil
		for v3_252, v3_253 in ipairs(v1_241) do v3_253:Disconnect() end
		v1_241 = {}
		v1_243:Destroy()
	end
	if v1_240 then
		v0_19(v1_243, v0_7.Card, v0_7.Sidebar, function() return v1_242._isListening end)
		table.insert(v1_241, v1_243.MouseButton1Click:Connect(function()
			if v1_242._isListening then v1_242:_stopListening() else v1_242:_startListening() end
		end))
		table.insert(v1_241, v1_243.MouseButton2Click:Connect(function()
			if v1_242._isListening then v1_242:_stopListening() end
			v1_242:Set(nil)
		end))
	end
	if v1_237.Key ~= nil then
		v1_242:Set(v1_237.Key, true)
	end
	table.insert(v1_235._binds, v1_242)
	v1_235._cleanups[v1_242] = function() v1_242:Destroy() end
	return v1_242
end
local function v0_254(v1_255, v1_256, v1_257)
	local v1_258 = v1_256.Instance
	local function v1_259()
		local v2_260 = math.clamp(v1_258.TextBounds.X + 14, 30, 96)
		v1_255.Size = UDim2.new(1, -(v1_257 + v2_260 + 6), 1, 0)
	end
	v1_259()
	v1_258:GetPropertyChangedSignal("TextBounds"):Connect(v1_259)
end
function v0_3:AddButton(v1_261)
	v1_261 = v1_261 or {}
	self._count += 1
	local v1_262 = Instance.new("TextButton")
	v1_262.Name = "Button"
	v1_262.Size = UDim2.new(1, 0, 0, 32)
	v1_262.BackgroundColor3 = v0_7.Element
	v1_262.BorderSizePixel = 0
	v1_262.Text = v1_261.Name or "Button"
	v1_262.TextColor3 = v0_7.Text
	v1_262.Font = Enum.Font.Gotham
	v1_262.TextSize = 14
	v1_262.TextTruncate = Enum.TextTruncate.AtEnd
	v1_262.AutoButtonColor = false
	v1_262.LayoutOrder = self._count
	v1_262.Parent = self.Holder
	v0_61(v1_262, 6)
	local v1_263 = Instance.new("UIPadding")
	v1_263.PaddingLeft = UDim.new(0, 8)
	v1_263.PaddingRight = UDim.new(0, 8)
	v1_263.Parent = v1_262
	v0_19(v1_262, v0_7.Element, v0_7.Hover)
	v1_262.MouseButton1Click:Connect(function()
		v1_262.BackgroundColor3 = v0_7.Accent
		v0_10(v1_262, { BackgroundColor3 = v0_7.Hover }, 0.3)
		if v1_261.Callback then v1_261.Callback() end
	end)
	return v1_262
end
function v0_3:AddToggle(v1_264)
	v1_264 = v1_264 or {}
	self._count += 1
	local v1_265 = v1_264.Default == true
	local v1_266 = self
	local v1_267 = Instance.new("TextButton")
	v1_267.Name = "Toggle"
	v1_267.Size = UDim2.new(1, 0, 0, 32)
	v1_267.BackgroundColor3 = v0_7.Element
	v1_267.BorderSizePixel = 0
	v1_267.Text = ""
	v1_267.AutoButtonColor = false
	v1_267.LayoutOrder = self._count
	v1_267.Parent = self.Holder
	v0_61(v1_267, 6)
	v0_19(v1_267, v0_7.Element, v0_7.Hover)
	local v1_268 = Instance.new("TextLabel")
	v1_268.Name = "Label"
	v1_268.Position = UDim2.new(0, 8, 0, 0)
	v1_268.Size = UDim2.new(1, -60, 1, 0)
	v1_268.BackgroundTransparency = 1
	v1_268.BorderSizePixel = 0
	v1_268.Text = v1_264.Name or "Toggle"
	v1_268.TextColor3 = v0_7.Text
	v1_268.Font = Enum.Font.Gotham
	v1_268.TextSize = 14
	v1_268.TextXAlignment = Enum.TextXAlignment.Left
	v1_268.TextTruncate = Enum.TextTruncate.AtEnd
	v1_268.Parent = v1_267
	local v1_269 = Instance.new("Frame")
	v1_269.Name = "Track"
	v1_269.AnchorPoint = Vector2.new(1, 0.5)
	v1_269.Position = UDim2.new(1, -8, 0.5, 0)
	v1_269.Size = UDim2.new(0, 34, 0, 18)
	v1_269.BackgroundColor3 = v0_7.Off
	v1_269.BorderSizePixel = 0
	v1_269.Parent = v1_267
	v0_61(v1_269, 9)
	local v1_270 = Instance.new("Frame")
	v1_270.Name = "Knob"
	v1_270.AnchorPoint = Vector2.new(0, 0.5)
	v1_270.Position = UDim2.new(0, 2, 0.5, 0)
	v1_270.Size = UDim2.new(0, 14, 0, 14)
	v1_270.BackgroundColor3 = v0_7.Text
	v1_270.BorderSizePixel = 0
	v1_270.Parent = v1_269
	v0_61(v1_270, 7)
	local function v1_271(v2_272)
		local v2_273 = TweenInfo.new(v2_272 and 0.15 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		v0_5:Create(v1_269, v2_273, { BackgroundColor3 = v1_265 and v0_7.Accent or v0_7.Off }):Play()
		v0_5:Create(v1_270, v2_273, {
			Position = v1_265 and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		}):Play()
	end
	v1_271(false)
	local v1_274 = { Instance = v1_267 }
	function v1_274:Set(v2_275, v2_276)
		v1_265 = v2_275 and true or false
		v1_271(true)
		if not v2_276 and v1_264.Callback then v1_264.Callback(v1_265) end
	end
	function v1_274:Get()
		return v1_265
	end
	v1_267.MouseButton1Click:Connect(function()
		v1_274:Set(not v1_265)
	end)
	function v1_274:AddKeybind(v2_277)
		if v1_274.Keybind then
			warn("[RobloxUI] this toggle already has a keybind")
			return v1_274.Keybind
		end
		local v2_278 = v0_234(v1_266._lib, v1_267, v2_277, UDim2.new(1, -48, 0.5, 0), function()
			v1_274:Set(not v1_265)
		end)
		v0_254(v1_268, v2_278, 60)
		local v2_279 = v2_278.Destroy
		function v2_278:Destroy()
			v2_279(v2_278)
			v1_274.Keybind = nil
			v1_268.Size = UDim2.new(1, -60, 1, 0)
		end
		v1_274.Keybind = v2_278
		return v2_278
	end
	function v1_274:Destroy()
		if v1_274._destroyed then return end
		v1_274._destroyed = true
		if v1_274.Keybind then v1_274.Keybind:Destroy() end
		v1_267:Destroy()
	end
	return v1_274
end
function v0_3:AddParagraph(v1_280)
	v1_280 = v1_280 or {}
	self._count += 1
	local v1_281 = v1_280.Title and tostring(v1_280.Title) or ""
	local v1_282 = v1_280.Content and tostring(v1_280.Content) or ""
	local v1_283 = Instance.new("Frame")
	v1_283.Name = "Paragraph"
	v1_283.Size = UDim2.new(1, 0, 0, 0)
	v1_283.AutomaticSize = Enum.AutomaticSize.Y
	v1_283.BackgroundColor3 = v0_7.Element
	v1_283.BorderSizePixel = 0
	v1_283.LayoutOrder = self._count
	v1_283.Parent = self.Holder
	v0_61(v1_283, 6)
	local v1_284 = Instance.new("UIPadding")
	v1_284.PaddingTop = UDim.new(0, 8)
	v1_284.PaddingBottom = UDim.new(0, 8)
	v1_284.PaddingLeft = UDim.new(0, 8)
	v1_284.PaddingRight = UDim.new(0, 8)
	v1_284.Parent = v1_283
	local v1_285 = Instance.new("UIListLayout")
	v1_285.Padding = UDim.new(0, 3)
	v1_285.SortOrder = Enum.SortOrder.LayoutOrder
	v1_285.Parent = v1_283
	local function v1_286(v2_287, v2_288, v2_289, v2_290, v2_291)
		local v2_292 = Instance.new("TextLabel")
		v2_292.Name = v2_287
		v2_292.Size = UDim2.new(1, 0, 0, 0)
		v2_292.AutomaticSize = Enum.AutomaticSize.Y
		v2_292.BackgroundTransparency = 1
		v2_292.BorderSizePixel = 0
		v2_292.TextColor3 = v2_290
		v2_292.Font = v2_288
		v2_292.TextSize = v2_289
		v2_292.TextWrapped = true
		v2_292.RichText = v1_280.RichText == true
		v2_292.TextXAlignment = Enum.TextXAlignment.Left
		v2_292.TextYAlignment = Enum.TextYAlignment.Top
		v2_292.LayoutOrder = v2_291
		v2_292.Parent = v1_283
		return v2_292
	end
	local v1_293 = v1_286("Title", Enum.Font.GothamBold, 14, v0_7.Text, 1)
	local v1_294 = v1_286("Content", Enum.Font.Gotham, 13, v0_7.SubText, 2)
	local function v1_295(v2_296)
		v1_293.Text = v1_281
		v1_293.Visible = v1_281 ~= ""
		v1_294.Text = v1_282
		v1_294.Visible = v1_282 ~= ""
		if v2_296 then
			v1_293.TextTransparency = 1
			v1_294.TextTransparency = 1
			v0_10(v1_293, { TextTransparency = 0 }, 0.2)
			v0_10(v1_294, { TextTransparency = 0 }, 0.2)
		end
	end
	v1_295(false)
	local v1_297 = { Instance = v1_283 }
	function v1_297:SetTitle(v2_298)
		v1_281 = v2_298 and tostring(v2_298) or ""
		v1_295(true)
	end
	function v1_297:SetContent(v2_299)
		v1_282 = v2_299 and tostring(v2_299) or ""
		v1_295(true)
	end
	function v1_297:Set(v2_300)
		v2_300 = v2_300 or {}
		if v2_300.Title ~= nil then v1_281 = tostring(v2_300.Title) end
		if v2_300.Content ~= nil then v1_282 = tostring(v2_300.Content) end
		v1_295(true)
	end
	function v1_297:Get()
		return v1_281, v1_282
	end
	function v1_297:Destroy()
		v1_283:Destroy()
	end
	return v1_297
end
function v0_3:AddTextbox(v1_301)
	v1_301 = v1_301 or {}
	self._count += 1
	local v1_302 = v1_301.Numeric == true
	local v1_303 = tonumber(v1_301.MaxLength)
	local v1_304 = v1_301.Name ~= nil and v1_301.Name ~= ""
	local v1_305, v1_306, v1_307 = false, false, false
	local function v1_308(v2_309)
		if v1_301.Min then v2_309 = math.max(v2_309, v1_301.Min) end
		if v1_301.Max then v2_309 = math.min(v2_309, v1_301.Max) end
		return v2_309
	end
	local v1_310
	if v1_302 then
		v1_310 = tonumber(v1_301.Default)
		if v1_310 then v1_310 = v1_308(v1_310) end
	else
		v1_310 = tostring(v1_301.Default or "")
	end
	local function v1_311(v2_312)
		return v2_312 == nil and "" or tostring(v2_312)
	end
	local function v1_313(v2_314)
		local v2_315 = v2_314:sub(1, 1) == "-"
		v2_314 = v2_314:gsub("[^%d%.]", "")
		local v2_316 = v2_314:find(".", 1, true)
		if v2_316 then
			local v3_317 = v2_314:sub(v2_316 + 1):gsub("%.", "")
			v2_314 = v2_314:sub(1, v2_316) .. v3_317
		end
		return (v2_315 and "-" or "") .. v2_314
	end
	local v1_318 = Instance.new("Frame")
	v1_318.Name = "Textbox"
	v1_318.Size = UDim2.new(1, 0, 0, 32)
	v1_318.BackgroundColor3 = v0_7.Element
	v1_318.BorderSizePixel = 0
	v1_318.LayoutOrder = self._count
	v1_318.Parent = self.Holder
	v0_61(v1_318, 6)
	if v1_304 then
		local v2_319 = Instance.new("TextLabel")
		v2_319.Name = "Label"
		v2_319.Position = UDim2.new(0, 8, 0, 0)
		v2_319.Size = UDim2.new(0.4, -8, 1, 0)
		v2_319.BackgroundTransparency = 1
		v2_319.BorderSizePixel = 0
		v2_319.Text = v1_301.Name
		v2_319.TextColor3 = v0_7.Text
		v2_319.Font = Enum.Font.Gotham
		v2_319.TextSize = 14
		v2_319.TextXAlignment = Enum.TextXAlignment.Left
		v2_319.TextTruncate = Enum.TextTruncate.AtEnd
		v2_319.Parent = v1_318
	end
	local v1_320 = Instance.new("Frame")
	v1_320.Name = "BoxHolder"
	v1_320.AnchorPoint = Vector2.new(1, 0.5)
	v1_320.Position = UDim2.new(1, -6, 0.5, 0)
	v1_320.Size = v1_304 and UDim2.new(0.6, -10, 0, 22) or UDim2.new(1, -12, 0, 22)
	v1_320.BackgroundColor3 = v0_7.Card
	v1_320.BorderSizePixel = 0
	v1_320.Parent = v1_318
	v0_61(v1_320, 5)
	local v1_321 = Instance.new("UIStroke")
	v1_321.Color = v0_7.Accent
	v1_321.Thickness = 1
	v1_321.Transparency = 1
	v1_321.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	v1_321.Parent = v1_320
	local v1_322 = Instance.new("TextBox")
	v1_322.Name = "Input"
	v1_322.Size = UDim2.new(1, 0, 1, 0)
	v1_322.BackgroundTransparency = 1
	v1_322.BorderSizePixel = 0
	v1_322.Text = v1_311(v1_310)
	v1_322.PlaceholderText = v1_301.Placeholder or ""
	v1_322.PlaceholderColor3 = v0_7.IconOff
	v1_322.TextColor3 = v0_7.Text
	v1_322.Font = Enum.Font.Gotham
	v1_322.TextSize = 13
	v1_322.TextXAlignment = Enum.TextXAlignment.Left
	v1_322.ClearTextOnFocus = v1_301.ClearTextOnFocus == true
	v1_322.ClipsDescendants = true
	v1_322.Parent = v1_320
	local v1_323 = Instance.new("UIPadding")
	v1_323.PaddingLeft = UDim.new(0, 6)
	v1_323.PaddingRight = UDim.new(0, 6)
	v1_323.Parent = v1_322
	local function v1_324()
		v0_10(v1_320, { BackgroundColor3 = (v1_306 and not v1_305) and v0_7.Sidebar or v0_7.Card }, 0.12)
		v0_10(v1_321, { Transparency = v1_305 and 0 or 1 }, 0.15)
	end
	v1_322:GetPropertyChangedSignal("Text"):Connect(function()
		if v1_307 then return end
		local v2_325 = v1_322.Text
		if v1_302 then v2_325 = v1_313(v2_325) end
		if v1_303 and #v2_325 > v1_303 then v2_325 = v2_325:sub(1, v1_303) end
		if v2_325 ~= v1_322.Text then
			v1_307 = true
			v1_322.Text = v2_325
			v1_307 = false
		end
	end)
	v1_322.Focused:Connect(function()
		v1_305 = true
		v1_324()
	end)
	v1_322.FocusLost:Connect(function(v2_326)
		v1_305 = false
		v1_324()
		if v1_302 then
			local v3_327 = tonumber(v1_322.Text)
			if v3_327 == nil then
				v1_322.Text = v1_311(v1_310)
				return
			end
			v3_327 = v1_308(v3_327)
			v1_310 = v3_327
			v1_322.Text = v1_311(v3_327)
		else
			v1_310 = v1_322.Text
		end
		if v1_301.Callback then v1_301.Callback(v1_310, v2_326) end
	end)
	v1_320.MouseEnter:Connect(function()
		v1_306 = true
		v1_324()
	end)
	v1_320.MouseLeave:Connect(function()
		v1_306 = false
		v1_324()
	end)
	local v1_328 = { Instance = v1_318 }
	function v1_328:Set(v2_329, v2_330)
		if v1_302 then
			local v3_331 = tonumber(v2_329)
			if v3_331 == nil then return end
			v1_310 = v1_308(v3_331)
		else
			v1_310 = tostring(v2_329 == nil and "" or v2_329)
			if v1_303 then v1_310 = v1_310:sub(1, v1_303) end
		end
		v1_322.Text = v1_311(v1_310)
		if not v2_330 and v1_301.Callback then v1_301.Callback(v1_310, false) end
	end
	function v1_328:Get()
		return v1_310
	end
	function v1_328:Focus()
		v1_322:CaptureFocus()
	end
	function v1_328:Destroy()
		if v1_322:IsFocused() then v1_322:ReleaseFocus() end
		v1_318:Destroy()
	end
	return v1_328
end
function v0_3:AddKeybind(v1_332)
	v1_332 = v1_332 or {}
	self._count += 1
	local v1_333 = Instance.new("Frame")
	v1_333.Name = "KeybindRow"
	v1_333.Size = UDim2.new(1, 0, 0, 32)
	v1_333.BackgroundColor3 = v0_7.Element
	v1_333.BorderSizePixel = 0
	v1_333.LayoutOrder = self._count
	v1_333.Parent = self.Holder
	v0_61(v1_333, 6)
	local v1_334 = Instance.new("TextLabel")
	v1_334.Name = "Label"
	v1_334.Position = UDim2.new(0, 8, 0, 0)
	v1_334.Size = UDim2.new(1, -60, 1, 0)
	v1_334.BackgroundTransparency = 1
	v1_334.BorderSizePixel = 0
	v1_334.Text = v1_332.Name or "Keybind"
	v1_334.TextColor3 = v0_7.Text
	v1_334.Font = Enum.Font.Gotham
	v1_334.TextSize = 14
	v1_334.TextXAlignment = Enum.TextXAlignment.Left
	v1_334.TextTruncate = Enum.TextTruncate.AtEnd
	v1_334.Parent = v1_333
	local v1_335 = v0_234(self._lib, v1_333, v1_332, UDim2.new(1, -8, 0.5, 0), function()
		if v1_332.OnPress then v1_332.OnPress() end
	end)
	v0_254(v1_334, v1_335, 16)
	v1_335.Row = v1_333
	local v1_336 = v1_335.Destroy
	function v1_335:Destroy()
		v1_336(v1_335)
		v1_333:Destroy()
	end
	return v1_335
end
function v0_3:AddSlider(v1_337)
	v1_337 = v1_337 or {}
	self._count += 1
	local v1_338 = self._lib
	local function v1_339(v2_340)
		return #(tostring(v2_340):match("%.(%d+)") or "")
	end
	local v1_341 = tonumber(v1_337.Min) or 0
	local v1_342 = tonumber(v1_337.Max) or 100
	if v1_342 < v1_341 then v1_341, v1_342 = v1_342, v1_341 end
	local v1_343 = tonumber(v1_337.Increment) or 1
	if v1_343 <= 0 then v1_343 = 1 end
	local v1_344 = math.max(v1_339(v1_343), v1_339(v1_341))
	local v1_345 = v1_337.ValueName
	local function v1_346(v2_347)
		v2_347 = math.clamp(v2_347, v1_341, v1_342)
		v2_347 = v1_341 + math.floor((v2_347 - v1_341) / v1_343 + 0.5) * v1_343
		v2_347 = math.clamp(v2_347, v1_341, v1_342)
		local v2_348 = 10 ^ v1_344
		return math.floor(v2_347 * v2_348 + 0.5) / v2_348
	end
	local function v1_349(v2_350)
		return v1_342 > v1_341 and (v2_350 - v1_341) / (v1_342 - v1_341) or 0
	end
	local function v1_351(v2_352)
		local v2_353 = v1_344 > 0 and string.format("%." .. v1_344 .. "f", v2_352) or tostring(v2_352)
		if v1_345 and v1_345 ~= "" then v2_353 = v2_353 .. " " .. tostring(v1_345) end
		return v2_353
	end
	local v1_354 = v1_346(tonumber(v1_337.Default) or v1_341)
	local v1_355, v1_356 = false, false
	local v1_357 = nil
	local v1_358 = Instance.new("Frame")
	v1_358.Name = "Slider"
	v1_358.Size = UDim2.new(1, 0, 0, 46)
	v1_358.BackgroundColor3 = v0_7.Element
	v1_358.BorderSizePixel = 0
	v1_358.LayoutOrder = self._count
	v1_358.Parent = self.Holder
	v0_61(v1_358, 6)
	local v1_359 = Instance.new("TextLabel")
	v1_359.Name = "Name"
	v1_359.Position = UDim2.new(0, 8, 0, 6)
	v1_359.Size = UDim2.new(0.6, -8, 0, 16)
	v1_359.BackgroundTransparency = 1
	v1_359.BorderSizePixel = 0
	v1_359.Text = v1_337.Name or "Slider"
	v1_359.TextColor3 = v0_7.Text
	v1_359.Font = Enum.Font.Gotham
	v1_359.TextSize = 14
	v1_359.TextXAlignment = Enum.TextXAlignment.Left
	v1_359.TextTruncate = Enum.TextTruncate.AtEnd
	v1_359.Parent = v1_358
	local v1_360 = Instance.new("TextLabel")
	v1_360.Name = "Value"
	v1_360.Position = UDim2.new(0.6, 0, 0, 6)
	v1_360.Size = UDim2.new(0.4, -8, 0, 16)
	v1_360.BackgroundTransparency = 1
	v1_360.BorderSizePixel = 0
	v1_360.Text = v1_351(v1_354)
	v1_360.TextColor3 = v0_7.SubText
	v1_360.Font = Enum.Font.GothamBold
	v1_360.TextSize = 13
	v1_360.TextXAlignment = Enum.TextXAlignment.Right
	v1_360.TextTruncate = Enum.TextTruncate.AtEnd
	v1_360.Parent = v1_358
	local v1_361 = Instance.new("Frame")
	v1_361.Name = "Track"
	v1_361.Position = UDim2.new(0, 15, 0, 31)
	v1_361.Size = UDim2.new(1, -30, 0, 6)
	v1_361.BackgroundColor3 = v0_7.Off
	v1_361.BorderSizePixel = 0
	v1_361.Parent = v1_358
	v0_61(v1_361, 3)
	local v1_362 = Instance.new("Frame")
	v1_362.Name = "Fill"
	v1_362.Size = UDim2.new(v1_349(v1_354), 0, 1, 0)
	v1_362.BackgroundColor3 = v0_7.Accent
	v1_362.BorderSizePixel = 0
	v1_362.Parent = v1_361
	v0_61(v1_362, 3)
	local v1_363 = Instance.new("Frame")
	v1_363.Name = "Knob"
	v1_363.AnchorPoint = Vector2.new(0.5, 0.5)
	v1_363.Position = UDim2.new(v1_349(v1_354), 0, 0.5, 0)
	v1_363.Size = UDim2.new(0, 14, 0, 14)
	v1_363.BackgroundColor3 = v0_7.Text
	v1_363.BorderSizePixel = 0
	v1_363.Parent = v1_361
	local v1_364 = Instance.new("UICorner")
	v1_364.CornerRadius = UDim.new(1, 0)
	v1_364.Parent = v1_363
	local v1_365 = Instance.new("TextButton")
	v1_365.Name = "Hit"
	v1_365.Size = UDim2.new(1, 0, 1, 0)
	v1_365.BackgroundTransparency = 1
	v1_365.BorderSizePixel = 0
	v1_365.Text = ""
	v1_365.AutoButtonColor = false
	v1_365.Parent = v1_358
	local function v1_366()
		local v2_367 = v1_355 or v1_356
		v0_10(v1_358, { BackgroundColor3 = v2_367 and v0_7.Hover or v0_7.Element }, 0.12)
		local v2_368 = v1_356 and 18 or (v1_355 and 16 or 14)
		v0_10(v1_363, { Size = UDim2.new(0, v2_368, 0, v2_368) }, 0.12, Enum.EasingStyle.Back)
	end
	local function v1_369(v2_370)
		local v2_371 = v1_349(v1_354)
		v0_10(v1_362, { Size = UDim2.new(v2_371, 0, 1, 0) }, v2_370)
		v0_10(v1_363, { Position = UDim2.new(v2_371, 0, 0.5, 0) }, v2_370)
		v1_360.Text = v1_351(v1_354)
	end
	local function v1_372(v2_373, v2_374, v2_375)
		v2_373 = v1_346(v2_373)
		local v2_376 = v2_373 ~= v1_354
		v1_354 = v2_373
		v1_369(v2_375)
		if v2_376 then
			v1_360.TextColor3 = v0_7.Text
			v0_10(v1_360, { TextColor3 = v0_7.SubText }, 0.3)
			if not v2_374 and v1_337.Callback then v1_337.Callback(v1_354) end
		end
	end
	local function v1_377(v2_378)
		local v2_379 = v1_361.AbsoluteSize.X
		if v2_379 <= 0 then return end
		v1_372(v1_341 + ((v2_378 - v1_361.AbsolutePosition.X) / v2_379) * (v1_342 - v1_341), false, 0.08)
	end
	local function v1_380()
		if v1_357 then
			for v4_381, v4_382 in ipairs(v1_357) do v4_382:Disconnect() end
			v1_357 = nil
		end
		if v1_356 then
			v1_356 = false
			v1_366()
		end
	end
	local function v1_383(v2_384)
		v1_380()
		v1_356 = true
		v1_366()
		v1_377(v2_384.Position.X)
		v1_357 = {
			v0_4.InputChanged:Connect(function(v3_385)
				if v3_385.UserInputType == Enum.UserInputType.MouseMovement or v3_385 == v2_384 then
					v1_377(v3_385.Position.X)
				end
			end),
			v0_4.InputEnded:Connect(function(v3_386)
				if v3_386 == v2_384 or v3_386.UserInputType == Enum.UserInputType.MouseButton1 then
					v1_380()
				end
			end),
		}
	end
	v1_365.InputBegan:Connect(function(v2_387)
		if v0_17(v2_387) then v1_383(v2_387) end
	end)
	v1_365.MouseEnter:Connect(function()
		v1_355 = true
		v1_366()
	end)
	v1_365.MouseLeave:Connect(function()
		v1_355 = false
		v1_366()
	end)
	local v1_388 = { Instance = v1_358 }
	function v1_388:Set(v2_389, v2_390)
		v1_372(tonumber(v2_389) or v1_354, v2_390, 0.2)
	end
	function v1_388:Get()
		return v1_354
	end
	function v1_388:Destroy()
		v1_380()
		v1_338._cleanups[v1_388] = nil
		v1_358:Destroy()
	end
	v1_338._cleanups[v1_388] = v1_380
	return v1_388
end
function v0_3:AddDropdown(v1_391)
	v1_391 = v1_391 or {}
	self._count += 1
	local v1_392 = v1_391.Options or {}
	local v1_393 = v1_391.Multi == true
	local v1_394 = 130
	local v1_395, v1_396 = 26, 4
	local v1_397 = nil
	local v1_398 = {}
	local v1_399 = {}
	local v1_400 = false
	local v1_401 = 0
	local v1_402 = nil
	local v1_403 = Instance.new("Frame")
	v1_403.Name = "Dropdown"
	v1_403.Size = UDim2.new(1, 0, 0, 32)
	v1_403.AutomaticSize = Enum.AutomaticSize.Y
	v1_403.BackgroundTransparency = 1
	v1_403.BorderSizePixel = 0
	v1_403.LayoutOrder = self._count
	v1_403.Parent = self.Holder
	local v1_404 = Instance.new("UIListLayout")
	v1_404.Padding = UDim.new(0, 4)
	v1_404.SortOrder = Enum.SortOrder.LayoutOrder
	v1_404.Parent = v1_403
	local v1_405 = Instance.new("TextButton")
	v1_405.Name = "Header"
	v1_405.Size = UDim2.new(1, 0, 0, 32)
	v1_405.BackgroundColor3 = v0_7.Element
	v1_405.BorderSizePixel = 0
	v1_405.Text = ""
	v1_405.AutoButtonColor = false
	v1_405.LayoutOrder = 1
	v1_405.Parent = v1_403
	v0_61(v1_405, 6)
	v0_19(v1_405, v0_7.Element, v0_7.Hover)
	local v1_406 = Instance.new("TextLabel")
	v1_406.Name = "Name"
	v1_406.Position = UDim2.new(0, 8, 0, 0)
	v1_406.Size = UDim2.new(0.5, -8, 1, 0)
	v1_406.BackgroundTransparency = 1
	v1_406.BorderSizePixel = 0
	v1_406.Text = v1_391.Name or "Dropdown"
	v1_406.TextColor3 = v0_7.Text
	v1_406.Font = Enum.Font.Gotham
	v1_406.TextSize = 14
	v1_406.TextXAlignment = Enum.TextXAlignment.Left
	v1_406.TextTruncate = Enum.TextTruncate.AtEnd
	v1_406.Parent = v1_405
	local v1_407 = Instance.new("TextLabel")
	v1_407.Name = "Value"
	v1_407.Position = UDim2.new(0.5, 0, 0, 0)
	v1_407.Size = UDim2.new(0.5, -28, 1, 0)
	v1_407.BackgroundTransparency = 1
	v1_407.BorderSizePixel = 0
	v1_407.Text = "None"
	v1_407.TextColor3 = v0_7.SubText
	v1_407.Font = Enum.Font.Gotham
	v1_407.TextSize = 13
	v1_407.TextXAlignment = Enum.TextXAlignment.Right
	v1_407.TextTruncate = Enum.TextTruncate.AtEnd
	v1_407.Parent = v1_405
	local v1_408 = Instance.new("ImageLabel")
	v1_408.Name = "Arrow"
	v1_408.AnchorPoint = Vector2.new(1, 0.5)
	v1_408.Position = UDim2.new(1, -8, 0.5, 0)
	v1_408.Size = UDim2.new(0, 16, 0, 16)
	v1_408.BackgroundTransparency = 1
	v1_408.BorderSizePixel = 0
	v1_408.ImageColor3 = v0_7.SubText
	v1_408.ScaleType = Enum.ScaleType.Fit
	v1_408.Parent = v1_405
	local v1_409 = Instance.new("TextLabel")
	v1_409.Name = "ArrowFallback"
	v1_409.Size = UDim2.new(1, 0, 1, 0)
	v1_409.BackgroundTransparency = 1
	v1_409.Text = "▼"
	v1_409.TextColor3 = v0_7.SubText
	v1_409.Font = Enum.Font.Gotham
	v1_409.TextSize = 9
	v1_409.Visible = false
	v1_409.Parent = v1_408
	local function v1_410(v2_411)
		local v2_412 = v0_42(v1_408, v2_411 and "chevron-up" or "chevron-down", self._icons)
		if not v2_412 then v1_408.Image = "" end
		v1_409.Visible = not v2_412
		v1_409.Text = v2_411 and "▲" or "▼"
		v1_408.ImageTransparency = 1
		v1_409.TextTransparency = 1
		v0_10(v1_408, { ImageTransparency = 0 }, 0.18)
		v0_10(v1_409, { TextTransparency = 0 }, 0.18)
	end
	v1_410(false)
	local v1_413 = Instance.new("ScrollingFrame")
	v1_413.Name = "List"
	v1_413.Size = UDim2.new(1, 0, 0, 0)
	v1_413.BackgroundColor3 = v0_7.Sidebar
	v1_413.BorderSizePixel = 0
	v1_413.ScrollBarThickness = 3
	v1_413.ScrollBarImageColor3 = v0_7.IconOff
	v1_413.ScrollingDirection = Enum.ScrollingDirection.Y
	v1_413.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v1_413.CanvasSize = UDim2.new(0, 0, 0, 0)
	v1_413.Visible = false
	v1_413.LayoutOrder = 2
	v1_413.Parent = v1_403
	v0_61(v1_413, 6)
	local v1_414 = Instance.new("UIPadding")
	v1_414.PaddingTop = UDim.new(0, 4)
	v1_414.PaddingBottom = UDim.new(0, 4)
	v1_414.Parent = v1_413
	local v1_415 = Instance.new("UIListLayout")
	v1_415.Padding = UDim.new(0, v1_396)
	v1_415.HorizontalAlignment = Enum.HorizontalAlignment.Center
	v1_415.SortOrder = Enum.SortOrder.LayoutOrder
	v1_415.Parent = v1_413
	local function v1_416(v2_417)
		if v1_393 then return v1_398[v2_417] == true end
		return v1_397 == v2_417
	end
	local function v1_418()
		local v2_419 = {}
		for v3_420, v3_421 in ipairs(v1_392) do
			if v1_398[v3_421] then table.insert(v2_419, v3_421) end
		end
		return v2_419
	end
	local function v1_422()
		for v3_423, v3_424 in pairs(v1_399) do
			local v3_425 = v1_416(v3_423)
			v3_424.BackgroundColor3 = v3_425 and v0_7.Accent or v0_7.Element
			v3_424.TextColor3 = v3_425 and v0_7.IconOn or v0_7.SubText
		end
		if v1_393 then
			local v3_426 = {}
			for v4_427, v4_428 in ipairs(v1_418()) do table.insert(v3_426, tostring(v4_428)) end
			v1_407.Text = #v3_426 > 0 and table.concat(v3_426, ", ") or "None"
		else
			v1_407.Text = v1_397 ~= nil and tostring(v1_397) or "None"
		end
	end
	local function v1_429(v2_430)
		if v1_400 == v2_430 then return end
		v1_400 = v2_430
		if v1_402 then v1_402:Cancel() end
		v1_410(v2_430)
		if v2_430 then
			v1_413.Visible = true
			v1_402 = v0_10(v1_413, { Size = UDim2.new(1, 0, 0, v1_401) }, 0.22, Enum.EasingStyle.Quint)
		else
			local v3_431 = v0_10(v1_413, { Size = UDim2.new(1, 0, 0, 0) }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			v1_402 = v3_431
			v3_431.Completed:Connect(function(v4_432)
				if v4_432 == Enum.PlaybackState.Completed and not v1_400 then
					v1_413.Visible = false
				end
			end)
		end
	end
	local v1_433 = { Instance = v1_403 }
	local function v1_434()
		if v1_391.Callback then
			v1_391.Callback(v1_393 and v1_418() or v1_397)
		end
	end
	local function v1_435()
		for v3_436, v3_437 in pairs(v1_399) do v3_437:Destroy() end
		v1_399 = {}
		for v3_438, v3_439 in ipairs(v1_392) do
			local v3_440 = Instance.new("TextButton")
			v3_440.Name = "Option"
			v3_440.Size = UDim2.new(1, -8, 0, v1_395)
			v3_440.BackgroundColor3 = v0_7.Element
			v3_440.BorderSizePixel = 0
			v3_440.Text = tostring(v3_439)
			v3_440.TextColor3 = v0_7.SubText
			v3_440.Font = Enum.Font.Gotham
			v3_440.TextSize = 13
			v3_440.TextTruncate = Enum.TextTruncate.AtEnd
			v3_440.AutoButtonColor = true
			v3_440.LayoutOrder = v3_438
			v3_440.Parent = v1_413
			v0_61(v3_440, 5)
			v3_440.MouseButton1Click:Connect(function()
				if v1_393 then
					v1_398[v3_439] = not v1_398[v3_439] or nil
					v1_422()
					v1_434()
				else
					v1_397 = v3_439
					v1_422()
					v1_429(false)
					v1_434()
				end
			end)
			v1_399[v3_439] = v3_440
		end
		local v2_441 = #v1_392
		local v2_442 = v2_441 > 0 and (v2_441 * v1_395 + (v2_441 - 1) * v1_396 + 8) or 0
		v1_401 = math.min(v2_442, v1_394)
		v1_413.Size = UDim2.new(1, 0, 0, v1_400 and v1_401 or 0)
		v1_422()
	end
	function v1_433:Set(v2_443, v2_444)
		if v1_393 then
			v1_398 = {}
			for v4_445, v4_446 in ipairs(typeof(v2_443) == "table" and v2_443 or { v2_443 }) do
				v1_398[v4_446] = true
			end
		else
			v1_397 = v2_443
		end
		v1_422()
		if not v2_444 then v1_434() end
	end
	function v1_433:Get()
		return v1_393 and v1_418() or v1_397
	end
	function v1_433:Refresh(v2_447, v2_448)
		v1_392 = v2_447 or {}
		if v2_448 then
			local v3_449 = {}
			for v4_450, v4_451 in ipairs(v1_392) do v3_449[v4_451] = true end
			if v1_393 then
				for v5_452 in pairs(v1_398) do
					if not v3_449[v5_452] then v1_398[v5_452] = nil end
				end
			elseif not v3_449[v1_397] then
				v1_397 = nil
			end
		else
			v1_398, v1_397 = {}, nil
		end
		v1_435()
	end
	function v1_433:Open() v1_429(true) end
	function v1_433:Close() v1_429(false) end
	v1_405.MouseButton1Click:Connect(function()
		v1_429(not v1_400)
	end)
	v1_435()
	if v1_391.Default ~= nil then
		v1_433:Set(v1_391.Default, true)
	end
	return v1_433
end
return v0_1
